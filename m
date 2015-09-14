From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Bugfix 3/3] eata: Enhance eata driver to support PCI device hot-removal
Date: Mon, 14 Sep 2015 11:08:59 +0800
Message-ID: <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbbINDGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2015 23:06:06 -0400
In-Reply-To: <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org

Due to having no hardware for testing, this is just a sample code
to support PCI device hot-removal. It just passing compilation,
no any tests.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/scsi/eata.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index b92e6856f909..f3bd7cbf260e 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1474,6 +1474,21 @@ static unsigned int port_probe(unsigned long port_base,
 #ifdef CONFIG_PCI
 static int eata2x_pci_device_count;
 
+/* TODO: need help here to shutdown the scsi host and release resources */
+static void port_remove(unsigned int id, resource_size_t port_base,
+			struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = sh[id];
+
+	/* TODO: stop scsi device */
+	scsi_unregister(shost);
+	/* TODO: clean up resources allocated by port_detect() */
+	clear_bit(id, eata_board_bitmap);
+	free_irq(shost->irq, &sha[id]);
+	release_region(port_base, REGION_SIZE);
+	ida_simple_remove(&eata_ida, id);
+}
+
 static int eata2x_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int i, ret = -ENXIO;
@@ -1521,6 +1536,16 @@ out_error:
 	return ret;
 }
 
+static void eata2x_pci_remove(struct pci_dev *pdev)
+{
+	int id = (int)(long)dev_get_drvdata(&pdev->dev);
+	resource_size_t port_base;
+
+	port_base = pci_resource_start(pdev, 0) + PCI_BASE_ADDRESS_0;
+	port_remove(id, port_base, pdev);
+	pci_disable_device(pdev);
+}
+
 static struct pci_device_id eata2x_tbl[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
 	{ },
@@ -1531,6 +1556,7 @@ static struct pci_driver eata2x_pci_driver = {
 	.name		= "eata",
 	.id_table	= eata2x_tbl,
 	.probe		= eata2x_pci_probe,
+	.remove		= eata2x_pci_remove,
 };
 
 static int eata2x_probe_pci_devices(struct scsi_host_template *tpnt)
-- 
1.7.10.4

