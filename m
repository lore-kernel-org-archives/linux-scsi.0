From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [janitor] (4/5) nsp32 (ninja): use kernel.h min/max/ARRAY_SIZE
Date: Tue, 27 Apr 2004 11:03:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427110351.111c589f.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59881 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264275AbUD0SOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 14:14:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>
Cc: yokota@netlab.is.tsukuba.ac.jp, gotom@debian.or.jp


From: Michael Veeck <michael.veeck@gmx.net>
Subject: [Kernel-janitors] [PATCH] drivers/scsi/nsp MIN/MAX/NUMBER removal

Patch (against 2.6.6-rc1) removes unnecessary min/max/number macros and 
changes calls to use kernel.h macros instead.


 drivers/scsi/nsp32.c |   24 ++++++++++++------------
 drivers/scsi/nsp32.h |    4 ----
 2 files changed, 12 insertions(+), 16 deletions(-)


Index: linux-266-rc2-kj1/drivers/scsi/nsp32.c
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/nsp32.c	2004-04-03 19:36:56.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/nsp32.c	2004-04-22 22:34:00.000000000 -0700
@@ -859,7 +859,7 @@ static int nsp32_reselection(Scsi_Cmnd *
 	 * or current nexus is not existed, unexpected
 	 * reselection is occurred. Send reject message.
 	 */
-	if (newid >= NUMBER(data->lunt) || newlun >= NUMBER(data->lunt[0])) {
+	if (newid >= ARRAY_SIZE(data->lunt) || newlun >= ARRAY_SIZE(data->lunt[0])) {
 		nsp32_msg(KERN_WARNING, "unknown id/lun");
 		return FALSE;
 	} else if(data->lunt[newid][newlun].SCpnt == NULL) {
@@ -1568,7 +1568,7 @@ static int nsp32_proc_info(
 
 
 	SPRINTF("SDTR status\n");
-	for(id = 0; id < NUMBER(data->target); id++) {
+	for (id = 0; id < ARRAY_SIZE(data->target); id++) {
 
                 SPRINTF("id %d: ", id);
 
@@ -1610,7 +1610,7 @@ static int nsp32_proc_info(
         }
 
 
-	thislength = MIN(thislength, length);
+	thislength = min(thislength, length);
 	*start = buffer + offset;
 
 	return thislength;
@@ -2753,17 +2753,17 @@ static int nsp32_detect(Scsi_Host_Templa
 	case CLOCK_4:
 		/* If data->clock is CLOCK_4, then select 40M sync table. */
 		data->synct   = nsp32_sync_table_40M;
-		data->syncnum = NUMBER(nsp32_sync_table_40M);
+		data->syncnum = ARRAY_SIZE(nsp32_sync_table_40M);
 		break;
 	case CLOCK_2:
 		/* If data->clock is CLOCK_2, then select 20M sync table. */
 		data->synct   = nsp32_sync_table_20M;
-		data->syncnum = NUMBER(nsp32_sync_table_20M);
+		data->syncnum = ARRAY_SIZE(nsp32_sync_table_20M);
 		break;
 	case PCICLK:
 		/* If data->clock is PCICLK, then select pci sync table. */
 		data->synct   = nsp32_sync_table_pci;
-		data->syncnum = NUMBER(nsp32_sync_table_pci);
+		data->syncnum = ARRAY_SIZE(nsp32_sync_table_pci);
 		break;
 	default:
 		nsp32_msg(KERN_WARNING,
@@ -2771,7 +2771,7 @@ static int nsp32_detect(Scsi_Host_Templa
 		/* Use default value CLOCK_4 */
 		data->clock   = CLOCK_4;
 		data->synct   = nsp32_sync_table_40M;
-		data->syncnum = NUMBER(nsp32_sync_table_40M);
+		data->syncnum = ARRAY_SIZE(nsp32_sync_table_40M);
 	}
 
 	/*
@@ -2805,9 +2805,9 @@ static int nsp32_detect(Scsi_Host_Templa
 		goto free_autoparam;
 	}
 
-	for (i = 0; i < NUMBER(data->lunt); i++) {
-		for (j = 0; j < NUMBER(data->lunt[0]); j++) {
-			int offset = i * NUMBER(data->lunt[0]) + j;
+	for (i = 0; i < ARRAY_SIZE(data->lunt); i++) {
+		for (j = 0; j < ARRAY_SIZE(data->lunt[0]); j++) {
+			int offset = i * ARRAY_SIZE(data->lunt[0]) + j;
 			nsp32_lunt tmp = {
 				.SCpnt       = NULL,
 				.save_datp   = 0,
@@ -2825,7 +2825,7 @@ static int nsp32_detect(Scsi_Host_Templa
 	/*
 	 * setup target
 	 */
-	for (i = 0; i < NUMBER(data->target); i++) {
+	for (i = 0; i < ARRAY_SIZE(data->target); i++) {
 		nsp32_target *target = &(data->target[i]);
 
 		target->limit_entry  = 0;
@@ -3021,7 +3021,7 @@ static void nsp32_do_bus_reset(nsp32_hw_
 	 * fall back to asynchronous transfer mode
 	 * initialize SDTR negotiation flag
 	 */
-	for (i = 0; i < NUMBER(data->target); i++) {
+	for (i = 0; i < ARRAY_SIZE(data->target); i++) {
 		nsp32_target *target = &data->target[i];
 
 		target->sync_flag = 0;
Index: linux-266-rc2-kj1/drivers/scsi/nsp32.h
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/nsp32.h	2004-04-03 19:36:11.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/nsp32.h	2004-04-22 22:34:00.000000000 -0700
@@ -70,11 +70,7 @@ typedef u16 u16_le;
 /*
  * MACRO
  */
-#define NUMBER(arr) ((int) (sizeof(arr) / sizeof(arr[0])))
 #define BIT(x)      (1UL << (x))
-#ifndef MIN
-# define MIN(a,b)   ((a) > (b) ? (b) : (a))
-#endif
 
 /*
  * BASIC Definitions


--
