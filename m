From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 4/4] fusion - Miscellanous updates, and bump driver version
Date: Wed, 1 Jun 2005 10:47:44 -0600
Message-ID: <200506011047.44027.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_waenC5k6XPgVWm3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56293 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261464AbVFAQvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 12:51:02 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j51Glfo7007772
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:47:41 -0700 (PDT)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id j51Gp1c3005851
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:51:01 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_waenC5k6XPgVWm3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mptfusion patch 4/4:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.03/

Changelog:
* bump driver version to 3.03.03 
* SAS pci id recoginzation
* implemented new SAS functions for host page buffers - 
this feature is for firmware to allow usage of host physical memory 
for RAID related features, when memory is limited in controller memory space
* implemented new SAS funtions for clearing the persistant mappings - this can
occur if ioc facts config page says it needs clearing, or we could receive an
async event from firmware requesting it cleared when table is full, or we can
force clearing it thru a command line option when driver loads
* mpt_interrupt clean up code - main interrupt handler, also adding 0xdeadbeef
check for validating message frames being in use or freed.
* removed RAID related data from the _SpiCfgData struct, and moved to
new structure called _RaidCfgData, also created new struct _SasCfgData.
* MSI Suport - this is enabled thru command line option
* SAS fixes for firmware download boot
* Event Handling - updated debug strings with support for new SAS and RAID 
events
* Some changes in scsi completion routine - handling returning proper status
for underrun case 
* added target reset in mptscsih_slave_destroy function when scsi device is
being removed - clears the firmware outstanding io queue.
* eh entry points - cleanup, and added some more debuging info, added dumping
fw response code
* minor domain validation fixes.

Signed-off-by: Eric.Moore<Eric.Moore@lsil.com>

--Boundary-00=_waenC5k6XPgVWm3
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sas_upates4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sas_upates4.patch"

--- b/drivers/message/fusion/mptbase.h	2005-05-10 15:09:56.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2005-05-26 17:14:39.000000000 -0600
@@ -65,6 +65,7 @@
 #include "lsi/mpi_fc.h"		/* Fibre Channel (lowlevel) support */
 #include "lsi/mpi_targ.h"	/* SCSI/FCP Target protcol support */
 #include "lsi/mpi_tool.h"	/* Tools support */
+#include "lsi/mpi_sas.h"	/* SAS support */
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
@@ -76,8 +77,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.02"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.02"
+#define MPT_LINUX_VERSION_COMMON	"3.03.03"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.03"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -451,16 +452,13 @@
 #define MPT_SCSICFG_ALL_IDS		0x02	/* WriteSDP1 to all IDS */
 /* #define MPT_SCSICFG_BLK_NEGO		0x10	   WriteSDP1 with WDTR and SDTR disabled */
 
-typedef	struct _ScsiCfgData {
+typedef	struct _SpiCfgData {
 	u32		 PortFlags;
 	int		*nvram;			/* table of device NVRAM values */
-	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */
-	IOCPage3_t	*pIocPg3;		/* table of physical disks */
 	IOCPage4_t	*pIocPg4;		/* SEP devices addressing */
 	dma_addr_t	 IocPg4_dma;		/* Phys Addr of IOCPage4 data */
 	int		 IocPg4Sz;		/* IOCPage4 size */
 	u8		 dvStatus[MPT_MAX_SCSI_DEVICES];
-	int		 isRaid;		/* bit field, 1 if RAID */
 	u8		 minSyncFactor;		/* 0xFF if async */
 	u8		 maxSyncOffset;		/* 0 if async */
 	u8		 maxBusWidth;		/* 0 if narrow, 1 if wide */
@@ -475,7 +473,21 @@
 	u8		 Saf_Te;		/* 1 to force all Processors as SAF-TE if Inquiry data length is too short to check for SAF-TE */
 	u8		 mpt_dv;		/* command line option: enhanced=1, basic=0 */
 	u8		 rsvd[1];
-} ScsiCfgData;
+} SpiCfgData;
+
+typedef	struct _SasCfgData {
+	u8		 ptClear;		/* 1 to automatically clear the
+						 * persistent table.
+						 * 0 to disable
+						 * automatic clearing.
+						 */
+}SasCfgData;
+
+typedef	struct _RaidCfgData {
+	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */
+	IOCPage3_t	*pIocPg3;		/* table of physical disks */
+	int		 isRaid;		/* bit field, 1 if RAID */
+} RaidCfgData;
 
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
@@ -530,11 +542,16 @@
 	u8			*sense_buf_pool;
 	dma_addr_t		 sense_buf_pool_dma;
 	u32			 sense_buf_low_dma;
+	u8			*HostPageBuffer; /* SAS - host page buffer support */
+	u32			HostPageBuffer_sz;
+	dma_addr_t		HostPageBuffer_dma;
 	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	u8			__iomem *memmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
-	ScsiCfgData		spi_data;	/* Scsi config. data */
+	SpiCfgData		spi_data;	/* Scsi config. data */
+	RaidCfgData		raid_data;	/* Raid config. data */
+	SasCfgData		sas_data;	/* Sas config. data */
 	MPT_IOCTL		*ioctl;		/* ioctl data pointer */
 	struct proc_dir_entry	*ioc_dentry;
 	struct _MPT_ADAPTER	*alt_ioc;	/* ptr to 929 bound adapter port */
@@ -554,30 +571,33 @@
 #else
 	u32			 mfcnt;
 #endif
-	u32			 NB_for_64_byte_frame;       
+	u32			 NB_for_64_byte_frame;
 	u32			 hs_req[MPT_MAX_FRAME_SIZE/sizeof(u32)];
 	u16			 hs_reply[MPT_MAX_FRAME_SIZE/sizeof(u16)];
 	IOCFactsReply_t		 facts;
 	PortFactsReply_t	 pfacts[2];
 	FCPortPage0_t		 fc_port_page0[2];
+	struct timer_list	 persist_timer;	/* persist table timer */
+	int			 persist_wait_done; /* persist completion flag */
+	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
-	/*  
+	/*
 	 * Description: errata_flag_1064
 	 * If a PCIX read occurs within 1 or 2 cycles after the chip receives
 	 * a split completion for a read data, an internal address pointer incorrectly
 	 * increments by 32 bytes
 	 */
-	int			 errata_flag_1064;	
+	int			 errata_flag_1064;
 	u8			 FirstWhoInit;
 	u8			 upload_fw;	/* If set, do a fw upload */
 	u8			 reload_fw;	/* Force a FW Reload on next reset */
-	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */     
+	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
 	u8			 pad1[4];
 	int			 DoneCtx;
 	int			 TaskCtx;
 	int			 InternalCtx;
-	struct list_head	 list; 
+	struct list_head	 list;
 	struct net_device	*netdev;
 } MPT_ADAPTER;
 
@@ -961,6 +981,7 @@
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
+extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 
 /*
  *  Public data decl's...
--- b/drivers/message/fusion/mptbase.c	2005-05-11 10:51:26.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2005-05-31 16:51:58.000000000 -0600
@@ -82,6 +82,10 @@
 /*
  *  cmd line parameters
  */
+static int mpt_msi_enable = 0;
+module_param(mpt_msi_enable, int, 0);
+MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
+
 #ifdef MFCNT
 static int mfcounter = 0;
 #define PRINT_MF_COUNT 20000
@@ -141,7 +145,7 @@
 static int	SendIocInit(MPT_ADAPTER *ioc, int sleepFlag);
 static int	SendPortEnable(MPT_ADAPTER *ioc, int portnum, int sleepFlag);
 static int	mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag);
-static int	mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag);
+static int	mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag);
 static int	mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
 static int	KickStart(MPT_ADAPTER *ioc, int ignore, int sleepFlag);
 static int	SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag);
@@ -152,6 +156,7 @@
 static int	GetLanConfigPages(MPT_ADAPTER *ioc);
 static int	GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 static int	GetIoUnitPage2(MPT_ADAPTER *ioc);
+int		mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 static int	mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum);
 static int	mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void 	mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
@@ -159,6 +164,8 @@
 static void	mpt_timer_expired(unsigned long data);
 static int	SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int	SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
+static int	mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
+static int	mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init);
 
 #ifdef CONFIG_PROC_FS
 static int	procmpt_summary_read(char *buf, char **start, off_t offset,
@@ -218,8 +225,7 @@
  *	(also referred to as a IO Controller or IOC).
  *	This routine must clear the interrupt from the adapter and does
  *	so by reading the reply FIFO.  Multiple replies may be processed
- *	per single call to this routine; up to MPT_MAX_REPLIES_PER_ISR
- *	which is currently set to 32 in mptbase.h.
+ *	per single call to this routine.
  *
  *	This routine handles register-level access of the adapter but
  *	dispatches (calls) a protocol-specific callback routine to handle
@@ -241,24 +247,65 @@
 
 	/*
 	 *  Drain the reply FIFO!
-	 *
-	 * NOTES: I've seen up to 10 replies processed in this loop, so far...
-	 * Update: I've seen up to 9182 replies processed in this loop! ??
-	 * Update: Limit ourselves to processing max of N replies
-	 *	(bottom of loop).
 	 */
 	while (1) {
 
 		if ((pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo)) == 0xFFFFFFFF)
 			return IRQ_HANDLED;
 
-		cb_idx = 0;
-		freeme = 0;
-
 		/*
 		 *  Check for non-TURBO reply!
 		 */
-		if (pa & MPI_ADDRESS_REPLY_A_BIT) {
+		if ((pa & MPI_ADDRESS_REPLY_A_BIT) == 0) {
+			/*
+			 *  Process turbo (context) reply...
+			 */
+			dmfprintk((MYIOC_s_INFO_FMT "Got TURBO reply req_idx=%08x\n", ioc->name, pa));
+			type = (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT);
+			if (type == MPI_CONTEXT_REPLY_TYPE_SCSI_INIT) {
+				req_idx = pa & 0x0000FFFF;
+				cb_idx = (pa & 0x00FF0000) >> 16;
+				mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
+				mr = NULL;
+				/*  Do the callback!  */
+				freeme = (*(MptCallbacks[cb_idx]))(ioc, mf, mr);
+
+				if (freeme) /*  Put Request back on FreeQ!  */
+					mpt_free_msg_frame(ioc,mf);
+				mb();
+				continue;
+			} else if (type == MPI_CONTEXT_REPLY_TYPE_LAN) {
+				cb_idx = mpt_lan_index;
+				/*
+				 *  Blind set of mf to NULL here was fatal
+				 *  after lan_reply says "freeme"
+				 *  Fix sort of combined with an optimization here;
+				 *  added explicit check for case where lan_reply
+				 *  was just returning 1 and doing nothing else.
+				 *  For this case skip the callback, but set up
+				 *  proper mf value first here:-)
+				 */
+				if ((pa & 0x58000000) == 0x58000000) {
+					req_idx = pa & 0x0000FFFF;
+					mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
+					freeme = 1;
+					/*
+					 *  IMPORTANT!  Invalidate the callback!
+					 */
+					cb_idx = 0;
+				} else {
+					mf = NULL;
+					freeme = 0;
+				}
+				mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
+			} else { /* MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET */
+				cb_idx = mpt_stm_index;
+				mf = NULL;
+				mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
+				freeme = 0;
+			}
+			pa = 0;	/* No reply flush! */
+		} else {
 			u32 reply_dma_low;
 			u16 ioc_stat;
 
@@ -271,6 +318,8 @@
 			 * pa is 32 bits - but the dma address may be 32 or 64 bits
 			 * get offset based only only the low addresses
 			 */
+			freeme = 0;
+
 			reply_dma_low = (pa = (pa << 1));
 			mr = (MPT_FRAME_HDR *)((u8 *)ioc->reply_frames +
 					 (reply_dma_low - ioc->reply_frames_low_dma));
@@ -279,11 +328,11 @@
 			cb_idx = mr->u.frame.hwhdr.msgctxu.fld.cb_idx;
 			mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 
-			dmfprintk((MYIOC_s_INFO_FMT "Got non-TURBO reply=%p req_idx=%x\n",
-					ioc->name, mr, req_idx));
+			dmfprintk((MYIOC_s_INFO_FMT "Got non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
+					ioc->name, mr, req_idx, cb_idx, mr->u.hdr.Function));
 			DBG_DUMP_REPLY_FRAME(mr)
 
-			/*  Check/log IOC log info
+			 /*  Check/log IOC log info
 			 */
 			ioc_stat = le16_to_cpu(mr->u.reply.IOCStatus);
 			if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
@@ -292,50 +341,16 @@
 					mpt_fc_log_info(ioc, log_info);
 				else if (ioc->bus_type == SCSI)
 					mpt_sp_log_info(ioc, log_info);
+				else /* TODO SAS log info */
+					printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x)\n",
+					    ioc->name, log_info);
 			}
 			if (ioc_stat & MPI_IOCSTATUS_MASK) {
-				if (ioc->bus_type == SCSI)
+				if (ioc->bus_type == SCSI &&
+				    cb_idx != mpt_stm_index &&
+				    cb_idx != mpt_lan_index)
 					mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);
 			}
