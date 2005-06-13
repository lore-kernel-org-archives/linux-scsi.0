From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [2/8] zfcp: several bug fixes
Date: Mon, 13 Jun 2005 12:47:10 +0200
Message-ID: <20050613104710.GB8892@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:35566 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261466AbVFMKrU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 06:47:20 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DAl8ew049024
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 10:47:09 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DAl82H158494
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 12:47:08 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DAl8fh027402
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 12:47:08 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This is patch 2 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one extends the time for adapter initialization:
In case of protocol status HOST_CONNECTION_INITIALIZING for the
exchange config data command do a first retry in 1 second, then double
the sleep time for each following retry until recovery exceeds 2
minutes. The old behaviour of allowing 6 retries with .5 seconds delay
between retries was insufficient and qdio queues were shut down too
erarly.


Regards,

Andreas


From: Maxim Shchetynin <maxim@de.ibm.com>
 
zfcp: fix: allow more time for adapter initialization

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h	2005-06-11 22:04:32.066611728 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h	2005-06-11 22:08:17.867284808 +0200
@@ -149,8 +149,10 @@
 #define FSF_QTCB_UNSOLICITED_STATUS		0x6305
 #define ZFCP_STATUS_READ_FAILED_THRESHOLD	3
 #define ZFCP_STATUS_READS_RECOM		        FSF_STATUS_READS_RECOM
-#define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	6
-#define ZFCP_EXCHANGE_CONFIG_DATA_SLEEP		50
+
+/* Do 1st retry in 1 second, then double the timeout for each following retry */
+#define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	100
+#define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
 
 /* timeout value for "default timer" for fsf requests */
 #define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ);
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c	2005-06-10 10:05:42.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c	2005-06-11 22:08:17.874283744 +0200
@@ -2286,12 +2286,12 @@
 {
 	int retval = ZFCP_ERP_SUCCEEDED;
 	int retries;
+	int sleep = ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
-	retries = ZFCP_EXCHANGE_CONFIG_DATA_RETRIES;
 
-	do {
+	for (retries = ZFCP_EXCHANGE_CONFIG_DATA_RETRIES; retries; retries--) {
 		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				  &adapter->status);
 		ZFCP_LOG_DEBUG("Doing exchange config data\n");
@@ -2329,16 +2329,17 @@
 				      zfcp_get_busid_by_adapter(adapter));
 			break;
 		}
-		if (atomic_test_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-				     &adapter->status)) {
-			ZFCP_LOG_DEBUG("host connection still initialising... "
-				       "waiting and retrying...\n");
-			/* sleep a little bit before retry */
-			msleep(jiffies_to_msecs(ZFCP_EXCHANGE_CONFIG_DATA_SLEEP));
-		}
-	} while ((retries--) &&
-		 atomic_test_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-				  &adapter->status));
+
+		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+				     &adapter->status))
+			break;
+
+		ZFCP_LOG_DEBUG("host connection still initialising... "
+			       "waiting and retrying...\n");
+		/* sleep a little bit before retry */
+		msleep(jiffies_to_msecs(sleep));
+		sleep *= 2;
+	}
 
 	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 			      &adapter->status)) {

