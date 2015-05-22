From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] mvsas: always iounmap resources
Date: Fri, 22 May 2015 11:15:02 +0200
Message-ID: <1432286102-18184-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Ben Hutchings <ben@decadent.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In case pci_resource_start() or pci_resource_len() reutrn 0, mvsas_ioremap
returns without doing an iounmap() of mvi->regs_ex.

Found by the cocinelle tool.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mvsas/mv_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 53030b0..04a3205 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -339,8 +339,11 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 
 	res_start = pci_resource_start(pdev, bar);
 	res_len = pci_resource_len(pdev, bar);
-	if (!res_start || !res_len)
+	if (!res_start || !res_len) {
+		iounmap(mvi->regs_ex);
+		mvi->regs_ex = NULL;
 		goto err_out;
+	}
 
 	res_flag = pci_resource_flags(pdev, bar);
 	if (res_flag & IORESOURCE_CACHEABLE)
-- 
2.4.1
