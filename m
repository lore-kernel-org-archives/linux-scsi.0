Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A5BC00454
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 15:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8372465B
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 15:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="qKp9DTuR";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Vvw2kcWY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLNP63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 10:58:29 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58504 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbfLNP63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 10:58:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B89EA8EE1E0;
        Sat, 14 Dec 2019 07:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1576339108;
        bh=aZUokjpp7DbnpRqboFXFwayJ8eIfsdEOtDXUBioebcI=;
        h=Subject:From:To:Cc:Date:From;
        b=qKp9DTuR47MaEWRjdxyfts+RGT+qSCdSnP+IlhVzaq5uy9bl6lqYg19knR4O73Xzc
         EgapV5FdpR2HerrPtDLljniIgx+UEPQJdV0Ni2BOrr+gp09c4LsWZEGzfMY8KOIRkZ
         wcaVypudLz2bO1KdrThBffxN5UoJlL0XmafSph5c=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SyaNGdvk82N5; Sat, 14 Dec 2019 07:58:27 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4360E8EE0F5;
        Sat, 14 Dec 2019 07:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1576339107;
        bh=aZUokjpp7DbnpRqboFXFwayJ8eIfsdEOtDXUBioebcI=;
        h=Subject:From:To:Cc:Date:From;
        b=Vvw2kcWYSs4SyCPa5XY85GML4uaU73xIC1NKI03xM46ZArMo4qEf469UM3nnAtcw5
         ipj6/e7rljGwz83zHdzlrKvoDLhezaaPA2N6ukxN3VsR7iJi48Iz2A6VjDe0SlZryo
         vtLnnjPaORqLbrduib44oVAgG09hWdyvW3IbE1mE=
Message-ID: <1576339105.4035.6.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.5-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 14 Dec 2019 07:58:25 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

24 fixes, all in drivers.  The lion's share (16) are qla2xxx and the
rest are iscsi (3), ufs (2), smarpqi, lpfc and libsas.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Bo Wu (2):
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func
      scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Can Guo (1):
      scsi: ufs: Give an unique ID to each ufs-bsg

Dan Carpenter (1):
      scsi: iscsi: qla4xxx: fix double free in probe

Himanshu Madhani (1):
      scsi: qla2xxx: Correctly retrieve and interpret active flash region

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Michael Hernandez (2):
      scsi: qla2xxx: Fix incorrect SFUB length used for Secure Flash Update MB Cmd
      scsi: qla2xxx: Added support for MPI and PEP regions for ISP28XX

Paul Menzel (1):
      scsi: smartpqi: Update attribute name to `driver_version`

Quinn Tran (1):
      scsi: qla2xxx: Use explicit LOGO in target mode

Roman Bolshakov (12):
      scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
      scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
      scsi: qla2xxx: Don't defer relogin unconditonally
      scsi: qla2xxx: Send Notify ACK after N2N PLOGI
      scsi: qla2xxx: Configure local loop for N2N target
      scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
      scsi: qla2xxx: Don't call qlt_async_event twice
      scsi: qla2xxx: Allow PLOGI in target mode
      scsi: qla2xxx: Change discovery state before PLOGI
      scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
      scsi: qla2xxx: Initialize free_work before flushing it
      scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd

sheebab (1):
      scsi: ufs: Disable autohibern8 feature in Cadence UFS

And the diffstat:

 Documentation/scsi/smartpqi.txt     |  2 +-
 drivers/scsi/libiscsi.c             |  4 ++--
 drivers/scsi/libsas/sas_discover.c  | 11 ++++++++++-
 drivers/scsi/lpfc/lpfc_bsg.c        | 15 +++++++++------
 drivers/scsi/qla2xxx/qla_attr.c     |  1 +
 drivers/scsi/qla2xxx/qla_bsg.c      |  2 +-
 drivers/scsi/qla2xxx/qla_def.h      |  1 +
 drivers/scsi/qla2xxx/qla_fw.h       |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c     | 21 ++++++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c     | 31 +++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c      |  4 ----
 drivers/scsi/qla2xxx/qla_mbx.c      |  3 ++-
 drivers/scsi/qla2xxx/qla_sup.c      | 35 ++++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_target.c   |  4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  |  3 +++
 drivers/scsi/qla4xxx/ql4_os.c       |  1 -
 drivers/scsi/scsi_transport_iscsi.c |  7 +++++++
 drivers/scsi/ufs/cdns-pltfrm.c      |  6 ++++++
 drivers/scsi/ufs/ufs_bsg.c          |  2 +-
 19 files changed, 111 insertions(+), 46 deletions(-)

With full diff below.

James

---

