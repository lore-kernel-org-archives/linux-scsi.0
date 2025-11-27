Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD4331220
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258888; cv=none; b=k/1KYYyiIFn2z3Eb9jb/FD/5IeAiMDXzizVp+u05j1lCAWUisk1A2UHXDXaCt6pG5DNIl5h2FuxvTZGcOeij8r71b/I2FQ1ujBRHkHRAfQsh9Uch7qSJFqL69h9imK2RzjT16GRnsTbDMaNhxMuhj5ojf4oHtP6shPsSwCqv8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258888; c=relaxed/simple;
	bh=UnK2ntYweN/+uoHx/cZ35NmP35Rk3AuyNeP3XG/hKoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRIpfEdPOiE5wmTtDaMUEwyRDMyucAi2FBt+V/4bNlAT/fij7+f3EwrYKa6Qqmrwf8JdwAzRy4YwVAisk3HuIlOX3KdxSbYsJIHhqHUIqj6h6Y7r7BzqaQ02qnHCMgbWX+3tzMHEtVs/O+qQuMPgQiCe3kCzt9iQSlAbqlp0TOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IgE4RC3q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IgE4RC3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764258884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DJlFUMlUmKnKN3LsYjfFmXO2vVL0XSZBtqZZGvyT5E0=;
	b=IgE4RC3qN3koPWTRJr8PeRyqZ0lrVUd1dAIlEWpdAmk9iKT6FYcwg5RSlo5RUFCzdKXKMl
	7b0hkmvO0Z8cXpYlUKrTCRux3lEMzUBVHlt8nUmCRNUK1bNKExpwAUEhDsSkE8UQH0Fe2v
	dsmRcMw+y1ztdqfGWki7xNZK9X2kzKg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-moWsFbkRM5u0v3XJFm7rjA-1; Thu,
 27 Nov 2025 10:54:39 -0500
X-MC-Unique: moWsFbkRM5u0v3XJFm7rjA-1
X-Mimecast-MFC-AGG-ID: moWsFbkRM5u0v3XJFm7rjA_1764258877
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 591101800358;
	Thu, 27 Nov 2025 15:54:37 +0000 (UTC)
Received: from localhost (unknown [10.2.16.53])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65D4B195608E;
	Thu, 27 Nov 2025 15:54:36 +0000 (UTC)
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
	Stefan Hajnoczi <stefanha@redhat.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 4/4] block: add IOC_PR_READ_RESERVATION ioctl
Date: Thu, 27 Nov 2025 10:54:24 -0500
Message-ID: <20251127155424.617569-5-stefanha@redhat.com>
In-Reply-To: <20251127155424.617569-1-stefanha@redhat.com>
References: <20251127155424.617569-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add a Persistent Reservations ioctl to read the current reservation.
This calls the pr_ops->read_reservation() function that was previously
added in commit c787f1baa503 ("block: Add PR callouts for read keys and
reservation") but was only used by the in-kernel SCSI target so far.

The IOC_PR_READ_RESERVATION ioctl is necessary so that userspace
applications that rely on Persistent Reservations ioctls have a way of
inspecting the current state. Cluster managers and validation tests need
this functionality.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/uapi/linux/pr.h |  7 +++++++
 block/ioctl.c           | 28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index fcb74eab92c80..847f3051057af 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -62,6 +62,12 @@ struct pr_read_keys {
 	__u64	keys_ptr;
 };
 
+struct pr_read_reservation {
+	__u64	key;
+	__u32	generation;
+	__u32	type;
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
@@ -71,5 +77,6 @@ struct pr_read_keys {
 #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
 #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
 #define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_read_keys)
+#define IOC_PR_READ_RESERVATION	_IOR('p', 207, struct pr_read_reservation)
 
 #endif /* _UAPI_PR_H */
diff --git a/block/ioctl.c b/block/ioctl.c
index 63b942392b234..a51628236fc7f 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -480,6 +480,32 @@ static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
 	return ret;
 }
 
+static int blkdev_pr_read_reservation(struct block_device *bdev,
+		blk_mode_t mode, struct pr_read_reservation __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_held_reservation rsv = {};
+	struct pr_read_reservation out = {};
+	int ret;
+
+	if (!blkdev_pr_allowed(bdev, mode))
+		return -EPERM;
+	if (!ops || !ops->pr_read_reservation)
+		return -EOPNOTSUPP;
+
+	ret = ops->pr_read_reservation(bdev, &rsv);
+	if (ret)
+		return ret;
+
+	out.key = rsv.key;
+	out.generation = rsv.generation;
+	out.type = rsv.type;
+
+	if (copy_to_user(arg, &out, sizeof(out)))
+		return -EFAULT;
+	return 0;
+}
+
 static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
 		unsigned long arg)
 {
@@ -703,6 +729,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return blkdev_pr_clear(bdev, mode, argp);
 	case IOC_PR_READ_KEYS:
 		return blkdev_pr_read_keys(bdev, mode, argp);
+	case IOC_PR_READ_RESERVATION:
+		return blkdev_pr_read_reservation(bdev, mode, argp);
 	default:
 		return blk_get_meta_cap(bdev, cmd, argp);
 	}
-- 
2.52.0

