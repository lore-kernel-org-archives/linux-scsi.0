Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7D43A257E
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 22:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787177010; cv=none; b=Ovtj/ZZ3BBo/JB3mkCOLRaain5kG+25dBwB32la3wqyZRNTxHZrmpZrJY07b11j9HVWPxIDnWIoNEdIgZjQ2XNABLaLSmklIzjykmOyMYgjx2NCYPfGMEu4uYtb7CGwydHaNEirTpHb2BjYjGbaM54FViM91ww8oPPxRtiD7rYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787177010; c=relaxed/simple;
	bh=D6VaASqwH1nGEidAP/2Rt92bNOLS9oYB2L7E8psNPhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OtBj5etOPqNqQh5Pj4uuc1jtUjCVj6xKqeg0tRk5vqmh+OAQH8rGdlTc09Q+jRsv+DY2GvOfnDRSgFqZPB0XIrvyhN75EdMUORHbteGM7WTQzYo+VQN9iWbt7zGhH06BoMIwK0RodDhb3mBGmgbPzbvKTxN+A6jwqA3VqvjmG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nAOU9R1r; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nAOU9R1r"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5bfaa014978so764005e0c.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 15:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787177006; x=1787781806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HhkyAwn7RmyLaDPVRMZZw5dHSW6ePghk6etlcD4cNrY=;
        b=nAOU9R1rvfmHXHqLZmyqwCsm4Dh2nJpdUjpZ9AvVbL+FdqzTB3xWPEta0r20siYKdh
         wjhv80DxmDG6nGjpgDm7L2wp/vrieRQRHCNhgPmX3VCNh+ISAt33TzWPT9nZngPPBR+U
         K+gfRSA5oNz9FuLZ36nUKeiHxSW0UxmmclN//EcSj+E0z9NT9Um/CZlyfQFL0wcsn3+G
         aKkGaubWOahiG26I8HP5WpZb4nLzROeImMLrLTj3jfm83ua56n8YweS0Wo8x3AfeYjbM
         89YRBT4/oZypbOGZ444rCf/nex6GDNvxb6ahAC4zbFpTfiA+WXl5/F3Pk5ilkorqUu5D
         Ssrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787177006; x=1787781806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HhkyAwn7RmyLaDPVRMZZw5dHSW6ePghk6etlcD4cNrY=;
        b=Yd1SSGQnslerBhuYAD26UMydnVCXJNiAkVIRXNSFckRqDtE+LKHasP/a6t5q2hOx4D
         Fw6pL1qMLn1zrdJBZWVrSeTHy+izOx7ZrTGwnHMSy1swL6UBeRFvbiT2jwMWBkp9oTKw
         GkHELml+3XKpEcIeyXM3wtfARBoFgd88hMoB0I7yrcTvAh7Tk7hWpqx6duZotM7LCUVN
         UaEesgtCihf3bVe8uXnh+hyJfPcJbBpJ28aoQ3l2f0VF8Zo3XzAXYZnS2GsZFxmebTPD
         YCYy4KBE9HEkZ1ZbiDwZc6ldUoqmTT4SqzGjVgzxBGDXGTi4MBVSJ5Z8C0hRMOxteLj/
         wHXw==
X-Forwarded-Encrypted: i=1; AHgh+Rryk4jdZLK+m87KzLoKYeyUfFKMraqbezfzEPK+MtEmW2bTsftfrJC3Ed8faNYoZxW9KiJsGWbWiGlP@vger.kernel.org
X-Gm-Message-State: AOJu0YxjPAq5nIwJ1YAa7V44uQE9u1hqwaY1rCCrRVrhHzdF0ujz95XR
	0FPaNL7pVeTR0sIVBRTxqPL4/4XVhFSEW1VZY+ifQd2LFT4ZT95DjPaJ
