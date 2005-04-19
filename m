From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 5/7] mptfusion: mptscsih Split driver support
Date: Tue, 19 Apr 2005 15:11:52 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C020C3D4F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54524.68B63D00"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9719 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261682AbVDSVL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:11:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54524.68B63D00
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 5/7:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.00/

Changelog:

(1) mptscsih.c: Remove credits, -sralston references , update copyright 
(2) mptscsih.c: split driver support
(3) mptscsih.c: module_init, module_exit, and probe routines moved to new 
stub drivers, mptfc and mptspi
(4) mptscsih.c: some global parameters are moved to MPT_SCSI_HOST
(5) mptscsih.c: removed scsi_device_online check.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



 


------_=_NextPart_000_01C54524.68B63D00
Content-Type: application/octet-stream;
	name="patch-5-mptscsih"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-5-mptscsih"

--- b/drivers/message/fusion/mptscsih.c	2005-04-19 08:38:57.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-04-19 14:14:02.000000000 =
-0600=0A=
@@ -1,32 +1,11 @@=0A=
 /*=0A=
  *  linux/drivers/message/fusion/mptscsih.c=0A=
- *      High performance SCSI / Fibre Channel SCSI Host device =
driver.=0A=
- *      For use with PCI chip/adapter(s):=0A=
- *          LSIFC9xx/LSI409xx Fibre Channel=0A=
+ *      For use with LSI Logic PCI chip/adapter(s)=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A special thanks to Pamela Delaney (LSI Logic) for tons of =
work=0A=
- *      and countless enhancements while adding support for the =
1030=0A=
- *      chip family.  Pam has been instrumental in the development =
of=0A=
- *      of the 2.xx.xx series fusion drivers, and her contributions =
are=0A=
- *      far too numerous to hope to list in one place.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      (see mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Original author: Steven J. Ralston=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptscsih.c,v 1.104 2002/12/03 21:26:34 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -96,27 +75,6 @@=0A=
 MODULE_DESCRIPTION(my_NAME);=0A=
 MODULE_LICENSE("GPL");=0A=
 =0A=
-/* Command line args */=0A=
-static int mpt_dv =3D MPTSCSIH_DOMAIN_VALIDATION;=0A=
-MODULE_PARM(mpt_dv, "i");=0A=
-MODULE_PARM_DESC(mpt_dv, " DV Algorithm: enhanced=3D1, basic=3D0 =
(default=3DMPTSCSIH_DOMAIN_VALIDATION=3D1)");=0A=
-=0A=
-static int mpt_width =3D MPTSCSIH_MAX_WIDTH;=0A=
-MODULE_PARM(mpt_width, "i");=0A=
-MODULE_PARM_DESC(mpt_width, " Max Bus Width: wide=3D1, narrow=3D0 =
(default=3DMPTSCSIH_MAX_WIDTH=3D1)");=0A=
-=0A=
-static int mpt_factor =3D MPTSCSIH_MIN_SYNC;=0A=
-MODULE_PARM(mpt_factor, "h");=0A=
-MODULE_PARM_DESC(mpt_factor, " Min Sync Factor =
(default=3DMPTSCSIH_MIN_SYNC=3D0x08)");=0A=
-=0A=
-static int mpt_saf_te =3D MPTSCSIH_SAF_TE;=0A=
-MODULE_PARM(mpt_saf_te, "i");=0A=
-MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: =
enable=3D1  (default=3DMPTSCSIH_SAF_TE=3D0)");=0A=
-=0A=
-static int mpt_pq_filter =3D 0;=0A=
-MODULE_PARM(mpt_pq_filter, "i");=0A=
-MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral qualifier filter: =
enable=3D1  (default=3D0)");=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
 typedef struct _BIG_SENSE_BUF {=0A=
@@ -169,18 +127,17 @@=0A=
 	u16		 pad1;=0A=
 } DVPARAMETERS;=0A=
 =0A=
-=0A=
 /*=0A=
  *  Other private/forward protos...=0A=
  */=0A=
-static int	mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
+int		mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
 static void	mptscsih_report_queue_full(struct scsi_cmnd *sc, =
SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);=0A=
-static int	mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);=0A=
+int		mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
 =0A=
 static int	mptscsih_AddSGE(MPT_ADAPTER *ioc, struct scsi_cmnd =
*SCpnt,=0A=
 				 SCSIIORequest_t *pReq, int req_idx);=0A=
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int =
req_idx);=0A=
-static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, =
MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);=0A=
+static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, =
MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);=0A=
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);=0A=
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong =
timeout );=0A=
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);=0A=
@@ -188,8 +145,8 @@=0A=
 static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, =
u8 target, u8 lun, int ctx2abort, ulong timeout);=0A=
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 =
channel, u8 target, u8 lun, int ctx2abort, ulong timeout);=0A=
 =0A=
-static int	mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
-static int	mptscsih_event_process(MPT_ADAPTER *ioc, =
EventNotificationReply_t *pEvReply);=0A=
+int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
+int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t =
*pEvReply);=0A=
 =0A=
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int =
target_id, u8 lun, char *data, int dlen);=0A=
 static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56);=0A=
@@ -198,8 +155,7 @@=0A=
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int =
target_id);=0A=
 static int	mptscsih_writeSDP1(MPT_SCSI_HOST *hd, int portnum, int =
target, int flags);=0A=
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, =
int bus);=0A=
-static int	mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);=0A=
-static void	mptscsih_timer_expired(unsigned long data);=0A=
+int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);=0A=
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int =
portnum);=0A=
 =0A=
@@ -212,29 +168,14 @@=0A=
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void =
*pPage);=0A=
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int =
width);=0A=
 #endif=0A=
-/* module entry point */=0A=
-static int  __init   mptscsih_init  (void);=0A=
-static void __exit   mptscsih_exit  (void);=0A=
-=0A=
-static int  mptscsih_probe (struct pci_dev *, const struct =
pci_device_id *);=0A=
-static void mptscsih_remove(struct pci_dev *);=0A=
-static void mptscsih_shutdown(struct device *);=0A=
+=0A=
+void 		mptscsih_remove(struct pci_dev *);=0A=
+void 		mptscsih_shutdown(struct device *);=0A=
 #ifdef CONFIG_PM=0A=
-static int mptscsih_suspend(struct pci_dev *pdev, pm_message_t =
state);=0A=
-static int mptscsih_resume(struct pci_dev *pdev);=0A=
+int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);=0A=
+int 		mptscsih_resume(struct pci_dev *pdev);=0A=
 #endif=0A=
 =0A=
-=0A=
-/*=0A=
- *	Private data...=0A=
- */=0A=
-=0A=
-static int	mpt_scsi_hosts =3D 0;=0A=
-=0A=
-static int	ScsiDoneCtx =3D -1;=0A=
-static int	ScsiTaskCtx =3D -1;=0A=
-static int	ScsiScanDvCtx =3D -1; /* Used only for bus scan and dv =
*/=0A=
-=0A=
 #define SNS_LEN(scp)	sizeof((scp)->sense_buffer)=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
@@ -244,20 +185,9 @@=0A=
 static DEFINE_SPINLOCK(dvtaskQ_lock);=0A=
 static int dvtaskQ_active =3D 0;=0A=
 static int dvtaskQ_release =3D 0;=0A=
-static struct work_struct	mptscsih_dvTask;=0A=
+static struct work_struct	dvTaskQ_task;=0A=
 #endif=0A=
 =0A=
