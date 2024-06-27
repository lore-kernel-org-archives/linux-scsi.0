Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7AA179663;
	Thu, 27 Jun 2024 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492591; cv=none; b=cEYixX64X0X97AEcO39ROLwrID2AdKOcuK+yCY82l0VaVmXNf6+7mfhocN1t5dUZUOB+DIdUMPEY87D/JoRUscWPX8FcF5tmuot8YFCK1GXV1rM/flff1oVwF8k3Jaq7BV7ptN1G3H6WenzKBl9pwadgg3J7tLGJsn2+Q14DjR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492591; c=relaxed/simple;
	bh=lcHPPdliqVo3ZlGRzysnWzG/VSRBLuNUtziq4tfuk64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EglkJ68GTaN0/xnb4oGph3Zt/teSHSP6l61XiZ9vC4q9gkEEa0DhRb9Zy5V0EhNzpkn6gN19N0SRCFbmFXebXz0ex9MJh73UMqqaRPCzQxC1k+nn1Va1ZGsF63jW5vTrTc8F3XVAh5BZRN6VbCobXoqk2P43i1aNkj+bqAOzWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GYYiAb6x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GYYiAb6x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dbpk/jWfnG14mb5+tOcVnh5G3VFRihrDhhSyb+gDW5k=; b=GYYiAb6xKy2+ss3/YkwjBjEUwk
	1+4SPxRtvHkA2yqmFYQlp/yweITRyiMXyBCxVkp2LgNgi+SghtblYXif88jPqnoPwI03E3MCMANQY
	oShN6oUjDOId4SxIo8USCjx93IRYjLnLOqsucF6b8462l6lj+9gd8X/YX3TA4vaxsFYsFwMprAl6B
	bjbWNS2u97jJ7arzdxiRJPwCFsHKysja+sAwvn+e51NZPiUwlMTHHBIM5ASTWHVKa8w6djJiShM/w
	RNlOfGkqVtfRaHmbLSjfjj3vmlm/2w2u0Ng8NV5wpjajv5tF+3WsI6/OudI1Lium2byQo/bcQ+Y5N
	DsCLrLVg==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZM-0000000AN4n-3fuw;
	Thu, 27 Jun 2024 12:49:47 +0000
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
Subject: [PATCH 4/5] rnbd: don't set QUEUE_FLAG_SAME_COMP
Date: Thu, 27 Jun 2024 14:49:14 +0200
Message-ID: <20240627124926.512662-5-hch@lst.de>
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

QUEUE_FLAG_SAME_COMP is already set by default.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-clt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 4918b0f68b46cd..0e3773fe479706 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1397,7 +1397,6 @@ static int rnbd_client_setup_device(struct rnbd_clt_dev *dev,
 	dev->queue = dev->gd->queue;
 	rnbd_init_mq_hw_queues(dev);
 
-	blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
 	return rnbd_clt_setup_gen_disk(dev, rsp, idx);
 }
-- 
2.43.0

