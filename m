From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion dead code removal
Date: Tue, 21 Sep 2004 12:57:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57050F7ECA@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C49FFC.0DEC2010"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:25793 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267856AbUIUQ5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:57:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C49FFC.0DEC2010
Content-Type: text/plain;
	charset="iso-8859-1"

The previous patch sent a couple weeks ago called "[PATCH] switch fusion
to use <linux/list.h> everywhere" is fine. Please ask James to apply.

However.. In this patch we have concerns over removing the MPTSTM target
mode
support. We request that the MPTSTM code remains for now. We will
investigate
into what would need to do to support using the generic scsi target midlayer
interface.  Here attached is a patch that has MPTSTM backed out, however we
are in the progress of validating this code, so please review but not apply.


On Monday, September 20, 2004 9:33 AM, Christoph Hellwig wrote:
> 
> This patch (ontop of the patch to use <linux/list.>) removes lots of
> dead code from the fusion driver, mostly related to the 
> orphaned dmp and
> target drivers.
> 
> 
> diff -ur scsi-misc-2.6/drivers/message/fusion.orig/mptbase.c 
> scsi-misc-2.6/drivers/message/fusion/mptbase.c
> --- scsi-misc-2.6/drivers/message/fusion.orig/mptbase.c	
> 2004-09-19 16:38:15.937614000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	
> 2004-09-19 16:50:51.318779320 +0200
> @@ -133,12 +133,9 @@
>   *  Public data...
>   */
>  int mpt_lan_index = -1;
> -int mpt_stm_index = -1;
>  
>  struct proc_dir_entry *mpt_proc_root_dir;
>  
> -DmpServices_t *DmpService;
> -
>  #define WHOINIT_UNKNOWN		0xAA
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
> @@ -169,7 +166,9 @@
>   */
>  static irqreturn_t mpt_interrupt(int irq, void *bus_id, 
> struct pt_regs *r);
>  static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR 
> *req, MPT_FRAME_HDR *reply);
> -
> +static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, 
> int reqBytes,
> +			u32 *req, int replyBytes, u16 
> *u16reply, int maxwait,
> +			int sleepFlag);
>  static int	mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 
> reason, int sleepFlag);
>  static void	mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct 
> pci_dev *pdev);
>  static void	mpt_adapter_disable(MPT_ADAPTER *ioc);
> @@ -354,11 +353,7 @@
>  			 */
>  			dmfprintk((MYIOC_s_INFO_FMT "Got TURBO 
> reply req_idx=%08x\n", ioc->name, pa));
>  			type = (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT);
> -			if (type == 
> MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET) {
> -				cb_idx = mpt_stm_index;
> -				mf = NULL;
> -				mr = (MPT_FRAME_HDR *) 
> CAST_U32_TO_PTR(pa);
> -			} else if (type == MPI_CONTEXT_REPLY_TYPE_LAN) {
> +			if (type == MPI_CONTEXT_REPLY_TYPE_LAN) {
>  				cb_idx = mpt_lan_index;
>  				/*
>  				 * BUG FIX!  20001218 -sralston
> @@ -958,41 +953,6 @@
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
>  /**
> - *	mpt_add_chain - Place a chain SGE at address pAddr.
> - *	@pAddr: virtual address for SGE
> - *	@next: nextChainOffset value (u32's)
> - *	@length: length of next SGL segment
> - *	@dma_addr: Physical address
> - *
> - *	This routine places a MPT request frame back on the MPT 
> adapter's
> - *	FreeQ.
> - */
> -void
> -mpt_add_chain(char *pAddr, u8 next, u16 length, dma_addr_t dma_addr)
> -{
> -	if (sizeof(dma_addr_t) == sizeof(u64)) {
> -		SGEChain64_t *pChain = (SGEChain64_t *) pAddr;
> -		u32 tmp = dma_addr & 0xFFFFFFFF;
> -
> -		pChain->Length = cpu_to_le16(length);
> -		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT | 
> mpt_addr_size();
> -
> -		pChain->NextChainOffset = next;
> -
> -		pChain->Address.Low = cpu_to_le32(tmp);
> -		tmp = (u32) ((u64)dma_addr >> 32);
> -		pChain->Address.High = cpu_to_le32(tmp);
> -	} else {
> -		SGEChain32_t *pChain = (SGEChain32_t *) pAddr;
> -		pChain->Length = cpu_to_le16(length);
> -		pChain->Flags = MPI_SGE_FLAGS_CHAIN_ELEMENT | 
> mpt_addr_size();
> -		pChain->NextChainOffset = next;
> -		pChain->Address = cpu_to_le32(dma_addr);
> -	}
> -}
> -
> -/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> -=-=-=-=-=-=-=-=*/
> -/**
>   *	mpt_send_handshake_request - Send MPT request via doorbell
>   *	handshake method.
>   *	@handle: Handle of registered MPT protocol driver
> @@ -3690,7 +3650,7 @@
>   *
>   *	Returns 0 for success, non-zero for failure.
>   */
> -int
> +static int
>  mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, 
> u32 *req,
>  				int replyBytes, u16 *u16reply, 
> int maxwait, int sleepFlag)
>  {
> @@ -5231,15 +5191,9 @@
>  			case MPTLAN_DRIVER:
>  				if (!lan++) drvname = "LAN";
>  				break;
> -			case MPTSTM_DRIVER:
> -				if (!targ++) drvname = "SCSI target";
> -				break;
>  			case MPTCTL_DRIVER:
>  				if (!ctl++) drvname = "ioctl";
>  				break;
> -			case MPTDMP_DRIVER:
> -				if (!dmp++) drvname = "DMP";
> -				break;
>  			}
>  
>  			if (drvname)
> @@ -5920,7 +5874,6 @@
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
>  EXPORT_SYMBOL(ioc_list);
>  EXPORT_SYMBOL(mpt_proc_root_dir);
> -EXPORT_SYMBOL(DmpService);
>  EXPORT_SYMBOL(mpt_register);
>  EXPORT_SYMBOL(mpt_deregister);
>  EXPORT_SYMBOL(mpt_event_register);
> @@ -5933,14 +5886,11 @@
>  EXPORT_SYMBOL(mpt_put_msg_frame);
>  EXPORT_SYMBOL(mpt_free_msg_frame);
>  EXPORT_SYMBOL(mpt_add_sge);
> -EXPORT_SYMBOL(mpt_add_chain);
>  EXPORT_SYMBOL(mpt_send_handshake_request);
> -EXPORT_SYMBOL(mpt_handshake_req_reply_wait);
>  EXPORT_SYMBOL(mpt_verify_adapter);
>  EXPORT_SYMBOL(mpt_GetIocState);
>  EXPORT_SYMBOL(mpt_print_ioc_summary);
>  EXPORT_SYMBOL(mpt_lan_index);
> -EXPORT_SYMBOL(mpt_stm_index);
>  EXPORT_SYMBOL(mpt_HardResetHandler);
>  EXPORT_SYMBOL(mpt_config);
>  EXPORT_SYMBOL(mpt_toolbox);
> @@ -5990,8 +5940,6 @@
>  		MptResetHandlers[i] = NULL;
>  	}
>  
> -	DmpService = NULL;
> -
>  	/* NEW!  20010120 -sralston
>  	 *  Register ourselves (mptbase) in order to facilitate
>  	 *  EventNotification handling.
> diff -ur scsi-misc-2.6/drivers/message/fusion.orig/mptbase.h 
> scsi-misc-2.6/drivers/message/fusion/mptbase.h
> --- scsi-misc-2.6/drivers/message/fusion.orig/mptbase.h	
> 2004-09-19 16:38:15.945613000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	
> 2004-09-19 16:49:57.945893232 +0200
> @@ -205,8 +205,6 @@
>  	MPTCTL_DRIVER,		/* MPT ioctl class */
>  	MPTSCSIH_DRIVER,	/* MPT SCSI host (initiator) class */
>  	MPTLAN_DRIVER,		/* MPT LAN class */
> -	MPTSTM_DRIVER,		/* MPT SCSI target mode class */
> -	MPTDMP_DRIVER,		/* MPT Dynamic Multi-pathing class */
>  	MPTUNKNOWN_DRIVER
>  } MPT_DRIVER_CLASS;
>  
> @@ -348,27 +346,6 @@
>  /*
>   *	Dynamic Multi-Pathing specific stuff...
>   */
> -#define DMP_MAX_PATHS	8
> -
> -typedef struct _PathInfo {
> -	u8		 ioc;
> -	u8		 target;
> -	u8		 pad;
> -	u8		 pflags;
> -} PathInfo;
> -
> -#define PATHINFO_FLAGS_OWNED		0x01
> -#define PATHINFO_FLAGS_EXISTS		0x02
> -#define PATHINFO_FLAGS_AVAILABLE	0x04
> -#define PATHINFO_FLAGS_SECONDARY	0x08
> -
> -#define PFLAGS_EXISTS_AND_AVAIL		
> (PATHINFO_FLAGS_EXISTS|PATHINFO_FLAGS_AVAILABLE)
> -#define PFLAGS_AVAIL_AND_OWNED		
> (PATHINFO_FLAGS_AVAILABLE|PATHINFO_FLAGS_OWNED)
> -
> -typedef struct _ScsiCmndTracker {
> -	void			*head;
> -	void			*tail;
> -} ScsiCmndTracker;
>  
>  /* VirtDevice negoFlags field */
>  #define MPT_TARGET_NO_NEGO_WIDE		0x01
> @@ -378,12 +355,9 @@
>  
>  /*
>   *	VirtDevice - FC LUN device or SCSI target device
> - *	(used to be FCSCSI_TARGET)
>   */
>  typedef struct _VirtDevice {
>  	struct scsi_device	*device;
> -	rwlock_t		 VdevLock;
> -	int			 ref_cnt;
>  	u8			 tflags;
>  	u8			 ioc_id;
>  	u8			 target_id;
> @@ -396,14 +370,8 @@
>  	u8			 type;		/* byte 0 of 
> Inquiry data */
>  	u8			 cflags;	/* controller flags */
>  	u8			 rsvd1raid;
> -	int			 npaths;
>  	u16			 fc_phys_lun;
>  	u16			 fc_xlat_lun;
> -	int			 stall_detected;
> -	PathInfo		 path[DMP_MAX_PATHS];
> -	struct timer_list	 stall_timer;
> -	struct timer_list	 retry_timer;
> -	struct timer_list	 gone_timer;
>  	u32			 num_luns;
>  	u32			 luns[8];		/* Max 
> LUNs is 256 */
>  	u8			 pad[4];
> @@ -427,14 +395,6 @@
>  #define MPT_TARGET_FLAGS_VALID_56	0x10
>  #define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20
>  
> -typedef struct _VirtDevTracker {
> -	struct _VirtDevice	*head;
> -	struct _VirtDevice	*tail;
> -	rwlock_t		 VlistLock;
> -	int			 pad;
> -} VirtDevTracker;
> -
> -
>  /*
>   *	/proc/mpt interface
>   */
> @@ -648,12 +608,6 @@
>  	struct net_device	*netdev;
>  } MPT_ADAPTER;
>  
> -
> -typedef struct _MPT_ADAPTER_TRACKER {
> -	MPT_ADAPTER	*head;
> -	MPT_ADAPTER	*tail;
> -} MPT_ADAPTER_TRACKER;
> -
>  /*
>   *  New return value convention:
>   *    1 = Ok to free associated request frame
> @@ -875,13 +829,6 @@
>  #define MPT_INDEX_2_RFPTR(ioc,idx) \
>  	(MPT_FRAME_HDR*)( (u8*)(ioc)->reply_frames + 
> (ioc)->req_sz * (idx) )
>  
> -#define SWAB4(value) \
> -	(u32)(   (((value) & 0x000000ff) << 24) \
> -	       | (((value) & 0x0000ff00) << 8)  \
> -	       | (((value) & 0x00ff0000) >> 8)  \
> -	       | (((value) & 0xff000000) >> 24) )
> -
> -
>  #if defined(MPT_DEBUG) || defined(MPT_DEBUG_MSG_FRAME)
>  #define DBG_DUMP_REPLY_FRAME(mfp) \
>  	{	u32 *m = (u32 *)(mfp);				
> 	\
> @@ -966,7 +913,6 @@
>  	u8			  resetPending;
>  	u8			  is_spi;		/* 
> Parallel SCSI i/f */
>  	u8			  negoNvram;		/* DV 
> disabled, nego NVRAM */
> -	u8			  is_multipath;		/* 
> Multi-path compatible */
>  	u8                        tmState;
>  	u8			  rsvd[2];
>  	MPT_FRAME_HDR		 *tmPtr;		/* Ptr 
> to TM request*/
> @@ -987,26 +933,6 @@
>  /* Forward decl, a strange C thing, to prevent gcc compiler 
> warnings */
>  struct scsi_cmnd;
>  
> -/*
> - *	DMP service layer structure / API interface
> - */
> -typedef struct _DmpServices {
> -	VirtDevTracker	  VdevList;
> -	struct semaphore *Daemon;
> -	int		(*ScsiPathSelect)
> -				(struct scsi_cmnd *, 
> MPT_SCSI_HOST **hd, int *target, int *lun);
> -	int		(*DmpIoDoneChk)
> -				(MPT_SCSI_HOST *, struct scsi_cmnd *,
> -				 SCSIIORequest_t *,
> -				 SCSIIOReply_t *);
> -	void		(*mptscsih_scanVlist)
> -				(MPT_SCSI_HOST *, int portnum);
> -	int		(*ScsiAbort)
> -				(struct scsi_cmnd *);
> -	int		(*ScsiBusReset)
> -				(struct scsi_cmnd *);
> -} DmpServices_t;
> -
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
>  /*
>   * Generic structure passed to the base mpt_config function.
> @@ -1042,10 +968,8 @@
>  extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, 
> MPT_FRAME_HDR *mf);
>  extern void	 mpt_put_msg_frame(int handle, MPT_ADAPTER 
> *ioc, MPT_FRAME_HDR *mf);
>  extern void	 mpt_add_sge(char *pAddr, u32 flagslength, 
> dma_addr_t dma_addr);
> -extern void	 mpt_add_chain(char *pAddr, u8 next, u16 
> length, dma_addr_t dma_addr);
>  
>  extern int	 mpt_send_handshake_request(int handle, 
> MPT_ADAPTER *ioc, int reqBytes, u32 *req, int sleepFlag);
> -extern int	 mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, 
> int reqBytes, u32 *req, int replyBytes, u16 *u16reply, int 
> maxwait, int sleepFlag);
>  extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);
>  extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
>  extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char 
> *buf, int *size, int len, int showlan);
> @@ -1062,21 +986,12 @@
>   */
>  extern struct list_head	  ioc_list;
>  extern struct proc_dir_entry	*mpt_proc_root_dir;
> -extern DmpServices_t		*DmpService;
>  
>  extern int		  mpt_lan_index;	/* needed by mptlan.c */
> -extern int		  mpt_stm_index;	/* needed by mptstm.c */
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
>  #endif		/* } __KERNEL__ */
>  
> -/*
> - *  More (public) macros...
> - */
> -#ifndef offsetof
> -#define offsetof(t, m)	((size_t) (&((t *)0)->m))
> -#endif
> -
>  #if defined(__alpha__) || defined(__sparc_v9__) || 
> defined(__ia64__) || defined(__x86_64__)
>  #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
>  #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
> diff -ur scsi-misc-2.6/drivers/message/fusion.orig/mptscsih.c 
> scsi-misc-2.6/drivers/message/fusion/mptscsih.c
> --- scsi-misc-2.6/drivers/message/fusion.orig/mptscsih.c	
> 2004-09-19 16:38:15.964610000 +0200
> +++ scsi-misc-2.6/drivers/message/fusion/mptscsih.c	
> 2004-09-19 16:41:02.865237856 +0200
> @@ -1192,12 +1192,7 @@
>  	hd->ioc = ioc;
>  
>  	if ((int)ioc->chip_type > (int)FC929)
> -	hd->is_spi = 1;
> -
> -	if (DmpService && (ioc->chip_type == FC919 ||
> -	  ioc->chip_type == FC929)) {
> -		hd->is_multipath = 1;
> -	}
> +		hd->is_spi = 1;
>  
>  	/* SCSI needs scsi_cmnd lookup table!
>  	 * (with size equal to req_depth*PtrSz!)
> @@ -2787,7 +2782,6 @@
>  			return -ENOMEM;
>  		} else {
>  			memset(vdev, 0, sizeof(VirtDevice));
> -			rwlock_init(&vdev->VdevLock);
>  			vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
>  			vdev->ioc_id = hd->ioc->id;
>  			vdev->target_id = device->id;
> @@ -2983,8 +2977,6 @@
>  	pReq = (SCSIIORequest_t *) mf;
>  	index = (int) pReq->TargetID;
>  	target = hd->Targets[index];
> -	if (hd->is_multipath && sc->device->hostdata)
> -		target = (VirtDevice *) sc->device->hostdata;
>  
>  	if (sense_count) {
>  		u8 *sense_data;
> 


------_=_NextPart_000_01C49FFC.0DEC2010
Content-Type: application/octet-stream;
	name="diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="diff"

diff -uarN b/message/fusion/mptbase.c a/message/fusion/mptbase.c=0A=
--- b/message/fusion/mptbase.c	2004-09-09 16:13:19.000000000 -0600=0A=
+++ a/message/fusion/mptbase.c	2004-09-20 15:42:02.000000000 -0600=0A=
@@ -137,8 +137,6 @@=0A=
 =0A=
 struct proc_dir_entry *mpt_proc_root_dir;=0A=
 =0A=
-DmpServices_t *DmpService;=0A=
-=0A=
 #define WHOINIT_UNKNOWN		0xAA=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -169,7 +167,9 @@=0A=
  */=0A=
 static irqreturn_t mpt_interrupt(int irq, void *bus_id, struct pt_regs =
*r);=0A=
 static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, =
MPT_FRAME_HDR *reply);=0A=
-=0A=
+static int	mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int =
reqBytes,=0A=
+			u32 *req, int replyBytes, u16 *u16reply, int maxwait,=0A=
+			int sleepFlag);=0A=
 static int	mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int =
