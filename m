Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498073EF65D
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969756; cv=none; b=hkJABt4QmOsTNOf8287o7PdgLhTR33qG+ap/Y9Hk6rodQX4jh81/ZekwugbTouuNC8ZMUZmkYbgi4DbroFvPpb9dxfsiE5Qcfawep60Z5TdNAtJtCZPAeVH8QSUywvnzxQG9W+ApALW3kr1BNrRNSBe56I09GHh3olvuvu9FX70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969756; c=relaxed/simple;
	bh=tEoZ0Lrl3EDghr83tjzFRbo6mdSZ8AGpkvri+IpRe+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsHbaDCCAdCzCzj81d+ztDqTovRu/D3vTVb7gfGSvLKLQlDvU7p+0fIPUqv6YwOTAofvYPtYuOZfr/CK6OXskSgwF3mrOKSlzlRYPJPTrQUOA/60r63OI3e8qWqp7jdTAzuNFPHtfnMfG7A7AGetJdnUhQdzOVzhOQWKbPHBFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=kuZ/WuvI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="kuZ/WuvI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso39826535e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777969754; x=1778574554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=da3gP39i/60E2mrHTxJ+5VvGJrP7pHHuNjutU85jPik=;
        b=kuZ/WuvIoU7fQg9u22jLYge3MOc1aGOUyoR3VEiXf4rXbbrsPBt/P92Xx7/2wV+O/9
         yfiBI9f3Dkqr5ELve77N3H+7zfutV5V3vcC1cH0ym/Ms10F/RV0XtvKD0VZ1252KcQIj
         FLH42ACTPUtMHwPCcWGyXWRWWJyk8FopeAMa/q5DLKDX9oJO5oF3kqDL/IiQKL/TjGco
         K1P9SyI93aqSLw0aRKyaC6TA8t8zhKTBZzJpgtCmUK+9SwVaP1jKQBGgn2wcNE8Vz6k+
         J5svYAfHkg9rPN/kOxGNyCoqP4oNiia8mEN0bM4vb8qh5ZKqWEBusSEDYoN24fwwppOn
         iqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777969754; x=1778574554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=da3gP39i/60E2mrHTxJ+5VvGJrP7pHHuNjutU85jPik=;
        b=JRV6+jrcgu/Dg7ZAguHH7klCutPBDXvSa/RRAjHBNuFh4BGdLmAGUl7DOt+7eb47hW
         KD2jkVw0tL26StLUEZQKfnSA8gIebTaX0DeohArfapXlvZ7kO2NBVJMM7UoXOvoWiDwx
         zzHgTZulI2lMNmzNEs9/uc1ox6gI6x+fDIUsF+OzokKt90QwKuw2v1NHBupDeBsUjVYT
         hwnp63IqHcEmHNAQINigOq8DIKv5ZIW6zHBMu8G54+6DkoxGSnqATlcIBzB+Cu6pAynl
         iRaZ+gPPNcYn1nxE+edDz3ZyaVTNYhPSZxe/MVZvJWlUf8ORNfSS+4GbC7mlpSScPgP5
         wtwg==
X-Forwarded-Encrypted: i=1; AFNElJ/x0P0muN862wJ1Vw1bMynRuhYRT6wM0akILOSU4wzCHaieUj1GFaRwno0af+CGxUMmEcnbifQgov0e@vger.kernel.org
X-Gm-Message-State: AOJu0YzZrd2A1YquEgDevBntYOhGcjFv1BiMYsFMqyJns4uN/aYeUxtz
	h2A6g+LLYcNyoSh7AYMSSH76Vy1f9205UekX9P5q8trK/Cicg1zx7l5ba9EGr9eBlVY=
