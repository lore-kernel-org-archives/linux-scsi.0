Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EF3192D97
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765349058; cv=none; b=sOIYAMzQfQ390l2XPDhCS4X1cf7dK/vF+NludT+tvFMeJ+pRNzPEL0m6/PJwKX3Z5Rtps81IqMJ9GE8tj7uqykPPGGI2oIcrmMw1ABhDmZey8fnuE6gwb1+0/HhCXV30shsfm9uG8jycsjKofqJ0vebJq+cV5x1+Ev1+0EFQH08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765349058; c=relaxed/simple;
	bh=pQk/VsKRZbp+0XzB+Q03dm08qGICP1U9VhcDF+Npy20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+NdhmiWvIY9OGZVIVp8QIWQZkX19Hrdh9Beh4tQl8BiUUgS1qhZbdauc4UuHDM2Y+UZb/hsOpxVFEAYZR+N2WTrsK4Dyj7C74oVn7SwwCrkgYahSBCcFbxBYPEe6wj+HteeCR7JkKIV7UI+zkE3bbR72F5kGlPHKJgACw7ypm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKpqj3+c; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKpqj3+c"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso7434108b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 22:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765349055; x=1765953855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ozbmnekjibMvdSHx2prJeHlQGN2Pdh8KnOVMCh4Km6A=;
        b=WKpqj3+cQtIZIWmugRR2VU2ibDy0OkbWQ2dtqobAma6G2hPFm5D2K2/IpQAT/bkbr4
         wih6U8Z1nWjybjzBQ2tNq+qP2d+3rQIJxaDJIrKJziA4FrO6CYtxMvkTaB0NPM6NfV/y
         A+YeswmkeqlrPYu9f1VvMTFb50ZRtoksLcDk69SeCYAF1bSO8U3hf/sZldMozKXwCKja
         +HDfIEFQtEDwgDTQB3S52VQLDc3lQhrBSkpQWegbSIhaQ5NMvI/bkwPLcGCrNpg7jvT6
         dpSXb2TxiKOKOGlyOGznXaOdYJYng6KwjUiRcETW25MO8SbdAH92Z8NcGKCt/JERCIV7
         pscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765349055; x=1765953855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozbmnekjibMvdSHx2prJeHlQGN2Pdh8KnOVMCh4Km6A=;
        b=PKwvzUxWFlz2nu1yzkOnMJcB6Pe+ubmiUZ/8H4aFCsefd6MU38cptmDrB/2s7mispI
         +O555rFbzQ8RSjCy1+Lwb3LYoYtknW8kwGrd+jnG3YaR2ASxVHW3UpWFjZndM1pHeSIe
         njbW++vPUK/gT+I76D/Ccwse+NQXT74L2doxg/NDO60VlC7V7EwwycaUwQslRxwGdGg0
         yKiknWgjgTAlffe3l/EMtNQXP/Wb8aZwX1jOv85dfgQRIl3+yGQi2L6cZ4dUWLXyx/kb
         JaEy6jdjD/NYMtG0rkI+laMWJ7iAm5F8p1VIFhbVTvgw5T/LKN6mMOPiQkNTGpvHdDvL
         oiow==
X-Gm-Message-State: AOJu0Ywjn9eagSBG8wmyndj+/Fe1m9fiR8T5KsAz+QIu29twzxV+1tAe
	3mhIIrHPzC0gqbewRnNiHI9GU3hoqbTQTLKn5Dt1EJp2pji2yAfd2cgHnZ7SSwOt5YozVA==