diff --git a/Documentation/scsi/smartpqi.txt b/Documentation/scsi/smartpqi.txt
index 201f80c7c050..df129f55ace5 100644
--- a/Documentation/scsi/smartpqi.txt
+++ b/Documentation/scsi/smartpqi.txt
@@ -29,7 +29,7 @@ smartpqi specific entries in /sys
   smartpqi host attributes:
   -------------------------
   /sys/class/scsi_host/host*/rescan
-  /sys/class/scsi_host/host*/version
+  /sys/class/scsi_host/host*/driver_version
 
   The host rescan attribute is a write only attribute. Writing to this
   attribute will trigger the driver to scan for new, changed, or removed
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ebd47c0cf9e9..70b99c0e2e67 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1945,7 +1945,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
-	spin_lock(&session->frwd_lock);
+	spin_lock_bh(&session->frwd_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -2072,7 +2072,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 done:
 	if (task)
 		task->last_timeout = jiffies;
-	spin_unlock(&session->frwd_lock);
+	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "shutdown or nh");
 	return rc;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index f47b4b281b14..d7302c2052f9 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -81,12 +81,21 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		else
 			dev->dev_type = SAS_SATA_DEV;
 		dev->tproto = SAS_PROTOCOL_SATA;
-	} else {
+	} else if (port->oob_mode == SAS_OOB_MODE) {
 		struct sas_identify_frame *id =
 			(struct sas_identify_frame *) dev->frame_rcvd;
 		dev->dev_type = id->dev_type;
 		dev->iproto = id->initiator_bits;
 		dev->tproto = id->target_bits;
+	} else {
+		/* If the oob mode is OOB_NOT_CONNECTED, the port is
+		 * disconnected due to race with PHY down. We cannot
+		 * continue to discover this port
+		 */
+		sas_put_device(dev);
+		pr_warn("Port %016llx is disconnected when discovering\n",
+			SAS_ADDR(port->attached_sas_addr));
+		return -ENODEV;
 	}
 
 	sas_init_dev(dev);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d4e1b120cc9e..0ea03ae93d91 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4489,12 +4489,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	phba->mbox_ext_buf_ctx.seqNum++;
 	nemb_tp = phba->mbox_ext_buf_ctx.nembType;
 
-	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
-	if (!dd_data) {
-		rc = -ENOMEM;
-		goto job_error;
-	}
-
 	pbuf = (uint8_t *)dmabuf->virt;
 	size = job->request_payload.payload_len;
 	sg_copy_to_buffer(job->request_payload.sg_list,
@@ -4531,6 +4525,13 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 				"2968 SLI_CONFIG ext-buffer wr all %d "
 				"ebuffers received\n",
 				phba->mbox_ext_buf_ctx.numBuf);
