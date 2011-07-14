From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/5] qla2xxx: Code changes to support new dynamic logging infrastructure (contd..)
Date: Thu, 14 Jul 2011 12:00:15 -0700
Message-ID: <1310670016-30216-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42435 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753252Ab1GNTJL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 15:09:11 -0400
In-Reply-To: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  849 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_os.c   |  730 +++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_sup.c  |  275 +++++++------
 3 files changed, 1042 insertions(+), 812 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3d03845..def6942 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -153,11 +153,10 @@ qla2x00_async_iocb_timeout(srb_t *sp)
 	fc_port_t *fcport = sp->fcport;
 	struct srb_ctx *ctx = sp->ctx;
 
-	DEBUG2(printk(KERN_WARNING
-		"scsi(%ld:%x): Async-%s timeout - portid=%02x%02x%02x.\n",
-		fcport->vha->host_no, sp->handle,
-		ctx->name, fcport->d_id.b.domain,
-		fcport->d_id.b.area, fcport->d_id.b.al_pa));
+	ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
+	    "Async-%s timeout - portid=%02x%02x%02x.\n",
+	    ctx->name, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa);
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	if (ctx->type == SRB_LOGIN_CMD) {
@@ -211,11 +210,10 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 
-	DEBUG2(printk(KERN_DEBUG
-	    "scsi(%ld:%x): Async-login - loop-id=%x portid=%02x%02x%02x "
-	    "retries=%d.\n", fcport->vha->host_no, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
-	    fcport->login_retry));
+	ql_dbg(ql_dbg_disc, vha, 0x2072,
+	    "Async-login - loopid=%x portid=%02x%02x%02x retries=%d.\n",
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa, fcport->login_retry);
 	return rval;
 
 done_free_sp:
@@ -259,10 +257,10 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 
-	DEBUG2(printk(KERN_DEBUG
-	    "scsi(%ld:%x): Async-logout - loop-id=%x portid=%02x%02x%02x.\n",
-	    fcport->vha->host_no, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
+	ql_dbg(ql_dbg_disc, vha, 0x2070,
+	    "Async-logout - loop-id=%x portid=%02x%02x%02x.\n",
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa);
 	return rval;
 
 done_free_sp:
@@ -309,11 +307,10 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 
-	DEBUG2(printk(KERN_DEBUG
-	    "scsi(%ld:%x): Async-adisc - loop-id=%x portid=%02x%02x%02x.\n",
-	    fcport->vha->host_no, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
-
+	ql_dbg(ql_dbg_disc, vha, 0x206f,
+	    "Async-adisc - loopid=%x portid=%02x%02x%02x.\n",
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa);
 	return rval;
 
 done_free_sp:
@@ -362,11 +359,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	if (rval != QLA_SUCCESS)
 		goto done_free_sp;
 
-	DEBUG2(printk(KERN_DEBUG
-	    "scsi(%ld:%x): Async-tmf - loop-id=%x portid=%02x%02x%02x.\n",
-	    fcport->vha->host_no, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa));
-
+	ql_dbg(ql_dbg_taskm, vha, 0x802f,
+	    "Async-tmf loop-id=%x portid=%02x%02x%02x.\n",
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa);
 	return rval;
 
 done_free_sp:
@@ -471,9 +467,8 @@ qla2x00_async_tm_cmd_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 		flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
 
 	if ((rval != QLA_SUCCESS) || iocb->u.tmf.data) {
-		DEBUG2_3_11(printk(KERN_WARNING
-			"%s(%ld): TM IOCB failed (%x).\n",
-			__func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_taskm, vha, 0x8030,
+		    "TM IOCB failed (%x).\n", rval);
 	}
 
 	return;
@@ -519,11 +514,12 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	set_bit(0, ha->req_qid_map);
 	set_bit(0, ha->rsp_qid_map);
 
-	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
+	ql_log(ql_log_info, vha, 0x0040,
+	    "Configuring PCI space...\n");
 	rval = ha->isp_ops->pci_config(vha);
 	if (rval) {
-		DEBUG2(printk("scsi(%ld): Unable to configure PCI space.\n",
-		    vha->host_no));
+		ql_log(ql_log_warn, vha, 0x0044,
+		    "Unable to configure PCI space.\n");
 		return (rval);
 	}
 
@@ -531,20 +527,21 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 
 	rval = qla2xxx_get_flash_info(vha);
 	if (rval) {
-		DEBUG2(printk("scsi(%ld): Unable to validate FLASH data.\n",
-		    vha->host_no));
+		ql_log(ql_log_fatal, vha, 0x004f,
+		    "Unable to validate FLASH data.\n");
 		return (rval);
 	}
 
 	ha->isp_ops->get_flash_version(vha, req->ring);
-
-	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
+	ql_log(ql_log_info, vha, 0x0061,
+	    "Configure NVRAM parameters...\n");
 
 	ha->isp_ops->nvram_config(vha);
 
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
-		qla_printk(KERN_INFO, ha, "Masking HBA WWPN "
+		ql_log(ql_log_info, vha, 0x0077,
+		    "Masking HBA WWPN "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x (via NVRAM).\n",
 		    vha->port_name[0], vha->port_name[1],
 		    vha->port_name[2], vha->port_name[3],
@@ -553,7 +550,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		return QLA_FUNCTION_FAILED;
 	}
 
-	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
+	ql_log(ql_log_info, vha, 0x0078,
+	    "Verifying loaded RISC code...\n");
 
 	if (qla2x00_isp_firmware(vha) != QLA_SUCCESS) {
 		rval = ha->isp_ops->chip_diag(vha);
@@ -567,7 +565,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA84XX(ha)) {
 		ha->cs84xx = qla84xx_get_chip(vha);
 		if (!ha->cs84xx) {
-			qla_printk(KERN_ERR, ha,
+			ql_log(ql_log_warn, vha, 0x00d0,
 			    "Unable to configure ISP84XX.\n");
 			return QLA_FUNCTION_FAILED;
 		}
@@ -579,8 +577,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		/* Issue verify 84xx FW IOCB to complete 84xx initialization */
 		rval = qla84xx_init_chip(vha);
 		if (rval != QLA_SUCCESS) {
-			qla_printk(KERN_ERR, ha,
-				"Unable to initialize ISP84XX.\n");
+			ql_log(ql_log_warn, vha, 0x00d4,
+			    "Unable to initialize ISP84XX.\n");
 		qla84xx_put_chip(vha);
 		}
 	}
@@ -797,9 +795,7 @@ qla2x00_isp_firmware(scsi_qla_host_t *vha)
 	rval = QLA_FUNCTION_FAILED;
 
 	if (ha->flags.disable_risc_code_load) {
-		DEBUG2(printk("scsi(%ld): RISC CODE NOT loaded\n",
-		    vha->host_no));
-		qla_printk(KERN_INFO, ha, "RISC CODE NOT loaded\n");
+		ql_log(ql_log_info, vha, 0x0079, "RISC CODE NOT loaded.\n");
 
 		/* Verify checksum of loaded RISC code. */
 		rval = qla2x00_verify_checksum(vha, ha->fw_srisc_address);
@@ -810,10 +806,9 @@ qla2x00_isp_firmware(scsi_qla_host_t *vha)
 		}
 	}
 
-	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): **** Load RISC code ****\n",
-		    vha->host_no));
-	}
+	if (rval)
+		ql_dbg(ql_dbg_init, vha, 0x007a,
+		    "**** Load RISC code ****.\n");
 
 	return (rval);
 }
@@ -1105,8 +1100,8 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	/* Assume a failed state */
 	rval = QLA_FUNCTION_FAILED;
 
-	DEBUG3(printk("scsi(%ld): Testing device at %lx.\n",
-	    vha->host_no, (u_long)&reg->flash_address));
+	ql_dbg(ql_dbg_init, vha, 0x007b,
+	    "Testing device at %lx.\n", (u_long)&reg->flash_address);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -1128,8 +1123,8 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	if (!cnt)
 		goto chip_diag_failed;
 
-	DEBUG3(printk("scsi(%ld): Reset register cleared by chip reset\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_init, vha, 0x007c,
+	    "Reset register cleared by chip reset.\n");
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
@@ -1150,7 +1145,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 		goto chip_diag_failed;
 
 	/* Check product ID of chip */
-	DEBUG3(printk("scsi(%ld): Checking product ID of chip\n", vha->host_no));
+	ql_dbg(ql_dbg_init, vha, 0x007d, "Checking product Id of chip.\n");
 
 	mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 	mb[2] = RD_MAILBOX_REG(ha, reg, 2);
@@ -1158,8 +1153,9 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	mb[4] = qla2x00_debounce_register(MAILBOX_REG(ha, reg, 4));
 	if (mb[1] != PROD_ID_1 || (mb[2] != PROD_ID_2 && mb[2] != PROD_ID_2a) ||
 	    mb[3] != PROD_ID_3) {
-		qla_printk(KERN_WARNING, ha,
-		    "Wrong product ID = 0x%x,0x%x,0x%x\n", mb[1], mb[2], mb[3]);
+		ql_log(ql_log_warn, vha, 0x0062,
+		    "Wrong product ID = 0x%x,0x%x,0x%x.\n",
+		    mb[1], mb[2], mb[3]);
 
 		goto chip_diag_failed;
 	}
@@ -1178,8 +1174,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
 		/* Limit firmware transfer size with a 2200A */
-		DEBUG3(printk("scsi(%ld): Found QLA2200A chip.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_init, vha, 0x007e, "Found QLA2200A Chip.\n");
 
 		ha->device_type |= DT_ISP2200A;
 		ha->fw_transfer_size = 128;
@@ -1188,24 +1183,20 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	/* Wrap Incoming Mailboxes Test. */
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	DEBUG3(printk("scsi(%ld): Checking mailboxes.\n", vha->host_no));
+	ql_dbg(ql_dbg_init, vha, 0x007f, "Checking mailboxes.\n");
 	rval = qla2x00_mbx_reg_test(vha);
-	if (rval) {
-		DEBUG(printk("scsi(%ld): Failed mailbox send register test\n",
-		    vha->host_no));
-		qla_printk(KERN_WARNING, ha,
-		    "Failed mailbox send register test\n");
-	}
-	else {
+	if (rval)
+		ql_log(ql_log_warn, vha, 0x0080,
+		    "Failed mailbox send register test.\n");
+	else
 		/* Flag a successful rval */
 		rval = QLA_SUCCESS;
-	}
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 chip_diag_failed:
 	if (rval)
-		DEBUG2_3(printk("scsi(%ld): Chip diagnostics **** FAILED "
-		    "****\n", vha->host_no));
+		ql_log(ql_log_info, vha, 0x0081,
+		    "Chip diagnostics **** FAILED ****.\n");
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1232,10 +1223,8 @@ qla24xx_chip_diag(scsi_qla_host_t *vha)
 
 	rval = qla2x00_mbx_reg_test(vha);
 	if (rval) {
-		DEBUG(printk("scsi(%ld): Failed mailbox send register test\n",
-		    vha->host_no));
-		qla_printk(KERN_WARNING, ha,
-		    "Failed mailbox send register test\n");
+		ql_log(ql_log_warn, vha, 0x0082,
+		    "Failed mailbox send register test.\n");
 	} else {
 		/* Flag a successful rval */
 		rval = QLA_SUCCESS;
@@ -1257,8 +1246,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	if (ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware dump previously allocated.\n");
+		ql_dbg(ql_dbg_init, vha, 0x00bd,
+		    "Firmware dump already allocated.\n");
 		return;
 	}
 
@@ -1288,8 +1277,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
 		    GFP_KERNEL);
 		if (!tc) {
-			qla_printk(KERN_WARNING, ha, "Unable to allocate "
-			    "(%d KB) for FCE.\n", FCE_SIZE / 1024);
+			ql_log(ql_log_warn, vha, 0x00be,
+			    "Unable to allocate (%d KB) for FCE.\n",
+			    FCE_SIZE / 1024);
 			goto try_eft;
 		}
 
@@ -1297,16 +1287,15 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
 		    ha->fce_mb, &ha->fce_bufs);
 		if (rval) {
-			qla_printk(KERN_WARNING, ha, "Unable to initialize "
-			    "FCE (%d).\n", rval);
+			ql_log(ql_log_warn, vha, 0x00bf,
+			    "Unable to initialize FCE (%d).\n", rval);
 			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
 			    tc_dma);
 			ha->flags.fce_enabled = 0;
 			goto try_eft;
 		}
-
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
-		    FCE_SIZE / 1024);
+		ql_log(ql_log_info, vha, 0x00c0,
+		    "Allocate (%d KB) for FCE...\n", FCE_SIZE / 1024);
 
 		fce_size = sizeof(struct qla2xxx_fce_chain) + FCE_SIZE;
 		ha->flags.fce_enabled = 1;
@@ -1317,23 +1306,23 @@ try_eft:
 		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
 		    GFP_KERNEL);
 		if (!tc) {
-			qla_printk(KERN_WARNING, ha, "Unable to allocate "
-			    "(%d KB) for EFT.\n", EFT_SIZE / 1024);
+			ql_log(ql_log_warn, vha, 0x00c1,
+			    "Unable to allocate (%d KB) for EFT.\n",
+			    EFT_SIZE / 1024);
 			goto cont_alloc;
 		}
 
 		memset(tc, 0, EFT_SIZE);
 		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
-			qla_printk(KERN_WARNING, ha, "Unable to initialize "
-			    "EFT (%d).\n", rval);
+			ql_log(ql_log_warn, vha, 0x00c2,
+			    "Unable to initialize EFT (%d).\n", rval);
 			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
 			    tc_dma);
 			goto cont_alloc;
 		}
-
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for EFT...\n",
-		    EFT_SIZE / 1024);
+		ql_log(ql_log_info, vha, 0x00c3,
+		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
 
 		eft_size = EFT_SIZE;
 		ha->eft_dma = tc_dma;
@@ -1350,8 +1339,9 @@ cont_alloc:
 
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha, "Unable to allocate (%d KB) for "
-		    "firmware dump!!!\n", dump_size / 1024);
+		ql_log(ql_log_warn, vha, 0x00c4,
+		    "Unable to allocate (%d KB) for firmware dump.\n",
+		    dump_size / 1024);
 
 		if (ha->fce) {
 			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce,
@@ -1368,8 +1358,8 @@ cont_alloc:
 		}
 		return;
 	}
-	qla_printk(KERN_INFO, ha, "Allocated (%d KB) for firmware dump...\n",
-	    dump_size / 1024);
+	ql_log(ql_log_info, vha, 0x00c5,
+	    "Allocated (%d KB) for firmware dump.\n", dump_size / 1024);
 
 	ha->fw_dump_len = dump_size;
 	ha->fw_dump->signature[0] = 'Q';
@@ -1398,23 +1388,21 @@ qla81xx_mpi_sync(scsi_qla_host_t *vha)
 	int rval;
 	uint16_t dc;
 	uint32_t dw;
-	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(vha->hw))
 		return QLA_SUCCESS;
 
 	rval = qla2x00_write_ram_word(vha, 0x7c00, 1);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "Sync-MPI: Unable to acquire semaphore.\n"));
+		ql_log(ql_log_warn, vha, 0x0105,
+		    "Unable to acquire semaphore.\n");
 		goto done;
 	}
 
 	pci_read_config_word(vha->hw->pdev, 0x54, &dc);
 	rval = qla2x00_read_ram_word(vha, 0x7a15, &dw);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "Sync-MPI: Unable to read sync.\n"));
+		ql_log(ql_log_warn, vha, 0x0067, "Unable to read sync.\n");
 		goto done_release;
 	}
 
@@ -1426,15 +1414,14 @@ qla81xx_mpi_sync(scsi_qla_host_t *vha)
 	dw |= dc;
 	rval = qla2x00_write_ram_word(vha, 0x7a15, dw);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "Sync-MPI: Unable to gain sync.\n"));
+		ql_log(ql_log_warn, vha, 0x0114, "Unable to gain sync.\n");
 	}
 
 done_release:
 	rval = qla2x00_write_ram_word(vha, 0x7c00, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "Sync-MPI: Unable to release semaphore.\n"));
+		ql_log(ql_log_warn, vha, 0x006d,
+		    "Unable to release semaphore.\n");
 	}
 
 done:
@@ -1479,14 +1466,14 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 	/* Load firmware sequences */
 	rval = ha->isp_ops->load_risc(vha, &srisc_address);
 	if (rval == QLA_SUCCESS) {
-		DEBUG(printk("scsi(%ld): Verifying Checksum of loaded RISC "
-		    "code.\n", vha->host_no));
+		ql_dbg(ql_dbg_init, vha, 0x00c9,
+		    "Verifying Checksum of loaded RISC code.\n");
 
 		rval = qla2x00_verify_checksum(vha, srisc_address);
 		if (rval == QLA_SUCCESS) {
 			/* Start firmware execution. */
-			DEBUG(printk("scsi(%ld): Checksum OK, start "
-			    "firmware.\n", vha->host_no));
+			ql_dbg(ql_dbg_init, vha, 0x00ca,
+			    "Starting firmware.\n");
 
 			rval = qla2x00_execute_fw(vha, srisc_address);
 			/* Retrieve firmware information. */
@@ -1522,9 +1509,9 @@ enable_82xx_npiv:
 				}
 			}
 		} else {
-			DEBUG2(printk(KERN_INFO
-			    "scsi(%ld): ISP Firmware failed checksum.\n",
-			    vha->host_no));
+			ql_log(ql_log_fatal, vha, 0x00cd,
+			    "ISP Firmware failed checksum.\n");
+			goto failed;
 		}
 	}
 
@@ -1549,7 +1536,7 @@ enable_82xx_npiv:
 			ha->flags.fac_supported = 1;
 			ha->fdt_block_size = size << 2;
 		} else {
-			qla_printk(KERN_ERR, ha,
+			ql_log(ql_log_warn, vha, 0x00ce,
 			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
 			    ha->fw_major_version, ha->fw_minor_version,
 			    ha->fw_subminor_version);
@@ -1557,8 +1544,8 @@ enable_82xx_npiv:
 	}
 failed:
 	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): Setup chip **** FAILED ****.\n",
-		    vha->host_no));
+		ql_log(ql_log_fatal, vha, 0x00cf,
+		    "Setup chip ****FAILED****.\n");
 	}
 
 	return (rval);
@@ -1608,10 +1595,11 @@ qla2x00_update_fw_options(scsi_qla_host_t *vha)
 		return;
 
 	/* Serial Link options. */
-	DEBUG3(printk("scsi(%ld): Serial link options:\n",
-	    vha->host_no));
-	DEBUG3(qla2x00_dump_buffer((uint8_t *)&ha->fw_seriallink_options,
-	    sizeof(ha->fw_seriallink_options)));
+	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x0115,
+	    "Serial link options.\n");
+	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0109,
+	    (uint8_t *)&ha->fw_seriallink_options,
+	    sizeof(ha->fw_seriallink_options));
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	if (ha->fw_seriallink_options[3] & BIT_2) {
@@ -1688,7 +1676,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	    le16_to_cpu(ha->fw_seriallink_options24[2]),
 	    le16_to_cpu(ha->fw_seriallink_options24[3]));
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x0104,
 		    "Unable to update Serial Link options (%x).\n", rval);
 	}
 }
