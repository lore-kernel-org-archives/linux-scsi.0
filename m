Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3459235966
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253366; cv=none; b=CMCcA6spIipqLqDvAu4suaeNJQEvdFfnYv6GOaS8k5l2r7tChTurgEmLRHhylS3a7K0AV9NrNd8lATpiByZ8OOAkcCNgjgQEV7k/W5PrRUw4DUzq/opkTbOIaUINf0F+Pl9ISfl+0NjyzQXwTxIE3HTZka8yg9XhlM4KHqtZTU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253366; c=relaxed/simple;
	bh=DpQSRniKPS9kGlVlxtRyDsCfVsFJDoaaya2P7Ytimcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4PblXfTR7sLCFzeMSSNtG/Q2//Lr6wLv7YGOxSnQF4TkVeyO+QaN/f2KGhBaiHw8KFJ71FZotIlz3ouvOWPrKRZiFNEFsWXjDWsFe0rgPZHFcKjswVU0C8HPBoUgZLwYy7hMuyYKbf5r5h8sAmxzM4GAz4S5LVCbx+8DrN7No8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WCHtyrUx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WCHtyrUx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPz81Xdlzm1742;
	Wed, 27 Aug 2025 00:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253362; x=1758845363; bh=DfbNJ
	Mp+Yu/k05y74HWGTPkAbeKT6hU9F4/+u0XP2lQ=; b=WCHtyrUxYw/c5PKH4rGtV
	Xj+jvvGXHogIGI1YSuTZTFgzKE1AyfAEj0CayJNXt6BIhW8Qg0lzEiTVWHjPMWqD
	IIRZC3pVQKkT/aBvFnPs9bSpD6HPovm8vM2yEsb2ExafmSIhX4RWukDs07UIvJLS
	OhsO3woBh6BVrh4vh9VNI9G3PhKmfellz8S4cMeN4DRMsho3WcOBlytRlDwaSC2D
	EfqxUHBXV0c+bEEJa/rh9v6+GmC3ruFsJjuVJTaQdux7ousAIpLqr3x7Hmx1PDcz
	E2Oz5NIWnYznM+i2zlkBGUr6A5kEtfGQAov/AZm5nMIKJ6YiR8JmXETo7sVQh6+K
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dfIz3TCsm6MY; Wed, 27 Aug 2025 00:09:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPz02Td5zm174D;
	Wed, 27 Aug 2025 00:09:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"ping.gao" <ping.gao@samsung.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3 07/26] ufs: core: Move an assignment
Date: Tue, 26 Aug 2025 17:06:11 -0700
Message-ID: <20250827000816.2370150-8-bvanassche@acm.org>
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
