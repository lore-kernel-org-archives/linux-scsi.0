Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C916D9D7;
	Wed, 12 Jun 2024 09:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718184697; cv=none; b=C1RbyYBddrsyZ56jn+wHNVsHscOWERuiD/rwoqicjiW8Fxg6ktMp8T1JhdQjtb80fu5j2sTN3KWGVwa12JS94Xv3XVJqfkX0KSHBf/eHuCBjZ57A1VRMXjIw917tDR7OI4ry8MlKNvXhrU/a9kbQx754Wu8kQpa5JSYQ9tINSmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718184697; c=relaxed/simple;
	bh=WNOzoJUF5Sd3jb54WNIWO7Ok2KUCrQMO20CYYkK0ZGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EW+I/oDa32NfcV45Orerj/3nCn9iRpB+IKWMwVxO6J2737gS2LLz5Mr3NQ2ikEghzo4Xbi+owaNuccyNutJsdD5eC1BuatcFq/n2G5FYCDKsNB4dIDlfl2m5WqdONYls7e+QykdS5per7AKDmP+PXwgkJCCa5gFm+OkXAv0NBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEz6HYS0; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEz6HYS0"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7041e39a5beso3687432b3a.3;
        Wed, 12 Jun 2024 02:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718184696; x=1718789496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7yzsgZOmviXDPRveEaKsBFzgEIXtcAbD/zH2lFEcpTU=;
        b=GEz6HYS0dIlX2CLFXJSOaK+VJz/35/sGYWlPWtR+46lTDPL/p6TqrNDfyp/yC9KUEW
         52Rgjh1aVTygvEDtfRTDdtIMcGeR6cDzL0qYB/UzWwsIlr0jm2detLK988u0QkW3hDth
         Rs+Iwz1/Q/zZERwEiLw5+1K7WdUYKj+rFpBMYkoeCmodFBFhPiT1gG9tm1M5PKfzNla2
         nrMjuRJtfdUdzjDLJzBI0JMMcOqeol3tXmRFc7I6mZURCayS94COwgwMaeAvzS00Scsg
         vz9UovPRCrpxRKfbdFp2NYDWX5hKLOZ8rF/Oe1S6mLHAdBBfw3ClqCiGhHNEJgVOiN5E
         LoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718184696; x=1718789496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7yzsgZOmviXDPRveEaKsBFzgEIXtcAbD/zH2lFEcpTU=;
        b=emKGj5Vdet26fhP3TcNCJyBxBE9tmtUFyX1M7ba8aXmcHszfWiz3PGdFVZ0TYOlDwm
         vt8ZM9cQwepRw4uBPrygpcn0MF71f0UFJIGsCeKRQ73znJ6JnHrKoXaZdLtfxKLvStqQ
         OF+tT+ffnNZ+XjmpHvNmHWS0tTzbrxRtLh0++o2p6oNQ1NfAz3xrD6mhKrdWWK7NPyLZ
         yBJCwufQGMhlq+YZ8pZ5i/ZExJpyPjzoyqBTBAnD6EifI854VC/P90w4lQSCPDkRZzNO
         hI0QfiP9+Npe+V2IcHlhmKxsAxDZzQpopGYgOmp0h/ZO4zVKhN1IiTskGDkrJR9lnj+N
         6KBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEBgkwH2Mfu6gbsmUoJ5Pa8efThXOs2jcNomNkWQ8WR8Vas/QraofBMJvaAd3WuZP8MjKg+6BJMLeKy0W+diyVixmgKQokOunTXYA7
X-Gm-Message-State: AOJu0YzrkmGw1lcCU9PLKHeVeJKzOpGxaYxmI5ogPsa1NafUT0P+KyPu
	Kb+wC39W5AFjtDdOexTK5S/rXSc9ST4IaJcsZouwx5iDdxchHltM
X-Google-Smtp-Source: AGHT+IFcQRCr4rkFrU5kbqsrK+X9/MIFW11p9GdKGUayDLo/CcyYLz7pcnOf9Dy5u/Gs1s15g1BepQ==
X-Received: by 2002:a05:6a00:1886:b0:705:951e:ed88 with SMTP id d2e1a72fcca58-705bceb0393mr1319701b3a.25.1718184695596;
        Wed, 12 Jun 2024 02:31:35 -0700 (PDT)
Received: from lhy-a01-ubuntu22.. ([106.39.42.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70596eed610sm5119140b3a.170.2024.06.12.02.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 02:31:35 -0700 (PDT)
From: Huai-Yuan Liu <qq810974084@gmail.com>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Huai-Yuan Liu <qq810974084@gmail.com>
Subject: [PATCH] [SCSI] esas2r: fix possible buffer overflow caused by bad DMA value in esas2r_process_vda_ioctl()
Date: Wed, 12 Jun 2024 17:31:19 +0800
Message-Id: <20240612093119.296983-1-qq810974084@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The value vi->function is stored in DMA memory, so it can be modified at
any time by malicious hardware. In this case, "if (vi->function >= vercnt)"
can be passed, which may cause buffer overflow and other unexpected 
execution results in the following code.

To address this issue, vi->function should be assigned to a local value,
which replaces the use of vi->function.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
---
 drivers/scsi/esas2r/esas2r_vda.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index 30028e56df63..48af8c05b01d 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -70,16 +70,17 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 	u32 datalen = 0;
 	struct atto_vda_sge *firstsg = NULL;
 	u8 vercnt = (u8)ARRAY_SIZE(esas2r_vdaioctl_versions);
+	u8 vi_function = vi->function;
 
 	vi->status = ATTO_STS_SUCCESS;
 	vi->vda_status = RS_PENDING;
 
-	if (vi->function >= vercnt) {
+	if (vi_function >= vercnt) {
 		vi->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
 
-	if (vi->version > esas2r_vdaioctl_versions[vi->function]) {
+	if (vi->version > esas2r_vdaioctl_versions[vi_function]) {
 		vi->status = ATTO_STS_INV_VERSION;
 		return false;
 	}
@@ -89,14 +90,14 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
-	if (vi->function != VDA_FUNC_SCSI)
+	if (vi_function != VDA_FUNC_SCSI)
 		clear_vda_request(rq);
 
-	rq->vrq->scsi.function = vi->function;
+	rq->vrq->scsi.function = vi_function;
 	rq->interrupt_cb = esas2r_complete_vda_ioctl;
 	rq->interrupt_cx = vi;
 
-	switch (vi->function) {
+	switch (vi_function) {
 	case VDA_FUNC_FLASH:
 
 		if (vi->cmd.flash.sub_func != VDA_FLASH_FREAD
-- 
2.34.1

