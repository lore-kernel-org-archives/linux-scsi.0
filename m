Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0623B8D78
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503658; cv=none; b=ODQDKuI5kJDBO1P3dq5l7ivARnpg9dc6qH98F0mbST/kaAk+4Q/mMnu/BwIIn7X07ptEjFLF/qT2arwr61YUFFf+pCD5WS2s2puLogs8fWM0JdFbbOMRsAI+1AXxol9OIFSh4vxU5Hg02dzoUQ45s9EV6XYMB9b6AOOAhg2uO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503658; c=relaxed/simple;
	bh=l+t8v9WxXW8yj45kL2UgUyKv0ERAXtt5Qf7uOcu7xTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl1wiksl6Ol40RQIOmitVxdqXKAeNyaUc/4LAPai1QO//fD8ci23aSg4I2pivN0V7KshdqlfgmUrhR15M8T08DYVXoyjFgFsrKHKNehpMovfX0gcD2sViNzdTFJokvL7+eIpKaxj+58/Zz8CAsg23pGjpvKVgT0h+aPR0E41dmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfzWXBTU; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfzWXBTU"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-9196b81f00dso1429806d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 16:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503656; x=1792108456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=PfzWXBTUvrcEyAaAdlui4GFQ0ZVFsOvhA6u/FNPcAX0MsOdXGKImyHLoZRmXxKQpkW
         iDNIEHpOBzwXwkOGpM3HFVxT51nmRQzuhZfCppSl8KhMNSyW0hbTACLG+VD8c3VPbS3Y
         ZWsD3gNp4Fol3BhIJrLhBuMtdqt2TVw2XbRlCAyxNN6fgxCAbft9B51rBfBt4XGBgniC
         NAu7UlK7vQOejkWMDxh9FmDW2jMEzvNtJ2+3a4c/voKLB/rDRg+8J918q95rkSgfpzCm
         Q7bCZOvlgtyfJPRmY2LqQGKn3GzrRzcQr3QDBsVWpsaKXx/d4bLvna55hgu4qkJxY3rY
         cXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503656; x=1792108456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=1KzR5hTbhz5WpVaWNxEVEYeKP14JN7Q2Rl+ISr+F+971jRW4sW6KRfDOOtD/QKiNP8
         OseY0kzcfdIezZZZcyP08oI9l5/Lr1DF/aBQHSzG+blO2tcHoabrf7gDmJZsrMOH0pWi
         LuSV0ne0piYhXSsR+bR7jJ0IzbzTpsCd4uyVkCDrswK310rt5YfqazrftDFAnEcJnLfb
         jstB0fSjcnnlPMGiR3qDbQn/z1kg5Qy4YC4erVhOKu2UmqpS71u0uQyUK/GFxmdtvYjL
         T/oDRuYdlWCgczwMnY2EncQXSCjE+/Mi9SCwjLN3G6Iw3okuX3k+5Ii/zRBbkLDnwG6+
         NrLg==
X-Forwarded-Encrypted: i=1; AKwUvBzb6S3WKijQxwvuh1HRALPKBtXDEZgV2hmPTInlkKEcvcVIzqAxHeimVt2IG4cTo0G+AptrJtiING2T@vger.kernel.org
X-Gm-Message-State: AFq9FYK+lrqHnFqlbUhkkH3JWuTUbDe7jp4zXP50aKKO7jbHdKNYeIEf
	Rz6jZVyJFk5f7V0IndGpxhFr/QWHf9CDUO1lKZUZA4kWzrwEyV81Qsnb1M9g87aDKss=
