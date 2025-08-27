Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F30A926
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253551; cv=none; b=KkRgVodeUdiReLHTtuQ0ArjxiUjAYAKMQSoNTxeBS8V7bt5KCJjssbL8LkpIape52C7aC1Pg2dSSHPyifQ1XGA1Rx4KwQi+56CU2IFIHtSmGveZuEj1uJ1pwD8EmFoL1Qzk2JwJIAGVSxnGS2Hdrv1XioBICH8Fa5MP0IDb1PXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253551; c=relaxed/simple;
	bh=Lq3rFuxtvS3i5jD67HVfMvmYQDbH9141rbOt+cXchyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB4rzJd3T+69qOlTYqfUh6d0YBrtyb99GgGTNdvRHu6ds0F6RHOK6DC5sfqALnSegpbMUVdkX8O6BpQATxv3rOGGGvKUWB+SNFQPLDm0RIbHEXDsKCDw2ZZCao3uG0nIWj2L6y3i8Dc3nwk7atVIJZhs7G7FKx5gNuRhOHsRgUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eIp99AQ1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eIp99AQ1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ2h36V4zm0yVM;
	Wed, 27 Aug 2025 00:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253546; x=1758845547; bh=3z6LC
	9yYkeaz9JEg00OkKeI/LHh/mOs6ngXDu/FBPMw=; b=eIp99AQ1LtvzrzHFtxJ0b
	M6MnnhsiJWFfVnBYud+TW27/MJ29L/oD1kcDYUm4P1qoPAEOg3claao/M8rZvh0h
	NGRlinr8oF4wlnTz0/vimDaAFKFqntSEpVGQy9gFc8a2z5jRnVXHwPYPFoVtl1Un
	Li9D006rutOU4xY/FILQcK6iJbQEB+xBL9a2pdp1Z5HNeSL2fGP0yjxabw8HYK7g
	Cujc6T3frUrQBadm7KgVhWZ/bebheEg4RUShyZwCqB4afRCHP8+92swdHvCPNfaX
	hg2/CYY8VMX/n64wS5y+IntC6qiVhiE3FF8+TXMpeO2h7Z0p+JadRuLKLxRN6ku+
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7AzvC05MTEP2; Wed, 27 Aug 2025 00:12:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ2Z52f8zm1742;
	Wed, 27 Aug 2025 00:12:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 23/26] ufs: core: Pass a SCSI pointer instead of an LRB pointer
Date: Tue, 26 Aug 2025 17:06:27 -0700
Message-ID: <20250827000816.2370150-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for removing the ufshcd_lrb task_tag member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ecb4a9f30cb8..6ff8582c038c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2818,12 +2818,13 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(stru=
ct scsi_cmnd *cmd,
 /**
  * ufshcd_prepare_utp_query_req_upiu() - fill the utp_transfer_req_desc =
for query request
  * @hba: UFS hba
- * @lrbp: local reference block pointer
+ * @cmd: SCSI command pointer
  * @upiu_flags: flags
  */
 static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
-				struct ufshcd_lrb *lrbp, u8 upiu_flags)
+				struct scsi_cmnd *cmd, u8 upiu_flags)
 {
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
 	struct ufs_query *query =3D &hba->dev_cmd.query;
 	u16 len =3D be16_to_cpu(query->request.upiu_req.length);
@@ -2852,8 +2853,9 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
t ufs_hba *hba,
 		memcpy(ucd_req_ptr + 1, query->descriptor, len);
 }
=20
-static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
+static inline void ufshcd_prepare_utp_nop_upiu(struct scsi_cmnd *cmd)
 {
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
=20
 	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
@@ -2868,22 +2870,23 @@ static inline void ufshcd_prepare_utp_nop_upiu(st=
ruct ufshcd_lrb *lrbp)
  * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
  * @hba: per adapter instance
- * @lrbp: pointer to local reference block
+ * @cmd: SCSI command pointer
  *
  * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
-				      struct ufshcd_lrb *lrbp)
+				      struct scsi_cmnd *cmd)
 {
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	u8 upiu_flags;
 	int ret =3D 0;
=20
 	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
=20
 	if (hba->dev_cmd.type =3D=3D DEV_CMD_TYPE_QUERY)
-		ufshcd_prepare_utp_query_req_upiu(hba, lrbp, upiu_flags);
+		ufshcd_prepare_utp_query_req_upiu(hba, cmd, upiu_flags);
 	else if (hba->dev_cmd.type =3D=3D DEV_CMD_TYPE_NOP)
-		ufshcd_prepare_utp_nop_upiu(lrbp);
+		ufshcd_prepare_utp_nop_upiu(cmd);
 	else
 		ret =3D -EINVAL;
=20
@@ -3121,11 +3124,9 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *h=
ba, struct scsi_cmnd *cmd,
 static int ufshcd_compose_dev_cmd(struct ufs_hba *hba, struct scsi_cmnd =
*cmd,
 				  enum dev_cmd_type cmd_type, int tag)
 {
-	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
-
 	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
=20
-	return ufshcd_compose_devman_upiu(hba, lrbp);
+	return ufshcd_compose_devman_upiu(hba, cmd);
 }
=20
 /*
