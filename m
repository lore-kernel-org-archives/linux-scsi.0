Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08613F3271;
	Mon,  7 Sep 2026 02:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749075; cv=none; b=a2etl7GEqgmZoFrBIWAdxSs4mqRzUnJzp3Jx8aDYxPkqbGuIdnZi9Ydgh4mUp8vwMTjDG4LQvRUv7BCM6f7wj1vfAcZ9KvizLaRo9hP5p4f5Tofq2ZV0mHWqoafFa2Hcf7PrNrt9FlgXJzubM9I1iBtqrVP0A/fXzUzxHCw42Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749075; c=relaxed/simple;
	bh=sOMwzZa0NdnTWRIgDojYQ4IrA1+ZXGcbJ3cXi5swHiQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewrACEvfOb63aDbA65X+hcL47aUaYVyLCbFRBPXa4iAaDzw4h0Yzh2b7kLonyoQXvfxpoG9LOxMTVuwiIdBOwfaI9r6M08NqUYq6ebPNTdb/l02vHc2+wSQ9tRwayU3DW1lpj9mhaPb8gs/MA9rDtM+VjbEbBmPDAxGRDNiN3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWxvTxU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWxvTxU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189F71F00A3F;
	Mon,  7 Sep 2026 02:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749073;
	bh=CM46EwpeNLmoB+t7DBWAwvfyu7/pm89j2hxJ0rls6GE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=iWxvTxU3ioIj+wX8Kclq87EU7irfaL/8AwArzfSmpeoygrj/MdmLIR7RgYsj97Bap
	 yEsRbyZxoXaRos0pzdyfEtzE9nOZEUV3ICUmrF+M8KRLFEHh+ywFuFBDQG6Rwu4sge
	 x7N1mSfSrL1KxiPLSFaopAz2LZOcsVj1+61lHtgeWDoY519pGgZsU7O0Y88IxANbB/
	 f/gfLpfvMWINERq3AW9qiPN/dgqvKlnGFR8e9Xsl5fj9AdV/8OTNd8CydD/OcXutEI
	 9iRTkcoAkitMp/cpIbz7cclvuym7iNi8uoiQZd7Dliz43VW81qbYgvcVyJofftZFy9
	 HglwG7i/eW4HQ==
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
Subject: [PATCH v5 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:27 +0900
Message-ID: <20260907024343.1046387-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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

