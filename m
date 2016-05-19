From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] [SCSI] aacraid: use kmemdup
Date: Thu, 19 May 2016 19:38:33 +0530
Message-ID: <1463666915-16906-3-git-send-email-falakreyaz@gmail.com>
References: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use kmemdup when some other buffer is immediately copied into allocated
region. It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 4b3bb52..b381b37 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -635,15 +635,14 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 		} else {
 			struct user_sgmap* usg;
-			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap), GFP_KERNEL);
+			usg = kmemdup(upsg,
+				      actual_fibsize - sizeof(struct aac_srb)
+				      + sizeof(struct sgmap), GFP_KERNEL);
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap));
 			actual_fibsize = actual_fibsize64;
 
 			for (i = 0; i < usg->count; i++) {
-- 
1.9.1
