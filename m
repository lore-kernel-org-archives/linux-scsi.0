From: swen@vnet.ibm.com
Subject: [patch 3/6] zfcp: Specify waiting times in ERP in seconds
Date: Mon, 05 Nov 2007 12:37:45 +0100
Message-ID: <20071105114600.743203000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:10384 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbXKELqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 06:46:43 -0500
Content-Disposition: inline; filename=803-zfcp-waits.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

It is not necessary to use jiffies or milliseconds to specify
waiting times that last a couple of seconds.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |    4 ++--
 drivers/s390/scsi/zfcp_erp.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: scsi-misc/drivers/s390/scsi/zfcp_def.h
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_def.h
+++ scsi-misc/drivers/s390/scsi/zfcp_def.h
@@ -117,7 +117,7 @@ zfcp_address_to_sg(void *address, struct
 
 #define ZFCP_SBAL_TIMEOUT               (5*HZ)
 
-#define ZFCP_TYPE2_RECOVERY_TIME        (8*HZ)
+#define ZFCP_TYPE2_RECOVERY_TIME        8	/* seconds */
 
 /* queue polling (values in microseconds) */
 #define ZFCP_MAX_INPUT_THRESHOLD 	5000	/* FIXME: tune */
@@ -138,7 +138,7 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_STATUS_READS_RECOM		        FSF_STATUS_READS_RECOM
 
 /* Do 1st retry in 1 second, then double the timeout for each following retry */
-#define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	100
+#define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	1
 #define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
 
 /* timeout value for "default timer" for fsf requests */
Index: scsi-misc/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_erp.c
+++ scsi-misc/drivers/s390/scsi/zfcp_erp.c
@@ -131,7 +131,7 @@ static void zfcp_close_qdio(struct zfcp_
 	debug_text_event(adapter->erp_dbf, 3, "qdio_down2a");
 	while (qdio_shutdown(adapter->ccw_device,
 			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
-		msleep(1000);
+		ssleep(1);
 	debug_text_event(adapter->erp_dbf, 3, "qdio_down2b");
 
 	/* cleanup used outbound sbals */
@@ -1900,7 +1900,7 @@ zfcp_erp_adapter_strategy(struct zfcp_er
 		ZFCP_LOG_INFO("Waiting to allow the adapter %s "
 			      "to recover itself\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		msleep(jiffies_to_msecs(ZFCP_TYPE2_RECOVERY_TIME));
+		ssleep(ZFCP_TYPE2_RECOVERY_TIME);
 	}
 
 	return retval;
@@ -2080,7 +2080,7 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 	debug_text_event(adapter->erp_dbf, 3, "qdio_down1a");
 	while (qdio_shutdown(adapter->ccw_device,
 			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
-		msleep(1000);
+		ssleep(1);
 	debug_text_event(adapter->erp_dbf, 3, "qdio_down1b");
 
  failed_qdio_establish:
@@ -2165,7 +2165,7 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		ZFCP_LOG_DEBUG("host connection still initialising... "
 			       "waiting and retrying...\n");
 		/* sleep a little bit before retry */
-		msleep(jiffies_to_msecs(sleep));
+		ssleep(sleep);
 		sleep *= 2;
 	}
 

-- 
