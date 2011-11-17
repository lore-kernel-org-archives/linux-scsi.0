From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its
 implementation
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.290.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c 2011-11-07 19:38:06.463566391 +0100
+++ b/drivers/scsi/aacraid/commctrl.c 2011-11-08 10:53:23.848146953 +0100
@@ -631,15 +631,14 @@ static int aac_send_raw_srb(struct aac_d
 			}
 		} else {
 			struct user_sgmap* usg;
-			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap), GFP_KERNEL);
+			usg = kmemdup(upsg,
+				      actual_fibsize - sizeof(struct aac_srb) + sizeof(struct sgmap),
+				      GFP_KERNEL);
 			if (!usg) {
 				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
-			  + sizeof(struct sgmap));
 			actual_fibsize = actual_fibsize64;
 
 			for (i = 0; i < usg->count; i++) {
