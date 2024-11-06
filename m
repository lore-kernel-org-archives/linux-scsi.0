Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F3645
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730933709; cv=none; b=hGeuTgmbxUaQe85WSeN5467laeMQMDEHmbve8vy+xIxiI9hwEZJYO2v01/jkPC3JQ2eTm/NgNfs52ktqW6EbWv9tbW9saMlbEYWwm5D5cj7Pcs7ngAggxMPM0IVMgFW3ElQIN3IK5PO4UXr8D+FXULZ13fUlEIljw/rWa0OwhWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730933709; c=relaxed/simple;
	bh=byln8NuRpa8HH18XhgOfSEmQy5Pxvmmv5bI7s1fyopA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CpZYEWc7Cn3rqr447k4ULXwL9Jpdr26UBpq7xldOfozsoGQeja/ujfS9zjwi7qTkYXXt4Odir1sSm8gatredi9ZhkANQ0UtKolNuOSteHvotjTfVWiFmdrsJpqEb4BWPr/ABqQQjykuzZ5vHvbr461hcd4b+1eIiBCMrh4sZCM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f66ILdMi; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f66ILdMi"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e13375d3so259204e87.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 14:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730933705; x=1731538505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R1cuA3Xb89yaJaPzCeZqODF7LPEeITxe8U51qkdDk2E=;
        b=f66ILdMi1Z887tdkyvHDrHoEkjyYGX41x0ikZrkC8SpvMrOr8w3FrBe4nCGdO4cQyA
         XNE0M85yDJFlHi9d224BJEUsnSa3pEbieKLtg0V6OuKV8sOItLgM/TNOSMwtVNNlj5/I
         2p9ZV2GbEjjBAMHjIu/yGyIW/8Nk18qKnX+9yTs6SAacVCp4zIzUcAn1zYtxN0P/Uucj
         l8Zq2p9YRBj2d4oXJVXwodVFa4ts1hf4RsPp+naShzoo/Qzjx/BG9QQqc+beQ9XZ0Qe2
         UO23M/NGv8Q37iIOMenvmg4B0rGgLlHuqYsvaSWpM7+08vnh3EKhmVlVvPl5HHP2tbP8
         +nXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730933705; x=1731538505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1cuA3Xb89yaJaPzCeZqODF7LPEeITxe8U51qkdDk2E=;
        b=Xoz4XRbFMDRTNo1HNXTlv30W+ZDaE36DpLM8EfZU3X/Go5GxEq6yVHLxHMJvOAneHa
         Va3jhSbyL8L7bjz4wV720NNm0tELXKdqLHpKfThTaM6IMzOlU93wnwzWEtNy0nH0ioRs
         aH8Ch7ArQlgaCGdtuB+JKxC9v5BpzYZcYHhVEemhDD84JDm7pbEBOklqEs0sFeqc2UfG
         LQD7BQ4cZsLsZNl8j91pUtGXGHt8dJutZmfSHvodj+UKDGaE0ujZeYIHRCQi5b+r+dJG
         iQ75VWsA1lB3hpwT5ir565Il2d+tyHnzkZeNUYhYoJVDCgp049adMUmsYo+ll5rm8bcQ
         SJZg==
X-Gm-Message-State: AOJu0Yw4QTtX7vjXO9sfXn09j99yWYWXfx5aFGPHR4uq9kPRRsvwq6IO
	t6OVZKR4vF15/29yM0Rz+X0K9MfJy+DTgQw+vuxcN76Xxxwm/lJKhVufF2Km
X-Google-Smtp-Source: AGHT+IFX6xKMsvukGXowMvsXszChHffFRR068pp/1rmX2xajOUdQsviyP+o7bPFUPreg4Gq7qGCcVw==
X-Received: by 2002:a05:6512:10c9:b0:539:f619:b458 with SMTP id 2adb3069b0e04-53c79e3253fmr12557293e87.22.1730933704996;
        Wed, 06 Nov 2024 14:55:04 -0800 (PST)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53d82688c36sm15081e87.107.2024.11.06.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:55:04 -0800 (PST)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com,
	hch@infradead.org
Cc: linmag7@gmail.com
Subject: [PATCH] scsi: qla1280.h
Date: Wed,  6 Nov 2024 23:49:57 +0100
Message-ID: <20241106225455.2736-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 Fix hardware revision numbering for ISP1020/1040. HWMASK
 suggest that the revision number only needs four bits, this is consistent
 with how NetBSD does things in their ISP driver. verified on a IPS1040B which
 is seen as rev 5 not BIT_4. ISP_CFG0_1040A is referenced on line 2187 in qla1280.c
 

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index d309e2ca14de..796cb493a4df 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -116,12 +116,12 @@ struct device_reg {
 	uint16_t id_h;		/* ID high */
 	uint16_t cfg_0;		/* Configuration 0 */
 #define ISP_CFG0_HWMSK   0x000f	/* Hardware revision mask */
-#define ISP_CFG0_1020    BIT_0	/* ISP1020 */
-#define ISP_CFG0_1020A	 BIT_1	/* ISP1020A */
-#define ISP_CFG0_1040	 BIT_2	/* ISP1040 */
-#define ISP_CFG0_1040A	 BIT_3	/* ISP1040A */
-#define ISP_CFG0_1040B	 BIT_4	/* ISP1040B */
-#define ISP_CFG0_1040C	 BIT_5	/* ISP1040C */
+#define ISP_CFG0_1020    1	/* ISP1020 */
+#define ISP_CFG0_1020A	 2	/* ISP1020A */
+#define ISP_CFG0_1040	 3	/* ISP1040 */
+#define ISP_CFG0_1040A	 4	/* ISP1040A */
+#define ISP_CFG0_1040B	 5	/* ISP1040B */
+#define ISP_CFG0_1040C	 6	/* ISP1040C */
 	uint16_t cfg_1;		/* Configuration 1 */
 #define ISP_CFG1_F128    BIT_6  /* 128-byte FIFO threshold */
 #define ISP_CFG1_F64     BIT_4|BIT_5 /* 128-byte FIFO threshold */
-- 
2.47.0

