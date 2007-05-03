From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Thu, 3 May 2007 10:44:46 -0700
Message-ID: <20070503174446.GB6605@andrew-vasquezs-computer.local>
References: <20070411221507.69c97257.randy.dunlap@oracle.com> <20070412172038.GG10124@andrew-vasquezs-computer.local> <20070412185347.GL26692@parisc-linux.org> <20070412193713.GB14510@andrew-vasquezs-computer.local> <20070412200438.GM26692@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:43488 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767537AbXECRpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 13:45:00 -0400
Content-Disposition: inline
In-Reply-To: <20070412200438.GM26692@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>, scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>, linux-driver@qlogic.com, gregkh <greg@kroah.com>, linuxppc-dev@ozlabs.org

On Thu, 12 Apr 2007, Matthew Wilcox wrote:

> On Thu, Apr 12, 2007 at 12:37:13PM -0700, Andrew Vasquez wrote:
> > On Thu, 12 Apr 2007, Matthew Wilcox wrote:
> > > Why should it fail?  If there's a platform which can't support a
> > > cacheline size that the qla2xyz card can handle, it should be able to
> > > happily fall back to doing plain writes instead of MWIs.  IMO, it should
> > > just call pci_set_mwi() and ignore the result.
> > 
> > I believe there were some erratas on some ISP2xxx chips where MWI
> > needed to be set for proper operation.  I'll go back, verify and
> > update the patch accordingly.
> 
> Hmm.  The thing is that pci_set_mwi() returns success on machines where
> MWI is disabled (currently only PPC64).  Perhaps it needs to fail
> instead.

Sorry for the latency on getting this one resolved...  So is Randy's
proposal for pci_try_set_mwi():

	http://article.gmane.org/gmane.linux.kernel/516349

going to be added in 2.6.22?  If so, I'd like to propose the following
to qla2xxx which handles the 2300 errata.

--

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6ad1588..8b83e1c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -130,18 +130,16 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t w, mwi;
+	uint16_t w;
 	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* Reset expansion ROM address decode enable */
@@ -166,22 +164,21 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t	w, mwi;
+	uint16_t	w;
 	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
 	if (IS_QLA2322(ha) || IS_QLA6322(ha))
 		w &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/*
 	 * If this is a 2300 card and not 2312, reset the
@@ -210,7 +207,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 		ha->fb_rev = RD_FB_CMD_REG(ha, reg);
 
 		if (ha->fb_rev == FPM_2300)
-			w &= ~PCI_COMMAND_INVALIDATE;
+			pci_clear_mwi(ha->pdev);
 
 		/* Deselect FPM registers. */
 		WRT_REG_WORD(&reg->ctrl_status, 0x0);
@@ -227,7 +224,6 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
-	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
@@ -253,19 +249,17 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t w, mwi;
+	uint16_t w;
 	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	int pcix_cmd_reg, pcie_dctl_reg;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	w &= ~PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
