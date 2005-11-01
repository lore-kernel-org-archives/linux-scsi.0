From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH]: Fusion-MPT slowness workaround
Date: Tue, 1 Nov 2005 12:34:48 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04BE8405@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5DF1B.51CDC488"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6371 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751190AbVKATfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 14:35:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Devera <devik@cdi.cz>, bstroesser@fujitsu-siemens.com, rupert@aquabolt.com, kenneth.w.chen@intel.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5DF1B.51CDC488
Content-Type: text/plain

On Tuesday, November 01, 2005 11:12 AM, Martin Devera wrote: 
> > NACK. Disabling DV is not the solution.
> > 
> > I have a fix I will post sometime this week.
> 
> excellent. Just to make it clear, I posted this one as quick 
> workaround not
> as final solution attempt.
> Please consider CCing me when the patch will be available - 
> I'll be pleased
> to test it :-)
> 

Here is a patch I would like to have tested to address the
performance issue many have posted to the forum.

I've added spin-lock to control domain validation, and 
alternate controller bringup which are occuring at the same time,
and causing dv to fail.  Thanks to Kenneth Chen and Bodo Stroesser.

Eric Moore
LSI Logic



------_=_NextPart_000_01C5DF1B.51CDC488
Content-Type: application/octet-stream;
	name="performance.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="performance.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-11-01 12:25:35.000000000 =
-0700=0A=
@@ -1121,6 +1121,38 @@=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
+ *	mpt_bringup_adapter - This is a wrapper function for =
mpt_do_ioc_recovery=0A=
+ *	@ioc: Pointer to MPT adapter structure=0A=
+ *	@sleepFlag: Use schedule if CAN_SLEEP else use udelay.=0A=
+ *=0A=
+ *	This routine performs all the steps necessary to bring the IOC=0A=
+ *	to a OPERATIONAL state.=0A=
+ *=0A=
+ *      Special Note: This function was added with spin lock's so as =
to allow=0A=
+ *      the dv(domain validation) work thread to succeed on the other =
channel=0A=
+ *      that maybe occuring at the same time when this function is =
called.=0A=
+ *      Without this lock, the dv would fail when message frames =
were=0A=
+ *      requested during hba bringup on the alternate ioc.=0A=
+ */=0A=
+static int=0A=
+mpt_bringup_adapter(MPT_ADAPTER *ioc, int sleepFlag)=0A=
+{=0A=
+int r;=0A=
+=0A=
+	if(ioc->alt_ioc)=0A=
+		spin_lock(&ioc->alt_ioc->initializing_hba_lock);=0A=
+=0A=
+	r =3D mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,=0A=
+	    CAN_SLEEP);=0A=
+=0A=
+	if(ioc->alt_ioc)=0A=
+		spin_unlock(&ioc->alt_ioc->initializing_hba_lock);=0A=
+=0A=
+return r;=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
  *	mpt_attach - Install a PCI intelligent MPT adapter.=0A=
  *	@pdev: Pointer to pci_dev structure=0A=
  *=0A=
@@ -1187,6 +1219,7 @@=0A=
 	ioc->pcidev =3D pdev;=0A=
 	ioc->diagPending =3D 0;=0A=
 	spin_lock_init(&ioc->diagLock);=0A=
+	spin_lock_init(&ioc->initializing_hba_lock);=0A=
 =0A=
 	/* Initialize the event logging.=0A=
 	 */=0A=
@@ -1409,8 +1442,7 @@=0A=
 	 */=0A=
 	mpt_detect_bound_ports(ioc, pdev);=0A=
 =0A=
-	if ((r =3D mpt_do_ioc_recovery(ioc,=0A=
-	  MPT_HOSTEVENT_IOC_BRINGUP, CAN_SLEEP)) !=3D 0) {=0A=
+	if ((r =3D mpt_bringup_adapter(ioc, CAN_SLEEP)) !=3D 0){=0A=
 		printk(KERN_WARNING MYNAM=0A=
 		  ": WARNING - %s did not initialize properly! (%d)\n",=0A=
 		  ioc->name, r);=0A=
@@ -6300,7 +6332,6 @@=0A=
 EXPORT_SYMBOL(mpt_free_fw_memory);=0A=
 EXPORT_SYMBOL(mptbase_sas_persist_operation);=0A=
 =0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	fusion_init - Fusion MPT base driver initialization routine.=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-11-01 12:08:50.000000000 =
-0700=0A=
@@ -601,6 +601,7 @@=0A=
 	int			 DoneCtx;=0A=
 	int			 TaskCtx;=0A=
 	int			 InternalCtx;=0A=
+	spinlock_t		 initializing_hba_lock;=0A=
 	struct list_head	 list;=0A=
 	struct net_device	*netdev;=0A=
 	struct list_head	 sas_topology;=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-10-27 18:02:08.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-11-01 12:24:27.000000000 =
-0700=0A=
@@ -3549,6 +3549,9 @@=0A=
 =0A=
 	ddvprintk((MYIOC_s_WARN_FMT "Timer Expired! Cmd %p\n", hd->ioc->name, =
hd->cmdPtr));=0A=
 =0A=
+	if(spin_is_locked(&hd->ioc->initializing_hba_lock))=0A=
+		spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
+=0A=
 	if (hd->cmdPtr) {=0A=
 		MPIHeader_t *cmd =3D (MPIHeader_t *)hd->cmdPtr;=0A=
 =0A=
@@ -3690,7 +3693,7 @@=0A=
 	in_isr =3D in_interrupt();=0A=
 	if (in_isr) {=0A=
 		dprintk((MYIOC_s_WARN_FMT "Internal SCSI IO request not allowed in =
ISR context!\n",=0A=
-       				hd->ioc->name));=0A=
+				hd->ioc->name));=0A=
 		return -EPERM;=0A=
 	}=0A=
 =0A=
@@ -3789,11 +3792,14 @@=0A=
 		return -EFAULT;=0A=
 	}=0A=
 =0A=
+	spin_lock(&hd->ioc->initializing_hba_lock);=0A=
+=0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
 	if ((mf =3D mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) =3D=3D =
NULL) {=0A=
 		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",=0A=
 					hd->ioc->name));=0A=
+		spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
 		return -EBUSY;=0A=
 	}=0A=
 =0A=
@@ -3883,6 +3889,7 @@=0A=
 	add_timer(&hd->timer);=0A=
 	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);=0A=
 	wait_event(hd->scandv_waitq, hd->scandv_wait_done);=0A=
+	spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
 =0A=
 	if (hd->pLocal) {=0A=
 		rc =3D hd->pLocal->completion;=0A=

------_=_NextPart_000_01C5DF1B.51CDC488--
