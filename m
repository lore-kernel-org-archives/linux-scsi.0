From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fix dma mapping leak in fusion
Date: Thu, 19 Aug 2004 10:47:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704DE6953@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C485FB.779E8720"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46978 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266254AbUHSOrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 10:47:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C485FB.779E8720
Content-Type: text/plain;
	charset="iso-8859-1"

Here is a patch to apply against 3.01.15. It will have a small
fix in mptscsih_abort which should work with Christoph's suggestion
of removing the "is the device is offline" check in 
mptscsih_flush_running_cmds.  Pls test and let me know if you still 
hit the oops.

Eric


On Thursday, August 19, 2004 7:15 AM, Masao Fukuchi wrote:
> 
> I tried fusion MPT driver 3.01.15 and I didn't met Oops.
> (Eric fixed Oops problem by Fusion MPT driver 3.01.04)
> 
> Masao Fukuchi
> 
> Message:
>  18:19:01 kernel: mptscsih: ioc3: >> Attempting task abort! 
> (sc=e00000007c205080)
>  18:19:01 kernel: mptscsih: ioc3: >> Attempting target reset! 
> (sc=e00000007c205080)
>  18:19:01 kernel: mptscsih: ioc3: >> Attempting bus reset! 
> (sc=e00000007c205080)
>  18:19:03 kernel: mptbase: Initiating ioc3 recovery
>  18:19:28 kernel: mptscsih: ioc3: >> Attempting task abort! 
> (sc=e00000007c205080)
>  18:19:28 kernel: mptscsih: ioc3: >> Attempting host reset! 
> (sc=e00000007c205080)
>  18:19:28 kernel: mptbase: Initiating ioc3 recovery
>  18:19:52 kernel: mptscsih: ioc3: >> Attempting task abort! 
> (sc=e00000007c205080)
>  18:19:52 kernel: scsi: Device offlined - not ready after 
> error recovery: host 3 channel 0 id 1 lun 0
>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 2
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 3
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 4
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 5
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 6
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 7
>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>  18:19:54 kernel: mptbase: Initiating ioc3 recovery
> 
> 
> Christoph Hellwig wrote:
> >On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
> >> Hi Christoph,
> >> 
> >> I applyed attached patch into latest fusion MPT driver(3.01.15) and
> >> tested it, but I still met Oops.
> >> Then I also applyed your latest patch(it gets rid of the 
> fusion pendingQ
> >> in favour of using the scsi midlayer queuing), but I met 
> Oops again.
> >
> >Can you try the patch Eric posted instead?
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


------_=_NextPart_000_01C485FB.779E8720
Content-Type: application/octet-stream;
	name="mptlinux-3.01.16.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.16.patch"

diff -uarN b/message/fusion/mptbase.c a/message/fusion/mptbase.c=0A=
--- b/message/fusion/mptbase.c	2004-08-09 16:42:28.000000000 -0600=0A=
+++ a/message/fusion/mptbase.c	2004-08-18 10:59:06.000000000 -0600=0A=
@@ -3395,7 +3395,7 @@=0A=
  *	@hd: Pointer to MPT_SCSI_HOST structure=0A=
  *	@init: If set, initialize the spin lock.=0A=
  */=0A=
-int=0A=
+static int=0A=
 initChainBuffers(MPT_ADAPTER *ioc)=0A=
 {=0A=
 	u8		*mem;=0A=
diff -uarN b/message/fusion/mptbase.h a/message/fusion/mptbase.h=0A=
--- b/message/fusion/mptbase.h	2004-08-09 16:42:45.000000000 -0600=0A=
+++ a/message/fusion/mptbase.h	2004-08-18 11:20:23.000000000 -0600=0A=
@@ -83,8 +83,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.15"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.15"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.16"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.16"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -318,17 +318,6 @@=0A=
 	struct _Q_ITEM	*tail;=0A=
 } Q_TRACKER;=0A=
 =0A=
