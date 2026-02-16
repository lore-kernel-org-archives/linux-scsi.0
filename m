Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968F48F48
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 20:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771273871; cv=none; b=o8FQOa4yK+ybTtbM978ZfAvUS48tNa2Ie3Ixl1+I7a8fuwwk9vxtyYpb515Q8zJnhHSJWU93+6SnjkLZZxlJ+38+9dVG12wf61APGmsFAsftSqKg6M0hq/wKU7rcMqS9u5eFvTGF3UuUZg/T0F/meo8hau+WGHgUuvo1D/mEY1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771273871; c=relaxed/simple;
	bh=nW1kcY+TgJdL+e/kVHTD86xB9DuQqwF/pa2u8gzwvpo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DSJR4EQTgMAup+iIuUlwz2g1xEUjEmZZ3dTBZR4TO9f1DEZfbUeY+8cEoVrzTQK+BL7StWJskW1Zjx65zYAzjm09BCzX+OMseOrKb8E8OPF1CttTr9RKRo/vM5FcEKjPpJ9C36IWF50TR/AgIN1pDTEqLzfQK62bLFNi4NhgP50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GU4vFCwq; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GU4vFCwq"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d195166b2cso2349887a34.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 12:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771273869; x=1771878669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pvIiweXEOPmG0CyDttbFAF8NZzA7a2gxvmfbKv0pvxQ=;
        b=GU4vFCwqekeu4g03NytUrBVRlu6IQ36yNbr3ixEgt7FbxwQpxvRQN0SvRTIFFdFK42
         Pkz4+TykvODO07LxNdusgOqkax+QUCYO2vYzfOQwOa7T2mDChJaY9kNtf6nw7ZohSMnr
         rrfyicmd11LbUtSA4ftsbAVdDBYBHQBtWV2dktJGr8kxUCybDwTzXEbKg+IxpUXPAn7x
         KR5+yklrJclHDZr0czr22/VE0gLi7psh+hxX3Xi9FQv+nFE7KxQVNzC9j8n0ulwWc85/
         2aR/RNdmITLxpYg+5k7JZe5onB5kVhYnz8ntCij5ENve+jrMtPrMH+6ovTJK/yU2TyYy
         vXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771273869; x=1771878669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvIiweXEOPmG0CyDttbFAF8NZzA7a2gxvmfbKv0pvxQ=;
        b=RVii54xT7NqNBcvQqh0SsSE2oKzMZoWtRiR74wxd1qjMuXsIewt3/oeqQTBsYcbT4G
         dYtUvX3uDfErx9jag3WTwFeJvT3YJbqNMYdt36vwHbo9nIhzwhGWoZD7ihJQnsK8HTvT
         dyWW3fewcQDvZNAKBJioPuiXUNtcDJoo9ImP0gb5Fkr2rdrwKFouQ0yCBRGX2rkePIRs
         N6PhCSnJcy1ajsJk3kyCBnltLvfZGzKYazQrNrZ3JYRgK/UsERGzWXoLNnBAT0XdaxYK
         WGlb/tUS9CLMsYEJrhaROfFhm/vYXLgp3EU7kP5ClYt+yZBqICvanRN9Z5Yck1xO2jwM
         BoGA==
X-Forwarded-Encrypted: i=1; AJvYcCVomyBDeCQxwZBpBm8ImlQfjpfN5KtbxXfzSYsniW6uqctoKSUY2/RrYkjQGAuEmTTXgpWIOZNiww/L@vger.kernel.org
X-Gm-Message-State: AOJu0YyMN1ePhv6A8IaMfpg2ap5e+HVOUrF/zgNzoFLksMSh0MzlXaOz
	ufKEh/YB/yYpijRs2OO8it4ROLDP0XYQJi5tFYUzDeDR0zqK2nU/7Rc4
