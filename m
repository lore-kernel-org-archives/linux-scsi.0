From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/7] aacraid: Delete unnecessary braces
Date: Sun, 21 Aug 2016 09:24:03 +0200
Message-ID: <dfde8ac2-fe7e-df1b-d0b3-cc225961d0a8@users.sourceforge.net>
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
Date: Sun, 21 Aug 2016 07:07:08 +0200

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 49a664f..9f4ddb0 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -66,13 +66,11 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	unsigned int size, osize;
 	int retval;
 
-	if (dev->in_reset) {
+	if (dev->in_reset)
 		return -EBUSY;
-	}
 	fibptr = aac_fib_alloc(dev);
-	if(fibptr == NULL) {
+	if (!fibptr)
 		return -ENOMEM;
-	}
 
 	kfib = fibptr->hw_fib_va;
 	/*
@@ -138,9 +136,8 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		retval = aac_fib_send(le16_to_cpu(kfib->header.Command), fibptr,
 				le16_to_cpu(kfib->header.Size) , FsaNormal,
 				1, 1, NULL, NULL);
-		if (retval) {
+		if (retval)
 			goto cleanup;
-		}
 		if (aac_fib_complete(fibptr) != 0) {
 			retval = -EINVAL;
 			goto cleanup;
@@ -228,12 +225,10 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		}
 		list_add_tail(&fibctx->next, &dev->fib_list);
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		if (copy_to_user(arg, &fibctx->unique,
-						sizeof(fibctx->unique))) {
+		if (copy_to_user(arg, &fibctx->unique, sizeof(fibctx->unique)))
 			status = -EFAULT;
-		} else {
+		else
 			status = 0;
-		}
 	}
 	return status;
 }
@@ -820,9 +815,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 free_user_srbcmd:
 	kfree(user_srbcmd);
 free_sg_list:
-	for(i=0; i <= sg_indx; i++){
+	for (i = 0; i <= sg_indx; i++)
 		kfree(sg_list[i]);
-	}
 	if (rcode != -ERESTARTSYS) {
 		aac_fib_complete(srbfib);
 		aac_fib_free(srbfib);
-- 
2.9.3
