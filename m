From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/11]: REPOST: megaraid_sas: Add struct megasas_instance_template
 changes
Date: Tue, 21 Dec 2010 10:23:23 -0800
Message-ID: <AANLkTinmWyFMOkUF0TLVfahTcuzvfxRJMCbcPs==tzBT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b85205d95390497efbb7e
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0LUSXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 13:23:24 -0500
Received: by vws16 with SMTP id 16so1830050vws.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 10:23:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016363b85205d95390497efbb7e
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

REPOSTED to fix sequential compile issue.

The following patch adds struct megasas_instance_template changes to
the megaraid_sas driver, and changes all code to use the new instance
entries:

   irqreturn_t (*service_isr )(int irq, void *devp);
   void (*tasklet)(unsigned long);
   u32 (*init_adapter)(struct megasas_instance *);
   u32 (*build_and_issue_cmd) (struct megasas_instance *, struct scsi_cmnd *);
   void (*issue_dcmd) (struct megasas_instance *instance,
                              struct megasas_cmd *cmd);

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
09:57:54.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
10:01:42.000000000 -0800
@@ -131,6 +131,20 @@
 static void
 megasas_complete_cmd(struct megasas_instance *instance, struct
megasas_cmd *cmd,
 		     u8 alt_status);
+static irqreturn_t megasas_isr(int irq, void *devp);
+static u32
+megasas_init_adapter_mfi(struct megasas_instance *instance);
+u32
+megasas_build_and_issue_cmd(struct megasas_instance *instance,
+			    struct scsi_cmnd *scmd);
+static void megasas_complete_cmd_dpc(unsigned long instance_addr);
+
+void
+megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	instance->instancet->fire_cmd(instance,
+		cmd->frame_phys_addr, 0, instance->reg_set);
+}

 /**
  * megasas_get_cmd -	Get a command from the free pool
@@ -334,6 +348,11 @@
 	.read_fw_status_reg = megasas_read_fw_status_reg_xscale,
 	.adp_reset = megasas_adp_reset_xscale,
 	.check_reset = megasas_check_reset_xscale,
+	.service_isr = megasas_isr,
+	.tasklet = megasas_complete_cmd_dpc,
+	.init_adapter = megasas_init_adapter_mfi,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd,
+	.issue_dcmd = megasas_issue_dcmd,
 };

 /**
@@ -460,6 +479,11 @@
 	.read_fw_status_reg = megasas_read_fw_status_reg_ppc,
 	.adp_reset = megasas_adp_reset_ppc,
 	.check_reset = megasas_check_reset_ppc,
+	.service_isr = megasas_isr,
+	.tasklet = megasas_complete_cmd_dpc,
+	.init_adapter = megasas_init_adapter_mfi,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd,
+	.issue_dcmd = megasas_issue_dcmd,
 };

 /**
@@ -581,6 +605,11 @@
 	.read_fw_status_reg = megasas_read_fw_status_reg_skinny,
 	.adp_reset = megasas_adp_reset_skinny,
 	.check_reset = megasas_check_reset_skinny,
+	.service_isr = megasas_isr,
+	.tasklet = megasas_complete_cmd_dpc,
+	.init_adapter = megasas_init_adapter_mfi,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd,
+	.issue_dcmd = megasas_issue_dcmd,
 };


@@ -755,6 +784,11 @@
 	.read_fw_status_reg = megasas_read_fw_status_reg_gen2,
 	.adp_reset = megasas_adp_reset_gen2,
 	.check_reset = megasas_check_reset_gen2,
+	.service_isr = megasas_isr,
+	.tasklet = megasas_complete_cmd_dpc,
+	.init_adapter = megasas_init_adapter_mfi,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd,
+	.issue_dcmd = megasas_issue_dcmd,
 };

 /**
@@ -1339,6 +1373,51 @@
 	printk(KERN_ERR "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
 }

+u32
+megasas_build_and_issue_cmd(struct megasas_instance *instance,
+			    struct scsi_cmnd *scmd)
+{
+	struct megasas_cmd *cmd;
+	u32 frame_count;
+
+	cmd = megasas_get_cmd(instance);
+	if (!cmd)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	/*
+	 * Logical drive command
+	 */
+	if (megasas_is_ldio(scmd))
+		frame_count = megasas_build_ldio(instance, scmd, cmd);
+	else
+		frame_count = megasas_build_dcdb(instance, scmd, cmd);
+
+	if (!frame_count)
+		goto out_return_cmd;
+
+	cmd->scmd = scmd;
+	scmd->SCp.ptr = (char *)cmd;
+
+	/*
+	 * Issue the command to the FW
+	 */
+	atomic_inc(&instance->fw_outstanding);
+
+	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
+				cmd->frame_count-1, instance->reg_set);
+	/*
+	 * Check if we have pend cmds to be completed
+	 */
+	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
+		tasklet_schedule(&instance->isr_tasklet);
+
+	return 0;
+out_return_cmd:
+	megasas_return_cmd(instance, cmd);
+	return 1;
+}
+
+
 /**
  * megasas_queue_command -	Queue entry point
  * @scmd:			SCSI command to be queued
@@ -1347,8 +1426,6 @@
 static int
 megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done)
(struct scsi_cmnd *))
 {
-	u32 frame_count;
-	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
 	unsigned long flags;

@@ -1387,42 +1464,13 @@
 		break;
 	}

-	cmd = megasas_get_cmd(instance);
-	if (!cmd)
+	if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
+		printk(KERN_ERR "megasas: Err returned from build_and_issue_cmd\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
-
-	/*
-	 * Logical drive command
-	 */
-	if (megasas_is_ldio(scmd))
-		frame_count = megasas_build_ldio(instance, scmd, cmd);
-	else
-		frame_count = megasas_build_dcdb(instance, scmd, cmd);
-
-	if (!frame_count)
-		goto out_return_cmd;
-
-	cmd->scmd = scmd;
-	scmd->SCp.ptr = (char *)cmd;
-
-	/*
-	 * Issue the command to the FW
-	 */
-	atomic_inc(&instance->fw_outstanding);
-
-	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
-				cmd->frame_count-1, instance->reg_set);
-	/*
-	 * Check if we have pend cmds to be completed
-	 */
-	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
-		tasklet_schedule(&instance->isr_tasklet);
-
+	}

 	return 0;

