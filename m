From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ibmvfc: Increase cancel timeout
Date: Wed, 04 Feb 2009 16:13:13 -0600
Message-ID: <200902042214.n14MEhLh009606@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41964 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760775AbZBDWOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2009 17:14:45 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n14MCjZu005097
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:12:45 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n14MEiPZ191022
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:14:44 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n14MEiGT009625
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:14:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


During cancel testing it has been shown that 15 seconds is not
nearly long enough for the VIOS to respond to a cancel under
loaded situations. Increasing this timeout to 60 seconds allows
time for the VIOS to cancel the outstanding commands and prevents
us from escalating to a full host reset, which can take much longer.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_default_timeout drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_default_timeout	2009-02-04 10:46:30.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-02-04 10:46:30.000000000 -0600
@@ -32,7 +32,7 @@
 #define IBMVFC_DRIVER_VERSION		"1.0.4"
 #define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
 
-#define IBMVFC_DEFAULT_TIMEOUT	15
+#define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_INIT_TIMEOUT		120
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
_
