From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: mptfusion: delete watchdogs timers from mptctl and mptscsih
Date: Mon, 24 Jan 2005 15:56:47 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CF5F4B9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C50267.FBB46DC0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55961 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261719AbVAXW4z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 17:56:55 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j0OMseJg013197
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 14:54:40 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j0OMurct001506
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 14:56:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C50267.FBB46DC0
Content-Type: text/plain;
	charset="iso-8859-1"

Here is a patch for mpt fusion drivers, which
removes the watchdog timers from mptctl/mptscsih.
The patch and changelog follows.

Pls note, this patch should be applied against
a recent patch from Andi Kleen "Add compat_ioctl to mptctl" 
before applying this patch. Andi's patch was applied against.
bk://linux-scsi.bkbits.net/scsi-misc-2.6 

Change log:

1) mptscsih.c: I have changed task management 
requests so they complete in same thread before returning
to os.  I removed the TMtimer code.  
 
(2) mptctl.c: I have deleted both TMtimer and timer code. Replaced
with wait_event_interruptible_timeout.  So commands are now
completed in same thread.  
 
(3) mptctl_do_fw_download - nasty polling of global parameters
that are set in contents of interrupt handler(mptctl_reply), now using
wait_event_interruptible_timeout. 
 
(4) I have cleaned up mptctl_reply.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C50267.FBB46DC0
Content-Type: application/octet-stream;
	name="mptlinux-3.01.19.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.19.patch"

diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-12-24 14:34:01.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-01-11 11:51:40.000000000 =
-0700=0A=
@@ -83,8 +83,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.18"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.18"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.19"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.19"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -420,7 +420,6 @@=0A=
 =0A=
 typedef struct _MPT_IOCTL {=0A=
 	struct _MPT_ADAPTER	*ioc;=0A=
-	struct timer_list	 timer;		/* timer function for this adapter */=0A=
 	u8			 ReplyFrame[MPT_DEFAULT_FRAME_SIZE];	/* reply frame data */=0A=
 	u8			 sense[MPT_SENSE_BUFFER_ALLOC];=0A=
 	int			 wait_done;	/* wake-up value for this ioc */=0A=
@@ -428,8 +427,6 @@=0A=
 	u8			 status;	/* current command status */=0A=
 	u8			 reset;		/* 1 if bus reset allowed */=0A=
 	u8			 target;	/* target for reset */=0A=
-	void 			*tmPtr;=0A=
-	struct timer_list	 TMtimer;	/* timer function for this adapter */=0A=
 	struct semaphore	 sem_ioc;=0A=
 } MPT_IOCTL;=0A=
 =0A=
@@ -882,11 +879,9 @@=0A=
 	int			  port;=0A=
 	u32			  pad0;=0A=
 	struct scsi_cmnd	**ScsiLookup;=0A=
-	u32			  qtag_tick;=0A=
 	VirtDevice		**Targets;=0A=
 	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */=0A=
 	struct timer_list	  timer;=0A=
-	struct timer_list	  TMtimer;		/* Timer for TM commands ONLY */=0A=
 		/* Pool of memory for holding SCpnts before doing=0A=
 		 * OS callbacks. freeQ is the free pool.=0A=
 		 */=0A=
@@ -896,7 +891,6 @@=0A=
 	u8			  pad1;=0A=
 	u8                        tmState;=0A=
 	u8			  rsvd[2];=0A=
-	MPT_FRAME_HDR		 *tmPtr;		/* Ptr to TM request*/=0A=
 	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */=0A=
 	struct scsi_cmnd	 *abortSCpnt;=0A=
 	MPT_LOCAL_REPLY		  localReply;		/* internal cmd reply struct */=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2005-01-23 14:24:03.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptctl.c	2005-01-23 15:17:47.000000000 =
-0700=0A=
@@ -81,6 +81,7 @@=0A=
 #include <linux/slab.h>=0A=
 #include <linux/types.h>=0A=
 #include <linux/pci.h>=0A=
+#include <linux/delay.h>	/* for mdelay */=0A=
 #include <linux/miscdevice.h>=0A=
 #include <linux/smp_lock.h>=0A=
 #include <linux/compat.h>=0A=
@@ -145,7 +146,6 @@=0A=
 #ifdef CONFIG_COMPAT=0A=
 static long compat_mpctl_ioctl(struct file *f, unsigned cmd, unsigned =
long arg);=0A=
 #endif=0A=
-=0A=
 /*=0A=
  * Private function calls.=0A=
  */=0A=
@@ -155,7 +155,7 @@=0A=
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);=0A=
 static void kfree_sgl( MptSge_t *sgl, dma_addr_t sgl_dma,=0A=
 		struct buflist *buflist, MPT_ADAPTER *ioc);=0A=
-static void mptctl_timer_expired (unsigned long data);=0A=
+static void mptctl_timeout_expired (MPT_IOCTL *ioctl);=0A=
 static int  mptctl_bus_reset(MPT_IOCTL *ioctl);=0A=
 static int mptctl_set_tm_flags(MPT_SCSI_HOST *hd);=0A=
 static void mptctl_free_tm_flags(MPT_ADAPTER *ioc);=0A=
@@ -188,9 +188,6 @@=0A=
 =0A=
 #define MPT_IOCTL_DEFAULT_TIMEOUT 10	/* Default timeout value =
(seconds) */=0A=
 =0A=
-static u32 fwReplyBuffer[16];=0A=
-static pMPIDefaultReply_t ReplyMsg =3D NULL;=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mptctl_syscall_down - Down the MPT adapter syscall semaphore.=0A=
@@ -208,11 +205,6 @@=0A=
 	int rc =3D 0;=0A=
 	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down(%p,%d) called\n", =
ioc, nonblock));=0A=
 =0A=
