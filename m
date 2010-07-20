From: akpm@linux-foundation.org
Subject: [patch 21/27] scsi: fix be2iscsi build
Date: Tue, 20 Jul 2010 15:29:01 -0700
Message-ID: <201007202229.o6KMT1hG021785@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932886Ab0GTW3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, jayamohank@serverengines.com

From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi driver should #include linux/if_ether.h since it uses
sysfs_format_mac().

It should also depend on NET since it selects SCSI_ISCSI_ATTRS,
which depends on NET.

These changes fix a build error when CONFIG_NET is not enabled:
ERROR: "sysfs_format_mac" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/be2iscsi/Kconfig   |    2 +-
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/be2iscsi/Kconfig~scsi-fix-be2iscsi-build drivers/scsi/be2iscsi/Kconfig
--- a/drivers/scsi/be2iscsi/Kconfig~scsi-fix-be2iscsi-build
+++ a/drivers/scsi/be2iscsi/Kconfig
@@ -1,6 +1,6 @@
 config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 
 	help
diff -puN drivers/scsi/be2iscsi/be_main.h~scsi-fix-be2iscsi-build drivers/scsi/be2iscsi/be_main.h
--- a/drivers/scsi/be2iscsi/be_main.h~scsi-fix-be2iscsi-build
+++ a/drivers/scsi/be2iscsi/be_main.h
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/if_ether.h>
 #include <linux/in.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
_