-		} else {
-			/*
-			 *  Process turbo (context) reply...
-			 */
-			dmfprintk((MYIOC_s_INFO_FMT "Got TURBO reply req_idx=%08x\n", ioc->name, pa));
-			type = (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT);
-			if (type == MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET) {
-				cb_idx = mpt_stm_index;
-				mf = NULL;
-				mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
-			} else if (type == MPI_CONTEXT_REPLY_TYPE_LAN) {
-				cb_idx = mpt_lan_index;
-				 /*  Blind set of mf to NULL here was fatal
-				 *  after lan_reply says "freeme"
-				 *  Fix sort of combined with an optimization here;
-				 *  added explicit check for case where lan_reply
-				 *  was just returning 1 and doing nothing else.
-				 *  For this case skip the callback, but set up
-				 *  proper mf value first here:-)
-				 */
-				if ((pa & 0x58000000) == 0x58000000) {
-					req_idx = pa & 0x0000FFFF;
-					mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
-					freeme = 1;
-					/*
-					 *  IMPORTANT!  Invalidate the callback!
-					 */
-					cb_idx = 0;
-				} else {
-					mf = NULL;
-				}
-				mr = (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);
-			} else {
-				req_idx = pa & 0x0000FFFF;
-				cb_idx = (pa & 0x00FF0000) >> 16;
-				mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
-				mr = NULL;
-			}
-			pa = 0;					/* No reply flush! */
 		}
 
 #ifdef MPT_DEBUG_IRQ
@@ -345,7 +360,7 @@
 			if ((mf) && ((mf >= MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))
 				|| (mf < ioc->req_frames)) ) {
 				printk(MYIOC_s_WARN_FMT
-					"mpt_interrupt: Invalid mf (%p) req_idx (%d)!\n", ioc->name, (void *)mf, req_idx);
+					"mpt_interrupt: Invalid mf (%p)!\n", ioc->name, (void *)mf);
 				cb_idx = 0;
 				pa = 0;
 				freeme = 0;
@@ -372,7 +387,8 @@
 		if (cb_idx) {
 			/*  Do the callback!  */
 			freeme = (*(MptCallbacks[cb_idx]))(ioc, mf, mr);
-		}
+		}else
+			freeme = 0;
 
 		if (pa) {
 			/*  Flush (non-TURBO) reply with a WRITE!  */
@@ -399,7 +415,7 @@
  *	@mf: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
  *
-	*	Returns 1 indicating original alloc'd request frame ptr
+ *	Returns 1 indicating original alloc'd request frame ptr
  *	should be freed, or 0 if it shouldn't.
  */
 static int
@@ -408,28 +424,17 @@
 	int freereq = 1;
 	u8 func;
 
-	dprintk((MYIOC_s_INFO_FMT "mpt_base_reply() called\n", ioc->name));
-
-	if ((mf == NULL) ||
-	    (mf >= MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {
-		printk(MYIOC_s_ERR_FMT "NULL or BAD request frame ptr! (=%p)\n",
-				ioc->name, (void *)mf);
-		return 1;
-	}
-
-	if (reply == NULL) {
-		dprintk((MYIOC_s_ERR_FMT "Unexpected NULL Event (turbo?) reply!\n",
-				ioc->name));
-		return 1;
-	}
+	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply() called\n", ioc->name));
 
+#if defined(MPT_DEBUG_MSG_FRAME)
 	if (!(reply->u.hdr.MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)) {
 		dmfprintk((KERN_INFO MYNAM ": Original request frame (@%p) header\n", mf));
 		DBG_DUMP_REQUEST_FRAME_HDR(mf)
 	}
+#endif
 
 	func = reply->u.hdr.Function;
-	dprintk((MYIOC_s_INFO_FMT "mpt_base_reply, Function=%02Xh\n",
+	dmfprintk((MYIOC_s_INFO_FMT "mpt_base_reply, Function=%02Xh\n",
 			ioc->name, func));
 
 	if (func == MPI_FUNCTION_EVENT_NOTIFICATION) {
@@ -448,8 +453,14 @@
 		 *	Hmmm...  It seems that EventNotificationReply is an exception
 		 *	to the rule of one reply per request.
 		 */
-		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY)
+		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY) {
 			freereq = 0;
+			devtprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p does not return Request frame\n",
+				ioc->name, pEvReply));
+		} else {
+			devtprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
+				ioc->name, pEvReply));
+		}
 
 #ifdef CONFIG_PROC_FS
 //		LogEvent(ioc, pEvReply);
@@ -504,6 +515,14 @@
 			pCfg->wait_done = 1;
 			wake_up(&mpt_waitq);
 		}
+	} else if (func == MPI_FUNCTION_SAS_IO_UNIT_CONTROL) {
+		/* we should be always getting a reply frame */
+		memcpy(ioc->persist_reply_frame, reply,
+		    min(MPT_DEFAULT_FRAME_SIZE,
+		    4*reply->u.reply.MsgLength));
+		del_timer(&ioc->persist_timer);
+		ioc->persist_wait_done = 1;
+		wake_up(&mpt_waitq);
 	} else {
 		printk(MYIOC_s_ERR_FMT "Unexpected msg function (=%02Xh) reply received!\n",
 				ioc->name, func);
@@ -705,7 +724,7 @@
 		if (dd_cbfunc->remove)
 			dd_cbfunc->remove(ioc->pcidev);
 	}
-	
+
 	MptDeviceDriverHandlers[cb_idx] = NULL;
 }
 
@@ -745,6 +764,7 @@
 		mf = list_entry(ioc->FreeQ.next, MPT_FRAME_HDR,
 				u.frame.linkage.list);
 		list_del(&mf->u.frame.linkage.list);
+		mf->u.frame.linkage.arg1 = 0;
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
@@ -818,7 +838,7 @@
 	}
 #endif
 
-	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];  
+	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
 	dsgprintk((MYIOC_s_INFO_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
 	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
 }
@@ -840,6 +860,7 @@
 
 	/*  Put Request back on FreeQ!  */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
+	mf->u.frame.linkage.arg1 = 0xdeadbeaf; /* signature to know if this mf is freed */
 	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 	ioc->mfcnt--;
@@ -920,7 +941,7 @@
 
 	/* Make sure there are no doorbells */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-	
+
 	CHIPREG_WRITE32(&ioc->chip->Doorbell,
 			((MPI_FUNCTION_HANDSHAKE<<MPI_DOORBELL_FUNCTION_SHIFT) |
 			 ((reqBytes/4)<<MPI_DOORBELL_ADD_DWORDS_SHIFT)));
@@ -935,14 +956,14 @@
 		return -5;
 
 	dhsprintk((KERN_INFO MYNAM ": %s: mpt_send_handshake_request start, WaitCnt=%d\n",
-			ioc->name, ii));
+		ioc->name, ii));
 
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
 	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
 		return -2;
 	}
-		
+
 	/* Send request via doorbell handshake */
 	req_as_bytes = (u8 *) req;
 	for (ii = 0; ii < reqBytes/4; ii++) {
@@ -966,12 +987,123 @@
 
 	/* Make sure there are no doorbells */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
-	
+
 	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
+ * mpt_host_page_access_control - provides mechanism for the host
+ * driver to control the IOC's Host Page Buffer access.
+ * @ioc: Pointer to MPT adapter structure
+ * @access_control_value: define bits below
+ *
+ * Access Control Value - bits[15:12]
+ * 0h Reserved
+ * 1h Enable Access { MPI_DB_HPBAC_ENABLE_ACCESS }
+ * 2h Disable Access { MPI_DB_HPBAC_DISABLE_ACCESS }
+ * 3h Free Buffer { MPI_DB_HPBAC_FREE_BUFFER }
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+
+static int
+mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag)
+{
+	int	 r = 0;
+
+	/* return if in use */
+	if (CHIPREG_READ32(&ioc->chip->Doorbell)
+	    & MPI_DOORBELL_ACTIVE)
+	    return -1;
+
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+
+	CHIPREG_WRITE32(&ioc->chip->Doorbell,
+		((MPI_FUNCTION_HOST_PAGEBUF_ACCESS_CONTROL
+		 <<MPI_DOORBELL_FUNCTION_SHIFT) |
+		 (access_control_value<<12)));
+
+	/* Wait for IOC to clear Doorbell Status bit */
+	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0) {
+		return -2;
+	}else
+		return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ *	mpt_host_page_alloc - allocate system memory for the fw
+ *	If we already allocated memory in past, then resend the same pointer.
+ *	ioc@: Pointer to pointer to IOC adapter
+ *	ioc_init@: Pointer to ioc init config page
+ *
+ *	Returns 0 for success, non-zero for failure.
+ */
+static int
+mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
+{
+	char	*psge;
+	int	flags_length;
+	u32	host_page_buffer_sz=0;
+
+	if(!ioc->HostPageBuffer) {
+
+		host_page_buffer_sz =
+		    (ioc->facts.HostPageBufferSGE.FlagsLength & 0xFFFFFF);
+
+		if(!host_page_buffer_sz)
+			return 0; /* fw doesn't need any host buffers */
+
+		/* spin till we get enough memory */
+		while(host_page_buffer_sz > 0) {
+
+			if((ioc->HostPageBuffer = pci_alloc_consistent(
+			    ioc->pcidev,
+			    host_page_buffer_sz,
+			    &ioc->HostPageBuffer_dma)) != NULL) {
+
+				dinitprintk((MYIOC_s_INFO_FMT
+				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
+				    ioc->name,
+				    ioc->HostPageBuffer,
+				    ioc->HostPageBuffer_dma,
+				    hst_page_buffer_sz));
+				ioc->alloc_total += host_page_buffer_sz;
+				ioc->HostPageBuffer_sz = host_page_buffer_sz;
+				break;
+			}
+
+			host_page_buffer_sz -= (4*1024);
+		}
+	}
+
+	if(!ioc->HostPageBuffer) {
+		printk(MYIOC_s_ERR_FMT
+		    "Failed to alloc memory for host_page_buffer!\n",
+		    ioc->name);
+		return -999;
+	}
+
+	psge = (char *)&ioc_init->HostPageBufferSGE;
+	flags_length = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+	    MPI_SGE_FLAGS_SYSTEM_ADDRESS |
+	    MPI_SGE_FLAGS_32_BIT_ADDRESSING |
+	    MPI_SGE_FLAGS_HOST_TO_IOC |
+	    MPI_SGE_FLAGS_END_OF_BUFFER;
+	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	    flags_length |= MPI_SGE_FLAGS_64_BIT_ADDRESSING;
+	}
+	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
+	flags_length |= ioc->HostPageBuffer_sz;
+	mpt_add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
+	ioc->facts.HostPageBufferSGE = ioc_init->HostPageBufferSGE;
+
+return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
  *	mpt_verify_adapter - Given a unique IOC identifier, set pointer to
  *	the associated MPT adapter structure.
  *	@iocid: IOC unique identifier (integer)
@@ -988,9 +1120,9 @@
 		if (ioc->id == iocid) {
 			*iocpp =ioc;
 			return iocid;
-		} 
+		}
 	}
-	
+
 	*iocpp = NULL;
 	return -1;
 }
@@ -1032,9 +1164,9 @@
 
 	if (pci_enable_device(pdev))
 		return r;
-	
+
 	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));
-	
+
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
 		dprintk((KERN_INFO MYNAM
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
@@ -1059,7 +1191,7 @@
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
-	
+
 	ioc->pcidev = pdev;
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
@@ -1079,7 +1211,7 @@
 
 	/* Initilize SCSI Config Data structure
 	 */
-	memset(&ioc->spi_data, 0, sizeof(ScsiCfgData));
+	memset(&ioc->spi_data, 0, sizeof(SpiCfgData));
 
 	/* Initialize the running configQ head.
 	 */
@@ -1088,7 +1220,7 @@
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
 	ioc->id = mpt_ids++;
-	
+
 	mem_phys = msize = 0;
 	port = psize = 0;
 	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
@@ -1143,7 +1275,7 @@
 		ioc->prod_name = "LSIFC909";
 		ioc->bus_type = FC;
 	}
-	if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929) {
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929) {
 		ioc->prod_name = "LSIFC929";
 		ioc->bus_type = FC;
 	}
