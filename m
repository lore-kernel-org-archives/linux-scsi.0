From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/9] - fusion - iocstatus, loginfo, and event debug updates
Date: Mon, 29 Jan 2007 09:44:54 -0700
Message-ID: <20070129164454.GA1898@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60578 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXA2QoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:44:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

various string updates for iocstatus, logingo, and fw asyn events.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/Makefile	2007-01-28 12:57:29.000000000 -0700
@@ -10,6 +10,7 @@
 #EXTRA_CFLAGS += -DMPT_DEBUG_FAIL
 #EXTRA_CFLAGS += -DMPT_DEBUG_DV
 #EXTRA_CFLAGS += -DMPT_DEBUG_TM
+#EXTRA_CFLAGS += -DMPT_DEBUG_REPLY
 
 #
 # driver/module specifics...
@@ -23,7 +24,6 @@
 #
 #  For mptscsih:
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_SCSI
-#CFLAGS_mptscsih.o += -DMPT_DEBUG_REPLY
 #
 #  For mptctl:
 #CFLAGS_mptctl.o += -DMPT_DEBUG_IOCTL
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
@@ -177,7 +177,9 @@ static void	mpt_get_fw_exp_ver(char *buf
 
 //int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 static int	ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply, int *evHandlers);
-static void	mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
+#ifdef MPT_DEBUG_REPLY
+static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
+#endif
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);
@@ -323,13 +325,11 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 		else if (ioc->bus_type == SAS)
 			mpt_sas_log_info(ioc, log_info);
 	}
-	if (ioc_stat & MPI_IOCSTATUS_MASK) {
-		if (ioc->bus_type == SPI &&
-		    cb_idx != mpt_stm_index &&
-		    cb_idx != mpt_lan_index)
-			mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);
-	}
 
+#ifdef MPT_DEBUG_REPLY
+	if (ioc_stat & MPI_IOCSTATUS_MASK)
+		mpt_iocstatus_info(ioc, (u32)ioc_stat, mf);
+#endif
 
 	/*  Check for (valid) IO callback!  */
 	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
@@ -5694,8 +5694,6 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
 	return rc;
 }
 
-# define EVENT_DESCR_STR_SZ		100
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static void
 EventDescriptionStr(u8 event, u32 evData0, char *evStr)
@@ -5723,9 +5721,6 @@ EventDescriptionStr(u8 event, u32 evData
 		break;
 	case MPI_EVENT_RESCAN:
 		ds = "Bus Rescan Event";
-		/* Ok, do we need to do anything here? As far as
-		   I can tell, this is when a new device gets added
-		   to the loop. */
 		break;
 	case MPI_EVENT_LINK_STATUS_CHANGE:
 		if (evData0 == MPI_EVENT_LINK_STATUS_FAILURE)
@@ -5802,48 +5797,63 @@ EventDescriptionStr(u8 event, u32 evData
 	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
 	{
 		u8 id = (u8)(evData0);
+		u8 channel = (u8)(evData0 >> 8);
 		u8 ReasonCode = (u8)(evData0 >> 16);
 		switch (ReasonCode) {
 		case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Added: id=%d", id);
+			    "SAS Device Status Change: Added: "
+			    "id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Deleted: id=%d", id);
+			    "SAS Device Status Change: Deleted: "
+			    "id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: SMART Data: id=%d",
-			    id);
+			    "SAS Device Status Change: SMART Data: "
+			    "id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: No Persistancy: id=%d", id);
+			    "SAS Device Status Change: No Persistancy: "
+			    "id=%d channel=%d", id, channel);
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Unsupported Device "
+			    "Discovered : id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Internal Device Reset : id=%d", id);
+			    "SAS Device Status Change: Internal Device "
+			    "Reset : id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Internal Task Abort : id=%d", id);
+			    "SAS Device Status Change: Internal Task "
+			    "Abort : id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Internal Abort Task Set : id=%d", id);
+			    "SAS Device Status Change: Internal Abort "
+			    "Task Set : id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Internal Clear Task Set : id=%d", id);
+			    "SAS Device Status Change: Internal Clear "
+			    "Task Set : id=%d channel=%d", id, channel);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Internal Query Task : id=%d", id);
+			    "SAS Device Status Change: Internal Query "
+			    "Task : id=%d channel=%d", id, channel);
 			break;
 		default:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
-			    "SAS Device Status Change: Unknown: id=%d", id);
+			    "SAS Device Status Change: Unknown: "
+			    "id=%d channel=%d", id, channel);
 			break;
 		}
 		break;
