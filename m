From: akpm@osdl.org
Subject: [patch 20/45] ioremap balanced with iounmap for drivers/scsi/nsp32.c
Date: Fri, 20 Oct 2006 14:48:20 -0700
Message-ID: <200610202148.k9KLmK2W004127@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40326 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992704AbWJTVse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:34 -0400
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

 drivers/scsi/nsp32.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/scsi/nsp32.c~ioremap-balanced-with-iounmap-drivers-scsi-nsp32c drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~ioremap-balanced-with-iounmap-drivers-scsi-nsp32c
+++ a/drivers/scsi/nsp32.c
@@ -3540,6 +3540,11 @@ static int __devinit nsp32_probe(struct 
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "exit %d", ret);
 
+	if (ret) {
+		iounmap(data->MmioAddress);
+		data->MmioAddress = NULL;
+	}
+
 	return ret;
 }
 
_