@@ -1746,8 +1734,9 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		icb->rid = __constant_cpu_to_le16(rid);
 		if (ha->flags.msix_enabled) {
 			msix = &ha->msix_entries[1];
-			DEBUG2_17(printk(KERN_INFO
-			"Registering vector 0x%x for base que\n", msix->entry));
+			ql_dbg(ql_dbg_init, vha, 0x00fd,
+			    "Registering vector 0x%x for base que.\n",
+			    msix->entry);
 			icb->msix = cpu_to_le16(msix->entry);
 		}
 		/* Use alternate PCI bus number */
@@ -1764,8 +1753,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 			icb->firmware_options_2 &=
 				__constant_cpu_to_le32(~BIT_22);
 			ha->flags.disable_msix_handshake = 1;
-			qla_printk(KERN_INFO, ha,
-				"MSIX Handshake Disable Mode turned on\n");
+			ql_dbg(ql_dbg_init, vha, 0x00fe,
+			    "MSIX Handshake Disable Mode turned on.\n");
 		} else {
 			icb->firmware_options_2 |=
 				__constant_cpu_to_le32(BIT_22);
@@ -1850,7 +1839,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	/* Update any ISP specific firmware options before initialization. */
 	ha->isp_ops->update_fw_options(vha);
 
-	DEBUG(printk("scsi(%ld): Issue init firmware.\n", vha->host_no));
+	ql_dbg(ql_dbg_init, vha, 0x00d1, "Issue init firmware.\n");
 
 	if (ha->flags.npiv_supported) {
 		if (ha->operating_mode == LOOP)
@@ -1866,11 +1855,11 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
-		    vha->host_no));
+		ql_log(ql_log_fatal, vha, 0x00d2,
+		    "Init Firmware **** FAILED ****.\n");
 	} else {
-		DEBUG3(printk("scsi(%ld): Init firmware -- success.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_init, vha, 0x00d3,
+		    "Init Firmware -- success.\n");
 	}
 
 	return (rval);
@@ -1913,10 +1902,8 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 
 	/* Wait for ISP to finish LIP */
 	if (!vha->flags.init_done)
- 		qla_printk(KERN_INFO, ha, "Waiting for LIP to complete...\n");
-
-	DEBUG3(printk("scsi(%ld): Waiting for LIP to complete...\n",
-	    vha->host_no));
+		ql_log(ql_log_info, vha, 0x801e,
+		    "Waiting for LIP to complete.\n");
 
 	do {
 		rval = qla2x00_get_firmware_state(vha, state);
@@ -1925,30 +1912,35 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 				vha->device_flags &= ~DFLG_NO_CABLE;
 			}
 			if (IS_QLA84XX(ha) && state[0] != FSTATE_READY) {
-				DEBUG16(printk("scsi(%ld): fw_state=%x "
-				    "84xx=%x.\n", vha->host_no, state[0],
-				    state[2]));
+				ql_dbg(ql_dbg_taskm, vha, 0x801f,
+				    "fw_state=%x 84xx=%x.\n", state[0],
+				    state[2]);
 				if ((state[2] & FSTATE_LOGGED_IN) &&
 				     (state[2] & FSTATE_WAITING_FOR_VERIFY)) {
-					DEBUG16(printk("scsi(%ld): Sending "
-					    "verify iocb.\n", vha->host_no));
+					ql_dbg(ql_dbg_taskm, vha, 0x8028,
+					    "Sending verify iocb.\n");
 
 					cs84xx_time = jiffies;
 					rval = qla84xx_init_chip(vha);
-					if (rval != QLA_SUCCESS)
+					if (rval != QLA_SUCCESS) {
+						ql_log(ql_log_warn,
+						    vha, 0x8043,
+						    "Init chip failed.\n");
 						break;
+					}
 
 					/* Add time taken to initialize. */
 					cs84xx_time = jiffies - cs84xx_time;
 					wtime += cs84xx_time;
 					mtime += cs84xx_time;
-					DEBUG16(printk("scsi(%ld): Increasing "
-					    "wait time by %ld. New time %ld\n",
-					    vha->host_no, cs84xx_time, wtime));
+					ql_dbg(ql_dbg_taskm, vha, 0x8042,
+					    "Increasing wait time by %ld. "
+					    "New time %ld.\n", cs84xx_time,
+					    wtime);
 				}
 			} else if (state[0] == FSTATE_READY) {
-				DEBUG(printk("scsi(%ld): F/W Ready - OK \n",
-				    vha->host_no));
+				ql_dbg(ql_dbg_taskm, vha, 0x8037,
+				    "F/W Ready - OK.\n");
 
 				qla2x00_get_retry_cnt(vha, &ha->retry_count,
 				    &ha->login_timeout, &ha->r_a_tov);
@@ -1965,7 +1957,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 				 * other than Wait for Login.
 				 */
 				if (time_after_eq(jiffies, mtime)) {
-					qla_printk(KERN_INFO, ha,
+					ql_log(ql_log_info, vha, 0x8038,
 					    "Cable is unplugged...\n");
 
 					vha->device_flags |= DFLG_NO_CABLE;
@@ -1985,17 +1977,17 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 		/* Delay for a while */
 		msleep(500);
 
-		DEBUG3(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
-		    vha->host_no, state[0], jiffies));
+		ql_dbg(ql_dbg_taskm, vha, 0x8039,
+		    "fw_state=%x curr time=%lx.\n", state[0], jiffies);
 	} while (1);
 
-	DEBUG(printk("scsi(%ld): fw_state=%x (%x, %x, %x, %x) curr time=%lx.\n",
-	    vha->host_no, state[0], state[1], state[2], state[3], state[4],
-	    jiffies));
+	ql_dbg(ql_dbg_taskm, vha, 0x803a,
+	    "fw_state=%x (%x, %x, %x, %x) " "curr time=%lx.\n", state[0],
+	    state[1], state[2], state[3], state[4], jiffies);
 
 	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): Firmware ready **** FAILED ****.\n",
-		    vha->host_no));
+		ql_log(ql_log_warn, vha, 0x803b,
+		    "Firmware ready **** FAILED ****.\n");
 	}
 
 	return (rval);
@@ -2034,19 +2026,19 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 		if (LOOP_TRANSITION(vha) || atomic_read(&ha->loop_down_timer) ||
 		    IS_QLA8XXX_TYPE(ha) ||
 		    (rval == QLA_COMMAND_ERROR && loop_id == 0x7)) {
-			DEBUG2(printk("%s(%ld) Loop is in a transition state\n",
-			    __func__, vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x2008,
+			    "Loop is in a transition state.\n");
 		} else {
-			qla_printk(KERN_WARNING, ha,
-			    "ERROR -- Unable to get host loop ID.\n");
+			ql_log(ql_log_warn, vha, 0x2009,
+			    "Unable to get host loop ID.\n");
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		}
 		return (rval);
 	}
 
 	if (topo == 4) {
-		qla_printk(KERN_INFO, ha,
-			"Cannot get topology - retrying.\n");
+		ql_log(ql_log_info, vha, 0x200a,
+		    "Cannot get topology - retrying.\n");
 		return (QLA_FUNCTION_FAILED);
 	}
 
@@ -2059,31 +2051,27 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 	switch (topo) {
 	case 0:
-		DEBUG3(printk("scsi(%ld): HBA in NL topology.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x200b, "HBA in NL topology.\n");
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
 
 	case 1:
-		DEBUG3(printk("scsi(%ld): HBA in FL topology.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x200c, "HBA in FL topology.\n");
 		ha->switch_cap = sw_cap;
 		ha->current_topology = ISP_CFG_FL;
 		strcpy(connect_type, "(FL_Port)");
 		break;
 
 	case 2:
-		DEBUG3(printk("scsi(%ld): HBA in N P2P topology.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_N;
 		strcpy(connect_type, "(N_Port-to-N_Port)");
 		break;
 
 	case 3:
-		DEBUG3(printk("scsi(%ld): HBA in F P2P topology.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x200e, "HBA in F P2P topology.\n");
 		ha->switch_cap = sw_cap;
 		ha->operating_mode = P2P;
 		ha->current_topology = ISP_CFG_F;
@@ -2091,9 +2079,8 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 		break;
 
 	default:
-		DEBUG3(printk("scsi(%ld): HBA in unknown topology %x. "
-		    "Using NL.\n",
-		    vha->host_no, topo));
+		ql_dbg(ql_dbg_disc, vha, 0x200f,
+		    "HBA in unknown topology %x, using NL.\n", topo);
 		ha->current_topology = ISP_CFG_NL;
 		strcpy(connect_type, "(Loop)");
 		break;
@@ -2106,14 +2093,16 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->d_id.b.al_pa = al_pa;
 
 	if (!vha->flags.init_done)
- 		qla_printk(KERN_INFO, ha,
-		    "Topology - %s, Host Loop address 0x%x\n",
+		ql_log(ql_log_info, vha, 0x2010,
+		    "Topology - %s, Host Loop address 0x%x.\n",
 		    connect_type, vha->loop_id);
 
 	if (rval) {
-		DEBUG2_3(printk("scsi(%ld): FAILED.\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x2011,
+		    "%s FAILED\n", __func__);
 	} else {
-		DEBUG3(printk("scsi(%ld): exiting normally.\n", vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2012,
+		    "%s success\n", __func__);
 	}
 
 	return(rval);
@@ -2227,18 +2216,22 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size; cnt++)
 		chksum += *ptr++;
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
-	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
+	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x010f,
+	    "Contents of NVRAM.\n");
+	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0110,
+	    (uint8_t *)nv, ha->nvram_size);
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
 	    nv->id[2] != 'P' || nv->id[3] != ' ' || nv->nvram_version < 1) {
 		/* Reset NVRAM data. */
-		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
-		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
-		    nv->nvram_version);
-		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
-		    "invalid -- WWPN) defaults.\n");
+		ql_log(ql_log_warn, vha, 0x0064,
+		    "Inconisistent NVRAM "
+		    "detected: checksum=0x%x id=%c version=0x%x.\n",
+		    chksum, nv->id[0], nv->nvram_version);
+		ql_log(ql_log_warn, vha, 0x0065,
+		    "Falling back to "
+		    "functioning (yet invalid -- WWPN) defaults.\n");
 
 		/*
 		 * Set default initialization control block.
@@ -2493,10 +2486,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		if (ha->zio_mode != QLA_ZIO_DISABLED) {
 			ha->zio_mode = QLA_ZIO_MODE_6;
 
-			DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer "
-			    "delay (%d us).\n", vha->host_no, ha->zio_mode,
-			    ha->zio_timer * 100));
-			qla_printk(KERN_INFO, ha,
+			ql_log(ql_log_info, vha, 0x0068,
 			    "ZIO mode %d enabled; timer delay (%d us).\n",
 			    ha->zio_mode, ha->zio_timer * 100);
 
@@ -2507,8 +2497,8 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	}
 
 	if (rval) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x0069,
+		    "NVRAM configuration failed.\n");
 	}
 	return (rval);
 }
@@ -2579,15 +2569,15 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	if (test_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags)) {
 		rval = qla2x00_configure_hba(vha);
 		if (rval != QLA_SUCCESS) {
-			DEBUG(printk("scsi(%ld): Unable to configure HBA.\n",
-			    vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x2013,
+			    "Unable to configure HBA.\n");
 			return (rval);
 		}
 	}
 
 	save_flags = flags = vha->dpc_flags;
-	DEBUG(printk("scsi(%ld): Configure loop -- dpc flags =0x%lx\n",
-	    vha->host_no, flags));
+	ql_dbg(ql_dbg_disc, vha, 0x2014,
+	    "Configure loop -- dpc flags = 0x%lx.\n", flags);
 
 	/*
 	 * If we have both an RSCN and PORT UPDATE pending then handle them
@@ -2624,15 +2614,21 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	}
 
 	if (test_bit(LOCAL_LOOP_UPDATE, &flags)) {
-		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
+			ql_dbg(ql_dbg_disc, vha, 0x2015,
+			    "Loop resync needed, failing.\n");
 			rval = QLA_FUNCTION_FAILED;
+		}
 		else
 			rval = qla2x00_configure_local_loop(vha);
 	}
 
 	if (rval == QLA_SUCCESS && test_bit(RSCN_UPDATE, &flags)) {
-		if (LOOP_TRANSITION(vha))
+		if (LOOP_TRANSITION(vha)) {
+			ql_dbg(ql_dbg_disc, vha, 0x201e,
+			    "Needs RSCN update and loop transition.\n");
 			rval = QLA_FUNCTION_FAILED;
+		}
 		else
 			rval = qla2x00_configure_fabric(vha);
 	}
@@ -2643,16 +2639,17 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			atomic_set(&vha->loop_state, LOOP_READY);
-
-			DEBUG(printk("scsi(%ld): LOOP READY\n", vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x2069,
+			    "LOOP READY.\n");
 		}
 	}
 
 	if (rval) {
-		DEBUG2_3(printk("%s(%ld): *** FAILED ***\n",
-		    __func__, vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x206a,
+		    "%s *** FAILED ***.\n", __func__);
 	} else {
-		DEBUG3(printk("%s: exiting normally\n", __func__));
+		ql_dbg(ql_dbg_disc, vha, 0x206b,
+		    "%s: exiting normally.\n", __func__);
 	}
 
 	/* Restore state if a resync event occurred during processing */
@@ -2700,8 +2697,10 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	new_fcport = NULL;
 	entries = MAX_FIBRE_DEVICES;
 
-	DEBUG3(printk("scsi(%ld): Getting FCAL position map\n", vha->host_no));
-	DEBUG3(qla2x00_get_fcal_position_map(vha, NULL));
+	ql_dbg(ql_dbg_disc, vha, 0x2016,
+	    "Getting FCAL position map.\n");
+	if (ql2xextended_error_logging & ql_dbg_disc)
+		qla2x00_get_fcal_position_map(vha, NULL);
 
 	/* Get list of logged in devices. */
 	memset(ha->gid_list, 0, GID_LIST_SIZE);
@@ -2710,14 +2709,17 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	if (rval != QLA_SUCCESS)
 		goto cleanup_allocation;
 
-	DEBUG3(printk("scsi(%ld): Entries in ID list (%d)\n",
-	    vha->host_no, entries));
-	DEBUG3(qla2x00_dump_buffer((uint8_t *)ha->gid_list,
-	    entries * sizeof(struct gid_list_info)));
+	ql_dbg(ql_dbg_disc, vha, 0x2017,
+	    "Entries in ID list (%d).\n", entries);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2075,
+	    (uint8_t *)ha->gid_list,
+	    entries * sizeof(struct gid_list_info));
 
 	/* Allocate temporary fcport for any new fcports discovered. */
 	new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (new_fcport == NULL) {
+		ql_log(ql_log_warn, vha, 0x2018,
+		    "Memory allocation failed for fcport.\n");
 		rval = QLA_MEMORY_ALLOC_FAILED;
 		goto cleanup_allocation;
 	}
@@ -2731,9 +2733,9 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		    fcport->port_type != FCT_BROADCAST &&
 		    (fcport->flags & FCF_FABRIC_DEVICE) == 0) {
 
-			DEBUG(printk("scsi(%ld): Marking port lost, "
-			    "loop_id=0x%04x\n",
-			    vha->host_no, fcport->loop_id));
+			ql_dbg(ql_dbg_disc, vha, 0x2019,
+			    "Marking port lost loop_id=0x%04x.\n",
+			    fcport->loop_id);
 
 			qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 		}
@@ -2774,12 +2776,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		new_fcport->vp_idx = vha->vp_idx;
 		rval2 = qla2x00_get_port_database(vha, new_fcport, 0);
 		if (rval2 != QLA_SUCCESS) {
-			DEBUG2(printk("scsi(%ld): Failed to retrieve fcport "
-			    "information -- get_port_database=%x, "
-			    "loop_id=0x%04x\n",
-			    vha->host_no, rval2, new_fcport->loop_id));
-			DEBUG2(printk("scsi(%ld): Scheduling resync...\n",
-			    vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x201a,
+			    "Failed to retrieve fcport information "
+			    "-- get_port_database=%x, loop_id=0x%04x.\n",
+			    rval2, new_fcport->loop_id);
+			ql_dbg(ql_dbg_disc, vha, 0x201b,
+			    "Scheduling resync.\n");
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			continue;
 		}
@@ -2815,6 +2817,8 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			fcport = new_fcport;
 			new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 			if (new_fcport == NULL) {
+				ql_log(ql_log_warn, vha, 0x201c,
+				    "Failed to allocate memory for fcport.\n");
 				rval = QLA_MEMORY_ALLOC_FAILED;
 				goto cleanup_allocation;
 			}
@@ -2833,8 +2837,8 @@ cleanup_allocation:
 	kfree(new_fcport);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(printk("scsi(%ld): Configure local loop error exit: "
-		    "rval=%x\n", vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x201d,
+		    "Configure local loop error exit: rval=%x.\n", rval);
 	}
 
 	return (rval);
@@ -2863,27 +2867,27 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	rval = qla2x00_set_idma_speed(vha, fcport->loop_id, fcport->fp_speed,
 	    mb);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(printk("scsi(%ld): Unable to adjust iIDMA "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
-		    vha->host_no, fcport->port_name[0], fcport->port_name[1],
+		ql_dbg(ql_dbg_disc, vha, 0x2004,
+		    "Unable to adjust iIDMA "
+		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x "
+		    "%04x.\n", fcport->port_name[0], fcport->port_name[1],
 		    fcport->port_name[2], fcport->port_name[3],
 		    fcport->port_name[4], fcport->port_name[5],
 		    fcport->port_name[6], fcport->port_name[7], rval,
-		    fcport->fp_speed, mb[0], mb[1]));
+		    fcport->fp_speed, mb[0], mb[1]);
 	} else {
 		link_speed = link_speeds[LS_UNKNOWN];
 		if (fcport->fp_speed < 5)
 			link_speed = link_speeds[fcport->fp_speed];
 		else if (fcport->fp_speed == 0x13)
 			link_speed = link_speeds[5];
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "iIDMA adjusted to %s GB/s on "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x.\n",
-		    link_speed, fcport->port_name[0],
-		    fcport->port_name[1], fcport->port_name[2],
-		    fcport->port_name[3], fcport->port_name[4],
-		    fcport->port_name[5], fcport->port_name[6],
-		    fcport->port_name[7]));
+		ql_dbg(ql_dbg_disc, vha, 0x2005,
+		    "iIDMA adjusted to %s GB/s "
+		    "on %02x%02x%02x%02x%02x%02x%02x%02x.\n", link_speed,
+		    fcport->port_name[0], fcport->port_name[1],
+		    fcport->port_name[2], fcport->port_name[3],
+		    fcport->port_name[4], fcport->port_name[5],
+		    fcport->port_name[6], fcport->port_name[7]);
 	}
 }
 
@@ -2892,7 +2896,6 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
-	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 
 	qla2x00_rport_del(fcport);
@@ -2904,8 +2907,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	fcport->rport = rport = fc_remote_port_add(vha->host, 0, &rport_ids);
 	if (!rport) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to allocate fc remote port!\n");
+		ql_log(ql_log_warn, vha, 0x2006,
+		    "Unable to allocate fc remote port.\n");
 		return;
 	}
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
@@ -2980,8 +2983,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		loop_id = SNS_FL_PORT;
 	rval = qla2x00_get_port_name(vha, loop_id, vha->fabric_node_name, 1);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(printk("scsi(%ld): MBC_GET_PORT_NAME Failed, No FL "
-		    "Port\n", vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x201f,
+		    "MBX_GET_PORT_NAME failed, No FL Port.\n");
 
 		vha->device_flags &= ~SWITCH_FOUND;
 		return (QLA_SUCCESS);
@@ -3008,32 +3011,32 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
 		    0xfc, mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
-			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", loop_id,
-			    mb[0], mb[1], mb[2], mb[6], mb[7]));
+			ql_dbg(ql_dbg_disc, vha, 0x2042,
+			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x "
+			    "mb[6]=%x mb[7]=%x.\n", loop_id, mb[0], mb[1],
+			    mb[2], mb[6], mb[7]);
 			return (QLA_SUCCESS);
 		}
 
 		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags)) {
 			if (qla2x00_rft_id(vha)) {
 				/* EMPTY */
-				DEBUG2(printk("scsi(%ld): Register FC-4 "
-				    "TYPE failed.\n", vha->host_no));
+				ql_dbg(ql_dbg_disc, vha, 0x2045,
+				    "Register FC-4 TYPE failed.\n");
 			}
 			if (qla2x00_rff_id(vha)) {
 				/* EMPTY */
-				DEBUG2(printk("scsi(%ld): Register FC-4 "
-				    "Features failed.\n", vha->host_no));
+				ql_dbg(ql_dbg_disc, vha, 0x2049,
+				    "Register FC-4 Features failed.\n");
 			}
 			if (qla2x00_rnn_id(vha)) {
 				/* EMPTY */
-				DEBUG2(printk("scsi(%ld): Register Node Name "
-				    "failed.\n", vha->host_no));
+				ql_dbg(ql_dbg_disc, vha, 0x204f,
+				    "Register Node Name failed.\n");
 			} else if (qla2x00_rsnn_nn(vha)) {
 				/* EMPTY */
-				DEBUG2(printk("scsi(%ld): Register Symbolic "
-				    "Node Name failed.\n", vha->host_no));
+				ql_dbg(ql_dbg_disc, vha, 0x2053,
+				    "Register Symobilic Node Name failed.\n");
 			}
 		}
 
