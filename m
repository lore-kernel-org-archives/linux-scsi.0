From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/11] mpt2sas: Removed compiler warnnings when logging is disabled
Date: Sat, 13 Nov 2010 04:29:20 +0530
Message-ID: <20101112225912.GC853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59927 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582Ab0KLXln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:41:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

The compiler throws warning messages while compiling without
CONFIG_SCSI_MPT2SAS_LOGGING.
Set proper ifdef for CONFIG_SCSI_MPT2SAS_LOGGING to avoid warnnings.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index b774973..6f7e9b2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -80,6 +80,7 @@ enum block_state {
 	BLOCKING,
 };
 
+#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
  * _ctl_sas_device_find_by_handle - sas device search
  * @ioc: per adapter object
@@ -106,7 +107,6 @@ _ctl_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	return r;
 }
 
-#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
  * _ctl_display_some_debug - debug routine
  * @ioc: per adapter object
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..9bf5c16 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2715,9 +2715,10 @@ static u8
 _scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
     u8 msix_index, u32 reply)
 {
+#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	Mpi2SasIoUnitControlReply_t *mpi_reply =
 	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
-
+#endif
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "sc_complete:handle(0x%04x), (open) "
 	    "smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