X-Gm-Gg: AZuq6aI9R20MbMO+R7KREjG8WMSZJPsggQcSSqF8/nk0geK/Ldj5O5ZNo+6dljHX3Zi
	givFS12gEa26Z3cbgxocW+oDJo8yjIHoblgAwlCUQyH3S4pIJXLgb6rv3bHY8YkDJnItP56uY+H
	ntFe34+hYZsdyL5V9PMXHsPuf8j4v8EYdLopIbp7IBf7DViBlEbVdpFfO9ZPdQVaRW6OYF38ZGL
	xh0+UauqThyGDUw/kT+5wBfd8ERNSriArAILBbNe4CB2bZ6qATCVkY+GhHumAbusT5J7NPO1T0c
	ZeEjBgR7cQF3inA0VTvlL+Oc7gWZjmyynRJpHKdLRLaJc2C7OMRrEWvC5n4Vgxw8/tRxQdCBJaE
	++mqYcK0gEq7PnjxbsPgqliw7Y+hd/HAOttznwXuu+IJefQK+jfGirhFUEYNjcEyDokqDZvIw2C
	yES3heLyn34cP/yRWHbiFVGVVXlAAdZniMLRUj4DpHgOAd+9ckBAuMzww=
X-Received: by 2002:a05:6830:6419:b0:7d1:586a:32a2 with SMTP id 46e09a7af769-7d4c2c20cd9mr9645370a34.0.1771273869567;
        Mon, 16 Feb 2026 12:31:09 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a7530a8bsm14343667a34.4.2026.02.16.12.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 12:31:09 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Arun Easi <aeasi@marvell.com>,
	Shyam Sundar <ssundar@marvell.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Fix resource leak and metadata corruption in default_item cleanup
Date: Mon, 16 Feb 2026 20:31:05 +0000
Message-Id: <20260216203105.9056-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qla2xxx driver utilizes a pre-allocated fallback item
(vha->default_item) to handle purex items during low memory (OOM)
conditions. Its lifecycle is managed via an atomic counter (in_use).
However, the cleanup paths for this item exhibit two critical
inconsistencies that lead to resource leaks and potential crashes:

1. In `qla24xx_free_purex_list()`, when the default_item is encountered,
it is removed from the list and skipped via `continue`, but its
`in_use` atomic counter is never decremented. Consequently, once the
default_item is used for the first time, its reference count remains
elevated permanently, rendering the fallback mechanism dead in all
subsequent OOM scenarios.

2. In `qla24xx_free_purex_item()`, the function attempts to reset the
default_item using a blanket `memset()`. This non-atomic operation not
only clobbers the `in_use` counter but also zeroes out essential
metadata pointers, most notably `item->vha`. If this default_item is
subsequently reallocated, any dereference of `item->vha` will result
in a NULL pointer dereference and a kernel panic.

Fix both issues by replacing the destructive `memset()` and the leaky
`continue` path with a unified, safe atomic reset of the `in_use`
counter (`atomic_set(&item->vha->default_item.in_use, 0)`). This
properly relinquishes the item for future allocations while preserving
its structural integrity.

Fixes: 0972252450f9 ("scsi: qla2xxx: Fix crash during module load unload test")
Fixes: 62e9dd177732 ("scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a88b460641f2..a424dc6b093e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3984,8 +3984,10 @@ qla24xx_free_purex_list(struct purex_list *list)
 	spin_lock_irqsave(&list->lock, flags);
 	list_for_each_entry_safe(item, next, &list->head, list) {
 		list_del(&item->list);
-		if (item == &item->vha->default_item)
+		if (item == &item->vha->default_item) {
+			atomic_set(&item->vha->default_item.in_use, 0);
 			continue;
+		}
 		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
@@ -6467,7 +6469,7 @@ void
 qla24xx_free_purex_item(struct purex_item *item)
 {
 	if (item == &item->vha->default_item)
-		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
+		atomic_set(&item->vha->default_item.in_use, 0);
 	else
 		kfree(item);
 }
-- 
2.25.1

