From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 04/24] uas: Add uas_get_tag() helper function
Date: Sat, 13 Sep 2014 12:26:31 +0200
Message-ID: <1410604011-3828-5-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Factor out the mapping of scsi-tags -> uas-tags/stream-ids to a helper function
so that there is a single place where this "magic" happens.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 0d97602..ac1424c 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -259,13 +259,29 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
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
@@ -516,10 +532,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
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
@@ -690,17 +703,13 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