+
+		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+		if (!dd_data) {
+			rc = -ENOMEM;
+			goto job_error;
+		}
+
 		/* mailbox command structure for base driver */
 		pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!pmboxq) {
@@ -4579,6 +4580,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	return SLI_CONFIG_HANDLED;
 
 job_error:
+	if (pmboxq)
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 	lpfc_bsg_dma_page_free(phba, dmabuf);
 	kfree(dd_data);
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ae97e2f310a3..d7e7043f9eab 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -178,6 +178,7 @@ qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 
 	faddr = ha->flt_region_nvram;
 	if (IS_QLA28XX(ha)) {
+		qla28xx_get_aux_images(vha, &active_regions);
 		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
 			faddr = ha->flt_region_nvram_sec;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 99f0a1a08143..cbaf178fc979 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2399,7 +2399,7 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	struct qla_active_regions regions = { };
 	struct active_regions active_regions = { };
 
-	qla28xx_get_aux_images(vha, &active_regions);
+	qla27xx_get_active_image(vha, &active_regions);
 	regions.global_image = active_regions.global;
 
 	if (IS_QLA28XX(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 460f443f6471..2edd9f7b3074 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2401,6 +2401,7 @@ typedef struct fc_port {
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
+	unsigned int explicit_logout:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 59f6903e5abe..9dc09c117416 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1523,6 +1523,10 @@ struct qla_flt_header {
 #define FLT_REG_NVRAM_SEC_28XX_1	0x10F
 #define FLT_REG_NVRAM_SEC_28XX_2	0x111
 #define FLT_REG_NVRAM_SEC_28XX_3	0x113
+#define FLT_REG_MPI_PRI_28XX		0xD3
+#define FLT_REG_MPI_SEC_28XX		0xF0
+#define FLT_REG_PEP_PRI_28XX		0xD1
+#define FLT_REG_PEP_SEC_28XX		0xF1
 
 struct qla_flt_region {
 	uint16_t code;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6c28f38f8021..aa5204163bec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -533,6 +533,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -1526,8 +1527,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		}
 	}
 
-	/* for pure Target Mode. Login will not be initiated */
-	if (vha->host->active_mode == MODE_TARGET)
+	/* Target won't initiate port login if fabric is present */
+	if (vha->host->active_mode == MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
 	if (fcport->flags & FCF_ASYNC_SENT) {
@@ -1719,6 +1720,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
 				      struct event_arg *ea)
 {
+	/* for pure Target Mode, PRLI will not be initiated */
+	if (vha->host->active_mode == MODE_TARGET)
+		return;
+
 	ql_dbg(ql_dbg_disc, vha, 0x2118,
 	    "%s %d %8phC post PRLI\n",
 	    __func__, __LINE__, ea->fcport->port_name);
@@ -4852,6 +4857,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	}
 
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
+	INIT_WORK(&fcport->free_work, qlt_free_session_done);
 	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
@@ -4930,14 +4936,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
-	} else if (ha->current_topology == ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology == ISP_CFG_NL) {
+	} else if (ha->current_topology == ISP_CFG_NL ||
+		   ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
@@ -5054,7 +5054,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..8b050f0b4333 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2405,11 +2405,19 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 static void
 qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
+	u16 control_flags = LCF_COMMAND_LOGO;
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
-	logio->control_flags =
-	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
-	if (!sp->fcport->keep_nport_handle)
-		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
+
+	if (sp->fcport->explicit_logout) {
+		control_flags |= LCF_EXPL_LOGO|LCF_FREE_NPORT;
+	} else {
+		control_flags |= LCF_IMPL_LOGO;
+
+		if (!sp->fcport->keep_nport_handle)
+			control_flags |= LCF_FREE_NPORT;
+	}
+
+	logio->control_flags = cpu_to_le16(control_flags);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
@@ -2617,6 +2625,10 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	memcpy(elsio->u.els_logo.els_logo_pyld, &logo_pyld,
 	    sizeof(struct els_logo_payload));
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3075, "LOGO buffer:");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x010a,
+		       elsio->u.els_logo.els_logo_pyld,
+		       sizeof(*elsio->u.els_logo.els_logo_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -2676,7 +2688,8 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3073,
 		    "PLOGI ELS IOCB:\n");
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
-		    (uint8_t *)els_iocb, 0x70);
+		    (uint8_t *)els_iocb,
+		    sizeof(*els_iocb));
 	} else {
 		els_iocb->control_flags = 1 << 13;
 		els_iocb->tx_byte_count =
@@ -2688,6 +2701,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		els_iocb->rx_byte_count = 0;
 		els_iocb->rx_address = 0;
 		els_iocb->rx_len = 0;
+		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3076,
+		       "LOGO ELS IOCB:");
+		ql_dump_buffer(ql_log_info, vha, 0x010b,
+			       els_iocb,
+			       sizeof(*els_iocb));
 	}
 
 	sp->vha->qla_stats.control_requests++;
@@ -2934,7 +2952,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3073, "PLOGI buffer:\n");
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x0109,
-	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld, 0x70);
+	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
+	    sizeof(*elsio->u.els_plogi.els_plogi_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2601d7673c37..7b8a6bfcf08d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1061,8 +1061,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			ql_dbg(ql_dbg_async, vha, 0x5011,
 			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
 			    mb[1], mb[2], mb[3]);
-
-			qlt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -1079,8 +1077,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
-
-		qlt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0cf94f05f008..b7c1108c48e2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3921,6 +3921,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					vha->d_id.b24 = 0;
 					vha->d_id.b.al_pa = 1;
 					ha->flags.n2n_bigger = 1;
+					ha->flags.n2n_ae = 0;
 
 					id.b.al_pa = 2;
 					ql_dbg(ql_dbg_async, vha, 0x5075,
@@ -3931,6 +3932,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					    "Format 1: Remote login - Waiting for WWPN %8phC.\n",
 					    rptid_entry->u.f1.port_name);
 					ha->flags.n2n_bigger = 0;
+					ha->flags.n2n_ae = 1;
 				}
 				qla24xx_post_newsess_work(vha, &id,
 				    rptid_entry->u.f1.port_name,
@@ -3942,7 +3944,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			/* if our portname is higher then initiate N2N login */
 
 			set_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags);
-			ha->flags.n2n_ae = 1;
 			return;
 			break;
 		case TOPO_FL:
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f2d5115b2d8d..bbe90354f49b 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -847,15 +847,15 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_sec = start;
 			break;
 		case FLT_REG_FW_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_fw_sec = start;
 			break;
 		case FLT_REG_BOOTLOAD_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_boot_sec = start;
 			break;
 		case FLT_REG_AUX_IMG_PRI_28XX:
