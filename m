Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE23274B4A
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506145; cv=none; b=mVTnq9r3AhKE3ZeSl3T+jaweGIq5s+tMK53v6vAnN5hfhNViyvN1++r2VcEGmoCCibj1GrKO8b7yKiOhs/Dkk819Ph/eY3xZMM/XlsCFyXmSeLwR/dz3TYVlxA26TmsHnHSs+ysQRlV8G2qsHjKvJIX5kF/E5cuwuug5ZPC7/gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506145; c=relaxed/simple;
	bh=l+t8v9WxXW8yj45kL2UgUyKv0ERAXtt5Qf7uOcu7xTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COHfHnupdPTQ7YyhIQqp1B9U7chQMjGrSBK8yCQ+SIW5RxEeYmQJTG5AljdSPOob5J8rh8LJNt+Qty+7AkhBA7B28/OVBpvv8KnuyB4eufkx0jWAAUE8ucbOg1IBSlk3iWNqheZwI1B0qMUb+ruwSfMKqKzO2GbtFeGumX6rzzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBORn/o7; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBORn/o7"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e8e8228183so26968e0c.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 17:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506143; x=1792110943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=UBORn/o7WKX3E4QP9bNP14sMHj9DTfWDzRRL1344vxuMzrTmzQcR7x+CENL6iRddFp
         shDUTHdFyGUi5Z8D0pID3c0ndm4VtF8E78RMXGyu9aZRRYce3iRb/J1AITQgOF2QjQV2
         D4pTt4epZc+TwmDYWhJHwAObUbKAqJ4LRyYh120jTlHwLDh4mYTk/Z2erXIJGSo887yR
         6nt46HiOoQaPfj/Og70gZoKpYTSUrm0LJ6YVAvbP2DcrHg495B54PJHf9UoVwnxS9GI5
         ziZAg+h8TjO3ZiPffpxwenhQjTSLh6VcQC7sfeKvwZsm5ovuVirzG3yAcgYDml3mgIME
         DtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506143; x=1792110943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=nzD8T3ogiPJfJAdxiM+gWcOhyQB0g24fiJRx0sjQQzePMXLcYd4LcKec5Wyc5AAw0O
         svgRbpN6lU/BDHa2BUzXMn2/2ua1cXdSSTRRtXssQdTZQuEBb3J+TQyIZs/xHSh9rK7S
         IQT7jJMpWtzti/Yj0JQpir2jbpk9QlmuM2zYetSspP/OoTax6DTv2eWPEbE+YN5neKdE
         3BhMM7Go+DLq7c80XMx6SahsYN1e06oaLHKfymuJFZtVmJp8DpWEPI/2Os1zhlMi+nCz
         ydLeyu6XdM6YoGJm0vf7a1AbsoVTRpHldKz2/05U2YlAp3e99VTggk2wBdtFo5CW/Dzm
         n76Q==
X-Forwarded-Encrypted: i=1; AKwUvBzGYQNeyXJpcSPG619QSTe+3NljVbFNMCCVnsMw2OcjY0PJ4XSismjgMAk9x1fhQNDs/CzSdoDQLf4r@vger.kernel.org
X-Gm-Message-State: AFq9FYJXbuPoDVD135PyOSW6uhyIHFwh7kK5wjpa4zPWbDblcP/EQ0YO
	mwkp+mWROzwyRVsmlkUjRrCNXu5Q6cpspGyf8SU9BFm3dletsVPa0rlR
X-Gm-Gg: AYBFou3cNKrxTqJg8zucqaopr+rJ/Us2B0UyfqA9bDs7VcMZkRhIzKTuQa809/AgBe9
	sPkhWy69GEu6ITDw55pbL/eAazffZFfn/lBbbCgW9Z6cKGVNfFSVjSFdHQFqQHC9qEutRY4E4h6
	a7SC9iwMnQtF7ExAScAQfSizqO6jiUaTbXbWOYb3geyC9PxWd8C2xolFBqrPD6jCgzKREiovZGu
	8V2xNV2kOXqdMi4KPWaf+85/0QdontvuVu03XKL5KMSwZ4XOckR98XAE75fguFjueshK96YR3ST
	KzouXK6/+SuGZRp4QO4QY0oZV7pkSOl3Xkjaj4veJVtX3L4RjAdGK3D4CQwe+GZQwG6kwnidO1p
	LPY1c6+B8O5WMyBmIhEXLRLvvRWzLKqniu37kg8yvw0BtfVZKX4x5vShDOtCQsMraiFQmPKjxvS
	i1MW4KQtXsfZB5AnFrTKUa/edKgKExrLDeW0X+FrAZuikz/35iUtMwWp7O2iC5tVvqzaR6/w+C2
	4xSsv0z5HqZjmYMaBtjSrK6njOql9N4DZXKwzNow/pK0aczfYWWir7XXo69AGqPz5DeoUIeawIm
	cbrYJKOLZVBgqEehYUA=
X-Received: by 2002:a05:6102:1624:b0:7c3:5d0:3028 with SMTP id ada2fe7eead31-7cb372122a9mr115807137.2.1791506142814;
        Thu, 08 Oct 2026 17:35:42 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:41 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 1/4] scsi: target: rd: Fix oversized sg table array allocation
Date: Thu,  8 Oct 2026 20:35:31 -0400
Message-ID: <20261009003537.62265-2-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
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

