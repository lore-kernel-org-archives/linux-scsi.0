From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 7/8] snic: add scsi host after determining max IOs.
Date: Thu, 17 Mar 2016 00:51:16 -0700
Message-ID: <1458201077-10211-7-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:27530 "EHLO
	alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbcCQH5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:38 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

scsi host is added after negotiating the max number of IOs with Firmware.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_main.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 37ec507..396b32d 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -631,19 +631,6 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_tmreq_pool;
 	}
 
-	/*
-	 * Initialization done with PCI system, hardware, firmware.
-	 * Add shost to SCSI
-	 */
-	ret = snic_add_host(shost, pdev);
-	if (ret) {
-		SNIC_HOST_ERR(shost,
-			      "Adding scsi host Failed ... exiting. %d\n",
-			      ret);
-
-		goto err_notify_unset;
-	}
-
 	spin_lock_irqsave(&snic_glob->snic_list_lock, flags);
 	list_add_tail(&snic->list, &snic_glob->snic_list);
 	spin_unlock_irqrestore(&snic_glob->snic_list_lock, flags);
@@ -676,8 +663,6 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < snic->intr_count; i++)
 		svnic_intr_unmask(&snic->intr[i]);
 
-	snic_set_state(snic, SNIC_ONLINE);
-
 	/* Get snic params */
 	ret = snic_get_conf(snic);
 	if (ret) {
@@ -688,6 +673,21 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_get_conf;
 	}
 
+	/*
+	 * Initialization done with PCI system, hardware, firmware.
+	 * Add shost to SCSI
+	 */
+	ret = snic_add_host(shost, pdev);
+	if (ret) {
+		SNIC_HOST_ERR(shost,
+			      "Adding scsi host Failed ... exiting. %d\n",
+			      ret);
+
+		goto err_get_conf;
+	}
+
+	snic_set_state(snic, SNIC_ONLINE);
+
 	ret = snic_disc_start(snic);
 	if (ret) {
 		SNIC_HOST_ERR(shost, "snic_probe:Discovery Failed w err = %d\n",
@@ -712,6 +712,8 @@ err_req_intr:
 	svnic_dev_disable(snic->vdev);
 
 err_vdev_enable:
+	svnic_dev_notify_unset(snic->vdev);
+
 	for (i = 0; i < snic->wq_count; i++) {
 		int rc = 0;
 
@@ -725,9 +727,6 @@ err_vdev_enable:
 	}
 	snic_del_host(snic->shost);
 
-err_notify_unset:
-	svnic_dev_notify_unset(snic->vdev);
-
 err_free_tmreq_pool:
 	mempool_destroy(snic->req_pool[SNIC_REQ_TM_CACHE]);
 
-- 
1.8.5.4

