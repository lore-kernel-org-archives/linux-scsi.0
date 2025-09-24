Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575A132A3C6
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746127; cv=none; b=sfEbb7vRXqVVgoX0PTNuciUiUzeVi3eUwwY8bYRBYZ2i3FGD4sauggZFHZWg9wBOjRtLnFZDcUfKlDnemRmkVjLXvo52ctCbeOanHSsqd57OsjGPjTF3fM0hjW2/lS/ochzocwrhEeFVSZXfkg3o1ovWN6AJRhLtelyMMLgIOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746127; c=relaxed/simple;
	bh=DmOCHNkSaJ+7ydk1NcEwOWEcZVSj46nNx7054TEAKxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYS/FgRCTIzZnPD2KpPlw1S04vsazkJ0E890HNbEWyf+x5a3WqMo1s2iaa2rw59/EfgXkgI5U6YaIQYX3+Hc3VKR9lsqIZlcphTSuJsYGGbW95o4U+VQbKNOCFfGGAiQl/HPZLOwzIRBGb+89R4+WO6m2o1NMZ7tGdUCT6p3z+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TVNmYDsL; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TVNmYDsL"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7rr3Jp6zlgqVB;
	Wed, 24 Sep 2025 20:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746122; x=1761338123; bh=O6swg
	NU7C/BqTNEDN+jvoVt2XL0mVcBlQqnpQ1AN9rQ=; b=TVNmYDsL/SQODIbLfCuMV
	GolsRaMT0GUUw7AFBY9KPBw5QKDR+K2ZP9PLIYL5iTmHxOdFLm8Jeou2BN0n4RU+
	RgWd9GJgIP33kh1pS6DHrT7yxBF95hJjXdeb+Mg3zZv9du1pRyX7+pLjJcwA6o8O
	Lq5ucrAy+xi595dtFicLUJX0Pz0yzcTqR4BSAI3vU2EB6UKfmVEY23OISV2qYQDS
	626Ht3G226Z5fssasD6FlPlmdGXStvWYOIuabzJJTAhixHIlGg07IX9rfuBowgg1
	dHk04NES52gaR40sHFd2Yt+yIZM3HETnYTGNIVA+Ke3Sols33I3so15oeTkgT8mF
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qsDRtx_9AmVI; Wed, 24 Sep 2025 20:35:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7rk48wmzlgqTr;
	Wed, 24 Sep 2025 20:35:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 27/28] ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
Date: Wed, 24 Sep 2025 13:30:46 -0700
Message-ID: <20250924203142.4073403-28-bvanassche@acm.org>
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
index a3c4f8cb2f37..b6ee8bfbb718 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3262,8 +3262,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
=20
 	if (likely(time_left)) {
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
-		if (!err)
-			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
 	} else {
 		err =3D -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
@@ -3372,6 +3370,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 {
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	int err;
=20
 	/* Protects use of hba->reserved_slot. */
@@ -3381,7 +3380,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba=
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
@@ -7384,12 +7387,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs=
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
@@ -7534,7 +7534,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
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
