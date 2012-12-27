From: Asim Kadav <kadav@cs.wisc.edu>
Subject: [PATCH] a100u2w: Added sanitization for pointer dereference using a value from hardware. Detected using Carburizer  (http://lwn.net/Articles/479653/)
Date: Thu, 27 Dec 2012 02:59:31 -0600
Message-ID: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56030 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2L0JPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Dec 2012 04:15:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Signed-off-by: Asim Kadav <kadav@cs.wisc.edu>
---
 drivers/scsi/a100u2w.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 0163457..c2ca15c 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -821,6 +821,9 @@ static irqreturn_t orc_interrupt(struct orc_host * host)
 		/* Get the SCB index of the SCB to service */
 		scb_index = inb(host->base + ORC_RQUEUE);
 
+		/* Sanitize incoming index */
+		scb_index &= 31;
+
 		/* Translate it back to a host pointer */
 		scb = (struct orc_scb *) ((unsigned long) host->scb_virt + (unsigned long) (sizeof(struct orc_scb) * scb_index));
 		scb->status = 0x0;
-- 
1.7.11.3