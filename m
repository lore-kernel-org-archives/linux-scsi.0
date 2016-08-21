From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] megaraid_sas: Use memdup_user() rather than duplicating its
 implementation
Date: Sun, 21 Aug 2016 10:48:48 +0200
Message-ID: <606e0b0c-370f-cff5-607b-0c8ae480e9c1@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, megaraidlinux.pdl@avagotech.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 10:39:04 +0200

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c1ed25a..9a2fe4e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6711,14 +6711,9 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	unsigned long flags;
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc)
-		return -ENOMEM;
-
-	if (copy_from_user(ioc, user_ioc, sizeof(*ioc))) {
-		error = -EFAULT;
-		goto out_kfree_ioc;
-	}
+	ioc = memdup_user(user_ioc, sizeof(*ioc));
+	if (IS_ERR(ioc))
+		return PTR_ERR(ioc);
 
 	instance = megasas_lookup_instance(ioc->host_no);
 	if (!instance) {
-- 
2.9.3

