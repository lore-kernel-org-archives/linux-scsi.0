Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D344D2EC6;
	Tue,  8 Sep 2026 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858249; cv=none; b=TKu861vHWBuzc4wrsjC8DfgG9ApU4NOvxF/J6huG4VR8QFgJXRbAiFRLybVzGODyNS0k+YbyMMy12tuDvGMUin+hSapwhNlEjNyfNn3Tpl4BB8rGLu08eIsxWntx+HGs/1gWJrjVJmTkn3t3vIlooOwtBNgI0ZdCPdtMzLYLwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858249; c=relaxed/simple;
	bh=cSczZ3QRqYuQCLLzBvdoJDHmpHHSAs4gQQltF0evkno=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDUb5/pzHvq1KpRzTDWM9/iKW6Csgyg37GN+CAydtn1c61BpAybIQcHH0pPUDwS875zyrAQxKBRns7JsJ1L3jCV7xHRVF6VI6C8JERquVEgeuOIh5Iy9jyteckpVMU7aXuWHfCVRhKfgWDv4vW10NU6IUmJLCE4RBjOO6j89FqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPiZaene; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPiZaene"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579C11F00A3A;
	Tue,  8 Sep 2026 09:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858242;
	bh=f2xnZcg2gq7aEhceEG0I8BvUo7HOs+PaT4HeLlx+Ii0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=iPiZaeneS3vktYbZwzSU4DLcwZNU+e2pHPWVzj5eqkg+JIHpVDNBK+o4bjI2NCtNB
	 DW1jMW4CL4ICEueXbGBlnRpYUqUudCfVcsB/IC+Yd0wXwDWsj5l8wjpPJMD+a6P2WP
	 1xuXfYZ0qNxlCnrA3lICfwZiS6y815UnX3CE/lNOOao/ewyOrg1Gb7owfnJxITO1nG
	 vaNXlXzbbrWYTlxQiEIAdik555XTEVZ+6Qt3YHpaXSpSu7XZMc25U6AeqfmK2w781Z
	 83G8ofIGIyAopFW+Jr1tbiTnJEQjg2xRdOYPvFBJX36k5s00wWYTMbDmCEwUdGkCg0
	 e2uZAOTUMYz5Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:52 +0900
Message-ID: <20260908090308.1085097-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the qla2xxx driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

While at it, the declaration function qlt_send_resp_ctio(), which is
modified to take a single 16-bits sense code argument, is changed to a
static function declaration since that function is used only in the file
where it is defined.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c    |  9 ++-
 drivers/scsi/qla2xxx/qla_target.c | 99 ++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h |  3 -
 3 files changed, 57 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 63b70d4abbf0..89c2af3fee4f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3263,21 +3263,24 @@ qla2x00_handle_dif_error(srb_t *sp, void *pkt)
 
 	/* check guard */
 	if (e_guard != a_guard) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
 
 	/* check ref tag */
 	if (e_ref_tag != a_ref_tag) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
 
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		return 1;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 53a505df8da0..431a59d499b3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2243,18 +2243,20 @@ void qlt_free_ul_mcmd(struct qla_hw_data *ha, struct qla_tgt_mgmt_cmd *mcmd)
  * ha->hardware_lock supposed to be held on entry. Might drop it, then
  * reacquire
  */
