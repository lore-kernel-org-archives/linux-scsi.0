From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/7] aacraid: One function call less in aac_send_raw_srb()
 after error detection
Date: Sun, 21 Aug 2016 09:20:45 +0200
Message-ID: <1e07bef4-1bdd-f2af-b316-6d577c616d99@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@microsemi.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>From e8187662ee30aab709a260c72fb86c51673f8e0d Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 20 Aug 2016 20:40:47 +0200
Subject: [PATCH 2/7] aacraid: One function call less in aac_send_raw_srb()
 after error detection

The kfree() function was called in a few cases by the
aac_send_raw_srb() function during error handling
even if the variable "user_srbcmd" contained eventually
an inappropriate pointer value.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 49 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 1af3084..6dcdf91 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -517,19 +517,19 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
 		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
 		rcode = -EFAULT;
-		goto cleanup;
+		goto free_sg_list;
 	}
 
 	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
 	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
-		goto cleanup;
+		goto free_sg_list;
 	}
 
 	user_srbcmd = memdup_user(user_srb, fibsize);
 	if (IS_ERR(user_srbcmd)) {
 		rcode = PTR_ERR(user_srbcmd);
-		goto cleanup;
+		goto free_sg_list;
 	}
 
 	user_reply = arg+fibsize;
@@ -564,7 +564,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		dprintk((KERN_DEBUG"aacraid: too many sg entries %d\n",
 		  le32_to_cpu(srbcmd->sg.count)));
 		rcode = -EINVAL;
-		goto cleanup;
+		goto free_user_srbcmd;
 	}
 	actual_fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry) +
 		((user_srbcmd->sg.count & 0xff) * sizeof(struct sgentry));
@@ -580,12 +580,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		  sizeof(struct aac_srb), sizeof(struct sgentry),
 		  sizeof(struct sgentry64), fibsize));
 		rcode = -EINVAL;
-		goto cleanup;
+		goto free_user_srbcmd;
 	}
 	if ((data_dir == DMA_NONE) && user_srbcmd->sg.count) {
 		dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
 		rcode = -EINVAL;
-		goto cleanup;
+		goto free_user_srbcmd;
 	}
 	byte_count = 0;
 	if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
@@ -606,7 +606,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
 					rcode = -EINVAL;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
@@ -614,7 +614,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  upsg->sg[i].count,i,upsg->count));
 					rcode = -ENOMEM;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				addr = (u64)upsg->sg[i].addr[0];
 				addr += ((u64)upsg->sg[i].addr[1]) << 32;
@@ -626,7 +626,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
-						goto cleanup;
+						goto free_user_srbcmd;
 					}
 				}
 				addr = pci_map_single(dev->pdev, p, upsg->sg[i].count, data_dir);
@@ -644,7 +644,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
-				goto cleanup;
+				goto free_user_srbcmd;
 			}
 			actual_fibsize = actual_fibsize64;
 
@@ -658,7 +658,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				      65536)) {
 					kfree(usg);
 					rcode = -EINVAL;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
@@ -667,7 +667,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					  usg->sg[i].count,i,usg->count));
 					kfree(usg);
 					rcode = -ENOMEM;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				sg_user[i] = (void __user *)(uintptr_t)usg->sg[i].addr;
 				sg_list[i] = p; // save so we can clean up later
@@ -678,7 +678,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 						kfree (usg);
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
-						goto cleanup;
+						goto free_user_srbcmd;
 					}
 				}
 				addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
@@ -711,7 +711,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
 					rcode = -EINVAL;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
@@ -719,7 +719,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
 					rcode = -ENOMEM;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				addr = (u64)usg->sg[i].addr[0];
 				addr += ((u64)usg->sg[i].addr[1]) << 32;
@@ -731,7 +731,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					if(copy_from_user(p,sg_user[i],usg->sg[i].count)){
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
-						goto cleanup;
+						goto free_user_srbcmd;
 					}
 				}
 				addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
@@ -750,14 +750,14 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
 					rcode = -EINVAL;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
 				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  upsg->sg[i].count, i, upsg->count));
 					rcode = -ENOMEM;
-					goto cleanup;
+					goto free_user_srbcmd;
 				}
 				sg_user[i] = (void __user *)(uintptr_t)upsg->sg[i].addr;
 				sg_list[i] = p; // save so we can clean up later
@@ -768,7 +768,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 							upsg->sg[i].count)) {
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
-						goto cleanup;
+						goto free_user_srbcmd;
 					}
 				}
 				addr = pci_map_single(dev->pdev, p,
@@ -788,13 +788,13 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 	if (status == -ERESTARTSYS) {
 		rcode = -ERESTARTSYS;
-		goto cleanup;
+		goto free_user_srbcmd;
 	}
 
 	if (status != 0){
 		dprintk((KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n"));
 		rcode = -ENXIO;
-		goto cleanup;
+		goto free_user_srbcmd;
 	}
 
 	if (flags & SRB_DataIn) {
@@ -806,7 +806,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			if(copy_to_user(sg_user[i], sg_list[i], byte_count)){
 				dprintk((KERN_DEBUG"aacraid: Could not copy sg data to user\n"));
 				rcode = -EFAULT;
-				goto cleanup;
+				goto free_user_srbcmd;
 
 			}
 		}
@@ -816,11 +816,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	if(copy_to_user(user_reply,reply,sizeof(struct aac_srb_reply))){
 		dprintk((KERN_DEBUG"aacraid: Could not copy reply to user\n"));
 		rcode = -EFAULT;
-		goto cleanup;
 	}
-
-cleanup:
+free_user_srbcmd:
 	kfree(user_srbcmd);
+free_sg_list:
 	for(i=0; i <= sg_indx; i++){
 		kfree(sg_list[i]);
 	}
-- 
2.9.3

