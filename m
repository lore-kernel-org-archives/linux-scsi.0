From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Sun, 03 Jun 2007 22:18:13 +0900
Message-ID: <20070603221813U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:40658 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXFCNSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 09:18:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

The previous commit to fix a blocking read bug put a bug that leads a
deadlock on discarding done commands. We don't need bsg_device's lock
there.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 2f78d7d..9b5f6d7 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -466,11 +466,8 @@ static int bsg_complete_all_commands(str
 	 */
 	ret = 0;
 	do {
-		spin_lock_irq(&bd->lock);
-		if (!bd->queued_cmds) {
-			spin_unlock_irq(&bd->lock);
+		if (!bd->queued_cmds)
 			break;
-		}
 
 		bc = bsg_get_done_cmd(bd);
 		if (IS_ERR(bc))
-- 
1.4.3.2

