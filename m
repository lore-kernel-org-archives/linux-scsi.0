From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/3] mpt2sas: Wait for port enable to get complete before reporting devices to OS.
Date: Wed, 4 Aug 2010 14:04:05 +0530
Message-ID: <20100804083355.GB13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:56430 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209Ab0HDJL5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 05:11:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Add support in driver so it will wait for discovery to complete
before returning from the send_port_enable routine.  There are some
cases where firmware is doing discovery after port enable completes.
When it does this, the driver will not have all the devices in the
sas_device_init_list list prior to calling the sort routine for reporting
boot devices to OS.

This patch is required so the driver is waiting for all the events to
be processed in the hot plug worker thread prior to reporting them to the
OS.

(1) The driver will wait for port enable to complete
(2) Wait for the first discovery stop event
(3) Wait an additional 500ms in case there are additional discoveries
(4) process device list -> reporting devcies to OS

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 57bcd5c..be160e0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3113,6 +3113,9 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 
+	if (ioc->wait_for_port_enable_to_complete)
+		init_completion(&ioc->port_enable_done);
+
 	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
@@ -3138,6 +3141,12 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		    " (ioc_state=0x%x)\n", ioc->name, __func__, ioc_state);
 		r = -EFAULT;
 	}
+
+	/* this is waiting for the discovery to complete */
+	if (ioc->wait_for_port_enable_to_complete && ioc_state == 0) {
+		wait_for_completion(&ioc->port_enable_done);
+		msleep(500); /* in case there are additional discoveries */
+	}
  out:
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 	printk(MPT2SAS_INFO_FMT "port enable: %s\n",
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 0ebef0c..3c1b088 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -620,6 +620,7 @@ struct MPT2SAS_ADAPTER {
 	u8		remove_host;
 	u8		pci_error_recovery;
 	u8		wait_for_port_enable_to_complete;
+	struct completion	port_enable_done;
 
 	u8		msix_enable;
 	u16		msix_vector_count;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6273abd..0e82863 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5125,6 +5125,10 @@ _scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED &&
 	    !ioc->sas_hba.num_phys)
 		_scsih_sas_host_add(ioc);
+
+	if (ioc->wait_for_port_enable_to_complete &&
+	    event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_COMPLETED)
+		complete(&ioc->port_enable_done);
 }
 
 /**
