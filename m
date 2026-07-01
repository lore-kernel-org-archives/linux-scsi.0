Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6B837DAAD
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782928341; cv=none; b=tILsCMMdmeS3OOwc2wNYCcMd1N1DIQrspcr9ESvSk77LG38wO/6RXjrbGRdknLk0XIvqKsL3WePOLhHSRIBaUfRgceb0dOIkmE9nvHoI53agkGeS2vPdYImJuEuPAFrx/4OXvevTOsf6my7UCfnnGvbHfJMj1Qf0pxMgXGY3Kq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782928341; c=relaxed/simple;
	bh=7kOXFPaAdPhx1Hpa4JOCw3FAkmd6IMhexw2XDa6LJu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f86yXhMrunahtpZ6xcqciZ4g2tKez74bqkquT6dBAi8i/7v2i8+OIvPAtUT7VGwP628lO9nO6D2xLXSawCHMkDbjuSH1EyThaz/gzYJcxZzCLkI5WkS9TVtUJJz4B6dfo7uWo+WA+QueaHibronNUZskkbwbHM82UhHIi1VHAsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFFb8ThG; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFFb8ThG"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c96d2bebca3so425065a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 10:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782928339; x=1783533139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xHvBh2uVHpZT329He2kyX45xyPSNwiWA2SzGOyBHv5I=;
        b=bFFb8ThG6U78QM6PXggTQJ3pItglWYFgNjMmDbfSBunqF/iaLE+s1vHY0ZhIiGEB/V
         kRSj/L95dodahgC5oqfe+Yotn7D+Cp1nzRtfkLrhWGF770FH0K1y+bXsGkuugQC2D0pQ
         DBJPhUWP8uuLPqWQfWZq4GCbUf8JWoPBDg3cVGXHogNbB2UYD1gFaIy/w1UwyEP860Nz
         RF+JaRaGp+yOADrm40w/d/0OaqCgsYVYBEQMzEteP55eGx7NCw9M4N7cCjNJ4QGOLoQs
         WGuaEwlXkbbTt69QOe/EYeFnbuCwUtbJpzv/C2BpLbWtQc1vf9Vazae4XrL1ZAfKYAz4
         hRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782928339; x=1783533139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHvBh2uVHpZT329He2kyX45xyPSNwiWA2SzGOyBHv5I=;
        b=nWhkFFFCY3prJr5/sp4ZrZlNx1xJMSYFfOe4zZjva4Ra4R0gbzAHTuFwVOZqZ5M4Qi
         vkcyIyoMOrkDT0KNrwqXhxflN/K+uMxa8UNlUfSaZFJ9hz+UI+vg3CEBNuqd1sCM4Cf/
         V4ZAmrIyPDk7LWJYV0UZfZE6Tuavf16YAV7D39EUl8txhxSHXcokgfc7TnrefbA+O1YL
         SL24bedNtVMMkc026Dt2nbabmai88IhOomzij6P6s9+tI3CTWgErD5egageV6Un/cO7Q
         uJIdUzbNdvgd623nVCn/0A3dGKgHqHDCJMezmWu6CK5TJR5nhrUDHzMo9irYpOQzLCnh
         OkfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Bnd75JM5hyYkIlVLg8kjI+U0clGhEAFQPhVQCK7ZrzPoGrPPHOZhm8WAderoWjBMMFspC8yu0hdp4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx82O82qYpQyjIfpq4qZq9cBWNYkkVwl2juopzb2pAaAzvwkUI7
	Ev5qQH23p/CCJQG+DdS3z/u+c82vFXF0HnOP533fD4OII4nv6LKBovjP4oCRxEizcw==
X-Gm-Gg: AfdE7clDbaN4pOls6obTwDE7zYVgHeOHYPGG5IbFaKeEoGMH/WpLMlx4xzmKebvZy7C
	RfWEXfnFFLZ8F8WKF04JX6tQ/faZaRfzYacDGAyA836p4kEW53qpAP+c4vP4xF/IhhJ3UBS3nyV
	YJYfEiM9Cad12IxeMRL75+kJBM5mXpjVjls15+Bali4/trS/q84vTeMmK9m9oOAB8ga6vue1AGv
	eTj8iI0/Ib9IjbY9/slOO68EVmx47XZb1/435J/W1fYbIbEVC+AuVbhpnbXVG4ke+HU2Z0pZDQT
	oWbptiNnYzfMQi1vmhc9wyVHdzlwTQxP1H0ltjVdPI/1pvN1qc6QojX0lQp9H0Bo/M0m4ZQ07UO
	RWyhIZAGLVp9ax424/OPf0LYbK2QnyBkijb0XSW9shV1UWePQP0GZ5vAw4r+z69KmYIoze4Je6o
	Vzsv8W
X-Received: by 2002:a05:6a20:938b:b0:3bd:3a53:c147 with SMTP id adf61e73a8af0-3bfed51d83dmr2947873637.45.1782928339527;
        Wed, 01 Jul 2026 10:52:19 -0700 (PDT)
Received: from devubuntu.. ([2402:e280:3e9d:20a:ff04:9039:171a:2c52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fe46sm57058eec.14.2026.07.01.10.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:52:17 -0700 (PDT)
From: Animesh Rai <animeshrai853@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Animesh Rai <animeshrai853@gmail.com>
Subject: [PATCH] scsi: ufs: ufshcd: use str_enabled_disabled() for Write Booster messages
Date: Wed,  1 Jul 2026 23:21:52 +0530
Message-ID: <20260701175152.7446-1-animeshrai853@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace open-coded ternary expressions of the form
  enable ? "enabled" : "disabled"
with the str_enabled_disabled() helper from <linux/string_choices.h>.

This reduces code duplication and allows the linker to deduplicate the
constant strings across the kernel image.

Signed-off-by: Animesh Rai <animeshrai853@gmail.com>
---
 drivers/ufs/core/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..e9cbed514a5c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -26,6 +26,7 @@
 #include <linux/sched/clock.h>
 #include <linux/sizes.h>
 #include <linux/iopoll.h>
+#include <linux/string_choices.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_driver.h>
@@ -6339,7 +6340,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 
 	hba->dev_info.wb_enabled = enable;
 	dev_dbg(hba->dev, "%s: Write Booster %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 
 	return ret;
 }
@@ -6357,7 +6358,7 @@ static void ufshcd_wb_toggle_buf_flush_during_h8(struct ufs_hba *hba,
 		return;
 	}
 	dev_dbg(hba->dev, "%s: WB-Buf Flush during H8 %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 }
 
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
@@ -6377,7 +6378,7 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 
 	hba->dev_info.wb_buf_flush_enabled = enable;
 	dev_dbg(hba->dev, "%s: WB-Buf Flush %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 
 	return ret;
 }
-- 
2.43.0

