Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEC73DC4CC
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451729; cv=none; b=Ge4/hYP1WUSD0iYLSSn/pYMHq2Rhnh/G6zfMKdF7mNGfvHSqDQgxR2/bemQ9l0jWScddaAytVYy/G+yW/waLZVrAYTMtcXRZufquvjacyBa4nHimhoznirnH2NMlenrrnlccEv5tBr/+kWZd79Q6eatLY/TopoAgaFPzWazn1A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451729; c=relaxed/simple;
	bh=GkKKt38ovT6SvKdvExo8yLlLsxwy44yVIual607NhKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLYJLnWPYpspGalibspEcfQww+PDQQIu6jjCPQCOXE+oLEG8imsWUC+ssmBDpEq5u8r5KLyATZqRxC/+ppng8Mtl07UD1C2BuPp4dohCEmpSlZb/flLGv5bjMex8gAQtwJ/8dcQdswmsVHGGH2QTHwL8/pK2eunkXuZLTuY5SD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uG7kXSwq; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uG7kXSwq"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4B74VBQz1XM6Jm;
	Thu, 30 Jul 2026 22:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451718; x=1788043719; bh=F0yAv
	2/sJ0Dqdu8LjWeTmgnzc3E6KVr/WrLwt3NFpHU=; b=uG7kXSwqprrHgOiXeCjpM
	Sy6OyJYuYKxSxy3ty40l3bUjaGR4AOSO/6NKk6xTCwegCFB6HODaARGZQAaBzRzZ
	1w4VGYf0Dn9O7HsnUPN5Pu8DPLVgRAxMJxwuLLT0jsoxwguz2C0/89/9yKKfwb/c
	KECiKHvoPCGOWSUcIg5nsJFgnQBBwM94xm6y8gNoUIE32ENoivchY/Mp06nzJr3K
	63OkYK/p+RrOZ7a4hqon5ivK3oP7fuGd8SBg21bz1pMhKSZ8RBy6E6AO1AULDDTM
	YqP/Vb7ova3sMfrp4tbcvSleWXeuiLJhiZgSJh+/8M5heKsikR9ScwwZWdG0E2A/
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 45-JM-YOTQe6; Thu, 30 Jul 2026 22:48:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49w0krJz1XM30r;
	Thu, 30 Jul 2026 22:48:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 39/57] scsi: megaraid_sas: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:22 -0700
Message-ID: <5b1efea947bc2923e205d7c920b15b356fc4eeff.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  9 ++++++---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 15 ++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 ++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid=
/megaraid_sas.h
index 8ee2bfe47571..67713173793a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2696,15 +2696,18 @@ __le16 get_updated_dev_handle(struct megasas_inst=
ance *instance,
 			      struct MR_DRV_RAID_MAP_ALL *drv_map);
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
 	struct LD_LOAD_BALANCE_INFO *lbInfo);
-int megasas_get_ctrl_info(struct megasas_instance *instance);
+int megasas_get_ctrl_info(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex);
 /* PD sequence */
 int
 megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend);
 void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 		struct queue_limits *lim, bool is_target_prop);
 int megasas_get_target_prop(struct megasas_instance *instance,
-			    struct scsi_device *sdev);
-void megasas_get_snapdump_properties(struct megasas_instance *instance);
+			    struct scsi_device *sdev)
+	__must_hold(&instance->reset_mutex);
+void megasas_get_snapdump_properties(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex);
=20
 int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	u8 crash_buf_state);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index ecd365d78ae3..ccefe5841a17 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -132,14 +132,16 @@ MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
 MODULE_DESCRIPTION("Broadcom MegaRAID SAS Driver");
=20
 int megasas_transition_to_ready(struct megasas_instance *instance, int o=
cr);
-static int megasas_get_pd_list(struct megasas_instance *instance);
+static int megasas_get_pd_list(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex);
 static int megasas_ld_list_query(struct megasas_instance *instance,
 				 u8 query_type);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
 static void megasas_get_pd_info(struct megasas_instance *instance,
-				struct scsi_device *sdev);
+				struct scsi_device *sdev)
+	__must_hold(&instance->reset_mutex);
 static void
 megasas_set_ld_removed_by_fw(struct megasas_instance *instance);
=20
@@ -229,7 +231,8 @@ megasas_adp_reset_gen2(struct megasas_instance *insta=
nce,
 		       struct megasas_register_set __iomem *reg_set);
 static irqreturn_t megasas_isr(int irq, void *devp);
 static u32
-megasas_init_adapter_mfi(struct megasas_instance *instance);
+megasas_init_adapter_mfi(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex);
 u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
@@ -4754,6 +4757,7 @@ megasas_get_pd_list(struct megasas_instance *instan=
ce)
  */
 static int
 megasas_get_ld_list(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex)
 {
 	int ret =3D 0, ld_index =3D 0, ids =3D 0;
 	struct megasas_cmd *cmd;
@@ -4871,6 +4875,7 @@ megasas_get_ld_list(struct megasas_instance *instan=
ce)
  */
 static int
 megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
+	__must_hold(&instance->reset_mutex)
 {
 	int ret =3D 0, ld_index =3D 0, ids =3D 0;
 	struct megasas_cmd *cmd;
@@ -4993,6 +4998,7 @@ megasas_ld_list_query(struct megasas_instance *inst=
ance, u8 query_type)
 static int
 megasas_host_device_list_query(struct megasas_instance *instance,
 			       bool is_probe)
+	__must_hold(&instance->reset_mutex)
 {
 	int ret, i, target_id;
 	struct megasas_cmd *cmd;
@@ -5874,6 +5880,7 @@ static void megasas_setup_reply_map(struct megasas_=
instance *instance)
  */
 static
 int megasas_get_device_list(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex)
 {
 	if (instance->enable_fw_dev_list) {
 		if (megasas_host_device_list_query(instance, true))
@@ -7789,6 +7796,7 @@ megasas_suspend(struct device *dev)
  */
 static int __maybe_unused
 megasas_resume(struct device *dev)
+	__must_hold(&((struct megasas_instance *)dev_get_drvdata(dev))->reset_m=
utex)
 {
 	int rval;
 	struct Scsi_Host *host;
@@ -8765,6 +8773,7 @@ static inline void megasas_remove_scsi_device(struc=
t scsi_device *sdev)
 static
 int megasas_update_device_list(struct megasas_instance *instance,
 			       int event_type)
+	__must_hold(&instance->reset_mutex)
 {
 	int dcmd_ret;
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
index 056cbe50e19e..a55094a31c82 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1792,6 +1792,7 @@ static inline void megasas_free_ioc_init_cmd(struct=
 megasas_instance *instance)
  */
 static u32
 megasas_init_adapter_fusion(struct megasas_instance *instance)
+	__must_hold(&instance->reset_mutex)
 {
 	struct fusion_context *fusion;
 	u32 scratch_pad_1;
@@ -4539,6 +4540,7 @@ static int
 megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 	uint channel, uint id, u16 smid_task, u8 type,
 	struct MR_PRIV_DEVICE *mr_device_priv_data)
+	__must_hold(&instance->reset_mutex)
 {
 	struct MR_TASK_MANAGE_REQUEST *mr_request;
 	struct MPI2_SCSI_TASK_MANAGE_REQUEST *mpi_request;