X-Gm-Gg: AeBDietC/kTHozVagY2SBFa41jEoVBQPJYJGqaqmrPOgrep6UqY53EvLqOAq+3u/LB8
	el31XRQJx/fv5TaPQy9iL2YFJx9zGbN0F8sRNWICNUXYUOwVi3y164xSNzZF8OdSg4ZHm3ycVXP
	Bv+vCnzhjVePtWw5y8Iy8GZ7HDkGgAHbvs0EHQgTxg2+GEJ/r4UOG7AgA1gHD//5QsEWHhEM6Pi
	pX7Y1cdYH/hLIdEYnIAmPVfoCeHYHJr7OEIsqtj5uYE/vc7NjMVxNfe1mZaMI5un+7jaqJQ/6Zk
	TEojsrZyH2IP8Mon4+A6MW16/keu8BCSXx2ufeXg7zNlBQvA5DWrA3uZ9oDOWl0T0ge3YE8PXah
	ETI2wCZNYMhyYDQmHavwxegCIM3SMHqtxb4gduN4J2NjdaAoSTuGsLVpsuvUHjT4Fd91XFqkyEQ
	P8PxZkJEy7dQUGSa742DD0cRWVzjfK9MyvdGGhsjXVY2twOsGjMLGL40HsAdis0sjPnLX2ZlKg3
	ugnvY2PfYZ09rNB12ida5WKm9CRQmk1UMyv
X-Received: by 2002:a05:600c:a30e:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-48a9866e918mr185944585e9.23.1777969753736;
        Tue, 05 May 2026 01:29:13 -0700 (PDT)
Received: from localhost (p200300f65f114e082236c6257eff72a1.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:2236:c625:7eff:72a1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-450524831cdsm3087684f8f.5.2026.05.05.01.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 01:29:13 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Archana Patni <archana.patni@intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ufs: ufshcd-pci: Use PCI_VDEVICE and named initializers for pci array
Date: Tue,  5 May 2026 10:28:53 +0200
Message-ID:  <6cac1c22381f7026edad9854d70833381d14929a.1777968942.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3428; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=tEoZ0Lrl3EDghr83tjzFRbo6mdSZ8AGpkvri+IpRe+w=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+apITuz8Ovs8zQnyrmBftrQlGwranYj1coSuQ CUnb32rJEOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafmqSAAKCRCPgPtYfRL+ TmoLB/9PqaphcdfWUA2bPd3lOpWAxsuGBnJAPySXm8U/ttfmKX+ZlAnS+g012a4CzHbwPFofun9 qbzZjfdgUZkOM7ul6T0VbC8nyWjBA5T20EgpTsGWMgc2W/d6P7FQW1BDRUZ9csD0oWz275lnryC xRBBOsit2vHX2635y6pJIEG2ysd4iclgvumHspeggrxXbeCnSLm6pL5UK35zwYekfNJ1FU6kpWz Bk5AH2NJvviI5aMkWmIKqtd8mWdy5ZAX+sEha7dqt7GMZzhKWztuw23W2ZuApN5SX2pUDDi4C16 lxtX4sOBKzngXjtvtAXtprkCJU8ESHLRrKC8bAdyB8T4gtz7
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The pci_device_id array uses a mixture of ways to initialize
ufshcd_pci_tbl[]. List initializers are hard to read unless you memoized
the order of the struct members. Use the PCI_VDEVICE for all entries and
a named initializer for .driver_data.

This allows to idiomatically assign the members without using zeros to
fill the fields before .driver_data (either explicitly or hidding in
PCI_VDEVICE()).

There are no changes to the compiled result of the array; verified with
builds for x86 and arm64.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/ufs/host/ufshcd-pci.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index effa3c7a01c5..13293e83064c 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -680,21 +680,20 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 };
 
 static const struct pci_device_id ufshcd_pci_tbl[] = {
-	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		(kernel_ulong_t)&ufs_qemu_hba_vops },
-	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4D47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0xD335), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(REDHAT, 0x0013), .driver_data = (kernel_ulong_t)&ufs_qemu_hba_vops },
+	{ PCI_VDEVICE(SAMSUNG, 0xC00C), .driver_data = 0 },
+	{ PCI_VDEVICE(INTEL, 0x9DFA), .driver_data = (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B41), .driver_data = (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B43), .driver_data = (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x98FA), .driver_data = (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x51FF), .driver_data = (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x54FF), .driver_data = (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7E47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xA847), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7747), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xE447), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4D47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0xD335), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.47.3

