From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 17/31] scsi/aacraid: use kmemdup rather than duplicating its
 implementation
Date: Fri, 07 Aug 2015 09:59:23 +0200
Message-ID: <1438934377-4922-18-git-send-email-a.hajda@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The patch was generated using fixed coccinelle semantic patch
scripts/coccinelle/api/memdup.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2014320

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/scsi/aacraid/commctrl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 54195a1..d2ed626 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -635,15 +635,14 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
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
-- 
1.9.1
