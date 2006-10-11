From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] MPT fusion: handle PCI layer error on resume
Date: Wed, 11 Oct 2006 17:38:34 -0400
Message-ID: <20061011213834.GA20253@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161529AbWJKVik@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


In the unlikely event of pci_enable_device() failure during resume, we
do the minimalist solution and simply exit, rather than continuing to
enable the hardware.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

---

 drivers/message/fusion/mptbase.c |   10 ++++++++--

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e5c7271..f183b83 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1515,7 +1515,7 @@ mpt_resume(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
-	int recovery_state;
+	int recovery_state, rc;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1523,7 +1523,13 @@ mpt_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(MYIOC_s_INFO_FMT
+			"pci-resume: device enable failed\n", ioc->name);
+		return rc;
+	}
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