@@ -1208,6 +1340,33 @@
 		ioc->prod_name = "LSI53C1035";
 		ioc->bus_type = SCSI;
 	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064) {
+		ioc->prod_name = "LSISAS1064";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066) {
+		ioc->prod_name = "LSISAS1066";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068) {
+		ioc->prod_name = "LSISAS1068";
+		ioc->bus_type = SAS;
+		ioc->errata_flag_1064 = 1;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064E) {
+		ioc->prod_name = "LSISAS1064E";
+		ioc->bus_type = SAS;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066E) {
+		ioc->prod_name = "LSISAS1066E";
+		ioc->bus_type = SAS;
+	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068E) {
+		ioc->prod_name = "LSISAS1068E";
+		ioc->bus_type = SAS;
+	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
@@ -1226,6 +1385,14 @@
 
 	ioc->pci_irq = -1;
 	if (pdev->irq) {
+
+		if ((mpt_msi_enable == 1) &&
+		    (pci_enable_msi(pdev)==0)) {
+			printk(MYIOC_s_INFO_FMT
+			    "PCI-MSI enabled for this hotplug controller\n",
+			    ioc->name);
+		}
+
 		r = request_irq(pdev->irq, mpt_interrupt, SA_SHIRQ, ioc->name, ioc);
 
 		if (r < 0) {
@@ -1266,6 +1433,9 @@
 
 		list_del(&ioc->list);
 		free_irq(ioc->pci_irq, ioc);
+		if (mpt_msi_enable == 1) {
+			pci_disable_msi(pdev);
+		}
 		iounmap(mem);
 		kfree(ioc);
 		pci_set_drvdata(pdev, NULL);
@@ -1322,7 +1492,7 @@
 	remove_proc_entry(pname, NULL);
 	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
 	remove_proc_entry(pname, NULL);
-	
+
 	/* call per device driver remove entry point */
 	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
 		if(MptDeviceDriverHandlers[ii] &&
@@ -1330,7 +1500,7 @@
 			MptDeviceDriverHandlers[ii]->remove(pdev);
 		}
 	}
-	
+
 	/* Disable interrupts! */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
 
@@ -1415,7 +1585,7 @@
 	u32 device_state = pdev->current_state;
 	int recovery_state;
 	int ii;
-	
+
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
 		ioc->name, pdev, pci_name(pdev), device_state);
@@ -1546,7 +1716,7 @@
 		if ((rc = GetIocFacts(ioc, sleepFlag, reason)) == 0)
 			break;
 	}
-	
+
 
 	if (ii == 5) {
 		dinitprintk((MYIOC_s_INFO_FMT "Retry IocFacts failed rc=%x\n", ioc->name, rc));
@@ -1554,7 +1724,7 @@
 	} else if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 		MptDisplayIocCapabilities(ioc);
 	}
-	
+
 	if (alt_ioc_ready) {
 		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
 			dinitprintk((MYIOC_s_INFO_FMT "Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
@@ -1611,8 +1781,25 @@
 			 */
 			if (ret == 0) {
 				rc = mpt_do_upload(ioc, sleepFlag);
-				if (rc != 0)
+				if (rc == 0) {
+					if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
+						/*
+						 * Maintain only one pointer to FW memory
+						 * so there will not be two attempt to
+						 * downloadboot onboard dual function
+						 * chips (mpt_adapter_disable,
+						 * mpt_diag_reset)
+						 */
+						ioc->cached_fw = NULL;
+						ddlprintk((MYIOC_s_INFO_FMT
+							": mpt_upload:  alt_%s has cached_fw=%p \n",
+							ioc->name, ioc->alt_ioc->name,
+							ioc->alt_ioc->cached_fw));
+					}
+				} else {
 					printk(KERN_WARNING MYNAM ": firmware upload failure!\n");
+					ret = -5;
+				}
 			}
 		}
 	}
@@ -1647,7 +1834,22 @@
 	 *	and we try GetLanConfigPages again...
 	 */
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
-		if (ioc->bus_type == FC) {
+		if (ioc->bus_type == SAS) {
+
+			/* clear persistency table */
+			if(ioc->facts.IOCExceptions &
+			    MPI_IOCFACTS_EXCEPT_PERSISTENT_TABLE_FULL) {
+				ret = mptbase_sas_persist_operation(ioc,
+				    MPI_SAS_OP_CLEAR_NOT_PRESENT);
+				if(ret != 0)
+					return -1;
+			}
+
+			/* Find IM volumes
+			 */
+			mpt_findImVolumes(ioc);
+
+		} else if (ioc->bus_type == FC) {
 			/*
 			 *  Pre-fetch FC port WWN and stuff...
 			 *  (FCPortPage0_t stuff)
@@ -1682,7 +1884,7 @@
 
 			/* Find IM volumes
 			 */
-			if (ioc->facts.MsgVersion >= 0x0102)
+			if (ioc->facts.MsgVersion >= MPI_VERSION_01_02)
 				mpt_findImVolumes(ioc);
 
 			/* Check, and possibly reset, the coalescing value
@@ -1790,7 +1992,7 @@
 
 	if (ioc->cached_fw != NULL) {
 		ddlprintk((KERN_INFO MYNAM ": mpt_adapter_disable: Pushing FW onto adapter\n"));
-		if ((ret = mpt_downloadboot(ioc, NO_SLEEP)) < 0) {
+		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)ioc->cached_fw, NO_SLEEP)) < 0) {
 			printk(KERN_WARNING MYNAM
 				": firmware downloadboot failure (%d)!\n", ret);
 		}
@@ -1838,13 +2040,13 @@
 	}
 
 	kfree(ioc->spi_data.nvram);
-	kfree(ioc->spi_data.pIocPg3);
+	kfree(ioc->raid_data.pIocPg3);
 	ioc->spi_data.nvram = NULL;
-	ioc->spi_data.pIocPg3 = NULL;
+	ioc->raid_data.pIocPg3 = NULL;
 
 	if (ioc->spi_data.pIocPg4 != NULL) {
 		sz = ioc->spi_data.IocPg4Sz;
-		pci_free_consistent(ioc->pcidev, sz, 
+		pci_free_consistent(ioc->pcidev, sz,
 			ioc->spi_data.pIocPg4,
 			ioc->spi_data.IocPg4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
@@ -1859,6 +2061,23 @@
 
 	kfree(ioc->ChainToChain);
 	ioc->ChainToChain = NULL;
+
+	if (ioc->HostPageBuffer != NULL) {
+		if((ret = mpt_host_page_access_control(ioc,
+		    MPI_DB_HPBAC_FREE_BUFFER, NO_SLEEP)) != 0) {
+			printk(KERN_ERR MYNAM
+			   ": %s: host page buffers free failed (%d)!\n",
+			    __FUNCTION__, ret);
+		}
+		dexitprintk((KERN_INFO MYNAM ": %s HostPageBuffer free  @ %p, sz=%d bytes\n",
+		 	ioc->name, ioc->HostPageBuffer, ioc->HostPageBuffer_sz));
+		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
+				ioc->HostPageBuffer,
+				ioc->HostPageBuffer_dma);
+		ioc->HostPageBuffer = NULL;
+		ioc->HostPageBuffer_sz = 0;
+		ioc->alloc_total -= ioc->HostPageBuffer_sz;
+	}
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1873,36 +2092,42 @@
 static void
 mpt_adapter_dispose(MPT_ADAPTER *ioc)
 {
-	if (ioc != NULL) {
-		int sz_first, sz_last;
+	int sz_first, sz_last;
+
+	if (ioc == NULL)
+		return;
 
-		sz_first = ioc->alloc_total;
+	sz_first = ioc->alloc_total;
 
-		mpt_adapter_disable(ioc);
+	mpt_adapter_disable(ioc);
 
-		if (ioc->pci_irq != -1) {
-			free_irq(ioc->pci_irq, ioc);
-			ioc->pci_irq = -1;
+	if (ioc->pci_irq != -1) {
+		free_irq(ioc->pci_irq, ioc);
+		if (mpt_msi_enable == 1) {
+			pci_disable_msi(ioc->pcidev);
 		}
+		ioc->pci_irq = -1;
+	}
 
-		if (ioc->memmap != NULL)
-			iounmap(ioc->memmap);
+	if (ioc->memmap != NULL) {
+		iounmap(ioc->memmap);
+		ioc->memmap = NULL;
+	}
 
 #if defined(CONFIG_MTRR) && 0
-		if (ioc->mtrr_reg > 0) {
-			mtrr_del(ioc->mtrr_reg, 0, 0);
-			dprintk((KERN_INFO MYNAM ": %s: MTRR region de-registered\n", ioc->name));
-		}
+	if (ioc->mtrr_reg > 0) {
+		mtrr_del(ioc->mtrr_reg, 0, 0);
+		dprintk((KERN_INFO MYNAM ": %s: MTRR region de-registered\n", ioc->name));
+	}
 #endif
 
-		/*  Zap the adapter lookup ptr!  */
-		list_del(&ioc->list);
+	/*  Zap the adapter lookup ptr!  */
+	list_del(&ioc->list);
 
-		sz_last = ioc->alloc_total;
-		dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
-				ioc->name, sz_first-sz_last+(int)sizeof(*ioc), sz_first));
-		kfree(ioc);
-	}
+	sz_last = ioc->alloc_total;
+	dprintk((KERN_INFO MYNAM ": %s: free'd %d of %d bytes\n",
+			ioc->name, sz_first-sz_last+(int)sizeof(*ioc), sz_first));
+	kfree(ioc);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1989,7 +2214,7 @@
 	}
 
 	/* Is it already READY? */
-	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_READY) 
+	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_READY)
 		return 0;
 
 	/*
@@ -2038,7 +2263,7 @@
 	 *  Loop here waiting for IOC to come READY.
 	 */
 	ii = 0;
-	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 15;	/* 15 seconds */
+	cntdn = ((sleepFlag == CAN_SLEEP) ? HZ : 1000) * 5;	/* 5 seconds */
 
 	while ((ioc_state = mpt_GetIocState(ioc, 1)) != MPI_IOC_STATE_READY) {
 		if (ioc_state == MPI_IOC_STATE_OPERATIONAL) {
@@ -2152,8 +2377,8 @@
 	get_facts.Function = MPI_FUNCTION_IOC_FACTS;
 	/* Assert: All other get_facts fields are zero! */
 
-	dinitprintk((MYIOC_s_INFO_FMT 
-	    "Sending get IocFacts request req_sz=%d reply_sz=%d\n", 
+	dinitprintk((MYIOC_s_INFO_FMT
+	    "Sending get IocFacts request req_sz=%d reply_sz=%d\n",
 	    ioc->name, req_sz, reply_sz));
 
 	/* No non-zero fields in the get_facts request are greater than
@@ -2216,6 +2441,7 @@
 				le32_to_cpu(facts->CurrentSenseBufferHighAddr);
 		facts->CurReplyFrameSize =
 				le16_to_cpu(facts->CurReplyFrameSize);
+		facts->IOCCapabilities = le32_to_cpu(facts->IOCCapabilities);
 
 		/*
 		 * Handle NEW (!) IOCFactsReply fields in MPI-1.01.xx
@@ -2233,7 +2459,7 @@
 		if ( sz & 0x02 )
 			sz += 2;
 		facts->FWImageSize = sz;
-		
+
 		if (!facts->RequestFrameSize) {
 			/*  Something is wrong!  */
 			printk(MYIOC_s_ERR_FMT "IOC reported invalid 0 request size!\n",
@@ -2252,7 +2478,7 @@
 		ioc->NBShiftFactor  = shiftFactor;
 		dinitprintk((MYIOC_s_INFO_FMT "NB_for_64_byte_frame=%x NBShiftFactor=%x BlockSize=%x\n",
 					ioc->name, vv, shiftFactor, r));
-    
+
 		if (reason == MPT_HOSTEVENT_IOC_BRINGUP) {
 			/*
 			 * Set values for this IOC's request & reply frame sizes,
@@ -2273,7 +2499,7 @@
 				return r;
 		}
 	} else {
-		printk(MYIOC_s_ERR_FMT 
+		printk(MYIOC_s_ERR_FMT
 		     "Invalid IOC facts reply, msgLength=%d offsetof=%zd!\n",
 		     ioc->name, facts->MsgLength, (offsetof(IOCFactsReply_t,
 		     RequestFrameSize)/sizeof(u32)));
@@ -2387,13 +2613,25 @@
 	ddlprintk((MYIOC_s_INFO_FMT "upload_fw %d facts.Flags=%x\n",
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));
 
-	if (ioc->bus_type == FC)
+	if(ioc->bus_type == SAS)
+		ioc_init.MaxDevices = ioc->facts.MaxDevices;
+	else if(ioc->bus_type == FC)
 		ioc_init.MaxDevices = MPT_MAX_FC_DEVICES;
 	else
 		ioc_init.MaxDevices = MPT_MAX_SCSI_DEVICES;
-	
 	ioc_init.MaxBuses = MPT_MAX_BUS;
-
+	dinitprintk((MYIOC_s_INFO_FMT "facts.MsgVersion=%x\n",
+		   ioc->name, ioc->facts.MsgVersion));
+	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05) {
+		// set MsgVersion and HeaderVersion host driver was built with
+		ioc_init.MsgVersion = cpu_to_le16(MPI_VERSION);
+	        ioc_init.HeaderVersion = cpu_to_le16(MPI_HEADER_VERSION);
+
+		if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_HOST_PAGE_BUFFER_PERSISTENT) {
+			ioc_init.HostPageBufferSGE = ioc->facts.HostPageBufferSGE;
+		} else if(mpt_host_page_alloc(ioc, &ioc_init))
+			return -99;
+	}
 	ioc_init.ReplyFrameSize = cpu_to_le16(ioc->reply_sz);	/* in BYTES */
 
 	if (sizeof(dma_addr_t) == sizeof(u64)) {
@@ -2407,17 +2645,21 @@
 		ioc_init.HostMfaHighAddr = cpu_to_le32(0);
 		ioc_init.SenseBufferHighAddr = cpu_to_le32(0);
 	}
-		
+
 	ioc->facts.CurrentHostMfaHighAddr = ioc_init.HostMfaHighAddr;
 	ioc->facts.CurrentSenseBufferHighAddr = ioc_init.SenseBufferHighAddr;
+	ioc->facts.MaxDevices = ioc_init.MaxDevices;
+	ioc->facts.MaxBuses = ioc_init.MaxBuses;
 
 	dhsprintk((MYIOC_s_INFO_FMT "Sending IOCInit (req @ %p)\n",
 			ioc->name, &ioc_init));
 
 	r = mpt_handshake_req_reply_wait(ioc, sizeof(IOCInit_t), (u32*)&ioc_init,
 				sizeof(MPIDefaultReply_t), (u16*)&init_reply, 10 /*seconds*/, sleepFlag);
-	if (r != 0)
+	if (r != 0) {
+		printk(MYIOC_s_ERR_FMT "Sending IOCInit failed(%d)!\n",ioc->name, r);
 		return r;
+	}
 
 	/* No need to byte swap the multibyte fields in the reply
 	 * since we don't even look at it's contents.
@@ -2425,9 +2667,11 @@
 
 	dhsprintk((MYIOC_s_INFO_FMT "Sending PortEnable (req @ %p)\n",
 			ioc->name, &ioc_init));
-	
-	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0)
+
+	if ((r = SendPortEnable(ioc, 0, sleepFlag)) != 0) {
+		printk(MYIOC_s_ERR_FMT "Sending PortEnable failed(%d)!\n",ioc->name, r);
 		return r;
+	}
 
 	/* YIKES!  SUPER IMPORTANT!!!
 	 *  Poll IocState until _OPERATIONAL while IOC is doing
@@ -2474,7 +2718,7 @@
 {
 	PortEnable_t		 port_enable;
 	MPIDefaultReply_t	 reply_buf;
-	int	 ii;
+	int	 rc;
 	int	 req_sz;
 	int	 reply_sz;
 
@@ -2496,22 +2740,15 @@
 
 	/* RAID FW may take a long time to enable
 	 */
-	if (ioc->bus_type == FC) {
-		ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
-				reply_sz, (u16*)&reply_buf, 65 /*seconds*/, sleepFlag);
-	} else {
-		ii = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
+	if ( (ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
+			> MPI_FW_HEADER_PID_PROD_TARGET_SCSI ) {
+		rc = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
 				reply_sz, (u16*)&reply_buf, 300 /*seconds*/, sleepFlag);
+	} else {
+		rc = mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&port_enable,
+				reply_sz, (u16*)&reply_buf, 30 /*seconds*/, sleepFlag);
 	}
-
-	if (ii != 0)
-		return ii;
-
-	/* We do not even look at the reply, so we need not
-	 * swap the multi-byte fields.
-	 */
-
-	return 0;
+	return rc;
 }
 
 /*
@@ -2587,7 +2824,7 @@
 
 	dinitprintk((KERN_WARNING MYNAM ": FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 		 ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
-	
+
 	if (ioc->cached_fw == NULL) {
 		/* Major Failure.
 		 */
@@ -2642,7 +2879,7 @@
 	dinitprintk((MYIOC_s_INFO_FMT ": do_upload status %d \n",
 			ioc->name, cmdStatus));
 
-	
+
 	if (cmdStatus) {
 
 		ddlprintk((MYIOC_s_INFO_FMT ": fw upload failed, freeing image \n",
@@ -2668,9 +2905,8 @@
  *		<0 for fw upload failure.
  */
 static int
-mpt_downloadboot(MPT_ADAPTER *ioc, int sleepFlag)
+mpt_downloadboot(MPT_ADAPTER *ioc, MpiFwHeader_t *pFwHeader, int sleepFlag)
 {
-	MpiFwHeader_t		*pFwHeader;
 	MpiExtImageHeader_t	*pExtImage;
 	u32			 fwSize;
 	u32			 diag0val;
@@ -2681,18 +2917,8 @@
 	u32			 load_addr;
 	u32 			 ioc_state=0;
 
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x, ioc FW Ptr %p\n",
-				ioc->name, ioc->facts.FWImageSize, ioc->cached_fw));
-
-	if ( ioc->facts.FWImageSize == 0 )
-		return -1;
-
-	if (ioc->cached_fw == NULL)
-		return -2;
-
-	/* prevent a second downloadboot and memory free with alt_ioc */
-	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
-		ioc->alt_ioc->cached_fw = NULL;
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot: fw size 0x%x (%d), FW Ptr %p\n",
+				ioc->name, pFwHeader->ImageSize, pFwHeader->ImageSize, pFwHeader));
 
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, MPI_WRSEQ_1ST_KEY_VALUE);
@@ -2720,16 +2946,17 @@
 				ioc->name, count));
 			break;
 		}
