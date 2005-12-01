From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] mptfusion : dv performance fix
Date: Thu, 1 Dec 2005 10:50:32 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C051F3253@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5F69F.B99622F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63166 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932362AbVLARuv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 12:50:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, hch@infradead.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5F69F.B99622F0
Content-Type: text/plain

Syncronization for Domain Validation workqueue and the initiation of the
alternate controller.  Its possible that dv could be terminated if the
workqueue on the 1st channel doesn complete in time before the 2nd channel
begins initialization.

Pls apply for 2.6.15 kernel.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



------_=_NextPart_000_01C5F69F.B99622F0
Content-Type: application/octet-stream;
	name="performance.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="performance.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-12-01 09:22:51.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-12-01 09:25:46.000000000 =
-0700=0A=
@@ -1118,6 +1118,65 @@=0A=
 	return -1;=0A=
 }=0A=
 =0A=
+int=0A=
+mpt_alt_ioc_wait(MPT_ADAPTER *ioc)=0A=
+{=0A=
+	int loop_count =3D 30 * 4;  /* Wait 30 seconds */=0A=
+	int status =3D -1; /* -1 means failed to get board READY */=0A=
+=0A=
+	do {=0A=
+		spin_lock(&ioc->initializing_hba_lock);=0A=
+		if (ioc->initializing_hba_lock_flag =3D=3D 0) {=0A=
+			ioc->initializing_hba_lock_flag=3D1;=0A=
+			spin_unlock(&ioc->initializing_hba_lock);=0A=
+			status =3D 0;=0A=
+			break;=0A=
+		}=0A=
+		spin_unlock(&ioc->initializing_hba_lock);=0A=
+		set_current_state(TASK_INTERRUPTIBLE);=0A=
+		schedule_timeout(HZ/4);=0A=
+	} while (--loop_count);=0A=
+=0A=
+	return status;=0A=
+}=0A=
+=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
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
+	int r;=0A=
+=0A=
+	if(ioc->alt_ioc) {=0A=
+		if((r=3Dmpt_alt_ioc_wait(ioc->alt_ioc)!=3D0))=0A=
+			return r;=0A=
+	}=0A=
+=0A=
+	r =3D mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,=0A=
+	    CAN_SLEEP);=0A=
+=0A=
+	if(ioc->alt_ioc) {=0A=
+		spin_lock(&ioc->alt_ioc->initializing_hba_lock);=0A=
+		ioc->alt_ioc->initializing_hba_lock_flag=3D0;=0A=
+		spin_unlock(&ioc->alt_ioc->initializing_hba_lock);=0A=
+	}=0A=
+=0A=
+return r;=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mpt_attach - Install a PCI intelligent MPT adapter.=0A=
@@ -1186,6 +1245,7 @@=0A=
 	ioc->pcidev =3D pdev;=0A=
 	ioc->diagPending =3D 0;=0A=
 	spin_lock_init(&ioc->diagLock);=0A=
+	spin_lock_init(&ioc->initializing_hba_lock);=0A=
 =0A=
 	/* Initialize the event logging.=0A=
 	 */=0A=
@@ -1408,8 +1468,7 @@=0A=
 	 */=0A=
 	mpt_detect_bound_ports(ioc, pdev);=0A=
 =0A=
-	if ((r =3D mpt_do_ioc_recovery(ioc,=0A=
-	  MPT_HOSTEVENT_IOC_BRINGUP, CAN_SLEEP)) !=3D 0) {=0A=
+	if ((r =3D mpt_bringup_adapter(ioc, CAN_SLEEP)) !=3D 0){=0A=
 		printk(KERN_WARNING MYNAM=0A=
 		  ": WARNING - %s did not initialize properly! (%d)\n",=0A=
 		  ioc->name, r);=0A=
@@ -6298,6 +6357,7 @@=0A=
 EXPORT_SYMBOL(mpt_alloc_fw_memory);=0A=
 EXPORT_SYMBOL(mpt_free_fw_memory);=0A=
 EXPORT_SYMBOL(mptbase_sas_persist_operation);=0A=
+EXPORT_SYMBOL(mpt_alt_ioc_wait);=0A=
 =0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2005-12-01 09:22:51.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-12-01 09:26:45.000000000 =
-0700=0A=
@@ -611,6 +611,8 @@=0A=
 	int			 DoneCtx;=0A=
 	int			 TaskCtx;=0A=
 	int			 InternalCtx;=0A=
+	spinlock_t		 initializing_hba_lock;=0A=
+	int 	 		 initializing_hba_lock_flag;=0A=
 	struct list_head	 list;=0A=
 	struct net_device	*netdev;=0A=
 	struct list_head	 sas_topology;=0A=
@@ -1001,6 +1003,7 @@=0A=
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);=0A=
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);=0A=
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 =
persist_opcode);=0A=
+extern int	 mpt_alt_ioc_wait(MPT_ADAPTER *ioc);=0A=
 =0A=
 /*=0A=
  *  Public data decl's...=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-12-01 09:22:51.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-12-01 09:27:36.000000000 =
-0700=0A=
@@ -4162,6 +4162,12 @@=0A=
 						}=0A=
 					}=0A=
 =0A=
+					if(mpt_alt_ioc_wait(hd->ioc)!=3D0) {=0A=
+						ddvprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",=0A=
+						    hd->ioc->name));=0A=
+						continue;=0A=
+					}=0A=
+=0A=
 					if (mptscsih_doDv(hd, 0, id) =3D=3D 1) {=0A=
 						/* Untagged device was busy, try again=0A=
 						 */=0A=
@@ -4173,6 +4179,10 @@=0A=
 						hd->ioc->spi_data.dvStatus[id] &=3D ~(MPT_SCSICFG_DV_NOT_DONE | =
MPT_SCSICFG_DV_PENDING);=0A=
 					}=0A=
 =0A=
+					spin_lock(&hd->ioc->initializing_hba_lock);=0A=
+					hd->ioc->initializing_hba_lock_flag=3D0;=0A=
+					spin_unlock(&hd->ioc->initializing_hba_lock);=0A=
+=0A=
 					if (isPhysDisk) {=0A=
 						for (ii=3D0; ii < MPT_MAX_SCSI_DEVICES; ii++) {=0A=
 							if (hd->ioc->raid_data.isRaid & (1 << ii)) {=0A=

------_=_NextPart_000_01C5F69F.B99622F0--
