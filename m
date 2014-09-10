From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 05/21] uas: Do not use scsi_host_find_tag
Date: Wed, 10 Sep 2014 13:46:35 +0200
Message-ID: <1410349611-17573-6-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaIJLrD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:03 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Using scsi_host_find_tag with tags returned by the device is unsafe for
multiple reasons:

1) It returns tags->rqs[tag], which may be non NULL even when the cmnd is
   not owned by us
2) It returns tags->rqs[tag], without holding any locks protecting it
3) It returns tags->rqs[tag], without doing any boundary checking

Instead keep our own list which maps tags -> inflight cmnds.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 05c1c81..b2423d3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -29,6 +29,8 @@
 
 #include "uas-detect.h"
 
+#define MAX_CMNDS 256
+
 /*
  * The r00-r01c specs define this version of the SENSE IU data structure.
  * It's still in use by several different firmware releases.
@@ -54,7 +56,7 @@ struct uas_dev_info {
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
 	unsigned shutdown:1;
-	struct scsi_cmnd *cmnd;
+	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
 	struct list_head inflight_list;
@@ -314,6 +316,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	if (cmdinfo->state & COMMAND_ABORTED)
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
 	list_del(&cmdinfo->list);
+	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
@@ -339,7 +342,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct scsi_cmnd *cmnd;
 	struct uas_cmd_info *cmdinfo;
 	unsigned long flags;
-	u16 tag;
+	unsigned int idx;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 
@@ -357,21 +360,17 @@ static void uas_stat_cmplt(struct urb *urb)
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
@@ -672,6 +671,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	unsigned long flags;
+	unsigned int stream;
 	int err;
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
@@ -685,19 +685,16 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
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
@@ -727,6 +724,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		uas_add_work(cmdinfo);
 	}
 
+	devinfo->cmnd[stream - 1] = cmnd;
 	list_add_tail(&cmdinfo->list, &devinfo->inflight_list);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
@@ -862,7 +860,6 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
 	int r;
 
 	devinfo->uas_sense_old = 0;
-	devinfo->cmnd = NULL;
 
 	r = uas_find_endpoints(devinfo->intf->cur_altsetting, eps);
 	if (r)
@@ -882,7 +879,7 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
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

