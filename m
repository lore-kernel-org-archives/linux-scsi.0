From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Wed, 17 Mar 2004 14:43:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C40C58.1AAF2DC0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28383 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262026AbUCQTnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 14:43:45 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, ak@suse.de, Alexander.Stohr@gmx.de, rddunlap@osdl.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C40C58.1AAF2DC0
Content-Type: text/plain;
	charset="iso-8859-1"

This is an update for the MPT Fusion drivers 2.6 kernel.
Version 3.01.02.

Changelog:

(1) Andi Kleen[ak@suse.de]
put warning "Device (0:0:0) reported QUEUE_FULL!" into debug messages

(2) Alexander Stohr[Alexander.Stohr@gmx.de]
fix warnings from mptscsih_setup when driver isn't compiled as module

(3) Randy.Dunlap[rddunlap@osdl.org]
Remove unnecessary min/max macros and change calls to 
use kernel.h macros instead.


You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.02


Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/




------_=_NextPart_000_01C40C58.1AAF2DC0
Content-Type: application/octet-stream;
	name="mptlinux-3.01.02.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.01.02.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2004-03-17 17:11:04.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2004-03-17 12:18:39.000000000 =
-0700=0A=
@@ -2567,10 +2567,10 @@=0A=
 			 * Set values for this IOC's request & reply frame sizes,=0A=
 			 * and request & reply queue depths...=0A=
 			 */=0A=
-			ioc->req_sz =3D MIN(MPT_DEFAULT_FRAME_SIZE, facts->RequestFrameSize =
* 4);=0A=
-			ioc->req_depth =3D MIN(MPT_MAX_REQ_DEPTH, facts->GlobalCredits);=0A=
+			ioc->req_sz =3D min(MPT_DEFAULT_FRAME_SIZE, facts->RequestFrameSize =
* 4);=0A=
+			ioc->req_depth =3D min_t(int, MPT_MAX_REQ_DEPTH, =
facts->GlobalCredits);=0A=
 			ioc->reply_sz =3D MPT_REPLY_FRAME_SIZE;=0A=
-			ioc->reply_depth =3D MIN(MPT_DEFAULT_REPLY_DEPTH, =
facts->ReplyQueueDepth);=0A=
+			ioc->reply_depth =3D min_t(int, MPT_DEFAULT_REPLY_DEPTH, =
facts->ReplyQueueDepth);=0A=
 =0A=
 			dprintk((MYIOC_s_INFO_FMT "reply_sz=3D%3d, reply_depth=3D%4d\n",=0A=
 				ioc->name, ioc->reply_sz, ioc->reply_depth));=0A=
@@ -4065,7 +4065,7 @@=0A=
 		/*=0A=
 		 * Copy out the cached reply...=0A=
 		 */=0A=
