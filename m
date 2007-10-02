From: akpm@linux-foundation.org
Subject: [patch 13/17] drivers/scsi/imm.c: fix check-after-use
Date: Tue, 02 Oct 2007 14:38:09 -0700
Message-ID: <200710022138.l92Lc9CR023594@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbXJBVid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org, bunk@stusta.de

From: Adrian Bunk <bunk@kernel.org>

The Coverity checker spotted that we have already oops'ed if "cmd"
was NULL.

Since "cmd" being NULL doesn't seem to be possible at this point this
patch removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/imm.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/imm.c~drivers-scsi-immc-fix-check-after-use drivers/scsi/imm.c
--- a/drivers/scsi/imm.c~drivers-scsi-immc-fix-check-after-use
+++ a/drivers/scsi/imm.c
@@ -740,10 +740,6 @@ static void imm_interrupt(struct work_st
 	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags;
 
-	if (!cmd) {
-		printk("IMM: bug in imm_interrupt\n");
-		return;
-	}
 	if (imm_engine(dev, cmd)) {
 		schedule_delayed_work(&dev->imm_tq, 1);
 		return;
_
