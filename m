From: Rob Herring <robh@kernel.org>
Subject: [PATCH] scsi: Use of_node_name_eq for node name comparisons
Date: Wed,  5 Dec 2018 13:50:39 -0600
Message-ID: <20181205195050.4759-23-robh@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert string compares of DT node names to use of_node_name_eq helper
instead. This removes direct access to the node name pointer.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/scsi/sun_esp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index a11efbcb7f8b..c71bd01fef94 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -529,11 +529,10 @@ static int esp_sbus_probe(struct platform_device *op)
 	int hme = 0;
 	int ret;
 
-	if (dp->parent &&
-	    (!strcmp(dp->parent->name, "espdma") ||
-	     !strcmp(dp->parent->name, "dma")))
+	if (of_node_name_eq(dp->parent, "espdma") ||
+	    of_node_name_eq(dp->parent, "dma"))
 		dma_node = dp->parent;
-	else if (!strcmp(dp->name, "SUNW,fas")) {
+	else if (of_node_name_eq(dp, "SUNW,fas")) {
 		dma_node = op->dev.of_node;
 		hme = 1;
 	}
-- 
2.19.1
