From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 01/19] aacraid: Remove __GFP_DMA for raw srb memory
Date: Wed, 10 May 2017 09:39:35 -0700
Message-ID: <1494434393-17261-2-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0043.outbound.protection.outlook.com ([104.47.38.43]:46336
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751235AbdEJGYG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:06 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

The raw srb commands do not requires memory that in the ZONE_DMA
memory space. For 32bit srb commands use GFP_DMA32 to limit the memory
to 32bit memory range (4GB).

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Corrected flag name to GFP_DMA32 in patch description and corrected
GFP_DMA to __GFP_DMA in patch heading
Removed comment

 drivers/scsi/aacraid/commctrl.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d2f8d59..106b933 100644
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
@@ -732,8 +732,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
+
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
