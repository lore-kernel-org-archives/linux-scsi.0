Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C13B8935
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777311956; cv=none; b=LS4/nkKtrDwJEElZs8XtYr/nIHz0X8JfDhvZn7vP6RpNWIDRxhacRY/MKe6N9uIanOQ3lJkaELznDsHCCm+2RZ7nFRvRc/l5pOSQmAcRIspnqbxvvARhSqXP9+KtZGefJTFanA70s8S7oaLl/mDc3/KhyK5Ixmh+jfEylXqSrWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777311956; c=relaxed/simple;
	bh=pwp+fkTdYCpbo4F8XIy0Or93eBGnbCwk1yfa8S5kaxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hb1yoHbgh43Kex9b3WKqZ/AHwZDrK5bex3pRujlJAN7B9z68XVYyWWHg1oCZNxgEtKRVv1flxWV9FRWPXLnMuav5E7p1W4NdKIifCFBVY9v3v8S4IfBbRXz9qy59Xz4mmK3rWEuI2Ze3tmuLQyFr7qKsU4xSPYvkFGmDLFWAo0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=vy8FPfTc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="vy8FPfTc"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d73352cf2so8855294f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 10:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777311952; x=1777916752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MvOgFtWGlX7l3oFyrAXPCvT6Shg+N89HEA6wfoAihl4=;
        b=vy8FPfTcSMY12BxWDI6UqHabxQ2y5ePx7tTZcaQr3pLlrraCT4rDctjF09eHWbLx3k
         4twsSt8Zvp8egKnduGAcXnd26TTDLyuXXQenIXp9o9auiWEVZxn1bzQpuSvy0NJiaBio
         JdHBGSVvpJQJNHPPO+W9y7VuiQQahS8A/vqg1npgB4+84cc06bHxZKUPB8Zcm/BPIzno
         nLyRycgge3dhD2AD27r6S4jNWImF/WuCp1ZVXN8WTaKf7qKfddx35KTAjOiMMkACEGMn
         5Mltti4Pk6frJgxrLzNb+fabdbCbdP5ghat4L/a4/LvAMsCe4kZ5wR8PBrEHUl1WaKhW
         DybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777311952; x=1777916752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvOgFtWGlX7l3oFyrAXPCvT6Shg+N89HEA6wfoAihl4=;
        b=XQyPDexd1sTvm+MVXxIcnm/GBtCeKt4CA9U6g8a+PJydZD4viiVbuVlgND+qCnLlrH
         Hwy4JMTAtlhaxdYSHk4S250TAKL35NqopZfaFQ0rHiwOPoInOT75XC9rae7+QUCVEmYX
         +AxWfW6HcqP8GzrTg/2NBUORNCDWY1fixm1M1jhyglNwanqQL5Xj386AsPdTfNxNPVpv
         u3GPQej1y/DsbYhh69440CoXFqp9TyPrn6LZyj4KvIWWlf28edsEDU+MoJrIr0oBq8rc
         djyLHdJySJUFcMXC1/SPKsmmzyhsviWL/4IX5bkIkgqUnZ11BOv2+tNvwvdc8sdYe+SD
         iaYg==
X-Forwarded-Encrypted: i=1; AFNElJ+yaewiRkPrUqfBoDrBPTstQUnKdyBlzUG6l0xVa6PsyM0KFysf6cIxseduHCXxJnMJX1HaqWKzPGBt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7rO4iVEWT5jl+pV4S9QcLhWkVRUlwTUI3dP2VpkpQT4KB+1T8
	r4bGFfaCPtQfO75Un+F7r+APK0Yl1FXDA+agnMB0sdqERSuE4lYE8m69aYS7ai7PmBI=
