Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0BA2C3252
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136368; cv=none; b=d6kANvDaTNgvgiIyhtFrKquog1rmyv8miwSu+aTB9KdaN+tDkHwkdokswOppx1sCm+5SF9lFe23F8r6W69zCaSpCCXWj96Su2DJ5UOiB5smLLDPZW8VtDm3QwsFgsq6jGTnOJW2hSQl8+/v951t0MwnU5Qn0jMGie/fqt+RdxTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136368; c=relaxed/simple;
	bh=xXNyc3XdzurEAz26qjxcttkpA50IJuXe67qdD2JoMBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JaBk7Ob4BFGo9ie80PrXgAOoOmLLmeao0ybpymyIRDsILErI04Z4g+jGVgSGOCSJv5c9flzbx2U2cgx6B22zGYhK3ipfL9hdnI9rGTEdjCHeGxIx2bRLqA0g40UMuAEyVuM9ZHyUGo/0uR42IvHVI4ggTgxlAtXF/J7z7b+HB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=kcqAn6VC; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="kcqAn6VC"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-42fbc305552so1140674f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136362; x=1766741162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8ApLgs+X4uwexjDkbhSVI2nnBcgdKLGB9tRGEOIKFA=;
        b=kcqAn6VCKkAWSolN/9wXWFxaLd6qfzH81lu2qT2crzusfTeOTE/hmaDJ++QVKoxo5q
         f2Eq8tB4+AfNUevtMkjgHPwUXEjtvKPjQ/DSta2T1n3nH8v3cMx+EwIV5uAo80EMtPKc
         PSe2V+tcc076a8wfOHRcuSx1jcfO/EZTN+pV1sda2CW/dzxUfWyMWCa+CgxyoO8mQw1k
         c/KV96Bq7v2h/KMj0QcBgH2uQVoGR8fBFzkAoTR5bOK4NU6w3O/PMqYs8wZx3IBd7uz5
         qDrlv121n5HnokFTc0prebXhz0W4CQ+kSVdsMzdTLMUWU7AJ0dXsNgnNTE0vEMMpgIf1
         /iLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136362; x=1766741162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u8ApLgs+X4uwexjDkbhSVI2nnBcgdKLGB9tRGEOIKFA=;
        b=Pz+1EkWCSk8gIZ0K1mhTDqO5zn4fbvbFZt7GuIitegCYdM1js93OHBMQbfyU3AGVIV
         tzwxAYbN2HIFHginJc2pZp+4cSG8V63e6wu+a8QjXIFrZ2QFurzdyYT+k4e7PHtBO9vr
         vUtvLHFw9Y713Y8+jvWktenTCm16/EfMCuQJLbbKv1G7kOY8vwLjhMgcstq2XUCOeEhT
         ROU+6Wrm/RGmuCsOwquCSatdeqJ6qP6Fl9Ec7b0UnlXaOdnE2AgGY3vOsYNjz/fU0Cji
         SfMxjje9E/Y1CaE/Vy4Ba3oD51KvLcSVX+WLG2xCWaJM+rci+FXWCqBY7i1g7pWYF1Xv
         /smg==
X-Forwarded-Encrypted: i=1; AJvYcCWeneqyi2nzKYE9zZoYtonCYck3HOKQsLPQToMNCumbCqOhyRHn5HN0Io+Eiu0J7FYHih72XKIBTWrA@vger.kernel.org
X-Gm-Message-State: AOJu0YwjV76DEI38yNl8ncE6YjY/co4Mj5tVzD+Li6IKXLB4wJZiWg6c
	fRHWxe7w802p/eBAtEIPeMWd9dHjyGmSTvl/EY/S8GaFJLMlt6ZCAwjqvJMYgj/yV00=
