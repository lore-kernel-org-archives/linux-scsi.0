Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33B630CD85;
	Wed, 27 Aug 2025 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330304; cv=none; b=JwkkLs06Mgh2jIh+hYEMzSn1DLJaczv99Az/mVgxctC7KWlsHp7vaqd5hhHxCByf2ClfCFFZJKxQQDIROqiwSu40HUreVfuluDijrwlBxd1JkkXTqaBFbR8z8WmsMWt+ZASCUrDnyYZ7BonaH1+ylFyRBEJAwWtBO/LLtkfiq+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330304; c=relaxed/simple;
	bh=CrTvDb32WrIN1o4xx/JNbKmh8GPvH8CHHjGStwJFzG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hka76U0+17S9ABZj6mt82Aymjvz4LWKjFdpM4Fz0AgT/k3DZDnQvnABg16JfFMKYOgga0Xtix9Q4CgU5fP2414Xq+5mj0VkgV/+7WX9b03iJlZBCrq1VsYSJfOxVHjs47jixgBCmnZGqu7Pp7YSHGnzQbC/+YsTRd7AkBnVDyUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BdzseIMx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BdzseIMx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByQk0d7tzm0ySh;
	Wed, 27 Aug 2025 21:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330300; x=1758922301; bh=4Fme3
	YHNhvvQ1oM+hE/DT50vE5BpmOdvIjT1vX/Uhq0=; b=BdzseIMx6DHzb9SydobEM
	1CjzDdb2Yru/SnbIaRXFZA8ZrK3TC9j8/YGqnYnr0BOIG9ouOKTEOnWOwlAJ6wEa
	zK1LlyO9HEmzaPx6AnVktAPjwOoI9PoMjFoZ0QpxUt4ZV2yCIcrVxxCZin2Ph18h
	8x/FcRTGwuvppBoO69SNfWI/bw12Kur8TzMLKwwutKFysqCRWhl4jEryHzPGirWR
	xcm3x9TAfaSTAYebn76nm9nJwnJ4oyA0YsR29V7e/B9gTxiX0oKBjkWclGt49lUf
	00ZHGXEZhBgi2b1SuvhaN2stHHXNEKL/0p7C8z5V+36JXjzy297BFTS8fZiJSmp/
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s1Nr0naykepw; Wed, 27 Aug 2025 21:31:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByQY5fGtzm174B;
	Wed, 27 Aug 2025 21:31:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v24 18/18] ufs: core: Inform the block layer about write ordering
Date: Wed, 27 Aug 2025 14:29:37 -0700
Message-ID: <20250827212937.2759348-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
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
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9a43102b2b21..c980857db9e2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5324,6 +5324,13 @@ static int ufshcd_sdev_configure(struct scsi_devic=
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
