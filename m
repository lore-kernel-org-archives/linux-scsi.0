From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/21] advansys: version, copyright, etc
Date: Thu, 26 Jul 2007 13:22:38 -0400
Message-ID: <11854705771114-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:37521 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874AbXGZSbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:31:21 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Update the version to 3.4
Add my copyright
Add myself to MAINTAINERS
Exercise my right to change the license from dual BSD/GPL to GPL
Don't force the definition of CONFIG_ISA on x86
Always include pci.h
Stop including stat.h
---
 MAINTAINERS             |    6 ++++++
 drivers/scsi/advansys.c |   43 +++++++++++++++++++------------------------
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 01f222e..11003c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -282,6 +282,12 @@ P:	Colin Leroy
 M:	colin@colino.net
 S:	Maintained
 
+ADVANSYS SCSI DRIVER
+P:	Matthew Wilcox
+M:	matthew@wil.cx
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+
 AEDSP16 DRIVER
 P:	Riccardo Facchetti
 M:	fizban@tin.it
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index bfa1ffc..a0bad3b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1,20 +1,23 @@
-#define ASC_VERSION "3.3K"	/* AdvanSys Driver Version */
+#define ASC_VERSION "3.4"	/* AdvanSys Driver Version */
 
 /*
  * advansys.c - Linux Host Driver for AdvanSys SCSI Adapters
  *
  * Copyright (c) 1995-2000 Advanced System Products, Inc.
  * Copyright (c) 2000-2001 ConnectCom Solutions, Inc.
+ * Copyright (c) 2007 Matthew Wilcox <matthew@wil.cx>
  * All Rights Reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that redistributions of source
- * code retain the above copyright notice and this comment without
- * modification.
- *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
  * As of March 8, 2000 Advanced System Products, Inc. (AdvanSys)
  * changed its name to ConnectCom Solutions, Inc.
- *
+ * On June 18, 2001 Initio Corp. acquired ConnectCom's SCSI assets
  */
 
 /*
@@ -755,11 +758,6 @@
  */
 
 #include <linux/module.h>
-
-#if defined(CONFIG_X86) && !defined(CONFIG_ISA)
-#define CONFIG_ISA
-#endif /* CONFIG_X86 && !CONFIG_ISA */
-
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -771,7 +769,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <linux/stat.h>
+#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 
@@ -779,6 +777,12 @@
 #include <asm/system.h>
 #include <asm/dma.h>
 
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+
 /* FIXME: (by jejb@steeleye.com) This warning is present for two
  * reasons:
  *
@@ -793,15 +797,6 @@
  */
 #warning this driver is still not properly converted to the DMA API
 
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
-#endif /* CONFIG_PCI */
-
 /*
  * --- Driver Options
  */
@@ -17760,8 +17755,6 @@ static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	}
 }
 
-MODULE_LICENSE("Dual BSD/GPL");
-
 static struct Scsi_Host *__devinit
 advansys_board_found(int iop, struct device *dev, int bus_type)
 {
@@ -19017,3 +19010,5 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
 #endif /* CONFIG_PCI */
+
+MODULE_LICENSE("GPL");
-- 
1.4.4.4

