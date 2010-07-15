From: Peter Huewe <PeterHuewe@gmx.de>
Subject: [PATCH 25/25] message/fusion: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:09:24 +0200
Message-ID: <201007152109.25219.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43711 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934497Ab0GOTJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2010 15:09:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, James Bottomley <James.Bottomley@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Tejun Heo <tj@kernel.org>, Michael Reed <mdr@sgi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/message/fusion/mptfc.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index b5f03ad..19dad15 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -139,24 +139,15 @@ static struct scsi_host_template mptfc_driver_template = {
  */
 
 static struct pci_device_id mptfc_pci_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC939X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_BROCADE, MPI_MANUFACTPAGE_DEVICEID_FC949E,
-		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC939X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E), },
+	{ PCI_VDEVICE(BROCADE, MPI_MANUFACTPAGE_DEVICEID_FC949E), },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);
-- 
1.7.1

