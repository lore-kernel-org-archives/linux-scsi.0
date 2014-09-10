From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/21] uas: Remove task-management / abort error handling code
Date: Wed, 10 Sep 2014 13:46:32 +0200
Message-ID: <1410349611-17573-3-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

There are various bug reports about oopses / hangs with the uas driver,
which all point to the abort-command and logical-unit-reset (task-management)
error handling paths.

Getting these right is very hard, there are quite a few corner cases, and
testing is almost impossible since under normal operation these code paths
are not used at all.

Another problem is that there are also some cases where it simply is not clear
what to do at all. E.g. over usb-2 multiple outstanding commands share the same
endpoint. What if a command gets aborted while its sense urb is half way
through completing (so some data has been transfered but not all). Since the
urb is not yet complete we don't know if the sense urb is actually for this
command, or for one of the other oustanding commands. If it is for one of the
other commands and we cancel it, then we end up in an undefined state. But if
it is actually for the command we're aborting, and the abort succeeds, then it
may never complete...

This exact same problem applies to logical unit resets too, if there are
multiple luns, then commands outstanding on both luns share the sense
endpoint. If there is only a single lun, then doing a logical unit reset is
little better then doing a full usb device reset.

So summarizing because:
1) abort / lun-reset is very tricky to get right
2) Not being able to test the tricky code, which means it will have bugs
3) This being a code path which under normal operation will never happen,
   so being slow / sub-optimal here is not really an issue
4) Under error conditions we will still be able to recover through usb
   device resets.
5) This may be a bit slower in some cases, but this is actually faster in
   cases where the bridge ship has locked up, which seems to be the most
   common error case sofar.

This commit removes the abort / lun-reset error handling paths, and also the
taks-mgmt code since those are the only 2 task-mgmt users. Leaving only the
(tested and testable) usb-device-reset error handling path in place.

Note I realize that this is somewhat of a big hammer, but currently people
are seeing very hard to debug oopses with uas. First let focus on making uas
work reliable, then we can later look into adding more fine grained error
handling.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 177 +---------------------------------------------
 1 file changed, 1 insertion(+), 176 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 05b2d8e..307658d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -2,7 +2,7 @@
  * USB Attached SCSI
  * Note that this is not the same as the USB Mass Storage driver
  *
- * Copyright Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> for Red Hat, Inc. 2013
+ * Copyright Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> for Red Hat, Inc. 2013 - 2014
  * Copyright Matthew Wilcox for Intel Corp, 2010
  * Copyright Sarah Sharp for Intel Corp, 2010
  *
@@ -50,11 +50,9 @@ struct uas_dev_info {
 	struct usb_anchor sense_urbs;
 	struct usb_anchor data_urbs;
 	int qdepth, resetting;
-	struct response_iu response;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
-	unsigned running_task:1;
 	unsigned shutdown:1;
 	struct scsi_cmnd *cmnd;
 	spinlock_t lock;
@@ -205,7 +203,6 @@ static void uas_zap_dead(struct uas_dev_info *devinfo)
 				    DATA_OUT_URB_INFLIGHT);
 		uas_try_complete(cmnd, __func__);
 	}
-	devinfo->running_task = 0;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
@@ -348,13 +345,6 @@ static void uas_stat_cmplt(struct urb *urb)
 		cmnd = scsi_host_find_tag(shost, tag - 1);
 
 	if (!cmnd) {
-		if (iu->iu_id == IU_ID_RESPONSE) {
-			if (!devinfo->running_task)
-				dev_warn(&urb->dev->dev,
-				    "stat urb: recv unexpected response iu\n");
-			/* store results for uas_eh_task_mgmt() */
-			memcpy(&devinfo->response, iu, sizeof(devinfo->response));
-		}
 		usb_free_urb(urb);
 		spin_unlock_irqrestore(&devinfo->lock, flags);
 		return;
@@ -534,56 +524,6 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	return NULL;
 }
 
