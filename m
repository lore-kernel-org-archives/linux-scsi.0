Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F71E376C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313139; cv=none; b=mpffp4fpCCxaKr7GVefHodMNEXF2svkUKjiA7fgryFBjmF31irCTNmkF0oyAtfMS8nc8fCp5aQFzezGOyDXHz+Hg1VDyAXOBigJMYVi1ewixDrU60wU5FD6Om9uXLfwwVH6amT91UO3vik6yD2HSC9OaHuRKI6aEggwNkBryEZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313139; c=relaxed/simple;
	bh=Ll0IisgGOHaUv8OMzdyo5F5kYF+1d8Kt0Xt3KldsvUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+NvRnd1QsoA8RHxtTczCXWGh5F/BauErZkWBvFXuSqYbS5E8sVdPJjE366MaE287tPEJsPnU+cQRKLPk9v+34sxltbvvsMLsZ2LkrZm+jWq8UkqMRYx9sM8rU7h0AwWyWeXxXwVgWuzmn4s9NKYNGIw5MfRqnSruDQRk28oLbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=CO6VWcNB; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="CO6VWcNB"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so8717483a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313136; x=1765917936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvandfZNGrOWFbeJMnBQXszBptryBv8qYSTimK269Eg=;
        b=CO6VWcNBUbNSmkFXWvAc93Fg8+GPcFqvpv5UVeIUjxAfijmd/YZCE7/74vEfyYepoe
         iZBaA8P/8qT6aQlu+gq/lxw/cvNMfhYC9umJiy02BZ9twEqnQVjqhHo6gru0URdNXK0K
         Tg4PGm1XajYCQTelWdTymBA9EOv7QNFi+6UTvunq+X7zdzeP6JeyD7bDWMcXw5keHwEb
         CSqCrn/Q4OWLT/DMRmm4hCg82NawfV61+a9Ki35mCR27c2UV0KIv2ahrKo/js8f0RmgX
         OJ4MhxKFQwtuk1fAbBdn0ZO9CwKZrVQz0XmMctpPPg7dzdg8efaVkxgb9V65wTaah4Z3
         whwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313136; x=1765917936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AvandfZNGrOWFbeJMnBQXszBptryBv8qYSTimK269Eg=;
        b=ecoDOEUAB8zz/ZpVdRWXUBMacAC6QWwdCF8g2+M+OTKy/djOnB7fAsIEq2pR+bU40u
         2tzQ19Tg82HqtEFnU6PlQFItHPeOhtc1uichA2AlA3F39TAejMcJGO3XvtKIU4DliO/h
         bnHIoo22vVloWjs+z0gOtEoflb6Wqs9f4wAOSyHVM7rTDNauwe7oQtKFEZ3ISuL9LEcn
         0ygDKBi+ZW9X3iZqSNQPLHtY7Fgqn8lpXYCUwPCsThi1qAj5reMXUlcIJ423lYN321Bv
         S9mKeXKzTSk/n48rRl99mvx5zqD6dPKak4QLry0enyfm2vKbmQ9/97fB6msejh93QSdz
         HMaA==
X-Forwarded-Encrypted: i=1; AJvYcCWShwBxbhegR9nIoxs1Wk8i6UNZvjQc41gPq/FGtnNqPBkuNpOh0yqCCBN1W2PN1uT+szbD82QiQNIr@vger.kernel.org
X-Gm-Message-State: AOJu0YxIyEytE+acwMfoGJ09G30azVLPUYCRMtZWZpfeKg3fMF5b7SK4
	ifmWsBGzpYfl4eBPcwwzHuTvjyjAK3qSOpzPdhN7z57jmfejTuKVetXe1ZnNoHdULLo=
X-Gm-Gg: AY/fxX5veYL5xH7riIefcsbUBHO9R/LNHAL/SRIpEsJVvGaH/ge+MFKPjFwRw9gKOvB
	Dh8a3BjV6wbdIXS/A75UuKeRyeYV+ghu88mTncPYcS2N2D5UPIOQ+Lihyz3LQSvxx0+Cw+KaksJ
	n6syj5Huo62xNF0kHz1GhATXfv0KHovz/WeRVbS2sfgGnXvRN482kCz9pjo9m6lfnkXLRfGtcq4
	w7fUspXETIi6KGFFqT4YsztOQsAMM8R3rBE2l+8XNlqFWBCkW24KYysCgMprswWnBQY6jes/Epa
	TPvMCzxVSqSVkmXxamSUPeUQhuH9gsld3iqLPDTm915KJ0tNkTt4ZvC3VOiPCb5CC4/0FV/zpPG
	Ca63PlKBzADz/Zs0kLCctTJp+oCK6HXm5MX/MaYaZ+jmZZTPul6PMtu9/FOT0oRtcRoXBdoz/Fw
	/e6lBQj56tJh/qzS69
X-Google-Smtp-Source: AGHT+IG7GS978+zk6it992R+60h9S+xg6pEFPCx0CFRpWBAP3bl8KuyuHaRieh6QUr8Yp+5ciiQTtw==
X-Received: by 2002:a05:6402:4409:b0:645:d34b:8166 with SMTP id 4fb4d7f45d1cf-6496d5b03bcmr205319a12.26.1765313135942;
        Tue, 09 Dec 2025 12:45:35 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-647b2ef7798sm14501893a12.15.2025.12.09.12.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:35 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/8] scsi: Make use of bus callbacks
Date: Tue,  9 Dec 2025 21:45:03 +0100
Message-ID:  <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4030; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=Ll0IisgGOHaUv8OMzdyo5F5kYF+1d8Kt0Xt3KldsvUs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpTS0cU75kZgwyWR58Z2ElRoPN4D9BmrumEg ++rdvhs9oGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKUwAKCRCPgPtYfRL+ TnYYB/4xuSTl3znXLWb7YU4PeILH4sQ2SejQrfEPH5dscHbYYcDLvLNnKnQ1KEN056mRdZ9CMgx 27fUosOGCYxvN9/Ocj9r9eI5YO3qx74oVHaYosC/xndSDmDK2wSH+TV2g9vHIc27J41bwmtuDFe cBrTwjSnHq0xZWYso+DLZ3iHjoMsjN9Gmml2bLl9hfsreeNlJzT+IO7EzhWDlirrqciRkp+FLVl xtGQ6EdwiJSjlx6Nt+2ymcNxtyrufdbkbkdE9iMHkl/xmrGyQH827BvKhYo8SjSOzcF7zJssRhz C0r8tqzf4bLYm8iwu09ZXXQjDbfUdrnnjYnKZEgoV7VEzxBd
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
index f2d62f71c8af..343c1f9098af 100644
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
@@ -1609,6 +1647,30 @@ void scsi_remove_target(struct device *dev)
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
@@ -1616,6 +1678,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
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