-/*=0A=
- * Wait Queue setup=0A=
- */=0A=
-static DECLARE_WAIT_QUEUE_HEAD (scandv_waitq);=0A=
-static int scandv_wait_done =3D 1;=0A=
-=0A=
-=0A=
-/* Driver command line structure=0A=
- */=0A=
-static struct scsi_host_template driver_template;=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mptscsih_add_sge - Place a simple SGE at address pAddr.=0A=
@@ -619,7 +549,7 @@=0A=
  *=0A=
  *	Returns 1 indicating alloc'd request frame ptr should be freed.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR =
*mr)=0A=
 {=0A=
 	struct scsi_cmnd	*sc;=0A=
@@ -677,8 +607,8 @@=0A=
 			sc->request_bufflen, xfer_cnt));=0A=
 =0A=
 		if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)=0A=
-			copy_sense_data(sc, hd, mf, pScsiReply);=0A=
-                =0A=
+			mptscsih_copy_sense_data(sc, hd, mf, pScsiReply);=0A=
+=0A=
 		/*=0A=
 		 *  Look for + dump FCP ResponseInfo[]!=0A=
 		 */=0A=
@@ -740,7 +670,7 @@=0A=
 			}=0A=
 			dreplyprintk((KERN_NOTICE "RESIDUAL_MISMATCH: result=3D%x on =
id=3D%d\n", sc->result, sc->target));=0A=
 			break;=0A=
-		=0A=
+=0A=
 		case MPI_IOCSTATUS_SCSI_DATA_UNDERRUN:		/* 0x0045 */=0A=
 			/*=0A=
 			 *  Do upfront check for valid SenseData and give it=0A=
@@ -773,7 +703,7 @@=0A=
 			 */=0A=
 			if (scsi_status =3D=3D MPI_SCSI_STATUS_TASK_SET_FULL)=0A=
 				mptscsih_report_queue_full(sc, pScsiReply, pScsiReq);=0A=
-			=0A=
+=0A=
 			break;=0A=
 =0A=
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */=0A=
@@ -905,18 +835,16 @@=0A=
 			 * Do OS callback=0A=
 			 * Free driver resources (chain, msg buffers)=0A=
 			 */=0A=
-			if (scsi_device_online(SCpnt->device)) {=0A=
-				if (SCpnt->use_sg) {=0A=
-					pci_unmap_sg(ioc->pcidev,=0A=
-						(struct scatterlist *) SCpnt->request_buffer,=0A=
-						SCpnt->use_sg,=0A=
-						SCpnt->sc_data_direction);=0A=
-				} else if (SCpnt->request_bufflen) {=0A=
-					pci_unmap_single(ioc->pcidev,=0A=
-						SCpnt->SCp.dma_handle,=0A=
-						SCpnt->request_bufflen,=0A=
-						SCpnt->sc_data_direction);=0A=
-				}=0A=
+			if (SCpnt->use_sg) {=0A=
+				pci_unmap_sg(ioc->pcidev,=0A=
+					(struct scatterlist *) SCpnt->request_buffer,=0A=
+					SCpnt->use_sg,=0A=
+					SCpnt->sc_data_direction);=0A=
+			} else if (SCpnt->request_bufflen) {=0A=
+				pci_unmap_single(ioc->pcidev,=0A=
+					SCpnt->SCp.dma_handle,=0A=
+					SCpnt->request_bufflen,=0A=
+					SCpnt->sc_data_direction);=0A=
 			}=0A=
 			SCpnt->result =3D DID_RESET << 16;=0A=
 			SCpnt->host_scribble =3D NULL;=0A=
@@ -981,11 +909,6 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
- *  Hack! It might be nice to report if a device is returning =
QUEUE_FULL=0A=
- *  but maybe not each and every time...=0A=
- */=0A=
-static long last_queue_full =3D 0;=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -1003,280 +926,20 @@=0A=
 mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t =
*pScsiReply, SCSIIORequest_t *pScsiReq)=0A=
 {=0A=
 	long time =3D jiffies;=0A=
-=0A=
-	if (time - last_queue_full > 10 * HZ) {=0A=
-		char *ioc_str =3D "ioc?";=0A=
-=0A=
-		if (sc->device && sc->device->host !=3D NULL && =
sc->device->host->hostdata !=3D NULL)=0A=
-			ioc_str =3D ((MPT_SCSI_HOST =
*)sc->device->host->hostdata)->ioc->name;=0A=
-		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported =
QUEUE_FULL!\n",=0A=
-				ioc_str, 0, sc->device->id, sc->device->lun));=0A=
-		last_queue_full =3D time;=0A=
-	}=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static char *info_kbuf =3D NULL;=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=0A=
- *	mptscsih_probe - Installs scsi devices per bus.=0A=
- *	@pdev: Pointer to pci_dev structure=0A=
- *=0A=
- *	Returns 0 for success, non-zero for failure.=0A=
- *=0A=
- */=0A=
-=0A=
-static int=0A=
-mptscsih_probe(struct pci_dev *pdev, const struct pci_device_id =
*id)=0A=
-{=0A=
-	struct Scsi_Host	*sh;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
-	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
-	unsigned long		 flags;=0A=
-	int			 sz, ii;=0A=
-	int			 numSGE =3D 0;=0A=
-	int			 scale;=0A=
-	int			 ioc_cap;=0A=
-	u8			*mem;=0A=
-	int			error=3D0;=0A=
-=0A=
-=0A=
-	/* 20010202 -sralston=0A=
-	 *  Added sanity check on readiness of the MPT adapter.=0A=
-	 */=0A=
-	if (ioc->last_state !=3D MPI_IOC_STATE_OPERATIONAL) {=0A=
-		printk(MYIOC_s_WARN_FMT=0A=
-		  "Skipping because it's not operational!\n",=0A=
-		  ioc->name);=0A=
-		return -ENODEV;=0A=
-	}=0A=
-=0A=
-	if (!ioc->active) {=0A=
-		printk(MYIOC_s_WARN_FMT "Skipping because it's disabled!\n",=0A=
-		  ioc->name);=0A=
-		return -ENODEV;=0A=
-	}=0A=
-=0A=
-	/*  Sanity check - ensure at least 1 port is INITIATOR capable=0A=
-	 */=0A=
-	ioc_cap =3D 0;=0A=
-	for (ii=3D0; ii < ioc->facts.NumberOfPorts; ii++) {=0A=
-		if (ioc->pfacts[ii].ProtocolFlags &=0A=
-		    MPI_PORTFACTS_PROTOCOL_INITIATOR)=0A=
-			ioc_cap ++;=0A=
-	}=0A=
-=0A=
-	if (!ioc_cap) {=0A=
-		printk(MYIOC_s_WARN_FMT=0A=
-			"Skipping ioc=3D%p because SCSI Initiator mode is NOT =
enabled!\n",=0A=
-			ioc->name, ioc);=0A=
-		return -ENODEV;=0A=
-	}=0A=
-=0A=
-	sh =3D scsi_host_alloc(&driver_template, sizeof(MPT_SCSI_HOST));=0A=
-        =0A=
-	if (!sh) {=0A=
-		printk(MYIOC_s_WARN_FMT=0A=
-			"Unable to register controller with SCSI subsystem\n",=0A=
-			ioc->name);=0A=
-                return -1;=0A=
-        }=0A=
-	=0A=
-	spin_lock_irqsave(&ioc->FreeQlock, flags);=0A=
-=0A=
-	/* Attach the SCSI Host to the IOC structure=0A=
-	 */=0A=
-	ioc->sh =3D sh;=0A=
-=0A=
-	sh->io_port =3D 0;=0A=
-	sh->n_io_port =3D 0;=0A=
-	sh->irq =3D 0;=0A=
-=0A=
-	/* set 16 byte cdb's */=0A=
-	sh->max_cmd_len =3D 16;=0A=
-=0A=
-	/* Yikes!  This is important!=0A=
-	 * Otherwise, by default, linux=0A=
-	 * only scans target IDs 0-7!=0A=
-	 * pfactsN->MaxDevices unreliable=0A=
-	 * (not supported in early=0A=
-	 *	versions of the FW).=0A=
-	 * max_id =3D 1 + actual max id,=0A=
-	 * max_lun =3D 1 + actual last lun,=0A=
-	 *	see hosts.h :o(=0A=
-	 */=0A=
-	if (ioc->bus_type =3D=3D SCSI) {=0A=
-		sh->max_id =3D MPT_MAX_SCSI_DEVICES;=0A=
-	} else {=0A=
-	/* For FC, increase the queue depth=0A=
-	 * from MPT_SCSI_CAN_QUEUE (31)=0A=
-	 * to MPT_FC_CAN_QUEUE (63).=0A=
-	 */=0A=
-		sh->can_queue =3D MPT_FC_CAN_QUEUE;=0A=
-		sh->max_id =3D=0A=
-		  MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;=0A=
-	}=0A=
-		=0A=
-	sh->max_lun =3D MPT_LAST_LUN + 1;=0A=
-	sh->max_channel =3D 0;=0A=
-	sh->this_id =3D ioc->pfacts[0].PortSCSIID;=0A=
-		=0A=
-	/* Required entry.=0A=
-	 */=0A=
-	sh->unique_id =3D ioc->id;=0A=
-=0A=
-	/* Verify that we won't exceed the maximum=0A=
-	 * number of chain buffers=0A=
-	 * We can optimize:  ZZ =3D req_sz/sizeof(SGE)=0A=
-	 * For 32bit SGE's:=0A=
-	 *  numSGE =3D 1 + (ZZ-1)*(maxChain -1) + ZZ=0A=
-	 *               + (req_sz - 64)/sizeof(SGE)=0A=
-	 * A slightly different algorithm is required for=0A=
-	 * 64bit SGEs.=0A=
-	 */=0A=
-	scale =3D ioc->req_sz/(sizeof(dma_addr_t) + sizeof(u32));=0A=
-	if (sizeof(dma_addr_t) =3D=3D sizeof(u64)) {=0A=
-		numSGE =3D (scale - 1) *=0A=
-		  (ioc->facts.MaxChainDepth-1) + scale +=0A=
-		  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +=0A=
-		  sizeof(u32));=0A=
-	} else {=0A=
-		numSGE =3D 1 + (scale - 1) *=0A=
-		  (ioc->facts.MaxChainDepth-1) + scale +=0A=
-		  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +=0A=
-		  sizeof(u32));=0A=
-	}=0A=
-		=0A=
-	if (numSGE < sh->sg_tablesize) {=0A=
-		/* Reset this value */=0A=
-		dprintk((MYIOC_s_INFO_FMT=0A=
-		  "Resetting sg_tablesize to %d from %d\n",=0A=
-		  ioc->name, numSGE, sh->sg_tablesize));=0A=
-		sh->sg_tablesize =3D numSGE;=0A=
-	}=0A=
-=0A=
-	/* Set the pci device pointer in Scsi_Host structure.=0A=
-	 */=0A=
-	scsi_set_device(sh, &ioc->pcidev->dev);=0A=
-=0A=
-	spin_unlock_irqrestore(&ioc->FreeQlock, flags);=0A=
-=0A=
-	hd =3D (MPT_SCSI_HOST *) sh->hostdata;=0A=
-	hd->ioc =3D ioc;=0A=
-=0A=
-	/* SCSI needs scsi_cmnd lookup table!=0A=
-	 * (with size equal to req_depth*PtrSz!)=0A=
-	 */=0A=
-	sz =3D ioc->req_depth * sizeof(void *);=0A=
-	mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-	if (mem =3D=3D NULL) {=0A=
-		error =3D -ENOMEM;=0A=
-		goto mptscsih_probe_failed;=0A=
-	}=0A=
-=0A=
-	memset(mem, 0, sz);=0A=
-	hd->ScsiLookup =3D (struct scsi_cmnd **) mem;=0A=
 =0A=
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=3D%d\n",=0A=
-		 ioc->name, hd->ScsiLookup, sz));=0A=
-		=0A=
-	/* Allocate memory for the device structures.=0A=
-	 * A non-Null pointer at an offset=0A=
-	 * indicates a device exists.=0A=
-	 * max_id =3D 1 + maximum id (hosts.h)=0A=
-	 */=0A=
-	sz =3D sh->max_id * sizeof(void *);=0A=
-	mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-	if (mem =3D=3D NULL) {=0A=
-		error =3D -ENOMEM;=0A=
-		goto mptscsih_probe_failed;=0A=
-	}=0A=
-=0A=
-	memset(mem, 0, sz);=0A=
-	hd->Targets =3D (VirtDevice **) mem;=0A=
-=0A=
-	dprintk((KERN_INFO=0A=
-	  "  Targets @ %p, sz=3D%d\n", hd->Targets, sz));=0A=
-=0A=
-	/* Clear the TM flags=0A=
-	 */=0A=
-	hd->tmPending =3D 0;=0A=
-	hd->tmState =3D TM_STATE_NONE;=0A=
-	hd->resetPending =3D 0;=0A=
-	hd->abortSCpnt =3D NULL;=0A=
-=0A=
-	/* Clear the pointer used to store=0A=
-	 * single-threaded commands, i.e., those=0A=
-	 * issued during a bus scan, dv and=0A=
-	 * configuration pages.=0A=
-	 */=0A=
-	hd->cmdPtr =3D NULL;=0A=
-=0A=
-	/* Initialize this SCSI Hosts' timers=0A=
-	 * To use, set the timer expires field=0A=
-	 * and add_timer=0A=
-	 */=0A=
-	init_timer(&hd->timer);=0A=
-	hd->timer.data =3D (unsigned long) hd;=0A=
-	hd->timer.function =3D mptscsih_timer_expired;=0A=
-=0A=
-	if (ioc->bus_type =3D=3D SCSI) {=0A=
-		/* Update with the driver setup=0A=
-		 * values.=0A=
-		 */=0A=
-		if (ioc->spi_data.maxBusWidth > mpt_width)=0A=
-			ioc->spi_data.maxBusWidth =3D mpt_width;=0A=
-		if (ioc->spi_data.minSyncFactor < mpt_factor)=0A=
-			ioc->spi_data.minSyncFactor =3D mpt_factor;=0A=
-=0A=
-		if (ioc->spi_data.minSyncFactor =3D=3D MPT_ASYNC) {=0A=
-			ioc->spi_data.maxSyncOffset =3D 0;=0A=
-		}=0A=
-=0A=
-		ioc->spi_data.Saf_Te =3D mpt_saf_te;=0A=
-=0A=
-		hd->negoNvram =3D 0;=0A=
-#ifndef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
-		hd->negoNvram =3D MPT_SCSICFG_USE_NVRAM;=0A=
-#endif=0A=
-		ioc->spi_data.forceDv =3D 0;=0A=
-		ioc->spi_data.noQas =3D 0;=0A=
-		for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
-			ioc->spi_data.dvStatus[ii] =3D=0A=
-			  MPT_SCSICFG_NEGOTIATE;=0A=
-		}=0A=
-=0A=
-		for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++)=0A=
-			ioc->spi_data.dvStatus[ii] |=3D=0A=
-			  MPT_SCSICFG_DV_NOT_DONE;=0A=
-=0A=
-		dinitprintk((MYIOC_s_INFO_FMT=0A=
-			"dv %x width %x factor %x saf_te %x\n",=0A=
-			ioc->name, mpt_dv,=0A=
-			mpt_width,=0A=
-			mpt_factor,=0A=
-			mpt_saf_te));=0A=
-	}=0A=
-=0A=
-	mpt_scsi_hosts++;=0A=
+	if (sc->device =3D=3D NULL)=0A=
+		return;=0A=
+	if (sc->device->host =3D=3D NULL)=0A=
+		return;=0A=
+	if ((hd =3D (MPT_SCSI_HOST *)sc->device->host->hostdata) =3D=3D =
NULL)=0A=
+		return;=0A=
 =0A=