-	if (ioc->ioctl->tmPtr !=3D NULL) {=0A=
-		dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down BUSY\n"));=0A=
-		return -EBUSY;=0A=
-	}=0A=
-=0A=
 	if (nonblock) {=0A=
 		if (down_trylock(&ioc->ioctl->sem_ioc))=0A=
 			rc =3D -EAGAIN;=0A=
@@ -239,131 +231,101 @@=0A=
 	u16 iocStatus;=0A=
 	u8 cmd;=0A=
 =0A=
-	dctlprintk((MYIOC_s_INFO_FMT ": mptctl_reply()!\n", ioc->name));=0A=
+	dctlprintk(("mptctl_reply()!\n"));=0A=
 	if (req)=0A=
 		 cmd =3D req->u.hdr.Function;=0A=
 	else=0A=
 		return 1;=0A=
 =0A=
 	if (ioc->ioctl) {=0A=
-		/* If timer is not running, then an error occurred.=0A=
-		 * A timeout will call the reset routine to reload the messaging=0A=
-		 * queues.=0A=
-		 * Main callback will free message and reply frames.=0A=
-		 */=0A=
-		if (reply && (cmd =3D=3D MPI_FUNCTION_SCSI_TASK_MGMT) &&=0A=
-		    (ioc->ioctl->status & MPT_IOCTL_STATUS_TMTIMER_ACTIVE)) {=0A=
-			/* This is internally generated TM=0A=
-			 */=0A=
-			del_timer (&ioc->ioctl->TMtimer);=0A=
-			ioc->ioctl->status &=3D ~MPT_IOCTL_STATUS_TMTIMER_ACTIVE;=0A=
 =0A=
-			mptctl_free_tm_flags(ioc);=0A=
+		if (reply=3D=3DNULL) {=0A=
 =0A=
-			/* If TM failed, reset the timer on the existing command,=0A=
-			 * will trigger an adapter reset.=0A=
-			 */=0A=
-			iocStatus =3D reply->u.reply.IOCStatus & MPI_IOCSTATUS_MASK;=0A=
-			if (iocStatus =3D=3D MPI_IOCSTATUS_SCSI_TASK_MGMT_FAILED) {=0A=
-				if (ioc->ioctl->status & MPT_IOCTL_STATUS_TIMER_ACTIVE) {=0A=
-					ioc->ioctl->reset &=3D ~MPTCTL_RESET_OK;=0A=
-					del_timer (&ioc->ioctl->timer);=0A=
-					ioc->ioctl->timer.expires =3D jiffies + HZ;=0A=
-					add_timer(&ioc->ioctl->timer);=0A=
-				}=0A=
-			}=0A=
-			ioc->ioctl->tmPtr =3D NULL;=0A=
+			dctlprintk(("mptctl_reply() NULL Reply "=0A=
+				"Function=3D%x!\n", cmd));=0A=
 =0A=
-		} else if (ioc->ioctl->status & MPT_IOCTL_STATUS_TIMER_ACTIVE) {=0A=
-			/* Delete this timer=0A=
-			 */=0A=
-			del_timer (&ioc->ioctl->timer);=0A=
-			ioc->ioctl->status &=3D ~MPT_IOCTL_STATUS_TIMER_ACTIVE;=0A=
+			ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
+			ioc->ioctl->reset &=3D ~MPTCTL_RESET_OK;=0A=
 =0A=
-			/* Set the overall status byte.  Good if:=0A=
-			 * IOC status is good OR if no reply and a SCSI IO request=0A=
-			 */=0A=
-			if (reply) {=0A=
-				/* Copy the reply frame (which much exist=0A=
-				 * for non-SCSI I/O) to the IOC structure.=0A=
-				 */=0A=
-				dctlprintk((MYIOC_s_INFO_FMT ": Copying Reply Frame @%p to =
IOC!\n",=0A=
-						ioc->name, reply));=0A=
-				memcpy(ioc->ioctl->ReplyFrame, reply,=0A=
-					min(ioc->reply_sz, 4*reply->u.reply.MsgLength));=0A=
-				ioc->ioctl->status |=3D MPT_IOCTL_STATUS_RF_VALID;=0A=
+			/* We are done, issue wake up=0A=
+	 		*/=0A=
+			ioc->ioctl->wait_done =3D 1;=0A=
+			wake_up (&mptctl_wait);=0A=
+			return 1;=0A=
 =0A=
-				/* Set the command status to GOOD if IOC Status is GOOD=0A=
-				 * OR if SCSI I/O cmd and data underrun or recovered error.=0A=
-				 */=0A=
-				iocStatus =3D reply->u.reply.IOCStatus & MPI_IOCSTATUS_MASK;=0A=
-				if (iocStatus  =3D=3D MPI_IOCSTATUS_SUCCESS)=0A=
-					ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
-=0A=
-				if ((cmd =3D=3D MPI_FUNCTION_SCSI_IO_REQUEST) ||=0A=
-					(cmd =3D=3D MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {=0A=
-					ioc->ioctl->reset &=3D ~MPTCTL_RESET_OK;=0A=
-=0A=
-					if ((iocStatus =3D=3D MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||=0A=
-						(iocStatus =3D=3D MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {=0A=
-						ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
-					}=0A=
-				}=0A=
+		}=0A=
 =0A=
-				/* Copy the sense data - if present=0A=
-				 */=0A=
-				if ((cmd =3D=3D MPI_FUNCTION_SCSI_IO_REQUEST) &&=0A=
-					(reply->u.sreply.SCSIState & MPI_SCSI_STATE_AUTOSENSE_VALID)){=0A=
+		dctlprintk(("mptctl_reply() with req=3D%p "=0A=
+			"reply=3D%p Function=3D%x!\n", req, reply, cmd));=0A=
 =0A=
-					sz =3D req->u.scsireq.SenseBufferLength;=0A=
-					req_index =3D =
le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
-					sense_data =3D ((u8 *)ioc->sense_buf_pool + (req_index * =
MPT_SENSE_BUFFER_ALLOC));=0A=
-					memcpy(ioc->ioctl->sense, sense_data, sz);=0A=
-					ioc->ioctl->status |=3D MPT_IOCTL_STATUS_SENSE_VALID;=0A=
-				}=0A=
+		/* Copy the reply frame (which much exist=0A=
+		 * for non-SCSI I/O) to the IOC structure.=0A=
+		 */=0A=
+		dctlprintk(("Copying Reply Frame @%p to ioc%d!\n",=0A=
+			reply, ioc->id));=0A=
+		memcpy(ioc->ioctl->ReplyFrame, reply,=0A=
+			min(ioc->reply_sz, 4*reply->u.reply.MsgLength));=0A=
+		ioc->ioctl->status |=3D MPT_IOCTL_STATUS_RF_VALID;=0A=
 =0A=
-				if (cmd =3D=3D MPI_FUNCTION_SCSI_TASK_MGMT)=0A=
-					mptctl_free_tm_flags(ioc);=0A=
+		/* Set the command status to GOOD if IOC Status is GOOD=0A=
+		 * OR if SCSI I/O cmd and data underrun or recovered error.=0A=
+		 */=0A=
+		iocStatus =3D reply->u.reply.IOCStatus & MPI_IOCSTATUS_MASK;=0A=
+		if (iocStatus  =3D=3D MPI_IOCSTATUS_SUCCESS)=0A=
+			ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
 =0A=
+		if ((cmd =3D=3D MPI_FUNCTION_SCSI_IO_REQUEST) ||=0A=
+			(cmd =3D=3D MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {=0A=
+			ioc->ioctl->reset &=3D ~MPTCTL_RESET_OK;=0A=
 =0A=
-			} else if ((cmd =3D=3D MPI_FUNCTION_SCSI_IO_REQUEST) ||=0A=
-					(cmd =3D=3D MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {=0A=
-				ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
-				ioc->ioctl->reset &=3D ~MPTCTL_RESET_OK;=0A=
+			if ((iocStatus =3D=3D MPI_IOCSTATUS_SCSI_DATA_UNDERRUN) ||=0A=
+			(iocStatus =3D=3D MPI_IOCSTATUS_SCSI_RECOVERED_ERROR)) {=0A=
+			ioc->ioctl->status |=3D MPT_IOCTL_STATUS_COMMAND_GOOD;=0A=
 			}=0A=
+		}=0A=
 =0A=
-			/* We are done, issue wake up=0A=
-			 */=0A=
-			ioc->ioctl->wait_done =3D 1;=0A=
-			wake_up (&mptctl_wait);=0A=
-		} else if (reply && cmd =3D=3D MPI_FUNCTION_FW_DOWNLOAD) {=0A=
-			/* Two paths to FW DOWNLOAD! */=0A=
-			// NOTE: Expects/requires non-Turbo reply!=0A=
-			dctlprintk((MYIOC_s_INFO_FMT ":Caching MPI_FUNCTION_FW_DOWNLOAD =
reply!\n",=0A=
-				ioc->name));=0A=
-			memcpy(fwReplyBuffer, reply, min_t(int, sizeof(fwReplyBuffer), =
4*reply->u.reply.MsgLength));=0A=
-			ReplyMsg =3D (pMPIDefaultReply_t) fwReplyBuffer;=0A=
+		/* Copy the sense data - if present=0A=
+		 */=0A=
+		if ((cmd =3D=3D MPI_FUNCTION_SCSI_IO_REQUEST) &&=0A=
+			(reply->u.sreply.SCSIState &=0A=
+			 MPI_SCSI_STATE_AUTOSENSE_VALID)){=0A=
+			sz =3D req->u.scsireq.SenseBufferLength;=0A=
+			req_index =3D=0A=
+			    le16_to_cpu(req->u.frame.hwhdr.msgctxu.fld.req_idx);=0A=
+			sense_data =3D=0A=
+			    ((u8 *)ioc->sense_buf_pool +=0A=
+			     (req_index * MPT_SENSE_BUFFER_ALLOC));=0A=
+			memcpy(ioc->ioctl->sense, sense_data, sz);=0A=
+			ioc->ioctl->status |=3D MPT_IOCTL_STATUS_SENSE_VALID;=0A=
 		}=0A=
+=0A=
+		if (cmd =3D=3D MPI_FUNCTION_SCSI_TASK_MGMT)=0A=
+			mptctl_free_tm_flags(ioc);=0A=
+=0A=
+		/* We are done, issue wake up=0A=
+		 */=0A=
+		ioc->ioctl->wait_done =3D 1;=0A=
+		wake_up (&mptctl_wait);=0A=
 	}=0A=
 	return 1;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/* mptctl_timer_expired=0A=
+/* mptctl_timeout_expired=0A=
  *=0A=
- * Call back for timer process. Used only for ioctl functionality.=0A=
+ * Expecting an interrupt, however timed out.=0A=
  *=0A=
  */=0A=
-static void mptctl_timer_expired (unsigned long data)=0A=
+static void mptctl_timeout_expired (MPT_IOCTL *ioctl)=0A=
 {=0A=
-	MPT_IOCTL *ioctl =3D (MPT_IOCTL *) data;=0A=
 	int rc =3D 1;=0A=
 =0A=
-	dctlprintk((KERN_NOTICE MYNAM ": Timer Expired! Host %d\n",=0A=
+	dctlprintk((KERN_NOTICE MYNAM ": Timeout Expired! Host %d\n",=0A=
 				ioctl->ioc->id));=0A=
 	if (ioctl =3D=3D NULL)=0A=
 		return;=0A=
 =0A=
+	ioctl->wait_done =3D 0;=0A=
 	if (ioctl->reset & MPTCTL_RESET_OK)=0A=
 		rc =3D mptctl_bus_reset(ioctl);=0A=
 =0A=
@@ -371,6 +333,8 @@=0A=
 		/* Issue a reset for this device.=0A=
 		 * The IOC is not responding.=0A=
 		 */=0A=
+		dctlprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",=0A=
+			 ioctl->ioc->name));=0A=
 		mpt_HardResetHandler(ioctl->ioc, NO_SLEEP);=0A=
 	}=0A=
 	return;=0A=
@@ -395,7 +359,7 @@=0A=
 =0A=
 	if (ioctl->ioc->sh =3D=3D NULL)=0A=
 		return -EPERM;=0A=
-	=0A=
+=0A=
 	hd =3D (MPT_SCSI_HOST *) ioctl->ioc->sh->hostdata;=0A=
 	if (hd =3D=3D NULL)=0A=
 		return -EPERM;=0A=
@@ -435,26 +399,34 @@=0A=
 		pScsiTm->Reserved2[ii] =3D 0;=0A=
 =0A=
 	pScsiTm->TaskMsgContext =3D 0;=0A=
-	dtmprintk((MYIOC_s_INFO_FMT "mptctl_bus_reset: issued.\n", =
ioctl->ioc->name));=0A=
+	dtmprintk((MYIOC_s_INFO_FMT=0A=
+		"mptctl_bus_reset: issued.\n", ioctl->ioc->name));=0A=
 =0A=
-	ioctl->tmPtr =3D mf;=0A=
-	ioctl->TMtimer.expires =3D jiffies + HZ * 20;	/* 20 seconds */=0A=
-	ioctl->status |=3D MPT_IOCTL_STATUS_TMTIMER_ACTIVE;=0A=
-	add_timer(&ioctl->TMtimer);=0A=
-=0A=
-	retval =3D mpt_send_handshake_request(mptctl_id, ioctl->ioc,=0A=
-			sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, NO_SLEEP);=0A=
-=0A=
-	if (retval !=3D 0) {=0A=
-		dtmprintk((MYIOC_s_WARN_FMT "_send_handshake FAILED!"=0A=
-			" (hd %p, ioc %p, mf %p) \n", ioctl->ioc->name, hd, hd->ioc, =
mf));=0A=
+	DBG_DUMP_TM_REQUEST_FRAME((u32 *)mf);=0A=
 =0A=
-		mptctl_free_tm_flags(ioctl->ioc);=0A=
-		del_timer(&ioctl->TMtimer);=0A=
-		mpt_free_msg_frame(ioctl->ioc, mf);=0A=
-		ioctl->tmPtr =3D NULL;=0A=
+	ioctl->wait_done=3D0;=0A=
+	if ((retval =3D mpt_send_handshake_request(mptctl_id, ioctl->ioc,=0A=
+	     sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, CAN_SLEEP)) !=3D 0) {=0A=
+		dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"=0A=
+			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,=0A=
+			hd->ioc, mf));=0A=
+		goto mptctl_bus_reset_done;=0A=
 	}=0A=
 =0A=
+	/* Now wait for the command to complete */=0A=
+	ii =3D wait_event_interruptible_timeout(mptctl_wait,=0A=
+	     ioctl->wait_done =3D=3D 1,=0A=
+	     HZ*5 /* 5 second timeout */);=0A=
+=0A=
+	if(ii <=3D0 && (ioctl->wait_done !=3D 1 ))  {=0A=
+		ioctl->wait_done =3D 0;=0A=
+		retval =3D -1; /* return failure */=0A=
+	}=0A=
+=0A=
+mptctl_bus_reset_done:=0A=
+=0A=
+	mpt_free_msg_frame(hd->ioc, mf);=0A=
+	mptctl_free_tm_flags(ioctl->ioc);=0A=
 	return retval;=0A=
 }=0A=
 =0A=
@@ -495,7 +467,6 @@=0A=
 	return;=0A=
 }=0A=
 =0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /* mptctl_ioc_reset=0A=
  *=0A=
@@ -508,43 +479,22 @@=0A=
 {=0A=
 	MPT_IOCTL *ioctl =3D ioc->ioctl;=0A=
 	dctlprintk((KERN_INFO MYNAM ": IOC %s_reset routed to IOCTL =
driver!\n",=0A=
-			reset_phase=3D=3DMPT_IOC_SETUP_RESET ? "setup" : (=0A=
-			reset_phase=3D=3DMPT_IOC_PRE_RESET ? "pre" : "post")));=0A=
+		reset_phase=3D=3DMPT_IOC_SETUP_RESET ? "setup" : (=0A=
+		reset_phase=3D=3DMPT_IOC_PRE_RESET ? "pre" : "post")));=0A=
 =0A=
-	if (reset_phase =3D=3D MPT_IOC_SETUP_RESET){=0A=
-		;=0A=
-	} else if (reset_phase =3D=3D MPT_IOC_PRE_RESET){=0A=
-=0A=
-		/* Someone has called the reset handler to=0A=
-		 * do a hard reset. No more replies from the FW.=0A=
-		 * Delete the timer. TM flags cleaned up by SCSI driver.=0A=
-		 * Do not need to free msg frame, as re-initialized=0A=
-		 */=0A=
-		if (ioctl && (ioctl->status & MPT_IOCTL_STATUS_TIMER_ACTIVE)){=0A=
-			del_timer(&ioctl->timer);=0A=
-		}=0A=
-		if (ioctl && (ioctl->status & MPT_IOCTL_STATUS_TMTIMER_ACTIVE)){=0A=
-			ioctl->status &=3D ~MPT_IOCTL_STATUS_TMTIMER_ACTIVE;=0A=
-			del_timer(&ioctl->TMtimer);=0A=
-			mpt_free_msg_frame(ioc, ioctl->tmPtr);=0A=
-		}=0A=
-=0A=
-	} else {=0A=
-		ioctl->tmPtr =3D NULL;=0A=
-=0A=
-		/* Set the status and continue IOCTL=0A=
-		 * processing. All memory will be free'd=0A=
-		 * by originating thread after wake_up is=0A=
-		 * called.=0A=
-		 */=0A=
-		if (ioctl && (ioctl->status & MPT_IOCTL_STATUS_TIMER_ACTIVE)){=0A=
-			ioctl->status |=3D MPT_IOCTL_STATUS_DID_IOCRESET;=0A=
+	if(ioctl =3D=3D NULL)=0A=
+		return 1;=0A=
 =0A=
-			/* Wake up the calling process=0A=
-			 */=0A=
-			ioctl->wait_done =3D 1;=0A=
-			wake_up(&mptctl_wait);=0A=
-		}=0A=
+	switch(reset_phase) {=0A=
+	case MPT_IOC_SETUP_RESET:=0A=
+		ioctl->status |=3D MPT_IOCTL_STATUS_DID_IOCRESET;=0A=
+		break;=0A=
+	case MPT_IOC_POST_RESET:=0A=
+		ioctl->status &=3D ~MPT_IOCTL_STATUS_DID_IOCRESET;=0A=
+		break;=0A=
+	case MPT_IOC_PRE_RESET:=0A=
+	default:=0A=
+		break;=0A=
 	}=0A=
 =0A=
 	return 1;=0A=
@@ -749,9 +699,9 @@=0A=
 	u32			 nib;=0A=
 	int			 fw_bytes_copied =3D 0;=0A=
 	int			 i;=0A=
-	int			 cntdn;=0A=
 	int			 sge_offset =3D 0;=0A=
 	u16			 iocstat;=0A=
+	pFWDownloadReply_t	 ReplyMsg =3D NULL;=0A=
 =0A=
 	dctlprintk((KERN_INFO "mptctl_do_fwdl called. mptctl_id =3D %xh.\n", =
mptctl_id));=0A=
 =0A=
@@ -882,31 +832,25 @@=0A=
 	/*=0A=
 	 * Finally, perform firmware download.=0A=
 	 */=0A=
-	ReplyMsg =3D NULL;=0A=
+	iocp->ioctl->wait_done =3D 0;=0A=
 	mpt_put_msg_frame(mptctl_id, iocp, mf);=0A=
 =0A=
-	/*=0A=
-	 *  Wait until the reply has been received=0A=
-	 */=0A=
-	for (cntdn=3DHZ*60, i=3D1; ReplyMsg =3D=3D NULL; cntdn--, i++) {=0A=
-		if (!cntdn) {=0A=
-			ret =3D -ETIME;=0A=
-			goto fwdl_out;=0A=
-		}=0A=
-=0A=
-		if (!(i%HZ)) {=0A=
-			dctlprintk((KERN_INFO "DbG::_do_fwdl: "=0A=
-				   "In ReplyMsg loop - iteration %d\n",=0A=
-				   i));=0A=
-		}=0A=
-=0A=
-		set_current_state(TASK_INTERRUPTIBLE);=0A=
-		schedule_timeout(1);=0A=
+	/* Now wait for the command to complete */=0A=
+	ret =3D wait_event_interruptible_timeout(mptctl_wait,=0A=
+	     iocp->ioctl->wait_done =3D=3D 1,=0A=
+	     HZ*60);=0A=
+=0A=
+	if(ret <=3D0 && (iocp->ioctl->wait_done !=3D 1 )) {=0A=
+	/* Now we need to reset the board */=0A=
+		mptctl_timeout_expired(iocp->ioctl);=0A=
+		ret =3D -ENODATA;=0A=
+		goto fwdl_out;=0A=
 	}=0A=
 =0A=
 	if (sgl)=0A=
 		kfree_sgl(sgl, sgl_dma, buflist, iocp);=0A=
 =0A=
+	ReplyMsg =3D (pFWDownloadReply_t)iocp->ioctl->ReplyFrame;=0A=
 	iocstat =3D le16_to_cpu(ReplyMsg->IOCStatus) & MPI_IOCSTATUS_MASK;=0A=
 	if (iocstat =3D=3D MPI_IOCSTATUS_SUCCESS) {=0A=
 		printk(KERN_INFO MYNAM ": F/W update successfully sent to %s!\n", =
iocp->name);=0A=
@@ -1194,14 +1138,14 @@=0A=
 		cim_rev =3D 0;	/* obsolete */=0A=
 	else=0A=
 		return -EFAULT;=0A=
-	=0A=
+=0A=
 	karg =3D kmalloc(data_size, GFP_KERNEL);=0A=
 	if (karg =3D=3D NULL) {=0A=
 		printk(KERN_ERR "%s::mpt_ioctl_iocinfo() @%d - no memory =
available!\n",=0A=
 				__FILE__, __LINE__);=0A=
 		return -ENOMEM;=0A=
 	}=0A=
-		=0A=
+=0A=
 	if (copy_from_user(karg, uarg, data_size)) {=0A=
 		printk(KERN_ERR "%s@%d::mptctl_getiocinfo - "=0A=
 			"Unable to read in mpt_ioctl_iocinfo struct @ %p\n",=0A=
@@ -1826,8 +1770,8 @@=0A=
 	int		iocnum, flagsLength;=0A=
 	int		sz, rc =3D 0;=0A=
 	int		msgContext;=0A=
-	int		tm_flags_set =3D 0;=0A=
 	u16		req_idx;=0A=
+	ulong 		timeout;=0A=
 =0A=
 	dctlprintk(("mptctl_do_mpt_command called.\n"));=0A=
 	bufIn.kptr =3D bufOut.kptr =3D NULL;=0A=
@@ -2043,7 +1987,6 @@=0A=
 				rc =3D -EPERM;=0A=
 				goto done_free_mem;=0A=
 			}=0A=
-			tm_flags_set =3D 1;=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -2195,136 +2138,108 @@=0A=
 		mpt_add_sge(psge, flagsLength, (dma_addr_t) -1);=0A=
 	}=0A=
 =0A=
-	/* The request is complete. Set the timer parameters=0A=
-	 * and issue the request.=0A=
-	 */=0A=
-	if (karg.timeout > 0) {=0A=
-		ioc->ioctl->timer.expires =3D jiffies + HZ*karg.timeout;=0A=
-	} else {=0A=
-		ioc->ioctl->timer.expires =3D jiffies + =
HZ*MPT_IOCTL_DEFAULT_TIMEOUT;=0A=
-	}=0A=
-=0A=
 	ioc->ioctl->wait_done =3D 0;=0A=
-	ioc->ioctl->status |=3D MPT_IOCTL_STATUS_TIMER_ACTIVE;=0A=
-	add_timer(&ioc->ioctl->timer);=0A=
-=0A=
 	if (hdr->Function =3D=3D MPI_FUNCTION_SCSI_TASK_MGMT) {=0A=
+=0A=
 		DBG_DUMP_TM_REQUEST_FRAME((u32 *)mf);=0A=
-		rc =3D mpt_send_handshake_request(mptctl_id, ioc,=0A=
-				sizeof(SCSITaskMgmt_t), (u32*)mf, CAN_SLEEP);=0A=
-		if (rc =3D=3D 0) {=0A=
-			wait_event(mptctl_wait, ioc->ioctl->wait_done);=0A=
-		} else {=0A=
+=0A=
+		if (mpt_send_handshake_request(mptctl_id, ioc,=0A=
+			sizeof(SCSITaskMgmt_t), (u32*)mf,=0A=
+			CAN_SLEEP) !=3D 0) {=0A=
+			dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"=0A=
+				" (ioc %p, mf %p) \n", ioc->name,=0A=
+				ioc, mf));=0A=
 			mptctl_free_tm_flags(ioc);=0A=
-			tm_flags_set=3D 0;=0A=
-			del_timer(&ioc->ioctl->timer);=0A=
-			ioc->ioctl->status &=3D ~MPT_IOCTL_STATUS_TIMER_ACTIVE;=0A=
-			ioc->ioctl->status |=3D MPT_IOCTL_STATUS_TM_FAILED;=0A=
-			mpt_free_msg_frame(ioc, mf);=0A=
+			rc =3D -ENODATA;=0A=
+			goto done_free_mem;=0A=
 		}=0A=
-	} else {=0A=
+=0A=
+	} else=0A=
 		mpt_put_msg_frame(mptctl_id, ioc, mf);=0A=
-		wait_event(mptctl_wait, ioc->ioctl->wait_done);=0A=
+=0A=
+	/* Now wait for the command to complete */=0A=
+	timeout =3D (karg.timeout > 0) ? karg.timeout : =
MPT_IOCTL_DEFAULT_TIMEOUT;=0A=
+	timeout =3D wait_event_interruptible_timeout(mptctl_wait,=0A=
+	     ioc->ioctl->wait_done =3D=3D 1,=0A=
+	     HZ*timeout);=0A=
+=0A=
+	if(timeout <=3D0 && (ioc->ioctl->wait_done !=3D 1 )) {=0A=
+	/* Now we need to reset the board */=0A=
+=0A=
+		if (hdr->Function =3D=3D MPI_FUNCTION_SCSI_TASK_MGMT)=0A=
+			mptctl_free_tm_flags(ioc);=0A=
+=0A=
+		mptctl_timeout_expired(ioc->ioctl);=0A=
+		rc =3D -ENODATA;=0A=
+		goto done_free_mem;=0A=
 	}=0A=
 =0A=
 	mf =3D NULL;=0A=
 =0A=
-	/* MF Cleanup:=0A=
-	 * If command failed and failure triggered a diagnostic reset=0A=
-	 * OR a diagnostic reset happens during command processing,=0A=
-	 * no data, messaging queues are reset (mf cannot be accessed),=0A=
-	 * and status is DID_IOCRESET=0A=
-	 *=0A=
-	 * If a user-requested bus reset fails to be handshaked, then=0A=
-	 * mf is returned to free queue and status is TM_FAILED.=0A=
-	 *=0A=
-	 * Otherise, the command completed and the mf was freed=0A=
-	 # by ISR (mf cannot be touched).=0A=
+	/* If a valid reply frame, copy to the user.=0A=
+	 * Offset 2: reply length in U32's=0A=
 	 */=0A=
-	if (ioc->ioctl->status & MPT_IOCTL_STATUS_DID_IOCRESET) {=0A=
-		/* The timer callback deleted the=0A=
-		 * timer and reset the adapter queues.=0A=
-		 */=0A=
-		printk(KERN_WARNING "%s@%d::mptctl_do_mpt_command - "=0A=
-			"Timeout Occurred on IOCTL! Reset IOC.\n", __FILE__, __LINE__);=0A=
-		tm_flags_set=3D 0;=0A=
-		rc =3D -ETIME;=0A=
-	} else if (ioc->ioctl->status & MPT_IOCTL_STATUS_TM_FAILED) {=0A=
-		/* User TM request failed! mf has not been freed.=0A=
-		 */=0A=
-		rc =3D -ENODATA;=0A=
-	} else {=0A=
-		/* If a valid reply frame, copy to the user.=0A=
-		 * Offset 2: reply length in U32's=0A=
-		 */=0A=
-		if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID) {=0A=
-			if (karg.maxReplyBytes < ioc->reply_sz) {=0A=
-				 sz =3D min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);=0A=
-			} else {=0A=
-				 sz =3D min(ioc->reply_sz, 4*ioc->ioctl->ReplyFrame[2]);=0A=
-			}=0A=
-=0A=
-			if (sz > 0) {=0A=
-				if (copy_to_user(karg.replyFrameBufPtr,=0A=
-					 &ioc->ioctl->ReplyFrame, sz)){=0A=
-=0A=
-					 printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "=0A=
-					 "Unable to write out reply frame %p\n",=0A=
-					 __FILE__, __LINE__, karg.replyFrameBufPtr);=0A=
-					 rc =3D  -ENODATA;=0A=
-					 goto done_free_mem;=0A=
-				}=0A=
-			}=0A=
+	if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID) {=0A=
+		if (karg.maxReplyBytes < ioc->reply_sz) {=0A=
+			 sz =3D min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);=0A=
+		} else {=0A=
+			 sz =3D min(ioc->reply_sz, 4*ioc->ioctl->ReplyFrame[2]);=0A=
 		}=0A=
 =0A=
-		/* If valid sense data, copy to user.=0A=
-		 */=0A=
-		if (ioc->ioctl->status & MPT_IOCTL_STATUS_SENSE_VALID) {=0A=
-			sz =3D min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);=0A=
-			if (sz > 0) {=0A=
-				if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {=0A=
-					printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "=0A=
-					"Unable to write sense data to user %p\n",=0A=
-					__FILE__, __LINE__,=0A=
-					karg.senseDataPtr);=0A=
-					rc =3D  -ENODATA;=0A=
-					goto done_free_mem;=0A=
-				}=0A=
+		if (sz > 0) {=0A=
+			if (copy_to_user(karg.replyFrameBufPtr,=0A=
+				 &ioc->ioctl->ReplyFrame, sz)){=0A=
+				 printk(KERN_ERR=0A=
+				     "%s@%d::mptctl_do_mpt_command - "=0A=
+				 "Unable to write out reply frame %p\n",=0A=
+				 __FILE__, __LINE__, karg.replyFrameBufPtr);=0A=
+				 rc =3D  -ENODATA;=0A=
+				 goto done_free_mem;=0A=
 			}=0A=
 		}=0A=
+	}=0A=
 =0A=
-		/* If the overall status is _GOOD and data in, copy data=0A=
-		 * to user.=0A=
-		 */=0A=
-		if ((ioc->ioctl->status & MPT_IOCTL_STATUS_COMMAND_GOOD) &&=0A=
-					(karg.dataInSize > 0) && (bufIn.kptr)) {=0A=
-=0A=
-			if (copy_to_user(karg.dataInBufPtr,=0A=
-					 bufIn.kptr, karg.dataInSize)) {=0A=
+	/* If valid sense data, copy to user.=0A=
+	 */=0A=
+	if (ioc->ioctl->status & MPT_IOCTL_STATUS_SENSE_VALID) {=0A=
+		sz =3D min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);=0A=
+		if (sz > 0) {=0A=
+			if (copy_to_user(karg.senseDataPtr, ioc->ioctl->sense, sz)) {=0A=
 				printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "=0A=
-					"Unable to write data to user %p\n",=0A=
-					__FILE__, __LINE__,=0A=
-					karg.dataInBufPtr);=0A=
+				"Unable to write sense data to user %p\n",=0A=
+				__FILE__, __LINE__,=0A=
+				karg.senseDataPtr);=0A=
 				rc =3D  -ENODATA;=0A=
+				goto done_free_mem;=0A=
 			}=0A=
 		}=0A=
 	}=0A=
 =0A=
+	/* If the overall status is _GOOD and data in, copy data=0A=
+	 * to user.=0A=
+	 */=0A=
+	if ((ioc->ioctl->status & MPT_IOCTL_STATUS_COMMAND_GOOD) &&=0A=
+				(karg.dataInSize > 0) && (bufIn.kptr)) {=0A=
+=0A=
+		if (copy_to_user(karg.dataInBufPtr,=0A=
+				 bufIn.kptr, karg.dataInSize)) {=0A=
+			printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "=0A=
+				"Unable to write data to user %p\n",=0A=
+				__FILE__, __LINE__,=0A=
+				karg.dataInBufPtr);=0A=
+			rc =3D  -ENODATA;=0A=
+		}=0A=
+	}=0A=
+=0A=
 done_free_mem:=0A=
-	/* Clear all status bits except TMTIMER_ACTIVE, this bit is =
cleared=0A=
-	 * upon completion of the TM command.=0A=
-	 * ioc->ioctl->status =3D 0;=0A=
-	 */=0A=
-	ioc->ioctl->status &=3D ~(MPT_IOCTL_STATUS_TIMER_ACTIVE | =
MPT_IOCTL_STATUS_TM_FAILED |=0A=
-			MPT_IOCTL_STATUS_COMMAND_GOOD | MPT_IOCTL_STATUS_SENSE_VALID |=0A=
-			MPT_IOCTL_STATUS_RF_VALID | MPT_IOCTL_STATUS_DID_IOCRESET);=0A=
 =0A=
-	if (tm_flags_set)=0A=
-		mptctl_free_tm_flags(ioc);=0A=
+	ioc->ioctl->status &=3D ~(MPT_IOCTL_STATUS_COMMAND_GOOD |=0A=
+		MPT_IOCTL_STATUS_SENSE_VALID |=0A=
+		MPT_IOCTL_STATUS_RF_VALID );=0A=
 =0A=
 	/* Free the allocated memory.=0A=
 	 */=0A=
-	 if (bufOut.kptr !=3D NULL) {=0A=
+	if (bufOut.kptr !=3D NULL) {=0A=
 		pci_free_consistent(ioc->pcidev,=0A=
 			bufOut.len, (void *) bufOut.kptr, dma_addr_out);=0A=
 	}=0A=
@@ -2563,7 +2478,7 @@=0A=
 				__FILE__, __LINE__, uarg);=0A=
 		return -EFAULT;=0A=
 	}=0A=
-	=0A=
+=0A=
 	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) =
||=0A=
 		(ioc =3D=3D NULL)) {=0A=
 		dctlprintk((KERN_ERR "%s::mptctl_hp_targetinfo() @%d - ioc%d not =
found!\n",=0A=
@@ -2581,7 +2496,7 @@=0A=
 =0A=
 	if (ioc->sh->host_no !=3D karg.hdr.host)=0A=
 		return -ENODEV;=0A=
-		=0A=
+=0A=
        /* Get the data transfer speeds=0A=
         */=0A=
 	data_sz =3D ioc->spi_data.sdp0length * 4;=0A=
@@ -2701,14 +2616,6 @@=0A=
 =0A=
 #include <linux/ioctl32.h>=0A=
 =0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/* compat_XXX functions are used to provide a conversion between=0A=
- * pointers and u32's. If the arg does not contain any pointers, =
then=0A=
- * a specialized function (compat_XXX) is not needed. If the arg=0A=
- * does contain pointer(s), then the specialized function is used=0A=
- * to ensure the structure contents is properly processed by =
mptctl.=0A=
- */=0A=
- =0A=
 static int=0A=
 compat_mptfwxfer_ioctl(struct file *filp, unsigned int cmd,=0A=
 			unsigned long arg)=0A=
@@ -2804,9 +2711,9 @@=0A=
 =0A=
 static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, =
unsigned long arg)=0A=
 {=0A=
-	int ret;=0A=
+	long ret;=0A=
 	lock_kernel();=0A=
-	switch (cmd) { =0A=
+	switch (cmd) {=0A=
 	case MPTIOCINFO:=0A=
 	case MPTIOCINFO1:=0A=
 	case MPTIOCINFO2:=0A=
@@ -2867,12 +2774,6 @@=0A=
 	memset(mem, 0, sz);=0A=
 	ioc->ioctl =3D (MPT_IOCTL *) mem;=0A=
 	ioc->ioctl->ioc =3D ioc;=0A=
-	init_timer (&ioc->ioctl->timer);=0A=
-	ioc->ioctl->timer.data =3D (unsigned long) ioc->ioctl;=0A=
-	ioc->ioctl->timer.function =3D mptctl_timer_expired;=0A=
-	init_timer (&ioc->ioctl->TMtimer);=0A=
-	ioc->ioctl->TMtimer.data =3D (unsigned long) ioc->ioctl;=0A=
-	ioc->ioctl->TMtimer.function =3D mptctl_timer_expired;=0A=
 	sema_init(&ioc->ioctl->sem_ioc, 1);=0A=
 	return 0;=0A=
 =0A=
@@ -2916,7 +2817,6 @@=0A=
 		": failed to register dd callbacks\n"));=0A=
 	}=0A=
 =0A=
-=0A=
 	/* Register this device */=0A=
 	err =3D misc_register(&mptctl_miscdev);=0A=
 	if (err < 0) {=0A=
@@ -2948,7 +2848,6 @@=0A=
 =0A=
 out_fail:=0A=
 =0A=
-=0A=
 	mpt_device_driver_deregister(MPTCTL_DRIVER);=0A=
 =0A=
 	return err;=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-01-23 08:53:54.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-01-23 15:10:43.000000000 =
-0700=0A=
@@ -179,10 +179,11 @@=0A=
 static void	mptscsih_freeChainBuffers(MPT_ADAPTER *ioc, int =
req_idx);=0A=
 static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, =
MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);=0A=
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);=0A=
+static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong =
timeout );=0A=
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);=0A=
 =0A=
-static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, =
u8 target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag);=0A=
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 =
channel, u8 target, u8 lun, int ctx2abort, ulong timeout, int =
sleepFlag);=0A=
+static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, =
u8 target, u8 lun, int ctx2abort, ulong timeout);=0A=
+static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 =
channel, u8 target, u8 lun, int ctx2abort, ulong timeout);=0A=
 =0A=
 static int	mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
 static int	mptscsih_event_process(MPT_ADAPTER *ioc, =
EventNotificationReply_t *pEvReply);=0A=
@@ -196,13 +197,9 @@=0A=
 static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int target_id, =
