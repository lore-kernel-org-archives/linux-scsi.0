From: James.Smart@Emulex.Com
Subject: [PATCH 6 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:22 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F414B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43454 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261248AbVFYOeY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:24 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYM9P008190
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:23 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add LP6000 PCI ID

Fix driver not seeing LP6000.  Fix: add PCI id to the pci_device_id
table and a short description for the HBA in get_hba_model_desc().
Also add a default clause to the switch statement that parses the
various PCI ID's.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_init.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/scsi/lpfc/lpfc_init.c~lp6000 drivers/scsi/lpfc/lpfc_init.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_init.c~lp6000	2005-06-25 09:42:15.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_init.c	2005-06-25 09:42:15.000000000 -0400
@@ -780,6 +780,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	pci_read_config_dword(phba->pcidev, PCI_VENDOR_ID, &id);
 
 	switch ((id >> 16) & 0xffff) {
+	case PCI_DEVICE_ID_FIREFLY:
+		strcpy(str, "LP6000 1");
+		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
 			strcpy(str, "LP7000 1");
@@ -837,6 +840,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	case PCI_DEVICE_ID_LP10000S:
 		strcpy(str, "LP10000-S 2");
 		break;
+	default:
+		memset(str, 0, 16);
+		break;
 	}
 	if (mdp)
 		sscanf(str, "%s", mdp);
@@ -1662,6 +1668,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FIREFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_THOR,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PEGASUS,
_
