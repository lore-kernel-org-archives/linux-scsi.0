From: Dave Jones <davej@redhat.com>
Subject: [PATCH] Remove redundant freeing code from aic7770
Date: Thu, 2 Sep 2004 20:19:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409021919.i82JJYQF016546@delerium.codemonkey.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from delerium.kernelslacker.org ([81.187.208.145]:48774 "EHLO
	delerium.codemonkey.org.uk") by vger.kernel.org with ESMTP
	id S268261AbUIBTTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 15:19:54 -0400
Received: from delerium.codemonkey.org.uk (localhost.localdomain [127.0.0.1])
	by delerium.codemonkey.org.uk (8.13.1/8.13.1) with ESMTP id i82JJZ18016547
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2004 20:19:35 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

ahc_alloc already frees the 'name' if ahc=NULL

Spotted with the source checker from Coverity.com.

Signed-off-by: Dave Jones <davej@redhat.com>


diff -urpN --exclude-from=/home/davej/.exclude bk-linus/drivers/scsi/aic7xxx/aic7770_osm.c linux-2.6/drivers/scsi/aic7xxx/aic7770_osm.c
--- bk-linus/drivers/scsi/aic7xxx/aic7770_osm.c	2004-06-03 13:40:05.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic7770_osm.c	2004-06-03 13:42:30.000000000 +0100
@@ -185,10 +185,8 @@ aic7770_linux_config(struct aic7770_iden
 		return (ENOMEM);
 	strcpy(name, buf);
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
-	if (ahc == NULL) {
-		free(name, M_DEVBUF);
+	if (ahc == NULL)
 		return (ENOMEM);
-	}
 	error = aic7770_config(ahc, entry, eisaBase);
 	if (error != 0) {
 		ahc->bsh.ioport = 0;
