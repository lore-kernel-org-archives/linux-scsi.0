Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D822E9EAD;
	Tue, 14 Oct 2025 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479015; cv=none; b=VswR/2gBUnsYm9+PrKN/Dx5sYkqxGvwfvQSLhjZyRdiKpHQC/gEj4FuYEf6r5qo8QXB7sVhYvadABYYEhz8kXdySMb8VYDF4b+Uv06a4AkPTh/oZK4CLyFUgQs3vloXdA2BI4rVVUsmd1gOtx8DHbYt8OjY8yBEBcu9En2AHS30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479015; c=relaxed/simple;
	bh=ZI4le3QHmTgmjHqlfnDXLUM4pNOJwr5qDV9ZOhxA/54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTlIn+XjGtZXa34XRsDidUcDgxKW7UrGgnnF5p4NfhnBLlKTao4oADUrMsDvfzfoBQNl26hcaiIpoJC13KwHosF7FOvBs140e1VYTbM1KnqnIWL9f1RUZvYLlWghBOC8OQcAdBqjYIzvHuzptbqO/8NDoILlOAoo8BMHbf3aZ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Blzd++Z9; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Blzd++Z9"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSjd10cBzm0ySn;
	Tue, 14 Oct 2025 21:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760479011; x=1763071012; bh=mts1d
	YP0qojMciEImDen3W7apJcigPyn/AsqoMCZcpk=; b=Blzd++Z9dOOQqs7JP/moT
	OxbepbHnWfzaGmkwkDvx+nBpCvfq3eLqz2l0plsXkqQUGKuhykP6NXZN2YVzNwrp
	zV8aASiPTLzXBAl6nPlaBMU612/OZzRsfawOTs8h+BefJzvSMNbY2o+6mDs9yxvn
	KxFxJrN20ha25RRUAtn/ji3Q6/r2jlWAqVrdxzn0JTg+U0IfML+PowkKwpfVCvbp
	i/50qf+qX2YxRsfRTeVfv/diNePPB0KacOfRIoo71Jv9GEzlINHhdkFPnaj5rghL
	zH1tAaQQiLIfZTC0BbXmH86/eTMTuzq+6e4yUNkUYs1yUyUodm/V3ITWVlFjdqdA
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id shgp4bKzd5Pl; Tue, 14 Oct 2025 21:56:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSjP3Xrtzm0yVW;
	Tue, 14 Oct 2025 21:56:40 +0000 (UTC)
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
Subject: [PATCH v25 20/20] ufs: core: Inform the block layer about write ordering
Date: Tue, 14 Oct 2025 14:54:28 -0700
Message-ID: <20251014215428.3686084-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
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
index 8339fec975b9..b2a44db7163b 100644
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