-		/* wait 1 sec */
+		/* wait .1 sec */
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (1000);
+			msleep_interruptible (100);
 		} else {
-			mdelay (1000);
+			mdelay (100);
 		}
 	}
 
 	if ( count == 30 ) {
-		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! Unable to RESET_ADAPTER diag0val=%x\n",
+		ddlprintk((MYIOC_s_INFO_FMT "downloadboot failed! "
+		"Unable to get MPI_DIAG_DRWE mode, diag0val=%x\n",
 		ioc->name, diag0val));
 		return -3;
 	}
@@ -2744,7 +2971,6 @@
 	/* Set the DiagRwEn and Disable ARM bits */
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, (MPI_DIAG_RW_ENABLE | MPI_DIAG_DISABLE_ARM));
 
-	pFwHeader = (MpiFwHeader_t *) ioc->cached_fw;
 	fwSize = (pFwHeader->ImageSize + 3)/4;
 	ptrFw = (u32 *) pFwHeader;
 
@@ -2794,19 +3020,38 @@
 	/* Clear the internal flash bad bit - autoincrementing register,
 	 * so must do two writes.
 	 */
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
-	diagRwData = CHIPREG_PIO_READ32(&ioc->pio_chip->DiagRwData);
-	diagRwData |= 0x4000000;
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
-	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
+	if (ioc->bus_type == SCSI) {
+		/*
+		 * 1030 and 1035 H/W errata, workaround to access
+		 * the ClearFlashBadSignatureBit
+		 */
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
+		diagRwData = CHIPREG_PIO_READ32(&ioc->pio_chip->DiagRwData);
+		diagRwData |= 0x40000000;
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);
+		CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);
+
+	} else /* if((ioc->bus_type == SAS) || (ioc->bus_type == FC)) */ {
+		diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+		CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val |
+		    MPI_DIAG_CLEAR_FLASH_BAD_SIG);
+
+		/* wait 1 msec */
+		if (sleepFlag == CAN_SLEEP) {
+			msleep_interruptible (1);
+		} else {
+			mdelay (1);
+		}
+	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(ioc->pcidev);
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
-	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, turning off PREVENT_IOC_BOOT, DISABLE_ARM\n",
+	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=%x, "
+		"turning off PREVENT_IOC_BOOT, DISABLE_ARM, RW_ENABLE\n",
 		ioc->name, diag0val));
-	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM);
+	diag0val &= ~(MPI_DIAG_PREVENT_IOC_BOOT | MPI_DIAG_DISABLE_ARM | MPI_DIAG_RW_ENABLE);
 	ddlprintk((MYIOC_s_INFO_FMT "downloadboot now diag0val=%x\n",
 		ioc->name, diag0val));
 	CHIPREG_WRITE32(&ioc->chip->Diagnostic, diag0val);
@@ -2814,10 +3059,23 @@
 	/* Write 0xFF to reset the sequencer */
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);
 
+	if (ioc->bus_type == SAS) {
+		ioc_state = mpt_GetIocState(ioc, 0);
+		if ( (GetIocFacts(ioc, sleepFlag,
+				MPT_HOSTEVENT_IOC_BRINGUP)) != 0 ) {
+			ddlprintk((MYIOC_s_INFO_FMT "GetIocFacts failed: IocState=%x\n",
+					ioc->name, ioc_state));
+			return -EFAULT;
+		}
+	}
+
 	for (count=0; count<HZ*20; count++) {
 		if ((ioc_state = mpt_GetIocState(ioc, 0)) & MPI_IOC_STATE_READY) {
 			ddlprintk((MYIOC_s_INFO_FMT "downloadboot successful! (count=%d) IocState=%x\n",
 					ioc->name, count, ioc_state));
+			if (ioc->bus_type == SAS) {
+				return 0;
+			}
 			if ((SendIocInit(ioc, sleepFlag)) != 0) {
 				ddlprintk((MYIOC_s_INFO_FMT "downloadboot: SendIocInit failed\n",
 					ioc->name));
@@ -2857,9 +3115,9 @@
  *			  0 else
  *
  *	Returns:
- *		 1 - hard reset, READY	
- *		 0 - no reset due to History bit, READY	
- *		-1 - no reset due to History bit but not READY	
+ *		 1 - hard reset, READY
+ *		 0 - no reset due to History bit, READY
+ *		-1 - no reset due to History bit but not READY
  *		     OR reset but failed to come READY
  *		-2 - no reset, could not enter DIAG mode
  *		-3 - reset but bad FW bit
@@ -3051,12 +3309,13 @@
 
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
-					ssleep(1);
+					msleep_interruptible (1000);
 				} else {
 					mdelay (1000);
 				}
 			}
-			if ((count = mpt_downloadboot(ioc, sleepFlag)) < 0) {
+			if ((count = mpt_downloadboot(ioc,
+				(MpiFwHeader_t *)ioc->cached_fw, sleepFlag)) < 0) {
 				printk(KERN_WARNING MYNAM
 					": firmware downloadboot failure (%d)!\n", count);
 			}
@@ -3600,7 +3859,7 @@
 		 */
 		if (!failcnt && (t = WaitForDoorbellReply(ioc, maxwait, sleepFlag)) < 0)
 			failcnt++;
-		
+
 		dhsprintk((MYIOC_s_INFO_FMT "HandShake reply count=%d%s\n",
 				ioc->name, t, failcnt ? " - MISSING DOORBELL REPLY!" : ""));
 
@@ -3759,7 +4018,7 @@
 	}
 
 	dhsprintk((MYIOC_s_INFO_FMT "WaitCnt=%d First handshake reply word=%08x%s\n",
-			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply), 
+			ioc->name, t, le32_to_cpu(*(u32 *)hs_reply),
 			failcnt ? " - MISSING DOORBELL HANDSHAKE!" : ""));
 
 	/*
@@ -4000,6 +4259,85 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *	mptbase_sas_persist_operation - Perform operation on SAS Persitent Table
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sas_address: 64bit SAS Address for operation.
+ *	@target_id: specified target for operation
+ *	@bus: specified bus for operation
+ *	@persist_opcode: see below
+ *
+ *	MPI_SAS_OP_CLEAR_NOT_PRESENT - Free all persist TargetID mappings for
+ *		devices not currently present.
+ *	MPI_SAS_OP_CLEAR_ALL_PERSISTENT - Clear al persist TargetID mappings
+ *
+ *	NOTE: Don't use not this function during interrupt time.
+ *
+ *	Returns: 0 for success, non-zero error
+ */
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+int
+mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode)
+{
+	SasIoUnitControlRequest_t	*sasIoUnitCntrReq;
+	SasIoUnitControlReply_t		*sasIoUnitCntrReply;
+	MPT_FRAME_HDR			*mf = NULL;
+	MPIHeader_t			*mpi_hdr;
+
+
+	/* insure garbage is not sent to fw */
+	switch(persist_opcode) {
+
+	case MPI_SAS_OP_CLEAR_NOT_PRESENT:
+	case MPI_SAS_OP_CLEAR_ALL_PERSISTENT:
+		break;
+
+	default:
+		return -1;
+		break;
+	}
+
+	printk("%s: persist_opcode=%x\n",__FUNCTION__, persist_opcode);
+
+	/* Get a MF for this command.
+	 */
+	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+		printk("%s: no msg frames!\n",__FUNCTION__);
+		return -1;
+        }
+
+	mpi_hdr = (MPIHeader_t *) mf;
+	sasIoUnitCntrReq = (SasIoUnitControlRequest_t *)mf;
+	memset(sasIoUnitCntrReq,0,sizeof(SasIoUnitControlRequest_t));
+	sasIoUnitCntrReq->Function = MPI_FUNCTION_SAS_IO_UNIT_CONTROL;
+	sasIoUnitCntrReq->MsgContext = mpi_hdr->MsgContext;
+	sasIoUnitCntrReq->Operation = persist_opcode;
+
+	init_timer(&ioc->persist_timer);
+	ioc->persist_timer.data = (unsigned long) ioc;
+	ioc->persist_timer.function = mpt_timer_expired;
+	ioc->persist_timer.expires = jiffies + HZ*10 /* 10 sec */;
+	ioc->persist_wait_done=0;
+	add_timer(&ioc->persist_timer);
+	mpt_put_msg_frame(mpt_base_index, ioc, mf);
+	wait_event(mpt_waitq, ioc->persist_wait_done);
+
+	sasIoUnitCntrReply =
+	    (SasIoUnitControlReply_t *)ioc->persist_reply_frame;
+	if ( sasIoUnitCntrReply->IOCStatus != MPI_IOCSTATUS_SUCCESS) {
+		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
+		    __FUNCTION__,
+		    sasIoUnitCntrReply->IOCStatus,
+		    sasIoUnitCntrReply->IOCLogInfo);
+		return -1;
+	}
+
+	printk("%s: success\n",__FUNCTION__);
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *	GetIoUnitPage2 - Retrieve BIOS version and boot order information.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
@@ -4332,10 +4670,10 @@
 	if (mpt_config(ioc, &cfg) != 0)
 		goto done_and_free;
 