sleepFlag);=0A=
 static void	mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct pci_dev =
*pdev);=0A=
 static void	mpt_adapter_disable(MPT_ADAPTER *ioc);=0A=
@@ -958,41 +958,6 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
- *	mpt_add_chain - Place a chain SGE at address pAddr.=0A=
- *	@pAddr: virtual address for SGE=0A=
- *	@next: nextChainOffset value (u32's)=0A=
- *	@length: length of next SGL segment=0A=
- *	@dma_addr: Physical address=0A=
- *=0A=
- *	This routine places a MPT request frame back on the MPT =
adapter's=0A=
- *	FreeQ.=0A=
- */=0A=
-void=0A=
-mpt_add_chain(char *pAddr, u8 next, u16 length, dma_addr_t =
dma_addr)=0A=
-{=0A=
-	if (sizeof(dma_addr_t) =3D=3D sizeof(u64)) {=0A=
-		SGEChain64_t *pChain =3D (SGEChain64_t *) pAddr;=0A=
-		u32 tmp =3D dma_addr & 0xFFFFFFFF;=0A=
-=0A=
-		pChain->Length =3D cpu_to_le16(length);=0A=
-		pChain->Flags =3D MPI_SGE_FLAGS_CHAIN_ELEMENT | mpt_addr_size();=0A=
-=0A=
-		pChain->NextChainOffset =3D next;=0A=
-=0A=
-		pChain->Address.Low =3D cpu_to_le32(tmp);=0A=
-		tmp =3D (u32) ((u64)dma_addr >> 32);=0A=
-		pChain->Address.High =3D cpu_to_le32(tmp);=0A=
-	} else {=0A=
-		SGEChain32_t *pChain =3D (SGEChain32_t *) pAddr;=0A=
-		pChain->Length =3D cpu_to_le16(length);=0A=
-		pChain->Flags =3D MPI_SGE_FLAGS_CHAIN_ELEMENT | mpt_addr_size();=0A=
-		pChain->NextChainOffset =3D next;=0A=
-		pChain->Address =3D cpu_to_le32(dma_addr);=0A=
-	}=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/**=0A=
  *	mpt_send_handshake_request - Send MPT request via doorbell=0A=
  *	handshake method.=0A=
  *	@handle: Handle of registered MPT protocol driver=0A=
@@ -3690,7 +3655,7 @@=0A=
  *=0A=
  *	Returns 0 for success, non-zero for failure.=0A=
  */=0A=
-int=0A=
+static int=0A=
 mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int reqBytes, u32 =
*req,=0A=
 				int replyBytes, u16 *u16reply, int maxwait, int sleepFlag)=0A=
 {=0A=
@@ -5237,9 +5202,6 @@=0A=
 			case MPTCTL_DRIVER:=0A=
 				if (!ctl++) drvname =3D "ioctl";=0A=
 				break;=0A=
-			case MPTDMP_DRIVER:=0A=
-				if (!dmp++) drvname =3D "DMP";=0A=
-				break;=0A=
 			}=0A=
 =0A=
 			if (drvname)=0A=
@@ -5920,7 +5882,6 @@=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 EXPORT_SYMBOL(ioc_list);=0A=
 EXPORT_SYMBOL(mpt_proc_root_dir);=0A=
-EXPORT_SYMBOL(DmpService);=0A=
 EXPORT_SYMBOL(mpt_register);=0A=
 EXPORT_SYMBOL(mpt_deregister);=0A=
 EXPORT_SYMBOL(mpt_event_register);=0A=
@@ -5933,9 +5894,7 @@=0A=
 EXPORT_SYMBOL(mpt_put_msg_frame);=0A=
 EXPORT_SYMBOL(mpt_free_msg_frame);=0A=
 EXPORT_SYMBOL(mpt_add_sge);=0A=
-EXPORT_SYMBOL(mpt_add_chain);=0A=
 EXPORT_SYMBOL(mpt_send_handshake_request);=0A=
-EXPORT_SYMBOL(mpt_handshake_req_reply_wait);=0A=
 EXPORT_SYMBOL(mpt_verify_adapter);=0A=
 EXPORT_SYMBOL(mpt_GetIocState);=0A=
 EXPORT_SYMBOL(mpt_print_ioc_summary);=0A=
@@ -5990,8 +5949,6 @@=0A=
 		MptResetHandlers[i] =3D NULL;=0A=
 	}=0A=
 =0A=