X-Gm-Gg: AR+sD12Tb06orJEn0SGRCjYVtK383ky6oKCPk3wrh4dttJsfwjTIMt4EMi/FJM2pLVy
	myvIJq8ZqL90ttjFqNCqqKFoNHknqFMOC6AnEImexs/F4V7grAdtLW3zf70mY/Yk3cUBHHpvJ5Q
	kl3oT2wy+c8KgTLwqObftTh42cjLdWJiFgV4y91oAFLrqO8Jo/wheGBmvdHGlR4elkii4BvhNji
	jyMpyHw3PagzsC18XmHrR0pBH+uE3LQvafsH5JltZSxWsyeyawrzs2FrPTB6yl0EtVp0e/hbUeo
	Yl4h7Mhy3MGr3Wc8pahiZEOo+Z8IIHXmVMhqUHmng2NCKLtno/BU701GfSwtk/mvC9nS9MSsmx3
	HgLYq9U+z82TWaQW6lTOeTHlncjrZPU70nDEdMi046PN0VybUdOt5ohxSN4sNZCJuIbZeMd/rcu
	vxZNDgVZpHVbAeZmDmN2TfPYGIhwq5NE9EPaFj28uLyG8jB5DtePRM1uZjaFZPU1uy++l1zij+K
	eF7q3MCZtEiiZflpXPqX7wjK3ZeRlfNL1ePPw09L1M=
X-Received: by 2002:a05:6122:4694:b0:5c0:fb8d:9993 with SMTP id 71dfb90a1353d-5c5e2ea3024mr2521414e0c.0.1787177005379;
        Wed, 19 Aug 2026 15:03:25 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:4c64:82a2:3443:53b2:2e07:b3bf])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c5e2617f06sm3698401e0c.6.2026.08.19.15.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 15:03:24 -0700 (PDT)
From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: ~lkcamp/patches@lists.sr.ht,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: fix inverted sscanf() check in csio_store_dbg_level
Date: Wed, 19 Aug 2026 18:58:57 -0300
Message-ID: <20260819220318.176167-1-rodrigo.gobbi.7@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

csio_store_dbg_level() has an inverted return check on sscanf():
the existing check treats a truthy return as an error, so every
valid write to the "dbg_level" sysfs attribute was rejected with
-EINVAL. This has been broken since the driver was first added.

checkpatch also flags this same line for a related issue:

WARNING: unchecked sscanf return value
WARNING: Prefer kstrto<type> to single variable sscanf

Replace the sscanf()/isdigit() combo with kstrtou32(buf, 16, ...),
so this class of inversion bug can't happen again. It also validates
the whole string instead of stopping at the first non-digit. This makes
the isdigit() pre-check redundant, so it's removed along with the now
unused <linux/ctype.h> include.

Base 16 is used instead of base 0 (which would only recognize hex
with an explicit "0x" prefix) to match csio_show_dbg_level(),
which always prints the value as bare hex via "%x". This keeps
read and write symmetric: writing back what was just read always
restores the same value.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
---
Hi all,

While looking at this file I noticed checkpatch flags
csio_store_dbg_level() with:

WARNING: unchecked sscanf return value
WARNING: Prefer kstrto<type> to single variable sscanf

Digging into it, the sscanf() check is actually inverted, so
csio_store_dbg_level() has been rejecting every valid write since the
driver was added. This patch fixes that with kstrtou32(), using base
16 (instead of 0) so that copy-pasting the value printed by
csio_show_dbg_level() (which is always printed as bare hex) back into
the store function round-trips correctly.

While tracing this I also noticed that log_level doesn't seem to be
read anywhere else in the driver to gate any behaviour -- I couldn't
find a consumer for it. I'm not proposing to remove the dbg_level
sysfs attribute as part of this fix, just flagging it in case it's
dead code worth a separate cleanup, if the maintainers agree.

I wasn't able to test this patch, only compile it.
Thanks and regards.
---
 drivers/scsi/csiostor/csio_scsi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index b1de615cf316..d64b47ee1bbe 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -34,7 +34,6 @@
 
 #include <linux/device.h>
 #include <linux/delay.h>
-#include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -1441,12 +1440,11 @@ csio_store_dbg_level(struct device *dev,
 	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	uint32_t dbg_level = 0;
+	int ret;
 
-	if (!isdigit(buf[0]))
-		return -EINVAL;
-
-	if (sscanf(buf, "%i", &dbg_level))
-		return -EINVAL;
+	ret = kstrtou32(buf, 16, &dbg_level);
+	if (ret)
+		return ret;
 
 	ln->params.log_level = dbg_level;
 	hw->params.log_level = dbg_level;
-- 
2.48.1

