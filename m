Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bell-sw-com.20230601.gappssmtp.com header.i=@bell-sw-com.20230601.gappssmtp.com header.b="VTCMz9xo"
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A6912C
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:14:40 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-507bd19eac8so7846840e87.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 09:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bell-sw-com.20230601.gappssmtp.com; s=20230601; t=1701191678; x=1701796478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CYyeww6On968FaF/k8d+pIH55nzcg94R1XkbsOTxDSU=;
        b=VTCMz9xoz1hMxN1UszinDhOehuvC1usoTBnvLdVGB7s1OOqyvALxgcaItGoWI4Eo22
         VdX798sETvsUaXRnegr0+iF9L3x36IVjBDtpS7lawfUGt65NhjP8rt5rNcj8v5zpxmV+
         BRx65rbUyniIClF/0nq0ou+LyMO37+H/xi1g7oGHyhI9IxNTOndJwcX4FVRpWQ7RSbGJ
         1OZez9Fm5fWvynB/sTdnMFXp8DMFVAdjNh1VtnRt+pXTb3RwjTj5xAvmy2jBqlS5R6Bj
         sTcpSbkhfxsFxiYlhpH0M9YUnU9UHfMs5NZhv5UkVGJKmx5RGBde3hnJduD1oQQSZQmi
         RZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701191678; x=1701796478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYyeww6On968FaF/k8d+pIH55nzcg94R1XkbsOTxDSU=;
        b=qAXaT0NfXKo60D4ydzm6xk+52VMs5i1cycH/xv8vL2WXUJD9BhPqB2tXBH9mi0p9OD
         WKJ5urDUAvaeZD4xLoEZ9cNopsF4htrjCfaFHMXhiLut/MzB8OZEqkomGtToY3y6B+hy
         agH+ODTwRDeu5xH1XF3oGZ7xTokUf1w53dnBZ22B/F39CTNvg94ZbNb0y8FP2N1vJ4bE
         sU+YHAfq4cZrYkeoMgPWPlZUKvd4OkcPC92vHP79PHKB9mtTglD0ClLT01blYj48Ywyp
         kGM/hjyZ5v/WBsVmZZAoh0Ig4Wb7VAsZsIs/7dDvdHuovCBvnM48lAgkYd1JGtSOpuaA
         7juA==
X-Gm-Message-State: AOJu0YzlS/IlrANx5kBkkdl/g1aNO56i/evJqHwb1CGsGXbla7bGxJ+n
	o0B8uS8/fg+sNUV0EQYwQnWEk1eL/JZJ4fYGEw==
X-Google-Smtp-Source: AGHT+IEEBHOrIu1NZWuMxDt1xZ4AY+S/D77mGt23K554DjateTUFfwnp8kyiYlUO0sdDdpYkSeDFDQ==
X-Received: by 2002:a05:6512:36ce:b0:50b:b92e:2f7 with SMTP id e14-20020a05651236ce00b0050bb92e02f7mr1530499lfs.27.1701191678412;
        Tue, 28 Nov 2023 09:14:38 -0800 (PST)
Received: from belltron.int.bell-sw.com ([95.161.223.113])
        by smtp.gmail.com with ESMTPSA id m25-20020a197119000000b005042ae2baf8sm1870333lfc.258.2023.11.28.09.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 09:14:38 -0800 (PST)
From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
To: linux-scsi@vger.kernel.org
Cc: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Subject: [PATCH 1/2] scsi: message: fusion: fix array index check in mpt_sas_log_info()
Date: Tue, 28 Nov 2023 17:13:51 +0000
Message-Id: <20231128171352.221822-1-aleksei.kodanev@bell-sw.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"sas_loginfo.dw.originator" index for "originator_str" array currently
has an obscure check that looks like a typo because it does the opposite,
exiting the function if index is in the valid range. But if "bus_type"
not equals "SAS" and index is invalid, it will proceed to get the string,
even though it should exit anyway in the switch below.

Detected using the static analysis tool - Svace.

Fixes: 466544d8898f ("[SCSI] fusion SAS support (mptsas driver) updates")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
---
 drivers/message/fusion/mptbase.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 4bf669c55649..4f507fc2f02d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -8076,8 +8076,8 @@ mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info, u8 cb_idx)
 	char *sub_code_desc = NULL;
 
 	sas_loginfo.loginfo = log_info;
-	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
-	    (sas_loginfo.dw.originator < ARRAY_SIZE(originator_str)))
+	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) ||
+	    (sas_loginfo.dw.originator >= ARRAY_SIZE(originator_str)))
 		return;
 
 	originator_desc = originator_str[sas_loginfo.dw.originator];
-- 
2.25.1

