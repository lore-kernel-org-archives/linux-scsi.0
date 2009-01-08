From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 2/7] sym53c8xx: fix NULL deref on error path
Date: Thu, 08 Jan 2009 12:53:37 -0500
Message-ID: <49663DA1.7010704@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2379 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbZAHRxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:53:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

If sym_attach() fails to allocate np, the error path will dereference
a NULL pointer for printk.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-07 17:31:07.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-07 17:32:33.000000000 -0500
@@ -1418,7 +1418,7 @@ static struct Scsi_Host * __devinit sym_
  attach_failed:
 	if (!shost)
 		return NULL;
-	printf_info("%s: giving up ...\n", sym_name(np));
+	printf_info("sym%d: giving up ...\n", unit);
 	if (np)
 		sym_free_resources(np, pdev);
 	scsi_host_put(shost);


