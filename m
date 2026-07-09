Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037B9394783;
	Thu,  9 Jul 2026 04:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783572040; cv=none; b=kFtBXwRrnPBZPCYag8a4mJ27IqagrITgRkwYoAWWZfdm/XEytVfPRMntGVInk8gJH4ksKG/qZ0kLLtd9QS6s1WJo99jmmZMoOYjSsll4bTUUpYkZM7s5PC38dWP0rahZB/pBU6ZY9RQOho7CGfADqkIVTeW9PtUfvPLQ1Vg4rBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783572040; c=relaxed/simple;
	bh=L4ncj+uQliTk6Jn+4BKDrV6fI5Gmavh3PQXIndSQjaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtf3qcrABBgsqViHqXBM4BD01qqvHgxvfg+T+ffduJ1wd6vsSa03zThzHYQ1aHluonO9AFJ5hnMfOvXTdjI2Ac+Fjjp5dNbvWi48mGuf9gDXKq5v5vpcm/dxj98dCoXdlKrv957UEpQgAo99unoTs8MoOa5b1FTrp0NotPtK/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwj235tZ3zYQtk6;
	Thu,  9 Jul 2026 12:40:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D446C4058F;
	Thu,  9 Jul 2026 12:40:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBHWHQ4Jk9qUIhNAg--.33862S5;
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
Subject: [PATCH v2 1/2] scsi: sg: validate scatter_elem_sz module parameter
Date: Thu,  9 Jul 2026 12:32:33 +0800
Message-ID: <20260709043234.2447340-2-yangerkun@huawei.com>
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
X-CM-TRANSID:cCh0CgBHWHQ4Jk9qUIhNAg--.33862S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWDXr13urWxZF4fCw17ZFb_yoW5XF1fpF
	WxJrWFyrW8JwnFvw4aq3W8Gr909ayvkryYkas2q343uF95tryYvF1UJFW5Zry3JrWrGrWU
	tF1qqa45Wa4xGa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4c8EcI0Ec7Cj
	xVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzWrXDUUUU
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

echo -1 or 0 > /sys/module/sg/parameters/scatter_elem_sz
exec 4<> /dev/sg0

The above triggers the following UBSAN warning:

UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1888:13
shift exponent 64 is too large for 32-bit type 'int'
.....
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
checks: reject non-positive values and values whose order exceeds
MAX_PAGE_ORDER, and round the accepted value up to a power-of-two
multiple of PAGE_SIZE.

Fixes: 6460e75a104d ("[SCSI] sg: fixes for large page_size")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/scsi/sg.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 74cd4e8a61c2..c56f8460c03f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1622,7 +1622,33 @@ sg_remove_device(struct device *cl_dev)
 	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
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
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
 static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
-- 
2.52.0

