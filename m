From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Fri, 29 Oct 2010 17:33:19 -0700 (PDT)
Message-ID: <106187.30360.qm@web31802.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:44795 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751885Ab0J3AdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2010 20:33:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Eliminate an infinite loop whereby the SCSI layer
would reissue a command (which would be failed by
the driver) ad infinitum. (Invariably due to the
driver's profuse use of the
SCSI_MLQUEUE_DEVICE_BUSY returned result in its
queuecommand() method.)

Also add a debug option and a few debug prints.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/Kconfig  |   10 ++++
 drivers/usb/storage/Makefile |    4 ++
 drivers/usb/storage/uas.c    |  102 +++++++++++++++++++++++++++--------------
 3 files changed, 81 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 49a489e..eb9f6af 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -185,6 +185,16 @@ config USB_UAS
 
 	  If you compile this driver as a module, it will be named uas.
 
+config USB_UAS_DEBUG
+       bool "Compile in debug mode"
+       default n
+       depends on USB_UAS
+       help
+	 Compiles the uas driver in debug mode. In debug mode,
+	 the driver prints debug messages to the console.
+
+	 If unsure, say 'N'.
+
 config USB_LIBUSUAL
 	bool "The shared table of common (or usual) storage devices"
 	depends on USB
diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index fcf14cd..16715ab 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -10,6 +10,10 @@ ccflags-y := -Idrivers/scsi
 obj-$(CONFIG_USB_UAS)		+= uas.o
 obj-$(CONFIG_USB_STORAGE)	+= usb-storage.o
 
+ifeq ($(CONFIG_USB_UAS_DEBUG),y)
+	EXTRA_CFLAGS += -DUAS_DEBUG
+endif
+
 usb-storage-y := scsiglue.o protocol.o transport.o usb.o
 usb-storage-y += initializers.o sierra_ms.o option_ms.o
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 48dc2b8..ef6e707 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -21,6 +21,14 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+#define uas_printk(fmt, ...)	printk(KERN_NOTICE "uas: " fmt, ## __VA_ARGS__)
+
+#ifdef UAS_DEBUG
+#define UAS_DPRINTK uas_printk
+#else
+#define UAS_DPRINTK(fmt, ...)
+#endif
+
 /* Common header for all IUs */
 struct iu {
 	__u8 iu_id;
@@ -128,6 +136,7 @@ static void uas_do_work(struct work_struct *work)
 {
 	struct uas_cmd_info *cmdinfo;
 	struct list_head list;
+	int res;
 
 	spin_lock_irq(&uas_work_lock);
 	list_replace_init(&uas_work_list, &list);
@@ -136,8 +145,10 @@ static void uas_do_work(struct work_struct *work)
 	list_for_each_entry(cmdinfo, &list, list) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp,
-							struct scsi_cmnd, SCp);
-		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
+						      struct scsi_cmnd, SCp);
+		res = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
+		UAS_DPRINTK("%s: cmd:%p, res:%d, state:0x%x\n", __FUNCTION__,
+			    cmnd, res, cmdinfo->state);
 	}
 }
 
@@ -198,13 +209,15 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 }
 
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
-							unsigned direction)
+			  unsigned direction)
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
 	cmdinfo->state = direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
+	UAS_DPRINTK("%s: cmd:%p, err:%d, state:0x%x\n", __FUNCTION__,
+		    cmnd, err, cmdinfo->state);
 	if (err) {
 		spin_lock(&uas_work_lock);
 		list_add_tail(&cmdinfo->list, &uas_work_list);
@@ -222,7 +235,8 @@ static void uas_stat_cmplt(struct urb *urb)
 	u16 tag;
 
 	if (urb->status) {
-		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
+		dev_err(&urb->dev->dev, "%s: URB BAD STATUS %d\n",
+			__FUNCTION__, urb->status);
 		usb_free_urb(urb);
 		return;
 	}
@@ -259,6 +273,14 @@ static void uas_stat_cmplt(struct urb *urb)
 static void uas_data_cmplt(struct urb *urb)
 {
 	struct scsi_data_buffer *sdb = urb->context;
+
+	if (urb->status) {
+		dev_err(&urb->dev->dev, "%s: URB BAD STATUS %d\n",
+			__FUNCTION__, urb->status);
+		usb_free_urb(urb);
+		return;
+	}
+	
 	sdb->resid = sdb->length - urb->actual_length;
 	usb_free_urb(urb);
 }
@@ -339,7 +361,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	memcpy(iu->cdb, cmnd->cmnd, cmnd->cmd_len);
 
 	usb_fill_bulk_urb(urb, udev, devinfo->cmd_pipe, iu, sizeof(*iu) + len,
-							usb_free_urb, NULL);
+			  usb_free_urb, NULL);
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
 	return urb;