@@ -3137,8 +3140,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	}
 
 	if (rval) {
-		DEBUG2(printk("scsi(%ld): Configure fabric error exit: "
-		    "rval=%d\n", vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2068,
+		    "Configure fabric error exit rval=%d.\n", rval);
 	}
 
 	return (rval);
@@ -3180,8 +3183,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_KERNEL);
 	if (!swl) {
 		/*EMPTY*/
-		DEBUG2(printk("scsi(%ld): GID_PT allocations failed, fallback "
-		    "on GA_NXT\n", vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2054,
+		    "GID_PT allocations failed, fallback on GA_NXT.\n");
 	} else {
 		if (qla2x00_gid_pt(vha, swl) != QLA_SUCCESS) {
 			kfree(swl);
@@ -3206,6 +3209,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	/* Allocate temporary fcport for any new fcports discovered. */
 	new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (new_fcport == NULL) {
+		ql_log(ql_log_warn, vha, 0x205e,
+		    "Failed to allocate memory for fcport.\n");
 		kfree(swl);
 		return (QLA_MEMORY_ALLOC_FAILED);
 	}
@@ -3252,9 +3257,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			/* Send GA_NXT to the switch */
 			rval = qla2x00_ga_nxt(vha, new_fcport);
 			if (rval != QLA_SUCCESS) {
-				qla_printk(KERN_WARNING, ha,
-				    "SNS scan failed -- assuming zero-entry "
-				    "result...\n");
+				ql_log(ql_log_warn, vha, 0x2064,
+				    "SNS scan failed -- assuming "
+				    "zero-entry result.\n");
 				list_for_each_entry_safe(fcport, fcptemp,
 				    new_fcports, list) {
 					list_del(&fcport->list);
@@ -3270,9 +3275,11 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			wrap.b24 = new_fcport->d_id.b24;
 			first_dev = 0;
 		} else if (new_fcport->d_id.b24 == wrap.b24) {
-			DEBUG2(printk("scsi(%ld): device wrap (%02x%02x%02x)\n",
-			    vha->host_no, new_fcport->d_id.b.domain,
-			    new_fcport->d_id.b.area, new_fcport->d_id.b.al_pa));
+			ql_dbg(ql_dbg_disc, vha, 0x2065,
+			    "Device wrap (%02x%02x%02x).\n",
+			    new_fcport->d_id.b.domain,
+			    new_fcport->d_id.b.area,
+			    new_fcport->d_id.b.al_pa);
 			break;
 		}
 
@@ -3377,6 +3384,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		nxt_d_id.b24 = new_fcport->d_id.b24;
 		new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 		if (new_fcport == NULL) {
+			ql_log(ql_log_warn, vha, 0x2066,
+			    "Memory allocation failed for fcport.\n");
 			kfree(swl);
 			return (QLA_MEMORY_ALLOC_FAILED);
 		}
@@ -3506,10 +3515,10 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
 		d_id.b.area = MSB(LSW(rscn_entry));
 		d_id.b.al_pa = LSB(LSW(rscn_entry));
 
-		DEBUG(printk("scsi(%ld): RSCN queue entry[%d] = "
-		    "[%02x/%02x%02x%02x].\n",
-		    vha->host_no, vha->rscn_out_ptr, format, d_id.b.domain,
-		    d_id.b.area, d_id.b.al_pa));
+		ql_dbg(ql_dbg_disc, vha, 0x2020,
+		    "RSCN queue entry[%d] = [%02x/%02x%02x%02x].\n",
+		    vha->rscn_out_ptr, format, d_id.b.domain, d_id.b.area,
+		    d_id.b.al_pa);
 
 		vha->rscn_out_ptr++;
 		if (vha->rscn_out_ptr == MAX_RSCN_COUNT)
@@ -3525,17 +3534,17 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
 			if (rscn_entry != vha->rscn_queue[rscn_out_iter])
 				break;
 
-			DEBUG(printk("scsi(%ld): Skipping duplicate RSCN queue "
-			    "entry found at [%d].\n", vha->host_no,
-			    rscn_out_iter));
+			ql_dbg(ql_dbg_disc, vha, 0x2021,
+			    "Skipping duplicate RSCN queue entry found at "
+			    "[%d].\n", rscn_out_iter);
 
 			vha->rscn_out_ptr = rscn_out_iter;
 		}
 
 		/* Queue overflow, set switch default case. */
 		if (vha->flags.rscn_queue_overflow) {
-			DEBUG(printk("scsi(%ld): device_resync: rscn "
-			    "overflow.\n", vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x2022,
+			    "device_resync: rscn overflow.\n");
 
 			format = 3;
 			vha->flags.rscn_queue_overflow = 0;
@@ -3664,10 +3673,11 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 	tmp_loopid = 0;
 
 	for (;;) {
-		DEBUG(printk("scsi(%ld): Trying Fabric Login w/loop id 0x%04x "
- 		    "for port %02x%02x%02x.\n",
-		    vha->host_no, fcport->loop_id, fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa));
+		ql_dbg(ql_dbg_disc, vha, 0x2000,
+		    "Trying Fabric Login w/loop id 0x%04x for port "
+		    "%02x%02x%02x.\n",
+		    fcport->loop_id, fcport->d_id.b.domain,
+		    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 		/* Login fcport on switch. */
 		ha->isp_ops->fabric_login(vha, fcport->loop_id,
@@ -3685,10 +3695,11 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			tmp_loopid = fcport->loop_id;
 			fcport->loop_id = mb[1];
 
-			DEBUG(printk("Fabric Login: port in use - next "
- 			    "loop id=0x%04x, port Id=%02x%02x%02x.\n",
+			ql_dbg(ql_dbg_disc, vha, 0x2001,
+			    "Fabric Login: port in use - next loop "
+			    "id=0x%04x, port id= %02x%02x%02x.\n",
 			    fcport->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa));
+			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 		} else if (mb[0] == MBS_COMMAND_COMPLETE) {
 			/*
@@ -3749,11 +3760,11 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			/*
 			 * unrecoverable / not handled error
 			 */
-			DEBUG2(printk("%s(%ld): failed=%x port_id=%02x%02x%02x "
- 			    "loop_id=%x jiffies=%lx.\n",
-			    __func__, vha->host_no, mb[0],
-			    fcport->d_id.b.domain, fcport->d_id.b.area,
-			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
+			ql_dbg(ql_dbg_disc, vha, 0x2002,
+			    "Failed=%x port_id=%02x%02x%02x loop_id=%x "
+			    "jiffies=%lx.\n", mb[0], fcport->d_id.b.domain,
+			    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+			    fcport->loop_id, jiffies);
 
 			*next_loopid = fcport->loop_id;
 			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
@@ -3857,7 +3868,8 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 		return (QLA_FUNCTION_FAILED);
 
 	if (rval)
-		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
+		ql_dbg(ql_dbg_disc, vha, 0x206c,
+		    "%s *** FAILED ***.\n", __func__);
 
 	return (rval);
 }
@@ -3934,8 +3946,8 @@ qla82xx_quiescent_state_cleanup(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
 
-	qla_printk(KERN_INFO, ha,
-			"Performing ISP error recovery - ha= %p.\n", ha);
+	ql_dbg(ql_dbg_p3p, vha, 0xb002,
+	    "Performing ISP error recovery - ha=%p.\n", ha);
 
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
@@ -3969,8 +3981,8 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	ha->qla_stats.total_isp_aborts++;
 
-	qla_printk(KERN_INFO, ha,
-	    "Performing ISP error recovery - ha= %p.\n", ha);
+	ql_log(ql_log_info, vha, 0x00af,
+	    "Performing ISP error recovery - ha=%p.\n", ha);
 
 	/* For ISP82XX, reset_chip is just disabling interrupts.
 	 * Driver waits for the completion of the commands.
@@ -4021,6 +4033,8 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 		/* Make sure for ISP 82XX IO DMA is complete */
 		if (IS_QLA82XX(ha)) {
 			qla82xx_chip_reset_cleanup(vha);
+			ql_log(ql_log_info, vha, 0x00b4,
+			    "Done chip reset cleanup.\n");
 
 			/* Done waiting for pending commands.
 			 * Reset the online flag.
@@ -4102,7 +4116,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
 				    &ha->fce_bufs);
 				if (rval) {
-					qla_printk(KERN_WARNING, ha,
+					ql_log(ql_log_warn, vha, 0x8033,
 					    "Unable to reinitialize FCE "
 					    "(%d).\n", rval);
 					ha->flags.fce_enabled = 0;
@@ -4114,7 +4128,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				rval = qla2x00_enable_eft_trace(vha,
 				    ha->eft_dma, EFT_NUM_BUFFERS);
 				if (rval) {
-					qla_printk(KERN_WARNING, ha,
+					ql_log(ql_log_warn, vha, 0x8034,
 					    "Unable to reinitialize EFT "
 					    "(%d).\n", rval);
 				}
@@ -4123,9 +4137,9 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 			vha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 				if (ha->isp_abort_cnt == 0) {
- 					qla_printk(KERN_WARNING, ha,
-					    "ISP error recovery failed - "
-					    "board disabled\n");
+					ql_log(ql_log_fatal, vha, 0x8035,
+					    "ISP error recover failed - "
+					    "board disabled.\n");
 					/*
 					 * The next call disables the board
 					 * completely.
@@ -4137,16 +4151,16 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 					status = 0;
 				} else { /* schedule another ISP abort */
 					ha->isp_abort_cnt--;
-					DEBUG(printk("qla%ld: ISP abort - "
-					    "retry remaining %d\n",
-					    vha->host_no, ha->isp_abort_cnt));
+					ql_dbg(ql_dbg_taskm, vha, 0x8020,
+					    "ISP abort - retry remaining %d.\n",
+					    ha->isp_abort_cnt);
 					status = 1;
 				}
 			} else {
 				ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
-				DEBUG(printk("qla2x00(%ld): ISP error recovery "
-				    "- retrying (%d) more times\n",
-				    vha->host_no, ha->isp_abort_cnt));
+				ql_dbg(ql_dbg_taskm, vha, 0x8021,
+				    "ISP error recovery - retrying (%d) "
+				    "more times.\n", ha->isp_abort_cnt);
 				set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 				status = 1;
 			}
@@ -4155,9 +4169,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	}
 
 	if (!status) {
-		DEBUG(printk(KERN_INFO
-				"qla2x00_abort_isp(%ld): succeeded.\n",
-				vha->host_no));
+		ql_dbg(ql_dbg_taskm, vha, 0x8022, "%s succeeded.\n", __func__);
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry(vp, &ha->vp_list, list) {
@@ -4174,8 +4186,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	} else {
-		qla_printk(KERN_INFO, ha,
-			"qla2x00_abort_isp: **** FAILED ****\n");
+		ql_log(ql_log_warn, vha, 0x8023, "%s **** FAILED ****.\n");
 	}
 
 	return(status);
@@ -4216,8 +4227,8 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 
 		status = qla2x00_fw_ready(vha);
 		if (!status) {
-			DEBUG(printk("%s(): Start configure loop, "
-			    "status = %d\n", __func__, status));
+			ql_dbg(ql_dbg_taskm, vha, 0x8031,
+			    "Start configure loop status = %d.\n", status);
 
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
@@ -4239,9 +4250,8 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 		if ((vha->device_flags & DFLG_NO_CABLE))
 			status = 0;
 
-		DEBUG(printk("%s(): Configure loop done, status = 0x%x\n",
-				__func__,
-				status));
+		ql_dbg(ql_dbg_taskm, vha, 0x8032,
+		    "Configure loop done, status = 0x%x.\n", status);
 	}
 	return (status);
 }
@@ -4261,13 +4271,13 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 			rsp->options &= ~BIT_0;
 			ret = qla25xx_init_rsp_que(base_vha, rsp);
 			if (ret != QLA_SUCCESS)
-				DEBUG2_17(printk(KERN_WARNING
-					"%s Rsp que:%d init failed\n", __func__,
-						rsp->id));
+				ql_dbg(ql_dbg_init, base_vha, 0x00ff,
+				    "%s Rsp que: %d init failed.\n",
+				    __func__, rsp->id);
 			else
-				DEBUG2_17(printk(KERN_INFO
-					"%s Rsp que:%d inited\n", __func__,
-						rsp->id));
+				ql_dbg(ql_dbg_init, base_vha, 0x0100,
+				    "%s Rsp que: %d inited.\n",
+				    __func__, rsp->id);
 		}
 	}
 	for (i = 1; i < ha->max_req_queues; i++) {
@@ -4277,13 +4287,13 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 			req->options &= ~BIT_0;
 			ret = qla25xx_init_req_que(base_vha, req);
 			if (ret != QLA_SUCCESS)
-				DEBUG2_17(printk(KERN_WARNING
-					"%s Req que:%d init failed\n", __func__,
-						req->id));
+				ql_dbg(ql_dbg_init, base_vha, 0x0101,
+				    "%s Req que: %d init failed.\n",
+				    __func__, req->id);
 			else
-				DEBUG2_17(printk(KERN_WARNING
-					"%s Req que:%d inited\n", __func__,
-						req->id));
+				ql_dbg(ql_dbg_init, base_vha, 0x0102,
+				    "%s Req que: %d inited.\n",
+				    __func__, req->id);
 		}
 	}
 	return ret;
@@ -4402,19 +4412,22 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
-	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
+	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x006a,
+	    "Contents of NVRAM\n");
+	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x010d,
+	    (uint8_t *)nv, ha->nvram_size);
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
-		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
-		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
-		    le16_to_cpu(nv->nvram_version));
-		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
-		    "invalid -- WWPN) defaults.\n");
+		ql_log(ql_log_warn, vha, 0x006b,
+		    "Inconisistent NVRAM detected: checksum=0x%x id=%c "
+		    "version=0x%x.\n", chksum, nv->id[0], nv->nvram_version);
+		ql_log(ql_log_warn, vha, 0x006c,
+		    "Falling back to functioning (yet invalid -- WWPN) "
+		    "defaults.\n");
 
 		/*
 		 * Set default initialization control block.
@@ -4592,10 +4605,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
 		ha->zio_mode = QLA_ZIO_MODE_6;
 
-		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
-		    "(%d us).\n", vha->host_no, ha->zio_mode,
-		    ha->zio_timer * 100));
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0x006f,
 		    "ZIO mode %d enabled; timer delay (%d us).\n",
 		    ha->zio_mode, ha->zio_timer * 100);
 
@@ -4606,8 +4616,8 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	}
 
 	if (rval) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x0070,
+		    "NVRAM configuration failed.\n");
 	}
 	return (rval);
 }
@@ -4625,8 +4635,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
-	qla_printk(KERN_INFO, ha,
-	    "FW: Loading from flash (%x)...\n", faddr);
+	ql_dbg(ql_dbg_init, vha, 0x008b,
+	    "Loading firmware from flash (%x).\n", faddr);
 
 	rval = QLA_SUCCESS;
 
@@ -4642,11 +4652,12 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		dcode[3] == 0)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of flash firmware image!\n");
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
-		    dcode[1], dcode[2], dcode[3]);
+		ql_log(ql_log_fatal, vha, 0x008c,
+		    "Unable to verify the integrity of flash firmware "
+		    "image.\n");
+		ql_log(ql_log_fatal, vha, 0x008d,
+		    "Firmware data: %08x %08x %08x %08x.\n",
+		    dcode[0], dcode[1], dcode[2], dcode[3]);
 
 		return QLA_FUNCTION_FAILED;
 	}
@@ -4665,9 +4676,10 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 			if (dlen > risc_size)
 				dlen = risc_size;
 
-			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
-			    "addr %x, number of dwords 0x%x, offset 0x%x.\n",
-			    vha->host_no, risc_addr, dlen, faddr));
+			ql_dbg(ql_dbg_init, vha, 0x008e,
+			    "Loading risc segment@ risc addr %x "
+			    "number of dwords 0x%x offset 0x%x.\n",
+			    risc_addr, dlen, faddr);
 
 			qla24xx_read_flash_data(vha, dcode, faddr, dlen);
 			for (i = 0; i < dlen; i++)
@@ -4676,12 +4688,9 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    dlen);
 			if (rval) {
-				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", vha->host_no,
-				    fragment));
-				qla_printk(KERN_WARNING, ha,
-				    "[ERROR] Failed to load segment %d of "
-				    "firmware\n", fragment);
+				ql_log(ql_log_fatal, vha, 0x008f,
+				    "Failed to load segment %d of firmware.\n",
+				    fragment);
 				break;
 			}
 
@@ -4714,9 +4723,10 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	/* Load firmware blob. */
 	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
-		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
-		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
-		    "from: " QLA_FW_URL ".\n");
+		ql_log(ql_log_info, vha, 0x0083,
+		    "Fimware image unavailable.\n");
+		ql_log(ql_log_info, vha, 0x0084,
+		    "Firmware images can be retrieved from: "QLA_FW_URL ".\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -4729,8 +4739,8 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 
 	/* Validate firmware image by checking version. */
 	if (blob->fw->size < 8 * sizeof(uint16_t)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		ql_log(ql_log_fatal, vha, 0x0085,
+		    "Unable to verify integrity of firmware image (%Zd).\n",
 		    blob->fw->size);
 		goto fail_fw_integrity;
 	}
@@ -4739,11 +4749,11 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	if ((wcode[0] == 0xffff && wcode[1] == 0xffff && wcode[2] == 0xffff &&
 	    wcode[3] == 0xffff) || (wcode[0] == 0 && wcode[1] == 0 &&
 		wcode[2] == 0 && wcode[3] == 0)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of firmware image!\n");
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware data: %04x %04x %04x %04x!\n", wcode[0],
-		    wcode[1], wcode[2], wcode[3]);
+		ql_log(ql_log_fatal, vha, 0x0086,
+		    "Unable to verify integrity of firmware image.\n");
+		ql_log(ql_log_fatal, vha, 0x0087,
+		    "Firmware data: %04x %04x %04x %04x.\n",
+		    wcode[0], wcode[1], wcode[2], wcode[3]);
 		goto fail_fw_integrity;
 	}
 
@@ -4756,9 +4766,9 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 		/* Validate firmware image size. */
 		fwclen += risc_size * sizeof(uint16_t);
 		if (blob->fw->size < fwclen) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_fatal, vha, 0x0088,
 			    "Unable to verify integrity of firmware image "
-			    "(%Zd)!\n", blob->fw->size);
+			    "(%Zd).\n", blob->fw->size);
 			goto fail_fw_integrity;
 		}
 
