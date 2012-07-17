From: <sreekanth.reddy@lsi.com>
Subject: [PATCH 07/09] [SCSI] mpt2sas : Fix for staged device discovery
 functionality of driver not working
Date: Tue, 17 Jul 2012 15:56:12 +0530
Message-ID: <20120717102612.GA7355@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46082 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754735Ab2GQKZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:25:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: jejb@kernel.org

This patch provides a command line option to disable "Port enable" during
the driver load.

The objective of this command line option is to load the driver and do
all the necessary initialization excluding port enable(i.e. delay
device discovery)

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3e231a7..7a69a5c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -119,6 +119,10 @@ module_param(diag_buffer_enable, int, 0);
 MODULE_PARM_DESC(diag_buffer_enable, " post diag buffers "
 	"(TRACE=1/SNAPSHOT=2/EXTENDED=4/default=0)");
 
+static int disable_discovery = -1;
+module_param(disable_discovery, int, 0);
+MODULE_PARM_DESC(disable_discovery, " disable discovery ");
+
 /**
  * struct sense_info - common structure for obtaining sense keys
  * @skey: sense key
@@ -5973,8 +5977,14 @@ _scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
 #endif
 
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED &&
-	    !ioc->sas_hba.num_phys)
+	    !ioc->sas_hba.num_phys) {
+		if (disable_discovery > 0 && ioc->shost_recovery) {
+			/* Wait for the reset to complete */
+			while (ioc->shost_recovery)
+				ssleep(1);
+		}
 		_scsih_sas_host_add(ioc);
+	}
 }
 
 /**
@@ -7929,6 +7939,9 @@ _scsih_scan_start(struct Scsi_Host *shost)
 	if (diag_buffer_enable != -1 && diag_buffer_enable != 0)
 		mpt2sas_enable_diag_buffer(ioc, diag_buffer_enable);
 
+	if (disable_discovery > 0)
+		return;
+
 	ioc->start_scan = 1;
 	rc = mpt2sas_port_enable(ioc);
 
@@ -7950,6 +7963,12 @@ _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 
+	if (disable_discovery > 0) {
+		ioc->is_driver_loading = 0;
+		ioc->wait_for_discovery_to_complete = 0;
+		return 1;
+	}
+
 	if (time >= (300 * HZ)) {
 		ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 		printk(MPT2SAS_INFO_FMT "port enable: FAILED with timeout "
