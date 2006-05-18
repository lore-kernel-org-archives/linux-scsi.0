From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 4/6] mpt fusion - fix fibre channel infinite request/response
 loop
Date: Thu, 18 May 2006 15:00:17 -0500
Message-ID: <446CD251.8090307@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070802020305060303020209"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:50873 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751394AbWERUAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 16:00:19 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4IMI58V010630
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 15:18:05 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k4IK0H4126267909
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 13:00:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070802020305060303020209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

While doing board reset testing I was able to put the system in
an infinite request/response loop between the scsi layer and
mptscsih_qcmd() by aborting the reset.  This patch installs
a "SETUP RESET" handler which calls fc_remote_port_delete()
for all registered rports.  This blocks the target which
prevents the loop.  Additionally, should the reset fail to
complete, the transport will now terminate i/o to the target.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------070802020305060303020209
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


--- rc3c/drivers/message/fusion/mptbase.h	2006-05-08 14:49:37.730936614 -0500
+++ rc3/drivers/message/fusion/mptbase.h	2006-05-08 14:50:02.161951124 -0500
@@ -635,6 +635,7 @@
 	int			 num_ports;
 	struct work_struct	 mptscsih_persistTask;
 
+	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
 	spinlock_t		 fc_rescan_work_lock;
 	int			 fc_rescan_work_count;
--- rc3c/drivers/message/fusion/mptfc.c	2006-05-08 14:49:37.730936614 -0500
+++ rc3/drivers/message/fusion/mptfc.c	2006-05-08 14:50:02.161951124 -0500
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
@@ -1018,6 +1043,7 @@
 
 	spin_lock_init(&ioc->fc_rescan_work_lock);
 	INIT_WORK(&ioc->fc_rescan_work, mptfc_rescan_devices,(void *)ioc);
+	INIT_WORK(&ioc->fc_setup_reset_work, mptfc_setup_reset, (void *)ioc);
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
@@ -1240,6 +1266,12 @@
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

--------------070802020305060303020209--
