From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] fusion - bug fix stack overflow in mptbase
Date: Wed, 26 Apr 2006 13:22:37 -0600
Message-ID: <20060426192237.GA25964@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41706 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964848AbWDZTYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 15:24:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

Bug fix for stack overflow in EventDescriptionStr, (a function
for debuging firmware events).  We allocated 50 bytes on local stack
for buff[], however there are places in the code where we've attempted
copying in greater than 50 bytes into buff[].

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-04-26 11:59:09.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-04-25 09:25:18.000000000 -0600
@@ -5735,12 +5735,13 @@
 	return rc;
 }
 
+# define EVENT_DESCR_STR_SZ		100
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static void
 EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 {
-	char *ds;
-	char buf[50];
+	char *ds = NULL;
 
 	switch(event) {
 	case MPI_EVENT_NONE:
@@ -5777,9 +5778,9 @@
 		if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LIP)
 			ds = "Loop State(LIP) Change";
 		else if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LPE)
-			ds = "Loop State(LPE) Change";			/* ??? */
+			ds = "Loop State(LPE) Change";		/* ??? */
 		else
-			ds = "Loop State(LPB) Change";			/* ??? */
+			ds = "Loop State(LPB) Change";		/* ??? */
 		break;
 	case MPI_EVENT_LOGOUT:
 		ds = "Logout";
@@ -5845,22 +5846,28 @@
 		u8 ReasonCode = (u8)(evData0 >> 16);
 		switch (ReasonCode) {
 		case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
-			sprintf(buf,"SAS Device Status Change: Added: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Added: id=%d", id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
-			sprintf(buf,"SAS Device Status Change: Deleted: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Deleted: id=%d", id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
-			sprintf(buf,"SAS Device Status Change: SMART Data: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: SMART Data: id=%d",
+			    id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
-			sprintf(buf,"SAS Device Status Change: No Persistancy Added: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: No Persistancy "
+			    "Added: id=%d", id);
 			break;
 		default:
-			sprintf(buf,"SAS Device Status Change: Unknown: id=%d", id);
-		break;
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Unknown: id=%d", id);
+			break;
 		}
-		ds = buf;
 		break;
 	}
 	case MPI_EVENT_ON_BUS_TIMER_EXPIRED:
@@ -5883,34 +5890,40 @@
 			MPI_EVENT_SAS_PLS_LR_CURRENT_SHIFT;
 		switch (LinkRates) {
 		case MPI_EVENT_SAS_PLS_LR_RATE_UNKNOWN:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate Unknown",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_PHY_DISABLED:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Phy Disabled",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_FAILED_SPEED_NEGOTIATION:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Failed Speed Nego",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_SATA_OOB_COMPLETE:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Sata OOB Completed",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_1_5:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate 1.5 Gbps",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_3_0:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate 3.0 Gpbs",PhyNumber);
 			break;
 		default:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d", PhyNumber);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d", PhyNumber);
 			break;
 		}
-		ds = buf;
 		break;
 	}
 	case MPI_EVENT_SAS_DISCOVERY_ERROR:
@@ -5919,8 +5932,8 @@
 	case MPI_EVENT_IR_RESYNC_UPDATE:
 	{
 		u8 resync_complete = (u8)(evData0 >> 16);
-		sprintf(buf,"IR Resync Update: Complete = %d:",resync_complete);
-		ds = buf;
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		    "IR Resync Update: Complete = %d:",resync_complete);
 		break;
 	}
 	case MPI_EVENT_IR2:
@@ -5973,7 +5986,8 @@
 		ds = "Unknown";
 		break;
 	}
-	strcpy(evStr,ds);
+	if (ds)
+		strncpy(evStr, ds, EVENT_DESCR_STR_SZ);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5995,7 +6009,7 @@
 	int ii;
 	int r = 0;
 	int handlers = 0;
-	char evStr[100];
+	char evStr[EVENT_DESCR_STR_SZ];
 	u8 event;
 
 	/*
 	}
