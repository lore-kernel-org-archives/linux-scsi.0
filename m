From: akpm@linux-foundation.org
Subject: [patch 22/27] scsi: fix bnx2i build errors
Date: Tue, 20 Jul 2010 15:29:02 -0700
Message-ID: <201007202229.o6KMT2Fm021788@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761857Ab0GTWfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:35:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, anilgv@broadcom.com

From: Randy Dunlap <randy.dunlap@oracle.com>

bnx2i should depend on NET since it selects SCSI_ISCSI_ATTRS, which
depends on NET.

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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bnx2i/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/bnx2i/Kconfig~scsi-fix-bnx2i-build-errors drivers/scsi/bnx2i/Kconfig
--- a/drivers/scsi/bnx2i/Kconfig~scsi-fix-bnx2i-build-errors
+++ a/drivers/scsi/bnx2i/Kconfig
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
_
