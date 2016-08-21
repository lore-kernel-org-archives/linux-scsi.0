From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/7] aacraid: Use memdup_user() rather than duplicating its
 implementation
Date: Sun, 21 Aug 2016 09:19:04 +0200
Message-ID: <23c56a66-74a6-6033-f209-ac3e4ba83e61@users.sourceforge.net>
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
Date: Sat, 20 Aug 2016 20:05:24 +0200

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 5648b71..1af3084 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -526,15 +526,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
-	if (!user_srbcmd) {
-		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
-		rcode = -ENOMEM;
-		goto cleanup;
-	}
-	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
-		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
-		rcode = -EFAULT;
+	user_srbcmd = memdup_user(user_srb, fibsize);
+	if (IS_ERR(user_srbcmd)) {
+		rcode = PTR_ERR(user_srbcmd);
 		goto cleanup;
 	}
 
-- 
2.9.3
