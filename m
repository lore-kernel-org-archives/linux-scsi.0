From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/24] uas: Do not use scsi_host_find_tag
Date: Sat, 13 Sep 2014 12:26:32 +0200
Message-ID: <1410604011-3828-6-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Using scsi_host_find_tag with tags returned by the device is unsafe for
multiple reasons:

1) It returns tags->rqs[tag], which may be non NULL even when the cmnd is
   not owned by us
2) It returns tags->rqs[tag], without holding any locks protecting it
3) It returns tags->rqs[tag], without doing any boundary checking

Instead keep our own list which maps tags -> inflight cmnds.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ac1424c..b58d133 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -30,6 +30,8 @@
 #include "uas-detect.h"
 #include "scsiglue.h"
 
+#define MAX_CMNDS 256
+
 /*
  * The r00-r01c specs define this version of the SENSE IU data structure.
  * It's still in use by several different firmware releases.
@@ -56,7 +58,7 @@ struct uas_dev_info {
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
 	unsigned shutdown:1;
-	struct scsi_cmnd *cmnd;
+	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
 	struct list_head inflight_list;
@@ -316,6 +318,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	if (cmdinfo->state & COMMAND_ABORTED)
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
 	list_del(&cmdinfo->list);
+	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
@@ -341,7 +344,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct scsi_cmnd *cmnd;
 	struct uas_cmd_info *cmdinfo;
 	unsigned long flags;
-	u16 tag;
+	unsigned int idx;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 
@@ -359,21 +362,17 @@ static void uas_stat_cmplt(struct urb *urb)
 		goto out;
 	}
 
-	tag = be16_to_cpup(&iu->tag) - 1;
-	if (tag == 0)
-		cmnd = devinfo->cmnd;
-	else
-		cmnd = scsi_host_find_tag(shost, tag - 1);
-
-	if (!cmnd)
+	idx = be16_to_cpup(&iu->tag) - 1;
+	if (idx >= MAX_CMNDS || !devinfo->cmnd[idx]) {
+		dev_err(&urb->dev->dev,
+			"stat urb: no pending cmd for tag %d\n", idx + 1);
 		goto out;
+	}
 
+	cmnd = devinfo->cmnd[idx];
 	cmdinfo = (void *)&cmnd->SCp;
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
-		if (devinfo->cmnd == cmnd)
-			devinfo->cmnd = NULL;
-
 		if (urb->actual_length < 16)
 			devinfo->uas_sense_old = 1;
 		if (devinfo->uas_sense_old)
@@ -674,6 +673,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	unsigned long flags;
+	unsigned int stream;
 	int err;
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
@@ -696,19 +696,16 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		return 0;
 	}
 
-	if (devinfo->cmnd) {
+	stream = uas_get_tag(cmnd);
+	if (devinfo->cmnd[stream - 1]) {
 		spin_unlock_irqrestore(&devinfo->lock, flags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
-	memset(cmdinfo, 0, sizeof(*cmdinfo));
-
-	if (!blk_rq_tagged(cmnd->request))
-		devinfo->cmnd = cmnd;
-
 	cmnd->scsi_done = done;
 
-	cmdinfo->stream = uas_get_tag(cmnd);
+	memset(cmdinfo, 0, sizeof(*cmdinfo));
+	cmdinfo->stream = stream;
 	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
@@ -738,6 +735,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		uas_add_work(cmdinfo);
 	}
 
+	devinfo->cmnd[stream - 1] = cmnd;
 	list_add_tail(&cmdinfo->list, &devinfo->inflight_list);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
@@ -873,7 +871,6 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
 	int r;
 
 	devinfo->uas_sense_old = 0;
-	devinfo->cmnd = NULL;
 
 	r = uas_find_endpoints(devinfo->intf->cur_altsetting, eps);
 	if (r)
@@ -893,7 +890,7 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
 		devinfo->use_streams = 0;
 	} else {
 		devinfo->qdepth = usb_alloc_streams(devinfo->intf, eps + 1,
-						    3, 256, GFP_NOIO);
+						    3, MAX_CMNDS, GFP_NOIO);
 		if (devinfo->qdepth < 0)
 			return devinfo->qdepth;
 		devinfo->use_streams = 1;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
