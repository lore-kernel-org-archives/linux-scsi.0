From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 3/5] PCI : Add selected_regions funcs
Date: Wed, 22 Nov 2006 17:06:22 +0900
Message-ID: <456404FE.1040708@jp.fujitsu.com>
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

    - Added new pci_request_selected_regions() and
      pci_release_selected_regions() for PCI legacy I/O port free
      drivers in order to request/release only the selected regions.

    - Added helper routine pci_select_bars() which makes proper mask
      of BARs from the specified resource type. This would be very
      helpful for users of pci_enable_device_bars().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 drivers/pci/pci.c   |   78 +++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/pci.h |    3 ++
 2 files changed, 65 insertions(+), 16 deletions(-)

Index: linux-2.6.19-rc6/drivers/pci/pci.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/pci/pci.c
+++ linux-2.6.19-rc6/drivers/pci/pci.c
@@ -758,6 +758,47 @@
 	return -EBUSY;
 }

+/**
+ * pci_release_selected_regions - Release selected PCI I/O and memory resources
+ * @pdev: PCI device whose resources were previously reserved
+ * @bars: Bitmask of BARs to be released
+ *
+ * Release selected PCI I/O and memory resources previously reserved.
+ * Call this function only after all use of the PCI regions has ceased.
+ */
+void pci_release_selected_regions(struct pci_dev *pdev, int bars)
+{
+	int i;
+
+	for (i = 0; i < 6; i++)
+		if (bars & (1 << i))
+			pci_release_region(pdev, i);
+}
+
+/**
+ * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
+ * @pdev: PCI device whose resources are to be reserved
+ * @bars: Bitmask of BARs to be requested
+ * @res_name: Name to be associated with resource
+ */
+int pci_request_selected_regions(struct pci_dev *pdev, int bars,
+				 const char *res_name)
+{
+	int i;
+
+	for (i = 0; i < 6; i++)
+		if (bars & (1 << i))
+			if(pci_request_region(pdev, i, res_name))
+				goto err_out;
+	return 0;
+
+err_out:
+	while(--i >= 0)
+		if (bars & (1 << i))
+			pci_release_region(pdev, i);
+
+	return -EBUSY;
+}

 /**
  *	pci_release_regions - Release reserved PCI I/O and memory resources
@@ -770,10 +811,7 @@

 void pci_release_regions(struct pci_dev *pdev)
 {
-	int i;
-	
-	for (i = 0; i < 6; i++)
-		pci_release_region(pdev, i);
+	pci_release_selected_regions(pdev, (1 << 6) - 1);
 }

 /**
@@ -791,18 +829,7 @@
  */
 int pci_request_regions(struct pci_dev *pdev, const char *res_name)
 {
-	int i;
-	
-	for (i = 0; i < 6; i++)
-		if(pci_request_region(pdev, i, res_name))
-			goto err_out;
-	return 0;
-
-err_out:
-	while(--i >= 0)
-		pci_release_region(pdev, i);
-		
-	return -EBUSY;
+	return pci_request_selected_regions(pdev, ((1 << 6) - 1), res_name);
 }

 /**
@@ -975,6 +1002,22 @@
 }
 #endif

+/**
+ * pci_select_bars - Make BAR mask from the type of resource
+ * @pdev: the PCI device for which BAR mask is made
+ * @flags: resource type mask to be selected
+ *
+ * This helper routine makes bar mask from the type of resource.
+ */
+int pci_select_bars(struct pci_dev *dev, unsigned long flags)
+{
+	int i, bars = 0;
+	for (i = 0; i < PCI_NUM_RESOURCES; i++)
+		if (pci_resource_flags(dev, i) & flags)
+			bars |= (1 << i);
+	return bars;
+}
+
 static int __devinit pci_init(void)
 {
 	struct pci_dev *dev = NULL;
@@ -1023,6 +1066,8 @@
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_release_region);
 EXPORT_SYMBOL(pci_request_region);
+EXPORT_SYMBOL(pci_release_selected_regions);
+EXPORT_SYMBOL(pci_request_selected_regions);
 EXPORT_SYMBOL(pci_set_master);
 EXPORT_SYMBOL(pci_set_mwi);
 EXPORT_SYMBOL(pci_clear_mwi);
@@ -1031,6 +1076,7 @@
 EXPORT_SYMBOL(pci_set_consistent_dma_mask);
 EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
+EXPORT_SYMBOL(pci_select_bars);

 EXPORT_SYMBOL(pci_set_power_state);
 EXPORT_SYMBOL(pci_save_state);
Index: linux-2.6.19-rc6/include/linux/pci.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/pci.h
+++ linux-2.6.19-rc6/include/linux/pci.h
@@ -514,6 +514,7 @@
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_assign_resource_fixed(struct pci_dev *dev, int i);
 void pci_restore_bars(struct pci_dev *dev);
+int pci_select_bars(struct pci_dev *dev, unsigned long flags);

 /* ROM control related routines */
 void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
@@ -542,6 +543,8 @@
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
 void pci_release_region(struct pci_dev *, int);
+int pci_request_selected_regions(struct pci_dev *, int, const char *);
+void pci_release_selected_regions(struct pci_dev *, int);

 /* drivers/pci/bus.c */
 int __must_check pci_bus_alloc_resource(struct pci_bus *bus,


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