X-Gm-Gg: AYBFou2jOse7wu7wMqNjSe52VjTSNIWxB2uXFNPM60F++bxBK0arV2erGnJT0lycqt8
	zL32kvM0TAY89K+KhSvfJ0zpgXgM9q4McwavNIQ604b4RuYW03kJUjd8jdzFjzAjU2lWj4LzXn2
	kEXxbDtpq00f/lMN/lgCIYVxQKRY/a5JvIiYLcfrau3XIJwNtzmX0u9Nmr6pqLe/F1veaHWRPnC
	64zFdVjbuS9DKeRC/QdkEWQ+nXPrkaF1e/fb9b742k6hbrTFUvps1DG1AXt2IDY/7S55f3qic04
	W7CzsijdzfszXCLsg5lOwGNPOYdXgeULn/TuzmsMw7v/b+h/NOLguZ/ikayu9bCKUNsLswOdaA2
	cjFmZNSm6ggGP8qqy9e7e7Y6zF5wgkJ3ddlzq/w62uN5emhlrIs1BohDwEengqZtUWw9BTfeF4w
	8udZ+7FETML0eaxSmxsEzeSvwt2md3Ihq0GwIroLiXQNeaQmRMpOPKF7pjn/7zyUD5CdYqhH+I1
	Go75icKpaGXlCznGa3wGLmrHahITE0MsbVJXbs5BUU7tQWtAqTEQlvVdXVhXDb/kjZz4px18KgE
	bWJUXxhvgisjzLSNfAA=
X-Received: by 2002:a05:6214:410a:b0:919:89f4:64f1 with SMTP id 6a1803df08f44-91b5537b9bdmr7537496d6.2.1791503656427;
        Thu, 08 Oct 2026 16:54:16 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:16 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 1/3] scsi: target: rd: Fix oversized sg table array allocation
Date: Thu,  8 Oct 2026 19:54:07 -0400
Message-ID: <20261008235411.56641-2-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008235411.56641-1-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

The rd_pages= device parameter is taken from configfs without an upper
bound. rd_build_device_space() uses it to size the sg table array, so a
large value such as INT_MAX makes it attempt a kzalloc() of roughly
64 MiB, which is above the page allocator's maximum order and triggers:

  WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x294/0x874
  Call trace:
   __alloc_frozen_pages_noprof+0x294/0x874 (P)
   ___kmalloc_large_node+0x64/0xd0
   __kmalloc_noprof+0x24/0x54
   rd_configure_device+0x74/0xdc
   target_configure_device+0xa0/0x1c4
   target_dev_enable_store+0x4c/0x5c
   configfs_write_iter+0xec/0x124

A ramdisk is backed page-by-page by system memory, so a page count
larger than totalram_pages() can never be satisfied. Reject it with
-EINVAL before allocating anything. NULLIO devices allocate no backing
pages and are not affected.

The array needs 64 bytes per 2048 pages, so even a valid page count
exceeds the 4 MiB maximum order once the ramdisk is larger than 512 GiB.
Allocate the sg table arrays with kvzalloc_objs() so that large arrays
fall back to vmalloc.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Reported-by: syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fa495e1497c48a6ed885
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d..97c63b122 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/highmem.h>
+#include <linux/mm.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -81,7 +82,7 @@ static u32 rd_release_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *s
 		kfree(sg);
 	}
 
-	kfree(sg_table);
+	kvfree(sg_table);
 	return page_count;
 }
 
@@ -188,10 +189,16 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rd_dev->rd_flags & RDF_NULLIO)
 		return 0;
 
+	if (rd_dev->rd_page_count > totalram_pages()) {
+		pr_err("Page count: %u exceeds total RAM pages: %lu for Ramdisk device\n",
+		       rd_dev->rd_page_count, totalram_pages());
+		return -EINVAL;
+	}
+
 	total_sg_needed = rd_dev->rd_page_count;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-	sg_table = kzalloc_objs(*sg_table, sg_tables);
+	sg_table = kvzalloc_objs(*sg_table, sg_tables);
 	if (!sg_table)
 		return -ENOMEM;
 
@@ -248,7 +255,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-	sg_table = kzalloc_objs(*sg_table, sg_tables);
+	sg_table = kvzalloc_objs(*sg_table, sg_tables);
 	if (!sg_table)
 		return -ENOMEM;
 
-- 
2.48.1

