Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E792F28E3
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136373; cv=none; b=fs0pu8QRgw53hoMVQSieZpP7Xdgmtu6vDPVuSza+1d1ezB6G9H1Re8/svSO62mVsmV1qiisDAN8gHJH3lVd5+xOA3gWR1NCKtgAYAprIdlTWWNROSQAL6xMDAq0SCHumcTzQX/h/DeOffHqYLEIgDjUzdHsAzCCa3ydqjcaw/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136373; c=relaxed/simple;
	bh=AHT26kUpMF4b7G1QPxCgxDWPcHR2tE/G5ZSM+TI0a0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0+Ru43F4wabt89LgZsaRt1SuNI7jl1pt1Zmc6hTbBN0ebolHRyJ9GY0gqjqxvA8/CY5jA5sMPxjRz7x2xy0LNk34CZ5JYwEDFAHxMnbL3MJHVcHgTm6DBjxM4u04fpBgpkIVYjxkXtrJdZC4XGU5UgWfysZdxkFdjpxhmnkzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=dzky3Z16; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="dzky3Z16"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47a8195e515so11987085e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136363; x=1766741163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMnbsBDys3Q5ALCY69G8Tp1FxSfr5hlJBitMcGmH9sY=;
        b=dzky3Z16c49yDXUmzXdmn8o4nH4wOX2IByLpGN1CvVbhhKtcH70jdjKJguDR4G1pds
         IC+WkoPf1zt8mXzUO4KY7Nf1bMBW3TDUZFnyu2J+uv9ytbymQQmX4ztChY4EUuRyffDU
         1cE5qem2Ga9B0nyw/wvl5VQKroKQYD91gMkhmfVKezXe8+5Gj/jBn6u0ctK7y+oKVmBP
         9lBGxNPmfX5BlYUOZuCfiW5D1G8hD5PT3Y2jniFy4dlv4SqGP/JrSTgjjO1Yh3RTqsWW
         67KZ1nWa8rhwyw+BFEAZM3p4piEW1mQpRA5mry9hw2MXVtDnmhn5mKhOMrdHnKQp/Tpx
         Mw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136363; x=1766741163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sMnbsBDys3Q5ALCY69G8Tp1FxSfr5hlJBitMcGmH9sY=;
        b=sBwV+GRwDfS2aWEELUJS1bIvbURmekNnIslGfvfWTnbIY8H39BvEnjUI8PyuMGI6ld
         ageIgjCHhLI7mSnjmvt3dUWrn/WkZygOdj7WE6SFprjB6GDQXu159pLRheoEqEWNJPZD
         rj+MgnkSizdvlEeQSnVrw7yzrbPJ/eRnjUaFPTBcLfGHo8mzQFxqkjo4gUFkBiNV5qXX
         Y8bwHi3QA7mpvi2832weraSMMfKdJ+da9PKA/2QUqjETt+I5DfWpAAdyL+bU/cXjJa9h
         lNbexEUAfsKzh0fy62Od882nTJeH89tTeMGid7mmbVLFK55kK4cQRTRFDtFpWoctzJob
         QvAQ==
X-Gm-Message-State: AOJu0YwwG3ggtos452g6PBLvLHgYw3SQ8OzcgzVqaACGHYEH5sk1GMeZ
	CSede+4RsvgiPAE0D8FKfpEPuRtmOtD8kfLwph0POkYvyJZkWSBqcsY/YRyCzrqD46A=
X-Gm-Gg: AY/fxX5ZUTuRs1Vg7G2Eu6foT2w4tQeAVDm9okyojKa7sfp9d4KgNA60ypDcn/Jc53b
	pIXvzR0moDgz7eiIuX2VSkiMyXKoEyLAkLXTrQkPzaNliePXwtS0O0HgmjenfoyLr5NFH4RkPc5
	58uZ9ewy8K16mrDaT2dnA4T9f45TRKdbZazvhx6VpeZi2QLerIYlyaGO8g5ihwtS4mE+ViQ3oHT
	+Qkb26BCfTfElkWJ15XUOY/btPfXaXTdP3T4toGvGhcfOP8D1TKhC2/X9BOfmS/0qCB77McCHif
	fEXJXtbt0gifD7+Oo+SHRFpDJjyzxbity9k45D4IpYyIUdgF4JToZtRQY+RcRMwbtg2GuNS/KfB
	ksl55zpETt+LyeRjKt6NHvEwkDbtigbJcigYbFrhwp7Gugkf4P7r7znEslNTLUXQ6et4piMV3L0
	9sUUndBmmTQ00CS5gMDke+CraTKEFI4LGTphbRQB60/IcnwEEbpYgmqWiU08i90MV1Yb1B8wWca
	O4=
