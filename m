Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FDA21771B
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933891; cv=none; b=K6vuSUlcdmflIyxE6sZAEWfGwjyFtCcgGJcuSiAN89ObndXFWaEudV07FB1Al/5271ZdhkyGfra2WnhxWPGEKFx2QMNDkS3qA3935TCpzRdqBzvKOVNRICSblSH3wpFtRlPUZJ5bJaXdMu3JcsD4Xm0CBTRyeXm1pIHdy7UvvZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933891; c=relaxed/simple;
	bh=DpQSRniKPS9kGlVlxtRyDsCfVsFJDoaaya2P7Ytimcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/M/8Rthgef7WZeB8ttQh0JQJB3GwZSihGWoH3X3cxqA+PtvQPTHnb0OrP035R232MRTyZ2jG1DUl0x6XOnG+aJaVVFOzEnupdU7+CHnhwXIAH37O4YnMIPwxo/s3RHknNP3tYxx99P/jEvCqPeODE+BIIYj4QjEUgoAkI+B4/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sjOD74Qk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sjOD74Qk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120d1jMJzlgqVP;
	Mon, 11 Aug 2025 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933887; x=1757525888; bh=DfbNJ
	Mp+Yu/k05y74HWGTPkAbeKT6hU9F4/+u0XP2lQ=; b=sjOD74QkY8ISmvwLngakO
	v35T1QcmZs7E8sZ+atJRVRxu92vnlPxqlPFmsMk8RBDfagfbeL9E/UAxWLYDlFwR
	8ExAVMh66/9gNVXIG7028khw3U5zpnIgpbsHfZocXl6Qn/sy8rX9W4dCK/0HGZWg
	8pRjc+GkRdP1GAHMs2xPvFRd1geMU050Hp5XvFdUvFvXs/bN1Ni4UNf7EUk9fFdw
	mdkquqCy+7g0SJYZgQU842FP4T6TMw34ttFGHi/b8LZuUx8ZJu6r4hUgJUVhawZ6
	DVBuu6ygjwtQ8lDcwzu6GWwuBpZ0oH+DeUEaKthrhqUSvhvmg1F9yOOC7s9282p6
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IzafhUrvAdHx; Mon, 11 Aug 2025 17:38:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120T70HzzlgqV3;
	Mon, 11 Aug 2025 17:38:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 07/30] ufs: core: Move an assignment
Date: Mon, 11 Aug 2025 10:34:19 -0700
Message-ID: <20250811173634.514041-8-bvanassche@acm.org>
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

Prepare for introducing a WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if
the tag lookup fails.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 1e50675772fe..4eb4f1af7800 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -303,9 +303,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
ba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
-	int tag =3D ufshcd_mcq_get_tag(hba, cqe);
=20
 	if (cqe->command_desc_base_addr) {
+		int tag =3D ufshcd_mcq_get_tag(hba, cqe);
+
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr =3D 0;
