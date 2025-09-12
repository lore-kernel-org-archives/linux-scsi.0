Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7C13009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701753; cv=none; b=Zcchm2JhDNz71uPlzDNz3ae5BoSxEM+7uyUQLlkeQ0E/5HLZtwRSfuqUWGZcMHqJt/mCDTRSP9DCwruYjYe9NM3T8wEIyg4klTn6YlWMNGPBxNmAAuRpzixWVu7+/EaqMT6d1RZGciyaPMLPsNL6JZArQaI7wMLL74chPvIeOlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701753; c=relaxed/simple;
	bh=KbFVk/tMik1FMD4e3EGtCeDMh3y4BP4dpR3OcN14qOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GminHXIoPakizckc3PbonojGccsk7U5/ReFBlBXP+N4R1j/nybINkADq3JDyWQVl769+6Kjej0IClfUsACznnl1kNXjK4IalSnsH+inUrWyJq/2bPayOrVLNRc2kWmNQYMBgnYqNKADQBgZ9gTUu/0xhwyhOrwYCFljzjr+z/MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sA5C6dey; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sA5C6dey"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjck60syzlgqyC;
	Fri, 12 Sep 2025 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701749; x=1760293750; bh=v/b1R
	buvrV71NoW+1q547kr7HJUbleUao+XEvg5OAnc=; b=sA5C6deyCrT2lGWIpBhw0
	XULRvvaISllxwiKfYG0Q22qBB39QLplIwn+xqL377r0XdfyC98QXoPnJZRqLhwPL
	NEbNiDDXb5oIpHUavlkB78FC+DRhFtpqq9tZO+S1LoWN14xkq4Z3f1QIfn8Ef4Zp
	VXigJjqJ+17RguqADL/zwrDSFvNl9hWGsXbJHQSv8IM/0uYo5Dee9sRNHrVWJ7SC
	WscRzfGXzmP4hJm5KNNGgClWpQBapwEGOHf9qjWTZ1r8pODIcoWASuA/EnqUbr91
	zE3ItDQIceJmn4n7dUlYW/hfQOkiT6XOq2aeuwZgjbana1h95A1jwgOfPmpElzxR
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4g_pmtMoUWwV; Fri, 12 Sep 2025 18:29:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjcd03dQzlgqTs;
	Fri, 12 Sep 2025 18:29:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 27/29] ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
Date: Fri, 12 Sep 2025 11:21:48 -0700
Message-ID: <20250912182340.3487688-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
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
index 2f815f74aa66..6e346fe59014 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3259,8 +3259,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
=20
 	if (likely(time_left)) {
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
-		if (!err)
-			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
 	} else {
 		err =3D -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
@@ -3369,6 +3367,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 {
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
 	int err;
=20
 	/* Protects use of hba->reserved_slot. */
@@ -3378,7 +3377,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba=
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
@@ -7381,12 +7384,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs=
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
@@ -7531,7 +7531,10 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hb=
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