@@ -5852,8 +5862,16 @@ EventDescriptionStr(u8 event, u32 evData
 		ds = "Bus Timer Expired";
 		break;
 	case MPI_EVENT_QUEUE_FULL:
-		ds = "Queue Full";
+	{
+		u16 curr_depth = (u16)(evData0 >> 16);
+		u8 channel = (u8)(evData0 >> 8);
+		u8 id = (u8)(evData0);
+
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		   "Queue Full: channel=%d id=%d depth=%d",
+		   channel, id, curr_depth);
 		break;
+	}
 	case MPI_EVENT_SAS_SES:
 		ds = "SAS SES Event";
 		break;
@@ -5957,6 +5975,76 @@ EventDescriptionStr(u8 event, u32 evData
 		ds = "SAS Log Entry Added";
 		break;
 
+	case MPI_EVENT_SAS_BROADCAST_PRIMITIVE:
+	{
+		u8 phy_num = (u8)(evData0);
+		u8 port_num = (u8)(evData0 >> 8);
+		u8 port_width = (u8)(evData0 >> 16);
+		u8 primative = (u8)(evData0 >> 24);
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		    "SAS Broadcase Primative: phy=%d port=%d "
+		    "width=%d primative=0x%02x",
+		    phy_num, port_num, port_width, primative);
+		break;
+	}
+
+	case MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
+	{
+		u8 reason = (u8)(evData0);
+		u8 port_num = (u8)(evData0 >> 8);
+		u16 handle = le16_to_cpu(evData0 >> 16);
+
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		    "SAS Initiator Device Status Change: reason=0x%02x "
+		    "port=%d handle=0x%04x",
+		    reason, port_num, handle);
+		break;
+	}
+
+	case MPI_EVENT_SAS_INIT_TABLE_OVERFLOW:
+	{
+		u8 max_init = (u8)(evData0);
+		u8 current_init = (u8)(evData0 >> 8);
+
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		    "SAS Initiator Device Table Overflow: max initiators=%02d "
+		    "current initators=%02d",
+		    max_init, current_init);
+		break;
+	}
+	case MPI_EVENT_SAS_SMP_ERROR:
+	{
+		u8 status = (u8)(evData0);
+		u8 port_num = (u8)(evData0 >> 8);
+		u8 result = (u8)(evData0 >> 16);
+
+		if (status == MPI_EVENT_SAS_SMP_FUNCTION_RESULT_VALID)
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d result=0x%02x",
+			    port_num, result);
+		else if (status == MPI_EVENT_SAS_SMP_CRC_ERROR)
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d : CRC Error",
+			    port_num);
+		else if (status == MPI_EVENT_SAS_SMP_TIMEOUT)
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d : Timeout",
+			    port_num);
+		else if (status == MPI_EVENT_SAS_SMP_NO_DESTINATION)
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d : No Destination",
+			    port_num);
+		else if (status == MPI_EVENT_SAS_SMP_BAD_DESTINATION)
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d : Bad Destination",
+			    port_num);
+		else
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS SMP Error: port=%d : status=0x%02x",
+			    port_num, status);
+		break;
+	}
+
 	/*
 	 *  MPT base "custom" events may be added here...
 	 */
@@ -6220,10 +6308,11 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 		"Abort",					/* 12h */
 		"IO Not Yet Executed",				/* 13h */
 		"IO Executed",					/* 14h */
-		"Persistent Reservation Out Not Affiliation Owner", /* 15h */
+		"Persistent Reservation Out Not Affiliation "
+		    "Owner", 					/* 15h */
 		"Open Transmit DMA Abort",			/* 16h */
 		"IO Device Missing Delay Retry",		/* 17h */
-		NULL,						/* 18h */
+		"IO Cancelled Due to Recieve Error",		/* 18h */
 		NULL,						/* 19h */
 		NULL,						/* 1Ah */
 		NULL,						/* 1Bh */
@@ -6233,6 +6322,96 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 		NULL,						/* 1Fh */
 		"Enclosure Management"				/* 20h */
 	};
