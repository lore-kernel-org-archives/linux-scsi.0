From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH ] fusion SAS support (mptsas driver)
Date: Wed, 14 Sep 2005 18:09:10 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0407A02F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5B989.B25BA498"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28066 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932495AbVIOAJ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 20:09:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5B989.B25BA498
Content-Type: text/plain;
	charset="iso-8859-1"

I've reviewed patches today: 
[PATCH 1/2] fusion core changes for SAS support
[PATCH 2/2] fusion SAS support (mptsas driver)
(However the driver oops when loading - sent
email earlier today on that).


These previous patches were posted last Friday
seem fine, however I recommend we add the following 
changes, and I've provided a patch attached to this email.

Also can be dowloaded from:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/mptfusion.patch

Summary of Changes:
* splitting mpt_interrupt per Christophs suggestion 
about a month ago 
* rename ScsiCfgData to SpiCfgData structure, 
then move all the raid related info into 
new structure called RaidCfgData.  This is 
done because SAS supports RAID, as well as SPI, 
so the raid stuff should be seperate.
* incorrect timeout calculation for cntdn 
inside WaitForDoorbellAck and WaitForDoortbellInt
* add support for interpreting SAS Log Info
* Increase Event Log Size from 0xA to 0x32
* Fix bug in mptsas/mptfc/mptspi - when controller 
has Initiator Mode Disabled, and only running in
TargetMode, the mptctl would panic when loading. 
The fix is to return 0, instead of -ENODEV, in 
SCSI LLD respective probe routines
* Fix bug in mptlan.c - driver will panic if 
there is host reset, due to dev being set to 
zero in mpt_lan_ioc_reset
* Fix's for SPI - Echo Buffer 
* Several fix's in mptscsih_io_done - FCP Response 
info, RESIDUAL_MISMATCH, Data Underrun, etc.
* Cleanup Error Handling - EH handlers, 
mptscsih_flush_cmds, and zeroing out ScsiLookup 
from mptscsih_qcmd
* Cleanup asyn event handling from 
mptscsih -> mptscsih_event_process.  Also
added support for SAS Persistent Table Full, 
an asyn event

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C5B989.B25BA498
Content-Type: application/octet-stream;
	name="mptfusion.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-09-14 12:16:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-09-14 16:22:54.000000000 =
-0600=0A=
@@ -135,7 +135,6 @@=0A=
 =0A=
 static void	MptDisplayIocCapabilities(MPT_ADAPTER *ioc);=0A=
 static int	MakeIocReady(MPT_ADAPTER *ioc, int force, int =
sleepFlag);=0A=
-//static u32	mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);=0A=
 static int	GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int =
reason);=0A=
 static int	GetPortFacts(MPT_ADAPTER *ioc, int portnum, int =
sleepFlag);=0A=
 static int	SendIocInit(MPT_ADAPTER *ioc, int sleepFlag);=0A=
@@ -178,6 +177,7 @@=0A=
 static void	mpt_sp_ioc_info(MPT_ADAPTER *ioc, u32 ioc_status, =
MPT_FRAME_HDR *mf);=0A=
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
 static void	mpt_sp_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
+static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);=0A=
 =0A=
 /* module entry point */=0A=
 static int  __init    fusion_init  (void);=0A=
@@ -209,6 +209,144 @@=0A=
 	pci_write_config_word(pdev, PCI_COMMAND, command_reg);=0A=
 }=0A=
 =0A=
+/*=0A=
+ *  Process turbo (context) reply...=0A=
+ */=0A=
+static void=0A=
+mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)=0A=
+{=0A=
+	MPT_FRAME_HDR *mf =3D NULL;=0A=
+	MPT_FRAME_HDR *mr =3D NULL;=0A=
+	int req_idx =3D 0;=0A=
+	int cb_idx;=0A=
+=0A=
+	dmfprintk((MYIOC_s_INFO_FMT "Got TURBO reply req_idx=3D%08x\n",=0A=
+				ioc->name, pa));=0A=
+=0A=
+	switch (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT) {=0A=
+	case MPI_CONTEXT_REPLY_TYPE_SCSI_INIT:=0A=
+		req_idx =3D pa & 0x0000FFFF;=0A=
+		cb_idx =3D (pa & 0x00FF0000) >> 16;=0A=
+		mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
+		break;=0A=
+	case MPI_CONTEXT_REPLY_TYPE_LAN:=0A=
+		cb_idx =3D mpt_lan_index;=0A=
+		/*=0A=
+		 *  Blind set of mf to NULL here was fatal=0A=
+		 *  after lan_reply says "freeme"=0A=
+		 *  Fix sort of combined with an optimization here;=0A=
+		 *  added explicit check for case where lan_reply=0A=
+		 *  was just returning 1 and doing nothing else.=0A=
+		 *  For this case skip the callback, but set up=0A=
+		 *  proper mf value first here:-)=0A=
+		 */=0A=
+		if ((pa & 0x58000000) =3D=3D 0x58000000) {=0A=
+			req_idx =3D pa & 0x0000FFFF;=0A=
+			mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
+			mpt_free_msg_frame(ioc, mf);=0A=
+			mb();=0A=
+			return;=0A=
+			break;=0A=
+		}=0A=
+		mr =3D (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);=0A=
+		break;=0A=
+	case MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET:=0A=
+		cb_idx =3D mpt_stm_index;=0A=
+		mr =3D (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);=0A=
+		break;=0A=
+	default:=0A=
+		cb_idx =3D 0;=0A=
+		BUG();=0A=
+	}=0A=
+=0A=
+	/*  Check for (valid) IO callback!  */=0A=
+	if (cb_idx < 1 || cb_idx >=3D MPT_MAX_PROTOCOL_DRIVERS ||=0A=
+			MptCallbacks[cb_idx] =3D=3D NULL) {=0A=
+		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",=0A=
+				__FUNCTION__, ioc->name, cb_idx);=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	if (MptCallbacks[cb_idx](ioc, mf, mr))=0A=
+		mpt_free_msg_frame(ioc, mf);=0A=
+ out:=0A=
+	mb();=0A=
+}=0A=
+=0A=
+static void=0A=
+mpt_reply(MPT_ADAPTER *ioc, u32 pa)=0A=
+{=0A=
+	MPT_FRAME_HDR	*mf;=0A=
+	MPT_FRAME_HDR	*mr;=0A=
+	int		 req_idx;=0A=
+	int		 cb_idx;=0A=
+	int		 freeme;=0A=
+=0A=
+	u32 reply_dma_low;=0A=
+	u16 ioc_stat;=0A=
+=0A=
+	/* non-TURBO reply!  Hmmm, something may be up...=0A=
+	 *  Newest turbo reply mechanism; get address=0A=
+	 *  via left shift 1 (get rid of MPI_ADDRESS_REPLY_A_BIT)!=0A=
+	 */=0A=
+=0A=
+	/* Map DMA address of reply header to cpu address.=0A=
+	 * pa is 32 bits - but the dma address may be 32 or 64 bits=0A=
+	 * get offset based only only the low addresses=0A=
+	 */=0A=
+=0A=
+	reply_dma_low =3D (pa <<=3D 1);=0A=
+	mr =3D (MPT_FRAME_HDR *)((u8 *)ioc->reply_frames +=0A=
+			 (reply_dma_low - ioc->reply_frames_low_dma));=0A=
+=0A=
+	req_idx =3D le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
+	cb_idx =3D mr->u.frame.hwhdr.msgctxu.fld.cb_idx;=0A=
+	mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
+=0A=
+	dmfprintk((MYIOC_s_INFO_FMT "Got non-TURBO reply=3D%p req_idx=3D%x =
cb_idx=3D%x Function=3D%x\n",=0A=
+			ioc->name, mr, req_idx, cb_idx, mr->u.hdr.Function));=0A=
+	DBG_DUMP_REPLY_FRAME(mr)=0A=
+=0A=
+	 /*  Check/log IOC log info=0A=
+	 */=0A=
+	ioc_stat =3D le16_to_cpu(mr->u.reply.IOCStatus);=0A=
+	if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {=0A=
+		u32	 log_info =3D le32_to_cpu(mr->u.reply.IOCLogInfo);=0A=
+		if (ioc->bus_type =3D=3D FC)=0A=
+			mpt_fc_log_info(ioc, log_info);=0A=
+		else if (ioc->bus_type =3D=3D SCSI)=0A=
+			mpt_sp_log_info(ioc, log_info);=0A=
+		else if (ioc->bus_type =3D=3D SAS)=0A=
+			mpt_sas_log_info(ioc, log_info);=0A=
+	}=0A=
+	if (ioc_stat & MPI_IOCSTATUS_MASK) {=0A=
+		if (ioc->bus_type =3D=3D SCSI &&=0A=
+		    cb_idx !=3D mpt_stm_index &&=0A=
+		    cb_idx !=3D mpt_lan_index)=0A=
+			mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);=0A=
+	}=0A=
+=0A=
+=0A=
+	/*  Check for (valid) IO callback!  */=0A=
+	if (cb_idx < 1 || cb_idx >=3D MPT_MAX_PROTOCOL_DRIVERS ||=0A=
+			MptCallbacks[cb_idx] =3D=3D NULL) {=0A=
+		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",=0A=
+				__FUNCTION__, ioc->name, cb_idx);=0A=
+		freeme =3D 0;=0A=
+		goto out;=0A=
+	}=0A=
+=0A=
+	freeme =3D MptCallbacks[cb_idx](ioc, mf, mr);=0A=
+=0A=
+ out:=0A=
+	/*  Flush (non-TURBO) reply with a WRITE!  */=0A=
+	CHIPREG_WRITE32(&ioc->chip->ReplyFifo, pa);=0A=
+=0A=
+	if (freeme)=0A=
+		mpt_free_msg_frame(ioc, mf);=0A=
+	mb();=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mpt_interrupt - MPT adapter (IOC) specific interrupt handler.=0A=
@@ -230,164 +368,21 @@=0A=
 static irqreturn_t=0A=
 mpt_interrupt(int irq, void *bus_id, struct pt_regs *r)=0A=
 {=0A=
-	MPT_ADAPTER	*ioc;=0A=
-	MPT_FRAME_HDR	*mf;=0A=
-	MPT_FRAME_HDR	*mr;=0A=
-	u32		 pa;=0A=
-	int		 req_idx;=0A=
-	int		 cb_idx;=0A=
-	int		 type;=0A=
-	int		 freeme;=0A=
-=0A=
-	ioc =3D (MPT_ADAPTER *)bus_id;=0A=
+	MPT_ADAPTER *ioc =3D bus_id;=0A=
+	u32 pa;=0A=
 =0A=
 	/*=0A=
 	 *  Drain the reply FIFO!=0A=
-	 *=0A=
-	 * NOTES: I've seen up to 10 replies processed in this loop, so =
far...=0A=
-	 * Update: I've seen up to 9182 replies processed in this loop! ??=0A=
-	 * Update: Limit ourselves to processing max of N replies=0A=
-	 *	(bottom of loop).=0A=
 	 */=0A=
 	while (1) {=0A=
-=0A=
-		if ((pa =3D CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo)) =3D=3D =
0xFFFFFFFF)=0A=
+		pa =3D CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);=0A=
+		if (pa =3D=3D 0xFFFFFFFF)=0A=
 			return IRQ_HANDLED;=0A=
