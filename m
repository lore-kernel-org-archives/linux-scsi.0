From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix be2iscsi build
Date: Tue, 4 May 2010 10:29:52 -0700
Message-ID: <20100504102952.1c7611d4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51463 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0EDRam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 13:30:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, Jayamohan Kallickal <jayamohank@serverengines.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi driver should #include linux/if_ether.h since it uses
sysfs_format_mac().

It should also depend on NET since it selects SCSI_ISCSI_ATTRS,
which depends on NET.

These changes fix a build error when CONFIG_NET is not enabled:
ERROR: "sysfs_format_mac" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/Kconfig   |    2 +-
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- lnx-2634-rc6.orig/drivers/scsi/be2iscsi/be_main.h
+++ lnx-2634-rc6/drivers/scsi/be2iscsi/be_main.h
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/if_ether.h>
 #include <linux/in.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
--- lnx-2634-rc6.orig/drivers/scsi/be2iscsi/Kconfig
+++ lnx-2634-rc6/drivers/scsi/be2iscsi/Kconfig
@@ -1,6 +1,6 @@
 config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 
 	help
