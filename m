From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/3] cxlflash: Add device dependent flags
Date: Wed, 15 Jun 2016 18:49:38 -0500
Message-ID: <1466034578-17914-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38191 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbcFOXtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:49:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNmkNw077920
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:49:51 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgpf7y6v-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:49:51 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 17:49:50 -0600
In-Reply-To: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Device dependent flags are needed to support functions that are
specific to a particular device.

One such case is - some CXL Flash cards need to be notified of
device shutdown. For other CXL devices, this feature does not prove
to be useful yet. Such distinct features need to be identified in
the driver to bypass or invoke specific functionality.

In this patch, a member 'flags' has been added to device dependent
values. These flags will be used and expanded in the future to
support various device specific functions.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 6 ++++--
 drivers/scsi/cxlflash/main.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index f1f977f..e027fa0 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2333,8 +2333,10 @@ static struct scsi_host_template driver_template = {
 /*
  * Device dependent values
  */
-static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS };
-static struct dev_dependent_vals dev_flash_gt_vals = { CXLFLASH_MAX_SECTORS };
+static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS,
+					0ULL };
+static struct dev_dependent_vals dev_flash_gt_vals = { CXLFLASH_MAX_SECTORS,
+					0ULL };
 
 /*
  * PCI device binding table
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index eb9d8f7..029f517 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -88,6 +88,7 @@ enum undo_level {
 
 struct dev_dependent_vals {
 	u64 max_sectors;
+	u64 flags;
 };
 
 struct asyc_intr_info {
-- 
2.1.0