@@ -355,23 +377,26 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
  */
 
 static int uas_submit_urbs(struct scsi_cmnd *cmnd,
-					struct uas_dev_info *devinfo, gfp_t gfp)
+			   struct uas_dev_info *devinfo, gfp_t gfp)
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	int res;
 
 	if (cmdinfo->state & ALLOC_STATUS_URB) {
 		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
 							  cmdinfo->stream);
 		if (!cmdinfo->status_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_STATUS_URB;
 	}
 
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		if (usb_submit_urb(cmdinfo->status_urb, gfp)) {
+		res = usb_submit_urb(cmdinfo->status_urb, gfp);
+		if (res) {
 			scmd_printk(KERN_INFO, cmnd,
-					"sense urb submission failure\n");
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+				    "sense urb submission failure (%d)\n",
+				    res);
+			return res;
 		}
 		cmdinfo->state &= ~SUBMIT_STATUS_URB;
 	}
@@ -381,15 +406,17 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 					devinfo->data_in_pipe, cmdinfo->stream,
 					scsi_in(cmnd), DMA_FROM_DEVICE);
 		if (!cmdinfo->data_in_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_DATA_IN_URB;
 	}
 
 	if (cmdinfo->state & SUBMIT_DATA_IN_URB) {
-		if (usb_submit_urb(cmdinfo->data_in_urb, gfp)) {
+		res = usb_submit_urb(cmdinfo->data_in_urb, gfp);
+		if (res) {
 			scmd_printk(KERN_INFO, cmnd,
-					"data in urb submission failure\n");
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+				    "data in urb submission failure (%d)\n",
+				    res);
+			return res;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
 	}
@@ -399,15 +426,17 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 					devinfo->data_out_pipe, cmdinfo->stream,
 					scsi_out(cmnd), DMA_TO_DEVICE);
 		if (!cmdinfo->data_out_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_DATA_OUT_URB;
 	}
 
 	if (cmdinfo->state & SUBMIT_DATA_OUT_URB) {
-		if (usb_submit_urb(cmdinfo->data_out_urb, gfp)) {
+		res = usb_submit_urb(cmdinfo->data_out_urb, gfp);
+		if (res) {
 			scmd_printk(KERN_INFO, cmnd,
-					"data out urb submission failure\n");
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+				    "data out urb submission failure (%d)\n",
+				    res);
+			return res;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
 	}
@@ -416,15 +445,16 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		cmdinfo->cmd_urb = uas_alloc_cmd_urb(devinfo, gfp, cmnd,
 							cmdinfo->stream);
 		if (!cmdinfo->cmd_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+			return -ENOMEM;
 		cmdinfo->state &= ~ALLOC_CMD_URB;
 	}
 
 	if (cmdinfo->state & SUBMIT_CMD_URB) {
-		if (usb_submit_urb(cmdinfo->cmd_urb, gfp)) {
+		res = usb_submit_urb(cmdinfo->cmd_urb, gfp);
+		if (res) {
 			scmd_printk(KERN_INFO, cmnd,
-					"cmd urb submission failure\n");
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+				    "cmd urb submission failure (%d)\n", res);
+			return res;
 		}
 		cmdinfo->state &= ~SUBMIT_CMD_URB;
 	}
@@ -433,12 +463,12 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 }
 
 static int uas_queuecommand(struct scsi_cmnd *cmnd,
-					void (*done)(struct scsi_cmnd *))
+			    void (*done)(struct scsi_cmnd *))
 {
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
-	int err;
+	int res;
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
@@ -474,17 +504,19 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 		cmdinfo->stream = 0;
 	}
 
-	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
-	if (err) {
-		/* If we did nothing, give up now */
-		if (cmdinfo->state & SUBMIT_STATUS_URB) {
-			usb_free_urb(cmdinfo->status_urb);
-			return SCSI_MLQUEUE_DEVICE_BUSY;
-		}
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
-		spin_unlock(&uas_work_lock);
-		schedule_work(&uas_work);
+	res = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
+	UAS_DPRINTK("%s: cmd:%p (0x%02x), err:%d, state:0x%x\n", __FUNCTION__,
+		    cmnd, cmnd->cmnd[0], res, cmdinfo->state);
+	if (res) {
+		usb_unlink_urb(cmdinfo->status_urb);
+		usb_unlink_urb(cmdinfo->data_in_urb);
+		usb_unlink_urb(cmdinfo->data_out_urb);
+		usb_unlink_urb(cmdinfo->cmd_urb);
+
+		sdev->current_cmnd = NULL;
+
+		cmnd->result = DID_NO_CONNECT << 16;
+		done(cmnd);
 	}
 
 	return 0;
-- 
1.7.0.1

