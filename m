Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E72947F3B7
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499042; cv=none; b=Tn+Dq3OxJrIuhhF4O4hNuhVssLrTo0wvu3i3UT924Q11jbMjee2ZeDwqLIgn3ih2wW5CmQ6YcLz9qrTKByGbxP1JcZeliJQjrQNFdbIwBNUozj30t18Yqp/DbHA7NNw07Nol9pkshytRehqyD65ktMlmtNps4Rxms9ztcZi5NwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499042; c=relaxed/simple;
	bh=l+t8v9WxXW8yj45kL2UgUyKv0ERAXtt5Qf7uOcu7xTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOV4kwOvlV8iToqiBs0VAvnbVDeO4hm1JTcJ/M/nqyJqYkNbi6hDpkI2qVTeUcWtuWG3MwQ3gcVZAIrPcWOOfVDxTz1ZZwLAyVAVCY63goxT1zlQKDsi+jH30guab2fizk6d6gqf3Octw9dZ4TsdqiMXPfWCLJC53/qp8gc5ehI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1PO/RLR; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1PO/RLR"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-988d3ad6432so30555241.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 15:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791499040; x=1792103840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=J1PO/RLRhIxUMC6MPZpcMUiLhYe9hfzpGXcJTipiyJdIwWkaeNm0kK/FseXZvRenS0
         Xl8wJ7oHdOGq16ciaeeP3mzfmWJrf2D03Jq8eZ3ktnIBkhdUOFNUHeNIDdnNYsn3tCeE
         YMVLuyNlUThYlFssDv0+8KyWRasAX04NyYnVjpPDP4su6Je0B3kM4D6Q699W/t/S3LrV
         WxoNO0UOthJqfd1NvDsavCB7d0BqBqvxr5ktfJ9wjZqidyLYx7DwEaIioEXqwYIdQxdy
         PTbIQ0ysb2Q6GE2OMddzjkKDKuCqSVdDTaNd4vaXUZ5k6g0RYViKhLmcJfVdJgan6lAu
         QJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791499040; x=1792103840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WdEsEyWM4pdqoDh+trBH24Lt+yVX+eIUgpA4t+jtMFA=;
        b=UhCUVWePcPrR5ET2dcj7lkFWPQfe/oRK3Z840wSNpl7MP2VEftHApHTmUcwZoR+8QW
         ZxJqgpQtV3vFzWSHmZKlCAFj6EOjevr/BhjT30X43ihORo7Vyg4TLw+UDCdpzvsjP4c9
         MB3kWm1TwRUciksvioeSw4uiraeN91FN5bwyWvW3NMOkNTWFVskyCUELBhbmSEs7ZQpy
         7lb+KGXxISseudbQ2iryH5a4cdgHQfs5S75pLHAfM8G0sTeoK5tjGIT7V/VftSvPTwWl
         62t3gKMcLSQ4n3qcQoGJbATYC+V9VzEnjXcgUevhobNrgT0s15iuZCLrayxd/qLL9J/U
         rQnQ==
X-Forwarded-Encrypted: i=1; AKwUvBwdZW1je5oSkDOy4Sx0kMkLzfwq5uD4/xBGJmRu5za3gEZpfA/N3ybvqap152bTI7i4zABnLqZqlrWo@vger.kernel.org
X-Gm-Message-State: AFq9FYK9tg3KCjgKZ3IfYaZrg6tDupvyU5bp2KlVpxhJZUGN8VgJl5Te
	17zwdyyFf60G7wexfhiN7FcyCMXfgeTwZzC6nJMPe9GDdUMsqj/GW6ghh0h8OZLOO1A=
X-Gm-Gg: AYBFou0tXHU5A3I4dk8tn+4Q2sSZHIipzdKNsMWePs1MyRee2S+cFNqCWRmUfUYIXX8
	e/BSDU056/rflxb7OzjMGxh9//0x1fSrTMxi8hIOpSwNDm7bIDPhhqrxjUKpWDvga11WqV1B+i5
	gSJKneqwxuJO8XvnRAoceDGZsOwJuPAkFx/m2Qud3XBu+BDumBE0Gi5Z8aXKsOaM3T6KKcDEyjc
	u3PzQOaFFdoP8A37vPelLVicOs+er6IAm3HZf52FPAErPUFPbxKGe+C0nPPWU08DiGsjrmlb1TA
	tEsEv+kHiYdo65U/B8xzFW2Kc36mXOidviI8cGkebjtSE/y7c3N+Lmtb8QIykLy7LH8T7XN7C0M
	Y4OtoeHXQEHA/mLavKear765Ec9yAqTeBh3tAYZcMmgzbZb3313aIThfnAu07HlCZsZhMJWQ1qT
	oMmz6x8efX+BgUUUoNgvz2wP8w2o1BtZLBiUqI7348idHegfXV0n3DehU5uYIUjOCpH3efYGd+9
	dOMRlE960H2MDuYU+HeJo1fYH3G6m2TffPeOiJwo8DztFPjBRlnjisBedYdRhU2oXwrrhesw+60
	fIoKo+qfoMd01OnBmfA=
X-Received: by 2002:a05:6122:a5c2:10b0:5c9:fe51:53d5 with SMTP id 71dfb90a1353d-5e91f242088mr18051e0c.1.1791499040144;
        Thu, 08 Oct 2026 15:37:20 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab8c40sm393284e0c.3.2026.10.08.15.37.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 15:37:19 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] scsi: target: rd: Fix oversized sg table array allocation
Date: Thu,  8 Oct 2026 18:37:09 -0400
Message-ID: <20261008223712.49827-2-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008223712.49827-1-sanan.hasanou@gmail.com>
References: <20261008223712.49827-1-sanan.hasanou@gmail.com>
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

