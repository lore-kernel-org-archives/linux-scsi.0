From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] esas2r: bitwise vs logical AND typo
Date: Thu, 29 Aug 2013 11:46:21 +0300
Message-ID: <20130829084620.GE14334@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The intent was to test if any bits were set but it used a logical AND.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 3a798e7..78b18c1 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -808,7 +808,7 @@ static void esas2r_init_pci_cfg_space(struct esas2r_adapter *a)
 	int pcie_cap_reg;
 
 	pcie_cap_reg = pci_find_capability(a->pcid, PCI_CAP_ID_EXP);
-	if (0xffff && pcie_cap_reg) {
+	if (0xffff & pcie_cap_reg) {
 		u16 devcontrol;
 
 		pci_read_config_word(a->pcid, pcie_cap_reg + PCI_EXP_DEVCTL,
