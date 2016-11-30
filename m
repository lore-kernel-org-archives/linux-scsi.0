From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ipr: Fix runaway IRQs when falling back from MSI to
 LSI
Date: Wed, 30 Nov 2016 15:28:55 -0600
Message-ID: <683a1049-2ff3-2777-b908-062212008ae4@linux.vnet.ibm.com>
References: <1479947042.10230.88.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479947042.10230.88.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-scsi@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org


Looks good. Thanks! Here is an updated version that should apply
cleanly on top of scsi-next.

8<
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

LSIs must be ack'ed with an MMIO otherwise they remain asserted
forever. This is controlled by the "clear_isr" flag.

While we set that flag properly when deciding initially whether
to use LSIs or MSIs, we fail to set it if we first chose MSIs,
the test fails, then fallback to LSIs.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_misx_fail_intx_clear_isr drivers/scsi/ipr.c
--- scsi/drivers/scsi/ipr.c~ipr_misx_fail_intx_clear_isr	2016-11-29 20:56:27.902534325 -0600
+++ scsi-bjking1/drivers/scsi/ipr.c	2016-11-29 20:56:50.645538533 -0600
@@ -10157,6 +10157,7 @@ static int ipr_probe_ioa(struct pci_dev
 			pci_free_irq_vectors(pdev);
 
 			ioa_cfg->nvectors = 1;
+			ioa_cfg->clear_isr = 1;
 			break;
 		default:
 			goto out_msi_disable;
_