+	static char *ir_code_str[] = {
+		"Raid Action Error",				/* 00h */
+		NULL,						/* 00h */
+		NULL,						/* 01h */
+		NULL,						/* 02h */
+		NULL,						/* 03h */
+		NULL,						/* 04h */
+		NULL,						/* 05h */
+		NULL,						/* 06h */
+		NULL						/* 07h */
+	};
+	static char *raid_sub_code_str[] = {
+		NULL, 						/* 00h */
+		"Volume Creation Failed: Data Passed too "
+		    "Large", 					/* 01h */
+		"Volume Creation Failed: Duplicate Volumes "
+		    "Attempted", 				/* 02h */
+		"Volume Creation Failed: Max Number "
+		    "Supported Volumes Exceeded",		/* 03h */
+		"Volume Creation Failed: DMA Error",		/* 04h */
+		"Volume Creation Failed: Invalid Volume Type",	/* 05h */
+		"Volume Creation Failed: Error Reading "
+		    "MFG Page 4", 				/* 06h */
+		"Volume Creation Failed: Creating Internal "
+		    "Structures", 				/* 07h */
+		NULL,						/* 08h */
+		NULL,						/* 09h */
+		NULL,						/* 0Ah */
+		NULL,						/* 0Bh */
+		NULL,						/* 0Ch */
+		NULL,						/* 0Dh */
+		NULL,						/* 0Eh */
+		NULL,						/* 0Fh */
+		"Activation failed: Already Active Volume", 	/* 10h */
+		"Activation failed: Unsupported Volume Type", 	/* 11h */
+		"Activation failed: Too Many Active Volumes", 	/* 12h */
+		"Activation failed: Volume ID in Use", 		/* 13h */
+		"Activation failed: Reported Failure", 		/* 14h */
+		"Activation failed: Importing a Volume", 	/* 15h */
+		NULL,						/* 16h */
+		NULL,						/* 17h */
+		NULL,						/* 18h */
+		NULL,						/* 19h */
+		NULL,						/* 1Ah */
+		NULL,						/* 1Bh */
+		NULL,						/* 1Ch */
+		NULL,						/* 1Dh */
+		NULL,						/* 1Eh */
+		NULL,						/* 1Fh */
+		"Phys Disk failed: Too Many Phys Disks", 	/* 20h */
+		"Phys Disk failed: Data Passed too Large",	/* 21h */
+		"Phys Disk failed: DMA Error", 			/* 22h */
+		"Phys Disk failed: Invalid <channel:id>", 	/* 23h */
+		"Phys Disk failed: Creating Phys Disk Config "
+		    "Page", 					/* 24h */
+		NULL,						/* 25h */
+		NULL,						/* 26h */
+		NULL,						/* 27h */
+		NULL,						/* 28h */
+		NULL,						/* 29h */
+		NULL,						/* 2Ah */
+		NULL,						/* 2Bh */
+		NULL,						/* 2Ch */
+		NULL,						/* 2Dh */
+		NULL,						/* 2Eh */
+		NULL,						/* 2Fh */
+		"Compatibility Error: IR Disabled",		/* 30h */
+		"Compatibility Error: Inquiry Comand Failed",	/* 31h */
+		"Compatibility Error: Device not Direct Access "
+		    "Device ",					/* 32h */
+		"Compatibility Error: Removable Device Found",	/* 33h */
+		"Compatibility Error: Device SCSI Version not "
+		    "2 or Higher", 				/* 34h */
+		"Compatibility Error: SATA Device, 48 BIT LBA "
+		    "not Supported", 				/* 35h */
+		"Compatibility Error: Device doesn't have "
+		    "512 Byte Block Sizes", 			/* 36h */
+		"Compatibility Error: Volume Type Check Failed", /* 37h */
+		"Compatibility Error: Volume Type is "
+		    "Unsupported by FW", 			/* 38h */
+		"Compatibility Error: Disk Drive too Small for "
+		    "use in Volume", 				/* 39h */
+		"Compatibility Error: Phys Disk for Create "
+		    "Volume not Found", 			/* 3Ah */
+		"Compatibility Error: Too Many or too Few "
+		    "Disks for Volume Type", 			/* 3Bh */
+		"Compatibility Error: Disk stripe Sizes "
+		    "Must be 64KB", 				/* 3Ch */
+		"Compatibility Error: IME Size Limited to < 2TB", /* 3Dh */
+	};
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -6241,7 +6420,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
  *	@log_info: U32 LogInfo reply word from the IOC
  *
  *	Refer to lsi/mpi_log_sas.h.
- */
+ **/
 static void
 mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info)
 {
@@ -6255,56 +6434,165 @@ union loginfo_type {
 	}dw;
 };
 	union loginfo_type sas_loginfo;
+	char *originator_desc = NULL;
 	char *code_desc = NULL;
+	char *sub_code_desc = NULL;
 
 	sas_loginfo.loginfo = log_info;
 	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
 	    (sas_loginfo.dw.originator < sizeof(originator_str)/sizeof(char*)))
 		return;
