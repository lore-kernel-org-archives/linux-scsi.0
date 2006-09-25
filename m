From: akpm@osdl.org
Subject: [patch 07/28] aic7xxx: fix byte I/O order in ahd_inw
Date: Mon, 25 Sep 2006 16:57:42 -0700
Message-ID: <200609252357.k8PNvgFe003434@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:33722 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751621AbWIYX5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:57:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, vda.linux@googlemail.com

From: Denis Vlasenko <vda.linux@googlemail.com>

Comment says "Read high byte first as some registers increment..."
but code doesn't guarantee that, I think:
	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
Compiler can reorder it.

Make the order explicit.

Signed-off-by: Denis Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~aic7xxx-fix-byte-i-o-order-in-ahd_inw drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~aic7xxx-fix-byte-i-o-order-in-ahd_inw
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -323,7 +323,9 @@ ahd_inw(struct ahd_softc *ahd, u_int por
 	 * or have other side effects when the low byte is
 	 * read.
 	 */
-	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
+	uint16_t r = ahd_inb(ahd, port+1) << 8;
+	r |= ahd_inb(ahd, port);
+	return r;
 }
 
 void
_
