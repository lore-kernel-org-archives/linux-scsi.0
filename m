Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18C3C2BC11
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F77207DE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="X35m3bAL";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="X35m3bAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbgIHUIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:08:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34704 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730179AbgIHPTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 11:19:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 4906D8EE111;
        Tue,  8 Sep 2020 08:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599578326;
        bh=K1FLNItfKGcOpnDIkIbrXdyYnqFr+9vdgACBPKfcOqg=;
        h=Subject:From:To:Cc:Date:From;
        b=X35m3bALDXGfIcqMzJhgrtKtrPJaR+1VuXI3zGTfRdErDevrUTYmyA+91hq1Xmxye
         zwoPTI/eqSt1pYLw/FmV01uKtSUUN23Ncwbrbv4fyS8h/TynKzRm4Z5OImUoBl4Uae
         y1hH9DbOXBH1zh+TBSTPvRpoWdIqE9lb/uwPlgxw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tOgwsp5SygsG; Tue,  8 Sep 2020 08:18:46 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id BFC3C8EE0C6;
        Tue,  8 Sep 2020 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599578326;
        bh=K1FLNItfKGcOpnDIkIbrXdyYnqFr+9vdgACBPKfcOqg=;
        h=Subject:From:To:Cc:Date:From;
        b=X35m3bALDXGfIcqMzJhgrtKtrPJaR+1VuXI3zGTfRdErDevrUTYmyA+91hq1Xmxye
         zwoPTI/eqSt1pYLw/FmV01uKtSUUN23Ncwbrbv4fyS8h/TynKzRm4Z5OImUoBl4Uae
         y1hH9DbOXBH1zh+TBSTPvRpoWdIqE9lb/uwPlgxw=
Message-ID: <1599578324.10803.12.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.9-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 08 Sep 2020 08:18:44 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eleven fixes, mostly in drivers or minor fixes in driver related
infrastructure libraries (target, libfc and libsas).  Most of the bugs
fixed only show up under rare circumstances, the exception being the
endianness problem in qla2xxx which is used as a device on some sparc
systems.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dinghao Liu (1):
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

James Smart (4):
      scsi: lpfc: Update lpfc version to 12.8.0.4
      scsi: lpfc: Extend the RDF FPIN Registration descriptor for additional events
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
      scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask

Javed Hasan (1):
      scsi: libfc: Fix for double free()

Luo Jiaxing (1):
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

René Rebe (1):
      scsi: qla2xxx: Fix regression on sparc64

Tomas Henzl (2):
      scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
      scsi: megaraid_sas: Don't call disable_irq from process IRQ poll

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

And the diffstat:

 drivers/scsi/libfc/fc_disc.c                |  2 --
 drivers/scsi/libsas/sas_ata.c               |  5 ++++-
 drivers/scsi/lpfc/lpfc_els.c                |  7 ++++++-
 drivers/scsi/lpfc/lpfc_hw4.h                |  2 +-
 drivers/scsi/lpfc/lpfc_init.c               |  1 -
 drivers/scsi/lpfc/lpfc_version.h            |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  2 +-
 drivers/scsi/pm8001/pm8001_sas.c            |  2 +-
 drivers/scsi/qla2xxx/qla_def.h              |  2 +-
 drivers/scsi/qla2xxx/qla_init.c             |  6 +++---
 drivers/target/iscsi/iscsi_target.c         | 17 +++++++++++++++--
 drivers/target/iscsi/iscsi_target_login.c   |  6 +++---
 drivers/target/iscsi/iscsi_target_login.h   |  3 +--
 drivers/target/iscsi/iscsi_target_nego.c    |  3 +--
 15 files changed, 39 insertions(+), 23 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index d8cbc9c0e766..e67abb184a8a 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -634,8 +634,6 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
-	if (!IS_ERR(fp))
-		fc_frame_free(fp);
 }
 
 /**
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1b93332daa6b..8b424c8ab834 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -209,7 +209,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = si;
 	}
 
-	task->data_dir = qc->dma_dir;
+	if (qc->tf.protocol == ATA_PROT_NODATA)
+		task->data_dir = DMA_NONE;
+	else
+		task->data_dir = qc->dma_dir;
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 48dc63f22cca..f4e274eb6c9c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3517,6 +3517,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 				FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));
 	prdf->reg_d1.reg_desc.count = cpu_to_be32(ELS_RDF_REG_TAG_CNT);
 	prdf->reg_d1.desc_tags[0] = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
+	prdf->reg_d1.desc_tags[1] = cpu_to_be32(ELS_DTAG_DELIVERY);
+	prdf->reg_d1.desc_tags[2] = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
+	prdf->reg_d1.desc_tags[3] = cpu_to_be32(ELS_DTAG_CONGESTION);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue RDF:       did:x%x",
@@ -4656,7 +4659,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
+		if (mbox)
+			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
+		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(shost->host_lock);
 
 		/* If the node is not being used by another discovery thread,
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index c4ba8273a63f..12e4e76233e6 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4800,7 +4800,7 @@ struct send_frame_wqe {
 	uint32_t fc_hdr_wd5;           /* word 15 */
 };
 