int bus);=0A=
 static int	mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR =
*mf, MPT_FRAME_HDR *r);=0A=
 static void	mptscsih_timer_expired(unsigned long data);=0A=
-static void	mptscsih_taskmgmt_timeout(unsigned long data);=0A=
-static void	mptscsih_schedule_reset(void *hd);=0A=
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);=0A=
 static int	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, int =
portnum);=0A=
 =0A=
-static struct work_struct   mptscsih_rstTask;=0A=
-=0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD =
*io);=0A=
 static void	mptscsih_domainValidation(void *hd);=0A=
@@ -1207,7 +1204,6 @@=0A=
 	hd->tmState =3D TM_STATE_NONE;=0A=
 	hd->resetPending =3D 0;=0A=
 	hd->abortSCpnt =3D NULL;=0A=
-	hd->tmPtr =3D NULL;=0A=
 =0A=
 	/* Clear the pointer used to store=0A=
 	 * single-threaded commands, i.e., those=0A=
@@ -1224,14 +1220,6 @@=0A=
 	hd->timer.data =3D (unsigned long) hd;=0A=
 	hd->timer.function =3D mptscsih_timer_expired;=0A=
 =0A=
-	init_timer(&hd->TMtimer);=0A=
-	hd->TMtimer.data =3D (unsigned long) hd;=0A=
-	hd->TMtimer.function =3D mptscsih_taskmgmt_timeout;=0A=
-	hd->qtag_tick =3D jiffies;=0A=
-=0A=
-	/* Moved Earlier Pam D */=0A=
-	/* ioc->sh =3D sh;	*/=0A=
-=0A=
 	if (ioc->bus_type =3D=3D SCSI) {=0A=
 		/* Update with the driver setup=0A=
 		 * values.=0A=
@@ -1925,7 +1913,6 @@=0A=
  *	@target: Logical Target ID for reset (if appropriate)=0A=
  *	@lun: Logical Unit for reset (if appropriate)=0A=
  *	@ctx2abort: Context for the task to be aborted (if appropriate)=0A=
- *	@sleepFlag: If set, use udelay instead of schedule in handshake =
code.=0A=
  *=0A=
  *	Remark: Currently invoked from a non-interrupt thread (_bh).=0A=
  *=0A=
@@ -1935,7 +1922,7 @@=0A=
  *	Returns 0 for SUCCESS or -1 if FAILED.=0A=
  */=0A=
 static int=0A=
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, =
u8 lun, int ctx2abort, ulong timeout, int sleepFlag)=0A=
+mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, =
u8 lun, int ctx2abort, ulong timeout)=0A=
 {=0A=
 	MPT_ADAPTER	*ioc;=0A=
 	int		 rc =3D -1;=0A=
@@ -2015,7 +2002,7 @@=0A=
 		 */=0A=
 		if (hd->hard_resets < -1)=0A=
 			hd->hard_resets++;=0A=
-		rc =3D mptscsih_IssueTaskMgmt(hd, type, channel, target, lun, =
ctx2abort, timeout, sleepFlag);=0A=
+		rc =3D mptscsih_IssueTaskMgmt(hd, type, channel, target, lun, =
ctx2abort, timeout);=0A=
 		if (rc) {=0A=
 			printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt failed!\n", =
hd->ioc->name);=0A=
 		} else {=0A=
@@ -2029,7 +2016,7 @@=0A=
 		ioc->reload_fw || (ioc->alt_ioc && ioc->alt_ioc->reload_fw))) {=0A=
 		dtmprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",=0A=
 			 hd->ioc->name));=0A=
