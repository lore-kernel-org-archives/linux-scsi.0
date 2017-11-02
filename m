From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: hisi_sas: select CONFIG_RAS
Date: Thu,  2 Nov 2017 17:50:53 +0100
Message-ID: <20171102165059.213216-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:58050 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933391AbdKBQvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2017 12:51:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The driver now uses the RAS infrastructure, and fails to link if that
is disabled:

drivers/scsi/hisi_sas/hisi_sas_v2_hw.o: In function `fatal_ecc_int_v2_hw':
hisi_sas_v2_hw.c:(.text+0xb08): undefined reference to `__tracepoint_non_standard_event'
drivers/scsi/hisi_sas/hisi_sas_v2_hw.o: In function `fatal_axi_int_v2_hw':
hisi_sas_v2_hw.c:(.text+0x1b34): undefined reference to `__tracepoint_non_standard_event'

This adds an explicit Kconfig 'select RAS' statement. I don't know if
the driver uses the interface correctly, as no other driver seems to do
it like this, but the change fixes the link error.

Fixes: dfeb5021f001 ("scsi: hisi_sas: report ECC and AXI errors in v2 hw to userspace")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/hisi_sas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index d42f29a5eb65..6ad8a6251d21 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -4,6 +4,7 @@ config SCSI_HISI_SAS
 	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
+	select RAS
 	depends on ATA
 	help
 		This driver supports HiSilicon's SAS HBA, including support based
-- 
2.9.0
