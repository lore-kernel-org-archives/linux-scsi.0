Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7130597F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473278; cv=none; b=tzowbE8+dj8y4QTVm+X7rtgxOuJx6T9GzYeCdNyfW2saRz8zuBad4KqKW969e3WJtm42Vj+ZD3aaa1VcEdbsdKB2FDUwyAwduRjQMOb6yYahTlRfkss/NP7RdHuuCOWI9lF/dVpmo7ifISQbZ2mAOP7rTXxbFNQPVxynJvfooew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473278; c=relaxed/simple;
	bh=NdbIeRW7d092tjv+cTOsEUqO+frXuyqUE1m9yGi3ak4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2ODafybeCCJbRgSvk6iJWEIfX9jaTViKKcL+N/XeKsct3BzFM7cUWIP0EkjimYAzmbI50yUMNIBkqAkiWgy7smphbyQvc8vrpL/OKQGKdwhs9OGvNOIVLKRfD72QZvTHTNT8jsiz2qYKOTRJnc/QtqCZnqUqNZAjhB/cYFliLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hvTEwXHM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hvTEwXHM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQbG5dwMzm0yVD;
	Tue, 14 Oct 2025 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473273; x=1763065274; bh=M1S0x
	JtQlr3bJiKP1+qH/qW/wZNnoRyMtEMPFGGw75c=; b=hvTEwXHMnWodHLrUwHGLp
	JI8iVVqQWqVpK9GYTZD3dEs16d6lz94oGIsUiqnKYUid2bYrubE4ypN6MyKK8/Cq
	7K0/DbbBXR0RjHeJCFDoSvgxgZ/pu2iraMGlYpOm4so3mmDL68htNk53p/Go+NDo
	Kys8cZ4AhixaL6HDVWo7ugBQ/b3fnnGqPFr/fU/okio8FunXoyGK0uiw/hgVjd0P
	BEJaLrXUDNAVGDDMwNI6m+CzATVicQzjERiSszmvNvatw28TXYXqD3OFfX78aQZu
	G5tnhOW1XCQnLZgr6u3E4qOeIrVBxKtabr8tssIRurdBdNdMHQHt2Anh2lZqm4/V
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7MOhrsDVxVZa; Tue, 14 Oct 2025 20:21:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQb90GpJzm0yVM;
	Tue, 14 Oct 2025 20:21:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 24/28] ufs: core: Pass a SCSI pointer instead of an LRB pointer
Date: Tue, 14 Oct 2025 13:16:06 -0700
Message-ID: <20251014201707.3396650-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index 0d90c93a85d4..da2d9e398c61 100644
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
