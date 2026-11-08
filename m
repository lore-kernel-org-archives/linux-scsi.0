Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170886;
	b=JPPV4ccxZtQUu/qCIqdhy9WXiGrtE1w+4/DRUEHOrlp32u38WGTy53zbrNPXwBbMcsBu
	 MW04ei0VYzHvHp1+4NvvtITB0E1TkjxccaEWpSYJGZ+LyujBqKijqvYHlYmB5smOIBgjk
	 HWQJqTTKr2hOWrGilnhK1HcuI4u+dxZ3cLl3fdnQCYLKI8CImr2mk9Nfcss1OKkOeVTfc
	 rVG7Sxqzxec0qg5mY8+X0ZgZqhLMLa7wKtzjEm9kYW7zp/g/HEQu0liy9QIDKWRGzQF50
	 gLiMBsiBthWQ0NQ+fIL27XH5DVNI9damT28Sjl4+dfYw+NaFEpP8fGLo8Nbnqi6faNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170886;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oOyPSLk+GrgEBerLslrKlUTAOuWXuUUSVo0ysXdvyrQ=;
	b=U+GI6sy/GEybhJ8t/GHVmW8yp9OKZAoELJxF8O2evxUBYwZG2V4fUa4q9p9xk9iD8oSf
	 46E2q3kRZdp5kJSk6xsZFpg7TUY1c8mflffv1cEMJ8zYU50z39jRm6nR5KpKMN4W+Rrpd
	 u8Q4Y6FQladbKe3x2LBuKG816rs3IZkIR13OGidxTeNa94gnk/407vOoBoX9CpLDpta9X
	 UOgih0NwsRn3EYQ7UxlBAhHKHVwHnV2OWcOTROWCpvDncYorNbHoWaRiLnq/KGMhZudYt
	 lPFqf0OwAfGyFgliK/Vb/zQEUn9pK1ZAYhfX1NR47EysCIEWwNA+22n9qTJ1iZ2Cdow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vXzF4kKT;
	arc=none smtp.remote-ip=91.218.175.3
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441F606D816
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B441F606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vXzF4kKT
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=A5vtG0AAOU2USuDE74SFeoHqv0A6nD9sPzQHbB7H7SM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170883; v=1; x=1794775683;
 b=vXzF4kKTZu6A+xwg7ZBmZAh4VXOvtgllgjDS/xRaEoIhGeXSZ3LZOb38RZGqoesxCH5alzU4
 +qmft+LSea2+e5dN8qS6YQWk7Ey0oyUxbpIQ1QZZUQ8+ADe6veapa4ymgYx6d41kgRqBv12ixup
 QCUidBtIM5xnGQThCCtfEmQk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 229adb54fd34a1a5;
	Sun, 08 Nov 2026 20:48:03 +0000
X-Mizu-Trace-ID: 229adb54fd34a1a5
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
Subject: [PATCH v9 09/29] libmultipath: Add support for block device IOCTL
Date: Sun,  8 Nov 2026 20:47:13 +0000
Message-ID: <20261108204733.557995-10-john.garry@linux.dev>
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

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index ae5a73d570b3..d59d7ba81087 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -455,11 +455,53 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	/*
+	 * This check is duplicated from sd_ioctl() as we don't pass the
+	 * partition bdev to fops->ioctl. That is not yet possible as the
+	 * per-path disk is hidden and, as such, does not have partitions
+	 * scanned.
+	 */
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -ENOTTY;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.0

