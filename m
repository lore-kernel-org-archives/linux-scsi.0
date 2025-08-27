Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D07F4F1
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253387; cv=none; b=Udtwfdbo1Ljobk3MQKdovT0ttEYATNTvgGYK7wDKxQJ9jyPYDoJ6AeBin9ewcPZNXHQu38v9l+wB7C3/xAAN8UxersriYTTlPMKp4X3M+QV9Mmihv9qcEiw/3b9KV8DMFGATTXhfTfGznSjfEXYa6FhOJXdVNhRDOx8fAQYdtqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253387; c=relaxed/simple;
	bh=s7dy5LFtoFVICuKD+tM5CSl+YiLqgWry24V/ZgZMjFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqg1UKc0sMQFbe7Q4fkK2i5ORpFc4j4ySVfQmbYwXFKJorL0/iSZ3xasJ9BKPgU2V2aMglbCfnvp9oEVnsJ7B6uOv5I9bMvNziUiJRWQmnEnSxKKWgC/KAX8iOB6exFoNhoKR1V8/y+mgsO35unyed5vlzaYw3kfDpif1y+3l6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MixNgVbg; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MixNgVbg"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPzY1nQVzm1742;
	Wed, 27 Aug 2025 00:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253383; x=1758845384; bh=jFsrM
	4OsiE1zhdzVH4yyKtMJwP7lHlxjVnnILPXAV00=; b=MixNgVbgJPYINyEJJPjTX
	+F603FuEpWY1odkBmGFIEzJLr3MHhKxzEAMgdKPYTYjQmDHxVf7cqgBK+MtTE/6p
	RBc9ESSeaPk5W6q8AexI+jKlhN4Jdn/hfUFgOYqeJ1mBWxerZfqxz1Uj21QCJgmu
	fneig42Q1XvKo+9mgBmbOo0EPisdMFyY+XWHkBQ5V57NoN9bNb2I/T2JQK3IqyX3
	BEg4Fi69efhhz+QklV2RJ/APvoMH3mImHxavbRLqnSrAm9K+1S4B/Jly2Q7gdN8y
	F/8Awdcy0uzbnkqPlN5z6/FDklQjvyi4VGgOCHb+Z95gfQP5m3ILhp21K3ArxkJb
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a-rY5hTVh6xC; Wed, 27 Aug 2025 00:09:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPzP6TBpzm174N;
	Wed, 27 Aug 2025 00:09:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 09/26] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Tue, 26 Aug 2025 17:06:13 -0700
Message-ID: <20250827000816.2370150-10-bvanassche@acm.org>
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

Instead of checking inside ufshcd_add_command_trace() whether 'cmd' point=
s
at a SCSI command, let the caller perform that check. This patch prepares
for removing the lrbp->cmd pointer.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0c12165c7644..3511e2d594c6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -488,9 +488,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
hba, unsigned int tag,
 	struct request *rq =3D scsi_cmd_to_rq(cmd);
 	int transfer_len =3D -1;
=20
-	if (!cmd)
-		return;
-
 	/* trace UPIU also */
 	ufshcd_add_cmd_upiu_trace(hba, lrbp, str_t);
 	if (!trace_ufshcd_command_enabled())
@@ -2365,9 +2362,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
gned int task_tag,
 		lrbp->compl_time_stamp =3D ktime_set(0, 0);
 		lrbp->compl_time_stamp_local_clock =3D 0;
 	}
-	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
-	if (lrbp->cmd)
+	if (lrbp->cmd) {
+		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 		ufshcd_clk_scaling_start_busy(hba);
+	}
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
=20
