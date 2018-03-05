From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/4] scsi: hpsa: Less function calls in
 hpsa_big_passthru_ioctl() after error detection
Date: Mon, 5 Mar 2018 09:32:31 +0100
Message-ID: <e53f792c-0062-1b7a-a914-fa5f62b9a5c9@users.sourceforge.net>
References: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Mar 2018 22:00:19 +0100

The function "kfree" was called in a few cases by
the hpsa_big_passthru_ioctl() function during error handling
even if the passed variable contained a null pointer.

* Adjust jump targets.

* Delete two initialisations and a check (for the local variable "buff")
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/hpsa.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b35248becef9..45177ead811f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6377,8 +6377,8 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 {
 	BIG_IOCTL_Command_struct *ioc;
 	struct CommandList *c;
-	unsigned char **buff = NULL;
-	int *buff_size = NULL;
+	unsigned char **buff;
+	int *buff_size;
 	u64 temp64;
 	BYTE sg_used = 0;
 	int status = 0;
@@ -6397,26 +6397,26 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if ((ioc->buf_size < 1) &&
 	    (ioc->Request.Type.Direction != XFER_NONE)) {
 		status = -EINVAL;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	/* Check kmalloc limits  using all SGs */
 	if (ioc->malloc_size > MAX_KMALLOC_SIZE) {
 		status = -EINVAL;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	if (ioc->buf_size > ioc->malloc_size * SG_ENTRIES_IN_CMD) {
 		status = -EINVAL;
-		goto cleanup1;
-	}
-	buff = kzalloc(SG_ENTRIES_IN_CMD * sizeof(char *), GFP_KERNEL);
-	if (!buff) {
-		status = -ENOMEM;
-		goto cleanup1;
+		goto free_ioc;
 	}
 	buff_size = kmalloc(SG_ENTRIES_IN_CMD * sizeof(int), GFP_KERNEL);
 	if (!buff_size) {
 		status = -ENOMEM;
-		goto cleanup1;
+		goto free_ioc;
+	}
+	buff = kzalloc(SG_ENTRIES_IN_CMD * sizeof(char *), GFP_KERNEL);
+	if (!buff) {
+		status = -ENOMEM;
+		goto free_buff_size;
 	}
 	left = ioc->buf_size;
 	data_ptr = ioc->buf;
@@ -6501,14 +6501,16 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 cleanup0:
 	cmd_free(h, c);
 cleanup1:
-	if (buff) {
+	{
 		int i;
 
 		for (i = 0; i < sg_used; i++)
 			kfree(buff[i]);
 		kfree(buff);
 	}
+free_buff_size:
 	kfree(buff_size);
+free_ioc:
 	kfree(ioc);
 	return status;
 }
-- 
2.16.2