-	DmpService =3D NULL;=0A=
-=0A=
 	/* NEW!  20010120 -sralston=0A=
 	 *  Register ourselves (mptbase) in order to facilitate=0A=
 	 *  EventNotification handling.=0A=
diff -uarN b/message/fusion/mptbase.h a/message/fusion/mptbase.h=0A=
--- b/message/fusion/mptbase.h	2004-09-09 16:13:19.000000000 -0600=0A=
+++ a/message/fusion/mptbase.h	2004-09-20 16:03:01.000000000 -0600=0A=
@@ -83,8 +83,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.16"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.16"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.17"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.17"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -206,7 +206,6 @@=0A=
 	MPTSCSIH_DRIVER,	/* MPT SCSI host (initiator) class */=0A=
 	MPTLAN_DRIVER,		/* MPT LAN class */=0A=
 	MPTSTM_DRIVER,		/* MPT SCSI target mode class */=0A=
-	MPTDMP_DRIVER,		/* MPT Dynamic Multi-pathing class */=0A=
 	MPTUNKNOWN_DRIVER=0A=
 } MPT_DRIVER_CLASS;=0A=
 =0A=
@@ -348,27 +347,6 @@=0A=
 /*=0A=
  *	Dynamic Multi-Pathing specific stuff...=0A=
  */=0A=
