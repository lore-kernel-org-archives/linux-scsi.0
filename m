Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5A145B3F
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746100; cv=none; b=NA3BTo1Kev0x9ILq1UY0iXlo0RfzjgpY9T6WWIZwOlfcd2tTRCaEVG66VHZbzZvzW/QFWLRvqcEPI7Q/fCGGvj2yL4c4IJaCdcxe57+mV0/pR4nVgcG57EZtnRpcp7xlMkWRFWNO2eKeiG2Q4M3JMuCyaz17r8inL+Dx4OTaRLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746100; c=relaxed/simple;
	bh=R0Fcp2XUqfdDk2Fp59uixqULzsO1eDmU6okNR/iACqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkD5g3XLVNlkuZ8Kp4PH1oHoduvOxOwjEvihb7rHIIexMKnxdp/su9jX2ZWMkTdR0caNfWVMVhgBKuKfaLGeXc8bp9h0tMRI1yQ1iKSsmtEZNFcwwltxR11RKLrhVlY5FBcmD7qXgWRuScnAb/FgslvRDM6Bj+g22oVuf6PO7IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3Y0PnWL5; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3Y0PnWL5"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7rL4nYNzlgqxl;
	Wed, 24 Sep 2025 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746096; x=1761338097; bh=RBEiR
	Ua5KXWMtnle26/w0Y8bu9O42WgHvqiRs1gOWEo=; b=3Y0PnWL5q/egKHpqbexXZ
	rbzjolPoJrh1NqkZH02Ae+D7pBDLlLMpz2jqQO9eTpwxE5ku+U3HNw3gXyTNzM3p
	TY3GG6+AU+QLF40Fak7QuTt0vMYFkhUlegrofUt+E/chw2/eXy7Djz5w4ahJza+t
	O4j0Ly7GzGof19VmuK04nGWf2o9mcfeufpt2yQBx86WUvKfOGHM32p7Ojy/3vkah
	XdtcL28qxJX4UguMwJJSsqtcwFygvRyqU0OhHr5dxOfZeeehugqdity3j9H/BLvy
	rgRyfQnXk29A2SR4gYM1dozWGQt3BCkEEkDZE8ntmA8YPAi9OhZ7sGnLxYDBPAR+
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KOQ1Uk8IwLHh; Wed, 24 Sep 2025 20:34:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7rD46Ytzlgqym;
	Wed, 24 Sep 2025 20:34:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 24/28] ufs: core: Pass a SCSI pointer instead of an LRB pointer
Date: Wed, 24 Sep 2025 13:30:43 -0700
Message-ID: <20250924203142.4073403-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass a pointer to a SCSI command between functions instead of an LRB
pointer. This change prepares for removing the ufshcd_lrb task_tag
member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 76375dbcaf5d..02e3e4c4bf3e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2821,12 +2821,13 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(stru=
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
@@ -2855,8 +2856,9 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
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
@@ -2871,22 +2873,23 @@ static inline void ufshcd_prepare_utp_nop_upiu(st=
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
@@ -3124,11 +3127,9 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *h=
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
