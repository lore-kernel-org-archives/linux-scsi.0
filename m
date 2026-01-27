Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854A32AAA5
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495403; cv=none; b=rmOreMBl/lLhiCnqjttGj4JssfndXVaDL74p7ZLCgIyf8UcNDtMrcTulif03z+wqHjXMaBe5B/OGFMRa5I55KZSWA6gmt0CX2Hrb8pvPBRKKKI1BOURaGynX9AAoymTDCgOW2xPz+ROnDb8+Y4c4bJ/I+jIzJg+l0P0TL1auZew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495403; c=relaxed/simple;
	bh=NKgh3Hkj/5gQkJBitSkEcln+TWr5GbQwes7T+SF2mg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D6+QcKJ0hIZyn+Jx14W4IO7IGquZWNpOh+WXlHOWOFLRQOKLYTPtP6AfUeVZaluZsljKeiCaw47phwspMjW3f7q0uSp7kbIujlaSt5BTvM88vwRm6XNHA9Z0x2m7OgrFETvgFYrGptNcOujbtMNXEbKzjYjAA9Wuu8M1WfDwzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f0b9M2BwBzKHMbD
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D6BEE40577
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfVZW3hpL_QVFQ--.16598S6;
	Tue, 27 Jan 2026 14:29:51 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v2 2/3] scsi: sg: Resolve soft lockup issue when opening /dev/sgX
Date: Tue, 27 Jan 2026 14:20:43 +0800
Message-Id: <20260127062044.3034148-3-yangerkun@huawei.com>
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
X-CM-TRANSID:gCh0CgAXxfVZW3hpL_QVFQ--.16598S6
X-Coremail-Antispam: 1UD129KBjvJXoWxuF18ArW5WF15ZFW5trykAFb_yoW5Gw4DpF
	WxJa45ArWUGrsF9r4ftrWUAF98ua9aqrWakFZ3X343ZFs8X34SvF18JFyYvrW5GrZ5Wr1j
	qF1DZw1rua47JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHSb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
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
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8ha9D
	UUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

The parameter def_reserved_size defines the default buffer size reserved
for each Sg_fd and should be restricted to a range between 0 and
1,048,576 (see https://tldp.org/HOWTO/SCSI-Generic-HOWTO/proc.html).
Although the function sg_proc_write_dressz enforces this limit, it is
possible to bypass it by directly modifying the module parameter as
shown below, which then causes a soft lockup:

echo -1 > /sys/module/sg/parameters/def_reserved_size
exec 4<> /dev/sg0

watchdog: BUG: soft lockup - CPU#5 stuck for 26 seconds! [bash:537]
Modules loaded:
CPU: 5 UID: 0 PID: 537 Command: bash, kernel version 6.19.0-rc3+ #134,
PREEMPT disabled
Hardware: QEMU Standard PC (i440FX + PIIX, 1996), BIOS version
1.16.1-2.fc37 dated 04/01/2014
...
Call Trace:

  sg_build_reserve+0x5c/0xa0
  sg_add_sfp+0x168/0x270
  sg_open+0x16e/0x340
  chrdev_open+0xbe/0x230
  do_dentry_open+0x175/0x480
  vfs_open+0x34/0xf0
  do_open+0x265/0x3d0
  path_openat+0x110/0x290
  do_filp_open+0xc3/0x170
  do_sys_openat2+0x71/0xe0
  __x64_sys_openat+0x6d/0xa0
  do_syscall_64+0x62/0x310
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The fix is to use module_param_cb to validate and reject invalid values
assigned to def_reserved_size.

Fixes: 6460e75a104d ("[SCSI] sg: fixes for large page_size")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c93cc9323f56..21c3962ee1cb 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1621,10 +1621,35 @@ sg_remove_device(struct device *cl_dev)
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
-module_param_named(def_reserved_size, def_reserved_size, int,
-		   S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
+static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
+{
+	int size, ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtoint(val, 0, &size);
+	if (ret)
+		return ret;
+
+	/* limit to 1 MB */
+	if (size < 0 || size > 1048576)
+		return -ERANGE;
+
+	def_reserved_size = size;
+	return 0;
+}
+
+static const struct kernel_param_ops def_reserved_size_ops = {
+	.set	= def_reserved_size_set,
+	.get	= param_get_int,
+};
+
+module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size,
+		   S_IRUGO | S_IWUSR);
+
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
-- 
2.39.2