@@ -4767,10 +4777,9 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			wlen = (uint16_t)(ha->fw_transfer_size >> 1);
 			if (wlen > risc_size)
 				wlen = risc_size;
-
-			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
-			    "addr %x, number of words 0x%x.\n", vha->host_no,
-			    risc_addr, wlen));
+			ql_dbg(ql_dbg_init, vha, 0x0089,
+			    "Loading risc segment@ risc addr %x number of "
+			    "words 0x%x.\n", risc_addr, wlen);
 
 			for (i = 0; i < wlen; i++)
 				wcode[i] = swab16(fwcode[i]);
@@ -4778,12 +4787,9 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    wlen);
 			if (rval) {
-				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", vha->host_no,
-				    fragment));
-				qla_printk(KERN_WARNING, ha,
-				    "[ERROR] Failed to load segment %d of "
-				    "firmware\n", fragment);
+				ql_log(ql_log_fatal, vha, 0x008a,
+				    "Failed to load segment %d of firmware.\n",
+				    fragment);
 				break;
 			}
 
@@ -4819,15 +4825,17 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	/* Load firmware blob. */
 	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
-		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
-		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
-		    "from: " QLA_FW_URL ".\n");
+		ql_log(ql_log_warn, vha, 0x0090,
+		    "Fimware image unavailable.\n");
+		ql_log(ql_log_warn, vha, 0x0091,
+		    "Firmware images can be retrieved from: "
+		    QLA_FW_URL ".\n");
 
 		return QLA_FUNCTION_FAILED;
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "FW: Loading via request-firmware...\n");
+	ql_log(ql_log_info, vha, 0x0092,
+	    "Loading via request-firmware.\n");
 
 	rval = QLA_SUCCESS;
 
@@ -4839,8 +4847,8 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 
 	/* Validate firmware image by checking version. */
 	if (blob->fw->size < 8 * sizeof(uint32_t)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		ql_log(ql_log_fatal, vha, 0x0093,
+		    "Unable to verify integrity of firmware image (%Zd).\n",
 		    blob->fw->size);
 		goto fail_fw_integrity;
 	}
@@ -4850,11 +4858,12 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		dcode[3] == 0)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of firmware image!\n");
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
-		    dcode[1], dcode[2], dcode[3]);
+		ql_log(ql_log_fatal, vha, 0x0094,
+		    "Unable to verify integrity of firmware image (%Zd).\n",
+		    blob->fw->size);
+		ql_log(ql_log_fatal, vha, 0x0095,
+		    "Firmware data: %08x %08x %08x %08x.\n",
+		    dcode[0], dcode[1], dcode[2], dcode[3]);
 		goto fail_fw_integrity;
 	}
 
@@ -4866,9 +4875,9 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 		/* Validate firmware image size. */
 		fwclen += risc_size * sizeof(uint32_t);
 		if (blob->fw->size < fwclen) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_fatal, vha, 0x0096,
 			    "Unable to verify integrity of firmware image "
-			    "(%Zd)!\n", blob->fw->size);
+			    "(%Zd).\n", blob->fw->size);
 
 			goto fail_fw_integrity;
 		}
@@ -4879,9 +4888,9 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			if (dlen > risc_size)
 				dlen = risc_size;
 
-			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
-			    "addr %x, number of dwords 0x%x.\n", vha->host_no,
-			    risc_addr, dlen));
+			ql_dbg(ql_dbg_init, vha, 0x0097,
+			    "Loading risc segment@ risc addr %x "
+			    "number of dwords 0x%x.\n", risc_addr, dlen);
 
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(fwcode[i]);
@@ -4889,12 +4898,9 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 			rval = qla2x00_load_ram(vha, req->dma, risc_addr,
 			    dlen);
 			if (rval) {
-				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
-				    "segment %d of firmware\n", vha->host_no,
-				    fragment));
-				qla_printk(KERN_WARNING, ha,
-				    "[ERROR] Failed to load segment %d of "
-				    "firmware\n", fragment);
+				ql_log(ql_log_fatal, vha, 0x0098,
+				    "Failed to load segment %d of firmware.\n",
+				    fragment);
 				break;
 			}
 
@@ -4958,14 +4964,13 @@ try_blob_fw:
 	if (rval == QLA_SUCCESS || !ha->flt_region_gold_fw)
 		return rval;
 
-	qla_printk(KERN_ERR, ha,
-	    "FW: Attempting to fallback to golden firmware...\n");
+	ql_log(ql_log_info, vha, 0x0099,
+	    "Attempting to fallback to golden firmware.\n");
 	rval = qla24xx_load_risc_flash(vha, srisc_addr, ha->flt_region_gold_fw);
 	if (rval != QLA_SUCCESS)
 		return rval;
 
-	qla_printk(KERN_ERR, ha,
-	    "FW: Please update operational firmware...\n");
+	ql_log(ql_log_info, vha, 0x009a, "Update operational firmware.\n");
 	ha->flags.running_gold_fw = 1;
 
 	return rval;
@@ -4992,8 +4997,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 			continue;
 		if (qla2x00_setup_chip(vha) != QLA_SUCCESS)
 			continue;
-		qla_printk(KERN_INFO, ha,
-		    "Attempting retry of stop-firmware command...\n");
+		ql_log(ql_log_info, vha, 0x8015,
+		    "Attempting retry of stop-firmware command.\n");
 		ret = qla2x00_stop_firmware(vha);
 	}
 }
@@ -5028,10 +5033,10 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	/* Login to SNS first */
 	ha->isp_ops->fabric_login(vha, NPH_SNS, 0xff, 0xff, 0xfc, mb, BIT_1);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
-		DEBUG15(qla_printk(KERN_INFO, ha,
-		    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
-		    "mb[2]=%x mb[6]=%x mb[7]=%x\n", NPH_SNS,
-		    mb[0], mb[1], mb[2], mb[6], mb[7]));
+		ql_dbg(ql_dbg_init, vha, 0x0103,
+		    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x "
+		    "mb[6]=%x mb[7]=%x.\n",
+		    NPH_SNS, mb[0], mb[1], mb[2], mb[6], mb[7]);
 		return (QLA_FUNCTION_FAILED);
 	}
 
@@ -5151,19 +5156,23 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
 		chksum += le32_to_cpu(*dptr++);
 
-	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", vha->host_no));
-	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
+	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x0111,
+	    "Contents of NVRAM:\n");
+	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0112,
+	    (uint8_t *)nv, ha->nvram_size);
 
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
 	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
-		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
-		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
+		ql_log(ql_log_info, vha, 0x0073,
+		    "Inconisistent NVRAM detected: checksum=0x%x id=%c "
+		    "version=0x%x.\n", chksum, nv->id[0],
 		    le16_to_cpu(nv->nvram_version));
-		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
-		    "invalid -- WWPN) defaults.\n");
+		ql_log(ql_log_info, vha, 0x0074,
+		    "Falling back to functioning (yet invalid -- WWPN) "
+		    "defaults.\n");
 
 		/*
 		 * Set default initialization control block.
@@ -5355,12 +5364,10 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
 		ha->zio_mode = QLA_ZIO_MODE_6;
 
-		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
-		    "(%d us).\n", vha->host_no, ha->zio_mode,
-		    ha->zio_timer * 100));
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0x0075,
 		    "ZIO mode %d enabled; timer delay (%d us).\n",
-		    ha->zio_mode, ha->zio_timer * 100);
+		    ha->zio_mode,
+		    ha->zio_timer * 100);
 
 		icb->firmware_options_2 |= cpu_to_le32(
 		    (uint32_t)ha->zio_mode);
@@ -5369,8 +5376,8 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	}
 
 	if (rval) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x0076,
+		    "NVRAM configuration failed.\n");
 	}
 	return (rval);
 }
@@ -5393,9 +5400,8 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 
 		status = qla2x00_fw_ready(vha);
 		if (!status) {
-			qla_printk(KERN_INFO, ha,
-			"%s(): Start configure loop, "
-			"status = %d\n", __func__, status);
+			ql_log(ql_log_info, vha, 0x803c,
+			    "Start configure loop, status =%d.\n", status);
 
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
@@ -5417,9 +5423,8 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		if ((vha->device_flags & DFLG_NO_CABLE))
 			status = 0;
 
-		qla_printk(KERN_INFO, ha,
-			"%s(): Configure loop done, status = 0x%x\n",
-			__func__, status);
+		ql_log(ql_log_info, vha, 0x803d,
+		    "Configure loop done, status = 0x%x.\n", status);
 	}
 
 	if (!status) {
@@ -5455,9 +5460,9 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 			    ha->fce_dma, ha->fce_bufs, ha->fce_mb,
 			    &ha->fce_bufs);
 			if (rval) {
-				qla_printk(KERN_WARNING, ha,
-				    "Unable to reinitialize FCE "
-				    "(%d).\n", rval);
+				ql_log(ql_log_warn, vha, 0x803e,
+				    "Unable to reinitialize FCE (%d).\n",
+				    rval);
 				ha->flags.fce_enabled = 0;
 			}
 		}
@@ -5467,17 +5472,16 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 			rval = qla2x00_enable_eft_trace(vha,
 			    ha->eft_dma, EFT_NUM_BUFFERS);
 			if (rval) {
-				qla_printk(KERN_WARNING, ha,
-				    "Unable to reinitialize EFT "
-				    "(%d).\n", rval);
+				ql_log(ql_log_warn, vha, 0x803f,
+				    "Unable to reinitialize EFT (%d).\n",
+				    rval);
 			}
 		}
 	}
 
 	if (!status) {
-		DEBUG(printk(KERN_INFO
-			"qla82xx_restart_isp(%ld): succeeded.\n",
-			vha->host_no));
+		ql_dbg(ql_dbg_taskm, vha, 0x8040,
+		    "qla82xx_restart_isp succeeded.\n");
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry(vp, &ha->vp_list, list) {
@@ -5494,8 +5498,8 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	} else {
-		qla_printk(KERN_INFO, ha,
-			"qla82xx_restart_isp: **** FAILED ****\n");
+		ql_log(ql_log_warn, vha, 0x8041,
+		    "qla82xx_restart_isp **** FAILED ****.\n");
 	}
 
 	return status;
@@ -5645,9 +5649,8 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (ret == QLA_SUCCESS)
 		fcport->fcp_prio = priority;
 	else
-		DEBUG2(printk(KERN_WARNING
-			"scsi(%ld): Unable to activate fcp priority, "
-			" ret=0x%x\n", vha->host_no, ret));
+		ql_dbg(ql_dbg_user, vha, 0x704f,
+		    "Unable to activate fcp priority, ret=0x%x.\n", ret);
 
 	return  ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8aa05c8..e02df27 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -141,8 +141,8 @@ MODULE_PARM_DESC(ql2xmultique_tag,
 int ql2xfwloadbin;
 module_param(ql2xfwloadbin, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xfwloadbin,
-		"Option to specify location from which to load ISP firmware:\n"
-		" 2 -- load firmware via the request_firmware() (hotplug)\n"
+		"Option to specify location from which to load ISP firmware:.\n"
+		" 2 -- load firmware via the request_firmware() (hotplug).\n"
 		"      interface.\n"
 		" 1 -- load firmware from flash.\n"
 		" 0 -- use default semantics.\n");
@@ -156,7 +156,7 @@ MODULE_PARM_DESC(ql2xetsenable,
 int ql2xdbwr = 1;
 module_param(ql2xdbwr, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xdbwr,
-	"Option to specify scheme for request queue posting\n"
+	"Option to specify scheme for request queue posting.\n"
 	" 0 -- Regular doorbell.\n"
 	" 1 -- CAMRAM doorbell (faster).\n");
 
@@ -181,7 +181,7 @@ MODULE_PARM_DESC(ql2xasynctmfenable,
 int ql2xdontresethba;
 module_param(ql2xdontresethba, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xdontresethba,
-	"Option to specify reset behaviour\n"
+	"Option to specify reset behaviour.\n"
 	" 0 (Default) -- Reset on failure.\n"
 	" 1 -- Do not reset on failure.\n");
 
@@ -260,8 +260,11 @@ static inline void
 qla2x00_restart_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
 	/* Currently used for 82XX only. */
-	if (vha->device_flags & DFLG_DEV_FAILED)
+	if (vha->device_flags & DFLG_DEV_FAILED) {
+		ql_dbg(ql_dbg_timer, vha, 0x600d,
+		    "Device in a failed state, returning.\n");
 		return;
+	}
 
 	mod_timer(&vha->timer, jiffies + interval * HZ);
 }
@@ -286,19 +289,20 @@ static void qla2x00_sp_free_dma(srb_t *);
 /* -------------------------------------------------------------------------- */
 static int qla2x00_alloc_queues(struct qla_hw_data *ha)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	ha->req_q_map = kzalloc(sizeof(struct req_que *) * ha->max_req_queues,
 				GFP_KERNEL);
 	if (!ha->req_q_map) {
-		qla_printk(KERN_WARNING, ha,
-			"Unable to allocate memory for request queue ptrs\n");
+		ql_log(ql_log_fatal, vha, 0x003b,
+		    "Unable to allocate memory for request queue ptrs.\n");
 		goto fail_req_map;
 	}
 
 	ha->rsp_q_map = kzalloc(sizeof(struct rsp_que *) * ha->max_rsp_queues,
 				GFP_KERNEL);
 	if (!ha->rsp_q_map) {
-		qla_printk(KERN_WARNING, ha,
-			"Unable to allocate memory for response queue ptrs\n");
+		ql_log(ql_log_fatal, vha, 0x003c,
+		    "Unable to allocate memory for response queue ptrs.\n");
 		goto fail_rsp_map;
 	}
 	set_bit(0, ha->rsp_qid_map);
@@ -362,8 +366,8 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!(ha->fw_attributes & BIT_6)) {
-		qla_printk(KERN_INFO, ha,
-			"Firmware is not multi-queue capable\n");
+		ql_log(ql_log_warn, vha, 0x00d8,
+		    "Firmware is not multi-queue capable.\n");
 		goto fail;
 	}
 	if (ql2xmultique_tag) {
@@ -372,8 +376,8 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 		req = qla25xx_create_req_que(ha, options, 0, 0, -1,
 			QLA_DEFAULT_QUE_QOS);
 		if (!req) {
-			qla_printk(KERN_WARNING, ha,
-				"Can't create request queue\n");
+			ql_log(ql_log_warn, vha, 0x00e0,
+			    "Failed to create request queue.\n");
 			goto fail;
 		}
 		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
@@ -382,17 +386,20 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
 			ret = qla25xx_create_rsp_que(ha, options, 0, 0, req);
 			if (!ret) {
-				qla_printk(KERN_WARNING, ha,
-					"Response Queue create failed\n");
+				ql_log(ql_log_warn, vha, 0x00e8,
+				    "Failed to create response queue.\n");
 				goto fail2;
 			}
 		}
 		ha->flags.cpu_affinity_enabled = 1;
-
-		DEBUG2(qla_printk(KERN_INFO, ha,
-			"CPU affinity mode enabled, no. of response"
-			" queues:%d, no. of request queues:%d\n",
-			ha->max_rsp_queues, ha->max_req_queues));
+		ql_dbg(ql_dbg_multiq, vha, 0xc007,
+		    "CPU affinity mode enalbed, "
+		    "no. of response queues:%d no. of request queues:%d.\n",
+		    ha->max_rsp_queues, ha->max_req_queues);
+		ql_dbg(ql_dbg_init, vha, 0x00e9,
+		    "CPU affinity mode enalbed, "
+		    "no. of response queues:%d no. of request queues:%d.\n",
+		    ha->max_rsp_queues, ha->max_req_queues);
 	}
 	return 0;
 fail2:
@@ -539,8 +546,11 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	struct qla_hw_data *ha = vha->hw;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
-	if (!sp)
+	if (!sp) {
+		ql_log(ql_log_warn, vha, 0x3006,
+		    "Memory allocation failed for sp.\n");
 		return sp;
+	}
 
 	atomic_set(&sp->ref_count, 1);
 	sp->fcport = fcport;
@@ -564,30 +574,43 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	int rval;
 
 	if (ha->flags.eeh_busy) {
-		if (ha->flags.pci_channel_io_perm_failure)
+		if (ha->flags.pci_channel_io_perm_failure) {
+			ql_dbg(ql_dbg_io, vha, 0x3001,
+			    "PCI Channel IO permanent failure, exiting "
+			    "cmd=%p.\n", cmd);
 			cmd->result = DID_NO_CONNECT << 16;
-		else
+		} else {
+			ql_dbg(ql_dbg_io, vha, 0x3002,
+			    "EEH_Busy, Requeuing the cmd=%p.\n", cmd);
 			cmd->result = DID_REQUEUE << 16;
+		}
 		goto qc24_fail_command;
 	}
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		cmd->result = rval;
+		ql_dbg(ql_dbg_io, vha, 0x3003,
+		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
+		    cmd, rval);
 		goto qc24_fail_command;
 	}
 
 	if (!vha->flags.difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
-			DEBUG2(qla_printk(KERN_ERR, ha,
-			    "DIF Cap Not Reg, fail DIF capable cmd's:%x\n",
-			    cmd->cmnd[0]));
+			ql_dbg(ql_dbg_io, vha, 0x3004,
+			    "DIF Cap not reg, fail DIF capable cmd's:%p.\n",
+			    cmd);
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 	}
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
+			ql_dbg(ql_dbg_io, vha, 0x3005,
+			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
+			    atomic_read(&fcport->state),
+			    atomic_read(&base_vha->loop_state));
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
@@ -599,8 +622,11 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto qc24_host_busy;
 
 	rval = ha->isp_ops->start_scsi(sp);
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_io, vha, 0x3013,
+		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
 		goto qc24_host_busy_free_sp;
+	}
 
 	return 0;
 
@@ -643,7 +669,8 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
 	int ret = QLA_SUCCESS;
 
 	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
-		DEBUG17(qla_printk(KERN_WARNING, ha, "return:eh_wait\n"));
+		ql_dbg(ql_dbg_taskm, vha, 0x8005,
+		    "Return:eh_wait.\n");
 		return ret;
 	}
 
@@ -736,7 +763,8 @@ qla2x00_wait_for_reset_ready(scsi_qla_host_t *vha)
 	else
 		return_status = QLA_FUNCTION_FAILED;
 