X-Gm-Gg: AY/fxX6eCTcJu9rKthO6YPcVKXwzg0ZLIkJBmytNedJwyvxC3opouMy0F0UyfRB9aPZ
	l4vh7KyVpkoz83wx7iTzmX1wbj4+iZU4FTNWlJvj2FM8XMqMLLcbd61VIDdFgDVhzSCpRdWyeN4
	uU4GffGmqKRzMRaVsgtYvXorTiwCoF/6wYKAZM44oCqZ6a0ehO8/uV6r1FA8afsIsjk0LCrRq8w
	CsnCieN7/WEtow/uRVHv7zR8BdIlsq10Mp1Wcn/eXVXr0nOOFVbWC39LcNJyrPS7zZg6P/FOmVh
	e0Oat48S8dWHA9HJconzq5tBMwZkNbwFcaJkdt92SJoPZPRsFAsjnXxcVv24qCN1q/uzNDiP2mD
	/3UdBWWjYPqLmdgmwm7mWa1hxssY27IcnlKxW4Mq+SzVvwCr/wpmSfOV9f1aSCQkJwxZONCAUQ+
	TO0xZYykpwD4xD3TegVnUP/Ua8jAlFfjrZboid94usGvQajuQfxELvE/EI0bTHqkfKdvz1ju19e
	GE=
X-Google-Smtp-Source: AGHT+IFQAhNkTc5ytTmFQoCzq2kpBrhbdcL15ws/0mD1lOKgcviKWNLj2gB606Fsbvncghm2MouC2Q==
X-Received: by 2002:a05:6000:2303:b0:431:342:ad42 with SMTP id ffacd0b85a97d-4324e50d6d7mr2259085f8f.44.1766136361832;
        Fri, 19 Dec 2025 01:26:01 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4324ea1b36fsm3863039f8f.5.2025.12.19.01.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:01 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	=?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 1/8] scsi: Pass a struct scsi_driver to scsi_{,un}register_driver()
Date: Fri, 19 Dec 2025 10:25:30 +0100
Message-ID:  <ac17fdea58e384cb514c639306d48ce0005820b0.1766133330.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5857; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=xXNyc3XdzurEAz26qjxcttkpA50IJuXe67qdD2JoMBo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoQ+rKmIl8VKZbGhEIWm8TteCPYl12ira9TX AoE/6RTArmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaEAAKCRCPgPtYfRL+ ThtBB/9ayMulPqjTlc0DszWoahuw67pfRGpc5vOLZsOtqHOXKA+kV0Lp72EO8zO686wO6j0wWde m2bV6qMC3NOc7Jp+9CB1NP5/rHr4SVg7D7B2Noa2+iS9nfJbaGHElNzsGFYq19/MkhsPY/wYWP9 9ngozQjFmjsQ/KKoCwxUGLWfAab7akqvGq2MftWRJ7DNMtAtsXRPWqz3GM8WM7WnaTtBg9gpFxV jXRGPpKCiyIWZcon5w+6sz7ouPRfeoOi10rqvjdsMOK9Uyr6IgTaaffaJEey2STBM+L32/iOSe4 SF76ectDaaQAIkTcpXVIwhEWJCjJCllTtHLvLIO2l2xcUHC8
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

This aligns with what other subsystems do, reduces boilerplate a bit for
device drivers and is less error prone.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/ch.c          | 4 ++--
 drivers/scsi/scsi_sysfs.c  | 4 +++-
 drivers/scsi/sd.c          | 4 ++--
 drivers/scsi/ses.c         | 4 ++--
 drivers/scsi/sr.c          | 4 ++--
 drivers/scsi/st.c          | 4 ++--
 drivers/ufs/core/ufshcd.c  | 4 ++--
 include/scsi/scsi_driver.h | 4 ++--
 8 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fa07a6f54003..f2b63e4b9b99 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -1014,7 +1014,7 @@ static int __init init_ch_module(void)
 		       SCSI_CHANGER_MAJOR);
 		goto fail1;
 	}
-	rc = scsi_register_driver(&ch_template.gendrv);
+	rc = scsi_register_driver(&ch_template);
 	if (rc < 0)
 		goto fail2;
 	return 0;
