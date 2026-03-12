Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960A83AF675;
	Thu, 12 Mar 2026 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773307430; cv=none; b=Xs9iRqT//TPuUkHioRkBU2IamCcDCc7zbhftCeQkwWCWiR2qojLG1roEClnOCoxSm+lKmp8+UPjdOeyMgcGlT2zWxzm6JVAbV7qj3wBJHVB6UxpwS+YLY1u0Y5aHKVuuHcYtS8R53xBVqA7nwXB2aVg14m9a/h0Nm2CPEkbt8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773307430; c=relaxed/simple;
	bh=QV+wYTxxc1lZcsdzIt9oegasrn9oT/yYWcNiE3KENhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DzM2mW3JuB0LLPvRS215lkZkjDfDy6AGgGBye5Kdoil6qZ5n2TcH9d7cNsa7/yYlQx5HYN4aSyBVPc/8C3gzeu1wx8crlUq++E5JxjmP5wUdnJ3SoljDO49EOG7i3LTnxw4KS3ackw54oEaKgTpEnr9F6xCHMdj/f+uMOUFqnnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XUm3Um7E; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XUm3Um7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Dl
	O5Xb7G+2xw6d08r3Ef3SeDx6Zjv1w9KNacfwiPlnE=; b=XUm3Um7EousC2RpNaV
	FHsqPX3W6BTyTMH8Q5Vhm80kAIiIK+Qj6olQ6eisUe28HrY6jv8kIgABgr9eojpj
	7rFTm6LE1/5IhChHT0Bovy7lQokB5cXdr6WI9ms8+Oe2Z84AIOjihH5hcmtJBnmJ
	iuSLvDcUnVY4H828L1iQsDGoE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDn0tbfhbJpu7uqAQ--.55S4;
	Thu, 12 Mar 2026 17:22:53 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v7 2/3] bsg: add io_uring command support to generic layer
Date: Thu, 12 Mar 2026 17:22:36 +0800
Message-Id: <20260312092237.2464560-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn0tbfhbJpu7uqAQ--.55S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFWrtw4rJrWUZFWUtF1DJrb_yoW7CrWfpF
	WrXa15JrWFgr4xua98JFs8Ar9Iqw48K3yxJFyI934YkrnFyr9Yqr1kuFy0qFWrJrWkCayY
	qanYqrWDCr1UAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-sqAUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwg2jNGmyhe2hZgAA3s

Add an io_uring command handler to the generic BSG layer. The new
.uring_cmd file operation validates io_uring features and delegates
handling to a per-queue bsg_uring_cmd_fn callback.

Extend bsg_register_queue() so transport drivers can register both
sg_io and io_uring command handlers.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg-lib.c         |  2 +-
 block/bsg.c             | 36 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_bsg.c | 10 +++++++++-
 include/linux/bsg.h     |  6 +++++-
 4 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 20cd0ef3c394..fdb4b290ca68 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -393,7 +393,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn);
+	bset->bd = bsg_register_queue(q, dev, name, bsg_transport_sg_io_fn, NULL);
 	if (IS_ERR(bset->bd)) {
 		ret = PTR_ERR(bset->bd);
 		goto out_cleanup_queue;
diff --git a/block/bsg.c b/block/bsg.c
index e0af6206ed28..4eaea66ad492 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -12,6 +12,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/io_uring/cmd.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -28,6 +29,7 @@ struct bsg_device {
 	unsigned int timeout;
 	unsigned int reserved_size;
 	bsg_sg_io_fn *sg_io_fn;
+	bsg_uring_cmd_fn *uring_cmd_fn;
 };
 
 static inline struct bsg_device *to_bsg_device(struct inode *inode)
@@ -158,11 +160,41 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 }
 
+static int bsg_check_uring_features(unsigned int issue_flags)
+{
+	/* BSG passthrough requires big SQE/CQE support */
+	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
+	    (IO_URING_F_SQE128|IO_URING_F_CQE32))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct request_queue *q;
+	struct bsg_device *bd;
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
+	int ret;
+
+	bd = to_bsg_device(file_inode(ioucmd->file));
+	q = bd->queue;
+
+	ret = bsg_check_uring_features(issue_flags);
+	if (ret)
+		return ret;
+
+	if (!bd->uring_cmd_fn)
+		return -EOPNOTSUPP;
+
+	return bd->uring_cmd_fn(q, ioucmd, issue_flags, open_for_write);
+}
+
 static const struct file_operations bsg_fops = {
 	.open		=	bsg_open,
 	.release	=	bsg_release,
 	.unlocked_ioctl	=	bsg_ioctl,
 	.compat_ioctl	=	compat_ptr_ioctl,
+	.uring_cmd	=	bsg_uring_cmd,
 	.owner		=	THIS_MODULE,
 	.llseek		=	default_llseek,
 };
@@ -187,7 +219,8 @@ void bsg_unregister_queue(struct bsg_device *bd)
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
 struct bsg_device *bsg_register_queue(struct request_queue *q,
-		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn)
+		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn,
+		bsg_uring_cmd_fn *uring_cmd_fn)
 {
 	struct bsg_device *bd;
 	int ret;
@@ -199,6 +232,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	bd->reserved_size = INT_MAX;
 	bd->queue = q;
 	bd->sg_io_fn = sg_io_fn;
+	bd->uring_cmd_fn = uring_cmd_fn;
 
 	ret = ida_alloc_max(&bsg_minor_ida, BSG_MAX_DEVS - 1, GFP_KERNEL);
 	if (ret < 0) {
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index a9a9ec086a7e..4d57e524e141 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bsg.h>
+#include <linux/io_uring/cmd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
@@ -9,6 +10,12 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+			       unsigned int issue_flags, bool open_for_write)
+{
+	return -EOPNOTSUPP;
+}
+
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
@@ -99,5 +106,6 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 struct bsg_device *scsi_bsg_register_queue(struct scsi_device *sdev)
 {
 	return bsg_register_queue(sdev->request_queue, &sdev->sdev_gendev,
-			dev_name(&sdev->sdev_gendev), scsi_bsg_sg_io_fn);
+			dev_name(&sdev->sdev_gendev), scsi_bsg_sg_io_fn,
+			scsi_bsg_uring_cmd);
 }
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index ee2df73edf83..162730bfc2d8 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,13 +7,17 @@
 struct bsg_device;
 struct device;
 struct request_queue;
+struct io_uring_cmd;
 
 typedef int (bsg_sg_io_fn)(struct request_queue *, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout);
 
+typedef int (bsg_uring_cmd_fn)(struct request_queue *q, struct io_uring_cmd *ioucmd,
+			       unsigned int issue_flags, bool open_for_write);
+
 struct bsg_device *bsg_register_queue(struct request_queue *q,
 		struct device *parent, const char *name,
-		bsg_sg_io_fn *sg_io_fn);
+		bsg_sg_io_fn *sg_io_fn, bsg_uring_cmd_fn *uring_cmd_fn);
 void bsg_unregister_queue(struct bsg_device *bcd);
 
 #endif /* _LINUX_BSG_H */
-- 
2.25.1