-	DEBUG2(printk("%s return_status=%d\n", __func__, return_status));
+	ql_dbg(ql_dbg_taskm, vha, 0x8019,
+	    "%s return status=%d.\n", __func__, return_status);
 
 	return return_status;
 }
@@ -844,10 +872,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_taskm, vha, 0x8000,
+	    "Entered %s for cmd=%p.\n", __func__, cmd);
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
 	ret = fc_block_scsi_eh(cmd);
+	ql_dbg(ql_dbg_taskm, vha, 0x8001,
+	    "Return value of fc_block_scsi_eh=%d.\n", ret);
 	if (ret != 0)
 		return ret;
 	ret = SUCCESS;
@@ -862,20 +894,19 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return SUCCESS;
 	}
 
-	DEBUG2(printk("%s(%ld): aborting sp %p from RISC.",
-	    __func__, vha->host_no, sp));
+	ql_dbg(ql_dbg_taskm, vha, 0x8002,
+	    "Aborting sp=%p cmd=%p from RISC ", sp, cmd);
 
 	/* Get a reference to the sp and drop the lock.*/
 	sp_get(sp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (ha->isp_ops->abort_command(sp)) {
-		DEBUG2(printk("%s(%ld): abort_command "
-		"mbx failed.\n", __func__, vha->host_no));
-		ret = FAILED;
+		ql_dbg(ql_dbg_taskm, vha, 0x8003,
+		    "Abort command mbx failed for cmd=%p.\n", cmd);
 	} else {
-		DEBUG3(printk("%s(%ld): abort_command "
-		"mbx success.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_taskm, vha, 0x8004,
+		    "Abort command mbx success.\n");
 		wait = 1;
 	}
 	qla2x00_sp_compl(ha, sp);
@@ -883,16 +914,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	/* Wait for the command to be returned. */
 	if (wait) {
 		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
-			qla_printk(KERN_ERR, ha,
-			    "scsi(%ld:%d:%d): Abort handler timed out -- %x.\n",
-			    vha->host_no, id, lun, ret);
+			ql_log(ql_log_warn, vha, 0x8006,
+			    "Abort handler timed out for cmd=%p.\n", cmd);
 			ret = FAILED;
 		}
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): Abort command issued -- %d %x.\n",
-	    vha->host_no, id, lun, wait, ret);
+	ql_log(ql_log_info, vha, 0x801c,
+	    "Abort command issued --  %d %x.\n", wait, ret);
 
 	return ret;
 }
@@ -960,40 +989,59 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
-	if (!fcport)
+	if (!fcport) {
+		ql_log(ql_log_warn, vha, 0x8007,
+		    "fcport is NULL.\n");
 		return FAILED;
+	}
 
 	err = fc_block_scsi_eh(cmd);
+	ql_dbg(ql_dbg_taskm, vha, 0x8008,
+	    "fc_block_scsi_eh ret=%d.\n", err);
 	if (err != 0)
 		return err;
 
-	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
-	    vha->host_no, cmd->device->id, cmd->device->lun, name);
+	ql_log(ql_log_info, vha, 0x8009,
+	    "%s RESET ISSUED for id %d lun %d cmd=%p.\n", name,
+	    cmd->device->id, cmd->device->lun, cmd);
 
 	err = 0;
-	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800a,
+		    "Wait for hba online failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
+	}
 	err = 1;
-	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800b,
+		    "Wait for loop ready failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
+	}
 	err = 2;
 	if (do_reset(fcport, cmd->device->lun, cmd->request->cpu + 1)
-		!= QLA_SUCCESS)
+		!= QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800c,
+		    "do_reset failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
+	}
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, type) != QLA_SUCCESS)
+	    cmd->device->lun, type) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800d,
+		    "wait for peding cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
+	}
 
-	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
-	    vha->host_no, cmd->device->id, cmd->device->lun, name);
+	ql_log(ql_log_info, vha, 0x800e,
+	    "%s RESET SUCCEEDED for id %d lun %d cmd=%p.\n", name,
+	    cmd->device->id, cmd->device->lun, cmd);
 
 	return SUCCESS;
 
 eh_reset_failed:
-	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n"
-	    , vha->host_no, cmd->device->id, cmd->device->lun, name,
-	    reset_errors[err]);
+	ql_log(ql_log_info, vha, 0x800f,
+	    "%s RESET FAILED: %s for id %d lun %d cmd=%p.\n", name,
+	    reset_errors[err], cmd->device->id, cmd->device->lun);
 	return FAILED;
 }
 
@@ -1043,19 +1091,25 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
-	if (!fcport)
+	if (!fcport) {
+		ql_log(ql_log_warn, vha, 0x8010,
+		    "fcport is NULL.\n");
 		return ret;
+	}
 
 	ret = fc_block_scsi_eh(cmd);
+	ql_dbg(ql_dbg_taskm, vha, 0x8011,
+	    "fc_block_scsi_eh ret=%d.\n", ret);
 	if (ret != 0)
 		return ret;
 	ret = FAILED;
 
-	qla_printk(KERN_INFO, vha->hw,
-	    "scsi(%ld:%d:%d): BUS RESET ISSUED.\n", vha->host_no, id, lun);
+	ql_log(ql_log_info, vha, 0x8012,
+	    "BUS RESET ISSUED for id %d lun %d.\n", id, lun);
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
-		DEBUG2(printk("%s failed:board disabled\n",__func__));
+		ql_log(ql_log_fatal, vha, 0x8013,
+		    "Wait for hba online failed board disabled.\n");
 		goto eh_bus_reset_done;
 	}
 
@@ -1068,12 +1122,15 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 
 	/* Flush outstanding commands. */
 	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) !=
-	    QLA_SUCCESS)
+	    QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x8014,
+		    "Wait for pending commands failed.\n");
 		ret = FAILED;
+	}
 
 eh_bus_reset_done:
-	qla_printk(KERN_INFO, vha->hw, "%s: reset %s\n", __func__,
-	    (ret == FAILED) ? "failed" : "succeeded");
+	ql_log(ql_log_warn, vha, 0x802b,
+	    "BUS RESET %s.\n", (ret == FAILED) ? "FAILED" : "SUCCEDED");
 
 	return ret;
 }
@@ -1106,16 +1163,21 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
-	if (!fcport)
+	if (!fcport) {
+		ql_log(ql_log_warn, vha, 0x8016,
+		    "fcport is NULL.\n");
 		return ret;
+	}
 
 	ret = fc_block_scsi_eh(cmd);
+	ql_dbg(ql_dbg_taskm, vha, 0x8017,
+	    "fc_block_scsi_eh ret=%d.\n", ret);
 	if (ret != 0)
 		return ret;
 	ret = FAILED;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
+	ql_log(ql_log_info, vha, 0x8018,
+	    "ADAPTER RESET ISSUED for id %d lun %d.\n", id, lun);
 
 	if (qla2x00_wait_for_reset_ready(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
@@ -1150,8 +1212,11 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 			/* failed. schedule dpc to try */
 			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 
-			if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+			if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+				ql_log(ql_log_warn, vha, 0x802a,
+				    "wait for hba online failed.\n");
 				goto eh_host_reset_lock;
+			}
 		}
 		clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	}
@@ -1162,7 +1227,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		ret = SUCCESS;
 
 eh_host_reset_lock:
-	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
+	qla_printk(KERN_INFO, ha, "%s: reset %s.\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeeded");
 
 	return ret;
@@ -1192,9 +1257,9 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 
 			ret = ha->isp_ops->target_reset(fcport, 0, 0);
 			if (ret != QLA_SUCCESS) {
-				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
-				    "target_reset=%d d_id=%x.\n", __func__,
-				    vha->host_no, ret, fcport->d_id.b24));
+				ql_dbg(ql_dbg_taskm, vha, 0x802c,
+				    "Bus Reset failed: Target Reset=%d "
+				    "d_id=%x.\n", ret, fcport->d_id.b24);
 			}
 		}
 	}
@@ -1202,9 +1267,8 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	if (ha->flags.enable_lip_full_login && !IS_QLA8XXX_TYPE(ha)) {
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
-			DEBUG2_3(printk("%s(%ld): failed: "
-			    "full_login_lip=%d.\n", __func__, vha->host_no,
-			    ret));
+			ql_dbg(ql_dbg_taskm, vha, 0x802d,
+			    "full_login_lip=%d.\n", ret);
 		}
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
@@ -1215,8 +1279,8 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	if (ha->flags.enable_lip_reset) {
 		ret = qla2x00_lip_reset(vha);
 		if (ret != QLA_SUCCESS) {
-			DEBUG2_3(printk("%s(%ld): failed: "
-			    "lip_reset=%d.\n", __func__, vha->host_no, ret));
+			ql_dbg(ql_dbg_taskm, vha, 0x802e,
+			    "lip_reset failed (%d).\n", ret);
 		} else
 			qla2x00_wait_for_loop_ready(vha);
 	}
@@ -1315,17 +1379,17 @@ static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
 	if (!scsi_track_queue_full(sdev, qdepth))
 		return;
 
-	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
-		"scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
-		fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
-		sdev->queue_depth));
+	ql_dbg(ql_dbg_io, fcport->vha, 0x3029,
+	    "Queue depth adjusted-down "
+	    "to %d for scsi(%ld:%d:%d:%d).\n",
+	    sdev->queue_depth, fcport->vha->host_no,
+	    sdev->channel, sdev->id, sdev->lun);
 }
 
 static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
 {
 	fc_port_t *fcport = sdev->hostdata;
 	struct scsi_qla_host *vha = fcport->vha;
-	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 
 	req = vha->req;
@@ -1340,10 +1404,11 @@ static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
 	else
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
 
-	DEBUG2(qla_printk(KERN_INFO, ha,
-	       "scsi(%ld:%d:%d:%d): Queue depth adjusted-up to %d.\n",
-	       fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
-	       sdev->queue_depth));
+	ql_dbg(ql_dbg_io, vha, 0x302a,
+	    "Queue depth adjusted-up to %d for "
+	    "scsi(%ld:%d:%d:%d).\n",
+	    sdev->queue_depth, fcport->vha->host_no,
+	    sdev->channel, sdev->id, sdev->lun);
 }
 
 static int
@@ -1789,6 +1854,9 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->flags.port0 = 1;
 	else
 		ha->flags.port0 = 0;
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
+	    "device_type=0x%x port=%d fw_srisc_address=%p.\n",
+	    ha->device_type, ha->flags.port0, ha->fw_srisc_address);
 }
 
 static int
@@ -1803,10 +1871,9 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 
 	if (pci_request_selected_regions(ha->pdev, ha->bars,
 	    QLA2XXX_DRIVER_NAME)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to reserve PIO/MMIO regions (%s)\n",
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0011,
+		    "Failed to reserve PIO/MMIO regions (%s), aborting.\n",
 		    pci_name(ha->pdev));
-
 		goto iospace_error_exit;
 	}
 	if (!(ha->bars & 1))
@@ -1816,39 +1883,42 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 	pio = pci_resource_start(ha->pdev, 0);
 	if (pci_resource_flags(ha->pdev, 0) & IORESOURCE_IO) {
 		if (pci_resource_len(ha->pdev, 0) < MIN_IOBASE_LEN) {
-			qla_printk(KERN_WARNING, ha,
-			    "Invalid PCI I/O region size (%s)...\n",
-				pci_name(ha->pdev));
+			ql_log_pci(ql_log_warn, ha->pdev, 0x0012,
+			    "Invalid pci I/O region size (%s).\n",
+			    pci_name(ha->pdev));
 			pio = 0;
 		}
 	} else {
-		qla_printk(KERN_WARNING, ha,
-		    "region #0 not a PIO resource (%s)...\n",
+		ql_log_pci(ql_log_warn, ha->pdev, 0x0013,
+		    "Region #0 no a PIO resource (%s).\n",
 		    pci_name(ha->pdev));
 		pio = 0;
 	}
 	ha->pio_address = pio;
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0014,
+	    "PIO address=%p.\n",
+	    ha->pio_address);
 
 skip_pio:
 	/* Use MMIO operations for all accesses. */
 	if (!(pci_resource_flags(ha->pdev, 1) & IORESOURCE_MEM)) {
-		qla_printk(KERN_ERR, ha,
-		    "region #1 not an MMIO resource (%s), aborting\n",
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0015,
+		    "Region #1 not an MMIO resource (%s), aborting.\n",
 		    pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
 	if (pci_resource_len(ha->pdev, 1) < MIN_IOBASE_LEN) {
-		qla_printk(KERN_ERR, ha,
-		    "Invalid PCI mem region size (%s), aborting\n",
-			pci_name(ha->pdev));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0016,
+		    "Invalid PCI mem region size (%s), aborting.\n",
+		    pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
 
 	ha->iobase = ioremap(pci_resource_start(ha->pdev, 1), MIN_IOBASE_LEN);
 	if (!ha->iobase) {
-		qla_printk(KERN_ERR, ha,
-		    "cannot remap MMIO (%s), aborting\n", pci_name(ha->pdev));
-
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0017,
+		    "Cannot remap MMIO (%s), aborting.\n",
+		    pci_name(ha->pdev));
 		goto iospace_error_exit;
 	}
 
@@ -1862,6 +1932,8 @@ skip_pio:
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
 			pci_resource_len(ha->pdev, 3));
 	if (ha->mqiobase) {
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0018,
+		    "MQIO Base=%p.\n", ha->mqiobase);
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
 		ha->msix_count = msix;
@@ -1874,17 +1946,24 @@ skip_pio:
 			ha->max_req_queues = 2;
 		} else if (ql2xmaxqueues > 1) {
 			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
-						QLA_MQ_SIZE : ql2xmaxqueues;
-			DEBUG2(qla_printk(KERN_INFO, ha, "QoS mode set, max no"
-			" of request queues:%d\n", ha->max_req_queues));
+			    QLA_MQ_SIZE : ql2xmaxqueues;
+			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc008,
+			    "QoS mode set, max no of request queues:%d.\n",
+			    ha->max_req_queues);
+			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0019,
+			    "QoS mode set, max no of request queues:%d.\n",
+			    ha->max_req_queues);
 		}
-		qla_printk(KERN_INFO, ha,
-			"MSI-X vector count: %d\n", msix);
+		ql_log_pci(ql_log_info, ha->pdev, 0x001a,
+		    "MSI-X vector count: %d.\n", msix);
 	} else
-		qla_printk(KERN_INFO, ha, "BAR 3 not enabled\n");
+		ql_log_pci(ql_log_info, ha->pdev, 0x001b,
+		    "BAR 3 not enabled.\n");
 
 mqiobase_exit:
 	ha->msix_count = ha->max_rsp_queues + 1;
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x001c,
+	    "MSIX Count:%d.\n", ha->msix_count);
 	return (0);
 
 iospace_error_exit:
@@ -1948,7 +2027,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8021) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		mem_only = 1;
+		ql_dbg_pci(ql_dbg_init, pdev, 0x0007,
+		    "Mem only adapter.\n");
 	}
+	ql_dbg_pci(ql_dbg_init, pdev, 0x0008,
+	    "Bars=%d.\n", bars);
 
 	if (mem_only) {
 		if (pci_enable_device_mem(pdev))
@@ -1963,9 +2046,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ha = kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
 	if (!ha) {
-		DEBUG(printk("Unable to allocate memory for ha\n"));
+		ql_log_pci(ql_log_fatal, pdev, 0x0009,
+		    "Unable to allocate memory for ha.\n");
 		goto probe_out;
 	}
+	ql_dbg_pci(ql_dbg_init, pdev, 0x000a,
+	    "Memory allocated for ha=%p.\n", ha);
 	ha->pdev = pdev;
 
 	/* Clear our data area */
@@ -1987,10 +2073,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_hw_failed;
 
-	qla_printk(KERN_INFO, ha,
-	    "Found an ISP%04X, irq %d, iobase 0x%p\n", pdev->device, pdev->irq,
-	    ha->iobase);
-
+	ql_log_pci(ql_log_info, pdev, 0x001d,
+	    "Found an ISP%04X irq %d iobase 0x%p.\n",
+	    pdev->device, pdev->irq, ha->iobase);
 	ha->prev_topology = 0;
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
@@ -2091,7 +2176,18 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->nvram_conf_off = FARX_ACCESS_NVRAM_CONF;
 		ha->nvram_data_off = FARX_ACCESS_NVRAM_DATA;
 	}
-
+	ql_dbg_pci(ql_dbg_init, pdev, 0x001e,
+	    "mbx_count=%d, req_length=%d, "
+	    "rsp_length=%d, max_loop_id=%d, init_cb_size=%d, "
+	    "gid_list_info_size=%d, optrom_size=%d, nvram_npiv_size=%d, .\n",
+	    ha->mbx_count, req_length, rsp_length, ha->max_loop_id,
+	    ha->init_cb_size, ha->gid_list_info_size, ha->optrom_size,
+	    ha->nvram_npiv_size);
+	ql_dbg_pci(ql_dbg_init, pdev, 0x001f,
+	    "isp_ops=%p, flash_conf_off=%d, "
+	    "flash_data_off=%d, nvram_conf_off=%d, nvram_data_off=%d.\n",
+	    ha->isp_ops, ha->flash_conf_off, ha->flash_data_off,
+	    ha->nvram_conf_off, ha->nvram_data_off);
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
@@ -2101,10 +2197,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
 	qla2x00_config_dma_addressing(ha);
+	ql_dbg_pci(ql_dbg_init, pdev, 0x0020,
+	    "64 Bit addressing is %s.\n",
+	    ha->flags.enable_64bit_addressing ? "enable" :
+	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
 	if (!ret) {
-		qla_printk(KERN_WARNING, ha,
-		    "[ERROR] Failed to allocate memory for adapter\n");
+		ql_log_pci(ql_log_fatal, pdev, 0x0031,
+		    "Failed to allocate memory for adapter, aborting.\n");
 
 		goto probe_hw_failed;
 	}
@@ -2116,9 +2216,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	base_vha = qla2x00_create_host(sht, ha);
 	if (!base_vha) {
-		qla_printk(KERN_WARNING, ha,
-		    "[ERROR] Failed to allocate memory for scsi_host\n");
-
 		ret = -ENOMEM;
 		qla2x00_mem_free(ha);
 		qla2x00_free_req_que(ha, req);
@@ -2145,7 +2242,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!IS_QLA82XX(ha))
 			host->sg_tablesize = QLA_SG_ALL;
 	}
-
+	ql_dbg(ql_dbg_init, base_vha, 0x0032,
+	    "can_queue=%d, req=%p, "
+	    "mgmt_svr_loop_id=%d, sg_tablesize=%d.\n",
+	    host->can_queue, base_vha->req,
+	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 	host->max_id = max_id;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
@@ -2159,6 +2260,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
+	ql_dbg(ql_dbg_init, base_vha, 0x0033,
+	    "max_id=%d this_id=%d "
+	    "cmd_per_len=%d unique_id=%d max_cmd_len=%d max_channel=%d "
+	    "max_lun=%d transportt=%p, vendor_id=%d.\n", host->max_id,
+	    host->this_id, host->cmd_per_lun, host->unique_id,
+	    host->max_cmd_len, host->max_channel, host->max_lun,
+	    host->transportt, sht->vendor_id);
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -2169,9 +2278,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Alloc arrays of request and response ring ptrs */
 que_init:
 	if (!qla2x00_alloc_queues(ha)) {
-		qla_printk(KERN_WARNING, ha,
-		"[ERROR] Failed to allocate memory for queue"
-		" pointers\n");
+		ql_log(ql_log_fatal, base_vha, 0x003d,
+		    "Failed to allocate memory for queue pointers.. aborting.\n");
 		goto probe_init_failed;
 	}
 
@@ -2199,20 +2307,33 @@ que_init:
 		rsp->rsp_q_out = &ha->iobase->isp82.rsp_q_out[0];
 	}
 
