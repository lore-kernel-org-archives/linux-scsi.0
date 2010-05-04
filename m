From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix bnx2i build errors
Date: Tue, 4 May 2010 10:30:01 -0700
Message-ID: <20100504103001.33fcbe88.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:53889 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab0EDRcV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 13:32:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Anil Veerabhadrappa <anilgv@broadcom.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

bnx2i should depend on NET since it selects SCSI_ISCSI_ATTRS,
which depends on NET.

Also move the dependencies together.

The "depends" change fixes multiple build errors when CONFIG_NET is
not enabled:
ERROR: "skb_trim" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_kernel_create" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_kernel_release" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "skb_pull" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "init_net" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "__alloc_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_broadcast" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "skb_put" [drivers/scsi/scsi_transport_iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-2634-rc6.orig/drivers/scsi/bnx2i/Kconfig
+++ lnx-2634-rc6/drivers/scsi/bnx2i/Kconfig
@@ -1,10 +1,11 @@
 config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
+	depends on NET
+	depends on PCI
 	select SCSI_ISCSI_ATTRS
 	select NETDEVICES
 	select NETDEV_1000
 	select CNIC
-	depends on PCI
 	---help---
 	This driver supports iSCSI offload for the Broadcom NetXtreme II
 	devices.
