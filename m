From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/7] uas: task mgmt & error handling
Date: Tue, 19 Jun 2012 09:54:54 +0200
Message-ID: <1340092494-18876-8-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add task management support, wind up in abort and device reset error
handlers.  Cancel all in-flight urbs in bus reset handler.

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c |  160 ++++++++++++++++++++++++++++++++++++--------
 include/linux/usb/uas.h   |   40 +++++++++++
 2 files changed, 171 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 875829a..638cd64 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -43,7 +43,8 @@ struct uas_dev_info {
 	struct usb_device *udev;
 	struct usb_anchor sense_urbs;
 	struct usb_anchor data_urbs;
-	int qdepth;
+	int qdepth, resetting;
+	struct response_ui response;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
@@ -68,6 +69,7 @@ enum {
 struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
+	unsigned int aborted;
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
@@ -222,16 +224,24 @@ static void uas_stat_cmplt(struct urb *urb)
 		return;
 	}
 
+	if (devinfo->resetting) {
+		usb_free_urb(urb);
+		return;
+	}
+
 	tag = be16_to_cpup(&iu->tag) - 1;
 	if (tag == 0)
 		cmnd = devinfo->cmnd;
 	else
 		cmnd = scsi_host_find_tag(shost, tag - 1);
 	if (!cmnd) {
-		usb_free_urb(urb);
-		return;
+		if (iu->iu_id != IU_ID_RESPONSE) {
+			usb_free_urb(urb);
+			return;
+		}
+	} else {
+		cmdinfo = (void *)&cmnd->SCp;
 	}
-	cmdinfo = (void *)&cmnd->SCp;
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
@@ -260,6 +270,10 @@ static void uas_stat_cmplt(struct urb *urb)
 	case IU_ID_WRITE_READY:
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
 		break;
+	case IU_ID_RESPONSE:
+		/* store results for uas_eh_task_mgmt() */
+		memcpy(&devinfo->response, iu, sizeof(devinfo->response));
+		break;
 	default:
 		scmd_printk(KERN_ERR, cmnd,
 			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
@@ -287,6 +301,9 @@ static void uas_data_cmplt(struct urb *urb)
 	} else {
 		sdb->resid = sdb->length - urb->actual_length;
 	}
+	if (cmdinfo->aborted) {
+		return;
+	}
 	uas_try_complete(cmnd, __func__);
 }
 
@@ -377,6 +394,51 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	return NULL;
 }
 
+static int uas_submit_task_urb(struct scsi_cmnd *cmnd, gfp_t gfp,
+			       u8 function, u16 stream_id)
+{
+	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
+	struct usb_device *udev = devinfo->udev;
+	struct urb *urb = usb_alloc_urb(0, gfp);
+	struct task_mgmt_iu *iu;
+	int err = -ENOMEM;
+
+	if (!urb)
+		goto err;
+
+	iu = kzalloc(sizeof(*iu), gfp);
+	if (!iu)
+		goto err;
+
+	iu->iu_id = IU_ID_TASK_MGMT;
+	iu->tag = cpu_to_be16(stream_id);
+	int_to_scsilun(cmnd->device->lun, &iu->lun);
+
+	iu->function = function;
+	switch (function) {
+	case TMF_ABORT_TASK:
+		if (blk_rq_tagged(cmnd->request))
+			iu->task_tag = cpu_to_be16(cmnd->request->tag + 2);
+		else
+			iu->task_tag = cpu_to_be16(1);
+		break;
+	}
+
+	usb_fill_bulk_urb(urb, udev, devinfo->cmd_pipe, iu, sizeof(*iu),
+			  usb_free_urb, NULL);
+	urb->transfer_flags |= URB_FREE_BUFFER;
+
+	err = usb_submit_urb(urb, gfp);
+	if (err)
+		goto err;
+
+	return 0;
+
+err:
+	usb_free_urb(urb);
+	return err;
+}
+
 /*
  * Why should I request the Status IU before sending the Command IU?  Spec
  * says to, but also says the device may receive them in any order.  Seems
@@ -502,6 +564,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	cmdinfo->state = SUBMIT_STATUS_URB |
 			ALLOC_CMD_URB | SUBMIT_CMD_URB;
+	cmdinfo->aborted = 0;
 
 	switch (cmnd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
@@ -537,34 +600,66 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 static DEF_SCSI_QCMD(uas_queuecommand)
 
-static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_task_mgmt(struct scsi_cmnd *cmnd,
+			    const char *fname, u8 function)
 {
-	uas_log_cmd_state(cmnd, __func__);
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
+	u16 tag = 9999; /* FIXME */
 
-/* XXX: Send ABORT TASK Task Management command */
-	return FAILED;
+	memset(&devinfo->response, 0, sizeof(devinfo->response));
+	if (uas_submit_sense_urb(shost, GFP_NOIO, tag)) {
+		shost_printk(KERN_INFO, shost,
+			     "%s: %s: submit sense urb failed\n",
+			     __func__, fname);
+		return FAILED;
+	}
+	if (uas_submit_task_urb(cmnd, GFP_NOIO, function, tag)) {
+		shost_printk(KERN_INFO, shost,
+			     "%s: %s: submit task mgmt urb failed\n",
+			     __func__, fname);
+		return FAILED;
+	}
+	if (0 == usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 3000)) {
+		shost_printk(KERN_INFO, shost,
+			     "%s: %s timed out\n", __func__, fname);
+		return FAILED;
+	}
+	if (be16_to_cpu(devinfo->response.tag) != tag) {
+		shost_printk(KERN_INFO, shost,
+			     "%s: %s failed (wrong tag %d/%d)\n", __func__,
+			     fname, be16_to_cpu(devinfo->response.tag), tag);
+		return FAILED;
+	}
+	if (devinfo->response.response_code != RC_TMF_COMPLETE) {
+		shost_printk(KERN_INFO, shost,
+			     "%s: %s failed (rc 0x%x)\n", __func__,
+			     fname, devinfo->response.response_code);
+		return FAILED;
+	}
+	return SUCCESS;
 }
 
