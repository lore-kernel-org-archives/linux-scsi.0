Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79734175B1;
	Tue, 19 Nov 2024 00:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976119; cv=none; b=aV/8A9RSj+RzbPpEC+iZYGO23LGy5VwDvT8uAiBaiqwbdykLJ25q+bPw16Qcm/1OcIZ4rQ/JQWNUGZ+URFYpEME7lMmwgjR02ANvZjUEjN5x7WcT2yvOtW2Frb2Aunn0AaMryXU9HD5kqd3K8hSp9kHHPU5+sqUZFIZD0n3Qies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976119; c=relaxed/simple;
	bh=ryj1LrIqHXicjHqRFWaCVhEPe6TL2T4m6y6qWp3jn6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI9IDAhIXw8DYMsxnIukN8G5S4ydnFjxxwrWUXWW4eCG+RBE3SYXGpIvEafXzpqEniwuv0PlBr5jOSmYBklp1Ib3OU8+exxBCgBsNjtD1fIJAP0Xq3f2V4x0uZ483uGhJrwozJ9Jni/2mtOWqmxvSL42QPh2Dym+XjPK8clixJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wkVLnOY4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wkVLnOY4"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslj06pjfzlgMVN;
	Tue, 19 Nov 2024 00:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976113; x=1734568114; bh=HyWas
	zR82zexjAxfSqNY6XuWsqw1mUnzF27e1iD6/9Q=; b=wkVLnOY4bU6Elq87TiVOb
	/d+fBcpawWBEEDneaLD9DCiM9ac/s9QoaNNHkVu1MNMznLkm64zZnQynHpPoJ4k2
	ooP2T3b1sskr3C8O2c+RDUPqXOakGCwYvYICYcjcby1y5N4Xrt/zUkSmdbeIXoQq
	OopJBQz/MyGoisa01pLk8AzQxQkWKmT+3FxzKd35aXIPOHcUKbndOQg7fw/F2MKa
	WoZqXA6e4vg3Ghq28nc7Abb398Gu9sKvEdktYPTXsJjn5SQE/SHiID2MTuPrDVbE
	Indrm7V+zxAGtsZOeebsfIqKPVNr3GzFtSPDDjqMdHi9pJI6VyiZrU81BthTgyyf
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id waDMZ7pLB9wz; Tue, 19 Nov 2024 00:28:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslhv3Wj6zlgVnN;
	Tue, 19 Nov 2024 00:28:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 02/26] blk-zoned: Split disk_zone_wplugs_work()
Date: Mon, 18 Nov 2024 16:27:51 -0800
Message-ID: <20241119002815.600608-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for adding a second disk_zone_process_err_list() call.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3346b8c53605..e5c8ab1eab9f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1341,10 +1341,8 @@ static void disk_zone_wplug_handle_error(struct ge=
ndisk *disk,
 	disk_put_zone_wplug(zwplug);
 }
=20
-static void disk_zone_wplugs_work(struct work_struct *work)
+static void disk_zone_process_err_list(struct gendisk *disk)
 {
-	struct gendisk *disk =3D
-		container_of(work, struct gendisk, zone_wplugs_work);
 	struct blk_zone_wplug *zwplug;
 	unsigned long flags;
=20
@@ -1365,6 +1363,14 @@ static void disk_zone_wplugs_work(struct work_stru=
ct *work)
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 }
=20
+static void disk_zone_wplugs_work(struct work_struct *work)
+{
+	struct gendisk *disk =3D
+		container_of(work, struct gendisk, zone_wplugs_work);
+
+	disk_zone_process_err_list(disk);
+}
+
 static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *di=
sk)
 {
 	return 1U << disk->zone_wplugs_hash_bits;
