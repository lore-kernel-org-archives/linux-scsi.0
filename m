From: Michael Reed <mdr@sgi.com>
Subject: [RESEND][PATCH] fusion: fibre channel: stall eh handlers if resetting
 while rport blocked
Date: Fri, 06 Oct 2006 15:39:25 -0500
Message-ID: <4526BEFD.5010803@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060400020505030700050404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:7623 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932606AbWJFUj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2006 16:39:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

This is a multi-part message in MIME format.
--------------060400020505030700050404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch applies against scsi-misc-2.6 and 2.6.19-rc1-git2.
This patch was previously ACK'd by Eric Moore.

Thanks to James Smart for the inspiration.

Stall error handler if attempting recovery while an rport is blocked.
This avoids device offline scenarios due to errors in the error handler.
Also verify that VirtDevice is available before issuing scsi command.
VirtDevice is removed when fc transport removes a target.

See James Smart's patch of 08/17/2006 for greater detail.

http://marc.theaimsgroup.com/?l=linux-scsi&m=115583213624803&w=2

Also bump version number per Eric's request.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------060400020505030700050404
Content-Type: text/x-patch;
 name="mptfc_stall_recovery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mptfc_stall_recovery.patch"

--- smu/drivers/message/fusion/mptbase.h	2006-09-14 10:35:52.000000000 -0500
+++ sm/drivers/message/fusion/mptbase.h	2006-09-27 09:31:13.041300911 -0500
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.01"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.01"
+#define MPT_LINUX_VERSION_COMMON	"3.04.02"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.02"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
--- smu/drivers/message/fusion/mptfc.c	2006-09-14 10:35:52.000000000 -0500
+++ sm/drivers/message/fusion/mptfc.c	2006-09-26 15:55:39.451261887 -0500
@@ -96,6 +96,10 @@ static int mptfc_qcmd(struct scsi_cmnd *
 static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void __devexit mptfc_remove(struct pci_dev *pdev);
+static int mptfc_abort(struct scsi_cmnd *SCpnt);
+static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_host_reset(struct scsi_cmnd *SCpnt);
 
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
@@ -110,10 +114,10 @@ static struct scsi_host_template mptfc_d
 	.target_destroy			= mptfc_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
-	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
-	.eh_bus_reset_handler		= mptscsih_bus_reset,
-	.eh_host_reset_handler		= mptscsih_host_reset,
+	.eh_abort_handler		= mptfc_abort,
+	.eh_device_reset_handler	= mptfc_dev_reset,
+	.eh_bus_reset_handler		= mptfc_bus_reset,
+	.eh_host_reset_handler		= mptfc_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_FC_CAN_QUEUE,
 	.this_id			= -1,
@@ -171,6 +175,77 @@ static struct fc_function_template mptfc
 	.show_host_symbolic_name = 1,
 };
 
+static int
+mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
+			  int (*func)(struct scsi_cmnd *SCpnt),
+			  const char *caller)
+{
+	struct scsi_device	*sdev = SCpnt->device;
+	struct Scsi_Host	*shost = sdev->host;
+	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
+	unsigned long		flags;
+	int			ready;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		dfcprintk ((MYIOC_s_INFO_FMT
+			"mptfc_block_error_handler.%d: %d:%d, port status is "
+			"DID_IMM_RETRY, deferring %s recovery.\n",
+			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
+			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+			SCpnt->device->id,SCpnt->device->lun,caller));
+		msleep(1000);
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
+		dfcprintk ((MYIOC_s_INFO_FMT
+			"%s.%d: %d:%d, failing recovery, "
+			"port state %d, vdev %p.\n", caller,
+			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
+			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+			SCpnt->device->id,SCpnt->device->lun,ready,
+			SCpnt->device->hostdata));
+		return FAILED;
+	}
+	dfcprintk ((MYIOC_s_INFO_FMT
+		"%s.%d: %d:%d, executing recovery.\n", caller,
+		((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
+		((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+		SCpnt->device->id,SCpnt->device->lun));
+	return (*func)(SCpnt);
+}
+
+static int
+mptfc_abort(struct scsi_cmnd *SCpnt)
+{
+	return
+	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __FUNCTION__);
+}
+
+static int
+mptfc_dev_reset(struct scsi_cmnd *SCpnt)
+{
+	return
+	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __FUNCTION__);
+}
+
+static int
+mptfc_bus_reset(struct scsi_cmnd *SCpnt)
+{
+	return
+	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __FUNCTION__);
+}
+
+static int
+mptfc_host_reset(struct scsi_cmnd *SCpnt)
+{
+	return
+	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __FUNCTION__);
+}
+
 static void
 mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
@@ -562,6 +637,12 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void
 		return 0;
 	}
 
+	if (!SCpnt->device->hostdata) {	/* vdev */
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
+	}
+
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {


--------------060400020505030700050404--