-#define DMP_MAX_PATHS	8=0A=
-=0A=
-typedef struct _PathInfo {=0A=
-	u8		 ioc;=0A=
-	u8		 target;=0A=
-	u8		 pad;=0A=
-	u8		 pflags;=0A=
-} PathInfo;=0A=
-=0A=
-#define PATHINFO_FLAGS_OWNED		0x01=0A=
-#define PATHINFO_FLAGS_EXISTS		0x02=0A=
-#define PATHINFO_FLAGS_AVAILABLE	0x04=0A=
-#define PATHINFO_FLAGS_SECONDARY	0x08=0A=
-=0A=
-#define PFLAGS_EXISTS_AND_AVAIL		=
(PATHINFO_FLAGS_EXISTS|PATHINFO_FLAGS_AVAILABLE)=0A=
-#define PFLAGS_AVAIL_AND_OWNED		=
(PATHINFO_FLAGS_AVAILABLE|PATHINFO_FLAGS_OWNED)=0A=
-=0A=
-typedef struct _ScsiCmndTracker {=0A=
-	void			*head;=0A=
-	void			*tail;=0A=
-} ScsiCmndTracker;=0A=
 =0A=
 /* VirtDevice negoFlags field */=0A=
 #define MPT_TARGET_NO_NEGO_WIDE		0x01=0A=