-static int uas_submit_task_urb(struct scsi_cmnd *cmnd, gfp_t gfp,
-			       u8 function, u16 stream_id)
-{
-	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
-	struct usb_device *udev = devinfo->udev;
-	struct urb *urb = usb_alloc_urb(0, gfp);
-	struct task_mgmt_iu *iu;
-	int err = -ENOMEM;
-
-	if (!urb)
-		goto err;
-
-	iu = kzalloc(sizeof(*iu), gfp);
-	if (!iu)
-		goto err;
-
-	iu->iu_id = IU_ID_TASK_MGMT;
-	iu->tag = cpu_to_be16(stream_id);
-	int_to_scsilun(cmnd->device->lun, &iu->lun);
-
-	iu->function = function;
-	switch (function) {
-	case TMF_ABORT_TASK:
-		if (blk_rq_tagged(cmnd->request))
-			iu->task_tag = cpu_to_be16(cmnd->request->tag + 2);
-		else
-			iu->task_tag = cpu_to_be16(1);
-		break;
-	}
-
-	usb_fill_bulk_urb(urb, udev, devinfo->cmd_pipe, iu, sizeof(*iu),
-			  uas_cmd_cmplt, cmnd);
-	urb->transfer_flags |= URB_FREE_BUFFER;
-
-	usb_anchor_urb(urb, &devinfo->cmd_urbs);
-	err = usb_submit_urb(urb, gfp);
-	if (err) {
-		usb_unanchor_urb(urb);
-		uas_log_cmd_state(cmnd, __func__);
-		scmd_printk(KERN_ERR, cmnd, "task submission err %d\n", err);
-		goto err;
-	}
-
-	return 0;
-
-err:
-	usb_free_urb(urb);
-	return err;
-}
-
 /*
  * Why should I request the Status IU before sending the Command IU?  Spec
  * says to, but also says the device may receive them in any order.  Seems
@@ -776,118 +716,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 static DEF_SCSI_QCMD(uas_queuecommand)
 
-static int uas_eh_task_mgmt(struct scsi_cmnd *cmnd,
-			    const char *fname, u8 function)
-{
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
-	u16 tag = devinfo->qdepth;
-	unsigned long flags;
-	struct urb *sense_urb;
-	int result = SUCCESS;
-
-	spin_lock_irqsave(&devinfo->lock, flags);
-
-	if (devinfo->resetting) {
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return FAILED;
-	}
-
-	if (devinfo->running_task) {
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s: error already running a task\n",
-			     __func__, fname);
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return FAILED;
-	}
-
-	devinfo->running_task = 1;
-	memset(&devinfo->response, 0, sizeof(devinfo->response));
-	sense_urb = uas_submit_sense_urb(cmnd, GFP_ATOMIC,
-					 devinfo->use_streams ? tag : 0);
-	if (!sense_urb) {
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s: submit sense urb failed\n",
-			     __func__, fname);
-		devinfo->running_task = 0;
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return FAILED;
-	}
-	if (uas_submit_task_urb(cmnd, GFP_ATOMIC, function, tag)) {
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s: submit task mgmt urb failed\n",
-			     __func__, fname);
-		devinfo->running_task = 0;
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		usb_kill_urb(sense_urb);
-		return FAILED;
-	}
-	spin_unlock_irqrestore(&devinfo->lock, flags);
-
-	if (usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 3000) == 0) {
-		/*
-		 * Note we deliberately do not clear running_task here. If we
-		 * allow new tasks to be submitted, there is no way to figure
-		 * out if a received response_iu is for the failed task or for
-		 * the new one. A bus-reset will eventually clear running_task.
-		 */
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s timed out\n", __func__, fname);
-		return FAILED;
-	}
-
-	spin_lock_irqsave(&devinfo->lock, flags);
-	devinfo->running_task = 0;
-	if (be16_to_cpu(devinfo->response.tag) != tag) {
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s failed (wrong tag %d/%d)\n", __func__,
-			     fname, be16_to_cpu(devinfo->response.tag), tag);
-		result = FAILED;
-	} else if (devinfo->response.response_code != RC_TMF_COMPLETE) {
-		shost_printk(KERN_INFO, shost,
-			     "%s: %s failed (rc 0x%x)\n", __func__,
-			     fname, devinfo->response.response_code);
-		result = FAILED;
-	}
-	spin_unlock_irqrestore(&devinfo->lock, flags);
-
-	return result;
-}
-
-static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
-{
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
-	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&devinfo->lock, flags);
-
-	if (devinfo->resetting) {
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return FAILED;
-	}
-
-	uas_mark_cmd_dead(devinfo, cmdinfo, DID_ABORT, __func__);
-	if (cmdinfo->state & COMMAND_INFLIGHT) {
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		ret = uas_eh_task_mgmt(cmnd, "ABORT TASK", TMF_ABORT_TASK);
-	} else {
-		uas_unlink_data_urbs(devinfo, cmdinfo, &flags);
-		uas_try_complete(cmnd, __func__);
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		ret = SUCCESS;
-	}
-	return ret;
-}
-
-static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
-{
-	sdev_printk(KERN_INFO, cmnd->device, "%s\n", __func__);
-	return uas_eh_task_mgmt(cmnd, "LOGICAL UNIT RESET",
-				TMF_LOGICAL_UNIT_RESET);
-}
