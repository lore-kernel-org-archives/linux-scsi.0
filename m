From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix pmcraid build errors
Date: Tue, 4 May 2010 10:29:14 -0700
Message-ID: <20100504102914.9be2cee4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51455 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0EDRam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 13:30:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, akpm <akpm@linux-foundation.org>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

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
Cc:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-rc6.orig/drivers/scsi/Kconfig
+++ lnx-2634-rc6/drivers/scsi/Kconfig
@@ -1849,7 +1849,7 @@ config ZFCP
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	---help---
 	  This driver supports the PMC SIERRA MaxRAID adapters.
 
