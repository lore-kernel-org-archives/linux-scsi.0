From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V2 4/9] aacraid: Fix memory leak in aac_fib_map_free
Date: Wed, 6 Jan 2016 23:22:19 -0800
Message-ID: <1452151344-417-5-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:40440 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbcAFXMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 18:12:35 -0500
In-Reply-To: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, David.Carroll@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

aac_fib_map_free() calls pci_free_consistent() without checking that
dev->hw_fib_va is not NULL and dev->max_fib_size is not zero.If they
are indeed NULL/0, this will result in a hang as pci_free_consistent()
will attempt to invalidate cache for the entire 64-bit address space
(which would take a very long time).

Fixed by adding a check to make sure that dev->hw_fib_va and
dev->max_fib_size are not NULL and 0 respectively.

Changes in V2:
None

Fixes: 9ad5204d6 - "[SCSI]aacraid: incorrect dma mapping mask
during blinked recover or user initiated reset"
Cc: stable@vger.kernel.org

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/commsup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e9f6e70..55459b4 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -83,9 +83,12 @@ static int fib_map_alloc(struct aac_dev *dev)
 
 void aac_fib_map_free(struct aac_dev *dev)
 {
-	pci_free_consistent(dev->pdev,
-	  dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB),
-	  dev->hw_fib_va, dev->hw_fib_pa);
+	if (dev->hw_fib_va && dev->max_fib_size) {
+		pci_free_consistent(dev->pdev,
+		(dev->max_fib_size *
+		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
+		dev->hw_fib_va, dev->hw_fib_pa);
+	}
 	dev->hw_fib_va = NULL;
 	dev->hw_fib_pa = 0;
 }
-- 
1.9.1

