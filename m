From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH]: Fusion-MPT slowness workaround
Date: Tue, 1 Nov 2005 15:08:51 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04BE8626@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5DF30.D761B8F8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3829 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751270AbVKAWJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 17:09:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, Martin Devera <devik@cdi.cz>, bstroesser@fujitsu-siemens.com, rupert@aquabolt.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5DF30.D761B8F8
Content-Type: text/plain

On Tuesday, November 01, 2005 2:39 PM, Chen, Kenneth W wrote:
> > 
> > I've added spin-lock to control domain validation, and 
> > alternate controller bringup which are occuring at the same time,
> > and causing dv to fail.  Thanks to Kenneth Chen and Bodo Stroesser.
> 
> With the patch, Kernel hung at boot (2.6.14 is used).
> 

Try this patch instead.  Use it over 2.6.14, not over the
previous post.

This patch is one that Bodo provided.  Let me know the results.

Eric Moore


------_=_NextPart_000_01C5DF30.D761B8F8
Content-Type: application/octet-stream;
	name="performance-take2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="performance-take2.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-11-01 15:03:12.000000000 =
-0700=0A=
@@ -118,6 +118,7 @@=0A=
 static int	last_drv_idx =3D -1;=0A=
 =0A=
 static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);=0A=
+static DECLARE_WAIT_QUEUE_HEAD(mpt_host_bringup_waitq);=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -1659,6 +1660,7 @@=0A=
 						ioc->alt_ioc->name));=0A=
 				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, ~(MPI_HIM_RIM));=0A=
 				ioc->alt_ioc->active =3D 1;=0A=
+				wake_up(&mpt_host_bringup_waitq);=0A=
 			}=0A=
 =0A=
 		} else {=0A=
@@ -1783,6 +1785,7 @@=0A=
 				ioc->alt_ioc->name));=0A=
 		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, ~(MPI_HIM_RIM));=0A=
 		ioc->alt_ioc->active =3D 1;=0A=
+		wake_up(&mpt_host_bringup_waitq);=0A=
 	}=0A=
 =0A=
 	/*  Enable MPT base driver management of EventNotification=0A=
@@ -1893,6 +1896,15 @@=0A=
 	return ret;=0A=
 }=0A=
 =0A=
+int=0A=
+mpt_wait_active(MPT_ADAPTER *ioc)=0A=
+{=0A=
+	if (ioc->active =3D=3D 0)=0A=
+		return wait_event_timeout(mpt_host_bringup_waitq,=0A=
+		    ioc->active =3D=3D 1, HZ*15) <=3D0;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mpt_detect_bound_ports - Search for PCI bus/dev_function=0A=
@@ -6299,7 +6311,7 @@=0A=
 EXPORT_SYMBOL(mpt_alloc_fw_memory);=0A=
 EXPORT_SYMBOL(mpt_free_fw_memory);=0A=
 EXPORT_SYMBOL(mptbase_sas_persist_operation);=0A=
-=0A=
+EXPORT_SYMBOL(mpt_wait_active);=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-11-01 14:59:05.000000000 =
-0700=0A=
@@ -966,6 +966,7 @@=0A=
 extern int	 mpt_resume(struct pci_dev *pdev);=0A=
 #endif=0A=
 extern int	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS =
dclass);=0A=
+extern int	 mpt_wait_active(MPT_ADAPTER *ioc);=0A=
 extern void	 mpt_deregister(int cb_idx);=0A=
 extern int	 mpt_event_register(int cb_idx, MPT_EVHANDLER =
ev_cbfunc);=0A=
 extern void	 mpt_event_deregister(int cb_idx);=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-11-01 15:01:16.000000000 =
-0700=0A=
@@ -3789,6 +3789,12 @@=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
+	if (mpt_wait_active(hd->ioc)) {=0A=
+		ddvprintk((MYIOC_s_WARN_FMT "wait_event: no msg frames!\n",=0A=
+		    hd->ioc->name));=0A=
+		return -EBUSY;=0A=
+	}=0A=
+=0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
 	if ((mf =3D mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) =3D=3D =
NULL) {=0A=

------_=_NextPart_000_01C5DF30.D761B8F8--
