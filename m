Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E9EC47404
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 04:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D8A222C0
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 04:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e53bBB1g";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="O4QhNatz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfJEEoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 00:44:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40948 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbfJEEoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Oct 2019 00:44:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 392978EE21D;
        Fri,  4 Oct 2019 21:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570250663;
        bh=kFm0N/8064CBrz4jmRuMbGNxo4f2gEpa3dF55eUmKQw=;
        h=Subject:From:To:Cc:Date:From;
        b=e53bBB1gz5BURiyMSjqwPcxjDOCNy1UCaqmdGsRV98C6rINYKKjcv2VpHbNOrWOAG
         MidwP3MkuLDOCViBEiAEsicvo5R4xbLEgAAy2ikSwlHySnw2XOdveUCed/cGtGr67q
         elBg2Nkx2IpbDybTvoJCiXG/bEzFSBpcIbhlCXwQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C8So0B_hREq0; Fri,  4 Oct 2019 21:44:20 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CD3CB8EE0EE;
        Fri,  4 Oct 2019 21:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570250659;
        bh=kFm0N/8064CBrz4jmRuMbGNxo4f2gEpa3dF55eUmKQw=;
        h=Subject:From:To:Cc:Date:From;
        b=O4QhNatzVAaET6gBrwmhn741LLYYmRDLP8QbTNblapkg+4v883DQmZp8gy5S8EQqP
         sNLYXD8eweppedoPPrDXK9pVp/79LnQJoW7TSD52GDepkRJHBxqo/CekLy3b6VYP8+
         vAIqyKEhdZS6YZz9MJyVih+0XuvS+hhOXnuMX96E=
Message-ID: <1570250655.17537.18.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.4-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 04 Oct 2019 21:44:15 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Twelve patches mostly small but obvious fixes or cosmetic but small
updates, all in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Austin Kim (1):
      scsi: qedf: Remove always false 'tmp_prio < 0' statement

Himanshu Madhani (1):
      scsi: qla2xxx: Silence fwdump template message

Laurence Oberman (1):
      scsi: bnx2fc: Handle scope bits when array returns BUSY or TSF

Long Li (1):
      scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue

Quinn Tran (6):
      scsi: qla2xxx: Fix Nport ID display value
      scsi: qla2xxx: Fix N2N link up fail
      scsi: qla2xxx: Fix N2N link reset
      scsi: qla2xxx: Optimize NPIV tear down process
      scsi: qla2xxx: Fix stale mem access on driver unload
      scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Stanley Chu (1):
      scsi: ufs: skip shutdown if hba is not powered

Xiang Chen (1):
      scsi: megaraid: disable device when probe failed after enabled device

YueHaibing (1):
      scsi: hisi_sas: Make three functions static

And the diffstat:

 drivers/scsi/bnx2fc/bnx2fc_io.c       |  29 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_main.c |   6 +-
 drivers/scsi/megaraid.c               |   4 +-
 drivers/scsi/qedf/qedf_main.c         |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c       |   2 +
 drivers/scsi/qla2xxx/qla_def.h        |   4 +-
 drivers/scsi/qla2xxx/qla_gs.c         |   3 +-
 drivers/scsi/qla2xxx/qla_init.c       | 109 ++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_iocb.c       |   7 ++-
 drivers/scsi/qla2xxx/qla_mbx.c        |  25 +++++++-
 drivers/scsi/qla2xxx/qla_mid.c        |  32 ++++++----
 drivers/scsi/qla2xxx/qla_os.c         |  18 ++++--
 drivers/scsi/qla2xxx/qla_target.c     |  26 ++++----
 drivers/scsi/storvsc_drv.c            |   3 +-
 drivers/scsi/ufs/ufshcd.c             |   3 +
 15 files changed, 193 insertions(+), 80 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index da00ca5fa5dc..401743e2b429 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1923,6 +1923,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	struct fcoe_fcp_rsp_payload *fcp_rsp;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct scsi_cmnd *sc_cmd;
