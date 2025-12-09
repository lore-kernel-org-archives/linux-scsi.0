Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229078F2E
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313138; cv=none; b=gHCxdBPK1ghfHL/o6RVWmSiiztqvSi6EWaVoC4ntrGgX2b+6/KmLSS2nyJd6D55aJtGxeIR9AJWmPxS8XhgcpIDaoaD42ORjHT+Vhejg5weSeMvY47HrtLA7X2gXZooMjQoZfmVeJE5qPhMTUrEsATKoK+QhK+GGb1Kafna3bxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313138; c=relaxed/simple;
	bh=8ITVtD6b3F2/I6+ZZmbk9o5De0dNCAQt6Fff7c8O8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSKdxq93cXlmFbA5DNQsoeLoeit9IkoL0PhyqnOSuujB9N+zKQzPLQRpt7suCb98PksTnbHy3bjBCHvM7iZjrx0HPslBJOpfhs8JJuIW46/5skbavwHzmy1dVxYPv1OIpF52N51VDNrZElziRTBOXJtCC6WZnG5liHWalrPpXPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=YDqMfJu8; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="YDqMfJu8"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b79d0a0537bso789535966b.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313134; x=1765917934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehOBmkSeEu9fXlQsC2PZTBXPFrzi4V5GiclZoBp6GCw=;
        b=YDqMfJu85/YRdOF+yPMqr4kVHNt40ZSiKvxfVHGyibkbrwbydyxjWdWSNexW+I1nza
         zc++S5gC4Izr2CU9B5V6jx5YxsZaQaGphJD9mCSpkBGJE57DS+bBsqSFjpx3igehXTU+
         Dvs8tflcy+TfTKgaciW7EY1BXcIdyklVcReRe0/qctJ5S0gISTL2kMiaZPsiaqH8md/6
         IeqwAfVSJvs+T9VKPzqFCCkXSXNKH86e0U+hYOvFX7rI6oqd/T+0wp39Xr7SknyPVdnS
         XMpeN8NbsJl37cA+IAFxmX60bsMCRS1wO9pgPbKwAv0Xm71pxnLoOKwOQlEY1aTz7H8F
         Kx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313134; x=1765917934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehOBmkSeEu9fXlQsC2PZTBXPFrzi4V5GiclZoBp6GCw=;
        b=vxb93HyHgTlIOOR/RrDOTO2ATOyWbPxCGDAWQTcgSjzq3uwGdPuFaUMP7nTnCXkUSl
         tbVqtWnZV2OdxDxlrdZc9cxqX1yySRhrSbk/YiIX5b8/WYHsJFSFPEiY8t3qGfw4Ion9
         KgTt4j6Sz8gCxpVLethYiCYJEAgzAhYtlyUlrDddFo/np+cOiY2xDVj2I5lsYL7UyB43
         dkyIgChos5XhSxAsGeJo/NwGGR2BnLlPgPn/QqOBch7o+752LzMJFFLk0hX1Hrn6HPjd
         Rg5ou//ymkJWhFii4+u1+epm4PbC00FORGRzCWlSFHo/KCz71Ag/u461TlBZu9+qq8F6
         3DeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUosBM8mBoefuv8/oP1RfKuYe5f/Yk22SCc6KESs3V+e2GHMSxBSc//3VljOuoC5Ul7JB0mTiaeNPsY@vger.kernel.org
X-Gm-Message-State: AOJu0YzAFN9jMhoyreTRXUJoCHL3Mw0flTZrrBuhIWakpIU3sMLTIAj9
	4IOrCeSu/idU6m35z3t812fHU3MvBJSaqBmhxtov77uaXU5eEhAQEkPKPF2bqxmKHZg=
X-Gm-Gg: ASbGncs7QUu6/U/+aZz3FbXRGJOdKZ+sKmEqdHaSHSInqoSOIxjup8MXf+vojfNHmCX
	5yKK1kfVAQcHLm5bb6pFSBZiKRrF2yp/bbtdjW95ggc+xkG9I3A0hDtmfW9e/TqyJrJGBCFFdhZ
	F5eUsLCSqHpXYobeN+KvmVpACqpOC7SAh8R1L+yzf7mJMZUeHfImYrrizhGuzipzIh4tYXTrOxo
	/XpkAMZMNdPAMiUQbObk6lAMneg5UD//+t7Tbo99nRjnTvBVls10nTUnx/RMJTiLZE/WGRnShaZ
	Cl2cFsyOS/zcaD5hhYMBkzR8P+BTFS/NEy+d+2eOS/njZPKytq2sDm4WfeU22CNl2KEwXSc6TjK
	PhvcfziLpmpmGl1lZJgi2WUavLheRDOrpB+R+1h2hLH8Kyfgj3pyMj8PZTsVWJoVjR8lzkmLC2x
	oMUgZ8N8j2ZfMvZ8/LZX8lD3eZMwQ=
