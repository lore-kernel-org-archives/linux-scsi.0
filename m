From: akpm@linux-foundation.org
Subject: [patch 11/17] Fix section mismatch in the Adaptec DPT SCSI Raid driver
Date: Tue, 02 Oct 2007 14:38:08 -0700
Message-ID: <200710022138.l92Lc89D023588@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415AbXJBVir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, joe.korty@ccur.com, aacraid@adaptec.com, willy@debian.org

From: Joe Korty <joe.korty@ccur.com>

Fix section mismatch in the Adaptec DPT SCSI Raid driver.

WARNING: vmlinux.o(.init.text+0x1fcd2): Section mismatch:
	reference to .exit.text:adpt_exit (between 'adpt_init' and 'ahc_linux_init')

This warning is due to adaptec device detection calling the exit routine on
failure to properly register the adaptec device.

The exit routine + call was added on July 30 by

	Commit: 55d9fcf57ba5ec427544fca7abc335cf3da78160
	Author: Matthew Wilcox
	Subject: [SCSI] dpt_i2o: convert to SCSI hotplug model.

Mathew: isn't a module exit routine a little too strong to be calling on the
failure of a single device?  Module exit implies that other, non-failing
adaptec raid devices will also get shut down.  

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver
+++ a/drivers/scsi/dpt_i2o.c
@@ -3346,7 +3346,7 @@ static int __init adpt_init(void)
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);
_
