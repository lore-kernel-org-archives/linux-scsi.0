From: akpm@osdl.org
Subject: [patch 21/28] Signedness issue in drivers/scsi/ipr.c
Date: Mon, 25 Sep 2006 16:59:07 -0700
Message-ID: <200609252359.k8PNx7vJ003518@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24253 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751811AbWIZADR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 20:03:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, snakebyte@gmx.de, brking@us.ibm.com

From: Eric Sesterhenn <snakebyte@gmx.de>

gcc 4.1 with some extra warnings show the following:

drivers/scsi/ipr.c:6361: warning: comparison of unsigned expression < 0 is always false
drivers/scsi/ipr.c:6385: warning: comparison of unsigned expression < 0 is always false
drivers/scsi/ipr.c:6415: warning: comparison of unsigned expression < 0 is always false

The problem is that rc is of the type u32, which can never be smaller than
zero, therefore all three error handling checks get useless.  This patch
changes it to a normal int, because all usages / all functions it get used
with expect an int.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Brian King <brking@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~signedness-issue-in-drivers-scsi-iprc drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~signedness-issue-in-drivers-scsi-iprc
+++ a/drivers/scsi/ipr.c
@@ -6352,7 +6352,7 @@ static int __devinit ipr_probe_ioa(struc
 	struct Scsi_Host *host;
 	unsigned long ipr_regs_pci;
 	void __iomem *ipr_regs;
-	u32 rc = PCIBIOS_SUCCESSFUL;
+	int rc = PCIBIOS_SUCCESSFUL;
 	volatile u32 mask, uproc;
 
 	ENTER;
_
