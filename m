Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD713B0AE4
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499044; cv=none; b=D1BIxV8sq7niOfjRJQB85hiPFAs/ILSSss+3qbMSvroGveYTB2yMUtJGRJAM8cHYXFF3++bhMNeumWo3Kq9QTfQeu3I1qQY0zcZB8/S1z934/afezuhVWft/2XwEgcmWzJOZD9KORzFRvCTnnhPXCaCUbgfOcox+t+foq9KO0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499044; c=relaxed/simple;
	bh=lJ6AYpHjGOkimMExUHB9UOtA234mEYMud8tyoTmPLRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlXEWWDR3Ilk1T/rkudv0csW+rrYwpgRIov1wIim+CEOFWY9GsexVWPACpumppRSemOP2HqsQ09Zsn7XiyzEvcNdpN+mSPx44XpFv4ez5BjPBltqxDzMaKion+NRuM+E9S6gbkiN8RwiH3j1Rk7f9YmWQdsrLjMYakyooQ1YCZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nmt0FaTo; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nmt0FaTo"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c7d1fc8f9dso76248e0c.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 15:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791499042; x=1792103842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nOpeyuGCRMACRp8m9ibObWPSIPWBOuQMlxgdPx+TYS8=;
        b=Nmt0FaToi/KWZq4wJ6LAgSt5oog2cBkOZ7xFgMILhDfY6pyURVMrYFF3iN55TFlYXR
         yNRtC60uD93YmFuVl+BadJpHyUDO7luvaqtpBcadB6QXaFGjf8yVGtSYZKFKwJX9yMWy
         SEtY6CHcHlbQVHH0ByjXH7XWU9OJNSxJxFrtFmEd3wKeDnXGqRcHtSkynK30qaheHRU0
         fmxtV75GEEN6wZJ12c8DJrN/6DAjXujMc6knKaBEkzjzZyTAOMkO832f2b7TJpVp5Qhm
         oSU42jc9YsfIVCjTmsKPdKGjJ1bPyqjJaLGmF5LhZIhKimQd4VjKfWY+h6xFoU0RZaQR
         3tvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791499042; x=1792103842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nOpeyuGCRMACRp8m9ibObWPSIPWBOuQMlxgdPx+TYS8=;
        b=edNdUW1sLuHH65Nn/Yz7TYHW01bAN+CPMlN4kezc5aLHL3myOtUtir68rSHGYRu8Tc
         tGLSYzyUDbHQdbPsUXcy0+Y/pth98E9vX0e1DqvcSw+/PlmeOpuGYODaEo1OVd0ib4te
         ecYcZM9HGkQI79q3hMHbWlyxFlk/niOILC2UQknqcOahgwNciHxWkvwsRQmayKvEcubX
         AQhut7TYHgyYTDH4+cHwPsHT7Hm6oZJWL8jrMh1RjhBeHmX5pbi4XMcg5oJlch+Exo62
         tOHTy9xhCgYImsOVHd0wgD10pagi9jLYnkwpMIicfji2kh/Ga2rJmRBU5LKDGJcMZuzM
         aChg==
X-Forwarded-Encrypted: i=1; AKwUvBxfG9cH/LhVD+Esi1zgB1H8j6dp331GcxmXjeiu+RYK87M5sSz9GNFsZRxp7WNXx3n6t7yk6PVp/1ea@vger.kernel.org
X-Gm-Message-State: AFq9FYKFquUhn/rrBDvFcBePo12bU1+/5G5cC6mp/mCQ4OWbE3Py7QmM
	zZccQq/Qw1WsLaYCBnweRSWMNAiEkb/b514mOL+9FNOnwOOZTj6B09B5QRocmQ/SCtk=
X-Gm-Gg: AYBFou0F6cnGCNfeWtpCoFvL4JDNGgK2sLSFb63dF91kC00XsHuvEG6QOTbBE24owUI
	RWACVI0MQM4tYvZQNtMnCAPK0HHpVtDv7tvxwpWhP+Jya5rKfgUJYO3bFYDUObTSOZkXqq2Ea83
	ssyyM1daHFgwO1oWC5wYgFeRx/UrZ/Nzv4a3lodkoGS3U904h9cEiLYPHHOIfLzcyTYk9yzCAFi
	PGTfqtt0BNOrK6IlzbzZSLOdsupj3YpJWXbpDr9jmfnOZI57kTq46VBZWv8SSgPHWsOz+MEMBxB
	poORSE8D87EUMIhNtvyaqaLrgYOE4WKePKudybUDtxTcE0Kxa4KDOHzsYr+ngRk1WwK81MaJjjU
	lWzT/E1zpTZAE5T6Kb/eL+tvPUuQlKz7JkY5Ot48JJjysFs4QRDAjwyYNdYi+xBpYQaXGAIPOMD
	tHI9s2Or020QDf+nnnpPLtCVrm0lrKR4CHJQQqEGfYn3FEHtz7bRjemn936VvdldRImC0vlh7Xm
	e7khpxgQGEXaIW+3uvBCaJVg3jC2Y16DZUKpUc+aEzRmyz31efroff73WFFiovizlaoOnrlnmaL
	95Hx3vaSJVrUm3KHsdc=
X-Received: by 2002:a05:6122:14a:b0:5cf:ad27:3a67 with SMTP id 71dfb90a1353d-5e91f58265emr4623e0c.5.1791499042370;
        Thu, 08 Oct 2026 15:37:22 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab8c40sm393284e0c.3.2026.10.08.15.37.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 15:37:21 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 18:37:10 -0400
Message-ID: <20261008223712.49827-3-sanan.hasanou@gmail.com>
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

rd_allocate_sgl_table() allocates the ramdisk's backing memory one page
at a time with GFP_KERNEL. When the requested ramdisk is larger than the
memory that can be freed, these allocations do not fail but invoke the
OOM killer instead. The pages are not charged to any task, so the OOM
killer keeps killing unrelated processes, and may panic the system once
nothing is left to kill, while the configfs write continues allocating.

Use __GFP_RETRY_MAYFAIL so that the allocation fails once reclaim can
make no more progress. rd_allocate_sgl_table() already handles failure
by returning -ENOMEM, and the caller then releases the pages allocated
so far. Add __GFP_NOWARN since the driver logs its own error.

Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 97c63b122..46698300e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+					 __GFP_NOWARN, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.48.1

