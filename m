From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 10/18] aacraid: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:19 +0200
Message-ID: <1401117687-28911-11-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: benoit.taine@lip6.fr, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/aacraid/commctrl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index fbcd48d..0cdb16b 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -635,15 +635,14 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 		} else {
 			struct user_sgmap* usg;
-			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap), GFP_KERNEL);
+			usg = kmemdup(upsg, actual_fibsize -
+				sizeof(struct aac_srb) + sizeof(struct sgmap),
+				GFP_KERNEL);
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap));
 			actual_fibsize = actual_fibsize64;
 
 			for (i = 0; i < usg->count; i++) {
