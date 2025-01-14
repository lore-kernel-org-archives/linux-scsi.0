Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61219149F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736885245; cv=none; b=Oi63DgiTM+OWpPk4u75gGEI9fUzWz7fg+Ztcb5xNmFuOLUs6ssAFbeIGgyOa47kPGFjwUj+bXWpgXWBN61mJxj0jtfxhtjYHoBvJkUvYHneNed3e7G4Q+cg2kE7KoTAqstb5RVUG1VzusKKlvX5Na75RV0YUKUiQD+ph+o8SFLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736885245; c=relaxed/simple;
	bh=CvW4khQ6vHl70GiNOhk5gbmrXwzLs1ymn4wa9CmkFYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j9IobF6AKTjTwwsng/RX0SpJW0GDpUfd2FKH3PrfpHPk6Fa4MMJqssn7QYqGhl1RrkP0PLj22tCbNOAe6UQLriaWunN1x2BLg91tamxNjQpLM6ke8fXNLF2v4s2o4Abybns5VkTsZVtdAqL8wpsufiDq4kp0LZPE86cgo+l7Zic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FYLcWYx1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FYLcWYx1"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43620a5f81bso6428725e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 12:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736885242; x=1737490042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wz3rX4Je09/J+8Ei/25Zrj8Kfz/o7SKbn92nTSq0sP4=;
        b=FYLcWYx1FxGrCKahddKggnhROrci4LLAfE5NoQBrppzw40dvAWswbrde6c1Q34PCTD
         sCjxnPhTZAWHBIaLbhq1K7oGNRwlWigkEtev6sKPeLkHp2ha7zycUoqnHxb566SzbcHF
         UZoLUdW9kiZwF2BgGaHLeS4O1RLGq/MQIH86LaCwuh2RwMFACpoz+WEJ+TumbiOSJi3g
         6//hSinWYKjGxULYNJafW3+/mkq5hSVSL7jkPszcEfnXqoe4PR6ru1XRQ9TpvmYHD0hU
         j2fiwHhrTp8YUBhMrKQ/IGXiGpjXAVSJsnv9xkLiGomQaa5yn6si7snFfh0JmyghJ4eR
         ByIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736885242; x=1737490042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wz3rX4Je09/J+8Ei/25Zrj8Kfz/o7SKbn92nTSq0sP4=;
        b=OgZ38037hhMm9PIK2VXQAaixYHnzU9I7ORVvdm5LOFs14H+ggEH8/jJvFVheQ14/vJ
         wJTZ8U849IdNnN/7f4bRqIP0pmptEOQCMEPMMGMoBNO15bRGfZjQlQfQP2ydYv4AxJfQ
         VR3vNye06yubh7smJc5qI8mTgOw/braHOPfaYEjfn6IT/p6xu6POySIiIUSP7bm09frd
         IS/4d6nE7kza4f1gMAFlRMS4eXq/FBpcrosa67FuYyEtUQgmXW1SQ8MWX7O6rYj+cUCw
         Tp4As/N5UQwl1lezH3N4NrRZNNTdpKhwxR4GUeH/L6LurfpimjSkWmB6fdT0mFAit1Ft
         +Lug==
X-Forwarded-Encrypted: i=1; AJvYcCXrvsBCRB+L5uGqbBcI1mj7GyTmO579pxjIxhc4MLeeYpOCDsgJtX95JaekixFwmt541m6Qa7iZI4kB@vger.kernel.org
X-Gm-Message-State: AOJu0YyLDpUJPzzgZNOrDin/XhrTOBFk/NsJe1RL75I0CwQ2GLkx3P5y
	3DTSYh+wNvzgPon40h+JPHVfMv7QiWa9Q9+1NFgTf4nAXfJ35Le1mtqtfTPnMiY=
X-Gm-Gg: ASbGncv5EA9DmBKbWBUzST/jIJO6iIadORCUQb26bzhDmrCMgNU9FBpX0XSpzwvA6at
	NdSM/9gJZAs7UKxWM7P+jEmt6ParKJeAJC8pKD13HuA0ySOadf9V76/awTQuSQfEE4O1EfYwt/A
	SAB1LS7s4lWUhHVXz7gGvXqLfC9sxhkiT3RJSZXpAKRTEnUIA1U2l3wTZR0GGTAZYvAFB12DPzn
	UNeF75VLCL9kcddGgFnyzyAiDoXvv27N17mXe2ZtvCsQ9OowQBOqPj/mwj+UpgQYez6/uI=
X-Google-Smtp-Source: AGHT+IE7Jj8lfNs/6Mawrj444oeAra8QM8Y3meAjqJpf/75OfBxvuzPW0rWmRWiybb+fzK9QvFi5qA==
X-Received: by 2002:adf:b60c:0:b0:385:df73:2f43 with SMTP id ffacd0b85a97d-38a872c8972mr6632398f8f.2.1736885241685;
        Tue, 14 Jan 2025 12:07:21 -0800 (PST)
Received: from krzk-bin.. ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9df958dsm185199475e9.17.2025.01.14.12.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 12:07:21 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] ufs: Use str_enable_disable-like helpers
Date: Tue, 14 Jan 2025 21:07:16 +0100
Message-ID: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace ternary (condition ? "enable" : "disable") syntax with helpers
from string_choices.h because:
1. Simple function call with one argument is easier to read.  Ternary
   operator has three arguments and with wrapping might lead to quite
   long code.
2. Is slightly shorter thus also easier to read.
3. It brings uniformity in the text - same string.
4. Allows deduping by the linker, which results in a smaller binary
   file.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/core/ufshcd.c       | 11 ++++++-----
 drivers/ufs/host/ufs-mediatek.c |  7 +++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 27154a5dcb7b..5225d48a47f8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -23,6 +23,7 @@
 #include <linux/pm_opp.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched/clock.h>
+#include <linux/string_choices.h>
 #include <linux/iopoll.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -1187,7 +1188,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq,
 
 out:
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
-			(scale_up ? "up" : "down"),
+			str_up_down(scale_up),
 			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 	return ret;
 }
@@ -1549,7 +1550,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 		hba->clk_scaling.target_freq = *freq;
 
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
-		(scale_up ? "up" : "down"),
+		str_up_down(scale_up),
 		ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 out:
@@ -6026,7 +6027,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 
 	hba->dev_info.wb_enabled = enable;
 	dev_dbg(hba->dev, "%s: Write Booster %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 
 	return ret;
 }
@@ -6044,7 +6045,7 @@ static void ufshcd_wb_toggle_buf_flush_during_h8(struct ufs_hba *hba,
 		return;
 	}
 	dev_dbg(hba->dev, "%s: WB-Buf Flush during H8 %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 }
 
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
@@ -6064,7 +6065,7 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 
 	hba->dev_info.wb_buf_flush_enabled = enable;
 	dev_dbg(hba->dev, "%s: WB-Buf Flush %s\n",
-			__func__, enable ? "enabled" : "disabled");
+			__func__, str_enabled_disabled(enable));
 
 	return ret;
 }
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 135cd78109e2..a7804fe387e9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
+#include <linux/string_choices.h>
 
 #include <ufs/ufshcd.h>
 #include "ufshcd-pltfrm.h"
@@ -480,10 +481,8 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 	}
 out:
 	if (ret) {
-		dev_info(hba->dev,
-			 "failed to %s va09: %d\n",
-			 on ? "enable" : "disable",
-			 ret);
+		dev_info(hba->dev, "failed to %s va09: %d\n",
+			 str_enable_disable(on), ret);
 	} else {
 		host->mphy_powered_on = on;
 	}
-- 
2.43.0

