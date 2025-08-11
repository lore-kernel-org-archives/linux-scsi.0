Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596CC21771B
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934020; cv=none; b=OasSAlc4UHvKQrLep77vOx+mVa10FDMVA0nz1hZIGee0bQozGS28j996J8uspfyLzwYzG86ESs+sB6KFA/SGiq5VKA1R07HIcl94mNOfN+5JBY+1eThdTACmtWfPDjVjYdRW37Ltk5AVbbrKc17J819GgGnXhn7LExSE0GG785U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934020; c=relaxed/simple;
	bh=GgXqbr453Qc5xHXcHjWzUlbxST2SQ5ET0Lq1hiAHeuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTo/PeHEzhyDFXMcDR357E6d76yQM+weuHiDXf0toSJmTJuCTiKEkSaoxTzB1KxTiHPSKAuzO2dL3q8tl6HeHiSMFYqSaKLb2aahM/piIMws9vxxKlIGmugQN+ZUNB+6ZnyETSFUDI9n9bDQYLIMGYyiyyB0kpAO5ghUrxgm+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4YNOjkj9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4YNOjkj9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c12363dtJzlgqV3;
	Mon, 11 Aug 2025 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934016; x=1757526017; bh=Pucff
	X2161vpGZ4670Pkoo2zAylJlRx+EnztIeo/l88=; b=4YNOjkj9rwfWA/GiunwHK
	bQMlAr9Y2ae62tt4PgHdC2Bd3RpmP7mBAkqQl5sUIf9+djwZH0kXdWr5E5EYBJQB
	ZOS0cSeL3v3Zm5GOH16J2QOHsfXLKZLJ/Xc89NCCyRIKcemq0r4OSIu/RrrX3l5y
	Y+u2pnS0I6sL/SZuuF0ERuIEUGhWvyz2+CEW/+XkgZZsRvNtRVmIMsCnqjj+OFyJ
	ivExHULhgRaRUdb8cYDDaETS3PIE3sYX1N24ok89ogB3ugU9q75SasxfFiZdzipj
	APBl5D0JKVUF1P1oO4bcp0d3+WlwlVMXFjxzdnC95u38fOoPi5lXscHJpk1aXmok
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s4QhhAGCbFsa; Mon, 11 Aug 2025 17:40:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c12304fphzlgqTq;
	Mon, 11 Aug 2025 17:40:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 19/30] ufs: core: Call ufshcd_mcq_init() once
Date: Mon, 11 Aug 2025 10:34:31 -0700
Message-ID: <20250811173634.514041-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In a later patch scsi_host_template.cmd_size will be set to make struct
scsi_cmnd and struct ufshcd_lrb adjacent. Since scsi_add_host() allocates
memory for SCSI commands,  the SCSI host must be allocated before any
device management commands are sent to the UFS device and before the UFS
device queue depth has been queried. Hence, the queue depth must be
modified after the UFS device queue depth has been queried. Modifiying th=
e
queue depth involves calling ufshcd_alloc_mcq() a second time. This patch
prepares for calling ufshcd_alloc_mcq() twice and makes sure that
ufshcd_mcq_init() is called once even if ufshcd_alloc_mcq() is called
twice.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d63bf5b3a414..23f7734d3cc1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8880,9 +8880,16 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba, i=
nt ufs_dev_qd)
 		return ret;
=20
 	hba->nutrs =3D ret;
-	ret =3D ufshcd_mcq_init(hba);
-	if (ret)
-		goto err;
+	if (hba->host->nr_hw_queues =3D=3D 0) {
+		/*
+		 * ufshcd_mcq_init() is independent of hba->nutrs. Hence, only
+		 * call ufshcd_mcq_init() the first time ufshcd_alloc_mcq() is
+		 * called.
+		 */
+		ret =3D ufshcd_mcq_init(hba);
+		if (ret)
+			goto err;
+	}
=20
 	/*
 	 * Previously allocated memory for nutrs may not be enough in MCQ mode.
