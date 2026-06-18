Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E54A1990A7
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 07:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781769135; cv=none; b=Y5LEdnDVYlb6mYc6F8Gu5ga6o+nVlr0oU+Mn8lB+Oi67fyLDoUDyPGcbG7WN/Yh1RH8Dka6J52NuKlm409K82X9fCk2PeDNelFAgtieqsJ/kwVJoPV0ttiaOxyolAjAXGKG305X+kyXizcd9V3ujkHuL/CfNhkkvzprqNJrwCXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781769135; c=relaxed/simple;
	bh=4nd8d8nXCrp4fh2CK3XF+QRzlDUQQz2xhK4xlv4TeuM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZkXMOBkMQO9rFzsThxyZS3rPhLoiGg4yxnC/6s8SJDnouVVnCBvAuQX9bm+04pVmCjeaMUmN/zWEU5oVS3hcGNx3FeibvYziejXvfpBR+HpZYkPqa7Kl5veIdG9/nK/dRM27CrFeO8nDWHqIPW6CyF0mGOs6KcIw4gzI+WGqBe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EGArLdik; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EGArLdik"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46019b190b6so489247f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 00:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1781769132; x=1782373932; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CerN24WvGNda5X/5X5+yXtaiL5Y+BUa+4egFlH3ETKw=;
        b=EGArLdikmYJurLRfO0+xta0cHdUr8xhtDY5B8laXTbJfiAqJNK/tvLrFNSfU6Tqccu
         AeqDN8Xy0NI4KI25H5e1ks9tJiEpS0BBUYNUChkRc9XftJCUG3mx1qoq+Url2PMlLvog
         phX11WLmTPCR69bCFONJfumzGsiIuONACf5PHrMGtCY3usObjTcR6sgYdk6lbcGZHhLW
         MHpwl3g6FiTxQHamfWJB1JaYCHasAH4iqi2P2iHasShikcwhSNQLrJYgKe/TzNLmeyvk
         r9pJMLnS7hVllJIfaFUMzAQbG72pcHSksLDwkHB0WBVbmbxbYJWB+AJgBoZ1ywbVSoRG
         vOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781769132; x=1782373932;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CerN24WvGNda5X/5X5+yXtaiL5Y+BUa+4egFlH3ETKw=;
        b=pOzvVfen9P7+ebEQQlnTEMcbMcKcIotA6M0PzrOhTAfyShPdqohY/JwskVD7Zi9dbL
         VCKW9zFugmwbvNJ6pUn1e0VfeLnkI01zNSnSZ8Vt/ZpHUqwK151vMu3S5hn/nZEhVuEz
         fIQSdkOcicRKbtXD4zDqzIDg20UdTCfC9HvY2i4HaISjiMW0whwWlQYKI6bFx/PtDJc+
         EpVu6d7Zw1KP9/DKf7dUpkGwlR0U1AkKqnWj5YTSQpdMJ9Nu5bXUt0YL8TuGxDxJel9W
         TyFrwyc4jk32o6A9GopMGleDgETwK+zNTbh25EOpc+k8gGCYFMmolZQZxCMeNInQ9+9f
         fp+g==
X-Gm-Message-State: AOJu0YzhzLHiGeBQHCAA3oPy03j5/t1M9/HAUGcZjWxHJe0qACsELeWV
	WpBSLpjybygMVfzXVd2ccXEOZqGCJjutYcZaMdXfKhBErTOaylOoPyPjgpE6iG7QD1I=
X-Gm-Gg: AfdE7cn0ltsfqxW4iLdrdLSkH7l379BFQEobw9mPuI9tn6f7pCdJx98LvhGSiRtbC4c
	BCgeP2DDkvh363Tnb4emLWzsjfI3dqIyRdh2yA8ugDm/Oy2gVq/CLFbT0Iq6q/Z1hpDNvMa1G9D
	/f/vN+GxbY9tt6tL+sO3Rml4Di3NvPwLjujU8d/JlJYDhigYjk72fPiUnIMb0u23Jh22/oHrzVa
	r0QGMUChSExO1mXTH53dRWCfZxOfitLlBeloesoEeLh4CfaNFTEfA5pg3ZK8dxG6czoIMotgMcf
	w964zqfSueOjd+IgexExpwGlArIMzXqugXZAgWT4Sc0i7bTdsbqyhOthI6wXgtmzD6b6jNmUdx2
	AaJfJgMLPDDBhGimFtiT6W92BC/NjbpeRy4AwS1GspCa0RoKz0PtSBfGVUJL4ZCBMOxW3kqvc6D
	l8sl8anoongAcjS6LVJ6+4TfQEBec6x4+5CfjV3tO+ZowF
