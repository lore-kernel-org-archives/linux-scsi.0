Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A81A83F7
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715361; cv=none; b=YviKTcRuyDvZ/Xs0KIu0ERLRxd0XFWiYU4k+mY2FQsHvIhYL4cxAvOv8a+qNMMZvtgjrZQdmJ8t5exte4H23P01R8A1y4Eo0P5qPefoKl36w1mFmdwNUxFnar4nl4A1qWqY4YTwTJE/SiFT0XNFtHsoEjwuHzM/N5RFl0j9cetE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715361; c=relaxed/simple;
	bh=sFvQmq3bsfD5PQ74ikP0KOR+a7ni5OH5QaQpn+AKbhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNaPYCcTWn5kC4GvbeW6Tmm7hl6ixLkqAMz7veTfmoTMQcMlEcV2La2jdZIWvS2N0q12KircxU9B+WPBk9tR9QrCjVsv1JZC4UwwcBU3dyWwcWoPE2jHOdnop65kJRFg5PF5/eW3xgK3O1EjHfVT1cD3RNQ9PtshdHJhlMVEBlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iFEaJ7Zu; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iFEaJ7Zu"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF7g1DPXzm0ySs;
	Thu,  3 Apr 2025 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715357; x=1746307358; bh=o2OKE
	JIq3SHAbqD03UQIaYv+ux3pLZOfPEhdH6xpgIw=; b=iFEaJ7Zuwf3FQv3BFdykH
	gCoPJBGw2SuO72/cM9/V0XnGdsz7/gi+cnxuEpYyt3zIPzb/a8/HvdFR2Jf0D6ct
	B/WsorTLVuVocGwQCrYoczpKYvunIQXfPRgRIlkex3X5iVfv8+pK/9Q/s5gfGUqM
	TRuFeRm+Wgde0xY5DmtxLHMgII0flYtnQ6k8LRuJFqZjuJQ143G3hAB17IGL/Pyf
	2EI0dvqOQ/v74AygqLxibXNxYiQGufjJ/PPt85gcSedkW1tjDQcoC4Y/vzXwkLRu
	b6Hhr2n3D9uGcGeLnrJeUhqVVAFEUPXDNOz4ySbsVngIDofBSznZ2IeQZUuZtsGc
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xJRYebB4Hnpn; Thu,  3 Apr 2025 21:22:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF7S4hr1zm0pKB;
	Thu,  3 Apr 2025 21:22:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 16/24] scsi: ufs: core: Add an argument to ufshcd_alloc_mcq()
Date: Thu,  3 Apr 2025 14:18:00 -0700
Message-ID: <20250403211937.2225615-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for allocating SCSI commands in two steps by making the UFS devic=
e
queue depth an argument of ufshcd_alloc_mcq().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 99cc7c49619f..acbf173a3732 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8723,12 +8723,12 @@ static void ufshcd_memory_free(struct ufs_hba *hb=
a)
 	}
 }
=20
-static int ufshcd_alloc_mcq(struct ufs_hba *hba)
+static int ufshcd_alloc_mcq(struct ufs_hba *hba, u32 ufs_dev_qd)
 {
 	int ret;
 	int old_nutrs =3D hba->nutrs;
=20
-	ret =3D ufshcd_mcq_decide_queue_depth(hba, hba->dev_info.bqueuedepth);
+	ret =3D ufshcd_mcq_decide_queue_depth(hba, ufs_dev_qd);
 	if (ret < 0)
 		return ret;
=20
@@ -10422,7 +10422,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
=20
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba);
+		err =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
 		if (!err) {
 			ufshcd_config_mcq(hba);
 		} else {
