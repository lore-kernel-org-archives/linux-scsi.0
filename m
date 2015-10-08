From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Bugfix v4 2/2] eata: Ask for help to reset eata controllers for kexec
Date: Thu,  8 Oct 2015 10:51:15 +0800
Message-ID: <1444272675-14631-2-git-send-email-jiang.liu@linux.intel.com>
References: <1444272675-14631-1-git-send-email-jiang.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444272675-14631-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Hannes Reinecke <hare@suse.de>, Ballabio@vger.kernel.org, Dario <dario.ballabio@emc.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Arthur Marsh <arthur.marsh@internode.on.net> reported that with the first
patch applied, he still encountered troubles when doing kexec with eata
devices. Quote Arthur's report:
    To clarify, if the eata driver gets loaded once and stays loaded, at a
    kexec reboot attempt the "Synchronising SCSI cache" message is missing
    for the SCSI disk attached to the controller using the eata driver and
    eventually other error messages appear as seen in screen images that
    I have previously posted at
	http://www.users.on.net/~arthur.marsh/20150915547.jpg.

    If the eata driver is loaded, unloaded via modprobe -r, then reloaded,
    a kexec reboot shows 2 "Synchronising SCSI cache" messages for the SCSI
    disk attached to the controller using the eata driver and the kexec
    reboot is successful.

For more details, please refer to thread at:
	http://www.gossamer-threads.com/lists/linux/kernel/2251833
	https://lkml.org/lkml/2015/9/6/165

First I thought we could solve this issue by implementing a shutdown
callback to reset eata controllers when rebooting, but it turns out
that this patch doesn't really help. And due to limited knowledge about
eata controllers and lack of hardware for tests, helps from eata experts
are really welcomed!

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/scsi/eata.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 7315f8adcf65..b83abe283744 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1519,6 +1519,11 @@ static void eata2x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static void eata2x_pci_shutdown(struct pci_dev *pdev)
+{
+	port_remove(&pdev->dev);
+}
+
 static struct pci_device_id eata2x_tbl[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
 	{ },
@@ -1530,6 +1535,7 @@ static struct pci_driver eata2x_pci_driver = {
 	.id_table	= eata2x_tbl,
 	.probe		= eata2x_pci_probe,
 	.remove		= eata2x_pci_remove,
+	.shutdown	= eata2x_pci_shutdown,
 };
 
 static int eata2x_register_pci_driver(void)
@@ -1571,8 +1577,14 @@ static int __exit eata2x_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void eata2x_platform_shutdown(struct platform_device *pdev)
+{
+	port_remove(&pdev->dev);
+}
+
 static struct platform_driver eata2x_platform_driver = {
 	.remove = __exit_p(eata2x_platform_remove),
+	.shutdown = eata2x_platform_shutdown,
 	.driver = {
 		.name	= "eata_plat",
 		.owner	= THIS_MODULE,
-- 
1.7.10.4
