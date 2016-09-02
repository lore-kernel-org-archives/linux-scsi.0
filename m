From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/6] cxlflash: Scan host only after the port is ready for I/O
Date: Fri,  2 Sep 2016 15:38:48 -0500
Message-ID: <1472848728-64961-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47873 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751699AbcIBUjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 16:39:24 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82KXFP8057906
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 16:39:16 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2575vwydf4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2016 16:39:15 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 2 Sep 2016 16:39:15 -0400
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

When a port link is established, the AFU sends a 'link up' interrupt.
After the link is up, corresponding initialization steps are performed
on the card. Following that, when the card is ready for I/O, the AFU
sends 'login succeeded' interrupt. Today, cxlflash invokes
scsi_scan_host() upon receipt of both interrupts.

SCSI commands sent to the port prior to the 'login succeeded' interrupt
will fail with 'port not available' error. This is not desirable.
Moreover, when async_scan is active for the host, subsequent scan calls
are terminated with error. Due to this, the scsi_scan_host() call
performed after 'login succeeded' interrupt could portentially return
error and the devices may not be scanned properly.

To avoid this problem, scsi_scan_host() should be called only after the
'login succeeded' interrupt.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 661bb94..b063c41 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1187,7 +1187,7 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC0_LOGI_F, "login failed", 0, CLR_FC_ERROR},
 	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, SCAN_HOST},
 	{SISL_ASTATUS_FC0_LINK_DN, "link down", 0, 0},
-	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, SCAN_HOST},
+	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, 0},
 	{SISL_ASTATUS_FC1_OTHER, "other error", 1, CLR_FC_ERROR | LINK_RESET},
 	{SISL_ASTATUS_FC1_LOGO, "target initiated LOGO", 1, 0},
 	{SISL_ASTATUS_FC1_CRC_T, "CRC threshold exceeded", 1, LINK_RESET},
@@ -1195,7 +1195,7 @@ static const struct asyc_intr_info ainfo[] = {
 	{SISL_ASTATUS_FC1_LOGI_F, "login failed", 1, CLR_FC_ERROR},
 	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, SCAN_HOST},
 	{SISL_ASTATUS_FC1_LINK_DN, "link down", 1, 0},
-	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, SCAN_HOST},
+	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, 0},
 	{0x0, "", 0, 0}		/* terminator */
 };
 
-- 
2.1.0

