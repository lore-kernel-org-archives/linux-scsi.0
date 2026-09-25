Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6224D0CFA
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361118; cv=none; b=N7MUpDElVCUw01B/7lrCsJuS1x8IW2+NyhTw1bTZudh4epQ1I4v+pCV7JHSPpq835OuDNH+F6d0A8/z21RTHtz8tt1vkXUHe5vT+N/zHSyPaeeLXmQepipU0hilunwTv4yawgNZ5EMKBtgr87XfTrkSWVst/ODdfaHiw2nGRCAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361118; c=relaxed/simple;
	bh=7iIRCp94zS0T8tMomGTH64NwxQOGD+2sDg47xWXeD6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctll1XTGBhOXqoYUbmi7ukyw3DXhB9qBS5C6DFoOEp4YGz7n4ZOBuNpG+VVaCUiFspSaKr1btJMonwDrxJHM3unYB0qyerlEkeuagywJUvaBjo23lxP/moLFSiTFDEGByd9zpy5uFYuYb5ZbidHKsY8aZAzVsZzuevToqdR1Fig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dyv2QPcl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dyv2QPcl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznR00F4z1XM5kW;
	Fri, 25 Sep 2026 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361111; x=1792953112; bh=cZL76
	z9UZNxIeIvW4bm8THrdQQr6eHntd84tfdyCE2c=; b=Dyv2QPclh6yU+VWHzmdb2
	GH3uhHGMMCYZR2Oz18hRc8guczUwBEjJuffusa02bd718wXXQesMB19GjKWXoOaA
	UU04gLAzO3OX/Hh2rG2i6aezr7+wzGXrk04Q2AE+lDkDd9aVG+dDJf5Sbs6/SCSK
	wmF0lAKRMZtOt7jc/2gIgG1mBHL1/72rDEApKT9dGNLdqliMrn0yMYNFu6g2HkQv
	/u+CMbb9CHN5snQ12uH2vcyiQd3eipYiJjjqK0HX2Kc8cShMya93S+Dvp7mkT4qP
	YOiyEt3In2A9ddGJwSFvV2C/b0CBg0cG+w00EsrT68qc6jTAjmD6K9t/Cvfj7NJT
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EYCStlumFg7e; Fri, 25 Sep 2026 18:31:51 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznH2BlVz1XM30g;
	Fri, 25 Sep 2026 18:31:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 33/54] scsi: ipr: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:11 -0700
Message-ID: <3e6e59930da8c522c95d598aeb04bb30dbc11e75.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e9066608323c..665fc54fcbb3 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5194,6 +5194,7 @@ static void ipr_abort_timeout(struct timer_list *t)
  *	SUCCESS / FAILED
  **/
 static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
+	__must_hold(&scsi_cmd->device->host->host_lock)
 {
 	struct Scsi_Host *host =3D scsi_cmd->device->host;
 	struct ipr_cmnd *ipr_cmd;