@@ -378,12 +356,9 @@=0A=
 =0A=
 /*=0A=
  *	VirtDevice - FC LUN device or SCSI target device=0A=
- *	(used to be FCSCSI_TARGET)=0A=
  */=0A=
 typedef struct _VirtDevice {=0A=
 	struct scsi_device	*device;=0A=
-	rwlock_t		 VdevLock;=0A=
-	int			 ref_cnt;=0A=
 	u8			 tflags;=0A=
 	u8			 ioc_id;=0A=
 	u8			 target_id;=0A=
@@ -396,14 +371,8 @@=0A=
 	u8			 type;		/* byte 0 of Inquiry data */=0A=
 	u8			 cflags;	/* controller flags */=0A=
 	u8			 rsvd1raid;=0A=
-	int			 npaths;=0A=
 	u16			 fc_phys_lun;=0A=
 	u16			 fc_xlat_lun;=0A=
-	int			 stall_detected;=0A=
-	PathInfo		 path[DMP_MAX_PATHS];=0A=
-	struct timer_list	 stall_timer;=0A=
-	struct timer_list	 retry_timer;=0A=
-	struct timer_list	 gone_timer;=0A=
 	u32			 num_luns;=0A=
 	u32			 luns[8];		/* Max LUNs is 256 */=0A=
 	u8			 pad[4];=0A=
@@ -427,14 +396,6 @@=0A=
 #define MPT_TARGET_FLAGS_VALID_56	0x10=0A=
 #define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20=0A=
 =0A=
-typedef struct _VirtDevTracker {=0A=
-	struct _VirtDevice	*head;=0A=
-	struct _VirtDevice	*tail;=0A=
-	rwlock_t		 VlistLock;=0A=
-	int			 pad;=0A=
-} VirtDevTracker;=0A=
-=0A=
-=0A=
 /*=0A=
  *	/proc/mpt interface=0A=
  */=0A=
@@ -648,12 +609,6 @@=0A=
 	struct net_device	*netdev;=0A=
 } MPT_ADAPTER;=0A=
 =0A=