-=0A=
-		cb_idx =3D 0;=0A=
-		freeme =3D 0;=0A=
-=0A=
-		/*=0A=
-		 *  Check for non-TURBO reply!=0A=
-		 */=0A=
-		if (pa & MPI_ADDRESS_REPLY_A_BIT) {=0A=
-			u32 reply_dma_low;=0A=
-			u16 ioc_stat;=0A=
-=0A=
-			/* non-TURBO reply!  Hmmm, something may be up...=0A=
-			 *  Newest turbo reply mechanism; get address=0A=
-			 *  via left shift 1 (get rid of MPI_ADDRESS_REPLY_A_BIT)!=0A=
-			 */=0A=
-=0A=
-			/* Map DMA address of reply header to cpu address.=0A=
-			 * pa is 32 bits - but the dma address may be 32 or 64 bits=0A=
-			 * get offset based only only the low addresses=0A=
-			 */=0A=
-			reply_dma_low =3D (pa =3D (pa << 1));=0A=
-			mr =3D (MPT_FRAME_HDR *)((u8 *)ioc->reply_frames +=0A=
-					 (reply_dma_low - ioc->reply_frames_low_dma));=0A=
-=0A=
-			req_idx =3D le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
-			cb_idx =3D mr->u.frame.hwhdr.msgctxu.fld.cb_idx;=0A=
-			mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
-=0A=
-			dmfprintk((MYIOC_s_INFO_FMT "Got non-TURBO reply=3D%p req_idx=3D%x =
cb_idx=3D%x Function=3D%x\n",=0A=
-					ioc->name, mr, req_idx, cb_idx, mr->u.hdr.Function));=0A=
-			DBG_DUMP_REPLY_FRAME(mr)=0A=
-=0A=
-			 /*  Check/log IOC log info=0A=
-			 */=0A=
-			ioc_stat =3D le16_to_cpu(mr->u.reply.IOCStatus);=0A=
-			if (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {=0A=
-				u32	 log_info =3D le32_to_cpu(mr->u.reply.IOCLogInfo);=0A=
-				if (ioc->bus_type =3D=3D FC)=0A=
-					mpt_fc_log_info(ioc, log_info);=0A=
-				else if (ioc->bus_type =3D=3D SCSI)=0A=
-					mpt_sp_log_info(ioc, log_info);=0A=
-			}=0A=
-			if (ioc_stat & MPI_IOCSTATUS_MASK) {=0A=
-				if (ioc->bus_type =3D=3D SCSI)=0A=
-					mpt_sp_ioc_info(ioc, (u32)ioc_stat, mf);=0A=
-			}=0A=
-		} else {=0A=
-			/*=0A=
-			 *  Process turbo (context) reply...=0A=
-			 */=0A=
-			dmfprintk((MYIOC_s_INFO_FMT "Got TURBO reply req_idx=3D%08x\n", =
ioc->name, pa));=0A=
-			type =3D (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT);=0A=
-			if (type =3D=3D MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET) {=0A=
-				cb_idx =3D mpt_stm_index;=0A=
-				mf =3D NULL;=0A=
-				mr =3D (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);=0A=
-			} else if (type =3D=3D MPI_CONTEXT_REPLY_TYPE_LAN) {=0A=
-				cb_idx =3D mpt_lan_index;=0A=
-				 /*  Blind set of mf to NULL here was fatal=0A=
-				 *  after lan_reply says "freeme"=0A=
-				 *  Fix sort of combined with an optimization here;=0A=
-				 *  added explicit check for case where lan_reply=0A=
-				 *  was just returning 1 and doing nothing else.=0A=
-				 *  For this case skip the callback, but set up=0A=
-				 *  proper mf value first here:-)=0A=
-				 */=0A=
-				if ((pa & 0x58000000) =3D=3D 0x58000000) {=0A=
-					req_idx =3D pa & 0x0000FFFF;=0A=
-					mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
-					freeme =3D 1;=0A=
-					/*=0A=
-					 *  IMPORTANT!  Invalidate the callback!=0A=
-					 */=0A=
-					cb_idx =3D 0;=0A=
-				} else {=0A=
-					mf =3D NULL;=0A=
-				}=0A=
-				mr =3D (MPT_FRAME_HDR *) CAST_U32_TO_PTR(pa);=0A=
-			} else {=0A=
-				req_idx =3D pa & 0x0000FFFF;=0A=
-				cb_idx =3D (pa & 0x00FF0000) >> 16;=0A=
-				mf =3D MPT_INDEX_2_MFPTR(ioc, req_idx);=0A=
-				mr =3D NULL;=0A=
-			}=0A=
-			pa =3D 0;					/* No reply flush! */=0A=
-		}=0A=
-=0A=
-#ifdef MPT_DEBUG_IRQ=0A=
-		if (ioc->bus_type =3D=3D SCSI) {=0A=
-			/* Verify mf, mr are reasonable.=0A=
-			 */=0A=
-			if ((mf) && ((mf >=3D MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))=0A=
-				|| (mf < ioc->req_frames)) ) {=0A=
-				printk(MYIOC_s_WARN_FMT=0A=
-					"mpt_interrupt: Invalid mf (%p)!\n", ioc->name, (void *)mf);=0A=
-				cb_idx =3D 0;=0A=
-				pa =3D 0;=0A=
-				freeme =3D 0;=0A=
-			}=0A=
-			if ((pa) && (mr) && ((mr >=3D MPT_INDEX_2_RFPTR(ioc, =
ioc->req_depth))=0A=
-				|| (mr < ioc->reply_frames)) ) {=0A=
-				printk(MYIOC_s_WARN_FMT=0A=
-					"mpt_interrupt: Invalid rf (%p)!\n", ioc->name, (void *)mr);=0A=
-				cb_idx =3D 0;=0A=
-				pa =3D 0;=0A=
-				freeme =3D 0;=0A=
-			}=0A=
-			if (cb_idx > (MPT_MAX_PROTOCOL_DRIVERS-1)) {=0A=
-				printk(MYIOC_s_WARN_FMT=0A=
-					"mpt_interrupt: Invalid cb_idx (%d)!\n", ioc->name, cb_idx);=0A=
-				cb_idx =3D 0;=0A=
-				pa =3D 0;=0A=
-				freeme =3D 0;=0A=
-			}=0A=
-		}=0A=
-#endif=0A=
-=0A=
-		/*  Check for (valid) IO callback!  */=0A=
-		if (cb_idx) {=0A=
-			/*  Do the callback!  */=0A=
-			freeme =3D (*(MptCallbacks[cb_idx]))(ioc, mf, mr);=0A=
-		}=0A=
-=0A=
-		if (pa) {=0A=
-			/*  Flush (non-TURBO) reply with a WRITE!  */=0A=
-			CHIPREG_WRITE32(&ioc->chip->ReplyFifo, pa);=0A=
-		}=0A=
-=0A=
-		if (freeme) {=0A=
-			/*  Put Request back on FreeQ!  */=0A=
-			mpt_free_msg_frame(ioc, mf);=0A=
-		}=0A=
-=0A=
-		mb();=0A=
-	}	/* drain reply FIFO */=0A=
+		else if (pa & MPI_ADDRESS_REPLY_A_BIT)=0A=
+			mpt_reply(ioc, pa);=0A=
+		else=0A=
+			mpt_turbo_reply(ioc, pa);=0A=
+	}=0A=
 =0A=
 	return IRQ_HANDLED;=0A=
 }=0A=
@@ -1065,7 +1060,7 @@=0A=
 				    ioc->name,=0A=
 				    ioc->HostPageBuffer,=0A=
 				    ioc->HostPageBuffer_dma,=0A=
-				    hst_page_buffer_sz));=0A=
+				    host_page_buffer_sz));=0A=
 				ioc->alloc_total +=3D host_page_buffer_sz;=0A=
 				ioc->HostPageBuffer_sz =3D host_page_buffer_sz;=0A=
 				break;=0A=
@@ -1208,7 +1203,7 @@=0A=
 =0A=
 	/* Initilize SCSI Config Data structure=0A=
 	 */=0A=
-	memset(&ioc->spi_data, 0, sizeof(ScsiCfgData));=0A=
+	memset(&ioc->spi_data, 0, sizeof(SpiCfgData));=0A=
 =0A=
 	/* Initialize the running configQ head.=0A=
 	 */=0A=
@@ -1755,8 +1750,23 @@=0A=
 			 */=0A=
 			if (ret =3D=3D 0) {=0A=
 				rc =3D mpt_do_upload(ioc, sleepFlag);=0A=
-				if (rc !=3D 0)=0A=
+				if (rc =3D=3D 0) {=0A=
+					if (ioc->alt_ioc && ioc->alt_ioc->cached_fw) {=0A=
+						/*=0A=
+						 * Maintain only one pointer to FW memory=0A=
+						 * so there will not be two attempt to=0A=
+						 * downloadboot onboard dual function=0A=
+						 * chips (mpt_adapter_disable,=0A=
+						 * mpt_diag_reset)=0A=
+						 */=0A=
+						ioc->cached_fw =3D NULL;=0A=
+						ddlprintk((MYIOC_s_INFO_FMT ": mpt_upload:  alt_%s has =
cached_fw=3D%p \n",=0A=
+							ioc->name, ioc->alt_ioc->name, ioc->alt_ioc->cached_fw));=0A=
+					}=0A=
+				} else {=0A=
 					printk(KERN_WARNING MYNAM ": firmware upload failure!\n");=0A=
+					ret =3D -5;=0A=
+				}=0A=
 			}=0A=
 		}=0A=
 	}=0A=
@@ -1997,9 +2007,9 @@=0A=
 	}=0A=
 =0A=
 	kfree(ioc->spi_data.nvram);=0A=
