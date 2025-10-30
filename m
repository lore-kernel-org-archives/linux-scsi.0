Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02913302163
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853282; cv=none; b=p+SbGIBMSz5Gl69jihWtguEhx8bATeUREVfGPTWT1BfUsJBnSnFLFWLL8l9WvsK7fQH6iH04ODyivvgtQWvEB4f023CfNb4bP7A2/I6h/qWdZNL3juuJmNE5uUohgdpRWscaqOyztTgE9pyMuF+rJUrzYN2vNqxsD9n/o9EiBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853282; c=relaxed/simple;
	bh=CM3zTBRvD1NlJouhqiG9EaST7iO0xMwp8oHY4AOYzGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhJfjcCqm2ueaoxVktItQH4jDh8xxd6z9laCjbwVH1+BUUHFAMWVpE5/4Mv30Yxc+l7hAA6OXxI9otcRZEJlOHcGEQ/IHNd8FC4XJGttSOi3IXTK4C6659uVAlY+I9ONAQ3hInf3j5D/ropApHFrtsJs2ntKnZxzagD26S2niAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tl5mDImD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tl5mDImD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDxr0ryfzlssyp;
	Thu, 30 Oct 2025 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853278; x=1764445279; bh=4mh/9
	8AS49CBpgvLo8Rg5DBrvrzXL+ZzJPRzqxiPhYs=; b=tl5mDImDv06hTxvQhxfMB
	Ef1Xy0PFrccB/Up27BWTRAyL83ODp/hlG57Z9cqTrybKN25VOdj4+iVsKVJ1LbtG
	J02e0uZ63iFUGe0LNjMcjL9O2M7uCFGG4bfufRC16Uh3ZdlrgJbiu+7KoT9EXcIB
	q3QCajRT3lmcbDBhqV8WqNxLu5RUjOg90nYVVEP+uluFdwhAK9fL++c7eM8vWUS6
	0dSiTlq4utfL00E2Wwc9e+HkuwMeIHJ94peYfjuIImp+WWC8JsuirFobHCgioSwf
	VIdDCfYkLctytbeRU2pGYUbknGwCfdSwOKzLykgFX7ixR4Jvv7wy9ti/1QvreFDx
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PKszY3vo0wYK; Thu, 30 Oct 2025 19:41:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDxg4CYzzlvfHB;
	Thu, 30 Oct 2025 19:41:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v7 24/28] ufs: core: Pass a SCSI pointer instead of an LRB pointer
Date: Thu, 30 Oct 2025 12:36:23 -0700
Message-ID: <20251030193720.871635-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
index f19af12cb7a7..1739403dfae4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2822,12 +2822,13 @@ static void ufshcd_prepare_utp_scsi_cmd_upiu(stru=
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
@@ -2856,8 +2857,9 @@ static void ufshcd_prepare_utp_query_req_upiu(struc=
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
@@ -2872,22 +2874,23 @@ static inline void ufshcd_prepare_utp_nop_upiu(st=
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
@@ -3125,11 +3128,9 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *h=
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
