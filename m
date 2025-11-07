Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2962F6579;
	Fri,  7 Nov 2025 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559703; cv=none; b=iXHDkX8T7z6V2VuLIkOH9DPXqaDRd0ZNnogvZlkYI+39JptnvDLrh9S0oKo9sk5YoIu+MZa3enYRlQ4gQtW6h5UH4dm6YGwWXrt7+PLVg1GndbW0Af/TPPFWErXEf7AfmBVqV/lee0KTgXB2NCCUUTK0pW1Wem0VJWs3Czm2MWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559703; c=relaxed/simple;
	bh=tiUZMmp5FYavmWyjJLxLMdxC5dtHWwCfclXOQRrBEfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpX52WN6CQpydTPm9aGqZPjtQwM1bfO1MDa2FSKqxGnVOKMuBEX1ioHC1Qvo2vawGrRnBE7gGMdMJwfN06As//3mSMUZAD1TlQ8Ogn73br+87Gr6+0qqrA2VRRYL4f0pCmbIJ84kkcH1hXxO5+mL83cYF3spZ22GpicidqYDXjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qfwmPRE6; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qfwmPRE6"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3GBs14R5zm17wZ;
	Fri,  7 Nov 2025 23:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559699; x=1765151700; bh=1pKpN
	K8knp/oZZyHBGKmyv3p+D9I+a11/aV8qELAym0=; b=qfwmPRE6U6+Kmu51pq8pg
	mph8eH+o+lbgagCddVauqfso7XljKeH/vJc+SSsMOSTgH4ZGi0IBQEO2SirMxBtk
	O/duDj4CEvzsfvMVyTQ9oM3dz6iG9OTCAk5zdPMrprrOXKDdb2BRmkB2VAo2k4Ib
	D9Cb2ueP8v8sv3MzYMthQydHVPtHAS4WmTPhpWSqDHLGX060O7YI9ae2QEQdXrtu
	2JTgSlWDaWa5W3l6h4LWt+rlyMEP//cPmOIAVq+HJFq1YYnROge/ScZvIxj1GfX4
	YEHvrpbl3w3Zg9rDFm5s9tYSjZsn0AEZBP0bAEI0eF5Y88veRgAqz3elxoxmXo3p
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id n784hw-YDi9N; Fri,  7 Nov 2025 23:54:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3GBg4pDKzm17xB;
	Fri,  7 Nov 2025 23:54:50 +0000 (UTC)
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
Subject: [PATCH v26 17/17] ufs: core: Inform the block layer about write ordering
Date: Fri,  7 Nov 2025 15:53:10 -0800
Message-ID: <20251107235310.2098676-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
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
index 9ca27de4767a..725e81540bd3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5333,6 +5333,13 @@ static int ufshcd_sdev_configure(struct scsi_devic=
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
