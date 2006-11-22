From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 2/5] PCI : Move pci_fixup_device and is_enabled
Date: Wed, 22 Nov 2006 17:06:07 +0900
Message-ID: <456404EF.3090902@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Cc: Andrew Morton <akpm@osdl.org>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds the following changes into generic PCI code especially
for PCI legacy I/O port free drivers.

    - Moved the following two things from pci_enable_device() into
      pci_enable_device_bars(). Already some drivers are using
      pci_enable_device_bars() to enable only the specific regions,
      but they had no chance to be fixup and to up is_enabled flag.

          o Call pci_fixup_device() on the device
          o Checking & Setting dev->is_enabled

    - Trivial cleanup

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 drivers/pci/pci.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6.19-rc6/drivers/pci/pci.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/pci/pci.c
+++ linux-2.6.19-rc6/drivers/pci/pci.c
@@ -558,12 +558,18 @@
 {
 	int err;

+	if (dev->is_enabled)
+		return 0;
+
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
 		return err;
 	err = pcibios_enable_device(dev, bars);
 	if (err < 0)
 		return err;
+
+	pci_fixup_device(pci_fixup_enable, dev);
+	dev->is_enabled = 1;
 	return 0;
 }

@@ -578,17 +584,7 @@
 int
 pci_enable_device(struct pci_dev *dev)
 {
-	int err;
-
-	if (dev->is_enabled)
-		return 0;
-
-	err = pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
-	if (err)
-		return err;
-	pci_fixup_device(pci_fixup_enable, dev);
-	dev->is_enabled = 1;
-	return 0;
+	return pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
 }

 /**
@@ -737,7 +733,7 @@
 {
 	if (pci_resource_len(pdev, bar) == 0)
 		return 0;
-		
+
 	if (pci_resource_flags(pdev, bar) & IORESOURCE_IO) {
 		if (!request_region(pci_resource_start(pdev, bar),
 			    pci_resource_len(pdev, bar), res_name))


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
