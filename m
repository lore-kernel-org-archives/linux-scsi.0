From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mpt3sas: add PCI dependency for CONFIG_SCSI_MPT2SAS
Date: Fri, 04 Dec 2015 15:27:40 +0100
Message-ID: <1953916.xaj9Y2FReq@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

CONFIG_SCSI_MPT2SAS was added as a backwards-compatibility helper that
selects the replacement SCSI_MPT3SAS symbol, but lacks the dependencies:

warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS which has unmet direct dependencies (SCSI_LOWLEVEL && PCI && SCSI)
0x7E5F9A79 Fri Dec 4 12:36:08 CET 2015 failed
drivers/scsi/mpt3sas/mpt3sas_base.c: In function 'mpt3sas_remove_dead_ioc_func':
drivers/scsi/mpt3sas/mpt3sas_base.c:140:2: error: implicit declaration of function 'pci_stop_and_remove_bus_device_locked' [-Werror=implicit-function-declaration]
drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_base_disable_msix':
drivers/scsi/mpt3sas/mpt3sas_base.c:1921:2: error: implicit declaration of function 'pci_disable_msix' [-Werror=implicit-function-declaration]

This adds the same dependencies that SCSI_MPT3SAS has.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b840c3627b6f ("mpt3sas: Add dummy Kconfig option for backwards compatibility")
---
This appeared on today's linux-next with ARM randconfig builds

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 25dc38f25ec6..33dc427cfe9a 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -74,6 +74,7 @@ config SCSI_MPT3SAS_MAX_SGE
 
 config SCSI_MPT2SAS
 	tristate "Legacy MPT2SAS config option"
+	depends on PCI && SCSI
 	default n
 	select SCSI_MPT3SAS
 	---help---