X-Received: by 2002:adf:e00c:0:20b0:461:a16c:a6c1 with SMTP id ffacd0b85a97d-463ae06c414mr2695255f8f.36.1781769131829;
        Thu, 18 Jun 2026 00:52:11 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:106d:1080:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c5266sm66635071f8f.29.2026.06.18.00.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 00:52:11 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
Date: Thu, 18 Jun 2026 09:52:09 +0200
Subject: [PATCH] ufs: switch WriteBooster missing free space message as
 warn_once
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
X-B4-Tracking: v=1; b=H4sIAKijM2oC/yXMQQ6CMBBA0auQWTtJW0mjXsW4gHGqY2JpOgU0h
 LtTdPkW/y+gnIUVLs0CmSdRGWKFPTRAzy4+GOVeDc44b7w9YRmSEI5Bce6R36l8ce5yxJasded
 A5th6qHXKHOTzO19vf+vYv5jKvoN13QBTKSo5ewAAAA==
X-Change-ID: 20260618-topic-ufs-wb-empty-warn-4c1129fc0346
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1554;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=4nd8d8nXCrp4fh2CK3XF+QRzlDUQQz2xhK4xlv4TeuM=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBqM6OqZl4/mfvPgk8oiUiIA3n3yXXFhAfiS+liVTQ1
 33X3QUmJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCajOjqgAKCRB33NvayMhJ0ZCtEA
 CVqRtgDLve72XhON5m4/MTku35ceBMWz2jHaFRAjN1l6rj32UL1NVfSfh/UMEhBxZ3zwqe6h/6okz4
 00AeBk5WikLnpmP0JxeOHXMfaQrjcMniuwT8aVJW/zJAj9y8IY+LV3MzO6F/4tII+5U93UKebbQv25
 7mTBsEosNI0JEHIL+1ia3mj7SopHsjnELbpNmZm+U8BpAnSEHuHz82orN4RWZ2lhN6WgVaf75ii0HV
 RStBfNXHX6DAjQPCgAsCyVLRg2NBhglTcK6yd/qQsoJqXgs2X4eVVUjrdI4J0RI37DpbTO5knCcq3c
 Jcpr3Rim6k5afnXbwxsudGGbFRapyEVZi7WbyP3dFPgpcTlad3JRFKMhqdbhmMvX59HdeTO1AS4GuO
 SSNBg3jqldHNJeQdlb6+hzGNIiB2PneAoldFe0H0uMSCRmC2/tQGE6jutCm5DjiIhtM+lujJacCU3t
 LgYnkD1PVd2C7lGjFzuCDtYyZ0BXJ2GAOPXgE2ZhUKGaxtl4KO07ZgyvF4LGEd2Ag7Qvjq/7PGBUET
 gAvvedSoqIoHNVYg7GnQ1aTZ5QXVSARDZE6Rh5DWd8MxO/BBshyGwLr4MNaO/+nQeO8EotkB+0SxUi
 TCchoPSCO6s1hiHIFhoeqLSv2tET4jVVixG4YFHJEEW+foIJUkfO5NQ9rEaQ==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE

Once the UFS WriteBooster fails to allocate memory, the situation
will stay until fstrim or equivalent is ran.

Mark is as a warning since it impacts the performance but only
print it once for the lifetime of the kernel since it's not fatal.

Otherwise it will be printed each time the device is resumed:
[   31.666880] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
[   52.655594] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
[   62.890469] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
...

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..579bf604e6f0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6367,8 +6367,8 @@ static bool ufshcd_wb_curr_buff_threshold_check(struct ufs_hba *hba,
 	}
 
 	if (!cur_buf) {
-		dev_info(hba->dev, "dCurWBBuf: %d WB disabled until free-space is available\n",
-			 cur_buf);
+		dev_warn_once(hba->dev, "dCurWBBuf: %d WB disabled until free-space is available\n",
+			      cur_buf);
 		return false;
 	}
 	/* Let it continue to flush when available buffer exceeds threshold */

---
base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
change-id: 20260618-topic-ufs-wb-empty-warn-4c1129fc0346

Best regards,
--  
Neil Armstrong <neil.armstrong@linaro.org>

