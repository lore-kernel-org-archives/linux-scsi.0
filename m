Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367432A3C1
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745960; cv=none; b=t4EYmD0abqPrfhDYX28lCSdTlw1Ug1B7IY4bevpBueAVfn4CTMwqIbBJESsCAtRE/wd9yMm6gVNGYY70svUGn6SExYK1IvhJQo+m5pl5ZYLi8Cw6uLirmzzKlDo9qs60f4HzNASVydqLLmLNoRRxlVjytkkm5yeeXam1if4BmfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745960; c=relaxed/simple;
	bh=DpQSRniKPS9kGlVlxtRyDsCfVsFJDoaaya2P7Ytimcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr90+haock6WunNmjrDygYcoByfMTjaIyz93vQFz8cQlwErw5D8TqAb4w8fgg0ydvq2uJw0eM7JL/bgvFkf1KPDxdEIETjFQHtyxEZcRh23SUxhJiwLFdj3tgzb6FtFMkFjcilbig4u/AaEJcClwHA6reAne4cnXyzyXvRyst8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JFRcw0aK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JFRcw0aK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7nf0DxbzlgqVP;
	Wed, 24 Sep 2025 20:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745956; x=1761337957; bh=DfbNJ
	Mp+Yu/k05y74HWGTPkAbeKT6hU9F4/+u0XP2lQ=; b=JFRcw0aKnafG9RW7jI1rN
	5CFaVRwmwfCybngkpPANuvwD1ZeT1+tiQA7f6MaN00CaXXo0HIy6+YVPHa4zU5Nt
	PJ2xfCCEmi5JtX8WjdmLKyhwLK32r5V3C/1IPU7EGXCk60eHb9nsngfkTqu0jsxT
	ah1+D6uQzRte3GgxfdNWLpaFAdyjfSTJ73q6pYi+5pnoUCSy6BorjeA+HKnaInAE
	GMZIwLULv52vNYOrj+Rsvk8rGz7bXNM8P0F4QmAA4fTQuPJ3WWR+B9Mvue25Wgo4
	kULe+/Hz6HFZ4tYD5LmLwt6/7JoWvzygKfASZY6URtP2DGR/S4IubUW2h3jL+GBe
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 58QBTJCDH3T6; Wed, 24 Sep 2025 20:32:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7nW4ygZzlgqxl;
	Wed, 24 Sep 2025 20:32:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v5 08/28] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Wed, 24 Sep 2025 13:30:27 -0700
Message-ID: <20250924203142.4073403-9-bvanassche@acm.org>
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