+	u16 scope = 0, qualifier = 0;
 
 	/* scsi_cmd_cmpl is called with tgt lock held */
 
@@ -1990,12 +1991,30 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 
 			if (io_req->cdb_status == SAM_STAT_TASK_SET_FULL ||
 			    io_req->cdb_status == SAM_STAT_BUSY) {
-				/* Set the jiffies + retry_delay_timer * 100ms
-				   for the rport/tgt */
-				tgt->retry_delay_timestamp = jiffies +
-					fcp_rsp->retry_delay_timer * HZ / 10;
+				/* Newer array firmware with BUSY or
+				 * TASK_SET_FULL may return a status that needs
+				 * the scope bits masked.
+				 * Or a huge delay timestamp up to 27 minutes
+				 * can result.
+				 */
+				if (fcp_rsp->retry_delay_timer) {
+					/* Upper 2 bits */
+					scope = fcp_rsp->retry_delay_timer
+						& 0xC000;
+					/* Lower 14 bits */
+					qualifier = fcp_rsp->retry_delay_timer
+						& 0x3FFF;
+				}
+				if (scope > 0 && qualifier > 0 &&
+					qualifier <= 0x3FEF) {
+					/* Set the jiffies +
+					 * retry_delay_timer * 100ms
+					 * for the rport/tgt
+					 */
+					tgt->retry_delay_timestamp = jiffies +
+						(qualifier * HZ / 10);
+				}
 			}
-
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d1513fdf1e00..0847e682797b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3683,7 +3683,7 @@ void hisi_sas_debugfs_work_handler(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_work_handler);
 
-void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
+static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	int i;
@@ -3705,7 +3705,7 @@ void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
 }
 
-int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
+static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
@@ -3796,7 +3796,7 @@ int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	return -ENOMEM;
 }
 
-void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
+static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 {
 	hisi_hba->debugfs_bist_dentry =
 			debugfs_create_dir("bist", hisi_hba->debugfs_dir);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 45a66048801b..ff6d4aa92421 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4183,11 +4183,11 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ &&
 		    pdev->subsystem_device == 0xC000)
-		   	return -ENODEV;
+			goto out_disable_device;
 		/* Now check the magic signature byte */
 		pci_read_config_word(pdev, PCI_CONF_AMISIG, &magic);
 		if (magic != HBA_SIGNATURE_471 && magic != HBA_SIGNATURE)
-			return -ENODEV;
+			goto out_disable_device;
 		/* Ok it is probably a megaraid */
 	}
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9c24f3834d70..1d2c111bdf82 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -596,7 +596,7 @@ static void qedf_dcbx_handler(void *dev, struct qed_dcbx_get *get, u32 mib_type)
 		tmp_prio = get->operational.app_prio.fcoe;
 		if (qedf_default_prio > -1)
 			qedf->prio = qedf_default_prio;
