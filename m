From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Improve async event handling
Date: Thu, 18 Dec 2008 09:26:51 -0600
Message-ID: <200812181628.mBIGS3CQ013344@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57388 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYLRP2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 10:28:02 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mBIFRDtr005791
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2008 10:27:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBIFS1HF135368
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2008 10:28:01 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBIGS9Ug013945
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2008 11:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


While doing various error injection testing, such as cable
pulls and target moves, some issues were observed in handling
these events. This patch improves the way these events are handled
by increasing the delay waiting for the fabric to settle and also
changes the behavior of Link Up to break the CRQ to ensure everything
gets cleaned up properly on the VIOS.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_improve_sync_events drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_improve_sync_events	2008-12-17 16:31:23.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-12-17 16:31:24.000000000 -0600
@@ -2156,15 +2156,17 @@ static void ibmvfc_handle_async(struct i
 	case IBMVFC_AE_LINK_UP:
 	case IBMVFC_AE_RESUME:
 		vhost->events_to_log |= IBMVFC_AE_LINKUP;
-		ibmvfc_init_host(vhost, 1);
+		vhost->delay_init = 1;
+		__ibmvfc_reset_host(vhost);
 		break;
 	case IBMVFC_AE_SCN_FABRIC:
+	case IBMVFC_AE_SCN_DOMAIN:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
-		ibmvfc_init_host(vhost, 1);
+		vhost->delay_init = 1;
+		__ibmvfc_reset_host(vhost);
 		break;
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
-	case IBMVFC_AE_SCN_DOMAIN:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
 	case IBMVFC_AE_ELS_LOGO:
 	case IBMVFC_AE_ELS_PRLO:
@@ -3619,7 +3621,7 @@ static void ibmvfc_do_work(struct ibmvfc
 		if (vhost->delay_init) {
 			vhost->delay_init = 0;
 			spin_unlock_irqrestore(vhost->host->host_lock, flags);
-			ssleep(5);
+			ssleep(15);
 			return;
 		} else
 			vhost->job_step(vhost);
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_improve_sync_events drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_improve_sync_events	2008-12-17 16:31:24.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-12-17 16:31:24.000000000 -0600
@@ -33,7 +33,7 @@
 #define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
-#define IBMVFC_INIT_TIMEOUT		30
+#define IBMVFC_INIT_TIMEOUT		120
 #define IBMVFC_MAX_REQUESTS_DEFAULT	100
 
 #define IBMVFC_DEBUG			0
_
