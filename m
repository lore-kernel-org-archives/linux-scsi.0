Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997992AD02;
	Tue,  3 Jun 2025 10:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945167; cv=none; b=niUDNCIZcnSiBg3G+meClaS6zisKYdNByPCJysNJzVUVvJQASgHDLqUzPwoP9TXqcewMB0S+nPjyLFnlQTfHLqGE/fU1ryro6lCtQMFXeFRbPxsNlLb7MKiQKeOMfG9k+z8RPM9sa8I9+WnigLRE1H1Vwgflvq8m0v1VOwe+DPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945167; c=relaxed/simple;
	bh=GLHpXmqM1IZutIkryodASrssO2tP1+XsYj3UZKfpBX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5ZcacLC9tJ+wX0djNY6nfhuSbtZD75bllx3TDxxJdYkNIJ+hO5FMLXAPRZS98RGGj6Omw6paZsXp+n7doXqRoP1uDjYOsxAAFYgHoFrA9BrSF10BEFJxi9NIHP7cUY6nAY0Pri3c+c5xu9NKmcUahn2hhs1J8kR6D+6AMNyCgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U02SJs3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U02SJs3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F506C4CEF0;
	Tue,  3 Jun 2025 10:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748945167;
	bh=GLHpXmqM1IZutIkryodASrssO2tP1+XsYj3UZKfpBX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U02SJs3RLq44jfJsVitxNDnQCsPRxBtfrid8fsMU624GyNO7/NDbUAhl5QIPbfWjf
	 NbO30vCnuQSjGp2FCJjMn6zB/xQhePc9QtmDWWf28amavqNNlMOCHBVFefuSaTwH16
	 NV1Ddj82i8U5yUZtO2HU6Ir8uG82osNqBaq5GkHDjmAasXSz8lJsIKwDq+4C44DuLy
	 oWTnpELcyILuuDh+XYCJbI646uJJuYjkE+cghfSzEaoM6XwXXzXUvilUQH0vMCWx3B
	 mvy7HRhdlyu9MulxruommbfQWMyteJTBR8+LnOS6y/GGN8uztOJPNmxJX2z5GXOPs/
	 KSbO1LU8Hn/5g==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 2/3] block: add 'read_reservation' persistent reservation ioctl
Date: Tue,  3 Jun 2025 12:04:15 +0200
Message-Id: <20250603100416.131490-3-hare@kernel.org>
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
'read_reservation', but this is not accessible via an ioctl (unlike the
other callbacks). So add a new persistent reservation ioctl 'READ_RESV'
to allow userspace to use this functionality.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 block/ioctl.c           | 22 ++++++++++++++++++++++
 include/linux/pr.h      |  6 ------
 include/uapi/linux/pr.h |  7 +++++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 71f87974e044..3612352a1d83 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -459,6 +459,26 @@ static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
 	return ret;
 }
 
+static int blkdev_pr_read_reservation(struct block_device *bdev,
+		blk_mode_t mode, struct pr_held_reservation __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_held_reservation r;
+	int ret;
+
+	if (!blkdev_pr_allowed(bdev, mode))
+		return -EPERM;
+	if (!ops || !ops->pr_read_reservation)
+		return -EOPNOTSUPP;
+
+	ret = ops->pr_read_reservation(bdev, &r);
+	if (ret)
+		return ret;
+	if (copy_to_user(arg, &r, sizeof(r)))
+		return -EFAULT;
+	return 0;
+}
+
 static int blkdev_flushbuf(struct block_device *bdev, unsigned cmd,
 		unsigned long arg)
 {
@@ -682,6 +702,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return blkdev_pr_clear(bdev, mode, argp);
 	case IOC_PR_READ_KEYS:
 		return blkdev_pr_read_keys(bdev, mode, argp);
+	case IOC_PR_READ_RESV:
+		return blkdev_pr_read_reservation(bdev, mode, argp);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 6f293c3e27a1..e3ccfbd9dfba 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,12 +4,6 @@
 
 #include <uapi/linux/pr.h>
 
-struct pr_held_reservation {
-	u64		key;
-	u32		generation;
-	enum pr_type	type;
-};
-
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index 6e0d91d43c54..20198c7e68e8 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -62,6 +62,12 @@ struct pr_keys {
 	__u64	keys[];
 };
 
+struct pr_held_reservation {
+	__u64		key;
+	__u32		generation;
+	__u32		type;
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
@@ -71,5 +77,6 @@ struct pr_keys {
 #define IOC_PR_PREEMPT_ABORT	_IOW('p', 204, struct pr_preempt)
 #define IOC_PR_CLEAR		_IOW('p', 205, struct pr_clear)
 #define IOC_PR_READ_KEYS	_IOWR('p', 206, struct pr_keys)
+#define IOC_PR_READ_RESV	_IOWR('p', 207, struct pr_held_reservation)
 
 #endif /* _UAPI_PR_H */
-- 
2.35.3

