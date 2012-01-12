From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: [PATCH][SCSI] enclosure & ses: modernize and add target power management
Date: Thu, 12 Jan 2012 12:03:55 -0500
Message-ID: <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com> <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:31188 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754371Ab2ALREC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 12:04:02 -0500
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>

Coincident repair of enclosure and ses device support. Fix problems with setting enclosure values careful to preserve other settings. Corrected fault setting as well. Modernize code. Add support for Device Power Management via a new r/w device_power node in sysfs and some internal interfaces to permit them to be called in the future by error recovery escalation. Enclosures that do not support individual power management will always return a status that the device has power.

The controversial adjustment in this patch is the support in the ses driver to punch-through error recovery, a specification requirement. Debate could be that scsi_error.c needs to export a scsi command queueing interface; also a controversial subject ...

Future: Add target device power-cycle to error recovery escalation before considering hba reset (tested in a libsas skunkwork on a 2.6.32 vintage kernel)

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

 drivers/misc/enclosure.c  |   62 ++++++++-
 drivers/scsi/ses.c        |  293 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/enclosure.h |    8 +
 3 files changed, 329 insertions(+), 34 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fca..287903b 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/slab.h>
 
 static LIST_HEAD(container_list);
 static DEFINE_MUTEX(container_list_lock);
@@ -420,10 +419,10 @@ static ssize_t set_component_fault(struct device *cdev,
 {
 	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
 	struct enclosure_component *ecomp = to_enclosure_component(cdev);
-	int val = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
 
-	if (edev->cb->set_fault)
-		edev->cb->set_fault(edev, ecomp, val);
+	if (!kstrtoul(buf, 0, &val) && edev->cb->set_fault)
+		edev->cb->set_fault(edev, ecomp, (int)val);
 	return count;
 }
 
@@ -478,10 +477,10 @@ static ssize_t set_component_active(struct device *cdev,
 {
 	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
 	struct enclosure_component *ecomp = to_enclosure_component(cdev);
-	int val = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
 
-	if (edev->cb->set_active)
-		edev->cb->set_active(edev, ecomp, val);
+	if (!kstrtoul(buf, 0, &val) && edev->cb->set_active)
+		edev->cb->set_active(edev, ecomp, (int)val);
 	return count;
 }
 
@@ -502,13 +501,53 @@ static ssize_t set_component_locate(struct device *cdev,
 {
 	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
 	struct enclosure_component *ecomp = to_enclosure_component(cdev);
-	int val = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
 
-	if (edev->cb->set_locate)
-		edev->cb->set_locate(edev, ecomp, val);
+	if (!kstrtoul(buf, 0, &val) && edev->cb->set_locate)
+		edev->cb->set_locate(edev, ecomp, (int)val);
 	return count;
 }
 
+int enclosure_get_device_power(struct device *cdev)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+
+	if (edev->cb->get_device_power)
+		edev->cb->get_device_power(edev, ecomp);
+	return ecomp->device_power;
+}
+EXPORT_SYMBOL_GPL(enclosure_get_device_power);
+
+void enclosure_set_device_power(struct device *cdev, int val)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+
+	if (edev->cb->set_device_power)
+		edev->cb->set_device_power(edev, ecomp, val);
+}
+EXPORT_SYMBOL_GPL(enclosure_set_device_power);
+
+#ifdef CONFIG_EXPERIMENTAL
+static ssize_t get_component_device_power(struct device *cdev,
+				    struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, 40, "%d\n", enclosure_get_device_power(cdev));
+}
+
+static ssize_t set_component_device_power(struct device *cdev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	unsigned long val;
+
+	if (!kstrtoul(buf, 0, &val))
+		enclosure_set_device_power(cdev, (int)val);
+	return count;
+}
+#endif
+
 static ssize_t get_component_type(struct device *cdev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -526,6 +565,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
 		   set_component_active);
 static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
 		   set_component_locate);
