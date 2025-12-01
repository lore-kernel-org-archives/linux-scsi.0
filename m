Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A50286897
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625426; cv=none; b=HtRPgec+MfxJaZFkZ7f8rdH2TI4ytznRInvTKqsnwd1HGW5dDrFwmBr25qbnhVYlm9HLJ2BtRvsXwDuWYmQgBUVVgEB2sxRpwQUZh9+Nwx3/MEzaRNk1SHlcghGv4amZ6QiFYsO2F9Y8ik+bC3Njve9YQh6MJIV2CMqDrU7yu8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625426; c=relaxed/simple;
	bh=NqAD7IKNmEKH9tDaD4XtjDhDUpCRgB85D8rfNscxioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXN5/ZNSmTjNhwzzpzk+fJvvGFd4YnGR2TpsBImDXFCBw4tVNei4pVOWNEdoRqmAgBg3a7r6KpIhr17OSwYCyh9TNunQ5mHzheNWAthtgNFVv5M8MMmphNQOZ3fwT3cekqD2uDSUD+Zwy0u57UDfa3IGv/fVKN5YDD5wV9bvbrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGe+DH8t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGe+DH8t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764625424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmEzslKSkhmC0gLB9i+o3Qufbcn1D02jCo9kyVUqdsk=;
	b=JGe+DH8tK7yMxozF+XEClkHX4D9XF/Tn/4BKJYkGEyFj1z9vhrmhSDCmEI/VeVfORhate2
	f28EJVlrXhyo5uBi+Eg0lO3udJGFLENQBI/Oiij6Jlu5NdRKwv/VxHRg5jg759wR6eO5s4
	mETLJ8LlvJUh9VFAFH/PZM+cFk1Vt1U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-pvHD_HxaPw-VDLFQazgHzw-1; Mon,
 01 Dec 2025 16:43:41 -0500
X-MC-Unique: pvHD_HxaPw-VDLFQazgHzw-1
X-Mimecast-MFC-AGG-ID: pvHD_HxaPw-VDLFQazgHzw_1764625419
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B9A719560A1;
	Mon,  1 Dec 2025 21:43:39 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BCA71956095;
	Mon,  1 Dec 2025 21:43:38 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Mike Christie <michael.christie@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-nvme@lists.infradead.org,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 3/4] block: add IOC_PR_READ_KEYS ioctl
Date: Mon,  1 Dec 2025 16:43:28 -0500
Message-ID: <20251201214329.933945-4-stefanha@redhat.com>
In-Reply-To: <20251201214329.933945-1-stefanha@redhat.com>
References: <20251201214329.933945-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add a Persistent Reservations ioctl to read the list of currently
registered reservation keys. This calls the pr_ops->read_keys() function
that was previously added in commit c787f1baa503 ("block: Add PR
callouts for read keys and reservation") but was only used by the
in-kernel SCSI target so far.

The IOC_PR_READ_KEYS ioctl is necessary so that userspace applications
that rely on Persistent Reservations ioctls have a way of inspecting the
current state. Cluster managers and validation tests need this
functionality.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/pr.h |  7 ++++++
 block/ioctl.c           | 56 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index d8126415966f3..fcb74eab92c80 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -56,6 +56,12 @@ struct pr_clear {
 	__u32	__pad;
 };
 
+struct pr_read_keys {
+	__u32	generation;
+	__u32	num_keys;
+	__u64	keys_ptr;
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
@@ -64,5 +70,6 @@ struct pr_clear {
 #define IOC_PR_PREEMPT		_IOW('p', 203, struct pr_preempt)
 #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
 #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
+#define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_read_keys)
 
 #endif /* _UAPI_PR_H */
diff --git a/block/ioctl.c b/block/ioctl.c
index d7489a56b33c3..95ce9aa90bba2 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -423,6 +423,60 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
 	return ops->pr_clear(bdev, c.key);
 }
 
+static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
+		struct pr_read_keys __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_keys *keys_info;
+	struct pr_read_keys read_keys;
+	u64 __user *keys_ptr;
+	size_t keys_info_len;
+	size_t keys_copy_len;
+	int ret;
+
+	if (!blkdev_pr_allowed(bdev, mode))
+		return -EPERM;
+	if (!ops || !ops->pr_read_keys)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&read_keys, arg, sizeof(read_keys)))
+		return -EFAULT;
+
+	keys_info_len = struct_size(keys_info, keys, read_keys.num_keys);
+	if (keys_info_len == SIZE_MAX)
+		return -EINVAL;
+
+	keys_info = kzalloc(keys_info_len, GFP_KERNEL);
+	if (!keys_info)
+		return -ENOMEM;
+
+	keys_info->num_keys = read_keys.num_keys;
+
+	ret = ops->pr_read_keys(bdev, keys_info);
+	if (ret)
+		goto out;
+
+	/* Copy out individual keys */
+	keys_ptr = u64_to_user_ptr(read_keys.keys_ptr);
+	keys_copy_len = min(read_keys.num_keys, keys_info->num_keys) *
+		        sizeof(keys_info->keys[0]);
+
+	if (copy_to_user(keys_ptr, keys_info->keys, keys_copy_len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* Copy out the arg struct */
+	read_keys.generation = keys_info->generation;
+	read_keys.num_keys = keys_info->num_keys;
+
+	if (copy_to_user(arg, &read_keys, sizeof(read_keys)))
+		ret = -EFAULT;
+out:
+	kfree(keys_info);
+	return ret;
+}
+
 static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
 		unsigned long arg)
 {
@@ -644,6 +698,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return blkdev_pr_preempt(bdev, mode, argp, true);
 	case IOC_PR_CLEAR:
 		return blkdev_pr_clear(bdev, mode, argp);
+	case IOC_PR_READ_KEYS:
+		return blkdev_pr_read_keys(bdev, mode, argp);
 	default:
 		return blk_get_meta_cap(bdev, cmd, argp);
 	}
-- 
2.52.0

