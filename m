Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B880338598
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258886; cv=none; b=ji5NyYg0w7p94zIzjcMxSJvHwoNGD2CFRRn9KKGfqLN8eNTNlW/20mg8cg4XQyMYJet7K99AO4f1fhDxJiXna8yoEPtL7CZiG0rqVm2qRDYXJbpZsrfkFTYbbCVw7qUlsCwqm/taTfU/Q0y+ldSQIR7K5ppX6O7coQG6DQiPtm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258886; c=relaxed/simple;
	bh=egCb4rKT0BX/LR4YMOIGxOs2/u5oGoqgTPsZiXW4/1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJL6r4fnPEQ9tqOW/JtJCR6CKZVSvhXIkxdv2aboD5IYS1fUGkhmnm/wVppabd19nJ+bG2Gd7ZLk+e+C9SgwnHv46N9z5f8X1Q2skcKvwGd+BHYBd1VyQ8zc+u2pkXv+4pa4kM9euB2fdcXSd3rt1X4zxCVlAlccp/a13Rz34m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xe/aq+Vh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xe/aq+Vh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764258883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Or+hOooxS4SFn2ETCxdT77BmFRIW+dZi7o2KBfzpbfo=;
	b=Xe/aq+VhiNa4gPaeN6C7pA3a0S9wRaRTN1t2MBI53ryW119dYdVOhV+L0hAhvqjyKAe0IP
	SuYVDplQKoX3rPySS3Xz3oYmLIbRNg2TD6IvZ97UFt/ZNnRPb5ffSkFxHP2KhjUwS5NZMp
	DG7//Yl7426liLCjctBLCJ4YNRM/iKQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-jbZUp9cMNLmpgzKEOzE8Kw-1; Thu,
 27 Nov 2025 10:54:38 -0500
X-MC-Unique: jbZUp9cMNLmpgzKEOzE8Kw-1
X-Mimecast-MFC-AGG-ID: jbZUp9cMNLmpgzKEOzE8Kw_1764258875
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A7E61800342;
	Thu, 27 Nov 2025 15:54:35 +0000 (UTC)
Received: from localhost (unknown [10.2.16.53])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 737531800451;
	Thu, 27 Nov 2025 15:54:34 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 3/4] block: add IOC_PR_READ_KEYS ioctl
Date: Thu, 27 Nov 2025 10:54:23 -0500
Message-ID: <20251127155424.617569-4-stefanha@redhat.com>
In-Reply-To: <20251127155424.617569-1-stefanha@redhat.com>
References: <20251127155424.617569-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
 include/uapi/linux/pr.h |  7 +++++
 block/ioctl.c           | 59 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

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
index d7489a56b33c3..63b942392b234 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/capability.h>
+#include <linux/cleanup.h>
 #include <linux/compat.h>
 #include <linux/blkdev.h>
 #include <linux/export.h>
@@ -423,6 +424,62 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
 	return ops->pr_clear(bdev, c.key);
 }
 
+static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
+		struct pr_read_keys __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_keys *keys_info __free(kfree) = NULL;
+	struct pr_read_keys inout;
+	u64 __user *keys_ptr;
+	size_t keys_info_len;
+	size_t keys_copy_len;
+	u32 num_copy_keys;
+	int ret;
+
+	if (!blkdev_pr_allowed(bdev, mode))
+		return -EPERM;
+	if (!ops || !ops->pr_read_keys)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&inout, arg, sizeof(inout)))
+		return -EFAULT;
+
+	/*
+	 * 64-bit hosts could handle more keys than 32-bit hosts, but this
+	 * limit is more than enough in practice.
+	 */
+	if (inout.num_keys > (U32_MAX - sizeof(*keys_info)) /
+	                     sizeof(keys_info->keys[0]))
+		return -EINVAL;
+
+	keys_info_len = struct_size(keys_info, keys, inout.num_keys);
+	keys_info = kzalloc(keys_info_len, GFP_KERNEL);
+	if (!keys_info)
+		return -ENOMEM;
+
+	keys_info->num_keys = inout.num_keys;
+
+	ret = ops->pr_read_keys(bdev, keys_info);
+	if (ret)
+		return ret;
+
+	/* Copy out individual keys */
+	keys_ptr = u64_to_user_ptr(inout.keys_ptr);
+	num_copy_keys = min(inout.num_keys, keys_info->num_keys);
+	keys_copy_len = num_copy_keys * sizeof(keys_info->keys[0]);
+
+	if (copy_to_user(keys_ptr, keys_info->keys, keys_copy_len))
+		return -EFAULT;
+
+	/* Copy out the arg struct */
+	inout.generation = keys_info->generation;
+	inout.num_keys = keys_info->num_keys;
+
+	if (copy_to_user(arg, &inout, sizeof(inout)))
+		return -EFAULT;
+	return ret;
+}
+
 static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
 		unsigned long arg)
 {
@@ -644,6 +701,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
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

