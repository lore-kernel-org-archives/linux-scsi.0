Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9E217BB22;
	Thu, 27 Jun 2024 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492581; cv=none; b=e2CZseKQTiQ+Yevo8xhp3qkFOGKXdYxW9I1Gg7cs4zSYRDA36pxsyDTHolZUCzSR/fAJ4gM370M6RwHNkZmr1adIo8lxxDcJBt2yFRGyJxfilu55BWpYyU3IQRm59whs7UAFjupbZG6hhmV7oqyFixAAULmQEGK/IN3MYK5hhpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492581; c=relaxed/simple;
	bh=tHrxUQ2I8sjGwTxqxPyzwuLmgQ1k7GR9fKapxHZM7K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj4HeyefSP2pX2hUshXxM7t8wzRKM/Nyyr5XcNtJTiFxqCijmPmf6dn241LR8DrkHUPvjewnKUQE3myHhFb8zqGo7WswQM7A6h1EdYW5+7Rj4OiVxfMpU6Yuvvu2Sug67jVNXlRA9DjMZ/eFyhzyFpm/uBBY0vuJSUu1TxDgGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GlRiewqI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GlRiewqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W/SCrTEXd5pa0FCte55wmCajAJIS3L5i7/QR+MpuT9o=; b=GlRiewqIHGkOsYgiQIMCf6oeEE
	jDVSJ2IsDC4SXCidGf2a8VLw1KDnkfI77AsKCjyPDRNSt78lyFMZ0PMgfxkeu1LEJ790vPOb3QQqo
	96LGp6eH6ujZjXqYkSPeDy9EF3dtSKrTWDuKyQfUvgfRYmEhjVo9h5Go9BmgpQwzd5TOc8Cwdh8Y9
	b5/FzGWGKHMTT9xli6DqK0qyYF7UmTa2viQxcU6+KBUSag6PuK/L4IRQqJwjtkbMo9Ia/f8O7LJuM
	FjLzRjb5C1iXiCa9SXvs51H/0P36lMmqV82KOWt1Hn/aJIFrHkNj7P0Y0BTk5mGVuEj6Gq2ugmjs4
	JlHyy+3w==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZF-0000000AN21-2IQW;
	Thu, 27 Jun 2024 12:49:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	linux-block@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 2/5] megaraid_sas: don't set QUEUE_FLAG_NOMERGES
Date: Thu, 27 Jun 2024 14:49:12 +0200
Message-ID: <20240627124926.512662-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240627124926.512662-1-hch@lst.de>
References: <20240627124926.512662-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Setting QUEUE_FLAG_NOMERGES was added in commit 15dd03811d99dcf
("scsi: megaraid_sas: NVME Interface detection and prop settings")
without any explanation.  Drivers should second guess the block
layer merge decisions, so remove the flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 88acefbf9aeaba..6c79c350a4d5ba 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1981,8 +1981,6 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev,
 
 	lim->max_hw_sectors = max_io_size / 512;
 	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
-
-	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue);
 }
 
 /*
-- 
2.43.0