-		rc =3D mpt_HardResetHandler(hd->ioc, sleepFlag);=0A=
+		rc =3D mpt_HardResetHandler(hd->ioc, CAN_SLEEP);=0A=
 	}=0A=
 =0A=
 	dtmprintk((MYIOC_s_INFO_FMT "TMHandler rc =3D %d!\n", hd->ioc->name, =
rc));=0A=
@@ -2046,7 +2033,6 @@=0A=
  *	@target: Logical Target ID for reset (if appropriate)=0A=
  *	@lun: Logical Unit for reset (if appropriate)=0A=
  *	@ctx2abort: Context for the task to be aborted (if appropriate)=0A=
- *	@sleepFlag: If set, use udelay instead of schedule in handshake =
code.=0A=
  *=0A=
  *	Remark: _HardResetHandler can be invoked from an interrupt thread =
(timer)=0A=
  *	or a non-interrupt thread.  In the former, must not call =
schedule().=0A=
@@ -2057,7 +2043,7 @@=0A=
  *	else other non-zero value returned.=0A=
  */=0A=
 static int=0A=
-mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 =
target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag)=0A=
+mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 =
target, u8 lun, int ctx2abort, ulong timeout)=0A=
 {=0A=
 	MPT_FRAME_HDR	*mf;=0A=
 	SCSITaskMgmt_t	*pScsiTm;=0A=
@@ -2087,7 +2073,7 @@=0A=
 	pScsiTm->TaskType =3D type;=0A=
 	pScsiTm->Reserved1 =3D 0;=0A=
 	pScsiTm->MsgFlags =3D (type =3D=3D =
MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS)=0A=
-	                    ? MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION =
: 0;=0A=
+                    ? MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION =
: 0;=0A=
 =0A=
 	for (ii=3D 0; ii < 8; ii++) {=0A=
 		pScsiTm->LUN[ii] =3D 0;=0A=
@@ -2099,29 +2085,32 @@=0A=
 =0A=
 	pScsiTm->TaskMsgContext =3D ctx2abort;=0A=
 =0A=
-	/* MPI v0.10 requires SCSITaskMgmt requests be sent via =
Doorbell/handshake=0A=
-		mpt_put_msg_frame(hd->ioc->id, mf);=0A=
-	* Save the MF pointer in case the request times out.=0A=
-	*/=0A=
-	hd->tmPtr =3D mf;=0A=
-	hd->TMtimer.expires =3D jiffies + timeout;=0A=
-	add_timer(&hd->TMtimer);=0A=
-=0A=
-	dtmprintk((MYIOC_s_INFO_FMT "IssueTaskMgmt: ctx2abort (0x%08x) =
type=3D%d\n",=0A=
-			hd->ioc->name, ctx2abort, type));=0A=
+	dtmprintk((MYIOC_s_INFO_FMT=0A=
+		"IssueTaskMgmt: ctx2abort (0x%08x) type=3D%d\n",=0A=
+		hd->ioc->name, ctx2abort, type));=0A=
 =0A=
 	DBG_DUMP_TM_REQUEST_FRAME((u32 *)pScsiTm);=0A=
 =0A=
 	if ((retval =3D mpt_send_handshake_request(ScsiTaskCtx, hd->ioc,=0A=
-				sizeof(SCSITaskMgmt_t), (u32*)pScsiTm, sleepFlag))=0A=
-	!=3D 0) {=0A=
+		sizeof(SCSITaskMgmt_t), (u32*)pScsiTm,=0A=
+		CAN_SLEEP)) !=3D 0) {=0A=
 		dfailprintk((MYIOC_s_ERR_FMT "_send_handshake FAILED!"=0A=
-			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd, hd->ioc, mf));=0A=
-		hd->tmPtr =3D NULL;=0A=
-		del_timer(&hd->TMtimer);=0A=
+			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,=0A=
+			hd->ioc, mf));=0A=
 		mpt_free_msg_frame(hd->ioc, mf);=0A=