-	if ( (mem = (u8 *)ioc->spi_data.pIocPg2) == NULL ) {
+	if ( (mem = (u8 *)ioc->raid_data.pIocPg2) == NULL ) {
 		mem = kmalloc(iocpage2sz, GFP_ATOMIC);
 		if (mem) {
-			ioc->spi_data.pIocPg2 = (IOCPage2_t *) mem;
+			ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 		} else {
 			goto done_and_free;
 		}
@@ -4352,7 +4690,7 @@
 		/* At least 1 RAID Volume
 		 */
 		pIocRv = pIoc2->RaidVolume;
-		ioc->spi_data.isRaid = 0;
+		ioc->raid_data.isRaid = 0;
 		for (jj = 0; jj < nVols; jj++, pIocRv++) {
 			vid = pIocRv->VolumeID;
 			vbus = pIocRv->VolumeBus;
@@ -4361,7 +4699,7 @@
 			/* find the match
 			 */
 			if (vbus == 0) {
-				ioc->spi_data.isRaid |= (1 << vid);
+				ioc->raid_data.isRaid |= (1 << vid);
 			} else {
 				/* Error! Always bus 0
 				 */
@@ -4396,8 +4734,8 @@
 
 	/* Free the old page
 	 */
-	kfree(ioc->spi_data.pIocPg3);
-	ioc->spi_data.pIocPg3 = NULL;
+	kfree(ioc->raid_data.pIocPg3);
+	ioc->raid_data.pIocPg3 = NULL;
 
 	/* There is at least one physical disk.
 	 * Read and save IOC Page 3
@@ -4434,7 +4772,7 @@
 		mem = kmalloc(iocpage3sz, GFP_ATOMIC);
 		if (mem) {
 			memcpy(mem, (u8 *)pIoc3, iocpage3sz);
-			ioc->spi_data.pIocPg3 = (IOCPage3_t *) mem;
+			ioc->raid_data.pIocPg3 = (IOCPage3_t *) mem;
 		}
 	}
 
@@ -4534,7 +4872,7 @@
 	cfg.physAddr = ioc1_dma;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	if (mpt_config(ioc, &cfg) == 0) {
-		
+
 		tmp = le32_to_cpu(pIoc1->Flags) & MPI_IOCPAGE1_REPLY_COALESCING;
 		if (tmp == MPI_IOCPAGE1_REPLY_COALESCING) {
 			tmp = le32_to_cpu(pIoc1->CoalescingTimeout);
@@ -5333,8 +5671,8 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-static char *
-EventDescriptionStr(u8 event, u32 evData0)
+static void
+EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 {
 	char *ds;
 
@@ -5387,8 +5725,95 @@
 			ds = "Events(OFF) Change";
 		break;
 	case MPI_EVENT_INTEGRATED_RAID:
-		ds = "Integrated Raid";
+	{
+		u8 ReasonCode = (u8)(evData0 >> 16);
+		switch (ReasonCode) {
+		case MPI_EVENT_RAID_RC_VOLUME_CREATED :
+			ds = "Integrated Raid: Volume Created";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_DELETED :
+			ds = "Integrated Raid: Volume Deleted";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_SETTINGS_CHANGED :
+			ds = "Integrated Raid: Volume Settings Changed";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_STATUS_CHANGED :
+			ds = "Integrated Raid: Volume Status Changed";
+			break;
+		case MPI_EVENT_RAID_RC_VOLUME_PHYSDISK_CHANGED :
+			ds = "Integrated Raid: Volume Physdisk Changed";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_CREATED :
+			ds = "Integrated Raid: Physdisk Created";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_DELETED :
+			ds = "Integrated Raid: Physdisk Deleted";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_SETTINGS_CHANGED :
+			ds = "Integrated Raid: Physdisk Settings Changed";
+			break;
+		case MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED :
+			ds = "Integrated Raid: Physdisk Status Changed";
+			break;
+		case MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED :
+			ds = "Integrated Raid: Domain Validation Needed";
+			break;
+		case MPI_EVENT_RAID_RC_SMART_DATA :
+			ds = "Integrated Raid; Smart Data";
+			break;
+		case MPI_EVENT_RAID_RC_REPLACE_ACTION_STARTED :
+			ds = "Integrated Raid: Replace Action Started";
+			break;
+		default:
+			ds = "Integrated Raid";
 		break;
+		}
+		break;
+	}
+	case MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE:
+		ds = "SCSI Device Status Change";
+		break;
+	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
+	{
+		u8 ReasonCode = (u8)(evData0 >> 16);
+		switch (ReasonCode) {
+		case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
+			ds = "SAS Device Status Change: Added";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
+			ds = "SAS Device Status Change: Deleted";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
+			ds = "SAS Device Status Change: SMART Data";
+			break;
+		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
+			ds = "SAS Device Status Change: No Persistancy Added";
+			break;
+		default:
+			ds = "SAS Device Status Change: Unknown";
+		break;
+		}
+		break;
+	}
+	case MPI_EVENT_ON_BUS_TIMER_EXPIRED:
+		ds = "Bus Timer Expired";
+		break;
+	case MPI_EVENT_QUEUE_FULL:
+		ds = "Queue Full";
+		break;
+	case MPI_EVENT_SAS_SES:
+		ds = "SAS SES Event";
+		break;
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:
+		ds = "Persistent Table Full";
+		break;
+	case MPI_EVENT_SAS_PHY_LINK_STATUS:
+		ds = "SAS PHY Link Status";
+		break;
+	case MPI_EVENT_SAS_DISCOVERY_ERROR:
+		ds = "SAS Discovery Error";
+		break;
+
 	/*
 	 *  MPT base "custom" events may be added here...
 	 */
@@ -5396,7 +5821,7 @@
 		ds = "Unknown";
 		break;
 	}
-	return ds;
+	strcpy(evStr,ds);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5418,7 +5843,7 @@
 	int ii;
 	int r = 0;
 	int handlers = 0;
-	char *evStr;
+	char evStr[100];
 	u8 event;
 
 	/*
@@ -5431,7 +5856,7 @@
 		evData0 = le32_to_cpu(pEventReply->Data[0]);
 	}
 
-	evStr = EventDescriptionStr(event, evData0);
+	EventDescriptionStr(event, evData0, evStr);
 	devtprintk((MYIOC_s_INFO_FMT "MPT event (%s=%02Xh) detected!\n",
 			ioc->name,
 			evStr,
@@ -5448,20 +5873,6 @@
 	 *  Do general / base driver event processing
 	 */
 	switch(event) {
-	case MPI_EVENT_NONE:			/* 00 */
-	case MPI_EVENT_LOG_DATA:		/* 01 */
-	case MPI_EVENT_STATE_CHANGE:		/* 02 */
-	case MPI_EVENT_UNIT_ATTENTION:		/* 03 */
-	case MPI_EVENT_IOC_BUS_RESET:		/* 04 */
-	case MPI_EVENT_EXT_BUS_RESET:		/* 05 */
-	case MPI_EVENT_RESCAN:			/* 06 */
-	case MPI_EVENT_LINK_STATUS_CHANGE:	/* 07 */
-	case MPI_EVENT_LOOP_STATE_CHANGE:	/* 08 */
-	case MPI_EVENT_LOGOUT:			/* 09 */
-	case MPI_EVENT_INTEGRATED_RAID:		/* 0B */
-	case MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE:	/* 0C */
-	default:
-		break;
 	case MPI_EVENT_EVENT_CHANGE:		/* 0A */
 		if (evDataLen) {
 			u8 evState = evData0 & 0xFF;
@@ -5474,6 +5885,8 @@
 			}
 		}
 		break;
+	default:
+		break;
 	}
 
 	/*
@@ -5516,6 +5929,8 @@
 	 *  If needed, send (a single) EventAck.
 	 */
 	if (pEventReply->AckRequired == MPI_EVENT_NOTIFICATION_ACK_REQUIRED) {
+		devtprintk((MYIOC_s_WARN_FMT
+			"EventAck required\n",ioc->name));
 		if ((ii = SendEventAck(ioc, pEventReply)) != 0) {
 			devtprintk((MYIOC_s_WARN_FMT "SendEventAck returned %d\n",
 					ioc->name, ii));
@@ -5596,7 +6011,7 @@
 	case 0x00080000:
 		desc = "Outbound DMA Overrun";
 		break;
-	
+
 	case 0x00090000:
 		desc = "Task Management";
 		break;
@@ -5612,7 +6027,7 @@
 	case 0x000C0000:
 		desc = "Untagged Table Size";
 		break;
-	
+
 	}
 
 	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): F/W: %s\n", ioc->name, log_info, desc);
@@ -5704,7 +6119,7 @@
 		break;
 
 	case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN: /* 0x0045 */
-		/* This error is checked in scsi_io_done(). Skip. 
+		/* This error is checked in scsi_io_done(). Skip.
 		desc = "SCSI Data Underrun";
 		*/
 		break;
@@ -5779,6 +6194,7 @@
 EXPORT_SYMBOL(mpt_read_ioc_pg_3);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
+EXPORT_SYMBOL(mptbase_sas_persist_operation);
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
--- b/drivers/message/fusion/mptscsih.c	2005-05-10 14:27:13.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2005-05-31 17:35:44.000000000 -0600
@@ -62,6 +62,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -93,8 +94,9 @@
 
 #define MPT_ICFLAG_BUF_CAP	0x01	/* ReadBuffer Read Capacity format */
 #define MPT_ICFLAG_ECHO		0x02	/* ReadBuffer Echo buffer format */
-#define MPT_ICFLAG_PHYS_DISK	0x04	/* Any SCSI IO but do Phys Disk Format */
-#define MPT_ICFLAG_TAGGED_CMD	0x08	/* Do tagged IO */
+#define MPT_ICFLAG_EBOS		0x04	/* ReadBuffer Echo buffer has EBOS */
+#define MPT_ICFLAG_PHYS_DISK	0x08	/* Any SCSI IO but do Phys Disk Format */
+#define MPT_ICFLAG_TAGGED_CMD	0x10	/* Do tagged IO */
 #define MPT_ICFLAG_DID_RESET	0x20	/* Bus Reset occurred with this command */
 #define MPT_ICFLAG_RESERVED	0x40	/* Reserved has been issued */
 
@@ -159,6 +161,8 @@
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int portnum);
 
+static struct work_struct   mptscsih_persistTask;
+
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD *io);
 static void	mptscsih_domainValidation(void *hd);
@@ -167,6 +171,7 @@
 static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int target);
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void *pPage);
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int width);
+static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);
 #endif
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -176,6 +181,8 @@
 int 		mptscsih_resume(struct pci_dev *pdev);
 #endif
 
+static void	mptscsih_sas_persist_clear_table(void * arg);
+
 #define SNS_LEN(scp)	sizeof((scp)->sense_buffer)
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
@@ -432,7 +439,7 @@
 			 */
 			pReq->ChainOffset = 0;
 			RequestNB = (((sgeOffset - 1) >> ioc->NBShiftFactor)  + 1) & 0x03;
