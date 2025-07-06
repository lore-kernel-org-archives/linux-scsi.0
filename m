Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA661386B4;
	Sun,  6 Jul 2025 09:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751793933; cv=none; b=hdF1sRr6u3AiAVNXnw+RDUz5u0EWEyVqGd0/ApurCuNfEicCFKH61nUVrrR7hg/pfq6WfxtRFPNsjiev9Ob9q2s99jUrxZMRVnGuTEq6Bmed/2KaraNlKCHbjjgjOMpc/JQiZSWHaAdYKxyVmc+Fu0K55W35IOEHVbLChrDfn3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751793933; c=relaxed/simple;
	bh=uNRG7Dp9Y5lA1BfsuxAk7MQ5UhU9xjl3Bg3u9K1zj8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZD7OxcoiQRvm3GolODJjIGZ+qDQx+mWpJSbFATPzC5zxyBxjM4SZNaLOq//ZoXue+vrbSukcSM0VJTu5pPCVCzp7toVp7FaEbwRWoe0t8Qo9l7CWFUziblAgMdUds02EoiUqJt0UCmoB2j9XluSNu2lol76CUU6kGT0SBnWl49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JidYwsZk; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JidYwsZk"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-236377f00a1so18116275ad.3;
        Sun, 06 Jul 2025 02:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751793932; x=1752398732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lA8KNkPs04Haqqyk/LQTF4+bgbkvtNg6lmvOnF3xgBo=;
        b=JidYwsZkga6QlzVHNsaXlfaNPb7+iusC4Hbkc77FBeBNMzHLzcFRdyDMpSSV6bPmWq
         ROnpJ4QRfmktw+p6SM6Hdxj6ayKY2JTC/sVsswa+IJ9mMxw0qpm5uq4JhxpK9ObsAkkt
         cNVDysnsL0nknRg+CTcD6k6BgcxPVg/CBmRg13nES0tcYptk9P46KKIYWXVY2/SIpZKZ
         ziDAJYDwR0bnWwX8WUChsAsvAdO2GJxeHQXmYWGw+apHhEOsCC+BIo6pT5pWLCPSO3wN
         42szxgw2XN7IxQaWUTbHhnwAAyYTkThDIm0g8WK3841tq04YMgpgN0Do4NAkoH4znScW
         W55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751793932; x=1752398732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lA8KNkPs04Haqqyk/LQTF4+bgbkvtNg6lmvOnF3xgBo=;
        b=VxZfT2B/LlsQXQZd3ko8VvYyKcWUKQ8o7rXGEVFmXZKtcbY0vc5AfzFKOJPIJRU8ya
         HkoNC+/57m50+H9kb9lnOY2KgM3ERjQ5kzLtO8AVO5/3PdVAn8W3BAJLM78+YamzZniX
         qMAtVMEQIAtlV4L0ZbUHc9GjaaTAyABOU9qgw1TxDn2/pbG5bAGTz5640pNb9BE+IN9C
         XhTmq28zEKFe/Tsf5IgjAl0+ZcQy9fw9KFskhCqpN90SB7kFmkyd9Ur1p/GXw3hbFi9F
         Qm5MAY76BQ4cTJBWgNu2alDQ++hjckKXKXbuaut1QL2NR+pW06OlZS5HXLDtpOuByWnk
         WDwA==
X-Forwarded-Encrypted: i=1; AJvYcCVkfgIQRGGAuGoalF4Xps7XIA8mfbbxIVhxvZDmau8v1oyDmjl3FaUR2oPw95mIa3JkPZmAMCWJ6dRVDlY=@vger.kernel.org, AJvYcCVutm2WCdZM9XAaKOoAADWrLcmIpHw50jThHd64IeOEhB4Y9gO1oiFhyLaMDFpCG8yz6srx8StxFCebeewf@vger.kernel.org, AJvYcCXukwA3HgVagyUDHQ3mu6SzMNthwSKJpQzEvjX1AZSGf6k8Boj4MFR8gNzN5gXdtPHmtexsRr2dSXD9Cg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz04bQ0af2Vf2XhJ/SvnGCWvHRYPAO3BaNCQy7bYM3iPBCXtjiF
	IO/XXxQNkFy9fEUU2Pj1+5ecjntdgYou3iCHV0mt2zqxJKiDUzBXx+AC
X-Gm-Gg: ASbGncvXzltjSK4l1xaAW7Zrb0Pnk71nD26PBfSgcyNfDM9xHMKK43Q6X6gGYLliPYh
	Ca5VyNkMthoYxf1+T7Q50YYgsYsGVIRoknQlPdkXruGC6EodRtFrOVtHAtEQmFX0Q0TepnCRfky
	Gv1LInRpq3dXhDs8u/ll13zJcggggK2pnPH/T40mbTK2k7SeKWeBHrpYcL4mTic3UI0jmHIo8HA
	5gSryzPKMMwxj8gAKmSH6sr3JztmtVuL76WdKTwplDVaU853rldzAVSK98D0IYSjuKAIq6wQA+Y
	PNon2VgWjK57PWaBHrkMQI1Kdjw9GVu1E7KvagWNEUzXgSj4FwU/FzHvI9iedzhWqzvnEdQuHjB
	dpnBgOQ==
X-Google-Smtp-Source: AGHT+IH3vq2oxcWMOz4KCi0buYRStjOlQa2oNevR3gflhsdNi9rysjwR5KZGyuusMR46XX2R/z7LXQ==
X-Received: by 2002:a17:902:db0c:b0:234:8ec1:4af6 with SMTP id d9443c01a7336-23c91056ecfmr73738155ad.45.1751793931566;
        Sun, 06 Jul 2025 02:25:31 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c30:6f3f:3d1:c4c0:3855:2a18])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaae5393dsm6247089a91.11.2025.07.06.02.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 02:25:31 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] target/core: replace strncpy with strscpy
Date: Sun,  6 Jul 2025 14:55:22 +0530
Message-ID: <20250706092522.9298-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strncpy() is deprecated and its use is discouraged. Replace strncpy()
with safer strscpy() as the p_buf buffer should be NUL-terminated, since
it holds human readable debug output strings.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..9c255ed21789 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1112,7 +1112,7 @@ void transport_dump_vpd_proto_id(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 }
@@ -1162,7 +1162,7 @@ int transport_dump_vpd_assoc(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 
@@ -1222,7 +1222,7 @@ int transport_dump_vpd_ident_type(
 	if (p_buf) {
 		if (p_buf_len < strlen(buf)+1)
 			return -EINVAL;
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	} else {
 		pr_debug("%s", buf);
 	}
@@ -1276,7 +1276,7 @@ int transport_dump_vpd_ident(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 
-- 
2.49.0

