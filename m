Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170889;
	b=cIg0yVL1vfuAHcbl22zYZH9V/g3VN2lZKnFoWVS43eY+0mP38DwDVnHOhY6qsaPRyYgM
	 IabHkBWeHpQeiVCuM5KvfFAtkppDxrl7YVkfs6n3zP4segjFs1bMhVsTzgj4HqTQjP9Qy
	 9zDNlEXRcPO4kP8kOAqyrJbTBuB9B6YY1L4v9ZIkcfZ6T9yNFzfRwTyqdf/T51ge56Kvh
	 DmTZftb7GJjboWbTstnG2xZHUk6RPBPYZ5wsRP0PZl0U3unxlff5noxOXMil/g+Epa/Nw
	 PAdqW9SMuX8QrHIvnb0KxExuJJ26gTuZdtak3k+Y3DYS0c/ZlVpd+lLdeWyjnhDHPNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170889;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uqE0xY48+HsHwpb4Up8/gX/8HzxQ6Bp9ud6iT5itTcM=;
	b=4yjjIW9H9+AwxbOvQsSq9HdNXlClyX6H8JdNozk58WkEkU92crry2KVUb9kXdDvJfgaW
	 VhkVnx5a2YmsxoMRmvtDaJnylQXG7s9o8hStv+Y5tkA06JgDMXNfdCelT7Ff5GmgzOzRb
	 QDKzKiwPlTZ8qiJumCY1WbrMkOk6tpk0uwodcUKRoAMfagSkaRrQDdcu879jlTD8ZH6GH
	 OdIz1XTEC2L0CmTy1ilmOrioiqleRdgYnlRDtZLms/E8pX6YkZ209naPD43ycAAY8RO6+
	 yvX4V/nKro4ZzAPjEWZFkZD2IsVLDzgTgWvHR3AG0FtkwcRnFjfUbSpaRGcbMN2JhHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bLbykPlv;
	arc=none smtp.remote-ip=95.215.58.72
Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F40606A33D
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9F40606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bLbykPlv
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=php3BuRcqSzcvJXynpfSwkuXZS0RYrDjb3XQI6eXRsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170887; v=1; x=1794775687;
 b=bLbykPlvBA3E6BGsExmywTRT3BtsLsvz4RGoyLuItN0IGyhwLnxeZrGCHqKahr7h8C0zXHjW
 6LuGKhpb4XFX3um2gEvqx59Ka3r1ithGOtM3Wm1a6nfyLpQclc3HWar76Cu6RMAF73hMDfbsfr/
 c47ucfRsLwMs4xUX6m3FwzeU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id f0abbd2653e1c286;
	Sun, 08 Nov 2026 20:48:06 +0000
X-Mizu-Trace-ID: f0abbd2653e1c286
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
Subject: [PATCH v9 11/29] libmultipath: Add mpath_bdev_get_unique_id()
Date: Sun,  8 Nov 2026 20:47:15 +0000
Message-ID: <20261108204733.557995-12-john.garry@linux.dev>
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

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 3e2dc7d8b2c2..b03080afb259 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -455,6 +455,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -522,6 +543,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.0