-			dsgprintk((MYIOC_s_ERR_FMT 
+			dsgprintk((MYIOC_s_ERR_FMT
 			    "Single Buffer RequestNB=%x, sgeOffset=%d\n", ioc->name, RequestNB, sgeOffset));
 			ioc->RequestNB[req_idx] = RequestNB;
 		}
@@ -491,7 +498,7 @@
 		/* NOTE: psge points to the beginning of the chain element
 		 * in current buffer. Get a chain buffer.
 		 */
-		dsgprintk((MYIOC_s_INFO_FMT 
+		dsgprintk((MYIOC_s_INFO_FMT
 		    "calling getFreeChainBuffer SCSI cmd=%02x (%p)\n",
 		    ioc->name, pReq->CDB[0], SCpnt));
 		if ((mptscsih_getFreeChainBuffer(ioc, &newIndex)) == FAILED)
@@ -556,11 +563,24 @@
 	MPT_SCSI_HOST	*hd;
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
-	u16		 req_idx;
+	u16		 req_idx, req_idx_MR;
 
 	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
 
 	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
+	req_idx_MR = (mr != NULL) ?
+	    le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx) : req_idx;
+	if ((req_idx != req_idx_MR) ||
+	    (mf->u.frame.linkage.arg1 == 0xdeadbeaf)) {
+		printk(MYIOC_s_ERR_FMT "Received a mf that was already freed\n",
+		    ioc->name);
+		printk (MYIOC_s_ERR_FMT
+		    "req_idx=%x req_idx_MR=%x mf=%p mr=%p sc=%p\n",
+		    ioc->name, req_idx, req_idx_MR, mf, mr,
+		    hd->ScsiLookup[req_idx_MR]);
+		return 0;
+	}
+
 	sc = hd->ScsiLookup[req_idx];
 	if (sc == NULL) {
 		MPIHeader_t *hdr = (MPIHeader_t *)mf;
@@ -577,14 +597,20 @@
 		return 1;
 	}
 
-	dmfprintk((MYIOC_s_INFO_FMT
-		"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d)\n",
-		ioc->name, mf, mr, sc, req_idx));
-
 	sc->result = DID_OK << 16;		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
 	pScsiReply = (SCSIIOReply_t *) mr;
 
+	if((ioc->facts.MsgVersion >= MPI_VERSION_01_05) && pScsiReply){
+		dmfprintk((MYIOC_s_INFO_FMT
+			"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d,task-tag=%d)\n",
+			ioc->name, mf, mr, sc, req_idx, pScsiReply->TaskTag));
+	}else{
+		dmfprintk((MYIOC_s_INFO_FMT
+			"ScsiDone (mf=%p,mr=%p,sc=%p,idx=%d)\n",
+			ioc->name, mf, mr, sc, req_idx));
+	}
+
 	if (pScsiReply == NULL) {
 		/* special context reply handling */
 		;
@@ -599,11 +625,24 @@
 		xfer_cnt = le32_to_cpu(pScsiReply->TransferCount);
 		sc->resid = sc->request_bufflen - xfer_cnt;
 
+		/*
+		 *  if we get a data underrun indication, yet no data was
+		 *  transferred and the SCSI status indicates that the
+		 *  command was never started, change the data underrun
+		 *  to success
+		 */
+		if (status == MPI_IOCSTATUS_SCSI_DATA_UNDERRUN && xfer_cnt == 0 &&
+		    (scsi_status == MPI_SCSI_STATUS_BUSY ||
+		     scsi_status == MPI_SCSI_STATUS_RESERVATION_CONFLICT ||
+		     scsi_status == MPI_SCSI_STATUS_TASK_SET_FULL)) {
+			status = MPI_IOCSTATUS_SUCCESS;
+		}
+
 		dreplyprintk((KERN_NOTICE "Reply ha=%d id=%d lun=%d:\n"
 			"IOCStatus=%04xh SCSIState=%02xh SCSIStatus=%02xh\n"
 			"resid=%d bufflen=%d xfer_cnt=%d\n",
 			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],
-			status, scsi_state, scsi_status, sc->resid, 
+			status, scsi_state, scsi_status, sc->resid,
 			sc->request_bufflen, xfer_cnt));
 
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)
@@ -612,8 +651,11 @@
 		/*
 		 *  Look for + dump FCP ResponseInfo[]!
 		 */
-		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID) {
-			printk(KERN_NOTICE "  FCP_ResponseInfo=%08xh\n",
+		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&
+		    pScsiReply->ResponseInfo) {
+			printk(KERN_NOTICE "ha=%d id=%d lun=%d: "
+			"FCP_ResponseInfo=%08xh\n",
+			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],
 			le32_to_cpu(pScsiReply->ResponseInfo));
 		}
 
@@ -658,8 +700,8 @@
 				/* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
 			} else if ( xfer_cnt == 0 ) {
-				/* A CRC Error causes this condition; retry */ 
-				sc->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | 
+				/* A CRC Error causes this condition; retry */
+				sc->result = (DRIVER_SENSE << 24) | (DID_OK << 16) |
 					(CHECK_CONDITION << 1);
 				sc->sense_buffer[0] = 0x70;
 				sc->sense_buffer[2] = NO_SENSE;
@@ -668,7 +710,9 @@
 			} else {
 				sc->result = DID_SOFT_ERROR << 16;
 			}
-			dreplyprintk((KERN_NOTICE "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->target));
+			dreplyprintk((KERN_NOTICE
+			    "RESIDUAL_MISMATCH: result=%x on id=%d\n",
+			    sc->result, sc->device->id));
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */
@@ -683,7 +727,10 @@
 				;
 			} else {
 				if (xfer_cnt < sc->underflow) {
-					sc->result = DID_SOFT_ERROR << 16;
+					if (scsi_status == SAM_STAT_BUSY)
+						sc->result = SAM_STAT_BUSY;
+					else
+						sc->result = DID_SOFT_ERROR << 16;
 				}
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | MPI_SCSI_STATE_NO_SCSI_STATUS)) {
 					/* What to do?
@@ -708,8 +755,10 @@
 
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			scsi_status = pScsiReply->SCSIStatus;
-			sc->result = (DID_OK << 16) | scsi_status;
+			if (scsi_status == MPI_SCSI_STATUS_BUSY)
+				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
+			else
+				sc->result = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
 				;
 			} else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
@@ -882,12 +931,13 @@
 	SCSIIORequest_t	*mf = NULL;
 	int		 ii;
 	int		 max = hd->ioc->req_depth;
+	struct scsi_cmnd *sc;
 
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max %d\n",
 			target, lun, max));
 
 	for (ii=0; ii < max; ii++) {
-		if (hd->ScsiLookup[ii] != NULL) {
+		if ((sc = hd->ScsiLookup[ii]) != NULL) {
 
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);
 
@@ -902,6 +952,20 @@
 			hd->ScsiLookup[ii] = NULL;
 			mptscsih_freeChainBuffers(hd->ioc, ii);
 			mpt_free_msg_frame(hd->ioc, (MPT_FRAME_HDR *)mf);
+			if (sc->use_sg) {
+				pci_unmap_sg(hd->ioc->pcidev,
+				(struct scatterlist *) sc->request_buffer,
+					sc->use_sg,
+					sc->sc_data_direction);
+			} else if (sc->request_bufflen) {
+				pci_unmap_single(hd->ioc->pcidev,
+					sc->SCp.dma_handle,
+					sc->request_bufflen,
+					sc->sc_data_direction);
+			}
+			sc->host_scribble = NULL;
+			sc->result = DID_NO_CONNECT << 16;
+			sc->scsi_done(sc);
 		}
 	}
 
@@ -1017,7 +1081,7 @@
 	scsi_host_put(host);
 
 	mpt_detach(pdev);
-	
+
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1072,7 +1136,7 @@
 	MPT_SCSI_HOST		*hd;
 
 	mpt_resume(pdev);
-	
+
 	if(!host)
 		return 0;
 
@@ -1214,8 +1278,8 @@
 	int size = 0;
 
 	if (func) {
-		/* 
-		 * write is not supported 
+		/*
+		 * write is not supported
 		 */
 	} else {
 		if (start)
@@ -1418,6 +1482,7 @@
 	return 0;
 
  fail:
+	hd->ScsiLookup[my_idx] = NULL;
 	mptscsih_freeChainBuffers(hd->ioc, my_idx);
 	mpt_free_msg_frame(hd->ioc, mf);
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1535,17 +1600,17 @@
 	 */
 	if (mptscsih_tm_pending_wait(hd) == FAILED) {
 		if (type == MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			dtmprintk((KERN_WARNING MYNAM ": %s: TMHandler abort: "
+			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler abort: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			   hd->ioc->name, hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET) {
-			dtmprintk((KERN_WARNING MYNAM ": %s: TMHandler target reset: "
+			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler target reset: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			   hd->ioc->name, hd->tmPending));
 			return FAILED;
 		} else if (type == MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) {
-			dtmprintk((KERN_WARNING MYNAM ": %s: TMHandler bus reset: "
+			dtmprintk((KERN_INFO MYNAM ": %s: TMHandler bus reset: "
 			   "Timed out waiting for last TM (%d) to complete! \n",
 			   hd->ioc->name, hd->tmPending));
 			if (hd->tmPending & (1 << MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS))
@@ -1631,8 +1696,7 @@
 	if ((mf = mpt_get_msg_frame(hd->ioc->TaskCtx, hd->ioc)) == NULL) {
 		dfailprintk((MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",
 				hd->ioc->name));
-		//return FAILED;
-		return -999;
+		return FAILED;
 	}
 	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt request @ %p\n",
 			hd->ioc->name, mf));
@@ -1661,9 +1725,8 @@
 
 	pScsiTm->TaskMsgContext = ctx2abort;
 
-	dtmprintk((MYIOC_s_INFO_FMT
-		"IssueTaskMgmt: ctx2abort (0x%08x) type=%d\n",
-		hd->ioc->name, ctx2abort, type));
+	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort (0x%08x) type=%d\n",
+			hd->ioc->name, ctx2abort, type));
 
 	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);
 
@@ -1708,24 +1771,23 @@
 	u32		 ctx2abort;
 	int		 scpnt_idx;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
+	int		 retval;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
 		SCpnt->result = DID_RESET << 16;
 		SCpnt->scsi_done(SCpnt);
-		dfailprintk((KERN_WARNING MYNAM ": mptscsih_abort: "
+		dfailprintk((KERN_INFO MYNAM ": mptscsih_abort: "
 			   "Can't locate host! (sc=%p)\n",
 			   SCpnt));
 		return FAILED;
 	}
 
 	ioc = hd->ioc;
-	if (hd->resetPending)
+	if (hd->resetPending) {
 		return FAILED;
-
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting task abort! (sc=%p)\n",
-	       hd->ioc->name, SCpnt);
+	}
 
 	if (hd->timeouts < -1)
 		hd->timeouts++;
@@ -1733,16 +1795,20 @@
 	/* Find this command
 	 */
 	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {
-		/* Cmd not found in ScsiLookup. 
+		/* Cmd not found in ScsiLookup.
 		 * Do OS callback.
 		 */
 		SCpnt->result = DID_RESET << 16;
-		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "
+		dtmprintk((KERN_INFO MYNAM ": %s: mptscsih_abort: "
 			   "Command not in the active list! (sc=%p)\n",
 			   hd->ioc->name, SCpnt));
 		return SUCCESS;
 	}
 
+	printk(KERN_WARNING MYNAM ": %s: attempting task abort! (sc=%p)\n",
+	       hd->ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
+
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!
 	 * (the IO to be ABORT'd)
 	 *
@@ -1756,41 +1822,23 @@
 	hd->abortSCpnt = SCpnt;
 
 	spin_unlock_irq(host_lock);
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
-		ctx2abort, 2 /* 2 second timeout */)
-		< 0) {
+		ctx2abort, 2 /* 2 second timeout */);
+	spin_lock_irq(host_lock);
 
-		/* The TM request failed and the subsequent FW-reload failed!
-		 * Fatal error case.
-		 */
-		printk(MYIOC_s_WARN_FMT "Error issuing abort task! (sc=%p)\n",
-		       hd->ioc->name, SCpnt);
+	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
+		hd->ioc->name,
+		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
-		/* We must clear our pending flag before clearing our state.
-		 */
+	if (retval == 0)
+		return SUCCESS;
+
+	if(retval != FAILED ) {
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
-
-		spin_lock_irq(host_lock);
-
-		/* Unmap the DMA buffers, if any. */
-		if (SCpnt->use_sg) {
-			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) SCpnt->request_buffer,
-				    SCpnt->use_sg, SCpnt->sc_data_direction);
-		} else if (SCpnt->request_bufflen) {
-			pci_unmap_single(ioc->pcidev, SCpnt->SCp.dma_handle,
-				SCpnt->request_bufflen, SCpnt->sc_data_direction);
-		}
-		hd->ScsiLookup[scpnt_idx] = NULL;
-		SCpnt->result = DID_RESET << 16;
-		SCpnt->scsi_done(SCpnt);		/* Issue the command callback */
-		mptscsih_freeChainBuffers(ioc, scpnt_idx);
-		mpt_free_msg_frame(ioc, mf);
-		return FAILED;
 	}
-	spin_lock_irq(host_lock);
-	return SUCCESS;
+	return FAILED;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1807,11 +1855,12 @@
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
+	int		 retval;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk((KERN_WARNING MYNAM ": mptscsih_dev_reset: "
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_dev_reset: "
 			   "Can't locate host! (sc=%p)\n",
 			   SCpnt));
 		return FAILED;
@@ -1820,27 +1869,28 @@
 	if (hd->resetPending)
 		return FAILED;
 
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! (sc=%p)\n",
+	printk(KERN_WARNING MYNAM ": %s: attempting target reset! (sc=%p)\n",
 	       hd->ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
 
 	spin_unlock_irq(host_lock);
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 		SCpnt->device->channel, SCpnt->device->id,
-		0, 0, 5 /* 5 second timeout */)
-		< 0){
-		/* The TM request failed and the subsequent FW-reload failed!
-		 * Fatal error case.
-		 */
-		printk(MYIOC_s_WARN_FMT "Error processing TaskMgmt request (sc=%p)\n",
-		 		hd->ioc->name, SCpnt);
+		0, 0, 5 /* 5 second timeout */);
+	spin_lock_irq(host_lock);
+
+	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=%p)\n",
+		hd->ioc->name,
+		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+
+	if (retval == 0)
+		return SUCCESS;
+
+	if(retval != FAILED ) {
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
-		spin_lock_irq(host_lock);
-		return FAILED;
 	}
-	spin_lock_irq(host_lock);
-	return SUCCESS;
-
+	return FAILED;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1857,41 +1907,42 @@
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
+	int		 retval;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk((KERN_WARNING MYNAM ": mptscsih_bus_reset: "
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_bus_reset: "
 			   "Can't locate host! (sc=%p)\n",
 			   SCpnt ) );
 		return FAILED;
 	}
 
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting bus reset! (sc=%p)\n",
+	printk(KERN_WARNING MYNAM ": %s: attempting bus reset! (sc=%p)\n",
 	       hd->ioc->name, SCpnt);
