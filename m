From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH] qedi: Add ISCSI_BOOT_SYSFS to Kconfig
Date: Wed, 19 Jul 2017 02:07:55 -0700
Message-ID: <20170719090755.27946-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:23376
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752582AbdGSJH6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 05:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

qedi uses iscsi_boot_sysfs to export the targets used
for boot to sysfs. Select the config option to make sure
the module is built.

This addresses the compile time issue,
    drivers/scsi/qedi/qedi_main.o: In function `qedi_remove':
    qedi_main.c:(.text+0x3bbd): undefined reference to `iscsi_boot_destroy_kset'
    drivers/scsi/qedi/qedi_main.o: In function `__qedi_probe.constprop.0':
    qedi_main.c:(.text+0x577a): undefined reference to `iscsi_boot_create_target'
    qedi_main.c:(.text+0x5807): undefined reference to `iscsi_boot_create_target'
    qedi_main.c:(.text+0x587f): undefined reference to `iscsi_boot_create_initiator'
    qedi_main.c:(.text+0x58f3): undefined reference to `iscsi_boot_create_ethernet'
    qedi_main.c:(.text+0x5927): undefined reference to `iscsi_boot_destroy_kset'
    qedi_main.c:(.text+0x5d7b): undefined reference to `iscsi_boot_create_host_kset'

Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
---
 drivers/scsi/qedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
index 2133145..6f3773f 100644
--- a/drivers/scsi/qedi/Kconfig
+++ b/drivers/scsi/qedi/Kconfig
@@ -5,6 +5,7 @@ config QEDI
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
 	select QED_ISCSI
+    select ISCSI_BOOT_SYSFS
 	---help---
 	This driver supports iSCSI offload for the QLogic FastLinQ
 	41000 Series Converged Network Adapters.
-- 
1.8.3.1
