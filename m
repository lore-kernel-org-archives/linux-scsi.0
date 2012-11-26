From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 04/11] IB/srp: keep processing commands during host removal
Date: Sun, 25 Nov 2012 23:44:09 -0500
Message-ID: <8715294a23dded5879b3a327c470d9b6a39ddbc4.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
References: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Some SCSI upper layer drivers, e.g. sd, issue SCSI commands from
inside scsi_remove_host() (see also the sd_shutdown() call in
sd_remove()). Make sure that these commands have a chance to reach
the SCSI device.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
[ adapted to new state tracking ]
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2951e1c..f7d7e6a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1328,12 +1328,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	int len;
 
 	if (unlikely(target->state)) {
-		if (!srp_is_removed(target))
+		/*
+		 * Only requeue commands if we cannot send them to the target.
+		 * We'll let commands through during shutdown so that caches
+		 * get flushed, etc.
+		 */
+		if (srp_is_disconnected(target) || srp_in_error(target))
 			goto err;
-
-		scmnd->result = DID_BAD_TARGET << 16;
-		scmnd->scsi_done(scmnd);
-		return 0;
 	}
 
 	spin_lock_irqsave(&target->lock, flags);
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