-		else if (tmp_prio < 0 || tmp_prio > 7) {
+		else if (tmp_prio > 7) {
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
 			    "FIP/FCoE prio %d out of range, setting to %d.\n",
 			    tmp_prio, QEDF_DEFAULT_PRIO);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e9c449ef515c..8b3015361428 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2920,6 +2920,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t id = vha->vp_idx;
 
+	set_bit(VPORT_DELETE, &vha->dpc_flags);
+
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 873a6aef1c5c..6ffa9877c28b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2396,6 +2396,7 @@ typedef struct fc_port {
 	unsigned int query:1;
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
+	unsigned int n2n_flag:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2446,7 +2447,6 @@ typedef struct fc_port {
 	uint8_t fc4_type;
 	uint8_t	fc4f_nvme;
 	uint8_t scan_state;
-	uint8_t n2n_flag;
 
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
@@ -3036,6 +3036,7 @@ enum scan_flags_t {
 enum fc4type_t {
 	FS_FC4TYPE_FCP	= BIT_0,
 	FS_FC4TYPE_NVME	= BIT_1,
+	FS_FCP_IS_N2N = BIT_7,
 };
 
 struct fab_scan_rp {
@@ -4394,6 +4395,7 @@ typedef struct scsi_qla_host {
 #define IOCB_WORK_ACTIVE	31
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
+#define VPORT_DELETE		34
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dc0e36676313..5298ed10059f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3102,7 +3102,8 @@ int qla24xx_post_gpnid_work(struct scsi_qla_host *vha, port_id_t *id)
 {
 	struct qla_work_evt *e;
 
-	if (test_bit(UNLOADING, &vha->dpc_flags))
+	if (test_bit(UNLOADING, &vha->dpc_flags) ||
+	    (vha->vp_idx && test_bit(VPORT_DELETE, &vha->dpc_flags)))
 		return 0;
 
 	e = qla2x00_alloc_work(vha, QLA_EVT_GPNID);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b6cdf108994c..67f522a8a9d4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -746,12 +746,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			break;
 		default:
 			if ((id.b24 != fcport->d_id.b24 &&
-			    fcport->d_id.b24) ||
+			    fcport->d_id.b24 &&
+			    fcport->loop_id != FC_NO_LOOP_ID) ||
 			    (fcport->loop_id != FC_NO_LOOP_ID &&
 				fcport->loop_id != loop_id)) {
 				ql_dbg(ql_dbg_disc, vha, 0x20e3,
 				    "%s %d %8phC post del sess\n",
 				    __func__, __LINE__, fcport->port_name);
+				if (fcport->n2n_flag)
+					fcport->d_id.b24 = 0;
 				qlt_schedule_sess_for_deletion(fcport);
 				return;
 			}
@@ -759,6 +762,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		}
 
 		fcport->loop_id = loop_id;
+		if (fcport->n2n_flag)
+			fcport->d_id.b24 = id.b24;
 
 		wwn = wwn_to_u64(fcport->port_name);
 		qlt_find_sess_invalidate_other(vha, wwn,
@@ -972,7 +977,7 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
 		wwn = wwn_to_u64(e->port_name);
 
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20e8,
-		    "%s %8phC %02x:%02x:%02x state %d/%d lid %x \n",
+		    "%s %8phC %02x:%02x:%02x CLS %x/%x lid %x \n",
 		    __func__, (void *)&wwn, e->port_id[2], e->port_id[1],
 		    e->port_id[0], e->current_login_state, e->last_login_state,
 		    (loop_id & 0x7fff));
@@ -1499,7 +1504,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
 
-	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP &&
+	    !N2N_TOPO(vha->hw)) {
 		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			return 0;
@@ -1570,8 +1576,9 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				qla24xx_post_gpdb_work(vha, fcport, 0);
 			}  else {
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
-				    "%s %d %8phC post NVMe PRLI\n",
-				    __func__, __LINE__, fcport->port_name);
+				    "%s %d %8phC post %s PRLI\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->fc4f_nvme ? "NVME" : "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1853,17 +1860,38 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		if (ea->fcport->n2n_flag) {
+		if (ea->fcport->fc4f_nvme) {
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post fc4 prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->fc4f_nvme = 0;
-			ea->fcport->n2n_flag = 0;
 			qla24xx_post_prli_work(vha, ea->fcport);
+			return;
+		}
+
+		/* at this point both PRLI NVME & PRLI FCP failed */
+		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt < 3) {
+				ea->fcport->n2n_link_reset_cnt++;
+				/*
+				 * remote port is not sending Plogi. Reset
+				 * link to kick start his state machine
+				 */
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2119,
+				    "%s %d %8phC Unable to reconnect\n",
+				    __func__, __LINE__, ea->fcport->port_name);
+			}
+		} else {
+			/*
+			 * switch connect. login failed. Take connection
+			 * down and allow relogin to retrigger
+			 */
+			ea->fcport->flags &= ~FCF_ASYNC_SENT;
+			ea->fcport->keep_nport_handle = 0;
+			qlt_schedule_sess_for_deletion(ea->fcport);
 		}
-		ql_dbg(ql_dbg_disc, vha, 0x2119,
-		    "%s %d %8phC unhandle event of %x\n",
-		    __func__, __LINE__, ea->fcport->port_name, ea->data[0]);
 		break;
 	}
 }