- out_return_cmd:
-	megasas_return_cmd(instance, cmd);
  out_done:
 	done(scmd);
 	return 0;
@@ -3221,69 +3269,15 @@
 			jiffies + MEGASAS_COMPLETION_TIMER_INTERVAL);
 }

-/**
- * megasas_init_mfi -	Initializes the FW
- * @instance:		Adapter soft state
- *
- * This is the main function for initializing MFI firmware.
- */
-static int megasas_init_mfi(struct megasas_instance *instance)
+static u32
+megasas_init_adapter_mfi(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *reg_set;
 	u32 context_sz;
 	u32 reply_q_sz;
-	u32 max_sectors_1;
-	u32 max_sectors_2;
-	u32 tmp_sectors;
-	struct megasas_register_set __iomem *reg_set;
-	struct megasas_ctrl_info *ctrl_info;
-	unsigned long bar_list;
-
-	/* Find first memory bar */
-	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
-	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
-	instance->base_addr = pci_resource_start(instance->pdev, instance->bar);
-	if (pci_request_selected_regions(instance->pdev, instance->bar,
-					 "megasas: LSI")) {
-		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
-		return -EBUSY;
-	}
-
-	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);
-
-	if (!instance->reg_set) {
-		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
-		goto fail_ioremap;
-	}

 	reg_set = instance->reg_set;

-	switch(instance->pdev->device)
-	{
-		case PCI_DEVICE_ID_LSI_SAS1078R:
-		case PCI_DEVICE_ID_LSI_SAS1078DE:
-			instance->instancet = &megasas_instance_template_ppc;
-			break;
-		case PCI_DEVICE_ID_LSI_SAS1078GEN2:
-		case PCI_DEVICE_ID_LSI_SAS0079GEN2:
-			instance->instancet = &megasas_instance_template_gen2;
-			break;
-		case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
-		case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
-			instance->instancet = &megasas_instance_template_skinny;
-			break;
-		case PCI_DEVICE_ID_LSI_SAS1064R:
-		case PCI_DEVICE_ID_DELL_PERC5:
-		default:
-			instance->instancet = &megasas_instance_template_xscale;
-			break;
-	}
-
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance))
-		goto fail_ready_state;
-
 	/*
 	 * Get various operational parameters from status register
 	 */
@@ -3337,6 +3331,87 @@
 	if (instance->fw_support_ieee)
 		instance->flag_ieee = 1;

+	return 0;
+
+fail_fw_init:
+
+	pci_free_consistent(instance->pdev, reply_q_sz,
+			    instance->reply_queue, instance->reply_queue_h);
+fail_reply_queue:
+	megasas_free_cmds(instance);
+
+fail_alloc_cmds:
+	iounmap(instance->reg_set);
+	return 1;
+}
+
+/**
+ * megasas_init_fw -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * This is the main function for initializing firmware
+ */
+
+static int megasas_init_fw(struct megasas_instance *instance)
+{
+	u32 max_sectors_1;
+	u32 max_sectors_2;
+	u32 tmp_sectors;
+	struct megasas_register_set __iomem *reg_set;
+	struct megasas_ctrl_info *ctrl_info;
+	unsigned long bar_list;
+
+	/* Find first memory bar */
+	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
+	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
+	instance->base_addr = pci_resource_start(instance->pdev, instance->bar);
+	if (pci_request_selected_regions(instance->pdev, instance->bar,
+					 "megasas: LSI")) {
+		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
+		return -EBUSY;
+	}
+
+	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);
+
+	if (!instance->reg_set) {
+		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
+		goto fail_ioremap;
+	}
+
+	reg_set = instance->reg_set;
+
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_SAS1078R:
+	case PCI_DEVICE_ID_LSI_SAS1078DE:
+		instance->instancet = &megasas_instance_template_ppc;
+		break;
+	case PCI_DEVICE_ID_LSI_SAS1078GEN2:
+	case PCI_DEVICE_ID_LSI_SAS0079GEN2:
+		instance->instancet = &megasas_instance_template_gen2;
+		break;
+	case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
+	case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
+		instance->instancet = &megasas_instance_template_skinny;
+		break;
+	case PCI_DEVICE_ID_LSI_SAS1064R:
+	case PCI_DEVICE_ID_DELL_PERC5:
+	default:
+		instance->instancet = &megasas_instance_template_xscale;
+		break;
+	}
+
+	/*
+	 * We expect the FW state to be READY
+	 */
+	if (megasas_transition_to_ready(instance))
+		goto fail_ready_state;
+
+	/* Get operational params, sge flags, send init cmd to controller */
+	if (instance->instancet->init_adapter(instance))
+		return -ENODEV;
+
+	printk(KERN_ERR "megasas: INIT adapter done\n");
+
 	/** for passthrough
 	* the following function will get the PD LIST.
 	*/
