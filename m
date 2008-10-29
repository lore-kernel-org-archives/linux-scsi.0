From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvfc: Fix log level filtering
Date: Wed, 29 Oct 2008 08:46:33 -0500
Message-ID: <200810291347.m9TDl23e008578@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45393 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbYJ2NrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 09:47:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9TDl4CJ001358
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDl4qN131468
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDl3bJ008637
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc log level filtering logic was reversed. The log_level scsi host parameter
should result in more verbose logs when log_level is larger, not smaller.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_log_level_fix drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_log_level_fix	2008-08-18 09:11:53.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-08-18 09:12:53.000000000 -0500
@@ -700,7 +700,7 @@ struct ibmvfc_host {
 
 #define ibmvfc_log(vhost, level, ...) \
 	do { \
-		if (level >= (vhost)->log_level) \
+		if ((vhost)->log_level >= level) \
 			dev_err((vhost)->dev, ##__VA_ARGS__); \
 	} while (0)
 
_