@@ -3190,7 +3218,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 
 		for (j = 0; j < 2; j++, fwdt++) {
 			if (!fwdt->template) {
-				ql_log(ql_log_warn, vha, 0x00ba,
+				ql_dbg(ql_dbg_init, vha, 0x00ba,
 				    "-> fwdt%u no template\n", j);
 				continue;
 			}
@@ -5000,28 +5028,47 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	unsigned long flags;
 
 	/* Inititae N2N login. */
-	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
-		/* borrowing */
-		u32 *bp, i, sz;
-
-		memset(ha->init_cb, 0, ha->init_cb_size);
-		sz = min_t(int, sizeof(struct els_plogi_payload),
-		    ha->init_cb_size);
-		rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
-		    (void *)ha->init_cb, sz);
-		if (rval == QLA_SUCCESS) {
-			bp = (uint32_t *)ha->init_cb;
-			for (i = 0; i < sz/4 ; i++, bp++)
-				*bp = cpu_to_be32(*bp);
+	if (N2N_TOPO(ha)) {
+		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
+			/* borrowing */
+			u32 *bp, i, sz;
+
+			memset(ha->init_cb, 0, ha->init_cb_size);
+			sz = min_t(int, sizeof(struct els_plogi_payload),
+			    ha->init_cb_size);
+			rval = qla24xx_get_port_login_templ(vha,
+			    ha->init_cb_dma, (void *)ha->init_cb, sz);
+			if (rval == QLA_SUCCESS) {
+				bp = (uint32_t *)ha->init_cb;
+				for (i = 0; i < sz/4 ; i++, bp++)
+					*bp = cpu_to_be32(*bp);
 
-			memcpy(&ha->plogi_els_payld.data, (void *)ha->init_cb,
-			    sizeof(ha->plogi_els_payld.data));
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		} else {
-			ql_dbg(ql_dbg_init, vha, 0x00d1,
-			    "PLOGI ELS param read fail.\n");
+				memcpy(&ha->plogi_els_payld.data,
+				    (void *)ha->init_cb,
+				    sizeof(ha->plogi_els_payld.data));
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			} else {
+				ql_dbg(ql_dbg_init, vha, 0x00d1,
+				    "PLOGI ELS param read fail.\n");
+				goto skip_login;
+			}
+		}
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->n2n_flag) {
+				qla24xx_fcport_handle_login(vha, fcport);
+				return QLA_SUCCESS;
+			}
+		}
+skip_login:
+		spin_lock_irqsave(&vha->work_lock, flags);
+		vha->scan.scan_retry++;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+
+		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
-		return QLA_SUCCESS;
 	}
 
 	found_devs = 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e92e52aa6e9b..518eb954cf42 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2656,9 +2656,10 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	els_iocb->s_id[0] = vha->d_id.b.al_pa;
-	els_iocb->s_id[1] = vha->d_id.b.area;
-	els_iocb->s_id[2] = vha->d_id.b.domain;
+	/* For SID the byte order is different than DID */
+	els_iocb->s_id[1] = vha->d_id.b.al_pa;
+	els_iocb->s_id[2] = vha->d_id.b.area;
+	els_iocb->s_id[0] = vha->d_id.b.domain;
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
 		els_iocb->control_flags = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4c858e2d0ea8..1cc6913f76c4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2249,7 +2249,7 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x105a,