-typedef struct _MPT_DONE_Q {=0A=
-	struct _MPT_DONE_Q	*forw;=0A=
-	struct _MPT_DONE_Q	*back;=0A=
-	void			*argp;=0A=
-} MPT_DONE_Q;=0A=
-=0A=
-typedef struct _DONE_Q_TRACKER {=0A=
-	MPT_DONE_Q	*head;=0A=
-	MPT_DONE_Q	*tail;=0A=
-} DONE_Q_TRACKER;=0A=
-=0A=
 /*=0A=
  *  Chip-specific stuff... FC929 delineates break between=0A=
  *  FC and Parallel SCSI parts. Do NOT re-order.=0A=
@@ -1028,12 +1017,7 @@=0A=
 		/* Pool of memory for holding SCpnts before doing=0A=
 		 * OS callbacks. freeQ is the free pool.=0A=
 		 */=0A=
-	u8			 *memQ;=0A=
-	DONE_Q_TRACKER		  freeQ;=0A=
-	DONE_Q_TRACKER		  doneQ;		/* Holds Linux formmatted requests */=0A=
-	DONE_Q_TRACKER		  pendingQ;		/* Holds MPI formmatted requests */=0A=
 	MPT_Q_TRACKER		  taskQ;		/* TM request Q */=0A=
-	spinlock_t		  freedoneQlock;=0A=
 	int			  taskQcnt;=0A=
 	u8			  tmPending;=0A=
 	u8			  resetPending;=0A=
diff -uarN b/message/fusion/mptctl.c a/message/fusion/mptctl.c=0A=
--- b/message/fusion/mptctl.c	2004-07-02 09:14:30.000000000 -0600=0A=
+++ a/message/fusion/mptctl.c	2004-08-18 10:59:54.000000000 -0600=0A=
@@ -2865,7 +2865,7 @@=0A=
 };=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-int __init mptctl_init(void)=0A=
+static int __init mptctl_init(void)=0A=
 {=0A=
 	int err;=0A=
 	int where =3D 1;=0A=
@@ -2963,7 +2963,7 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-void mptctl_exit(void)=0A=
+static void mptctl_exit(void)=0A=
 {=0A=
 	misc_deregister(&mptctl_miscdev);=0A=
 	printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ =
(major,minor=3D%d,%d)\n",=0A=
diff -uarN b/message/fusion/mptscsih.c a/message/fusion/mptscsih.c=0A=
--- b/message/fusion/mptscsih.c	2004-08-02 17:01:01.000000000 -0600=0A=
+++ a/message/fusion/mptscsih.c	2004-08-18 16:38:57.000000000 -0600=0A=
@@ -168,8 +168,6 @@=0A=
 static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, =
MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);=0A=
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);=0A=
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);=0A=
-static MPT_FRAME_HDR *mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int =
scpnt_idx);=0A=
-static void	post_pendingQ_commands(MPT_SCSI_HOST *hd);=0A=
 =0A=
 static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, =
u8 target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag);=0A=
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 =
channel, u8 target, u8 lun, int ctx2abort, ulong timeout, int =
sleepFlag);=0A=
@@ -178,7 +176,7 @@=0A=
 static int	mptscsih_event_process(MPT_ADAPTER *ioc, =
EventNotificationReply_t *pEvReply);=0A=
 =0A=
 static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, int bus_id, int =
target_id, u8 lun, char *data, int dlen);=0A=
-void		mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56);=0A=
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56);=0A=
 static void	mptscsih_set_dvflags(MPT_SCSI_HOST *hd, SCSIIORequest_t =
*pReq);=0A=
 static void	mptscsih_setDevicePage1Flags (u8 width, u8 factor, u8 =
offset, int *requestedPtr, int *configurationPtr, u8 flags);=0A=
 static void	mptscsih_no_negotiate(MPT_SCSI_HOST *hd, int =
target_id);=0A=
@@ -895,84 +893,6 @@=0A=
 	return 1;=0A=
 }=0A=
 =0A=