X-Google-Smtp-Source: AGHT+IFzkjZPzxPlnS6Ow6hz4zSS41oEGkCfVA/Re/iCz/umJKEWAXSWKmimuVnJLpL0yI49Gbq+rA==
X-Received: by 2002:a17:907:1c8e:b0:b77:1bcf:5a85 with SMTP id a640c23a62f3a-b7a247f3fd9mr1303023466b.39.1765313134324;
        Tue, 09 Dec 2025 12:45:34 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f497674asm1460509666b.38.2025.12.09.12.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:33 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	=?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/8] scsi: Pass a struct scsi_driver to scsi_{,un}register_driver()
Date: Tue,  9 Dec 2025 21:45:02 +0100
Message-ID:  <a63b9f2a4f03499a9350ab19ded785e9da226752.1765312062.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5806; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=8ITVtD6b3F2/I6+ZZmbk9o5De0dNCAQt6Fff7c8O8EI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpRvxz7E1+9H7LuyDas8hhcxXoadiVjvhfNf 1eINFQViHWJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKUQAKCRCPgPtYfRL+ Tt/gCACwvjLgKBO5RvCfgdisFzvHo9SPUzR3mqkysdEjUNdydfI6PfHb3Mho16ZIge69Myg06rc KyyhxH2Y6o0Kr18AMDbNWdB9iqtnaUIPwZD3bVPErtfGCqRNbDS+BzMFX2cNFw4xa9ERFJ9jVyD AacLeQ30fgUXf6z9XBNzbVJdu8ijdNKA0MQb3hTodXBkHYCm7S6YLzqhNrk3i0LCjCY9SCX7w6l kSSx5pdGC9oPDivW2nJoMf0WUq7INiGua3/zKZaQF36VT5+PD04XG5yc/ZhdS+7cmCzL4Um7mJa r/nUPg1rBkqMaEpGfc7MOWKqC9awY5FgtoOh1tp3aK9Aznx9
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

This aligns with what other subsystems do, reduces boilerplate a bit for
device drivers and is less error prone.

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
index 15ba493d2138..f2d62f71c8af 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1609,8 +1609,10 @@ void scsi_remove_target(struct device *dev)
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
index 0252d3f6bed1..da927c030ecc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4375,7 +4375,7 @@ static int __init init_sd(void)
 		goto err_out_class;
 	}
 
-	err = scsi_register_driver(&sd_template.gendrv);
+	err = scsi_register_driver(&sd_template);
 	if (err)
 		goto err_out_driver;
 
@@ -4402,7 +4402,7 @@ static void __exit exit_sd(void)
 
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
index 74a6830b7ed8..83140b60f3fb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4533,7 +4533,7 @@ static int __init init_st(void)
 		goto err_class;
 	}
 
-	err = scsi_register_driver(&st_template.gendrv);
+	err = scsi_register_driver(&st_template);
 	if (err)
 		goto err_chrdev;
 
@@ -4549,7 +4549,7 @@ static int __init init_st(void)
 
 static void __exit exit_st(void)
 {
-	scsi_unregister_driver(&st_template.gendrv);
+	scsi_unregister_driver(&st_template);
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
 	class_unregister(&st_sysfs_class);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6a060a72461..98a3aec81ade 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -11088,7 +11088,7 @@ static int __init ufshcd_core_init(void)
 
 	ufs_debugfs_init();
 
-	ret = scsi_register_driver(&ufs_dev_wlun_template.gendrv);
+	ret = scsi_register_driver(&ufs_dev_wlun_template);
 	if (ret)
 		ufs_debugfs_exit();
 	return ret;
@@ -11097,7 +11097,7 @@ static int __init ufshcd_core_init(void)
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

