From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] scsi/ipr: Fix runaway IRQs when falling back from MSI to LSI
Date: Thu, 24 Nov 2016 11:24:02 +1100
Message-ID: <1479947042.10230.88.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>, Brian King <brking@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

LSIs must be ack'ed with an MMIO otherwise they remain asserted
forever. This is controlled by the "clear_isr" flag.

While we set that flag properly when deciding initially whether
to use LSIs or MSIs, we fail to set it if we first chose MSIs,
the test fails, then fallback to LSIs.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/scsi/ipr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5324741..5dd3194 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10213,6 +10213,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 			}
 
 			ioa_cfg->intr_flag = IPR_USE_LSI;
+			ioa_cfg->clear_isr = 1;
 			ioa_cfg->nvectors = 1;
 		}
 		else if (rc)
