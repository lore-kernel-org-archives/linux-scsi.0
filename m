Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E4438C428;
	Tue, 17 Mar 2026 07:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773732223; cv=none; b=gYI5Ndour0dH5tyq3MwlfHWBd71ORKhQiFH771LQL9egP/L0H6oYwM+R0sXQDyuNXplKMOHDqc+6mdZ1Jmm7FwHT1UIcb037SGDf5WcFqUEDv6v/6JfwsCAoZOiporEEMLspXPgYRnnXDa2jsycxyjAWph6DJnquL0jTq32JuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773732223; c=relaxed/simple;
	bh=94kV+YyGbPZOnbSyDlcl8B4SY4FtvRNWeUcVSiwZ+nU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0uRgGVShIRs/ibqhD6Mz6o8racDbMcg6aYWV1Vp7YMcyAFfRXGV1o8NhfWtP6a8gIrMayX66rr8xGwaHq5oFVXtTQD7/XjU8gBgTGWrnkbCGriCDV+8hEmDWZPNsHaMzb18UVFEz1nWAEk9FACYz4rqRRHQhDVefKXl8zKxnx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HiCV+QKN; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HiCV+QKN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9R
	qBGzMKagNYReOeRIu2ZbercOTEKpe3p1vmTXLqjDo=; b=HiCV+QKNvPnneDcO5f
	5Uf3LxXgnvXdmayX63zkHszmpHL0R/1KuptdKDpL8aUERRGO1Su3ANBnHkuFzkTG
	rv4k5edw7NFvDfwizMukmCe1gUb7wfd7OPQOZuqB/yY4WdD3mdt8YbqW/grz2wLN
	G1rQdZP2apBtS18TMgrg5Zik0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnhdw1AblpkrBDWA--.58229S4;
	Tue, 17 Mar 2026 15:22:34 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v8 2/3] bsg: add io_uring command support to generic layer
Date: Tue, 17 Mar 2026 15:22:25 +0800
Message-Id: <20260317072226.2598233-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260317072226.2598233-1-yangxiuwei@kylinos.cn>
References: <20260317072226.2598233-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnhdw1AblpkrBDWA--.58229S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFW7ZrykGry8KFyxWFWDCFg_yoW7Cry3pF
	WrXa15JrWFgr4xuFZ8JFs8Ar9Iqw48K3yxJFyI9345KrnFyr9aqr1kWFy8tFWrJrWkCayY
	qanYqrWDCr1UAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-sqAUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hoXp2m5ATrc0AAA3n

Add an io_uring command handler to the generic BSG layer. The new
.uring_cmd file operation validates io_uring features and delegates
handling to a per-queue bsg_uring_cmd_fn callback.

Extend bsg_register_queue() so transport drivers can register both
sg_io and io_uring command handlers.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 block/bsg-lib.c         |  2 +-
 block/bsg.c             | 33 ++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_bsg.c | 10 +++++++++-
 include/linux/bsg.h     |  6 +++++-
 4 files changed, 47 insertions(+), 4 deletions(-)

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
index e0af6206ed28..82aaf3cee582 100644
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
@@ -158,11 +160,38 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+	struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
+	struct request_queue *q = bd->queue;
+	int ret;
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
@@ -187,7 +216,8 @@ void bsg_unregister_queue(struct bsg_device *bd)
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
 struct bsg_device *bsg_register_queue(struct request_queue *q,
-		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn)
+		struct device *parent, const char *name, bsg_sg_io_fn *sg_io_fn,
+		bsg_uring_cmd_fn *uring_cmd_fn)
 {
 	struct bsg_device *bd;
 	int ret;
@@ -199,6 +229,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
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

