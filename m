From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/2] drivers/scsi/sun3x_esp.c: Convert && to ||
Date: Tue, 14 Oct 2008 18:00:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54173 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYJNQAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 12:00:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, sammy@sammy.net, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The pattern !E && !E->fld is nonsensical.  The patch below updates this
according to the assumption that && should be ||.  But perhaps another
solution was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/sun3x_esp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -213,7 +213,7 @@ static int __devinit esp_sun3x_probe(str
 	esp->ops = &sun3x_esp_ops;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unlink;
 
 	esp->regs = ioremap_nocache(res->start, 0x20);
@@ -221,7 +221,7 @@ static int __devinit esp_sun3x_probe(str
 		goto fail_unmap_regs;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res && !res->start)
+	if (!res || !res->start)
 		goto fail_unmap_regs;
 
 	esp->dma_regs = ioremap_nocache(res->start, 0x10);
