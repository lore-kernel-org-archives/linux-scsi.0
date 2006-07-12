From: Eric Moore <eric.moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 14:22:00 -0600
Message-ID: <20060712202200.GA10783@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7920 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750814AbWGLUe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 16:34:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

-- Wednesday, Julyl 12, 2006 1:26PM, James Bottomley wrote:

> As long as they all apply without this one, I should be OK.

James - I removed the TLR patch. And here I've combined all the other
patch's into this single patch.  This applies over this weeks two mptsas
patchs for backlink and integrated raid channel fix.  Breaking everything
out into seperate patchs will take a long time.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2006-07-11 16:39:39.000000000 -0600
@@ -48,10 +48,8 @@ config FUSION_SAS
 	  List of supported controllers:
 
 	  LSISAS1064
-	  LSISAS1066
 	  LSISAS1068
 	  LSISAS1064E
-	  LSISAS1066E
 	  LSISAS1068E
 
 config FUSION_MAX_SGE
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-07-11 16:39:39.000000000 -0600
@@ -436,8 +436,6 @@ mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRA
 		 */
 		if (pEvReply->MsgFlags & MPI_MSGFLAGS_CONTINUATION_REPLY) {
 			freereq = 0;
-			devtverboseprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p does not return Request frame\n",
-				ioc->name, pEvReply));
 		} else {
 			devtverboseprintk((MYIOC_s_WARN_FMT "EVENT_NOTIFICATION reply %p returns Request frame\n",
 				ioc->name, pEvReply));
@@ -678,19 +676,19 @@ int
 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx)
 {
 	MPT_ADAPTER	*ioc;
+	const struct pci_device_id *id;
 
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS) {
+	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -EINVAL;
-	}
 
 	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
 
 	/* call per pci device probe entry point */
 	list_for_each_entry(ioc, &ioc_list, list) {
-		if(dd_cbfunc->probe) {
-			dd_cbfunc->probe(ioc->pcidev,
-			  ioc->pcidev->driver->id_table);
-  		}
+		id = ioc->pcidev->driver ?
+		    ioc->pcidev->driver->id_table : NULL;
+		if (dd_cbfunc->probe)
+			dd_cbfunc->probe(ioc->pcidev, id);
 	 }
 
 	return 0;
@@ -1056,9 +1054,8 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pI
 
 				dinitprintk((MYIOC_s_INFO_FMT
 				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
-				    ioc->name,
-				    ioc->HostPageBuffer,
-				    ioc->HostPageBuffer_dma,
+				    ioc->name, ioc->HostPageBuffer,
+				    (u32)ioc->HostPageBuffer_dma,
 				    host_page_buffer_sz));
 				ioc->alloc_total += host_page_buffer_sz;
 				ioc->HostPageBuffer_sz = host_page_buffer_sz;
@@ -1380,6 +1377,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
+
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
@@ -1762,9 +1760,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 						 * chips (mpt_adapter_disable,
 						 * mpt_diag_reset)
 						 */
-						ioc->cached_fw = NULL;
 						ddlprintk((MYIOC_s_INFO_FMT ": mpt_upload:  alt_%s has cached_fw=%p \n",
 							ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));
+						ioc->alt_ioc->cached_fw = NULL;
 					}
 				} else {
 					printk(KERN_WARNING MYNAM ": firmware upload failure!\n");
@@ -1885,7 +1883,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		/* FIXME?  Examine results here? */
 	}
 
-out:
+ out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
 		if (mpt_msi_enable)
@@ -2670,6 +2668,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	dinitprintk((MYIOC_s_INFO_FMT "INFO - Wait IOC_OPERATIONAL state (cnt=%d)\n",
 			ioc->name, count));
 
+	ioc->aen_event_read_flag=0;
 	return r;
 }
 