+	ql_dbg(ql_dbg_disc, vha, 0x105a,
 	    "Entered %s.\n", __func__);
 
 	if (IS_CNA_CAPABLE(vha->hw)) {
@@ -3883,14 +3883,24 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		case TOPO_N2N:
 			ha->current_topology = ISP_CFG_N;
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+			list_for_each_entry(fcport, &vha->vp_fcports, list) {
+				fcport->scan_state = QLA_FCPORT_SCAN;
+				fcport->n2n_flag = 0;
+			}
+
 			fcport = qla2x00_find_fcport_by_wwpn(vha,
 			    rptid_entry->u.f1.port_name, 1);
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 			if (fcport) {
 				fcport->plogi_nack_done_deadline = jiffies + HZ;
-				fcport->dm_login_expire = jiffies + 3*HZ;
+				fcport->dm_login_expire = jiffies + 2*HZ;
 				fcport->scan_state = QLA_FCPORT_FOUND;
+				fcport->n2n_flag = 1;
+				fcport->keep_nport_handle = 1;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4f_nvme = 1;
+
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
 					set_bit(RELOGIN_NEEDED,
@@ -3924,7 +3934,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				    rptid_entry->u.f1.port_name,
 				    rptid_entry->u.f1.node_name,
 				    NULL,
-				    FC4_TYPE_UNKNOWN);
+				    FS_FCP_IS_N2N);
 			}
 
 			/* if our portname is higher then initiate N2N login */
@@ -4023,6 +4033,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			fcport->scan_state = QLA_FCPORT_SCAN;
+			fcport->n2n_flag = 0;
 		}
 
 		fcport = qla2x00_find_fcport_by_wwpn(vha,
@@ -4032,6 +4043,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			fcport->login_retry = vha->hw->login_retry_count;
 			fcport->plogi_nack_done_deadline = jiffies + HZ;
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->keep_nport_handle = 1;
+			fcport->n2n_flag = 1;
+			fcport->d_id.b.domain =
+				rptid_entry->u.f2.remote_nport_id[2];
+			fcport->d_id.b.area =
+				rptid_entry->u.f2.remote_nport_id[1];
+			fcport->d_id.b.al_pa =
+				rptid_entry->u.f2.remote_nport_id[0];
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 1a9a11ae7285..6afad68e5ba2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -66,6 +66,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
+	u8 i;
 
 	mutex_lock(&ha->vport_lock);
 	/*
@@ -75,8 +76,9 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	wait_event_timeout(vha->vref_waitq, !atomic_read(&vha->vref_count),
-	    10*HZ);
+	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
+		wait_event_timeout(vha->vref_waitq,
+		    atomic_read(&vha->vref_count), HZ);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	if (atomic_read(&vha->vref_count)) {
@@ -262,6 +264,9 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
+			if (test_bit(VPORT_DELETE, &vha->dpc_flags))
+				continue;
+
 			atomic_inc(&vha->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -300,6 +305,20 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 int
 qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 {
+	fc_port_t *fcport;
+
+	/*
+	 * To exclusively reset vport, we need to log it out first.
+	 * Note: This control_vp can fail if ISP reset is already
+	 * issued, this is expected, as the vp would be already
+	 * logged out due to ISP reset.
+	 */
+	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
+		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
+		list_for_each_entry(fcport, &vha->vp_fcports, list)
+			fcport->logout_on_delete = 0;
+	}
+
 	/*
 	 * Physical port will do most of the abort and recovery work. We can
 	 * just treat it as a loop down
@@ -312,16 +331,9 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	}
 
-	/*
-	 * To exclusively reset vport, we need to log it out first.  Note: this
-	 * control_vp can fail if ISP reset is already issued, this is
-	 * expected, as the vp would be already logged out due to ISP reset.
-	 */
-	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
-		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
-
 	ql_dbg(ql_dbg_taskm, vha, 0x801d,
 	    "Scheduling enable of Vport %d.\n", vha->vp_idx);
