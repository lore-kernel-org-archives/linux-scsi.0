From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: [PATCH] PCI legacy I/O port free driver - Making fusion MPT driver
Date: Fri, 28 Sep 2007 15:19:54 +0900
Message-ID: <200709280619.AA09134@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760211AbXI1GU1@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric.Moore@lsi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch makes Fusion MPT driver legacy I/O port free.

The latest kernel has interface for PCI device drivers to tell the
kernel which resource the driver want to use.

I've made a patch which makes Fusion MPT driver legacy I/O port
free by using PCI core changes.
Fusion MPT driver basically doesn't use PCI legacy I/O port.
But some PCI card/controller still use PCI legacy I/O port for
download boot operation.
So, this driver assigns I/O port at download boot operation.

Thanks,
Masao Fukuchi

Signed-off-by: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>

diff -uarpN linux-2.6.23-rc5.org/drivers/message/fusion/mptbase.c linux-2.6.23-
rc5.new/drivers/message/fusion/mptbase.c
--- linux-2.6.23-rc5.org/drivers/message/fusion/mptbase.c	2007-09-01 15:08:24.000000000 +
0900
+++ linux-2.6.23-rc5.new/drivers/message/fusion/mptbase.c	2007-09-27 14:38:23.000000000 +
0900
@@ -1404,6 +1404,7 @@ mpt_attach(struct pci_dev *pdev, const s
 	u8		 revision;
 	u8		 pcixcmd;
 	static int	 mpt_ids = 0;
+	int		 bars;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *dent, *ent;
 #endif
@@ -1418,7 +1419,10 @@ mpt_attach(struct pci_dev *pdev, const s
 	if (mpt_debug_level)
 		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
 
-	if (pci_enable_device(pdev))
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	if (pci_enable_device_bars(pdev, bars))
+		return r;
+	if (pci_request_selected_regions(pdev, bars, "mpt"))
 		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
@@ -1751,6 +1755,7 @@ mpt_resume(struct pci_dev *pdev)
 	u32 device_state = pdev->current_state;
 	int recovery_state;
 	int err;
+	int bars;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1758,7 +1763,8 @@ mpt_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	err = pci_enable_device(pdev);
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	err = pci_enable_device_bars(pdev, bars);
 	if (err)
 		return err;
 
@@ -2838,6 +2844,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	int			 r;
 	int			 count;
 	int			 cntdn;
+	int			 bars;
 
 	memset(&ioc_init, 0, sizeof(ioc_init));
 	memset(&init_reply, 0, sizeof(init_reply));
@@ -2849,9 +2856,17 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepF
 	 * then this pointer is not NULL. Skip the upload a second time.
 	 * Set this flag if cached_fw set for either IOC.
 	 */
-	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT)
+	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT) {
 		ioc->upload_fw = 1;
-	else
+		/* re-enable with io */
+		pci_disable_device(ioc->pcidev);
+		bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM | IORESOURCE_IO);
+		if (pci_enable_device_bars(ioc->pcidev, bars))
+			return -ENODEV;
+		bars = pci_select_bars(ioc->pcidev, IORESOURCE_IO);
+		if (pci_request_selected_regions(ioc->pcidev, bars, "mpt"))
+			return -ENODEV;
+	} else
 		ioc->upload_fw = 0;
 	ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "upload_fw %d facts.Flags=%x\n",
 		   ioc->name, ioc->upload_fw, ioc->facts.Flags));
