From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mptfusion - fix panic loading driver statically com
	pile d
Date: Thu, 28 Apr 2005 17:17:14 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0225D223@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C54C48.69E29360"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19090 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262330AbVD1XRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 19:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C54C48.69E29360
Content-Type: text/plain;
	charset="iso-8859-1"

On Thursday, April 28, 2005 4:28 PM, James Bottomley wrote:
> 
> Surely this is just a simple link order problem?  Can't we 
> solve it like
> the attached?
>


That fix's does have fusion_init loaded before mptspi_init.
Thanks.

However still got a panic further on in mpt_interrupt.

I changed the ordering again in the Makefile, and move setting
the ioc->DoneCtx handles for mptspi/mptfc in the message frame.
And I'm now not seeing the panic.  I have added on the other 
items from the previous patch.

See attached. 

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.01/


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C54C48.69E29360
Content-Type: application/octet-stream;
	name="mptlinux-3.03.01.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptlinux-3.03.01.patch"

diff -uarN b/drivers/message/fusion/Makefile =
a/drivers/message/fusion/Makefile=0A=
--- b/drivers/message/fusion/Makefile	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/Makefile	2005-04-28 16:51:53.000000000 =
-0600=0A=
@@ -32,7 +32,7 @@=0A=
 =0A=
 =
#=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-} LSI_LOGIC=0A=
 =0A=
-obj-$(CONFIG_FUSION_SPI)	+=3D mptspi.o mptscsih.o mptbase.o=0A=
-obj-$(CONFIG_FUSION_FC)		+=3D mptfc.o mptscsih.o mptbase.o=0A=
+obj-$(CONFIG_FUSION_SPI)	+=3D mptbase.o mptscsih.o mptspi.o=0A=
+obj-$(CONFIG_FUSION_FC)		+=3D mptbase.o mptscsih.o mptfc.o=0A=
 obj-$(CONFIG_FUSION_CTL)	+=3D mptctl.o=0A=
 obj-$(CONFIG_FUSION_LAN)	+=3D mptlan.o=0A=
diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-04-28 17:04:13.000000000 =
-0600=0A=
@@ -360,15 +360,8 @@=0A=
 		}=0A=
 =0A=
 		if (freeme) {=0A=
-			unsigned long flags;=0A=
-=0A=
 			/*  Put Request back on FreeQ!  */=0A=
-			spin_lock_irqsave(&ioc->FreeQlock, flags);=0A=
-			list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);=0A=
-#ifdef MFCNT=0A=
-			ioc->mfcnt--;=0A=
-#endif=0A=
-			spin_unlock_irqrestore(&ioc->FreeQlock, flags);=0A=
+			mpt_free_msg_frame(ioc, mf);=0A=
 		}=0A=
 =0A=
 		mb();=0A=
@@ -735,8 +728,8 @@=0A=
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx =3D handle;	/* byte */=0A=
 		req_offset =3D (u8 *)mf - (u8 *)ioc->req_frames;=0A=
 								/* u16! */=0A=
-		req_idx =3D cpu_to_le16(req_offset / ioc->req_sz);=0A=
-		mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D req_idx;=0A=
+		req_idx =3D req_offset / ioc->req_sz;=0A=
+		mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D cpu_to_le16(req_idx);=0A=
 		mf->u.frame.hwhdr.msgctxu.fld.rsvd =3D 0;=0A=
 		ioc->RequestNB[req_idx] =3D ioc->NB_for_64_byte_frame; /* Default, =
will be changed if necessary in SG generation */=0A=
 #ifdef MFCNT=0A=
@@ -782,8 +775,8 @@=0A=
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx =3D handle;		/* byte */=0A=
 	req_offset =3D (u8 *)mf - (u8 *)ioc->req_frames;=0A=
 								/* u16! */=0A=
-	req_idx =3D cpu_to_le16(req_offset / ioc->req_sz);=0A=
-	mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D req_idx;=0A=
+	req_idx =3D req_offset / ioc->req_sz;=0A=
+	mf->u.frame.hwhdr.msgctxu.fld.req_idx =3D cpu_to_le16(req_idx);=0A=
 	mf->u.frame.hwhdr.msgctxu.fld.rsvd =3D 0;=0A=
 =0A=
 #ifdef MPT_DEBUG_MSG_FRAME=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-04-28 17:05:25.000000000 =
-0600=0A=
@@ -76,8 +76,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.03.00"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.00"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.01"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.01"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=
diff -uarN b/drivers/message/fusion/mptfc.c =
a/drivers/message/fusion/mptfc.c=0A=
--- b/drivers/message/fusion/mptfc.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptfc.c	2005-04-28 16:52:58.000000000 =
-0600=0A=
@@ -166,6 +166,9 @@=0A=
 		return r;=0A=
 	=0A=
 	ioc =3D pci_get_drvdata(pdev);=0A=
+	ioc->DoneCtx =3D mptfcDoneCtx;=0A=
+	ioc->TaskCtx =3D mptfcTaskCtx;=0A=
+	ioc->InternalCtx =3D mptfcInternalCtx;=0A=
 =0A=
 	/*  Added sanity check on readiness of the MPT adapter.=0A=
 	 */=0A=
@@ -325,10 +328,6 @@=0A=
 	hd->timer.data =3D (unsigned long) hd;=0A=
 	hd->timer.function =3D mptscsih_timer_expired;=0A=
 =0A=
-	ioc->DoneCtx =3D mptfcDoneCtx;=0A=
-	ioc->TaskCtx =3D mptfcTaskCtx;=0A=
-	ioc->InternalCtx =3D mptfcInternalCtx;=0A=
-=0A=
 	hd->mpt_pq_filter =3D mpt_pq_filter;=0A=
 =0A=
 	ddvprintk((MYIOC_s_INFO_FMT=0A=
diff -uarN b/drivers/message/fusion/mptspi.c =
a/drivers/message/fusion/mptspi.c=0A=
--- b/drivers/message/fusion/mptspi.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptspi.c	2005-04-28 16:53:03.000000000 =
-0600=0A=
@@ -180,6 +180,9 @@=0A=
 		return r;=0A=
 	=0A=
 	ioc =3D pci_get_drvdata(pdev);=0A=
+	ioc->DoneCtx =3D mptspiDoneCtx;=0A=
+	ioc->TaskCtx =3D mptspiTaskCtx;=0A=
+	ioc->InternalCtx =3D mptspiInternalCtx;=0A=
 	=0A=
 	/*  Added sanity check on readiness of the MPT adapter.=0A=
 	 */=0A=
@@ -395,10 +398,6 @@=0A=
 	hd->scandv_wait_done =3D 0;=0A=
 	hd->last_queue_full =3D 0;=0A=
 =0A=
-	ioc->DoneCtx =3D mptspiDoneCtx;=0A=
-	ioc->TaskCtx =3D mptspiTaskCtx;=0A=
-	ioc->InternalCtx =3D mptspiInternalCtx;=0A=
-=0A=
 	error =3D scsi_add_host (sh, &ioc->pcidev->dev);=0A=
 	if(error) {=0A=
 		dprintk((KERN_ERR MYNAM=0A=

------_=_NextPart_000_01C54C48.69E29360--
