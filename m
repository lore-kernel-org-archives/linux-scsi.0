Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70706178373;
	Thu, 27 Jun 2024 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492603; cv=none; b=Ge/aIAiPMoz7LNGjJz/t8Fbxwe/thOZr7tja23n1L1cnVHknFXzVKg9fESeBM1PwIL555EcINYc7d5NLq94uFTFc2TkuTEGHod7vh7slSOqU8KSGovxXxmli7ewApqgb/aw3dZa0BCUMGz5g1L3sk7b3VAqWoL1zeMrauzTRcCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492603; c=relaxed/simple;
	bh=KiRiCHXBO4fbh2lG1mrEJMJKYq0Qh8AHMt38HgXSDp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq1LnBgnRKUfrPKbvbcQ060guLUTl65Ue3BGVa/OZj0D3V6Z+QLwjv5WTz8uep8R9tEPosjVueelvcjHuvPn8uHMLaGitY0ddSFupW/obRTnkHR1Q5zhr4Ng346PG2n8Nnk2ZlD6ZSKJ/SKKlDKZ5J7tMJOu6Jj/jDrDxjZI/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IC8ttUCz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IC8ttUCz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0FsjDylBbtdo2dKDqYsVLk+b6OxeYZvuRamj2Ya6XU4=; b=IC8ttUCzgSkN2O6buP2i3z9qk6
	KOAlnfraqYzcaMFHiCvLR6Y9NGxDhVp/wCWWJsqsCNv7d97ghGzTxzuRnoRLg+ZQj+B8uN53hehba
	wBUdYKvEhiyhK3kxBM2FVUTAvB0mf0kgFb9hQMAf/hS9sW1vKlTuaLFMJRwUt4oawkvY9AWxUG9gU
	tPh6OndVka6sRZvLntn7XbHfrYLaSdLyJjxlCSB2SpZ3Zv0mAzAjHrSYhxqbIUznOzTrN8H7Ld+wU
	IiUVw+ol4Ao+ORonqtGafICTXfuxeA/aa/ck/e/GSEJ0cGLk5Thjb+7fvSC5h9OoybHSflj1eP36R
	SgvoXIoA==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZT-0000000AN6t-0DGZ;
	Thu, 27 Jun 2024 12:49:53 +0000
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
Subject: [PATCH 5/5] rnbd-cnt: don't set QUEUE_FLAG_SAME_FORCE
Date: Thu, 27 Jun 2024 14:49:15 +0200
Message-ID: <20240627124926.512662-6-hch@lst.de>
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

QUEUE_FLAG_SAME_FORCE has been set by rnbd-cnt since the initial
merge.  There is no good reason for a driver to force exact core
delivery, which is tunable for very specific workloads and not a
driver setting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-clt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 0e3773fe479706..c34695d2eea7fe 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1397,7 +1397,6 @@ static int rnbd_client_setup_device(struct rnbd_clt_dev *dev,
 	dev->queue = dev->gd->queue;
 	rnbd_init_mq_hw_queues(dev);
 
-	blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
 	return rnbd_clt_setup_gen_disk(dev, rsp, idx);
 }
 
-- 
2.43.0