-	error =3D scsi_add_host (sh, &ioc->pcidev->dev);=0A=
-	if(error) {=0A=
-		dprintk((KERN_ERR MYNAM=0A=
-		  "scsi_add_host failed\n"));=0A=
-		goto mptscsih_probe_failed;=0A=
+	if (time - hd->last_queue_full > 10 * HZ) {=0A=
+		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported =
QUEUE_FULL!\n",=0A=
+				hd->ioc->name, 0, sc->device->id, sc->device->lun));=0A=
+		hd->last_queue_full =3D time;=0A=
 	}=0A=
-=0A=
-	scsi_scan_host(sh);=0A=
-	return 0;=0A=
-=0A=
-mptscsih_probe_failed:=0A=
-=0A=
-	mptscsih_remove(pdev);=0A=
-	return error;=0A=
-=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1286,7 +949,7 @@=0A=
  *=0A=
  *=0A=
  */=0A=
-static void=0A=
+void=0A=
 mptscsih_remove(struct pci_dev *pdev)=0A=
 {=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
@@ -1294,12 +957,16 @@=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 	int 		 	count;=0A=
 	unsigned long	 	flags;=0A=
+	int sz1;=0A=
 =0A=
 	if(!host)=0A=
 		return;=0A=
 =0A=
 	scsi_remove_host(host);=0A=
 =0A=
+	if((hd =3D (MPT_SCSI_HOST *)host->hostdata) =3D=3D NULL)=0A=
+		return;=0A=
+=0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 	/* Check DV thread active */=0A=
 	count =3D 10 * HZ;=0A=
@@ -1321,40 +988,39 @@=0A=
 #endif=0A=
 #endif=0A=
 =0A=
-	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
-	if (hd !=3D NULL) {=0A=
-		int sz1;=0A=
+	mptscsih_shutdown(&pdev->dev);=0A=
 =0A=
-		mptscsih_shutdown(&pdev->dev);=0A=
+	sz1=3D0;=0A=
 =0A=
-		sz1=3D0;=0A=
+	if (hd->ScsiLookup !=3D NULL) {=0A=
+		sz1 =3D hd->ioc->req_depth * sizeof(void *);=0A=
+		kfree(hd->ScsiLookup);=0A=
+		hd->ScsiLookup =3D NULL;=0A=
+	}=0A=
 =0A=
-		if (hd->ScsiLookup !=3D NULL) {=0A=
-			sz1 =3D hd->ioc->req_depth * sizeof(void *);=0A=
-			kfree(hd->ScsiLookup);=0A=
-			hd->ScsiLookup =3D NULL;=0A=
-		}=0A=
+	if (hd->Targets !=3D NULL) {=0A=
+		/*=0A=
+		 * Free pointer array.=0A=
+		 */=0A=
+		kfree(hd->Targets);=0A=
+		hd->Targets =3D NULL;=0A=
+	}=0A=
 =0A=
-		if (hd->Targets !=3D NULL) {=0A=
-			/*=0A=
-			 * Free pointer array.=0A=
-			 */=0A=
-			kfree(hd->Targets);=0A=
-			hd->Targets =3D NULL;=0A=
-		}=0A=
+	dprintk((MYIOC_s_INFO_FMT=0A=
+	    "Free'd ScsiLookup (%d) memory\n",=0A=
+	    hd->ioc->name, sz1));=0A=
 =0A=
-		dprintk((MYIOC_s_INFO_FMT =0A=
-		    "Free'd ScsiLookup (%d) memory\n",=0A=
-		    hd->ioc->name, sz1));=0A=
+	if (hd->info_kbuf !=3D NULL)=0A=
+		kfree(hd->info_kbuf);=0A=
 =0A=
-		/* NULL the Scsi_Host pointer=0A=
-		 */=0A=
-		hd->ioc->sh =3D NULL;=0A=
-	}=0A=
+	/* NULL the Scsi_Host pointer=0A=
+	 */=0A=
+	hd->ioc->sh =3D NULL;=0A=
 =0A=
 	scsi_host_put(host);=0A=
-	mpt_scsi_hosts--;=0A=
 =0A=
+	mpt_detach(pdev);=0A=
+	=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1362,7 +1028,7 @@=0A=
  *	mptscsih_shutdown - reboot notifier=0A=
  *=0A=
  */=0A=
-static void=0A=
+void=0A=
 mptscsih_shutdown(struct device * dev)=0A=
 {=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(to_pci_dev(dev));=0A=
@@ -1384,15 +1050,15 @@=0A=
 #ifdef CONFIG_PM=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
- *	mptscsih_suspend - Fusion MPT scsie driver suspend routine.=0A=
+ *	mptscsih_suspend - Fusion MPT scsi driver suspend routine.=0A=
  *=0A=
  *=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
 {=0A=
 	mptscsih_shutdown(&pdev->dev);=0A=
-	return 0;=0A=
+	return mpt_suspend(pdev,state);=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1401,13 +1067,15 @@=0A=
  *=0A=
  *=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_resume(struct pci_dev *pdev)=0A=
 {=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
 	struct Scsi_Host 	*host =3D ioc->sh;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 =0A=
+	mpt_resume(pdev);=0A=
+	=0A=
 	if(!host)=0A=
 		return 0;=0A=
 =0A=
@@ -1422,9 +1090,9 @@=0A=
 	if (!dvtaskQ_active) {=0A=
 		dvtaskQ_active =3D 1;=0A=
 		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-		INIT_WORK(&mptscsih_dvTask,=0A=
+		INIT_WORK(&dvTaskQ_task,=0A=
 		  mptscsih_domainValidation, (void *) hd);=0A=
-		schedule_work(&mptscsih_dvTask);=0A=
+		schedule_work(&dvTaskQ_task);=0A=
 	} else {=0A=
 		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
 	}=0A=
@@ -1435,82 +1103,6 @@=0A=
 =0A=
 #endif=0A=
 =0A=
-static struct mpt_pci_driver mptscsih_driver =3D {=0A=
-	.probe		=3D mptscsih_probe,=0A=
-	.remove		=3D mptscsih_remove,=0A=
-	.shutdown	=3D mptscsih_shutdown,=0A=
-#ifdef CONFIG_PM=0A=
-	.suspend	=3D mptscsih_suspend,=0A=
-	.resume		=3D mptscsih_resume,=0A=
-#endif=0A=
-};=0A=
-=0A=
-/*  SCSI host fops start here...  */=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/**=0A=
- *	mptscsih_init - Register MPT adapter(s) as SCSI host(s) with=0A=
- *	linux scsi mid-layer.=0A=
- *=0A=
- *	Returns 0 for success, non-zero for failure.=0A=
- */=0A=
-static int __init=0A=
-mptscsih_init(void)=0A=
-{=0A=
-=0A=
-	show_mptmod_ver(my_NAME, my_VERSION);=0A=
-=0A=
-	ScsiDoneCtx =3D mpt_register(mptscsih_io_done, MPTSCSIH_DRIVER);=0A=
-	ScsiTaskCtx =3D mpt_register(mptscsih_taskmgmt_complete, =
MPTSCSIH_DRIVER);=0A=
-	ScsiScanDvCtx =3D mpt_register(mptscsih_scandv_complete, =
MPTSCSIH_DRIVER);=0A=
-=0A=
-	if (mpt_event_register(ScsiDoneCtx, mptscsih_event_process) =3D=3D 0) =
{=0A=
-		devtprintk((KERN_INFO MYNAM=0A=
-		  ": Registered for IOC event notifications\n"));=0A=
-	}=0A=
-=0A=
-	if (mpt_reset_register(ScsiDoneCtx, mptscsih_ioc_reset) =3D=3D 0) =
{=0A=
-		dprintk((KERN_INFO MYNAM=0A=
-		  ": Registered for IOC reset notifications\n"));=0A=
-	}=0A=
-=0A=
-	if(mpt_device_driver_register(&mptscsih_driver,=0A=
-	  MPTSCSIH_DRIVER) !=3D 0 ) {=0A=
-		dprintk((KERN_INFO MYNAM=0A=
-		": failed to register dd callbacks\n"));=0A=
-	}=0A=
-=0A=
-	return 0;=0A=
-=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/**=0A=
- *	mptscsih_exit - Unregisters MPT adapter(s)=0A=
- *=0A=
- */=0A=
-static void __exit=0A=
-mptscsih_exit(void)=0A=
-{=0A=
-	mpt_device_driver_deregister(MPTSCSIH_DRIVER);=0A=
-=0A=
-	mpt_reset_deregister(ScsiDoneCtx);=0A=
-	dprintk((KERN_INFO MYNAM=0A=
-	  ": Deregistered for IOC reset notifications\n"));=0A=
-=0A=
-	mpt_event_deregister(ScsiDoneCtx);=0A=
-	dprintk((KERN_INFO MYNAM=0A=
-	  ": Deregistered for IOC event notifications\n"));=0A=
-=0A=
-	mpt_deregister(ScsiScanDvCtx);=0A=
-	mpt_deregister(ScsiTaskCtx);=0A=
-	mpt_deregister(ScsiDoneCtx);=0A=
-=0A=
-	if (info_kbuf !=3D NULL)=0A=
-		kfree(info_kbuf);=0A=
-=0A=
-}=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mptscsih_info - Return information about MPT adapter=0A=
@@ -1520,24 +1112,25 @@=0A=
  *=0A=
  *	Returns pointer to buffer where information was written.=0A=
  */=0A=
-static const char *=0A=
+const char *=0A=
 mptscsih_info(struct Scsi_Host *SChost)=0A=
 {=0A=
 	MPT_SCSI_HOST *h;=0A=
 	int size =3D 0;=0A=
 =0A=
-	if (info_kbuf =3D=3D NULL)=0A=
-		if ((info_kbuf =3D kmalloc(0x1000 /* 4Kb */, GFP_KERNEL)) =3D=3D =
NULL)=0A=
-			return info_kbuf;=0A=
-=0A=
 	h =3D (MPT_SCSI_HOST *)SChost->hostdata;=0A=
-	info_kbuf[0] =3D '\0';=0A=
+=0A=
 	if (h) {=0A=
-		mpt_print_ioc_summary(h->ioc, info_kbuf, &size, 0, 0);=0A=
-		info_kbuf[size-1] =3D '\0';=0A=
+		if (h->info_kbuf =3D=3D NULL)=0A=
+			if ((h->info_kbuf =3D kmalloc(0x1000 /* 4Kb */, GFP_KERNEL)) =3D=3D =
NULL)=0A=
+				return h->info_kbuf;=0A=
+		h->info_kbuf[0] =3D '\0';=0A=
+=0A=
+		mpt_print_ioc_summary(h->ioc, h->info_kbuf, &size, 0, 0);=0A=
+		h->info_kbuf[size-1] =3D '\0';=0A=
 	}=0A=
 =0A=
-	return info_kbuf;=0A=
+	return h->info_kbuf;=0A=
 }=0A=
 =0A=
 struct info_str {=0A=
@@ -1547,7 +1140,8 @@=0A=
 	int   pos;=0A=
 };=0A=
 =0A=
-static void copy_mem_info(struct info_str *info, char *data, int =
len)=0A=
+static void=0A=
+mptscsih_copy_mem_info(struct info_str *info, char *data, int len)=0A=
 {=0A=
 	if (info->pos + len > info->length)=0A=
 		len =3D info->length - info->pos;=0A=
@@ -1568,7 +1162,8 @@=0A=
 	}=0A=
 }=0A=
 =0A=
-static int copy_info(struct info_str *info, char *fmt, ...)=0A=
+static int=0A=
+mptscsih_copy_info(struct info_str *info, char *fmt, ...)=0A=
 {=0A=
 	va_list args;=0A=
 	char buf[81];=0A=
@@ -1578,11 +1173,12 @@=0A=
 	len =3D vsprintf(buf, fmt, args);=0A=
 	va_end(args);=0A=
 =0A=
-	copy_mem_info(info, buf, len);=0A=
+	mptscsih_copy_mem_info(info, buf, len);=0A=
 	return len;=0A=
 }=0A=
 =0A=
-static int mptscsih_host_info(MPT_ADAPTER *ioc, char *pbuf, off_t =
offset, int len)=0A=
+static int=0A=
+mptscsih_host_info(MPT_ADAPTER *ioc, char *pbuf, off_t offset, int =
len)=0A=
 {=0A=
 	struct info_str info;=0A=
 =0A=
@@ -1591,10 +1187,10 @@=0A=
 	info.offset	=3D offset;=0A=
 	info.pos	=3D 0;=0A=
 =0A=
-	copy_info(&info, "%s: %s, ", ioc->name, ioc->prod_name);=0A=
-	copy_info(&info, "%s%08xh, ", MPT_FW_REV_MAGIC_ID_STRING, =
ioc->facts.FWVersion.Word);=0A=
-	copy_info(&info, "Ports=3D%d, ", ioc->facts.NumberOfPorts);=0A=
-	copy_info(&info, "MaxQ=3D%d\n", ioc->req_depth);=0A=
+	mptscsih_copy_info(&info, "%s: %s, ", ioc->name, ioc->prod_name);=0A=
+	mptscsih_copy_info(&info, "%s%08xh, ", MPT_FW_REV_MAGIC_ID_STRING, =
ioc->facts.FWVersion.Word);=0A=
+	mptscsih_copy_info(&info, "Ports=3D%d, ", =
ioc->facts.NumberOfPorts);=0A=
+	mptscsih_copy_info(&info, "MaxQ=3D%d\n", ioc->req_depth);=0A=
 =0A=
 	return ((info.pos > info.offset) ? info.pos - info.offset : 0);=0A=
 }=0A=
@@ -1612,7 +1208,7 @@=0A=
  * 	hostno: scsi host number=0A=
  *	func:   if write =3D 1; if read =3D 0=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, =
off_t offset,=0A=
 			int length, int func)=0A=
 {=0A=
@@ -1649,7 +1245,7 @@=0A=
  *=0A=
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd =
*))=0A=
 {=0A=
 	MPT_SCSI_HOST		*hd;=0A=
@@ -1684,7 +1280,7 @@=0A=
 	/*=0A=
 	 *  Put together a MPT SCSI request...=0A=
 	 */=0A=
-	if ((mf =3D mpt_get_msg_frame(ScsiDoneCtx, hd->ioc)) =3D=3D NULL) =
{=0A=
+	if ((mf =3D mpt_get_msg_frame(hd->ioc->DoneCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		dprintk((MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",=0A=
 				hd->ioc->name));=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
@@ -1696,8 +1292,7 @@=0A=
 =0A=
 	ADD_INDEX_LOG(my_idx);=0A=
 =0A=
-	/*  BUG FIX!  19991030 -sralston=0A=
-	 *    TUR's being issued with scsictl=3D0x02000000 (DATA_IN)!=0A=
+	/*    TUR's being issued with scsictl=3D0x02000000 (DATA_IN)!=0A=
 	 *    Seems we may receive a buffer (datalen>0) even when there=0A=
 	 *    will be no data transfer!  GRRRRR...=0A=
 	 */=0A=
@@ -1791,9 +1386,9 @@=0A=
 				if (!dvtaskQ_active) {=0A=
 					dvtaskQ_active =3D 1;=0A=
 					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-					INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) =
hd);=0A=
+					INIT_WORK(&dvTaskQ_task, mptscsih_domainValidation, (void *) =
hd);=0A=
 =0A=
-					schedule_work(&mptscsih_dvTask);=0A=
+					schedule_work(&dvTaskQ_task);=0A=
 				} else {=0A=
 					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
 				}=0A=
@@ -1819,7 +1414,7 @@=0A=
 	}=0A=
 #endif=0A=
 =0A=
-	mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
+	mpt_put_msg_frame(hd->ioc->DoneCtx, hd->ioc, mf);=0A=
 	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=3D%p =
idx=3D%d\n",=0A=
 			hd->ioc->name, SCpnt, mf, my_idx));=0A=
 	DBG_DUMP_REQUEST_FRAME(mf)=0A=
@@ -2036,7 +1631,7 @@=0A=
 =0A=
 	/* Return Fail to calling function if no message frames available.=0A=
 	 */=0A=
-	if ((mf =3D mpt_get_msg_frame(ScsiTaskCtx, hd->ioc)) =3D=3D NULL) =
{=0A=
+	if ((mf =3D mpt_get_msg_frame(hd->ioc->TaskCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		dfailprintk((MYIOC_s_ERR_FMT "IssueTaskMgmt, no msg frames!!\n",=0A=
 				hd->ioc->name));=0A=
 		//return FAILED;=0A=
@@ -2075,7 +1670,7 @@=0A=
 =0A=
 	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);=0A=
 =0A=
-	if ((retval =3D mpt_send_handshake_request(ScsiTaskCtx, hd->ioc,=0A=
+	if ((retval =3D mpt_send_handshake_request(hd->ioc->TaskCtx, =
hd->ioc,=0A=
 		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm,=0A=
 		CAN_SLEEP)) !=3D 0) {=0A=
 		dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"=0A=
@@ -2107,7 +1702,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_abort(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2210,7 +1805,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2260,7 +1855,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_bus_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2312,7 +1907,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST *  hd;=0A=
@@ -2426,7 +2021,7 @@=0A=
  *=0A=
  *	Returns 1 indicating alloc'd request frame ptr should be freed.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *mr)=0A=
 {=0A=
 	SCSITaskMgmtReply_t	*pScsiTmReply;=0A=
@@ -2509,7 +2104,7 @@=0A=
 /*=0A=
  *	This is anyones guess quite frankly.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_bios_param(struct scsi_device * sdev, struct block_device =
*bdev,=0A=
 		sector_t capacity, int geom[])=0A=
 {=0A=
@@ -2556,7 +2151,7 @@=0A=
  *	Return non-zero if allocation fails.=0A=
  *	Init memory once per id (not LUN).=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_slave_alloc(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
@@ -2599,7 +2194,8 @@=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static int mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)=0A=
+static int =0A=
+mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)=0A=
 {=0A=
 	int i;=0A=
 =0A=
@@ -2618,7 +2214,7 @@=0A=
  *	OS entry point to allow for host driver to free allocated memory=0A=
  *	Called if no device present or device being unloaded=0A=
  */=0A=
-static void=0A=
+void=0A=
 mptscsih_slave_destroy(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
@@ -2639,7 +2235,7 @@=0A=
 =0A=
 	kfree(hd->Targets[target]);=0A=
 	hd->Targets[target] =3D NULL;=0A=
-	=0A=
+=0A=
 	if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
 		if (mptscsih_is_raid_volume(hd, target)) {=0A=
 			hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
@@ -2695,7 +2291,7 @@=0A=
  *	member to 1 if a device does not support Q tags.=0A=
  *	Return non-zero if fails.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_slave_configure(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*sh =3D device->host;=0A=
@@ -2758,7 +2354,7 @@=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static ssize_t=0A=
+ssize_t=0A=
 mptscsih_store_queue_depth(struct device *dev, const char *buf, size_t =
count)=0A=
 {=0A=
 	int			 depth;=0A=
@@ -2788,7 +2384,7 @@=0A=
  *=0A=
  */=0A=
 static void=0A=
-copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR =
*mf, SCSIIOReply_t *pScsiReply)=0A=
+mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, =
MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)=0A=
 {=0A=
 	VirtDevice	*target;=0A=
 	SCSIIORequest_t	*pReq;=0A=
@@ -2854,7 +2450,7 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static int=0A=
+int=0A=
 mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2949,8 +2545,8 @@=0A=
 			 */=0A=
 			hd->pLocal =3D &hd->localReply;=0A=
 			hd->pLocal->completion =3D MPT_SCANDV_DID_RESET;=0A=
-			scandv_wait_done =3D 1;=0A=
-			wake_up(&scandv_waitq);=0A=
+			hd->scandv_wait_done =3D 1;=0A=
+			wake_up(&hd->scandv_waitq);=0A=
 			hd->cmdPtr =3D NULL;=0A=
 		}=0A=
 =0A=
@@ -2969,7 +2565,7 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-static int=0A=
+int=0A=
 mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t =
*pEvReply)=0A=
 {=0A=
 	MPT_SCSI_HOST *hd;=0A=
@@ -3085,42 +2681,6 @@=0A=
 	return 1;		/* currently means nothing really */=0A=
 }=0A=
 =0A=
-static struct device_attribute mptscsih_queue_depth_attr =3D {=0A=
-	.attr =3D {=0A=
-		.name =3D 	"queue_depth",=0A=
-		.mode =3D		S_IWUSR,=0A=
-	},=0A=
-	.store =3D mptscsih_store_queue_depth,=0A=
-};=0A=
-=0A=
-static struct device_attribute *mptscsih_dev_attrs[] =3D {=0A=
-	&mptscsih_queue_depth_attr,=0A=
-	NULL,=0A=
-};=0A=
-=0A=
-static struct scsi_host_template driver_template =3D {=0A=
-	.proc_name			=3D "mptscsih",=0A=
-	.proc_info			=3D mptscsih_proc_info,=0A=
-	.name				=3D "MPT SCSI Host",=0A=
-	.info				=3D mptscsih_info,=0A=
-	.queuecommand			=3D mptscsih_qcmd,=0A=
-	.slave_alloc			=3D mptscsih_slave_alloc,=0A=
-	.slave_configure		=3D mptscsih_slave_configure,=0A=
-	.slave_destroy			=3D mptscsih_slave_destroy,=0A=
-	.eh_abort_handler		=3D mptscsih_abort,=0A=
-	.eh_device_reset_handler	=3D mptscsih_dev_reset,=0A=
-	.eh_bus_reset_handler		=3D mptscsih_bus_reset,=0A=
-	.eh_host_reset_handler		=3D mptscsih_host_reset,=0A=
-	.bios_param			=3D mptscsih_bios_param,=0A=
-	.can_queue			=3D MPT_SCSI_CAN_QUEUE,=0A=
-	.this_id			=3D -1,=0A=
-	.sg_tablesize			=3D MPT_SCSI_SG_DEPTH,=0A=
-	.max_sectors			=3D 8192,=0A=
-	.cmd_per_lun			=3D 7,=0A=
-	.use_clustering			=3D ENABLE_CLUSTERING,=0A=
-	.sdev_attrs			=3D mptscsih_dev_attrs,=0A=
-};=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mptscsih_initTarget - Target, LUN alloc/free functionality.=0A=
@@ -3158,9 +2718,9 @@=0A=
 	 * around a bug in th emid-layer in some distributions in which the =
mid-layer will=0A=
 	 * continue to try to communicate to the LUN and evntually create a =
dummy LUN.=0A=
 	*/=0A=
-	if (mpt_pq_filter && dlen && (data[0] & 0xE0))=0A=
+	if (hd->mpt_pq_filter && dlen && (data[0] & 0xE0))=0A=
 		data[0] |=3D 0x40;=0A=
-	=0A=
+=0A=
 	/* Is LUN supported? If so, upper 2 bits will be 0=0A=
 	* in first byte of inquiry data.=0A=
 	*/=0A=
@@ -3307,7 +2867,7 @@=0A=
 				ddvtprintk((KERN_INFO "Enabling QAS on id=3D%d due to =
~TARGET_FLAGS_VALID_56!\n", id));=0A=
 				noQas =3D 0;=0A=
 			}=0A=
-				=0A=
+=0A=
 			offset =3D pspi_data->maxSyncOffset;=0A=
 =0A=
 			/* If RAID, never disable QAS=0A=
@@ -3401,7 +2961,7 @@=0A=
 				if ( (vdev =3D hd->Targets[ii]) ) {=0A=
 					vdev->negoFlags |=3D MPT_TARGET_NO_NEGO_QAS;=0A=
 					mptscsih_writeSDP1(hd, 0, ii, vdev->negoFlags);=0A=
-				}	=0A=
+				}=0A=
 			}=0A=
 		}=0A=
 	}=0A=
@@ -3426,14 +2986,15 @@=0A=
  * Tapes, initTarget will set this flag on completion of Inquiry =
command.=0A=
  * Called only if DV_NOT_DONE flag is set=0A=
  */=0A=
-static void mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t =
*pReq)=0A=
+static void=0A=
+mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t *pReq)=0A=
 {=0A=
 	u8 cmd;=0A=
 	ScsiCfgData *pSpi;=0A=
 =0A=
 	ddvtprintk((" set_dvflags: id=3D%d lun=3D%d negoNvram=3D%x =
cmd=3D%x\n", =0A=
 		pReq->TargetID, pReq->LUN[1], hd->negoNvram, pReq->CDB[0]));=0A=
-	=0A=
+=0A=
 	if ((pReq->LUN[1] !=3D 0) || (hd->negoNvram !=3D 0))=0A=
 		return;=0A=
 =0A=
@@ -3464,7 +3025,8 @@=0A=
  * If no Target, bus reset on 1st I/O. Set the flag to=0A=
  * prevent any future negotiations to this device.=0A=
  */=0A=
-static void mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id)=0A=
+static void=0A=
+mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int target_id)=0A=
 {=0A=
 =0A=
 	if ((hd->Targets) && (hd->Targets[target_id] =3D=3D NULL))=0A=
@@ -3631,7 +3193,7 @@=0A=
 			offset =3D pTarget->maxOffset;=0A=
 			negoFlags =3D pTarget->negoFlags;=0A=
 		}=0A=
-		=0A=
+=0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 		/* Force to async and narrow if DV has not been executed=0A=
 		 * for this ID=0A=
@@ -3653,7 +3215,7 @@=0A=
 =0A=
 		/* Get a MF for this command.=0A=
 		 */=0A=
-		if ((mf =3D mpt_get_msg_frame(ScsiDoneCtx, ioc)) =3D=3D NULL) {=0A=
+		if ((mf =3D mpt_get_msg_frame(ioc->DoneCtx, ioc)) =3D=3D NULL) {=0A=
 			dprintk((MYIOC_s_WARN_FMT "write SDP1: no msg frames!\n",=0A=
 						ioc->name));=0A=
 			return -EAGAIN;=0A=
@@ -3717,7 +3279,7 @@=0A=
 				ioc->name, id, (id | (bus<<8)),=0A=
 				requested, configuration));=0A=
 =0A=
-		mpt_put_msg_frame(ScsiDoneCtx, ioc, mf);=0A=
+		mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);=0A=
 	}=0A=
 =0A=
 	return 0;=0A=
@@ -3748,7 +3310,7 @@=0A=
 =0A=
 	/* Get a MF for this command.=0A=
 	 */=0A=
-	if ((mf =3D mpt_get_msg_frame(ScsiDoneCtx, ioc)) =3D=3D NULL) {=0A=
+	if ((mf =3D mpt_get_msg_frame(ioc->DoneCtx, ioc)) =3D=3D NULL) {=0A=
 		dprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",=0A=
 					ioc->name));=0A=
 		return -EAGAIN;=0A=
@@ -3794,7 +3356,7 @@=0A=
 		"writeIOCPage4: MaxSEP=3D%d ActiveSEP=3D%d id=3D%d bus=3D%d\n",=0A=
 			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, target_id, =
bus));=0A=
 =0A=
-	mpt_put_msg_frame(ScsiDoneCtx, ioc, mf);=0A=
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
@@ -3824,7 +3386,7 @@=0A=
  *	in the IOC member localReply structure.=0A=
  *	Used ONLY for DV and other internal commands.=0A=
  */=0A=
-static int=0A=
+int=0A=
 mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *mr)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -3832,6 +3394,8 @@=0A=
 	int		 completionCode;=0A=
 	u16		 req_idx;=0A=
 =0A=
+	hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
+=0A=
 	if ((mf =3D=3D NULL) ||=0A=
 	    (mf >=3D MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {=0A=
 		printk(MYIOC_s_ERR_FMT=0A=
@@ -3840,7 +3404,6 @@=0A=
 		goto wakeup;=0A=
 	}=0A=
 =0A=
-	hd =3D (MPT_SCSI_HOST *) ioc->sh->hostdata;=0A=
 	del_timer(&hd->timer);=0A=
 	req_idx =3D le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
 	hd->ScsiLookup[req_idx] =3D NULL;=0A=
@@ -3972,8 +3535,8 @@=0A=
 	/*=0A=
 	 * Wake up the original calling thread=0A=
 	 */=0A=
-	scandv_wait_done =3D 1;=0A=
-	wake_up(&scandv_waitq);=0A=
+	hd->scandv_wait_done =3D 1;=0A=
+	wake_up(&hd->scandv_waitq);=0A=
 =0A=
 	return 1;=0A=
 }=0A=
@@ -3984,7 +3547,8 @@=0A=
  *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long=0A=
  *=0A=
  */=0A=
-static void mptscsih_timer_expired(unsigned long data)=0A=
+void=0A=
+mptscsih_timer_expired(unsigned long data)=0A=
 {=0A=
 	MPT_SCSI_HOST *hd =3D (MPT_SCSI_HOST *) data;=0A=
 =0A=
@@ -4051,7 +3615,7 @@=0A=
 =0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
-	if ((mf =3D mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc)) =3D=3D NULL) =
{=0A=
+	if ((mf =3D mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",=0A=
 					hd->ioc->name));=0A=
 		return -EAGAIN;=0A=
@@ -4077,7 +3641,7 @@=0A=
 =0A=
 	hd->pLocal =3D NULL;=0A=
 	hd->timer.expires =3D jiffies + HZ*10; /* 10 second timeout */=0A=
-	scandv_wait_done =3D 0;=0A=
+	hd->scandv_wait_done =3D 0;=0A=
 =0A=
 	/* Save cmd pointer, for resource free if timeout or=0A=
 	 * FW reload occurs=0A=
@@ -4085,8 +3649,8 @@=0A=
 	hd->cmdPtr =3D mf;=0A=
 =0A=
 	add_timer(&hd->timer);=0A=
-	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc, mf);=0A=
-	wait_event(scandv_waitq, scandv_wait_done);=0A=
+	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);=0A=
+	wait_event(hd->scandv_waitq, hd->scandv_wait_done);=0A=
 =0A=
 	if ((hd->pLocal =3D=3D NULL) || (hd->pLocal->completion !=3D =
MPT_SCANDV_GOOD))=0A=
 		return -1;=0A=
@@ -4232,7 +3796,7 @@=0A=
 =0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
-	if ((mf =3D mpt_get_msg_frame(ScsiScanDvCtx, hd->ioc)) =3D=3D NULL) =
{=0A=
+	if ((mf =3D mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",=0A=
 					hd->ioc->name));=0A=
 		return -EBUSY;=0A=
@@ -4314,7 +3878,7 @@=0A=
 	 */=0A=
 	hd->pLocal =3D NULL;=0A=
 	hd->timer.expires =3D jiffies + HZ*cmdTimeout;=0A=
-	scandv_wait_done =3D 0;=0A=
+	hd->scandv_wait_done =3D 0;=0A=
 =0A=
 	/* Save cmd pointer, for resource free if timeout or=0A=
 	 * FW reload occurs=0A=
@@ -4322,8 +3886,8 @@=0A=
 	hd->cmdPtr =3D mf;=0A=
 =0A=
 	add_timer(&hd->timer);=0A=
-	mpt_put_msg_frame(ScsiScanDvCtx, hd->ioc, mf);=0A=
-	wait_event(scandv_waitq, scandv_wait_done);=0A=
+	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);=0A=
+	wait_event(hd->scandv_waitq, hd->scandv_wait_done);=0A=
 =0A=
 	if (hd->pLocal) {=0A=
 		rc =3D hd->pLocal->completion;=0A=
@@ -4640,7 +4204,8 @@=0A=
 =0A=
 /* Search IOC page 3 to determine if this is hidden physical disk=0A=
  */=0A=
-static int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)=0A=
+static int =0A=
+mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id)=0A=
 {=0A=
 	if (ioc->spi_data.pIocPg3) {=0A=
 		Ioc3PhysDisk_t *pPDisk =3D  ioc->spi_data.pIocPg3->PhysDisk;=0A=
@@ -4659,7 +4224,8 @@=0A=
 =0A=
 /* Write SDP1 if no QAS has been enabled=0A=
  */=0A=
-static void mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)=0A=
+static void=0A=
+mptscsih_qas_check(MPT_SCSI_HOST *hd, int id)=0A=
 {=0A=
 	VirtDevice *pTarget;=0A=
 	int ii;=0A=
@@ -5157,7 +4723,7 @@=0A=
 	}=0A=
 	ddvprintk((MYIOC_s_NOTE_FMT "DV: Basic test on id=3D%d completed =
OK.\n", ioc->name, id));=0A=
 =0A=
-	if (mpt_dv =3D=3D 0)=0A=
+	if (ioc->spi_data.mpt_dv =3D=3D 0)=0A=
 		goto target_done;=0A=
 =0A=
 	inq0 =3D (*pbuf1) & 0x1F;=0A=
@@ -6015,7 +5581,29 @@=0A=
 }=0A=
 #endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */=0A=
 =0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+EXPORT_SYMBOL(mptscsih_remove);=0A=
+EXPORT_SYMBOL(mptscsih_shutdown);=0A=
+#ifdef CONFIG_PM=0A=
+EXPORT_SYMBOL(mptscsih_suspend);=0A=
+EXPORT_SYMBOL(mptscsih_resume);=0A=
+#endif=0A=
+EXPORT_SYMBOL(mptscsih_proc_info);=0A=
+EXPORT_SYMBOL(mptscsih_info);=0A=
+EXPORT_SYMBOL(mptscsih_qcmd);=0A=
+EXPORT_SYMBOL(mptscsih_slave_alloc);=0A=
+EXPORT_SYMBOL(mptscsih_slave_destroy);=0A=
+EXPORT_SYMBOL(mptscsih_slave_configure);=0A=
+EXPORT_SYMBOL(mptscsih_abort);=0A=
+EXPORT_SYMBOL(mptscsih_dev_reset);=0A=
+EXPORT_SYMBOL(mptscsih_bus_reset);=0A=
+EXPORT_SYMBOL(mptscsih_host_reset);=0A=
+EXPORT_SYMBOL(mptscsih_bios_param);=0A=
+EXPORT_SYMBOL(mptscsih_io_done);=0A=
+EXPORT_SYMBOL(mptscsih_taskmgmt_complete);=0A=
+EXPORT_SYMBOL(mptscsih_scandv_complete);=0A=
+EXPORT_SYMBOL(mptscsih_event_process);=0A=
+EXPORT_SYMBOL(mptscsih_ioc_reset);=0A=
+EXPORT_SYMBOL(mptscsih_store_queue_depth);=0A=
+EXPORT_SYMBOL(mptscsih_timer_expired);=0A=
 =0A=
-module_init(mptscsih_init);=0A=
-module_exit(mptscsih_exit);=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
--- b/drivers/message/fusion/mptscsih.h	2005-04-19 08:37:22.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.h	2005-04-19 14:14:02.000000000 =
-0600=0A=
@@ -1,26 +1,13 @@=0A=
 /*=0A=
- *  linux/drivers/message/fusion/mptscsih.h=0A=
+ *  linux/drivers/message/fusion/mptscsi.h=0A=
  *      High performance SCSI / Fibre Channel SCSI Host device =
driver.=0A=
  *      For use with PCI chip/adapter(s):=0A=
  *          LSIFC9xx/LSI409xx Fibre Channel=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston=0A=
- *  (mailto:netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptscsih.h,v 1.21 2002/12/03 21:26:35 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -91,4 +78,30 @@=0A=
 #define MPTSCSIH_MIN_SYNC               0x08=0A=
 #define MPTSCSIH_SAF_TE                 0=0A=
 =0A=
+=0A=
+#endif=0A=
+=0A=
+extern void mptscsih_remove(struct pci_dev *);=0A=
+extern void mptscsih_shutdown(struct device *);=0A=
+#ifdef CONFIG_PM=0A=
+extern int mptscsih_suspend(struct pci_dev *pdev, u32 state);=0A=
+extern int mptscsih_resume(struct pci_dev *pdev);=0A=
 #endif=0A=
+extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, =
char **start, off_t offset, int length, int func);=0A=
+extern const char * mptscsih_info(struct Scsi_Host *SChost);=0A=
+extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct =
scsi_cmnd *));=0A=
+extern int mptscsih_slave_alloc(struct scsi_device *device);=0A=
+extern void mptscsih_slave_destroy(struct scsi_device *device);=0A=
+extern int mptscsih_slave_configure(struct scsi_device *device);=0A=
+extern int mptscsih_abort(struct scsi_cmnd * SCpnt);=0A=
+extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);=0A=
+extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);=0A=
+extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);=0A=
+extern int mptscsih_bios_param(struct scsi_device * sdev, struct =
block_device *bdev, sector_t capacity, int geom[]);=0A=
+extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, =
MPT_FRAME_HDR *r);=0A=
+extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);=0A=
+extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);=0A=
+extern int mptscsih_event_process(MPT_ADAPTER *ioc, =
EventNotificationReply_t *pEvReply);=0A=
+extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
+extern ssize_t mptscsih_store_queue_depth(struct device *dev, const =
char *buf, size_t count);=0A=
+extern void mptscsih_timer_expired(unsigned long data);=0A=

------_=_NextPart_000_01C54524.68B63D00--
