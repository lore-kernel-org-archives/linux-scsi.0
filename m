From: matthew@wil.cx
Subject: [PATCH 3/5] uas: Rename sense pipe and sense urb to status pipe and status urb
Date: Wed, 15 Dec 2010 15:44:04 -0500
Message-ID: <1292445846-12101-3-git-send-email-matthew@wil.cx>
References: <20101215204147.GA1263@parisc-linux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

The spec calls this the status pipe.  While it is used to receive sense IUs,
it is also used to receive other IUs, so this can be confusing.

Reported-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 981fdef..f82787f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -100,8 +100,8 @@ struct uas_dev_info {
 };
 
 enum {
-	ALLOC_SENSE_URB		= (1 << 0),
-	SUBMIT_SENSE_URB	= (1 << 1),
+	ALLOC_STATUS_URB	= (1 << 0),
+	SUBMIT_STATUS_URB	= (1 << 1),
 	ALLOC_DATA_IN_URB	= (1 << 2),
 	SUBMIT_DATA_IN_URB	= (1 << 3),
 	ALLOC_DATA_OUT_URB	= (1 << 4),
@@ -115,7 +115,7 @@ struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
 	struct urb *cmd_urb;
-	struct urb *sense_urb;
+	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
 	struct list_head list;
@@ -207,7 +207,7 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
-	cmdinfo->state = direction | SUBMIT_SENSE_URB;
+	cmdinfo->state = direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
 		spin_lock(&uas_work_lock);
@@ -360,21 +360,21 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
-	if (cmdinfo->state & ALLOC_SENSE_URB) {
-		cmdinfo->sense_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
-							cmdinfo->stream);
-		if (!cmdinfo->sense_urb)
+	if (cmdinfo->state & ALLOC_STATUS_URB) {
+		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
+							  cmdinfo->stream);
+		if (!cmdinfo->status_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
-		cmdinfo->state &= ~ALLOC_SENSE_URB;
+		cmdinfo->state &= ~ALLOC_STATUS_URB;
 	}
 
-	if (cmdinfo->state & SUBMIT_SENSE_URB) {
-		if (usb_submit_urb(cmdinfo->sense_urb, gfp)) {
+	if (cmdinfo->state & SUBMIT_STATUS_URB) {
+		if (usb_submit_urb(cmdinfo->status_urb, gfp)) {
 			scmd_printk(KERN_INFO, cmnd,
 					"sense urb submission failure\n");
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		cmdinfo->state &= ~SUBMIT_SENSE_URB;
+		cmdinfo->state &= ~SUBMIT_STATUS_URB;
 	}
 
 	if (cmdinfo->state & ALLOC_DATA_IN_URB) {
@@ -443,7 +443,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->sense_urb && sdev->current_cmnd)
+	if (!cmdinfo->status_urb && sdev->current_cmnd)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	if (blk_rq_tagged(cmnd->request)) {
@@ -455,7 +455,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	cmnd->scsi_done = done;
 
-	cmdinfo->state = ALLOC_SENSE_URB | SUBMIT_SENSE_URB |
+	cmdinfo->state = ALLOC_STATUS_URB | SUBMIT_STATUS_URB |
 			ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
@@ -478,8 +478,8 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
 	if (err) {
 		/* If we did nothing, give up now */
-		if (cmdinfo->state & SUBMIT_SENSE_URB) {
-			usb_free_urb(cmdinfo->sense_urb);
+		if (cmdinfo->state & SUBMIT_STATUS_URB) {
+			usb_free_urb(cmdinfo->status_urb);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		spin_lock(&uas_work_lock);
-- 
1.7.2.3
