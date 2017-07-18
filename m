From: Rob Herring <robh@kernel.org>
Subject: [PATCH] scsi: Convert to using %pOF instead of full_name
Date: Tue, 18 Jul 2017 16:43:28 -0500
Message-ID: <20170718214339.7774-48-robh@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we have a custom printf format specifier, convert users of
full_name to use %pOF instead. This is preparation to remove storing
of the full path string for each node.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mac53c94.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index a6682c508c4c..8c4d3003b68b 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -448,15 +448,14 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 		ioremap(macio_resource_start(mdev, 1), 0x1000);
 	state->dmaintr = macio_irq(mdev, 1);
 	if (state->regs == NULL || state->dma == NULL) {
-		printk(KERN_ERR "mac53c94: ioremap failed for %s\n",
-		       node->full_name);
+		printk(KERN_ERR "mac53c94: ioremap failed for %pOF\n", node);
 		goto out_free;
 	}

 	clkprop = of_get_property(node, "clock-frequency", &proplen);
        	if (clkprop == NULL || proplen != sizeof(int)) {
-       		printk(KERN_ERR "%s: can't get clock frequency, "
-       		       "assuming 25MHz\n", node->full_name);
+       		printk(KERN_ERR "%pOF: can't get clock frequency, "
+       		       "assuming 25MHz\n", node);
        		state->clk_freq = 25000000;
        	} else
        		state->clk_freq = *(int *)clkprop;
@@ -469,7 +468,7 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
        				sizeof(struct dbdma_cmd), GFP_KERNEL);
        	if (dma_cmd_space == 0) {
        		printk(KERN_ERR "mac53c94: couldn't allocate dma "
-       		       "command space for %s\n", node->full_name);
+       		       "command space for %pOF\n", node);
 		rc = -ENOMEM;
        		goto out_free;
        	}
@@ -481,8 +480,8 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	mac53c94_init(state);

 	if (request_irq(state->intr, do_mac53c94_interrupt, 0, "53C94",state)) {
-		printk(KERN_ERR "mac53C94: can't get irq %d for %s\n",
-		       state->intr, node->full_name);
+		printk(KERN_ERR "mac53C94: can't get irq %d for %pOF\n",
+		       state->intr, node);
 		goto out_free_dma;
 	}

--
2.11.0