X-Gm-Gg: ASbGnctQR0I/bEqK/EVawTMeASZXYyXQxC+AjcWUXCO9npR9dzE9vtxZ6NWNqP4ACwx
	f3+VRgX6dCE5Ghu4DzB8UHK8U3OXeavz57xWXURXfWrIXZbgRh7W0fLMkfUT5HI+HZUrgNb2h/1
	nEZSNuQRifzja76YyiBdG2l/B5airEInZ/cwFa4G1mSW+mB3fZ2Ry7E1Qf4DoyHQZ0AlW/qqhIK
	n3NJv/myGwGLtFOWydIASJ3bgJrW+67bM8c9JcQXyduWOmYtrfQ4bkxmdife3nxtfT93v71Hnza
	5kyTcKvbQ7eNmgmPAdjVxfK9TO7DTKqc8+Vy3EkuIojmpdpTiqLbYjH6NB92AEjnIPNs6pGFPOL
	vmNUwv9IRRnGyrHFhZzBqhvs/XGmBKAA7RtQVSc6akyM8VUbNA4QqcQ/OOFWtTJjwpo8/J+IsHF
	PJvl99iSWxtF0s831uFeRKLkWRcq8q7N1xkYS5io5tFbKPJTYs+/KYMHL/c0f+q1X3Q/r0+rcIx
	vvC1234ocNaJBE=
X-Google-Smtp-Source: AGHT+IHyQ7i9W5pbU6QW4Q6VzP7t2GWGTQDbO/cfAzKSW1JR3creH/eh19Q7TPHsB8wKtgqIj1JPoQ==
X-Received: by 2002:a05:7022:688a:b0:11a:b04b:3c2e with SMTP id a92af1059eb24-11f296cdbe3mr1072556c88.29.1765349055360;
        Tue, 09 Dec 2025 22:44:15 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76edd4fsm74790466c88.8.2025.12.09.22.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 22:44:15 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH] scsi: replace trivial module_init/exit functions with module_pci_driver
Date: Tue,  9 Dec 2025 22:44:05 -0800
Message-ID: <20251210064405.27152-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several SCSI drivers unnecessarily use module_init/exit instead of
module_pci_driver. Most of these drivers also print unnecessary version
messages on load, even though their versions are accessible through
MODULE_VERSION (or sysfs, in the case of hptiop). Replace these
init/exit functions with module_pci_driver.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/3w-9xxx.c           | 18 +-----------------
 drivers/scsi/3w-sas.c            | 18 +-----------------
 drivers/scsi/3w-xxxx.c           | 18 +-----------------
 drivers/scsi/arcmsr/arcmsr_hba.c | 14 +-------------
 drivers/scsi/hptiop.c            | 15 +--------------
 drivers/scsi/nsp32.c             | 20 +-------------------
 drivers/scsi/stex.c              | 17 +----------------
 drivers/scsi/vmw_pvscsi.c        | 15 +--------------
 8 files changed, 8 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a377a6f6900a..f05ea5053ac4 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2286,20 +2286,4 @@ static struct pci_driver twa_driver = {
 	.shutdown	= twa_shutdown
 };
 
-/* This function is called on driver initialization */
-static int __init twa_init(void)
-{
-	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
-
-	return pci_register_driver(&twa_driver);
-} /* End twa_init() */
-
-/* This function is called on driver exit */
-static void __exit twa_exit(void)
-{
-	pci_unregister_driver(&twa_driver);
-} /* End twa_exit() */
-
-module_init(twa_init);
-module_exit(twa_exit);
-
+module_pci_driver(twa_driver);
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index e319be7d369c..6ad32f48c96c 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1840,20 +1840,4 @@ static struct pci_driver twl_driver = {
 	.shutdown	= twl_shutdown
 };
 
-/* This function is called on driver initialization */
-static int __init twl_init(void)
-{
-	printk(KERN_INFO "LSI 3ware SAS/SATA-RAID Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
-
-	return pci_register_driver(&twl_driver);
-} /* End twl_init() */
-
-/* This function is called on driver exit */
-static void __exit twl_exit(void)
-{
-	pci_unregister_driver(&twl_driver);
-} /* End twl_exit() */
-
-module_init(twl_init);
-module_exit(twl_exit);
-
+module_pci_driver(twl_driver);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 0306a228c702..634b0c2792ff 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2411,20 +2411,4 @@ static struct pci_driver tw_driver = {
 	.shutdown	= tw_shutdown,
 };
 
-/* This function is called on driver initialization */
-static int __init tw_init(void)
-{
-	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
-
-	return pci_register_driver(&tw_driver);
-} /* End tw_init() */
-
-/* This function is called on driver exit */
-static void __exit tw_exit(void)
-{
-	pci_unregister_driver(&tw_driver);
-} /* End tw_exit() */
-
-module_init(tw_init);
-module_exit(tw_exit);
-
+module_pci_driver(tw_driver);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f0c5a30ce51b..bcc2dd8f597f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1775,19 +1775,7 @@ static void arcmsr_shutdown(struct pci_dev *pdev)
 	arcmsr_flush_adapter_cache(acb);
 }
 
