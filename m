From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 01/19] aacraid: Remove GFP_DMA for raw srb memory
Date: Sun, 7 May 2017 04:26:46 -0700
Message-ID: <20170507112704.21940-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:56168
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754438AbdEGVkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:17 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

The raw srb commands do not requires memory that in the ZONE_DMA
memory space. For 32bit srb commands use __GFP_DMA32 to limit the memory
to 32bit memory range (4GB).

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commctrl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d2f8d59..da01f9c 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -668,7 +668,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				goto cleanup;
 			}
 
-			p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+			p = kmalloc(sg_count[i], GFP_KERNEL);
 			if (!p) {
 				rcode = -ENOMEM;
 				goto cleanup;
@@ -733,7 +733,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					goto cleanup;
 				}
 				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+				p = kmalloc(sg_count[i], GFP_KERNEL);
 				if(!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  sg_count[i], i, upsg->count));
@@ -788,8 +788,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(sg_count[i], GFP_KERNEL);
 				if(!p) {
 					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 						sg_count[i], i, usg->count));
@@ -845,8 +845,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+				p = kmalloc(sg_count[i], GFP_KERNEL|GFP_DMA32);
 				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 						sg_count[i], i, usg->count));
@@ -887,7 +886,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-				p = kmalloc(sg_count[i], GFP_KERNEL);
+				p = kmalloc(sg_count[i], GFP_KERNEL|GFP_DMA32);
 				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  sg_count[i], i, upsg->count));
-- 
2.7.4
