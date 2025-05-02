Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713FE2676EB;
	Fri,  2 May 2025 06:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168589; cv=none; b=Waj2JACj0zghAbike+Whd7sVt2HxKIDGvmykxgn+9AbU0QLrbjkr1bl/TmSHhtcL6XjJp1g089D5WojON8AhFhBAkZL23VG3WYgatu2ow2LvDdi6fe6/lQK311J1sLJCmbBoemZ58S55KO1B+kh2tMzZlnsjQQwf5dwhDFfFVFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168589; c=relaxed/simple;
	bh=EK4ifc2r0IZ2alSl3I8+DcaE9+bdWouYUg+M/fSqqn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT+tuPN7j2foJLACmwfx5uzuKrSnLxYp3g11bJWFsIgc+Z4CscOEgKk3dgUH1ufRh9XcNYkpwYs2q9Hm4vyt9c7scuVL9p9VO8Q4WVpXKyOklIbbP98EEIJkNBmlZya5b0HWr40S4XIbmLjXUAGsCis6GlR8Q7c0Bm6fNM2CxnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BH+FiiaC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BH+FiiaC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t0yZoIwUV4+inxjNwnVHFH6tBnwOSSgcyj6eYeL50as=; b=BH+FiiaCFjwHqbT8ck0NnC9Rst
	umcS9ah9p9cWCX4gwNvsnisd/XwF5YyQWtWJzA2L6EGlYqMvEkaaR78cHcioW42Aak7RmOVH+ZSss
	VUaT6VWYeC34bfnDwi336TPrb2sqXNFDrSkkpLzYejK02mm9MwhGoF1BV5bWvw2RJ+rqutMi6TZ3D
	ct4wz6yGKFDvcv/vzWA5Qy9jFBqwSysnwf23lYB9kOhJXPupzi5I/bHFof5lOK/om5sidZHJx/V+d
	yg3PaZrkL1ImhDwaZwZjiRHJKhE8+66fTe0R+8M2dY9xR/v84OcY5IGI31g9+e3eE/NVEyIy7N8wY
	l/jLCh1g==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDR-00000001158-1lb9;
	Fri, 02 May 2025 06:49:45 +0000
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
	linux-mm@kvack.org
Subject: [PATCH 5/7] scsi: remove the no_highmem flag in the host
Date: Fri,  2 May 2025 07:49:22 +0100
Message-ID: <20250502064930.2981820-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
References: <20250502064930.2981820-1-hch@lst.de>
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

