From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/5]  qla2xxx: Add support to dynamically enable/disable ZIO.
Date: Thu, 27 Oct 2005 11:09:48 -0700 (PDT)
Message-ID: <20051027180948.11768.99937.sendpatchset@plap.qlogic.com>
References: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:49000 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751421AbVJ0SJt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:09:49 -0400
In-Reply-To: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP23xx and ISP24xx chips have support for an adaptive
method of posting SCSI command completions for multiple SCSI
commands during a single system interrupt.

SCSI commands are placed on the system response queue
without interrupting the host until 1) a delay timer
expires; or 2) a SCSI command completes with an error.

As long as the host software (qla2xxx) services the response
queue for completions (this polling is done during
queuecommand()) within the 'delay timer' period, the
firmware will not generate system interrupt.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c |   83 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    8 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 -
 drivers/scsi/qla2xxx/qla_init.c |   53 +++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_iocb.c |   10 +++++
 drivers/scsi/qla2xxx/qla_isr.c  |    7 ++-
 drivers/scsi/qla2xxx/qla_os.c   |   23 -----------
 7 files changed, 146 insertions(+), 41 deletions(-)

13c93a518a4cd938f27130eae70e3012a3b7ab65
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fc25cd8..47c9ecf 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -319,6 +319,83 @@ qla2x00_state_show(struct class_device *
 	return len;
 }
 
+static ssize_t
+qla2x00_zio_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	int len = 0;
+
+	switch (ha->zio_mode) {
+	case QLA_ZIO_MODE_5:
+		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 5\n");
+		break;
+	case QLA_ZIO_MODE_6:
+		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 6\n");
+		break;
+	case QLA_ZIO_DISABLED:
+		len += snprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
+		break;
+	}
+	return len;
+}
+
+static ssize_t
+qla2x00_zio_store(struct class_device *cdev, const char *buf, size_t count)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	int val = 0;
+	uint16_t zio_mode;
+
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+
+	switch (val) {
+	case 1:
+		zio_mode = QLA_ZIO_MODE_5;
+		break;
+	case 2:
+		zio_mode = QLA_ZIO_MODE_6;
+		break;
+	default:
+		zio_mode = QLA_ZIO_DISABLED;
+		break;
+	}
+
+	/* Update per-hba values and queue a reset. */
+	if (zio_mode != QLA_ZIO_DISABLED || ha->zio_mode != QLA_ZIO_DISABLED) {
+		ha->zio_mode = zio_mode;
+		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	}
+	return strlen(buf);
+}
+
+static ssize_t
+qla2x00_zio_timer_show(struct class_device *cdev, char *buf)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+
+	return snprintf(buf, PAGE_SIZE, "%d us\n", ha->zio_timer * 100);
+}
+
+static ssize_t
+qla2x00_zio_timer_store(struct class_device *cdev, const char *buf,
+    size_t count)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	int val = 0;
+	uint16_t zio_timer;
+
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+	if (val > 25500 || val < 100)
+		return -ERANGE;
+
+	zio_timer = (uint16_t)(val / 100);
+	ha->zio_timer = zio_timer;
+
+	return strlen(buf);
+}
+
 static CLASS_DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show,
 	NULL);
 static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
@@ -329,6 +406,10 @@ static CLASS_DEVICE_ATTR(model_name, S_I
 static CLASS_DEVICE_ATTR(model_desc, S_IRUGO, qla2x00_model_desc_show, NULL);
 static CLASS_DEVICE_ATTR(pci_info, S_IRUGO, qla2x00_pci_info_show, NULL);
 static CLASS_DEVICE_ATTR(state, S_IRUGO, qla2x00_state_show, NULL);
+static CLASS_DEVICE_ATTR(zio, S_IRUGO | S_IWUSR, qla2x00_zio_show,
+    qla2x00_zio_store);
+static CLASS_DEVICE_ATTR(zio_timer, S_IRUGO | S_IWUSR, qla2x00_zio_timer_show,
+    qla2x00_zio_timer_store);
 
 struct class_device_attribute *qla2x00_host_attrs[] = {
 	&class_device_attr_driver_version,
@@ -340,6 +421,8 @@ struct class_device_attribute *qla2x00_h
 	&class_device_attr_model_desc,
 	&class_device_attr_pci_info,
 	&class_device_attr_state,
+	&class_device_attr_zio,
+	&class_device_attr_zio_timer,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e0025da..0821b05 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -824,6 +824,11 @@ typedef struct {
 #define PD_STATE_WAIT_PORT_LOGOUT_ACK		11
 
 
+#define QLA_ZIO_MODE_5		(BIT_2 | BIT_0)
+#define QLA_ZIO_MODE_6		(BIT_2 | BIT_1)
+#define QLA_ZIO_DISABLED	0
+#define QLA_ZIO_DEFAULT_TIMER	2
+
 /*
  * ISP Initialization Control Block.
  * Little endian except where noted.
@@ -2473,6 +2478,9 @@ typedef struct scsi_qla_host {
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
 	uint16_t	beacon_green_on;
+
+	uint16_t	zio_mode;
+	uint16_t	zio_timer;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1ed32e7..7680b95 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -76,8 +76,6 @@ extern char qla2x00_version_str[];
 extern int ql2xlogintimeout;
 extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
-extern int ql2xenablezio;
-extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
 
@@ -223,6 +221,7 @@ extern irqreturn_t qla2100_intr_handler(
 extern irqreturn_t qla2300_intr_handler(int, void *, struct pt_regs *);
 extern irqreturn_t qla24xx_intr_handler(int, void *, struct pt_regs *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
+extern void qla24xx_process_response_queue(struct scsi_qla_host *);
 
 /*
  * Global Function Prototypes in qla_sup.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8fd40fb..5c35408 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1372,7 +1372,6 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	nvram_t         *nv = (nvram_t *)ha->request_ring;
 	uint8_t         *ptr = (uint8_t *)ha->request_ring;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint8_t         timer_mode;
 
 	rval = QLA_SUCCESS;
 
@@ -1650,22 +1649,26 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 
 		ha->flags.process_response_queue = 1;
 	} else {
-		/* Enable ZIO -- Support mode 5 only. */
-		timer_mode = icb->add_firmware_options[0] &
-		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		/* Enable ZIO. */
+		if (!ha->flags.init_done) {
+			ha->zio_mode = icb->add_firmware_options[0] &
+			    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
+			ha->zio_timer = icb->interrupt_delay_timer ?
+			    icb->interrupt_delay_timer: 2;
+		}
 		icb->add_firmware_options[0] &=
 		    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
-		if (ql2xenablezio)
-			timer_mode = BIT_2 | BIT_0;
-		if (timer_mode == (BIT_2 | BIT_0)) {
-			DEBUG2(printk("scsi(%ld): ZIO enabled; timer delay "
-			    "(%d).\n", ha->host_no, ql2xintrdelaytimer));
+		ha->flags.process_response_queue = 0;
+		if (ha->zio_mode != QLA_ZIO_DISABLED) {
+			DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer "
+			    "delay (%d us).\n", ha->host_no, ha->zio_mode,
+			    ha->zio_timer * 100));
 			qla_printk(KERN_INFO, ha,
-			    "ZIO enabled; timer delay (%d).\n",
-			    ql2xintrdelaytimer);
+			    "ZIO mode %d enabled; timer delay (%d us).\n",
+			    ha->zio_mode, ha->zio_timer * 100);
 
-			icb->add_firmware_options[0] |= timer_mode;
-			icb->interrupt_delay_timer = ql2xintrdelaytimer;
+			icb->add_firmware_options[0] |= (uint8_t)ha->zio_mode;
+			icb->interrupt_delay_timer = (uint8_t)ha->zio_timer;
 			ha->flags.process_response_queue = 1;
 		}
 	}
