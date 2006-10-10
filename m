From: akpm@osdl.org
Subject: [patch 15/36] ioremap balanced with iounmap for drivers/scsi/zalon.c
Date: Tue, 10 Oct 2006 14:41:33 -0700
Message-ID: <200610102141.k9ALfXgM025397@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11422 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965056AbWJJVlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:41:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/zalon.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/zalon.c~ioremap-balanced-with-iounmap-drivers-scsi-zalonc drivers/scsi/zalon.c
--- a/drivers/scsi/zalon.c~ioremap-balanced-with-iounmap-drivers-scsi-zalonc
+++ a/drivers/scsi/zalon.c
@@ -156,6 +156,8 @@ zalon_probe(struct parisc_device *dev)
  fail_free_irq:
 	free_irq(dev->irq, host);
  fail:
+	if (zalon)
+		iounmap(zalon);
 	ncr53c8xx_release(host);
 	return error;
 }
_