-/*=0A=
- * Flush all commands on the doneQ.=0A=
- * Lock Q when deleting/adding members=0A=
- * Lock io_request_lock for OS callback.=0A=
- */=0A=
-static void=0A=
-flush_doneQ(MPT_SCSI_HOST *hd)=0A=
-{=0A=
-	MPT_DONE_Q	*buffer;=0A=
-	struct scsi_cmnd	*SCpnt;=0A=
-	unsigned long	 flags;=0A=
-=0A=
-	/* Flush the doneQ.=0A=
-	 */=0A=
-	dtmprintk((KERN_INFO MYNAM ": flush_doneQ called\n"));=0A=
-	while (1) {=0A=
-		spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-		if (Q_IS_EMPTY(&hd->doneQ)) {=0A=
-			spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-			break;=0A=
-		}=0A=
-=0A=
-		buffer =3D hd->doneQ.head;=0A=
-		/* Delete from Q=0A=
-		 */=0A=
-		Q_DEL_ITEM(buffer);=0A=
-=0A=
-		/* Set the struct scsi_cmnd pointer=0A=
-		 */=0A=
-		SCpnt =3D (struct scsi_cmnd *) buffer->argp;=0A=
-		buffer->argp =3D NULL;=0A=
-=0A=
-		/* Add to the freeQ=0A=
-		 */=0A=
-		Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);=0A=
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-=0A=
-		/* Do the OS callback.=0A=
-		 */=0A=
-		SCpnt->scsi_done(SCpnt);=0A=
-	}=0A=
-=0A=
-	return;=0A=
-}=0A=
-=0A=
-/*=0A=
- * Search the doneQ for a specific command. If found, delete from =
Q.=0A=
- * Calling function will finish processing.=0A=
- */=0A=
-static void=0A=
-search_doneQ_for_cmd(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt)=0A=
-{=0A=
-	unsigned long	 flags;=0A=
-	MPT_DONE_Q	*buffer;=0A=
-=0A=
-	spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-	if (!Q_IS_EMPTY(&hd->doneQ)) {=0A=
-		buffer =3D hd->doneQ.head;=0A=
-		do {=0A=
-			struct scsi_cmnd *sc =3D (struct scsi_cmnd *) buffer->argp;=0A=
-			if (SCpnt =3D=3D sc) {=0A=
-				Q_DEL_ITEM(buffer);=0A=
-				SCpnt->result =3D sc->result;=0A=
-=0A=
-				/* Set the struct scsi_cmnd pointer=0A=
-				 */=0A=
-				buffer->argp =3D NULL;=0A=
-=0A=
-				/* Add to the freeQ=0A=
-				 */=0A=
-				Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);=0A=
-				break;=0A=
-			}=0A=
-		} while ((buffer =3D buffer->forw) !=3D (MPT_DONE_Q *) =
&hd->doneQ);=0A=
-	}=0A=
-	spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-	return;=0A=
-}=0A=
 =0A=
 /*=0A=
  *	mptscsih_flush_running_cmds - For each command found, search=0A=
@@ -990,10 +910,8 @@=0A=
 	MPT_ADAPTER *ioc =3D hd->ioc;=0A=
 	struct scsi_cmnd	*SCpnt;=0A=
 	MPT_FRAME_HDR	*mf;=0A=
-	MPT_DONE_Q	*buffer;=0A=
 	int		 ii;=0A=
 	int		 max =3D ioc->req_depth;=0A=
-	unsigned long	 flags;=0A=
 =0A=
 	dprintk((KERN_INFO MYNAM ": flush_ScsiLookup called\n"));=0A=
 	for (ii=3D 0; ii < max; ii++) {=0A=
@@ -1002,11 +920,6 @@=0A=
 			/* Command found.=0A=
 			 */=0A=
 =0A=
-			/* Search pendingQ, if found,=0A=
-			 * delete from Q.=0A=
-			 */=0A=
-			mptscsih_search_pendingQ(hd, ii);=0A=
-=0A=
 			/* Null ScsiLookup index=0A=
 			 */=0A=
 			hd->ScsiLookup[ii] =3D NULL;=0A=
@@ -1019,18 +932,16 @@=0A=
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
@@ -1041,32 +952,7 @@=0A=
 			/* Free Message frames */=0A=
 			mpt_free_msg_frame(ioc, mf);=0A=
 =0A=
-#if 1=0A=
-			/* Post to doneQ, do not reply until POST phase=0A=
-			 * of reset handler....prevents new commands from=0A=
-			 * being queued.=0A=
-			 */=0A=
-			spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-			if (!Q_IS_EMPTY(&hd->freeQ)) {=0A=
-				buffer =3D hd->freeQ.head;=0A=
-				Q_DEL_ITEM(buffer);=0A=
-=0A=
-				/* Set the struct scsi_cmnd pointer=0A=
-				 */=0A=
-				buffer->argp =3D (void *)SCpnt;=0A=
-=0A=
-				/* Add to the doneQ=0A=
-				 */=0A=
-				Q_ADD_TAIL(&hd->doneQ.head, buffer, MPT_DONE_Q);=0A=
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-			} else {=0A=
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-				SCpnt->scsi_done(SCpnt);=0A=
-			}=0A=
-#else=0A=
 			SCpnt->scsi_done(SCpnt);	/* Issue the command callback */=0A=
