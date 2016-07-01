From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/2] hpsa: change hpsa_passthru_ioctl timeout
Date: Fri, 1 Jul 2016 13:37:38 -0500
Message-ID: <146739825879.24478.15918793437417180394.stgit@brunhilda>
References: <146739698564.24478.63853333596746262.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0079.outbound.protection.outlook.com ([104.47.33.79]:60676
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbcGAWL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2016 18:11:27 -0400
In-Reply-To: <146739698564.24478.63853333596746262.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Was not alloting for FW Flash times.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 375a396..030d002 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6524,7 +6524,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Ext = cpu_to_le32(HPSA_SG_LAST); /* not chaining */
 	}
 	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
-					DEFAULT_TIMEOUT);
+					NO_TIMEOUT);
 	if (iocommand.buf_size > 0)
 		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
@@ -6657,7 +6657,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[--i].Ext = cpu_to_le32(HPSA_SG_LAST);
 	}
 	status = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
-						DEFAULT_TIMEOUT);
+						NO_TIMEOUT);
 	if (sg_used)
 		hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);