@@ -3392,15 +3467,7 @@
 				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	return 0;

-      fail_fw_init:
-
-	pci_free_consistent(instance->pdev, reply_q_sz,
-			    instance->reply_queue, instance->reply_queue_h);
-      fail_reply_queue:
-	megasas_free_cmds(instance);
-
-      fail_alloc_cmds:
-      fail_ready_state:
+fail_ready_state:
 	iounmap(instance->reg_set);

       fail_ioremap:
@@ -3855,7 +3922,7 @@
 	/*
 	 * Initialize MFI Firmware
 	 */
-	if (megasas_init_mfi(instance))
+	if (megasas_init_fw(instance))
 		goto fail_init_mfi;

 	/* Try to enable MSI-X */
@@ -3870,7 +3937,7 @@
 	 * Register IRQ
 	 */
 	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
-			pdev->irq, megasas_isr,
+			pdev->irq, instance->instancet->service_isr,
 			IRQF_SHARED, "megasas", instance)) {
 		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
 		goto fail_irq;
@@ -3920,7 +3987,6 @@
 		 instance->pdev->irq, instance);
 	if (instance->msi_flag)
 		pci_disable_msix(instance->pdev);
-	megasas_release_mfi(instance);

       fail_irq:
       fail_init_mfi:
@@ -3930,9 +3996,11 @@
 				    instance->evt_detail,
 				    instance->evt_detail_h);

-	if (instance->producer)
+	if (instance->producer) {
 		pci_free_consistent(pdev, sizeof(u32), instance->producer,
 				    instance->producer_h);
+		megasas_release_mfi(instance);
+	}
 	if (instance->consumer)
 		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
 				    instance->consumer_h);
@@ -4134,7 +4202,7 @@
 	 * Register IRQ
 	 */
 	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
-			pdev->irq, megasas_isr,
+			pdev->irq, instance->instancet->service_isr,
 			IRQF_SHARED, "megasas", instance)) {
 		printk(KERN_ERR "megasas: Failed to register IRQ\n");
 		goto fail_irq;
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
09:57:54.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
10:00:16.000000000 -0800
@@ -1364,6 +1364,13 @@
 		struct megasas_register_set __iomem *);
 	int (*check_reset)(struct megasas_instance *, \
 		struct megasas_register_set __iomem *);
+	irqreturn_t (*service_isr)(int irq, void *devp);
+	void (*tasklet)(unsigned long);
+	u32 (*init_adapter)(struct megasas_instance *);
+	u32 (*build_and_issue_cmd) (struct megasas_instance *,
+				    struct scsi_cmnd *);
+	void (*issue_dcmd) (struct megasas_instance *instance,
+			    struct megasas_cmd *cmd);
 };

 #define MEGASAS_IS_LOGICAL(scp)						\

