Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F2F20B203;
	Thu,  7 Nov 2024 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979398; cv=none; b=OfCoM14muA98k50RQ80CIOz8/kKObsV+kCCeV4mGo66RBw9ctUJ6+agTmLcep4zhMRzJN+Kx9PV9CDauHT3X1mm4paVugeGyo3BW/aKqIJQddD7GXZVVTj9zcmBMy1AfKGlyMVtSJghInSCr8cN85Ow8/0tcQHdNKLdQ54dtyMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979398; c=relaxed/simple;
	bh=CH9/StpZNFG7diJjUclrLq77fIQV4JcsqmIb9ctfqzc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=rFsSIkI88wfb9dCrY+dRWzLuGaZmq4bAhBaq4j521c25IxBmPcK2U6fj2Xc1vsbI6ywyVcN1LaVusmdPx+lDC9Wfhwdu9IfUkYhZiva9J0rExuFmG+BUzhp4t03PpCjfT6YWNm9zsMB/NLxTbqLtgmcDnKsaxllX3cKN0qhTS14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Svxb2kEu; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Svxb2kEu"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-71e953f4e7cso600730b3a.3;
        Thu, 07 Nov 2024 03:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730979396; x=1731584196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g/dHPzNyDc2NVhT2Ee5/qj52DYW2lrGGJfwE7Y0Tb8o=;
        b=Svxb2kEuBsixhTUk7xwrnvOzREnLK5EeAI8XfO2JxaXn031N4ReEqEOg10IYjidm7a
         YSg11IFj8ozgJfSA6IoT3fmnhfhBGsLvtIQa9kPTOSn4d9Ljr8/wJtWeNyiBpG5lF/Yo
         5mKwHDQj6UQZq24bAukwJOHeA2zmeyQLQwJIvA/Qmdu+K2c4y8AgY/6TmoEW92gpCJrq
         HYWdCh13aIyCxb4dLqfsHGTpB5tB6L25xFfEwzIpwyMH7oK63u1VvTqXFDx5Qv+ptVMs
         Aylm+XmX2ZmYD8AsZDmMdBNjy9iGg6oy3oKGlAfeiSJLqsNH14WkBqcPJ5z1f9r3Hkzv
         GoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730979396; x=1731584196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g/dHPzNyDc2NVhT2Ee5/qj52DYW2lrGGJfwE7Y0Tb8o=;
        b=ueHsmB5bWp6lLbvrLedPz1bhYbvPshJrkmKoDozfg77+ArU91EM0AMqy4xXiuPdQIT
         l4bBcVzrDspFTKaB7nkk1buJod4Cd6vQ0xnibLjaxnsuuHBmFxDDHqUf0VBTNSEl+PFk
         axzyFi9gf6kq+mD1AY3IfgKuV/7pD8djTrwp5UMYYNDBLl6ukF+ro9tmcnwPibpSItKE
         kstw+lfuw9DmXGbcemh9axgTCkNBCVawrsIIK4EzaouKwkvTpSDWuo6O4Us3FYUnCdO2
         W2iOJlwXW06EndOWawEirBZe0wG1i6BZvhNOVFB8zlF9gYAQw0y05G8CxeLz+hfXQWK2
         tIZA==
X-Forwarded-Encrypted: i=1; AJvYcCU8g9wGmP6pLZGK2XjpbzR+d0MJSixOpkRnjhImWpOTkktfaN7Mr8D+AbrgA7UfyUW7Gu/mjIFG@vger.kernel.org, AJvYcCXqzyt9C6GB0aM56VKjz4RgSadujgmx3Ve9HvidlEMLqHXwh+gfytuiiQjY1tnWJ83lBaNqRiHdrdUBC0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5YYq4dnhDwCLMXfzxPVo47AaRszK1eoCmvkLfjtTdp4q/h5vQ
	q+I5zMjS+dUtf0hrXEI6TeFMKdnFh9i1yDUB0/VVgxd+/h4BtJTX
X-Google-Smtp-Source: AGHT+IFa2Wu97Lm75h658e6+rqtkORVJfrOpgQg5JYbUu/snDirRgqMf3mfBvsxHmTWk9BbsNmxLOw==
X-Received: by 2002:a05:6a20:d805:b0:1d9:1ceb:a4de with SMTP id adf61e73a8af0-1dba533098bmr30895498637.27.1730979395827;
        Thu, 07 Nov 2024 03:36:35 -0800 (PST)
Received: from tom-QiTianM540-A739.. ([106.39.42.118])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72407a5ea27sm1266383b3a.177.2024.11.07.03.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 03:36:35 -0800 (PST)
From: Qiu-ji Chen <chenqiuji666@gmail.com>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] esas2r: fix possible buffer overflow caused by bad DMA value in esas2r_process_vda_ioctl()
Date: Thu,  7 Nov 2024 19:36:17 +0800
Message-Id: <20241107113617.402343-1-chenqiuji666@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In line 1854 of the file esas2r_ioctl.c, the function 
esas2r_process_vda_ioctl() is called with the parameter vi being assigned 
the value of a->vda_buffer. On line 1892, a->vda_buffer is stored in DMA 
memory with the statement 
a->vda_buffer = dma_alloc_coherent(&a->pcid->dev, ..., indicating that the 
parameter vi passed to the function is also stored in DMA memory. This 
suggests that the parameter vi could be altered at any time by malicious 
hardware. If vi’s value is changed after the first conditional check 
if (vi->function >= vercnt), it is likely that an array out-of-bounds 
access could occur in the subsequent check 
if (vi->version > esas2r_vdaioctl_versions[vi_function]), leading to 
serious issues.

To fix this issue, we will store the value of vi->function in a local 
variable to ensure that the subsequent checks remain valid.

Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
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

