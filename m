Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A789CA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943490; cv=none; b=LexhcbXtvOAm1nimWRNxjQTgY8uiLBbbFfR7GStZ7g6wESPIJPl5p6np8+MQ7xHLkYyTXcl+EsRoEp/rJR5YSggP5u8a3xpO0HSdR7DO51NnsKYiVjO9KHFKp8BwX6pMOLxs4F7m6KAVImT5LZpQRXnX9P0OqKt4PEYuIopAur4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943490; c=relaxed/simple;
	bh=2lYOb3cRLKGJCUufa4bvf7R/14ga5YzgEDyCfg3f/nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgoi80c2FKDr07IuKZjAfGUFfwhQ3jj3lJem2i6SSUO1lsk5MM/W7zqaqwZJ0IU/lfs5Kcb/DPDa0hjvp2wtp7fBWPesNr84SYkgeMymrNAX4+yKoPSizMEa6Z+P5AV9jsNmfwlWFDAhafR7feYKk+zMv0TTuM27R7ErGTxUECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3DAyhUJR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3DAyhUJR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytJc34kTzm0pL4;
	Fri, 31 Oct 2025 20:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943486; x=1764535487; bh=QaILL
	fdW/aOXfOIxKvYzWbfhLkYabKRM0J7L20qSHFE=; b=3DAyhUJRTwNQ37gJ4uVhC
	O/e5tvxKf+LVC7N4NNIXmBd2BCdK2TvvJXkKUrjnvQq1MBKbvETtVfI2bBfqhNV6
	V1IcIe5uva2VlRcaaCDXjd+P1/XRjzeDv9QxLuMpExu2/z+P5/OkQauEarWcl5wG
	qCK0TpeOOR6MXKeiOn1ETd2G1qAAPKRtwpU0Bo9TTt70w+6soWfTjIgkIgunVcEx
	FT7Qdj9u5vPqLDNns8eAxDvphg+xRHxU0dVKSM8M3ZrFVxQLaohZVhcAMc0uheMa
	ygcpOFgIUMAeBtrNaucCmhAv2Y24wGwPEmdxYPUYcrE30I8FS36+UJ5gzdimWSgB
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gj0K64bYtHkl; Fri, 31 Oct 2025 20:44:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytJS4BTTzm0pKc;
	Fri, 31 Oct 2025 20:44:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 27/28] ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
Date: Fri, 31 Oct 2025 13:39:35 -0700
Message-ID: <20251031204029.2883185-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f493f180279f..2175b41262c8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3265,8 +3265,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
=20
 	if (likely(time_left)) {
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
-		if (!err)
-			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
 	} else {
 		err =3D -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
@@ -3376,6 +3374,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 {
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	int err;
=20
 	/* Protects use of hba->reserved_slot. */
@@ -3385,7 +3384,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba=
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
@@ -7412,12 +7415,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs=
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
@@ -7563,7 +7563,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
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
