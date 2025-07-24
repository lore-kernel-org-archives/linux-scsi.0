Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E11221858A;
	Thu, 24 Jul 2025 21:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394364; cv=none; b=BV/xFs6mW1SDJxpycLVsowwSfa8zRV3mx1mH2MeA+ixcX1yQe4WxgKoBPNt2gKLMAhUOyJK7I0xcQRUyYlFyCTOvb/ulKsXaiFpvF+4q9HnnraKCrSujH/xbrtMhFN01VeQm4sKbp6+iGHS3gWN34Uwt8tDFpP5EhS5f4j4nCqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394364; c=relaxed/simple;
	bh=a1GeMU9pzp+aaRRqmQ4iYCYUO8rIrY1Vk9cTwmk2dyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLQy8lxGEACKpo2ZeG8n7Z9Jo1tIkKXVaA52d8KcfJCqENkm+fKFN+GZfrqtMutWX8Bxq6kxvDpUuEozEkFX92zLpKQwyDqhwc8N/B0vDYaIvaNcU6IHfmCmvKob6H2ENAZaJjm1f7l03q1piViDuwD+fYAb2cZ6etv/LpKviXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iPJcgAQ5; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iPJcgAQ5"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4fL41kTzlgqVB;
	Thu, 24 Jul 2025 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394360; x=1755986361; bh=b7/py
	0P028lMbB4c+XUc8d82X2s5g2pHrclhUkoNqqw=; b=iPJcgAQ5VdT9wD2y+QSoq
	f8kNAvC2JoWQrdP3jb+HdwjaZ3ZRBp1Tg4qXRyau8D5Vp0YnBYFN827fTxZehNZm
	ekUXQdBUnzsk4cvbXM2odZNRRHvbDqG5vjMz2e50JIiJcZUhNZcdUJqN1cZH48VA
	Eg81Il1ezvdwkgFHYh/y1hEWvfTA07oX2neik38jj5FXDp6E6y7dpn9xDfNuXQcU
	fjkxA8Jht11iR5mCq+TLXf8sLQW8Dt9KSdw3UkdZ9JeRBYlrmrKydtfRx8agPjz0
	0+43elfxMZ8rzWtygcmUhLpPPl7IjT0VCdr3aR/6duDzT9qzFnphOFJwWRdGnCLk
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ak80e6gFJnov; Thu, 24 Jul 2025 21:59:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4f3208RzlgqTv;
	Thu, 24 Jul 2025 21:59:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v22 14/14] ufs: core: Inform the block layer about write ordering
Date: Thu, 24 Jul 2025 14:57:03 -0700
Message-ID: <20250724215703.2910510-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From the UFSHCI 4.0 specification, about the MCQ mode:
"Command Submission
1. Host SW writes an Entry to SQ
2. Host SW updates SQ doorbell tail pointer

Command Processing
3. After fetching the Entry, Host Controller updates SQ doorbell head
   pointer
4. Host controller sends COMMAND UPIU to UFS device"

In other words, in MCQ mode, UFS controllers are required to forward
commands to the UFS device in the order these commands have been
received from the host.

This patch improves performance as follows on a test setup with UFSHCI
4.0 controller:
- When not using an I/O scheduler: 2.3x more IOPS for small writes.
- With the mq-deadline scheduler: 2.0x more IOPS for small writes.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..6ff097e2c919 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5281,6 +5281,13 @@ static int ufshcd_sdev_configure(struct scsi_devic=
e *sdev,
 	struct ufs_hba *hba =3D shost_priv(sdev->host);
 	struct request_queue *q =3D sdev->request_queue;
=20
+	/*
+	 * The write order is preserved per MCQ. Without MCQ, auto-hibernation
+	 * may cause write reordering that results in unaligned write errors.
+	 */
+	if (hba->mcq_enabled)
+		lim->features |=3D BLK_FEAT_ORDERED_HWQ;
+
 	lim->dma_pad_mask =3D PRDT_DATA_BYTE_COUNT_PAD - 1;
=20
 	/*
