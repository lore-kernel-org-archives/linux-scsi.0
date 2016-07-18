From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: [PATCH v2] cxl: remove dead Kconfig options
Date: Mon, 18 Jul 2016 14:52:57 +1000
Message-ID: <1468817577-1843-1-git-send-email-andrew.donnellan@au1.ibm.com>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50520 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbcGRExM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jul 2016 00:53:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6I4nJNN017548
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 00:53:11 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24826y8tnh-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 00:53:11 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Mon, 18 Jul 2016 14:53:09 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 6584F2CE802D
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:53:07 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6I4r7lC24444956
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:53:07 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6I4r6WB024506
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:53:07 +1000
In-Reply-To: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: clombard@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, mrochs@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, imunsie@au1.ibm.com

Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they were only
needed to coordinate the merging of the cxlflash driver. Also remove the
stub implementation of cxl_perst_reloads_same_image() in cxlflash which is
only used if CXL_EEH isn't defined (i.e. never).

Suggested-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

---

Applies on top of powerpc#next, now that the Mellanox CX-4 patches have
been applied.
---
 drivers/misc/cxl/Kconfig     | 10 ----------
 drivers/scsi/cxlflash/main.h |  4 ----
 2 files changed, 14 deletions(-)

diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
index 8d76770..b75cf83 100644
--- a/drivers/misc/cxl/Kconfig
+++ b/drivers/misc/cxl/Kconfig
@@ -7,14 +7,6 @@ config CXL_BASE
 	default n
 	select PPC_COPRO_BASE
 
-config CXL_KERNEL_API
-	bool
-	default n
-
-config CXL_EEH
-	bool
-	default n
-
 config CXL_AFU_DRIVER_OPS
 	bool
 	default n
@@ -23,8 +15,6 @@ config CXL
 	tristate "Support for IBM Coherent Accelerators (CXL)"
 	depends on PPC_POWERNV && PCI_MSI && EEH
 	select CXL_BASE
-	select CXL_KERNEL_API
-	select CXL_EEH
 	select CXL_AFU_DRIVER_OPS
 	default m
 	help
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index eb9d8f7..a893408 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -100,8 +100,4 @@ struct asyc_intr_info {
 #define SCAN_HOST	0x04
 };
 
-#ifndef CONFIG_CXL_EEH
-#define cxl_perst_reloads_same_image(_a, _b) do { } while (0)
-#endif
-
 #endif /* _CXLFLASH_MAIN_H */
-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

