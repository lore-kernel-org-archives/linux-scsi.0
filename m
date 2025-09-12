Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B822C324B25
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701535; cv=none; b=qVck//HZweMg14Aaol8Qctn50vzlq5Y01beJeHW1+S3iHdN+onRvQFKdv8gyb7uPgcYgYj+et5cX04ysMkSPwnpImj0B6lTyj6ItFR1nAJhTB99rn0Je9UPq/gHtZ0E9j0I48+0lnHsABQIyZbbVYFJm1B8qmjBNlzw8kWM5fgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701535; c=relaxed/simple;
	bh=DpQSRniKPS9kGlVlxtRyDsCfVsFJDoaaya2P7Ytimcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0MGoSleX3QNOEhvkOhCjMv3f91iEmlih0FCc8Pdft6ADBVwss9gGNEV2tGMBbtWhd3KJkWOpeu+dHRnnzmpx4/JX+o23iwK41gasY7T5FPYfcgntsrAFewhkDXizXsNl86QcrfK/H5d5sAiFTOfb4t7pv6mpdsuIKUdEP6RUiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gjh8vbP7; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gjh8vbP7"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjXY0DNWzlgqyk;
	Fri, 12 Sep 2025 18:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701531; x=1760293532; bh=DfbNJ
	Mp+Yu/k05y74HWGTPkAbeKT6hU9F4/+u0XP2lQ=; b=gjh8vbP708/PmSC144L/e
	jIYl7ElE9QOc0ajw4PtGOnCFK1pCqrR7J0v8/6ztGGujq3yL2DSvNCICVwsew9kb
	0Ooyh7SbP2A1iXlasErzPhRRGE9aNHalxSNmqb3ay6ujXYqxDY/1wQ/Ij/wu55vB
	09hKFdk3TTrEUiaWDAO5LHM/4gzK0FnK11flTNcMVCes04BPwSFyGH0M0y2mVrGp
	WfY1XZAQNhRFYPZX1yE8tHlUjJfM/e0/Ard8hSWyBE0e5ZXlWY4UN9DQnAaPcXsU
	FtPx2wy6mF4nW+BqWifmBpw2tm4X7NZIe1ugSjruA757BWAq9/o4iYEzoTspN7k0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GL3YojXPssrj; Fri, 12 Sep 2025 18:25:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjXN51nVzlgqVJ;
	Fri, 12 Sep 2025 18:25:23 +0000 (UTC)
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
Subject: [PATCH v4 08/29] ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Fri, 12 Sep 2025 11:21:29 -0700
Message-ID: <20250912182340.3487688-9-bvanassche@acm.org>
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