-=0A=
-typedef struct _MPT_ADAPTER_TRACKER {=0A=
-	MPT_ADAPTER	*head;=0A=
-	MPT_ADAPTER	*tail;=0A=
-} MPT_ADAPTER_TRACKER;=0A=
-=0A=
 /*=0A=
  *  New return value convention:=0A=
  *    1 =3D Ok to free associated request frame=0A=
@@ -875,13 +830,6 @@=0A=
 #define MPT_INDEX_2_RFPTR(ioc,idx) \=0A=
 	(MPT_FRAME_HDR*)( (u8*)(ioc)->reply_frames + (ioc)->req_sz * (idx) =
)=0A=
 =0A=
-#define SWAB4(value) \=0A=
-	(u32)(   (((value) & 0x000000ff) << 24) \=0A=
-	       | (((value) & 0x0000ff00) << 8)  \=0A=
-	       | (((value) & 0x00ff0000) >> 8)  \=0A=
-	       | (((value) & 0xff000000) >> 24) )=0A=
-=0A=
-=0A=
 #if defined(MPT_DEBUG) || defined(MPT_DEBUG_MSG_FRAME)=0A=
 #define DBG_DUMP_REPLY_FRAME(mfp) \=0A=
 	{	u32 *m =3D (u32 *)(mfp);					\=0A=
@@ -966,7 +914,7 @@=0A=
 	u8			  resetPending;=0A=
 	u8			  is_spi;		/* Parallel SCSI i/f */=0A=
 	u8			  negoNvram;		/* DV disabled, nego NVRAM */=0A=