-	if ((sas_loginfo.dw.originator == 0 /*IOP*/) &&
-	    (sas_loginfo.dw.code < sizeof(iop_code_str)/sizeof(char*))) {
-		code_desc = iop_code_str[sas_loginfo.dw.code];
-	}else if ((sas_loginfo.dw.originator == 1 /*PL*/) &&
-	    (sas_loginfo.dw.code < sizeof(pl_code_str)/sizeof(char*) )) {
-		code_desc = pl_code_str[sas_loginfo.dw.code];
+
+	originator_desc = originator_str[sas_loginfo.dw.originator];
+
+	switch (sas_loginfo.dw.originator) {
+
+		case 0:  /* IOP */
+			if (sas_loginfo.dw.code <
+			    sizeof(iop_code_str)/sizeof(char*))
+				code_desc = iop_code_str[sas_loginfo.dw.code];
+			break;
+		case 1:  /* PL */
+			if (sas_loginfo.dw.code <
+			    sizeof(pl_code_str)/sizeof(char*))
+				code_desc = pl_code_str[sas_loginfo.dw.code];
+			break;
+		case 2:  /* IR */
+			if (sas_loginfo.dw.code >=
+			    sizeof(ir_code_str)/sizeof(char*))
+				break;
+			code_desc = ir_code_str[sas_loginfo.dw.code];
+			if (sas_loginfo.dw.subcode >=
+			    sizeof(raid_sub_code_str)/sizeof(char*))
+			break;
+			if (sas_loginfo.dw.code == 0)
+				sub_code_desc =
+				    raid_sub_code_str[sas_loginfo.dw.subcode];
+			break;
+		default:
+			return;
 	}
 
-	if (code_desc != NULL)
+	if (sub_code_desc != NULL)
+		printk(MYIOC_s_INFO_FMT
+			"LogInfo(0x%08x): Originator={%s}, Code={%s},"
+			" SubCode={%s}\n",
+			ioc->name, log_info, originator_desc, code_desc,
+			sub_code_desc);
+	else if (code_desc != NULL)
 		printk(MYIOC_s_INFO_FMT
 			"LogInfo(0x%08x): Originator={%s}, Code={%s},"
 			" SubCode(0x%04x)\n",
-			ioc->name,
-			log_info,
-			originator_str[sas_loginfo.dw.originator],
-			code_desc,
+			ioc->name, log_info, originator_desc, code_desc,
 			sas_loginfo.dw.subcode);
 	else
 		printk(MYIOC_s_INFO_FMT
 			"LogInfo(0x%08x): Originator={%s}, Code=(0x%02x),"
 			" SubCode(0x%04x)\n",
-			ioc->name,
-			log_info,
-			originator_str[sas_loginfo.dw.originator],
-			sas_loginfo.dw.code,
-			sas_loginfo.dw.subcode);
+			ioc->name, log_info, originator_desc,
+			sas_loginfo.dw.code, sas_loginfo.dw.subcode);
 }
 
