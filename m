From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 04/21] uas: Add uas_get_tag() helper function
Date: Wed, 10 Sep 2014 13:46:34 +0200
Message-ID: <1410349611-17573-5-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Factor out the mapping of scsi-tags -> uas-tags/stream-ids to a helper function
so that there is a single place where this "magic" happens.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4f745a3..05c1c81 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -257,13 +257,29 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 	cmnd->result = sense_iu->status;
 }
 
+/*
+ * scsi-tags go from 0 - (nr_tags - 1), uas tags need to match stream-ids,
+ * which go from 1 - nr_streams. And we use 1 for untagged commands.
+ */
+static int uas_get_tag(struct scsi_cmnd *cmnd)
+{
+	int tag;
+
+	if (blk_rq_tagged(cmnd->request))
+		tag = cmnd->request->tag + 2;
+	else
+		tag = 1;
+
+	return tag;
+}
+
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 {
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd, "%s %p tag %d, inflight:"
 		    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
-		    caller, cmnd, cmnd->request->tag,
+		    caller, cmnd, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -514,10 +530,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	iu->iu_id = IU_ID_COMMAND;
-	if (blk_rq_tagged(cmnd->request))
-		iu->tag = cpu_to_be16(cmnd->request->tag + 2);
-	else
-		iu->tag = cpu_to_be16(1);
+	iu->tag = cpu_to_be16(uas_get_tag(cmnd));
 	iu->prio_attr = UAS_SIMPLE_TAG;
 	iu->len = len;
 	int_to_scsilun(sdev->lun, &iu->lun);
@@ -679,17 +692,13 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	memset(cmdinfo, 0, sizeof(*cmdinfo));
 
-	if (blk_rq_tagged(cmnd->request)) {
-		cmdinfo->stream = cmnd->request->tag + 2;
-	} else {
+	if (!blk_rq_tagged(cmnd->request))
 		devinfo->cmnd = cmnd;
-		cmdinfo->stream = 1;
-	}
 
 	cmnd->scsi_done = done;
 
-	cmdinfo->state = SUBMIT_STATUS_URB |
-			ALLOC_CMD_URB | SUBMIT_CMD_URB;
+	cmdinfo->stream = uas_get_tag(cmnd);
+	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
-- 
2.1.0
