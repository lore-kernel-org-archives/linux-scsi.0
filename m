From: akpm@linux-foundation.org
Subject: [patch for 3.0 3/3] hpsa: do not attempt to read from a write-only register
Date: Mon, 11 Jul 2011 14:08:26 -0700
Message-ID: <201107112108.p6BL8Qs2003567@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1GKVJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 17:09:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, scameron@beardog.cce.hp.com, stable@kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Most smartarrays tolerate it, but a few new ones don't.

When the controller doesn't tolerate the bug, the firmware on it locks up.
 No interrupts are received, no commands complete.  I/o on that controller
grinds to a halt.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.h~hpsa-do-not-attempt-to-read-from-a-write-only-register drivers/scsi/hpsa.h
--- a/drivers/scsi/hpsa.h~hpsa-do-not-attempt-to-read-from-a-write-only-register
+++ a/drivers/scsi/hpsa.h
@@ -214,7 +214,7 @@ static void SA5_submit_command(struct ct
 	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 	h->commands_outstanding++;
 	if (h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
_
