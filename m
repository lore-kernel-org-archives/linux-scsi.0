From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/5] mpt fusion: Added support for MPT discovery completion check
Date: Tue, 6 Jan 2009 15:06:59 +0530
Message-ID: <20090106093654.GG13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:60204 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZAFJ43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 04:56:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, sathyap@lsi.com, James.Bottomley@HansenPartnership.com


Added support for MPT discovery completion check. 
Now using mpt_is_discovery_complete we can make sure that there is no more pending MPT discovery command with Firmware.
---

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index b473236..d677b56 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -45,7 +45,6 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -278,6 +277,57 @@ mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
 	return 0;
 }
 
+/*
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
+
 /**
  *	mpt_fault_reset_work - work performed on workq after ioc fault
  *	@work: input argument, used to derive ioc
@@ -286,8 +336,8 @@ mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
 static void
 mpt_fault_reset_work(struct work_struct *work)
 {
-	MPT_ADAPTER	*ioc =
-	    container_of(work, MPT_ADAPTER, fault_reset_work.work);
+	MPT_ADAPTER     *ioc =
+		container_of(work, MPT_ADAPTER, fault_reset_work.work);
 	u32		 ioc_raw_state;
 	int		 rc;
 	unsigned long	 flags;
@@ -303,14 +353,21 @@ mpt_fault_reset_work(struct work_struct *work)
 		       ioc->name, __func__);
 		rc = mpt_HardResetHandler(ioc, CAN_SLEEP);
 		printk(MYIOC_s_WARN_FMT "%s: HardReset: %s\n", ioc->name,
-		       __func__, (rc == 0) ? "success" : "failed");
+			__func__, (rc == 0) ? "success" : "failed");
 		ioc_raw_state = mpt_GetIocState(ioc, 0);
 		if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT)
 			printk(MYIOC_s_WARN_FMT "IOC is in FAULT state after "
-			    "reset (%04xh)\n", ioc->name, ioc_raw_state &
-			    MPI_DOORBELL_DATA_MASK);
+				"reset (%04xh)\n", ioc->name, ioc_raw_state &
+				MPI_DOORBELL_DATA_MASK);
+	} else if (ioc->bus_type == SAS && ioc->sas_discovery_quiesce_io) {
+		if ((mpt_is_discovery_complete(ioc))) {
+			devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "clearing "
+			 "discovery_quiesce_io flag\n", ioc->name));
+			 ioc->sas_discovery_quiesce_io = 0;
+		}
 	}
 
+
  out:
 	/*
 	 * Take turns polling alternate controller
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b3e981d..50f8bb6 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -697,6 +697,7 @@ typedef struct _MPT_ADAPTER
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
+	u8			 sas_discovery_quiesce_io;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
 	struct work_struct	 sas_persist_task;