-		for (ii=3D0; ii < MIN(replyBytes/2,mptReply->MsgLength*2); ii++)=0A=
+		for (ii=3D0; ii < min(replyBytes/2,mptReply->MsgLength*2); ii++)=0A=
 			u16reply[ii] =3D ioc->hs_reply[ii];=0A=
 	} else {=0A=
 		return -99;=0A=
@@ -4312,7 +4312,7 @@=0A=
 =0A=
 			if ((rc =3D mpt_config(ioc, &cfg)) =3D=3D 0) {=0A=
 				/* save the data */=0A=
-				copy_sz =3D MIN(sizeof(LANPage0_t), data_sz);=0A=
+				copy_sz =3D min_t(int, sizeof(LANPage0_t), data_sz);=0A=
 				memcpy(&ioc->lan_cnfg_page0, ppage0_alloc, copy_sz);=0A=
 =0A=
 			}=0A=
@@ -4357,7 +4357,7 @@=0A=
 =0A=
 		if ((rc =3D mpt_config(ioc, &cfg)) =3D=3D 0) {=0A=
 			/* save the data */=0A=
-			copy_sz =3D MIN(sizeof(LANPage1_t), data_sz);=0A=
+			copy_sz =3D min_t(int, sizeof(LANPage1_t), data_sz);=0A=
 			memcpy(&ioc->lan_cnfg_page1, ppage1_alloc, copy_sz);=0A=
 		}=0A=
 =0A=
@@ -4426,7 +4426,7 @@=0A=
 		if ((rc =3D mpt_config(ioc, &cfg)) =3D=3D 0) {=0A=
 			/* save the data */=0A=
 			pp0dest =3D &ioc->fc_port_page0[portnum];=0A=
-			copy_sz =3D MIN(sizeof(FCPortPage0_t), data_sz);=0A=
+			copy_sz =3D min_t(int, sizeof(FCPortPage0_t), data_sz);=0A=
 			memcpy(pp0dest, ppage0_alloc, copy_sz);=0A=
 =0A=
 			/*=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-03-17 17:11:04.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-03-17 12:18:39.000000000 =
-0700=0A=
@@ -81,8 +81,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2004 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.01.01"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.01"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.01.02"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.01.02"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
@@ -1061,13 +1061,6 @@=0A=
 /*=0A=
  *  More (public) macros...=0A=
  */=0A=
-#ifndef MIN=0A=
-#define MIN(a, b)   (((a) < (b)) ? (a) : (b))=0A=
-#endif=0A=
-#ifndef MAX=0A=
-#define MAX(a, b)   (((a) > (b)) ? (a) : (b))=0A=
-#endif=0A=
-=0A=
 #ifndef offsetof=0A=
 #define offsetof(t, m)	((size_t) (&((t *)0)->m))=0A=
 #endif=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2004-03-17 17:11:04.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptctl.c	2004-03-17 12:18:39.000000000 =
-0700=0A=
@@ -285,7 +285,7 @@=0A=
 				dctlprintk((MYIOC_s_INFO_FMT ": Copying Reply Frame @%p to =
IOC!\n",=0A=
 						ioc->name, reply));=0A=
 				memcpy(ioc->ioctl->ReplyFrame, reply,=0A=
-					MIN(ioc->reply_sz, 4*reply->u.reply.MsgLength));=0A=
+					min(ioc->reply_sz, 4*reply->u.reply.MsgLength));=0A=
 				ioc->ioctl->status |=3D MPT_IOCTL_STATUS_RF_VALID;=0A=
 =0A=
 				/* Set the command status to GOOD if IOC Status is GOOD=0A=
@@ -336,7 +336,7 @@=0A=
 			// NOTE: Expects/requires non-Turbo reply!=0A=
 			dctlprintk((MYIOC_s_INFO_FMT ":Caching MPI_FUNCTION_FW_DOWNLOAD =
reply!\n",=0A=
 				ioc->name));=0A=
-			memcpy(fwReplyBuffer, reply, MIN(sizeof(fwReplyBuffer), =
4*reply->u.reply.MsgLength));=0A=
+			memcpy(fwReplyBuffer, reply, min_t(int, sizeof(fwReplyBuffer), =
4*reply->u.reply.MsgLength));=0A=
 			ReplyMsg =3D (pMPIDefaultReply_t) fwReplyBuffer;=0A=
 		}=0A=
 	}=0A=
@@ -991,7 +991,7 @@=0A=
 	MptSge_t	*sgl;=0A=
 	int		 numfrags =3D 0;=0A=
 	int		 fragcnt =3D 0;=0A=
-	int		 alloc_sz =3D MIN(bytes,MAX_KMALLOC_SZ);	// avoid kernel warning =
msg!=0A=
+	int		 alloc_sz =3D min(bytes,MAX_KMALLOC_SZ);	// avoid kernel warning =
msg!=0A=
 	int		 bytes_allocd =3D 0;=0A=
 	int		 this_alloc;=0A=
 	dma_addr_t	 pa;					// phys addr=0A=
@@ -1036,7 +1036,7 @@=0A=
 	sgl =3D sglbuf;=0A=
 	sg_spill =3D ((ioc->req_sz - sge_offset)/(sizeof(dma_addr_t) + =
sizeof(u32))) - 1;=0A=
 	while (bytes_allocd < bytes) {=0A=
-		this_alloc =3D MIN(alloc_sz, bytes-bytes_allocd);=0A=
+		this_alloc =3D min(alloc_sz, bytes-bytes_allocd);=0A=
 		buflist[buflist_ent].len =3D this_alloc;=0A=
 		buflist[buflist_ent].kptr =3D pci_alloc_consistent(ioc->pcidev,=0A=
 								 this_alloc,=0A=
@@ -2293,9 +2293,9 @@=0A=
 		 */=0A=
 		if (ioc->ioctl->status & MPT_IOCTL_STATUS_RF_VALID) {=0A=
 			if (karg.maxReplyBytes < ioc->reply_sz) {=0A=
-				 sz =3D MIN(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);=0A=
+				 sz =3D min(karg.maxReplyBytes, 4*ioc->ioctl->ReplyFrame[2]);=0A=
 			} else {=0A=
-				 sz =3D MIN(ioc->reply_sz, 4*ioc->ioctl->ReplyFrame[2]);=0A=
+				 sz =3D min(ioc->reply_sz, 4*ioc->ioctl->ReplyFrame[2]);=0A=
 			}=0A=
 =0A=
 			if (sz > 0) {=0A=
@@ -2314,7 +2314,7 @@=0A=
 		/* If valid sense data, copy to user.=0A=
 		 */=0A=
 		if (ioc->ioctl->status & MPT_IOCTL_STATUS_SENSE_VALID) {=0A=
-			sz =3D MIN(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);=0A=
+			sz =3D min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);=0A=
 			if (sz > 0) {=0A=
 				if (copy_to_user((char *)karg.senseDataPtr, ioc->ioctl->sense, =
sz)) {=0A=
 					printk(KERN_ERR "%s@%d::mptctl_do_mpt_command - "=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-03-17 17:11:04.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-03-17 12:18:39.000000000 =
-0700=0A=
@@ -196,8 +196,9 @@=0A=
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void =
*pPage);=0A=
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int =
width);=0A=
 #endif=0A=
+#ifdef MODULE=0A=
 static int	mptscsih_setup(char *str);=0A=
-=0A=
+#endif=0A=
 /* module entry point */=0A=
 static int  __init   mptscsih_init  (void);=0A=
 static void __exit   mptscsih_exit  (void);=0A=
@@ -1366,8 +1367,8 @@=0A=
 =0A=
 		if (sc->device && sc->device->host !=3D NULL && =
sc->device->host->hostdata !=3D NULL)=0A=
 			ioc_str =3D ((MPT_SCSI_HOST =
*)sc->device->host->hostdata)->ioc->name;=0A=
-		printk(MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported =
QUEUE_FULL!\n",=0A=
-				ioc_str, 0, sc->device->id, sc->device->lun);=0A=
+		dprintk((MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported =
QUEUE_FULL!\n",=0A=
+				ioc_str, 0, sc->device->id, sc->device->lun));=0A=
 		last_queue_full =3D time;=0A=
 	}=0A=
 }=0A=
@@ -4519,7 +4520,7 @@=0A=
 					if (nfactor < pspi_data->minSyncFactor )=0A=
 						nfactor =3D pspi_data->minSyncFactor;=0A=
 =0A=
-					factor =3D MAX (factor, nfactor);=0A=
+					factor =3D max(factor, nfactor);=0A=
 					if (factor =3D=3D MPT_ASYNC)=0A=
 						offset =3D 0;=0A=
 				} else {=0A=
@@ -4727,7 +4728,7 @@=0A=
 		maxid =3D ioc->sh->max_id - 1;=0A=
 	} else if (ioc->sh) {=0A=
 		id =3D target_id;=0A=
-		maxid =3D MIN(id, ioc->sh->max_id - 1);=0A=
+		maxid =3D min_t(int, id, ioc->sh->max_id - 1);=0A=
 	}=0A=
 =0A=
 	for (; id <=3D maxid; id++) {=0A=
@@ -5134,7 +5135,7 @@=0A=
 				sense_data =3D ((u8 *)hd->ioc->sense_buf_pool +=0A=
 					(req_idx * MPT_SENSE_BUFFER_ALLOC));=0A=
 =0A=
-				sz =3D MIN (pReq->SenseBufferLength,=0A=
+				sz =3D min_t(int, pReq->SenseBufferLength,=0A=
 							SCSI_STD_SENSE_BYTES);=0A=
 				memcpy(hd->pLocal->sense, sense_data, sz);=0A=
 =0A=
@@ -5786,7 +5787,7 @@=0A=
 				ioc->spi_data.forceDv &=3D ~MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
 			}=0A=
 =0A=
-			maxid =3D MIN (ioc->sh->max_id, MPT_MAX_SCSI_DEVICES);=0A=
+			maxid =3D min_t(int, ioc->sh->max_id, MPT_MAX_SCSI_DEVICES);=0A=
 =0A=
 			for (id =3D 0; id < maxid; id++) {=0A=
 				spin_lock_irqsave(&dvtaskQ_lock, flags);=0A=
@@ -6509,7 +6510,7 @@=0A=
 	if (echoBufSize > 0) {=0A=
 		iocmd.flags |=3D MPT_ICFLAG_ECHO;=0A=
 		if (dataBufSize > 0)=0A=
-			bufsize =3D MIN(echoBufSize, dataBufSize);=0A=
+			bufsize =3D min(echoBufSize, dataBufSize);=0A=
 		else=0A=
 			bufsize =3D echoBufSize;=0A=
 	} else if (dataBufSize =3D=3D 0)=0A=
@@ -6520,7 +6521,7 @@=0A=
 =0A=
 	/* Data buffers for write-read-compare test max 1K.=0A=
 	 */=0A=
-	sz =3D MIN(bufsize, 1024);=0A=
+	sz =3D min(bufsize, 1024);=0A=
 =0A=
 	/* --- loop ----=0A=
 	 * On first pass, always issue a reserve.=0A=
@@ -6875,9 +6876,9 @@=0A=
 		}=0A=
 =0A=
 		/* limit by adapter capabilities */=0A=
-		width =3D MIN(width, hd->ioc->spi_data.maxBusWidth);=0A=
-		offset =3D MIN(offset, hd->ioc->spi_data.maxSyncOffset);=0A=
-		factor =3D MAX(factor, hd->ioc->spi_data.minSyncFactor);=0A=
+		width =3D min(width, hd->ioc->spi_data.maxBusWidth);=0A=
+		offset =3D min(offset, hd->ioc->spi_data.maxSyncOffset);=0A=
+		factor =3D max(factor, hd->ioc->spi_data.minSyncFactor);=0A=
 =0A=
 		/* Check Consistency */=0A=
 		if (offset && (factor < MPT_ULTRA2) && !width)=0A=
@@ -7217,19 +7218,22 @@=0A=
 #define	ARG_SEP	','=0A=
 #endif=0A=
 =0A=
+#ifdef MODULE=0A=
 static char setup_token[] __initdata =3D=0A=
 	"dv:"=0A=
 	"width:"=0A=
 	"factor:"=0A=
 	"saf-te:"=0A=
        ;	/* DO NOT REMOVE THIS ';' */=0A=
-=0A=
+#endif=0A=
+       =0A=
 #define OPT_DV			1=0A=
 #define OPT_MAX_WIDTH		2=0A=
 #define OPT_MIN_SYNC_FACTOR	3=0A=
 #define OPT_SAF_TE		4=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
*/=0A=
+#ifdef MODULE=0A=
 static int=0A=
 get_setup_token(char *p)=0A=
 {=0A=
@@ -7298,7 +7302,7 @@=0A=
 	}=0A=
 	return 1;=0A=
 }=0A=
-=0A=
+#endif=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 =0A=
 =0A=

------_=_NextPart_000_01C40C58.1AAF2DC0--
