From: akpm@linux-foundation.org
Subject: [patch 1/5] drivers/scsi/a100u2w.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 14:52:26 -0700
Message-ID: <20130913215226.831285A427E@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53395 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3IMVw1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 17:52:27 -0400
Received: by mail-vc0-f202.google.com with SMTP id gd11so227973vcb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 14:52:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, clbchenlibo.chen@huawei.com

From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/a100u2w.c: convert to module_pci_driver

Use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a100u2w.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/scsi/a100u2w.c~drivers-scsi-a100u2w-convert-to-module_pci_driver drivers/scsi/a100u2w.c
--- a/drivers/scsi/a100u2w.c~drivers-scsi-a100u2w-convert-to-module_pci_driver
+++ a/drivers/scsi/a100u2w.c
@@ -1227,19 +1227,9 @@ static struct pci_driver inia100_pci_dri
 	.remove		= inia100_remove_one,
 };
 
-static int __init inia100_init(void)
-{
-	return pci_register_driver(&inia100_pci_driver);
-}
-
-static void __exit inia100_exit(void)
-{
-	pci_unregister_driver(&inia100_pci_driver);
-}
+module_pci_driver(inia100_pci_driver);
 
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
 
-module_init(inia100_init);
-module_exit(inia100_exit);
_