-#endif=0A=
-=0A=
 		}=0A=
 	}=0A=
 =0A=
@@ -1173,7 +1059,6 @@=0A=
 	struct Scsi_Host	*sh;=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 	MPT_ADAPTER 		*ioc =3D pci_get_drvdata(pdev);=0A=
-	MPT_DONE_Q		*freedoneQ;=0A=
 	unsigned long		 flags;=0A=
 	int			 sz, ii;=0A=
 	int			 numSGE =3D 0;=0A=
@@ -1330,32 +1215,6 @@=0A=
 	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p, sz=3D%d\n",=0A=
 		 ioc->name, hd->ScsiLookup, sz));=0A=
 		=0A=
-	/* Allocate memory for free and doneQ's=0A=
-	 */=0A=
-	sz =3D sh->can_queue * sizeof(MPT_DONE_Q);=0A=
-	mem =3D kmalloc(sz, GFP_ATOMIC);=0A=
-	if (mem =3D=3D NULL) {=0A=
-		error =3D -ENOMEM;=0A=
-		goto mptscsih_probe_failed;=0A=
-	}=0A=
-=0A=
-	memset(mem, 0xFF, sz);=0A=
-	hd->memQ =3D mem;=0A=
-=0A=
-	/* Initialize the free, done and pending Qs.=0A=
-	 */=0A=
-	Q_INIT(&hd->freeQ, MPT_DONE_Q);=0A=
-	Q_INIT(&hd->doneQ, MPT_DONE_Q);=0A=
-	Q_INIT(&hd->pendingQ, MPT_DONE_Q);=0A=
-	spin_lock_init(&hd->freedoneQlock);=0A=
-=0A=
-	mem =3D hd->memQ;=0A=
-	for (ii=3D0; ii < sh->can_queue; ii++) {=0A=
-		freedoneQ =3D (MPT_DONE_Q *) mem;=0A=
-		Q_ADD_TAIL(&hd->freeQ.head, freedoneQ, MPT_DONE_Q);=0A=
-		mem +=3D sizeof(MPT_DONE_Q);=0A=
-	}=0A=
-=0A=
 	/* Initialize this Scsi_Host=0A=
 	 * internal task Q.=0A=
 	 */=0A=
@@ -1445,10 +1304,6 @@=0A=
 #ifndef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 		hd->negoNvram =3D MPT_SCSICFG_USE_NVRAM;=0A=
 #endif=0A=
-		if (driver_setup.dv =3D=3D 0) {=0A=
-			hd->negoNvram =3D MPT_SCSICFG_USE_NVRAM;=0A=
-		}=0A=
-=0A=
 		ioc->spi_data.forceDv =3D 0;=0A=
 		for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
 			ioc->spi_data.dvStatus[ii] =3D=0A=
@@ -1531,7 +1386,6 @@=0A=
 	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 	if (hd !=3D NULL) {=0A=
 		int sz1, sz3, sztarget=3D0;=0A=
-		int szQ =3D 0;=0A=
 =0A=
 		mptscsih_shutdown(&pdev->dev);=0A=
 =0A=
@@ -1543,12 +1397,6 @@=0A=
 			hd->ScsiLookup =3D NULL;=0A=
 		}=0A=
 =0A=
