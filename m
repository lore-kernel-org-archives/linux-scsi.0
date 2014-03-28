From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH 3/3] [SCSI] Fix command result state propagation
Date: Fri, 28 Mar 2014 10:51:15 -0700
Message-ID: <1396029075.15365.33.camel@dabdike>
References: <1396028874.15365.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396028874.15365.30.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>

We're seeing a case where the contents of scmd->result isn't being reset after
a SCSI command encounters an error, is resubmitted, times out and then gets
handled.  The error handler acts on the stale result of the previous error
instead of the timeout.  Fix this by properly zeroing the scmd->status before
the command is resubmitted.

Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Signed-off-by: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>
---
 drivers/scsi/scsi_error.c | 1 +
 drivers/scsi/scsi_lib.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 221a5bc..335eaf4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -927,6 +927,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->request->next_rq = NULL;
+	scmd->result = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5681c05..b1f4867 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -137,6 +137,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * lock such that the kblockd_schedule_work() call happens
 	 * before blk_cleanup_queue() finishes.
 	 */
+	cmd->result = 0;
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
 	kblockd_schedule_work(q, &device->requeue_work);
-- 
1.9.1



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
