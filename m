From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Thu, 12 Apr 2007 10:20:38 -0700
Message-ID: <20070412172038.GG10124@andrew-vasquezs-computer.local>
References: <20070411221507.69c97257.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:1786 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574AbXDLRUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 13:20:41 -0400
Content-Disposition: inline
In-Reply-To: <20070411221507.69c97257.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>
Cc: scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>, linux-driver@qlogic.com, gregkh <greg@kroah.com>

On Wed, 11 Apr 2007, Randy Dunlap wrote:

> Both scsi/qla2xxx/qla_init.c and scsi/qla4xxx/ql4_init.c use pci_set_mwi()
> like this:
> 
> 
> 	mwi = 0;
> 	if (pci_set_mwi(ha->pdev))
> 		mwi = PCI_COMMAND_INVALIDATE;
> 
> and then go on to set the PCI_COMMAND "word" based on that value.
> 
> I don't quite get it.  pci_set_mwi() returns 0 for success or
> negative for error... so if pci_set_mwi() fails, the qla init
> code still tries to set the PCI_COMMAND_INVALIDATE bit in the
> PCI_COMMAND word?  The logic looks inverted to me.  What am I
> overlooking?

No, the current logic doesn't make much sense at all, initialization
should not continue if MWI is not set... I'll queue-up something like
the patch below for our next batch-of-qla2xxx-updates.

Dave S., please be sure something similar is added for qla4xxx.

Thanks,
AV

---

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 98c01cd..a586e19 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -130,18 +130,17 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
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
+	if (pci_set_mwi(ha->pdev) < 0)
+		return QLA_FUNCTION_FAILED;
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* Reset expansion ROM address decode enable */
@@ -166,19 +165,18 @@ qla2100_pci_config(scsi_qla_host_t *ha)
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
+	if (pci_set_mwi(ha->pdev) < 0)
+		return QLA_FUNCTION_FAILED;
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
 
 	if (IS_QLA2322(ha) || IS_QLA6322(ha))
 		w &= ~PCI_COMMAND_INTX_DISABLE;
@@ -253,19 +251,18 @@ qla2300_pci_config(scsi_qla_host_t *ha)
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
+	if (pci_set_mwi(ha->pdev) < 0)
+		return QLA_FUNCTION_FAILED;
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
 	w &= ~PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