@@ -2737,6 +2736,8 @@ mpt_alloc_fw_memory(MPT_ADAPTER *ioc, in
 	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {
 		ioc->cached_fw = ioc->alt_ioc->cached_fw;  /* use alt_ioc's memory */
 		ioc->cached_fw_dma = ioc->alt_ioc->cached_fw_dma;
+		ioc->alloc_total += size;
+		ioc->alt_ioc->alloc_total -= size;
 	} else {
 		if ( (ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma) ) )
 			ioc->alloc_total += size;
@@ -3166,6 +3167,7 @@ KickStart(MPT_ADAPTER *ioc, int force, i
 static int
 mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 {
+	MPT_ADAPTER	*iocp=NULL;
 	u32 diag0val;
 	u32 doorbell;
 	int hard_reset_done = 0;
@@ -3301,17 +3303,23 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 			/* FIXME?  Examine results here? */
 		}
 
-		if (ioc->cached_fw) {
+		if (ioc->cached_fw)
+			iocp = ioc;
+		else if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)
+			iocp = ioc->alt_ioc;
+		if (iocp) {
 			/* If the DownloadBoot operation fails, the
 			 * IOC will be left unusable. This is a fatal error
 			 * case.  _diag_reset will return < 0
 			 */
 			for (count = 0; count < 30; count ++) {
-				diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
+				diag0val = CHIPREG_READ32(&iocp->chip->Diagnostic);
 				if (!(diag0val & MPI_DIAG_RESET_ADAPTER)) {
 					break;
 				}
 
+				dprintk((MYIOC_s_INFO_FMT "cached_fw: diag0val=%x count=%d\n",
+					iocp->name, diag0val, count));
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
 					msleep (1000);
@@ -3320,7 +3328,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				}
 			}
 			if ((count = mpt_downloadboot(ioc,
-				(MpiFwHeader_t *)ioc->cached_fw, sleepFlag)) < 0) {
+				(MpiFwHeader_t *)iocp->cached_fw, sleepFlag)) < 0) {
 				printk(KERN_WARNING MYNAM
 					": firmware downloadboot failure (%d)!\n", count);
 			}
@@ -3907,18 +3915,18 @@ WaitForDoorbellAck(MPT_ADAPTER *ioc, int
 
 	if (sleepFlag == CAN_SLEEP) {
 		while (--cntdn) {
+			msleep (1);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
-			msleep (1);
 			count++;
 		}
 	} else {
 		while (--cntdn) {
+			mdelay (1);
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
-			mdelay (1);
 			count++;
 		}
 	}
@@ -4883,6 +4891,7 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 		pIoc4 = pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
 		if (!pIoc4)
 			return;
+		ioc->alloc_total += iocpage4sz;
 	} else {
 		ioc4_dma = ioc->spi_data.IocPg4_dma;
 		iocpage4sz = ioc->spi_data.IocPg4Sz;
@@ -4899,6 +4908,7 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 	} else {
 		pci_free_consistent(ioc->pcidev, iocpage4sz, pIoc4, ioc4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
+		ioc->alloc_total -= iocpage4sz;
 	}
 }
 
@@ -5030,19 +5040,18 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
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
 
