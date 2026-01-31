Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61636315760
	for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 00:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769820933; cv=none; b=cI6rPQQ8Ux+tNcnPugW5ZczLiPCyXh1m6hjv1KwKf1jKTr1Zdkcix6ug2BBvnM17jMyR3jbr9zBrxdrsIy4F8VwsuWYZ8BOiLo/mXcLmaLqOInqCGrGSe8xqL3DZs41xZhnS6mLLJXVnT6MolEaY9OEhZStMUJr1ElzzEodESTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769820933; c=relaxed/simple;
	bh=XlkH1cga0z8Tq+Thox7+uBGxxgsQg/KxvySlmT4xdMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uO7jIvg3EaZBDud64uCxq5ywhAz8sc16ggAoF9XLDlmZIw+Wcng4dLb4Yb/IeExEOqUEMNa9tFNHrGj6RSETilz6Zaq2sfVOv1nMcIUpEMZ4dUBnx6GYc6UA9JymQQqoC+eCSzFX4cWEFH7ABc9zu8D68q8nPTa+Gqv2+N51Wxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/jyMd/a; arc=none smtp.client-ip=74.125.82.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/jyMd/a"
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b7c5db431cso2392198eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 16:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769820931; x=1770425731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yS1rSvP2SMf5vlSPGq4rWgJRSthqe7LzK20dwh/O6Tk=;
        b=k/jyMd/an3fKmtdACYM+hcdkqzw3oTdigxJ9X+m6ZvPzUG2KGTNulzjHJp1ZzkjTVr
         aUORLlY0TgtvQUSRq6qilvG8bybl/f9HHhf+7fiGi2gLhUZCVETSn4TkKLPNxTc1APDi
         t+PTxJ6MRWCCXygOF5uiREafXDerjb1EvddNcuNhvkDCYW/jIhMi9D456r2sup2Gls2U
         yd9y//1CtexjZzAbeXrR4UoFmkPdlFLMCoMTt38nreMfI4vTww6fdBLnpdORLhRjU0LC
         RMcVqtiyUMI1lkk2vgjsT1bCLk6sO+QfpJjR0CsS5EVk6RPcG7Zjv3h6O6WtXeltKCT5
         w/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769820931; x=1770425731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yS1rSvP2SMf5vlSPGq4rWgJRSthqe7LzK20dwh/O6Tk=;
        b=oi8SIUqmMZKl5C92dSOB7XfH3F/pGhFFi/F6c6zO3lBVE10eTn43pcPeZMXcU6GvMo
         uTdjoUo3yBZ2uA/IrPzZjvmrSKJ4NWsUO5e3UdELupJ2HmXuKZagfuzjOxVBgUn6peWU
         3qVQH+C/lNOc+JuJ0vcAEqeuFMIOkFU/tgI4Jp5tSgX6z1NQ5S+dHSdCfNzVmI1ensQc
         xis6qML9ol22cgGvswK0V2myIH/7cB6/no//8KAKS+3RE40gVpKkZg5b4RoNfgNr1kdL
         yCkcpy6LSEEXQOaKLFSxcy98YTXDROft3bWNvPH8EGrgRYjBXso8THKTaBaxK9bpy1Ik
         3pnA==
X-Gm-Message-State: AOJu0Ywi4MJoNmkk3omKxhYwBSjobdyMtI4quPU3wHXF3hdTtv7zOeSR
	3YuMqIy76fiT2cChYI0uDWcu3D3Z0CAMPqkdTyL1jNUiStUHkFC0uFWC85Rpnicx
X-Gm-Gg: AZuq6aJJJVX06/0ulFcsxaKrM4gNrtgUJDA6GE4ZY4Qpnf+FZrOG5cYYUm0wQHBKl8U
	dNgFMiY/0Zg4+M9DjXAuTVv5T9biKUiBlSR28J7zmEU9niupnqBDQuDwhKxgXph++lm0hv9bzBt
	B0PTYgJDFLNW6GB5q+/pY6RbV3qKC705Q6rPHSFp4ef5fW3uwqEcgNMHzX/J/qEvmBhTJfZpuZz
	VVhZgURPThbumxiVYSfGFiKiGiaWNZh8g6KRvBMTQ0NiN/enzhLO/Ha6n6uv2SHFEnchV0Q5MiS
	54UaNlnnSW3IyIF8RayG6mCq/Gb5o15mKC/Tem+/200FptDHRGK5yNNyDo+oYtwurdkx4ljxQip
	ptrPiLtYTxNXbjU1r0u7VgfZoCfcu307KIC5Jidcgd13TxGZDA/DynlTZZvq0sioP9seQpwtlvl
	y6hSEcot67XIwYfqxYxGuqXVDUhtF773oLY68P6+vZL++DlsmNoFLNdbkqRiE1kBBj/75mWim/I
	+763N3TiwwotkzmBQT0bZ+/28z0iq1zE2GBAy3/4SoWDQ09OuGIFANOQ5/pB5ITRAoA1XGMhEo3
	gqsYnb+7NEb/1d0=
X-Received: by 2002:a05:7301:fa86:b0:2b7:2fff:ed30 with SMTP id 5a478bee46e88-2b7c88ea1a4mr2508884eec.20.1769820931314;
        Fri, 30 Jan 2026 16:55:31 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cfc73sm13371049eec.6.2026.01.30.16.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 16:55:31 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jens Axboe <axboe@kernel.dk>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] scsi: replace trivial module_init/exit functions with module_pci_driver
Date: Fri, 30 Jan 2026 16:55:14 -0800
Message-ID: <20260131005522.21122-1-enelsonmoore@gmail.com>
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
Changes in v2:
Rebase on latest mainline tree
CC maintainers

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