+#ifdef MPT_DEBUG_REPLY
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_sp_ioc_info - IOC information returned from SCSI Parallel IOC.
+ *	mpt_iocstatus_info_config - IOCSTATUS information for config pages
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	ioc_status: U32 IOCStatus word from IOC
+ *	@mf: Pointer to MPT request frame
+ *
+ *	Refer to lsi/mpi.h.
+ **/
+static void
+mpt_iocstatus_info_config(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
+{
+	Config_t *pReq = (Config_t *)mf;
+	char extend_desc[EVENT_DESCR_STR_SZ];
+	char *desc = NULL;
+	u32 form;
+	u8 page_type;
+
+	if (pReq->Header.PageType == MPI_CONFIG_PAGETYPE_EXTENDED)
+		page_type = pReq->ExtPageType;
+	else
+		page_type = pReq->Header.PageType;
+
+	/*
+	 * ignore invalid page messages for GET_NEXT_HANDLE
+	 */
+	form = le32_to_cpu(pReq->PageAddress);
+	if (ioc_status == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
+		if (page_type == MPI_CONFIG_EXTPAGETYPE_SAS_DEVICE ||
+		    page_type == MPI_CONFIG_EXTPAGETYPE_SAS_EXPANDER ||
+		    page_type == MPI_CONFIG_EXTPAGETYPE_ENCLOSURE) {
+			if ((form >> MPI_SAS_DEVICE_PGAD_FORM_SHIFT) ==
+				MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE)
+				return;
+		}
+		if (page_type == MPI_CONFIG_PAGETYPE_FC_DEVICE)
+			if ((form & MPI_FC_DEVICE_PGAD_FORM_MASK) ==
+				MPI_FC_DEVICE_PGAD_FORM_NEXT_DID)
+				return;
+	}
+
+	snprintf(extend_desc, EVENT_DESCR_STR_SZ,
+	    "type=%02Xh, page=%02Xh, action=%02Xh, form=%08Xh",
+	    page_type, pReq->Header.PageNumber, pReq->Action, form);
+
+	switch (ioc_status) {
+
+	case MPI_IOCSTATUS_CONFIG_INVALID_ACTION: /* 0x0020 */
+		desc = "Config Page Invalid Action";
+		break;
+
+	case MPI_IOCSTATUS_CONFIG_INVALID_TYPE:   /* 0x0021 */
+		desc = "Config Page Invalid Type";
+		break;
+
+	case MPI_IOCSTATUS_CONFIG_INVALID_PAGE:   /* 0x0022 */
+		desc = "Config Page Invalid Page";
+		break;
+
+	case MPI_IOCSTATUS_CONFIG_INVALID_DATA:   /* 0x0023 */
+		desc = "Config Page Invalid Data";
+		break;
+
+	case MPI_IOCSTATUS_CONFIG_NO_DEFAULTS:    /* 0x0024 */
+		desc = "Config Page No Defaults";
+		break;
+
+	case MPI_IOCSTATUS_CONFIG_CANT_COMMIT:    /* 0x0025 */
+		desc = "Config Page Can't Commit";
+		break;
+	}
+
+	if (!desc)
+		return;
+
+	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s: %s\n",
+	    ioc->name, ioc_status, desc, extend_desc);
+}
+
+/**
+ *	mpt_iocstatus_info - IOCSTATUS information returned from IOC.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@ioc_status: U32 IOCStatus word from IOC
  *	@mf: Pointer to MPT request frame
  *
  *	Refer to lsi/mpi.h.
- */
+ **/
 static void
-mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
+mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
 {
 	u32 status = ioc_status & MPI_IOCSTATUS_MASK;
 	char *desc = NULL;
 
 	switch (status) {
+
+/****************************************************************************/
+/*  Common IOCStatus values for all replies                                 */
+/****************************************************************************/
+
 	case MPI_IOCSTATUS_INVALID_FUNCTION: /* 0x0001 */
 		desc = "Invalid Function";
 		break;
@@ -6337,84 +6625,180 @@ mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 io
 		desc = "Invalid State";
 		break;
 
+/****************************************************************************/
+/*  Config IOCStatus values                                                 */
+/****************************************************************************/
+
 	case MPI_IOCSTATUS_CONFIG_INVALID_ACTION: /* 0x0020 */
 	case MPI_IOCSTATUS_CONFIG_INVALID_TYPE:   /* 0x0021 */
 	case MPI_IOCSTATUS_CONFIG_INVALID_PAGE:   /* 0x0022 */
 	case MPI_IOCSTATUS_CONFIG_INVALID_DATA:   /* 0x0023 */
 	case MPI_IOCSTATUS_CONFIG_NO_DEFAULTS:    /* 0x0024 */
 	case MPI_IOCSTATUS_CONFIG_CANT_COMMIT:    /* 0x0025 */
-		/* No message for Config IOCStatus values */
+		mpt_iocstatus_info_config(ioc, status, mf);
 		break;
 
+/****************************************************************************/
+/*  SCSIIO Reply (SPI, FCP, SAS) initiator values                           */
+/*                                                                          */
+/*  Look at mptscsih_iocstatus_info_scsiio in mptscsih.c */
+/*                                                                          */
+/****************************************************************************/
+
 	case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR: /* 0x0040 */
-		/* No message for recovered error
-		desc = "SCSI Recovered Error";
-		*/
+	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN: /* 0x0045 */
+	case MPI_IOCSTATUS_SCSI_INVALID_BUS: /* 0x0041 */
+	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID: /* 0x0042 */
+	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE: /* 0x0043 */
+	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN: /* 0x0044 */
+	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR: /* 0x0046 */
+	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR: /* 0x0047 */
+	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */
+	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH: /* 0x0049 */
+	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED: /* 0x004A */
+	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED: /* 0x004B */
+	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED: /* 0x004C */
 		break;
 
-	case MPI_IOCSTATUS_SCSI_INVALID_BUS: /* 0x0041 */
-		desc = "SCSI Invalid Bus";
+/****************************************************************************/
+/*  SCSI Target values                                                      */
+/****************************************************************************/
+
+	case MPI_IOCSTATUS_TARGET_PRIORITY_IO: /* 0x0060 */
+		desc = "Target: Priority IO";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID: /* 0x0042 */
-		desc = "SCSI Invalid TargetID";
+	case MPI_IOCSTATUS_TARGET_INVALID_PORT: /* 0x0061 */
+		desc = "Target: Invalid Port";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE: /* 0x0043 */
-	  {
-		SCSIIORequest_t *pScsiReq = (SCSIIORequest_t *) mf;
-		U8 cdb = pScsiReq->CDB[0];
-		if (cdb != 0x12) { /* Inquiry is issued for device scanning */
-			desc = "SCSI Device Not There";
-		}
+	case MPI_IOCSTATUS_TARGET_INVALID_IO_INDEX: /* 0x0062 */
+		desc = "Target Invalid IO Index:";
 		break;
-	  }
 
-	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN: /* 0x0044 */
-		desc = "SCSI Data Overrun";
+	case MPI_IOCSTATUS_TARGET_ABORTED: /* 0x0063 */
+		desc = "Target: Aborted";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN: /* 0x0045 */
-		/* This error is checked in scsi_io_done(). Skip.
-		desc = "SCSI Data Underrun";
-		*/
+	case MPI_IOCSTATUS_TARGET_NO_CONN_RETRYABLE: /* 0x0064 */
+		desc = "Target: No Conn Retryable";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR: /* 0x0046 */
-		desc = "SCSI I/O Data Error";
+	case MPI_IOCSTATUS_TARGET_NO_CONNECTION: /* 0x0065 */
+		desc = "Target: No Connection";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR: /* 0x0047 */
-		desc = "SCSI Protocol Error";
+	case MPI_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH: /* 0x006A */
+		desc = "Target: Transfer Count Mismatch";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */
-		desc = "SCSI Task Terminated";
+	case MPI_IOCSTATUS_TARGET_STS_DATA_NOT_SENT: /* 0x006B */
+		desc = "Target: STS Data not Sent";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH: /* 0x0049 */
-		desc = "SCSI Residual Mismatch";
+	case MPI_IOCSTATUS_TARGET_DATA_OFFSET_ERROR: /* 0x006D */
+		desc = "Target: Data Offset Error";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED: /* 0x004A */
-		desc = "SCSI Task Management Failed";
+	case MPI_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA: /* 0x006E */
+		desc = "Target: Too Much Write Data";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED: /* 0x004B */
-		desc = "SCSI IOC Terminated";
+	case MPI_IOCSTATUS_TARGET_IU_TOO_SHORT: /* 0x006F */
+		desc = "Target: IU Too Short";
 		break;
 
-	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED: /* 0x004C */
-		desc = "SCSI Ext Terminated";
+	case MPI_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT: /* 0x0070 */
+		desc = "Target: ACK NAK Timeout";
+		break;
+
+	case MPI_IOCSTATUS_TARGET_NAK_RECEIVED: /* 0x0071 */
+		desc = "Target: Nak Received";
+		break;
+
+/****************************************************************************/
+/*  Fibre Channel Direct Access values                                      */
+/****************************************************************************/
+
+	case MPI_IOCSTATUS_FC_ABORTED: /* 0x0066 */
+		desc = "FC: Aborted";
+		break;
+
+	case MPI_IOCSTATUS_FC_RX_ID_INVALID: /* 0x0067 */
+		desc = "FC: RX ID Invalid";
+		break;
+
+	case MPI_IOCSTATUS_FC_DID_INVALID: /* 0x0068 */
+		desc = "FC: DID Invalid";
+		break;
+
+	case MPI_IOCSTATUS_FC_NODE_LOGGED_OUT: /* 0x0069 */
+		desc = "FC: Node Logged Out";
+		break;
+
+	case MPI_IOCSTATUS_FC_EXCHANGE_CANCELED: /* 0x006C */
+		desc = "FC: Exchange Canceled";
+		break;
+
+/****************************************************************************/
+/*  LAN values                                                              */
+/****************************************************************************/
+
+	case MPI_IOCSTATUS_LAN_DEVICE_NOT_FOUND: /* 0x0080 */
+		desc = "LAN: Device not Found";
+		break;
+
+	case MPI_IOCSTATUS_LAN_DEVICE_FAILURE: /* 0x0081 */
+		desc = "LAN: Device Failure";
+		break;
+
+	case MPI_IOCSTATUS_LAN_TRANSMIT_ERROR: /* 0x0082 */
+		desc = "LAN: Transmit Error";
+		break;
+
+	case MPI_IOCSTATUS_LAN_TRANSMIT_ABORTED: /* 0x0083 */
+		desc = "LAN: Transmit Aborted";
+		break;
+
+	case MPI_IOCSTATUS_LAN_RECEIVE_ERROR: /* 0x0084 */
+		desc = "LAN: Receive Error";
+		break;
+
+	case MPI_IOCSTATUS_LAN_RECEIVE_ABORTED: /* 0x0085 */
+		desc = "LAN: Receive Aborted";
+		break;
+
+	case MPI_IOCSTATUS_LAN_PARTIAL_PACKET: /* 0x0086 */
+		desc = "LAN: Partial Packet";
+		break;
+
+	case MPI_IOCSTATUS_LAN_CANCELED: /* 0x0087 */
+		desc = "LAN: Canceled";
+		break;
+
+/****************************************************************************/
+/*  Serial Attached SCSI values                                             */
+/****************************************************************************/
+
+	case MPI_IOCSTATUS_SAS_SMP_REQUEST_FAILED: /* 0x0090 */
+		desc = "SAS: SMP Request Failed";
+		break;
+
+	case MPI_IOCSTATUS_SAS_SMP_DATA_OVERRUN: /* 0x0090 */
+		desc = "SAS: SMP Data Overrun";
 		break;
 
 	default:
 		desc = "Others";
 		break;
 	}
-	if (desc != NULL)
-		printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04x): %s\n", ioc->name, status, desc);
+
+	if (!desc)
+		return;
+
+	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s\n", ioc->name, status, desc);
 }
