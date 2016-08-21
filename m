From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/7] aacraid: Add spaces after control flow keywords
Date: Sun, 21 Aug 2016 09:25:53 +0200
Message-ID: <086097eb-5f5a-a10c-89e6-7bef81f36779@users.sourceforge.net>
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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 07:10:43 +0200

Keywords which belong to the category "control flow" in the C programming
language should be followed by a space character according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 9f4ddb0..cda03f0 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -251,7 +251,7 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct list_head * entry;
 	unsigned long flags;
 
-	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
+	if (copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
 		return -EFAULT;
 	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
@@ -280,7 +280,7 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		return -EINVAL;
 	}
 
-	if((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
+	if ((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
 		 (fibctx->size != sizeof(struct aac_fib_context))) {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		dprintk ((KERN_INFO "Fib Context corrupt?\n"));
@@ -327,7 +327,7 @@ return_fib:
 			ssleep(1);
 		}
 		if (f.wait) {
-			if(down_interruptible(&fibctx->wait_sem) < 0) {
+			if (down_interruptible(&fibctx->wait_sem) < 0) {
 				status = -ERESTARTSYS;
 			} else {
 				/* Lock again and retry */
@@ -404,7 +404,7 @@ static int close_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	entry = dev->fib_list.next;
 	fibctx = NULL;
 
-	while(entry != &dev->fib_list) {
+	while (entry != &dev->fib_list) {
 		fibctx = list_entry(entry, struct aac_fib_context, next);
 		/*
 		 *	Extract the fibctx from the input parameters
@@ -418,7 +418,7 @@ static int close_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	if (!fibctx)
 		return 0; /* Already gone */
 
-	if((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
+	if ((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
 		 (fibctx->size != sizeof(struct aac_fib_context)))
 		return -EINVAL;
 	spin_lock_irqsave(&dev->fib_lock, flags);
@@ -509,7 +509,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	srbcmd = (struct aac_srb*) fib_data(srbfib);
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
-	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
+	if (copy_from_user(&fibsize, &user_srb->count, sizeof(u32))) {
 		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
 		rcode = -EFAULT;
 		goto free_sg_list;
@@ -605,7 +605,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
-				if(!p) {
+				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  upsg->sg[i].count,i,upsg->count));
 					rcode = -ENOMEM;
@@ -618,7 +618,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+					if (copy_from_user(p,
+							   sg_user[i],
+							   upsg->sg[i].count)) {
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto free_user_srbcmd;
@@ -657,7 +659,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
-				if(!p) {
+				if (!p) {
 					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
 					kfree(usg);
@@ -669,7 +671,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+					if (copy_from_user(p,
+							   sg_user[i],
+							   upsg->sg[i].count)) {
 						kfree (usg);
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
@@ -710,7 +714,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
-				if(!p) {
+				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
 					rcode = -ENOMEM;
@@ -723,7 +727,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p,sg_user[i],usg->sg[i].count)){
+					if (copy_from_user(p,
+							   sg_user[i],
+							   usg->sg[i].count)) {
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto free_user_srbcmd;
@@ -759,8 +765,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				sg_indx = i;
 
 				if (flags & SRB_DataOut) {
-					if(copy_from_user(p, sg_user[i],
-							upsg->sg[i].count)) {
+					if (copy_from_user(p,
+							   sg_user[i],
+							   upsg->sg[i].count)) {
 						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
 						rcode = -EFAULT;
 						goto free_user_srbcmd;
@@ -793,12 +800,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 
 	if (flags & SRB_DataIn) {
-		for(i = 0 ; i <= sg_indx; i++){
+		for (i = 0 ; i <= sg_indx; i++) {
 			byte_count = le32_to_cpu(
 			  (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)
 			      ? ((struct sgmap64*)&srbcmd->sg)->sg[i].count
 			      : srbcmd->sg.sg[i].count);
-			if(copy_to_user(sg_user[i], sg_list[i], byte_count)){
+			if (copy_to_user(sg_user[i], sg_list[i], byte_count)) {
 				dprintk((KERN_DEBUG"aacraid: Could not copy sg data to user\n"));
 				rcode = -EFAULT;
 				goto free_user_srbcmd;
@@ -808,7 +815,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 
 	reply = (struct aac_srb_reply *) fib_data(srbfib);
-	if(copy_to_user(user_reply,reply,sizeof(struct aac_srb_reply))){
+	if (copy_to_user(user_reply, reply, sizeof(struct aac_srb_reply))) {
 		dprintk((KERN_DEBUG"aacraid: Could not copy reply to user\n"));
 		rcode = -EFAULT;
 	}
-- 
2.9.3