+static DEVICE_ATTR(device_power, S_IRUGO | S_IWUSR, get_component_device_power,
+		   set_component_device_power);
 static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
 
 static struct attribute *enclosure_component_attrs[] = {
@@ -533,6 +574,7 @@ static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_status.attr,
 	&dev_attr_active.attr,
 	&dev_attr_locate.attr,
+	&dev_attr_device_power.attr,
 	&dev_attr_type.attr,
 	NULL
 };
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eba183c..27bc0ef 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -21,7 +21,6 @@
 **-----------------------------------------------------------------------------
 */
 
-#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/enclosure.h>
@@ -32,6 +31,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 struct ses_device {
 	unsigned char *page1;
@@ -67,6 +67,196 @@ static int ses_probe(struct device *dev)
 #define SES_TIMEOUT (30 * HZ)
 #define SES_RETRIES 3
 
+/* Copy-n-Paste from scsi_error.c, names changed to protect the innocent */
+
+/**
+ * ses_scsi_eh_done - Completion function for error handling.
+ * @scmd:	Cmd that is done.
+ */
+static void ses_scsi_eh_done(struct scsi_cmnd *scmd)
+{
+	struct completion     *eh_action;
+
+	eh_action = scmd->device->host->eh_action;
+	if (eh_action)
+		complete(eh_action);
+}
+
+/**
+ * ses_scsi_eh_completed_normally - Disposition a eh cmd on return from LLD.
+ * @scmd:	SCSI cmd to examine.
+ *
+ * Notes:
+ *    This is *only* called when we are examining the status of commands
+ *    queued during error recovery.  the main difference here is that we
+ *    don't allow for the possibility of retries here, and we are a lot
+ *    more restrictive about what we consider acceptable.
+ */
+static int ses_scsi_eh_completed_normally(struct scsi_cmnd *scmd)
+{
+	/*
+	 * first check the host byte, to see if there is anything in there
+	 * that would indicate what we need to do.
+	 */
+	if (host_byte(scmd->result) == DID_RESET)
+		return SUCCESS;
+	if (host_byte(scmd->result) != DID_OK)
+		return FAILED;
+
+	/*
+	 * next, check the message byte.
+	 */
+	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
+		return FAILED;
+
+	/*
+	 * now, check the status byte to see if this indicates
+	 * anything special.
+	 */
+	switch (status_byte(scmd->result)) {
+	case GOOD:
+	case COMMAND_TERMINATED:
+		return SUCCESS;
+	case CHECK_CONDITION:
+		return SUCCESS;
+	case CONDITION_GOOD:
+	case INTERMEDIATE_GOOD:
+	case INTERMEDIATE_C_GOOD:
+		/*
+		 * who knows?  FIXME(eric)
+		 */
+		return SUCCESS;
+	case RESERVATION_CONFLICT:
+		if (scmd->cmnd[0] == TEST_UNIT_READY)
+			/* it is a success, we probed the device and
+			 * found it */
+			return SUCCESS;
+		/* otherwise, we failed to send the command */
+		return FAILED;
+	case QUEUE_FULL:
+		/* fall through */
+	case BUSY:
+		return NEEDS_RETRY;
+	default:
+		return FAILED;
+	}
+	return FAILED;
+}
+
+/**
+ * ses_scsi_send_eh_cmnd  - submit a scsi command as part of error recory
+ * @scmd:       SCSI command structure to hijack
+ * @cmnd:       CDB to send
+ * @cmnd_size:  size in bytes of @cmnd
+ * @timeout:    timeout for this request
+ * @sense_bytes: size of sense data to copy or 0
+ *
+ * This function is used to send a scsi command down to a target device
+ * as part of the error recovery process. See also scsi_eh_prep_cmnd() above.
+ *
+ * Return value:
+ *    SUCCESS or FAILED or NEEDS_RETRY
+ */
+static int ses_scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
+			     int cmnd_size, int timeout, unsigned sense_bytes)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	DECLARE_COMPLETION_ONSTACK(done);
+	unsigned long timeleft;
+	unsigned long flags;
+	struct scsi_eh_save ses;
+	int rtn;
+
+	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
+	shost->eh_action = &done;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->hostt->queuecommand(scmd, ses_scsi_eh_done);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	timeleft = wait_for_completion_timeout(&done, timeout);
+
+	shost->eh_action = NULL;
+
+	/*
+	 * If there is time left ses_scsi_eh_done got called, and we will
+	 * examine the actual status codes to see whether the command
+	 * actually did complete normally, else tell the host to forget
+	 * about this command.
+	 */
+	if (timeleft) {
+		rtn = ses_scsi_eh_completed_normally(scmd);
+
+		switch (rtn) {
+		case SUCCESS:
+		case NEEDS_RETRY:
+		case FAILED:
+		case TARGET_ERROR:
+			break;
+		case ADD_TO_MLQUEUE:
+			rtn = NEEDS_RETRY;
+			break;
+		default:
+			rtn = FAILED;
+			break;
+		}
+	} else {
+		/* WASS */
+		rtn = TARGET_ERROR;
+	}
+
+	scsi_eh_restore_cmnd(scmd, &ses);
+	return rtn;
+}
+
+/*
+ * Function:	ses_scsi_execute_req
+ *
+ * Purpose:	Send requested reset to a bus or device at any phase.
+ *
+ * Arguments:	device	- device to send reset to
+ *		flag - reset type (see scsi.h)
+ *
+ * Returns:	SUCCESS/FAILURE.
+ *
+ * Notes:	This is used by the SCSI Generic driver to provide
+ *		Bus/Device reset capability.
+ */
+int
+ses_scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen)
+{
+	struct scsi_cmnd *scmd;
+	struct request req;
+	int result = DRIVER_ERROR << 24;
+
+	blk_rq_init(NULL, &req);
+	req.cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req.cmd, cmd, req.cmd_len);
+	req.sense = NULL;
+	req.sense_len = 0;
+	req.retries = SES_RETRIES;
+	req.timeout = SES_TIMEOUT;
+	req.cmd_type = REQ_TYPE_BLOCK_PC;
+	req.cmd_flags = REQ_QUIET | REQ_PREEMPT;
+	if (bufflen && blk_rq_map_kern(sdev->request_queue, &req,
+				buffer, bufflen, __GFP_WAIT))
+		return result;
+
+	scmd = scsi_get_command(sdev, GFP_KERNEL);
+	scmd->request = &req;
+	scmd->cmnd = req.cmd;
+	scmd->scsi_done = ses_scsi_eh_done;
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
+	scmd->cmd_len = 6;
+	scmd->sc_data_direction = data_direction;
+
+	result = ses_scsi_send_eh_cmnd(scmd, cmd, 6, SES_TIMEOUT, 0);
+
+	return result;
+}
+
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
@@ -79,6 +269,13 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 
+	/* Allow command to punch-through host error recovery? */
+	if (scsi_host_in_recovery(sdev->host) && !list_empty(&sdev->cmd_list))
+		return DRIVER_SOFT << 24;
+
+	if (scsi_host_in_recovery(sdev->host))
+		return ses_scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE,
+					buf, bufflen);
 	return scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
 				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 }