-		if (hd->memQ !=3D NULL) {=0A=
-			szQ =3D host->can_queue * sizeof(MPT_DONE_Q);=0A=
-			kfree(hd->memQ);=0A=
-			hd->memQ =3D NULL;=0A=
-		}=0A=
-=0A=
 		if (hd->Targets !=3D NULL) {=0A=
 			int max, ii;=0A=
 =0A=
@@ -1760,7 +1608,7 @@=0A=
  *=0A=
  *	Returns pointer to buffer where information was written.=0A=
  */=0A=
-const char *=0A=
+static const char *=0A=
 mptscsih_info(struct Scsi_Host *SChost)=0A=
 {=0A=
 	MPT_SCSI_HOST *h;=0A=
@@ -1975,7 +1823,8 @@=0A=
  * 	hostno: scsi host number=0A=
  *	func:   if write =3D 1; if read =3D 0=0A=
  */=0A=
-int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char =
**start, off_t offset,=0A=
+static int =0A=
+mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, =
off_t offset,=0A=
 			int length, int func)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
@@ -2010,15 +1859,13 @@=0A=
  *=0A=
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd =
*))=0A=
 {=0A=
 	MPT_SCSI_HOST		*hd;=0A=
 	MPT_FRAME_HDR		*mf;=0A=
 	SCSIIORequest_t		*pScsiReq;=0A=
 	VirtDevice		*pTarget;=0A=
-	MPT_DONE_Q		*buffer;=0A=
-	unsigned long		 flags;=0A=
 	int	 target;=0A=
 	int	 lun;=0A=
 	u32	 datalen;=0A=
@@ -2043,16 +1890,9 @@=0A=
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt, done));=0A=
 =0A=
 	if (hd->resetPending) {=0A=
-		/* Prevent new commands from being issued=0A=
-		 * while reloading the FW. Reset timer to 60 seconds,=0A=
-		 * as the FW can take some time to come ready.=0A=
-		 * For New EH, cmds on doneQ posted to FW.=0A=
-		 */=0A=
-		did_errcode =3D 1;=0A=
-		mod_timer(&SCpnt->eh_timeout, jiffies + (HZ * 60));=0A=
 		dtmprintk((MYIOC_s_WARN_FMT "qcmd: SCpnt=3D%p timeout + 60HZ\n",=0A=
 			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));=0A=
-		goto did_error;=0A=
+		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	}=0A=
 =0A=
 	/*=0A=
@@ -2061,8 +1901,7 @@=0A=
 	if ((mf =3D mpt_get_msg_frame(ScsiDoneCtx, hd->ioc)) =3D=3D NULL) =
{=0A=
 		dprintk((MYIOC_s_WARN_FMT "QueueCmd, no msg frames!!\n",=0A=
 				hd->ioc->name));=0A=
-		did_errcode =3D 2;=0A=
-		goto did_error;=0A=
+		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	}=0A=
 =0A=
 	pScsiReq =3D (SCSIIORequest_t *) mf;=0A=
@@ -2211,64 +2050,17 @@=0A=
 			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=3D%p =
idx=3D%d\n",=0A=
 					hd->ioc->name, SCpnt, mf, my_idx));=0A=
 			DBG_DUMP_REQUEST_FRAME(mf)=0A=
-		} else {=0A=
-			ddvtprintk((MYIOC_s_INFO_FMT "Pending cmd=3D%p idx %d\n",=0A=
-					hd->ioc->name, SCpnt, my_idx));=0A=
-			/* Place this command on the pendingQ if possible */=0A=
-			spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-			if (!Q_IS_EMPTY(&hd->freeQ)) {=0A=
-				buffer =3D hd->freeQ.head;=0A=
-				Q_DEL_ITEM(buffer);=0A=
-=0A=
-				/* Save the mf pointer=0A=
-				 */=0A=
-				buffer->argp =3D (void *)mf;=0A=
-=0A=
-				/* Add to the pendingQ=0A=
-				 */=0A=
-				Q_ADD_TAIL(&hd->pendingQ.head, buffer, MPT_DONE_Q);=0A=
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-			} else {=0A=
-				spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-				SCpnt->result =3D (DID_BUS_BUSY << 16);=0A=
-				SCpnt->scsi_done(SCpnt);=0A=
-			}=0A=
-		}=0A=
-	} else {=0A=
-		mptscsih_freeChainBuffers(hd->ioc, my_idx);=0A=
-		mpt_free_msg_frame(hd->ioc, mf);=0A=
-		did_errcode =3D 3;=0A=
-		goto did_error;=0A=
-	}=0A=
+		} else=0A=
+			goto fail;=0A=
+	} else=0A=
+		goto fail;=0A=
 =0A=
 	return 0;=0A=
 =0A=
