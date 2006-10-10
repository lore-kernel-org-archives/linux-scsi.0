From: akpm@osdl.org
Subject: [patch 20/36] ioremap balanced with iounmap for drivers/scsi/nsp32.c
Date: Tue, 10 Oct 2006 14:41:37 -0700
Message-ID: <200610102141.k9ALfbbF025420@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2463 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030472AbWJJVm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:42:59 -0400
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