-	if (qla2x00_initialize_adapter(base_vha)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to initialize adapter\n");
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc009,
+	    "rsp_q_map=%p req_q_map=%p rsp->req=%p req->rsp=%p.\n",
+	    ha->rsp_q_map, ha->req_q_map, rsp->req, req->rsp);
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc00a,
+	    "req->req_q_in=%p req->req_q_out=%p "
+	    "rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
+	    req->req_q_in, req->req_q_out,
+	    rsp->rsp_q_in, rsp->rsp_q_out);
+	ql_dbg(ql_dbg_init, base_vha, 0x003e,
+	    "rsp_q_map=%p req_q_map=%p rsp->req=%p req->rsp=%p.\n",
+	    ha->rsp_q_map, ha->req_q_map, rsp->req, req->rsp);
+	ql_dbg(ql_dbg_init, base_vha, 0x003f,
+	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
+	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
-		DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
-		    "Adapter flags %x.\n",
-		    base_vha->host_no, base_vha->device_flags));
+	if (qla2x00_initialize_adapter(base_vha)) {
+		ql_log(ql_log_fatal, base_vha, 0x00d6,
+		    "Failed to initialize adapter - Adapter flags %x.\n",
+		    base_vha->device_flags);
 
 		if (IS_QLA82XX(ha)) {
 			qla82xx_idc_lock(ha);
 			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 				QLA82XX_DEV_FAILED);
 			qla82xx_idc_unlock(ha);
-			qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+			ql_log(ql_log_fatal, base_vha, 0x00d7,
+			    "HW State: FAILED.\n");
 		}
 
 		ret = -ENODEV;
@@ -2221,9 +2342,8 @@ que_init:
 
 	if (ha->mqenable) {
 		if (qla25xx_setup_mode(base_vha)) {
-			qla_printk(KERN_WARNING, ha,
-				"Can't create queues, falling back to single"
-				" queue mode\n");
+			ql_log(ql_log_warn, base_vha, 0x00ec,
+			    "Failed to create queues, falling back to single queue mode.\n");
 			goto que_init;
 		}
 	}
@@ -2235,13 +2355,15 @@ que_init:
 	 * Startup the kernel thread for this host adapter
 	 */
 	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
-			"%s_dpc", base_vha->host_str);
+	    "%s_dpc", base_vha->host_str);
 	if (IS_ERR(ha->dpc_thread)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to start DPC thread!\n");
+		ql_log(ql_log_fatal, base_vha, 0x00ed,
+		    "Failed to start DPC thread.\n");
 		ret = PTR_ERR(ha->dpc_thread);
 		goto probe_failed;
 	}
+	ql_dbg(ql_dbg_init, base_vha, 0x00ee,
+	    "DPC thread started successfully.\n");
 
 skip_dpc:
 	list_add_tail(&base_vha->list, &ha->vp_list);
@@ -2249,16 +2371,18 @@ skip_dpc:
 
 	/* Initialized the timer */
 	qla2x00_start_timer(base_vha, qla2x00_timer, WATCH_INTERVAL);
-
-	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
-	    base_vha->host_no, ha));
+	ql_dbg(ql_dbg_init, base_vha, 0x00ef,
+	    "Started qla2x00_timer with "
+	    "interval=%d.\n", WATCH_INTERVAL);
+	ql_dbg(ql_dbg_init, base_vha, 0x00f0,
+	    "Detected hba at address=%p.\n",
+	    ha);
 
 	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
 			base_vha->flags.difdix_supported = 1;
-			DEBUG18(qla_printk(KERN_INFO, ha,
-			    "Registering for DIF/DIX type 1 and 3"
-			    " protection.\n"));
+			ql_dbg(ql_dbg_init, base_vha, 0x00f1,
+			    "Registering for DIF/DIX type 1 and 3 protection.\n");
 			scsi_host_set_prot(host,
 			    SHOST_DIF_TYPE1_PROTECTION
 			    | SHOST_DIF_TYPE2_PROTECTION
@@ -2280,6 +2404,9 @@ skip_dpc:
 	base_vha->flags.init_done = 1;
 	base_vha->flags.online = 1;
 
+	ql_dbg(ql_dbg_init, base_vha, 0x00f2,
+	    "Init done and hba is online.\n");
+
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(base_vha);
@@ -2288,14 +2415,17 @@ skip_dpc:
 
 	qla2x00_dfs_setup(base_vha);
 
-	qla_printk(KERN_INFO, ha, "\n"
-	    " QLogic Fibre Channel HBA Driver: %s\n"
-	    "  QLogic %s - %s\n"
-	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
-	    qla2x00_version_str, ha->model_number,
-	    ha->model_desc ? ha->model_desc : "", pdev->device,
-	    ha->isp_ops->pci_info_str(base_vha, pci_info), pci_name(pdev),
-	    ha->flags.enable_64bit_addressing ? '+' : '-', base_vha->host_no,
+	ql_log(ql_log_info, base_vha, 0x00fa,
+	    "QLogic Fibre Channed HBA Driver: %s.\n",
+	    qla2x00_version_str);
+	ql_log(ql_log_info, base_vha, 0x00fb,
+	    "QLogic %s - %s.\n",
+	    ha->model_number, ha->model_desc ? ha->model_desc : "");
+	ql_log(ql_log_info, base_vha, 0x00fc,
+	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
+	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
+	    pci_name(pdev), ha->flags.enable_64bit_addressing ? '+' : '-',
+	    base_vha->host_no,
 	    ha->isp_ops->fw_version_str(base_vha, fw_str));
 
 	return 0;
@@ -2593,20 +2723,15 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 		fcport->login_retry = vha->hw->login_retry_count;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
-		DEBUG(printk("scsi(%ld): Port login retry: "
+		ql_dbg(ql_dbg_disc, vha, 0x2067,
+		    "Port login retry "
 		    "%02x%02x%02x%02x%02x%02x%02x%02x, "
-		    "id = 0x%04x retry cnt=%d\n",
-		    vha->host_no,
-		    fcport->port_name[0],
-		    fcport->port_name[1],
-		    fcport->port_name[2],
-		    fcport->port_name[3],
-		    fcport->port_name[4],
-		    fcport->port_name[5],
-		    fcport->port_name[6],
-		    fcport->port_name[7],
-		    fcport->loop_id,
-		    fcport->login_retry));
+		    "id = 0x%04x retry cnt=%d.\n",
+		    fcport->port_name[0], fcport->port_name[1],
+		    fcport->port_name[2], fcport->port_name[3],
+		    fcport->port_name[4], fcport->port_name[5],
+		    fcport->port_name[6], fcport->port_name[7],
+		    fcport->loop_id, fcport->login_retry);
 	}
 }
 
@@ -2689,6 +2814,9 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 			ctx_cachep);
 		if (!ha->ctx_mempool)
 			goto fail_free_srb_mempool;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0021,
+		    "ctx_cachep=%p ctx_mempool=%p.\n",
+		    ctx_cachep, ha->ctx_mempool);
 	}
 
 	/* Get memory for cached NVRAM */
@@ -2703,22 +2831,29 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->s_dma_pool)
 		goto fail_free_nvram;
 
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0022,
+	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
+	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
+
 	if (IS_QLA82XX(ha) || ql2xenabledif) {
 		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			DSD_LIST_DMA_POOL_SIZE, 8, 0);
 		if (!ha->dl_dma_pool) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - dl_dma_pool\n");
+			ql_log_pci(ql_log_fatal, ha->pdev, 0x0023,
+			    "Failed to allocate memory for dl_dma_pool.\n");
 			goto fail_s_dma_pool;
 		}
 
 		ha->fcp_cmnd_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			FCP_CMND_DMA_POOL_SIZE, 8, 0);
 		if (!ha->fcp_cmnd_dma_pool) {
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - fcp_cmnd_dma_pool\n");
+			ql_log_pci(ql_log_fatal, ha->pdev, 0x0024,
+			    "Failed to allocate memory for fcp_cmnd_dma_pool.\n");
 			goto fail_dl_dma_pool;
 		}
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0025,
+		    "dl_dma_pool=%p fcp_cmnd_dma_pool=%p.\n",
+		    ha->dl_dma_pool, ha->fcp_cmnd_dma_pool);
 	}
 
 	/* Allocate memory for SNS commands */
@@ -2728,6 +2863,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma, GFP_KERNEL);
 		if (!ha->sns_cmd)
 			goto fail_dma_pool;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0026,
+		    "sns_cmd.\n", ha->sns_cmd);
 	} else {
 	/* Get consistent memory allocated for MS IOCB */
 		ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
@@ -2739,12 +2876,16 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 			sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
 		if (!ha->ct_sns)
 			goto fail_free_ms_iocb;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0027,
+		    "ms_iocb=%p ct_sns=%p.\n",
+		    ha->ms_iocb, ha->ct_sns);
 	}
 
 	/* Allocate memory for request ring */
 	*req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
 	if (!*req) {
-		DEBUG(printk("Unable to allocate memory for req\n"));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0028,
+		    "Failed to allocate memory for req.\n");
 		goto fail_req;
 	}
 	(*req)->length = req_len;
@@ -2752,14 +2893,15 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		((*req)->length + 1) * sizeof(request_t),
 		&(*req)->dma, GFP_KERNEL);
 	if (!(*req)->ring) {
-		DEBUG(printk("Unable to allocate memory for req_ring\n"));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0029,
+		    "Failed to allocate memory for req_ring.\n");
 		goto fail_req_ring;
 	}
 	/* Allocate memory for response ring */
 	*rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
 	if (!*rsp) {
-		qla_printk(KERN_WARNING, ha,
-			"Unable to allocate memory for rsp\n");
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x002a,
+		    "Failed to allocate memory for rsp.\n");
 		goto fail_rsp;
 	}
 	(*rsp)->hw = ha;
@@ -2768,19 +2910,24 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		((*rsp)->length + 1) * sizeof(response_t),
 		&(*rsp)->dma, GFP_KERNEL);
 	if (!(*rsp)->ring) {
-		qla_printk(KERN_WARNING, ha,
-			"Unable to allocate memory for rsp_ring\n");
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x002b,
+		    "Failed to allocate memory for rsp_ring.\n");
 		goto fail_rsp_ring;
 	}
 	(*req)->rsp = *rsp;
 	(*rsp)->req = *req;
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002c,
+	    "req=%p req->length=%d req->ring=%p rsp=%p "
+	    "rsp->length=%d rsp->ring=%p.\n",
+	    *req, (*req)->length, (*req)->ring, *rsp, (*rsp)->length,
+	    (*rsp)->ring);
 	/* Allocate memory for NVRAM data for vports */
 	if (ha->nvram_npiv_size) {
 		ha->npiv_info = kzalloc(sizeof(struct qla_npiv_entry) *
-					ha->nvram_npiv_size, GFP_KERNEL);
+		    ha->nvram_npiv_size, GFP_KERNEL);
 		if (!ha->npiv_info) {
-			qla_printk(KERN_WARNING, ha,
-				"Unable to allocate memory for npiv info\n");
+			ql_log_pci(ql_log_fatal, ha->pdev, 0x002d,
+			    "Failed to allocate memory for npiv_info.\n");
 			goto fail_npiv_info;
 		}
 	} else
@@ -2792,6 +2939,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		    &ha->ex_init_cb_dma);
 		if (!ha->ex_init_cb)
 			goto fail_ex_init_cb;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002e,
+		    "ex_init_cb=%p.\n", ha->ex_init_cb);
 	}
 
 	INIT_LIST_HEAD(&ha->gbl_dsd_list);
@@ -2802,6 +2951,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 			&ha->async_pd_dma);
 		if (!ha->async_pd)
 			goto fail_async_pd;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002f,
+		    "async_pd=%p.\n", ha->async_pd);
 	}
 
 	INIT_LIST_HEAD(&ha->vp_list);
@@ -2867,7 +3018,8 @@ fail_free_init_cb:
 	ha->init_cb = NULL;
 	ha->init_cb_dma = 0;
 fail:
-	DEBUG(printk("%s: Memory allocation failure\n", __func__));
+	ql_log(ql_log_fatal, NULL, 0x0030,
+	    "Memory allocation failure.\n");
 	return -ENOMEM;
 }
 
@@ -3016,8 +3168,8 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
-		printk(KERN_WARNING
-		"qla2xxx: Couldn't allocate host from scsi layer!\n");
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0107,
+		    "Failed to allocate host from the scsi layer, aborting.\n");
 		goto fail;
 	}
 
@@ -3036,6 +3188,11 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	spin_lock_init(&vha->work_lock);
 
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
+	ql_dbg(ql_dbg_init, vha, 0x0041,
+	    "Allocated the host=%p hw=%p vha=%p dev_name=%s",
+	    vha->host, vha->hw, vha,
+	    dev_name(&(ha->pdev->dev)));
+
 	return vha;
 
 fail:
@@ -3277,18 +3434,18 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 			if (status == QLA_SUCCESS) {
 				fcport->old_loop_id = fcport->loop_id;
 
-				DEBUG(printk("scsi(%ld): port login OK: logged "
-				"in ID 0x%x\n", vha->host_no, fcport->loop_id));
+				ql_dbg(ql_dbg_disc, vha, 0x2003,
+				    "Port login OK: logged in ID 0x%x.\n",
+				    fcport->loop_id);
 
 				qla2x00_update_fcport(vha, fcport);
 
 			} else if (status == 1) {
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				/* retry the login again */
-				DEBUG(printk("scsi(%ld): Retrying"
-				" %d login again loop_id 0x%x\n",
-				vha->host_no, fcport->login_retry,
-						fcport->loop_id));
+				ql_dbg(ql_dbg_disc, vha, 0x2007,
+				    "Retrying %d login again loop_id 0x%x.\n",
+				    fcport->login_retry, fcport->loop_id);
 			} else {
 				fcport->login_retry = 0;
 			}
@@ -3328,26 +3485,27 @@ qla2x00_do_dpc(void *data)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
+		ql_dbg(ql_dbg_dpc, base_vha, 0x4000,
+		    "DPC handler sleeping.\n");
 
 		schedule();
 		__set_current_state(TASK_RUNNING);
 
-		DEBUG3(printk("qla2x00: DPC handler waking up\n"));
+		ql_dbg(ql_dbg_dpc, base_vha, 0x4001,
+		    "DPC handler waking up.\n");
+		ql_dbg(ql_dbg_dpc, base_vha, 0x4002,
+		    "dpc_flags=0x%lx.\n", base_vha->dpc_flags);
 
 		/* Initialization not yet finished. Don't do anything yet. */
 		if (!base_vha->flags.init_done)
 			continue;
 
 		if (ha->flags.eeh_busy) {
-			DEBUG17(qla_printk(KERN_WARNING, ha,
-			    "qla2x00_do_dpc: dpc_flags: %lx\n",
-			    base_vha->dpc_flags));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x4003,
+			    "eeh_busy=%d.\n", ha->flags.eeh_busy);
 			continue;
 		}
 
-		DEBUG3(printk("scsi(%ld): DPC handler\n", base_vha->host_no));
-
 		ha->dpc_active = 1;
 
 		if (ha->flags.mbox_busy) {
@@ -3364,8 +3522,8 @@ qla2x00_do_dpc(void *data)
 				qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 					QLA82XX_DEV_FAILED);
 				qla82xx_idc_unlock(ha);
-				qla_printk(KERN_INFO, ha,
-					"HW State: FAILED\n");
+				ql_log(ql_log_info, base_vha, 0x4004,
+				    "HW State: FAILED.\n");
 				qla82xx_device_state_handler(base_vha);
 				continue;
 			}
@@ -3373,10 +3531,8 @@ qla2x00_do_dpc(void *data)
 			if (test_and_clear_bit(FCOE_CTX_RESET_NEEDED,
 				&base_vha->dpc_flags)) {
 
-				DEBUG(printk(KERN_INFO
-					"scsi(%ld): dpc: sched "
-					"qla82xx_fcoe_ctx_reset ha = %p\n",
-					base_vha->host_no, ha));
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4005,
+				    "FCoE context reset scheduled.\n");
 				if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
 					&base_vha->dpc_flags))) {
 					if (qla82xx_fcoe_ctx_reset(base_vha)) {
@@ -3390,18 +3546,16 @@ qla2x00_do_dpc(void *data)
 						&base_vha->dpc_flags);
 				}
 
-				DEBUG(printk("scsi(%ld): dpc:"
-					" qla82xx_fcoe_ctx_reset end\n",
-					base_vha->host_no));
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4006,
+				    "FCoE context reset end.\n");
 			}
 		}
 
 		if (test_and_clear_bit(ISP_ABORT_NEEDED,
 						&base_vha->dpc_flags)) {
 
-			DEBUG(printk("scsi(%ld): dpc: sched "
-			    "qla2x00_abort_isp ha = %p\n",
-			    base_vha->host_no, ha));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
+			    "ISP abort scheduled.\n");
 			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
 			    &base_vha->dpc_flags))) {
 
@@ -3414,8 +3568,8 @@ qla2x00_do_dpc(void *data)
 						&base_vha->dpc_flags);
 			}
 
-			DEBUG(printk("scsi(%ld): dpc: qla2x00_abort_isp end\n",
-			    base_vha->host_no));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x4008,
+			    "ISP abort end.\n");
 		}
 
 		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
@@ -3424,9 +3578,8 @@ qla2x00_do_dpc(void *data)
 		}
 
 		if (test_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags)) {
-			DEBUG(printk(KERN_INFO "scsi(%ld): dpc: sched "
-			    "qla2x00_quiesce_needed ha = %p\n",
-			    base_vha->host_no, ha));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x4009,
+			    "Quiescence mode scheduled.\n");
 			qla82xx_device_state_handler(base_vha);
 			clear_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags);
 			if (!ha->flags.quiesce_owner) {
@@ -3436,17 +3589,20 @@ qla2x00_do_dpc(void *data)
 				qla82xx_clear_qsnt_ready(base_vha);
 				qla82xx_idc_unlock(ha);
 			}
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400a,
+			    "Quiescence mode end.\n");
 		}
 
 		if (test_and_clear_bit(RESET_MARKER_NEEDED,
 							&base_vha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &base_vha->dpc_flags)))) {
 
-			DEBUG(printk("scsi(%ld): qla2x00_reset_marker()\n",
-			    base_vha->host_no));
-
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400b,
+			    "Reset marker scheduled.\n");
 			qla2x00_rst_aen(base_vha);
 			clear_bit(RESET_ACTIVE, &base_vha->dpc_flags);
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400c,
+			    "Reset marker end.\n");
 		}
 
 		/* Retry each device up to login retry count */
@@ -3455,19 +3611,18 @@ qla2x00_do_dpc(void *data)
 		    !test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags) &&
 		    atomic_read(&base_vha->loop_state) != LOOP_DOWN) {
 
-			DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
-					base_vha->host_no));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400d,
+			    "Relogin scheduled.\n");
 			qla2x00_relogin(base_vha);
