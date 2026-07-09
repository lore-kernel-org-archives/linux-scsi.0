Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA50395AF5;
	Thu,  9 Jul 2026 04:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783572041; cv=none; b=VkeX/lS7QvaM0wDEMi6HNUz9yKNOmW2qR6GCySyaRb1cKrRsPT6u35HtLVxS/unHaqig31AxfDGmpjeNJuCbGRhSngKc9HqSJni7aGtG3g9tp988isiHfsU1jp+B1XxzXAdkaQFFf3Kgze/Fhw4pT0Qj7mBdjQKKFVQVWq0vHjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783572041; c=relaxed/simple;
	bh=sszC4oHAl25pngDZxm+QTBDgd3UtqV8z2Peqwo9iLBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2yKg/Wmv3PB4TdYDJoMvj1L6l2t1lHoTKmtsejPKUL6ynzZv0XhSc1smDt7F9en8EsHris21spr2Oembi98LuQ5GWr1a59YhHr8owVP0lyCOBhO5EFJgDcyzLnlQX61b/cFBTFkUUiwlmcBY9NJgyjff8wdhafrsbAHsHgFmrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gwj1l72MmzKHMPT;
	Thu,  9 Jul 2026 12:40:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EA02140597;
	Thu,  9 Jul 2026 12:40:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBHWHQ4Jk9qUIhNAg--.33862S6;
	Thu, 09 Jul 2026 12:40:28 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yukuai@kernel.org,
	hch@lst.de,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	yangerkun@huawei.com
Subject: [PATCH v2 2/2] scsi: sg: clean up scatter_elem_sz handling and module param permissions
Date: Thu,  9 Jul 2026 12:32:34 +0800
Message-ID: <20260709043234.2447340-3-yangerkun@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260709043234.2447340-1-yangerkun@huawei.com>
References: <20260709043234.2447340-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHWHQ4Jk9qUIhNAg--.33862S6
X-Coremail-Antispam: 1UD129KBjvJXoWxur4DKr4fJrW8Aw48uFyDWrg_yoWrtF43pF
	WfJFW29rWrGF4jgwsrXw4DGwnxua45K34YkFy0qw1Y93s8A3WrWF17JFyjqFWUJr95GrWk
	KrWDZ3W8Z342ka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUH0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVAKzI0EY4vE52x082I5MxAqzxv26xkF
	7I0En4kS14v26r1q6r43MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8S1v3UUUUU==
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Now that scatter_elem_sz is validated and rounded up to a power-of-two
multiple of PAGE_SIZE by the .set callback at write time (and the
init-time value SG_SCATTER_SZ is always >= PAGE_SIZE), the runtime
fixup logic in sg_build_indirect() is redundant:

  - The entry fixup (syncing scatter_elem_sz_prev to scatter_elem_sz)
    was fragile -- it updated scatter_elem_sz_prev but not the local
    variable "num", which is the exact source of the UBSAN warning
    fixed by the previous patch.
  - The in-loop fixup (updating scatter_elem_sz to ret_sz when
    ret_sz > scatter_elem_sz_prev) is no longer needed because
    scatter_elem_sz is always a power-of-two multiple of PAGE_SIZE,
    making it always equal to ret_sz.
  - The init_sg boot-time clamp is also removed as it can no longer
    trigger (SG_SCATTER_SZ >= PAGE_SIZE, and the .set callback rejects
    sub-PAGE_SIZE values).

Remove the scatter_elem_sz_prev variable, the entry/in-loop fixup, and
the boot-time clamp. Snapshot scatter_elem_sz into a local elem_sz for
get_order(), and switch the debug printk to "%s"/__func__ since the
"num" argument no longer exists.

While at it, replace S_IRUGO | S_IWUSR with 0644 for the allow_dio and
def_reserved_size module parameters, as checkpatch warns about symbolic
permissions on touched module_param lines.

Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c56f8460c03f..377c3e1dee7f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -92,7 +92,6 @@ static int def_reserved_size = SG_DEF_RESERVED_SIZE;
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
 
@@ -1649,7 +1648,7 @@ static int scatter_elem_sz_set(const char *val, const struct kernel_param *kp)
 module_param_call(scatter_elem_sz, scatter_elem_sz_set, param_get_int,
 		  &scatter_elem_sz, 0644);
 
-module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
+module_param_named(allow_dio, sg_allow_dio, int, 0644);
 
 static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
 {
@@ -1675,8 +1674,7 @@ static const struct kernel_param_ops def_reserved_size_ops = {
 	.get	= param_get_int,
 };
 
-module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size,
-		   S_IRUGO | S_IWUSR);
+module_param_cb(def_reserved_size, &def_reserved_size_ops, &def_reserved_size, 0644);
 
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
@@ -1694,11 +1692,6 @@ init_sg(void)
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
@@ -1880,9 +1873,10 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
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
@@ -1900,39 +1894,19 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
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

