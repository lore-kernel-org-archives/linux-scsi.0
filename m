From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 4/9] mptfusion: sas loginfo update
Date: Tue, 11 Jul 2006 17:39:13 -0600
Message-ID: <20060711233913.GB8640@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33235 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932265AbWGKXwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:52:03 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k6BNjSXu004805
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 16:45:28 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k6BNq2Ua012569
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 16:52:02 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adding more sas loginfo strings.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-07-11 12:26:19.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-07-11 12:34:35.000000000 -0600
@@ -436,8 +436,6 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 		 */
 		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY) {
 			freereq = 0;
-			devtverboseprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p does not return Request frame\n",
-				ioc->name, pEvReply));
 		} else {
 			devtverboseprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
 				ioc->name, pEvReply));
@@ -5030,19 +5028,18 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
 	EventAck_t	*pAck;
 
 	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		printk(MYIOC_s_WARN_FMT "Unable to allocate event ACK "
-			"request frame for Event=%x EventContext=%x EventData=%x!\n",
-			ioc->name, evnp->Event, le32_to_cpu(evnp->EventContext),
-			le32_to_cpu(evnp->Data[0]));
+		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
+		    ioc->name,__FUNCTION__));
 		return -1;
 	}
-	memset(pAck, 0, sizeof(*pAck));
 
-	dprintk((MYIOC_s_INFO_FMT "Sending EventAck\n", ioc->name));
+	devtverboseprintk((MYIOC_s_INFO_FMT "Sending EventAck\n", ioc->name));
 
 	pAck->Function     = MPI_FUNCTION_EVENT_ACK;
 	pAck->ChainOffset  = 0;
+	pAck->Reserved[0]  = pAck->Reserved[1] = 0;
 	pAck->MsgFlags     = 0;
+	pAck->Reserved1[0] = pAck->Reserved1[1] = pAck->Reserved1[2] = 0;
 	pAck->Event        = evnp->Event;
 	pAck->EventContext = evnp->EventContext;
 
@@ -5704,9 +5701,9 @@ EventDescriptionStr(u8 event, u32 evData
 		break;
 	case MPI_EVENT_EVENT_CHANGE:
 		if (evData0)
-			ds = "Events(ON) Change";
+			ds = "Events ON";
 		else
-			ds = "Events(OFF) Change";
+			ds = "Events OFF";
 		break;
 	case MPI_EVENT_INTEGRATED_RAID:
 	{
@@ -5777,8 +5774,27 @@ EventDescriptionStr(u8 event, u32 evData
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: No Persistancy "
-			    "Added: id=%d", id);
+			    "SAS Device Status Change: No Persistancy: id=%d", id);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Internal Device Reset : id=%d", id);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Internal Task Abort : id=%d", id);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Internal Abort Task Set : id=%d", id);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Internal Clear Task Set : id=%d", id);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Internal Query Task : id=%d", id);
 			break;
 		default:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
@@ -6034,7 +6050,7 @@ ProcessEventNotification(MPT_ADAPTER *io
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@log_info: U32 LogInfo reply word from the IOC
  *
- *	Refer to lsi/fc_log.h.
+ *	Refer to lsi/mpi_log_fc.h.
  */
 static void
 mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info)
@@ -6131,8 +6147,10 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 		"Invalid SAS Address",				/* 01h */
 		NULL,						/* 02h */
 		"Invalid Page",					/* 03h */
-		NULL,						/* 04h */
-		"Task Terminated"				/* 05h */
+		"Diag Message Error",				/* 04h */
+		"Task Terminated",				/* 05h */
+		"Enclosure Management",				/* 06h */
+		"Target Mode"					/* 07h */
 	};
 	static char *pl_code_str[] = {
 		NULL,						/* 00h */
@@ -6158,7 +6176,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 		"IO Executed",					/* 14h */
 		"Persistant Reservation Out Not Affiliation Owner", /* 15h */
 		"Open Transmit DMA Abort",			/* 16h */
-		NULL,						/* 17h */
+		"IO Device Missing Delay Retry",		/* 17h */
 		NULL,						/* 18h */
 		NULL,						/* 19h */
 		NULL,						/* 1Ah */
@@ -6238,7 +6256,7 @@ static void
 mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
 {
 	u32 status = ioc_status & MPI_IOCSTATUS_MASK;
-	char *desc = "";
+	char *desc = NULL;
 
 	switch (status) {
 	case MPI_IOCSTATUS_INVALID_FUNCTION: /* 0x0001 */
@@ -6348,7 +6366,7 @@ mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 io
 		desc = "Others";
 		break;
 	}
-	if (desc != "")
+	if (desc != NULL)
 		printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04x): %s\n", ioc->name, status, desc);
 }
 