@@ -1028,7 +1028,7 @@ static int __init init_ch_module(void)
 
 static void __exit exit_ch_module(void)
 {
-	scsi_unregister_driver(&ch_template.gendrv);
+	scsi_unregister_driver(&ch_template);
 	unregister_chrdev(SCSI_CHANGER_MAJOR, "ch");
 	class_unregister(&ch_sysfs_class);
 	idr_destroy(&ch_index_idr);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 99eb0a30df61..db0ba68f2e6e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1554,8 +1554,10 @@ void scsi_remove_target(struct device *dev)
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
-int __scsi_register_driver(struct device_driver *drv, struct module *owner)
+int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 {
+	struct device_driver *drv = &sdrv->gendrv;
+
 	drv->bus = &scsi_bus_type;
 	drv->owner = owner;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f50b92e63201..6ea6ee2830a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4417,7 +4417,7 @@ static int __init init_sd(void)
 		goto err_out_class;
 	}
 
-	err = scsi_register_driver(&sd_template.gendrv);
+	err = scsi_register_driver(&sd_template);
 	if (err)
 		goto err_out_driver;
 
@@ -4444,7 +4444,7 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
-	scsi_unregister_driver(&sd_template.gendrv);
+	scsi_unregister_driver(&sd_template);
 	mempool_destroy(sd_page_pool);
 
 	class_unregister(&sd_disk_class);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2c61624cb4b0..f8f5164f3de2 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -921,7 +921,7 @@ static int __init ses_init(void)
 	if (err)
 		return err;
 
-	err = scsi_register_driver(&ses_template.gendrv);
+	err = scsi_register_driver(&ses_template);
 	if (err)
 		goto out_unreg;
 
@@ -934,7 +934,7 @@ static int __init ses_init(void)
 
 static void __exit ses_exit(void)
 {
-	scsi_unregister_driver(&ses_template.gendrv);
+	scsi_unregister_driver(&ses_template);
 	scsi_unregister_interface(&ses_interface);
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index add13e306898..2f6bb6355186 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -1001,7 +1001,7 @@ static int __init init_sr(void)
 	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
 	if (rc)
 		return rc;
-	rc = scsi_register_driver(&sr_template.gendrv);
+	rc = scsi_register_driver(&sr_template);
 	if (rc)
 		unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 
@@ -1010,7 +1010,7 @@ static int __init init_sr(void)
 
 static void __exit exit_sr(void)
 {
-	scsi_unregister_driver(&sr_template.gendrv);
+	scsi_unregister_driver(&sr_template);
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 168f25e4aaa3..45622cfce926 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4576,7 +4576,7 @@ static int __init init_st(void)
 		goto err_class;
 	}
 
-	err = scsi_register_driver(&st_template.gendrv);
+	err = scsi_register_driver(&st_template);
 	if (err)
 		goto err_chrdev;
 
@@ -4592,7 +4592,7 @@ static int __init init_st(void)
 
 static void __exit exit_st(void)
 {
-	scsi_unregister_driver(&st_template.gendrv);
+	scsi_unregister_driver(&st_template);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
 	class_unregister(&st_sysfs_class);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 80c0b49f30b0..da1e89e95d07 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11240,7 +11240,7 @@ static int __init ufshcd_core_init(void)
 
 	ufs_debugfs_init();
 
-	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
+	ret = scsi_register_driver(&ufs_dev_wlun_template);
 	if (ret)
 		ufs_debugfs_exit();
 	return ret;
@@ -11249,7 +11249,7 @@ static int __init ufshcd_core_init(void)
 static void __exit ufshcd_core_exit(void)
 {
 	ufs_debugfs_exit();
-	scsi_unregister_driver(&ufs_dev_wlun_template.gendrv);
+	scsi_unregister_driver(&ufs_dev_wlun_template);
 }
 
 module_init(ufshcd_core_init);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index c0e89996bdb3..40aba9a9349a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -25,9 +25,9 @@ struct scsi_driver {
 
 #define scsi_register_driver(drv) \
 	__scsi_register_driver(drv, THIS_MODULE)
-int __scsi_register_driver(struct device_driver *, struct module *);
+int __scsi_register_driver(struct scsi_driver *, struct module *);
 #define scsi_unregister_driver(drv) \
-	driver_unregister(drv);
+	driver_unregister(&(drv)->gendrv);
 
 extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
-- 
2.47.3

