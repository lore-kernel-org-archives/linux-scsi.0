From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/17] mpt fusion: [2.6.30-rc6][Reviewed]Added support for MPT discovery completion check
Date: Fri, 29 May 2009 16:38:14 +0530
Message-ID: <20090529110809.GC10181@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:35972 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZE2L3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 07:29:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


sas_discovery_quiesce_io flag is used to control IO start/resume functionality.
IO will be stoped while doing discovery of topology. Once discovery is completed
It will resume IO. Resending patch including James review.

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a663692..54326e0 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -277,6 +277,56 @@ mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
 }
 
 /**
+ * mpt_is_discovery_complete - determine if discovery has completed
+ * @ioc: per adatper instance
+ *
+ * Returns 1 when discovery completed, else zero.
+ */
+static int
+mpt_is_discovery_complete(MPT_ADAPTER *ioc)
+{
+	ConfigExtendedPageHeader_t hdr;
+	CONFIGPARMS cfg;
+	SasIOUnitPage0_t *buffer;
+	dma_addr_t dma_handle;
+	int rc = 0;
+
+	memset(&hdr, 0, sizeof(ConfigExtendedPageHeader_t));
+	memset(&cfg, 0, sizeof(CONFIGPARMS));
+	hdr.PageVersion = MPI_SASIOUNITPAGE0_PAGEVERSION;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
+	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_IO_UNIT;
+	cfg.cfghdr.ehdr = &hdr;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+
+	if ((mpt_config(ioc, &cfg)))
+		goto out;
+	if (!hdr.ExtPageLength)
+		goto out;
+
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+	    &dma_handle);
+	if (!buffer)
+		goto out;
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if ((mpt_config(ioc, &cfg)))
+		goto out_free_consistent;
+
+	if (!(buffer->PhyData[0].PortFlags &
+	    MPI_SAS_IOUNIT0_PORT_FLAGS_DISCOVERY_IN_PROGRESS))
+		rc = 1;
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
+	    buffer, dma_handle);
+ out:
+	return rc;
+}
+
+/**
  *	mpt_fault_reset_work - work performed on workq after ioc fault
  *	@work: input argument, used to derive ioc
  *
@@ -307,6 +357,12 @@ mpt_fault_reset_work(struct work_struct *work)
 			printk(MYIOC_s_WARN_FMT "IOC is in FAULT state after "
 			    "reset (%04xh)\n", ioc->name, ioc_raw_state &
 			    MPI_DOORBELL_DATA_MASK);
+	} else if (ioc->bus_type == SAS && ioc->sas_discovery_quiesce_io) {
+		if ((mpt_is_discovery_complete(ioc))) {
+			devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "clearing "
+			    "discovery_quiesce_io flag\n", ioc->name));
+			ioc->sas_discovery_quiesce_io = 0;
+		}
 	}
 
  out:
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index e75300c..1b258b2 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -706,6 +706,7 @@ typedef struct _MPT_ADAPTER
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
+	u8			 sas_discovery_quiesce_io;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
 	struct work_struct	 sas_persist_task;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index b162f7a..40dbaaa 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1008,6 +1008,8 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 static int
 mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
+	MPT_SCSI_HOST	*hd;
+	MPT_ADAPTER	*ioc;
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
@@ -1016,6 +1018,12 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
+	hd = shost_priv(SCpnt->device->host);
+	ioc = hd->ioc;
+
+	if (ioc->sas_discovery_quiesce_io)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 //	scsi_print_command(SCpnt);
 
 	return mptscsih_qcmd(SCpnt,done);
@@ -3009,6 +3017,7 @@ mptsas_send_discovery_event(MPT_ADAPTER *ioc,
 	EVENT_DATA_SAS_DISCOVERY *discovery_data)
 {
 	struct mptsas_discovery_event *ev;
+	u32 discovery_status;
 
 	/*
 	 * DiscoveryStatus
@@ -3017,7 +3026,9 @@ mptsas_send_discovery_event(MPT_ADAPTER *ioc,
 	 * kicks off discovery, and return to zero
 	 * once its completed.
 	 */
-	if (discovery_data->DiscoveryStatus)
+	discovery_status = le32_to_cpu(discovery_data->DiscoveryStatus);
+	ioc->sas_discovery_quiesce_io = discovery_status ? 1 : 0;
+	if (discovery_status)
 		return;
 
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
@@ -3299,12 +3310,22 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return error;
 }
 
+void
+mptsas_shutdown(struct pci_dev *pdev)
+{
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+
+	ioc->sas_discovery_quiesce_io = 0;
+}
+
 static void __devexit mptsas_remove(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	struct mptsas_portinfo *p, *n;
 	int i;
 
+	mptsas_shutdown(pdev);
+
 	ioc->sas_discovery_ignore_events = 1;
 	sas_remove_host(ioc->sh);
 
@@ -3342,7 +3363,7 @@ static struct pci_driver mptsas_driver = {
 	.id_table	= mptsas_pci_table,
 	.probe		= mptsas_probe,
 	.remove		= __devexit_p(mptsas_remove),
-	.shutdown	= mptscsih_shutdown,
+	.shutdown	= mptsas_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
 	.resume		= mptscsih_resume,
