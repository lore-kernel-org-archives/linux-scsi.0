From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 09/15] mpt3sas: Allow processing of events during driver  unload.
Date: Fri, 30 Mar 2018 15:07:18 +0530
Message-ID: <1522402644-3016-10-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Events were not processed during driver unload, hence unloading of driver
doesn't complete when drives are disconnected while unloading of driver.
So don't block events in ISR path, i,e., remove the flag ioc->remove_host
so that events are getting processed during driver unload.
Thus allowing driver unload to complete by processing drive removal events
during driver unload.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ec86ec5..9d7099d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3677,11 +3677,7 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 ioc_state;
 	struct _sc_list *delayed_sc;
 
-	if (ioc->remove_host) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: host has been removed\n", __func__, ioc->name));
-		return 1;
-	} else if (ioc->pci_error_recovery) {
+	if (ioc->pci_error_recovery) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
 			"%s: host in pci error recovery\n", __func__,
 			ioc->name));
@@ -3803,8 +3799,7 @@ _scsih_tm_tr_volume_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	u16 smid;
 	struct _tr_list *delayed_tr;
 
-	if (ioc->shost_recovery || ioc->remove_host ||
-	    ioc->pci_error_recovery) {
+	if (ioc->pci_error_recovery) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
 			"%s: host reset in progress!\n",
 			__func__, ioc->name));
@@ -3857,8 +3852,7 @@ _scsih_tm_volume_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	Mpi2SCSITaskManagementReply_t *mpi_reply =
 	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
-	if (ioc->shost_recovery || ioc->remove_host ||
-	    ioc->pci_error_recovery) {
+	if (ioc->shost_recovery || ioc->pci_error_recovery) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
 			"%s: host reset in progress!\n",
 			__func__, ioc->name));
@@ -9477,8 +9471,8 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	u16 sz;
 	Mpi26EventDataActiveCableExcept_t *ActiveCableEventData;
 
-	/* events turned off due to host reset or driver unloading */
-	if (ioc->remove_host || ioc->pci_error_recovery)
+	/* events turned off due to host reset */
+	if (ioc->pci_error_recovery)
 		return 1;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
-- 
1.8.3.1
