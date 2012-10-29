From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 02/11] ata: zpodd: Add CONFIG_SATA_ZPODD
Date: Mon, 29 Oct 2012 17:01:29 +0800
Message-ID: <1351501298-3716-3-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Added a new config CONFIG_SATA_ZPODD, which is ued to support
SATA based zero power ODD. It depends on ACPI, and selects BLK_DEV_SR
as the implementation of ZPODD depends on SCSI sr driver.

2 new files are added, which will be used to host ZPODD related code.
They are empty for this commit.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/Kconfig  | 12 ++++++++++++
 drivers/ata/Makefile |  1 +
 2 files changed, 13 insertions(+)
 create mode 100644 drivers/ata/sata_zpodd.c
 create mode 100644 drivers/ata/sata_zpodd.h

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..2cdecee 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -58,6 +58,18 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_ZPODD
+	bool "SATA Zero Power ODD Support"
+	depends on ACPI
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
index 9329daf..a5120ff 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -107,3 +107,4 @@ libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
+obj-$(CONFIG_SATA_ZPODD)	+= sata_zpodd.o
diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/ata/sata_zpodd.h b/drivers/ata/sata_zpodd.h
new file mode 100644
index 0000000..e69de29
-- 
1.7.12.4

