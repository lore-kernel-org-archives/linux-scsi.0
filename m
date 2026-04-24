Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89E93FE67B;
	Fri, 24 Apr 2026 22:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070561; cv=none; b=szWRXeh7WPZEWrIcORaf+sh5aJp/thC6udTjMha7+/VguKbnT9zGbvfOE5xiqOKZGudkUDkzVy91lj69Rve/xL8ohF/kgZL0JKf3q8W45CxkGoiudSNqLJ9RsM4QcIYZ9a473yiNXhncWsxLQszTBr1+plcZJ0Wo2tTyA/jRLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070561; c=relaxed/simple;
	bh=FM4rLkFDFk0APqa4jfyeUq3tCBP6SY2PyF2fJYoL/rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DldpbZp72y1KIu6C6acg3DFijAfNi9V/E+m2VLt5ckoGVadsebsVMMf6AWwR9LKqFIb1lzdrCiYR5aLU9eF2tRwhHx1EywcYsKE0sFZ4xJMwRsyQxIraaoUir6F5Dvmzg1dhEVIZcOYrJiaWSPIni7THosNv6qvvQ0piIVCG/jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TINU3I4H; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TINU3I4H"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdj72WCz1XLHZ6;
	Fri, 24 Apr 2026 22:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070549; x=1779662550; bh=E09dO
	n9ADG8OwTD8WVqq6oMOalW+1VMCECVk65HZSAg=; b=TINU3I4H2sUD76hKNKY4E
	ecoby23j1sebYr9YdLWC84QOAwSnR532s/xlgMbuKsUERD68Wc/Yde3STcBuC2aM
	PE1dTANfXY87Pmyj/GfCobGbY5K0Ac1Y/fZlDe/Don3eNhficokWVCCKLTwd/aqU
	R7L728Af0KBajM4ZR0ih0HJgi0MYjuWHOUI8DpFHVAVSicyzWOCQAHvj4LolV6Ic
	90dTPIsToA33MKr8vV32lmnisq3iTweuaPBnkUYUITJrip5Ut4hUMGLJzn2kmdTx
	GcaiNw8/nFvuEeiH2IKQgoJvUiX9uUMwh3agAMryRbQqkUuqQlA1WT7ZuisJTlad
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BjifY1RZlGsy; Fri, 24 Apr 2026 22:42:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2SdV4kY2z1XLHYt;
	Fri, 24 Apr 2026 22:42:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/12] block: Introduce accessor functions for copy offload bios
Date: Fri, 24 Apr 2026 15:41:54 -0700
Message-ID: <20260424224201.1949243-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make it easy for block drivers to iterate over the copy offload bios by
providing accessor functions for the copy offloading bios.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-copy.c         | 47 ++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-copy.h |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/block/blk-copy.c b/block/blk-copy.c
index 459ed8581efc..f49a5f835b4a 100644
--- a/block/blk-copy.c
+++ b/block/blk-copy.c
@@ -7,6 +7,53 @@
 #include <linux/blk-copy.h>
 #include <linux/blk-mq.h>
=20
+static struct bio *__blk_next_copy_bio(struct request *rq, struct bio *p=
rev_bio,
+				       enum req_op op)
+{
+	struct bio *bio;
+
+	if (prev_bio) {
+		bio =3D prev_bio->bi_next;
+	} else {
+		struct bio_copy_offload_ctx *copy_ctx =3D rq->bio->bi_copy_ctx;
+
+		bio =3D copy_ctx->bios;
+	}
+
+	for (; bio && bio_op(bio) !=3D op; bio =3D bio->bi_next)
+		;
+	return bio;
+}
+
+struct bio *blk_first_copy_bio(struct request *rq, enum req_op op)
+{
+	struct bio *bio =3D rq->bio;
+
+	if (bio_op(bio) =3D=3D op)
+		return bio;
+
+	return __blk_next_copy_bio(rq, NULL, op);
+}
+EXPORT_SYMBOL_GPL(blk_first_copy_bio);
+
+struct bio *blk_next_copy_bio(struct bio *bio)
+{
+	return __blk_next_copy_bio(NULL, bio, bio_op(bio));
+}
+EXPORT_SYMBOL_GPL(blk_next_copy_bio);
+
+unsigned int blk_copy_bio_count(struct request *rq, enum req_op op)
+{
+	unsigned int count =3D 0;
+
+	for (struct bio *bio =3D blk_first_copy_bio(rq, op); bio;
+	     bio =3D blk_next_copy_bio(bio))
+		count++;
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(blk_copy_bio_count);
+
 /**
  * Tracks the state of a single onloaded copy operation.
  * @params: Data copy parameters.
diff --git a/include/linux/blk-copy.h b/include/linux/blk-copy.h
index 5e38cfc14a71..4c8435312752 100644
--- a/include/linux/blk-copy.h
+++ b/include/linux/blk-copy.h
@@ -43,4 +43,8 @@ struct bio_copy_offload_ctx {
 	void (*translation_complete)(struct bio_copy_offload_ctx *ctx);
 };
=20
+struct bio *blk_first_copy_bio(struct request *rq, enum req_op op);
+struct bio *blk_next_copy_bio(struct bio *bio);
+unsigned int blk_copy_bio_count(struct request *rq, enum req_op op);
+
 #endif /* __LINUX_BLK_COPY_H */
