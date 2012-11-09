From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 02/10] ata: zpodd: Add CONFIG_SATA_ZPODD
Date: Fri,  9 Nov 2012 14:51:54 +0800
Message-ID: <1352443922-13734-3-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

Added a new config CONFIG_SATA_ZPODD, which is used to support
SATA based zero power ODD. It depends on ATA_ACPI, and selects
BLK_DEV_SR as the implementation of ZPODD depends on SCSI sr driver.

A new file libata-zpodd.c is added, which will be used to host ZPODD
related code. It is empty for this commit.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/Kconfig  | 12 ++++++++++++
 drivers/ata/Makefile |  1 +
 2 files changed, 13 insertions(+)
 create mode 100644 drivers/ata/libata-zpodd.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..9bcb8fb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -58,6 +58,18 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_ZPODD
+	bool "SATA Zero Power ODD Support"
+	depends on ATA_ACPI
+	select BLK_DEV_SR
+	default n
+	help
+	  This option adds support for SATA ZPODD. It requires both
+	  ODD and the platform support, and if enabled, will automatically
+	  power on/off the ODD when certain condition is satisfied. This
+	  does not impact user's experience of the ODD, only power is saved
+	  when ODD is not in use(i.e. no disc inside).
+
 config SATA_PMP
 	bool "SATA Port Multiplier support"
 	default y
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 9329daf..85e3de4 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -107,3 +107,4 @@ libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
+libata-$(CONFIG_SATA_ZPODD)	+= libata-zpodd.o
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
new file mode 100644
index 0000000..e69de29
-- 
1.7.12.4

