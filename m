From: Dave Jones <davej@redhat.com>
Subject: [PATCH] Remove possible reuse of stale pointer in aic7xxx
Date: Thu, 2 Sep 2004 20:19:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409021919.i82JJZmW016561@delerium.codemonkey.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from delerium.kernelslacker.org ([81.187.208.145]:50310 "EHLO
	delerium.codemonkey.org.uk") by vger.kernel.org with ESMTP
	id S268339AbUIBTTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 15:19:54 -0400
Received: from delerium.codemonkey.org.uk (localhost.localdomain [127.0.0.1])
	by delerium.codemonkey.org.uk (8.13.1/8.13.1) with ESMTP id i82JJZL3016562
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2004 20:19:35 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Spotted with the source checker from Coverity.com.

Signed-off-by: Dave Jones <davej@redhat.com>


diff -urpN --exclude-from=/home/davej/.exclude bk-linus/drivers/scsi/aic7xxx_old.c linux-2.6/drivers/scsi/aic7xxx_old.c
--- bk-linus/drivers/scsi/aic7xxx_old.c	2004-08-28 21:57:23.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx_old.c	2004-09-01 13:31:11.000000000 +0100
@@ -9243,6 +9243,7 @@ aic7xxx_detect(Scsi_Host_Template *templ
 	    {
               /* duplicate PCI entry, skip it */
 	      kfree(temp_p);
+	      temp_p = NULL;
               continue;
 	    }
 	    current_p = current_p->next;
