Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5955477E43
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573472; cv=none; b=tf10Mx2nBgKnyRzkvfNI6mt22zJNPHW/f/qKywslO/1Cq3tho405kETtmtlxG4NnytU27nOU6heY43d8Fs1diaveo28umkbHmlxLt6kt4cRUyXgQf3VK9+ZZgNyOVlbfYWMnyb9ZxS6f6gabbMmU7+deBEd5AgbCqOsC1YmM6Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573472; c=relaxed/simple;
	bh=Ai+Z8LgPRtAek8zo60rptsjGvYx+oadFcveQVB+e0iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTiu/X0kS70JCowWxaoEMfh6gavm2RpbVDHZhaEV05PI7+HkKjd9DbkkUOiVswMtKzKcq+l9EQrTNSG191q6sDHgvmlBdG0T+cCVQXxb73yeW1HqwTueto/Q3TimUImf4uqJ4aCSWHCBnwYCEvkd8+SSWMeeFg9lNo5AKGO8Vfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3j6cyDIZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3j6cyDIZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62d827TYzlfvpH;
	Thu, 30 Apr 2026 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573460; x=1780165461; bh=XcAnB
	5JPkLYO8B0NrF2IwY4MYvn379R3G66Moz52924=; b=3j6cyDIZaIM4Xs6vytA4Q
	sM68ppV3REnTnjJijWW2Eq1Ixo5FKQHZV83DNYlnbA4Ek4REK7SX9aFloDx3x/un
	iHoFkVXejY1Bf5mK170KDhTwVqALSXtgYZfQsIKUl6PttOchxkeu/8cZH0AKi5yg
	EHHtWLTT7TGCbDCD1d3baTes4nyXfxspiu+56l/n3x4Q6HZCj2RDFr7mnrcg8p9J
	wqaK3bQ+jjJ5CpYmOLGE5O09Rjw/nef3c90/Muqdl4Ik8KAF5gZCuFZ4gaozF8go
	zDrGHZv+43wGW7NYT8BeOuGZKkfAVHvVI2Z+jSQ8VJM0FmSGTjJpVOx0TSmmSP1/
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iU7Lb-YP8KtD; Thu, 30 Apr 2026 18:24:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62cx6NxYzlfl89;
	Thu, 30 Apr 2026 18:24:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 39/56] scsi: megaraid_sas: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:20:09 -0700
Message-ID: <20260430182130.1978347-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
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
index 2699e4e09b5b..664bec111474 100644
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
@@ -4530,6 +4531,7 @@ static int
 megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 	uint channel, uint id, u16 smid_task, u8 type,
 	struct MR_PRIV_DEVICE *mr_device_priv_data)
+	__must_hold(&instance->reset_mutex)
 {
 	struct MR_TASK_MANAGE_REQUEST *mr_request;
 	struct MPI2_SCSI_TASK_MANAGE_REQUEST *mpi_request;
