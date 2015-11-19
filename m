From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: hpsa: select CONFIG_SCSI_SAS_ATTR
Date: Thu, 19 Nov 2015 23:04:35 +0100
Message-ID: <3970646.5sOyETUiWo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

The hpsa driver recently started using the sas transport class, but it
does not ensure that the corresponding code is actually built, which
may lead to a link error:

drivers/built-in.o: In function `hpsa_free_sas_phy':
(.text+0x1ce874): undefined reference to `sas_port_delete_phy'
(.text+0x1ce87c): undefined reference to `sas_phy_free'
drivers/built-in.o: In function `hpsa_alloc_sas_port':
(.text+0x1ceb9c): undefined reference to `sas_port_alloc_num'
(.text+0x1ceba8): undefined reference to `sas_port_add'
drivers/built-in.o: In function `hpsa_init':
(.init.text+0x8838): undefined reference to `sas_attach_transport'
(.init.text+0x8868): undefined reference to `sas_release_transport

This adds 'select SCSI_SAS_ATTR' in the Kconfig entry, just like we do
for all other drivers using those functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
---
This showed up on the ARM randconfig builds today for the first time.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 04a720686516..64eed87d34a8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -364,6 +364,7 @@ config SCSI_HPSA
 	tristate "HP Smart Array SCSI driver"
 	depends on PCI && SCSI
 	select CHECK_SIGNATURE
+	select SCSI_SAS_ATTRS
 	help
 	  This driver supports HP Smart Array Controllers (circa 2009).
 	  It is a SCSI alternative to the cciss driver, which is a block
