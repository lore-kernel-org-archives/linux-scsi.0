Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09927BF78;
	Thu, 24 Apr 2025 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745522955; cv=none; b=r2Xbe4pPgZS0y4dm4vxl65zxQrv7+TA/mNCy86kbLkD+RgvQ4beiNaGmt0FqJiZQ714eroPUWl5qFPzyaYzVDSy3YMPPPOtcbe9qMzJXaA0198vYWQkE7RdGd1YNMnvE/DsnmjfFIs8aMUh+ei9ifI/3tkcrVGd9KgDs+wGYo7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745522955; c=relaxed/simple;
	bh=0qifbnWRlYW0Nn3J7ah2cJcMtGKeozh2QNokmEtCmLo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=M3mqPu/5FHbSWIJej9eX2ckcXb9nVn/GbSvsKmLZnPkq1dqFXxkXo+0JRJzp3FIKPsFd0tASTXcNIxNTeHWXtE3bOBg/YbJkqFxh5JT9AVwaxXTyEgM/lFXKAzjCjA5YrN/+LyYWXL3h/0KXICN/cQYrdy42fUVSB6SK4t04FFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Q/Q2UnV8; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Q/Q2UnV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1745522951;
	bh=0qifbnWRlYW0Nn3J7ah2cJcMtGKeozh2QNokmEtCmLo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=Q/Q2UnV8saa/oP6gRV41tNMsHoWFt5HFh9BBZY5+LkP6ad5DNZXfqSNcxWAxZDNtI
	 5IbzQm6KV1JZlHAJGuf+ac2MX3ZiyE0wG6PWHFWAEkg8jhrlL21xoQHokllREFIsRm
	 EL0bFeBOO7B0szmiWi1Wy56DIggGwfvNnITUfTx0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E08141C0332;
	Thu, 24 Apr 2025 15:29:10 -0400 (EDT)
Message-ID: <b574ba430d181f9fa53a6a7bd76e42911c50d899.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.15-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2025 15:29:10 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The single core change is an obvious bug fix (and falls within the LF
guidelines for patches from sanctioned entities).  The other driver
changes are a bit larger but likewise pretty obvious.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anastasia Kovaleva (1):
      scsi: core: Clear flags for scsi_cmnd that did not complete

Chenyuan Yang (2):
      scsi: ufs: core: Add NULL check in ufshcd_mcq_compl_pending_transfer(=
)
      scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()

Dmitry Bogdanov (1):
      scsi: target: iscsi: Fix timeout on deleted connection

Manish Pandey (2):
      scsi: ufs: Introduce quirk to extend PA_HIBERN8TIME for UFS devices
      scsi: ufs: qcom: Add quirks for Samsung UFS devices

Ranjan Kumar (3):
      scsi: mpi3mr: Add level check to control event logging
      scsi: mpi3mr: Reset the pending interrupt flag
      scsi: mpi3mr: Fix pending I/O counter

And the diffstat:

 drivers/scsi/mpi3mr/mpi3mr_fw.c     |  8 ++++++-
 drivers/scsi/scsi_lib.c             |  6 +++++-
 drivers/target/iscsi/iscsi_target.c |  2 +-
 drivers/ufs/core/ufs-mcq.c          | 12 +++++------
 drivers/ufs/core/ufshcd.c           | 31 ++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c         | 43 +++++++++++++++++++++++++++++++++=
++++
 drivers/ufs/host/ufs-qcom.h         | 18 ++++++++++++++++
 include/ufs/ufs_quirks.h            |  6 ++++++
 8 files changed, 116 insertions(+), 10 deletions(-)


With full diff below.

James

---

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_f=
w.c
index 3fcb1ad3b070..1d7901a8f0e4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -174,6 +174,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *=
mrioc,
 	char *desc =3D NULL;
 	u16 event;
=20
+	if (!(mrioc->logging_level & MPI3_DEBUG_EVENT))
+		return;
+
 	event =3D event_reply->event;
=20
 	switch (event) {
@@ -451,6 +454,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mri=
oc)
 		return 0;
 	}
=20
+	atomic_set(&mrioc->admin_pend_isr, 0);
 	reply_desc =3D (struct mpi3_default_reply_descriptor *)mrioc->admin_reply=
_base +
 	    admin_reply_ci;
=20
@@ -565,7 +569,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
-		atomic_dec(&op_reply_q->pend_ios);
+
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;
@@ -2925,6 +2929,7 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc=
 *mrioc)
 	mrioc->admin_reply_ci =3D 0;
 	mrioc->admin_reply_ephase =3D 1;
 	atomic_set(&mrioc->admin_reply_q_in_use, 0);