-	kfree(ioc->spi_data.pIocPg3);=0A=
+	kfree(ioc->raid_data.pIocPg3);=0A=
 	ioc->spi_data.nvram =3D NULL;=0A=
-	ioc->spi_data.pIocPg3 =3D NULL;=0A=
+	ioc->raid_data.pIocPg3 =3D NULL;=0A=
 =0A=
 	if (ioc->spi_data.pIocPg4 !=3D NULL) {=0A=
 		sz =3D ioc->spi_data.IocPg4Sz;=0A=
@@ -3852,7 +3862,7 @@=0A=
 	int count =3D 0;=0A=
 	u32 intstat=3D0;=0A=
 =0A=
-	cntdn =3D ((sleepFlag =3D=3D CAN_SLEEP) ? HZ : 1000) * howlong;=0A=
+	cntdn =3D 1000 * howlong;=0A=
 =0A=
 	if (sleepFlag =3D=3D CAN_SLEEP) {=0A=
 		while (--cntdn) {=0A=
@@ -3902,7 +3912,7 @@=0A=
 	int count =3D 0;=0A=
 	u32 intstat=3D0;=0A=
 =0A=
-	cntdn =3D ((sleepFlag =3D=3D CAN_SLEEP) ? HZ : 1000) * howlong;=0A=
+	cntdn =3D 1000 * howlong;=0A=
 	if (sleepFlag =3D=3D CAN_SLEEP) {=0A=
 		while (--cntdn) {=0A=
 			intstat =3D CHIPREG_READ32(&ioc->chip->IntStatus);=0A=
@@ -4634,10 +4644,10 @@=0A=
 	if (mpt_config(ioc, &cfg) !=3D 0)=0A=
 		goto done_and_free;=0A=
 =0A=
-	if ( (mem =3D (u8 *)ioc->spi_data.pIocPg2) =3D=3D NULL ) {=0A=
+	if ( (mem =3D (u8 *)ioc->raid_data.pIocPg2) =3D=3D NULL ) {=0A=
 		mem =3D kmalloc(iocpage2sz, GFP_ATOMIC);=0A=
 		if (mem) {=0A=
-			ioc->spi_data.pIocPg2 =3D (IOCPage2_t *) mem;=0A=
+			ioc->raid_data.pIocPg2 =3D (IOCPage2_t *) mem;=0A=
 		} else {=0A=
 			goto done_and_free;=0A=
 		}=0A=
@@ -4654,7 +4664,7 @@=0A=
 		/* At least 1 RAID Volume=0A=
 		 */=0A=
 		pIocRv =3D pIoc2->RaidVolume;=0A=
-		ioc->spi_data.isRaid =3D 0;=0A=
+		ioc->raid_data.isRaid =3D 0;=0A=
 		for (jj =3D 0; jj < nVols; jj++, pIocRv++) {=0A=
 			vid =3D pIocRv->VolumeID;=0A=
 			vbus =3D pIocRv->VolumeBus;=0A=
@@ -4663,7 +4673,7 @@=0A=
 			/* find the match=0A=
 			 */=0A=
 			if (vbus =3D=3D 0) {=0A=
-				ioc->spi_data.isRaid |=3D (1 << vid);=0A=
+				ioc->raid_data.isRaid |=3D (1 << vid);=0A=
 			} else {=0A=
 				/* Error! Always bus 0=0A=
 				 */=0A=
@@ -4698,8 +4708,8 @@=0A=
 =0A=
 	/* Free the old page=0A=
 	 */=0A=
-	kfree(ioc->spi_data.pIocPg3);=0A=
-	ioc->spi_data.pIocPg3 =3D NULL;=0A=
+	kfree(ioc->raid_data.pIocPg3);=0A=
+	ioc->raid_data.pIocPg3 =3D NULL;=0A=
 =0A=
 	/* There is at least one physical disk.=0A=
 	 * Read and save IOC Page 3=0A=
@@ -4736,7 +4746,7 @@=0A=
 		mem =3D kmalloc(iocpage3sz, GFP_ATOMIC);=0A=
 		if (mem) {=0A=
 			memcpy(mem, (u8 *)pIoc3, iocpage3sz);=0A=
-			ioc->spi_data.pIocPg3 =3D (IOCPage3_t *) mem;=0A=
+			ioc->raid_data.pIocPg3 =3D (IOCPage3_t *) mem;=0A=
 		}=0A=
 	}=0A=
 =0A=
@@ -6022,6 +6032,111 @@=0A=
 	printk(MYIOC_s_INFO_FMT "LogInfo(0x%08x): F/W: %s\n", ioc->name, =
log_info, desc);=0A=
 }=0A=
 =0A=
+/* strings for sas loginfo */=0A=
+	static char *originator_str[] =3D {=0A=
+		"IOP",						/* 00h */=0A=
+		"PL",						/* 01h */=0A=
+		"IR"						/* 02h */=0A=
+	};=0A=
+	static char *iop_code_str[] =3D {=0A=
+		NULL,						/* 00h */=0A=
+		"Invalid SAS Address",				/* 01h */=0A=
+		NULL,						/* 02h */=0A=
+		"Invalid Page",					/* 03h */=0A=
+		NULL,						/* 04h */=0A=
+		"Task Terminated"				/* 05h */=0A=
+	};=0A=
+	static char *pl_code_str[] =3D {=0A=
+		NULL,						/* 00h */=0A=
+		"Open Failure",					/* 01h */=0A=
+		"Invalid Scatter Gather List",			/* 02h */=0A=
+		"Wrong Relative Offset or Frame Length",	/* 03h */=0A=
+		"Frame Transfer Error",				/* 04h */=0A=
+		"Transmit Frame Connected Low",			/* 05h */=0A=
+		"SATA Non-NCQ RW Error Bit Set",		/* 06h */=0A=
+		"SATA Read Log Receive Data Error",		/* 07h */=0A=
+		"SATA NCQ Fail All Commands After Error",	/* 08h */=0A=
+		"SATA Error in Receive Set Device Bit FIS",	/* 09h */=0A=
+		"Receive Frame Invalid Message",		/* 0Ah */=0A=
+		"Receive Context Message Valid Error",		/* 0Bh */=0A=
+		"Receive Frame Current Frame Error",		/* 0Ch */=0A=
+		"SATA Link Down",				/* 0Dh */=0A=
+		"Discovery SATA Init W IOS",			/* 0Eh */=0A=
+		"Config Invalid Page",				/* 0Fh */=0A=
+		"Discovery SATA Init Timeout",			/* 10h */=0A=
+		"Reset",					/* 11h */=0A=
+		"Abort",					/* 12h */=0A=
+		"IO Not Yet Executed",				/* 13h */=0A=
+		"IO Executed",					/* 14h */=0A=
+		NULL,						/* 15h */=0A=
+		NULL,						/* 16h */=0A=
+		NULL,						/* 17h */=0A=
+		NULL,						/* 18h */=0A=
+		NULL,						/* 19h */=0A=
+		NULL,						/* 1Ah */=0A=
+		NULL,						/* 1Bh */=0A=
+		NULL,						/* 1Ch */=0A=
+		NULL,						/* 1Dh */=0A=
+		NULL,						/* 1Eh */=0A=
+		NULL,						/* 1Fh */=0A=
+		"Enclosure Management"				/* 20h */=0A=
+	};=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+ *	mpt_sas_log_info - Log information returned from SAS IOC.=0A=
+ *	@ioc: Pointer to MPT_ADAPTER structure=0A=
+ *	@log_info: U32 LogInfo reply word from the IOC=0A=
+ *=0A=
+ *	Refer to lsi/mpi_log_sas.h.=0A=
+ */=0A=
+static void=0A=
+mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info)=0A=
+{=0A=
+union loginfo_type {=0A=
+	u32	loginfo;=0A=
+	struct {=0A=
+		u32	subcode:16;=0A=
+		u32	code:8;=0A=
+		u32	originator:4;=0A=
+		u32	bus_type:4;=0A=
+	}dw;=0A=
+};=0A=
+	union loginfo_type sas_loginfo;=0A=
+	char *code_desc =3D NULL;=0A=
+=0A=
+	sas_loginfo.loginfo =3D log_info;=0A=
+	if ((sas_loginfo.dw.bus_type !=3D 3 /*SAS*/) &&=0A=
+	    (sas_loginfo.dw.originator < =
sizeof(originator_str)/sizeof(char*)))=0A=
+		return;=0A=
+	if ((sas_loginfo.dw.originator =3D=3D 0 /*IOP*/) &&=0A=
+	    (sas_loginfo.dw.code < sizeof(iop_code_str)/sizeof(char*))) {=0A=
+		code_desc =3D iop_code_str[sas_loginfo.dw.code];=0A=
+	}else if ((sas_loginfo.dw.originator =3D=3D 1 /*PL*/) &&=0A=
+	    (sas_loginfo.dw.code < sizeof(pl_code_str)/sizeof(char*) )) {=0A=
+		code_desc =3D pl_code_str[sas_loginfo.dw.code];=0A=
+	}=0A=
+=0A=
+	if (code_desc !=3D NULL)=0A=
+		printk(MYIOC_s_INFO_FMT=0A=
+			"LogInfo(0x%08x): Originator=3D{%s}, Code=3D{%s},"=0A=
+			" SubCode(0x%04x)\n",=0A=
+			ioc->name,=0A=
+			log_info,=0A=
+			originator_str[sas_loginfo.dw.originator],=0A=
+			code_desc,=0A=
+			sas_loginfo.dw.subcode);=0A=
+	else=0A=
+		printk(MYIOC_s_INFO_FMT=0A=
+			"LogInfo(0x%08x): Originator=3D{%s}, Code=3D(0x%02x),"=0A=
+			" SubCode(0x%04x)\n",=0A=
+			ioc->name,=0A=
+			log_info,=0A=
+			originator_str[sas_loginfo.dw.originator],=0A=
+			sas_loginfo.dw.code,=0A=
+			sas_loginfo.dw.subcode);=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mpt_sp_ioc_info - IOC information returned from SCSI Parallel =
IOC.=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-09-14 12:16:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-09-14 17:17:19.000000000 =
-0600=0A=
@@ -77,8 +77,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.03.02"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.02"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.03"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.03"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -424,7 +424,7 @@=0A=
 /*=0A=
  *  Event Structure and define=0A=
  */=0A=
-#define MPTCTL_EVENT_LOG_SIZE		(0x0000000A)=0A=
+#define MPTCTL_EVENT_LOG_SIZE		(0x000000032)=0A=
 typedef struct _mpt_ioctl_events {=0A=
 	u32	event;		/* Specified by define above */=0A=
 	u32	eventContext;	/* Index or counter */=0A=
@@ -452,16 +452,13 @@=0A=
 #define MPT_SCSICFG_ALL_IDS		0x02	/* WriteSDP1 to all IDS */=0A=
 /* #define MPT_SCSICFG_BLK_NEGO		0x10	   WriteSDP1 with WDTR and SDTR =
disabled */=0A=
 =0A=
-typedef	struct _ScsiCfgData {=0A=
+typedef	struct _SpiCfgData {=0A=
 	u32		 PortFlags;=0A=
 	int		*nvram;			/* table of device NVRAM values */=0A=
-	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */=0A=
-	IOCPage3_t	*pIocPg3;		/* table of physical disks */=0A=
 	IOCPage4_t	*pIocPg4;		/* SEP devices addressing */=0A=
 	dma_addr_t	 IocPg4_dma;		/* Phys Addr of IOCPage4 data */=0A=
 	int		 IocPg4Sz;		/* IOCPage4 size */=0A=
 	u8		 dvStatus[MPT_MAX_SCSI_DEVICES];=0A=
-	int		 isRaid;		/* bit field, 1 if RAID */=0A=
 	u8		 minSyncFactor;		/* 0xFF if async */=0A=
 	u8		 maxSyncOffset;		/* 0 if async */=0A=
 	u8		 maxBusWidth;		/* 0 if narrow, 1 if wide */=0A=
@@ -473,10 +470,14 @@=0A=
 	u8		 dvScheduled;		/* 1 if scheduled */=0A=
 	u8		 forceDv;		/* 1 to force DV scheduling */=0A=
 	u8		 noQas;			/* Disable QAS for this adapter */=0A=
-	u8		 Saf_Te;		/* 1 to force all Processors as SAF-TE if Inquiry data =
length is too short to check for SAF-TE */=0A=
+	u8		 Saf_Te;		/* 1 to force all Processors as=0A=
+						 * SAF-TE if Inquiry data length=0A=
+						 * is too short to check for SAF-TE=0A=
+						 */=0A=
 	u8		 mpt_dv;		/* command line option: enhanced=3D1, basic=3D0 */=0A=
+	u8		 bus_reset;		/* 1 to allow bus reset */=0A=
 	u8		 rsvd[1];=0A=
-} ScsiCfgData;=0A=
+}SpiCfgData;=0A=
 =0A=
 typedef	struct _SasCfgData {=0A=
 	u8		 ptClear;		/* 1 to automatically clear the=0A=
@@ -486,6 +487,12 @@=0A=
 						 */=0A=
 }SasCfgData;=0A=
 =0A=
+typedef	struct _RaidCfgData {=0A=
+	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */=0A=
+	IOCPage3_t	*pIocPg3;		/* table of physical disks */=0A=
+	int		 isRaid;		/* bit field, 1 if RAID */=0A=
+}RaidCfgData;=0A=
+=0A=
 /*=0A=
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS=0A=
  */=0A=
@@ -546,7 +553,8 @@=0A=
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */=0A=
 	u8			__iomem *memmap;	/* mmap address */=0A=
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */=0A=
-	ScsiCfgData		spi_data;	/* Scsi config. data */=0A=
+	SpiCfgData		spi_data;	/* Scsi config. data */=0A=
+	RaidCfgData		raid_data;	/* Raid config. data */=0A=
 	SasCfgData		sas_data;	/* Sas config. data */=0A=
 	MPT_IOCTL		*ioctl;		/* ioctl data pointer */=0A=
 	struct proc_dir_entry	*ioc_dentry;=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2005-09-14 12:15:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2005-09-14 17:19:20.000000000 =
-0600=0A=
@@ -1326,7 +1326,7 @@=0A=
 		 */=0A=
 		if (hd && hd->Targets) {=0A=
 			mpt_findImVolumes(ioc);=0A=
-			pIoc2 =3D ioc->spi_data.pIocPg2;=0A=
+			pIoc2 =3D ioc->raid_data.pIocPg2;=0A=
 			for ( id =3D 0; id <=3D max_id; ) {=0A=
 				if ( pIoc2 && pIoc2->NumActiveVolumes ) {=0A=
 					if ( id =3D=3D pIoc2->RaidVolume[0].VolumeID ) {=0A=
@@ -1348,7 +1348,7 @@=0A=
 						--maxWordsLeft;=0A=
 						goto next_id;=0A=
 					} else {=0A=
-						pIoc3 =3D ioc->spi_data.pIocPg3;=0A=
+						pIoc3 =3D ioc->raid_data.pIocPg3;=0A=
             					for ( jj =3D 0; jj < pIoc3->NumPhysDisks; jj++ ) {=0A=
                     					if ( pIoc3->PhysDisk[jj].PhysDiskID =3D=3D id =
)=0A=
 								goto next_id;=0A=
diff -uarN b/drivers/message/fusion/mptfc.c =
a/drivers/message/fusion/mptfc.c=0A=
--- b/drivers/message/fusion/mptfc.c	2005-08-28 17:41:01.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptfc.c	2005-09-14 17:14:34.000000000 =
-0600=0A=
@@ -189,7 +189,7 @@=0A=
 		printk(MYIOC_s_WARN_FMT=0A=
 			"Skipping ioc=3D%p because SCSI Initiator mode is NOT =
enabled!\n",=0A=
 			ioc->name, ioc);=0A=
-		return -ENODEV;=0A=
+		return 0;=0A=
 	}=0A=
 =0A=
 	sh =3D scsi_host_alloc(&mptfc_driver_template, =
sizeof(MPT_SCSI_HOST));=0A=
diff -uarN b/drivers/message/fusion/mptlan.c =
a/drivers/message/fusion/mptlan.c=0A=
--- b/drivers/message/fusion/mptlan.c	2005-08-28 17:41:01.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptlan.c	2005-09-14 16:31:39.000000000 =
-0600=0A=
@@ -312,7 +312,12 @@=0A=
 mpt_lan_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)=0A=
 {=0A=
 	struct net_device *dev =3D ioc->netdev;=0A=
-	struct mpt_lan_priv *priv =3D netdev_priv(dev);=0A=
+	struct mpt_lan_priv *priv;=0A=
+=0A=
+	if (dev =3D=3D NULL)=0A=
+		return(1);=0A=
+	else=0A=
+		priv =3D netdev_priv(dev);=0A=
 =0A=
 	dlprintk((KERN_INFO MYNAM ": IOC %s_reset routed to LAN =
driver!\n",=0A=
 			reset_phase=3D=3DMPT_IOC_SETUP_RESET ? "setup" : (=0A=
diff -uarN b/drivers/message/fusion/mptsas.c =
a/drivers/message/fusion/mptsas.c=0A=
--- b/drivers/message/fusion/mptsas.c	2005-09-14 12:16:06.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptsas.c	2005-09-14 17:14:13.000000000 =
-0600=0A=
@@ -980,7 +980,7 @@=0A=
 		printk(MYIOC_s_WARN_FMT=0A=
 			"Skipping ioc=3D%p because SCSI Initiator mode "=0A=
 			"is NOT enabled!\n", ioc->name, ioc);=0A=
-		return -ENODEV;=0A=
+		return 0;=0A=
 	}=0A=
 =0A=
 	sh =3D scsi_host_alloc(&mptsas_driver_template, =
sizeof(MPT_SCSI_HOST));=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-09-14 12:16:00.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-09-14 17:23:32.000000000 =
-0600=0A=
@@ -93,8 +93,9 @@=0A=
 =0A=
 #define MPT_ICFLAG_BUF_CAP	0x01	/* ReadBuffer Read Capacity format =
*/=0A=
 #define MPT_ICFLAG_ECHO		0x02	/* ReadBuffer Echo buffer format */=0A=
-#define MPT_ICFLAG_PHYS_DISK	0x04	/* Any SCSI IO but do Phys Disk =
Format */=0A=
-#define MPT_ICFLAG_TAGGED_CMD	0x08	/* Do tagged IO */=0A=
+#define MPT_ICFLAG_EBOS		0x04	/* ReadBuffer Echo buffer has EBOS */=0A=
+#define MPT_ICFLAG_PHYS_DISK	0x08	/* Any SCSI IO but do Phys Disk =
Format */=0A=
+#define MPT_ICFLAG_TAGGED_CMD	0x10	/* Do tagged IO */=0A=
 #define MPT_ICFLAG_DID_RESET	0x20	/* Bus Reset occurred with this =
command */=0A=
 #define MPT_ICFLAG_RESERVED	0x40	/* Reserved has been issued */=0A=
 =0A=
@@ -159,6 +160,8 @@=0A=
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);=0A=
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int =
portnum);=0A=
 =0A=
+static struct work_struct   mptscsih_persistTask;=0A=
+=0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD =
*io);=0A=
 static void	mptscsih_domainValidation(void *hd);=0A=
@@ -167,6 +170,7 @@=0A=
 static int	mptscsih_doDv(MPT_SCSI_HOST *hd, int channel, int =
target);=0A=
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void =
*pPage);=0A=
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int =
width);=0A=
+static void	mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id);=0A=
 #endif=0A=
 =0A=
 void 		mptscsih_remove(struct pci_dev *);=0A=
@@ -606,11 +610,24 @@=0A=
 		xfer_cnt =3D le32_to_cpu(pScsiReply->TransferCount);=0A=
 		sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
 =0A=
+		/*=0A=
+		 *  if we get a data underrun indication, yet no data was=0A=
+		 *  transferred and the SCSI status indicates that the=0A=
+		 *  command was never started, change the data underrun=0A=
+		 *  to success=0A=
+		 */=0A=
+		if (status =3D=3D MPI_IOCSTATUS_SCSI_DATA_UNDERRUN && xfer_cnt =
=3D=3D 0 &&=0A=
+		    (scsi_status =3D=3D MPI_SCSI_STATUS_BUSY ||=0A=
+		     scsi_status =3D=3D MPI_SCSI_STATUS_RESERVATION_CONFLICT ||=0A=
+		     scsi_status =3D=3D MPI_SCSI_STATUS_TASK_SET_FULL)) {=0A=
+			status =3D MPI_IOCSTATUS_SUCCESS;=0A=
+		}=0A=
+=0A=
 		dreplyprintk((KERN_NOTICE "Reply ha=3D%d id=3D%d lun=3D%d:\n"=0A=
 			"IOCStatus=3D%04xh SCSIState=3D%02xh SCSIStatus=3D%02xh\n"=0A=
 			"resid=3D%d bufflen=3D%d xfer_cnt=3D%d\n",=0A=
 			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
-			status, scsi_state, scsi_status, sc->resid, =0A=
+			status, scsi_state, scsi_status, sc->resid,=0A=
 			sc->request_bufflen, xfer_cnt));=0A=
 =0A=
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)=0A=
@@ -619,8 +636,11 @@=0A=
 		/*=0A=
 		 *  Look for + dump FCP ResponseInfo[]!=0A=
 		 */=0A=
-		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID) {=0A=
-			printk(KERN_NOTICE "  FCP_ResponseInfo=3D%08xh\n",=0A=
+		if (scsi_state & MPI_SCSI_STATE_RESPONSE_INFO_VALID &&=0A=
+		    pScsiReply->ResponseInfo) {=0A=
+			printk(KERN_NOTICE "ha=3D%d id=3D%d lun=3D%d: "=0A=
+			"FCP_ResponseInfo=3D%08xh\n",=0A=
+			ioc->id, pScsiReq->TargetID, pScsiReq->LUN[1],=0A=
 			le32_to_cpu(pScsiReply->ResponseInfo));=0A=
 		}=0A=
 =0A=
@@ -661,23 +681,13 @@=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */=0A=
-			if ( xfer_cnt >=3D sc->underflow ) {=0A=
-				/* Sufficient data transfer occurred */=0A=
+			sc->resid =3D sc->request_bufflen - xfer_cnt;=0A=
+			if((xfer_cnt=3D=3D0)||(sc->underflow > xfer_cnt))=0A=
+				sc->result=3DDID_SOFT_ERROR << 16;=0A=
+			else /* Sufficient data transfer occurred */=0A=
 				sc->result =3D (DID_OK << 16) | scsi_status;=0A=
-			} else if ( xfer_cnt =3D=3D 0 ) {=0A=
-				/* A CRC Error causes this condition; retry */=0A=
-				sc->result =3D (DRIVER_SENSE << 24) | (DID_OK << 16) |=0A=
-					(CHECK_CONDITION << 1);=0A=
-				sc->sense_buffer[0] =3D 0x70;=0A=
-				sc->sense_buffer[2] =3D NO_SENSE;=0A=
-				sc->sense_buffer[12] =3D 0;=0A=
-				sc->sense_buffer[13] =3D 0;=0A=
-			} else {=0A=
-				sc->result =3D DID_SOFT_ERROR << 16;=0A=
-			}=0A=
-			dreplyprintk((KERN_NOTICE=0A=
-			    "RESIDUAL_MISMATCH: result=3D%x on id=3D%d\n",=0A=
-			    sc->result, sc->device->id));=0A=
+			dreplyprintk((KERN_NOTICE =0A=
+			    "RESIDUAL_MISMATCH: result=3D%x on id=3D%d\n", sc->result, =
sc->device->id));=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */=0A=
@@ -692,7 +702,10 @@=0A=
 				;=0A=
 			} else {=0A=
 				if (xfer_cnt < sc->underflow) {=0A=
-					sc->result =3D DID_SOFT_ERROR << 16;=0A=
+					if (scsi_status =3D=3D SAM_STAT_BUSY)=0A=
+						sc->result =3D SAM_STAT_BUSY;=0A=
+					else=0A=
+						sc->result =3D DID_SOFT_ERROR << 16;=0A=
 				}=0A=
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | =
MPI_SCSI_STATE_NO_SCSI_STATUS)) {=0A=
 					/* What to do?=0A=
@@ -717,8 +730,10 @@=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */=0A=
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */=0A=
-			scsi_status =3D pScsiReply->SCSIStatus;=0A=
-			sc->result =3D (DID_OK << 16) | scsi_status;=0A=
+			if (scsi_status =3D=3D MPI_SCSI_STATUS_BUSY)=0A=
+				sc->result =3D (DID_BUS_BUSY << 16) | scsi_status;=0A=
+			else=0A=
+				sc->result =3D (DID_OK << 16) | scsi_status;=0A=
 			if (scsi_state =3D=3D 0) {=0A=
 				;=0A=
 			} else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {=0A=
@@ -890,12 +905,13 @@=0A=
 	SCSIIORequest_t	*mf =3D NULL;=0A=
 	int		 ii;=0A=
 	int		 max =3D hd->ioc->req_depth;=0A=
+	struct scsi_cmnd *sc;=0A=
 =0A=
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max =
%d\n",=0A=
 			target, lun, max));=0A=
 =0A=
 	for (ii=3D0; ii < max; ii++) {=0A=
-		if (hd->ScsiLookup[ii] !=3D NULL) {=0A=
+		if ((sc =3D hd->ScsiLookup[ii]) !=3D NULL) {=0A=
 =0A=
 			mf =3D (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);=0A=
 =0A=
@@ -910,9 +926,22 @@=0A=
 			hd->ScsiLookup[ii] =3D NULL;=0A=
 			mptscsih_freeChainBuffers(hd->ioc, ii);=0A=
 			mpt_free_msg_frame(hd->ioc, (MPT_FRAME_HDR *)mf);=0A=
+			if (sc->use_sg) {=0A=
+				pci_unmap_sg(hd->ioc->pcidev,=0A=
+				(struct scatterlist *) sc->request_buffer,=0A=
+					sc->use_sg,=0A=
+					sc->sc_data_direction);=0A=
+			} else if (sc->request_bufflen) {=0A=
+				pci_unmap_single(hd->ioc->pcidev,=0A=
+					sc->SCp.dma_handle,=0A=
+					sc->request_bufflen,=0A=
+					sc->sc_data_direction);=0A=
+			}=0A=
+			sc->host_scribble =3D NULL;=0A=
+			sc->result =3D DID_NO_CONNECT << 16;=0A=
+			sc->scsi_done(sc);=0A=
 		}=0A=
 	}=0A=
-=0A=
 	return;=0A=
 }=0A=
 =0A=
@@ -967,8 +996,10 @@=0A=
 	unsigned long	 	flags;=0A=
 	int sz1;=0A=
 =0A=
-	if(!host)=0A=
+	if(!host) {=0A=
+		mpt_detach(pdev);=0A=
 		return;=0A=
+	}=0A=
 =0A=
 	scsi_remove_host(host);=0A=
 =0A=
@@ -1422,6 +1453,7 @@=0A=
 	return 0;=0A=
 =0A=
  fail:=0A=
+	hd->ScsiLookup[my_idx] =3D NULL;=0A=
 	mptscsih_freeChainBuffers(hd->ioc, my_idx);=0A=
 	mpt_free_msg_frame(hd->ioc, mf);=0A=
 	return SCSI_MLQUEUE_HOST_BUSY;=0A=
@@ -1709,24 +1741,23 @@=0A=
 	MPT_FRAME_HDR	*mf;=0A=
 	u32		 ctx2abort;=0A=
 	int		 scpnt_idx;=0A=
+	int		 retval;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) =3D=3D =
NULL) {=0A=
 		SCpnt->result =3D DID_RESET << 16;=0A=
 		SCpnt->scsi_done(SCpnt);=0A=
-		dfailprintk((KERN_WARNING MYNAM ": mptscsih_abort: "=0A=
+		dfailprintk((KERN_INFO MYNAM ": mptscsih_abort: "=0A=
 			   "Can't locate host! (sc=3D%p)\n",=0A=
 			   SCpnt));=0A=
 		return FAILED;=0A=
 	}=0A=
 =0A=
 	ioc =3D hd->ioc;=0A=
-	if (hd->resetPending)=0A=
+	if (hd->resetPending) {=0A=
 		return FAILED;=0A=
-=0A=
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting task abort! =
(sc=3D%p)\n",=0A=
-	       hd->ioc->name, SCpnt);=0A=
+	}=0A=
 =0A=
 	if (hd->timeouts < -1)=0A=
 		hd->timeouts++;=0A=
@@ -1734,16 +1765,20 @@=0A=
 	/* Find this command=0A=
 	 */=0A=
 	if ((scpnt_idx =3D SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {=0A=
-		/* Cmd not found in ScsiLookup. =0A=
+		/* Cmd not found in ScsiLookup.=0A=
 		 * Do OS callback.=0A=
 		 */=0A=
 		SCpnt->result =3D DID_RESET << 16;=0A=
-		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "=0A=
+		dtmprintk((KERN_INFO MYNAM ": %s: mptscsih_abort: "=0A=
 			   "Command not in the active list! (sc=3D%p)\n",=0A=
 			   hd->ioc->name, SCpnt));=0A=
 		return SUCCESS;=0A=
 	}=0A=
 =0A=
+	printk(KERN_WARNING MYNAM ": %s: attempting task abort! =
(sc=3D%p)\n",=0A=
+	       hd->ioc->name, SCpnt);=0A=
+	scsi_print_command(SCpnt);=0A=
+=0A=
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!=0A=
 	 * (the IO to be ABORT'd)=0A=
 	 *=0A=
@@ -1756,38 +1791,22 @@=0A=
 =0A=
 	hd->abortSCpnt =3D SCpnt;=0A=
 =0A=
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,=0A=
+	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,=0A=
 		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,=0A=
-		ctx2abort, 2 /* 2 second timeout */)=0A=
-		< 0) {=0A=
+		ctx2abort, 2 /* 2 second timeout */);=0A=
 =0A=
-		/* The TM request failed and the subsequent FW-reload failed!=0A=
-		 * Fatal error case.=0A=
-		 */=0A=
-		printk(MYIOC_s_WARN_FMT "Error issuing abort task! (sc=3D%p)\n",=0A=
-		       hd->ioc->name, SCpnt);=0A=
+	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=3D%p)\n",=0A=
+		hd->ioc->name,=0A=
+		((retval =3D=3D 0) ? "SUCCESS" : "FAILED" ), SCpnt);=0A=
 =0A=
-		/* We must clear our pending flag before clearing our state.=0A=
-		 */=0A=
+	if (retval =3D=3D 0)=0A=
+		return SUCCESS;=0A=
+=0A=
+	if(retval !=3D FAILED ) {=0A=
 		hd->tmPending =3D 0;=0A=
 		hd->tmState =3D TM_STATE_NONE;=0A=
-=0A=
-		/* Unmap the DMA buffers, if any. */=0A=
-		if (SCpnt->use_sg) {=0A=
-			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) =
SCpnt->request_buffer,=0A=
-				    SCpnt->use_sg, SCpnt->sc_data_direction);=0A=
-		} else if (SCpnt->request_bufflen) {=0A=
-			pci_unmap_single(ioc->pcidev, SCpnt->SCp.dma_handle,=0A=
-				SCpnt->request_bufflen, SCpnt->sc_data_direction);=0A=
-		}=0A=
-		hd->ScsiLookup[scpnt_idx] =3D NULL;=0A=
-		SCpnt->result =3D DID_RESET << 16;=0A=
-		SCpnt->scsi_done(SCpnt);		/* Issue the command callback */=0A=
-		mptscsih_freeChainBuffers(ioc, scpnt_idx);=0A=
-		mpt_free_msg_frame(ioc, mf);=0A=
-		return FAILED;=0A=
 	}=0A=
-	return SUCCESS;=0A=
+	return FAILED;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1803,11 +1822,12 @@=0A=
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
+	int		 retval;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) =3D=3D =
NULL){=0A=
-		dtmprintk((KERN_WARNING MYNAM ": mptscsih_dev_reset: "=0A=
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_dev_reset: "=0A=
 			   "Can't locate host! (sc=3D%p)\n",=0A=
 			   SCpnt));=0A=
 		return FAILED;=0A=
@@ -1816,24 +1836,26 @@=0A=
 	if (hd->resetPending)=0A=
 		return FAILED;=0A=
 =0A=
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! =
(sc=3D%p)\n",=0A=
+	printk(KERN_WARNING MYNAM ": %s: attempting target reset! =
(sc=3D%p)\n",=0A=
 	       hd->ioc->name, SCpnt);=0A=
+	scsi_print_command(SCpnt);=0A=
 =0A=
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,=0A=
+	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,=0A=
 		SCpnt->device->channel, SCpnt->device->id,=0A=
-		0, 0, 5 /* 5 second timeout */)=0A=
-		< 0){=0A=
-		/* The TM request failed and the subsequent FW-reload failed!=0A=
-		 * Fatal error case.=0A=
-		 */=0A=
-		printk(MYIOC_s_WARN_FMT "Error processing TaskMgmt request =
(sc=3D%p)\n",=0A=
-		 		hd->ioc->name, SCpnt);=0A=
+		0, 0, 5 /* 5 second timeout */);=0A=
+=0A=
+	printk (KERN_WARNING MYNAM ": %s: target reset: %s (sc=3D%p)\n",=0A=
+		hd->ioc->name,=0A=
+		((retval =3D=3D 0) ? "SUCCESS" : "FAILED" ), SCpnt);=0A=
+=0A=
+	if (retval =3D=3D 0)=0A=
+		return SUCCESS;=0A=
+=0A=
+	if(retval !=3D FAILED ) {=0A=
 		hd->tmPending =3D 0;=0A=
 		hd->tmState =3D TM_STATE_NONE;=0A=
-		return FAILED;=0A=
 	}=0A=
-=0A=
-	return SUCCESS;=0A=
+	return FAILED;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1849,41 +1871,39 @@=0A=
 mptscsih_bus_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
-	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;=0A=
+	int		 retval;=0A=
 =0A=
 	/* If we can't locate our host adapter structure, return FAILED =
status.=0A=
 	 */=0A=
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) =3D=3D =
NULL){=0A=
-		dtmprintk((KERN_WARNING MYNAM ": mptscsih_bus_reset: "=0A=
+		dtmprintk((KERN_INFO MYNAM ": mptscsih_bus_reset: "=0A=
 			   "Can't locate host! (sc=3D%p)\n",=0A=
 			   SCpnt ) );=0A=
 		return FAILED;=0A=
 	}=0A=
 =0A=
-	printk(KERN_WARNING MYNAM ": %s: >> Attempting bus reset! =
(sc=3D%p)\n",=0A=
+	printk(KERN_WARNING MYNAM ": %s: attempting bus reset! =
(sc=3D%p)\n",=0A=
 	       hd->ioc->name, SCpnt);=0A=
+	scsi_print_command(SCpnt);=0A=
 =0A=
 	if (hd->timeouts < -1)=0A=
 		hd->timeouts++;=0A=
 =0A=
-	/* We are now ready to execute the task management request. */=0A=
-	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,=0A=
-		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)=0A=
-	    < 0){=0A=
+	retval =3D mptscsih_TMHandler(hd, =
MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,=0A=
+		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */);=0A=
 =0A=
-		/* The TM request failed and the subsequent FW-reload failed!=0A=
-		 * Fatal error case.=0A=
-		 */=0A=
-		printk(MYIOC_s_WARN_FMT=0A=
-		       "Error processing TaskMgmt request (sc=3D%p)\n",=0A=
-		       hd->ioc->name, SCpnt);=0A=
+	printk (KERN_WARNING MYNAM ": %s: bus reset: %s (sc=3D%p)\n",=0A=
+		hd->ioc->name,=0A=
+		((retval =3D=3D 0) ? "SUCCESS" : "FAILED" ), SCpnt);=0A=
+=0A=
+	if (retval =3D=3D 0)=0A=
+		return SUCCESS;=0A=
+=0A=
+	if(retval !=3D FAILED ) {=0A=
 		hd->tmPending =3D 0;=0A=
 		hd->tmState =3D TM_STATE_NONE;=0A=
-		spin_lock_irq(host_lock);=0A=
-		return FAILED;=0A=
 	}=0A=
-=0A=
-	return SUCCESS;=0A=
+	return FAILED;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -2165,7 +2185,7 @@=0A=
 	vdev->raidVolume =3D 0;=0A=
 	hd->Targets[device->id] =3D vdev;=0A=
 	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if (hd->ioc->spi_data.isRaid & (1 << device->id)) {=0A=
+		if (hd->ioc->raid_data.isRaid & (1 << device->id)) {=0A=
 			vdev->raidVolume =3D 1;=0A=
 			ddvtprintk((KERN_INFO=0A=
 			    "RAID Volume @ id %d\n", device->id));=0A=
@@ -2180,22 +2200,6 @@=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static int =0A=
-mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)=0A=
-{=0A=
-	int i;=0A=
-=0A=
-	if (!hd->ioc->spi_data.isRaid || !hd->ioc->spi_data.pIocPg3)=0A=
-		return 0;=0A=
-=0A=
-	for (i =3D 0; i < hd->ioc->spi_data.pIocPg3->NumPhysDisks; i++) {=0A=
-		if (id =3D=3D hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID)=0A=
-			return 1;=0A=
-	}=0A=
-=0A=
-	return 0;=0A=
-}=0A=
-=0A=
 /*=0A=
  *	OS entry point to allow for host driver to free allocated memory=0A=
  *	Called if no device present or device being unloaded=0A=
@@ -2223,7 +2227,7 @@=0A=
 	hd->Targets[target] =3D NULL;=0A=
 =0A=
 	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
-		if (mptscsih_is_raid_volume(hd, target)) {=0A=
+		if (mptscsih_is_phys_disk(hd->ioc, target)) {=0A=
 			hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 		} else {=0A=
 			hd->ioc->spi_data.dvStatus[target] =3D=0A=
@@ -2436,6 +2440,7 @@=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
 	unsigned long	 flags;=0A=
+	int 		ii;=0A=
 =0A=
 	dtmprintk((KERN_WARNING MYNAM=0A=
 			": IOC %s_reset routed to SCSI host driver!\n",=0A=
@@ -2493,11 +2498,8 @@=0A=
 =0A=
 		/* ScsiLookup initialization=0A=
 		 */=0A=
-		{=0A=
-			int ii;=0A=
-			for (ii=3D0; ii < hd->ioc->req_depth; ii++)=0A=
-				hd->ScsiLookup[ii] =3D NULL;=0A=
-		}=0A=
+		for (ii=3D0; ii < hd->ioc->req_depth; ii++)=0A=
+			hd->ScsiLookup[ii] =3D NULL;=0A=
 =0A=
 		/* 2. Chain Buffer initialization=0A=
 		 */=0A=
@@ -2546,6 +2548,16 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/* work queue thread to clear the persitency table */=0A=
+static void=0A=
+mptscsih_sas_persist_clear_table(void * arg)=0A=
+{=0A=
+	MPT_ADAPTER *ioc =3D (MPT_ADAPTER *)arg;=0A=
+=0A=
+	mptbase_sas_persist_operation(ioc, MPI_SAS_OP_CLEAR_NOT_PRESENT);=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 int=0A=
 mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t =
*pEvReply)=0A=
 {=0A=
@@ -2555,18 +2567,18 @@=0A=
 	devtprintk((MYIOC_s_INFO_FMT "MPT event (=3D%02Xh) routed to SCSI =
host driver!\n",=0A=
 			ioc->name, event));=0A=
 =0A=
+	if (ioc->sh =3D=3D NULL ||=0A=
+		((hd =3D (MPT_SCSI_HOST *)ioc->sh->hostdata) =3D=3D NULL))=0A=
+		return 1;=0A=
+=0A=
 	switch (event) {=0A=
 	case MPI_EVENT_UNIT_ATTENTION:			/* 03 */=0A=
 		/* FIXME! */=0A=
 		break;=0A=
 	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */=0A=
 	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */=0A=
-		hd =3D NULL;=0A=
-		if (ioc->sh) {=0A=
-			hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
-			if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->soft_resets < -1))=0A=
-				hd->soft_resets++;=0A=
-		}=0A=
+		if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->soft_resets < -1))=0A=
+			hd->soft_resets++;=0A=
 		break;=0A=
 	case MPI_EVENT_LOGOUT:				/* 09 */=0A=
 		/* FIXME! */=0A=
@@ -2585,69 +2597,24 @@=0A=
 		break;=0A=
 =0A=
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */=0A=
+	{=0A=
+		pMpiEventDataRaid_t pRaidEventData =3D=0A=
+		    (pMpiEventDataRaid_t) pEvReply->Data;=0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
-		/* negoNvram set to 0 if DV enabled and to USE_NVRAM if=0A=
-		 * if DV disabled. Need to check for target mode.=0A=
-		 */=0A=
-		hd =3D NULL;=0A=
-		if (ioc->sh)=0A=
-			hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
-=0A=
-		if (hd && (ioc->bus_type =3D=3D SCSI) && (hd->negoNvram =3D=3D 0)) =
{=0A=
-			ScsiCfgData	*pSpi;=0A=
-			Ioc3PhysDisk_t	*pPDisk;=0A=
-			int		 numPDisk;=0A=
-			u8		 reason;=0A=
-			u8		 physDiskNum;=0A=
-=0A=
-			reason =3D (le32_to_cpu(pEvReply->Data[0]) & 0x00FF0000) >> 16;=0A=
-			if (reason =3D=3D MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {=0A=
-				/* New or replaced disk.=0A=
-				 * Set DV flag and schedule DV.=0A=
-				 */=0A=
-				pSpi =3D &ioc->spi_data;=0A=
-				physDiskNum =3D (le32_to_cpu(pEvReply->Data[0]) & 0xFF000000) >> =
24;=0A=
-				ddvtprintk(("DV requested for phys disk id %d\n", =
physDiskNum));=0A=
-				if (pSpi->pIocPg3) {=0A=
-					pPDisk =3D  pSpi->pIocPg3->PhysDisk;=0A=
-					numPDisk =3DpSpi->pIocPg3->NumPhysDisks;=0A=
-=0A=
-					while (numPDisk) {=0A=
-						if (physDiskNum =3D=3D pPDisk->PhysDiskNum) {=0A=
-							pSpi->dvStatus[pPDisk->PhysDiskID] =3D (MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_DV_NOT_DONE);=0A=
-							pSpi->forceDv =3D MPT_SCSICFG_NEED_DV;=0A=
-							ddvtprintk(("NEED_DV set for phys disk id %d\n", =
pPDisk->PhysDiskID));=0A=
-							break;=0A=
-						}=0A=
-						pPDisk++;=0A=
-						numPDisk--;=0A=
-					}=0A=
-=0A=
-					if (numPDisk =3D=3D 0) {=0A=
-						/* The physical disk that needs DV was not found=0A=
-						 * in the stored IOC Page 3. The driver must reload=0A=
-						 * this page. DV routine will set the NEED_DV flag for=0A=
-						 * all phys disks that have DV_NOT_DONE set.=0A=
-						 */=0A=
-						pSpi->forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
-						ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 =
Flag\n", physDiskNum));=0A=
-					}=0A=
-				}=0A=
-			}=0A=
-		}=0A=
+		/* Domain Validation Needed */=0A=
+		if (ioc->bus_type =3D=3D SCSI &&=0A=
+		    pRaidEventData->ReasonCode =3D=3D=0A=
+		    MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED)=0A=
+			mptscsih_set_dvflags_raid(hd, pRaidEventData->PhysDiskNum);=0A=
 #endif=0A=
+		break;=0A=
+	}=0A=
 =0A=
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)=0A=
-		printk("Raid Event RF: ");=0A=
-		{=0A=
-			u32 *m =3D (u32 *)pEvReply;=0A=
-			int ii;=0A=
-			int n =3D (int)pEvReply->MsgLength;=0A=
-			for (ii=3D6; ii < n; ii++)=0A=
-				printk(" %08x", le32_to_cpu(m[ii]));=0A=
-			printk("\n");=0A=
-		}=0A=
-#endif=0A=
+	/* Persistent table is full. */=0A=
+	case MPI_EVENT_PERSISTENT_TABLE_FULL:=0A=
+		INIT_WORK(&mptscsih_persistTask,=0A=
+		    mptscsih_sas_persist_clear_table,(void *)ioc);=0A=
+		schedule_work(&mptscsih_persistTask);=0A=
 		break;=0A=
 =0A=
 	case MPI_EVENT_NONE:				/* 00 */=0A=
@@ -2684,7 +2651,7 @@=0A=
 {=0A=
 	int		indexed_lun, lun_index;=0A=
 	VirtDevice	*vdev;=0A=
-	ScsiCfgData	*pSpi;=0A=
+	SpiCfgData	*pSpi;=0A=
 	char		data_56;=0A=
 =0A=
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=3D%d id=3D%d lun=3D%d =
hd=3D%p\n",=0A=
@@ -2791,7 +2758,7 @@=0A=
 static void=0A=
 mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, =
char byte56)=0A=
 {=0A=
-	ScsiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
+	SpiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
 	int  id =3D (int) target->target_id;=0A=
 	int  nvram;=0A=
 	VirtDevice	*vdev;=0A=
@@ -2970,11 +2937,13 @@=0A=
 static void=0A=
 mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)=0A=
 {=0A=
+	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
 	u8 cmd;=0A=
-	ScsiCfgData *pSpi;=0A=
+	SpiCfgData	*pSpi;=0A=
 =0A=
-	ddvtprintk((" set_dvflags: id=3D%d lun=3D%d negoNvram=3D%x =
cmd=3D%x\n", =0A=
-		pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));=0A=
+	ddvtprintk((MYIOC_s_NOTE_FMT=0A=
+		" set_dvflags: id=3D%d lun=3D%d negoNvram=3D%x cmd=3D%x\n",=0A=
+		hd->ioc->name, pReq->TargetID, pReq->LUN[1], hd->negoNvram, =
pReq->CDB[0]));=0A=
 =0A=
 	if ((pReq->LUN[1] !=3D 0) || (hd->negoNvram !=3D 0))=0A=
 		return;=0A=
@@ -2982,12 +2951,12 @@=0A=
 	cmd =3D pReq->CDB[0];=0A=
 =0A=
 	if ((cmd =3D=3D READ_CAPACITY) || (cmd =3D=3D MODE_SENSE)) {=0A=
-		pSpi =3D &hd->ioc->spi_data;=0A=
-		if ((pSpi->isRaid & (1 << pReq->TargetID)) && pSpi->pIocPg3) {=0A=
+		pSpi =3D &ioc->spi_data;=0A=
+		if ((ioc->raid_data.isRaid & (1 << pReq->TargetID)) && =
ioc->raid_data.pIocPg3) {=0A=
 			/* Set NEED_DV for all hidden disks=0A=
 			 */=0A=
-			Ioc3PhysDisk_t *pPDisk =3D  pSpi->pIocPg3->PhysDisk;=0A=
-			int		numPDisk =3D pSpi->pIocPg3->NumPhysDisks;=0A=
+			Ioc3PhysDisk_t *pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
+			int		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
 =0A=
 			while (numPDisk) {=0A=
 				pSpi->dvStatus[pPDisk->PhysDiskID] |=3D MPT_SCSICFG_NEED_DV;=0A=
@@ -3001,6 +2970,50 @@=0A=
 	}=0A=
 }=0A=
 =0A=
+/* mptscsih_raid_set_dv_flags()=0A=
+ *=0A=
+ * New or replaced disk. Set DV flag and schedule DV.=0A=
+ */=0A=
+static void=0A=
+mptscsih_set_dvflags_raid(MPT_SCSI_HOST *hd, int id)=0A=
+{=0A=
+	MPT_ADAPTER	*ioc =3D hd->ioc;=0A=
+	SpiCfgData	*pSpi =3D &ioc->spi_data;=0A=
+	Ioc3PhysDisk_t	*pPDisk;=0A=
+	int		 numPDisk;=0A=
+=0A=
+	if (hd->negoNvram !=3D 0)=0A=
+		return;=0A=
+=0A=
+	ddvtprintk(("DV requested for phys disk id %d\n", id));=0A=
+	if (ioc->raid_data.pIocPg3) {=0A=
+		pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
+		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
+		while (numPDisk) {=0A=
+			if (id =3D=3D pPDisk->PhysDiskNum) {=0A=
+				pSpi->dvStatus[pPDisk->PhysDiskID] =3D=0A=
+				    (MPT_SCSICFG_NEED_DV | MPT_SCSICFG_DV_NOT_DONE);=0A=
+				pSpi->forceDv =3D MPT_SCSICFG_NEED_DV;=0A=
+				ddvtprintk(("NEED_DV set for phys disk id %d\n",=0A=
+				    pPDisk->PhysDiskID));=0A=
+				break;=0A=
+			}=0A=
+			pPDisk++;=0A=
+			numPDisk--;=0A=
+		}=0A=
+=0A=
+		if (numPDisk =3D=3D 0) {=0A=
+			/* The physical disk that needs DV was not found=0A=
+			 * in the stored IOC Page 3. The driver must reload=0A=
+			 * this page. DV routine will set the NEED_DV flag for=0A=
+			 * all phys disks that have DV_NOT_DONE set.=0A=
+			 */=0A=
+			pSpi->forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
+			ddvtprintk(("phys disk %d not found. Setting reload IOC Pg3 =
Flag\n",id));=0A=
+		}=0A=
+	}=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  * If no Target, bus reset on 1st I/O. Set the flag to=0A=
@@ -3088,7 +3101,7 @@=0A=
 	MPT_ADAPTER		*ioc =3D hd->ioc;=0A=
 	Config_t		*pReq;=0A=
 	SCSIDevicePage1_t	*pData;=0A=
-	VirtDevice		*pTarget;=0A=
+	VirtDevice		*pTarget=3DNULL;=0A=
 	MPT_FRAME_HDR		*mf;=0A=
 	dma_addr_t		 dataDma;=0A=
 	u16			 req_idx;=0A=
@@ -3187,7 +3200,7 @@=0A=
 #endif=0A=
 =0A=
 		if (flags & MPT_SCSICFG_BLK_NEGO)=0A=
-			negoFlags =3D MPT_TARGET_NO_NEGO_WIDE | MPT_TARGET_NO_NEGO_SYNC;=0A=
+			negoFlags |=3D MPT_TARGET_NO_NEGO_WIDE | =
MPT_TARGET_NO_NEGO_SYNC;=0A=
 =0A=
 		mptscsih_setDevicePage1Flags(width, factor, offset,=0A=
 					&requested, &configuration, negoFlags);=0A=
@@ -4008,7 +4021,7 @@=0A=
 =0A=
 		/* If target Ptr NULL or if this target is NOT a disk, skip.=0A=
 		 */=0A=
-		if ((pTarget) && (pTarget->tflags & MPT_TARGET_FLAGS_Q_YES)){=0A=
+		if ((pTarget) && (pTarget->inq_data[0] =3D=3D TYPE_DISK)){=0A=
 			for (lun=3D0; lun <=3D MPT_LAST_LUN; lun++) {=0A=
 				/* If LUN present, issue the command=0A=
 				 */=0A=
@@ -4103,9 +4116,9 @@=0A=
 =0A=
 			if ((ioc->spi_data.forceDv & MPT_SCSICFG_RELOAD_IOC_PG3) !=3D 0) =
{=0A=
 				mpt_read_ioc_pg_3(ioc);=0A=
-				if (ioc->spi_data.pIocPg3) {=0A=
-					Ioc3PhysDisk_t *pPDisk =3D ioc->spi_data.pIocPg3->PhysDisk;=0A=
-					int		numPDisk =3D ioc->spi_data.pIocPg3->NumPhysDisks;=0A=
+				if (ioc->raid_data.pIocPg3) {=0A=
+					Ioc3PhysDisk_t *pPDisk =3D ioc->raid_data.pIocPg3->PhysDisk;=0A=
+					int		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
 =0A=
 					while (numPDisk) {=0A=
 						if (ioc->spi_data.dvStatus[pPDisk->PhysDiskID] & =
MPT_SCSICFG_DV_NOT_DONE)=0A=
@@ -4144,7 +4157,7 @@=0A=
 					isPhysDisk =3D mptscsih_is_phys_disk(ioc, id);=0A=
 					if (isPhysDisk) {=0A=
 						for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
-							if (hd->ioc->spi_data.isRaid & (1 << ii)) {=0A=
+							if (hd->ioc->raid_data.isRaid & (1 << ii)) {=0A=
 								hd->ioc->spi_data.dvStatus[ii] |=3D MPT_SCSICFG_DV_PENDING;=0A=
 							}=0A=
 						}=0A=
@@ -4163,7 +4176,7 @@=0A=
 =0A=
 					if (isPhysDisk) {=0A=
 						for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
-							if (hd->ioc->spi_data.isRaid & (1 << ii)) {=0A=
+							if (hd->ioc->raid_data.isRaid & (1 << ii)) {=0A=
 								hd->ioc->spi_data.dvStatus[ii] &=3D =
~MPT_SCSICFG_DV_PENDING;=0A=
 							}=0A=
 						}=0A=
@@ -4185,21 +4198,21 @@=0A=
 =0A=
 /* Search IOC page 3 to determine if this is hidden physical disk=0A=
  */=0A=
-static int =0A=
+/* Search IOC page 3 to determine if this is hidden physical disk=0A=
+ */=0A=
+static int=0A=
 mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)=0A=
 {=0A=
-	if (ioc->spi_data.pIocPg3) {=0A=
-		Ioc3PhysDisk_t *pPDisk =3D  ioc->spi_data.pIocPg3->PhysDisk;=0A=
-		int		numPDisk =3D ioc->spi_data.pIocPg3->NumPhysDisks;=0A=
+	int i;=0A=
 =0A=
-		while (numPDisk) {=0A=
-			if (pPDisk->PhysDiskID =3D=3D id) {=0A=
-				return 1;=0A=
-			}=0A=
-			pPDisk++;=0A=
-			numPDisk--;=0A=
-		}=0A=
+	if (!ioc->raid_data.isRaid || !ioc->raid_data.pIocPg3)=0A=
+		return 0;=0A=
+=0A=
+	for (i =3D 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {=0A=
+		if (id =3D=3D ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID)=0A=
+			return 1;=0A=
 	}=0A=
+=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -4405,7 +4418,7 @@=0A=
 	/* Skip this ID? Set cfg.cfghdr.hdr to force config page write=0A=
 	 */=0A=
 	{=0A=
-		ScsiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
+		SpiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
 		if (pspi_data->nvram && (pspi_data->nvram[id] !=3D =
MPT_HOST_NVRAM_INVALID)) {=0A=
 			/* Set the factor from nvram */=0A=
 			nfactor =3D (pspi_data->nvram[id] & MPT_NVRAM_SYNC_MASK) >> 8;=0A=
@@ -4435,11 +4448,11 @@=0A=
 	}=0A=
 =0A=
 	/* Finish iocmd inititialization - hidden or visible disk? */=0A=
-	if (ioc->spi_data.pIocPg3) {=0A=
+	if (ioc->raid_data.pIocPg3) {=0A=
 		/* Search IOC page 3 for matching id=0A=
 		 */=0A=
-		Ioc3PhysDisk_t *pPDisk =3D  ioc->spi_data.pIocPg3->PhysDisk;=0A=
-		int		numPDisk =3D ioc->spi_data.pIocPg3->NumPhysDisks;=0A=
+		Ioc3PhysDisk_t *pPDisk =3D  ioc->raid_data.pIocPg3->PhysDisk;=0A=
+		int		numPDisk =3D ioc->raid_data.pIocPg3->NumPhysDisks;=0A=
 =0A=
 		while (numPDisk) {=0A=
 			if (pPDisk->PhysDiskID =3D=3D id) {=0A=
@@ -4463,7 +4476,7 @@=0A=
 	/* RAID Volume ID's may double for a physical device. If RAID but=0A=
 	 * not a physical ID as well, skip DV.=0A=
 	 */=0A=
-	if ((hd->ioc->spi_data.isRaid & (1 << id)) && !(iocmd.flags & =
MPT_ICFLAG_PHYS_DISK))=0A=
+	if ((hd->ioc->raid_data.isRaid & (1 << id)) && !(iocmd.flags & =
MPT_ICFLAG_PHYS_DISK))=0A=
 		goto target_done;=0A=
 =0A=
 =0A=
@@ -4812,6 +4825,8 @@=0A=
 					notDone =3D 0;=0A=
 					if (iocmd.flags & MPT_ICFLAG_ECHO) {=0A=
 						bufsize =3D  ((pbuf1[2] & 0x1F) <<8) | pbuf1[3];=0A=
+						if (pbuf1[0] & 0x01)=0A=
+							iocmd.flags |=3D MPT_ICFLAG_EBOS;=0A=
 					} else {=0A=
 						bufsize =3D  pbuf1[1]<<16 | pbuf1[2]<<8 | pbuf1[3];=0A=
 					}=0A=
@@ -4908,6 +4923,9 @@=0A=
 		}=0A=
 		iocmd.flags &=3D ~MPT_ICFLAG_DID_RESET;=0A=
 =0A=
+		if (iocmd.flags & MPT_ICFLAG_EBOS)=0A=
+			goto skip_Reserve;=0A=
+=0A=
 		repeat =3D 5;=0A=
 		while (repeat && (!(iocmd.flags & MPT_ICFLAG_RESERVED))) {=0A=
 			iocmd.cmd =3D RESERVE;=0A=
@@ -4951,6 +4969,7 @@=0A=
 			}=0A=
 		}=0A=
 =0A=
+skip_Reserve:=0A=
 		mptscsih_fillbuf(pbuf1, sz, patt, 1);=0A=
 		iocmd.cmd =3D WRITE_BUFFER;=0A=
 		iocmd.data_dma =3D buf1_dma;=0A=
@@ -5195,11 +5214,12 @@=0A=
 		 * If not an LVD bus, the adapter minSyncFactor has been=0A=
 		 * already throttled back.=0A=
 		 */=0A=
+		negoFlags =3D hd->ioc->spi_data.noQas;=0A=
 		if ((hd->Targets)&&((pTarget =3D hd->Targets[(int)id]) !=3D NULL) && =
!pTarget->raidVolume) {=0A=
 			width =3D pTarget->maxWidth;=0A=
 			offset =3D pTarget->maxOffset;=0A=
 			factor =3D pTarget->minSyncFactor;=0A=
-			negoFlags =3D pTarget->negoFlags;=0A=
+			negoFlags |=3D pTarget->negoFlags;=0A=
 		} else {=0A=
 			if (hd->ioc->spi_data.nvram && (hd->ioc->spi_data.nvram[id] !=3D =
MPT_HOST_NVRAM_INVALID)) {=0A=
 				data =3D hd->ioc->spi_data.nvram[id];=0A=
@@ -5220,7 +5240,6 @@=0A=
 			}=0A=
 =0A=
 			/* Set the negotiation flags */=0A=
-			negoFlags =3D hd->ioc->spi_data.noQas;=0A=
 			if (!width)=0A=
 				negoFlags |=3D MPT_TARGET_NO_NEGO_WIDE;=0A=
 =0A=
diff -uarN b/drivers/message/fusion/mptscsih.h =
a/drivers/message/fusion/mptscsih.h=0A=
--- b/drivers/message/fusion/mptscsih.h	2005-08-28 17:41:01.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.h	2005-09-14 17:15:30.000000000 =
-0600=0A=
@@ -1,5 +1,5 @@=0A=
 /*=0A=
- *  linux/drivers/message/fusion/mptscsi.h=0A=
+ *  linux/drivers/message/fusion/mptscsih.h=0A=
  *      High performance SCSI / Fibre Channel SCSI Host device =
driver.=0A=
  *      For use with PCI chip/adapter(s):=0A=
  *          LSIFC9xx/LSI409xx Fibre Channel=0A=
@@ -53,8 +53,8 @@=0A=
  *	SCSI Public stuff...=0A=
  */=0A=
 =0A=
-#define MPT_SCSI_CMD_PER_DEV_HIGH	31=0A=
-#define MPT_SCSI_CMD_PER_DEV_LOW	7=0A=
+#define MPT_SCSI_CMD_PER_DEV_HIGH	64=0A=
+#define MPT_SCSI_CMD_PER_DEV_LOW	32=0A=
 =0A=
 #define MPT_SCSI_CMD_PER_LUN		7=0A=
 =0A=
@@ -77,6 +77,7 @@=0A=
 #define MPTSCSIH_MAX_WIDTH              1=0A=
 #define MPTSCSIH_MIN_SYNC               0x08=0A=
 #define MPTSCSIH_SAF_TE                 0=0A=
+#define MPTSCSIH_PT_CLEAR               0=0A=
 =0A=
 =0A=
 #endif=0A=
@@ -105,3 +106,4 @@=0A=
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int =
qdepth);=0A=
 extern void mptscsih_timer_expired(unsigned long data);=0A=
+extern void scsi_print_command(struct scsi_cmnd *cmd);=0A=
diff -uarN b/drivers/message/fusion/mptspi.c =
a/drivers/message/fusion/mptspi.c=0A=
--- b/drivers/message/fusion/mptspi.c	2005-09-14 12:15:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptspi.c	2005-09-14 17:13:59.000000000 =
-0600=0A=
@@ -199,7 +199,7 @@=0A=
 		printk(MYIOC_s_WARN_FMT=0A=
 			"Skipping ioc=3D%p because SCSI Initiator mode is NOT =
enabled!\n",=0A=
 			ioc->name, ioc);=0A=
-		return -ENODEV;=0A=
+		return 0;=0A=
 	}=0A=
 =0A=
 	sh =3D scsi_host_alloc(&mptspi_driver_template, =
sizeof(MPT_SCSI_HOST));=0A=

------_=_NextPart_000_01C5B989.B25BA498--
