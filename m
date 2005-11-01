From: brking@us.ibm.com
Subject: [PATCH 24/26] ipr: Increase ipr device scanning limits
Date: Tue, 01 Nov 2005 17:02:49 -0600
Message-ID: <200511012302.jA1N2nR9019032@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49119 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751420AbVKAXCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2o1b028534
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:50 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2o5c104786
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:50 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2o0w019069
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Increase device scanning limits so that all devices are found.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_scanning_limits drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_scanning_limits	2005-10-31 21:00:37.496521504 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-31 21:00:37.500520896 -0600
@@ -98,14 +98,14 @@
 #define IPR_NUM_LOG_HCAMS				2
 #define IPR_NUM_CFG_CHG_HCAMS				2
 #define IPR_NUM_HCAMS	(IPR_NUM_LOG_HCAMS + IPR_NUM_CFG_CHG_HCAMS)
-#define IPR_MAX_NUM_TARGETS_PER_BUS			0x10
+#define IPR_MAX_NUM_TARGETS_PER_BUS			256
 #define IPR_MAX_NUM_LUNS_PER_TARGET			256
 #define IPR_MAX_NUM_VSET_LUNS_PER_TARGET	8
 #define IPR_VSET_BUS					0xff
 #define IPR_IOA_BUS						0xff
 #define IPR_IOA_TARGET					0xff
 #define IPR_IOA_LUN						0xff
-#define IPR_MAX_NUM_BUSES				4
+#define IPR_MAX_NUM_BUSES				8
 #define IPR_MAX_BUS_TO_SCAN				IPR_MAX_NUM_BUSES
 
 #define IPR_NUM_RESET_RELOAD_RETRIES		3
@@ -1326,7 +1326,7 @@ static inline int ipr_is_naca_model(stru
 static inline int ipr_is_device(struct ipr_res_addr *res_addr)
 {
 	if ((res_addr->bus < IPR_MAX_NUM_BUSES) &&
-	    (res_addr->target < IPR_MAX_NUM_TARGETS_PER_BUS))
+	    (res_addr->target < (IPR_MAX_NUM_TARGETS_PER_BUS - 1)))
 		return 1;
 
 	return 0;
_