@@ -5704,9 +5713,9 @@ EventDescriptionStr(u8 event, u32 evData
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
@@ -5777,8 +5786,27 @@ EventDescriptionStr(u8 event, u32 evData
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
@@ -6034,7 +6062,7 @@ ProcessEventNotification(MPT_ADAPTER *io
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@log_info: U32 LogInfo reply word from the IOC
  *
- *	Refer to lsi/fc_log.h.
+ *	Refer to lsi/mpi_log_fc.h.
  */
 static void
 mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info)
@@ -6131,8 +6159,10 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
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
@@ -6158,7 +6188,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
 		"IO Executed",					/* 14h */
 		"Persistant Reservation Out Not Affiliation Owner", /* 15h */
 		"Open Transmit DMA Abort",			/* 16h */
-		NULL,						/* 17h */
+		"IO Device Missing Delay Retry",		/* 17h */
 		NULL,						/* 18h */
 		NULL,						/* 19h */
 		NULL,						/* 1Ah */
@@ -6238,7 +6268,7 @@ static void
 mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
 {
 	u32 status = ioc_status & MPI_IOCSTATUS_MASK;
-	char *desc = "";
+	char *desc = NULL;
 
 	switch (status) {
 	case MPI_IOCSTATUS_INVALID_FUNCTION: /* 0x0001 */
@@ -6348,7 +6378,7 @@ mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 io
 		desc = "Others";
 		break;
 	}
-	if (desc != "")
+	if (desc != NULL)
 		printk(MYIOC_s_INFO_FMT "IOCStatus(0x%04x): %s\n", ioc->name, status, desc);
 }
 
@@ -6386,7 +6416,6 @@ EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
 
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	fusion_init - Fusion MPT base driver initialization routine.
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-12 13:54:19.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 16:39:39.000000000 -0600
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.00"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.00"
+#define MPT_LINUX_VERSION_COMMON	"3.04.01"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.01"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -307,8 +307,8 @@ typedef struct _SYSIF_REGS
 	u32	HostIndex;	/* 50     Host Index register        */
 	u32	Reserved4[15];	/* 54-8F                             */
 	u32	Fubar;		/* 90     For Fubar usage            */
-	u32     Reserved5[1050];/* 94-10F8                           */
-	u32     Reset_1078;     /* 10FC   Reset 1078                 */
+	u32	Reserved5[1050];/* 94-10F8                           */
+	u32	Reset_1078;	/* 10FC   Reset 1078                 */
 } SYSIF_REGS;
 
 /*
@@ -363,6 +363,7 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_VALID_56	0x10
 #define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
+#define MPT_TARGET_FLAGS_LED_ON		0x80
 
 /*
  *	/proc/mpt interface
@@ -980,7 +981,7 @@ typedef struct _MPT_SCSI_HOST {
 	wait_queue_head_t	  scandv_waitq;
 	int			  scandv_wait_done;
 	long			  last_queue_full;
-	u8		 	  mpt_pq_filter;
+	u16			  tm_iocstatus;
 } MPT_SCSI_HOST;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2006-07-11 16:39:39.000000000 -0600
@@ -2332,7 +2332,7 @@ done_free_mem:
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* Prototype Routine for the HP HOST INFO command.
+/* Prototype Routine for the HOST INFO command.
  *
  * Outputs:	None.
  * Return:	0 if successful
@@ -2568,7 +2568,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* Prototype Routine for the HP TARGET INFO command.
+/* Prototype Routine for the TARGET INFO command.
  *
  * Outputs:	None.
  * Return:	0 if successful
diff -uarpN b/drivers/message/fusion/mptctl.h a/drivers/message/fusion/mptctl.h
--- b/drivers/message/fusion/mptctl.h	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/mptctl.h	2006-07-11 16:39:39.000000000 -0600
@@ -354,9 +354,6 @@ struct mpt_ioctl_command32 {
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *	HP Specific IOCTL Defines and Structures
- */
 
 #define CPQFCTS_IOC_MAGIC 'Z'
 #define HP_IOC_MAGIC 'Z'
@@ -364,8 +361,6 @@ struct mpt_ioctl_command32 {
 #define HP_GETHOSTINFO1		_IOR(HP_IOC_MAGIC, 20, hp_host_info_rev0_t)
 #define HP_GETTARGETINFO	_IOR(HP_IOC_MAGIC, 21, hp_target_info_t)
 
-/* All HP IOCTLs must include this header
- */
 typedef struct _hp_header {
 	unsigned int iocnum;
 	unsigned int host;
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2006-07-11 16:39:39.000000000 -0600
@@ -77,10 +77,6 @@ MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
 /* Command line args */
-static int mpt_pq_filter = 0;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
-
 #define MPTFC_DEV_LOSS_TMO (60)
 static int mptfc_dev_loss_tmo = MPTFC_DEV_LOSS_TMO;	/* reasonable default */
 module_param(mptfc_dev_loss_tmo, int, 0);
@@ -513,8 +509,7 @@ mptfc_slave_alloc(struct scsi_device *sd
 
 	if (vtarget->num_luns == 0) {
 		vtarget->ioc_id = hd->ioc->id;
-		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES |
-		    		  MPT_TARGET_FLAGS_VALID_INQUIRY;
+		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES;
 		hd->Targets[sdev->id] = vtarget;
 	}
 
@@ -1129,13 +1124,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	hd->timer.data = (unsigned long) hd;
 	hd->timer.function = mptscsih_timer_expired;
 
-	hd->mpt_pq_filter = mpt_pq_filter;
-
-	ddvprintk((MYIOC_s_INFO_FMT
-		"mpt_pq_filter %x\n",
-		ioc->name, 
-		mpt_pq_filter));
-
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-07-12 13:54:30.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-07-12 14:12:19.000000000 -0600
@@ -76,16 +76,10 @@ MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
 
-static int mpt_pq_filter;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter,
-		"Enable peripheral qualifier filter: enable=1  "
-		"(default=0)");
-
 static int mpt_pt_clear;
 module_param(mpt_pt_clear, int, 0);
 MODULE_PARM_DESC(mpt_pt_clear,
-		"Clear persistency table: enable=1  "
+		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
 
 static int	mptsasDoneCtx = -1;
@@ -655,7 +649,7 @@ mptsas_slave_configure(struct scsi_devic
 
 	sas_read_port_mode_page(sdev);
 
- out:
+out:
 	return mptscsih_slave_configure(sdev);
 }
 
@@ -2707,7 +2701,6 @@ mptsas_probe(struct pci_dev *pdev, const
 	hd->timer.data = (unsigned long) hd;
 	hd->timer.function = mptscsih_timer_expired;
 
-	hd->mpt_pq_filter = mpt_pq_filter;
 	ioc->sas_data.ptClear = mpt_pt_clear;
 
 	if (ioc->sas_data.ptClear==1) {
@@ -2715,12 +2708,6 @@ mptsas_probe(struct pci_dev *pdev, const
 		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
 	}
 
-	ddvprintk((MYIOC_s_INFO_FMT
-		"mpt_pq_filter %x mpt_pq_filter %x\n",
-		ioc->name,
-		mpt_pq_filter,
-		mpt_pq_filter));
-
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-07-12 13:50:57.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-07-12 14:22:12.000000000 -0600
@@ -66,6 +66,7 @@
 
 #include "mptbase.h"
 #include "mptscsih.h"
+#include "lsi/mpi_log_sas.h"
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define my_NAME		"Fusion MPT SCSI Host driver"
@@ -127,7 +128,7 @@ static void	mptscsih_freeChainBuffers(MP
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
-static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
+static int	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 
@@ -138,7 +139,6 @@ static void	mptscsih_initTarget(MPT_SCSI
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, int bus);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
-static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
 
 void 		mptscsih_remove(struct pci_dev *);
@@ -497,6 +497,34 @@ nextSGEset:
 	return SUCCESS;
 } /* mptscsih_AddSGE() */
 
+static void
+mptscsih_issue_sep_command(MPT_ADAPTER *ioc, VirtTarget *vtarget,
+    U32 SlotStatus)
+{
+	MPT_FRAME_HDR *mf;
+	SEPRequest_t 	 *SEPMsg;
+
+	if (ioc->bus_type == FC)
+		return;
+
+	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
+		    ioc->name,__FUNCTION__));
+		return;
+	}
+
+	SEPMsg = (SEPRequest_t *)mf;
+	SEPMsg->Function = MPI_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
+	SEPMsg->Bus = vtarget->bus_id;
+	SEPMsg->TargetID = vtarget->target_id;
+	SEPMsg->Action = MPI_SEP_REQ_ACTION_WRITE_STATUS;
+	SEPMsg->SlotStatus = SlotStatus;
+	devtverboseprintk((MYIOC_s_WARN_FMT
+	    "Sending SEP cmd=%x id=%d bus=%d\n",
+	    ioc->name, SlotStatus, SEPMsg->TargetID, SEPMsg->Bus));
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_io_done - Main SCSI IO callback routine registered to
@@ -520,6 +548,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
 	u16		 req_idx, req_idx_MR;
+	VirtDevice	 *vdev;
+	VirtTarget	 *vtarget;
 
 	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
 
@@ -538,6 +568,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	}
 
 	sc = hd->ScsiLookup[req_idx];
+	hd->ScsiLookup[req_idx] = NULL;
 	if (sc == NULL) {
 		MPIHeader_t *hdr = (MPIHeader_t *)mf;
 
@@ -553,6 +584,12 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		return 1;
 	}
 
+	if ((unsigned char *)mf != sc->host_scribble) {
+		mptscsih_freeChainBuffers(ioc, req_idx);
+		return 1;
+	}
+ 
+	sc->host_scribble = NULL;
 	sc->result = DID_OK << 16;		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
 	pScsiReply = (SCSIIOReply_t *) mr;
@@ -640,10 +677,36 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
+
+			vdev = sc->device->hostdata;
+			if (!vdev)
+				break;
+			vtarget = vdev->vtarget;
+			if (vtarget->tflags & MPT_TARGET_FLAGS_LED_ON) {
+				mptscsih_issue_sep_command(ioc, vtarget,
+				    MPI_SEP_REQ_SLOTSTATUS_UNCONFIGURED);
+				vtarget->tflags &= ~MPT_TARGET_FLAGS_LED_ON;
+			}
 			break;
 
-		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 		case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:		/* 0x004B */
+			if ( ioc->bus_type == SAS ) {
+				u16 ioc_status = le16_to_cpu(pScsiReply->IOCStatus);
+				if (ioc_status & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
+					u32 log_info = le32_to_cpu(mr->u.reply.IOCLogInfo);
+					log_info &=SAS_LOGINFO_MASK;
+					if (log_info == SAS_LOGINFO_NEXUS_LOSS) {
+						sc->result = (DID_BUS_BUSY << 16);
+						break;
+					}
+				}
+			}
+
+			/*
+			 * Allow non-SAS & non-NEXUS_LOSS to drop into below code
+			 */
+
+		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			/* Linux handles an unsolicited DID_RESET better
 			 * than an unsolicited DID_ABORT.
@@ -658,7 +721,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 				sc->result=DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
 				sc->result = (DID_OK << 16) | scsi_status;
-			dreplyprintk((KERN_NOTICE 
+			dreplyprintk((KERN_NOTICE
 			    "RESIDUAL_MISMATCH: result=%x on id=%d\n", sc->result, sc->device->id));
 			break;
 
@@ -784,8 +847,6 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 				sc->request_bufflen, sc->sc_data_direction);
 	}
 
-	hd->ScsiLookup[req_idx] = NULL;
-
 	sc->scsi_done(sc);		/* Issue the command callback */
 
 	/* Free Chain buffers */
@@ -827,9 +888,17 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			dmfprintk(( "flush: ScsiDone (mf=%p,sc=%p)\n",
 					mf, SCpnt));
 
+			/* Free Chain buffers */
+			mptscsih_freeChainBuffers(ioc, ii);
+
+			/* Free Message frames */
+			mpt_free_msg_frame(ioc, mf);
+
+			if ((unsigned char *)mf != SCpnt->host_scribble)
+				continue;
+
 			/* Set status, free OS resources (SG DMA buffers)
 			 * Do OS callback
-			 * Free driver resources (chain, msg buffers)
 			 */
 			if (SCpnt->use_sg) {
 				pci_unmap_sg(ioc->pcidev,
@@ -845,12 +914,6 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
-			/* Free Chain buffers */
-			mptscsih_freeChainBuffers(ioc, ii);
-
-			/* Free Message frames */
-			mpt_free_msg_frame(ioc, mf);
-
 			SCpnt->scsi_done(SCpnt);	/* Issue the command callback */
 		}
 	}
@@ -887,10 +950,10 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
 
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);
-
+			if (mf == NULL)
+				continue;
 			dsprintk(( "search_running: found (sc=%p, mf = %p) target %d, lun %d \n",
 					hd->ScsiLookup[ii], mf, mf->TargetID, mf->LUN[1]));
-
 			if ((mf->TargetID != ((u8)vdevice->vtarget->target_id)) || (mf->LUN[1] != ((u8) vdevice->lun)))
 				continue;
 
@@ -899,6 +962,8 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			hd->ScsiLookup[ii] = NULL;
 			mptscsih_freeChainBuffers(hd->ioc, ii);
 			mpt_free_msg_frame(hd->ioc, (MPT_FRAME_HDR *)mf);
+			if ((unsigned char *)mf != sc->host_scribble)
+				continue;
 			if (sc->use_sg) {
 				pci_unmap_sg(hd->ioc->pcidev,
 				(struct scatterlist *) sc->request_buffer,
@@ -1341,8 +1406,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 			goto fail;
 	}
 
+	SCpnt->host_scribble = (unsigned char *)mf;
 	hd->ScsiLookup[my_idx] = SCpnt;
-	SCpnt->host_scribble = NULL;
 
 	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);
 	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
@@ -1529,6 +1594,12 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
 		rc = mpt_HardResetHandler(hd->ioc, CAN_SLEEP);
 	}
 
+	/*
+	 * Check IOCStatus from TM reply message
+	 */
+	 if (hd->tm_iocstatus != MPI_IOCSTATUS_SUCCESS)
+		rc = FAILED;
+
 	dtmprintk((MYIOC_s_INFO_FMT "TMHandler rc = %d!\n", hd->ioc->name, rc));
 
 	return rc;
@@ -1654,6 +1725,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	int		 scpnt_idx;
 	int		 retval;
 	VirtDevice	 *vdev;
+	ulong	 	 sn = SCpnt->serial_number;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1707,6 +1779,11 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		vdev->vtarget->bus_id, vdev->vtarget->target_id, vdev->lun,
 		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
 
+	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
+	    SCpnt->serial_number == sn) {
+		retval = FAILED;
+	}
+
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
 		((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
@@ -2023,6 +2100,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 		DBG_DUMP_TM_REPLY_FRAME((u32 *)pScsiTmReply);
 
 		iocstatus = le16_to_cpu(pScsiTmReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+		hd->tm_iocstatus = iocstatus;
 		dtmprintk((MYIOC_s_WARN_FMT "  SCSI TaskMgmt (%d) IOCStatus=%04x IOCLogInfo=%08x\n",
 			ioc->name, tmType, iocstatus, le32_to_cpu(pScsiTmReply->IOCLogInfo)));
 		/* Error?  (anything non-zero?) */
@@ -2401,6 +2479,13 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
 
 				ioc->eventContext++;
+				if (hd->ioc->pcidev->vendor ==
+				    PCI_VENDOR_ID_IBM) {
+					mptscsih_issue_sep_command(hd->ioc,
+					    vdev->vtarget, MPI_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
+					vdev->vtarget->tflags |=
+					    MPT_TARGET_FLAGS_LED_ON;
+				}
 			}
 		}
 	} else {
@@ -2409,7 +2494,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
 	}
 }
 
