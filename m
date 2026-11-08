Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170888;
	b=tSo+NUc1fuJGXUbK4WC4W/PuEHD75ZPIirPWUq1MEc5hdLaNuQxJhjlKRskiws0ui5iW
	 r4RiyHyVkM8m3kAXsRN9+NKzm1abOt85ZW1A36abkbYhZtHG7AN+rekpofCywjuUdAvTF
	 wrO7QhOt8EZmz26dDvsDWpTWM9uaqRIaYe+0qqigaCzupL3Ei7pj+ClEL2Ua4xOHOexxY
	 98dJIeHXb2f16aY+9G7/PmDj64Y6XD/fY6MBiwO5+4VusTixDJV8/RyNSC4teXkaFvSFq
	 rhhlNJR3ZTPL4MjonGEYz58U48YQRAmImgpHhmmSIyQsInxU8EKUK8UcM+2d6Jjv5gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170888;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kSNTv+aNJxonZ0HiJim69/NMT9ESSsTK9I4rjqvPbcw=;
	b=pSF1A7QhxiFWSMALBAZGq2TWkrq58VY/Hz+Xbs80UbFdwWnzudg5moLbaS5J627EPPh/
	 66KhibumtHTYQZrGJC2hojlOJXDGTuA1DUH3nzVhW/CIrGtahG5s/Kt5YNdgP0cQ8TGCe
	 dlpY+lBx1qAZwNt/jWO5okg/iN9lbvnGQThQbIqOCyy/81f6CQ0mLzDtEmAvW3f6IlrpL
	 YJicmPpdrycLjLgGFBdKSKEDTa887MLyqv6eq3Cm0gZ1MPDtiP965G7uFjebCebvrkDVo
	 KiwxZV1COdw8FwmzKQKyzpxhv8F7FQECwQDiIVNahxT7icFXKwMk0H/Xc46HBHeL9Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WC1AE5eT;
	arc=none smtp.remote-ip=91.218.175.8
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E6606A320
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C5E6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WC1AE5eT
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=exsDCEn091ZlDw2fBJ4TkGMv2ZuFWeVd9KO0T+qf7z0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170886; v=1; x=1794775686;
 b=WC1AE5eTmrbCY1/M5DpcsKmHp0iseageC296A/K9ry3kRSaxwNjxEmLLBSnhfRxezOwpKK9d
 Z8FdqKTTOEK5+OpQvOX3d9LpKXd3ZvB2EGvy1VyLc+WVbYvns/LcRhmByJkMozF7FYOLPqVROcQ
 Z5h4CbOchgiWHgRmB0/Rr0ZU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 87f386aec11499aa;
	Sun, 08 Nov 2026 20:48:06 +0000
X-Mizu-Trace-ID: 87f386aec11499aa
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 10/29] libmultipath: Add mpath_bdev_getgeo()
Date: Sun,  8 Nov 2026 20:47:14 +0000
Message-ID: <20261108204733.557995-11-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index d59d7ba81087..3e2dc7d8b2c2 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -491,6 +491,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
@@ -502,6 +522,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.0