+
 	return qla24xx_enable_vp(vha);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 51154c049385..ee47de9fbc05 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1115,9 +1115,15 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
 void
 qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 {
+	u8 i;
+
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha), 10*HZ);
+	for (i = 0; i < 10; i++)
+		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
+		    HZ);
+
+	flush_workqueue(vha->hw->wq);
 }
 
 /*
@@ -5027,6 +5033,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
+
+			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N)
+				fcport->n2n_flag = 1;
+
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 				   "%s %8phC mem alloc fail.\n",
@@ -5125,11 +5135,9 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			if (dfcp)
 				qlt_schedule_sess_for_deletion(tfcp);
 
-
-			if (N2N_TOPO(vha->hw))
-				fcport->flags &= ~FCF_FABRIC_DEVICE;
-
 			if (N2N_TOPO(vha->hw)) {
+				fcport->flags &= ~FCF_FABRIC_DEVICE;
+				fcport->keep_nport_handle = 1;
 				if (vha->flags.nvme_enabled) {
 					fcport->fc4f_nvme = 1;
 					fcport->n2n_flag = 1;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0ffda6171614..a06e56224a55 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -953,7 +953,7 @@ void qlt_free_session_done(struct work_struct *work)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	bool logout_started = false;
-	scsi_qla_host_t *base_vha;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	struct qlt_plogi_ack_t *own =
 		sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 
@@ -1020,6 +1020,7 @@ void qlt_free_session_done(struct work_struct *work)
 
 	if (logout_started) {
 		bool traced = false;
+		u16 cnt = 0;
 
 		while (!READ_ONCE(sess->logout_completed)) {
 			if (!traced) {
@@ -1029,6 +1030,9 @@ void qlt_free_session_done(struct work_struct *work)
 				traced = true;
 			}
 			msleep(100);
+			cnt++;
+			if (cnt > 200)
+				break;
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
@@ -1101,6 +1105,7 @@ void qlt_free_session_done(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	sess->free_pending = 0;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
@@ -1109,17 +1114,9 @@ void qlt_free_session_done(struct work_struct *work)
 	if (tgt && (tgt->sess_count == 0))
 		wake_up_all(&tgt->waitQ);
 
-	if (vha->fcport_count == 0)
-		wake_up_all(&vha->fcport_waitQ);
-
-	base_vha = pci_get_drvdata(ha->pdev);
-
-	sess->free_pending = 0;
-
-	if (test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags))
-		return;
-
-	if ((!tgt || !tgt->tgt_stop) && !LOOP_TRANSITION(vha)) {
+	if (!test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags) &&
+	    !(vha->vp_idx && test_bit(VPORT_DELETE, &vha->dpc_flags)) &&
+	    (!tgt || !tgt->tgt_stop) && !LOOP_TRANSITION(vha)) {
 		switch (vha->host->active_mode) {
 		case MODE_INITIATOR:
 		case MODE_DUAL:
@@ -1132,6 +1129,9 @@ void qlt_free_session_done(struct work_struct *work)
 			break;
 		}
 	}
+
+	if (vha->fcport_count == 0)
+		wake_up_all(&vha->fcport_waitQ);
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -1161,7 +1161,7 @@ void qlt_unreg_sess(struct fc_port *sess)
 	sess->last_login_gen = sess->login_gen;
 
 	INIT_WORK(&sess->free_work, qlt_free_session_done);
-	schedule_work(&sess->free_work);
+	queue_work(sess->vha->hw->wq, &sess->free_work);
 }
 EXPORT_SYMBOL(qlt_unreg_sess);
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ed8b9ac805e6..542d2bac2922 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1837,8 +1837,7 @@ static int storvsc_probe(struct hv_device *device,
 	/*
 	 * Set the number of HW queues we are supporting.
 	 */
-	if (stor_device->num_sc != 0)
-		host->nr_hw_queues = stor_device->num_sc + 1;
+	host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c4a015e42045..57b2c3a8def3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8140,6 +8140,9 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	int ret = 0;
 
+	if (!hba->is_powered)
+		goto out;
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 