+		return retval;=0A=
 	}=0A=
-	=0A=
+=0A=
+	if(mptscsih_tm_wait_for_completion(hd, timeout) =3D=3D FAILED) {=0A=
+		dfailprintk((MYIOC_s_ERR_FMT "_wait_for_completion FAILED!"=0A=
+			" (hd %p, ioc %p, mf %p) \n", hd->ioc->name, hd,=0A=
+			hd->ioc, mf));=0A=
+		mpt_free_msg_frame(hd->ioc, mf);=0A=
+		dtmprintk((MYIOC_s_INFO_FMT "Calling HardReset! \n",=0A=
+			 hd->ioc->name));=0A=
+		retval =3D mpt_HardResetHandler(hd->ioc, CAN_SLEEP);=0A=
+	}=0A=
+=0A=
 	return retval;=0A=
 }=0A=
 =0A=
@@ -2187,13 +2176,13 @@=0A=
 	 */=0A=
 	mf =3D MPT_INDEX_2_MFPTR(hd->ioc, scpnt_idx);=0A=
 	ctx2abort =3D mf->u.frame.hwhdr.msgctxu.MsgContext;=0A=
-	=0A=
+=0A=
 	hd->abortSCpnt =3D SCpnt;=0A=
 =0A=
 	spin_unlock_irq(host_lock);=0A=
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,=0A=
 		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,=0A=