--0016363b85205d95390497efbb7e
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghz4bcwk0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0yMSAwOTo1Nzo1NC4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTAtMTItMjEgMTA6MDE6NDIuMDAwMDAwMDAwIC0wODAw
CkBAIC0xMzEsNiArMTMxLDIwIEBACiBzdGF0aWMgdm9pZAogbWVnYXNhc19jb21wbGV0ZV9jbWQo
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNt
ZCwKIAkJICAgICB1OCBhbHRfc3RhdHVzKTsKK3N0YXRpYyBpcnFyZXR1cm5fdCBtZWdhc2FzX2lz
cihpbnQgaXJxLCB2b2lkICpkZXZwKTsKK3N0YXRpYyB1MzIKK21lZ2FzYXNfaW5pdF9hZGFwdGVy
X21maShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwordTMyCittZWdhc2FzX2J1
aWxkX2FuZF9pc3N1ZV9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJ
ICAgIHN0cnVjdCBzY3NpX2NtbmQgKnNjbWQpOworc3RhdGljIHZvaWQgbWVnYXNhc19jb21wbGV0
ZV9jbWRfZHBjKHVuc2lnbmVkIGxvbmcgaW5zdGFuY2VfYWRkcik7CisKK3ZvaWQKK21lZ2FzYXNf
aXNzdWVfZGNtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdh
c2FzX2NtZCAqY21kKQoreworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVfY21kKGluc3RhbmNl
LAorCQljbWQtPmZyYW1lX3BoeXNfYWRkciwgMCwgaW5zdGFuY2UtPnJlZ19zZXQpOworfQogCiAv
KioKICAqIG1lZ2FzYXNfZ2V0X2NtZCAtCUdldCBhIGNvbW1hbmQgZnJvbSB0aGUgZnJlZSBwb29s
CkBAIC0zMzQsNiArMzQ4LDExIEBACiAJLnJlYWRfZndfc3RhdHVzX3JlZyA9IG1lZ2FzYXNfcmVh
ZF9md19zdGF0dXNfcmVnX3hzY2FsZSwKIAkuYWRwX3Jlc2V0ID0gbWVnYXNhc19hZHBfcmVzZXRf
eHNjYWxlLAogCS5jaGVja19yZXNldCA9IG1lZ2FzYXNfY2hlY2tfcmVzZXRfeHNjYWxlLAorCS5z
ZXJ2aWNlX2lzciA9IG1lZ2FzYXNfaXNyLAorCS50YXNrbGV0ID0gbWVnYXNhc19jb21wbGV0ZV9j
bWRfZHBjLAorCS5pbml0X2FkYXB0ZXIgPSBtZWdhc2FzX2luaXRfYWRhcHRlcl9tZmksCisJLmJ1
aWxkX2FuZF9pc3N1ZV9jbWQgPSBtZWdhc2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWQsCisJLmlzc3Vl
X2RjbWQgPSBtZWdhc2FzX2lzc3VlX2RjbWQsCiB9OwogCiAvKioKQEAgLTQ2MCw2ICs0NzksMTEg
QEAKIAkucmVhZF9md19zdGF0dXNfcmVnID0gbWVnYXNhc19yZWFkX2Z3X3N0YXR1c19yZWdfcHBj
LAogCS5hZHBfcmVzZXQgPSBtZWdhc2FzX2FkcF9yZXNldF9wcGMsCiAJLmNoZWNrX3Jlc2V0ID0g
bWVnYXNhc19jaGVja19yZXNldF9wcGMsCisJLnNlcnZpY2VfaXNyID0gbWVnYXNhc19pc3IsCisJ
LnRhc2tsZXQgPSBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGMsCisJLmluaXRfYWRhcHRlciA9IG1l
Z2FzYXNfaW5pdF9hZGFwdGVyX21maSwKKwkuYnVpbGRfYW5kX2lzc3VlX2NtZCA9IG1lZ2FzYXNf
YnVpbGRfYW5kX2lzc3VlX2NtZCwKKwkuaXNzdWVfZGNtZCA9IG1lZ2FzYXNfaXNzdWVfZGNtZCwK
IH07CiAKIC8qKgpAQCAtNTgxLDYgKzYwNSwxMSBAQAogCS5yZWFkX2Z3X3N0YXR1c19yZWcgPSBt
ZWdhc2FzX3JlYWRfZndfc3RhdHVzX3JlZ19za2lubnksCiAJLmFkcF9yZXNldCA9IG1lZ2FzYXNf
YWRwX3Jlc2V0X3NraW5ueSwKIAkuY2hlY2tfcmVzZXQgPSBtZWdhc2FzX2NoZWNrX3Jlc2V0X3Nr
aW5ueSwKKwkuc2VydmljZV9pc3IgPSBtZWdhc2FzX2lzciwKKwkudGFza2xldCA9IG1lZ2FzYXNf
Y29tcGxldGVfY21kX2RwYywKKwkuaW5pdF9hZGFwdGVyID0gbWVnYXNhc19pbml0X2FkYXB0ZXJf
bWZpLAorCS5idWlsZF9hbmRfaXNzdWVfY21kID0gbWVnYXNhc19idWlsZF9hbmRfaXNzdWVfY21k
LAorCS5pc3N1ZV9kY21kID0gbWVnYXNhc19pc3N1ZV9kY21kLAogfTsKIAogCkBAIC03NTUsNiAr
Nzg0LDExIEBACiAJLnJlYWRfZndfc3RhdHVzX3JlZyA9IG1lZ2FzYXNfcmVhZF9md19zdGF0dXNf
cmVnX2dlbjIsCiAJLmFkcF9yZXNldCA9IG1lZ2FzYXNfYWRwX3Jlc2V0X2dlbjIsCiAJLmNoZWNr
X3Jlc2V0ID0gbWVnYXNhc19jaGVja19yZXNldF9nZW4yLAorCS5zZXJ2aWNlX2lzciA9IG1lZ2Fz
YXNfaXNyLAorCS50YXNrbGV0ID0gbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjLAorCS5pbml0X2Fk
YXB0ZXIgPSBtZWdhc2FzX2luaXRfYWRhcHRlcl9tZmksCisJLmJ1aWxkX2FuZF9pc3N1ZV9jbWQg
PSBtZWdhc2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWQsCisJLmlzc3VlX2RjbWQgPSBtZWdhc2FzX2lz
c3VlX2RjbWQsCiB9OwogCiAvKioKQEAgLTEzMzksNiArMTM3Myw1MSBAQAogCXByaW50ayhLRVJO
X0VSUiAibWVnYXNhc1slZF06IER1bXBpbmcgRG9uZS5cblxuIixpbnN0YW5jZS0+aG9zdC0+aG9z
dF9ubyk7CiB9CiAKK3UzMgorbWVnYXNhc19idWlsZF9hbmRfaXNzdWVfY21kKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSAgICBzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQor
eworCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOworCXUzMiBmcmFtZV9jb3VudDsKKworCWNtZCA9
IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CisJaWYgKCFjbWQpCisJCXJldHVybiBTQ1NJX01M
UVVFVUVfSE9TVF9CVVNZOworCisJLyoKKwkgKiBMb2dpY2FsIGRyaXZlIGNvbW1hbmQKKwkgKi8K
KwlpZiAobWVnYXNhc19pc19sZGlvKHNjbWQpKQorCQlmcmFtZV9jb3VudCA9IG1lZ2FzYXNfYnVp
bGRfbGRpbyhpbnN0YW5jZSwgc2NtZCwgY21kKTsKKwllbHNlCisJCWZyYW1lX2NvdW50ID0gbWVn
YXNhc19idWlsZF9kY2RiKGluc3RhbmNlLCBzY21kLCBjbWQpOworCisJaWYgKCFmcmFtZV9jb3Vu
dCkKKwkJZ290byBvdXRfcmV0dXJuX2NtZDsKKworCWNtZC0+c2NtZCA9IHNjbWQ7CisJc2NtZC0+
U0NwLnB0ciA9IChjaGFyICopY21kOworCisJLyoKKwkgKiBJc3N1ZSB0aGUgY29tbWFuZCB0byB0
aGUgRlcKKwkgKi8KKwlhdG9taWNfaW5jKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOworCisJ
aW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsIGNtZC0+ZnJhbWVfcGh5c19h
ZGRyLAorCQkJCWNtZC0+ZnJhbWVfY291bnQtMSwgaW5zdGFuY2UtPnJlZ19zZXQpOworCS8qCisJ
ICogQ2hlY2sgaWYgd2UgaGF2ZSBwZW5kIGNtZHMgdG8gYmUgY29tcGxldGVkCisJICovCisJaWYg
KHBvbGxfbW9kZV9pbyAmJiBhdG9taWNfcmVhZCgmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5nKSkK
KwkJdGFza2xldF9zY2hlZHVsZSgmaW5zdGFuY2UtPmlzcl90YXNrbGV0KTsKKworCXJldHVybiAw
Oworb3V0X3JldHVybl9jbWQ6CisJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwor
CXJldHVybiAxOworfQorCisKIC8qKgogICogbWVnYXNhc19xdWV1ZV9jb21tYW5kIC0JUXVldWUg
ZW50cnkgcG9pbnQKICAqIEBzY21kOgkJCVNDU0kgY29tbWFuZCB0byBiZSBxdWV1ZWQKQEAgLTEz
NDcsOCArMTQyNiw2IEBACiBzdGF0aWMgaW50CiBtZWdhc2FzX3F1ZXVlX2NvbW1hbmRfbGNrKHN0
cnVjdCBzY3NpX2NtbmQgKnNjbWQsIHZvaWQgKCpkb25lKSAoc3RydWN0IHNjc2lfY21uZCAqKSkK
IHsKLQl1MzIgZnJhbWVfY291bnQ7Ci0Jc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CiAJc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKQEAg
LTEzODcsNDIgKzE0NjQsMTMgQEAKIAkJYnJlYWs7CiAJfQogCi0JY21kID0gbWVnYXNhc19nZXRf
Y21kKGluc3RhbmNlKTsKLQlpZiAoIWNtZCkKKwlpZiAoaW5zdGFuY2UtPmluc3RhbmNldC0+YnVp
bGRfYW5kX2lzc3VlX2NtZChpbnN0YW5jZSwgc2NtZCkpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJt
ZWdhc2FzOiBFcnIgcmV0dXJuZWQgZnJvbSBidWlsZF9hbmRfaXNzdWVfY21kXG4iKTsKIAkJcmV0
dXJuIFNDU0lfTUxRVUVVRV9IT1NUX0JVU1k7Ci0KLQkvKgotCSAqIExvZ2ljYWwgZHJpdmUgY29t
bWFuZAotCSAqLwotCWlmIChtZWdhc2FzX2lzX2xkaW8oc2NtZCkpCi0JCWZyYW1lX2NvdW50ID0g
bWVnYXNhc19idWlsZF9sZGlvKGluc3RhbmNlLCBzY21kLCBjbWQpOwotCWVsc2UKLQkJZnJhbWVf
Y291bnQgPSBtZWdhc2FzX2J1aWxkX2RjZGIoaW5zdGFuY2UsIHNjbWQsIGNtZCk7Ci0KLQlpZiAo
IWZyYW1lX2NvdW50KQotCQlnb3RvIG91dF9yZXR1cm5fY21kOwotCi0JY21kLT5zY21kID0gc2Nt
ZDsKLQlzY21kLT5TQ3AucHRyID0gKGNoYXIgKiljbWQ7Ci0KLQkvKgotCSAqIElzc3VlIHRoZSBj
b21tYW5kIHRvIHRoZSBGVwotCSAqLwotCWF0b21pY19pbmMoJmluc3RhbmNlLT5md19vdXRzdGFu
ZGluZyk7Ci0KLQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5jZSwgY21kLT5m
cmFtZV9waHlzX2FkZHIsCi0JCQkJY21kLT5mcmFtZV9jb3VudC0xLCBpbnN0YW5jZS0+cmVnX3Nl
dCk7Ci0JLyoKLQkgKiBDaGVjayBpZiB3ZSBoYXZlIHBlbmQgY21kcyB0byBiZSBjb21wbGV0ZWQK
LQkgKi8KLQlpZiAocG9sbF9tb2RlX2lvICYmIGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0
c3RhbmRpbmcpKQotCQl0YXNrbGV0X3NjaGVkdWxlKCZpbnN0YW5jZS0+aXNyX3Rhc2tsZXQpOwot
CisJfQogCiAJcmV0dXJuIDA7CiAKLSBvdXRfcmV0dXJuX2NtZDoKLQltZWdhc2FzX3JldHVybl9j
bWQoaW5zdGFuY2UsIGNtZCk7CiAgb3V0X2RvbmU6CiAJZG9uZShzY21kKTsKIAlyZXR1cm4gMDsK
QEAgLTMyMjEsNjkgKzMyNjksMTUgQEAKIAkJCWppZmZpZXMgKyBNRUdBU0FTX0NPTVBMRVRJT05f
VElNRVJfSU5URVJWQUwpOwogfQogCi0vKioKLSAqIG1lZ2FzYXNfaW5pdF9tZmkgLQlJbml0aWFs
aXplcyB0aGUgRlcKLSAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQotICoKLSAqIFRo
aXMgaXMgdGhlIG1haW4gZnVuY3Rpb24gZm9yIGluaXRpYWxpemluZyBNRkkgZmlybXdhcmUuCi0g
Ki8KLXN0YXRpYyBpbnQgbWVnYXNhc19pbml0X21maShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2UpCitzdGF0aWMgdTMyCittZWdhc2FzX2luaXRfYWRhcHRlcl9tZmkoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQogeworCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3Nl
dCBfX2lvbWVtICpyZWdfc2V0OwogCXUzMiBjb250ZXh0X3N6OwogCXUzMiByZXBseV9xX3N6Owot
CXUzMiBtYXhfc2VjdG9yc18xOwotCXUzMiBtYXhfc2VjdG9yc18yOwotCXUzMiB0bXBfc2VjdG9y
czsKLQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVnX3NldDsKLQlzdHJ1
Y3QgbWVnYXNhc19jdHJsX2luZm8gKmN0cmxfaW5mbzsKLQl1bnNpZ25lZCBsb25nIGJhcl9saXN0
OwotCi0JLyogRmluZCBmaXJzdCBtZW1vcnkgYmFyICovCi0JYmFyX2xpc3QgPSBwY2lfc2VsZWN0
X2JhcnMoaW5zdGFuY2UtPnBkZXYsIElPUkVTT1VSQ0VfTUVNKTsKLQlpbnN0YW5jZS0+YmFyID0g
ZmluZF9maXJzdF9iaXQoJmJhcl9saXN0LCBzaXplb2YodW5zaWduZWQgbG9uZykpOwotCWluc3Rh
bmNlLT5iYXNlX2FkZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQoaW5zdGFuY2UtPnBkZXYsIGluc3Rh
bmNlLT5iYXIpOwotCWlmIChwY2lfcmVxdWVzdF9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5w
ZGV2LCBpbnN0YW5jZS0+YmFyLAotCQkJCQkgIm1lZ2FzYXM6IExTSSIpKSB7Ci0JCXByaW50ayhL
RVJOX0RFQlVHICJtZWdhc2FzOiBJTyBtZW1vcnkgcmVnaW9uIGJ1c3khXG4iKTsKLQkJcmV0dXJu
IC1FQlVTWTsKLQl9Ci0KLQlpbnN0YW5jZS0+cmVnX3NldCA9IGlvcmVtYXBfbm9jYWNoZShpbnN0
YW5jZS0+YmFzZV9hZGRyLCA4MTkyKTsKLQotCWlmICghaW5zdGFuY2UtPnJlZ19zZXQpIHsKLQkJ
cHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBtYXAgSU8gbWVtXG4iKTsKLQkJ
Z290byBmYWlsX2lvcmVtYXA7Ci0JfQogCiAJcmVnX3NldCA9IGluc3RhbmNlLT5yZWdfc2V0Owog
Ci0Jc3dpdGNoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpCi0JewotCQljYXNlIFBDSV9ERVZJQ0Vf
SURfTFNJX1NBUzEwNzhSOgotCQljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhERToKLQkJ
CWluc3RhbmNlLT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9wcGM7Ci0J
CQlicmVhazsKLQkJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMxMDc4R0VOMjoKLQkJY2FzZSBQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMwMDc5R0VOMjoKLQkJCWluc3RhbmNlLT5pbnN0YW5jZXQgPSAm
bWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9nZW4yOwotCQkJYnJlYWs7Ci0JCWNhc2UgUENJX0RF
VklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWToKLQkJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMw
MDcxU0tJTk5ZOgotCQkJaW5zdGFuY2UtPmluc3RhbmNldCA9ICZtZWdhc2FzX2luc3RhbmNlX3Rl
bXBsYXRlX3NraW5ueTsKLQkJCWJyZWFrOwotCQljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEw
NjRSOgotCQljYXNlIFBDSV9ERVZJQ0VfSURfREVMTF9QRVJDNToKLQkJZGVmYXVsdDoKLQkJCWlu
c3RhbmNlLT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV94c2NhbGU7Ci0J
CQlicmVhazsKLQl9Ci0KLQkvKgotCSAqIFdlIGV4cGVjdCB0aGUgRlcgc3RhdGUgdG8gYmUgUkVB
RFkKLQkgKi8KLQlpZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KGluc3RhbmNlKSkKLQkJ
Z290byBmYWlsX3JlYWR5X3N0YXRlOwotCiAJLyoKIAkgKiBHZXQgdmFyaW91cyBvcGVyYXRpb25h
bCBwYXJhbWV0ZXJzIGZyb20gc3RhdHVzIHJlZ2lzdGVyCiAJICovCkBAIC0zMzM3LDYgKzMzMzEs
ODcgQEAKIAlpZiAoaW5zdGFuY2UtPmZ3X3N1cHBvcnRfaWVlZSkKIAkJaW5zdGFuY2UtPmZsYWdf
aWVlZSA9IDE7CiAKKwlyZXR1cm4gMDsKKworZmFpbF9md19pbml0OgorCisJcGNpX2ZyZWVfY29u
c2lzdGVudChpbnN0YW5jZS0+cGRldiwgcmVwbHlfcV9zeiwKKwkJCSAgICBpbnN0YW5jZS0+cmVw
bHlfcXVldWUsIGluc3RhbmNlLT5yZXBseV9xdWV1ZV9oKTsKK2ZhaWxfcmVwbHlfcXVldWU6CisJ
bWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOworCitmYWlsX2FsbG9jX2NtZHM6CisJaW91bm1h
cChpbnN0YW5jZS0+cmVnX3NldCk7CisJcmV0dXJuIDE7Cit9CisKKy8qKgorICogbWVnYXNhc19p
bml0X2Z3IC0JSW5pdGlhbGl6ZXMgdGhlIEZXCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQg
c3RhdGUKKyAqCisgKiBUaGlzIGlzIHRoZSBtYWluIGZ1bmN0aW9uIGZvciBpbml0aWFsaXppbmcg
ZmlybXdhcmUKKyAqLworCitzdGF0aWMgaW50IG1lZ2FzYXNfaW5pdF9mdyhzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJdTMyIG1heF9zZWN0b3JzXzE7CisJdTMyIG1heF9z
ZWN0b3JzXzI7CisJdTMyIHRtcF9zZWN0b3JzOworCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3Nl
dCBfX2lvbWVtICpyZWdfc2V0OworCXN0cnVjdCBtZWdhc2FzX2N0cmxfaW5mbyAqY3RybF9pbmZv
OworCXVuc2lnbmVkIGxvbmcgYmFyX2xpc3Q7CisKKwkvKiBGaW5kIGZpcnN0IG1lbW9yeSBiYXIg
Ki8KKwliYXJfbGlzdCA9IHBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRldiwgSU9SRVNPVVJD
RV9NRU0pOworCWluc3RhbmNlLT5iYXIgPSBmaW5kX2ZpcnN0X2JpdCgmYmFyX2xpc3QsIHNpemVv
Zih1bnNpZ25lZCBsb25nKSk7CisJaW5zdGFuY2UtPmJhc2VfYWRkciA9IHBjaV9yZXNvdXJjZV9z
dGFydChpbnN0YW5jZS0+cGRldiwgaW5zdGFuY2UtPmJhcik7CisJaWYgKHBjaV9yZXF1ZXN0X3Nl
bGVjdGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNlLT5iYXIsCisJCQkJCSAibWVn
YXNhczogTFNJIikpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IElPIG1lbW9yeSBy
ZWdpb24gYnVzeSFcbiIpOworCQlyZXR1cm4gLUVCVVNZOworCX0KKworCWluc3RhbmNlLT5yZWdf
c2V0ID0gaW9yZW1hcF9ub2NhY2hlKGluc3RhbmNlLT5iYXNlX2FkZHIsIDgxOTIpOworCisJaWYg
KCFpbnN0YW5jZS0+cmVnX3NldCkgeworCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFp
bGVkIHRvIG1hcCBJTyBtZW1cbiIpOworCQlnb3RvIGZhaWxfaW9yZW1hcDsKKwl9CisKKwlyZWdf
c2V0ID0gaW5zdGFuY2UtPnJlZ19zZXQ7CisKKwlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZp
Y2UpIHsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhSOgorCWNhc2UgUENJX0RFVklD
RV9JRF9MU0lfU0FTMTA3OERFOgorCQlpbnN0YW5jZS0+aW5zdGFuY2V0ID0gJm1lZ2FzYXNfaW5z
dGFuY2VfdGVtcGxhdGVfcHBjOworCQlicmVhazsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NB
UzEwNzhHRU4yOgorCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3OUdFTjI6CisJCWluc3Rh
bmNlLT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9nZW4yOworCQlicmVh
azsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlk6CisJY2FzZSBQQ0lfREVW
SUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZOgorCQlpbnN0YW5jZS0+aW5zdGFuY2V0ID0gJm1lZ2Fz
YXNfaW5zdGFuY2VfdGVtcGxhdGVfc2tpbm55OworCQlicmVhazsKKwljYXNlIFBDSV9ERVZJQ0Vf
SURfTFNJX1NBUzEwNjRSOgorCWNhc2UgUENJX0RFVklDRV9JRF9ERUxMX1BFUkM1OgorCWRlZmF1
bHQ6CisJCWluc3RhbmNlLT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV94
c2NhbGU7CisJCWJyZWFrOworCX0KKworCS8qCisJICogV2UgZXhwZWN0IHRoZSBGVyBzdGF0ZSB0
byBiZSBSRUFEWQorCSAqLworCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFu
Y2UpKQorCQlnb3RvIGZhaWxfcmVhZHlfc3RhdGU7CisKKwkvKiBHZXQgb3BlcmF0aW9uYWwgcGFy
YW1zLCBzZ2UgZmxhZ3MsIHNlbmQgaW5pdCBjbWQgdG8gY29udHJvbGxlciAqLworCWlmIChpbnN0
YW5jZS0+aW5zdGFuY2V0LT5pbml0X2FkYXB0ZXIoaW5zdGFuY2UpKQorCQlyZXR1cm4gLUVOT0RF
VjsKKworCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogSU5JVCBhZGFwdGVyIGRvbmVcbiIpOwor
CiAJLyoqIGZvciBwYXNzdGhyb3VnaAogCSogdGhlIGZvbGxvd2luZyBmdW5jdGlvbiB3aWxsIGdl
dCB0aGUgUEQgTElTVC4KIAkqLwpAQCAtMzM5MiwxNSArMzQ2Nyw3IEBACiAJCQkJTUVHQVNBU19D
T01QTEVUSU9OX1RJTUVSX0lOVEVSVkFMKTsKIAlyZXR1cm4gMDsKIAotICAgICAgZmFpbF9md19p
bml0OgotCi0JcGNpX2ZyZWVfY29uc2lzdGVudChpbnN0YW5jZS0+cGRldiwgcmVwbHlfcV9zeiwK
LQkJCSAgICBpbnN0YW5jZS0+cmVwbHlfcXVldWUsIGluc3RhbmNlLT5yZXBseV9xdWV1ZV9oKTsK
LSAgICAgIGZhaWxfcmVwbHlfcXVldWU6Ci0JbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOwot
Ci0gICAgICBmYWlsX2FsbG9jX2NtZHM6Ci0gICAgICBmYWlsX3JlYWR5X3N0YXRlOgorZmFpbF9y
ZWFkeV9zdGF0ZToKIAlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKIAogICAgICAgZmFpbF9p
b3JlbWFwOgpAQCAtMzg1NSw3ICszOTIyLDcgQEAKIAkvKgogCSAqIEluaXRpYWxpemUgTUZJIEZp
cm13YXJlCiAJICovCi0JaWYgKG1lZ2FzYXNfaW5pdF9tZmkoaW5zdGFuY2UpKQorCWlmIChtZWdh
c2FzX2luaXRfZncoaW5zdGFuY2UpKQogCQlnb3RvIGZhaWxfaW5pdF9tZmk7CiAKIAkvKiBUcnkg
dG8gZW5hYmxlIE1TSS1YICovCkBAIC0zODcwLDcgKzM5MzcsNyBAQAogCSAqIFJlZ2lzdGVyIElS
UQogCSAqLwogCWlmIChyZXF1ZXN0X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+
bXNpeGVudHJ5LnZlY3RvciA6Ci0JCQlwZGV2LT5pcnEsIG1lZ2FzYXNfaXNyLAorCQkJcGRldi0+
aXJxLCBpbnN0YW5jZS0+aW5zdGFuY2V0LT5zZXJ2aWNlX2lzciwKIAkJCUlSUUZfU0hBUkVELCAi
bWVnYXNhcyIsIGluc3RhbmNlKSkgewogCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFp
bGVkIHRvIHJlZ2lzdGVyIElSUVxuIik7CiAJCWdvdG8gZmFpbF9pcnE7CkBAIC0zOTIwLDcgKzM5
ODcsNiBAQAogCQkgaW5zdGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOwogCWlmIChpbnN0YW5j
ZS0+bXNpX2ZsYWcpCiAJCXBjaV9kaXNhYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwotCW1lZ2Fz
YXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOwogCiAgICAgICBmYWlsX2lycToKICAgICAgIGZhaWxf
aW5pdF9tZmk6CkBAIC0zOTMwLDkgKzM5OTYsMTEgQEAKIAkJCQkgICAgaW5zdGFuY2UtPmV2dF9k
ZXRhaWwsCiAJCQkJICAgIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOwogCi0JaWYgKGluc3RhbmNl
LT5wcm9kdWNlcikKKwlpZiAoaW5zdGFuY2UtPnByb2R1Y2VyKSB7CiAJCXBjaV9mcmVlX2NvbnNp
c3RlbnQocGRldiwgc2l6ZW9mKHUzMiksIGluc3RhbmNlLT5wcm9kdWNlciwKIAkJCQkgICAgaW5z
dGFuY2UtPnByb2R1Y2VyX2gpOworCQltZWdhc2FzX3JlbGVhc2VfbWZpKGluc3RhbmNlKTsKKwl9
CiAJaWYgKGluc3RhbmNlLT5jb25zdW1lcikKIAkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBz
aXplb2YodTMyKSwgaW5zdGFuY2UtPmNvbnN1bWVyLAogCQkJCSAgICBpbnN0YW5jZS0+Y29uc3Vt
ZXJfaCk7CkBAIC00MTM0LDcgKzQyMDIsNyBAQAogCSAqIFJlZ2lzdGVyIElSUQogCSAqLwogCWlm
IChyZXF1ZXN0X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZl
Y3RvciA6Ci0JCQlwZGV2LT5pcnEsIG1lZ2FzYXNfaXNyLAorCQkJcGRldi0+aXJxLCBpbnN0YW5j
ZS0+aW5zdGFuY2V0LT5zZXJ2aWNlX2lzciwKIAkJCUlSUUZfU0hBUkVELCAibWVnYXNhcyIsIGlu
c3RhbmNlKSkgewogCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IEZhaWxlZCB0byByZWdpc3Rl
ciBJUlFcbiIpOwogCQlnb3RvIGZhaWxfaXJxOwpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUu
b2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBsaW51eC0yLjYuMzctcmM1
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIGxpbnV4LTIuNi4z
Ny1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDEwLTEyLTIx
IDA5OjU3OjU0LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTAtMTItMjEgMTA6MDA6MTYuMDAwMDAw
MDAwIC0wODAwCkBAIC0xMzY0LDYgKzEzNjQsMTMgQEAKIAkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0
ZXJfc2V0IF9faW9tZW0gKik7CiAJaW50ICgqY2hlY2tfcmVzZXQpKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICosIFwKIAkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKik7CisJ
aXJxcmV0dXJuX3QgKCpzZXJ2aWNlX2lzcikoaW50IGlycSwgdm9pZCAqZGV2cCk7CisJdm9pZCAo
KnRhc2tsZXQpKHVuc2lnbmVkIGxvbmcpOworCXUzMiAoKmluaXRfYWRhcHRlcikoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKik7CisJdTMyICgqYnVpbGRfYW5kX2lzc3VlX2NtZCkgKHN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICosCisJCQkJICAgIHN0cnVjdCBzY3NpX2NtbmQgKik7CisJdm9pZCAo
Kmlzc3VlX2RjbWQpIChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQkgICAg
c3RydWN0IG1lZ2FzYXNfY21kICpjbWQpOwogfTsKIAogI2RlZmluZSBNRUdBU0FTX0lTX0xPR0lD
QUwoc2NwKQkJCQkJCVwK
--0016363b85205d95390497efbb7e--
