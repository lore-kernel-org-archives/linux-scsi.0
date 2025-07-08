Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968531C5F13;
	Tue,  8 Jul 2025 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012533; cv=none; b=q2CBLhMYYVRtIJHcr11866zNN63xLxoAicD0iGE/JSZCGY9jEXdwj6FjZ/GBrlqLZnn6cr2/3XLoyd7iDV8E2DfqS4VKVMC5SIwxOKS+syC9mcioYutw47Ve1WVGmEGASJwP8okoARC+oet7dut7LrX2cjOj2Kls3EYD9pipDeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012533; c=relaxed/simple;
	bh=CXMV6wfDaQSlWZQyF4hSEXvoxhfI57wDE1w3O8R1x3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbgzG4pYMit8OjpbZpcLiTuY8Bsg8mhHZJjV0XTDi4nthZsGgXB3iQdO123+4NiIc0BNu0MA/0lX347H6lhfg9N6GSQvVxbfJt8bh+2+El2ZktJ/o3/MKVKZnq+QLKjfrZcItYCNuUs2LoYoqfjAsUo1VWqBQ3kQiC+uczTRjPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W22CMXOo; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W22CMXOo"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFcf6qNgzlgqVk;
	Tue,  8 Jul 2025 22:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012528; x=1754604529; bh=CIeKg
	tusAl5YQmSP+f8DbV1x3/RtOLjWueDD7VaDP0I=; b=W22CMXOoZE49rEZ9oe6ck
	v2YaALUxSBJyrKwLOgpgCBsVp6/B0dieyGSUKSvijrvmHKivYqlM+PaHtffZBODE
	V/OYVZsZ9CHpIkKnfiA0lO6z1VZFZWxyL+lp+v6Uvk3XPB3XjDDdO1x0YxdEi9xC
	5MibQHqPn+3kzM0rbJrzl7bWFeHzK+6tlWdUGGxuZFUad0Sh+iNkOfraO+Xl0nei
	QOYGGfUi9nok6gN64nWu+XvBao8lxmNZvlgFYCGCL08R70kae9VJr1/bGJl2rzZN
	4ZMSFsv58084ww54V5w/N/9D/5ZzAmyIZCHOnWSt7pbbaHoBCwyIJZsAa4mjdacl
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id g_lm1eQNWxex; Tue,  8 Jul 2025 22:08:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFcV4kSDzlrnQB;
	Tue,  8 Jul 2025 22:08:41 +0000 (UTC)
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
Subject: [PATCH v20 13/13] scsi: ufs: Inform the block layer about write ordering
Date: Tue,  8 Jul 2025 15:07:10 -0700
Message-ID: <20250708220710.3897958-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250708220710.3897958-1-bvanassche@acm.org>
References: <20250708220710.3897958-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..1f2fc47ca7b4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5281,6 +5281,12 @@ static int ufshcd_sdev_configure(struct scsi_devic=
e *sdev,
 	struct ufs_hba *hba =3D shost_priv(sdev->host);
 	struct request_queue *q =3D sdev->request_queue;
=20
+	/*
+	 * The write order is preserved per MCQ. Without MCQ, auto-hibernation
+	 * may cause write reordering that results in unaligned write errors.
+	 */
+	lim->driver_preserves_write_order =3D hba->mcq_enabled;
+
 	lim->dma_pad_mask =3D PRDT_DATA_BYTE_COUNT_PAD - 1;
=20
 	/*
