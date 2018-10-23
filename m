From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v6 2/4] mpt3sas: Fix Sync cache command failure during driver unload
Date: Tue, 23 Oct 2018 15:51:19 +0530
Message-ID: <1540290081-15827-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: helgaas@kernel.org, lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

This is to fix Sync cache and start stop command
 failures with DID_NO_CONNECT during driver unload.

1) Release drives first from SML, then remove internally
in driver.
2) And allow sync cache and Start stop commands to firmware,
even when remove_host flag is set

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 38 ++++++++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  7 ++++--
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 4d73b5e..df56cbe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3748,6 +3748,40 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
 
+/** _scsih_allow_scmd_to_device - check whether scmd needs to
+ *				 issue to IOC or not.
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ *
+ * Returns true if scmd can be issued to IOC otherwise returns false.
+ */
+inline bool _scsih_allow_scmd_to_device(struct MPT3SAS_ADAPTER *ioc,
+	struct scsi_cmnd *scmd)
+{
+
+	if (ioc->pci_error_recovery)
+		return false;
+
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION) {
+		if (ioc->remove_host)
+			return false;
+
+		return true;
+	}
+
+	if (ioc->remove_host) {
+
+		switch (scmd->cmnd[0]) {
+		case SYNCHRONIZE_CACHE:
+		case START_STOP:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return true;
+}
 
 /**
  * _scsih_sas_control_complete - completion routine
@@ -4571,7 +4605,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
-	if (ioc->pci_error_recovery || ioc->remove_host) {
+	if (!(_scsih_allow_scmd_to_device(ioc, scmd))) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
@@ -9641,6 +9675,7 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	/* release all the volumes */
 	_scsih_ir_shutdown(ioc);
+	sas_remove_host(shost);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
 		if (raid_device->starget) {
@@ -9682,7 +9717,6 @@ static void scsih_remove(struct pci_dev *pdev)
 		ioc->sas_hba.num_phys = 0;
 	}
 
-	sas_remove_host(shost);
 	mpt3sas_base_detach(ioc);
 	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index bc1e67b..7d722b9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -807,10 +807,13 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			    mpt3sas_port->remote_identify.sas_address,
 			    mpt3sas_phy->phy_id);
 		mpt3sas_phy->phy_belongs_to_port = 0;
-		sas_port_delete_phy(mpt3sas_port->port, mpt3sas_phy->phy);
+		if (!ioc->remove_host)
+			sas_port_delete_phy(mpt3sas_port->port,
+						mpt3sas_phy->phy);
 		list_del(&mpt3sas_phy->port_siblings);
 	}
-	sas_port_delete(mpt3sas_port->port);
+	if (!ioc->remove_host)
+		sas_port_delete(mpt3sas_port->port);
 	kfree(mpt3sas_port);
 }
 
-- 
1.8.3.1