-#define ELS_RDF_REG_TAG_CNT		1
+#define ELS_RDF_REG_TAG_CNT		4
 struct lpfc_els_rdf_reg_desc {
 	struct fc_df_desc_fpin_reg	reg_desc;	/* descriptor header */
 	__be32				desc_tags[ELS_RDF_REG_TAG_CNT];
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c69725999315..ca25e54bb782 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11376,7 +11376,6 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hdl *eqhdl)
 {
 	cpumask_clear(&eqhdl->aff_mask);
 	irq_clear_status_flags(eqhdl->irq, IRQ_NO_BALANCING);
-	irq_set_affinity_hint(eqhdl->irq, &eqhdl->aff_mask);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 20adec4387f0..c657abf22b75 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.8.0.3"
+#define LPFC_DRIVER_VERSION "12.8.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0824410f78f8..0e143020a9fb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3689,7 +3689,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 	instance = irq_ctx->instance;
 
 	if (irq_ctx->irq_line_enable) {
-		disable_irq(irq_ctx->os_irq);
+		disable_irq_nosync(irq_ctx->os_irq);
 		irq_ctx->irq_line_enable = false;
 	}
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1d64524cd863..5850569a8396 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1733,7 +1733,7 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 	reply_q = container_of(irqpoll, struct adapter_reply_queue,
 			irqpoll);
 	if (reply_q->irq_line_enable) {
-		disable_irq(reply_q->os_irq);
+		disable_irq_nosync(reply_q->os_irq);
 		reply_q->irq_line_enable = false;
 	}
 	num_entries = _base_process_reply_queue(reply_q);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 337e79d6837f..9889bab7d31c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -818,7 +818,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1bc090d8a71b..a165120d2976 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1626,7 +1626,7 @@ typedef struct {
 	 */
 	uint8_t	 firmware_options[2];
 
-	uint16_t frame_payload_size;
+	__le16	frame_payload_size;
 	__le16	max_iocb_allocation;
 	__le16	execution_throttle;
 	uint8_t	 retry_count;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 57a2d76aa691..4ff75d9fc125 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4603,18 +4603,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 2048;
+			nv->frame_payload_size = cpu_to_le16(2048);
 			nv->special_options[1] = BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] = BIT_3 | BIT_1;
 			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = cpu_to_le16(1024);
 		}
 
 		nv->max_iocb_allocation = cpu_to_le16(256);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c9689610e186..2ec778e97b1b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1389,14 +1389,27 @@ static u32 iscsit_do_crypto_hash_sg(
 	sg = cmd->first_data_sg;
 	page_off = cmd->first_data_sg_off;
 
+	if (data_length && page_off) {
+		struct scatterlist first_sg;
+		u32 len = min_t(u32, data_length, sg->length - page_off);
+
+		sg_init_table(&first_sg, 1);
+		sg_set_page(&first_sg, sg_page(sg), len, sg->offset + page_off);
+
+		ahash_request_set_crypt(hash, &first_sg, NULL, len);
+		crypto_ahash_update(hash);
+
+		data_length -= len;
+		sg = sg_next(sg);
+	}
+
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
+		u32 cur_len = min_t(u32, data_length, sg->length);
 
 		ahash_request_set_crypt(hash, sg, NULL, cur_len);
 		crypto_ahash_update(hash);
 
 		data_length -= cur_len;
-		page_off = 0;
 		/* iscsit_map_iovec has already checked for invalid sg pointers */
 		sg = sg_next(sg);
 	}
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 85748e338858..893d1b406c29 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1149,7 +1149,7 @@ void iscsit_free_conn(struct iscsi_conn *conn)
 }
 
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
-		struct iscsi_np *np, bool zero_tsih, bool new_sess)
+				 bool zero_tsih, bool new_sess)
 {
 	if (!new_sess)
 		goto old_sess_out;
@@ -1167,7 +1167,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	conn->sess = NULL;
 
 old_sess_out:
-	iscsi_stop_login_thread_timer(np);
 	/*
 	 * If login negotiation fails check if the Time2Retain timer
 	 * needs to be restarted.
@@ -1407,8 +1406,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 new_sess_out:
 	new_sess = true;
 old_sess_out:
+	iscsi_stop_login_thread_timer(np);
 	tpg_np = conn->tpg_np;
-	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
+	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
 	new_sess = false;
 
 	if (tpg) {
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 3b8e3639ff5d..fc95e6150253 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -22,8 +22,7 @@ extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
-extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-				bool, bool);
+extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
 extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f88a52fec889..8b40f10976ff 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -535,12 +535,11 @@ static bool iscsi_target_sk_check_and_clear(struct iscsi_conn *conn, unsigned in
 
 static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
 {
-	struct iscsi_np *np = login->np;
 	bool zero_tsih = login->zero_tsih;
 
 	iscsi_remove_failed_auth_entry(conn);
 	iscsi_target_nego_release(conn);
-	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
+	iscsi_target_login_sess_out(conn, zero_tsih, true);
 }
 
 struct conn_timeout {
