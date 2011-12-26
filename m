From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH v2] fusion: use pci_dev->revision
Date: Mon, 26 Dec 2011 19:36:32 +0300
Message-ID: <201112261936.32878.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:57931 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755656Ab1LZPhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 10:37:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, support@lsi.com, linux-kernel@vger.kernel.org

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision).

In one case, it even reads PCI revision ID without using it -- that code is now
removed...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This patch is refreshed against the recent Linus' tree.
This patch hasn't been applied to 3.1 or 3.2, hopefully it can be applied to
3.3 at last...

 drivers/message/fusion/mptbase.c |   12 ++++--------
 drivers/message/fusion/mptctl.c  |    4 +---
 2 files changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -1652,7 +1652,6 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	unsigned long	 port;
 	u32		 msize;
 	u32		 psize;
-	u8		 revision;
 	int		 r = -ENODEV;
 	struct pci_dev *pdev;
 
@@ -1669,8 +1668,6 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return r;
 	}
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-
 	if (sizeof(dma_addr_t) > 4) {
 		const uint64_t required_mask = dma_get_required_mask
 		    (&pdev->dev);
@@ -1778,7 +1775,6 @@ mpt_attach(struct pci_dev *pdev, const s
 	MPT_ADAPTER	*ioc;
 	u8		 cb_idx;
 	int		 r = -ENODEV;
-	u8		 revision;
 	u8		 pcixcmd;
 	static int	 mpt_ids = 0;
 #ifdef CONFIG_PROC_FS
@@ -1886,8 +1882,8 @@ mpt_attach(struct pci_dev *pdev, const s
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
 	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
+	mpt_get_product_name(pdev->vendor, pdev->device, pdev->revision,
+			     ioc->prod_name);
 
 	switch (pdev->device)
 	{
@@ -1902,7 +1898,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		break;
 
 	case MPI_MANUFACTPAGE_DEVICEID_FC929X:
-		if (revision < XL_929) {
+		if (pdev->revision < XL_929) {
 			/* 929X Chip Fix. Set Split transactions level
 		 	* for PCIX. Set MOST bits to zero.
 		 	*/
@@ -1933,7 +1929,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		/* 1030 Chip Fix. Disable Split transactions
 		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
 		 */
-		if (revision < C0_1030) {
+		if (pdev->revision < C0_1030) {
 			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
 			pcixcmd &= 0x8F;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
Index: linux-2.6/drivers/message/fusion/mptctl.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptctl.c
+++ linux-2.6/drivers/message/fusion/mptctl.c
@@ -1250,7 +1250,6 @@ mptctl_getiocinfo (unsigned long arg, un
 	int			iocnum;
 	unsigned int		port;
 	int			cim_rev;
-	u8			revision;
 	struct scsi_device 	*sdev;
 	VirtDevice		*vdevice;
 
@@ -1324,8 +1323,7 @@ mptctl_getiocinfo (unsigned long arg, un
 	pdev = (struct pci_dev *) ioc->pcidev;
 
 	karg->pciId = pdev->device;
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	karg->hwRev = revision;
+	karg->hwRev = pdev->revision;
 	karg->subSystemDevice = pdev->subsystem_device;
 	karg->subSystemVendor = pdev->subsystem_vendor;
 
