From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 4/6] mpt fusion - fix fibre channel infinite request/response
 loop
Date: Wed, 24 May 2006 15:07:40 -0500
Message-ID: <4474BD0C.1080403@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050903030807000704080302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:25753 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932226AbWEXUHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 16:07:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------050903030807000704080302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

While doing board reset testing I was able to put the system in
an infinite request/response loop between the scsi layer and
mptscsih_qcmd() by aborting the reset.  This patch installs
a "SETUP RESET" handler which calls fc_remote_port_delete()
for all registered rports.  This blocks the target which
prevents the loop.  Additionally, should the reset fail to
complete, the transport will now terminate i/o to the target.

(Insertion point changes.)

Signed-off-by: Michael Reed <mdr@sgi.com>





--------------050903030807000704080302
Content-Type: text/x-patch;
 name="04-mptfc_setup_reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-mptfc_setup_reset.patch"

While doing board reset testing I was able to put the system in
an infinite request/response loop between the scsi layer and
mptscsih_qcmd() by aborting the reset.  This patch installs
a "SETUP RESET" handler which calls fc_remote_port_delete()
for all registered rports.  This blocks the target which
prevents the loop.  Additionally, should the reset fail to
complete, the transport will now terminate i/o to the target.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc4u/drivers/message/fusion/mptbase.h	2006-05-24 14:39:18.792259154 -0500
+++ rc4/drivers/message/fusion/mptbase.h	2006-05-24 14:40:39.319168329 -0500
@@ -635,6 +635,7 @@
 	int			 num_ports;
 	struct work_struct	 mptscsih_persistTask;
 
+	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
 	spinlock_t		 fc_rescan_work_lock;
 	int			 fc_rescan_work_count;
--- rc4u/drivers/message/fusion/mptfc.c	2006-05-24 14:39:18.792259154 -0500
+++ rc4/drivers/message/fusion/mptfc.c	2006-05-24 14:40:39.323167905 -0500
@@ -580,10 +580,10 @@
 #ifdef DMPT_DEBUG_FC
 	if (unlikely(err)) {
 		dfcprintk ((MYIOC_s_INFO_FMT
-			"mptfc_qcmd.%d: %d:%d, mptscsih_qcmd returns non-zero.\n",
+			"mptfc_qcmd.%d: %d:%d, mptscsih_qcmd returns non-zero, (%x).\n",
 			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
 			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun));
+			SCpnt->device->id,SCpnt->device->lun,err));
 	}
 #endif
 	return err;
@@ -873,6 +873,31 @@
 }
 
 static void
+mptfc_setup_reset(void *arg)
+{
+	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
+	u64			pn;
+	struct mptfc_rport_info *ri;
+
+	/* reset about to happen, delete (block) all rports */
+	list_for_each_entry(ri, &ioc->fc_rports, list) {
+		if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
+			ri->flags &= ~MPT_RPORT_INFO_FLAGS_REGISTERED;
+			fc_remote_port_delete(ri->rport);	/* won't sleep */
+			ri->rport = NULL;
+
+			pn = (u64)ri->pg0.WWPN.High << 32 |
+			     (u64)ri->pg0.WWPN.Low;
+			dfcprintk ((MYIOC_s_INFO_FMT
+				"mptfc_setup_reset.%d: %llx deleted\n",
+				ioc->name,
+				ioc->sh->host_no,
+				(unsigned long long)pn));
+		}
+	}
+}
+
+static void
 mptfc_rescan_devices(void *arg)
 {
 	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
@@ -1008,6 +1033,7 @@
 
 	spin_lock_init(&ioc->fc_rescan_work_lock);
 	INIT_WORK(&ioc->fc_rescan_work, mptfc_rescan_devices,(void *)ioc);
+	INIT_WORK(&ioc->fc_setup_reset_work, mptfc_setup_reset, (void *)ioc);
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
@@ -1230,6 +1256,12 @@
 		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
 	if (reset_phase == MPT_IOC_SETUP_RESET) {
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		if (ioc->fc_rescan_work_q) {
+			queue_work(ioc->fc_rescan_work_q,
+				   &ioc->fc_setup_reset_work);
+		}
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 	}
 
 	else if (reset_phase == MPT_IOC_PRE_RESET) {

--------------050903030807000704080302--
