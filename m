Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CC1E2858
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495404; cv=none; b=D5+vC/vn4CemKKQFuR2CNtANtewYfD+kGrWlnOpKWyWU3AjisVd0juCcdlUQstbf+BRt2J9C5geED1llfqzey4Zzl5VB35QTcYxy2Prn1jacQPbQpK4Ll9QxgwBzSTcvpMfv+1Y3ZUmOtwFpgQV+r+1CBrSsecnTJkI8Jua593E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495404; c=relaxed/simple;
	bh=08REbb35qUt0o2HUogn2468UIDAltM5Lqc7Ti3ZOMQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+/hdbbh86T0XLg/21Gv2d/HUduTj7hXdm9azTuI6LCaFPF8AAmK+dxjmbhqylDsglsN9gU5/6hjl0z+Gbac4iN0oYRI8/z6EW9dc7fKYjW7GoKjKYgPn46Ydg4o4hTs7GIJwN0cl3GGcH6QV4sBeYEk1MpUbeithyEEOQ3rWbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f0b9M2WhJzKHMKQ
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E198B4056B
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfVZW3hpL_QVFQ--.16598S7;
	Tue, 27 Jan 2026 14:29:53 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v2 3/3] scsi: sg: Remove deprecated sg-big-buff
Date: Tue, 27 Jan 2026 14:20:44 +0800
Message-Id: <20260127062044.3034148-4-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfVZW3hpL_QVFQ--.16598S7
X-Coremail-Antispam: 1UD129KBjvJXoWxur48AryUuFWftrykZFy5urg_yoWrKry7pF
	Wa9r4IvrW5Wr18Grs8tFWDAFy5uasrt3429FZ7Z34avF1UGr9IqF1fJFyIqFW3GrZ5Ga18
	Jw1DZa4ru3yUJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHSb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I
	0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVAKzI0EY4vE52x082I5MxAq
	zxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1sqXP
	UUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

These deprecated sysctl has been broken since commit 26d1c80fd61e5
("scsi/sg: move sg-big-buff sysctl to scsi/sg.c") and nobody has found
this. I believe it's time to remove it, which will allow us to clean
up a significant amount of code.

Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 59 +++++++++--------------------------------------
 1 file changed, 11 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 21c3962ee1cb..ff66613f418f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -81,14 +81,14 @@ static int sg_proc_init(void);
 
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
-static int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
-   /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
-   of this size (or less if there is not enough memory) will be reserved
-   for use by this file descriptor. [Deprecated usage: this variable is also
-   readable via /proc/sys/kernel/sg-big-buff if the sg driver is built into
-   the kernel (i.e. it is not a module).] */
-static int def_reserved_size = -1;	/* picks up init parameter */
+ * /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
+ * of this size (or less if there is not enough memory) will be reserved
+ * for use by this file descriptor.
+ */
+
+/* picks up init parameter */
+static int def_reserved_size = SG_DEF_RESERVED_SIZE;
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
@@ -1661,35 +1661,6 @@ MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element "
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
-#ifdef CONFIG_SYSCTL
-#include <linux/sysctl.h>
-
-static const struct ctl_table sg_sysctls[] = {
-	{
-		.procname	= "sg-big-buff",
-		.data		= &sg_big_buff,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-};
-
-static struct ctl_table_header *hdr;
-static void register_sg_sysctls(void)
-{
-	if (!hdr)
-		hdr = register_sysctl("kernel", sg_sysctls);
-}
-
-static void unregister_sg_sysctls(void)
-{
-	unregister_sysctl_table(hdr);
-}
-#else
-#define register_sg_sysctls() do { } while (0)
-#define unregister_sg_sysctls() do { } while (0)
-#endif /* CONFIG_SYSCTL */
-
 static int __init
 init_sg(void)
 {
@@ -1699,10 +1670,6 @@ init_sg(void)
 		scatter_elem_sz = PAGE_SIZE;
 		scatter_elem_sz_prev = scatter_elem_sz;
 	}
-	if (def_reserved_size >= 0)
-		sg_big_buff = def_reserved_size;
-	else
-		def_reserved_size = sg_big_buff;
 
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
 				    SG_MAX_DEVS, "sg");
@@ -1714,7 +1681,6 @@ init_sg(void)
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
-		register_sg_sysctls();
 #ifdef CONFIG_SCSI_PROC_FS
 		sg_proc_init();
 #endif				/* CONFIG_SCSI_PROC_FS */
@@ -1729,7 +1695,6 @@ init_sg(void)
 static void __exit
 exit_sg(void)
 {
-	unregister_sg_sysctls();
 #ifdef CONFIG_SCSI_PROC_FS
 	remove_proc_subtree("scsi/sg", NULL);
 #endif				/* CONFIG_SCSI_PROC_FS */
@@ -2205,10 +2170,8 @@ sg_add_sfp(Sg_device * sdp)
 	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_add_sfp: sfp=0x%p\n", sfp));
-	if (unlikely(sg_big_buff != def_reserved_size))
-		sg_big_buff = def_reserved_size;
 
-	bufflen = min_t(int, sg_big_buff,
+	bufflen = min_t(int, def_reserved_size,
 			max_sectors_bytes(sdp->device->request_queue));
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
@@ -2436,7 +2399,7 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 
 static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
 {
-	return single_open(file, sg_proc_seq_show_int, &sg_big_buff);
+	return single_open(file, sg_proc_seq_show_int, &def_reserved_size);
 }
 
 static ssize_t 
@@ -2453,7 +2416,7 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 	if (err)
 		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
-		sg_big_buff = k;
+		def_reserved_size = k;
 		return count;
 	}
 	return -ERANGE;
@@ -2626,7 +2589,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 
 	if (it && (0 == it->index))
 		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
-			   (int)it->max, sg_big_buff);
+			   (int)it->max, def_reserved_size);
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-- 
2.39.2