-	u8			  is_multipath;		/* Multi-path compatible */=0A=
+	u8			  pad1;=0A=
 	u8                        tmState;=0A=
 	u8			  rsvd[2];=0A=
 	MPT_FRAME_HDR		 *tmPtr;		/* Ptr to TM request*/=0A=
@@ -987,26 +935,6 @@=0A=
 /* Forward decl, a strange C thing, to prevent gcc compiler warnings =
*/=0A=
 struct scsi_cmnd;=0A=
 =0A=
-/*=0A=
- *	DMP service layer structure / API interface=0A=
- */=0A=
-typedef struct _DmpServices {=0A=
-	VirtDevTracker	  VdevList;=0A=
-	struct semaphore *Daemon;=0A=
-	int		(*ScsiPathSelect)=0A=
-				(struct scsi_cmnd *, MPT_SCSI_HOST **hd, int *target, int =
*lun);=0A=
-	int		(*DmpIoDoneChk)=0A=
-				(MPT_SCSI_HOST *, struct scsi_cmnd *,=0A=
-				 SCSIIORequest_t *,=0A=
-				 SCSIIOReply_t *);=0A=
-	void		(*mptscsih_scanVlist)=0A=
-				(MPT_SCSI_HOST *, int portnum);=0A=
-	int		(*ScsiAbort)=0A=
-				(struct scsi_cmnd *);=0A=
-	int		(*ScsiBusReset)=0A=
-				(struct scsi_cmnd *);=0A=
-} DmpServices_t;=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  * Generic structure passed to the base mpt_config function.=0A=
@@ -1042,10 +970,8 @@=0A=
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf);=0A=
 extern void	 mpt_put_msg_frame(int handle, MPT_ADAPTER *ioc, =
MPT_FRAME_HDR *mf);=0A=
 extern void	 mpt_add_sge(char *pAddr, u32 flagslength, dma_addr_t =
dma_addr);=0A=
-extern void	 mpt_add_chain(char *pAddr, u8 next, u16 length, =
dma_addr_t dma_addr);=0A=
 =0A=
 extern int	 mpt_send_handshake_request(int handle, MPT_ADAPTER *ioc, =
int reqBytes, u32 *req, int sleepFlag);=0A=
-extern int	 mpt_handshake_req_reply_wait(MPT_ADAPTER *ioc, int =
reqBytes, u32 *req, int replyBytes, u16 *u16reply, int maxwait, int =
sleepFlag);=0A=
 extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp);=0A=
 extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);=0A=
 extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int =