@@ -3462,6 +3465,30 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	if (ql2xloginretrycount)
 		ha->login_retry_count = ql2xloginretrycount;
 
+	/* Enable ZIO. */
+	if (!ha->flags.init_done) {
+		ha->zio_mode = le32_to_cpu(icb->firmware_options_2) &
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
+		    le16_to_cpu(icb->interrupt_delay_timer): 2;
+	}
+	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
+	ha->flags.process_response_queue = 0;
+	if (ha->zio_mode != QLA_ZIO_DISABLED) {
+		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
+		    "(%d us).\n", ha->host_no, ha->zio_mode,
+		    ha->zio_timer * 100));
+		qla_printk(KERN_INFO, ha,
+		    "ZIO mode %d enabled; timer delay (%d us).\n",
+		    ha->zio_mode, ha->zio_timer * 100);
+
+		icb->firmware_options_2 |= cpu_to_le32(
+		    (uint32_t)ha->zio_mode);
+		icb->interrupt_delay_timer = cpu_to_le16(ha->zio_timer);
+		ha->flags.process_response_queue = 1;
+	}
+
 	if (rval) {
 		DEBUG2_3(printk(KERN_WARNING
 		    "scsi(%ld): NVRAM configuration failed!\n", ha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 37f82e2..d735562 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -440,6 +440,11 @@ qla2x00_start_scsi(srb_t *sp)
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
 	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (ha->flags.process_response_queue &&
+	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
+		qla2x00_process_response_queue(ha);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
 
@@ -877,6 +882,11 @@ qla24xx_start_scsi(srb_t *sp)
 	WRT_REG_DWORD(&reg->req_q_in, ha->req_ring_index);
 	RD_REG_DWORD_RELAXED(&reg->req_q_in);		/* PCI Posting. */
 
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (ha->flags.process_response_queue &&
+	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(ha);
+
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c255bb0..cf6c6ce 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -21,13 +21,11 @@
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
-void qla2x00_process_response_queue(struct scsi_qla_host *);
 static void qla2x00_status_entry(scsi_qla_host_t *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
 static void qla2x00_ms_entry(scsi_qla_host_t *, ms_iocb_entry_t *);
 
-void qla24xx_process_response_queue(scsi_qla_host_t *);
 static void qla24xx_ms_entry(scsi_qla_host_t *, struct ct_entry_24xx *);
 
 /**
@@ -651,7 +649,10 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		    "scsi(%ld): [R|Z]IO update completion.\n",
 		    ha->host_no));
 
-		qla2x00_process_response_queue(ha);
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			qla24xx_process_response_queue(ha);
+		else
+			qla2x00_process_response_queue(ha);
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 111fe95..8226fa2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -61,19 +61,6 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"a Fabric scan.  This is needed for several broken switches."
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
 
-int ql2xenablezio = 0;
-module_param(ql2xenablezio, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(ql2xenablezio,
-		"Option to enable ZIO:If 1 then enable it otherwise"
-		" use the default set in the NVRAM."
-		" Default is 0 : disabled");
-
-int ql2xintrdelaytimer = 10;
-module_param(ql2xintrdelaytimer, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(ql2xintrdelaytimer,
-		"ZIO: Waiting time for Firmware before it generates an "
-		"interrupt to the host to notify completion of request.");
-
 int ql2xloginretrycount = 0;
 module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xloginretrycount,
@@ -402,16 +389,6 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (ha->flags.online && ha->flags.process_response_queue &&
-	    ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		qla2x00_process_response_queue(ha);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
-
 	spin_lock_irq(ha->host->host_lock);
 
 	return 0;

-- 
Andrew Vasquez
