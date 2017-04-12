From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 12/17] cxlflash: Fix power-of-two validations
Date: Wed, 12 Apr 2017 14:15:11 -0500
Message-ID: <1492024511-56065-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42265 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752401AbdDLTP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98Xl079657
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:27 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29snvj59jc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:27 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:15:25 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Validation statements to enforce assumptions about specific defines
are not being evaluated by the compiler due to the fact that they
reside in a routine that is not used. To activate them, call the
routine as part of module initialization. As an additional, related
cleanup, remove the now-defunct CXLFLASH_NUM_CMDS.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 7 +------
 drivers/scsi/cxlflash/main.c   | 1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 17aa74a..455fd4d 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -52,12 +52,6 @@ extern const struct file_operations cxlflash_cxl_fops;
 				   certain AFU errors */
 
 /* Command management definitions */
-#define CXLFLASH_NUM_CMDS	(2 * CXLFLASH_MAX_CMDS)	/* Must be a pow2 for
-							   alignment and more
-							   efficient array
-							   index derivation
-							 */
-
 #define CXLFLASH_MAX_CMDS               256
 #define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
 
@@ -71,6 +65,7 @@ extern const struct file_operations cxlflash_cxl_fops;
 static inline void check_sizes(void)
 {
 	BUILD_BUG_ON_NOT_POWER_OF_2(CXLFLASH_NUM_FC_PORTS_PER_BANK);
+	BUILD_BUG_ON_NOT_POWER_OF_2(CXLFLASH_MAX_CMDS);
 }
 
 /* AFU defines a fixed size of 4K for command buffers (borrow 4K page define) */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3c4a833..f5c952c 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2847,6 +2847,7 @@ static struct pci_driver cxlflash_driver = {
  */
 static int __init init_cxlflash(void)
 {
+	check_sizes();
 	cxlflash_list_init();
 
 	return pci_register_driver(&cxlflash_driver);
-- 
2.1.0
