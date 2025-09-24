Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22AC32BF54
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745977; cv=none; b=riyskEzXdu50dXAE4IvQaOXToNiCfWxZ+SQ5hw8QjpTZz0Ig3Z5yRom/deYApZIx3kKf0BrEnLTimi65RrEUhe/QWiL8Fl4ZmjZMg26MPFw6BKH94S+o6/Jcy/zjl/A+Rqn7q8b95CqPl0bLqwVJNj4JCr4acLjAIodd9L06JP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745977; c=relaxed/simple;
	bh=nCedrCeDBo2CZKg923h80VSYng8+ckDQ3LJxubaldtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUOV23z1NQafKEjW85oBc8IkAb2llWEzpofW7gfdNQrvMrD91XSqVz1bjmvWxEvu0u27V26+yNqHF+s5IdtuWNSYdjKfEbHqiw45+YASj2sqQuoWE7yeIM6OKF5AG5Z7nWvHji7nm2mJmnL0cDfn7KJSzSXwwPvsjALpGkj6BkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EMz2ED4u; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EMz2ED4u"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7nz0TH2zlgqyg;
	Wed, 24 Sep 2025 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745973; x=1761337974; bh=YRIOx
	OnQnQ5ZRzpXiHuCzWGMCbhKzy2iOtlaLiaQ0gg=; b=EMz2ED4u+ZZeNIM2qVow+
	imUrXhjLR+TWb0CNNcPYuKmmrim0M4yKEmvhEZdq4ceH698c/NBtGcOzOoSfV9Tf
	955r3L5SKBEdNxEi879HuW+eFB8TD8Ezfl+9c97ex6JeKu88qyiuWkdSAF3HouAL
	Ai+0abC9bxRTbMP1gwTKfp9sFgLbzV41OP7Q+YObW8eh39Le+n8115pRwRwPS/71
	uz7DikflTve59d3F7hf7Zk6NU6W7eWoqR3O3gSL6PSLrdf5BXjFUEaEQLwz0HXZS
	Rflhy68Y/sI2fWsWP0C/qZ0y4gtTDQCsB5mEvmeXOMEBRLUpLzAFZb24OryRmszz
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RcMMrBfHejcg; Wed, 24 Sep 2025 20:32:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7nq500XzlgqyB;
	Wed, 24 Sep 2025 20:32:46 +0000 (UTC)
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
Subject: [PATCH v5 10/28] ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
Date: Wed, 24 Sep 2025 13:30:29 -0700
Message-ID: <20250924203142.4073403-11-bvanassche@acm.org>
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
index fa3d5a0a7db7..394cc1b5719b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -491,9 +491,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *=
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
@@ -2368,9 +2365,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsi=
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
