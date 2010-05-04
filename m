From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix cxgb3i build errors
Date: Tue, 4 May 2010 10:28:33 -0700
Message-ID: <20100504102833.db09b0df.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51537 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0EDRaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 13:30:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Karen Xie <kxie@chelsio.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

cxgb3i should depend on NET since it selects SCSI_ISCSI_ATTRS,
which depends on NET.
This change fixes multiple build (link) errors:

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
Cc: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgb3i/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-rc6.orig/drivers/scsi/cxgb3i/Kconfig
+++ lnx-2634-rc6/drivers/scsi/cxgb3i/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_CXGB3_ISCSI
 	tristate "Chelsio S3xx iSCSI support"
-	depends on CHELSIO_T3_DEPENDS
+	depends on CHELSIO_T3_DEPENDS && NET
 	select CHELSIO_T3
 	select SCSI_ISCSI_ATTRS
 	---help---