+	scsi_print_command(SCpnt);
 
 	if (hd->timeouts < -1)
 		hd->timeouts++;
 
 	/* We are now ready to execute the task management request. */
 	spin_unlock_irq(host_lock);
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)
-	    < 0){
+	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */);
+	spin_lock_irq(host_lock);
 
-		/* The TM request failed and the subsequent FW-reload failed!
-		 * Fatal error case.
-		 */
-		printk(MYIOC_s_WARN_FMT
-		       "Error processing TaskMgmt request (sc=%p)\n",
-		       hd->ioc->name, SCpnt);
+	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=%p)\n",
+		hd->ioc->name,
+		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+
+	if (retval == 0)
+		return SUCCESS;
+
+	if(retval != FAILED ) {
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
-		spin_lock_irq(host_lock);
-		return FAILED;
 	}
-	spin_lock_irq(host_lock);
-	return SUCCESS;
+	return FAILED;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1913,13 +1964,13 @@
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
-		dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
+		dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
 			     "Can't locate host! (sc=%p)\n",
 			     SCpnt ) );
 		return FAILED;
 	}
 
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting host reset! (sc=%p)\n",
+	printk(KERN_WARNING MYNAM ": %s: Attempting host reset! (sc=%p)\n",
 	       hd->ioc->name, SCpnt);
 
 	/*  If our attempts to reset the host failed, then return a failed
@@ -1938,7 +1989,7 @@
 	spin_lock_irq(host_lock);
 
 
-	dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
+	dtmprintk( ( KERN_INFO MYNAM ": mptscsih_host_reset: "
 		     "Status = %s\n",
 		     (status == SUCCESS) ? "SUCCESS" : "FAILED" ) );
 
@@ -1965,8 +2016,8 @@
 		if (hd->tmState == TM_STATE_NONE) {
 			hd->tmState = TM_STATE_IN_PROGRESS;
 			hd->tmPending = 1;
-			status = SUCCESS;
 			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
+			status = SUCCESS;
 			break;
 		}
 		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
@@ -1994,7 +2045,7 @@
 		spin_lock_irqsave(&hd->ioc->FreeQlock, flags);
 		if(hd->tmPending == 0) {
 			status = SUCCESS;
-			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
+ 			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
 			break;
 		}
 		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
@@ -2005,6 +2056,42 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+static void
+mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code)
+{
+	char *desc;
+
+	switch (response_code) {
+	case MPI_SCSITASKMGMT_RSP_TM_COMPLETE:
+		desc = "The task completed.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_INVALID_FRAME:
+		desc = "The IOC received an invalid frame status.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_NOT_SUPPORTED:
+		desc = "The task type is not supported.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_FAILED:
+		desc = "The requested task failed.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_SUCCEEDED:
+		desc = "The task completed successfully.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_TM_INVALID_LUN:
+		desc = "The LUN request is invalid.";
+		break;
+	case MPI_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC:
+		desc = "The task is in the IOC queue and has not been sent to target.";
+		break;
+	default:
+		desc = "unknown";
+		break;
+	}
+	printk(MYIOC_s_INFO_FMT "Response Code(0x%08x): F/W: %s\n",
+		ioc->name, response_code, desc);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_taskmgmt_complete - Registered with Fusion MPT base driver
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -2053,6 +2140,11 @@
 		/* Figure out if this was ABORT_TASK, TARGET_RESET, or BUS_RESET! */
 		tmType = pScsiTmReq->TaskType;
 
+		if (ioc->facts.MsgVersion >= MPI_VERSION_01_05 &&
+		    pScsiTmReply->ResponseCode)
+			mptscsih_taskmgmt_response_code(ioc,
+			    pScsiTmReply->ResponseCode);
+
 		dtmprintk((MYIOC_s_WARN_FMT "  TaskType = %d, TerminationCount=%d\n",
 				ioc->name, tmType, le32_to_cpu(pScsiTmReply->TerminationCount)));
 		DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
@@ -2177,7 +2269,7 @@
 	vdev->raidVolume = 0;
 	hd->Targets[device->id] = vdev;
 	if (hd->ioc->bus_type == SCSI) {
-		if (hd->ioc->spi_data.isRaid & (1 << device->id)) {
+		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {
 			vdev->raidVolume = 1;
 			ddvtprintk((KERN_INFO
 			    "RAID Volume @ id %d\n", device->id));
@@ -2186,27 +2278,11 @@
 		vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
 	}
 
- out:
+out:
 	vdev->num_luns++;
 	return 0;
 }
 
-static int 
-mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)
-{
-	int i;
-
-	if (!hd->ioc->spi_data.isRaid || !hd->ioc->spi_data.pIocPg3)
-		return 0;
-
-	for (i = 0; i < hd->ioc->spi_data.pIocPg3->NumPhysDisks; i++) {
-		if (id == hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID)
-			return 1;
-	}
-
-	return 0;
-}
-
 /*
  *	OS entry point to allow for host driver to free allocated memory
  *	Called if no device present or device being unloaded
@@ -2223,6 +2299,28 @@
 	if (hd == NULL)
 		return;
 
+	/* kill oustanding tasks for this
+	 * device out in firmware stack
+	 */
+	if (mptscsih_TMHandler(hd,
+	     MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+	     device->channel,
+	     device->id,
+	     0, 0, 5 /* 5 second timeout */)
+	     < 0){
+
+		/* The TM request failed!
+		 * Fatal error case.
+		 */
+		printk(MYIOC_s_WARN_FMT
+	       "Error processing TaskMgmt id=%d TARGET_RESET\n",
+			hd->ioc->name,
+			device->id);
+
+		hd->tmPending = 0;
+		hd->tmState = TM_STATE_NONE;
+	}
+
 	mptscsih_search_running_cmds(hd, target, lun);
 
 	vdev = hd->Targets[target];