X-Google-Smtp-Source: AGHT+IFmYQWz6L1SzUM2nXiY7KJqgf22XIvvvf4Np23ibdDNNhvtpV68GA/JG623TG5sdemIb6dcqw==
X-Received: by 2002:a05:600c:3486:b0:477:54cd:200a with SMTP id 5b1f17b1804b1-47d19549631mr17568935e9.6.1766136363134;
        Fri, 19 Dec 2025 01:26:03 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d19352306sm34503295e9.5.2025.12.19.01.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:02 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	=?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 2/8] scsi: Make use of bus callbacks
Date: Fri, 19 Dec 2025 10:25:31 +0100
Message-ID:  <a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4030; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=AHT26kUpMF4b7G1QPxCgxDWPcHR2tE/G5ZSM+TI0a0M=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoTuOkvwoPMSOYtESOOgiv6oZfT0xdqbse/N jAOhYZgWmmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaEwAKCRCPgPtYfRL+ TrsfCACNqbNGpjownpLGZtSSMrJmbFfGRDYqSoEmO49EXbu2sgihlNoaZAk5hoSKoiUC1r9Ch1n 3ADQ+ZxDYAl97Af3cII2dD+Z7pDDr32KbMx4btjW9SPY1Cjlptm520rdW1/dCseaJawHYvq5dAS mqRlv7yYybysepVq2up6L92cVk3BDUbbqcgmf4dvYJabdhhjQy2dDUEB3QPpSr24oG4ow7ymGRs 5i/0X5x8SkT2jbWs91x+wH9Olj0QgUATt2P/bgJDCHVhswi7HoM8zmB5JlsMCifEk3mmX1r4m5j VVfOj+epeU2jDE4CcL8/G2j7zSF70I3dNhkdE4I8g4+BROFe
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Introduce a bus specific probe, remove and shutdown function. For now
this only allows to get rid of a cast of the generic device to an scsi
device in the drivers and changes the remove prototype to return
void---a non-zero return value is ignored anyhow.

The objective is to get rid of users of struct device_driver callbacks
.probe(), .remove() and .shutdown() to eventually remove these. Until
all scsi drivers are converted this results in a runtime warning about
the drivers needing an update because there is a bus probe function and
a driver probe function. The in-tree drivers are fixed by the following
commits.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/scsi_sysfs.c  | 73 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_driver.h |  3 ++
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index db0ba68f2e6e..6b8c5c05f294 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -554,10 +554,48 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
 	return 0;
 }
 
+static int scsi_bus_probe(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (drv->probe)
+		return drv->probe(sdp);
+	else
+		return 0;
+}
+
+static void scsi_bus_remove(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (drv->remove)
+		drv->remove(sdp);
+}
+
+static void scsi_bus_shutdown(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv;
+
+	if (!dev->driver)
+		return;
+
+	drv = to_scsi_driver(dev->driver);
+
+	if (drv->shutdown)
+		drv->shutdown(sdp);
+}
+
+
 const struct bus_type scsi_bus_type = {
-        .name		= "scsi",
-        .match		= scsi_bus_match,
+	.name		= "scsi",
+	.match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
+	.probe		= scsi_bus_probe,
+	.remove		= scsi_bus_remove,
+	.shutdown	= scsi_bus_shutdown,
 #ifdef CONFIG_PM
 	.pm		= &scsi_bus_pm_ops,
 #endif
@@ -1554,6 +1592,30 @@ void scsi_remove_target(struct device *dev)
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
+static int scsi_legacy_probe(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	return driver->probe(dev);
+}
+
+static void scsi_legacy_remove(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	driver->remove(dev);
+}
+
+static void scsi_legacy_shutdown(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	driver->shutdown(dev);
+}
+
 int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 {
 	struct device_driver *drv = &sdrv->gendrv;
@@ -1561,6 +1623,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 	drv->bus = &scsi_bus_type;
 	drv->owner = owner;
 
+	if (!sdrv->probe && drv->probe)
+		sdrv->probe = scsi_legacy_probe;
+	if (!sdrv->remove && drv->remove)
+		sdrv->remove = scsi_legacy_remove;
+	if (!sdrv->shutdown && drv->shutdown)
+		sdrv->shutdown = scsi_legacy_shutdown;
+
 	return driver_register(drv);
 }
 EXPORT_SYMBOL(__scsi_register_driver);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 40aba9a9349a..249cea724abd 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -12,6 +12,9 @@ struct request;
 struct scsi_driver {
 	struct device_driver	gendrv;
 
+	int (*probe)(struct scsi_device *);
+	void (*remove)(struct scsi_device *);
+	void (*shutdown)(struct scsi_device *);
 	int (*resume)(struct device *);
 	void (*rescan)(struct device *);
 	blk_status_t (*init_command)(struct scsi_cmnd *);
-- 
2.47.3

