Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03318C932
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731538633; cv=none; b=XYdndLOBKUFkXN976emDC0RHFdTxUK0jaUraXb7COK03s6f9WKbPfWJGzHvpvVI+aomwH7u5eheZWA2bZ33T9nQUm00PQCFX5qmvBVxkAtAlc1hhzs1BH6VxTdSEeoJnvy8UkQcEoGcALNclwnTZ6fvodX72Cf4CyJ6gmeUnP6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731538633; c=relaxed/simple;
	bh=Qbbiql31Y+SbAT9SRfVv2pt21w87yo3p4rdeKwptQmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nYtPa0jrWkw4HA99JN+/x7/WskM7uDRg3GXHP+sB14o5zBunPrRYAKPUmnhcfhvEnYIxmW52HPuHdkbutS64jqMHPXIGtODaODekqR5fBRx2zYXB8qnElYdE4g+h/Wgy1MM8ZwOg6V3JWpF+Kn+TAoBkMuC3woOgqFoLnwL7Eek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPPkLw/m; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPPkLw/m"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53da4ff4d7fso163989e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2024 14:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731538630; x=1732143430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EHT2AYJCUPZb/nes6FmWW0M4iSiWmMgxlx9jAFC1WdM=;
        b=UPPkLw/mOPMbigXhfQsgYvsNYwyq17lU7EAU6twlltrIMS07jD8BZx9JDCkI0wEPua
         y/gmT6G792lN0SCl5B2dZS16mgbs1PqW/HLWNN4mHWkqlIatqIhdKBlQbBw7g0t/zBzB
         uX6ASPLU/mRW20V0r1sJZpq3cY53kVkNGHKilgEPVaDbSEblmMSZKGBVWmkuaVGgfybf
         PxNnaKa8rJcsajQmbmFijH97DyMmu06RKlGz7tHhuVKCq3OlByrq4KNw4kfmBTz2Hdme
         ZH9UN3zD7fFTxhPaMCJrqRLZmL9FjwtVyjvzIvhmKMoAlKEuZUSzXl+HZiRk2+fGdxzt
         L82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731538630; x=1732143430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHT2AYJCUPZb/nes6FmWW0M4iSiWmMgxlx9jAFC1WdM=;
        b=FO7hiFCSd2bbPbkP/h4f4viOImJmgqqTL0jFUbHl3t4QDtGjZx8u+IFZLm+bfVhz99
         ZphtBovxoJGKCGP+VtASYYao8pjhV7DrsWQkojAu8yrgfkj30ND4i4/sER9rbYnqGah7
         I0uRilKA5VZ7SWF37Q13mwD+KrfLWhrFXKKLYPd/GX4zzPeU0QZ64sBHTMk9MfK5S2t3
         kCfrS+m24wBvyMuN/AK5zLByNFUR5v8NnefZZy4OxN9fOr8I1phB4DnF9hHxTIrWB6PV
         C/HMSWsCnZKVkRC6lKb8y41JipqwoGft8SiP9BToyI1WBBYbSyCZbaNURBF+rEacB5oc
         GnkQ==
X-Gm-Message-State: AOJu0YxvZEulhiIlBdcoKZeAEbDqRQA5qLWZfDcoZq8H5FpMaXM5ao/T
	xZIwV+T+igvWSOkFBQDI/1xWyJQLfolKSfoNwuz0VNeD9BPOrfDG2uh1X2KG
X-Google-Smtp-Source: AGHT+IEiC4bhEjSOi/uhrDpl1XYbOJK5gFQ1QdbA/IJ3lJ8Q1TbYEUT6R2WM4sDsZ7Ls8/pLPpc4bw==
X-Received: by 2002:a05:6512:b01:b0:53b:1fd1:df4e with SMTP id 2adb3069b0e04-53da47bd26fmr339480e87.19.1731538629610;
        Wed, 13 Nov 2024 14:57:09 -0800 (PST)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53d826a9c42sm2329321e87.215.2024.11.13.14.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 14:57:08 -0800 (PST)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	hch@infradead.org,
	martin.petersen@oracle.com
Cc: linmag7@gmail.com
Subject: [PATCH v2] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Wed, 13 Nov 2024 23:51:49 +0100
Message-ID: <20241113225636.2276-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the hardware revision numbering for Qlogic ISP1020/1040 boards.
HWMASK suggest that the revision number only needs four bits, this is
consistent with how NetBSD does things in their ISP driver. verified on
a IPS1040B which is seen as rev 5 not as BIT_4.

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

