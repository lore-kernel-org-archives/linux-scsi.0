From: Vladimir Gratinskiy <gratinskiy@ispras.ru>
Subject: [PATCH 1/2] scsi: Use GFP_ATOMIC in kzalloc().
Date: Wed,  8 Aug 2012 12:41:30 +0400
Message-ID: <1344415290-10486-1-git-send-email-gratinskiy@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianyun Li <jyli@marvell.com>
Cc: Vladimir Gratinskiy <gratinskiy@ispras.ru>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@ispras.ru
List-Id: linux-scsi@vger.kernel.org

Calling memory allocation function from the context of interrupt:
request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED, "mvumi", mhba);
Function mvumi_isr_handler() calls mvumi_handshake(mhba) that calls
mvumi_init_data(mhba). In mvumi_init_data() there is function
mvumi_alloc_mem_resource(mhba,..) that calls kzalloc(sizeof(*res), GFP_KERNEL).
In the case of GFP_KERNEL flag, function execution can be preempted,
because a greater number of operations to find and allocate memory
blocks is executed.

The patch change GFP_KERNEL flag to GFP_ATOMIC.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Vladimir Gratinskiy <gratinskiy@ispras.ru>
---
 drivers/scsi/mvumi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..097f72f 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -118,7 +118,7 @@ static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array)
 static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 				enum resource_type type, unsigned int size)
 {
-	struct mvumi_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
+	struct mvumi_res *res = kzalloc(sizeof(*res), GFP_ATOMIC);
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
@@ -128,7 +128,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	switch (type) {
 	case RESOURCE_CACHED_MEMORY:
-		res->virt_addr = kzalloc(size, GFP_KERNEL);
+		res->virt_addr = kzalloc(size, GFP_ATOMIC);
 		if (!res->virt_addr) {
 			dev_err(&mhba->pdev->dev,
 				"unable to allocate memory,size = %d.\n", size);
-- 
1.7.9.5