@@ -2234,7 +2332,7 @@
 	hd->Targets[target] = NULL;
 
 	if (hd->ioc->bus_type == SCSI) {
-		if (mptscsih_is_raid_volume(hd, target)) {
+		if (mptscsih_is_phys_disk(hd->ioc, target)) {
 			hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
 		} else {
 			hd->ioc->spi_data.dvStatus[target] =
@@ -2318,10 +2416,10 @@
 	if (pTarget == NULL) {
 		/* Driver doesn't know about this device.
 		 * Kernel may generate a "Dummy Lun 0" which
-		 * may become a real Lun if a 
+		 * may become a real Lun if a
 		 * "scsi add-single-device" command is executed
-		 * while the driver is active (hot-plug a 
-		 * device).  LSI Raid controllers need 
+		 * while the driver is active (hot-plug a
+		 * device).  LSI Raid controllers need
 		 * queue_depth set to DEV_HIGH for this reason.
 		 */
 		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
@@ -2452,8 +2550,9 @@
 {
 	MPT_SCSI_HOST	*hd;
 	unsigned long	 flags;
+	int ii;
 
-	dtmprintk((KERN_WARNING MYNAM
+	dtmprintk((KERN_INFO MYNAM
 			": IOC %s_reset routed to SCSI host driver!\n",
 			reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
 			reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
@@ -2509,11 +2608,8 @@
 
 		/* ScsiLookup initialization
 		 */
-		{
-			int ii;
-			for (ii=0; ii < hd->ioc->req_depth; ii++)
-				hd->ScsiLookup[ii] = NULL;
-		}
+		for (ii=0; ii < hd->ioc->req_depth; ii++)
+			hd->ScsiLookup[ii] = NULL;
 
 		/* 2. Chain Buffer initialization
 		 */
@@ -2562,27 +2658,38 @@
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/* work queue thread to clear the persitency table */
+static void
+mptscsih_sas_persist_clear_table(void * arg)
+{
+	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
+
+	mptbase_sas_persist_operation(ioc, MPI_SAS_OP_CLEAR_NOT_PRESENT);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 int
 mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 {
 	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
-	devtprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
+	devtprintk((MYIOC_s_INFO_FMT
+		"MPT event (=%02Xh) routed to SCSI host driver!\n",
 			ioc->name, event));
 
+	if (ioc->sh == NULL ||
+		((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL))
+		return 1;
+
 	switch (event) {
 	case MPI_EVENT_UNIT_ATTENTION:			/* 03 */
 		/* FIXME! */
 		break;
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		hd = NULL;
-		if (ioc->sh) {
-			hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
-			if (hd && (ioc->bus_type == SCSI) && (hd->soft_resets < -1))
-				hd->soft_resets++;
-		}
+		if (hd && (ioc->bus_type == SCSI) && (hd->soft_resets < -1))
+			hd->soft_resets++;
 		break;
 	case MPI_EVENT_LOGOUT:				/* 09 */
 		/* FIXME! */
@@ -2601,69 +2708,50 @@
 		break;
 
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
+	{
+		pMpiEventDataRaid_t pRaidEventData =
+		    (pMpiEventDataRaid_t) pEvReply->Data;
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
-		/* negoNvram set to 0 if DV enabled and to USE_NVRAM if
-		 * if DV disabled. Need to check for target mode.
-		 */
-		hd = NULL;
-		if (ioc->sh)
-			hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
+		/* Domain Validation Needed */
+		if (ioc->bus_type == SCSI &&
+			pRaidEventData->ReasonCode ==
+			MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {
 
-		if (hd && (ioc->bus_type == SCSI) && (hd->negoNvram == 0)) {
-			ScsiCfgData	*pSpi;
-			Ioc3PhysDisk_t	*pPDisk;
-			int		 numPDisk;
-			u8		 reason;
-			u8		 physDiskNum;
-
-			reason = (le32_to_cpu(pEvReply->Data[0]) & 0x00FF0000) >> 16;
-			if (reason == MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {
-				/* New or replaced disk.
-				 * Set DV flag and schedule DV.
-				 */
-				pSpi = &ioc->spi_data;
-				physDiskNum = (le32_to_cpu(pEvReply->Data[0]) & 0xFF000000) >> 24;
-				ddvtprintk(("DV requested for phys disk id %d\n", physDiskNum));
-				if (pSpi->pIocPg3) {
-					pPDisk =  pSpi->pIocPg3->PhysDisk;
-					numPDisk =pSpi->pIocPg3->NumPhysDisks;
+			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);
+		}
+#endif
+		break;
+	}
 
-					while (numPDisk) {
-						if (physDiskNum == pPDisk->PhysDiskNum) {
-							pSpi->dvStatus[pPDisk->PhysDiskID] = (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);
-							pSpi->forceDv = MPT_SCSICFG_NEED_DV;
-							ddvtprintk(("NEED_DV set for phys disk id %d\n", pPDisk->PhysDiskID));
-							break;
-						}
-						pPDisk++;
-						numPDisk--;
-					}
+	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:  /* 0F */
+	{
+		pMpiEventDataSasDeviceStatusChange_t pSasEventData =
+		    (pMpiEventDataSasDeviceStatusChange_t ) pEvReply->Data;
 
-					if (numPDisk == 0) {
-						/* The physical disk that needs DV was not found
-						 * in the stored IOC Page 3. The driver must reload
-						 * this page. DV routine will set the NEED_DV flag for
-						 * all phys disks that have DV_NOT_DONE set.
-						 */
-						pSpi->forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
-						ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 Flag\n", physDiskNum));
-					}
-				}
-			}
+		if ((pSasEventData->DeviceInfo &
+		    (MPI_SAS_DEVICE_INFO_SSP_TARGET |
+		     MPI_SAS_DEVICE_INFO_STP_TARGET |
+		     MPI_SAS_DEVICE_INFO_SATA_DEVICE )) == 0) {
+			break;
 		}
-#endif
 
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
-		printk("Raid Event RF: ");
-		{
-			u32 *m = (u32 *)pEvReply;
-			int ii;
-			int n = (int)pEvReply->MsgLength;
-			for (ii=6; ii < n; ii++)
-				printk(" %08x", le32_to_cpu(m[ii]));
-			printk("\n");
+		/* Persistent table is full. */
+		if (pSasEventData->ReasonCode ==
+		    MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED) {
+
+			INIT_WORK(&mptscsih_persistTask,
+			    mptscsih_sas_persist_clear_table,(void *)ioc);
+			schedule_work(&mptscsih_persistTask);
 		}
-#endif
+
+		break;
+	}
+
+	/* Persistent table is full. */
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:
+		INIT_WORK(&mptscsih_persistTask,
+		    mptscsih_sas_persist_clear_table,(void *)ioc);
+		schedule_work(&mptscsih_persistTask);
 		break;
 
 	case MPI_EVENT_NONE:				/* 00 */
@@ -2700,7 +2788,7 @@
 {
 	int		indexed_lun, lun_index;
 	VirtDevice	*vdev;
-	ScsiCfgData	*pSpi;
+	SpiCfgData	*pSpi;
 	char		data_56;
 
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
@@ -2710,7 +2798,7 @@
 	 * If the peripheral qualifier filter is enabled then if the target reports a 0x1
 	 * (i.e. The targer is capable of supporting the specified peripheral device type
 	 * on this logical unit; however, the physical device is not currently connected
-	 * to this logical unit) it will be converted to a 0x3 (i.e. The target is not 
+	 * to this logical unit) it will be converted to a 0x3 (i.e. The target is not
 	 * capable of supporting a physical device on this logical unit). This is to work
 	 * around a bug in th emid-layer in some distributions in which the mid-layer will
 	 * continue to try to communicate to the LUN and evntually create a dummy LUN.
@@ -2807,7 +2895,7 @@
 static void
 mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, char byte56)
 {
-	ScsiCfgData *pspi_data = &hd->ioc->spi_data;
+	SpiCfgData *pspi_data = &hd->ioc->spi_data;
 	int  id = (int) target->target_id;
 	int  nvram;
 	VirtDevice	*vdev;
@@ -2986,10 +3074,11 @@
 static void
 mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)
 {
+	MPT_ADAPTER	*ioc = hd->ioc;
 	u8 cmd;
-	ScsiCfgData *pSpi;
+	SpiCfgData	*pSpi;
 
-	ddvtprintk((" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n", 
+	ddvtprintk((" set_dvflags: id=%d lun=%d negoNvram=%x cmd=%x\n",
 		pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));
 
 	if ((pReq->LUN[1] != 0) || (hd->negoNvram != 0))
@@ -2998,12 +3087,12 @@
 	cmd = pReq->CDB[0];
 
 	if ((cmd == READ_CAPACITY) || (cmd == MODE_SENSE)) {
-		pSpi = &hd->ioc->spi_data;
-		if ((pSpi->isRaid & (1 << pReq->TargetID)) && pSpi->pIocPg3) {
+		pSpi = &ioc->spi_data;
+		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && ioc->raid_data.pIocPg3) {
 			/* Set NEED_DV for all hidden disks
 			 */
-			Ioc3PhysDisk_t *pPDisk =  pSpi->pIocPg3->PhysDisk;
-			int		numPDisk = pSpi->pIocPg3->NumPhysDisks;
+			Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
+			int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
 
 			while (numPDisk) {
 				pSpi->dvStatus[pPDisk->PhysDiskID] |= MPT_SCSICFG_NEED_DV;
@@ -3017,6 +3106,50 @@
 	}
 }
 
+/* mptscsih_raid_set_dv_flags()
+ *
+ * New or replaced disk. Set DV flag and schedule DV.
+ */
+static void
+mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)
+{
+	MPT_ADAPTER	*ioc = hd->ioc;
+	SpiCfgData	*pSpi = &ioc->spi_data;
+	Ioc3PhysDisk_t	*pPDisk;
+	int		 numPDisk;
+
+	if (hd->negoNvram != 0)
+		return;
+
+	ddvtprintk(("DV requested for phys disk id %d\n", id));
+	if (ioc->raid_data.pIocPg3) {
+		pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
+		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
+		while (numPDisk) {
+			if (id == pPDisk->PhysDiskNum) {
+				pSpi->dvStatus[pPDisk->PhysDiskID] =
+				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);
+				pSpi->forceDv = MPT_SCSICFG_NEED_DV;
+				ddvtprintk(("NEED_DV set for phys disk id %d\n",
+				    pPDisk->PhysDiskID));
+				break;
+			}
+			pPDisk++;
+			numPDisk--;
+		}
+
+		if (numPDisk == 0) {
+			/* The physical disk that needs DV was not found
+			 * in the stored IOC Page 3. The driver must reload
+			 * this page. DV routine will set the NEED_DV flag for
+			 * all phys disks that have DV_NOT_DONE set.
+			 */
+			pSpi->forceDv = MPT_SCSICFG_NEED_DV | MPT_SCSICFG_RELOAD_IOC_PG3;
+			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 Flag\n", ));
+		}
+	}
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  * If no Target, bus reset on 1st I/O. Set the flag to
@@ -3104,7 +3237,7 @@
 	MPT_ADAPTER		*ioc = hd->ioc;
 	Config_t		*pReq;
 	SCSIDevicePage1_t	*pData;
-	VirtDevice		*pTarget;
+	VirtDevice		*pTarget=NULL;
 	MPT_FRAME_HDR		*mf;
 	dma_addr_t		 dataDma;
 	u16			 req_idx;
@@ -3188,7 +3321,7 @@
 			width = pTarget->maxWidth;
 			factor = pTarget->minSyncFactor;
 			offset = pTarget->maxOffset;
-			negoFlags = pTarget->negoFlags;
+			negoFlags |= pTarget->negoFlags;
 		}
 
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
@@ -3203,7 +3336,7 @@
 #endif
 
 		if (flags & MPT_SCSICFG_BLK_NEGO)
-			negoFlags = MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC;
+			negoFlags |= MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC;
 
 		mptscsih_setDevicePage1Flags(width, factor, offset,
 					&requested, &configuration, negoFlags);
@@ -4024,7 +4157,7 @@
 
 		/* If target Ptr NULL or if this target is NOT a disk, skip.
 		 */
-		if ((pTarget) && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)){
+		if ((pTarget) && (pTarget->inq_data[0] == TYPE_DISK)){
 			for (lun=0; lun <= MPT_LAST_LUN; lun++) {
 				/* If LUN present, issue the command
 				 */
@@ -4119,9 +4252,9 @@
 
 			if ((ioc->spi_data.forceDv & MPT_SCSICFG_RELOAD_IOC_PG3) != 0) {
 				mpt_read_ioc_pg_3(ioc);
-				if (ioc->spi_data.pIocPg3) {
-					Ioc3PhysDisk_t *pPDisk = ioc->spi_data.pIocPg3->PhysDisk;
-					int		numPDisk = ioc->spi_data.pIocPg3->NumPhysDisks;
+				if (ioc->raid_data.pIocPg3) {
+					Ioc3PhysDisk_t *pPDisk = ioc->raid_data.pIocPg3->PhysDisk;
+					int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
 
 					while (numPDisk) {
 						if (ioc->spi_data.dvStatus[pPDisk->PhysDiskID] & MPT_SCSICFG_DV_NOT_DONE)
@@ -4160,7 +4293,7 @@
 					isPhysDisk = mptscsih_is_phys_disk(ioc, id);
 					if (isPhysDisk) {
 						for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-							if (hd->ioc->spi_data.isRaid & (1 << ii)) {
+							if (hd->ioc->raid_data.isRaid & (1 << ii)) {
 								hd->ioc->spi_data.dvStatus[ii] |= MPT_SCSICFG_DV_PENDING;
 							}
 						}
@@ -4179,7 +4312,7 @@
 
 					if (isPhysDisk) {
 						for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
-							if (hd->ioc->spi_data.isRaid & (1 << ii)) {
+							if (hd->ioc->raid_data.isRaid & (1 << ii)) {
 								hd->ioc->spi_data.dvStatus[ii] &= ~MPT_SCSICFG_DV_PENDING;
 							}
 						}
@@ -4201,21 +4334,19 @@
 
 /* Search IOC page 3 to determine if this is hidden physical disk
  */
-static int 
+static int
 mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)
 {
-	if (ioc->spi_data.pIocPg3) {
-		Ioc3PhysDisk_t *pPDisk =  ioc->spi_data.pIocPg3->PhysDisk;
-		int		numPDisk = ioc->spi_data.pIocPg3->NumPhysDisks;
+	int i;
 
-		while (numPDisk) {
-			if (pPDisk->PhysDiskID == id) {
-				return 1;
-			}
-			pPDisk++;
-			numPDisk--;
-		}
+	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)
+		return 0;
+
+	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
+		if (id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)
+			return 1;
 	}
+
 	return 0;
 }
 
@@ -4421,7 +4552,7 @@
 	/* Skip this ID? Set cfg.hdr to force config page write
 	 */
 	{
-		ScsiCfgData *pspi_data = &hd->ioc->spi_data;
+		SpiCfgData *pspi_data = &hd->ioc->spi_data;
 		if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
 			/* Set the factor from nvram */
 			nfactor = (pspi_data->nvram[id] & MPT_NVRAM_SYNC_MASK) >> 8;
@@ -4451,11 +4582,11 @@
 	}
 
 	/* Finish iocmd inititialization - hidden or visible disk? */
-	if (ioc->spi_data.pIocPg3) {
+	if (ioc->raid_data.pIocPg3) {
 		/* Search IOC page 3 for matching id
 		 */
-		Ioc3PhysDisk_t *pPDisk =  ioc->spi_data.pIocPg3->PhysDisk;
-		int		numPDisk = ioc->spi_data.pIocPg3->NumPhysDisks;
+		Ioc3PhysDisk_t *pPDisk =  ioc->raid_data.pIocPg3->PhysDisk;
+		int		numPDisk = ioc->raid_data.pIocPg3->NumPhysDisks;
 
 		while (numPDisk) {
 			if (pPDisk->PhysDiskID == id) {
@@ -4479,7 +4610,7 @@
 	/* RAID Volume ID's may double for a physical device. If RAID but
 	 * not a physical ID as well, skip DV.
 	 */
-	if ((hd->ioc->spi_data.isRaid & (1 << id)) && !(iocmd.flags & MPT_ICFLAG_PHYS_DISK))
+	if ((hd->ioc->raid_data.isRaid & (1 << id)) && !(iocmd.flags & MPT_ICFLAG_PHYS_DISK))
 		goto target_done;
 
 
@@ -4615,8 +4746,8 @@
 				if ((pbuf1[56] & 0x02) == 0) {
 					pTarget->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
 					hd->ioc->spi_data.noQas = MPT_TARGET_NO_NEGO_QAS;
-					ddvprintk((MYIOC_s_NOTE_FMT 
-					    "DV: Start Basic noQas on id=%d due to pbuf1[56]=%x\n", 
+					ddvprintk((MYIOC_s_NOTE_FMT
+					    "DV: Start Basic noQas on id=%d due to pbuf1[56]=%x\n",
 					    ioc->name, id, pbuf1[56]));
 				}
 			}
@@ -4692,7 +4823,7 @@
 						if (!firstPass)
 							doFallback = 1;
 					} else {
-						ddvprintk((MYIOC_s_NOTE_FMT 
+						ddvprintk((MYIOC_s_NOTE_FMT
 						    "DV:Inquiry compared id=%d, calling initTarget\n", ioc->name, id));
 						hd->ioc->spi_data.dvStatus[id] &= ~MPT_SCSICFG_DV_NOT_DONE;
 						mptscsih_initTarget(hd,
@@ -4708,8 +4839,8 @@
 
 			} else if (rc == MPT_SCANDV_ISSUE_SENSE)
 				doFallback = 1;	/* set fallback flag */
-			else if ((rc == MPT_SCANDV_DID_RESET) || 
-				 (rc == MPT_SCANDV_SENSE) || 
+			else if ((rc == MPT_SCANDV_DID_RESET) ||
+				 (rc == MPT_SCANDV_SENSE) ||
 				 (rc == MPT_SCANDV_FALLBACK))
 				doFallback = 1;	/* set fallback flag */
 			else
@@ -4828,6 +4959,8 @@
 					notDone = 0;
 					if (iocmd.flags & MPT_ICFLAG_ECHO) {
 						bufsize =  ((pbuf1[2] & 0x1F) <<8) | pbuf1[3];
+						if (pbuf1[0] & 0x01)
+							iocmd.flags |= MPT_ICFLAG_EBOS;
 					} else {
 						bufsize =  pbuf1[1]<<16 | pbuf1[2]<<8 | pbuf1[3];
 					}
@@ -4924,6 +5057,9 @@
 		}
 		iocmd.flags &= ~MPT_ICFLAG_DID_RESET;
 
+		if (iocmd.flags & MPT_ICFLAG_EBOS)
+			goto skip_Reserve;
+
 		repeat = 5;
 		while (repeat && (!(iocmd.flags & MPT_ICFLAG_RESERVED))) {
 			iocmd.cmd = RESERVE;
@@ -4967,6 +5103,7 @@
 			}
 		}
 
+skip_Reserve:
 		mptscsih_fillbuf(pbuf1, sz, patt, 1);
 		iocmd.cmd = WRITE_BUFFER;
 		iocmd.data_dma = buf1_dma;
@@ -5145,7 +5282,7 @@
 		 */
 		if ((inq0 == 0) && (dv.now.factor > MPT_ULTRA320)) {
 			hd->ioc->spi_data.noQas = MPT_TARGET_NO_NEGO_QAS;
-			ddvprintk((MYIOC_s_NOTE_FMT 
+			ddvprintk((MYIOC_s_NOTE_FMT
 			    "noQas set due to id=%d has factor=%x\n", ioc->name, id, dv.now.factor));
 		}
 
@@ -5211,11 +5348,12 @@
 		 * If not an LVD bus, the adapter minSyncFactor has been
 		 * already throttled back.
 		 */
+		negoFlags = hd->ioc->spi_data.noQas;
 		if ((hd->Targets)&&((pTarget = hd->Targets[(int)id]) != NULL) && !pTarget->raidVolume) {
 			width = pTarget->maxWidth;
 			offset = pTarget->maxOffset;
 			factor = pTarget->minSyncFactor;
-			negoFlags = pTarget->negoFlags;
+			negoFlags |= pTarget->negoFlags;
 		} else {
 			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
 				data = hd->ioc->spi_data.nvram[id];
@@ -5236,7 +5374,6 @@
 			}
 
 			/* Set the negotiation flags */
-			negoFlags = hd->ioc->spi_data.noQas;
 			if (!width)
 				negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
 

--Boundary-00=_waenC5k6XPgVWm3--