-		ctx2abort, (HZ*2) /* 2 second timeout */,CAN_SLEEP)=0A=
+		ctx2abort, 2 /* 2 second timeout */)=0A=
 		< 0) {=0A=
 =0A=
 		/* The TM request failed and the subsequent FW-reload failed!=0A=
@@ -2206,7 +2195,7 @@=0A=
 		 */=0A=
 		hd->tmPending =3D 0;=0A=
 		hd->tmState =3D TM_STATE_NONE;=0A=
-		=0A=
+=0A=
 		spin_lock_irq(host_lock);=0A=
 =0A=
 		/* Unmap the DMA buffers, if any. */=0A=
@@ -2226,7 +2215,6 @@=0A=
 	}=0A=
 	spin_lock_irq(host_lock);=0A=
 	return SUCCESS;=0A=
-=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -2259,15 +2247,10 @@=0A=
 	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! =
(sc=3D%p)\n",=0A=
 	       hd->ioc->name, SCpnt);=0A=
 =0A=
-	/* Supported for FC only.=0A=
-	 */=0A=
-	if (hd->ioc->bus_type =3D=3D SCSI) =0A=
-		return FAILED;=0A=
-=0A=
 	spin_unlock_irq(host_lock);=0A=
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,=0A=
 		SCpnt->device->channel, SCpnt->device->id,=0A=
