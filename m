Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A180CA9ED0
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D633F2085B
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rFIm/DZP";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rFIm/DZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfKBBHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 21:07:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32772 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfKBBHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 21:07:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 71D558EE16B;
        Fri,  1 Nov 2019 18:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1572656829;
        bh=GqQD4nOZhsUGGox09TnYbfcB+/jMb7K09jZQvLZ8nUM=;
        h=Subject:From:To:Cc:Date:From;
        b=rFIm/DZPo/7KC8khfiK2eAYI8wsU0UroMc9Cq0JeBb0qxcSnQVYOaaWTJ6Nv/4WXh
         b79jwY2dE5EmJs7JxVSTeOsGcIzY1KRyo+gnVIMajcGtJH2IekLMrIWfUQhCC2GYQL
         QqVUDUViBJqCoHdJvPefODU8XI/x9ZWCfiEU3TLk=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fGIbicr3zDoY; Fri,  1 Nov 2019 18:07:09 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CB7D68EE144;
        Fri,  1 Nov 2019 18:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1572656829;
        bh=GqQD4nOZhsUGGox09TnYbfcB+/jMb7K09jZQvLZ8nUM=;
        h=Subject:From:To:Cc:Date:From;
        b=rFIm/DZPo/7KC8khfiK2eAYI8wsU0UroMc9Cq0JeBb0qxcSnQVYOaaWTJ6Nv/4WXh
         b79jwY2dE5EmJs7JxVSTeOsGcIzY1KRyo+gnVIMajcGtJH2IekLMrIWfUQhCC2GYQL
         QqVUDUViBJqCoHdJvPefODU8XI/x9ZWCfiEU3TLk=
Message-ID: <1572656827.19347.17.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.4-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 01 Nov 2019 18:07:07 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nine changes, eight in drivers [ufs, target, lpfc x 2, qla2xxx x 4] and
one core change in sd that fixes an I/O failure on DIF type 3 devices.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Avri Altman (1):
      scsi: ufs-bsg: Wake the device before sending raw upiu commands

Bart Van Assche (1):
      scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Daniel Wagner (2):
      scsi: lpfc: Honor module parameter lpfc_use_adisc
      scsi: lpfc: Check queue pointer before use

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Himanshu Madhani (1):
      scsi: qla2xxx: Initialized mailbox to prevent driver load failure

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Quinn Tran (1):
      scsi: qla2xxx: Fix partial flash write of MBI

Xiang Chen (1):
      scsi: sd: define variable dif as unsigned int instead of bool

And the diffstat:

 drivers/scsi/lpfc/lpfc_nportdisc.c      | 4 ++--
 drivers/scsi/lpfc/lpfc_sli.c            | 2 +-
 drivers/scsi/qla2xxx/qla_attr.c         | 7 +++----
 drivers/scsi/qla2xxx/qla_bsg.c          | 6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c          | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c           | 4 ++++
 drivers/scsi/sd.c                       | 3 ++-
 drivers/scsi/ufs/ufs_bsg.c              | 4 ++++
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 3 ++-
 9 files changed, 23 insertions(+), 13 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f4b879d25fe9..fc6e4546d738 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -851,9 +851,9 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	if (!(vport->fc_flag & FC_PT2PT)) {
 		/* Check config parameter use-adisc or FCP-2 */
-		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
+		if (vport->cfg_use_adisc && ((vport->fc_flag & FC_RSCN_MODE) ||
 		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
-		     (ndlp->nlp_type & NLP_FCP_TARGET))) {
+		     (ndlp->nlp_type & NLP_FCP_TARGET)))) {
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_ADISC;
 			spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a0c6945b8139..614f78dddafe 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7866,7 +7866,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 	if (sli4_hba->hdwq) {
 		for (eqidx = 0; eqidx < phba->cfg_irq_chann; eqidx++) {
 			eq = phba->sli4_hba.hba_eq_hdl[eqidx].eq;
-			if (eq->queue_id == sli4_hba->mbx_cq->assoc_qid) {
+			if (eq && eq->queue_id == sli4_hba->mbx_cq->assoc_qid) {
 				fpeq = eq;
 				break;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8b3015361428..8705ca6395e4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -440,9 +440,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		valid = 0;
 		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
 			valid = 1;
-		else if (start == (ha->flt_region_boot * 4) ||
-		    start == (ha->flt_region_fw * 4))
-			valid = 1;
 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 			valid = 1;
 		if (!valid) {
@@ -489,8 +486,10 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    "Writing flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size);
 
-		ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+		rval = ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
+		if (rval)
+			rval = -EIO;
 		break;
 	default:
 		rval = -EINVAL;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 28d587a89ba6..99f0a1a08143 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -253,7 +253,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	srb_t *sp;
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
-	int rval =  (DRIVER_ERROR << 16);
+	int rval =  (DID_ERROR << 16);
 	uint16_t nextlid = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
@@ -432,7 +432,7 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	int rval = (DRIVER_ERROR << 16);
+	int rval = (DID_ERROR << 16);
 	int req_sg_cnt, rsp_sg_cnt;
 	uint16_t loop_id;
 	struct fc_port *fcport;
@@ -1950,7 +1950,7 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
-	int rval = (DRIVER_ERROR << 16);
+	int rval = (DID_ERROR << 16);
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 	srb_t *sp;
 	int req_sg_cnt = 0, rsp_sg_cnt = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1cc6913f76c4..4a1f21c11758 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -702,6 +702,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
 		mcp->mb[4] = 0;
+		mcp->mb[11] = 0;
 		ha->flags.using_lr_setting = 0;
 		if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
 		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -746,7 +747,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		if (ha->flags.exchoffld_enabled)
 			mcp->mb[4] |= ENABLE_EXCHANGE_OFFLD;
 
-		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
+		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
 		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e4d765fc03ea..39f7782a133b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3529,6 +3529,10 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_try_to_stop_firmware(vha);
 	}
 
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
 	/* Turn adapter off line */
 	vha->flags.online = 0;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0f96eb0ddbfa..fe05475ce5dc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1166,11 +1166,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	sector_t threshold;
 	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
-	bool dif, dix;
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
 	blk_status_t ret;
+	unsigned int dif;
+	bool dix;
 
 	ret = scsi_init_io(cmd);
 	if (ret != BLK_STS_OK)
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index a9344eb4e047..dc2f6d2b46ed 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -98,6 +98,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	bsg_reply->reply_payload_rcv_len = 0;
 
+	pm_runtime_get_sync(hba->dev);
+
 	msgcode = bsg_request->msgcode;
 	switch (msgcode) {
 	case UPIU_TRANSACTION_QUERY_REQ:
@@ -135,6 +137,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	}
 
+	pm_runtime_put_sync(hba->dev);
+
 	if (!desc_buff)
 		goto out;
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 22dd4c457d6a..23a90c685dc6 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1829,7 +1829,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	while (credits) {
 		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
-		const u32 csum = (__force u32)p->csum;
+		u32 csum;
 
 		if (unlikely(!p)) {
 			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
@@ -1838,6 +1838,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 			break;
 		}
 
+		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
 			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
 				csk,  csk->tid,