@@ -2725,8 +2725,11 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
 		    "Region %x is secure\n", region.code);
 
-		if (region.code == FLT_REG_FW ||
-		    region.code == FLT_REG_FW_SEC_27XX) {
+		switch (region.code) {
+		case FLT_REG_FW:
+		case FLT_REG_FW_SEC_27XX:
+		case FLT_REG_MPI_PRI_28XX:
+		case FLT_REG_MPI_SEC_28XX:
 			fw_array = dwptr;
 
 			/* 1st fw array */
@@ -2757,9 +2760,23 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				buf_size_without_sfub += risc_size;
 				fw_array += risc_size;
 			}
-		} else {
-			ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
-			    "Secure region %x not supported\n",
+			break;
+
+		case FLT_REG_PEP_PRI_28XX:
+		case FLT_REG_PEP_SEC_28XX:
+			fw_array = dwptr;
+
+			/* 1st fw array */
+			risc_size = be32_to_cpu(fw_array[3]);
+			risc_attr = be32_to_cpu(fw_array[9]);
+
+			buf_size_without_sfub = risc_size;
+			fw_array += risc_size;
+			break;
+
+		default:
+			ql_log(ql_log_warn + ql_dbg_verbose, vha,
+			    0xffff, "Secure region %x not supported\n",
 			    region.code);
 			rval = QLA_COMMAND_ERROR;
 			goto done;
@@ -2880,7 +2897,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    "Sending Secure Flash MB Cmd\n");
 			rval = qla28xx_secure_flash_update(vha, 0, region.code,
 				buf_size_without_sfub, sfub_dma,
-				sizeof(struct secure_flash_update_block));
+				sizeof(struct secure_flash_update_block) >> 2);
 			if (rval != QLA_SUCCESS) {
 				ql_log(ql_log_warn, vha, 0xffff,
 				    "Secure Flash MB Cmd failed %x.", rval);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 51b275a575a5..68c14143e50e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1104,6 +1104,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
+	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
@@ -1160,7 +1161,6 @@ void qlt_unreg_sess(struct fc_port *sess)
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
 
-	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	queue_work(sess->vha->hw->wq, &sess->free_work);
 }
 EXPORT_SYMBOL(qlt_unreg_sess);
@@ -1265,7 +1265,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
 	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
 }
 
@@ -4804,6 +4803,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 
 	switch (sess->disc_state) {
 	case DSC_DELETED:
+	case DSC_LOGIN_PEND:
 		qlt_plogi_ack_unref(vha, pla);
 		break;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 042a24314edc..abe7f79bb789 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -246,6 +246,8 @@ static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
  */
 static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 {
+	if (!mcmd)
+		return;
 	INIT_WORK(&mcmd->free_work, tcm_qla2xxx_complete_mcmd);
 	queue_work(tcm_qla2xxx_free_wq, &mcmd->free_work);
 }
@@ -348,6 +350,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8c674eca09f1..2323432a0edb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4275,7 +4275,6 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 	return QLA_SUCCESS;
 
 mem_alloc_error_exit:
-	qla4xxx_mem_free(ha);
 	return QLA_ERROR;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 417b868d8735..ed8d9709b9b9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -24,6 +24,8 @@
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
+#define ISCSI_SEND_MAX_ALLOWED  10
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/iscsi.h>
 
@@ -3682,6 +3684,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		struct nlmsghdr	*nlh;
 		struct iscsi_uevent *ev;
 		uint32_t group;
+		int retries = ISCSI_SEND_MAX_ALLOWED;
 
 		nlh = nlmsg_hdr(skb);
 		if (nlh->nlmsg_len < sizeof(*nlh) + sizeof(*ev) ||
@@ -3712,6 +3715,10 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
+			if (err == -EAGAIN && --retries < 0) {
+				printk(KERN_WARNING "Send reply failed, error %d\n", err);
+				break;
+			}
 		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
 		skb_pull(skb, rlen);
 	}
diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index b2af04c57a39..6feeb0faf123 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -99,6 +99,12 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
 	 */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 
+	/*
+	 * Disabling Autohibern8 feature in cadence UFS
+	 * to mask unexpected interrupt trigger.
+	 */
+	hba->ahit = 0;
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index baeecee35d1e..53dd87628cbe 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -203,7 +203,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	bsg_dev->parent = get_device(parent);
 	bsg_dev->release = ufs_bsg_node_release;
 
-	dev_set_name(bsg_dev, "ufs-bsg");
+	dev_set_name(bsg_dev, "ufs-bsg%u", shost->host_no);
 
 	ret = device_add(bsg_dev);
 	if (ret)