-did_error:=0A=
-	dprintk((MYIOC_s_WARN_FMT "_qcmd did_errcode=3D%d (sc=3D%p)\n",=0A=
-			hd->ioc->name, did_errcode, SCpnt));=0A=
-	/* Just wish OS to issue a retry */=0A=
-	SCpnt->result =3D (DID_BUS_BUSY << 16);=0A=
-	spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-	if (!Q_IS_EMPTY(&hd->freeQ)) {=0A=
-		dtmprintk((MYIOC_s_WARN_FMT "SCpnt=3D%p to doneQ\n",=0A=
-			(hd && hd->ioc) ? hd->ioc->name : "ioc?", SCpnt));=0A=
-		buffer =3D hd->freeQ.head;=0A=
-		Q_DEL_ITEM(buffer);=0A=
-=0A=
-		/* Set the scsi_cmnd pointer=0A=
-		 */=0A=
-		buffer->argp =3D (void *)SCpnt;=0A=
-=0A=
-		/* Add to the doneQ=0A=
-		 */=0A=
-		Q_ADD_TAIL(&hd->doneQ.head, buffer, MPT_DONE_Q);=0A=
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-	} else {=0A=
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-		SCpnt->scsi_done(SCpnt);=0A=
-	}=0A=
-=0A=
-	return 0;=0A=
+ fail:=0A=
+	mptscsih_freeChainBuffers(hd->ioc, my_idx);=0A=
+	mpt_free_msg_frame(hd->ioc, mf);=0A=
+	return SCSI_MLQUEUE_HOST_BUSY;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -2551,10 +2343,11 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_abort(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
+	MPT_ADAPTER	*ioc;=0A=
 	MPT_FRAME_HDR	*mf;=0A=
 	u32		 ctx2abort;=0A=
 	int		 scpnt_idx;=0A=
@@ -2571,6 +2364,7 @@=0A=
 		return FAILED;=0A=
 	}=0A=
 =0A=
+	ioc =3D hd->ioc;=0A=
 	if (hd->resetPending)=0A=
 		return FAILED;=0A=
 =0A=
@@ -2583,11 +2377,9 @@=0A=
 	/* Find this command=0A=
 	 */=0A=
 	if ((scpnt_idx =3D SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {=0A=
-		/* Cmd not found in ScsiLookup. If found in=0A=
-		 * doneQ, delete from Q. Do OS callback.=0A=
+		/* Cmd not found in ScsiLookup. =0A=
+		 * Do OS callback.=0A=
 		 */=0A=
-		search_doneQ_for_cmd(hd, SCpnt);=0A=
-=0A=
 		SCpnt->result =3D DID_RESET << 16;=0A=
 		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "=0A=
 			   "Command not in the active list! (sc=3D%p)\n",=0A=
@@ -2595,18 +2387,6 @@=0A=
 		return SUCCESS;=0A=
 	}=0A=
 =0A=
-	/* If this command is pended, then timeout/hang occurred=0A=
-	 * during DV. Post command and flush pending Q=0A=
-	 * and then following up with the reset request.=0A=
-	 */=0A=
-	if ((mf =3D mptscsih_search_pendingQ(hd, scpnt_idx)) !=3D NULL) {=0A=
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
-		post_pendingQ_commands(hd);=0A=
-		dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_abort: "=0A=
-			   "Posting pended cmd! (sc=3D%p)\n",=0A=
-			   hd->ioc->name, SCpnt));=0A=
-	}=0A=
-=0A=
 	/* Most important!  Set TaskMsgContext to SCpnt's MsgContext!=0A=
 	 * (the IO to be ABORT'd)=0A=
 	 *=0A=
@@ -2635,12 +2415,26 @@=0A=
 		 */=0A=
 		hd->tmPending =3D 0;=0A=
 		hd->tmState =3D TM_STATE_NONE;=0A=
-=0A=
+		=0A=
 		spin_lock_irq(host_lock);=0A=
+=0A=
+		/* Unmap the DMA buffers, if any. */=0A=
+		if (SCpnt->use_sg) {=0A=
+			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) =
SCpnt->request_buffer,=0A=
+				    SCpnt->use_sg, SCpnt->sc_data_direction);=0A=
+		} else if (SCpnt->request_bufflen) {=0A=
+			pci_unmap_single(ioc->pcidev, SCpnt->SCp.dma_handle,=0A=
+				SCpnt->request_bufflen, SCpnt->sc_data_direction);=0A=
+		}=0A=
+		hd->ScsiLookup[scpnt_idx] =3D NULL;=0A=
+		SCpnt->result =3D DID_RESET << 16;=0A=
+		SCpnt->scsi_done(SCpnt);		/* Issue the command callback */=0A=
+		mptscsih_freeChainBuffers(ioc, scpnt_idx);=0A=
+		mpt_free_msg_frame(ioc, mf);=0A=
 		return FAILED;=0A=
 	}=0A=
 	spin_lock_irq(host_lock);=0A=
