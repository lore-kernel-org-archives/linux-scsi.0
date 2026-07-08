Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E773DB64B;
	Wed,  8 Jul 2026 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783492724; cv=none; b=A6BNma0xyKVi10LViQqybkPmRhHfGULPRYAMtIQhSNPEnS/NZo/mS/sNSmpLxLeS1VUOefUohupZiLt21acs3Qrmb+xbJYFFj0BsaB++tQ+kfJ56PrfbC5Q6hDrdCfQBgW1dJeo8uUZjMvVrGqaW2DBTXdIfKC3ze9xIPleuBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783492724; c=relaxed/simple;
	bh=XnHptsupe31IfwuSGI2O5NgEIUMtzDrC2TUeEEvxXL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RzBFKUH69JnHS8YZNcxHAlunYAV4c3ZI9c0GzzVs+DkdIuOp1XoCiv7dALbDh+tAibXIhn4z27jZZNQZtXtCBOU5wtP/HPH2oLu5L8HBYreHlB4aahpTrpM6NUUmXznaXjZno1V9gw6Yli/Bg/j30nLA2UScPk4O2Zf9LGKmMRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gw7hS6KJjzKHMLt;
	Wed,  8 Jul 2026 14:38:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6FD01405CA;
	Wed,  8 Jul 2026 14:38:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nJo8E1qVSffAQ--.18674S4;
	Wed, 08 Jul 2026 14:38:37 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yukuai@kernel.org,
	hch@lst.de,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	yangerkun@huawei.com
Subject: [PATCH] scsi: sg: validate and round up scatter_elem_sz module parameter
Date: Wed,  8 Jul 2026 14:30:45 +0800
Message-ID: <20260708063045.2008478-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nJo8E1qVSffAQ--.18674S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKr4rXr1UWr1DXw43GF1Utrb_yoW7Kr1DpF
	WfJFW29rWrGr12qwsrXr4UKrn09as5K345uF92qw1a93s8Jwn8uF1UAFWYqFy5Jr95GrWk
	KFWDZ3Wru342ka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY
	0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU1nYFJUUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

echo -1 or 0 > /sys/module/sg/parameters/scatter_elem_sz
exec 4<> /dev/sg0

The preferred shell trigger following UBSAN warning:

UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1888:13
shift exponent 64 is too large for 32-bit type 'int'
....
Call Trace:
 <TASK>
 dump_stack_lvl+0x64/0x80
 __ubsan_handle_shift_out_of_bounds+0x1d1/0x380
 sg_build_indirect.cold+0x38/0x4b
 sg_build_reserve+0x59/0x90
 sg_add_sfp+0x151/0x240
 sg_open+0x169/0x310
 chrdev_open+0xbe/0x240
 do_dentry_open+0x121/0x480
 vfs_open+0x2e/0xf0
 do_open+0x265/0x400
 path_openat+0x110/0x2b0
 do_file_open+0xe4/0x1a0
 do_sys_openat2+0x7f/0xe0
 __x64_sys_openat+0x56/0xa0
 do_syscall_64+0xf5/0x640
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The scatter_elem_sz module parameter currently lacks validation. Setting
it to -1/0 causes a left shift overflow in sg_build_indirect. Although
this overflow does not currently cause other problem, allowing
scatter_elem_sz to be set to -1/0 is not appropriate given its intended
purpose. Therefore, this patch uses module_param_call to add validation
checks.

Additionally, the code handling scatter_elem_sz is refactored for
clarity: the scatter_elem_sz_prev variable and the runtime fixup logic
in sg_build_indirect() are removed. The entry fixup (syncing
scatter_elem_sz_prev to scatter_elem_sz) was fragile -- it updated
scatter_elem_sz_prev but not the local variable "num", which is the
exact source of the UBSAN warning. The in-loop fixup (updating
scatter_elem_sz to ret_sz when ret_sz > scatter_elem_sz_prev) is no
longer needed because the .set callback rounds up scatter_elem_sz to a
power-of-two multiple of PAGE_SIZE, making it always equal to ret_sz.
The init_sg boot-time clamp is also removed as SG_SCATTER_SZ (32768)
is always >= PAGE_SIZE.

Fixes: 6460e75a104d ("[SCSI] sg: fixes for large page_size")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 68 +++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 74cd4e8a61c2..377c3e1dee7f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -92,7 +92,6 @@ static int def_reserved_size = SG_DEF_RESERVED_SIZE;
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
 
@@ -1622,8 +1621,34 @@ sg_remove_device(struct device *cl_dev)
 	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
-module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
+static int scatter_elem_sz_set(const char *val, const struct kernel_param *kp)
+{
+	int ret, new_val, order;
+
+	ret = kstrtoint(val, 0, &new_val);
+	if (ret)
+		return ret;
+
+	if (new_val <= 0) {
+		pr_err("sg: scatter_elem_sz must be positive, got %d\n", new_val);
+		return -EINVAL;
+	}
+
+	order = get_order(new_val);
+	if (order > MAX_PAGE_ORDER) {
+		pr_err("sg: scatter_elem_sz too large (order %d > MAX_PAGE_ORDER %d)\n",
+			order, MAX_PAGE_ORDER);
+		return -EINVAL;
+	}
+
+	scatter_elem_sz = 1 << (PAGE_SHIFT + order);
+	return 0;
+}
+
+module_param_call(scatter_elem_sz, scatter_elem_sz_set, param_get_int,
+		  &scatter_elem_sz, 0644);
+
+module_param_named(allow_dio, sg_allow_dio, int, 0644);
 
 static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
 {
@@ -1649,8 +1674,7 @@ static const struct kernel_param_ops def_reserved_size_ops = {
 	.get	= param_get_int,
 };
 
-module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size,
-		   S_IRUGO | S_IWUSR);
+module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size, 0644);
 
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
@@ -1668,11 +1692,6 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
-		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
-
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
 				    SG_MAX_DEVS, "sg");
 	if (rc)
@@ -1854,9 +1873,10 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 static int
 sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 {
-	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
+	int ret_sz = 0, i, k, rem_sz, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
+	int elem_sz = scatter_elem_sz;
 	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 
 	if (blk_size < 0)
@@ -1874,39 +1894,19 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	if (mx_sc_elems < 0)
 		return mx_sc_elems;	/* most likely -ENOMEM */
 
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
-	}
-
-	order = get_order(num);
+	order = get_order(elem_sz);
 retry:
 	ret_sz = 1 << (PAGE_SHIFT + order);
 
 	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
 	     k++, rem_sz -= ret_sz) {
-
-		num = (rem_sz > scatter_elem_sz_prev) ?
-			scatter_elem_sz_prev : rem_sz;
-
 		schp->pages[k] = alloc_pages(gfp_mask, order);
 		if (!schp->pages[k])
 			goto out;
 
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
-		}
-
 		SCSI_LOG_TIMEOUT(5, sg_printk(KERN_INFO, sfp->parentdp,
-				 "sg_build_indirect: k=%d, num=%d, ret_sz=%d\n",
-				 k, num, ret_sz));
+				 "%s: k=%d, ret_sz=%d\n",
+				 __func__, k, ret_sz));
 	}		/* end of for loop */
 
 	schp->page_order = order;
-- 
2.52.0

