From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] cciss: section mismatch
Date: Thu, 10 Jan 2008 14:32:35 -0800
Message-ID: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:63390 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbYAJWdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:33:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, mike.miller@hp.com, iss_storagedev@hp.com
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>, axboe@kernel.dk

From: Randy Dunlap <randy.dunlap@oracle.com>

Mark cciss_pci_init() as __devinit, to fix section mismatch warning.

WARNING: vmlinux.o(.text+0x601fc9): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7-git1.orig/drivers/block/cciss.c
+++ linux-2.6.24-rc7-git1/drivers/block/cciss.c
@@ -2927,7 +2927,7 @@ default_int_mode:
 	return;
 }
 
-static int cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
+static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
