From: akpm@linux-foundation.org
Subject: [patch 20/27] scsi: fix pmcraid build errors
Date: Tue, 20 Jul 2010 15:29:01 -0700
Message-ID: <201007202229.o6KMT193021782@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884Ab0GTW3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, anil_ravindranath@pmc-sierra.com

From: Randy Dunlap <randy.dunlap@oracle.com>

pmcraid should depend on NET since it uses netlink interfaces.
This fixes multiple build errors when CONFIG_NET is not enabled:

ERROR: "genl_register_family" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "genl_unregister_family" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "nla_put" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "init_net" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "__alloc_skb" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "netlink_broadcast" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "skb_put" [drivers/scsi/pmcraid.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi-fix-pmcraid-build-errors drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-fix-pmcraid-build-errors
+++ a/drivers/scsi/Kconfig
@@ -1849,7 +1849,7 @@ config ZFCP
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	---help---
 	  This driver supports the PMC SIERRA MaxRAID adapters.
 
_