-	return FAILED;=0A=
+	return SUCCESS;=0A=
 =0A=
 }=0A=
 =0A=
@@ -2653,7 +2447,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2708,7 +2502,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_bus_reset(struct scsi_cmnd * SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST	*hd;=0A=
@@ -2760,7 +2554,7 @@=0A=
  *=0A=
  *	Returns SUCCESS or FAILED.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)=0A=
 {=0A=
 	MPT_SCSI_HOST *  hd;=0A=
@@ -2919,7 +2713,6 @@=0A=
 			dtmprintk((MYIOC_s_WARN_FMT " TaskMgmt SUCCESS\n", ioc->name));=0A=
 =0A=
 			hd->abortSCpnt =3D NULL;=0A=
-			flush_doneQ(hd);=0A=
 =0A=
 		}=0A=
 	}=0A=
@@ -2937,7 +2730,7 @@=0A=
 /*=0A=
  *	This is anyones guess quite frankly.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_bios_param(struct scsi_device * sdev, struct block_device =
*bdev,=0A=
 		sector_t capacity, int geom[])=0A=
 {=0A=
@@ -2984,7 +2777,7 @@=0A=
  *	Return non-zero if allocation fails.=0A=
  *	Init memory once per id (not LUN).=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_slave_alloc(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
@@ -3033,7 +2826,7 @@=0A=
  *	OS entry point to allow for host driver to free allocated memory=0A=
  *	Called if no device present or device being unloaded=0A=
  */=0A=
-void=0A=
+static void=0A=
 mptscsih_slave_destroy(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
@@ -3098,7 +2891,7 @@=0A=
  *	member to 1 if a device does not support Q tags.=0A=
  *	Return non-zero if fails.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mptscsih_slave_configure(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*sh =3D device->host;=0A=
@@ -3257,102 +3050,6 @@=0A=
 	return -1;=0A=
 }=0A=
 =0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/* Search the pendingQ for a command with specific index.=0A=
- * If found, delete and return mf pointer=0A=
- * If not found, return NULL=0A=
- */=0A=
-static MPT_FRAME_HDR *=0A=
-mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int scpnt_idx)=0A=
-{=0A=
-	unsigned long	 flags;=0A=
-	MPT_DONE_Q	*buffer;=0A=
-	MPT_FRAME_HDR	*mf =3D NULL;=0A=
-	MPT_FRAME_HDR	*cmdMfPtr;=0A=
-=0A=
-	ddvtprintk((MYIOC_s_INFO_FMT ": search_pendingQ ...", =
hd->ioc->name));=0A=
-	cmdMfPtr =3D MPT_INDEX_2_MFPTR(hd->ioc, scpnt_idx);=0A=
-	spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-	if (!Q_IS_EMPTY(&hd->pendingQ)) {=0A=
-		buffer =3D hd->pendingQ.head;=0A=
-		do {=0A=
-			mf =3D (MPT_FRAME_HDR *) buffer->argp;=0A=
-			if (mf =3D=3D cmdMfPtr) {=0A=
-				Q_DEL_ITEM(buffer);=0A=
-=0A=
-				/* clear the arg pointer=0A=
-				 */=0A=
-				buffer->argp =3D NULL;=0A=
-=0A=
-				/* Add to the freeQ=0A=
-				 */=0A=
-				Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);=0A=
-				break;=0A=
-			}=0A=
-			mf =3D NULL;=0A=
-		} while ((buffer =3D buffer->forw) !=3D (MPT_DONE_Q *) =
&hd->pendingQ);=0A=
-	}=0A=
-	spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-	ddvtprintk((" ...return %p\n", mf));=0A=
-	return mf;=0A=
-}=0A=
-=0A=
-/* Post all commands on the pendingQ to the FW.=0A=
- * Lock Q when deleting/adding members=0A=
- * Lock io_request_lock for OS callback.=0A=
- */=0A=
-static void=0A=
-post_pendingQ_commands(MPT_SCSI_HOST *hd)=0A=
-{=0A=
-	MPT_FRAME_HDR	*mf;=0A=
-	MPT_DONE_Q	*buffer;=0A=
-	unsigned long	 flags;=0A=
-=0A=
-	/* Flush the pendingQ.=0A=
-	 */=0A=
-	ddvtprintk((MYIOC_s_INFO_FMT ": post_pendingQ_commands\n", =
hd->ioc->name));=0A=
-	while (1) {=0A=
-		spin_lock_irqsave(&hd->freedoneQlock, flags);=0A=
-		if (Q_IS_EMPTY(&hd->pendingQ)) {=0A=
-			spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-			break;=0A=
-		}=0A=
-=0A=
-		buffer =3D hd->pendingQ.head;=0A=
-		/* Delete from Q=0A=
-		 */=0A=
-		Q_DEL_ITEM(buffer);=0A=
-=0A=
-		mf =3D (MPT_FRAME_HDR *) buffer->argp;=0A=
-		buffer->argp =3D NULL;=0A=
-=0A=
-		/* Add to the freeQ=0A=
-		 */=0A=
-		Q_ADD_TAIL(&hd->freeQ.head, buffer, MPT_DONE_Q);=0A=
-		spin_unlock_irqrestore(&hd->freedoneQlock, flags);=0A=
-=0A=
-		if (!mf) {=0A=
-			/* This should never happen */=0A=
-			printk(MYIOC_s_WARN_FMT "post_pendingQ_commands: mf %p\n", =
hd->ioc->name, (void *) mf);=0A=
-			continue;=0A=
-		}=0A=
-=0A=
-		mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
-=0A=
-#if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)=0A=
-		{=0A=
-			u16		 req_idx =3D =
le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
-			struct scsi_cmnd	*sc =3D hd->ScsiLookup[req_idx];=0A=
-			printk(MYIOC_s_INFO_FMT "Issued SCSI cmd (sc=3D%p) idx=3D%d =
(mf=3D%p)\n",=0A=
-					hd->ioc->name, sc, req_idx, mf);=0A=
-		}=0A=
-#endif=0A=
-	}=0A=
-=0A=
-	return;=0A=
-}=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 static int=0A=
 mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)=0A=