@@ -97,7 +294,16 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+	/* Allow command to punch-through host error recovery? */
+	if (scsi_host_in_recovery(sdev->host) && !list_empty(&sdev->cmd_list))
+		return DRIVER_SOFT << 24;
+
+	if (scsi_host_in_recovery(sdev->host))
+		result = ses_scsi_execute_req(sdev, cmd, DMA_TO_DEVICE,
+				  buf, bufflen);
+	else
+		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE,
+				  buf, bufflen,
 				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
@@ -174,18 +380,38 @@ static void ses_get_fault(struct enclosure_device *edev,
 		ecomp->fault = (desc[3] & 0x60) >> 4;
 }
 
+static void ses_read_page2_descriptor(struct enclosure_device *edev,
+				      struct enclosure_component *ecomp,
+				      unsigned char *desc)
+{
+	unsigned char *desc_ptr = ses_get_page2_descriptor(edev, ecomp);
+
+	if (desc_ptr)
+		memcpy(desc, desc_ptr, 4);
+	/* preserve active state */
+	if (ecomp->active)
+		desc[2] |= 0x80;
+	else
+		desc[2] &= ~0x80;
+	/* Clear all reserved/alternate-purpose bits */
+	desc[2] &= 0xE7;
+	desc[3] &= 0x3C;
+}
+
 static int ses_set_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			 enum enclosure_component_setting val)
 {
 	unsigned char desc[4] = {0 };
 
+	ses_read_page2_descriptor(edev, ecomp, desc);
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
 		/* zero is disabled */
+		desc[3] &= ~0x20;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[3] = 0x20;
+		desc[3] |= 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
@@ -221,12 +447,46 @@ static int ses_set_locate(struct enclosure_device *edev,
 {
 	unsigned char desc[4] = {0 };
 
+	ses_read_page2_descriptor(edev, ecomp, desc);
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
 		/* zero is disabled */
+		desc[2] &= ~0x02;
+		break;
+	case ENCLOSURE_SETTING_ENABLED:
+		desc[2] |= 0x02;
+		break;
+	default:
+		/* SES doesn't do the SGPIO blink settings */
+		return -EINVAL;
+	}
+	return ses_set_page2_descriptor(edev, ecomp, desc);
+}
+
+static void ses_get_device_power(struct enclosure_device *edev,
+			   struct enclosure_component *ecomp)
+{
+	unsigned char *desc;
+
+	desc = ses_get_page2_descriptor(edev, ecomp);
+	if (desc)
+		ecomp->device_power = (desc[3] & 0x10) ? 0 : 1;
+}
+
+static int ses_set_device_power(struct enclosure_device *edev,
+			  struct enclosure_component *ecomp,
+			  enum enclosure_component_setting val)
+{
+	unsigned char desc[4] = {0 };
+
+	ses_read_page2_descriptor(edev, ecomp, desc);
+	switch (val) {
+	case ENCLOSURE_SETTING_DISABLED:
+		/* one is disabled */
+		desc[3] |= 0x10;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[3] &= ~0x10;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
@@ -241,13 +501,15 @@ static int ses_set_active(struct enclosure_device *edev,
 {
 	unsigned char desc[4] = {0 };
 
+	ses_read_page2_descriptor(edev, ecomp, desc);
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
 		/* zero is disabled */
+		desc[2] &= ~0x80;
 		ecomp->active = 0;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x80;
+		desc[2] |= 0x80;
 		ecomp->active = 1;
 		break;
 	default:
@@ -263,6 +525,8 @@ static struct enclosure_component_callbacks ses_enclosure_callbacks = {
 	.get_status		= ses_get_status,
 	.get_locate		= ses_get_locate,
 	.set_locate		= ses_set_locate,
+	.get_device_power	= ses_get_device_power,
+	.set_device_power	= ses_set_device_power,
 	.set_active		= ses_set_active,
 };
 
@@ -271,25 +535,6 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
-#if 0
-int ses_match_host(struct enclosure_device *edev, void *data)
-{
-	struct ses_host_edev *sed = data;
-	struct scsi_device *sdev;
-
-	if (!scsi_is_sdev_device(edev->edev.parent))
-		return 0;
-
-	sdev = to_scsi_device(edev->edev.parent);
-
-	if (sdev->host != sed->shost)
-		return 0;
-
-	sed->edev = edev;
-	return 1;
-}
-#endif  /*  0  */
-
 static void ses_process_descriptor(struct enclosure_component *ecomp,
 				   unsigned char *desc)
 {
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 9a33c5f..46f4482 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -79,6 +79,11 @@ struct enclosure_component_callbacks {
 	int (*set_locate)(struct enclosure_device *,
 			  struct enclosure_component *,
 			  enum enclosure_component_setting);
+	void (*get_device_power)(struct enclosure_device *,
+			   struct enclosure_component *);
+	int (*set_device_power)(struct enclosure_device *,
+			  struct enclosure_component *,
+			  enum enclosure_component_setting);
 };
 
 
@@ -91,6 +96,7 @@ struct enclosure_component {
 	int fault;
 	int active;
 	int locate;
+	int device_power;
 	enum enclosure_status status;
 };
 
@@ -129,5 +135,7 @@ struct enclosure_device *enclosure_find(struct device *dev,
 					struct enclosure_device *start);
 int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
 			      void *data);
+int enclosure_get_device_power(struct device *cdev);
+void enclosure_set_device_power(struct device *cdev, int val);
 
 #endif /* _LINUX_ENCLOSURE_H_ */