-static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	int ret;
 
-/* XXX: Send LOGICAL UNIT RESET Task Management command */
-	return FAILED;
+	uas_log_cmd_state(cmnd, __func__);
+	cmdinfo->aborted = 1;
+	ret = uas_eh_task_mgmt(cmnd, "ABORT TASK", TMF_ABORT_TASK);
+	if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
+		usb_kill_urb(cmdinfo->data_in_urb);
+	if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
+		usb_kill_urb(cmdinfo->data_out_urb);
+	return ret;
 }
 
-static int uas_eh_target_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
-
-/* XXX: Can we reset just the one USB interface?
- * Would calling usb_set_interface() have the right effect?
- */
-	return FAILED;
+	sdev_printk(KERN_INFO, cmnd->device, "%s\n", __func__);
+	return uas_eh_task_mgmt(cmnd, "LOGICAL UNIT RESET",
+				TMF_LOGICAL_UNIT_RESET);
 }
 
 static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
@@ -572,14 +667,21 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct usb_device *udev = devinfo->udev;
+	int err;
 
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	devinfo->resetting = 1;
+	usb_kill_anchored_urbs(&devinfo->sense_urbs);
+	usb_kill_anchored_urbs(&devinfo->data_urbs);
+	err = usb_reset_device(udev);
+	devinfo->resetting = 0;
 
-	if (usb_reset_device(udev))
-		return SUCCESS;
+	if (err) {
+		shost_printk(KERN_INFO, sdev->host, "%s FAILED\n", __func__);
+		return FAILED;
+	}
 
-	return FAILED;
+	shost_printk(KERN_INFO, sdev->host, "%s success\n", __func__);
+	return SUCCESS;
 }
 
 static int uas_slave_alloc(struct scsi_device *sdev)
@@ -604,7 +706,6 @@ static struct scsi_host_template uas_host_template = {
 	.slave_configure = uas_slave_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
-	.eh_target_reset_handler = uas_eh_target_reset_handler,
 	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
 	.can_queue = 65536,	/* Is there a limit on the _host_ ? */
 	.this_id = -1,
@@ -766,6 +867,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->intf = intf;
 	devinfo->udev = udev;
+	devinfo->resetting = 0;
 	init_usb_anchor(&devinfo->sense_urbs);
 	init_usb_anchor(&devinfo->data_urbs);
 	uas_configure_endpoints(devinfo);
diff --git a/include/linux/usb/uas.h b/include/linux/usb/uas.h
index 9a988e4..5499ab5 100644
--- a/include/linux/usb/uas.h
+++ b/include/linux/usb/uas.h
@@ -20,6 +20,28 @@ enum {
 	IU_ID_WRITE_READY	= 0x07,
 };
 
+enum {
+	TMF_ABORT_TASK          = 0x01,
+	TMF_ABORT_TASK_SET      = 0x02,
+	TMF_CLEAR_TASK_SET      = 0x04,
+	TMF_LOGICAL_UNIT_RESET  = 0x08,
+	TMF_I_T_NEXUS_RESET     = 0x10,
+	TMF_CLEAR_ACA           = 0x40,
+	TMF_QUERY_TASK          = 0x80,
+	TMF_QUERY_TASK_SET      = 0x81,
+	TMF_QUERY_ASYNC_EVENT   = 0x82,
+};
+
+enum {
+	RC_TMF_COMPLETE         = 0x00,
+	RC_INVALID_INFO_UNIT    = 0x02,
+	RC_TMF_NOT_SUPPORTED    = 0x04,
+	RC_TMF_FAILED           = 0x05,
+	RC_TMF_SUCCEEDED        = 0x08,
+	RC_INCORRECT_LUN        = 0x09,
+	RC_OVERLAPPED_TAG       = 0x0a,
+};
+
 struct command_iu {
 	__u8 iu_id;
 	__u8 rsvd1;
@@ -32,6 +54,16 @@ struct command_iu {
 	__u8 cdb[16];	/* XXX: Overflow-checking tools may misunderstand */
 };
 
+struct task_mgmt_iu {
+	__u8 iu_id;
+	__u8 rsvd1;
+	__be16 tag;
+	__u8 function;
+	__u8 rsvd2;
+	__be16 task_tag;
+	struct scsi_lun lun;
+};
+
 /*
  * Also used for the Read Ready and Write Ready IUs since they have the
  * same first four bytes
@@ -47,6 +79,14 @@ struct sense_iu {
 	__u8 sense[SCSI_SENSE_BUFFERSIZE];
 };
 
+struct response_ui {
+	__u8 iu_id;
+	__u8 rsvd1;
+	__be16 tag;
+	__be16 add_response_info;
+	__u8 response_code;
+};
+
 struct usb_pipe_usage_descriptor {
 	__u8  bLength;
 	__u8  bDescriptorType;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