-		0, 0, (HZ*5) /* 5 second timeout */, CAN_SLEEP)=0A=
+		0, 0, 5 /* 5 second timeout */)=0A=
 		< 0){=0A=
 		/* The TM request failed and the subsequent FW-reload failed!=0A=
 		 * Fatal error case.=0A=
@@ -2317,7 +2300,7 @@=0A=
 	/* We are now ready to execute the task management request. */=0A=
 	spin_unlock_irq(host_lock);=0A=
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,=0A=
-		SCpnt->device->channel, 0, 0, 0, (HZ*5) /* 5 second timeout */, =
CAN_SLEEP)=0A=
+		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)=0A=
 	    < 0){=0A=
 =0A=
 		/* The TM request failed and the subsequent FW-reload failed!=0A=
@@ -2398,7 +2381,7 @@=0A=
 mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd)=0A=
 {=0A=
 	unsigned long  flags;=0A=
-	int            loop_count =3D 10 * 4;  /* Wait 10 seconds */=0A=
+	int            loop_count =3D 4 * 10;  /* Wait 10 seconds */=0A=
 	int            status =3D FAILED;=0A=
 =0A=
 	do {=0A=
@@ -2406,8 +2389,8 @@=0A=
 		if (hd->tmState =3D=3D TM_STATE_NONE) {=0A=
 			hd->tmState =3D TM_STATE_IN_PROGRESS;=0A=
 			hd->tmPending =3D 1;=0A=
-			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);=0A=
 			status =3D SUCCESS;=0A=
+			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);=0A=
 			break;=0A=
 		}=0A=
 		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);=0A=