+	atomic_set(&mrioc->admin_pend_isr, 0);
=20
 	if (!mrioc->admin_req_base) {
 		mrioc->admin_req_base =3D dma_alloc_coherent(&mrioc->pdev->dev,
@@ -4653,6 +4658,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	if (mrioc->admin_reply_base)
 		memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
 	atomic_set(&mrioc->admin_reply_q_in_use, 0);
+	atomic_set(&mrioc->admin_pend_isr, 0);
=20
 	if (mrioc->init_cmds.reply) {
 		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0d29470e86b0..1b43013d72c0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1253,8 +1253,12 @@ EXPORT_SYMBOL_GPL(scsi_alloc_request);
  */
 static void scsi_cleanup_rq(struct request *rq)
 {
+	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+
+	cmd->flags =3D 0;
+
 	if (rq->rq_flags & RQF_DONTPREP) {
-		scsi_mq_uninit_cmd(blk_mq_rq_to_pdu(rq));
+		scsi_mq_uninit_cmd(cmd);
 		rq->rq_flags &=3D ~RQF_DONTPREP;
 	}
 }
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 1244ef3aa86c..620ba6e0ab07 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4263,8 +4263,8 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
=20
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
+	iscsit_stop_nopin_response_timer(conn);
=20
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 240ce135bbfb..f1294c29f484 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -677,13 +677,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int err;
=20
-	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
-		dev_err(hba->dev,
-			"%s: skip abort. cmd at tag %d already completed.\n",
-			__func__, tag);
-		return FAILED;
-	}
-
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
@@ -692,6 +685,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	}
=20
 	hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+	if (!hwq) {
+		dev_err(hba->dev, "%s: skip abort. cmd at tag %d already completed.\n",
+			__func__, tag);
+		return FAILED;
+	}
=20
 	if (ufshcd_mcq_sqe_search(hba, hwq, tag)) {
 		/*
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 44156041d88f..5cb6132b8147 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -278,6 +278,7 @@ static const struct ufs_dev_quirk ufs_fixups[] =3D {
 	  .model =3D UFS_ANY_MODEL,
 	  .quirk =3D UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
 		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
+		   UFS_DEVICE_QUIRK_PA_HIBER8TIME |
 		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
 	{ .wmanufacturerid =3D UFS_VENDOR_SKHYNIX,
 	  .model =3D UFS_ANY_MODEL,
@@ -5677,6 +5678,8 @@ static void ufshcd_mcq_compl_pending_transfer(struct =
ufs_hba *hba,
 			continue;
=20
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			continue;
=20
 		if (force_compl) {
 			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
@@ -8470,6 +8473,31 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struc=
t ufs_hba *hba)
 	return ret;
 }
=20
+/**
+ * ufshcd_quirk_override_pa_h8time - Ensures proper adjustment of PA_HIBER=
N8TIME.
+ * @hba: per-adapter instance
+ *
+ * Some UFS devices require specific adjustments to the PA_HIBERN8TIME par=
ameter
+ * to ensure proper hibernation timing. This function retrieves the curren=
t
+ * PA_HIBERN8TIME value and increments it by 100us.
+ */
+static void ufshcd_quirk_override_pa_h8time(struct ufs_hba *hba)
+{
+	u32 pa_h8time;
+	int ret;
+
+	ret =3D ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME), &pa_h8time);
+	if (ret) {
+		dev_err(hba->dev, "Failed to get PA_HIBERN8TIME: %d\n", ret);
+		return;
+	}
+
+	/* Increment by 1 to increase hibernation time by 100 =C2=B5s */
+	ret =3D ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), pa_h8time + 1);
+	if (ret)
+		dev_err(hba->dev, "Failed updating PA_HIBERN8TIME: %d\n", ret);
+}
+
 static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 {
 	ufshcd_vops_apply_dev_quirks(hba);
@@ -8480,6 +8508,9 @@ static void ufshcd_tune_unipro_params(struct ufs_hba =
*hba)
=20
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_HIBER8TIME)
+		ufshcd_quirk_override_pa_h8time(hba);
 }
=20
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1b37449fbffc..c0761ccc1381 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -33,6 +33,10 @@
 	((((c) >> 16) & MCQ_QCFGPTR_MASK) * MCQ_QCFGPTR_UNIT)
 #define MCQ_QCFG_SIZE	0x40
=20
+/* De-emphasis for gear-5 */
+#define DEEMPHASIS_3_5_dB	0x04
+#define NO_DEEMPHASIS		0x0
+
 enum {
 	TSTBUS_UAWM,
 	TSTBUS_UARM,
@@ -795,6 +799,23 @@ static int ufs_qcom_icc_update_bw(struct ufs_qcom_host=
 *host)
 	return ufs_qcom_icc_set_bw(host, bw_table.mem_bw, bw_table.cfg_bw);
 }