-
-			DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
-			    base_vha->host_no));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400e,
+			    "Relogin end.\n");
 		}
 
 		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
 							&base_vha->dpc_flags)) {
 
-			DEBUG(printk("scsi(%ld): qla2x00_loop_resync()\n",
-				base_vha->host_no));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
+			    "Loop resync scheduled.\n");
 
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
 			    &base_vha->dpc_flags))) {
@@ -3478,8 +3633,8 @@ qla2x00_do_dpc(void *data)
 						&base_vha->dpc_flags);
 			}
 
-			DEBUG(printk("scsi(%ld): qla2x00_loop_resync - end\n",
-			    base_vha->host_no));
+			ql_dbg(ql_dbg_dpc, base_vha, 0x4010,
+			    "Loop resync end.\n");
 		}
 
 		if (test_bit(NPIV_CONFIG_NEEDED, &base_vha->dpc_flags) &&
@@ -3502,7 +3657,8 @@ qla2x00_do_dpc(void *data)
 	} /* End of while(1) */
 	__set_current_state(TASK_RUNNING);
 
-	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
+	ql_dbg(ql_dbg_dpc, base_vha, 0x4011,
+	    "DPC handler exiting.\n");
 
 	/*
 	 * Make sure that nobody tries to wake us up again.
@@ -3609,9 +3765,11 @@ void
 qla2x00_sp_compl(struct qla_hw_data *ha, srb_t *sp)
 {
 	if (atomic_read(&sp->ref_count) == 0) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "SP reference-count to ZERO -- sp=%p\n", sp));
-		DEBUG2(BUG());
+		ql_dbg(ql_dbg_io, sp->fcport->vha, 0x3015,
+		    "SP reference-count to ZERO -- sp=%p cmd=%p.\n",
+		    sp, sp->cmd);
+		if (ql2xextended_error_logging & ql_dbg_io)
+			BUG();
 		return;
 	}
 	if (!atomic_dec_and_test(&sp->ref_count))
@@ -3639,6 +3797,9 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	struct req_que *req;
 
 	if (ha->flags.eeh_busy) {
+		ql_dbg(ql_dbg_timer, vha, 0x6000,
+		    "EEH = %d, restarting timer.\n",
+		    ha->flags.eeh_busy);
 		qla2x00_restart_timer(vha, WATCH_INTERVAL);
 		return;
 	}
@@ -3663,9 +3824,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		if (atomic_read(&vha->loop_down_timer) ==
 		    vha->loop_down_abort_time) {
 
-			DEBUG(printk("scsi(%ld): Loop Down - aborting the "
-			    "queues before time expire\n",
-			    vha->host_no));
+			ql_log(ql_log_info, vha, 0x6008,
+			    "Loop down - aborting the queues before time expires.\n");
 
 			if (!IS_QLA2100(ha) && vha->link_down_timeout)
 				atomic_set(&vha->loop_state, LOOP_DEAD);
@@ -3710,10 +3870,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
 			if (!(vha->device_flags & DFLG_NO_CABLE)) {
-				DEBUG(printk("scsi(%ld): Loop down - "
-				    "aborting ISP.\n",
-				    vha->host_no));
-				qla_printk(KERN_WARNING, ha,
+				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 
 				if (IS_QLA82XX(ha))
@@ -3724,9 +3881,9 @@ qla2x00_timer(scsi_qla_host_t *vha)
 						&vha->dpc_flags);
 			}
 		}
-		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
-		    vha->host_no,
-		    atomic_read(&vha->loop_down_timer)));
+		ql_dbg(ql_dbg_timer, vha, 0x600a,
+		    "Loop down - seconds remaining %d.\n",
+		    atomic_read(&vha->loop_down_timer));
 	}
 
 	/* Check if beacon LED needs to be blinked for physical host only */
@@ -3749,8 +3906,27 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	    test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags) ||
 	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) ||
 	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags)))
+	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags))) {
+		ql_dbg(ql_dbg_timer, vha, 0x600b,
+		    "isp_abort_needed=%d loop_resync_needed=%d "
+		    "fcport_update_needed=%d start_dpc=%d "
+		    "reset_marker_needed=%d",
+		    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags),
+		    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags),
+		    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags),
+		    start_dpc,
+		    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags));
+		ql_dbg(ql_dbg_timer, vha, 0x600c,
+		    "beacon_blink_needed=%d isp_unrecoverable=%d "
+		    "fcoe_ctx_reset_needed=%d vp_dpc_needed=%d "
+		    "relogin_needed=%d.\n",
+		    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags),
+		    test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags),
+		    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags),
+		    test_bit(VP_DPC_NEEDED, &vha->dpc_flags),
+		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
+	}
 
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
@@ -3819,8 +3995,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		goto out;
 
 	if (request_firmware(&blob->fw, blob->name, &ha->pdev->dev)) {
-		DEBUG2(printk("scsi(%ld): Failed to load firmware image "
-		    "(%s).\n", vha->host_no, blob->name));
+		ql_log(ql_log_warn, vha, 0x0063,
+		    "Failed to load firmware image (%s).\n", blob->name);
 		blob->fw = NULL;
 		blob = NULL;
 		goto out;
@@ -3849,8 +4025,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 	scsi_qla_host_t *vha = pci_get_drvdata(pdev);
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG2(qla_printk(KERN_WARNING, ha, "error_detected:state %x\n",
-	    state));
+	ql_dbg(ql_dbg_aer, vha, 0x9000,
+	    "PCI error detected, state %x.\n", state);
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -3863,9 +4039,9 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 			ha->flags.isp82xx_fw_hung = 1;
 			if (ha->flags.mbox_busy) {
 				ha->flags.mbox_int = 1;
-				DEBUG2(qla_printk(KERN_ERR, ha,
-					"Due to pci channel io frozen, doing premature "
-					"completion of mbx command\n"));
+				ql_dbg(ql_dbg_aer, vha, 0x9001,
+				    "Due to pci channel io frozen, doing premature "
+				    "completion of mbx command.\n");
 				complete(&ha->mbx_intr_comp);
 			}
 		}
@@ -3913,8 +4089,8 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (risc_paused) {
-		qla_printk(KERN_INFO, ha, "RISC paused -- mmio_enabled, "
-		    "Dumping firmware!\n");
+		ql_log(ql_log_info, base_vha, 0x9003,
+		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
 		ha->isp_ops->fw_dump(base_vha, 0);
 
 		return PCI_ERS_RESULT_NEED_RESET;
@@ -3930,8 +4106,8 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 	int fn;
 	struct pci_dev *other_pdev = NULL;
 
-	DEBUG17(qla_printk(KERN_INFO, ha,
-	    "scsi(%ld): In qla82xx_error_recovery\n", base_vha->host_no));
+	ql_dbg(ql_dbg_aer, base_vha, 0x9006,
+	    "Entered %s.\n", __func__);
 
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
@@ -3945,8 +4121,8 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 	fn = PCI_FUNC(ha->pdev->devfn);
 	while (fn > 0) {
 		fn--;
-		DEBUG17(qla_printk(KERN_INFO, ha,
-		    "Finding pci device at function = 0x%x\n", fn));
+		ql_dbg(ql_dbg_aer, base_vha, 0x9007,
+		    "Finding pci device at function = 0x%x.\n", fn);
 		other_pdev =
 		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
 		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
@@ -3955,9 +4131,9 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 		if (!other_pdev)
 			continue;
 		if (atomic_read(&other_pdev->enable_cnt)) {
-			DEBUG17(qla_printk(KERN_INFO, ha,
-			    "Found PCI func available and enabled at 0x%x\n",
-			    fn));
+			ql_dbg(ql_dbg_aer, base_vha, 0x9008,
+			    "Found PCI func available and enable at 0x%x.\n",
+			    fn);
 			pci_dev_put(other_pdev);
 			break;
 		}
@@ -3966,8 +4142,9 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 
 	if (!fn) {
 		/* Reset owner */
-		DEBUG17(qla_printk(KERN_INFO, ha,
-		    "This devfn is reset owner = 0x%x\n", ha->pdev->devfn));
+		ql_dbg(ql_dbg_aer, base_vha, 0x9009,
+		    "This devfn is reset owner = 0x%x.\n",
+		    ha->pdev->devfn);
 		qla82xx_idc_lock(ha);
 
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
@@ -3977,8 +4154,8 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 		    QLA82XX_IDC_VERSION);
 
 		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
-		DEBUG17(qla_printk(KERN_INFO, ha,
-		    "drv_active = 0x%x\n", drv_active));
+		ql_dbg(ql_dbg_aer, base_vha, 0x900a,
+		    "drv_active = 0x%x.\n", drv_active);
 
 		qla82xx_idc_unlock(ha);
 		/* Reset if device is not already reset
@@ -3991,12 +4168,14 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 		qla82xx_idc_lock(ha);
 
 		if (rval != QLA_SUCCESS) {
-			qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+			ql_log(ql_log_info, base_vha, 0x900b,
+			    "HW State: FAILED.\n");
 			qla82xx_clear_drv_active(ha);
 			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			    QLA82XX_DEV_FAILED);
 		} else {
-			qla_printk(KERN_INFO, ha, "HW State: READY\n");
+			ql_log(ql_log_info, base_vha, 0x900c,
+			    "HW State: READY.\n");
 			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			    QLA82XX_DEV_READY);
 			qla82xx_idc_unlock(ha);
@@ -4009,8 +4188,9 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 		}
 		qla82xx_idc_unlock(ha);
 	} else {
-		DEBUG17(qla_printk(KERN_INFO, ha,
-		    "This devfn is not reset owner = 0x%x\n", ha->pdev->devfn));
+		ql_dbg(ql_dbg_aer, base_vha, 0x900d,
+		    "This devfn is not reset owner = 0x%x.\n",
+		    ha->pdev->devfn);
 		if ((qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
 		    QLA82XX_DEV_READY)) {
 			ha->flags.isp82xx_fw_hung = 0;
@@ -4034,7 +4214,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	struct rsp_que *rsp;
 	int rc, retries = 10;
 
-	DEBUG17(qla_printk(KERN_WARNING, ha, "slot_reset\n"));
+	ql_dbg(ql_dbg_aer, base_vha, 0x9004,
+	    "Slot Reset.\n");
 
 	/* Workaround: qla2xxx driver which access hardware earlier
 	 * needs error state to be pci_channel_io_online.
@@ -4055,7 +4236,7 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		rc = pci_enable_device(pdev);
 
 	if (rc) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, base_vha, 0x9005,
 		    "Can't re-enable PCI device after reset.\n");
 		goto exit_slot_reset;
 	}
@@ -4085,8 +4266,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 
 
 exit_slot_reset:
-	DEBUG17(qla_printk(KERN_WARNING, ha,
-	    "slot_reset-return:ret=%x\n", ret));
+	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
+	    "slot_reset return %x.\n", ret);
 
 	return ret;
 }
@@ -4098,13 +4279,13 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
-	DEBUG17(qla_printk(KERN_WARNING, ha, "pci_resume\n"));
+	ql_dbg(ql_dbg_aer, base_vha, 0x900f,
+	    "pci_resume.\n");
 
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
-		qla_printk(KERN_ERR, ha,
-		    "the device failed to resume I/O "
-		    "from slot/link_reset");
+		ql_log(ql_log_fatal, base_vha, 0x9002,
+		    "The device failed to resume I/O from slot/link_reset.\n");
 	}
 
 	pci_cleanup_aer_uncorrect_error_status(pdev);
@@ -4168,8 +4349,8 @@ qla2x00_module_init(void)
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL);
 	if (srb_cachep == NULL) {
-		printk(KERN_ERR
-		    "qla2xxx: Unable to allocate SRB cache...Failing load!\n");
+		ql_log(ql_log_fatal, NULL, 0x0001,
+		    "Unable to allocate SRB cache...Failing load!.\n");
 		return -ENOMEM;
 	}
 
@@ -4182,13 +4363,15 @@ qla2x00_module_init(void)
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
 		kmem_cache_destroy(srb_cachep);
+		ql_log(ql_log_fatal, NULL, 0x0002,
+		    "fc_attach_transport failed...Failing load!.\n");
 		return -ENODEV;
 	}
 
 	apidev_major = register_chrdev(0, QLA2XXX_APIDEV, &apidev_fops);
 	if (apidev_major < 0) {
-		printk(KERN_WARNING "qla2xxx: Unable to register char device "
-		    "%s\n", QLA2XXX_APIDEV);
+		ql_log(ql_log_fatal, NULL, 0x0003,
+		    "Unable to register char device %s.\n", QLA2XXX_APIDEV);
 	}
 
 	qla2xxx_transport_vport_template =
@@ -4196,16 +4379,21 @@ qla2x00_module_init(void)
 	if (!qla2xxx_transport_vport_template) {
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
+		ql_log(ql_log_fatal, NULL, 0x0004,
+		    "fc_attach_transport vport failed...Failing load!.\n");
 		return -ENODEV;
 	}
-
-	printk(KERN_INFO "QLogic Fibre Channel HBA Driver: %s\n",
+	ql_log(ql_log_info, NULL, 0x0005,
+	    "QLogic Fibre Channel HBA Driver: %s.\n",
 	    qla2x00_version_str);
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
 		fc_release_transport(qla2xxx_transport_vport_template);
+		ql_log(ql_log_fatal, NULL, 0x0006,
+		    "pci_register_driver failed...ret=%d Failing load!.\n",
+		    ret);
 	}
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6936476..eff1356 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -189,6 +189,7 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 	uint16_t word;
 	uint32_t nv_cmd, wait_cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	qla2x00_nv_write(ha, NVR_DATA_OUT);
 	qla2x00_nv_write(ha, 0);
@@ -220,8 +221,8 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(qla_printk(KERN_WARNING, ha,
-			    "NVRAM didn't go ready...\n"));
+			ql_dbg(ql_dbg_user, vha, 0x708d,
+			    "NVRAM didn't go ready...\n");
 			break;
 		}
 		NVRAM_DELAY();
@@ -308,6 +309,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word, wait_cnt;
 	uint16_t wprot, wprot_old;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	/* Clear NVRAM write protection. */
 	ret = QLA_FUNCTION_FAILED;
@@ -350,8 +352,8 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 		wait_cnt = NVR_WAIT_CNT;
 		do {
 			if (!--wait_cnt) {
-				DEBUG9_10(qla_printk(KERN_WARNING, ha,
-				    "NVRAM didn't go ready...\n"));
+				ql_dbg(ql_dbg_user, vha, 0x708e,
+				    "NVRAM didn't go ready...\n");
 				break;
 			}
 			NVRAM_DELAY();
@@ -371,6 +373,7 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word, wait_cnt;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	if (stat != QLA_SUCCESS)
 		return;
@@ -409,8 +412,8 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(qla_printk(KERN_WARNING, ha,
-			    "NVRAM didn't go ready...\n"));
+			ql_dbg(ql_dbg_user, vha, 0x708f,
+			    "NVRAM didn't go ready...\n");
 			break;
 		}
 		NVRAM_DELAY();
@@ -607,9 +610,10 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	for (chksum = 0; cnt; cnt--)
 		chksum += le16_to_cpu(*wptr++);
 	if (chksum) {
-		qla_printk(KERN_ERR, ha,
+		ql_log(ql_log_fatal, vha, 0x0045,
 		    "Inconsistent FLTL detected: checksum=0x%x.\n", chksum);
-		qla2x00_dump_buffer(buf, sizeof(struct qla_flt_location));
+		ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x010e,
+		    buf, sizeof(struct qla_flt_location));
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -618,7 +622,9 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	*start = (le16_to_cpu(fltl->start_hi) << 16 |
 	    le16_to_cpu(fltl->start_lo)) >> 2;
 end:
-	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLTL[%s] = 0x%x.\n", loc, *start));
+	ql_dbg(ql_dbg_init, vha, 0x0046,
+	    "FLTL[%s] = 0x%x.\n",
+	    loc, *start);
 	return QLA_SUCCESS;
 }
 
@@ -685,10 +691,10 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
 	if (flt->version != __constant_cpu_to_le16(1)) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported FLT detected: "
-		    "version=0x%x length=0x%x checksum=0x%x.\n",
+		ql_log(ql_log_warn, vha, 0x0047,
+		    "Unsupported FLT detected: version=0x%x length=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
-		    le16_to_cpu(flt->checksum)));
+		    le16_to_cpu(flt->checksum));
 		goto no_flash_data;
 	}
 
@@ -696,10 +702,10 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	for (chksum = 0; cnt; cnt--)
 		chksum += le16_to_cpu(*wptr++);
 	if (chksum) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent FLT detected: "
-		    "version=0x%x length=0x%x checksum=0x%x.\n",
+		ql_log(ql_log_fatal, vha, 0x0048,
+		    "Inconsistent FLT detected: version=0x%x length=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
-		    chksum));
+		    le16_to_cpu(flt->checksum));
 		goto no_flash_data;
 	}
 
@@ -708,10 +714,11 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	for ( ; cnt; cnt--, region++) {
 		/* Store addresses as DWORD offsets. */
 		start = le32_to_cpu(region->start) >> 2;
-
-		DEBUG3(qla_printk(KERN_DEBUG, ha, "FLT[%02x]: start=0x%x "
-		    "end=0x%x size=0x%x.\n", le32_to_cpu(region->code), start,
-		    le32_to_cpu(region->end) >> 2, le32_to_cpu(region->size)));
+		ql_dbg(ql_dbg_init, vha, 0x0049,
+		    "FLT[%02x]: start=0x%x "
+		    "end=0x%x size=0x%x.\n", le32_to_cpu(region->code),
+		    start, le32_to_cpu(region->end) >> 2,
+		    le32_to_cpu(region->size));
 
 		switch (le32_to_cpu(region->code) & 0xff) {
 		case FLT_REG_FW:
@@ -796,12 +803,16 @@ no_flash_data:
 	ha->flt_region_npiv_conf = ha->flags.port0 ?
 	    def_npiv_conf0[def] : def_npiv_conf1[def];
 done:
-	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
-	    "vpd_nvram=0x%x vpd=0x%x nvram=0x%x fdt=0x%x flt=0x%x "
-	    "npiv=0x%x. fcp_prio_cfg=0x%x\n", loc, ha->flt_region_boot,
-	    ha->flt_region_fw, ha->flt_region_vpd_nvram, ha->flt_region_vpd,
-	    ha->flt_region_nvram, ha->flt_region_fdt, ha->flt_region_flt,
-	    ha->flt_region_npiv_conf, ha->flt_region_fcp_prio));
+	ql_dbg(ql_dbg_init, vha, 0x004a,
+	    "FLT[%s]: boot=0x%x fw=0x%x vpd_nvram=0x%x vpd=0x%x.\n",
+	    loc, ha->flt_region_boot,
+	    ha->flt_region_fw, ha->flt_region_vpd_nvram,
+	    ha->flt_region_vpd);
+	ql_dbg(ql_dbg_init, vha, 0x004b,
+	    "nvram=0x%x fdt=0x%x flt=0x%x npiv=0x%x fcp_prif_cfg=0x%x.\n",
+	    ha->flt_region_nvram,
+	    ha->flt_region_fdt, ha->flt_region_flt,
+	    ha->flt_region_npiv_conf, ha->flt_region_fcp_prio);
 }
 
 static void
@@ -833,10 +844,12 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	    cnt++)
 		chksum += le16_to_cpu(*wptr++);
 	if (chksum) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent FDT detected: "