@@ -2419,6 +2402,34 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
+ *	mptscsih_tm_wait_for_completion - wait for completion of TM task=0A=
+ *	@hd: Pointer to MPT host structure.=0A=
+ *=0A=
+ *	Returns {SUCCESS,FAILED}.=0A=
+ */=0A=
+static int=0A=
+mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout )=0A=
+{=0A=
+	unsigned long  flags;=0A=
+	int            loop_count =3D 4 * timeout;=0A=
+	int            status =3D FAILED;=0A=
+=0A=
+	do {=0A=
+		spin_lock_irqsave(&hd->ioc->FreeQlock, flags);=0A=
+		if(hd->tmPending =3D=3D 0) {=0A=
+			status =3D SUCCESS;=0A=
+			spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);=0A=
+			break;=0A=
+		}=0A=
+		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);=0A=
+		msleep_interruptible(250);=0A=
+	} while (--loop_count);=0A=
+=0A=
+	return status;=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/**=0A=
  *	mptscsih_taskmgmt_complete - Registered with Fusion MPT base =
driver=0A=
  *	@ioc: Pointer to MPT_ADAPTER structure=0A=
  *	@mf: Pointer to SCSI task mgmt request frame=0A=
@@ -2449,9 +2460,6 @@=0A=
 		 * Decrement count of outstanding TM requests.=0A=
 		 */=0A=
 		hd =3D (MPT_SCSI_HOST *)ioc->sh->hostdata;=0A=
-		if (hd->tmPtr) {=0A=
-			del_timer(&hd->TMtimer);=0A=
-		}=0A=
 	} else {=0A=
 		dtmprintk((MYIOC_s_WARN_FMT "TaskMgmt Complete: NULL Scsi Host =
Ptr\n",=0A=
 			ioc->name));=0A=
@@ -2505,7 +2513,6 @@=0A=
 		}=0A=
 	}=0A=
 =0A=
-	hd->tmPtr =3D NULL;=0A=
 	spin_lock_irqsave(&ioc->FreeQlock, flags);=0A=
 	hd->tmPending =3D 0;=0A=
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);=0A=
@@ -2913,14 +2920,6 @@=0A=
 			mpt_free_msg_frame(ioc, hd->cmdPtr);=0A=
 		}=0A=
 =0A=
-		/* 2d. If a task management has not completed,=0A=
-		 * free resources associated with this request.=0A=
-		 */=0A=
-		if (hd->tmPtr) {=0A=
-			del_timer(&hd->TMtimer);=0A=
-			mpt_free_msg_frame(ioc, hd->tmPtr);=0A=
-		}=0A=
-=0A=
 		dtmprintk((MYIOC_s_WARN_FMT "Pre-Reset complete.\n", ioc->name));=0A=
 =0A=
 	} else {=0A=
@@ -2942,12 +2941,6 @@=0A=
 		/* 2. Chain Buffer initialization=0A=
 		 */=0A=
 =0A=
-		/* 3. tmPtr clear=0A=
-		 */=0A=
-		if (hd->tmPtr) {=0A=
-			hd->tmPtr =3D NULL;=0A=
-		}=0A=
-=0A=
 		/* 4. Renegotiate to all devices, if SCSI=0A=
 		 */=0A=
 		if (ioc->bus_type =3D=3D SCSI) {=0A=
@@ -3811,60 +3804,6 @@=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*	mptscsih_taskmgmt_timeout - Call back for timeout on a=0A=
- *	task management request.=0A=
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long=0A=
- *=0A=
- */=0A=
-static void mptscsih_taskmgmt_timeout(unsigned long data)=0A=
-{=0A=
-	MPT_SCSI_HOST *hd =3D (MPT_SCSI_HOST *) data;=0A=
-=0A=
-	dtmprintk((KERN_WARNING MYNAM ": %s: mptscsih_taskmgmt_timeout: "=0A=
-		   "TM request timed out!\n", hd->ioc->name));=0A=
-=0A=
-	/* Delete the timer that triggered this callback.=0A=
-	 * Remark: del_timer checks to make sure timer is active=0A=
-	 * before deleting.=0A=
-	 */=0A=
-	del_timer(&hd->TMtimer);=0A=
-=0A=
-	/* Call the reset handler. Already had a TM request=0A=
-	 * timeout - so issue a diagnostic reset=0A=
-	 */=0A=
-	INIT_WORK(&mptscsih_rstTask, mptscsih_schedule_reset, (void *)hd);=0A=
-	schedule_work(&mptscsih_rstTask);=0A=
-	return;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/*	mptscsih_schedule_reset - Call back for timeout on a=0A=
- *	task management request.=0A=
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long=0A=
- *=0A=
- */=0A=
-static void=0A=
-mptscsih_schedule_reset(void *arg)=0A=
-{=0A=
-        MPT_SCSI_HOST           *hd;=0A=
-        hd =3D (MPT_SCSI_HOST *) arg;=0A=
-=0A=
-	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0) {=0A=
-		printk((KERN_WARNING " Firmware Reload FAILED!!\n"));=0A=
-	} else {=0A=
-		/* Because we have reset the IOC, no TM requests can be=0A=
-		 * pending.  So let's make sure the tmPending flag is reset.=0A=
-		 */=0A=
-		dtmprintk((KERN_WARNING MYNAM=0A=
-			   ": %s: mptscsih_taskmgmt_timeout\n",=0A=
-			   hd->ioc->name));=0A=
-		hd->tmPending =3D 0;=0A=
-	}=0A=
-=0A=
-	return;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *  Bus Scan and Domain Validation functionality ...=0A=
  */=0A=

------_=_NextPart_000_01C50267.FBB46DC0--