=20
+static void ufs_qcom_set_tx_hs_equalizer(struct ufs_hba *hba, u32 gear, u3=
2 tx_lanes)
+{
+	u32 equalizer_val;
+	int ret, i;
+
+	/* Determine the equalizer value based on the gear */
+	equalizer_val =3D (gear =3D=3D 5) ? DEEMPHASIS_3_5_dB : NO_DEEMPHASIS;
+
+	for (i =3D 0; i < tx_lanes; i++) {
+		ret =3D ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_HS_EQUALIZER, i),
+				     equalizer_val);
+		if (ret)
+			dev_err(hba->dev, "%s: failed equalizer lane %d\n",
+				__func__, i);
+	}
+}
+
 static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status status,
 				const struct ufs_pa_layer_attr *dev_max_params,
@@ -846,6 +867,11 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *=
hba,
 						dev_req_params->gear_tx,
 						PA_INITIAL_ADAPT);
 		}
+
+		if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TX_DEEMPHASIS_TUNING)
+			ufs_qcom_set_tx_hs_equalizer(hba,
+					dev_req_params->gear_tx, dev_req_params->lane_tx);
+
 		break;
 	case POST_CHANGE:
 		if (ufs_qcom_cfg_timers(hba, false)) {
@@ -893,6 +919,16 @@ static int ufs_qcom_quirk_host_pa_saveconfigtime(struc=
t ufs_hba *hba)
 			    (pa_vs_config_reg1 | (1 << 12)));
 }
=20
+static void ufs_qcom_override_pa_tx_hsg1_sync_len(struct ufs_hba *hba)
+{
+	int err;
+
+	err =3D ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TX_HSG1_SYNC_LENGTH),
+				  PA_TX_HSG1_SYNC_LENGTH_VAL);
+	if (err)
+		dev_err(hba->dev, "Failed (%d) set PA_TX_HSG1_SYNC_LENGTH\n", err);
+}
+
 static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
 {
 	int err =3D 0;
@@ -900,6 +936,9 @@ static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hb=
a)
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
 		err =3D ufs_qcom_quirk_host_pa_saveconfigtime(hba);
=20
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TX_HSG1_SYNC_LENGTH)
+		ufs_qcom_override_pa_tx_hsg1_sync_len(hba);
+
 	return err;
 }
=20
@@ -914,6 +953,10 @@ static struct ufs_dev_quirk ufs_qcom_dev_fixups[] =3D =
{
 	{ .wmanufacturerid =3D UFS_VENDOR_WDC,
 	  .model =3D UFS_ANY_MODEL,
 	  .quirk =3D UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE },
+	{ .wmanufacturerid =3D UFS_VENDOR_SAMSUNG,
+	  .model =3D UFS_ANY_MODEL,
+	  .quirk =3D UFS_DEVICE_QUIRK_PA_TX_HSG1_SYNC_LENGTH |
+		   UFS_DEVICE_QUIRK_PA_TX_DEEMPHASIS_TUNING },
 	{}
 };
=20
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index d0e6ec9128e7..05d4cb569c50 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -122,8 +122,11 @@ enum {
 				 TMRLUT_HW_CGC_EN | OCSC_HW_CGC_EN)
=20
 /* QUniPro Vendor specific attributes */
+#define PA_TX_HSG1_SYNC_LENGTH	0x1552
 #define PA_VS_CONFIG_REG1	0x9000
 #define DME_VS_CORE_CLK_CTRL	0xD002
+#define TX_HS_EQUALIZER		0x0037
+
 /* bit and mask definitions for DME_VS_CORE_CLK_CTRL attribute */
 #define CLK_1US_CYCLES_MASK_V4				GENMASK(27, 16)
 #define CLK_1US_CYCLES_MASK				GENMASK(7, 0)
@@ -141,6 +144,21 @@ enum {
 #define UNIPRO_CORE_CLK_FREQ_201_5_MHZ         202
 #define UNIPRO_CORE_CLK_FREQ_403_MHZ           403
=20
+/* TX_HSG1_SYNC_LENGTH attr value */
+#define PA_TX_HSG1_SYNC_LENGTH_VAL	0x4A
+
+/*
+ * Some ufs device vendors need a different TSync length.
+ * Enable this quirk to give an additional TX_HS_SYNC_LENGTH.
+ */
+#define UFS_DEVICE_QUIRK_PA_TX_HSG1_SYNC_LENGTH		BIT(16)
+
+/*
+ * Some ufs device vendors need a different Deemphasis setting.
+ * Enable this quirk to tune TX Deemphasis parameters.
+ */
+#define UFS_DEVICE_QUIRK_PA_TX_DEEMPHASIS_TUNING	BIT(17)
+
 /* ICE allocator type to share AES engines among TX stream and RX stream *=
/
 #define ICE_ALLOCATOR_TYPE 2
=20
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index 41ff44dfa1db..f52de5ed1b3b 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -107,4 +107,10 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
=20
+/*
+ * Some ufs devices may need more time to be in hibern8 before exiting.
+ * Enable this quirk to give it an additional 100us.
+ */
+#define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
+
 #endif /* UFS_QUIRKS_H_ */