+#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 EXPORT_SYMBOL(mpt_attach);
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
@@ -172,6 +172,9 @@
 #define MPT_SCSI_SG_DEPTH	40
 #endif
 
+/* debug print string length used for events and iocstatus */
+# define EVENT_DESCR_STR_SZ             100
+
 #ifdef __KERNEL__	/* { */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
@@ -487,6 +487,90 @@ mptscsih_issue_sep_command(MPT_ADAPTER *
 	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
 }
 
+#ifdef MPT_DEBUG_REPLY
+/**
+ *	mptscsih_iocstatus_info_scsiio - IOCSTATUS information for SCSIIO
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@ioc_status: U32 IOCStatus word from IOC
+ *	@scsi_status: U8 sam status from target
+ *	@scsi_state: U8 scsi state
+ *	@sc: original scsi cmnd pointer
+ *	@mf: Pointer to MPT request frame
+ *
+ *	Refer to lsi/mpi.h.
+ **/
+static void
+mptscsih_iocstatus_info_scsiio(MPT_ADAPTER *ioc, u32 ioc_status,
+    u8 scsi_status, u8 scsi_state, struct scsi_cmnd *sc)
+{
+	char extend_desc[EVENT_DESCR_STR_SZ];
+	char *desc = NULL;
+
+	switch (ioc_status) {
+
+	case MPI_IOCSTATUS_SCSI_INVALID_BUS: /* 0x0041 */
+		desc = "SCSI Invalid Bus";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_INVALID_TARGETID: /* 0x0042 */
+		desc = "SCSI Invalid TargetID";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE: /* 0x0043 */
+		/*
+		 * Inquiry is issued for device scanning
+		 */
+		if (sc->cmnd[0] != 0x12)
+			desc = "SCSI Device Not There";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_DATA_OVERRUN: /* 0x0044 */
+		desc = "SCSI Data Overrun";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR: /* 0x0046 */
+		desc = "SCSI I/O Data Error";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR: /* 0x0047 */
+		desc = "SCSI Protocol Error";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */
+		desc = "SCSI Task Terminated";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH: /* 0x0049 */
+		desc = "SCSI Residual Mismatch";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED: /* 0x004A */
+		desc = "SCSI Task Management Failed";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_IOC_TERMINATED: /* 0x004B */
+		desc = "SCSI IOC Terminated";
+		break;
+
+	case MPI_IOCSTATUS_SCSI_EXT_TERMINATED: /* 0x004C */
+		desc = "SCSI Ext Terminated";
+		break;
+	}
+
+	if (!desc)
+		return;
+
+	snprintf(extend_desc, EVENT_DESCR_STR_SZ,
+	    "[%d:%d:%d:%d] cmd=%02Xh, sam_status=%02Xh state=%02Xh",
+		sc->device->host->host_no,
+		sc->device->channel, sc->device->id, sc->device->lun,
+		sc->cmnd[0], scsi_status, scsi_state);
+
+	printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04X): %s: %s\n",
+	    ioc->name, ioc_status, desc, extend_desc);
+}
+#endif
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_io_done - Main SCSI IO callback routine registered to
@@ -573,12 +657,14 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		u32	 xfer_cnt;
 		u16	 status;
 		u8	 scsi_state, scsi_status;