-static int __init arcmsr_module_init(void)
-{
-	int error = 0;
-	error = pci_register_driver(&arcmsr_pci_driver);
-	return error;
-}
-
-static void __exit arcmsr_module_exit(void)
-{
-	pci_unregister_driver(&arcmsr_pci_driver);
-}
-module_init(arcmsr_module_init);
-module_exit(arcmsr_module_exit);
+module_pci_driver(arcmsr_pci_driver);
 
 static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
 						u32 intmask_org)
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 21f1d9871a33..087a14bdd997 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1680,20 +1680,7 @@ static struct pci_driver hptiop_pci_driver = {
 	.shutdown   = hptiop_shutdown,
 };
 
-static int __init hptiop_module_init(void)
-{
-	printk(KERN_INFO "%s %s\n", driver_name_long, driver_ver);
-	return pci_register_driver(&hptiop_pci_driver);
-}
-
-static void __exit hptiop_module_exit(void)
-{
-	pci_unregister_driver(&hptiop_pci_driver);
-}
-
-
-module_init(hptiop_module_init);
-module_exit(hptiop_module_exit);
+module_pci_driver(hptiop_pci_driver);
 
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index abc4ce9eae74..0318e37a5f88 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -178,8 +178,6 @@ static nsp32_sync_table nsp32_sync_table_pci[] = {
 /* module entry point */
 static int nsp32_probe (struct pci_dev *, const struct pci_device_id *);
 static void nsp32_remove(struct pci_dev *);
-static int  __init init_nsp32  (void);
-static void __exit exit_nsp32  (void);
 
 /* struct struct scsi_host_template */
 static int	   nsp32_show_info   (struct seq_file *, struct Scsi_Host *);
@@ -3385,20 +3383,4 @@ static struct pci_driver nsp32_driver = {
 #endif
 };
 
-/*********************************************************************
- * Moule entry point
- */
-static int __init init_nsp32(void) {
-	nsp32_msg(KERN_INFO, "loading...");
-	return pci_register_driver(&nsp32_driver);
-}
-
-static void __exit exit_nsp32(void) {
-	nsp32_msg(KERN_INFO, "unloading...");
-	pci_unregister_driver(&nsp32_driver);
-}
-
-module_init(init_nsp32);
-module_exit(exit_nsp32);
-
-/* end */
+module_pci_driver(nsp32_driver);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 93c223e0a777..6f18c22f75c1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -2012,19 +2012,4 @@ static struct pci_driver stex_pci_driver = {
 	.resume		= stex_resume,
 };
 
-static int __init stex_init(void)
-{
-	printk(KERN_INFO DRV_NAME
-		": Promise SuperTrak EX Driver version: %s\n",
-		 ST_DRIVER_VERSION);
-
-	return pci_register_driver(&stex_pci_driver);
-}
-
-static void __exit stex_exit(void)
-{
-	pci_unregister_driver(&stex_pci_driver);
-}
-
-module_init(stex_init);
-module_exit(stex_exit);
+module_pci_driver(stex_pci_driver);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 32242d86cf5b..963279ea1c7b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1606,17 +1606,4 @@ static struct pci_driver pvscsi_pci_driver = {
 	.shutdown       = pvscsi_shutdown,
 };
 
-static int __init pvscsi_init(void)
-{
-	pr_info("%s - version %s\n",
-		PVSCSI_LINUX_DRIVER_DESC, PVSCSI_DRIVER_VERSION_STRING);
-	return pci_register_driver(&pvscsi_pci_driver);
-}
-
-static void __exit pvscsi_exit(void)
-{
-	pci_unregister_driver(&pvscsi_pci_driver);
-}
-
-module_init(pvscsi_init);
-module_exit(pvscsi_exit);
+module_pci_driver(pvscsi_pci_driver);
-- 
2.43.0

