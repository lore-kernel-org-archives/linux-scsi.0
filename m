From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] scsi: qla4xxx driver depends on NET
Date: Sat, 10 Sep 2011 17:13:34 -0700
Message-ID: <4E6BFD2E.4020908@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:32972 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750862Ab1IKANg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Sep 2011 20:13:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: JBottomley@parallels.com, Linus Torvalds <torvalds@linux-foundation.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com

From: Randy Dunlap <rdunlap@xenotime.net>

When CONFIG_NET is disabled, SCSI_QLA_ISCSI selects SCSI_ISCSI_ATTRS,
which uses network interfaces, so the build fails with multiple errors:

warning: (ISCSI_TCP && SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_QLA_ISCSI && INFINIBAND_ISER) selects SCSI_ISCSI_ATTRS which has unmet direct dependencies (SCSI && NET)

ERROR: "skb_trim" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_kernel_create" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_kernel_release" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "skb_pull" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "init_net" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "__alloc_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "netlink_broadcast" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "skb_put" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
ERROR: "sysfs_format_mac" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

so make SCSI_QLA_ISCSI also depend on NET to prevent the build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Ravi Anand <ravi.anand@qlogic.com>
Cc:	Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc:	iscsi-driver@qlogic.com
---
 drivers/scsi/qla4xxx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-31-rc5.orig/drivers/scsi/qla4xxx/Kconfig
+++ lnx-31-rc5/drivers/scsi/qla4xxx/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX and ISP82XX host adapter family support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	---help---
 	This driver supports the QLogic 40xx (ISP4XXX) and 8022 (ISP82XX)