*size, int len, int showlan);=0A=
@@ -1062,7 +988,6 @@=0A=
  */=0A=
 extern struct list_head	  ioc_list;=0A=
 extern struct proc_dir_entry	*mpt_proc_root_dir;=0A=
-extern DmpServices_t		*DmpService;=0A=
 =0A=
 extern int		  mpt_lan_index;	/* needed by mptlan.c */=0A=
 extern int		  mpt_stm_index;	/* needed by mptstm.c */=0A=
@@ -1070,13 +995,6 @@=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 #endif		/* } __KERNEL__ */=0A=
 =0A=
-/*=0A=
- *  More (public) macros...=0A=
- */=0A=
-#ifndef offsetof=0A=
-#define offsetof(t, m)	((size_t) (&((t *)0)->m))=0A=
-#endif=0A=
-=0A=
 #if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) =
|| defined(__x86_64__)=0A=
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)=0A=
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)=0A=
diff -uarN b/message/fusion/mptscsih.c a/message/fusion/mptscsih.c=0A=
--- b/message/fusion/mptscsih.c	2004-09-09 16:13:19.000000000 -0600=0A=
+++ a/message/fusion/mptscsih.c	2004-09-20 15:36:26.000000000 -0600=0A=
@@ -1192,12 +1192,7 @@=0A=
 	hd->ioc =3D ioc;=0A=
 =0A=
 	if ((int)ioc->chip_type > (int)FC929)=0A=
-	hd->is_spi =3D 1;=0A=
-=0A=
-	if (DmpService && (ioc->chip_type =3D=3D FC919 ||=0A=
-	  ioc->chip_type =3D=3D FC929)) {=0A=
-		hd->is_multipath =3D 1;=0A=
-	}=0A=
+		hd->is_spi =3D 1;=0A=
 =0A=
 	/* SCSI needs scsi_cmnd lookup table!=0A=
 	 * (with size equal to req_depth*PtrSz!)=0A=
@@ -2787,7 +2782,6 @@=0A=
 			return -ENOMEM;=0A=
 		} else {=0A=
 			memset(vdev, 0, sizeof(VirtDevice));=0A=
-			rwlock_init(&vdev->VdevLock);=0A=
 			vdev->tflags =3D MPT_TARGET_FLAGS_Q_YES;=0A=
 			vdev->ioc_id =3D hd->ioc->id;=0A=
 			vdev->target_id =3D device->id;=0A=
@@ -2983,8 +2977,6 @@=0A=
 	pReq =3D (SCSIIORequest_t *) mf;=0A=
 	index =3D (int) pReq->TargetID;=0A=
 	target =3D hd->Targets[index];=0A=
-	if (hd->is_multipath && sc->device->hostdata)=0A=
-		target =3D (VirtDevice *) sc->device->hostdata;=0A=
 =0A=
 	if (sense_count) {=0A=
 		u8 *sense_data;=0A=

------_=_NextPart_000_01C49FFC.0DEC2010--