@@ -3472,11 +3169,7 @@=0A=
 			hd->cmdPtr =3D NULL;=0A=
 		}=0A=
 =0A=
-		/* 7. Flush doneQ=0A=
-		 */=0A=
-		flush_doneQ(hd);=0A=
-=0A=
-		/* 8. Set flag to force DV and re-read IOC Page 3=0A=
+		/* 7. Set flag to force DV and re-read IOC Page 3=0A=
 		 */=0A=
 		if (hd->is_spi) {=0A=
 			ioc->spi_data.forceDv =3D MPT_SCSICFG_NEED_DV | =
MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
@@ -3743,7 +3436,8 @@=0A=
  *  the Inquiry data, adapter capabilities, and NVRAM settings.=0A=
  *=0A=
  */=0A=
-void mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice =
*target, char byte56)=0A=
+static void=0A=
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtDevice *target, =
char byte56)=0A=
 {=0A=
 	ScsiCfgData *pspi_data =3D &hd->ioc->spi_data;=0A=
 	int  id =3D (int) target->target_id;=0A=
@@ -5175,11 +4869,6 @@=0A=
 						}=0A=
 					}=0A=
 =0A=
-					/* Post OS IOs that were pended while=0A=
-					 * DV running.=0A=
-					 */=0A=
-					post_pendingQ_commands(hd);=0A=
-=0A=
 					if (hd->ioc->spi_data.noQas)=0A=
 						mptscsih_qas_check(hd, id);=0A=
 				}=0A=
@@ -5712,6 +5401,10 @@=0A=
 		}=0A=
 	}=0A=
 	ddvprintk((MYIOC_s_NOTE_FMT "DV: Basic test on id=3D%d completed =
OK.\n", ioc->name, id));=0A=
+=0A=
+	if (driver_setup.dv =3D=3D 0)=0A=
+		goto target_done;=0A=
+=0A=
 	inq0 =3D (*pbuf1) & 0x1F;=0A=
 =0A=
 	/* Continue only for disks=0A=

------_=_NextPart_000_01C485FB.779E8720--
