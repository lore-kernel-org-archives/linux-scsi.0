Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EB83064B1
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473305; cv=none; b=oF+eoRMQa6eo7O7ZC2dl1LyrvEcv6XsitHdCY4Gwb56314zkL3Nsqa+2qh6JRX8tq41/PCGs+/9DEtabfmKzu1DuSt7WCzjnoDQXsuQr+Z6k2ce3mW5DnO0nEpqyjVHB8VBL6oUH3czAabSY4AH2he6MrNOKYozJXh17F6jBfFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473305; c=relaxed/simple;
	bh=agXlMUqnNiNykwSp1qXHz5INXuRAeI8lY5a+TrPuygo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQz46AduzDthtkDJ6OSxHeH2avVOS7amAL+ZZ9mYUASGNvv/84qO+q3Sz4ddMpjedknUtnUbcZkuNLWM8NXcklW7L2kE5cgwSkKkc2AO44q8pcXObQJRpiw8VONldsNCJLz7+mFwxeSGESNlVowb0ImJcZAX1a7+z34inWQuL7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HPbX2hn7; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HPbX2hn7"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQbp6SqYzm0yVD;
	Tue, 14 Oct 2025 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473301; x=1763065302; bh=jHfjr
	g505LuEV0WbEU7EN86gZTZDpgqO1PuW8p+zSKU=; b=HPbX2hn7ylgsTiL1cklKq
	zPS75XVDimkgqvdASDBOlxgcPvW41WM5riHCwoi47gaVphc97ByF/8tKE4hsjGKm
	bvxGUAsfKcrFsRHuyWjKQQnMzJebMt51qCKOsSsafU/v3orwEE0MMnhKI2HPkeKW
	NI8XlgJL0RdsU1dEj4QXgFojVMDcZhIivDIfYgJudmWn92Wk+4dIQo6EcabOosgS
	/z8IEGGrkwZsLA8268FPbBgzxjaHhL8oTNUZJX0E++pedvah1skIld9qQFIzGKtU
	gu/8nSqfW/CcBnvdT/g75z5Db2wcEoGmvTPEn1lHdq6JZ8eTNDcL9UPDzhi3wG9u
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NZG3nidnaZ98; Tue, 14 Oct 2025 20:21:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQbh4YKyzm0yVJ;
	Tue, 14 Oct 2025 20:21:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 27/28] ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
Date: Tue, 14 Oct 2025 13:16:09 -0700
Message-ID: <20251014201707.3396650-28-bvanassche@acm.org>
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

The ufshcd_dev_cmd_completion() call is useful for some but not for all
ufshcd_wait_for_dev_cmd() callers. Hence, remove the
ufshcd_dev_cmd_completion() call from ufshcd_wait_for_dev_cmd() and move
it past the ufshcd_issue_dev_cmd() calls where appropriate. This makes
it easier to detect timeout errors for UPIU frames submitted through the
BSG interface.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 92c1a47044d5..62c11f3e43ba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3263,8 +3263,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
=20
 	if (likely(time_left)) {
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
-		if (!err)
-			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
 	} else {
 		err =3D -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
@@ -3374,6 +3372,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 {
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	int err;
=20
 	/* Protects use of hba->reserved_slot. */
@@ -3383,7 +3382,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba=
,
 	if (unlikely(err))
 		return err;
=20
-	return ufshcd_issue_dev_cmd(hba, cmd, tag, timeout);
+	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, timeout);
+	if (err)
+		return err;
+
+	return ufshcd_dev_cmd_completion(hba, lrbp);
 }
=20
 /**
@@ -7408,12 +7411,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs=
_hba *hba,
=20
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
=20
-	/*
-	 * ignore the returning value here - ufshcd_check_query_response is
-	 * bound to fail since dev_cmd.query and dev_cmd.type were left empty.
-	 * read the response directly ignoring all errors.
-	 */
-	ufshcd_issue_dev_cmd(hba, cmd, tag, dev_cmd_timeout);
+	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, dev_cmd_timeout);
+	if (err)
+		return err;
=20
 	/* just copy the upiu response as it is */
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
@@ -7559,7 +7559,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
a *hba, struct utp_upiu_req *r
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
=20
 	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, ADVANCED_RPMB_REQ_TIMEOUT);
+	if (err)
+		return err;
=20
+	err =3D ufshcd_dev_cmd_completion(hba, lrbp);
 	if (!err) {
 		/* Just copy the upiu response as it is */
 		memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
