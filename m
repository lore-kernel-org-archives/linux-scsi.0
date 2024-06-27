Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9516017838D;
	Thu, 27 Jun 2024 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492578; cv=none; b=i7joV537qiwOxAzioBltLaRXGq8slC+i/lIzyVh0rRtyM7f6O/L1WNTE4DHn5/nwvBfxOJcrvgyWji+JlKjkW8Ny1K8oUQq5WmAa0v4KJESPDoB26spuIGtFVCH1bv64+qJzdSG4ll816sjL6dQkOREpvzQ1pLQi2xaI8XdsI+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492578; c=relaxed/simple;
	bh=B/Mz61kJ0gKhqTo9TQhnVEwo9B0DXR73xnWUb5qnv70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCVFM8xqWi1l41G8PhcWD5hLbIx67r7xLJdJxsOMFYtWJoiNQje6BzTXo96R3ehnJH9l5yoJ/U7zUBOuYedeabSXQdLNlJMaEj9UdyrOwb6Lo/fgPdlwSsidBk46iOj6UOpb1jjMTwhmPBP599BwLxjgkJHy1n5FOTVhGQl/2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bK7T0t2R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bK7T0t2R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7bza4BPcHCE+GDsbiJfWSek0v/JwxgMHleU7FQsIb/0=; b=bK7T0t2RFNyxDE7zjSaf907S5l
	4rPnA0bh/NErNalALdph0xpA0FrgVOboKiKuz8eY3D0pEWtz2yhfn3IyGrI5zDTAmqwrZx+mIQx/Z
	WyAN7DC3EvpF6UFv3Dl0JhOlf25P1IqYSPfiDgxDd6z1E6wsMPxklTLWpjpUQ3RTbQ5syDJiAvq+U
	gQ6wCjfD4oHc5SyvJ3i/84SNcS8rus86koMyIpDrQx+1Knc6pamVGjEs7S0Z3cZNiLOiF7Db8tro1
	GiZBDtYiWlx8/RgOzYFUnFPl4teGKFiTUUkBOeph5FnKbHjq46GXQZCPECUHnrdvkVdMLI0n1VSl7
	KVcv1fCw==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZB-0000000AN1C-2lkE;
	Thu, 27 Jun 2024 12:49:34 +0000
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
Subject: [PATCH 1/5] loop: don't set QUEUE_FLAG_NOMERGES
Date: Thu, 27 Jun 2024 14:49:11 +0200
Message-ID: <20240627124926.512662-2-hch@lst.de>
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

QUEUE_FLAG_NOMERGES isn't really a driver interface, but a user tunable.
There also isn't any good reason to set it in the loop driver.

The original commit adding it (5b5e20f421c0b6d "block: loop: set
QUEUE_FLAG_NOMERGES for request queue of loop") claims that "It doesn't
make sense to enable merge because the I/O submitted to backing file is
handled page by page."  which of course isn't true for multi-page bvec
now, and it never has been for direct I/O, for which commit 40326d8a33d
("block/loop: allow request merge for directio mode") alredy disabled
the nomerges flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 86b5d956dc4e02..3a116314877109 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -211,13 +211,10 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 	if (lo->lo_state == Lo_bound)
 		blk_mq_freeze_queue(lo->lo_queue);
 	lo->use_dio = use_dio;
-	if (use_dio) {
-		blk_queue_flag_clear(QUEUE_FLAG_NOMERGES, lo->lo_queue);
+	if (use_dio)
 		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
-	} else {
-		blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
+	else
 		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
-	}
 	if (lo->lo_state == Lo_bound)
 		blk_mq_unfreeze_queue(lo->lo_queue);
 }
@@ -2033,14 +2030,6 @@ static int loop_add(int i)
 	}
 	lo->lo_queue = lo->lo_disk->queue;
 
-	/*
-	 * By default, we do buffer IO, so it doesn't make sense to enable
-	 * merge because the I/O submitted to backing file is handled page by
-	 * page. For directio mode, merge does help to dispatch bigger request
-	 * to underlayer disk. We will enable merge once directio is enabled.
-	 */
-	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
-
 	/*
 	 * Disable partition scanning by default. The in-kernel partition
 	 * scanning can be requested individually per-device during its
-- 
2.43.0