-void qlt_send_resp_ctio(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
-    uint8_t scsi_status, uint8_t sense_key, uint8_t asc, uint8_t ascq)
+static void qlt_send_resp_ctio(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
+    uint8_t scsi_status, uint8_t sense_key, uint16_t sense_code)
 {
 	struct atio_from_isp *atio = &cmd->atio;
 	struct ctio7_to_24xx *ctio;
 	uint16_t temp;
 	struct scsi_qla_host *vha = cmd->vha;
+	uint8_t asc = scsi_sense_code_asc(sense_code);
+	uint8_t ascq = scsi_sense_code_ascq(sense_code);
 
 	ql_dbg(ql_dbg_tgt_dif, vha, 0x3066,
 	    "Sending response CTIO7 (vha=%p, atio=%p, scsi_status=%02x, "
 	    "sense_key=%02x, asc=%02x, ascq=%02x",
-	    vha, atio, scsi_status, sense_key, asc, ascq);
+	       vha, atio, scsi_status, sense_key, asc, ascq);
 
 	ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs(vha, NULL);
 	if (!ctio) {
@@ -2677,44 +2679,47 @@ static void qlt_print_dif_err(struct qla_tgt_prm *prm)
 {
 	struct qla_tgt_cmd *cmd;
 	struct scsi_qla_host *vha;
+	u16 scode;
 
 	/* asc 0x10=dif error */
-	if (prm->sense_buffer && (prm->sense_buffer[12] == 0x10)) {
-		cmd = prm->cmd;
-		vha = cmd->vha;
-		/* ASCQ */
-		switch (prm->sense_buffer[13]) {
-		case 1:
-			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00b,
-			    "BE detected Guard TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
-			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
-			    cmd->atio.u.isp24.exchange_addr);
-			break;
-		case 2:
-			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00c,
-			    "BE detected APP TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
-			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
-			    cmd->atio.u.isp24.exchange_addr);
-			break;
-		case 3:
-			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00f,
-			    "BE detected REF TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
-			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
-			    cmd->atio.u.isp24.exchange_addr);
-			break;
-		default:
-			ql_dbg(ql_dbg_tgt_dif, vha, 0xe010,
-			    "BE detected Dif ERR: lba[%llx|%lld] len[%x] "
-			    "se_cmd=%p tag[%x]",
-			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
-			    cmd->atio.u.isp24.exchange_addr);
-			break;
-		}
-		ql_dump_buffer(ql_dbg_tgt_dif, vha, 0xe011, cmd->cdb, 16);
+	if (!prm->sense_buffer ||
+	    prm->sense_buffer[12] != ASC_ID_CRC_OR_ECC_ERROR)
+		return;
+
+	cmd = prm->cmd;
+	vha = cmd->vha;
+	scode = scsi_sense_code(prm->sense_buffer[12], prm->sense_buffer[13]);
+	switch (scode) {
+	case LOGICAL_BLOCK_GUARD_CHECK_FAILED:
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xe00b,
+		       "BE detected Guard TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+		       "se_cmd=%p tag[%x]",
+		       cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+		       cmd->atio.u.isp24.exchange_addr);
+		break;
+	case LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED:
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xe00c,
+		       "BE detected APP TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+		       "se_cmd=%p tag[%x]",
+		       cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+		       cmd->atio.u.isp24.exchange_addr);
+		break;
+	case LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED:
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xe00f,
+		       "BE detected REF TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+		       "se_cmd=%p tag[%x]",
+		       cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+		       cmd->atio.u.isp24.exchange_addr);
+		break;
+	default:
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xe010,
+		       "BE detected Dif ERR: lba[%llx|%lld] len[%x] "
+		       "se_cmd=%p tag[%x]",
+		       cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+		       cmd->atio.u.isp24.exchange_addr);
+		break;
 	}
+	ql_dump_buffer(ql_dbg_tgt_dif, vha, 0xe011, cmd->cdb, 16);
 }
 
 /*
@@ -3467,7 +3472,8 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	uint8_t		*ap = &sts->actual_dif[0];
 	uint8_t		*ep = &sts->expected_dif[0];
 	uint64_t	lba = cmd->se_cmd.t_task_lba;
-	uint8_t scsi_status, sense_key, asc, ascq;
+	uint8_t scsi_status, sense_key;
+	uint16_t sense_code = 0;
 	struct scsi_qla_host *vha = cmd->vha;
 
 	cmd->trc_flags |= TRC_DIF_ERR;
@@ -3483,7 +3489,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	ql_dbg(ql_dbg_tgt_dif, vha, 0xf075,
 	    "%s: aborted %d state %d\n", __func__, cmd->aborted, cmd->state);
 
-	scsi_status = sense_key = asc = ascq = 0;
+	scsi_status = sense_key = 0;
 
 	/* check appl tag */
 	if (cmd->e_app_tag != cmd->a_app_tag) {
@@ -3497,8 +3503,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		cmd->dif_err_code = DIF_ERR_APP;
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		sense_key = ABORTED_COMMAND;
-		asc = 0x10;
-		ascq = 0x2;
+		sense_code = LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED;
 	}
 
 	/* check ref tag */
@@ -3513,8 +3518,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		cmd->dif_err_code = DIF_ERR_REF;
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		sense_key = ABORTED_COMMAND;
-		asc = 0x10;
-		ascq = 0x3;
+		sense_code = LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED;
 		goto out;
 	}
 
@@ -3530,8 +3534,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		cmd->dif_err_code = DIF_ERR_GRD;
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		sense_key = ABORTED_COMMAND;
-		asc = 0x10;
-		ascq = 0x1;
+		sense_code = LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 	}
 out:
 	switch (cmd->state) {
@@ -3547,8 +3550,8 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 			break;
 		}
 
-		qlt_send_resp_ctio(qpair, cmd, scsi_status, sense_key, asc,
-		    ascq);
+		qlt_send_resp_ctio(qpair, cmd, scsi_status, sense_key,
+				   sense_code);
 		/* assume scsi status gets out on the wire.
 		 * Will not wait for completion.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 61072fb41b29..71bc1affb1bc 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1178,7 +1178,4 @@ extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_logo_completion_handler(fc_port_t *, int);
 extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
-void qlt_send_resp_ctio(struct qla_qpair *, struct qla_tgt_cmd *, uint8_t,
-    uint8_t, uint8_t, uint8_t);
-
 #endif /* __QLA_TARGET_H */
-- 
2.55.0