-static u32
+static int
 SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc)
 {
 	MPT_SCSI_HOST *hd;
@@ -3003,6 +3088,8 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 				completionCode = MPT_SCANDV_DID_RESET;
 			else if (pReply->SCSIState & MPI_SCSI_STATE_TERMINATED)
 				completionCode = MPT_SCANDV_DID_RESET;
+			else if (scsi_status == MPI_SCSI_STATUS_BUSY)
+				completionCode = MPT_SCANDV_SOME_ERROR;
 			else {
 				completionCode = MPT_SCANDV_GOOD;
 				hd->pLocal->scsiStatus = scsi_status;
@@ -3120,7 +3207,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTER
 	int		in_isr;
 	char		 cmdLen;
 	char		 CDB[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
-	char		 cmd = io->cmd;
+	u8		 cmd = io->cmd;
 
 	in_isr = in_interrupt();
 	if (in_isr) {
@@ -3401,5 +3488,4 @@ EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
 EXPORT_SYMBOL(mptscsih_TMHandler);
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-07-12 13:50:58.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-07-11 16:39:39.000000000 -0600
@@ -83,10 +83,6 @@ static int mpt_saf_te = MPTSCSIH_SAF_TE;
 module_param(mpt_saf_te, int, 0);
 MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: enable=1  (default=MPTSCSIH_SAF_TE=0)");
 
-static int mpt_pq_filter = 0;
-module_param(mpt_pq_filter, int, 0);
-MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: enable=1  (default=0)");
-
 static void mptspi_write_offset(struct scsi_target *, int);
 static void mptspi_write_width(struct scsi_target *, int);
 static int mptspi_write_spi_device_pg1(struct scsi_target *,
@@ -1047,14 +1043,12 @@ mptspi_probe(struct pci_dev *pdev, const
 	hd->timer.function = mptscsih_timer_expired;
 
 	ioc->spi_data.Saf_Te = mpt_saf_te;
-	hd->mpt_pq_filter = mpt_pq_filter;
 
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 	ddvprintk((MYIOC_s_INFO_FMT
-		"saf_te %x mpt_pq_filter %x\n",
+		"saf_te %x\n",
 		ioc->name,
-		mpt_saf_te,
-		mpt_pq_filter));
+		mpt_saf_te));
 	ioc->spi_data.noQas = 0;
 
 	init_waitqueue_head(&hd->scandv_waitq);
