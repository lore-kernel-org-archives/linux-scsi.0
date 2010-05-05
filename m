From: "Anil Ravindranath" <Anil_Ravindranath@pmc-sierra.com>
Subject: RE: [PATCH] scsi: fix pmcraid build errors
Date: Wed, 5 May 2010 05:14:12 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266702742625@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <20100504102914.9be2cee4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53076 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934433Ab0EEMnm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 08:43:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, akpm <akpm@linux-foundation.org>, Anil Ravindranath <Anil_Ravindranath@pmc-sierra.com>

Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

________________________________

From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
Sent: Tue 5/4/2010 10:29 AM
To: scsi
Cc: jejbscsi; akpm; Anil Ravindranath
Subject: [PATCH] scsi: fix pmcraid build errors



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
Cc:     Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-rc6.orig/drivers/scsi/Kconfig
+++ lnx-2634-rc6/drivers/scsi/Kconfig
@@ -1849,7 +1849,7 @@ config ZFCP

 config SCSI_PMCRAID
        tristate "PMC SIERRA Linux MaxRAID adapter support"
-       depends on PCI && SCSI
+       depends on PCI && SCSI && NET
        ---help---
          This driver supports the PMC SIERRA MaxRAID adapters.



