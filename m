Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DA1F03DA;
	Mon,  5 May 2025 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432720; cv=none; b=HWNB6+YVCKdjZODelgPC8/gkL2dnz1C9d4YzXTFO05gamrCIgaT5v+vsh5FIaE2Kyb9iTR5Fj7B5pscdGWvA870Cq3Q0LhHCDkE2MeCbNlEzb4geJMyeLl0vAZQIenL86qF7N2kSVPxWEEl9LSZppRxi8r4XTQqiGKc1IETAIdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432720; c=relaxed/simple;
	bh=0cE3jj+Ir0XL+wHPsYyWxyqeQilhFZ/6F8O9mWVJOMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqCQ0PHp2kXqKWyysEzQVfPJQaVzX6R1FGp3Kxrdcn3o6Q1TM3P7udVY2U5x9JEJluNXSIlE8Ayfi4vVD1KwyWnh6zf7BgF6AwZDbzSat84wJ92RD6/z1c4PKf5RZZ6dgtFQGOT4xwcKJpX3Ndw7mJ3S/5ZZITCOiwR855ttr4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ma23w4e1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ma23w4e1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hVlNKlTiWcKWvQE8hDK2imIjySObLEfLFt6NJgg5UfE=; b=Ma23w4e1Pe/gas5w5H6/iRWCOw
	CKRA2ETeQCHEB1a4YjUuj2YyB6RAc//POSpE3PbyN8NuxyARuDIIOF2y4GdwwEdvRB3+Cj1jdyZz7
	DfWVtF49hrC7r16yyqo7+HDfa9vpmHEtEdYtTbUBgzXoIjdDtqFhY76rRv5oWsTcT2dr1TbZIHI8Z
	b7DIZMFnT6VjxjXXHewgyB5Kdm2BPBzskivKoPUsrWrYoWe3Hgjz9sV8fD1KSGOcG2C1AEEIUkQP+
	koOWvhBJnGngwDEGTc9mSUPyYw3Xg6r5bEgcC4ZQvpujP/jz/TTSuM6dyeorMNX9m6fwNn5/S+ol3
	8/T1fSdg==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvd-00000006kYK-3FIY;
	Mon, 05 May 2025 08:11:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] scsi: remove the no_highmem flag in the host
Date: Mon,  5 May 2025 10:11:24 +0200
Message-ID: <20250505081138.3435992-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>
References: <20250505081138.3435992-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All users are gone now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c  | 3 ---
 include/scsi/scsi_host.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0d29470e86b0..39320dccbdd5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2000,9 +2000,6 @@ void scsi_init_limits(struct Scsi_Host *shost, struct queue_limits *lim)
 	lim->dma_alignment = max_t(unsigned int,
 		shost->dma_alignment, dma_get_cache_alignment() - 1);
 
-	if (shost->no_highmem)
-		lim->features |= BLK_FEAT_BOUNCE_HIGH;
-
 	/*
 	 * Propagate the DMA formation properties to the dma-mapping layer as
 	 * a courtesy service to the LLDDs.  This needs to check that the buses
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 26bc23419cfd..c53812b9026f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -670,8 +670,6 @@ struct Scsi_Host {
 	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
 	unsigned no_scsi2_lun_in_cdb:1;
 
-	unsigned no_highmem:1;
-
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
2.47.2

