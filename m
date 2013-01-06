From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 2/9] libata: Add CONFIG_SATA_ZPODD
Date: Sun,  6 Jan 2013 10:48:22 +0800
Message-ID: <1357440509-28108-3-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3AFCsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jan 2013 21:48:22 -0500
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

Added a new config CONFIG_SATA_ZPODD, which is used to support
SATA based zero power ODD(ZPODD), and depends on ATA_ACPI.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/Kconfig  | 13 +++++++++++++
 drivers/ata/Makefile |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..996d16c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -58,6 +58,19 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_ZPODD
+	bool "SATA Zero Power ODD Support"
+	depends on ATA_ACPI
+	default n
+	help
+	  This option adds support for SATA ZPODD. It requires both
+	  ODD and the platform support, and if enabled, will automatically
+	  power on/off the ODD when certain condition is satisfied. This
+	  does not impact user's experience of the ODD, only power is saved
+	  when ODD is not in use(i.e. no disc inside).
+
+	  If unsure, say N.
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
-- 
1.7.11.7

