From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Remove unused variable requeue_event
Date: Sat,  2 Dec 2017 02:19:26 -0800
Message-ID: <1512209966-27239-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34790 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdLBKTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Dec 2017 05:19:52 -0500
Received: by mail-qk0-f195.google.com with SMTP id d66so16205109qkg.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Dec 2017 02:19:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com

No Functional change just cleanup,
Removed variable requeue_event and made function as void.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 362f406..c71f964 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7211,7 +7211,7 @@ _scsih_pcie_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
  * Context: user.
  *
  */
-static int
+static void
 _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
@@ -7221,7 +7221,6 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u8 link_rate, prev_link_rate;
 	unsigned long flags;
 	int rc;
-	int requeue_event;
 	Mpi26EventDataPCIeTopologyChangeList_t *event_data =
 		(Mpi26EventDataPCIeTopologyChangeList_t *) fw_event->event_data;
 	struct _pcie_device *pcie_device;
@@ -7231,12 +7230,12 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
 	if (ioc->shost_recovery || ioc->remove_host ||
 		ioc->pci_error_recovery)
-		return 0;
+		return;
 
 	if (fw_event->ignore) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT "ignoring switch event\n",
 			ioc->name));
-		return 0;
+		return;
 	}
 
 	/* handle siblings events */
@@ -7244,10 +7243,10 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 		if (fw_event->ignore) {
 			dewtprintk(ioc, pr_info(MPT3SAS_FMT
 				"ignoring switch event\n", ioc->name));
-			return 0;
+			return;
 		}
 		if (ioc->remove_host || ioc->pci_error_recovery)
-			return 0;
+			return;
 		reason_code = event_data->PortEntry[i].PortStatus;
 		handle =
 			le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
@@ -7316,7 +7315,6 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			break;
 		}
 	}
-	return requeue_event;
 }
 
 /**
-- 
2.5.5