+		u32	 log_info;
 
 		status = le16_to_cpu(pScsiReply->IOCStatus) & MPI_IOCSTATUS_MASK;
 		scsi_state = pScsiReply->SCSIState;
 		scsi_status = pScsiReply->SCSIStatus;
 		xfer_cnt = le32_to_cpu(pScsiReply->TransferCount);
 		sc->resid = sc->request_bufflen - xfer_cnt;
+		log_info = le32_to_cpu(pScsiReply->IOCLogInfo);
 
 		/*
 		 *  if we get a data underrun indication, yet no data was
@@ -593,13 +679,6 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			status = MPI_IOCSTATUS_SUCCESS;
 		}
 
-		dreplyprintk((KERN_NOTICE "Reply ha=%d id=%d lun=%d:\n"
-			"IOCStatus=%04xh SCSIState=%02xh SCSIStatus=%02xh\n"
-			"resid=%d bufflen=%d xfer_cnt=%d\n",
-			ioc->id, sc->device->id, sc->device->lun,
-			status, scsi_state, scsi_status, sc->resid,
-			sc->request_bufflen, xfer_cnt));
-
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)
 			mptscsih_copy_sense_data(sc, hd, mf, pScsiReply);
 
@@ -608,9 +687,10 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		 */
 		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
 		    pScsiReply->ResponseInfo) {
-			printk(KERN_NOTICE "ha=%d id=%d lun=%d: "
+			printk(KERN_NOTICE "[%d:%d:%d:%d] "
 			"FCP_ResponseInfo=%08xh\n",
-			ioc->id, sc->device->id, sc->device->lun,
+			sc->device->host->host_no, sc->device->channel,
+			sc->device->id, sc->device->lun,
 			le32_to_cpu(pScsiReply->ResponseInfo));
 		}
 
@@ -655,9 +735,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			if ( ioc->bus_type == SAS ) {
 				u16 ioc_status = le16_to_cpu(pScsiReply->IOCStatus);
 				if (ioc_status & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
-					u32 log_info = le32_to_cpu(mr->u.reply.IOCLogInfo);
-					log_info &=SAS_LOGINFO_MASK;
-					if (log_info == SAS_LOGINFO_NEXUS_LOSS) {
+					if ((log_info & SAS_LOGINFO_MASK)
+					    == SAS_LOGINFO_NEXUS_LOSS) {
 						sc->result = (DID_BUS_BUSY << 16);
 						break;
 					}
@@ -695,7 +774,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			else /* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
 			dreplyprintk((KERN_NOTICE
-			    "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->device->id));
+			    "RESIDUAL_MISMATCH: result=%x on channel=%d id=%d\n",
+			    sc->result, sc->device->channel, sc->device->id));
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
@@ -808,7 +888,28 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 
 		}	/* switch(status) */
 
-		dreplyprintk((KERN_NOTICE "  sc->result is %08xh\n", sc->result));
+#ifdef MPT_DEBUG_REPLY
+		if (sc->result) {
+
+			mptscsih_iocstatus_info_scsiio(ioc, status,
+			    scsi_status, scsi_state, sc);
+
+			dreplyprintk(("%s: [%d:%d:%d:%d] cmd=0x%02x "
+			    "result=0x%08x\n\tiocstatus=0x%04X "
+			    "scsi_state=0x%02X scsi_status=0x%02X "
+			    "loginfo=0x%08X\n", __FUNCTION__,
+			    sc->device->host->host_no, sc->device->channel, sc->device->id,
+			    sc->device->lun, sc->cmnd[0], sc->result, status,
+			    scsi_state, scsi_status, log_info));
+
+			dreplyprintk(("%s: [%d:%d:%d:%d] resid=%d "
+			    "bufflen=%d xfer_cnt=%d\n", __FUNCTION__,
+			    sc->device->host->host_no, sc->device->channel, sc->device->id,
+			    sc->device->lun, sc->resid, sc->request_bufflen,
+			    xfer_cnt));
+		}
+#endif
+
 	} /* end of address reply case */
 
 	/* Unmap the DMA buffers, if any. */
