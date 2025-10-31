Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E7332548E
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943292; cv=none; b=FrDyVRN9G85g/59kqHv5+WafSqmp+eh0gBEV9w7W6TE3c7sjrFVLLD5FujZmIyUApWyZNnRyQ1ROqBR0M5URdkq8zQh4CBKiWp1kpuDxzbrU7qi68SB472U9cKmm3/rofJl+EfC9xkoGlXG192BoGkgXfZzyfec8SUC8eCDTxT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943292; c=relaxed/simple;
	bh=72XM0DijgpkekbP1cPUsl4ZsnAifZ7SBAFCzQflOnZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBjtVesHNyN8RThEsZVnwQ21bs8Y7eVINpqdwTMFFgiSX4dSDkqtwDVG/kRnq+2aTcNlfeb6GbVPnJUGn4lDPxtmpHgP49bpxLHK+/TFEeImF9uSvBpW6/UbJFMMITA43x1hs7+xlDGb1NDrzH34n1CwS6VjowLCsQc5xLG/BVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OdPM5AUY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OdPM5AUY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytDn62SXzm0pKm;
	Fri, 31 Oct 2025 20:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943288; x=1764535289; bh=w43aU
	+y1tdr+5Ha9R1pCW5+yoZoqTTexTm0Z17Xjd5o=; b=OdPM5AUYZf+CUwZAmq68j
	ZZ3TekYDhzm3ZWwylqDT/qX9sJ3kU4XOZ/hkhY0efEqZGLAqfsT5T9Ur/wRXQeWr
	/wHaMynnt6O5zt4C8Hz+Rk4Q+dgdXnGB0A0/qAyDsTBFtml9zpcICBVk/CXnqfam
	SZMTPh+DJ/qGLgkMKbsF65HtlfyUb4HUJJqZwDofs89k5C4jYGmFHMU5gHOwbTEM
	mh2cF9blTyj/H2f+5G97OPx9rmQ9TNFln1FZV/RcvNhb/tk6yKumnh5Z5O/uyv2D
	Q8eskgS/JUhKGZngwg4KeIgwWV2UlcsHDJRn+RUSW5HHeu+hVqSYocd3QZM4FGav
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qkLw9xhfrBrG; Fri, 31 Oct 2025 20:41:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytDf1CBBzm0pKC;
	Fri, 31 Oct 2025 20:41:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH v8 08/28] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Fri, 31 Oct 2025 13:39:16 -0700
Message-ID: <20251031204029.2883185-9-bvanassche@acm.org>
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

Since 'tag' is only used inside the if-statement, move the 'tag'
assignment into the if-statement. This patch prepares for introducing a
WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if the tag lookup fails.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index d04662b57cd1..bae35d0f99c5 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -307,9 +307,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
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
