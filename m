Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97C1DA100;
	Mon,  6 Jan 2025 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158025; cv=none; b=JG3VuxdPw4y7aTVrJ8UfnXSrJS/ckMJ1RAuRLLqHjAtXuHujxYrrZYXOPMkfeKCOdDAi8vXp7dfVWcDBPwEKbyKT2aCskDCzGFJDATsSqmuQdMvRiEugHKXSWnFkM85KSDK6cSfXj+0DE7ximyDDmSEtnIdsxfhZ51nrYLaWx3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158025; c=relaxed/simple;
	bh=z6kTajixlsC9wEmzo7NCih2TB48CnS/WbzEswB4K/ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCd3t/WO/Mw/mu2uuoJ0EuvdKOwSIZdhIKfag+GgYAi/6HL3de0psxIkQRPaFfanKAlIkzZchIqKGH/feMESxPWUA7UjKb8yCKJDGNCPzij7lXR0qujvKYyRyl9b7Ohf7QolAdoYaBH/4c96TQvTZ5Da5Qe8Da4TVrYTtJAR1gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CsLByopa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CsLByopa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tT0aOQgFNadtOuHliq+69Sjlga1i5Xt3nJO+Rr56CdE=; b=CsLByopaT+BZFwWNQNn/AldHtu
	szE6CVzrkyZQ6he41uPX81kinV5QV8UV3pSzsm9JTCje1UkzoZY/Ie9V6A/6parV/WSJrKJBNiOI9
	mUwY8noVeKlCazEdyd5EN06jNcJqs2JbUnW17QC3QQN+xbNGViqLmEWHFFZW1v6i5rC66L5fP9Cb4
	cVN9ImnAbprDYCenS2JYBT9FLBaSv7LxGL0qqzKx4UmFMFe+Q9tETRIAYaYOwyqmk8RIDwq2QbgLp
	VVw8/lF3XmkVzgguHi+/0ox9lAS3s572gJK70dp/HM29d9ITRfNYQmEEbVsg/CFsKITBj/DB8W8V+
	qLLQKUOw==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0h-00000000nQG-0OWw;
	Mon, 06 Jan 2025 10:06:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 04/10] block: use queue_limits_commit_update in queue_attr_store
Date: Mon,  6 Jan 2025 11:06:17 +0100
Message-ID: <20250106100645.850445-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106100645.850445-1-hch@lst.de>
References: <20250106100645.850445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use queue_limits_commit_update to apply a consistent freeze vs limits
lock order in queue_attr_store.  Also remove taking the sysfs lock
as it doesn't protect anything here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8d69315e986d..3bac27fcd635 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -687,22 +687,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (entry->load_module)
 		entry->load_module(disk, page, length);
 
-	mutex_lock(&q->sysfs_lock);
-	blk_mq_freeze_queue(q);
 	if (entry->store_limit) {
 		struct queue_limits lim = queue_limits_start_update(q);
 
 		res = entry->store_limit(disk, page, length, &lim);
 		if (res < 0) {
 			queue_limits_cancel_update(q);
-		} else {
-			res = queue_limits_commit_update(q, &lim);
-			if (!res)
-				res = length;
+			return res;
 		}
-	} else {
-		res = entry->store(disk, page, length);
+
+		res = queue_limits_commit_update_frozen(q, &lim);
+		if (res)
+			return res;
+		return length;
 	}
+
+	mutex_lock(&q->sysfs_lock);
+	blk_mq_freeze_queue(q);
+	res = entry->store(disk, page, length);
 	blk_mq_unfreeze_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	return res;
-- 
2.45.2

