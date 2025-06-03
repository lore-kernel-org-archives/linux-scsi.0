Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626B2AD02;
	Tue,  3 Jun 2025 10:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945166; cv=none; b=RfdsdcxbUfPvyzdBVSylLfCr8MZcVgao7T72/NdJ+kavoKvyOyGwzFvql3VeRhoWMJCWmGg8MQa4F98uCN7nGDPhYc7xU0skGao+UznfQwaPM3l4WMFxZpHkug8fkMwu6c+/dHW2cL71MHqUQzH0S7qkUalMn46HSSK8iAaJO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945166; c=relaxed/simple;
	bh=qbqxz7fvNqfbQzcGB5ZbzcH6HWNnj8SopuCcypubu9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ikrjK/ocFUAaOoOoJ9Yr/MltBE/PSPUaatWpIJ2oqzitu7sz2JRTU0xA+fXIkORrwtw4lJY5yE+ix4uC9cufAcyaxBXjLfVR16bupqnQldQlTFN5fnlidzsM6aD0mIhtkG4ne6d0dVdBgDGhwGfEee5TLN1GL5qwRq9PQ9XkmHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJCF9hx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJCF9hx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF99C4CEEF;
	Tue,  3 Jun 2025 10:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748945165;
	bh=qbqxz7fvNqfbQzcGB5ZbzcH6HWNnj8SopuCcypubu9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJCF9hx0d11D4koD/G9qAZPVNAUvmWZwS4NHAlQDjxsxuuatW6Vg5OkJZFppW6YLO
	 SHCsTOnEAxKTs8Go/yxnj9pEt1ZolOrrzUSrV+znDiB4Mpc4RIneVYZZt1Pgum+bf1
	 m0jnFl2iSrn2sbB/G2e9kAfUDiycsvV4FofvuKGGUeH/uZyt94X1+spPTwoqoni0e5
	 58G3eSku5Uskv16/e8cLWKsZMgiaAJ1mbm1lkAJ59+bNZfEP5eMMfP/NFH/x34smi0
	 BUZFauzxuYezaPU4gFnbpUeITR0Mm6ENAekfRAAtczNZBeB1YSRcqfrWQytvzgnXpq
	 SLzwOb+TgCl0w==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 1/3] block: add 'read_keys' persistent reservation ioctl
Date: Tue,  3 Jun 2025 12:04:14 +0200
Message-Id: <20250603100416.131490-2-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20250603100416.131490-1-hare@kernel.org>
References: <20250603100416.131490-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The persistent reservation operations already have a callback for
'read_keys', but this is not accessible via an ioctl (unlike the
other callbacks). So add a new persistent reservation ioctl 'READ_KEYS'
to allow userspace to use this functionality.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 block/ioctl.c           | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/pr.h      |  6 ------
 include/uapi/linux/pr.h |  7 +++++++
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e472cc1030c6..71f87974e044 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -422,6 +422,43 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
 	return ops->pr_clear(bdev, c.key);
 }
 
+static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
+		struct pr_keys __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_keys k_in, *k_out;
+	size_t k_len;
+	int ret, num_keys;
+
+	if (!blkdev_pr_allowed(bdev, mode))
+		return -EPERM;
+	if (!ops || !ops->pr_read_keys)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&k_in, arg, sizeof(k_in)))
+		return -EFAULT;
+
+	num_keys = k_in.num_keys;
+	k_out = kzalloc(sizeof(struct pr_keys) + num_keys * sizeof(u64),
+			GFP_KERNEL);
+	if (!k_out)
+		return -ENOMEM;
+
+	k_out->num_keys = num_keys;
+	ret = ops->pr_read_keys(bdev, k_out);
+	if (ret) {
+		kfree(k_out);
+		return ret;
+	}
+
+	k_len = sizeof(k_in) + num_keys * sizeof(u64);
+	if (copy_to_user(arg, k_out, k_len))
+		ret = -EFAULT;
+
+	kfree(k_out);
+	return ret;
+}
+
 static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
 		unsigned long arg)
 {
@@ -643,6 +680,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return blkdev_pr_preempt(bdev, mode, argp, true);
 	case IOC_PR_CLEAR:
 		return blkdev_pr_clear(bdev, mode, argp);
+	case IOC_PR_READ_KEYS:
+		return blkdev_pr_read_keys(bdev, mode, argp);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 3003daec28a5..6f293c3e27a1 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,12 +4,6 @@
 
 #include <uapi/linux/pr.h>
 
-struct pr_keys {
-	u32	generation;
-	u32	num_keys;
-	u64	keys[];
-};
-
 struct pr_held_reservation {
 	u64		key;
 	u32		generation;
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index d8126415966f..6e0d91d43c54 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -56,6 +56,12 @@ struct pr_clear {
 	__u32	__pad;
 };
 
+struct pr_keys {
+	__u32	generation;
+	__u32	num_keys;
+	__u64	keys[];
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
@@ -64,5 +70,6 @@ struct pr_clear {
 #define IOC_PR_PREEMPT		_IOW('p', 203, struct pr_preempt)
 #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
 #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
+#define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_keys)
 
 #endif /* _UAPI_PR_H */
-- 
2.35.3