X-Gm-Gg: AeBDiespchUiz2JG1D1bBugRmVo4rZs/8DREJiS6PMQ+jTUcHqhpbAghvDTR1ehywUc
	XyE2uYJA96N1VWFqrBanANtb3XNs1hmPsh97AupWH+EYds6iwe3m3eq2y/42LcFHRuGfoXsTCp4
	4l1M63LHMpq0tsrmbsEbDbsGWhKBV++BKjbaYT6uo9Sroobeeir317qUpff34FlxXrJwSVzWSxQ
	Rdh3F+tWxkNZ1cKK2w2cwwKysXHooPVadRGLe/IdGLx5Py3ppFxZM+SJkI14wukot9BfxuOL1hu
	Dx3ZzTQuqbWQ3oaM+RR6kCDaRzplpEgCkcbSWYbciVK5dZE1qDY+x8jFqvlS2G/EqqHNpEtgB7x
	pqucWU38dx7o+4CaSz/UvMpwMETUXxTnJr+5mlAOgCTZdqu98QGq9qElrZMR/rXLFm6PlWmoANB
	SSWncNOiGWvM0BdJLBD/B2ScGLDvXNB+FnDKVejutjjmi6Fyw8HCx9aFU5CC5quJxy616EdwdhR
	pGzQZF3k9/WguEL67eddI+OMQ==
X-Received: by 2002:a05:6000:4283:b0:439:c18f:5aaf with SMTP id ffacd0b85a97d-43fe3e13dddmr67790382f8f.34.1777311951536;
        Mon, 27 Apr 2026 10:45:51 -0700 (PDT)
Received: from localhost (p200300f65f114e08ec76e48b71c06d70.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:ec76:e48b:71c0:6d70])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e46471sm79227982f8f.28.2026.04.27.10.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 10:45:51 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mvsas: Don't emit __LINE__ in debug messages
Date: Mon, 27 Apr 2026 19:45:46 +0200
Message-ID: <20260427174545.2014499-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1424; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=pwp+fkTdYCpbo4F8XIy0Or93eBGnbCwk1yfa8S5kaxM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp76DJRLTt/0cozFWsfFBYgrk77iA4IZ1rOWWZL KEb4GBRmFOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCae+gyQAKCRCPgPtYfRL+ TlA2CACSa3DdK/I+oGJUGzyuBP+hkRvC2jJW/v0mQ0hhzWaBhAuGVvKZ83t9Bv+zXh6nAHdCvji NFeQDFmxhdwGDZHNvTC/VH4qOrqFttRg1PlS9JUhNbPZzyNwnyHcPNelFYVp9/et6QTobRCgKJH ZFd6L8NtQVHb6rL65c8ZAR2KCEsGNPAK7vu714LaRiuJBMSsbb41a1BWakC6FtpAe411WT7T+Y3 Pee3uqwmvGrfSjBiUCTKMdTRUcHc0IQCEA7EdSf5Os0lBDKHeuts/U+xl147FA3rxy9NCZKZj+7 0f05UosEAuDkXlGaZzReN2mFEXEmedommdLiNHJ/zcj2Xsvb
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

__LINE__ changes quite easily for cleanup commits. So when checking if a
cleanup patch introduces changes to the resulting binary each usage of
__LINE__ is source of annoyance.

So instead of __FILE__ and __LINE__ emit __func__ to give at least some
more indication about where the messages originates from than __FILE__
alone; with that and the actual message the situation should be clear
enough.

While at it reduce duplication by implementing mv_dprintk() using
mv_printk().

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/mvsas/mv_sas.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 09ce3f2241f2..7521f969aa87 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -35,10 +35,10 @@
 #define MVS_ID_NOT_MAPPED	0x7f
 #define WIDE_PORT_MAX_PHY		4
 #define mv_printk(fmt, arg ...)	\
-	printk(KERN_DEBUG"%s %d:" fmt, __FILE__, __LINE__, ## arg)
+	printk(KERN_DEBUG "%s: " fmt, __func__, ## arg)
 #ifdef MV_DEBUG
-#define mv_dprintk(format, arg...)	\
-	printk(KERN_DEBUG"%s %d:" format, __FILE__, __LINE__, ## arg)
+#define mv_dprintk(fmt, arg...)	\
+	mv_printk(fmt, ## arg)
 #else
 #define mv_dprintk(format, arg...) no_printk(format, ## arg)
 #endif

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

