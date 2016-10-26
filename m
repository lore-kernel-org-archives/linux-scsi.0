From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/4] hpsa: correct lockup detector pci_disable_device
Date: Wed, 26 Oct 2016 17:21:46 -0500
Message-ID: <147752050626.813.15549750881571218281.stgit@brunhilda>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0089.outbound.protection.outlook.com ([104.47.40.89]:55120
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934570AbcJZWWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 18:22:34 -0400
In-Reply-To: <147752001094.813.10247306839794156732.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

need to check if the device is already disabled first

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d007ec1..798fb20 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8456,7 +8456,8 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x after %d\n",
 			lockup_detected, h->heartbeat_sample_interval / HZ);
-	pci_disable_device(h->pdev);
+	if (pci_is_enabled(h->pdev))
+		pci_disable_device(h->pdev);
 	fail_all_outstanding_cmds(h);
 }
 

