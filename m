From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/7] aacraid: Improve determination of a few sizes
Date: Sun, 21 Aug 2016 09:27:19 +0200
Message-ID: <5fa01979-9ca2-32d0-bece-c33902a5259b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@microsemi.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 08:04:48 +0200

Replace the specification of data structures by references for variables
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index cda03f0..d2029db 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -177,7 +177,7 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct aac_fib_context * fibctx;
 	int status;
 
-	fibctx = kmalloc(sizeof(struct aac_fib_context), GFP_KERNEL);
+	fibctx = kmalloc(sizeof(*fibctx), GFP_KERNEL);
 	if (fibctx == NULL) {
 		status = -ENOMEM;
 	} else {
@@ -186,7 +186,7 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		struct aac_fib_context * context;
 
 		fibctx->type = FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT;
-		fibctx->size = sizeof(struct aac_fib_context);
+		fibctx->size = sizeof(*fibctx);
 		/*
 		 *	Yes yes, I know this could be an index, but we have a
 		 * better guarantee of uniqueness for the locked loop below.
@@ -251,7 +251,7 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 	struct list_head * entry;
 	unsigned long flags;
 
-	if (copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
+	if (copy_from_user(&f, arg, sizeof(f)))
 		return -EFAULT;
 	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
@@ -509,7 +509,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	srbcmd = (struct aac_srb*) fib_data(srbfib);
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
-	if (copy_from_user(&fibsize, &user_srb->count, sizeof(u32))) {
+	if (copy_from_user(&fibsize, &user_srb->count, sizeof(fibsize))) {
 		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
 		rcode = -EFAULT;
 		goto free_sg_list;
-- 
2.9.3