-		    "checksum=0x%x id=%c version=0x%x.\n", chksum, fdt->sig[0],
-		    le16_to_cpu(fdt->version)));
-		DEBUG9(qla2x00_dump_buffer((uint8_t *)fdt, sizeof(*fdt)));
+		ql_dbg(ql_dbg_init, vha, 0x004c,
+		    "Inconsistent FDT detected:"
+		    " checksum=0x%x id=%c version0x%x.\n", chksum,
+		    fdt->sig[0], le16_to_cpu(fdt->version));
+		ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0113,
+		    (uint8_t *)fdt, sizeof(*fdt));
 		goto no_flash_data;
 	}
 
@@ -890,11 +903,12 @@ no_flash_data:
 		break;
 	}
 done:
-	DEBUG2(qla_printk(KERN_DEBUG, ha, "FDT[%s]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
+	ql_dbg(ql_dbg_init, vha, 0x004d,
+	    "FDT[%x]: (0x%x/0x%x) erase=0x%x "
+	    "pr=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
 	    ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
-	    ha->fdt_unprotect_sec_cmd, ha->fdt_wrt_disable,
-	    ha->fdt_block_size));
+	    ha->fdt_wrt_disable, ha->fdt_block_size);
+
 }
 
 static void
@@ -919,6 +933,10 @@ qla2xxx_get_idc_param(scsi_qla_host_t *vha)
 		ha->nx_dev_init_timeout = le32_to_cpu(*wptr++);
 		ha->nx_reset_timeout = le32_to_cpu(*wptr);
 	}
+	ql_dbg(ql_dbg_init, vha, 0x004e,
+	    "nx_dev_init_timeout=%d "
+	    "nx_reset_timeout=%d.\n", ha->nx_dev_init_timeout,
+	    ha->nx_reset_timeout);
 	return;
 }
 
@@ -963,17 +981,18 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	if (hdr.version == __constant_cpu_to_le16(0xffff))
 		return;
 	if (hdr.version != __constant_cpu_to_le16(1)) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported NPIV-Config "
+		ql_dbg(ql_dbg_user, vha, 0x7090,
+		    "Unsupported NPIV-Config "
 		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(hdr.version), le16_to_cpu(hdr.entries),
-		    le16_to_cpu(hdr.checksum)));
+		    le16_to_cpu(hdr.checksum));
 		return;
 	}
 
 	data = kmalloc(NPIV_CONFIG_SIZE, GFP_KERNEL);
 	if (!data) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "NPIV-Config: Unable to "
-		    "allocate memory.\n"));
+		ql_log(ql_log_warn, vha, 0x7091,
+		    "Unable to allocate memory for data.\n");
 		return;
 	}
 
@@ -985,10 +1004,11 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	for (wptr = data, chksum = 0; cnt; cnt--)
 		chksum += le16_to_cpu(*wptr++);
 	if (chksum) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent NPIV-Config "
+		ql_dbg(ql_dbg_user, vha, 0x7092,
+		    "Inconsistent NPIV-Config "
 		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(hdr.version), le16_to_cpu(hdr.entries),
-		    chksum));
+		    le16_to_cpu(hdr.checksum));
 		goto done;
 	}
 
@@ -1014,21 +1034,22 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 		vid.port_name = wwn_to_u64(entry->port_name);
 		vid.node_name = wwn_to_u64(entry->node_name);
 
-		DEBUG2(qla_printk(KERN_INFO, ha, "NPIV[%02x]: wwpn=%llx "
-			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
-			(unsigned long long)vid.port_name,
-			(unsigned long long)vid.node_name,
-			le16_to_cpu(entry->vf_id),
-			entry->q_qos, entry->f_qos));
+		ql_dbg(ql_dbg_user, vha, 0x7093,
+		    "NPIV[%02x]: wwpn=%llx "
+		    "wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
+		    (unsigned long long)vid.port_name,
+		    (unsigned long long)vid.node_name,
+		    le16_to_cpu(entry->vf_id),
+		    entry->q_qos, entry->f_qos);
 
 		if (i < QLA_PRECONFIG_VPORTS) {
 			vport = fc_vport_create(vha->host, 0, &vid);
 			if (!vport)
-				qla_printk(KERN_INFO, ha,
-				"NPIV-Config: Failed to create vport [%02x]: "
-				"wwpn=%llx wwnn=%llx.\n", cnt,
-				(unsigned long long)vid.port_name,
-				(unsigned long long)vid.node_name);
+				ql_log(ql_log_warn, vha, 0x7094,
+				    "NPIV-Config Failed to create vport [%02x]: "
+				    "wwpn=%llx wwnn=%llx.\n", cnt,
+				    (unsigned long long)vid.port_name,
+				    (unsigned long long)vid.node_name);
 		}
 	}
 done:
@@ -1127,9 +1148,10 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 		    &optrom_dma, GFP_KERNEL);
 		if (!optrom) {
-			qla_printk(KERN_DEBUG, ha,
-			    "Unable to allocate memory for optrom burst write "
-			    "(%x KB).\n", OPTROM_BURST_SIZE / 1024);
+			ql_log(ql_log_warn, vha, 0x7095,
+			    "Unable to allocate "
+			    "memory for optrom burst write (%x KB).\n",
+			    OPTROM_BURST_SIZE / 1024);
 		}
 	}
 
@@ -1138,7 +1160,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 
 	ret = qla24xx_unprotect_flash(vha);
 	if (ret != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7096,
 		    "Unable to unprotect flash for update.\n");
 		goto done;
 	}
@@ -1156,9 +1178,9 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				    0xff0000) | ((fdata >> 16) & 0xff));
 			ret = qla24xx_erase_sector(vha, fdata);
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(qla_printk(KERN_WARNING, ha,
-				    "Unable to erase sector: address=%x.\n",
-				    faddr));
+				ql_dbg(ql_dbg_user, vha, 0x7007,
+				    "Unable to erase erase sector: address=%x.\n",
+				    faddr);
 				break;
 			}
 		}
@@ -1172,12 +1194,12 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    flash_data_addr(ha, faddr),
 			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
-				qla_printk(KERN_WARNING, ha,
+				ql_log(ql_log_warn, vha, 0x7097,
 				    "Unable to burst-write optrom segment "
 				    "(%x/%x/%llx).\n", ret,
 				    flash_data_addr(ha, faddr),
 				    (unsigned long long)optrom_dma);
-				qla_printk(KERN_WARNING, ha,
+				ql_log(ql_log_warn, vha, 0x7098,
 				    "Reverting to slow-write.\n");
 
 				dma_free_coherent(&ha->pdev->dev,
@@ -1194,9 +1216,9 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		ret = qla24xx_write_flash_dword(ha,
 		    flash_data_addr(ha, faddr), cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
-			DEBUG9(printk("%s(%ld) Unable to program flash "
-			    "address=%x data=%x.\n", __func__,
-			    vha->host_no, faddr, *dwptr));
+			ql_dbg(ql_dbg_user, vha, 0x7006,
+			    "Unable to program flash address=%x data=%x.\n",
+			    faddr, *dwptr);
 			break;
 		}
 
@@ -1211,7 +1233,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 
 	ret = qla24xx_protect_flash(vha);
 	if (ret != QLA_SUCCESS)
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7099,
 		    "Unable to protect flash after update.\n");
 done:
 	if (optrom)
@@ -1324,9 +1346,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 		ret = qla24xx_write_flash_dword(ha,
 		    nvram_data_addr(ha, naddr), cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
-			DEBUG9(qla_printk(KERN_WARNING, ha,
+			ql_dbg(ql_dbg_user, vha, 0x709a,
 			    "Unable to program nvram address=%x data=%x.\n",
-			    naddr, *dwptr));
+			    naddr, *dwptr);
 			break;
 		}
 	}
@@ -1476,7 +1498,7 @@ qla2x00_beacon_on(struct scsi_qla_host *vha)
 	ha->fw_options[1] |= FO1_DISABLE_GPIO6_7;
 
 	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x709b,
 		    "Unable to update fw options (beacon on).\n");
 		return QLA_FUNCTION_FAILED;
 	}
@@ -1541,7 +1563,7 @@ qla2x00_beacon_off(struct scsi_qla_host *vha)
 
 	rval = qla2x00_set_fw_options(vha, ha->fw_options);
 	if (rval != QLA_SUCCESS)
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x709c,
 		    "Unable to update fw options (beacon off).\n");
 	return rval;
 }
@@ -1616,7 +1638,7 @@ qla24xx_beacon_on(struct scsi_qla_host *vha)
 
 		if (qla2x00_get_fw_options(vha, ha->fw_options) !=
 		    QLA_SUCCESS) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x7009,
 			    "Unable to update fw options (beacon on).\n");
 			return QLA_FUNCTION_FAILED;
 		}
@@ -1670,14 +1692,14 @@ qla24xx_beacon_off(struct scsi_qla_host *vha)
 	ha->fw_options[1] &= ~ADD_FO1_DISABLE_GPIO_LED_CTRL;
 
 	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to update fw options (beacon off).\n");
+		ql_log(ql_log_warn, vha, 0x704d,
+		    "Unable to update fw options (beacon on).\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
 	if (qla2x00_get_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to get fw options (beacon off).\n");
+		ql_log(ql_log_warn, vha, 0x704e,
+		    "Unable to update fw options (beacon on).\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2389,10 +2411,9 @@ try_fast:
 	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 	    &optrom_dma, GFP_KERNEL);
 	if (!optrom) {
-		qla_printk(KERN_DEBUG, ha,
-		    "Unable to allocate memory for optrom burst read "
-		    "(%x KB).\n", OPTROM_BURST_SIZE / 1024);
-
+		ql_log(ql_log_warn, vha, 0x00cc,
+		    "Unable to allocate memory for optrom burst read (%x KB).\n",
+		    OPTROM_BURST_SIZE / 1024);
 		goto slow_read;
 	}
 
@@ -2407,12 +2428,11 @@ try_fast:
 		rval = qla2x00_dump_ram(vha, optrom_dma,
 		    flash_data_addr(ha, faddr), burst);
 		if (rval) {
-			qla_printk(KERN_WARNING, ha,
-			    "Unable to burst-read optrom segment "
-			    "(%x/%x/%llx).\n", rval,
-			    flash_data_addr(ha, faddr),
+			ql_log(ql_log_warn, vha, 0x00f5,
+			    "Unable to burst-read optrom segment (%x/%x/%llx).\n",
+			    rval, flash_data_addr(ha, faddr),
 			    (unsigned long long)optrom_dma);
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x00f6,
 			    "Reverting to slow-read.\n");
 
 			dma_free_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
@@ -2556,8 +2576,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (qla2x00_read_flash_byte(ha, pcihdr) != 0x55 ||
 		    qla2x00_read_flash_byte(ha, pcihdr + 0x01) != 0xaa) {
 			/* No signature */
-			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
-			    "signature.\n"));
+			ql_log(ql_log_fatal, vha, 0x0050,
+			    "No matching ROM signature.\n");
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2573,8 +2593,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		    qla2x00_read_flash_byte(ha, pcids + 0x2) != 'I' ||
 		    qla2x00_read_flash_byte(ha, pcids + 0x3) != 'R') {
 			/* Incorrect header. */
-			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
-			    "found pcir_adr=%x.\n", pcids));
+			ql_log(ql_log_fatal, vha, 0x0051,
+			    "PCI data struct not found pcir_adr=%x.\n", pcids);
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2588,8 +2608,9 @@ qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->bios_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
-			    ha->bios_revision[1], ha->bios_revision[0]));
+			ql_dbg(ql_dbg_init, vha, 0x0052,
+			    "Read BIOS %d.%d.\n",
+			    ha->bios_revision[1], ha->bios_revision[0]);
 			break;
 		case ROM_CODE_TYPE_FCODE:
 			/* Open Firmware standard for PCI (FCode). */
@@ -2602,12 +2623,14 @@ qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->efi_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
-			    ha->efi_revision[1], ha->efi_revision[0]));
+			ql_dbg(ql_dbg_init, vha, 0x0053,
+			    "Read EFI %d.%d.\n",
+			    ha->efi_revision[1], ha->efi_revision[0]);
 			break;
 		default:
-			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
-			    "type %x at pcids %x.\n", code_type, pcids));
+			ql_log(ql_log_warn, vha, 0x0054,
+			    "Unrecognized code type %x at pcids %x.\n",
+			    code_type, pcids);
 			break;
 		}
 
@@ -2627,21 +2650,28 @@ qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 
 		qla2x00_read_flash_data(ha, dbyte, ha->flt_region_fw * 4 + 10,
 		    8);
-		DEBUG3(qla_printk(KERN_DEBUG, ha, "dumping fw ver from "
-		    "flash:\n"));
-		DEBUG3(qla2x00_dump_buffer((uint8_t *)dbyte, 8));
+		ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x010a,
+		    "Dumping fw "
+		    "ver from flash:.\n");
+		ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x010b,
+		    (uint8_t *)dbyte, 8);
 
 		if ((dcode[0] == 0xffff && dcode[1] == 0xffff &&
 		    dcode[2] == 0xffff && dcode[3] == 0xffff) ||
 		    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		    dcode[3] == 0)) {
-			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
-			    "revision at %x.\n", ha->flt_region_fw * 4));
+			ql_log(ql_log_warn, vha, 0x0057,
+			    "Unrecognized fw revision at %x.\n",
+			    ha->flt_region_fw * 4);
 		} else {
 			/* values are in big endian */
 			ha->fw_revision[0] = dbyte[0] << 16 | dbyte[1];
 			ha->fw_revision[1] = dbyte[2] << 16 | dbyte[3];
 			ha->fw_revision[2] = dbyte[4] << 16 | dbyte[5];
+			ql_dbg(ql_dbg_init, vha, 0x0058,
+			    "FW Version: "
+			    "%d.%d.%d.\n", ha->fw_revision[0],
+			    ha->fw_revision[1], ha->fw_revision[2]);
 		}
 	}
 
@@ -2683,8 +2713,8 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		bcode = mbuf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa) {
 			/* No signature */
-			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
-			    "signature.\n"));
+			ql_log(ql_log_fatal, vha, 0x0059,
+			    "No matching ROM signature.\n");
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2699,8 +2729,8 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (bcode[0x0] != 'P' || bcode[0x1] != 'C' ||
 		    bcode[0x2] != 'I' || bcode[0x3] != 'R') {
 			/* Incorrect header. */
-			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
-			    "found pcir_adr=%x.\n", pcids));
+			ql_log(ql_log_fatal, vha, 0x005a,
+			    "PCI data struct not found pcir_adr=%x.\n", pcids);
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2712,26 +2742,30 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			/* Intel x86, PC-AT compatible. */
 			ha->bios_revision[0] = bcode[0x12];
 			ha->bios_revision[1] = bcode[0x13];
-			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
-			    ha->bios_revision[1], ha->bios_revision[0]));
+			ql_dbg(ql_dbg_init, vha, 0x005b,
+			    "Read BIOS %d.%d.\n",
+			    ha->bios_revision[1], ha->bios_revision[0]);
 			break;
 		case ROM_CODE_TYPE_FCODE:
 			/* Open Firmware standard for PCI (FCode). */
 			ha->fcode_revision[0] = bcode[0x12];
 			ha->fcode_revision[1] = bcode[0x13];
-			DEBUG3(qla_printk(KERN_DEBUG, ha, "read FCODE %d.%d.\n",
-			    ha->fcode_revision[1], ha->fcode_revision[0]));
+			ql_dbg(ql_dbg_init, vha, 0x005c,
+			    "Read FCODE %d.%d.\n",
+			    ha->fcode_revision[1], ha->fcode_revision[0]);
 			break;
 		case ROM_CODE_TYPE_EFI:
 			/* Extensible Firmware Interface (EFI). */
 			ha->efi_revision[0] = bcode[0x12];
 			ha->efi_revision[1] = bcode[0x13];
-			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
-			    ha->efi_revision[1], ha->efi_revision[0]));
+			ql_dbg(ql_dbg_init, vha, 0x005d,
+			    "Read EFI %d.%d.\n",
+			    ha->efi_revision[1], ha->efi_revision[0]);
 			break;
 		default:
-			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
-			    "type %x at pcids %x.\n", code_type, pcids));
+			ql_log(ql_log_warn, vha, 0x005e,
+			    "Unrecognized code type %x at pcids %x.\n",
+			    code_type, pcids);
 			break;
 		}
 
@@ -2753,13 +2787,18 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 	    dcode[3] == 0)) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
-		    "revision at %x.\n", ha->flt_region_fw * 4));
+		ql_log(ql_log_warn, vha, 0x005f,
+		    "Unrecognized fw revision at %x.\n",
+		    ha->flt_region_fw * 4);
 	} else {
 		ha->fw_revision[0] = dcode[0];
 		ha->fw_revision[1] = dcode[1];
 		ha->fw_revision[2] = dcode[2];
 		ha->fw_revision[3] = dcode[3];
+		ql_dbg(ql_dbg_init, vha, 0x0060,
+		    "Firmware revision %d.%d.%d.%d.\n",
+		    ha->fw_revision[0], ha->fw_revision[1],
+		    ha->fw_revision[2], ha->fw_revision[3]);
 	}
 
 	/* Check for golden firmware and get version if available */
@@ -2775,9 +2814,9 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 
 	if (dcode[4] == 0xFFFFFFFF && dcode[5] == 0xFFFFFFFF &&
 	    dcode[6] == 0xFFFFFFFF && dcode[7] == 0xFFFFFFFF) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "%s(%ld): Unrecognized golden fw at 0x%x.\n",
-		    __func__, vha->host_no, ha->flt_region_gold_fw * 4));
+		ql_log(ql_log_warn, vha, 0x0056,
+		    "Unrecognized golden fw at 0x%x.\n",
+		    ha->flt_region_gold_fw * 4);
 		return ret;
 	}
 
@@ -2843,9 +2882,9 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
 	if (!ha->fcp_prio_cfg) {
 		ha->fcp_prio_cfg = vmalloc(FCP_PRIO_CFG_SIZE);
 		if (!ha->fcp_prio_cfg) {
-			qla_printk(KERN_WARNING, ha,
-			"Unable to allocate memory for fcp priority data "
-					"(%x).\n", FCP_PRIO_CFG_SIZE);
+			ql_log(ql_log_warn, vha, 0x00d5,
+			    "Unable to allocate memory for fcp priorty data (%x).\n",
+			    FCP_PRIO_CFG_SIZE);
 			return QLA_FUNCTION_FAILED;
 		}
 	}
@@ -2857,7 +2896,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
 	ha->isp_ops->read_optrom(vha, (uint8_t *)ha->fcp_prio_cfg,
 			fcp_prio_addr << 2, FCP_PRIO_CFG_HDR_SIZE);
 
-	if (!qla24xx_fcp_prio_cfg_valid(ha->fcp_prio_cfg, 0))
+	if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 0))
 		goto fail;
 
 	/* read remaining FCP CMD config data from flash */
@@ -2869,7 +2908,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
 			fcp_prio_addr << 2, (len < max_len ? len : max_len));
 
 	/* revalidate the entire FCP priority config data, including entries */
-	if (!qla24xx_fcp_prio_cfg_valid(ha->fcp_prio_cfg, 1))
+	if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1))
 		goto fail;
 
 	ha->flags.fcp_prio_enabled = 1;
-- 
1.6.0.2

