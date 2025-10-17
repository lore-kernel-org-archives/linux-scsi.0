Received: from mail-m1973180.qiye.163.com (mail-m1973180.qiye.163.com [220.197.31.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EDA33469A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760686419; cv=none; b=rDUUXo1i3eDzbJJ+cPoG9rfxJV1EK58v7Evj/HMJ2xM+4yDDhMEtCz4eL7mEDaZdzwMnGGEQ7gcsKfg6m8E+Ik+/tTnnaBqD+j/f72b4Ym60xZHlJW0hTiseDUJIQThMigWgXEUqqsFcqp3eoMdiSNrowLQqyg57c/U0rTOKGZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760686419; c=relaxed/simple;
	bh=HHVsYRCPYwWXc6nhHzQq86haQeFtBKB+xT2UvNGvgNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=apn4saT0KXCGF/P4q3FaQdCBB8F+xf26VzblcMDqvIVFEW0hPTYWZDZ6hfUK9g0+3vT48ZGS4hycxNNw4wVFWyyh7ZHa9ufmT23lVJEP5No4LiOCiqx5Urbdrpdv9R0XqNvvSujl3hbA3iSI25++y37Y12dh9lZxjWQRzkJnu4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=KnokD/CR; arc=none smtp.client-ip=220.197.31.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="KnokD/CR"
Received: from localhost.localdomain (unknown [1.203.157.252])
	by smtp.qiye.163.com (Hmail) with ESMTP id 263fd1b60;
	Fri, 17 Oct 2025 15:28:08 +0800 (GMT+08:00)
From: doubled <doubled@leap-io-kernel.com>
To: doubled@leap-io-kernel.com
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v2] scsi: leapraid: Add new scsi driver
Date: Fri, 17 Oct 2025 15:28:07 +0800
Message-Id: <20251017072807.3327789-1-doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250919100032.3931476-1-doubled@leap-io-kernel.com>
References: <20250919100032.3931476-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a99f111a18b09cckunmbf2eebf911c66e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSEwZVhlIGU8YQk1KH0NOSlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKVUlLSFVKTkxVSU5JWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=KnokD/CRqGaesWH5YNL52g0yRs3zPZow3TWmvch0RsaykZm8i7epQU5Y3C+65IsAEanaf3FnSGNnj4Q0JcFCcpAREuGR79cwFXrN0FXSwQaOhdS/p60VGrlJku/jGQZb6KXMoRRSk9dQI82J1joJywZ6cOZd0NuyddM8nd5hlJkdXh9i0TqJWLisD4qAm4pKUIs1IN6lLN1LN3E4okH17xo4wDItrhwu2lynccvvY3+ZWucYhWfpH6IFllpUcUicjQVRQeORduPwY6TBjuDagu54dqhDlCzxUSi6ezEPDP3RhRFHSbypg0QAoroMiBB566FD0C+SBMLcNcRMw5h8Cw==; s=default; c=relaxed/relaxed; d=leap-io-kernel.com; v=1;
	bh=o9obGuh1ZweoQ5KgfAnbn9euC2u5eT/1vLEY+0bmLGI=;
	h=date:mime-version:subject:message-id:from;

This commit adds support for the LeapIO
RAID controller. It supports RAID levels
0, 1, 5, 6, 10, 50, and 60, and works with
both SAS and SATA HDDs/SSDs.

Signed-off-by: doubled <doubled@leap-io-kernel.com>
---
Changes in v2:
 - fix unused variable and undocumented struct member warnings.
 - refactor volume event handling and drive hotplug logic
v1:
 - Link: https://lore.kernel.org/all/20250919100032.3931476-1-doubled@leap-io-kernel.com/
---
 Documentation/scsi/index.rst               |    1 +
 Documentation/scsi/leapraid.rst            |   35 +
 MAINTAINERS                                |    7 +
 drivers/scsi/Kconfig                       |    1 +
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/leapraid/Kconfig              |   11 +
 drivers/scsi/leapraid/Makefile             |   10 +
 drivers/scsi/leapraid/leapraid.h           | 1131 +++
 drivers/scsi/leapraid/leapraid_app.c       |  713 ++
 drivers/scsi/leapraid/leapraid_func.c      | 8355 ++++++++++++++++++++
 drivers/scsi/leapraid/leapraid_func.h      | 1347 ++++
 drivers/scsi/leapraid/leapraid_os.c        | 2390 ++++++
 drivers/scsi/leapraid/leapraid_transport.c | 1235 +++
 13 files changed, 15237 insertions(+)
 create mode 100644 Documentation/scsi/leapraid.rst
 create mode 100644 drivers/scsi/leapraid/Kconfig
 create mode 100644 drivers/scsi/leapraid/Makefile
 create mode 100644 drivers/scsi/leapraid/leapraid.h
 create mode 100644 drivers/scsi/leapraid/leapraid_app.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.h
 create mode 100644 drivers/scsi/leapraid/leapraid_os.c
 create mode 100644 drivers/scsi/leapraid/leapraid_transport.c

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index f15a0f348ae4..52970f0159ca 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -56,6 +56,7 @@ SCSI host adapter drivers
    g_NCR5380
    hpsa
    hptiop
+   leapraid
    libsas
    lpfc
    megaraid
diff --git a/Documentation/scsi/leapraid.rst b/Documentation/scsi/leapraid.rst
new file mode 100644
index 000000000000..3fb464bb1aef
--- /dev/null
+++ b/Documentation/scsi/leapraid.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+LeapRaid Driver for Linux
+=========================
+
+Introduction
+============
+
+LeapRaid is a storage RAID controller driver developed by LeapIO Tech.
+The controller targets enterprise storage, cloud infrastructure, high
+performance computing (HPC), and AI workloads.
+
+It provides high-performance storage virtualization over PCI Express
+Gen4 and supports both SAS and SATA HDDs and SSDs. It offers both Host
+Bus Adapter (HBA) and RAID modes to meet diverse deployment requirements.
+
+Features
+========
+- PCIe Gen4 x8 host interface
+- Support for SAS and SATA devices
+- RAID levels: 0, 1, 10, 5, 50, 6, 60
+- Advanced error handling and end-to-end data integrity
+- NVMe/SATA/SAS tri-mode connectivity (future roadmap)
+
+File Location
+=============
+The driver source is located at:
+
+``drivers/scsi/leapraid/``
+
+.. note::
+
+   This document is intended for kernel developers and system
+   integrators who need to build, test, and deploy the LeapRaid driver.
\ No newline at end of file
diff --git a/MAINTAINERS b/MAINTAINERS
index a20ec47e42ee..17ebb8830a25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13836,6 +13836,13 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/hardening
 F:	scripts/leaking_addresses.pl
 
+LEAPIO SCSI RAID DRIVER
+M:	doubled <doubled@leap-io-kernel.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	Documentation/scsi/leapraid.rst
+F:	drivers/scsi/leapraid/
+
 LED SUBSYSTEM
 M:	Lee Jones <lee@kernel.org>
 M:	Pavel Machek <pavel@kernel.org>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5522310bab8d..dd2429566743 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -462,6 +462,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 source "drivers/scsi/hisi_sas/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"
+source "drivers/scsi/leapraid/Kconfig"
 
 config SCSI_MVUMI
 	tristate "Marvell UMI driver"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c..5b7bd119cd9f 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -152,6 +152,7 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
 obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
+obj-$(CONFIG_SCSI_LEAPRAID) += leapraid/
 
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
diff --git a/drivers/scsi/leapraid/Kconfig b/drivers/scsi/leapraid/Kconfig
new file mode 100644
index 000000000000..7edc377e3514
--- /dev/null
+++ b/drivers/scsi/leapraid/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+config SCSI_LEAPRAID
+		tristate "LeapIO RAID Adapter"
+		depends on PCI && SCSI
+		select SCSI_SAS_ATTRS
+		help
+		  Driver for LeapIO Storage & RAID
+		  Controllers.
+		  To compile this driver as a module, choose M here: the
+		  module will be called leapraid.
diff --git a/drivers/scsi/leapraid/Makefile b/drivers/scsi/leapraid/Makefile
new file mode 100644
index 000000000000..bdafc036cd00
--- /dev/null
+++ b/drivers/scsi/leapraid/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the LEAPRAID drivers.
+#
+
+obj-$(CONFIG_SCSI_LEAPRAID) += leapraid.o
+leapraid-objs += leapraid_func.o \
+		leapraid_os.o \
+		leapraid_transport.o \
+		leapraid_app.o
diff --git a/drivers/scsi/leapraid/leapraid.h b/drivers/scsi/leapraid/leapraid.h
new file mode 100644
index 000000000000..36fc2970b13e
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid.h
@@ -0,0 +1,1131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ */
+
+#ifndef LEAPRAID_H
+#define LEAPRAID_H
+
+// #define LEAPRAID_ADAPTER_COALESCING_TEST
+
+#define REP_POST_HOST_IDX_REG_CNT (16)
+
+#define LEAPRAID_DB_RESET		(0x00000000)
+#define LEAPRAID_DB_READY		(0x10000000)
+#define LEAPRAID_DB_OPERATIONAL	(0x20000000)
+#define LEAPRAID_DB_FAULT		(0x40000000)
+#define LEAPRAID_DB_MASK		(0xF0000000)
+
+#define LEAPRAID_DB_OVER_TEMPERATURE	(0x2810)
+
+#define LEAPRAID_DB_USED				(0x08000000)
+#define LEAPRAID_DB_DATA_MASK			(0x0000FFFF)
+#define LEAPRAID_DB_FUNC_SHIFT			(24)
+#define LEAPRAID_DB_ADD_DWORDS_SHIFT	(16)
+
+#define LEAPRAID_DIAG_WRITE_ENABLE      (0x00000080)
+#define LEAPRAID_DIAG_RESET				(0x00000004)
+#define LEAPRAID_DIAG_HOLD_ADAPTER_RESET	(0x00000002)
+
+#define LEAPRAID_HOST2ADAPTER_DB_STATUS	(0x80000000)
+#define LEAPRAID_ADAPTER2HOST_DB_STATUS	(0x00000001)
+
+#define LEAPRAID_RPHI_MSIX_IDX_SHIFT	(24)
+
+#define LEAPRAID_REQ_DESC_FLG_SCSI_IO		(0x00)
+#define LEAPRAID_REQ_DESC_FLG_HPR			(0x06)
+#define LEAPRAID_REQ_DESC_FLG_DFLT_TYPE		(0x08)
+
+#define LEAPRAID_RPY_DESC_FLG_TYPE_MASK				(0x0F)
+#define LEAPRAID_RPY_DESC_FLG_SCSI_IO_SUCCESS		(0x00)
+#define LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY			(0x01)
+#define LEAPRAID_RPY_DESC_FLG_UNUSED				(0x0F)
+
+#define LEAPRAID_FUNC_SCSIIO_REQ				(0x00)
+#define LEAPRAID_FUNC_SCSI_TMF					(0x01)
+#define LEAPRAID_FUNC_ADAPTER_INIT				(0x02)
+#define LEAPRAID_FUNC_GET_ADAPTER_FEATURES		(0x03)
+#define LEAPRAID_FUNC_CONFIG_OP					(0x04)
+#define LEAPRAID_FUNC_SCAN_DEV					(0x06)
+#define LEAPRAID_FUNC_EVENT_NOTIFY				(0x07)
+#define LEAPRAID_FUNC_FW_DOWNLOAD				(0x09)
+#define LEAPRAID_FUNC_FW_UPLOAD					(0x12)
+#define LEAPRAID_FUNC_RAID_ACTION				(0x15)
+#define LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH	(0x16)
+#define LEAPRAID_FUNC_SCSI_ENC_PROCESSOR		(0x18)
+#define LEAPRAID_FUNC_SMP_PASSTHROUGH			(0x1A)
+#define LEAPRAID_FUNC_SAS_IO_UNIT_CTRL			(0x1B)
+#define LEAPRAID_FUNC_SATA_PASSTHROUGH			(0x1C)
+#define LEAPRAID_FUNC_ADAPTER_UNIT_RESET		(0x40)
+#define LEAPRAID_FUNC_HANDSHAKE					(0x42)
+#define LEAPRAID_FUNC_LOGBUF_INIT				(0x57)
+
+#define LEAPRAID_ADAPTER_STATUS_MASK	(0x7FFF)
+#define LEAPRAID_ADAPTER_STATUS_SUCCESS	(0x0000)
+#define LEAPRAID_ADAPTER_STATUS_BUSY	(0x0002)
+#define LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR	(0x0004)
+#define LEAPRAID_ADAPTER_STATUS_INSUFFICIENT_RESOURCES	(0x0006)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_ACTION	(0x0020)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_TYPE		(0x0021)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE		(0x0022)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_DATA		(0x0023)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_NO_DEFAULTS		(0x0024)
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_CANT_COMMIT		(0x0025)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_RECOVERED_ERROR	(0x0040)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DEVICE_NOT_THERE	(0x0043)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DATA_OVERRUN		(0x0044)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN		(0x0045)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_IO_DATA_ERROR		(0x0046)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_PROTOCOL_ERROR		(0x0047)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_TASK_TERMINATED	(0x0048)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_RESIDUAL_MISMATCH	(0x0049)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_TASK_MGMT_FAILED	(0x004A)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_ADAPTER_TERMINATED	(0x004B)
+#define LEAPRAID_ADAPTER_STATUS_SCSI_EXT_TERMINATED		(0x004C)
+
+#define LEAPRAID_SGE_FLG_LAST_ONE		(0x80)
+#define LEAPRAID_SGE_FLG_EOB			(0x40)
+#define LEAPRAID_SGE_FLG_EOL			(0x01)
+#define LEAPRAID_SGE_FLG_SHIFT			(24)
+#define LEAPRAID_SGE_FLG_SIMPLE_ONE		(0x10)
+#define LEAPRAID_SGE_FLG_SYSTEM_ADDR	(0x00)
+#define LEAPRAID_SGE_FLG_H2C			(0x04)
+#define LEAPRAID_SGE_FLG_32				(0x00)
+#define LEAPRAID_SGE_FLG_64				(0x02)
+
+#define LEAPRAID_IEEE_SGE_FLG_EOL			(0x40)
+#define LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE	(0x00)
+#define LEAPRAID_IEEE_SGE_FLG_CHAIN_ONE		(0x80)
+#define LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR	(0x00)
+
+#define LEAPRAID_CFG_PT_IO_UNIT			(0x00)
+#define LEAPRAID_CFG_PT_ADAPTER			(0x01)
+#define LEAPRAID_CFG_PT_BIOS			(0x02)
+#define LEAPRAID_CFG_PT_RAID_VOLUME		(0x08)
+#define LEAPRAID_CFG_PT_RAID_PHYSDISK	(0x0A)
+#define LEAPRAID_CFG_PT_EXTENDED		(0x0F)
+#define LEAPRAID_CFG_EXTPT_SAS_IO_UNIT	(0x10)
+#define LEAPRAID_CFG_EXTPT_SAS_EXP		(0x11)
+#define LEAPRAID_CFG_EXTPT_SAS_DEV		(0x12)
+#define LEAPRAID_CFG_EXTPT_SAS_PHY		(0x13)
+#define LEAPRAID_CFG_EXTPT_ENC			(0x15)
+#define LEAPRAID_CFG_EXTPT_RAID_CONFIG	(0x16)
+
+#define LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP		(0x00000000)
+#define LEAPRAID_SAS_ENC_CFG_PGAD_HDL			(0x10000000)
+#define LEAPRAID_SAS_DEV_CFG_PGAD_HDL			(0x20000000)
+#define LEAPRAID_SAS_EXP_CFG_PGAD_HDL_PHY_NUM	(0x10000000)
+#define LEAPRAID_SAS_EXP_CFD_PGAD_HDL			(0x20000000)
+#define LEAPRAID_SAS_EXP_CFG_PGAD_PHYNUM_SHIFT	(16)
+#define LEAPRAID_RAID_VOL_CFG_PGAD_HDL			(0x10000000)
+#define LEAPRAID_SAS_PHY_CFG_PGAD_PHY_NUMBER	(0x00000000)
+#define LEAPRAID_PHYSDISK_CFG_PGAD_PHYSDISKNUM	(0x10000000)
+
+#define LEAPRAID_CFG_ACT_PAGE_HEADER		(0x00)
+#define LEAPRAID_CFG_ACT_PAGE_READ_CUR		(0x01)
+#define LEAPRAID_CFG_ACT_PAGE_WRITE_CUR		(0x02)
+
+
+#define LEAPRAID_VOL_STATE_MISSING		(0x00)
+#define LEAPRAID_VOL_STATE_FAILED		(0x01)
+#define LEAPRAID_VOL_STATE_INITIALIZING	(0x02)
+#define LEAPRAID_VOL_STATE_ONLINE		(0x03)
+#define LEAPRAID_VOL_STATE_DEGRADED		(0x04)
+#define LEAPRAID_VOL_STATE_OPTIMAL		(0x05)
+#define LEAPRAID_VOL_TYPE_RAID0			(0x00)
+#define LEAPRAID_VOL_TYPE_RAID1E		(0x01)
+#define LEAPRAID_VOL_TYPE_RAID1			(0x02)
+#define LEAPRAID_VOL_TYPE_RAID10		(0x05)
+#define LEAPRAID_VOL_TYPE_UNKNOWN		(0xFF)
+
+#define LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL		(0x0F)
+#define LEAPRAID_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE	(0x00)
+#define LEAPRAID_SAS_NEG_LINK_RATE_PHY_DISABLED			(0x01)
+#define LEAPRAID_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED	(0x02)
+#define LEAPRAID_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE	(0x03)
+#define LEAPRAID_SAS_NEG_LINK_RATE_PORT_SELECTOR		(0x04)
+#define LEAPRAID_SAS_NEG_LINK_RATE_SMP_RESETTING		(0x05)
+#define LEAPRAID_SAS_NEG_LINK_RATE_1_5					(0x08)
+#define LEAPRAID_SAS_NEG_LINK_RATE_3_0					(0x09)
+#define LEAPRAID_SAS_NEG_LINK_RATE_6_0					(0x0A)
+#define LEAPRAID_SAS_NEG_LINK_RATE_12_0					(0x0B)
+
+#define LEAPRAID_SAS_PHYINFO_VPHY	(0x00001000)
+
+#define LEAPRAID_SAS_PRATE_MIN_RATE_MASK	(0x0F)
+#define LEAPRAID_SAS_HWRATE_MIN_RATE_MASK	(0x0F)
+
+#define LEAPRAID_SAS_DEV_P0_FLG_FP_CAP			(0x2000)
+#define LEAPRAID_SAS_DEV_P0_FLG_SATA_SMART		(0x0040)
+#define LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID	(0x0002)
+#define LEAPRAID_SAS_DEV_P0_FLG_DEV_PRESENT		(0x0001)
+
+#define LEAPRAID_RAIDCFG_P0_EFLG_MASK_ELEMENT_TYPE		(0x000F)
+#define LEAPRAID_RAIDCFG_P0_EFLG_VOL_PHYS_DISK_ELEMENT	(0x0001)
+#define LEAPRAID_RAIDCFG_P0_EFLG_HOT_SPARE_ELEMENT		(0x0002)
+#define LEAPRAID_RAIDCFG_P0_EFLG_OCE_ELEMENT			(0x0003)
+
+#define LEAPRAID_SCSIIO_MSGFLG_SYSTEM_SENSE_ADDR	(0x00)
+
+#define LEAPRAID_SCSIIO_CTRL_ADDCDBLEN_SHIFT	(26)
+#define LEAPRAID_SCSIIO_CTRL_NODATATRANSFER		(0x00000000)
+#define LEAPRAID_SCSIIO_CTRL_WRITE				(0x01000000)
+#define LEAPRAID_SCSIIO_CTRL_READ				(0x02000000)
+#define LEAPRAID_SCSIIO_CTRL_BIDIRECTIONAL		(0x03000000)
+#define LEAPRAID_SCSIIO_CTRL_SIMPLEQ			(0x00000000)
+#define LEAPRAID_SCSIIO_CTRL_ORDEREDQ			(0x00000200)
+
+#define LEAPRAID_SCSI_STATUS_BUSY					(0x08)
+#define LEAPRAID_SCSI_STATUS_RESERVATION_CONFLICT	(0x18)
+#define LEAPRAID_SCSI_STATUS_TASK_SET_FULL			(0x28)
+#define LEAPRAID_SCSI_STATE_RESPONSE_INFO_VALID		(0x10)
+#define LEAPRAID_SCSI_STATE_TERMINATED				(0x08)
+#define LEAPRAID_SCSI_STATE_NO_SCSI_STATUS			(0x04)
+#define LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED		(0x02)
+#define LEAPRAID_SCSI_STATE_AUTOSENSE_VALID			(0x01)
+
+#define LEAPRAID_TM_TASKTYPE_ABORT_TASK			(0x01)
+#define LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET		(0x02)
+#define LEAPRAID_TM_TASKTYPE_TARGET_RESET		(0x03)
+#define LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET	(0x05)
+#define LEAPRAID_TM_TASKTYPE_CLEAR_TASK_SET	    (0x06)
+#define LEAPRAID_TM_TASKTYPE_QUERY_TASK			(0x07)
+#define LEAPRAID_TM_TASKTYPE_CLEAR_ACA			(0x08)
+#define LEAPRAID_TM_TASKTYPE_QUERY_TASK_SET		(0x09)
+#define LEAPRAID_TM_TASKTYPE_QUERY_ASYNC_EVENT	(0x0A)
+
+#define LEAPRAID_TM_MSGFLAGS_LINK_RESET			(0x00)
+#define LEAPRAID_TM_RSP_INVALID_FRAME			(0x02)
+#define LEAPRAID_TM_RSP_TM_SUCCEEDED			(0x08)
+#define LEAPRAID_TM_RSP_IO_QUEUED_ON_ADAPTER	(0x80)
+
+#define LEAPRAID_SEP_REQ_ACT_WRITE_STATUS			(0x00)
+#define LEAPRAID_SEP_REQ_FLG_DEVHDL_ADDRESS			(0x00)
+#define LEAPRAID_SEP_REQ_FLG_ENCLOSURE_SLOT_ADDRESS	(0x01)
+#define LEAPRAID_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT	(0x00000040)
+
+#define LEAPRAID_WHOINIT_HOST_DRIVER					(0x04)
+#define LEAPRAID_ADAPTER_INIT_MSGFLG_RDPQ_ARRAY_MODE	(0x01)
+
+#define LEAPRAID_ADAPTER_FEATURES_CAP_ATOMIC_REQ	(0x00080000)
+#define LEAPRAID_ADAPTER_FEATURES_CAP_RDPQ_ARRAY_CAPABLE	(0x00040000)
+#define LEAPRAID_ADAPTER_FEATURES_CAP_EVENT_REPLAY	(0x00002000)
+#define LEAPRAID_ADAPTER_FEATURES_CAP_INTEGRATED_RAID	(0x00001000)
+
+#define LEAPRAID_EVT_SAS_DISCOVERY				(0x0016)
+
+#define LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST		(0x001C)
+#define LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE	(0x001D)
+#define LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE		(0x000F)
+
+
+#define LEAPRAID_EVT_TURN_ON_PFA_LED			(0xFFFC)
+#define LEAPRAID_EVT_REMOVE_DEAD_DEV			(0xFFFF)
+
+#define LEAPRAID_EVT_SAS_DEV_STAT_RC_INTERNAL_DEV_RESET		(0x08)
+#define LEAPRAID_EVT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET	(0x0E)
+
+
+#define LEAPRAID_EVT_IR_CHANGE                  (0x0020)
+
+#define LEAPRAID_EVT_IR_RC_VOLUME_ADD                       (0x01)
+#define LEAPRAID_EVT_IR_RC_VOLUME_DELETE                    (0x02)
+#define LEAPRAID_EVT_IR_RC_PD_HIDDEN_TO_ADD                 (0x03)
+#define LEAPRAID_EVT_IR_RC_PD_UNHIDDEN_TO_DELETE            (0x04)
+#define LEAPRAID_EVT_IR_RC_PD_CREATED_TO_HIDE               (0x05)
+#define LEAPRAID_EVT_IR_RC_PD_DELETED_TO_EXPOSE             (0x06)
+
+#define LEAPRAID_EVT_SAS_TOPO_ES_NO_EXPANDER			(0x00)
+#define LEAPRAID_EVT_SAS_TOPO_ES_ADDED					(0x01)
+#define LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING			(0x02)
+#define LEAPRAID_EVT_SAS_TOPO_ES_RESPONDING				(0x03)
+
+#define LEAPRAID_EVT_SAS_TOPO_RC_MASK					(0x0F)
+#define LEAPRAID_EVT_SAS_TOPO_RC_TARG_ADDED				(0x01)
+#define LEAPRAID_EVT_SAS_TOPO_RC_TARG_NOT_RESPONDING	(0x02)
+#define LEAPRAID_EVT_SAS_TOPO_RC_PHY_CHANGED			(0x03)
+
+#define LEAPRAID_EVT_IR_VOLUME_RC_STATE_CHANGED		(0x03)
+#define LEAPRAID_EVT_IR_PHYSDISK_RC_STATE_CHANGED	(0x03)
+#define LEAPRAID_EVT_IR_CHANGE_FLG_FOREIGN_CONFIG	(0x00000001)
+
+#define LEAPRAID_EVT_SAS_DISC_RC_STARTED		(0x01)
+#define LEAPRAID_EVT_SAS_DISC_RC_COMPLETED		(0x02)
+
+#define LEAPRAID_EVT_SAS_ENCL_RC_ADDED			(0x01)
+#define LEAPRAID_EVT_SAS_ENCL_RC_NOT_RESPONDING	(0x02)
+
+#define LEAPRAID_EVT_PRIMITIVE_ASYNC_EVT	(0x04)
+#define LEAPRAID_CTRL_OP_REMOVE_DEV			(0x0D)
+
+#define LEAPRAID_DEVTYP_SEP			(0x00004000)
+#define LEAPRAID_DEVTYP_SSP_TGT		(0x00000400)
+#define LEAPRAID_DEVTYP_STP_TGT		(0x00000200)
+#define LEAPRAID_DEVTYP_SMP_TGT		(0x00000100)
+#define LEAPRAID_DEVTYP_SATA_DEV	(0x00000080)
+#define LEAPRAID_DEVTYP_SSP_INIT	(0x00000040)
+#define LEAPRAID_DEVTYP_STP_INIT	(0x00000020)
+#define LEAPRAID_DEVTYP_SMP_INIT	(0x00000010)
+#define LEAPRAID_DEVTYP_SATA_HOST	(0x00000008)
+
+#define LEAPRAID_DEVTYP_MASK_DEV_TYPE	(0x00000007)
+#define LEAPRAID_DEVTYP_NO_DEV			(0x00000000)
+#define LEAPRAID_DEVTYP_END_DEV			(0x00000001)
+#define LEAPRAID_DEVTYP_EDGE_EXPANDER	(0x00000002)
+#define LEAPRAID_DEVTYP_FANOUT_EXPANDER	(0x00000003)
+
+#define LEAPRAID_SAS_OP_PHY_LINK_RESET	(0x06)
+#define LEAPRAID_SAS_OP_PHY_HARD_RESET	(0x07)
+#define LEAPRAID_SAS_OP_SET_PARAMETER	(0x0F)
+
+#define LEAPRAID_RAID_ACT_SYSTEM_SHUTDOWN_INITIATED		(0x20)
+#define LEAPRAID_RAID_ACT_PHYSDISK_HIDDEN				(0x24)
+
+
+#define LEAPRAID_BOOTDEV_FORM_MASK		(0x0F)
+#define LEAPRAID_BOOTDEV_FORM_NONE		(0x00)
+#define LEAPRAID_BOOTDEV_FORM_SAS_WWID	(0x05)
+#define LEAPRAID_BOOTDEV_FORM_ENC_SLOT	(0x06)
+#define LEAPRAID_BOOTDEV_FORM_DEV_NAME	(0x07)
+
+
+struct leapraid_reg_base {
+	__le32 db;
+	__le32 ws;
+	__le32 host_diag;
+	__le32 r1[9];
+	__le32 host_int_status;
+	__le32 host_int_mask;
+	__le32 r2[4];
+	__le32 rep_msg_host_idx;
+	__le32 r3[29];
+	__le32 r4[2];
+	__le32 atomic_req_desc_post;
+	__le32 adapter_log_buf_pos;
+	__le32 host_log_buf_pos;
+	__le32 r5[142];
+	struct leapraid_rep_post_reg_idx {
+		__le32 idx;
+		__le32 r1;
+		__le32 r2;
+		__le32 r3;
+	} rep_post_reg_idx[REP_POST_HOST_IDX_REG_CNT];
+} __packed;
+
+struct leapraid_atomic_req_desc {
+	u8 flg;
+	u8 msix_idx;
+	__le16 taskid;
+};
+
+union leapraid_rep_desc_union {
+	struct leapraid_rep_desc {
+		u8 rep_flg;
+		u8 msix_idx;
+		__le16 taskid;
+		u8 r1[4];
+	} dflt_rep;
+	struct leapraid_add_rep_desc {
+		u8 rep_flg;
+		u8 msix_idx;
+		__le16 taskid;
+		__le32 rep_frame_addr;
+	} addr_rep;
+	__le64 words;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+}  __packed __aligned(4);
+
+struct leapraid_req {
+	__le16 func_dep1;
+	u8 r1;
+	u8 func;
+	u8 r2[8];
+};
+
+struct leapraid_rep {
+	u8 r1[2];
+	u8 msg_len;
+	u8 function;
+	u8 r2[10];
+	__le16 adapter_status;
+	u8 r3[4];
+};
+
+struct leapraid_sge_simple32 {
+	__le32 flg_and_len;
+	__le32 addr;
+};
+
+struct leapraid_sge_simple64 {
+	__le32 flg_and_len;
+	__le64 addr;
+} __packed __aligned(4);
+
+struct leapraid_sge_simple_union {
+	__le32 flg_and_len;
+	union {
+		__le32 addr32;
+		__le64 addr64;
+	} u;
+} __packed __aligned(4);
+
+struct leapraid_sge_chain_union {
+	__le16 len;
+	u8 next_chain_offset;
+	u8 flg;
+	union {
+		__le32 addr32;
+		__le64 addr64;
+	} u;
+} __packed __aligned(4);
+
+struct leapraid_ieee_sge_simple32 {
+	__le32 addr;
+	__le32 flg_and_len;
+};
+
+struct leapraid_ieee_sge_simple64 {
+	__le64 addr;
+	__le32 len;
+	u8 r1[3];
+	u8 flg;
+} __packed __aligned(4);
+
+union leapraid_ieee_sge_simple_union {
+	struct leapraid_ieee_sge_simple32 simple32;
+	struct leapraid_ieee_sge_simple64 simple64;
+};
+
+union leapraid_ieee_sge_chain_union {
+	struct leapraid_ieee_sge_simple32 chain32;
+	struct leapraid_ieee_sge_simple64 chain64;
+};
+
+struct leapraid_chain64_ieee_sg {
+	__le64 addr;
+	__le32 len;
+	u8 r1[2];
+	u8 next_chain_offset;
+	u8 flg;
+} __packed __aligned(4);
+
+union leapraid_ieee_sge_io_union {
+	struct leapraid_ieee_sge_simple64 ieee_simple;
+	struct leapraid_chain64_ieee_sg ieee_chain;
+};
+
+union leapraid_simple_sge_union {
+	struct leapraid_sge_simple_union leapio_simple;
+	union leapraid_ieee_sge_simple_union ieee_simple;
+};
+
+union leapraid_sge_io_union {
+	struct leapraid_sge_simple_union leapio_simple;
+	struct leapraid_sge_chain_union leapio_chain;
+	union leapraid_ieee_sge_simple_union ieee_simple;
+	union leapraid_ieee_sge_chain_union ieee_chain;
+};
+
+struct leapraid_cfg_pg_header {
+	u8 r1;
+	u8 page_len;
+	u8 page_num;
+	u8 page_type;
+};
+
+struct leapraid_cfg_ext_pg_header {
+	u8 r1;
+	u8 r2;
+	u8 page_num;
+	u8 page_type;
+	__le16 ext_page_len;
+	u8 ext_page_type;
+	u8 r3;
+};
+
+struct leapraid_cfg_req {
+	u8 action;
+	u8 sgl_flag;
+	u8 chain_offset;
+	u8 func;
+	__le16 ext_page_len;
+	u8 ext_page_type;
+	u8 msg_flag;
+	u8 r2[12];
+	struct leapraid_cfg_pg_header header;
+	__le32 page_addr;
+	union leapraid_sge_io_union page_buf_sge;
+};
+
+struct leapraid_cfg_rep {
+	u8 action;
+	u8 r1;
+	u8 msg_len;
+	u8 func;
+	__le16 ext_page_len;
+	u8 ext_page_type;
+	u8 msg_flag;
+	u8 r2[6];
+	__le16 adapter_status;
+	u8 r3[4];
+	struct leapraid_cfg_pg_header header;
+};
+
+struct leapraid_boot_dev_format_sas_wwid {
+	__le64 sas_addr;
+	u8 lun[8];
+	u8 r1[8];
+} __packed __aligned(4);
+
+struct leapraid_boot_dev_format_enc_slot {
+	__le64 enc_lid;
+	u8 r1[8];
+	__le16 slot_num;
+	u8 r2[6];
+} __packed __aligned(4);
+
+struct leapraid_boot_dev_format_dev_name {
+	__le64 dev_name;
+	u8 lun[8];
+	u8 r1[8];
+} __packed __aligned(4);
+
+union leapraid_boot_dev_format {
+	struct leapraid_boot_dev_format_sas_wwid sas_wwid;
+	struct leapraid_boot_dev_format_enc_slot enc_slot;
+	struct leapraid_boot_dev_format_dev_name dev_name;
+};
+
+struct leapraid_bios_page2 {
+	struct leapraid_cfg_pg_header header;
+	u8 r1[24];
+	u8 requested_boot_dev_form;
+	u8 r2[3];
+	union leapraid_boot_dev_format requested_boot_dev;
+	u8 requested_alt_boot_dev_form;
+	u8 r3[3];
+	union leapraid_boot_dev_format requested_alt_boot_dev;
+	u8 current_boot_dev_form;
+	u8 r4[3];
+	union leapraid_boot_dev_format current_boot_dev;
+};
+
+struct leapraid_bios_page3 {
+	struct leapraid_cfg_pg_header header;
+	u8 r1[4];
+	__le32 bios_version;
+	u8 r2[84];
+};
+
+
+struct leapraid_raidvol0_phys_disk {
+	u8 r1[2];
+	u8 phys_disk_num;
+	u8 r2;
+};
+
+struct leapraid_raidvol_p0 {
+	struct leapraid_cfg_pg_header header;
+	__le16 dev_hdl;
+	u8 volume_state;
+	u8 volume_type;
+	u8 r1[28];
+	u8 num_phys_disks;
+	u8 r2[3];
+	struct leapraid_raidvol0_phys_disk phys_disk[];
+};
+
+struct leapraid_raidvol_p1 {
+	struct leapraid_cfg_pg_header header;
+	__le16 dev_hdl;
+	u8 r1[42];
+	__le64 wwid;
+	u8 r2[8];
+} __packed __aligned(4);
+
+struct leapraid_raidpd_p0 {
+	struct leapraid_cfg_pg_header header;
+	__le16 dev_hdl;
+	u8 r1;
+	u8 phys_disk_num;
+	u8 r2[112];
+};
+
+struct leapraid_sas_io_unit0_phy_info {
+	u8 port;
+	u8 port_flg;
+	u8 phy_flg;
+	u8 neg_link_rate;
+	__le32 controller_phy_dev_info;
+	__le16 attached_dev_hdl;
+	__le16 controller_dev_hdl;
+	u8 r1[8];
+};
+
+struct leapraid_sas_io_unit_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[4];
+	u8 phy_num;
+	u8 r2[3];
+	struct leapraid_sas_io_unit0_phy_info phy_info[];
+};
+
+struct leapraid_sas_io_unit1_phy_info {
+	u8 r1[12];
+};
+
+struct leapraid_sas_io_unit_page1 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[2];
+	__le16 narrowport_max_queue_depth;
+	u8 r2[2];
+	__le16 wideport_max_queue_depth;
+	u8 r3;
+	u8 sata_max_queue_depth;
+	u8 r4[2];
+	struct leapraid_sas_io_unit1_phy_info phy_info[];
+};
+
+struct leapraid_exp_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 physical_port;
+	u8 r1;
+	__le16 enc_hdl;
+	__le64 sas_address;
+	u8 r2[4];
+	__le16 dev_hdl;
+	__le16 parent_dev_hdl;
+	u8 r3[4];
+	u8 phy_num;
+	u8 r4[27];
+} __packed __aligned(4);
+
+struct leapraid_exp_p1 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[8];
+	u8 p_link_rate;
+	u8 hw_link_rate;
+	__le16 attached_dev_hdl;
+	u8 r2[11];
+	u8 neg_link_rate;
+	u8 r3[12];
+};
+
+struct leapraid_sas_dev_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	__le16 slot;
+	__le16 enc_hdl;
+	__le64 sas_address;
+	__le16 parent_dev_hdl;
+	u8 phy_num;
+	u8 r1;
+	__le16 dev_hdl;
+	u8 r2[2];
+	__le32 dev_info;
+	__le16 flg;
+	u8 physical_port;
+	u8 max_port_connections;
+	__le64 dev_name;
+	u8 port_groups;
+	u8 r3[2];
+	u8 enc_level;
+	u8 connector_name[4];
+	u8 r4[4];
+} __packed __aligned(4);
+
+struct leapraid_sas_phy_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[4];
+	__le16 attached_dev_hdl;
+	u8 r2[6];
+	u8 p_link_rate;
+	u8 hw_link_rate;
+	u8 r3[2];
+	__le32 phy_info;
+	u8 neg_link_rate;
+	u8 r4[3];
+};
+
+struct leapraid_enc_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[4];
+	__le64 enc_lid;
+	u8 r2[2];
+	__le16 enc_hdl;
+	u8 r3[15];
+} __packed __aligned(4);
+
+struct leapraid_raid_cfg_p0_element {
+	__le16 element_flg;
+	__le16 vol_dev_hdl;
+	u8 r1[2];
+	__le16 phys_disk_dev_hdl;
+};
+
+struct leapraid_raid_cfg_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[3];
+	u8 cfg_num;
+	u8 r2[32];
+	u8 elements_num;
+	u8 r3[3];
+	struct leapraid_raid_cfg_p0_element cfg_element[];
+};
+
+union leapraid_mpi_scsi_io_cdb_union {
+	u8 cdb32[32];
+	struct leapraid_sge_simple_union sge;
+};
+
+struct leapraid_mpi_scsiio_req {
+	__le16 dev_hdl;
+	u8 chain_offset;
+	u8 func;
+	u8 r1[3];
+	u8 msg_flg;
+	u8 r2[4];
+	__le32 sense_buffer_low_add;
+	u8 dma_flag;
+	u8 r3;
+	u8 sense_buffer_len;
+	u8 r4;
+	u8 sgl_offset0;
+	u8 sgl_offset1;
+	u8 sgl_offset2;
+	u8 sgl_offset3;
+	__le32 skip_count;
+	__le32 data_len;
+	__le32 bi_dir_data_len;
+	__le16 io_flg;
+	__le16 eedp_flag;
+	__le16 eedp_block_size;
+	u8 r5[2];
+	__le32 secondary_ref_tag;
+	__le16 secondary_app_tag;
+	__le16 app_tag_trans_mask;
+	u8 lun[8];
+	__le32 ctrl;
+	union leapraid_mpi_scsi_io_cdb_union cdb;
+	union leapraid_sge_io_union sgl;
+};
+
+union leapraid_scsi_io_cdb_union {
+	u8 cdb32[32];
+	struct leapraid_ieee_sge_simple64 sge;
+};
+
+struct leapraid_scsiio_req {
+	__le16 dev_hdl;
+	u8 chain_offset;
+	u8 func;
+	u8 r1[3];
+	u8 msg_flg;
+	u8 r2[4];
+	__le32 sense_buffer_low_add;
+	u8 dma_flag;
+	u8 r3;
+	u8 sense_buffer_len;
+	u8 r4;
+	u8 sgl_offset0;
+	u8 sgl_offset1;
+	u8 sgl_offset2;
+	u8 sgl_offset3;
+	__le32 skip_count;
+	__le32 data_len;
+	__le32 bi_dir_data_len;
+	__le16 io_flg;
+	__le16 eedp_flag;
+	__le16 eedp_block_size;
+	u8 r5[2];
+	__le32 secondary_ref_tag;
+	__le16 secondary_app_tag;
+	__le16 app_tag_trans_mask;
+	u8 lun[8];
+	__le32 ctrl;
+	union leapraid_scsi_io_cdb_union cdb;
+	union leapraid_ieee_sge_io_union sgl;
+};
+
+struct leapraid_scsiio_rep {
+	__le16 dev_hdl;
+	u8 msg_len;
+	u8 func;
+	u8 r1[3];
+	u8 msg_flg;
+	u8 r2[4];
+	u8 scsi_status;
+	u8 scsi_state;
+	__le16 adapter_status;
+	u8 r3[4];
+	__le32 transfer_count;
+	__le32 sense_count;
+	__le32 resp_info;
+	__le16 task_tag;
+	__le16 scsi_status_qualifier;
+	__le32 bi_dir_trans_count;
+	__le32 eedp_error_offset;
+	__le16 eedp_observed_app_tag;
+	__le16 eedp_observed_guard;
+	__le32 eedp_observed_ref_tag;
+};
+
+struct leapraid_scsi_tm_req {
+	__le16 dev_hdl;
+	u8 chain_offset;
+	u8 func;
+	u8 r1;
+	u8 task_type;
+	u8 r2;
+	u8 msg_flg;
+	u8 r3[4];
+	u8 lun[8];
+	u8 r4[28];
+	__le16 task_mid;
+	u8 r5[2];
+};
+
+struct leapraid_scsi_tm_rep {
+	__le16 dev_hdl;
+	u8 msg_len;
+	u8 func;
+	u8 resp_code;
+	u8 task_type;
+	u8 r1;
+	u8 msg_flag;
+	u8 r2[6];
+	__le16 adapter_status;
+	u8 r3[4];
+	__le32 termination_count;
+	__le32 response_info;
+};
+
+struct leapraid_sep_req {
+	__le16 dev_hdl;
+	u8 chain_offset;
+	u8 func;
+	u8 act;
+	u8 flg;
+	u8 r1;
+	u8 msg_flag;
+	u8 r2[4];
+	__le32 slot_status;
+	u8 r3[12];
+	__le16 slot;
+	__le16 enc_hdl;
+};
+
+struct leapraid_sep_rep {
+	__le16 dev_hdl;
+	u8 msg_len;
+	u8 func;
+	u8 act;
+	u8 flg;
+	u8 r1;
+	u8 msg_flag;
+	u8 r2[6];
+	__le16 adapter_status;
+	u8 r3[4];
+	__le32 slot_status;
+	u8 r4[4];
+	__le16 slot;
+	__le16 enc_hdl;
+};
+
+struct leapraid_adapter_init_req {
+	u8 who_init;
+	u8 r1;
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flg;
+	u8 r3[4];
+	__le16 msg_ver;
+	__le16 header_ver;
+	__le32 host_buf_addr;
+	u8 r4[2];
+	u8 host_buf_size;
+	u8 host_msix_vectors;
+	u8 r6[2];
+	__le16 req_frame_size;
+	__le16 rep_desc_qd;
+	__le16 rep_msg_qd;
+	__le32 sense_buffer_add_high;
+	__le32 rep_msg_dma_high;
+	__le64 task_desc_base_addr;
+	__le64 rep_desc_q_arr_addr;
+	__le64 rep_msg_addr_dma;
+	__le64 time_stamp;
+} __packed __aligned(4);
+
+struct leapraid_rep_desc_q_arr {
+	__le64 rep_desc_base_addr;
+	__le64 r1;
+} __packed __aligned(4);
+
+struct leapraid_adapter_init_rep {
+	u8 who_init;
+	u8 r1;
+	u8 msg_len;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[6];
+	__le16 adapter_status;
+	u8 r4[4];
+};
+
+struct leapraid_adapter_log_req {
+	u8 action;
+	u8 type;
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[4];
+	union {
+		u8		b[12];
+		__le16	s[6];
+		__le32	w[3];
+	} mbox;
+	struct leapraid_sge_simple64 sge;
+} __packed __aligned(4);
+
+struct leapraid_adapter_log_rep {
+	u8 action;
+	u8 type;
+	u8 msg_len;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[6];
+	__le16 adapter_status;
+};
+
+struct leapraid_adapter_features_req {
+	u8 r1[2];
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[4];
+};
+
+struct leapraid_adapter_features_rep {
+	u16 msg_ver;
+	u8 msg_len;
+	u8 func;
+	u16 header_ver;
+	u8 r1;
+	u8 msg_flag;
+	u8 r2[6];
+	u16 adapter_status;
+	u8 r3[4];
+	u8 sata_max_qdepth;
+	u8 who_init;
+	u8 r4;
+	u8 max_msix_vectors;
+	__le16 req_slot;
+	u8 r5[2];
+	__le32 adapter_caps;
+	__le32 fw_version;
+	__le16 sas_wide_max_qdepth;
+	__le16 sas_narrow_max_qdepth;
+	u8 r6[10];
+	__le16 hp_slot;
+	u8 r7[3];
+	u8 max_volumes;
+	__le16 max_dev_hdl;
+	u8 r8[2];
+	__le16 min_dev_hdl;
+	u8 r9[6];
+};
+
+struct leapraid_scan_dev_req {
+	u8 r1[2];
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[4];
+};
+
+struct leapraid_scan_dev_rep {
+	u8 r1[2];
+	u8 msg_len;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[6];
+	__le16 adapter_status;
+	u8 r4[4];
+};
+
+struct leapraid_evt_notify_req {
+	u8 r1[2];
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[12];
+	__le32 evt_masks[4];
+	u8 r4[8];
+};
+
+struct leapraid_evt_notify_rep {
+	__le16 evt_data_len;
+	u8 msg_len;
+	u8 func;
+	u8 r1[2];
+	u8 r2;
+	u8 msg_flag;
+	u8 r3[6];
+	__le16 adapter_status;
+	u8 r4[4];
+	__le16 evt;
+	u8 r5[6];
+	__le32 evt_data[];
+};
+
+struct leapraid_evt_data_sas_dev_status_change {
+	__le16 task_tag;
+	u8 reason_code;
+	u8 physical_port;
+	u8 r1[2];
+	__le16 dev_hdl;
+	u8 r2[4];
+	__le64 sas_address;
+	u8 lun[8];
+} __packed __aligned(4);
+struct leapraid_evt_data_ir_change {
+	u8 r1;
+	u8 reason_code;
+	u8 r2[2];
+	__le16 vol_dev_hdl;
+	__le16 phys_disk_dev_hdl;
+};
+
+struct leapraid_evt_data_sas_disc {
+	u8 r1;
+	u8 reason_code;
+	u8 physical_port;
+	u8 r2[5];
+};
+
+
+struct leapraid_evt_sas_topo_phy_entry {
+	__le16 attached_dev_hdl;
+	u8 link_rate;
+	u8 phy_status;
+};
+
+struct leapraid_evt_data_sas_topo_change_list {
+	__le16 encl_hdl;
+	__le16 exp_dev_hdl;
+	u8 num_phys;
+	u8 r2[3];
+	u8 entry_num;
+	u8 start_phy_num;
+	u8 exp_status;
+	u8 physical_port;
+	struct leapraid_evt_sas_topo_phy_entry phy[];
+};
+
+struct leapraid_evt_data_sas_enc_dev_status_change {
+	__le16 enc_hdl;
+	u8 reason_code;
+	u8 physical_port;
+	__le64 encl_logical_id;
+	__le16 num_slots;
+	__le16 start_slot;
+	__le32 phy_bits;
+};
+
+struct leapraid_io_unit_ctrl_req {
+	u8 op;
+	u8 r1;
+	u8 chain_offset;
+	u8 func;
+	u16 dev_hdl;
+	u8 adapter_para;
+	u8 msg_flag;
+	u8 r2[6];
+	u8 phy_num;
+	u8 r3[17];
+	__le32 adapter_para_value;
+	__le32 adapter_para_value2;
+	u8 r4[4];
+};
+
+struct leapraid_io_unit_ctrl_rep {
+	u8 op;
+	u8 r1[2];
+	u8 func;
+	__le16 dev_hdl;
+	u8 r2[14];
+};
+
+struct leapraid_raid_act_req {
+	u8 act;
+	u8 r1[2];
+	u8 func;
+	u8 r2[2];
+	u8 phys_disk_num;
+	u8 r3[13];
+	struct leapraid_sge_simple_union action_data_sge;
+};
+
+struct leapraid_raid_act_rep {
+	u8 act;
+	u8 r1[2];
+	u8 func;
+	__le16 vol_dev_hdl;
+	u8 r2[8];
+	__le16 adapter_status;
+	u8 r3[76];
+};
+
+struct leapraid_smp_passthrough_req {
+	u8 passthrough_flg;
+	u8 physical_port;
+	u8 r1;
+	u8 func;
+	__le16 req_data_len;
+	u8 r2[10];
+	__le64 sas_address;
+	u8 r3[8];
+	union leapraid_simple_sge_union sgl;
+} __packed __aligned(4);
+
+struct leapraid_smp_passthrough_rep {
+	u8 passthrough_flg;
+	u8 physical_port;
+	u8 r1;
+	u8 func;
+	__le16 resp_data_len;
+	u8 r2[8];
+	__le16 adapter_status;
+	u8 r3[12];
+};
+
+struct leapraid_sas_io_unit_ctrl_req {
+	u8 op;
+	u8 r1[2];
+	u8 func;
+	__le16 dev_hdl;
+	u8 r2[38];
+};
+
+struct leapraid_sas_io_unit_ctrl_rep {
+	u8 op;
+	u8 r1[2];
+	u8 func;
+	__le16 dev_hdl;
+	u8 r2[8];
+	__le16 adapter_status;
+	u8 r3[4];
+};
+
+#endif /* LEAPRAID_H */
diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
new file mode 100644
index 000000000000..329244b93eef
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -0,0 +1,713 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+ * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
+ * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
+ * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
+ * PURPOSE. Each Recipient is solely responsible for determining
+ * the appropriateness of using and distributing the Program and
+ * assumes all risks associated with its exercise of rights under
+ * this Agreement, including but not limited to the risks and costs
+ * of program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
+ * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES
+ */
+
+#include <linux/compat.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+
+#include "leapraid_func.h"
+
+#define LEAPRAID_DEV_NAME	"leapioraid_ctl"
+
+#define LEAPRAID_IOCTL_DEFAULT_TIMEOUT (10)
+
+#define LEAPRAID_ADAPTER_INFO	(17)
+#define LEAPRAID_COMMAND		(20)
+#define LEAPRAID_EVENTQUERY		(21)
+#define LEAPRAID_EVENTREPORT	(23)
+#define LEAPRAID_HARDRESET		(24)
+
+/**
+ * struct leapraid_ioctl_header - IOCTL command header
+ * @adapter_number: Adapter identifier
+ * @port_number: Port identifier
+ * @max_data_size: Maximum data size for transfer
+ */
+struct leapraid_ioctl_header {
+	uint32_t adapter_number;
+	uint32_t port_number;
+	uint32_t max_data_size;
+};
+
+struct leapraid_ioctl_diag_reset {
+	struct leapraid_ioctl_header hdr;
+};
+
+struct leapraid_ioctl_pci_info {
+	union {
+		struct {
+			uint32_t dev:5;
+			uint32_t func:3;
+			uint32_t bus:24;
+		} bits;
+		uint32_t word;
+	} u;
+	uint32_t seg_id;
+};
+
+/**
+ * struct leapraid_ioctl_adapter_info - Adapter information for IOCTL
+ * @hdr: IOCTL header
+ * @adapter_type: Adapter type identifier
+ * @port_number: Port number
+ * @pci_id: PCI device ID
+ * @revision: Revision number
+ * @sub_dev: Subsystem device ID
+ * @sub_vendor: Subsystem vendor ID
+ * @r0: Reserved
+ * @fw_ver: Firmware version
+ * @bios_ver: BIOS version
+ * @driver_ver: Driver version
+ * @r1: Reserved
+ * @scsi_id: SCSI ID
+ * @r2: Reserved
+ * @pci_info: PCI information structure
+ */
+struct leapraid_ioctl_adapter_info {
+	struct leapraid_ioctl_header hdr;
+	uint32_t adapter_type;
+	uint32_t port_number;
+	uint32_t pci_id;
+	uint32_t revision;
+	uint32_t sub_dev;
+	uint32_t sub_vendor;
+	uint32_t r0;
+	uint32_t fw_ver;
+	uint32_t bios_ver;
+	uint8_t driver_ver[32];
+	uint8_t r1;
+	uint8_t scsi_id;
+	uint16_t r2;
+	struct leapraid_ioctl_pci_info pci_info;
+};
+
+/**
+ * struct leapraid_ioctl_command - IOCTL command structure
+ * @hdr: IOCTL header
+ * @timeout: Command timeout
+ * @rep_msg_buf_ptr: User pointer to reply message buffer
+ * @c2h_buf_ptr: User pointer to card-to-host data buffer
+ * @h2c_buf_ptr: User pointer to host-to-card data buffer
+ * @sense_data_ptr: User pointer to sense data buffer
+ * @max_rep_bytes: Maximum reply bytes
+ * @c2h_size: Card-to-host data size
+ * @h2c_size: Host-to-card data size
+ * @max_sense_bytes: Maximum sense data bytes
+ * @data_sge_offset: Data SGE offset
+ * @mf: Message frame data (flexible array)
+ */
+struct leapraid_ioctl_command {
+	struct leapraid_ioctl_header hdr;
+	uint32_t timeout;
+	void __user *rep_msg_buf_ptr;
+	void __user *c2h_buf_ptr;
+	void __user *h2c_buf_ptr;
+	void __user *sense_data_ptr;
+	uint32_t max_rep_bytes;
+	uint32_t c2h_size;
+	uint32_t h2c_size;
+	uint32_t max_sense_bytes;
+	uint32_t data_sge_offset;
+	uint8_t mf[];
+};
+
+struct leapraid_ioctl_locate {
+	struct leapraid_ioctl_header hdr;
+	uint32_t id;
+	uint32_t bus;
+	uint16_t hdl;
+	uint16_t r0;
+};
+
+
+static struct leapraid_adapter *
+leapraid_ctl_lookup_adapter(int adapter_number)
+{
+	struct leapraid_adapter *adapter;
+
+	spin_lock(&leapraid_adapter_lock);
+	list_for_each_entry(adapter, &leapraid_adapter_list, list) {
+		if (adapter->adapter_attr.id == adapter_number) {
+			spin_unlock(&leapraid_adapter_lock);
+			return adapter;
+		}
+	}
+	spin_unlock(&leapraid_adapter_lock);
+
+	return NULL;
+}
+
+static void
+leapraid_cli_scsiio_cmd(struct leapraid_adapter *adapter,
+	 struct leapraid_req *ctl_sp_mpi_req, u16 taskid,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 u16 dev_hdl, void *psge)
+{
+	struct leapraid_mpi_scsiio_req *scsiio_request
+		 = (struct leapraid_mpi_scsiio_req *) ctl_sp_mpi_req;
+
+	scsiio_request->sense_buffer_len = SCSI_SENSE_BUFFERSIZE;
+	scsiio_request->sense_buffer_low_add =
+		 leapraid_get_sense_buffer_dma(adapter, taskid);
+	memset((void *)(&adapter->driver_cmds.ctl_cmd.sense),
+		 0, SCSI_SENSE_BUFFERSIZE);
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size);
+	if (scsiio_request->func == LEAPRAID_FUNC_SCSIIO_REQ)
+		leapraid_fire_scsi_io(adapter, taskid, dev_hdl);
+	else
+		leapraid_fire_task(adapter, taskid);
+}
+
+static void
+leapraid_ctl_smp_passthrough_cmd(struct leapraid_adapter *adapter,
+	 struct leapraid_req *ctl_sp_mpi_req, u16 taskid,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, void *h2c)
+{
+	struct leapraid_smp_passthrough_req *smp_pt_req =
+		 (struct leapraid_smp_passthrough_req *) ctl_sp_mpi_req;
+	u8 *data;
+
+	if (!adapter->adapter_attr.enable_mp)
+		smp_pt_req->physical_port = LEAPRAID_DISABLE_MP_PORT_ID;
+	if (smp_pt_req->passthrough_flg & 0x80)
+		data = (u8 *) &smp_pt_req->sgl;
+	else
+		data = h2c;
+
+	if (data[1] == 0x91 && (data[10] == 1 || data[10] == 2))
+		adapter->reset_desc.adapter_link_resetting = true;
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size);
+	leapraid_fire_task(adapter, taskid);
+}
+
+static void
+leapraid_ctl_fire_ieee_cmd(struct leapraid_adapter *adapter,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, u16 taskid)
+{
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size,
+		 c2h_dma_addr, c2h_size);
+	leapraid_fire_task(adapter, taskid);
+}
+
+static void
+leapraid_ctl_sata_passthrough_cmd(struct leapraid_adapter *adapter,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, u16 taskid)
+{
+	leapraid_ctl_fire_ieee_cmd(adapter, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+}
+
+static void
+leapraid_ctl_load_fw_cmd(struct leapraid_adapter *adapter,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, u16 taskid)
+{
+	leapraid_ctl_fire_ieee_cmd(adapter, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+}
+
+static void
+leapraid_ctl_fire_mpi_cmd(struct leapraid_adapter *adapter,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, u16 taskid)
+{
+	leapraid_build_mpi_sg(adapter, psge, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size);
+	leapraid_fire_task(adapter, taskid);
+}
+
+static void
+leapraid_ctl_sas_io_unit_ctrl_cmd(struct leapraid_adapter *adapter,
+	 struct leapraid_req *ctl_sp_mpi_req,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size,
+	 void *psge, u16 taskid)
+{
+	struct leapraid_sas_io_unit_ctrl_req *sas_io_unit_ctrl_req
+		 = (struct leapraid_sas_io_unit_ctrl_req *) ctl_sp_mpi_req;
+
+	if (sas_io_unit_ctrl_req->op == LEAPRAID_SAS_OP_PHY_HARD_RESET
+		 || sas_io_unit_ctrl_req->op == LEAPRAID_SAS_OP_PHY_LINK_RESET)
+		adapter->reset_desc.adapter_link_resetting = true;
+	leapraid_ctl_fire_mpi_cmd(adapter, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+}
+
+static long
+leapraid_ctl_do_command(struct leapraid_adapter *adapter,
+	 struct leapraid_ioctl_command *karg, void __user *mf)
+{
+	struct leapraid_req *leap_mpi_req = NULL;
+	struct leapraid_req *ctl_sp_mpi_req = NULL;
+	u16 taskid;
+	void *h2c = NULL;
+	size_t h2c_size = 0;
+	dma_addr_t h2c_dma_addr = 0;
+	void *c2h = NULL;
+	size_t c2h_size = 0;
+	dma_addr_t c2h_dma_addr = 0;
+	void *psge;
+	unsigned long timeout;
+	u16 dev_hdl = LEAPRAID_INVALID_DEV_HANDLE;
+	bool issue_reset = false;
+	u32 sz;
+	long rc = 0;
+
+	rc = leapraid_check_adapter_is_op(adapter);
+	if (rc)
+		goto out;
+
+	leap_mpi_req = kzalloc(LEAPRAID_REQUEST_SIZE, GFP_KERNEL);
+	if (!leap_mpi_req) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (karg->data_sge_offset * 4 > LEAPRAID_REQUEST_SIZE
+		 || karg->data_sge_offset > ((~0U) / 4)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (copy_from_user(leap_mpi_req, mf,
+		 karg->data_sge_offset * 4)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	taskid = adapter->driver_cmds.ctl_cmd.taskid;
+
+	adapter->driver_cmds.ctl_cmd.status = LEAPRAID_CMD_PENDING;
+	memset((void *)(&adapter->driver_cmds.ctl_cmd.reply),
+		 0, LEAPRAID_REPLY_SIEZ);
+	ctl_sp_mpi_req = leapraid_get_task_desc(adapter, taskid);
+	memset(ctl_sp_mpi_req, 0, LEAPRAID_REQUEST_SIZE);
+	memcpy(ctl_sp_mpi_req, leap_mpi_req, karg->data_sge_offset * 4);
+
+	if (ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSIIO_REQ
+		 || ctl_sp_mpi_req->func ==
+			 LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH
+		 || ctl_sp_mpi_req->func == LEAPRAID_FUNC_SATA_PASSTHROUGH) {
+		dev_hdl = le16_to_cpu(ctl_sp_mpi_req->func_dep1);
+		if (!dev_hdl || (dev_hdl >
+			 adapter->adapter_attr.features.max_dev_handle)) {
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (WARN_ON(ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSI_TMF))
+		return -EINVAL;
+
+	h2c_size = karg->h2c_size;
+	c2h_size = karg->c2h_size;
+	if (h2c_size) {
+		h2c = dma_alloc_coherent(&adapter->pdev->dev, h2c_size,
+			 &h2c_dma_addr, GFP_ATOMIC);
+		if (!h2c) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		if (copy_from_user(h2c, karg->h2c_buf_ptr, h2c_size)) {
+			rc = -EFAULT;
+			goto out;
+		}
+	}
+	if (c2h_size) {
+		c2h = dma_alloc_coherent(&adapter->pdev->dev,
+			 c2h_size, &c2h_dma_addr, GFP_ATOMIC);
+		if (!c2h) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	psge = (void *)ctl_sp_mpi_req + (karg->data_sge_offset * 4);
+	init_completion(&adapter->driver_cmds.ctl_cmd.done);
+
+	switch (ctl_sp_mpi_req->func) {
+	case LEAPRAID_FUNC_SCSIIO_REQ:
+	case LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH:
+		if (test_bit(dev_hdl,
+			 (unsigned long *)adapter->dev_topo.dev_removing)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		leapraid_cli_scsiio_cmd(adapter, ctl_sp_mpi_req, taskid,
+			 h2c_dma_addr, h2c_size, c2h_dma_addr, c2h_size,
+			 dev_hdl, psge);
+		break;
+	case LEAPRAID_FUNC_SMP_PASSTHROUGH:
+		if (!h2c) {
+			rc = -EINVAL;
+			goto out;
+		}
+		leapraid_ctl_smp_passthrough_cmd(adapter,
+			 ctl_sp_mpi_req, taskid,
+			 h2c_dma_addr, h2c_size,
+			 c2h_dma_addr, c2h_size, psge, h2c);
+		break;
+	case LEAPRAID_FUNC_SATA_PASSTHROUGH:
+		if (test_bit(dev_hdl,
+			 (unsigned long *)adapter->dev_topo.dev_removing)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		leapraid_ctl_sata_passthrough_cmd(adapter, h2c_dma_addr,
+			 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+		break;
+	case LEAPRAID_FUNC_FW_DOWNLOAD:
+	case LEAPRAID_FUNC_FW_UPLOAD:
+		leapraid_ctl_load_fw_cmd(adapter, h2c_dma_addr,
+			 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+		break;
+	case LEAPRAID_FUNC_SAS_IO_UNIT_CTRL:
+		leapraid_ctl_sas_io_unit_ctrl_cmd(adapter, ctl_sp_mpi_req,
+			 h2c_dma_addr, h2c_size, c2h_dma_addr, c2h_size,
+			 psge, taskid);
+		break;
+	default:
+		leapraid_ctl_fire_mpi_cmd(adapter, h2c_dma_addr,
+			 h2c_size, c2h_dma_addr, c2h_size, psge, taskid);
+		break;
+	}
+
+	timeout = karg->timeout;
+	if (timeout < LEAPRAID_IOCTL_DEFAULT_TIMEOUT)
+		timeout = LEAPRAID_IOCTL_DEFAULT_TIMEOUT;
+	wait_for_completion_timeout(&adapter->driver_cmds.ctl_cmd.done,
+		 timeout * HZ);
+
+	if ((leap_mpi_req->func == LEAPRAID_FUNC_SMP_PASSTHROUGH
+		 || leap_mpi_req->func == LEAPRAID_FUNC_SAS_IO_UNIT_CTRL)
+		 && adapter->reset_desc.adapter_link_resetting) {
+		adapter->reset_desc.adapter_link_resetting = false;
+	}
+	if (!(adapter->driver_cmds.ctl_cmd.status & LEAPRAID_CMD_DONE)) {
+		issue_reset =
+			 leapraid_check_reset(
+				adapter->driver_cmds.ctl_cmd.status);
+		goto reset;
+	}
+
+	if (c2h_size) {
+		if (copy_to_user(karg->c2h_buf_ptr, c2h, c2h_size)) {
+			rc = -ENODATA;
+			goto out;
+		}
+	}
+	if (karg->max_rep_bytes) {
+		sz = min_t(u32, karg->max_rep_bytes, LEAPRAID_REPLY_SIEZ);
+		if (copy_to_user(karg->rep_msg_buf_ptr,
+			 (void *)(&adapter->driver_cmds.ctl_cmd.reply), sz)) {
+			rc = -ENODATA;
+			goto out;
+		}
+	}
+
+	if (karg->max_sense_bytes
+		 && (leap_mpi_req->func == LEAPRAID_FUNC_SCSIIO_REQ
+		 || leap_mpi_req->func ==
+			 LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH)) {
+		if (karg->sense_data_ptr == NULL)
+			goto out;
+
+		sz = min_t(u32, karg->max_sense_bytes, SCSI_SENSE_BUFFERSIZE);
+		if (copy_to_user(karg->sense_data_ptr,
+			 (void *)(&adapter->driver_cmds.ctl_cmd.sense), sz)) {
+			rc = -ENODATA;
+			goto out;
+		}
+	}
+reset:
+	if (issue_reset) {
+		rc = -ENODATA;
+		if ((leap_mpi_req->func == LEAPRAID_FUNC_SCSIIO_REQ
+			 || leap_mpi_req->func ==
+				 LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH
+			 || leap_mpi_req->func ==
+				 LEAPRAID_FUNC_SATA_PASSTHROUGH)) {
+			dev_err(&adapter->pdev->dev,
+				 "fire tgt reset: hdl=0x%04x\n",
+				 le16_to_cpu(leap_mpi_req->func_dep1));
+			leapraid_issue_locked_tm(adapter,
+				 le16_to_cpu(leap_mpi_req->func_dep1), 0, 0, 0,
+				 LEAPRAID_TM_TASKTYPE_TARGET_RESET, taskid,
+				 LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+		} else
+			leapraid_hard_reset_handler(adapter,
+				 FULL_RESET);
+	}
+out:
+	if (c2h)
+		dma_free_coherent(&adapter->pdev->dev,
+			 c2h_size, c2h, c2h_dma_addr);
+	if (h2c)
+		dma_free_coherent(&adapter->pdev->dev,
+			 h2c_size, h2c, h2c_dma_addr);
+	kfree(leap_mpi_req);
+	adapter->driver_cmds.ctl_cmd.status = LEAPRAID_CMD_NOT_USED;
+	return rc;
+}
+
+static long
+leapraid_ctl_get_adapter_info(struct leapraid_adapter *adapter,
+	 void __user *arg)
+{
+	struct leapraid_ioctl_adapter_info *karg;
+	u8 revision;
+
+	karg = kzalloc(sizeof(struct leapraid_ioctl_adapter_info), GFP_KERNEL);
+	if (!karg)
+		return -ENOMEM;
+
+	pci_read_config_byte(adapter->pdev, PCI_CLASS_REVISION, &revision);
+	karg->revision = revision;
+	karg->pci_id = adapter->pdev->device;
+	karg->sub_dev = adapter->pdev->subsystem_device;
+	karg->sub_vendor = adapter->pdev->subsystem_vendor;
+	karg->pci_info.u.bits.bus = adapter->pdev->bus->number;
+	karg->pci_info.u.bits.dev = PCI_SLOT(adapter->pdev->devfn);
+	karg->pci_info.u.bits.func = PCI_FUNC(adapter->pdev->devfn);
+	karg->pci_info.seg_id = pci_domain_nr(adapter->pdev->bus);
+	karg->fw_ver = adapter->adapter_attr.features.fw_version;
+	(void)strscpy(karg->driver_ver, LEAPRAID_DRIVER_NAME,
+		 sizeof(karg->driver_ver));
+	strcat(karg->driver_ver, "-");
+	strcat(karg->driver_ver, LEAPRAID_DRIVER_VERSION);
+	karg->adapter_type = 0x07;
+	karg->bios_ver = adapter->adapter_attr.bios_version;
+	if (copy_to_user(arg, karg,
+		 sizeof(struct leapraid_ioctl_adapter_info))) {
+		kfree(karg);
+		return -EFAULT;
+	}
+
+	kfree(karg);
+	return 0;
+}
+
+
+static long
+leapraid_ctl_do_reset(struct leapraid_adapter *adapter,
+	 void __user *arg)
+{
+	struct leapraid_ioctl_diag_reset karg;
+	int rc;
+
+	if (copy_from_user(&karg, arg, sizeof(karg)))
+		return -EFAULT;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering
+		 || adapter->scan_dev_desc.driver_loading
+		 || adapter->access_ctrl.host_removing)
+		return -EAGAIN;
+
+	rc = leapraid_hard_reset_handler(adapter,
+		 FULL_RESET);
+	dev_info(&adapter->pdev->dev, "host reset %s!\n",
+		 ((rc) ? "failed" : "success"));
+
+	return 0;
+}
+
+
+static long
+leapraid_ctl_ioctl_main(struct file *file, unsigned int cmd,
+	 void __user *arg, u8 compat)
+{
+	struct leapraid_ioctl_header ioctl_header;
+	struct leapraid_adapter *adapter;
+	long rc = -ENOIOCTLCMD;
+
+	if (copy_from_user(&ioctl_header, (char __user *)arg,
+		 sizeof(struct leapraid_ioctl_header)))
+		return -EFAULT;
+
+	adapter = leapraid_ctl_lookup_adapter(
+		ioctl_header.adapter_number);
+	if (!adapter)
+		return -EFAULT;
+
+	mutex_lock(&adapter->access_ctrl.pci_access_lock);
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering
+		 || adapter->scan_dev_desc.driver_loading
+		 || adapter->access_ctrl.host_removing) {
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&adapter->driver_cmds.ctl_cmd.mutex)) {
+			rc = -EAGAIN;
+			goto out;
+		}
+	} else if (mutex_lock_interruptible(
+		&adapter->driver_cmds.ctl_cmd.mutex)) {
+		rc = -ERESTARTSYS;
+		goto out;
+	}
+
+	switch (_IOC_NR(cmd)) {
+	case LEAPRAID_ADAPTER_INFO:
+		if (_IOC_SIZE(cmd) == sizeof(
+			struct leapraid_ioctl_adapter_info))
+			rc = leapraid_ctl_get_adapter_info(adapter, arg);
+		break;
+	case LEAPRAID_COMMAND:
+	{
+		struct leapraid_ioctl_command __user *uarg;
+		struct leapraid_ioctl_command karg;
+
+		if (copy_from_user(&karg, arg, sizeof(karg))) {
+			rc = -EFAULT;
+			break;
+		}
+
+		if (karg.hdr.adapter_number != ioctl_header.adapter_number) {
+			rc = -EINVAL;
+			break;
+		}
+
+		if (_IOC_SIZE(cmd) == sizeof(struct leapraid_ioctl_command)) {
+			uarg = arg;
+			rc = leapraid_ctl_do_command(
+				adapter, &karg, &uarg->mf);
+		}
+		break;
+	}
+	case LEAPRAID_EVENTQUERY:
+	case LEAPRAID_EVENTREPORT:
+		rc = 0;
+		break;
+	case LEAPRAID_HARDRESET:
+		if (_IOC_SIZE(cmd) == sizeof(struct leapraid_ioctl_diag_reset))
+			rc = leapraid_ctl_do_reset(adapter, arg);
+		break;
+	default:
+		pr_err("unknown ioctl opcode=0x%08x\n", cmd);
+		break;
+	}
+	mutex_unlock(&adapter->driver_cmds.ctl_cmd.mutex);
+
+out:
+	mutex_unlock(&adapter->access_ctrl.pci_access_lock);
+	return rc;
+}
+
+static long
+leapraid_ctl_ioctl(struct file *file,
+	 unsigned int cmd, unsigned long arg)
+{
+	return leapraid_ctl_ioctl_main(file, cmd,
+		 (void __user *)arg, 0);
+}
+
+static int
+leapraid_fw_mmap(struct file *filp,
+	 struct vm_area_struct *vma)
+{
+	struct leapraid_adapter *adapter;
+	unsigned long length;
+	unsigned long pfn;
+
+	length = vma->vm_end - vma->vm_start;
+
+	adapter = list_first_entry(&leapraid_adapter_list,
+		 struct leapraid_adapter, list);
+
+	if (length > (LEAPRAID_SYS_LOG_BUF_SIZE +
+		 LEAPRAID_SYS_LOG_BUF_RESERVE)) {
+		dev_err(&adapter->pdev->dev,
+			 "requested mapping size is too large!\n");
+		return -EINVAL;
+	}
+
+	if (adapter->fw_log_desc.fw_log_buffer == NULL) {
+		dev_err(&adapter->pdev->dev, "no log buffer!\n");
+		return -EINVAL;
+	}
+
+	pfn = virt_to_phys(adapter->fw_log_desc.fw_log_buffer)
+		 >> PAGE_SHIFT;
+
+	if (remap_pfn_range(vma, vma->vm_start, pfn, length,
+		 vma->vm_page_prot)) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to map memory to user space!\n");
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static const struct file_operations leapraid_ctl_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = leapraid_ctl_ioctl,
+	.mmap = leapraid_fw_mmap,
+};
+
+static struct miscdevice leapraid_ctl_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = LEAPRAID_DEV_NAME,
+	.fops = &leapraid_ctl_fops,
+};
+
+void leapraid_ctl_init(void)
+{
+	if (misc_register(&leapraid_ctl_dev) < 0)
+		pr_err("%s can't register misc device\n",
+			 LEAPRAID_DRIVER_NAME);
+}
+
+void leapraid_ctl_exit(void)
+{
+	misc_deregister(&leapraid_ctl_dev);
+}
diff --git a/drivers/scsi/leapraid/leapraid_func.c b/drivers/scsi/leapraid/leapraid_func.c
new file mode 100644
index 000000000000..560e123d73e2
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_func.c
@@ -0,0 +1,8355 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+ * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
+ * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
+ * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
+ * PURPOSE. Each Recipient is solely responsible for determining
+ * the appropriateness of using and distributing the Program and
+ * assumes all risks associated with its exercise of rights under
+ * this Agreement, including but not limited to the risks and costs
+ * of program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
+ * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES
+ */
+
+#include <linux/module.h>
+
+#include "leapraid_func.h"
+
+static int msix_disable;
+module_param(msix_disable, int, 0444);
+MODULE_PARM_DESC(msix_disable,
+	 "disable msix routed interrupts (default=0)");
+
+static int smart_poll;
+module_param(smart_poll, int, 0444);
+MODULE_PARM_DESC(smart_poll,
+	 "check SATA drive health via SMART polling: (default=0)");
+
+static int interrupt_mode;
+module_param(interrupt_mode, int, 0444);
+MODULE_PARM_DESC(interrupt_mode,
+	 "intr mode: 0 for MSI-X, 1 for MSI, 2 for legacy. (default=0)");
+
+static int poll_queues;
+module_param(poll_queues, int, 0444);
+MODULE_PARM_DESC(poll_queues,
+	 "specifies the number of queues for io_uring poll mode.");
+
+static int max_msix_vectors = -1;
+module_param(max_msix_vectors, int, 0444);
+MODULE_PARM_DESC(max_msix_vectors, " max msix vectors");
+
+
+static void
+leapraid_remove_device(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev);
+static void
+leapraid_set_led(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev, bool on);
+static void
+leapraid_ublk_io_dev(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+static int
+leapraid_make_adapter_available(struct leapraid_adapter *adapter);
+static int
+leapraid_fw_log_init(struct leapraid_adapter *adapter);
+static int
+leapraid_make_adapter_ready(struct leapraid_adapter *adapter,
+	 enum reset_type type);
+
+bool
+leapraid_pci_removed(struct leapraid_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	u32 vendor_id;
+
+	if (pci_bus_read_config_dword(pdev->bus,
+		 pdev->devfn, PCI_VENDOR_ID, &vendor_id))
+		return true;
+
+	return ((vendor_id & 0xffff) != LEAPRAID_VENDOR_ID);
+}
+
+static bool
+leapraid_pci_active(struct leapraid_adapter *adapter)
+{
+	return !(adapter->access_ctrl.pcie_recovering
+			 || leapraid_pci_removed(adapter));
+}
+
+void *
+leapraid_get_reply_vaddr(struct leapraid_adapter *adapter,
+	 u32 rep_paddr)
+{
+	if (!rep_paddr)
+		return NULL;
+
+	return adapter->mem_desc.rep_msg
+		 + (rep_paddr - (u32) adapter->mem_desc.rep_msg_dma);
+}
+
+void *
+leapraid_get_task_desc(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	return (void *)(adapter->mem_desc.task_desc
+		 + (taskid * LEAPRAID_REQUEST_SIZE));
+}
+
+void *
+leapraid_get_sense_buffer(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	return (void *)(adapter->mem_desc.sense_data
+		 + ((taskid - 1) * SCSI_SENSE_BUFFERSIZE));
+}
+
+__le32
+leapraid_get_sense_buffer_dma(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	return cpu_to_le32(adapter->mem_desc.sense_data_dma
+		 + ((taskid - 1) * SCSI_SENSE_BUFFERSIZE));
+}
+
+void
+leapraid_mask_int(struct leapraid_adapter *adapter)
+{
+	u32 reg;
+
+	adapter->mask_int = true;
+	reg = leapraid_readl(&adapter->iomem_base->host_int_mask);
+	reg |= 0x00000001 + 0x00000008 + 0x40000000;
+	writel(reg, &adapter->iomem_base->host_int_mask);
+	leapraid_readl(&adapter->iomem_base->host_int_mask);
+}
+
+void
+leapraid_unmask_int(struct leapraid_adapter *adapter)
+{
+	u32 reg;
+
+	reg = leapraid_readl(&adapter->iomem_base->host_int_mask);
+	reg &= ~0x00000008;
+	writel(reg, &adapter->iomem_base->host_int_mask);
+	adapter->mask_int = false;
+}
+
+static void
+leapraid_flush_io_and_panic(struct leapraid_adapter *adapter)
+{
+	adapter->access_ctrl.adapter_thermal_alert = true;
+	leapraid_smart_polling_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	leapraid_mq_polling_pause(adapter);
+	leapraid_clean_active_scsi_cmds(adapter);
+}
+
+static void
+leapraid_check_panic_needed(struct leapraid_adapter *adapter,
+	 u32 db, u32 adapter_state)
+{
+	bool fault_1 = adapter_state == LEAPRAID_DB_MASK;
+	bool fault_2 = (adapter_state == LEAPRAID_DB_FAULT)
+		 && ((db & LEAPRAID_DB_DATA_MASK) ==
+			 LEAPRAID_DB_OVER_TEMPERATURE);
+
+	if (!fault_1 && !fault_2)
+		return;
+
+	if (fault_1)
+		pr_err("%s, doorbell status 0xFFFF!\n",
+				 __func__);
+	else
+		pr_err("%s, adapter overheating detected!\n",
+				 __func__);
+
+	leapraid_flush_io_and_panic(adapter);
+	panic("%s overheating detected, panic now!!!\n", __func__);
+}
+
+u32
+leapraid_get_adapter_state(struct leapraid_adapter *adapter)
+{
+	u32 db;
+	u32 adapter_state;
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	adapter_state = db & LEAPRAID_DB_MASK;
+	leapraid_check_panic_needed(adapter, db, adapter_state);
+	return adapter_state;
+}
+
+static bool
+leapraid_wait_adapter_ready(struct leapraid_adapter *adapter)
+{
+	u32 cur_state;
+	u32 cnt = 15000;
+
+	do {
+		cur_state = leapraid_get_adapter_state(adapter);
+		if (cur_state == LEAPRAID_DB_READY)
+			return true;
+		if (cur_state == LEAPRAID_DB_FAULT)
+			break;
+		usleep_range(1000, 1100);
+	} while (--cnt);
+
+	return false;
+}
+
+static int
+leapraid_db_wait_int_host(struct leapraid_adapter *adapter)
+{
+	u32 cnt = 20000;
+
+	do {
+		if (leapraid_readl(&adapter->iomem_base->host_int_status)
+			 & LEAPRAID_ADAPTER2HOST_DB_STATUS)
+			return 0;
+		udelay(500);
+	} while (--cnt);
+
+	return -EFAULT;
+}
+
+static int
+leapraid_db_wait_ack_and_clear_int(struct leapraid_adapter *adapter)
+{
+	u32 adapter_state;
+	u32 int_status;
+	u32 cnt;
+
+	cnt = 15000;
+	do {
+		int_status = leapraid_readl(&adapter->iomem_base->host_int_status);
+		if (!(int_status & LEAPRAID_HOST2ADAPTER_DB_STATUS)) {
+			return 0;
+		} else if (int_status & LEAPRAID_ADAPTER2HOST_DB_STATUS) {
+			adapter_state = leapraid_get_adapter_state(adapter);
+			if (adapter_state == LEAPRAID_DB_FAULT)
+				return -EFAULT;
+		} else if (int_status == 0xFFFFFFFF)
+			goto out;
+
+		usleep_range(1000, 1100);
+	} while (--cnt);
+
+out:
+	return -EFAULT;
+}
+
+static int
+leapraid_handshake_func(struct leapraid_adapter *adapter,
+	 int req_bytes, u32 *req, int rep_bytes, u16 *rep)
+{
+	int failed, i;
+
+	if ((leapraid_readl(&adapter->iomem_base->db)
+		 & LEAPRAID_DB_USED))
+		return -EFAULT;
+
+	if (leapraid_readl(&adapter->iomem_base->host_int_status)
+		 & LEAPRAID_ADAPTER2HOST_DB_STATUS)
+		writel(0, &adapter->iomem_base->host_int_status);
+
+	writel(((LEAPRAID_FUNC_HANDSHAKE << LEAPRAID_DB_FUNC_SHIFT)
+		 | ((req_bytes / 4) << LEAPRAID_DB_ADD_DWORDS_SHIFT)),
+		 &adapter->iomem_base->db);
+
+	if (leapraid_db_wait_int_host(adapter))
+		return -EFAULT;
+
+	writel(0, &adapter->iomem_base->host_int_status);
+
+	if (leapraid_db_wait_ack_and_clear_int(adapter))
+		return -EFAULT;
+
+	for (i = 0, failed = 0; i < req_bytes / 4 && !failed; i++) {
+		writel((u32) (req[i]), &adapter->iomem_base->db);
+		if (leapraid_db_wait_ack_and_clear_int(adapter))
+			failed = 1;
+	}
+	if (failed)
+		return -EFAULT;
+
+	for (i = 0; i < rep_bytes / 2; i++) {
+		if (leapraid_db_wait_int_host(adapter))
+			return -EFAULT;
+		rep[i] = (u16) (leapraid_readl(&adapter->iomem_base->db)
+			 & LEAPRAID_DB_DATA_MASK);
+		writel(0, &adapter->iomem_base->host_int_status);
+	}
+
+	if (leapraid_db_wait_int_host(adapter))
+		return -EFAULT;
+
+	writel(0, &adapter->iomem_base->host_int_status);
+
+	return 0;
+}
+
+
+int
+leapraid_check_adapter_is_op(struct leapraid_adapter *adapter)
+{
+	int wait_count = 10;
+
+	do {
+		if (leapraid_pci_removed(adapter))
+			return -EFAULT;
+
+		if (leapraid_get_adapter_state(adapter)
+			 == LEAPRAID_DB_OPERATIONAL)
+			return 0;
+		ssleep(1);
+	} while (--wait_count);
+
+	return -EFAULT;
+}
+
+struct leapraid_io_req_tracker *
+leapraid_get_io_tracker_from_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	struct scsi_cmnd *scmd;
+
+	if (WARN_ON(!taskid))
+		return NULL;
+
+	if (WARN_ON(taskid > adapter->shost->can_queue))
+		return NULL;
+
+	scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+	if (scmd)
+		return leapraid_get_scmd_priv(scmd);
+
+	return NULL;
+}
+
+static u8
+leapraid_get_cb_idx(struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_driver_cmd *sp_cmd;
+	u8 cb_idx = 0xFF;
+
+	if (WARN_ON(!taskid))
+		return cb_idx;
+
+	list_for_each_entry(sp_cmd, &adapter->driver_cmds.special_cmd_list,
+			 list)
+		if (taskid == sp_cmd->taskid
+			 || taskid == sp_cmd->hp_taskid
+			 || taskid == sp_cmd->inter_taskid)
+			return sp_cmd->cb_idx;
+
+	WARN_ON(cb_idx == 0xFF);
+	return cb_idx;
+}
+
+
+struct scsi_cmnd *
+leapraid_get_scmd_from_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	struct leapraid_scsiio_req *leap_mpi_req;
+	struct leapraid_io_req_tracker *st;
+	struct scsi_cmnd *scmd;
+	u32 uniq_tag;
+
+	if (taskid <= 0 || taskid > adapter->shost->can_queue)
+		return NULL;
+
+	uniq_tag = adapter->mem_desc.taskid_to_uniq_tag[taskid - 1]
+		 << BLK_MQ_UNIQUE_TAG_BITS | (taskid - 1);
+	leap_mpi_req = leapraid_get_task_desc(adapter, taskid);
+	if (!leap_mpi_req->dev_hdl)
+		return NULL;
+
+	scmd = scsi_host_find_tag(adapter->shost, uniq_tag);
+	if (scmd) {
+		st = leapraid_get_scmd_priv(scmd);
+		if (st && st->taskid == taskid)
+			return scmd;
+	}
+
+	return NULL;
+}
+
+u16
+leapraid_alloc_scsiio_taskid(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd)
+{
+	struct leapraid_io_req_tracker *request;
+	u16 taskid;
+	u32 tag = scsi_cmd_to_rq(scmd)->tag;
+	u32 unique_tag;
+
+	unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	tag = blk_mq_unique_tag_to_tag(unique_tag);
+	adapter->mem_desc.taskid_to_uniq_tag[tag]
+		 = blk_mq_unique_tag_to_hwq(unique_tag);
+	request = leapraid_get_scmd_priv(scmd);
+	taskid = tag + 1;
+	request->taskid = taskid;
+	request->scmd = scmd;
+	return taskid;
+}
+
+static void
+leapraid_check_pending_io(struct leapraid_adapter *adapter)
+{
+	if (adapter->access_ctrl.shost_recovering
+			 && adapter->reset_desc.pending_io_cnt) {
+		if (adapter->reset_desc.pending_io_cnt == 1)
+			wake_up(&adapter->reset_desc.reset_wait_queue);
+		adapter->reset_desc.pending_io_cnt--;
+	}
+}
+
+static void
+leapraid_clear_io_tracker(struct leapraid_adapter *adapter,
+	 struct leapraid_io_req_tracker *io_tracker)
+{
+	if (!io_tracker)
+		return;
+
+	if (WARN_ON(io_tracker->taskid == 0))
+		return;
+
+	io_tracker->scmd = NULL;
+}
+
+static bool
+leapraid_is_fixed_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	return (taskid == adapter->driver_cmds.ctl_cmd.taskid
+		 || taskid == adapter->driver_cmds.driver_scsiio_cmd.taskid
+		 || taskid == adapter->driver_cmds.tm_cmd.hp_taskid
+		 || taskid == adapter->driver_cmds.ctl_cmd.hp_taskid
+		 || taskid == adapter->driver_cmds.scan_dev_cmd.inter_taskid
+		 || taskid ==
+			 adapter->driver_cmds.timestamp_sync_cmd.inter_taskid
+		 || taskid == adapter->driver_cmds.raid_action_cmd.inter_taskid
+		 || taskid == adapter->driver_cmds.transport_cmd.inter_taskid
+		 || taskid == adapter->driver_cmds.cfg_op_cmd.inter_taskid
+		 || taskid == adapter->driver_cmds.enc_cmd.inter_taskid
+		 || taskid ==
+			 adapter->driver_cmds.notify_event_cmd.inter_taskid);
+}
+
+void
+leapraid_free_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	struct leapraid_io_req_tracker *io_tracker;
+	void *task_desc;
+
+	if (leapraid_is_fixed_taskid(adapter, taskid))
+		return;
+
+	if (taskid <= adapter->shost->can_queue) {
+		io_tracker = leapraid_get_io_tracker_from_taskid(adapter,
+			 taskid);
+		if (!io_tracker) {
+			leapraid_check_pending_io(adapter);
+			return;
+		}
+
+		task_desc = leapraid_get_task_desc(adapter, taskid);
+		memset(task_desc, 0, LEAPRAID_REQUEST_SIZE);
+		leapraid_clear_io_tracker(adapter, io_tracker);
+		leapraid_check_pending_io(adapter);
+		adapter->mem_desc.taskid_to_uniq_tag[taskid - 1] = 0xFFFF;
+	}
+}
+
+static u8
+leapraid_get_msix_idx(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd)
+{
+	if (scmd && adapter->shost->nr_hw_queues > 1) {
+		u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+
+		return blk_mq_unique_tag_to_hwq(tag);
+	}
+	return adapter->notification_desc.msix_cpu_map[
+		raw_smp_processor_id()];
+}
+
+static u8
+leapraid_get_and_set_msix_idx_from_taskid(
+	struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_io_req_tracker *io_tracker = NULL;
+
+	if (taskid <= adapter->shost->can_queue)
+		io_tracker = leapraid_get_io_tracker_from_taskid(
+			adapter, taskid);
+
+	if (io_tracker == NULL)
+		return leapraid_get_msix_idx(adapter, NULL);
+
+	io_tracker->msix_io = leapraid_get_msix_idx(adapter,
+		 io_tracker->scmd);
+
+	return io_tracker->msix_io;
+}
+
+void
+leapraid_fire_scsi_io(struct leapraid_adapter *adapter,
+	 u16 taskid, u16 handle)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_SCSI_IO;
+	desc.msix_idx
+		 = leapraid_get_and_set_msix_idx_from_taskid(adapter,
+				 taskid);
+	desc.taskid = cpu_to_le16(taskid);
+	writel(cpu_to_le32(*((u32 *)&desc)),
+		 &adapter->iomem_base->atomic_req_desc_post);
+}
+
+
+void
+leapraid_fire_hpr_task(struct leapraid_adapter *adapter,
+	 u16 taskid, u16 msix_task)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_HPR;
+	desc.msix_idx = msix_task;
+	desc.taskid = cpu_to_le16(taskid);
+	writel(cpu_to_le32(*((u32 *)&desc)),
+		 &adapter->iomem_base->atomic_req_desc_post);
+}
+
+void
+leapraid_fire_task(struct leapraid_adapter *adapter,
+	 u16 taskid)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_DFLT_TYPE;
+	desc.msix_idx
+		 = leapraid_get_and_set_msix_idx_from_taskid(adapter,
+				 taskid);
+	desc.taskid = cpu_to_le16(taskid);
+	writel(cpu_to_le32(*((u32 *)&desc)),
+		 &adapter->iomem_base->atomic_req_desc_post);
+}
+
+void
+leapraid_clean_active_scsi_cmds(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_req_tracker *io_tracker;
+	struct scsi_cmnd *scmd;
+	u16 taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		io_tracker = leapraid_get_scmd_priv(scmd);
+		if (io_tracker && io_tracker->taskid == 0)
+			continue;
+
+		scsi_dma_unmap(scmd);
+		leapraid_clear_io_tracker(adapter, io_tracker);
+		if ((!leapraid_pci_active(adapter))
+			 || (adapter->reset_desc.adapter_reset_results != 0)
+			 || adapter->access_ctrl.adapter_thermal_alert
+			 || adapter->access_ctrl.host_removing)
+			scmd->result = DID_NO_CONNECT << 16;
+		else
+			scmd->result = DID_RESET << 16;
+		scsi_done(scmd);
+	}
+}
+
+static void
+leapraid_clean_active_driver_cmd(
+	struct leapraid_driver_cmd *driver_cmd)
+{
+	if (driver_cmd->status & LEAPRAID_CMD_PENDING) {
+		driver_cmd->status |= LEAPRAID_CMD_RESET;
+		complete(&driver_cmd->done);
+	}
+}
+
+static void
+leapraid_clean_active_driver_cmds(struct leapraid_adapter *adapter)
+{
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.timestamp_sync_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.raid_action_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.driver_scsiio_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.tm_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.transport_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.enc_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.notify_event_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.cfg_op_cmd);
+	leapraid_clean_active_driver_cmd(
+		&adapter->driver_cmds.ctl_cmd);
+
+	if (adapter->driver_cmds.scan_dev_cmd.status
+			 & LEAPRAID_CMD_PENDING) {
+		adapter->scan_dev_desc.scan_dev_failed = true;
+		adapter->driver_cmds.scan_dev_cmd.status
+			 |= LEAPRAID_CMD_RESET;
+		if (adapter->scan_dev_desc.driver_loading) {
+			adapter->scan_dev_desc.scan_start_failed =
+				 LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR;
+			adapter->scan_dev_desc.scan_start = false;
+		} else
+			complete(&adapter->driver_cmds.scan_dev_cmd.done);
+	}
+}
+
+static void
+leapraid_clean_active_cmds(struct leapraid_adapter *adapter)
+{
+	leapraid_clean_active_driver_cmds(adapter);
+	memset(adapter->dev_topo.pending_dev_add,
+		 0, adapter->dev_topo.pending_dev_add_sz);
+	memset(adapter->dev_topo.dev_removing,
+		 0, adapter->dev_topo.dev_removing_sz);
+	leapraid_clean_active_fw_evt(adapter);
+	leapraid_clean_active_scsi_cmds(adapter);
+}
+
+
+static void
+leapraid_tgt_not_responding(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct leapraid_sas_dev *sas_dev = NULL;
+	unsigned long flags = 0;
+	u32 adapter_state = 0;
+
+	if (adapter->access_ctrl.pcie_recovering)
+		return;
+
+	adapter_state = leapraid_get_adapter_state(adapter);
+	if (adapter_state != LEAPRAID_DB_OPERATIONAL)
+		return;
+
+	if (test_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls))
+		return;
+
+	clear_bit(hdl, (unsigned long *)adapter->dev_topo.pending_dev_add);
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev && sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = true;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (starget_priv)
+		starget_priv->hdl = LEAPRAID_INVALID_DEV_HANDLE;
+
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+static void
+leapraid_tgt_rst_send(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct leapraid_sas_dev *sas_dev = NULL;
+	struct leapraid_card_port *port = NULL;
+	u64 sas_address = 0;
+	unsigned long flags;
+	u32 adapter_state;
+
+	if (adapter->access_ctrl.pcie_recovering)
+		return;
+
+	adapter_state = leapraid_get_adapter_state(adapter);
+	if (adapter_state != LEAPRAID_DB_OPERATIONAL)
+		return;
+
+	if (test_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls))
+		return;
+
+	clear_bit(hdl, (unsigned long *)adapter->dev_topo.pending_dev_add);
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev && sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = true;
+		sas_address = sas_dev->sas_addr;
+		port = sas_dev->card_port;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (starget_priv) {
+		leapraid_ublk_io_dev(adapter, sas_address, port);
+		starget_priv->hdl = LEAPRAID_INVALID_DEV_HANDLE;
+	}
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+
+static inline void
+leapraid_single_mpi_sg_append(struct leapraid_adapter *adapter,
+	 void *sge, u32 flag_and_len, dma_addr_t dma_addr)
+{
+	if (adapter->adapter_attr.use_32_dma_mask) {
+		((struct leapraid_sge_simple32 *)sge)->flg_and_len
+			 = cpu_to_le32(flag_and_len
+				 | (LEAPRAID_SGE_FLG_32
+				 | LEAPRAID_SGE_FLG_SYSTEM_ADDR) <<
+					 LEAPRAID_SGE_FLG_SHIFT);
+		((struct leapraid_sge_simple32 *)sge)->addr =
+			 cpu_to_le32(dma_addr);
+	} else {
+		((struct leapraid_sge_simple64 *)sge)->flg_and_len
+			 = cpu_to_le32(flag_and_len
+				 | (LEAPRAID_SGE_FLG_64
+				 | LEAPRAID_SGE_FLG_SYSTEM_ADDR) <<
+					 LEAPRAID_SGE_FLG_SHIFT);
+		((struct leapraid_sge_simple64 *)sge)->addr =
+			 cpu_to_le64(dma_addr);
+	}
+}
+
+static inline void
+leapraid_single_ieee_sg_append(void *sge, u8 flag,
+	 u8 next_chain_offset, u32 len, dma_addr_t dma_addr)
+{
+	((struct leapraid_chain64_ieee_sg *)sge)->flg =
+		 flag;
+	((struct leapraid_chain64_ieee_sg *)sge)->next_chain_offset =
+		 next_chain_offset;
+	((struct leapraid_chain64_ieee_sg *)sge)->len =
+		 cpu_to_le32(len);
+	((struct leapraid_chain64_ieee_sg *)sge)->addr =
+		 cpu_to_le64(dma_addr);
+}
+
+static void
+leapraid_build_nodata_mpi_sg(struct leapraid_adapter *adapter,
+	 void *sge)
+{
+	leapraid_single_mpi_sg_append(adapter, sge,
+		 (u32) ((LEAPRAID_SGE_FLG_LAST_ONE
+		 | LEAPRAID_SGE_FLG_EOB
+		 | LEAPRAID_SGE_FLG_EOL
+		 | LEAPRAID_SGE_FLG_SIMPLE_ONE) << LEAPRAID_SGE_FLG_SHIFT),
+		 -1);
+}
+
+void
+leapraid_build_mpi_sg(struct leapraid_adapter *adapter, void *sge,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	if (h2c_size && !c2h_size)
+		leapraid_single_mpi_sg_append(adapter, sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_LAST_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_EOL
+				 | LEAPRAID_SGE_FLG_H2C) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | h2c_size, h2c_dma_addr);
+	else if (!h2c_size && c2h_size)
+		leapraid_single_mpi_sg_append(adapter, sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_LAST_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_EOL) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | c2h_size, c2h_dma_addr);
+	else if (h2c_size && c2h_size) {
+		leapraid_single_mpi_sg_append(adapter, sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_H2C) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | h2c_size, h2c_dma_addr);
+		if (adapter->adapter_attr.use_32_dma_mask)
+			sge += sizeof(struct leapraid_sge_simple32);
+		else
+			sge += sizeof(struct leapraid_sge_simple64);
+		leapraid_single_mpi_sg_append(adapter, sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_LAST_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_EOL) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | c2h_size, c2h_dma_addr);
+	} else
+		return leapraid_build_nodata_mpi_sg(adapter, sge);
+}
+
+void
+leapraid_build_ieee_nodata_sg(struct leapraid_adapter *adapter,
+	 void *sge)
+{
+	leapraid_single_ieee_sg_append(sge,
+		 (LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+			 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR
+			 | LEAPRAID_IEEE_SGE_FLG_EOL), 0, 0, -1);
+}
+
+int
+leapraid_build_scmd_ieee_sg(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd, u16 taskid)
+{
+	struct leapraid_scsiio_req *scsiio_req;
+	struct leapraid_io_req_tracker *io_tracker;
+	struct scatterlist *scmd_sg_cur;
+	int sg_entries_left;
+	void *sg_entry_cur;
+	void *host_chain;
+	dma_addr_t host_chain_dma;
+	u8 host_chain_cursor;
+	u32 sg_entries_in_cur_seg;
+	u32 chain_offset_in_cur_seg;
+	u32 chain_len_in_cur_seg;
+
+	io_tracker = leapraid_get_scmd_priv(scmd);
+	scsiio_req = leapraid_get_task_desc(adapter, taskid);
+	scmd_sg_cur = scsi_sglist(scmd);
+	sg_entries_left = scsi_dma_map(scmd);
+	if (sg_entries_left < 0)
+		return -ENOMEM;
+	sg_entry_cur = &scsiio_req->sgl;
+	if (sg_entries_left <= 2)
+		goto fill_last_seg;
+
+	scsiio_req->chain_offset = 7;
+	leapraid_single_ieee_sg_append(sg_entry_cur,
+		 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+			 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+		 0, sg_dma_len(scmd_sg_cur),
+		 sg_dma_address(scmd_sg_cur));
+	scmd_sg_cur = sg_next(scmd_sg_cur);
+	sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+	sg_entries_left--;
+
+	host_chain_cursor = 0;
+	host_chain = io_tracker->chain +
+		 host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+	host_chain_dma = io_tracker->chain_dma +
+		 host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+	host_chain_cursor += 1;
+	for (;;) {
+		sg_entries_in_cur_seg =
+			 (sg_entries_left <= LEAPRAID_MAX_SGES_IN_CHAIN)
+				 ? sg_entries_left :
+				 LEAPRAID_MAX_SGES_IN_CHAIN;
+		chain_offset_in_cur_seg =
+			 (sg_entries_left == sg_entries_in_cur_seg)
+				 ? 0 : sg_entries_in_cur_seg;
+		chain_len_in_cur_seg = sg_entries_in_cur_seg *
+			 LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+		if (chain_offset_in_cur_seg)
+			chain_len_in_cur_seg += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+
+		leapraid_single_ieee_sg_append(sg_entry_cur,
+			 LEAPRAID_IEEE_SGE_FLG_CHAIN_ONE
+				 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+			 chain_offset_in_cur_seg, chain_len_in_cur_seg,
+			 host_chain_dma);
+		sg_entry_cur = host_chain;
+		if (!chain_offset_in_cur_seg)
+			goto fill_last_seg;
+
+		while (sg_entries_in_cur_seg) {
+			leapraid_single_ieee_sg_append(sg_entry_cur,
+				 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+					 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+				 0, sg_dma_len(scmd_sg_cur),
+				 sg_dma_address(scmd_sg_cur));
+			scmd_sg_cur = sg_next(scmd_sg_cur);
+			sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+			sg_entries_left--;
+			sg_entries_in_cur_seg--;
+		}
+		host_chain = io_tracker->chain + host_chain_cursor *
+			 LEAPRAID_CHAIN_SEG_SIZE;
+		host_chain_dma = io_tracker->chain_dma
+			 + host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+		host_chain_cursor += 1;
+	}
+
+fill_last_seg:
+	while (sg_entries_left > 0) {
+		u32 flags = LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+			 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR;
+		if (sg_entries_left == 1)
+			flags |= LEAPRAID_IEEE_SGE_FLG_EOL;
+		leapraid_single_ieee_sg_append(sg_entry_cur, flags,
+			 0, sg_dma_len(scmd_sg_cur),
+			 sg_dma_address(scmd_sg_cur));
+		scmd_sg_cur = sg_next(scmd_sg_cur);
+		sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+		sg_entries_left--;
+	}
+	return 0;
+}
+
+void
+leapraid_build_ieee_sg(struct leapraid_adapter *adapter, void *sge,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	if (h2c_size && !c2h_size)
+		leapraid_single_ieee_sg_append(sge,
+			 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_IEEE_SGE_FLG_EOL
+				 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR, 0,
+				 h2c_size, h2c_dma_addr);
+	else if (!h2c_size && c2h_size)
+		leapraid_single_ieee_sg_append(sge,
+			 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_IEEE_SGE_FLG_EOL
+				 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR, 0,
+				 c2h_size, c2h_dma_addr);
+	else if (h2c_size && c2h_size) {
+		leapraid_single_ieee_sg_append(sge,
+			 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+				 0, h2c_size, h2c_dma_addr);
+		sge += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+		leapraid_single_ieee_sg_append(sge,
+			 LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR
+				 | LEAPRAID_IEEE_SGE_FLG_EOL,
+				 0, c2h_size, c2h_dma_addr);
+	} else
+		return leapraid_build_ieee_nodata_sg(adapter, sge);
+}
+
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_from_tgt(struct leapraid_adapter *adapter,
+	 struct leapraid_starget_priv *tgt_priv)
+{
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	if (tgt_priv->sas_dev)
+		leapraid_sdev_get(tgt_priv->sas_dev);
+
+	return tgt_priv->sas_dev;
+}
+
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_from_tgt(struct leapraid_adapter *adapter,
+	 struct leapraid_starget_priv *tgt_priv)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_from_tgt(adapter,
+		 tgt_priv);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+static struct leapraid_card_port *
+leapraid_get_port_by_id(struct leapraid_adapter *adapter,
+	 u8 port_id, bool skip_dirty)
+{
+	struct leapraid_card_port *port;
+	struct leapraid_card_port *dirty_port = NULL;
+
+	if (!adapter->adapter_attr.enable_mp)
+		port_id = LEAPRAID_DISABLE_MP_PORT_ID;
+
+	list_for_each_entry(port, &adapter->dev_topo.card_port_list,
+		 list) {
+		if (port->port_id != port_id)
+			continue;
+
+		if (!(port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY))
+			return port;
+
+		if (skip_dirty && !dirty_port)
+			dirty_port = port;
+	}
+
+	if (dirty_port)
+		return dirty_port;
+
+	if (unlikely(!adapter->adapter_attr.enable_mp)) {
+		port = kzalloc(sizeof(struct leapraid_card_port),
+			 GFP_ATOMIC);
+		if (!port)
+			return NULL;
+
+		port->port_id = LEAPRAID_DISABLE_MP_PORT_ID;
+		list_add_tail(&port->list,
+			 &adapter->dev_topo.card_port_list);
+		return port;
+	}
+
+	return NULL;
+}
+
+struct leapraid_vphy *
+leapraid_get_vphy_by_phy(struct leapraid_card_port *port,
+	 u32 phy_seq_num)
+{
+	struct leapraid_vphy *vphy;
+
+	if (!port || !port->vphys_mask)
+		return NULL;
+
+	list_for_each_entry(vphy, &port->vphys_list, list) {
+		if (vphy->phy_mask & BIT(phy_seq_num))
+			return vphy;
+	}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+	struct leapraid_adapter *adapter,
+		 u64 sas_address, struct sas_rphy *rphy)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list,
+		 list)
+		if (sas_dev->sas_addr == sas_address
+			 && sas_dev->rphy == rphy) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+		 list)
+		if (sas_dev->sas_addr == sas_address
+			 && sas_dev->rphy == rphy) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_addr(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	if (!port)
+		return NULL;
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list,
+		 list)
+		if (sas_dev->sas_addr == sas_address
+			 && sas_dev->card_port == port) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+		 list)
+		if (sas_dev->sas_addr == sas_address
+			 && sas_dev->card_port == port) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_by_addr(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	if (!port)
+		return NULL;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+		 sas_address, port);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list,
+		 list)
+		if (sas_dev->hdl == hdl) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+		 list)
+		if (sas_dev->hdl == hdl) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+void
+leapraid_sas_dev_remove(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev)
+{
+	unsigned long flags;
+	bool del_from_list;
+
+	if (!sas_dev)
+		return;
+
+	del_from_list = false;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	if (!list_empty(&sas_dev->list)) {
+		list_del_init(&sas_dev->list);
+		del_from_list = true;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list)
+		leapraid_sdev_put(sas_dev);
+}
+
+static void
+leapraid_sas_dev_remove_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	bool del_from_list;
+
+	if (adapter->access_ctrl.shost_recovering)
+		return;
+
+	del_from_list = false;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter,
+		 hdl);
+	if (sas_dev) {
+		if (!list_empty(&sas_dev->list)) {
+			list_del_init(&sas_dev->list);
+			del_from_list = true;
+			leapraid_sdev_put(sas_dev);
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list) {
+		leapraid_remove_device(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+void
+leapraid_sas_dev_remove_by_sas_address(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	bool del_from_list;
+
+	if (adapter->access_ctrl.shost_recovering)
+		return;
+
+	del_from_list = false;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+		 sas_address, port);
+	if (sas_dev) {
+		if (!list_empty(&sas_dev->list)) {
+			list_del_init(&sas_dev->list);
+			del_from_list = true;
+			leapraid_sdev_put(sas_dev);
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list) {
+		leapraid_remove_device(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+struct leapraid_raid_volume *
+leapraid_raid_volume_find_by_id(struct leapraid_adapter *adapter,
+	 int id, int channel)
+{
+	struct leapraid_raid_volume *raid_volume;
+
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+		 list) {
+		if (raid_volume->id == id
+			 && raid_volume->channel == channel) {
+			return raid_volume;
+		}
+	}
+
+	return NULL;
+}
+
+struct leapraid_raid_volume *
+leapraid_raid_volume_find_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_raid_volume *raid_volume;
+
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+		 list) {
+		if (raid_volume->hdl == hdl)
+			return raid_volume;
+	}
+
+	return NULL;
+}
+
+static struct leapraid_raid_volume *
+leapraid_raid_volume_find_by_wwid(struct leapraid_adapter *adapter,
+	 u64 wwid)
+{
+	struct leapraid_raid_volume *raid_volume;
+
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+		 list) {
+		if (raid_volume->wwid == wwid)
+			return raid_volume;
+	}
+
+	return NULL;
+}
+
+static void
+leapraid_raid_volume_add(struct leapraid_adapter *adapter,
+	 struct leapraid_raid_volume *raid_volume)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_add_tail(&raid_volume->list,
+		 &adapter->dev_topo.raid_volume_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+void
+leapraid_raid_volume_remove(struct leapraid_adapter *adapter,
+	 struct leapraid_raid_volume *raid_volume)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_del(&raid_volume->list);
+	kfree(raid_volume);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+static struct leapraid_enc_node *
+leapraid_enc_find_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_enc_node *enc_dev;
+
+	list_for_each_entry(enc_dev, &adapter->dev_topo.enc_list,
+		 list) {
+		if (le16_to_cpu(enc_dev->pg0.enc_hdl) == hdl)
+			return enc_dev;
+	}
+
+	return NULL;
+}
+
+struct leapraid_topo_node *
+leapraid_exp_find_by_sas_address(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_topo_node *sas_exp;
+
+	if (!port)
+		return NULL;
+
+	list_for_each_entry(sas_exp, &adapter->dev_topo.exp_list,
+		 list) {
+		if (sas_exp->sas_address == sas_address
+			 && sas_exp->card_port == port)
+			return sas_exp;
+	}
+
+	return NULL;
+}
+
+bool
+leapraid_scmd_find_by_tgt(struct leapraid_adapter *adapter,
+	 int id, int channel)
+{
+	struct scsi_cmnd *scmd;
+	int taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		if (scmd->device->id == id
+			 && scmd->device->channel == channel)
+			return true;
+	}
+
+	return false;
+}
+
+bool
+leapraid_scmd_find_by_lun(struct leapraid_adapter *adapter,
+	 int id, unsigned int lun, int channel)
+{
+	struct scsi_cmnd *scmd;
+	int taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		if (scmd->device->id == id
+			 && scmd->device->channel == channel
+			 && scmd->device->lun == lun)
+			return true;
+	}
+
+	return false;
+}
+
+static struct leapraid_topo_node *
+leapraid_exp_find_by_hdl(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_topo_node *sas_exp;
+
+	list_for_each_entry(sas_exp, &adapter->dev_topo.exp_list,
+		 list) {
+		if (sas_exp->hdl == hdl)
+			return sas_exp;
+	}
+
+	return NULL;
+}
+
+static enum leapraid_card_port_checking_flg
+leapraid_get_card_port_feature(struct leapraid_card_port *old_card_port,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_card_port_feature *feature)
+{
+	feature->dirty_flg =
+		 old_card_port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY;
+	feature->same_addr =
+		 old_card_port->sas_address == card_port->sas_address;
+	feature->exact_phy =
+		 old_card_port->phy_mask == card_port->phy_mask;
+	feature->phy_overlap =
+		 old_card_port->phy_mask & card_port->phy_mask;
+	feature->same_port =
+		 old_card_port->port_id == card_port->port_id;
+	feature->cur_chking_old_port = old_card_port;
+
+	if (!feature->dirty_flg || !feature->same_addr)
+		return CARD_PORT_SKIP_CHECKING;
+
+	return CARD_PORT_FURTHER_CHECKING_NEEDED;
+}
+
+static int
+leapraid_process_card_port_feature(struct leapraid_card_port_feature
+		 *feature)
+{
+	struct leapraid_card_port *old_card_port;
+
+	old_card_port = feature->cur_chking_old_port;
+	if (feature->exact_phy) {
+		feature->checking_state = SAME_PORT_WITH_NOTHING_CHANGED;
+		feature->expected_old_port = old_card_port;
+		return 1;
+	} else if (feature->phy_overlap) {
+		if (feature->same_port) {
+			feature->checking_state
+				 = SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS;
+			feature->expected_old_port = old_card_port;
+		} else if (feature->checking_state !=
+			 SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS) {
+			feature->checking_state
+				 = SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS;
+			feature->expected_old_port = old_card_port;
+		}
+	} else {
+		if ((feature->checking_state
+				 != SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS)
+				 && (feature->checking_state
+				 != SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS)) {
+			feature->checking_state = SAME_ADDR_ONLY;
+			feature->expected_old_port = old_card_port;
+			feature->same_addr_port_count++;
+		}
+	}
+
+	return 0;
+}
+
+static int
+leapraid_check_card_port(struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_card_port **expected_card_port,
+	 int *count)
+{
+	struct leapraid_card_port *old_card_port;
+	struct leapraid_card_port_feature feature;
+
+	*expected_card_port = NULL;
+	memset(&feature, 0, sizeof(struct leapraid_card_port_feature));
+	feature.expected_old_port = NULL;
+	feature.same_addr_port_count = 0;
+	feature.checking_state = NEW_CARD_PORT;
+
+	list_for_each_entry(old_card_port,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (leapraid_get_card_port_feature(old_card_port,
+			 card_port, &feature))
+			continue;
+
+		if (leapraid_process_card_port_feature(&feature))
+			break;
+	}
+
+	if (feature.checking_state == SAME_ADDR_ONLY)
+		*count = feature.same_addr_port_count;
+
+	*expected_card_port = feature.expected_old_port;
+	return feature.checking_state;
+}
+
+static void
+leapraid_del_phy_part_of_anther_port(struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *card_port_table, int index,
+	 u8 port_count, int offset)
+{
+	struct leapraid_topo_node *card_topo_node;
+	bool found = false;
+	int i;
+
+	card_topo_node = &adapter->dev_topo.card;
+	for (i = 0; i < port_count; i++) {
+		if (i == index)
+			continue;
+
+		if (card_port_table[i].phy_mask & BIT(offset)) {
+			leapraid_transport_detach_phy_to_port(adapter,
+				 card_topo_node,
+				 &card_topo_node->card_phy[offset]);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		card_port_table[index].phy_mask |= BIT(offset);
+}
+
+static void
+leapraid_add_or_del_phys_from_existing_port(
+	struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_card_port *card_port_table,
+	 int index, u8 port_count)
+{
+	struct leapraid_topo_node *card_topo_node;
+	u32 phy_mask_diff;
+	u32 offset = 0;
+
+	card_topo_node = &adapter->dev_topo.card;
+	phy_mask_diff = card_port->phy_mask
+		 ^ card_port_table[index].phy_mask;
+	for (offset = 0; offset < adapter->dev_topo.card.phys_num;
+		 offset++) {
+		if (!(phy_mask_diff & BIT(offset)))
+			continue;
+
+		if (!(card_port_table[index].phy_mask & BIT(offset))) {
+			leapraid_del_phy_part_of_anther_port(adapter,
+				 card_port_table, index, port_count, offset);
+			continue;
+		}
+
+		if (card_topo_node->card_phy[offset].phy_is_assigned)
+			leapraid_transport_detach_phy_to_port(adapter,
+				 card_topo_node,
+				 &card_topo_node->card_phy[offset]);
+
+		leapraid_transport_attach_phy_to_port(adapter,
+			 card_topo_node, &card_topo_node->card_phy[offset],
+			 card_port->sas_address,
+			 card_port);
+	}
+}
+
+struct leapraid_sas_dev *
+leapraid_get_next_sas_dev_from_init_list(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	if (!list_empty(&adapter->dev_topo.sas_dev_init_list)) {
+		sas_dev = list_first_entry(
+			&adapter->dev_topo.sas_dev_init_list,
+			 struct leapraid_sas_dev, list);
+		leapraid_sdev_get(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+static bool
+leapraid_check_boot_dev_internal(u64 sas_address, u64 dev_name,
+	 u64 enc_lid, u16 slot, struct leapraid_boot_dev *boot_dev,
+	 u8 form)
+{
+	if (!boot_dev)
+		return false;
+
+	switch (form & LEAPRAID_BOOTDEV_FORM_MASK) {
+	case LEAPRAID_BOOTDEV_FORM_SAS_WWID:
+		if (!sas_address)
+			return false;
+
+		return sas_address ==
+			 le64_to_cpu(
+				((struct leapraid_boot_dev_format_sas_wwid *)(
+					boot_dev->pg_dev))->sas_addr);
+	case LEAPRAID_BOOTDEV_FORM_ENC_SLOT:
+		if (!enc_lid)
+			return false;
+
+		return (enc_lid ==
+			 le64_to_cpu(
+				((struct leapraid_boot_dev_format_enc_slot *)(
+					boot_dev->pg_dev))->enc_lid) && slot == le16_to_cpu(
+						((struct leapraid_boot_dev_format_enc_slot *)(
+							boot_dev->pg_dev))->slot_num));
+	case LEAPRAID_BOOTDEV_FORM_DEV_NAME:
+		if (!dev_name)
+			return false;
+
+		return dev_name ==
+			 le64_to_cpu(((struct leapraid_boot_dev_format_dev_name *)(
+				boot_dev->pg_dev))->dev_name);
+	case LEAPRAID_BOOTDEV_FORM_NONE:
+	default:
+		return false;
+	}
+}
+
+static void
+leapraid_try_set_boot_dev(struct leapraid_boot_dev *boot_dev,
+	 u64 sas_addr, u64 dev_name,
+	 u64 enc_lid, u16 slot,
+	 void *dev, u32 chnl)
+{
+	bool matched = false;
+
+	if (boot_dev->dev)
+		return;
+
+	matched = leapraid_check_boot_dev_internal(sas_addr, dev_name,
+		 enc_lid, slot, boot_dev, boot_dev->form);
+	if (matched) {
+		boot_dev->dev = dev;
+		boot_dev->chnl = chnl;
+	}
+}
+
+static void
+leapraid_check_boot_dev(struct leapraid_adapter *adapter,
+	 void *dev, u32 chnl)
+{
+	u64 sas_addr = 0;
+	u64 dev_name = 0;
+	u64 enc_lid = 0;
+	u16 slot = 0;
+
+	if (!adapter->scan_dev_desc.driver_loading)
+		return;
+
+	switch (chnl) {
+	case RAID_CHANNEL:
+	{
+		struct leapraid_raid_volume *raid_volume
+			 = (struct leapraid_raid_volume *)dev;
+		sas_addr = raid_volume->wwid;
+		break;
+	}
+	default:
+	{
+		struct leapraid_sas_dev *sas_dev
+			 = (struct leapraid_sas_dev *)dev;
+		sas_addr = sas_dev->sas_addr;
+		dev_name = sas_dev->dev_name;
+		enc_lid = sas_dev->enc_lid;
+		slot = sas_dev->slot;
+		break;
+	}
+	}
+
+	leapraid_try_set_boot_dev(
+		&adapter->boot_devs.requested_boot_dev,
+		 sas_addr, dev_name, enc_lid, slot, dev, chnl);
+	leapraid_try_set_boot_dev(
+		&adapter->boot_devs.requested_alt_boot_dev,
+		 sas_addr, dev_name, enc_lid, slot, dev, chnl);
+	leapraid_try_set_boot_dev(
+		&adapter->boot_devs.current_boot_dev,
+		 sas_addr, dev_name, enc_lid, slot, dev, chnl);
+}
+
+static void
+leapraid_build_and_fire_cfg_req(struct leapraid_adapter *adapter,
+	 struct leapraid_cfg_req *leap_mpi_cfgp_req,
+	 struct leapraid_cfg_rep *leap_mpi_cfgp_rep)
+{
+	struct leapraid_cfg_req *local_leap_cfg_req;
+
+	memset(leap_mpi_cfgp_rep, 0, sizeof(struct leapraid_cfg_rep));
+	memset((void *)(&adapter->driver_cmds.cfg_op_cmd.reply), 0,
+		 sizeof(struct leapraid_cfg_rep));
+	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_PENDING;
+	local_leap_cfg_req = leapraid_get_task_desc(
+		adapter, adapter->driver_cmds.cfg_op_cmd.inter_taskid);
+	memcpy(local_leap_cfg_req, leap_mpi_cfgp_req,
+			 sizeof(struct leapraid_cfg_req));
+	init_completion(&adapter->driver_cmds.cfg_op_cmd.done);
+	leapraid_fire_task(adapter,
+			 adapter->driver_cmds.cfg_op_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.cfg_op_cmd.done,
+			 LEAPRAID_CFP_DEFAULT_TIMEOUT * HZ);
+}
+
+static int
+leapraid_req_cfg_func(struct leapraid_adapter *adapter,
+	 struct leapraid_cfg_req *leap_mpi_cfgp_req,
+	 struct leapraid_cfg_rep *leap_mpi_cfgp_rep,
+	 void *target_cfg_pg, void *real_cfg_pg_addr,
+	 u16 target_real_cfg_pg_sz)
+{
+	u32 adapter_status = ~0U;
+	bool issue_reset = false;
+	u8 retry_cnt;
+	int rc;
+
+	retry_cnt = 0;
+	mutex_lock(&adapter->driver_cmds.cfg_op_cmd.mutex);
+retry:
+	if (retry_cnt) {
+		if (retry_cnt > LEAPRAID_CFG_REQ_RETRY_TIMES) {
+			rc = -EFAULT;
+			goto out;
+		}
+		dev_info(&adapter->pdev->dev,
+			 "attempting retry request cfg header cnt=%d\n",
+			 retry_cnt);
+	}
+
+	rc = leapraid_check_adapter_is_op(adapter);
+	if (rc)
+		goto out;
+
+	leapraid_build_and_fire_cfg_req(adapter,
+		 leap_mpi_cfgp_req, leap_mpi_cfgp_rep);
+	if (!(adapter->driver_cmds.cfg_op_cmd.status
+			 & LEAPRAID_CMD_DONE)) {
+		retry_cnt++;
+		if (adapter->driver_cmds.cfg_op_cmd.status
+				 & LEAPRAID_CMD_RESET)
+			goto retry;
+
+		if (adapter->access_ctrl.shost_recovering
+			 || adapter->access_ctrl.pcie_recovering) {
+			issue_reset = false;
+			rc = -EFAULT;
+		} else
+			issue_reset = true;
+		goto out;
+	}
+
+	if (adapter->driver_cmds.cfg_op_cmd.status
+			 & LEAPRAID_CMD_REPLY_VALID) {
+		memcpy(leap_mpi_cfgp_rep,
+			 (void *)(&adapter->driver_cmds.cfg_op_cmd.reply),
+			 sizeof(struct leapraid_cfg_rep));
+		adapter_status = le16_to_cpu(leap_mpi_cfgp_rep->adapter_status)
+			 & LEAPRAID_ADAPTER_STATUS_MASK;
+		if (adapter_status == LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+			if (target_cfg_pg
+				 && real_cfg_pg_addr
+				 && target_real_cfg_pg_sz)
+				if (leap_mpi_cfgp_req->action
+					 == LEAPRAID_CFG_ACT_PAGE_READ_CUR)
+					memcpy(target_cfg_pg,
+						 real_cfg_pg_addr,
+						 target_real_cfg_pg_sz);
+		} else {
+			rc = -EFAULT;
+		}
+	} else {
+		rc = -EFAULT;
+	}
+
+out:
+	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.cfg_op_cmd.mutex);
+	if (issue_reset) {
+		if (adapter->scan_dev_desc.first_scan_dev_fired) {
+			leapraid_hard_reset_handler(adapter, FULL_RESET);
+			rc = -EFAULT;
+		} else {
+			rc = -EFAULT;
+		}
+	}
+	return rc;
+}
+
+static int
+leapraid_request_cfg_pg_header(struct leapraid_adapter *adapter,
+	 struct leapraid_cfg_req *leap_mpi_cfgp_req,
+	 struct leapraid_cfg_rep *leap_mpi_cfgp_rep)
+{
+	return leapraid_req_cfg_func(adapter, leap_mpi_cfgp_req,
+		 leap_mpi_cfgp_rep, NULL, NULL, 0);
+}
+
+static int
+leapraid_request_cfg_pg(struct leapraid_adapter *adapter,
+	 struct leapraid_cfg_req *leap_mpi_cfgp_req,
+	 struct leapraid_cfg_rep *leap_mpi_cfgp_rep,
+	 void *target_cfg_pg, void *real_cfg_pg_addr,
+	 u16 target_real_cfg_pg_sz)
+{
+	return leapraid_req_cfg_func(adapter, leap_mpi_cfgp_req,
+		 leap_mpi_cfgp_rep, target_cfg_pg, real_cfg_pg_addr,
+		 target_real_cfg_pg_sz);
+}
+
+int
+leapraid_op_config_page(struct leapraid_adapter *adapter,
+	 void *target_cfg_pg, union cfg_param_1 cfgp1,
+	 union cfg_param_2 cfgp2,
+	 enum config_page_action cfg_op)
+{
+	struct leapraid_cfg_req leap_mpi_cfgp_req;
+	struct leapraid_cfg_rep leap_mpi_cfgp_rep;
+	u16 real_cfg_pg_sz = 0;
+	void *real_cfg_pg_addr = NULL;
+	dma_addr_t real_cfg_pg_dma = 0;
+	u32 __page_size;
+	int rc;
+
+	memset(&leap_mpi_cfgp_req, 0,
+			 sizeof(struct leapraid_cfg_req));
+	leap_mpi_cfgp_req.func = LEAPRAID_FUNC_CONFIG_OP;
+	leap_mpi_cfgp_req.action = LEAPRAID_CFG_ACT_PAGE_HEADER;
+
+	switch (cfg_op) {
+	case GET_BIOS_PG3:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_BIOS;
+		leap_mpi_cfgp_req.header.page_num = 0x3;
+		__page_size = sizeof(struct leapraid_bios_page3);
+		break;
+	case GET_BIOS_PG2:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_BIOS;
+		leap_mpi_cfgp_req.header.page_num = 0x2;
+		__page_size = sizeof(struct leapraid_bios_page2);
+		break;
+	case GET_SAS_DEVICE_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_DEV;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = sizeof(struct leapraid_sas_dev_p0);
+		break;
+	case GET_SAS_IOUNIT_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_IO_UNIT;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = cfgp1.size;
+		break;
+	case GET_SAS_IOUNIT_PG1:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_IO_UNIT;
+		leap_mpi_cfgp_req.header.page_num = 0x1;
+		__page_size = cfgp1.size;
+		break;
+	case GET_SAS_EXPANDER_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_EXP;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = sizeof(struct leapraid_exp_p0);
+		break;
+	case GET_SAS_EXPANDER_PG1:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_EXP;
+		leap_mpi_cfgp_req.header.page_num = 0x1;
+		__page_size = sizeof(struct leapraid_exp_p1);
+		break;
+	case GET_SAS_ENCLOSURE_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_ENC;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = sizeof(struct leapraid_enc_p0);
+		break;
+	case GET_PHY_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type
+			 = LEAPRAID_CFG_EXTPT_SAS_PHY;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = sizeof(struct leapraid_sas_phy_p0);
+		break;
+	case GET_RAID_VOLUME_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_RAID_VOLUME;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = cfgp1.size;
+		break;
+	case GET_RAID_VOLUME_PG1:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_RAID_VOLUME;
+		leap_mpi_cfgp_req.header.page_num = 0x1;
+		__page_size = sizeof(struct leapraid_raidvol_p1);
+		break;
+	case GET_PHY_DISK_PG0:
+		leap_mpi_cfgp_req.header.page_type
+			 = LEAPRAID_CFG_PT_RAID_PHYSDISK;
+		leap_mpi_cfgp_req.header.page_num = 0x0;
+		__page_size = sizeof(struct leapraid_raidpd_p0);
+		break;
+	default:
+		dev_err(&adapter->pdev->dev,
+				 "unsupported config page action=%d!\n",
+				 cfg_op);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	leapraid_build_nodata_mpi_sg(adapter,
+			 &leap_mpi_cfgp_req.page_buf_sge);
+	rc = leapraid_request_cfg_pg_header(adapter,
+			 &leap_mpi_cfgp_req, &leap_mpi_cfgp_rep);
+	if (rc)
+		goto out;
+
+	if (cfg_op == GET_SAS_DEVICE_PG0
+		|| cfg_op == GET_SAS_EXPANDER_PG0
+		|| cfg_op == GET_SAS_ENCLOSURE_PG0
+		|| cfg_op == GET_RAID_VOLUME_PG1)
+		leap_mpi_cfgp_req.page_addr = cpu_to_le32(
+			cfgp1.form | cfgp2.handle);
+	else if (cfg_op == GET_PHY_DISK_PG0)
+		leap_mpi_cfgp_req.page_addr = cpu_to_le32(
+			cfgp1.form | cfgp2.form_specific);
+	else if (cfg_op == GET_RAID_VOLUME_PG0)
+		leap_mpi_cfgp_req.page_addr =
+			 cpu_to_le32(LEAPRAID_RAID_VOL_CFG_PGAD_HDL
+				 | cfgp2.handle);
+	else if (cfg_op == GET_SAS_EXPANDER_PG1)
+		leap_mpi_cfgp_req.page_addr =
+			 cpu_to_le32(LEAPRAID_SAS_EXP_CFG_PGAD_HDL_PHY_NUM
+				 | (cfgp1.phy_number
+				 << LEAPRAID_SAS_EXP_CFG_PGAD_PHYNUM_SHIFT)
+					 | cfgp2.handle);
+	else if (cfg_op == GET_PHY_PG0)
+		leap_mpi_cfgp_req.page_addr
+			 = cpu_to_le32(LEAPRAID_SAS_PHY_CFG_PGAD_PHY_NUMBER
+				 | cfgp1.phy_number);
+
+	leap_mpi_cfgp_req.action = LEAPRAID_CFG_ACT_PAGE_READ_CUR;
+
+	leap_mpi_cfgp_req.header.page_num
+		 = leap_mpi_cfgp_rep.header.page_num;
+	leap_mpi_cfgp_req.header.page_type
+		 = leap_mpi_cfgp_rep.header.page_type;
+	leap_mpi_cfgp_req.header.page_len
+		 = leap_mpi_cfgp_rep.header.page_len;
+	leap_mpi_cfgp_req.ext_page_len
+		 = leap_mpi_cfgp_rep.ext_page_len;
+	leap_mpi_cfgp_req.ext_page_type
+		 = leap_mpi_cfgp_rep.ext_page_type;
+
+	real_cfg_pg_sz = (leap_mpi_cfgp_req.header.page_len) ?
+		 leap_mpi_cfgp_req.header.page_len * 4 :
+		 le16_to_cpu(leap_mpi_cfgp_rep.ext_page_len) * 4;
+	real_cfg_pg_addr = dma_alloc_coherent(&adapter->pdev->dev,
+		 real_cfg_pg_sz, &real_cfg_pg_dma, GFP_KERNEL);
+	if (!real_cfg_pg_addr) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (leap_mpi_cfgp_req.action == LEAPRAID_CFG_ACT_PAGE_WRITE_CUR) {
+		leapraid_single_mpi_sg_append(adapter,
+			 &leap_mpi_cfgp_req.page_buf_sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_LAST_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_EOL
+				 | LEAPRAID_SGE_FLG_H2C) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | real_cfg_pg_sz, real_cfg_pg_dma);
+		memcpy(real_cfg_pg_addr, target_cfg_pg,
+				 min_t(u16, real_cfg_pg_sz, __page_size));
+	} else {
+		memset(target_cfg_pg, 0, __page_size);
+		leapraid_single_mpi_sg_append(adapter,
+				 &leap_mpi_cfgp_req.page_buf_sge,
+				 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+					 | LEAPRAID_SGE_FLG_LAST_ONE
+					 | LEAPRAID_SGE_FLG_EOB
+					 | LEAPRAID_SGE_FLG_EOL) <<
+						 LEAPRAID_SGE_FLG_SHIFT)
+					 | real_cfg_pg_sz, real_cfg_pg_dma);
+		memset(real_cfg_pg_addr, 0,
+				 min_t(u16, real_cfg_pg_sz, __page_size));
+	}
+
+	rc = leapraid_request_cfg_pg(adapter, &leap_mpi_cfgp_req,
+		 &leap_mpi_cfgp_rep, target_cfg_pg, real_cfg_pg_addr,
+		 min_t(u16, real_cfg_pg_sz, __page_size));
+	if (real_cfg_pg_addr)
+		dma_free_coherent(&adapter->pdev->dev,
+			 real_cfg_pg_sz, real_cfg_pg_addr, real_cfg_pg_dma);
+out:
+	return rc;
+}
+
+static int
+leapraid_cfg_get_volume_hdl_dispatch(struct leapraid_adapter *adapter,
+	 struct leapraid_cfg_req *cfg_req,
+	 struct leapraid_cfg_rep *cfg_rep,
+	 struct leapraid_raid_cfg_p0 *raid_cfg_p0,
+	 void *real_cfg_pg_addr,
+	 u16 real_cfg_pg_sz,
+	 u16 raid_cfg_p0_sz,
+	 u16 pd_hdl, u16 *vol_hdl)
+{
+	u16 phys_disk_dev_hdl;
+	u16 adapter_status;
+	u16 element_type;
+	int config_num;
+	int rc, i;
+
+	config_num = 0xff;
+	while (true) {
+		cfg_req->page_addr = cpu_to_le32(config_num +
+			 LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP);
+		rc = leapraid_request_cfg_pg(adapter, cfg_req, cfg_rep,
+			 raid_cfg_p0, real_cfg_pg_addr,
+			 min_t(u16, real_cfg_pg_sz, raid_cfg_p0_sz));
+		if (rc)
+			return rc;
+
+		adapter_status = le16_to_cpu(cfg_rep->adapter_status) &
+			 LEAPRAID_ADAPTER_STATUS_MASK;
+		if (adapter_status
+			 == LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE) {
+			*vol_hdl = 0;
+			return 0;
+		} else if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
+			return -1;
+
+		for (i = 0; i < raid_cfg_p0->elements_num; i++) {
+			element_type =
+				 le16_to_cpu(
+					raid_cfg_p0->cfg_element[i].element_flg) &
+					 LEAPRAID_RAIDCFG_P0_EFLG_MASK_ELEMENT_TYPE;
+
+			switch (element_type) {
+			case LEAPRAID_RAIDCFG_P0_EFLG_VOL_PHYS_DISK_ELEMENT:
+			case LEAPRAID_RAIDCFG_P0_EFLG_OCE_ELEMENT:
+				phys_disk_dev_hdl =
+					 le16_to_cpu(
+						raid_cfg_p0->cfg_element[i].phys_disk_dev_hdl);
+				if (phys_disk_dev_hdl == pd_hdl) {
+					*vol_hdl =
+						 le16_to_cpu(
+							raid_cfg_p0->cfg_element[i].vol_dev_hdl);
+					return 0;
+				}
+				break;
+
+			case LEAPRAID_RAIDCFG_P0_EFLG_HOT_SPARE_ELEMENT:
+				*vol_hdl = 0;
+				return 0;
+			default:
+				break;
+			}
+		}
+		config_num = raid_cfg_p0->cfg_num;
+	}
+	return 0;
+}
+
+int
+leapraid_cfg_get_volume_hdl(struct leapraid_adapter *adapter,
+	 u16 pd_hdl, u16 *vol_hdl)
+{
+	struct leapraid_raid_cfg_p0 *raid_cfg_p0 = NULL;
+	struct leapraid_cfg_req cfg_req;
+	struct leapraid_cfg_rep cfg_rep;
+	dma_addr_t real_cfg_pg_dma = 0;
+	void *real_cfg_pg_addr = NULL;
+	u16 real_cfg_pg_sz = 0;
+	int rc, raid_cfg_p0_sz;
+
+	*vol_hdl = 0;
+	memset(&cfg_req, 0, sizeof(struct leapraid_cfg_req));
+	cfg_req.func = LEAPRAID_FUNC_CONFIG_OP;
+	cfg_req.action = LEAPRAID_CFG_ACT_PAGE_HEADER;
+	cfg_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+	cfg_req.ext_page_type = LEAPRAID_CFG_EXTPT_RAID_CONFIG;
+	cfg_req.header.page_num = 0;
+
+
+	leapraid_build_nodata_mpi_sg(adapter, &cfg_req.page_buf_sge);
+	rc = leapraid_request_cfg_pg_header(adapter,
+			 &cfg_req, &cfg_rep);
+	if (rc)
+		goto out;
+
+	cfg_req.action = LEAPRAID_CFG_ACT_PAGE_READ_CUR;
+	raid_cfg_p0_sz = (le16_to_cpu(cfg_rep.ext_page_len) * 4);
+	raid_cfg_p0 = kmalloc(raid_cfg_p0_sz, GFP_KERNEL);
+	if (!raid_cfg_p0) {
+		rc = -1;
+		goto out;
+	}
+
+	real_cfg_pg_sz = (cfg_req.header.page_len) ?
+		 cfg_req.header.page_len * 4 :
+		 le16_to_cpu(cfg_rep.ext_page_len) * 4;
+
+	real_cfg_pg_addr = dma_alloc_coherent(&adapter->pdev->dev,
+		 real_cfg_pg_sz, &real_cfg_pg_dma, GFP_KERNEL);
+	if (!real_cfg_pg_addr) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memset(raid_cfg_p0, 0, raid_cfg_p0_sz);
+	leapraid_single_mpi_sg_append(adapter,
+			 &cfg_req.page_buf_sge,
+			 ((LEAPRAID_SGE_FLG_SIMPLE_ONE
+				 | LEAPRAID_SGE_FLG_LAST_ONE
+				 | LEAPRAID_SGE_FLG_EOB
+				 | LEAPRAID_SGE_FLG_EOL) <<
+					 LEAPRAID_SGE_FLG_SHIFT)
+				 | real_cfg_pg_sz, real_cfg_pg_dma);
+	memset(real_cfg_pg_addr, 0,
+			 min_t(u16, real_cfg_pg_sz, raid_cfg_p0_sz));
+
+	rc = leapraid_cfg_get_volume_hdl_dispatch(adapter,
+		 &cfg_req, &cfg_rep,
+		 raid_cfg_p0, real_cfg_pg_addr,
+		 real_cfg_pg_sz, raid_cfg_p0_sz,
+		 pd_hdl, vol_hdl);
+
+out:
+	if (real_cfg_pg_addr)
+		dma_free_coherent(&adapter->pdev->dev,
+			 real_cfg_pg_sz, real_cfg_pg_addr, real_cfg_pg_dma);
+	kfree(raid_cfg_p0);
+	return rc;
+}
+
+static int
+leapraid_get_adapter_phys(struct leapraid_adapter *adapter, u8 *nr_phys)
+{
+	struct leapraid_sas_io_unit_p0 sas_io_unit_page0;
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	int rc = 0;
+
+	*nr_phys = 0;
+	cfgp1.size = sizeof(struct leapraid_sas_io_unit_p0);
+	rc = leapraid_op_config_page(adapter, &sas_io_unit_page0,
+		 cfgp1, cfgp2, GET_SAS_IOUNIT_PG0);
+	if (rc)
+		return rc;
+
+	*nr_phys = sas_io_unit_page0.phy_num;
+
+	return 0;
+}
+
+static int
+leapraid_cfg_get_number_pds(struct leapraid_adapter *adapter,
+	 u16 hdl, u8 *num_pds)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p0 raidvol_p0;
+	int rc;
+
+	*num_pds = 0;
+	cfgp1.size = sizeof(struct leapraid_raidvol_p0);
+	cfgp2.handle = hdl;
+	rc = leapraid_op_config_page(adapter, &raidvol_p0,
+		 cfgp1, cfgp2, GET_RAID_VOLUME_PG0);
+
+	if (!rc)
+		*num_pds = raidvol_p0.num_phys_disks;
+
+	return rc;
+}
+
+int
+leapraid_cfg_get_volume_wwid(struct leapraid_adapter *adapter,
+	 u16 vol_hdl, u64 *wwid)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p1 raidvol_p1;
+	int rc;
+
+	*wwid = 0;
+	cfgp1.form = LEAPRAID_RAID_VOL_CFG_PGAD_HDL;
+	cfgp2.handle = vol_hdl;
+	rc = leapraid_op_config_page(adapter,
+		 &raidvol_p1, cfgp1, cfgp2, GET_RAID_VOLUME_PG1);
+	if (!rc)
+		*wwid = le64_to_cpu(raidvol_p1.wwid);
+
+	return rc;
+}
+
+static int
+leapraid_get_sas_io_unit_page0(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_io_unit_p0 *sas_io_unit_p0,
+	 u16 sas_iou_pg0_sz)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+
+	cfgp1.size = sas_iou_pg0_sz;
+	return leapraid_op_config_page(adapter, sas_io_unit_p0,
+		 cfgp1, cfgp2, GET_SAS_IOUNIT_PG0);
+}
+
+static int
+leapraid_get_sas_address(struct leapraid_adapter *adapter,
+	 u16 hdl, u64 *sas_address)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+
+	*sas_address = 0;
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if ((leapraid_op_config_page(adapter,
+		 &sas_dev_p0, cfgp1, cfgp2, GET_SAS_DEVICE_PG0)))
+		return -ENXIO;
+
+	if ((hdl <= adapter->dev_topo.card.phys_num) &&
+		 (!(le32_to_cpu(sas_dev_p0.dev_info)
+		 & LEAPRAID_DEVTYP_SEP)))
+		*sas_address = adapter->dev_topo.card.sas_address;
+	else
+		*sas_address = le64_to_cpu(sas_dev_p0.sas_address);
+
+	return 0;
+}
+
+int
+leapraid_get_volume_cap(struct leapraid_adapter *adapter,
+	 struct leapraid_raid_volume *raid_volume)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p0 *raidvol_p0;
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_raidpd_p0 raidpd_p0;
+	u8 num_pds;
+	u16 sz;
+
+	if ((leapraid_cfg_get_number_pds(adapter, raid_volume->hdl,
+		 &num_pds)) || !num_pds)
+		return -EFAULT;
+
+	raid_volume->pd_num = num_pds;
+	sz = offsetof(struct leapraid_raidvol_p0, phys_disk)
+		 + (num_pds * sizeof(struct leapraid_raidvol0_phys_disk));
+	raidvol_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!raidvol_p0)
+		return -EFAULT;
+
+	cfgp1.size = sz;
+	cfgp2.handle = raid_volume->hdl;
+	if ((leapraid_op_config_page(adapter, raidvol_p0, cfgp1, cfgp2,
+		 GET_RAID_VOLUME_PG0))) {
+		kfree(raidvol_p0);
+		return -EFAULT;
+	}
+
+	raid_volume->vol_type = raidvol_p0->volume_type;
+	cfgp1.form = LEAPRAID_PHYSDISK_CFG_PGAD_PHYSDISKNUM;
+	cfgp2.form_specific = raidvol_p0->phys_disk[0].phys_disk_num;
+	if (!(leapraid_op_config_page(adapter, &raidpd_p0, cfgp1, cfgp2,
+		 GET_PHY_DISK_PG0))) {
+		cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+		cfgp2.handle = le16_to_cpu(raidpd_p0.dev_hdl);
+		if (!(leapraid_op_config_page(adapter, &sas_dev_p0,
+			 cfgp1, cfgp2, GET_SAS_DEVICE_PG0))) {
+			raid_volume->dev_info =
+				 le32_to_cpu(sas_dev_p0.dev_info);
+		}
+	}
+
+	kfree(raidvol_p0);
+	return 0;
+}
+
+static void
+leapraid_fw_log_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter = container_of(work,
+		 struct leapraid_adapter, fw_log_desc.fw_log_work.work);
+	struct leapraid_fw_log_info *infom;
+	unsigned long flags;
+
+	infom = (struct leapraid_fw_log_info *)(
+		adapter->fw_log_desc.fw_log_buffer
+			 + LEAPRAID_SYS_LOG_BUF_SIZE);
+
+	if (adapter->fw_log_desc.fw_log_init_flag == 0) {
+		infom->user_position
+			 = leapraid_readl(
+				&adapter->iomem_base->host_log_buf_pos);
+		infom->adapter_position
+			 = leapraid_readl(
+				&adapter->iomem_base->adapter_log_buf_pos);
+		adapter->fw_log_desc.fw_log_init_flag++;
+	}
+
+	writel(infom->user_position,
+		 &adapter->iomem_base->host_log_buf_pos);
+	infom->adapter_position
+		 = leapraid_readl(
+			&adapter->iomem_base->adapter_log_buf_pos);
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	if (adapter->fw_log_desc.fw_log_wq)
+		queue_delayed_work(adapter->fw_log_desc.fw_log_wq,
+			 &adapter->fw_log_desc.fw_log_work,
+			 msecs_to_jiffies(LEAPRAID_PCIE_LOG_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+}
+
+void
+leapraid_fw_log_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	wq = adapter->fw_log_desc.fw_log_wq;
+	adapter->fw_log_desc.fw_log_wq = NULL;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	if (wq) {
+		if (!cancel_delayed_work_sync(
+			&adapter->fw_log_desc.fw_log_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
+void
+leapraid_fw_log_start(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return;
+
+	if (adapter->fw_log_desc.fw_log_wq)
+		return;
+
+	INIT_DELAYED_WORK(&adapter->fw_log_desc.fw_log_work,
+		 leapraid_fw_log_work);
+	snprintf(adapter->fw_log_desc.fw_log_wq_name,
+		 sizeof(adapter->fw_log_desc.fw_log_wq_name),
+		 "poll_%s%u_fw_log",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->fw_log_desc.fw_log_wq
+		 = create_singlethread_workqueue(
+			adapter->fw_log_desc.fw_log_wq_name);
+	if (!adapter->fw_log_desc.fw_log_wq)
+		return;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	if (adapter->fw_log_desc.fw_log_wq)
+		queue_delayed_work(adapter->fw_log_desc.fw_log_wq,
+			 &adapter->fw_log_desc.fw_log_work,
+			 msecs_to_jiffies(LEAPRAID_PCIE_LOG_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+}
+
+static void
+leapraid_timestamp_sync(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_unit_ctrl_req *io_unit_ctrl_req;
+	ktime_t current_time;
+	bool issue_reset = false;
+	u64 time_stamp = 0;
+
+	mutex_lock(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+	adapter->driver_cmds.timestamp_sync_cmd.status
+		 = LEAPRAID_CMD_PENDING;
+	io_unit_ctrl_req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.timestamp_sync_cmd.inter_taskid);
+	memset(io_unit_ctrl_req, 0,
+			 sizeof(struct leapraid_io_unit_ctrl_req));
+	io_unit_ctrl_req->func = LEAPRAID_FUNC_SAS_IO_UNIT_CTRL;
+	io_unit_ctrl_req->op = LEAPRAID_SAS_OP_SET_PARAMETER;
+	io_unit_ctrl_req->adapter_para =
+		 LEAPRAID_SET_PARAMETER_SYNC_TIMESTAMP;
+
+	current_time = ktime_get_real();
+	time_stamp = ktime_to_ms(current_time);
+
+	io_unit_ctrl_req->adapter_para_value =
+		 cpu_to_le32(time_stamp & 0xFFFFFFFF);
+	io_unit_ctrl_req->adapter_para_value2
+		 = cpu_to_le32(time_stamp >> 32);
+	init_completion(
+		&adapter->driver_cmds.timestamp_sync_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.timestamp_sync_cmd.inter_taskid);
+	wait_for_completion_timeout(
+		&adapter->driver_cmds.timestamp_sync_cmd.done,
+		 10 * HZ);
+	if (!(adapter->driver_cmds.timestamp_sync_cmd.status
+			 & LEAPRAID_CMD_DONE))
+		issue_reset = leapraid_check_reset(
+			adapter->driver_cmds.timestamp_sync_cmd.status);
+
+	if (issue_reset)
+		leapraid_hard_reset_handler(adapter, FULL_RESET);
+
+	adapter->driver_cmds.timestamp_sync_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+}
+
+static bool
+leapraid_should_skip_fault_check(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+	bool skip;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+			 flags);
+	skip = adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering
+		 || adapter->access_ctrl.host_removing;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+			 flags);
+
+	return skip;
+}
+static void
+leapraid_check_scheduled_fault_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter;
+	unsigned long flags;
+	u32 adapter_state;
+	int rc;
+
+	adapter = container_of(work, struct leapraid_adapter,
+		 reset_desc.fault_reset_work.work);
+
+	if (leapraid_should_skip_fault_check(adapter))
+		goto scheduled_timer;
+
+	adapter_state = leapraid_get_adapter_state(adapter);
+	if (adapter_state != LEAPRAID_DB_OPERATIONAL) {
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		dev_warn(&adapter->pdev->dev, "%s: hard reset: %s\n",
+			 __func__, (rc == 0) ? "success" : "failed");
+
+		adapter_state = leapraid_get_adapter_state(adapter);
+		if (rc && adapter_state != LEAPRAID_DB_OPERATIONAL)
+			return;
+	}
+
+
+	if (++adapter->timestamp_sync_cnt
+			 >= LEAPRAID_TIMESTAMP_SYNC_INTERVAL) {
+		adapter->timestamp_sync_cnt = 0;
+		leapraid_timestamp_sync(adapter);
+	}
+
+scheduled_timer:
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+			 flags);
+	if (adapter->reset_desc.fault_reset_wq)
+		queue_delayed_work(adapter->reset_desc.fault_reset_wq,
+			 &adapter->reset_desc.fault_reset_work,
+			 msecs_to_jiffies(LEAPRAID_FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+			 flags);
+}
+
+void
+leapraid_check_scheduled_fault_start(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	if (adapter->reset_desc.fault_reset_wq)
+		return;
+
+	adapter->timestamp_sync_cnt = 0;
+	INIT_DELAYED_WORK(&adapter->reset_desc.fault_reset_work,
+		 leapraid_check_scheduled_fault_work);
+	snprintf(adapter->reset_desc.fault_reset_wq_name,
+		 sizeof(adapter->reset_desc.fault_reset_wq_name),
+		 "poll_%s%u_status",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->reset_desc.fault_reset_wq =
+		 create_singlethread_workqueue(
+			adapter->reset_desc.fault_reset_wq_name);
+	if (!adapter->reset_desc.fault_reset_wq) {
+		dev_err(&adapter->pdev->dev,
+			 "create single thread workqueue failed!\n");
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	if (adapter->reset_desc.fault_reset_wq)
+		queue_delayed_work(adapter->reset_desc.fault_reset_wq,
+			 &adapter->reset_desc.fault_reset_work,
+			 msecs_to_jiffies(LEAPRAID_FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+}
+
+void
+leapraid_check_scheduled_fault_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	wq = adapter->reset_desc.fault_reset_wq;
+	adapter->reset_desc.fault_reset_wq = NULL;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+
+	if (!wq)
+		return;
+
+	if (!cancel_delayed_work_sync(
+		&adapter->reset_desc.fault_reset_work))
+		flush_workqueue(wq);
+	destroy_workqueue(wq);
+}
+
+static bool
+leapraid_ready_for_scsi_io(struct leapraid_adapter *adapter,
+		 u16 hdl)
+{
+	if (adapter->access_ctrl.pcie_recovering
+		 || adapter->access_ctrl.shost_recovering)
+		return false;
+
+	if (leapraid_check_adapter_is_op(adapter))
+		return false;
+
+	if (hdl == LEAPRAID_INVALID_DEV_HANDLE)
+		return false;
+
+	if (test_bit(hdl,
+			 (unsigned long *)adapter->dev_topo.dev_removing))
+		return false;
+
+	return true;
+}
+
+static int
+leapraid_dispatch_scsi_io(struct leapraid_adapter *adapter,
+		 struct leapraid_scsi_cmd_desc *cmd_desc)
+{
+	struct scsi_device *sdev;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_cmnd *scmd;
+	void *dma_buffer = NULL;
+	dma_addr_t dma_addr = 0;
+	u8 sdev_flg = 0;
+	bool issue_reset = false;
+	int rc = 0;
+
+	if (WARN_ON(!adapter->driver_cmds.internal_scmd))
+		return -EINVAL;
+
+	if (!leapraid_ready_for_scsi_io(adapter, cmd_desc->hdl))
+		return -EINVAL;
+
+	mutex_lock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	if (adapter->driver_cmds.driver_scsiio_cmd.status
+		 != LEAPRAID_CMD_NOT_USED) {
+		rc = -EAGAIN;
+		goto out;
+	}
+	adapter->driver_cmds.driver_scsiio_cmd.status
+		 = LEAPRAID_CMD_PENDING;
+
+	__shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (sdev_priv->starget_priv->hdl == cmd_desc->hdl
+			 && sdev_priv->lun == cmd_desc->lun) {
+			sdev_flg = 1;
+			break;
+		}
+	}
+
+	if (!sdev_flg) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (cmd_desc->data_length) {
+		dma_buffer = dma_alloc_coherent(&adapter->pdev->dev,
+			 cmd_desc->data_length, &dma_addr, GFP_ATOMIC);
+		if (!dma_buffer) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		if (cmd_desc->dir == DMA_TO_DEVICE)
+			memcpy(dma_buffer, cmd_desc->data_buffer,
+					 cmd_desc->data_length);
+	}
+
+	scmd = adapter->driver_cmds.internal_scmd;
+	scmd->device = sdev;
+	scmd->cmd_len = cmd_desc->cdb_length;
+	memcpy(scmd->cmnd, cmd_desc->cdb, cmd_desc->cdb_length);
+	scmd->sc_data_direction = cmd_desc->dir;
+	scmd->sdb.length = cmd_desc->data_length;
+	scmd->sdb.table.nents = 1;
+	scmd->sdb.table.orig_nents = 1;
+	sg_init_one(scmd->sdb.table.sgl, dma_buffer,
+		 cmd_desc->data_length);
+	init_completion(&adapter->driver_cmds.driver_scsiio_cmd.done);
+	if (leapraid_queuecommand(adapter->shost, scmd)) {
+		adapter->driver_cmds.driver_scsiio_cmd.status
+			 &= ~LEAPRAID_CMD_PENDING;
+		complete(&adapter->driver_cmds.driver_scsiio_cmd.done);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	wait_for_completion_timeout(
+		&adapter->driver_cmds.driver_scsiio_cmd.done,
+			 cmd_desc->time_out * HZ);
+
+
+	if (!(adapter->driver_cmds.driver_scsiio_cmd.status
+			 & LEAPRAID_CMD_DONE)) {
+		issue_reset =
+			 leapraid_check_reset(
+				adapter->driver_cmds.driver_scsiio_cmd.status);
+		rc = -ENODATA;
+		goto reset;
+	}
+
+	rc = adapter->driver_cmds.internal_scmd->result;
+	if (!rc && cmd_desc->dir == DMA_FROM_DEVICE)
+		memcpy(cmd_desc->data_buffer, dma_buffer,
+				 cmd_desc->data_length);
+
+reset:
+	if (issue_reset) {
+		rc = -ENODATA;
+		dev_err(&adapter->pdev->dev,
+			 "fire tgt reset: hdl=0x%04x\n",
+			 cmd_desc->hdl);
+		leapraid_issue_locked_tm(adapter,
+			 cmd_desc->hdl, 0, 0,
+			 0,
+			 LEAPRAID_TM_TASKTYPE_TARGET_RESET,
+			 adapter->driver_cmds.driver_scsiio_cmd.taskid,
+			 LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+	}
+out:
+	if (dma_buffer)
+		dma_free_coherent(&adapter->pdev->dev,
+				 cmd_desc->data_length, dma_buffer, dma_addr);
+	adapter->driver_cmds.driver_scsiio_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	return rc;
+}
+
+static int
+leapraid_dispatch_logsense(struct leapraid_adapter *adapter,
+		 u16 hdl, u32 lun)
+{
+	struct leapraid_scsi_cmd_desc *desc;
+	int rc = 0;
+
+	desc = kzalloc(sizeof(struct leapraid_scsi_cmd_desc),
+		 GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->hdl = hdl;
+	desc->lun = lun;
+	desc->data_length = 16;
+	desc->dir = DMA_FROM_DEVICE;
+	desc->cdb_length = 10;
+	desc->cdb[0] = LOG_SENSE;
+	desc->cdb[2] = 0x6F;
+	desc->cdb[8] = desc->data_length;
+	desc->raid_member = false;
+	desc->time_out = 5;
+
+	desc->data_buffer = kzalloc(desc->data_length, GFP_KERNEL);
+	if (!desc->data_buffer) {
+		kfree(desc);
+		return -ENOMEM;
+	}
+
+	rc = leapraid_dispatch_scsi_io(adapter, desc);
+	if (!rc) {
+		if (((char *)desc->data_buffer)[8] == 0x5D)
+			leapraid_smart_fault_detect(adapter, hdl);
+	}
+
+	kfree(desc->data_buffer);
+	kfree(desc);
+
+	return rc;
+}
+
+static bool
+leapraid_smart_poll_check(struct leapraid_adapter *adapter,
+		 struct leapraid_sdev_priv *sdev_priv,
+		 u32 reset_flg)
+{
+	struct leapraid_sas_dev *sas_dev = NULL;
+
+	if (!sdev_priv || !sdev_priv->starget_priv->card_port)
+		goto out;
+
+	sas_dev = leapraid_get_sas_dev_by_addr(adapter,
+			 sdev_priv->starget_priv->sas_address,
+			 sdev_priv->starget_priv->card_port);
+	if (!sas_dev || !sas_dev->support_smart)
+		goto out;
+
+	if (reset_flg)
+		sas_dev->led_on = false;
+	else if (sas_dev->led_on)
+		goto out;
+
+	if ((sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER)
+		 || (sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME)
+		 || (sdev_priv->block))
+		goto out;
+
+	leapraid_sdev_put(sas_dev);
+	return true;
+
+out:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+	return false;
+}
+
+static void
+leapraid_sata_smart_poll_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter = container_of(work,
+		 struct leapraid_adapter,
+		 smart_poll_desc.smart_poll_work.work);
+	struct scsi_device *sdev;
+	struct leapraid_sdev_priv *sdev_priv;
+	static u32 reset_cnt;
+	bool reset_flg = false;
+
+	if (leapraid_check_adapter_is_op(adapter))
+		goto out;
+
+	reset_flg = (reset_cnt < adapter->reset_desc.reset_cnt);
+	reset_cnt = adapter->reset_desc.reset_cnt;
+
+	__shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (leapraid_smart_poll_check(adapter, sdev_priv, reset_flg))
+			leapraid_dispatch_logsense(adapter,
+					 sdev_priv->starget_priv->hdl,
+					 sdev_priv->lun);
+	}
+
+out:
+	if (adapter->smart_poll_desc.smart_poll_wq)
+		queue_delayed_work(adapter->smart_poll_desc.smart_poll_wq,
+				 &adapter->smart_poll_desc.smart_poll_work,
+				 msecs_to_jiffies(
+					LEAPRAID_SMART_POLLING_INTERVAL));
+}
+
+void
+leapraid_smart_polling_start(struct leapraid_adapter *adapter)
+{
+	if (adapter->smart_poll_desc.smart_poll_wq
+			 || !smart_poll)
+		return;
+
+	INIT_DELAYED_WORK(&adapter->smart_poll_desc.smart_poll_work,
+		 leapraid_sata_smart_poll_work);
+
+	snprintf(adapter->smart_poll_desc.smart_poll_wq_name,
+			 sizeof(adapter->smart_poll_desc.smart_poll_wq_name),
+			 "poll_%s%u_smart_poll",
+			 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->smart_poll_desc.smart_poll_wq
+		 = create_singlethread_workqueue(
+			adapter->smart_poll_desc.smart_poll_wq_name);
+	if (!adapter->smart_poll_desc.smart_poll_wq)
+		return;
+	queue_delayed_work(adapter->smart_poll_desc.smart_poll_wq,
+			 &adapter->smart_poll_desc.smart_poll_work,
+			 msecs_to_jiffies(LEAPRAID_SMART_POLLING_INTERVAL));
+}
+
+void
+leapraid_smart_polling_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+
+	if (!adapter->smart_poll_desc.smart_poll_wq)
+		return;
+
+	wq = adapter->smart_poll_desc.smart_poll_wq;
+	adapter->smart_poll_desc.smart_poll_wq = NULL;
+
+	if (wq) {
+		if (!cancel_delayed_work_sync(
+			&adapter->smart_poll_desc.smart_poll_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
+static void
+leapraid_fw_work(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt);
+
+static void
+leapraid_fw_evt_free(struct kref *r)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+
+	fw_evt = container_of(r, struct leapraid_fw_evt_work,
+		 refcnt);
+
+	kfree(fw_evt->evt_data);
+	kfree(fw_evt);
+}
+
+static void
+leapraid_fw_evt_get(struct leapraid_fw_evt_work *fw_evt)
+{
+	kref_get(&fw_evt->refcnt);
+}
+
+static void
+leapraid_fw_evt_put(struct leapraid_fw_evt_work *fw_work)
+{
+	kref_put(&fw_work->refcnt, leapraid_fw_evt_free);
+}
+
+static struct leapraid_fw_evt_work *
+leapraid_alloc_fw_evt_work(void)
+{
+	struct leapraid_fw_evt_work *fw_evt
+		 = kzalloc(sizeof(struct leapraid_fw_evt_work), GFP_ATOMIC);
+	if (!fw_evt)
+		return NULL;
+
+	kref_init(&fw_evt->refcnt);
+	return fw_evt;
+}
+
+static void
+leapraid_run_fw_evt_work(struct work_struct *work)
+{
+	struct leapraid_fw_evt_work *fw_evt
+		 = container_of(work, struct leapraid_fw_evt_work,
+				 work);
+
+	leapraid_fw_work(fw_evt->adapter, fw_evt);
+}
+
+static void
+leapraid_fw_evt_add(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	unsigned long flags;
+
+	if (adapter->fw_evt_s.fw_evt_thread == NULL)
+		return;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock,
+			 flags);
+	leapraid_fw_evt_get(fw_evt);
+	INIT_LIST_HEAD(&fw_evt->list);
+	list_add_tail(&fw_evt->list,
+			 &adapter->fw_evt_s.fw_evt_list);
+	INIT_WORK(&fw_evt->work, leapraid_run_fw_evt_work);
+	leapraid_fw_evt_get(fw_evt);
+	queue_work(adapter->fw_evt_s.fw_evt_thread, &fw_evt->work);
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock,
+			 flags);
+}
+
+static void
+leapraid_del_fw_evt_from_list(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+	if (!list_empty(&fw_evt->list)) {
+		list_del_init(&fw_evt->list);
+		leapraid_fw_evt_put(fw_evt);
+	}
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+}
+
+static struct leapraid_fw_evt_work *
+leapraid_next_fw_evt(struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_evt = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+	if (!list_empty(&adapter->fw_evt_s.fw_evt_list)) {
+		fw_evt = list_first_entry(&adapter->fw_evt_s.fw_evt_list,
+			 struct leapraid_fw_evt_work, list);
+		list_del_init(&fw_evt->list);
+		leapraid_fw_evt_put(fw_evt);
+	}
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+	return fw_evt;
+}
+
+void
+leapraid_clean_active_fw_evt(struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+	bool rc = false;
+
+	if ((list_empty(&adapter->fw_evt_s.fw_evt_list)
+		 && !adapter->fw_evt_s.cur_evt)
+		 || !adapter->fw_evt_s.fw_evt_thread)
+		return;
+
+	adapter->fw_evt_s.fw_evt_cleanup = 1;
+	if (adapter->access_ctrl.shost_recovering
+		 && adapter->fw_evt_s.cur_evt)
+		adapter->fw_evt_s.cur_evt->ignore = 1;
+
+	while ((fw_evt = leapraid_next_fw_evt(adapter))
+		 || (fw_evt = adapter->fw_evt_s.cur_evt)) {
+		if (fw_evt == adapter->fw_evt_s.cur_evt
+			 && (adapter->fw_evt_s.cur_evt->evt_type
+				 != LEAPRAID_EVT_REMOVE_DEAD_DEV)) {
+			adapter->fw_evt_s.cur_evt = NULL;
+			continue;
+		}
+
+		rc = cancel_work_sync(&fw_evt->work);
+
+		if (rc)
+			leapraid_fw_evt_put(fw_evt);
+	}
+	adapter->fw_evt_s.fw_evt_cleanup = 0;
+}
+
+static void
+leapraid_internal_dev_ublk(struct scsi_device *sdev,
+	 struct leapraid_sdev_priv *sdev_priv)
+{
+	int rc = 0;
+
+	sdev_printk(KERN_WARNING, sdev,
+		 "hdl 0x%04x: now internal unblkg dev\n",
+		 sdev_priv->starget_priv->hdl);
+	sdev_priv->block = false;
+	rc = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+	if (rc == -EINVAL) {
+		sdev_printk(KERN_WARNING, sdev,
+			 "hdl 0x%04x: unblkg failed, rc=%d\n",
+			 sdev_priv->starget_priv->hdl, rc);
+		sdev_priv->block = true;
+		rc = scsi_internal_device_block_nowait(sdev);
+		if (rc)
+			sdev_printk(KERN_WARNING, sdev,
+				 "hdl 0x%04x: blkg failed: earlier unblkg err, rc=%d\n",
+				 sdev_priv->starget_priv->hdl, rc);
+
+		sdev_priv->block = false;
+		rc = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+		if (rc)
+			sdev_printk(KERN_WARNING, sdev,
+				 "hdl 0x%04x: ublkg failed again, rc=%d\n",
+				 sdev_priv->starget_priv->hdl, rc);
+	}
+}
+
+static void
+leapraid_internal_ublk_io_dev_to_running(struct scsi_device *sdev)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+
+	sdev_priv = sdev->hostdata;
+	sdev_priv->block = false;
+	scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+	sdev_printk(KERN_WARNING, sdev,
+		 "%s: ublk hdl 0x%04x\n",
+		 __func__, sdev_priv->starget_priv->hdl);
+}
+
+static void
+leapraid_ublk_io_dev_to_running(struct leapraid_adapter *adapter,
+	 u64 sas_addr, struct leapraid_card_port *card_port)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->sas_address != sas_addr
+			 || sdev_priv->starget_priv->card_port != card_port)
+			continue;
+
+		if (sdev_priv->block)
+			leapraid_internal_ublk_io_dev_to_running(sdev);
+	}
+}
+
+static void
+leapraid_ublk_io_dev(struct leapraid_adapter *adapter,
+	 u64 sas_addr, struct leapraid_card_port *card_port)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv || !sdev_priv->starget_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->sas_address
+			 != sas_addr)
+			continue;
+
+		if (sdev_priv->starget_priv->card_port
+			 != card_port)
+			continue;
+
+		if (sdev_priv->block)
+			leapraid_internal_dev_ublk(sdev, sdev_priv);
+
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+	}
+}
+
+static void
+leapraid_ublk_io_all_dev(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_starget_priv *stgt_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+
+		if (!sdev_priv)
+			continue;
+
+		stgt_priv = sdev_priv->starget_priv;
+		if (!stgt_priv || stgt_priv->deleted)
+			continue;
+
+		if (!sdev_priv->block)
+			continue;
+
+		sdev_printk(KERN_WARNING, sdev,
+			 "hdl 0x%04x: blkg...\n",
+			 sdev_priv->starget_priv->hdl);
+		leapraid_internal_dev_ublk(sdev, sdev_priv);
+		continue;
+	}
+}
+
+static void __maybe_unused
+leapraid_internal_dev_blk(struct scsi_device *sdev,
+	 struct leapraid_sdev_priv *sdev_priv)
+{
+	int rc = 0;
+
+	sdev_printk(KERN_INFO, sdev,
+		 "internal blkg hdl 0x%04x\n",
+		 sdev_priv->starget_priv->hdl);
+	sdev_priv->block = true;
+	rc = scsi_internal_device_block_nowait(sdev);
+	if (rc == -EINVAL)
+		sdev_printk(KERN_WARNING, sdev,
+			 "hdl 0x%04x: blkg failed, rc=%d\n",
+			 rc, sdev_priv->starget_priv->hdl);
+}
+
+
+static void __maybe_unused
+leapraid_blkio_dev(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_device *sdev;
+
+	sas_dev = leapraid_get_sas_dev_by_hdl(adapter, hdl);
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->hdl != hdl)
+			continue;
+
+		if (sdev_priv->block)
+			continue;
+
+		if (sas_dev && sas_dev->pend_sas_rphy_add)
+			continue;
+
+		if (sdev_priv->sep) {
+			sdev_printk(KERN_INFO, sdev,
+				 "sep hdl 0x%04x skip blkg\n",
+				 sdev_priv->starget_priv->hdl);
+			continue;
+		}
+
+		leapraid_internal_dev_blk(sdev, sdev_priv);
+	}
+
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+
+
+static void
+leapraid_imm_blkio_to_end_dev(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev =
+		 leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+			 sas_port->remote_identify.sas_address,
+			 sas_port->card_port);
+
+	if (sas_dev) {
+		shost_for_each_device(sdev, adapter->shost) {
+			sdev_priv = sdev->hostdata;
+			if (!sdev_priv)
+				continue;
+
+			if (sdev_priv->starget_priv->hdl != sas_dev->hdl)
+				continue;
+
+			if (sdev_priv->block)
+				continue;
+
+			if (sas_dev && sas_dev->pend_sas_rphy_add)
+				continue;
+
+			if (sdev_priv->sep) {
+				sdev_printk(KERN_INFO, sdev,
+					 "%s skip dev blk for sep hdl 0x%04x\n",
+					 __func__,
+					 sdev_priv->starget_priv->hdl);
+				continue;
+			}
+
+			leapraid_internal_dev_blk(sdev, sdev_priv);
+		}
+
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void
+leapraid_imm_blkio_set_end_dev_blk_hdls(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_sas_port *sas_port;
+
+	list_for_each_entry(sas_port,
+		 &topo_node_exp->sas_port_list, port_list) {
+		if (sas_port->remote_identify.device_type ==
+			 SAS_END_DEVICE) {
+			leapraid_imm_blkio_to_end_dev(adapter, sas_port);
+		}
+	}
+}
+
+static void
+leapraid_imm_blkio_to_kids_attchd_to_ex(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp);
+
+static void
+leapraid_imm_blkio_to_sib_exp(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_topo_node *topo_node_exp_sib;
+	struct leapraid_sas_port *sas_port;
+
+	list_for_each_entry(sas_port,
+			 &topo_node_exp->sas_port_list, port_list) {
+		if (sas_port->remote_identify.device_type ==
+			 SAS_EDGE_EXPANDER_DEVICE ||
+			 sas_port->remote_identify.device_type ==
+			 SAS_FANOUT_EXPANDER_DEVICE) {
+			topo_node_exp_sib =
+				 leapraid_exp_find_by_sas_address(adapter,
+					 sas_port->remote_identify.sas_address,
+					 sas_port->card_port);
+			leapraid_imm_blkio_to_kids_attchd_to_ex(adapter,
+					 topo_node_exp_sib);
+		}
+	}
+}
+
+static void
+leapraid_imm_blkio_to_kids_attchd_to_ex(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp)
+{
+	if (!topo_node_exp)
+		return;
+
+	leapraid_imm_blkio_set_end_dev_blk_hdls(adapter, topo_node_exp);
+
+	leapraid_imm_blkio_to_sib_exp(adapter, topo_node_exp);
+}
+
+static void
+leapraid_report_sdev_directly(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev)
+{
+	struct leapraid_sas_port *sas_port;
+
+	sas_port = leapraid_transport_port_add(adapter, sas_dev->hdl,
+		 sas_dev->parent_sas_addr, sas_dev->card_port);
+	if (!sas_port) {
+		leapraid_sas_dev_remove(adapter, sas_dev);
+		return;
+	}
+
+	if (!sas_dev->starget) {
+		if (!adapter->scan_dev_desc.driver_loading) {
+			leapraid_transport_port_remove(adapter,
+				 sas_dev->sas_addr,
+				 sas_dev->parent_sas_addr, sas_dev->card_port);
+			leapraid_sas_dev_remove(adapter, sas_dev);
+		}
+		return;
+	}
+
+	clear_bit(sas_dev->hdl,
+		 (unsigned long *)adapter->dev_topo.pending_dev_add);
+}
+
+static struct leapraid_sas_dev*
+leapraid_init_sas_dev(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev_p0 *sas_dev_pg0,
+	 struct leapraid_card_port *card_port, u16 hdl,
+	 u64 parent_sas_addr, u64 sas_addr, u32 dev_info)
+{
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_enc_node *enc_dev;
+
+	sas_dev = kzalloc(sizeof(struct leapraid_sas_dev),
+		 GFP_KERNEL);
+	if (!sas_dev)
+		return NULL;
+
+	kref_init(&sas_dev->refcnt);
+	sas_dev->hdl = hdl;
+	sas_dev->dev_info = dev_info;
+	sas_dev->sas_addr = sas_addr;
+	sas_dev->card_port = card_port;
+	sas_dev->parent_sas_addr = parent_sas_addr;
+	sas_dev->phy = sas_dev_pg0->phy_num;
+	sas_dev->enc_hdl = le16_to_cpu(sas_dev_pg0->enc_hdl);
+	sas_dev->dev_name = le64_to_cpu(sas_dev_pg0->dev_name);
+	sas_dev->port_type = sas_dev_pg0->max_port_connections;
+	sas_dev->slot = sas_dev->enc_hdl ?
+		 le16_to_cpu(sas_dev_pg0->slot) : 0;
+	sas_dev->support_smart = (le16_to_cpu(sas_dev_pg0->flg)
+		 & LEAPRAID_SAS_DEV_P0_FLG_SATA_SMART);
+	if (le16_to_cpu(sas_dev_pg0->flg)
+		 & LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID) {
+		sas_dev->enc_level = sas_dev_pg0->enc_level;
+		memcpy(sas_dev->connector_name,
+			 sas_dev_pg0->connector_name, 4);
+		sas_dev->connector_name[4] = '\0';
+	} else {
+		sas_dev->enc_level = 0;
+		sas_dev->connector_name[0] = '\0';
+	}
+	if (le16_to_cpu(sas_dev_pg0->enc_hdl)) {
+		enc_dev = leapraid_enc_find_by_hdl(adapter,
+			 le16_to_cpu(sas_dev_pg0->enc_hdl));
+		sas_dev->enc_lid = enc_dev ?
+			 le64_to_cpu(enc_dev->pg0.enc_lid) : 0;
+	}
+	dev_info(&adapter->pdev->dev,
+		 "add dev: hdl=0x%0x, sas addr=0x%016llx, port_type=0x%0x\n",
+		 hdl, sas_dev->sas_addr, sas_dev->port_type);
+
+	return sas_dev;
+}
+
+static void
+leapraid_add_dev(struct leapraid_adapter *adapter, u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_pg0;
+	struct leapraid_card_port *card_port;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u64 parent_sas_addr;
+	u32 dev_info;
+	u64 sas_addr;
+	u8 port_id;
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if ((leapraid_op_config_page(adapter, &sas_dev_pg0,
+		 cfgp1, cfgp2, GET_SAS_DEVICE_PG0)))
+		return;
+
+	dev_info = le32_to_cpu(sas_dev_pg0.dev_info);
+	if (!(leapraid_is_end_dev(dev_info)))
+		return;
+
+	set_bit(hdl, (unsigned long *)adapter->dev_topo.pending_dev_add);
+	sas_addr = le64_to_cpu(sas_dev_pg0.sas_address);
+	if (!(le16_to_cpu(sas_dev_pg0.flg)
+		 & LEAPRAID_SAS_DEV_P0_FLG_DEV_PRESENT))
+		return;
+
+	port_id = sas_dev_pg0.physical_port;
+	card_port = leapraid_get_port_by_id(adapter, port_id, false);
+	if (!card_port)
+		return;
+
+	sas_dev = leapraid_get_sas_dev_by_addr(adapter, sas_addr,
+		 card_port);
+	if (sas_dev) {
+		clear_bit(hdl,
+			 (unsigned long *)adapter->dev_topo.pending_dev_add);
+		leapraid_sdev_put(sas_dev);
+		return;
+	}
+
+	if (leapraid_get_sas_address(adapter,
+		 le16_to_cpu(sas_dev_pg0.parent_dev_hdl), &parent_sas_addr))
+		return;
+
+	sas_dev = leapraid_init_sas_dev(adapter, &sas_dev_pg0, card_port,
+		 hdl, parent_sas_addr, sas_addr, dev_info);
+	if (!sas_dev)
+		return;
+	if (adapter->scan_dev_desc.wait_scan_dev_done) {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_sdev_get(sas_dev);
+		list_add_tail(&sas_dev->list,
+			 &adapter->dev_topo.sas_dev_init_list);
+		leapraid_check_boot_dev(adapter, sas_dev, 0);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	} else {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_sdev_get(sas_dev);
+		list_add_tail(&sas_dev->list, &adapter->dev_topo.sas_dev_list);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_report_sdev_directly(adapter, sas_dev);
+	}
+}
+
+static void
+leapraid_remove_device(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	if (sas_dev->led_on) {
+		leapraid_set_led(adapter, sas_dev, false);
+		sas_dev->led_on = false;
+	}
+
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = true;
+		leapraid_ublk_io_dev(adapter,
+			 sas_dev->sas_addr, sas_dev->card_port);
+		starget_priv->hdl = LEAPRAID_INVALID_DEV_HANDLE;
+	}
+
+	leapraid_transport_port_remove(adapter,
+		 sas_dev->sas_addr, sas_dev->parent_sas_addr,
+		 sas_dev->card_port);
+
+	dev_info(&adapter->pdev->dev,
+		 "remove dev: hdl=0x%04x, sas addr=0x%016llx\n",
+		 sas_dev->hdl, (unsigned long long)sas_dev->sas_addr);
+}
+
+static struct leapraid_vphy *
+leapraid_alloc_vphy(struct leapraid_adapter *adapter,
+	 u8 port_id, u8 phy_num)
+{
+	struct leapraid_card_port *port;
+	struct leapraid_vphy *vphy;
+
+	port = leapraid_get_port_by_id(adapter, port_id, false);
+	if (!port)
+		return NULL;
+
+	vphy = leapraid_get_vphy_by_phy(port, phy_num);
+	if (vphy)
+		return vphy;
+
+	vphy = kzalloc(sizeof(struct leapraid_vphy),
+		GFP_KERNEL);
+	if (!vphy)
+		return NULL;
+
+	if (!port->vphys_mask)
+		INIT_LIST_HEAD(&port->vphys_list);
+
+	port->vphys_mask |= BIT(phy_num);
+	vphy->phy_mask |= BIT(phy_num);
+	list_add_tail(&vphy->list, &port->vphys_list);
+	return vphy;
+}
+
+static int
+leapraid_add_port_to_card_port_list(struct leapraid_adapter *adapter,
+	 u8 port_id, bool refresh)
+{
+	struct leapraid_card_port *card_port;
+
+	card_port = leapraid_get_port_by_id(adapter,
+		 port_id, false);
+	if (card_port)
+		return 0;
+
+	card_port = kzalloc(sizeof(struct leapraid_card_port),
+		 GFP_KERNEL);
+	if (!card_port)
+		return -ENOMEM;
+
+	card_port->port_id = port_id;
+	dev_info(&adapter->pdev->dev,
+		 "port: %d is added to card_port list\n",
+		 card_port->port_id);
+
+	if (refresh)
+		if (adapter->access_ctrl.shost_recovering)
+			card_port->flg = LEAPRAID_CARD_PORT_FLG_NEW;
+	list_add_tail(&card_port->list,
+		 &adapter->dev_topo.card_port_list);
+	return 0;
+}
+
+static void
+leapraid_sas_host_add(struct leapraid_adapter *adapter, bool refresh)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_phy_p0 phy_pg0;
+	struct leapraid_sas_dev_p0 sas_dev_pg0;
+	struct leapraid_enc_p0 enc_pg0;
+	struct leapraid_sas_io_unit_p0 *sas_iou_pg0;
+	u16 sas_iou_pg0_sz;
+	u16 attached_hdl;
+	u8 phys_num;
+	u8 port_id;
+	u8 link_rate;
+	int i;
+
+	if (!refresh) {
+		if (leapraid_get_adapter_phys(adapter,
+			 &phys_num) || !phys_num)
+			return;
+
+		adapter->dev_topo.card.card_phy = kcalloc(phys_num,
+			 sizeof(struct leapraid_card_phy), GFP_KERNEL);
+		if (!adapter->dev_topo.card.card_phy)
+			return;
+
+		adapter->dev_topo.card.phys_num = phys_num;
+	}
+
+	sas_iou_pg0_sz = offsetof(struct leapraid_sas_io_unit_p0, phy_info) +
+		 (adapter->dev_topo.card.phys_num *
+		 sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iou_pg0 = kzalloc(sas_iou_pg0_sz, GFP_KERNEL);
+	if (!sas_iou_pg0)
+		goto out;
+
+	if (leapraid_get_sas_io_unit_page0(adapter,
+		 sas_iou_pg0, sas_iou_pg0_sz))
+		goto out;
+
+	adapter->dev_topo.card.parent_dev = &adapter->shost->shost_gendev;
+	adapter->dev_topo.card.hdl = le16_to_cpu(
+		sas_iou_pg0->phy_info[0].controller_dev_hdl);
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if (!refresh) { /* add */
+			cfgp1.phy_number = i;
+			if (leapraid_op_config_page(adapter, &phy_pg0,
+				 cfgp1, cfgp2, GET_PHY_PG0))
+				goto out;
+
+			port_id = sas_iou_pg0->phy_info[i].port;
+			if (leapraid_add_port_to_card_port_list(adapter,
+				 port_id, false))
+				goto out;
+
+			if ((le32_to_cpu(phy_pg0.phy_info) &
+				 LEAPRAID_SAS_PHYINFO_VPHY)
+				 && (phy_pg0.neg_link_rate >> 4) >=
+					 LEAPRAID_SAS_NEG_LINK_RATE_1_5) {
+				if (!leapraid_alloc_vphy(adapter,
+						 port_id, i))
+					goto out;
+				adapter->dev_topo.card.card_phy[i].vphy
+					 = true;
+			}
+
+			adapter->dev_topo.card.card_phy[i].hdl
+				 = adapter->dev_topo.card.hdl;
+			adapter->dev_topo.card.card_phy[i].phy_id = i;
+			adapter->dev_topo.card.card_phy[i].card_port
+				 = leapraid_get_port_by_id(adapter,
+					 port_id, false);
+			leapraid_transport_add_card_phy(adapter,
+				 &adapter->dev_topo.card.card_phy[i],
+				 &phy_pg0, adapter->dev_topo.card.parent_dev);
+		} else { /* refresh */
+			link_rate = sas_iou_pg0->phy_info[i].neg_link_rate >>
+				 4;
+			port_id = sas_iou_pg0->phy_info[i].port;
+			if (leapraid_add_port_to_card_port_list(adapter,
+				 port_id, true))
+				goto out;
+
+			if (le32_to_cpu(
+				sas_iou_pg0->phy_info[i].controller_phy_dev_info)
+				 & LEAPRAID_DEVTYP_SEP && (link_rate
+				 >= LEAPRAID_SAS_NEG_LINK_RATE_1_5)) {
+				cfgp1.phy_number = i;
+				if ((leapraid_op_config_page(adapter,
+					 &phy_pg0, cfgp1, cfgp2, GET_PHY_PG0)))
+					continue;
+
+				if ((le32_to_cpu(phy_pg0.phy_info)
+					 & LEAPRAID_SAS_PHYINFO_VPHY)) {
+					if (!leapraid_alloc_vphy(adapter, port_id, i))
+						goto out;
+					adapter->dev_topo.card.card_phy[i].vphy = true;
+				}
+			}
+
+			adapter->dev_topo.card.card_phy[i].hdl
+				 = adapter->dev_topo.card.hdl;
+			attached_hdl =
+				 le16_to_cpu(
+					sas_iou_pg0->phy_info[i].attached_dev_hdl);
+			if (attached_hdl && link_rate
+					 < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+				link_rate = LEAPRAID_SAS_NEG_LINK_RATE_1_5;
+
+			adapter->dev_topo.card.card_phy[i].card_port =
+				 leapraid_get_port_by_id(
+					adapter, port_id, false);
+			if (!adapter->dev_topo.card.card_phy[i].phy) {
+				cfgp1.phy_number = i;
+				if ((leapraid_op_config_page(adapter, &phy_pg0,
+					 cfgp1, cfgp2, GET_PHY_PG0)))
+					continue;
+
+				adapter->dev_topo.card.card_phy[i].phy_id = i;
+				leapraid_transport_add_card_phy(adapter,
+					 &adapter->dev_topo.card.card_phy[i],
+					 &phy_pg0,
+					 adapter->dev_topo.card.parent_dev);
+				continue;
+			}
+
+			leapraid_transport_update_links(adapter,
+				 adapter->dev_topo.card.sas_address,
+				 attached_hdl, i, link_rate,
+				 adapter->dev_topo.card.card_phy[i].card_port);
+		}
+	}
+
+	if (!refresh) {
+		cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+		cfgp2.handle = adapter->dev_topo.card.hdl;
+		if ((leapraid_op_config_page(adapter, &sas_dev_pg0,
+			 cfgp1, cfgp2, GET_SAS_DEVICE_PG0)))
+			goto out;
+
+		adapter->dev_topo.card.enc_hdl =
+			 le16_to_cpu(sas_dev_pg0.enc_hdl);
+		adapter->dev_topo.card.sas_address =
+			 le64_to_cpu(sas_dev_pg0.sas_address);
+		dev_info(&adapter->pdev->dev,
+			 "add host: devhdl=0x%04x, sas addr=0x%016llx, phynums=%d\n",
+			 adapter->dev_topo.card.hdl,
+			 (unsigned long long)adapter->dev_topo.card.sas_address,
+			 adapter->dev_topo.card.phys_num);
+
+		if (adapter->dev_topo.card.enc_hdl) {
+			cfgp1.form = LEAPRAID_SAS_ENC_CFG_PGAD_HDL;
+			cfgp2.handle = adapter->dev_topo.card.enc_hdl;
+			if (!(leapraid_op_config_page(adapter, &enc_pg0,
+				 cfgp1, cfgp2, GET_SAS_ENCLOSURE_PG0)))
+				adapter->dev_topo.card.enc_lid
+					 = le64_to_cpu(enc_pg0.enc_lid);
+		}
+	}
+out:
+	kfree(sas_iou_pg0);
+}
+
+static int
+leapraid_internal_exp_add(struct leapraid_adapter *adapter,
+	 struct leapraid_exp_p0 *exp_pg0,
+	 union cfg_param_1 *cfgp1,
+	 union cfg_param_2 *cfgp2,
+	 u16 hdl)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_sas_port *sas_port = NULL;
+	struct leapraid_enc_node *enc_dev;
+	struct leapraid_exp_p1 exp_pg1;
+	int rc = 0;
+	unsigned long flags;
+	u8 port_id;
+	u16 parent_handle;
+	u64 sas_addr_parent = 0;
+	int i;
+
+	port_id = exp_pg0->physical_port;
+	parent_handle = le16_to_cpu(exp_pg0->parent_dev_hdl);
+
+	if (leapraid_get_sas_address(adapter,
+		 parent_handle, &sas_addr_parent)
+		 != 0)
+		return -1;
+
+	topo_node_exp = kzalloc(
+		sizeof(struct leapraid_topo_node), GFP_KERNEL);
+	if (!topo_node_exp)
+		return -1;
+
+	topo_node_exp->hdl = hdl;
+	topo_node_exp->phys_num = exp_pg0->phy_num;
+	topo_node_exp->sas_address_parent = sas_addr_parent;
+	topo_node_exp->sas_address
+		 = le64_to_cpu(exp_pg0->sas_address);
+	topo_node_exp->card_port =
+		 leapraid_get_port_by_id(adapter, port_id, false);
+	if (!topo_node_exp->card_port) {
+		rc = -1;
+		goto out_fail;
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "add exp: sas addr=0x%016llx, hdl=0x%04x, phdl=0x%04x, phys=%d\n",
+		 (unsigned long long)topo_node_exp->sas_address,
+		 hdl, parent_handle,
+		 topo_node_exp->phys_num);
+	if (!topo_node_exp->phys_num) {
+		rc = -1;
+		goto out_fail;
+	}
+
+	topo_node_exp->card_phy = kcalloc(topo_node_exp->phys_num,
+		 sizeof(struct leapraid_card_phy), GFP_KERNEL);
+	if (!topo_node_exp->card_phy) {
+		rc = -1;
+		goto out_fail;
+	}
+
+	INIT_LIST_HEAD(&topo_node_exp->sas_port_list);
+	sas_port = leapraid_transport_port_add(adapter, hdl,
+		 sas_addr_parent, topo_node_exp->card_port);
+	if (!sas_port) {
+		rc = -1;
+		goto out_fail;
+	}
+
+	topo_node_exp->parent_dev = &sas_port->rphy->dev;
+	topo_node_exp->rphy = sas_port->rphy;
+	for (i = 0; i < topo_node_exp->phys_num; i++) {
+		cfgp1->phy_number = i;
+		cfgp2->handle = hdl;
+		if ((leapraid_op_config_page(adapter, &exp_pg1,
+			 *cfgp1, *cfgp2, GET_SAS_EXPANDER_PG1))) {
+			rc = -1;
+			goto out_fail;
+		}
+
+		topo_node_exp->card_phy[i].hdl = hdl;
+		topo_node_exp->card_phy[i].phy_id = i;
+		topo_node_exp->card_phy[i].card_port =
+			 leapraid_get_port_by_id(adapter, port_id, false);
+		if ((leapraid_transport_add_exp_phy(adapter,
+			 &topo_node_exp->card_phy[i],
+			 &exp_pg1, topo_node_exp->parent_dev))) {
+			rc = -1;
+			goto out_fail;
+		}
+	}
+
+	if (topo_node_exp->enc_hdl) {
+		enc_dev =
+			 leapraid_enc_find_by_hdl(adapter,
+				 topo_node_exp->enc_hdl);
+		if (enc_dev)
+			topo_node_exp->enc_lid =
+				 le64_to_cpu(enc_dev->pg0.enc_lid);
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_add_tail(&topo_node_exp->list, &adapter->dev_topo.exp_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+		 flags);
+	return 0;
+
+out_fail:
+	if (sas_port)
+		leapraid_transport_port_remove(adapter,
+			 topo_node_exp->sas_address,
+			 sas_addr_parent,
+			 topo_node_exp->card_port);
+	kfree(topo_node_exp);
+	return rc;
+}
+
+static int
+leapraid_exp_add(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_exp_p0 exp_pg0;
+	u16 parent_handle;
+	u64 sas_addr, sas_addr_parent = 0;
+	unsigned long flags;
+	u8 port_id;
+	int rc = 0;
+
+	if (!hdl)
+		return -EPERM;
+
+	if (adapter->access_ctrl.shost_recovering ||
+		 adapter->access_ctrl.pcie_recovering)
+		return -EPERM;
+
+	cfgp1.form = LEAPRAID_SAS_EXP_CFD_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if ((leapraid_op_config_page(adapter, &exp_pg0,
+			 cfgp1, cfgp2, GET_SAS_EXPANDER_PG0)))
+		return -EPERM;
+
+	parent_handle = le16_to_cpu(exp_pg0.parent_dev_hdl);
+	if (leapraid_get_sas_address(adapter,
+		 parent_handle, &sas_addr_parent)
+		 != 0)
+		return -EPERM;
+
+	port_id = exp_pg0.physical_port;
+	if (sas_addr_parent != adapter->dev_topo.card.sas_address) {
+		spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+		topo_node_exp =
+			 leapraid_exp_find_by_sas_address(adapter,
+			 sas_addr_parent,
+			 leapraid_get_port_by_id(adapter, port_id, false));
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+		if (!topo_node_exp) {
+			rc = leapraid_exp_add(adapter, parent_handle);
+			if (rc != 0)
+				return rc;
+		}
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	sas_addr = le64_to_cpu(exp_pg0.sas_address);
+	topo_node_exp =
+		 leapraid_exp_find_by_sas_address(adapter, sas_addr,
+			 leapraid_get_port_by_id(adapter, port_id, false));
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (topo_node_exp)
+		return 0;
+
+	return leapraid_internal_exp_add(adapter,
+		 &exp_pg0, &cfgp1, &cfgp2, hdl);
+}
+
+static void
+leapraid_exp_node_rm(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+	unsigned long flags;
+	int port_id;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+		 &topo_node_exp->sas_port_list, port_list) {
+		if (adapter->access_ctrl.shost_recovering)
+			return;
+
+		switch (sas_port->remote_identify.device_type) {
+		case SAS_END_DEVICE:
+			leapraid_sas_dev_remove_by_sas_address(adapter,
+				 sas_port->remote_identify.sas_address,
+				 sas_port->card_port);
+			break;
+		case SAS_EDGE_EXPANDER_DEVICE:
+		case SAS_FANOUT_EXPANDER_DEVICE:
+			leapraid_exp_rm(adapter,
+				 sas_port->remote_identify.sas_address,
+				 sas_port->card_port);
+			break;
+		default:
+			break;
+		}
+	}
+
+	port_id = topo_node_exp->card_port->port_id;
+	leapraid_transport_port_remove(adapter, topo_node_exp->sas_address,
+		 topo_node_exp->sas_address_parent, topo_node_exp->card_port);
+	dev_info(&adapter->pdev->dev,
+		 "removing exp: port=%d, sas addr=0x%016llx, hdl=0x%04x\n",
+		 port_id, (unsigned long long)topo_node_exp->sas_address,
+		 topo_node_exp->hdl);
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_del(&topo_node_exp->list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+	kfree(topo_node_exp->card_phy);
+	kfree(topo_node_exp);
+}
+
+void
+leapraid_exp_rm(struct leapraid_adapter *adapter,
+	 u64 sas_addr, struct leapraid_card_port *port)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	unsigned long flags;
+
+	if (adapter->access_ctrl.shost_recovering)
+		return;
+
+	if (!port)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node_exp = leapraid_exp_find_by_sas_address(adapter,
+		 sas_addr, port);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (topo_node_exp)
+		leapraid_exp_node_rm(adapter, topo_node_exp);
+}
+
+static void
+leapraid_check_device(struct leapraid_adapter *adapter,
+	 u64 parent_sas_address, u16 handle, u8 phy_number, u8 link_rate)
+{
+	struct leapraid_sas_dev_p0 sas_device_pg0;
+	struct leapraid_sas_dev *sas_dev = NULL;
+	struct leapraid_enc_node *enclosure_dev = NULL;
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	unsigned long flags;
+	u64 sas_address;
+	struct scsi_target *starget;
+	struct leapraid_starget_priv *sas_target_priv_data;
+	u32 device_info;
+	struct leapraid_card_port *port;
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = handle;
+	if ((leapraid_op_config_page(adapter, &sas_device_pg0,
+		 cfgp1, cfgp2, GET_SAS_DEVICE_PG0)))
+		return;
+
+	if (phy_number != sas_device_pg0.phy_num)
+		return;
+
+	device_info = le32_to_cpu(sas_device_pg0.dev_info);
+	if (!(leapraid_is_end_dev(device_info)))
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_address = le64_to_cpu(sas_device_pg0.sas_address);
+	port = leapraid_get_port_by_id(adapter,
+		 sas_device_pg0.physical_port, false);
+	if (!port)
+		goto out_unlock;
+
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(
+		adapter, sas_address, port);
+	if (!sas_dev)
+		goto out_unlock;
+
+	if (unlikely(sas_dev->hdl != handle)) {
+		starget = sas_dev->starget;
+		sas_target_priv_data = starget->hostdata;
+		starget_printk(KERN_INFO, starget,
+			"hdl changed from 0x%04x to 0x%04x!\n",
+			sas_dev->hdl, handle);
+		sas_target_priv_data->hdl = handle;
+		sas_dev->hdl = handle;
+		if (le16_to_cpu(sas_device_pg0.flg) &
+			LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID) {
+			sas_dev->enc_level =
+				sas_device_pg0.enc_level;
+			memcpy(sas_dev->connector_name,
+				sas_device_pg0.connector_name, 4);
+			sas_dev->connector_name[4] = '\0';
+		} else {
+			sas_dev->enc_level = 0;
+			sas_dev->connector_name[0] = '\0';
+		}
+		sas_dev->enc_hdl =
+			le16_to_cpu(sas_device_pg0.enc_hdl);
+		enclosure_dev =
+			leapraid_enc_find_by_hdl(
+				adapter, sas_dev->enc_hdl);
+		if (enclosure_dev) {
+			sas_dev->enc_lid =
+				le64_to_cpu(enclosure_dev->pg0.enc_lid);
+		}
+	}
+
+	if (!(le16_to_cpu(sas_device_pg0.flg) &
+		 LEAPRAID_SAS_DEV_P0_FLG_DEV_PRESENT))
+		goto out_unlock;
+
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	leapraid_ublk_io_dev_to_running(adapter, sas_address, port);
+	goto out;
+
+out_unlock:
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+out:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+static int
+leapraid_internal_sas_topo_chg_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_topo_node *topo_node_exp,
+	 struct leapraid_fw_evt_work *fw_evt,
+	 u64 sas_addr, u8 max_phys)
+{
+	struct leapraid_evt_data_sas_topo_change_list *evt_data;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u8 phy_number;
+	u8 link_rate, prev_link_rate;
+	u16 reason_code;
+	u16 hdl;
+	int i;
+
+	evt_data = fw_evt->evt_data;
+	for (i = 0; i < evt_data->entry_num; i++) {
+		if (fw_evt->ignore)
+			return 0;
+
+		if (adapter->access_ctrl.host_removing
+			 || adapter->access_ctrl.pcie_recovering)
+			return 0;
+
+		phy_number = evt_data->start_phy_num + i;
+		if (phy_number >= max_phys)
+			continue;
+
+		reason_code =
+			 evt_data->phy[i].phy_status &
+				 LEAPRAID_EVT_SAS_TOPO_RC_MASK;
+
+		hdl = le16_to_cpu(evt_data->phy[i].attached_dev_hdl);
+		if (!hdl)
+			continue;
+
+		link_rate = evt_data->phy[i].link_rate >> 4;
+		prev_link_rate = evt_data->phy[i].link_rate & 0xF;
+		switch (reason_code) {
+		case LEAPRAID_EVT_SAS_TOPO_RC_PHY_CHANGED:
+			if (adapter->access_ctrl.shost_recovering)
+				break;
+
+			if (link_rate == prev_link_rate)
+				break;
+
+			leapraid_transport_update_links(adapter,
+				 sas_addr, hdl, phy_number,
+				 link_rate, card_port);
+			if (link_rate < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+				break;
+
+			leapraid_check_device(adapter, sas_addr,
+				 hdl, phy_number, link_rate);
+			spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock,
+				 flags);
+			sas_dev =
+				 leapraid_hold_lock_get_sas_dev_by_hdl(
+					adapter, hdl);
+			spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock,
+				 flags);
+			if (sas_dev) {
+				leapraid_sdev_put(sas_dev);
+				break;
+			}
+			if (!test_bit(hdl,
+				 (unsigned long *)adapter->dev_topo.pending_dev_add))
+				break;
+
+			evt_data->phy[i].phy_status &= 0xF0;
+			evt_data->phy[i].phy_status |=
+				 LEAPRAID_EVT_SAS_TOPO_RC_TARG_ADDED;
+			fallthrough;
+		case LEAPRAID_EVT_SAS_TOPO_RC_TARG_ADDED:
+			if (adapter->access_ctrl.shost_recovering)
+				break;
+			leapraid_transport_update_links(adapter,
+				 sas_addr, hdl, phy_number,
+				 link_rate, card_port);
+			if (link_rate < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+				break;
+			leapraid_add_dev(adapter, hdl);
+			break;
+		case LEAPRAID_EVT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
+			leapraid_sas_dev_remove_by_hdl(adapter, hdl);
+			break;
+		}
+	}
+
+	if ((evt_data->exp_status == LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING)
+		 && topo_node_exp)
+		leapraid_exp_rm(adapter, sas_addr, card_port);
+
+	return 0;
+}
+
+static int
+leapraid_sas_topo_chg_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_card_port *card_port;
+	struct leapraid_evt_data_sas_topo_change_list *evt_data;
+	u16 phdl;
+	u8 max_phys;
+	u64 sas_addr;
+	unsigned long flags;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.host_removing
+		 || adapter->access_ctrl.pcie_recovering)
+		return 0;
+
+	evt_data = fw_evt->evt_data;
+	leapraid_sas_host_add(adapter,
+		 adapter->dev_topo.card.phys_num);
+
+	if (fw_evt->ignore)
+		return 0;
+
+	phdl = le16_to_cpu(evt_data->exp_dev_hdl);
+	card_port = leapraid_get_port_by_id(adapter,
+		 evt_data->physical_port, false);
+	if (evt_data->exp_status == LEAPRAID_EVT_SAS_TOPO_ES_ADDED)
+		if (leapraid_exp_add(adapter, phdl) != 0)
+			return 0;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node_exp = leapraid_exp_find_by_hdl(adapter, phdl);
+	if (topo_node_exp) {
+		sas_addr = topo_node_exp->sas_address;
+		max_phys = topo_node_exp->phys_num;
+		card_port = topo_node_exp->card_port;
+	} else if (phdl < adapter->dev_topo.card.phys_num) {
+		sas_addr = adapter->dev_topo.card.sas_address;
+		max_phys = adapter->dev_topo.card.phys_num;
+	} else {
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.topo_node_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(
+		&adapter->dev_topo.topo_node_lock, flags);
+
+	return leapraid_internal_sas_topo_chg_evt(adapter,
+		 card_port, topo_node_exp, fw_evt,
+		 sas_addr, max_phys);
+}
+
+static void
+leapraid_sas_pd_add(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_sas_dev *sas_dev;
+	u64 sas_address;
+	u16 parent_hdl;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+
+	set_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls);
+	sas_dev = leapraid_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev) {
+		leapraid_sdev_put(sas_dev);
+		return;
+	}
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if ((leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1, cfgp2,
+		 GET_SAS_DEVICE_PG0)))
+		return;
+
+	parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+	if (!leapraid_get_sas_address(adapter, parent_hdl, &sas_address))
+		leapraid_transport_update_links(adapter, sas_address, hdl,
+			 sas_dev_p0.phy_num, LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+			 leapraid_get_port_by_id(adapter,
+				 sas_dev_p0.physical_port, false));
+	leapraid_add_dev(adapter, hdl);
+}
+
+static void
+leapraid_sas_pd_delete(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+	leapraid_sas_dev_remove_by_hdl(adapter, hdl);
+}
+
+
+static void
+leapraid_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
+{
+	sdev->no_uld_attach = no_uld_attach ? 1 : 0;
+	sdev_printk(KERN_INFO, sdev,
+		 "%s raid component to upper layer\n",
+		 sdev->no_uld_attach ? "hide" : "expose");
+	WARN_ON(scsi_device_reprobe(sdev));
+}
+
+static void
+leapraid_sas_pd_hide(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *starget = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u64 volume_wwid = 0;
+	u16 volume_hdl = 0;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+	leapraid_cfg_get_volume_hdl(adapter, hdl, &volume_hdl);
+	if (volume_hdl)
+		leapraid_cfg_get_volume_wwid(
+			adapter, volume_hdl, &volume_wwid);
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock,
+			 flags);
+		return;
+	}
+
+	set_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls);
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget = sas_dev->starget;
+		starget_priv = starget->hostdata;
+		starget_priv->flg |= LEAPRAID_TGT_FLG_RAID_MEMBER;
+		sas_dev->volume_hdl = volume_hdl;
+		sas_dev->volume_wwid = volume_wwid;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	if (starget)
+		starget_for_each_device(
+			starget, (void *)1, leapraid_reprobe_lun);
+}
+
+
+static void
+leapraid_sas_pd_expose(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *starget = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		return;
+	}
+
+	sas_dev->volume_hdl = 0;
+	sas_dev->volume_wwid = 0;
+	clear_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls);
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget = sas_dev->starget;
+		starget_priv = starget->hostdata;
+		starget_priv->flg &= ~LEAPRAID_TGT_FLG_RAID_MEMBER;
+		sas_dev->led_on = false;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (starget)
+		starget_for_each_device(starget,
+			 NULL, leapraid_reprobe_lun);
+}
+
+static void
+leapraid_sas_volume_add(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_raid_volume *raid_volume;
+	unsigned long flags;
+	u64 wwid;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->vol_dev_hdl);
+
+	if (leapraid_cfg_get_volume_wwid(adapter, hdl, &wwid))
+		return;
+
+	if (!wwid)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume = leapraid_raid_volume_find_by_wwid(adapter, wwid);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	if (raid_volume)
+		return;
+
+	raid_volume = kzalloc(sizeof(struct leapraid_raid_volume),
+		 GFP_KERNEL);
+	if (!raid_volume)
+		return;
+
+	raid_volume->id = adapter->dev_topo.sas_id++;
+	raid_volume->channel = RAID_CHANNEL;
+	raid_volume->hdl = hdl;
+	raid_volume->wwid = wwid;
+	leapraid_raid_volume_add(adapter, raid_volume);
+	if (!adapter->scan_dev_desc.wait_scan_dev_done) {
+		if (scsi_add_device(adapter->shost, RAID_CHANNEL,
+				 raid_volume->id, 0))
+			leapraid_raid_volume_remove(adapter, raid_volume);
+	} else {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		leapraid_check_boot_dev(adapter, raid_volume, RAID_CHANNEL);
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+			 flags);
+	}
+}
+
+static void
+leapraid_sas_volume_delete(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_raid_volume *raid_volume;
+	struct scsi_target *starget = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, hdl);
+	if (!raid_volume) {
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.raid_volume_lock, flags);
+		return;
+	}
+
+	if (raid_volume->starget) {
+		starget = raid_volume->starget;
+		starget_priv = starget->hostdata;
+		starget_priv->deleted = true;
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "delete raid volume: hdl=0x%04x, wwid=0x%016llx\n",
+		 raid_volume->hdl,
+		 (unsigned long long)raid_volume->wwid);
+	list_del(&raid_volume->list);
+	kfree(raid_volume);
+
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	if (starget)
+		scsi_remove_target(&starget->dev);
+}
+
+static void
+leapraid_sas_ir_chg_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_evt_data_ir_change *evt_data;
+
+	evt_data = fw_evt->evt_data;
+
+	switch (evt_data->reason_code) {
+	case LEAPRAID_EVT_IR_RC_VOLUME_ADD:
+		leapraid_sas_volume_add(adapter, evt_data);
+		break;
+	case LEAPRAID_EVT_IR_RC_VOLUME_DELETE:
+		leapraid_sas_volume_delete(adapter,
+			 le16_to_cpu(evt_data->vol_dev_hdl));
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_HIDDEN_TO_ADD:
+		leapraid_sas_pd_add(adapter, evt_data);
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_UNHIDDEN_TO_DELETE:
+		leapraid_sas_pd_delete(adapter, evt_data);
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_CREATED_TO_HIDE:
+		leapraid_sas_pd_hide(adapter, evt_data);
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_DELETED_TO_EXPOSE:
+		leapraid_sas_pd_expose(adapter, evt_data);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+leapraid_sas_enc_dev_stat_add_node(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_enc_node *enc_node = NULL;
+	int rc;
+
+	enc_node =
+		 kzalloc(sizeof(struct leapraid_enc_node), GFP_KERNEL);
+	if (!enc_node)
+		return;
+
+	cfgp1.form = LEAPRAID_SAS_ENC_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	rc = leapraid_op_config_page(adapter,
+			 &enc_node->pg0, cfgp1, cfgp2, GET_SAS_ENCLOSURE_PG0);
+	if (rc) {
+		kfree(enc_node);
+		return;
+	}
+	list_add_tail(&enc_node->list, &adapter->dev_topo.enc_list);
+}
+
+static void
+leapraid_sas_enc_dev_stat_del_node(struct leapraid_enc_node *enc_node)
+{
+	if (enc_node == NULL)
+		return;
+
+	list_del(&enc_node->list);
+	kfree(enc_node);
+}
+
+static void
+leapraid_sas_enc_dev_stat_chg_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_enc_node *enc_node = NULL;
+	struct leapraid_evt_data_sas_enc_dev_status_change *evt_data;
+	u16 enc_hdl;
+
+	if (adapter->access_ctrl.shost_recovering)
+		return;
+
+	evt_data = fw_evt->evt_data;
+	enc_hdl = le16_to_cpu(evt_data->enc_hdl);
+	if (enc_hdl)
+		enc_node =
+			 leapraid_enc_find_by_hdl(adapter, enc_hdl);
+	switch (evt_data->reason_code) {
+	case LEAPRAID_EVT_SAS_ENCL_RC_ADDED:
+		if (!enc_node)
+			leapraid_sas_enc_dev_stat_add_node(adapter, enc_hdl);
+		break;
+	case LEAPRAID_EVT_SAS_ENCL_RC_NOT_RESPONDING:
+		leapraid_sas_enc_dev_stat_del_node(enc_node);
+		break;
+	default:
+		break;
+	}
+}
+
+
+static void
+leapraid_remove_unresp_sas_end_dev(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev, *sas_dev_next;
+	unsigned long flags;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	list_for_each_entry_safe(sas_dev, sas_dev_next,
+		 &adapter->dev_topo.sas_dev_init_list, list) {
+		list_del_init(&sas_dev->list);
+		leapraid_sdev_put(sas_dev);
+	}
+	list_for_each_entry_safe(sas_dev, sas_dev_next,
+		 &adapter->dev_topo.sas_dev_list, list) {
+		if (!sas_dev->resp)
+			list_move_tail(&sas_dev->list, &head);
+		else
+			sas_dev->resp = false;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	list_for_each_entry_safe(sas_dev, sas_dev_next, &head, list) {
+		leapraid_remove_device(adapter, sas_dev);
+		list_del_init(&sas_dev->list);
+		leapraid_sdev_put(sas_dev);
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "unresponding sas end devices removed\n");
+}
+
+static void
+leapraid_remove_unresp_raid_volumes(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume, *raid_volume_next;
+
+	list_for_each_entry_safe(raid_volume, raid_volume_next,
+		 &adapter->dev_topo.raid_volume_list, list) {
+		if (!raid_volume->resp)
+			leapraid_sas_volume_delete(adapter, raid_volume->hdl);
+		else
+			raid_volume->resp = false;
+	}
+	dev_info(&adapter->pdev->dev,
+		 "unresponding raid volumes removed\n");
+}
+
+static void
+leapraid_remove_unresp_sas_exp(struct leapraid_adapter *adapter)
+{
+	struct leapraid_topo_node *topo_node_exp, *topo_node_exp_next;
+	unsigned long flags;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
+		 &adapter->dev_topo.exp_list, list) {
+		if (!topo_node_exp->resp)
+			list_move_tail(&topo_node_exp->list, &head);
+		else
+			topo_node_exp->resp = false;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
+		 &head, list)
+		leapraid_exp_node_rm(adapter, topo_node_exp);
+
+	dev_info(&adapter->pdev->dev,
+		 "unresponding sas expanders removed\n");
+}
+
+static void
+leapraid_remove_unresp_dev(struct leapraid_adapter *adapter)
+{
+	leapraid_remove_unresp_sas_end_dev(adapter);
+	if (adapter->adapter_attr.raid_support)
+		leapraid_remove_unresp_raid_volumes(adapter);
+	leapraid_remove_unresp_sas_exp(adapter);
+	leapraid_ublk_io_all_dev(adapter);
+}
+
+static void
+leapraid_del_dirty_vphy(struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	list_for_each_entry_safe(card_port, card_port_next,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (!card_port->vphys_mask)
+			continue;
+
+		list_for_each_entry_safe(vphy, vphy_next,
+			 &card_port->vphys_list, list) {
+
+			if (!(vphy->flg & LEAPRAID_VPHY_FLG_DIRTY))
+				continue;
+
+			card_port->vphys_mask &= ~vphy->phy_mask;
+			list_del(&vphy->list);
+			kfree(vphy);
+		}
+
+		if (!card_port->vphys_mask && !card_port->sas_address)
+			card_port->flg |= LEAPRAID_CARD_PORT_FLG_DIRTY;
+	}
+}
+
+static void
+leapraid_del_dirty_card_port(struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+
+	list_for_each_entry_safe(card_port, card_port_next,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (!(card_port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY)
+			 || card_port->flg & LEAPRAID_CARD_PORT_FLG_NEW)
+			continue;
+
+		list_del(&card_port->list);
+		kfree(card_port);
+	}
+}
+
+static void
+leapraid_update_dev_qdepth(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_device *sdev;
+	u16 qdepth;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv || !sdev_priv->starget_priv)
+			continue;
+		sas_dev = sdev_priv->starget_priv->sas_dev;
+		if (sas_dev && sas_dev->dev_info & LEAPRAID_DEVTYP_SSP_TGT)
+			qdepth = (sas_dev->port_type > 1)
+				 ? adapter->adapter_attr.wideport_max_queue_depth
+				 : adapter->adapter_attr.narrowport_max_queue_depth;
+		else if (sas_dev && sas_dev->dev_info
+				 & LEAPRAID_DEVTYP_SATA_DEV)
+			qdepth = adapter->adapter_attr.sata_max_queue_depth;
+		else
+			continue;
+
+		leapraid_adjust_sdev_queue_depth(sdev, qdepth);
+	}
+}
+
+static void
+leapraid_update_exp_links(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node_exp, u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_exp_p1 exp_p1;
+	int i;
+
+	cfgp2.handle = hdl;
+	for (i = 0; i < topo_node_exp->phys_num; i++) {
+		cfgp1.phy_number = i;
+		if ((leapraid_op_config_page(adapter, &exp_p1,
+			 cfgp1, cfgp2, GET_SAS_EXPANDER_PG1)))
+			return;
+
+		leapraid_transport_update_links(adapter,
+			 topo_node_exp->sas_address,
+			 le16_to_cpu(exp_p1.attached_dev_hdl), i,
+			 exp_p1.neg_link_rate >> 4,
+			 topo_node_exp->card_port);
+	}
+}
+
+static void
+leapraid_scan_exp_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_exp_p0 exp_p0;
+	unsigned long flags;
+	u16 hdl;
+	u8 port_id;
+
+	dev_info(&adapter->pdev->dev, "begin scanning expanders\n");
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+		 !leapraid_op_config_page(adapter, &exp_p0,
+		 cfgp1, cfgp2, GET_SAS_EXPANDER_PG0);
+		 cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(exp_p0.dev_hdl);
+		port_id = exp_p0.physical_port;
+		spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+		topo_node_exp = leapraid_exp_find_by_sas_address(adapter,
+			 le64_to_cpu(exp_p0.sas_address),
+			 leapraid_get_port_by_id(adapter, port_id, false));
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.topo_node_lock, flags);
+
+		if (topo_node_exp)
+			leapraid_update_exp_links(adapter, topo_node_exp, hdl);
+		else {
+			leapraid_exp_add(adapter, hdl);
+
+			dev_info(&adapter->pdev->dev,
+				 "add exp: hdl=0x%04x, sas addr=0x%016llx\n",
+				 hdl,
+				 (unsigned long long)le64_to_cpu(
+					exp_p0.sas_address));
+		}
+	}
+
+	dev_info(&adapter->pdev->dev, "expanders scan complete\n");
+}
+
+static void
+leapraid_scan_phy_disks_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union cfg_param_1 cfgp1_extra = {0};
+	union cfg_param_2 cfgp2_extra = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_raidpd_p0 raidpd_p0;
+	struct leapraid_sas_dev *sas_dev;
+	u8 phys_disk_num, port_id;
+	u16 hdl, parent_hdl;
+	u64 sas_addr;
+
+	dev_info(&adapter->pdev->dev, "begin scanning phys disk\n");
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (phys_disk_num = 0xFF, cfgp2.form_specific = phys_disk_num;
+		 !leapraid_op_config_page(adapter, &raidpd_p0,
+		 cfgp1, cfgp2, GET_PHY_DISK_PG0);
+		 cfgp2.form_specific = phys_disk_num) {
+		phys_disk_num = raidpd_p0.phys_disk_num;
+		hdl = le16_to_cpu(raidpd_p0.dev_hdl);
+		sas_dev = leapraid_get_sas_dev_by_hdl(adapter, hdl);
+		if (sas_dev) {
+			leapraid_sdev_put(sas_dev);
+			continue;
+		}
+
+		cfgp1_extra.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+		cfgp2_extra.handle = hdl;
+		if (leapraid_op_config_page(adapter, &sas_dev_p0,
+			 cfgp1_extra, cfgp2_extra, GET_SAS_DEVICE_PG0) != 0)
+			continue;
+
+		parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+		if (!leapraid_get_sas_address(adapter,
+				 parent_hdl, &sas_addr)) {
+			port_id = sas_dev_p0.physical_port;
+			leapraid_transport_update_links(adapter, sas_addr,
+				 hdl, sas_dev_p0.phy_num,
+				 LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+				 leapraid_get_port_by_id(
+					adapter, port_id, false));
+			set_bit(hdl,
+				 (unsigned long *)adapter->dev_topo.pd_hdls);
+
+			leapraid_add_dev(adapter, hdl);
+
+			dev_info(&adapter->pdev->dev,
+				 "add phys disk: hdl=0x%04x, sas addr=0x%016llx\n",
+				 hdl,
+				 (unsigned long long)le64_to_cpu(sas_dev_p0.sas_address));
+		}
+	}
+
+	dev_info(&adapter->pdev->dev, "phys disk scan complete\n");
+}
+
+static void
+leapraid_scan_vol_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union cfg_param_1 cfgp1_extra = {0};
+	union cfg_param_2 cfgp2_extra = {0};
+	struct leapraid_evt_data_ir_change evt_data;
+	static struct leapraid_raid_volume *raid_volume;
+	struct leapraid_raidvol_p1 *vol_p1;
+	struct leapraid_raidvol_p0 *vol_p0;
+	unsigned long flags;
+	u16 hdl;
+
+	vol_p0 = kzalloc(sizeof(*vol_p0), GFP_KERNEL);
+	if (!vol_p0)
+		return;
+
+	vol_p1 = kzalloc(sizeof(*vol_p1), GFP_KERNEL);
+	if (!vol_p1) {
+		kfree(vol_p0);
+		return;
+	}
+
+	dev_info(&adapter->pdev->dev, "begin scanning volumes\n");
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+		 !leapraid_op_config_page(adapter, vol_p1, cfgp1,
+		 cfgp2, GET_RAID_VOLUME_PG1);
+		 cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(vol_p1->dev_hdl);
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		raid_volume = leapraid_raid_volume_find_by_wwid(adapter,
+			 le64_to_cpu(vol_p1->wwid));
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+			 flags);
+		if (raid_volume)
+			continue;
+
+		cfgp1_extra.size = sizeof(struct leapraid_raidvol_p0);
+		cfgp2_extra.handle = hdl;
+		if (leapraid_op_config_page(adapter, vol_p0,
+			 cfgp1_extra, cfgp2_extra, GET_RAID_VOLUME_PG0))
+			continue;
+
+		if (vol_p0->volume_state == LEAPRAID_VOL_STATE_OPTIMAL
+			 || vol_p0->volume_state == LEAPRAID_VOL_STATE_ONLINE
+			 || vol_p0->volume_state
+				 == LEAPRAID_VOL_STATE_DEGRADED) {
+			memset(&evt_data,
+				 0,
+				 sizeof(struct leapraid_evt_data_ir_change));
+			evt_data.reason_code = LEAPRAID_EVT_IR_RC_VOLUME_ADD;
+			evt_data.vol_dev_hdl = vol_p1->dev_hdl;
+			leapraid_sas_volume_add(
+				adapter, &evt_data);
+			dev_info(&adapter->pdev->dev,
+				 "add volume: hdl=0x%04x\n",
+				 vol_p1->dev_hdl);
+		}
+	}
+
+	kfree(vol_p0);
+	kfree(vol_p1);
+
+	dev_info(&adapter->pdev->dev, "volumes scan complete\n");
+}
+
+static void
+leapraid_scan_sas_dev_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_sas_dev *sas_dev;
+	u16 hdl, parent_hdl;
+	u64 sas_address;
+	u8 port_id;
+
+	dev_info(&adapter->pdev->dev,
+		 "begin scanning sas end devices\n");
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+		 !leapraid_op_config_page(adapter, &sas_dev_p0,
+		 cfgp1, cfgp2, GET_SAS_DEVICE_PG0);
+		 cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(sas_dev_p0.dev_hdl);
+		if (!(leapraid_is_end_dev(le32_to_cpu(sas_dev_p0.dev_info))))
+			continue;
+
+		port_id = sas_dev_p0.physical_port;
+		sas_dev = leapraid_get_sas_dev_by_addr(adapter,
+			 le64_to_cpu(sas_dev_p0.sas_address),
+			 leapraid_get_port_by_id(adapter, port_id, false));
+		if (sas_dev) {
+			leapraid_sdev_put(sas_dev);
+			continue;
+		}
+
+		parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+		if (!leapraid_get_sas_address(adapter,
+				 parent_hdl, &sas_address)) {
+			leapraid_transport_update_links(adapter, sas_address,
+				 hdl, sas_dev_p0.phy_num,
+				 LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+				 leapraid_get_port_by_id(adapter,
+					 port_id, false));
+			leapraid_add_dev(adapter, hdl);
+			dev_info(&adapter->pdev->dev,
+				 "add sas dev: hdl=0x%04x, sas addr=0x%016llx\n",
+				 hdl,
+				 (unsigned long long)le64_to_cpu(sas_dev_p0.sas_address));
+		}
+	}
+
+	dev_info(&adapter->pdev->dev, "sas end devices scan complete\n");
+}
+
+static void
+leapraid_scan_all_dev_after_reset(struct leapraid_adapter *adapter)
+{
+	dev_info(&adapter->pdev->dev, "begin scanning devices\n");
+
+	leapraid_sas_host_add(adapter, adapter->dev_topo.card.phys_num);
+	leapraid_scan_exp_after_reset(adapter);
+	if (adapter->adapter_attr.raid_support) {
+		leapraid_scan_phy_disks_after_reset(adapter);
+		leapraid_scan_vol_after_reset(adapter);
+	}
+	leapraid_scan_sas_dev_after_reset(adapter);
+
+	dev_info(&adapter->pdev->dev, "devices scan complete\n");
+}
+
+static void
+leapraid_hardreset_async_logic(struct leapraid_adapter *adapter)
+{
+	leapraid_remove_unresp_dev(adapter);
+	leapraid_del_dirty_vphy(adapter);
+	leapraid_del_dirty_card_port(adapter);
+	leapraid_update_dev_qdepth(adapter);
+	leapraid_scan_all_dev_after_reset(adapter);
+
+	if (adapter->scan_dev_desc.driver_loading)
+		leapraid_scan_dev_done(adapter);
+}
+
+static int
+leapraid_send_enc_cmd(struct leapraid_adapter *adapter,
+	 struct leapraid_sep_rep *sep_rep, struct leapraid_sep_req *sep_req)
+{
+	void *req;
+	bool reset_flg = false;
+	int rc = 0;
+
+	mutex_lock(&adapter->driver_cmds.enc_cmd.mutex);
+	rc = leapraid_check_adapter_is_op(adapter);
+	if (rc)
+		goto out;
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_PENDING;
+	req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.enc_cmd.inter_taskid);
+	memset(req, 0, LEAPRAID_REQUEST_SIZE);
+	memcpy(req, sep_req, sizeof(struct leapraid_sep_req));
+	init_completion(&adapter->driver_cmds.enc_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.enc_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.enc_cmd.done,
+		 msecs_to_jiffies(10000));
+	if (!(adapter->driver_cmds.enc_cmd.status & LEAPRAID_CMD_DONE)) {
+		reset_flg
+			 = leapraid_check_reset(
+				adapter->driver_cmds.enc_cmd.status);
+		rc = -EFAULT;
+		goto do_hard_reset;
+	}
+
+	if (adapter->driver_cmds.enc_cmd.status & LEAPRAID_CMD_REPLY_VALID)
+		memcpy(sep_rep,
+			 (void *)(&adapter->driver_cmds.enc_cmd.reply),
+			 sizeof(struct leapraid_sep_rep));
+do_hard_reset:
+	if (reset_flg)
+		leapraid_hard_reset_handler(adapter, FULL_RESET);
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_NOT_USED;
+out:
+	mutex_unlock(&adapter->driver_cmds.enc_cmd.mutex);
+	return rc;
+}
+
+static void
+leapraid_set_led(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev, bool on)
+{
+	struct leapraid_sep_rep sep_rep;
+	struct leapraid_sep_req sep_req;
+
+	if (!sas_dev)
+		return;
+
+	memset(&sep_req, 0, sizeof(struct leapraid_sep_req));
+	memset(&sep_rep, 0, sizeof(struct leapraid_sep_rep));
+	sep_req.func = LEAPRAID_FUNC_SCSI_ENC_PROCESSOR;
+	sep_req.act = LEAPRAID_SEP_REQ_ACT_WRITE_STATUS;
+	if (on) {
+		sep_req.slot_status =
+			 cpu_to_le32(
+				LEAPRAID_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
+		sep_req.dev_hdl = cpu_to_le16(sas_dev->hdl);
+		sep_req.flg = LEAPRAID_SEP_REQ_FLG_DEVHDL_ADDRESS;
+		if (leapraid_send_enc_cmd(adapter,
+			 &sep_rep, &sep_req)) {
+			leapraid_sdev_put(sas_dev);
+			return;
+		}
+
+		sas_dev->led_on = true;
+		if (sep_rep.adapter_status)
+			leapraid_sdev_put(sas_dev);
+	} else {
+		sep_req.slot_status = 0;
+		sep_req.slot = cpu_to_le16(sas_dev->slot);
+		sep_req.dev_hdl = 0;
+		sep_req.enc_hdl = cpu_to_le16(sas_dev->enc_hdl);
+		sep_req.flg = LEAPRAID_SEP_REQ_FLG_ENCLOSURE_SLOT_ADDRESS;
+		if ((leapraid_send_enc_cmd(adapter,
+			 &sep_rep, &sep_req))) {
+			leapraid_sdev_put(sas_dev);
+			return;
+		}
+
+		if (sep_rep.adapter_status) {
+			leapraid_sdev_put(sas_dev);
+			return;
+		}
+	}
+}
+
+static void
+leapraid_fw_work(struct leapraid_adapter *adapter,
+	 struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	adapter->fw_evt_s.cur_evt = fw_evt;
+	leapraid_del_fw_evt_from_list(adapter, fw_evt);
+	if (adapter->access_ctrl.host_removing
+		 || adapter->access_ctrl.pcie_recovering) {
+		leapraid_fw_evt_put(fw_evt);
+		adapter->fw_evt_s.cur_evt = NULL;
+		return;
+	}
+
+	switch (fw_evt->evt_type) {
+	case LEAPRAID_EVT_SAS_DISCOVERY:
+	{
+		struct leapraid_evt_data_sas_disc *evt_data;
+
+		evt_data = fw_evt->evt_data;
+		if (evt_data->reason_code == LEAPRAID_EVT_SAS_DISC_RC_STARTED
+			 && !adapter->dev_topo.card.phys_num)
+			leapraid_sas_host_add(adapter, 0);
+		break;
+	}
+	case LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST:
+		leapraid_sas_topo_chg_evt(adapter, fw_evt);
+		break;
+	case LEAPRAID_EVT_IR_CHANGE:
+		leapraid_sas_ir_chg_evt(adapter, fw_evt);
+		break;
+	case LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE:
+		leapraid_sas_enc_dev_stat_chg_evt(adapter, fw_evt);
+		break;
+	case LEAPRAID_EVT_REMOVE_DEAD_DEV:
+		while (scsi_host_in_recovery(adapter->shost)
+			 || adapter->access_ctrl.shost_recovering) {
+			if (adapter->access_ctrl.host_removing
+				 || adapter->fw_evt_s.fw_evt_cleanup)
+				goto out;
+
+			ssleep(1);
+		}
+		leapraid_hardreset_async_logic(adapter);
+		break;
+	case LEAPRAID_EVT_TURN_ON_PFA_LED:
+		sas_dev = leapraid_get_sas_dev_by_hdl(adapter,
+			 fw_evt->dev_handle);
+		leapraid_set_led(adapter, sas_dev, true);
+		break;
+	default:
+		break;
+	}
+out:
+	leapraid_fw_evt_put(fw_evt);
+	adapter->fw_evt_s.cur_evt = NULL;
+}
+
+static void
+leapraid_sas_dev_stat_chg_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_sas_dev_status_change *event_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sas_dev *sas_dev = NULL;
+	u64 sas_address;
+	unsigned long flags;
+
+	switch (event_data->reason_code) {
+	case LEAPRAID_EVT_SAS_DEV_STAT_RC_INTERNAL_DEV_RESET:
+	case LEAPRAID_EVT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET:
+		break;
+	default:
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+
+	sas_address = le64_to_cpu(event_data->sas_address);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+		 sas_address, leapraid_get_port_by_id(adapter,
+			 event_data->physical_port, false));
+
+	if (sas_dev && sas_dev->starget) {
+		starget_priv = sas_dev->starget->hostdata;
+		if (starget_priv) {
+			switch (event_data->reason_code) {
+			case LEAPRAID_EVT_SAS_DEV_STAT_RC_INTERNAL_DEV_RESET:
+				starget_priv->tm_busy = true;
+				break;
+			case LEAPRAID_EVT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET:
+				starget_priv->tm_busy = false;
+				break;
+			}
+		}
+	}
+
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void
+leapraid_set_volume_delete_flag(struct leapraid_adapter *adapter,
+	 u16 handle)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *sas_target_priv_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, handle);
+	if (raid_volume && raid_volume->starget &&
+		raid_volume->starget->hostdata) {
+		sas_target_priv_data = raid_volume->starget->hostdata;
+		sas_target_priv_data->deleted = true;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+
+static void
+leapraid_check_ir_change_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_ir_change *evt_data)
+{
+	u16 phys_disk_dev_hdl;
+
+	switch (evt_data->reason_code) {
+	case LEAPRAID_EVT_IR_RC_VOLUME_DELETE:
+		leapraid_set_volume_delete_flag(adapter,
+			 le16_to_cpu(evt_data->vol_dev_hdl));
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_UNHIDDEN_TO_DELETE:
+		phys_disk_dev_hdl =
+			 le16_to_cpu(evt_data->phys_disk_dev_hdl);
+		clear_bit(phys_disk_dev_hdl,
+			 (unsigned long *)adapter->dev_topo.pd_hdls);
+		leapraid_tgt_rst_send(adapter, phys_disk_dev_hdl);
+		break;
+	}
+}
+
+static void
+leapraid_topo_del_evts_process_exp_status(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_sas_topo_change_list *evt_data)
+{
+	struct leapraid_fw_evt_work *fw_evt = NULL;
+	struct leapraid_evt_data_sas_topo_change_list *loc_evt_data = NULL;
+	unsigned long flags;
+	u16 exp_hdl;
+
+	exp_hdl = le16_to_cpu(evt_data->exp_dev_hdl);
+
+	switch (evt_data->exp_status) {
+	case LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING:
+		spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+		list_for_each_entry(fw_evt,
+			 &adapter->fw_evt_s.fw_evt_list, list) {
+			if (fw_evt->evt_type !=
+				 LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST ||
+				 fw_evt->ignore)
+				continue;
+
+			loc_evt_data = fw_evt->evt_data;
+			if ((loc_evt_data->exp_status ==
+				 LEAPRAID_EVT_SAS_TOPO_ES_ADDED ||
+				 loc_evt_data->exp_status ==
+				 LEAPRAID_EVT_SAS_TOPO_ES_RESPONDING) &&
+				 le16_to_cpu(loc_evt_data->exp_dev_hdl)
+					 == exp_hdl)
+				fw_evt->ignore = 1;
+		}
+		spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+leapraid_check_topo_del_evts(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_data_sas_topo_change_list *evt_data)
+{
+	int reason_code;
+	u16 hdl;
+	int i;
+
+	for (i = 0; i < evt_data->entry_num; i++) {
+		hdl = le16_to_cpu(evt_data->phy[i].attached_dev_hdl);
+		if (!hdl)
+			continue;
+
+		reason_code =
+			 evt_data->phy[i].phy_status &
+				 LEAPRAID_EVT_SAS_TOPO_RC_MASK;
+		if (reason_code ==
+			 LEAPRAID_EVT_SAS_TOPO_RC_TARG_NOT_RESPONDING)
+			leapraid_tgt_not_responding(adapter, hdl);
+	}
+	leapraid_topo_del_evts_process_exp_status(adapter,
+		 evt_data);
+}
+
+static bool
+leapraid_async_process_evt(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_notify_rep *event_notify_rep)
+{
+	u16 evt = le16_to_cpu(event_notify_rep->evt);
+	bool exitFlag = false;
+
+	switch (evt) {
+	case LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE:
+		leapraid_sas_dev_stat_chg_evt(adapter,
+			 (struct leapraid_evt_data_sas_dev_status_change
+				 *)event_notify_rep->evt_data);
+		break;
+	case LEAPRAID_EVT_IR_CHANGE:
+		leapraid_check_ir_change_evt(adapter,
+			 (struct leapraid_evt_data_ir_change
+				 *)event_notify_rep->evt_data);
+		break;
+	case LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST:
+		leapraid_check_topo_del_evts(adapter,
+			 (struct leapraid_evt_data_sas_topo_change_list
+				 *)event_notify_rep->evt_data);
+		if (adapter->access_ctrl.shost_recovering) {
+			exitFlag = true;
+			return exitFlag;
+		}
+		break;
+	case LEAPRAID_EVT_SAS_DISCOVERY:
+	case LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE:
+	default:
+		exitFlag = true;
+		return exitFlag;
+	}
+
+	return exitFlag;
+}
+
+static void
+leapraid_async_evt_cb_enqueue(struct leapraid_adapter *adapter,
+	 struct leapraid_evt_notify_rep *evt_notify_rep)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+	u16 evt_sz;
+
+	fw_evt = leapraid_alloc_fw_evt_work();
+	if (!fw_evt)
+		return;
+
+	evt_sz = le16_to_cpu(evt_notify_rep->evt_data_len) * 4;
+	fw_evt->evt_data = kmemdup(evt_notify_rep->evt_data,
+	 evt_sz, GFP_ATOMIC);
+	if (!fw_evt->evt_data) {
+		leapraid_fw_evt_put(fw_evt);
+		return;
+	}
+	fw_evt->adapter = adapter;
+	fw_evt->evt_type = le16_to_cpu(evt_notify_rep->evt);
+	leapraid_fw_evt_add(adapter, fw_evt);
+	leapraid_fw_evt_put(fw_evt);
+}
+
+static void
+leapraid_async_evt_cb(struct leapraid_adapter *adapter,
+	 u8 msix_index, u32 rep_paddr)
+{
+	struct leapraid_evt_notify_rep *evt_notify_rep;
+
+	if (adapter->access_ctrl.pcie_recovering)
+		return;
+
+	evt_notify_rep = leapraid_get_reply_vaddr(adapter, rep_paddr);
+	if (unlikely(!evt_notify_rep))
+		return;
+
+	if (leapraid_async_process_evt(adapter, evt_notify_rep))
+		return;
+
+	leapraid_async_evt_cb_enqueue(adapter, evt_notify_rep);
+}
+
+static void
+leapraid_handle_async_event(struct leapraid_adapter *adapter,
+	 u8 msix_index, u32 reply)
+{
+	struct leapraid_evt_notify_rep *leap_mpi_rep
+		 = leapraid_get_reply_vaddr(adapter, reply);
+
+	if (!leap_mpi_rep)
+		return;
+
+	if (leap_mpi_rep->func != LEAPRAID_FUNC_EVENT_NOTIFY)
+		return;
+
+	leapraid_async_evt_cb(adapter, msix_index, reply);
+}
+
+void
+leapraid_async_turn_on_led(struct leapraid_adapter *adapter,
+	 u16 handle)
+{
+	struct leapraid_fw_evt_work *fw_event;
+
+	fw_event = leapraid_alloc_fw_evt_work();
+	if (!fw_event)
+		return;
+
+	fw_event->dev_handle = handle;
+	fw_event->adapter = adapter;
+	fw_event->evt_type = LEAPRAID_EVT_TURN_ON_PFA_LED;
+	leapraid_fw_evt_add(adapter, fw_event);
+	leapraid_fw_evt_put(fw_event);
+}
+
+static void
+leapraid_hardreset_barrier(struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_event;
+
+	fw_event = leapraid_alloc_fw_evt_work();
+	if (!fw_event)
+		return;
+
+	fw_event->adapter = adapter;
+	fw_event->evt_type = LEAPRAID_EVT_REMOVE_DEAD_DEV;
+	leapraid_fw_evt_add(adapter, fw_event);
+	leapraid_fw_evt_put(fw_event);
+}
+
+
+
+static u8
+leapraid_driver_cmds_done(struct leapraid_adapter *adapter, u16 taskid,
+	 u8 msix_index, u32 rep_paddr, u8 cb_idx)
+{
+	struct leapraid_rep *leap_mpi_rep =
+		 leapraid_get_reply_vaddr(adapter, rep_paddr);
+	struct leapraid_driver_cmd *sp_cmd, *_sp_cmd = NULL;
+
+
+
+	list_for_each_entry(sp_cmd, &adapter->driver_cmds.special_cmd_list,
+		 list)
+		if (cb_idx == sp_cmd->cb_idx) {
+			_sp_cmd = sp_cmd;
+			break;
+		}
+
+	if (WARN_ON(!_sp_cmd))
+		return 1;
+	if (WARN_ON(_sp_cmd->status == LEAPRAID_CMD_NOT_USED))
+		return 1;
+	if (WARN_ON(taskid != _sp_cmd->hp_taskid
+		 && taskid != _sp_cmd->taskid
+		 && taskid != _sp_cmd->inter_taskid))
+		return 1;
+
+	_sp_cmd->status |= LEAPRAID_CMD_DONE;
+	if (leap_mpi_rep) {
+		memcpy((void *)(&_sp_cmd->reply), leap_mpi_rep,
+			 leap_mpi_rep->msg_len * 4);
+		_sp_cmd->status |= LEAPRAID_CMD_REPLY_VALID;
+
+		if (_sp_cmd->cb_idx == LEAPRAID_SCAN_DEV_CB_IDX) {
+			u16 adapter_status;
+
+			_sp_cmd->status &= ~LEAPRAID_CMD_PENDING;
+			adapter_status =
+				 le16_to_cpu(leap_mpi_rep->adapter_status)
+				 & LEAPRAID_ADAPTER_STATUS_MASK;
+			if (adapter_status !=
+				 LEAPRAID_ADAPTER_STATUS_SUCCESS)
+				adapter->scan_dev_desc.scan_dev_failed
+					 = true;
+
+			if (_sp_cmd->async_scan_dev) {
+				adapter->scan_dev_desc.scan_start = false;
+				if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
+					adapter->scan_dev_desc.scan_start_failed = adapter_status;
+				return 1;
+			}
+
+			complete(&_sp_cmd->done);
+			return 1;
+		}
+
+		if (_sp_cmd->cb_idx == LEAPRAID_CTL_CB_IDX) {
+			struct leapraid_scsiio_rep *scsiio_reply;
+
+			if (leap_mpi_rep->function == LEAPRAID_FUNC_SCSIIO_REQ
+				 || leap_mpi_rep->function
+				 == LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH) {
+				scsiio_reply =
+					 (struct leapraid_scsiio_rep *) leap_mpi_rep;
+				if (scsiio_reply->scsi_state
+					 & LEAPRAID_SCSI_STATE_AUTOSENSE_VALID)
+					memcpy((void *)(&adapter->driver_cmds.ctl_cmd.sense),
+						 leapraid_get_sense_buffer(adapter,
+							 taskid),
+						 min_t(u32,
+							 SCSI_SENSE_BUFFERSIZE,
+							 le32_to_cpu(
+								scsiio_reply->sense_count)));
+			}
+		}
+	}
+
+	_sp_cmd->status &= ~LEAPRAID_CMD_PENDING;
+	complete(&_sp_cmd->done);
+
+	return 1;
+}
+
+static void
+leapraid_request_descript_handler(struct leapraid_adapter *adapter,
+	 union leapraid_rep_desc_union *rpf, u8 req_desc_type,
+	 u8 msix_idx)
+{
+	u32 rep;
+	u16 taskid;
+
+	rep = 0;
+	taskid = le16_to_cpu(rpf->dflt_rep.taskid);
+	switch (req_desc_type) {
+	case LEAPRAID_RPY_DESC_FLG_SCSI_IO_SUCCESS:
+		if (taskid <= adapter->shost->can_queue
+				 || taskid
+					 == adapter->driver_cmds.driver_scsiio_cmd.taskid) {
+			leapraid_scsiio_done(adapter, taskid, msix_idx, 0);
+		} else {
+			if (leapraid_driver_cmds_done(
+				adapter, taskid, msix_idx,
+				 0, leapraid_get_cb_idx(adapter, taskid)))
+				leapraid_free_taskid(adapter, taskid);
+		}
+		break;
+	case LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY:
+		rep = le32_to_cpu(rpf->addr_rep.rep_frame_addr);
+		if (rep > ((u32) (adapter->mem_desc.rep_msg_dma)
+			 + adapter->adapter_attr.rep_msg_qd
+				 * LEAPRAID_REPLY_SIEZ)
+				 || rep < ((u32) (adapter->mem_desc.rep_msg_dma)))
+			rep = 0;
+		if (taskid) {
+			if (taskid <= adapter->shost->can_queue
+					 || taskid ==
+						 adapter->driver_cmds.driver_scsiio_cmd.taskid) {
+				leapraid_scsiio_done(
+					adapter, taskid, msix_idx, rep);
+			} else {
+				if (leapraid_driver_cmds_done(
+					adapter, taskid, msix_idx,
+					 rep, leapraid_get_cb_idx(
+						adapter, taskid)))
+					leapraid_free_taskid(adapter, taskid);
+			}
+		} else {
+			leapraid_handle_async_event(adapter, msix_idx, rep);
+		}
+
+		if (rep) {
+			adapter->rep_msg_host_idx = (adapter->rep_msg_host_idx
+				 == (adapter->adapter_attr.rep_msg_qd - 1)) ?
+				 0 : adapter->rep_msg_host_idx + 1;
+			adapter->mem_desc.rep_msg_addr[adapter->rep_msg_host_idx]
+				 = cpu_to_le32(rep);
+			wmb(); /* Make sure that all write ops are in order */
+			writel(adapter->rep_msg_host_idx,
+				 &adapter->iomem_base->rep_msg_host_idx);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+int
+leapraid_rep_queue_handler(struct leapraid_rq *rq)
+{
+	struct leapraid_adapter *adapter = rq->adapter;
+	union leapraid_rep_desc_union *rep_desc;
+	u8 req_desc_type;
+	u64 finish_cmds;
+	u8 msix_idx;
+
+	msix_idx = rq->msix_idx;
+	finish_cmds = 0;
+	if (!atomic_add_unless(&rq->busy, 1, 1))
+		return finish_cmds;
+
+	rep_desc = &rq->rep_desc[rq->rep_post_host_idx];
+	req_desc_type = rep_desc->dflt_rep.rep_flg
+		 & LEAPRAID_RPY_DESC_FLG_TYPE_MASK;
+	if (req_desc_type == LEAPRAID_RPY_DESC_FLG_UNUSED) {
+		atomic_dec(&rq->busy);
+		return finish_cmds;
+	}
+
+	for (;;) {
+		if (rep_desc->u.low == ~0U
+			 || rep_desc->u.high == ~0U)
+			break;
+
+		leapraid_request_descript_handler(adapter, rep_desc,
+			 req_desc_type, msix_idx);
+		rep_desc->words = cpu_to_le64(~0ULL);
+		rq->rep_post_host_idx = (rq->rep_post_host_idx
+			 == (adapter->adapter_attr.rep_desc_qd - 1)) ?
+			 0 : rq->rep_post_host_idx + 1;
+		req_desc_type =
+			 rq->rep_desc[rq->rep_post_host_idx].dflt_rep.rep_flg
+			 & LEAPRAID_RPY_DESC_FLG_TYPE_MASK;
+		finish_cmds++;
+		if (req_desc_type == LEAPRAID_RPY_DESC_FLG_UNUSED)
+			break;
+		rep_desc = rq->rep_desc + rq->rep_post_host_idx;
+	}
+
+	if (!finish_cmds) {
+		atomic_dec(&rq->busy);
+		return finish_cmds;
+	}
+
+	wmb(); /* Make sure that all write ops are in order */
+	writel(rq->rep_post_host_idx | ((msix_idx & 7) <<
+		 LEAPRAID_RPHI_MSIX_IDX_SHIFT),
+		 &adapter->iomem_base->rep_post_reg_idx[msix_idx / 8].idx);
+	atomic_dec(&rq->busy);
+	return finish_cmds;
+}
+
+static irqreturn_t
+leapraid_irq_handler(int irq, void *bus_id)
+{
+	struct leapraid_rq *rq = bus_id;
+	struct leapraid_adapter *adapter = rq->adapter;
+
+	if (adapter->mask_int)
+		return IRQ_NONE;
+
+	return ((leapraid_rep_queue_handler(rq) > 0) ?
+		 IRQ_HANDLED : IRQ_NONE);
+}
+
+void
+leapraid_sync_irqs(struct leapraid_adapter *adapter,
+	 bool poll)
+{
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	int i;
+
+	if (!adapter->notification_desc.msix_enable)
+		return;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.host_removing
+		 || adapter->access_ctrl.pcie_recovering)
+		return;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		if (adapter->access_ctrl.shost_recovering
+			|| adapter->access_ctrl.host_removing
+			|| adapter->access_ctrl.pcie_recovering)
+			return;
+
+		if (int_rq->rq.msix_idx == 0)
+			continue;
+
+		synchronize_irq(
+			pci_irq_vector(adapter->pdev, int_rq->rq.msix_idx));
+		if (poll)
+			leapraid_rep_queue_handler(&int_rq->rq);
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq
+			 = &adapter->notification_desc.blk_mq_poll_rqs[i];
+		if (adapter->access_ctrl.shost_recovering
+			|| adapter->access_ctrl.host_removing
+			|| adapter->access_ctrl.pcie_recovering)
+			return;
+
+		if (blk_mq_poll_rq->rq.msix_idx == 0)
+			continue;
+
+		leapraid_rep_queue_handler(&blk_mq_poll_rq->rq);
+	}
+}
+
+void
+leapraid_mq_polling_pause(struct leapraid_adapter *adapter)
+{
+	int iopoll_q_count =
+		 adapter->adapter_attr.rq_cnt -
+			 adapter->notification_desc.iopoll_qdex;
+	int qid;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[qid].pause,
+				 1);
+
+	for (qid = 0; qid < iopoll_q_count; qid++) {
+		while (atomic_read(
+			&adapter->notification_desc.blk_mq_poll_rqs[qid].busy)) {
+			cpu_relax();
+			udelay(500);
+		}
+	}
+}
+
+void
+leapraid_mq_polling_resume(struct leapraid_adapter *adapter)
+{
+	int iopoll_q_count = adapter->adapter_attr.rq_cnt
+		 - adapter->notification_desc.iopoll_qdex;
+	int qid;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[qid].pause,
+				 0);
+}
+
+static int
+leapraid_unlock_host_diag(struct leapraid_adapter *adapter,
+	 u32 *host_diag)
+{
+	const u32 unlock_seq[] = { 0x0, 0xF, 0x4, 0xB, 0x2, 0x7, 0xD };
+	const int max_retries = 20;
+	int retry = 0;
+	int i;
+
+	*host_diag = 0;
+	while (retry++ <= max_retries) {
+		for (i = 0; i < ARRAY_SIZE(unlock_seq); i++)
+			writel(unlock_seq[i], &adapter->iomem_base->ws);
+
+		msleep(100);
+
+		*host_diag =
+			 leapraid_readl(&adapter->iomem_base->host_diag);
+		if (*host_diag & LEAPRAID_DIAG_WRITE_ENABLE)
+			return 0;
+	}
+
+	dev_err(&adapter->pdev->dev, "try host reset timeout!\n");
+	return -EFAULT;
+}
+
+static int
+leapraid_host_diag_reset(struct leapraid_adapter *adapter)
+{
+	u32 host_diag;
+	u32 cnt;
+
+	dev_info(&adapter->pdev->dev, "entering host diag reset!\n");
+	pci_cfg_access_lock(adapter->pdev);
+
+	mutex_lock(&adapter->reset_desc.host_diag_mutex);
+	if (leapraid_unlock_host_diag(adapter, &host_diag))
+		goto out;
+
+	writel(host_diag | LEAPRAID_DIAG_RESET,
+		 &adapter->iomem_base->host_diag);
+
+	msleep(100);
+	for (cnt = 0; cnt < 10000; cnt++) {
+		host_diag = leapraid_readl(&adapter->iomem_base->host_diag);
+		if (host_diag == 0xFFFFFFFF)
+			goto out;
+
+		if (!(host_diag & LEAPRAID_DIAG_RESET))
+			break;
+
+		msleep(500);
+	}
+
+	writel(host_diag & ~LEAPRAID_DIAG_HOLD_ADAPTER_RESET,
+		 &adapter->iomem_base->host_diag);
+	writel(0x0, &adapter->iomem_base->ws);
+	mutex_unlock(&adapter->reset_desc.host_diag_mutex);
+	if (!leapraid_wait_adapter_ready(adapter))
+		goto out;
+
+	pci_cfg_access_unlock(adapter->pdev);
+	dev_info(&adapter->pdev->dev, "host diag success!\n");
+	return 0;
+out:
+	pci_cfg_access_unlock(adapter->pdev);
+	dev_info(&adapter->pdev->dev, "host diag failed!\n");
+	mutex_unlock(&adapter->reset_desc.host_diag_mutex);
+	return -EFAULT;
+}
+
+static int
+leapraid_find_matching_port(struct leapraid_card_port *card_port_table,
+	 u8 count, u8 port_id, u64 sas_addr)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (card_port_table[i].port_id == port_id
+			 && card_port_table[i].sas_address == sas_addr)
+			return i;
+	}
+	return -1;
+}
+
+static u8
+leapraid_fill_card_port_table(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_io_unit_p0 *sas_iounit_p0,
+	 struct leapraid_card_port *new_card_port_table)
+{
+	u8 port_entry_num = 0, port_id;
+	u16 attached_hdl;
+	u64 attached_sas_addr;
+	int i, idx;
+
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if ((sas_iounit_p0->phy_info[i].neg_link_rate >> 4)
+			 < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+			continue;
+
+		attached_hdl =
+			 le16_to_cpu(sas_iounit_p0->phy_info[i].attached_dev_hdl);
+		if (leapraid_get_sas_address(adapter,
+			 attached_hdl, &attached_sas_addr) != 0)
+			continue;
+
+		port_id = sas_iounit_p0->phy_info[i].port;
+
+		idx = leapraid_find_matching_port(new_card_port_table,
+			 port_entry_num, port_id, attached_sas_addr);
+		if (idx >= 0) {
+			new_card_port_table[idx].phy_mask |= BIT(i);
+		} else {
+			new_card_port_table[port_entry_num].port_id = port_id;
+			new_card_port_table[port_entry_num].phy_mask = BIT(i);
+			new_card_port_table[port_entry_num].sas_address
+				 = attached_sas_addr;
+			port_entry_num++;
+		}
+	}
+
+	return port_entry_num;
+}
+
+static u8
+leapraid_set_new_card_port_table_after_reset(
+	struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *new_card_port_table)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_io_unit_p0 *sas_iounit_p0 = NULL;
+	u8 port_entry_num = 0;
+	u16 sz;
+
+	sz = offsetof(struct leapraid_sas_io_unit_p0, phy_info)
+		 + (adapter->dev_topo.card.phys_num
+			 * sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iounit_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_p0)
+		return port_entry_num;
+
+	cfgp1.size = sz;
+	if ((leapraid_op_config_page(adapter, sas_iounit_p0,
+		 cfgp1, cfgp2, GET_SAS_IOUNIT_PG0)) != 0)
+		goto out;
+
+	port_entry_num = leapraid_fill_card_port_table(adapter,
+		 sas_iounit_p0, new_card_port_table);
+out:
+	kfree(sas_iounit_p0);
+	return port_entry_num;
+}
+
+static void
+leapraid_update_existing_port(struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *new_table,
+	 int entry_idx, int port_entry_num)
+{
+	struct leapraid_card_port *matched_card_port = NULL;
+	int matched_code;
+	int count = 0, lcount = 0;
+	u64 sas_addr;
+	int i;
+
+	matched_code = leapraid_check_card_port(
+		 adapter, &new_table[entry_idx], &matched_card_port, &count);
+
+	if (!matched_card_port)
+		return;
+
+	if (matched_code == SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS
+		 || matched_code == SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS) {
+		leapraid_add_or_del_phys_from_existing_port(adapter,
+			 matched_card_port, new_table,
+			 entry_idx, port_entry_num);
+	} else if (matched_code == SAME_ADDR_ONLY) {
+		sas_addr = new_table[entry_idx].sas_address;
+		for (i = 0; i < port_entry_num; i++) {
+			if (new_table[i].sas_address == sas_addr)
+				lcount++;
+		}
+		if ((count > 1) || (lcount > 1))
+			return;
+
+		leapraid_add_or_del_phys_from_existing_port(adapter,
+			 matched_card_port, new_table,
+			 entry_idx, port_entry_num);
+	}
+
+	if (matched_card_port->port_id != new_table[entry_idx].port_id)
+		matched_card_port->port_id = new_table[entry_idx].port_id;
+
+	matched_card_port->flg &= ~LEAPRAID_CARD_PORT_FLG_DIRTY;
+	matched_card_port->phy_mask = new_table[entry_idx].phy_mask;
+}
+
+static void
+leapraid_update_card_port_after_reset(struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *new_card_port_table;
+	struct leapraid_card_port *matched_card_port = NULL;
+	u8 port_entry_num = 0;
+	u8 nr_phys;
+	int i;
+
+	if (leapraid_get_adapter_phys(adapter, &nr_phys)
+		 || !nr_phys)
+		return;
+
+	adapter->dev_topo.card.phys_num = nr_phys;
+	new_card_port_table = kcalloc(adapter->dev_topo.card.phys_num,
+		 sizeof(struct leapraid_card_port), GFP_KERNEL);
+	if (!new_card_port_table)
+		return;
+
+	port_entry_num =
+		 leapraid_set_new_card_port_table_after_reset(adapter,
+		 new_card_port_table);
+	if (!port_entry_num)
+		return;
+
+	list_for_each_entry(matched_card_port,
+		 &adapter->dev_topo.card_port_list, list) {
+		matched_card_port->flg |= LEAPRAID_CARD_PORT_FLG_DIRTY;
+	}
+
+	matched_card_port = NULL;
+	for (i = 0; i < port_entry_num; i++)
+		leapraid_update_existing_port(adapter,
+			 new_card_port_table, i, port_entry_num);
+}
+
+static bool
+leapraid_is_valid_vphy(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_io_unit_p0 *sas_io_unit_p0,
+	 int phy_index)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_phy_p0 phy_p0;
+
+	if ((sas_io_unit_p0->phy_info[phy_index].neg_link_rate >> 4)
+		 < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+		return false;
+
+	if (!(le32_to_cpu(
+		 sas_io_unit_p0->phy_info[phy_index].controller_phy_dev_info)
+		 & LEAPRAID_DEVTYP_SEP))
+		return false;
+
+	cfgp1.phy_number = phy_index;
+	if (leapraid_op_config_page(adapter, &phy_p0,
+			 cfgp1, cfgp2, GET_PHY_PG0))
+		return false;
+
+	if (!(le32_to_cpu(phy_p0.phy_info) & LEAPRAID_SAS_PHYINFO_VPHY))
+		return false;
+
+	return true;
+}
+
+static void
+leapraid_update_vphy_binding(struct leapraid_adapter *adapter,
+	 struct leapraid_card_port *card_port, struct leapraid_vphy *vphy,
+	 int phy_index, u8 may_new_port_id, u64 attached_sas_addr)
+{
+	struct leapraid_card_port *may_new_card_port;
+	struct leapraid_sas_dev *sas_dev;
+
+	may_new_card_port = leapraid_get_port_by_id(adapter,
+		 may_new_port_id, true);
+	if (!may_new_card_port) {
+		may_new_card_port = kzalloc(
+			sizeof(struct leapraid_card_port), GFP_KERNEL);
+		if (!may_new_card_port)
+			return;
+		may_new_card_port->port_id = may_new_port_id;
+		dev_err(&adapter->pdev->dev,
+			 "%s: new card port %p added, port=%d\n",
+			 __func__, may_new_card_port, may_new_port_id);
+		list_add_tail(&may_new_card_port->list,
+			 &adapter->dev_topo.card_port_list);
+	}
+
+	if (card_port != may_new_card_port) {
+		if (!may_new_card_port->vphys_mask)
+			INIT_LIST_HEAD(&may_new_card_port->vphys_list);
+		may_new_card_port->vphys_mask |= BIT(phy_index);
+		card_port->vphys_mask &= ~BIT(phy_index);
+		list_move(&vphy->list, &may_new_card_port->vphys_list);
+
+		sas_dev = leapraid_get_sas_dev_by_addr(adapter,
+			 attached_sas_addr, card_port);
+		if (sas_dev)
+			sas_dev->card_port = may_new_card_port;
+	}
+
+	if (may_new_card_port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY) {
+		may_new_card_port->sas_address = 0;
+		may_new_card_port->phy_mask = 0;
+		may_new_card_port->flg &= ~LEAPRAID_CARD_PORT_FLG_DIRTY;
+	}
+	vphy->flg &= ~LEAPRAID_VPHY_FLG_DIRTY;
+}
+
+static void
+leapraid_update_vphys_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_io_unit_p0 *sas_iounit_p0 = NULL;
+	struct leapraid_card_port *card_port, *card_port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+	u64 attached_sas_addr;
+	u16 sz;
+	u16 attached_hdl;
+	bool found = false;
+	u8 port_id;
+	int i;
+
+	list_for_each_entry_safe(card_port, card_port_next,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (!card_port->vphys_mask)
+			continue;
+
+		list_for_each_entry_safe(vphy, vphy_next,
+				 &card_port->vphys_list, list) {
+			vphy->flg |= LEAPRAID_VPHY_FLG_DIRTY;
+		}
+	}
+
+	sz = offsetof(struct leapraid_sas_io_unit_p0, phy_info)
+		 + (adapter->dev_topo.card.phys_num
+			 * sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iounit_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_p0)
+		return;
+
+	cfgp1.size = sz;
+	if ((leapraid_op_config_page(adapter, sas_iounit_p0,
+		 cfgp1, cfgp2, GET_SAS_IOUNIT_PG0)) != 0)
+		goto out;
+
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if (!leapraid_is_valid_vphy(adapter, sas_iounit_p0, i))
+			continue;
+
+		attached_hdl =
+			 le16_to_cpu(sas_iounit_p0->phy_info[i].attached_dev_hdl);
+		if (leapraid_get_sas_address(adapter,
+			 attached_hdl, &attached_sas_addr) != 0)
+			continue;
+
+		found = false;
+		card_port = card_port_next = NULL;
+		list_for_each_entry_safe(card_port, card_port_next,
+			 &adapter->dev_topo.card_port_list, list) {
+			if (!card_port->vphys_mask)
+				continue;
+
+			list_for_each_entry_safe(vphy, vphy_next,
+				 &card_port->vphys_list, list) {
+				if (!(vphy->flg & LEAPRAID_VPHY_FLG_DIRTY))
+					continue;
+
+				if (vphy->sas_address != attached_sas_addr)
+					continue;
+
+				if (!(vphy->phy_mask & BIT(i)))
+					vphy->phy_mask = BIT(i);
+
+				port_id = sas_iounit_p0->phy_info[i].port;
+
+				leapraid_update_vphy_binding(
+					adapter, card_port, vphy,
+					 i, port_id, attached_sas_addr);
+
+				found = true;
+				break;
+			}
+			if (found)
+				break;
+		}
+	}
+out:
+	kfree(sas_iounit_p0);
+}
+
+static void
+leapraid_mark_all_dev_deleted(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (sdev_priv && sdev_priv->starget_priv)
+			sdev_priv->starget_priv->deleted = true;
+	}
+}
+
+static void
+leapraid_free_enc_list(struct leapraid_adapter *adapter)
+{
+	struct leapraid_enc_node *enc_dev, *enc_dev_next;
+
+	list_for_each_entry_safe(enc_dev,
+		 enc_dev_next, &adapter->dev_topo.enc_list,
+		 list) {
+		list_del(&enc_dev->list);
+		kfree(enc_dev);
+	}
+}
+
+static void
+leapraid_rebuild_enc_list_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_enc_node *enc_node;
+	u16 enc_hdl;
+	int rc;
+
+	leapraid_free_enc_list(adapter);
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (enc_hdl = 0xFFFF; ; enc_hdl = le16_to_cpu(
+			enc_node->pg0.enc_hdl)) {
+		enc_node = kzalloc(sizeof(struct leapraid_enc_node),
+			 GFP_KERNEL);
+		if (!enc_node)
+			return;
+
+		cfgp2.handle = enc_hdl;
+		rc = leapraid_op_config_page(adapter, &enc_node->pg0,
+			 cfgp1, cfgp2, GET_SAS_ENCLOSURE_PG0);
+		if (rc) {
+			kfree(enc_node);
+			return;
+		}
+
+		list_add_tail(&enc_node->list, &adapter->dev_topo.enc_list);
+	}
+}
+
+static void
+leapraid_mark_resp_sas_dev(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev_p0 *sas_dev_p0)
+{
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct leapraid_enc_node *enc_node = NULL;
+	struct leapraid_card_port *card_port;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_target *starget;
+	unsigned long flags;
+
+	card_port = leapraid_get_port_by_id(adapter,
+		 sas_dev_p0->physical_port, false);
+	if (sas_dev_p0->enc_hdl) {
+		enc_node = leapraid_enc_find_by_hdl(adapter,
+			 le16_to_cpu(sas_dev_p0->enc_hdl));
+		if (enc_node == NULL)
+			dev_info(&adapter->pdev->dev,
+				 "enc hdl 0x%04x has no matched enc dev\n",
+				 le16_to_cpu(sas_dev_p0->enc_hdl));
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list,
+		 list) {
+		if ((sas_dev->sas_addr == le64_to_cpu(sas_dev_p0->sas_address))
+			 && (sas_dev->slot == le16_to_cpu(sas_dev_p0->slot))
+			 && (sas_dev->card_port == card_port)) {
+			sas_dev->resp = true;
+			starget = sas_dev->starget;
+			if (starget && starget->hostdata) {
+				starget_priv = starget->hostdata;
+				starget_priv->tm_busy = false;
+				starget_priv->deleted = false;
+			} else
+				starget_priv = NULL;
+
+			if (starget) {
+				starget_printk(KERN_INFO, starget,
+					 "dev: hdl=0x%04x, sas addr=0x%016llx, port_id=%d\n",
+					 sas_dev->hdl,
+					 (unsigned long long)sas_dev->sas_addr,
+					 sas_dev->card_port->port_id);
+				if (sas_dev->enc_hdl != 0)
+					starget_printk(KERN_INFO, starget,
+						 "enc info: enc_lid=0x%016llx, slot=%d\n",
+						 (unsigned long long)sas_dev->enc_lid,
+						 sas_dev->slot);
+			}
+
+			if (le16_to_cpu(sas_dev_p0->flg)
+				 & LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID) {
+				sas_dev->enc_level = sas_dev_p0->enc_level;
+				memcpy(sas_dev->connector_name,
+					 sas_dev_p0->connector_name, 4);
+				sas_dev->connector_name[4] = '\0';
+			} else {
+				sas_dev->enc_level = 0;
+				sas_dev->connector_name[0] = '\0';
+			}
+
+			sas_dev->enc_hdl =
+				 le16_to_cpu(sas_dev_p0->enc_hdl);
+			if (enc_node) {
+				sas_dev->enc_lid =
+					 le64_to_cpu(enc_node->pg0.enc_lid);
+			}
+			if (sas_dev->hdl == le16_to_cpu(sas_dev_p0->dev_hdl))
+				goto out;
+
+			dev_info(&adapter->pdev->dev,
+				 "hdl changed: 0x%04x -> 0x%04x\n",
+				 sas_dev->hdl, sas_dev_p0->dev_hdl);
+			sas_dev->hdl = le16_to_cpu(sas_dev_p0->dev_hdl);
+			if (starget_priv)
+				starget_priv->hdl =
+					 le16_to_cpu(sas_dev_p0->dev_hdl);
+			goto out;
+		}
+	}
+out:
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock,
+		 flags);
+}
+
+static void
+leapraid_search_resp_sas_dev(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	u32 device_info;
+
+	dev_info(&adapter->pdev->dev,
+		 "begin searching for sas end devices\n");
+
+	if (list_empty(&adapter->dev_topo.sas_dev_list))
+		goto out;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (cfgp2.handle = 0xFFFF;
+		 !leapraid_op_config_page(adapter, &sas_dev_p0,
+		 cfgp1, cfgp2, GET_SAS_DEVICE_PG0);
+		 cfgp2.handle = le16_to_cpu(sas_dev_p0.dev_hdl)) {
+		device_info = le32_to_cpu(sas_dev_p0.dev_info);
+		if (!(leapraid_is_end_dev(device_info)))
+			continue;
+
+		leapraid_mark_resp_sas_dev(adapter, &sas_dev_p0);
+	}
+out:
+	dev_info(&adapter->pdev->dev,
+		 "sas end devices searching complete\n");
+}
+
+static void
+leapraid_mark_resp_raid_volume(struct leapraid_adapter *adapter,
+	 u64 wwid, u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_raid_volume *raid_volume;
+	struct scsi_target *starget;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock,
+		 flags);
+	list_for_each_entry(raid_volume,
+		 &adapter->dev_topo.raid_volume_list, list) {
+		if (raid_volume->wwid == wwid && raid_volume->starget) {
+			starget = raid_volume->starget;
+			if (starget && starget->hostdata) {
+				starget_priv = starget->hostdata;
+				starget_priv->deleted = false;
+			} else
+				starget_priv = NULL;
+
+			raid_volume->resp = true;
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock,
+				 flags);
+
+			starget_printk(KERN_INFO, raid_volume->starget,
+				 "raid volume: hdl=0x%04x, wwid=0x%016llx\n",
+				 hdl, (unsigned long long)raid_volume->wwid);
+			spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock,
+				 flags);
+			if (raid_volume->hdl == hdl) {
+				spin_unlock_irqrestore(
+					&adapter->dev_topo.raid_volume_lock,
+					 flags);
+				return;
+			}
+
+			dev_info(&adapter->pdev->dev,
+				 "hdl changed: 0x%04x -> 0x%04x\n",
+				 raid_volume->hdl, hdl);
+
+			raid_volume->hdl = hdl;
+			if (starget_priv)
+				starget_priv->hdl = hdl;
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock,
+				 flags);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+static void
+leapraid_search_resp_raid_volume(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_1 cfgp1_extra = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union cfg_param_2 cfgp2_extra = {0};
+	struct leapraid_raidvol_p1 raidvol_p1;
+	struct leapraid_raidvol_p0 raidvol_p0;
+	struct leapraid_raidpd_p0 raidpd_p0;
+	u16 hdl;
+	u8 phys_disk_num;
+
+	if (!adapter->adapter_attr.raid_support)
+		return;
+
+	dev_info(&adapter->pdev->dev,
+		 "begin searching for raid volumes\n");
+
+	if (list_empty(&adapter->dev_topo.raid_volume_list))
+		goto out;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+		 !leapraid_op_config_page(adapter, &raidvol_p1,
+		 cfgp1, cfgp2, GET_RAID_VOLUME_PG1);
+		 cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(raidvol_p1.dev_hdl);
+		cfgp1_extra.size = sizeof(struct leapraid_raidvol_p0);
+		cfgp2_extra.handle = hdl;
+		if (leapraid_op_config_page(adapter, &raidvol_p0,
+			 cfgp1_extra, cfgp2_extra, GET_RAID_VOLUME_PG0))
+			continue;
+
+		if (raidvol_p0.volume_state == LEAPRAID_VOL_STATE_OPTIMAL
+			 || raidvol_p0.volume_state ==
+				 LEAPRAID_VOL_STATE_ONLINE
+			 || raidvol_p0.volume_state ==
+				 LEAPRAID_VOL_STATE_DEGRADED)
+			leapraid_mark_resp_raid_volume(adapter,
+				 le64_to_cpu(raidvol_p1.wwid), hdl);
+	}
+
+	memset(adapter->dev_topo.pd_hdls, 0, adapter->dev_topo.pd_hdls_sz);
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (phys_disk_num = 0xFF, cfgp2.form_specific = phys_disk_num;
+		 !leapraid_op_config_page(adapter, &raidpd_p0,
+		 cfgp1, cfgp2, GET_PHY_DISK_PG0);
+		 cfgp2.form_specific = phys_disk_num) {
+		phys_disk_num = raidpd_p0.phys_disk_num;
+		hdl = le16_to_cpu(raidpd_p0.dev_hdl);
+		set_bit(hdl, (unsigned long *)adapter->dev_topo.pd_hdls);
+	}
+out:
+	dev_info(&adapter->pdev->dev,
+		 "raid volumes searching complete\n");
+}
+
+static void
+leapraid_mark_resp_exp(struct leapraid_adapter *adapter,
+	 struct leapraid_exp_p0 *exp_pg0)
+{
+	struct leapraid_enc_node *enc_node = NULL;
+	struct leapraid_topo_node *topo_node_exp;
+	u16 enc_hdl = le16_to_cpu(exp_pg0->enc_hdl);
+	u64 sas_address = le64_to_cpu(exp_pg0->sas_address);
+	u16 hdl = le16_to_cpu(exp_pg0->dev_hdl);
+	u8 port_id = exp_pg0->physical_port;
+	struct leapraid_card_port *card_port
+		 = leapraid_get_port_by_id(adapter, port_id, false);
+	unsigned long flags;
+	int i;
+
+	if (enc_hdl)
+		enc_node = leapraid_enc_find_by_hdl(adapter, enc_hdl);
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_for_each_entry(topo_node_exp, &adapter->dev_topo.exp_list,
+		 list) {
+		if (topo_node_exp->sas_address != sas_address
+			 || (topo_node_exp->card_port != card_port))
+			continue;
+
+		topo_node_exp->resp = true;
+		if (enc_node) {
+			topo_node_exp->enc_lid =
+				 le64_to_cpu(enc_node->pg0.enc_lid);
+			topo_node_exp->enc_hdl = le16_to_cpu(exp_pg0->enc_hdl);
+		}
+		if (topo_node_exp->hdl == hdl)
+			goto out;
+
+		dev_info(&adapter->pdev->dev,
+			 "hdl changed: 0x%04x -> 0x%04x\n",
+			 topo_node_exp->hdl, hdl);
+		topo_node_exp->hdl = hdl;
+		for (i = 0; i < topo_node_exp->phys_num; i++)
+			topo_node_exp->card_phy[i].hdl = hdl;
+		goto out;
+	}
+out:
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+}
+
+static void
+leapraid_search_resp_exp(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_exp_p0 exp_p0;
+	u64 sas_address;
+	u16 hdl;
+	u8 port;
+
+	dev_info(&adapter->pdev->dev,
+		 "begin searching for expanders\n");
+	if (list_empty(&adapter->dev_topo.exp_list))
+		goto out;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+		 !leapraid_op_config_page(adapter, &exp_p0,
+			 cfgp1, cfgp2, GET_SAS_EXPANDER_PG0);
+		 cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(exp_p0.dev_hdl);
+		sas_address = le64_to_cpu(exp_p0.sas_address);
+		port = exp_p0.physical_port;
+
+		dev_info(&adapter->pdev->dev,
+			 "exp detected: hdl=0x%04x, sas=0x%016llx, port=%u",
+			 hdl, (unsigned long long)sas_address,
+			 ((adapter->adapter_attr.enable_mp)
+			 ? (port) : (LEAPRAID_DISABLE_MP_PORT_ID)));
+		leapraid_mark_resp_exp(adapter, &exp_p0);
+	}
+out:
+	dev_info(&adapter->pdev->dev,
+		 "expander searching complete\n");
+}
+
+void
+leapraid_wait_cmds_done(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_req_tracker *io_req_tracker;
+	unsigned long flags;
+	u16 i;
+
+	adapter->reset_desc.pending_io_cnt = 0;
+	if (!leapraid_pci_active(adapter)) {
+		dev_err(&adapter->pdev->dev,
+			 "%s %s: pci error, device reset or unplugged!\n",
+			 adapter->adapter_attr.name, __func__);
+		return;
+	}
+
+	if (leapraid_get_adapter_state(adapter) != LEAPRAID_DB_OPERATIONAL)
+		return;
+
+	spin_lock_irqsave(&adapter->dynamic_task_desc.task_lock, flags);
+	for (i = 1; i <= adapter->shost->can_queue; i++) {
+		io_req_tracker = leapraid_get_io_tracker_from_taskid(adapter,
+			 i);
+		if (io_req_tracker && io_req_tracker->taskid != 0)
+			if (io_req_tracker->scmd)
+				adapter->reset_desc.pending_io_cnt++;
+	}
+	spin_unlock_irqrestore(&adapter->dynamic_task_desc.task_lock,
+		 flags);
+
+	if (!adapter->reset_desc.pending_io_cnt)
+		return;
+
+	wait_event_timeout(adapter->reset_desc.reset_wait_queue,
+		 adapter->reset_desc.pending_io_cnt == 0, 10 * HZ);
+}
+
+int
+leapraid_hard_reset_handler(struct leapraid_adapter *adapter,
+	 enum reset_type type)
+{
+	unsigned long flags;
+	int rc;
+
+	if (!mutex_trylock(&adapter->reset_desc.adapter_reset_mutex)) {
+		do {
+			ssleep(1);
+		} while (adapter->access_ctrl.shost_recovering);
+		return adapter->reset_desc.adapter_reset_results;
+	}
+
+	if (!leapraid_pci_active(adapter)) {
+		if (leapraid_pci_removed(adapter)) {
+			dev_info(&adapter->pdev->dev,
+				 "pci_dev removed, pausing polling and cleaning cmds\n");
+			leapraid_mq_polling_pause(adapter);
+			leapraid_clean_active_scsi_cmds(adapter);
+			leapraid_mq_polling_resume(adapter);
+		}
+		rc = 0;
+		goto exit_pci_unavailable;
+	}
+
+	dev_info(&adapter->pdev->dev, "starting hard reset\n");
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	adapter->access_ctrl.shost_recovering = true;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+
+	leapraid_wait_cmds_done(adapter);
+	leapraid_mask_int(adapter);
+	leapraid_mq_polling_pause(adapter);
+	rc = leapraid_make_adapter_ready(adapter, type);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to make adapter ready, rc=%d\n", rc);
+		goto out;
+	}
+
+	rc = leapraid_fw_log_init(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"firmware log init failed\n");
+		goto out;
+	}
+
+	leapraid_clean_active_cmds(adapter);
+	if (adapter->scan_dev_desc.driver_loading
+		 && adapter->scan_dev_desc.scan_dev_failed) {
+		dev_err(&adapter->pdev->dev,
+			 "Previous device scan failed or driver loading\n");
+		adapter->access_ctrl.host_removing = true;
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = leapraid_make_adapter_available(adapter);
+	if (!rc) {
+		dev_info(&adapter->pdev->dev,
+			 "adapter is now available, rebuilding topology\n");
+		if (adapter->adapter_attr.enable_mp) {
+			leapraid_update_card_port_after_reset(adapter);
+			leapraid_update_vphys_after_reset(adapter);
+		}
+		leapraid_mark_all_dev_deleted(adapter);
+		leapraid_rebuild_enc_list_after_reset(adapter);
+		leapraid_search_resp_sas_dev(adapter);
+		leapraid_search_resp_raid_volume(adapter);
+		leapraid_search_resp_exp(adapter);
+		leapraid_hardreset_barrier(adapter);
+	}
+out:
+	dev_info(&adapter->pdev->dev, "hard reset %s\n",
+		 ((rc == 0) ? "SUCCESS" : "FAILED"));
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	adapter->reset_desc.adapter_reset_results = rc;
+	adapter->access_ctrl.shost_recovering = false;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
+		 flags);
+	adapter->reset_desc.reset_cnt++;
+	mutex_unlock(&adapter->reset_desc.adapter_reset_mutex);
+
+	if (rc)
+		leapraid_clean_active_scsi_cmds(adapter);
+	leapraid_mq_polling_resume(adapter);
+
+exit_pci_unavailable:
+	dev_info(&adapter->pdev->dev, "pcie unavailable!\n");
+	return rc;
+}
+
+static int
+leapraid_get_adapter_features(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_features_req leap_mpi_req;
+	struct leapraid_adapter_features_rep leap_mpi_rep;
+	u32 db;
+	int r;
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if (db & LEAPRAID_DB_USED ||
+		 (db & LEAPRAID_DB_MASK) == LEAPRAID_DB_FAULT)
+		return -EFAULT;
+
+	if (((db & LEAPRAID_DB_MASK) != LEAPRAID_DB_READY) &&
+		 (db & LEAPRAID_DB_MASK) != LEAPRAID_DB_OPERATIONAL) {
+		if (!leapraid_wait_adapter_ready(adapter))
+			return -EFAULT;
+	}
+
+	memset(&leap_mpi_req, 0,
+		 sizeof(struct leapraid_adapter_features_req));
+	memset(&leap_mpi_rep, 0,
+		 sizeof(struct leapraid_adapter_features_rep));
+	leap_mpi_req.func = LEAPRAID_FUNC_GET_ADAPTER_FEATURES;
+	r = leapraid_handshake_func(adapter,
+		 sizeof(struct leapraid_adapter_features_req),
+		 (u32 *)&leap_mpi_req,
+		 sizeof(struct leapraid_adapter_features_rep),
+		 (u16 *)&leap_mpi_rep);
+	if (r) {
+		dev_err(&adapter->pdev->dev,
+			 "%s %s: handshake failed, r=%d\n",
+			 adapter->adapter_attr.name, __func__, r);
+		return r;
+	}
+
+	memset(&adapter->adapter_attr.features, 0,
+		 sizeof(struct leapraid_adapter_features));
+	adapter->adapter_attr.features.req_slot
+		 = le16_to_cpu(leap_mpi_rep.req_slot);
+	adapter->adapter_attr.features.hp_slot
+		 = le16_to_cpu(leap_mpi_rep.hp_slot);
+	adapter->adapter_attr.features.adapter_caps
+		 = le32_to_cpu(leap_mpi_rep.adapter_caps);
+	adapter->adapter_attr.features.max_volumes
+		 = leap_mpi_rep.max_volumes;
+	if (!adapter->adapter_attr.features.max_volumes)
+		adapter->adapter_attr.features.max_volumes = 32;
+	adapter->adapter_attr.features.max_dev_handle
+		 = le16_to_cpu(leap_mpi_rep.max_dev_hdl);
+	if (!adapter->adapter_attr.features.max_dev_handle)
+		adapter->adapter_attr.features.max_dev_handle = 2048;
+	adapter->adapter_attr.features.min_dev_handle
+		 = le16_to_cpu(leap_mpi_rep.min_dev_hdl);
+	if ((adapter->adapter_attr.features.adapter_caps &
+		 LEAPRAID_ADAPTER_FEATURES_CAP_INTEGRATED_RAID))
+		adapter->adapter_attr.raid_support = true;
+	if (WARN_ON(!(adapter->adapter_attr.features.adapter_caps &
+		 LEAPRAID_ADAPTER_FEATURES_CAP_ATOMIC_REQ)))
+		return -EFAULT;
+	adapter->adapter_attr.features.fw_version
+		 = le32_to_cpu(leap_mpi_rep.fw_version);
+	adapter->shost->max_id = -1;
+
+	return 0;
+}
+
+static inline void
+leapraid_disable_pcie(struct leapraid_adapter *adapter)
+{
+	mutex_lock(&adapter->access_ctrl.pci_access_lock);
+	if (adapter->iomem_base) {
+		iounmap(adapter->iomem_base);
+		adapter->iomem_base = NULL;
+	}
+	if (pci_is_enabled(adapter->pdev)) {
+		pci_release_regions(adapter->pdev);
+		pci_disable_device(adapter->pdev);
+	}
+	mutex_unlock(&adapter->access_ctrl.pci_access_lock);
+}
+
+static int
+leapraid_enable_pcie(struct leapraid_adapter *adapter)
+{
+	u64 dma_mask;
+	int rc;
+
+	rc = pci_enable_device(adapter->pdev);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to enable PCI device\n");
+		return rc;
+	}
+
+	rc = pci_request_regions(adapter->pdev, LEAPRAID_DRIVER_NAME);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to obtain PCI resources\n");
+		goto disable_pcie;
+	}
+
+	if (sizeof(dma_addr_t) > 4) {
+		dma_mask = DMA_BIT_MASK(64);
+		adapter->adapter_attr.use_32_dma_mask = false;
+	} else {
+		dma_mask = DMA_BIT_MASK(32);
+		adapter->adapter_attr.use_32_dma_mask = true;
+	}
+
+	rc = dma_set_mask_and_coherent(&adapter->pdev->dev, dma_mask);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to set %lld DMA mask\n", dma_mask);
+		goto disable_pcie;
+	}
+	adapter->iomem_base = ioremap(pci_resource_start(adapter->pdev, 0),
+		 sizeof(struct leapraid_reg_base));
+	if (!adapter->iomem_base) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to map memory for controller registers\n");
+		rc = -ENOMEM;
+		goto disable_pcie;
+	}
+
+	pci_set_master(adapter->pdev);
+
+	return 0;
+
+disable_pcie:
+	return rc;
+}
+
+static void
+leapraid_cpus_on_irq(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	unsigned int i, base_group, this_group;
+	unsigned int cpu, nr_cpus, total_msix, index = 0;
+
+	total_msix = adapter->notification_desc.iopoll_qdex;
+	nr_cpus = num_online_cpus();
+
+	if (!nr_cpus || !total_msix)
+		return;
+	base_group = nr_cpus / total_msix;
+
+	cpu = cpumask_first(cpu_online_mask);
+	for (index = 0; index < adapter->notification_desc.iopoll_qdex;
+		 index++) {
+		int_rq = &adapter->notification_desc.int_rqs[index];
+
+		if (cpu >= nr_cpus)
+			break;
+
+		this_group = base_group +
+			 (index < (nr_cpus % total_msix) ? 1 : 0);
+
+		for (i = 0 ; i < this_group ; i++) {
+			adapter->notification_desc.msix_cpu_map[cpu] =
+				 int_rq->rq.msix_idx;
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
+	}
+}
+
+static void
+leapraid_map_msix_to_cpu(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	const cpumask_t *affinity_mask;
+	u32 i;
+	u16 cpu;
+
+	if (!adapter->adapter_attr.rq_cnt)
+		return;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		affinity_mask = pci_irq_get_affinity(adapter->pdev,
+			int_rq->rq.msix_idx);
+		if (!affinity_mask)
+			goto out;
+
+		for_each_cpu_and(cpu, affinity_mask, cpu_online_mask) {
+			if (cpu >= adapter->notification_desc.msix_cpu_map_sz)
+				break;
+
+			adapter->notification_desc.msix_cpu_map[cpu]
+				 = int_rq->rq.msix_idx;
+		}
+	}
+out:
+	leapraid_cpus_on_irq(adapter);
+}
+
+static void
+leapraid_configure_reply_queue_affinity(
+	struct leapraid_adapter *adapter)
+{
+	if (!adapter || !adapter->notification_desc.msix_enable)
+		return;
+
+	leapraid_map_msix_to_cpu(adapter);
+}
+
+static void
+leapraid_free_irq(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	unsigned int i;
+
+	if (!adapter->notification_desc.int_rqs)
+		return;
+
+	for (i = 0; i < adapter->notification_desc.int_rqs_allocated; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		if (!int_rq)
+			continue;
+
+		irq_set_affinity_hint(pci_irq_vector(adapter->pdev,
+			 int_rq->rq.msix_idx), NULL);
+		free_irq(pci_irq_vector(adapter->pdev,
+			 int_rq->rq.msix_idx), &int_rq->rq);
+	}
+	adapter->notification_desc.int_rqs_allocated = 0;
+
+	if (!adapter->notification_desc.msix_enable)
+		return;
+
+	pci_free_irq_vectors(adapter->pdev);
+	adapter->notification_desc.msix_enable = false;
+
+	kfree(adapter->notification_desc.blk_mq_poll_rqs);
+	adapter->notification_desc.blk_mq_poll_rqs = NULL;
+
+	kfree(adapter->notification_desc.int_rqs);
+	adapter->notification_desc.int_rqs = NULL;
+
+	kfree(adapter->notification_desc.msix_cpu_map);
+	adapter->notification_desc.msix_cpu_map = NULL;
+}
+
+static inline int
+leapraid_msix_cnt(struct pci_dev *pdev)
+{
+	return pci_msix_vec_count(pdev);
+}
+
+static inline int
+leapraid_msi_cnt(struct pci_dev *pdev)
+{
+	return pci_msi_vec_count(pdev);
+}
+
+static int
+leapraid_setup_irqs(struct leapraid_adapter *adapter)
+{
+	int i, rc = 0;
+
+	if (interrupt_mode == 0) {
+		rc = pci_alloc_irq_vectors_affinity(adapter->pdev,
+			 adapter->notification_desc.iopoll_qdex,
+			 adapter->notification_desc.iopoll_qdex,
+			 PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, NULL);
+
+		if (rc < 0) {
+			dev_err(&adapter->pdev->dev,
+				 "%d msi/msix vectors alloacted failed!\n",
+				 adapter->notification_desc.iopoll_qdex);
+			return rc;
+		}
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		adapter->notification_desc.int_rqs[i].rq.adapter = adapter;
+		adapter->notification_desc.int_rqs[i].rq.msix_idx = i;
+		atomic_set(&adapter->notification_desc.int_rqs[i].rq.busy, 0);
+		if (interrupt_mode == 0)
+			snprintf(adapter->notification_desc.int_rqs[i].rq.name,
+				 LEAPRAID_NAME_LENGTH, "%s%u-MSIx%u",
+				 LEAPRAID_DRIVER_NAME,
+				 adapter->adapter_attr.id, i);
+		else if (interrupt_mode == 1)
+			snprintf(adapter->notification_desc.int_rqs[i].rq.name,
+				 LEAPRAID_NAME_LENGTH, "%s%u-MSI%u",
+				 LEAPRAID_DRIVER_NAME,
+				 adapter->adapter_attr.id, i);
+
+		rc = request_irq(pci_irq_vector(adapter->pdev, i),
+			 leapraid_irq_handler,
+			 IRQF_SHARED,
+			 adapter->notification_desc.int_rqs[i].rq.name,
+			 &adapter->notification_desc.int_rqs[i].rq);
+		if (rc) {
+			dev_err(&adapter->pdev->dev,
+				 "MSI/MSIx: request_irq %s failed!\n",
+				 adapter->notification_desc.int_rqs[i].rq.name);
+			return rc;
+		}
+		adapter->notification_desc.int_rqs_allocated++;
+	}
+
+	return 0;
+}
+
+static int
+leapraid_setup_legacy_int(struct leapraid_adapter *adapter)
+{
+	int rc;
+
+	adapter->notification_desc.int_rqs[0].rq.adapter = adapter;
+	adapter->notification_desc.int_rqs[0].rq.msix_idx = 0;
+	atomic_set(&adapter->notification_desc.int_rqs[0].rq.busy, 0);
+	snprintf(adapter->notification_desc.int_rqs[0].rq.name,
+		 LEAPRAID_NAME_LENGTH, "%s%d-LegacyInt",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+
+	rc = pci_alloc_irq_vectors_affinity(adapter->pdev,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qdex,
+		 PCI_IRQ_INTX | PCI_IRQ_AFFINITY,
+		 NULL);
+	if (rc < 0) {
+		dev_err(&adapter->pdev->dev,
+			 "legacy irq alloacted failed!\n");
+		return rc;
+	}
+
+	rc = request_irq(pci_irq_vector(adapter->pdev, 0),
+		 leapraid_irq_handler, IRQF_SHARED,
+		 adapter->notification_desc.int_rqs[0].rq.name,
+		 &adapter->notification_desc.int_rqs[0].rq);
+	if (rc) {
+		irq_set_affinity_hint(pci_irq_vector(adapter->pdev, 0), NULL);
+		pci_free_irq_vectors(adapter->pdev);
+		dev_err(&adapter->pdev->dev,
+			 "Legact Int: request_irq %s failed!\n",
+			 adapter->notification_desc.int_rqs[0].rq.name);
+		return -EBUSY;
+	}
+	adapter->notification_desc.int_rqs_allocated = 1;
+	return rc;
+}
+
+static int
+leapraid_set_legacy_int(struct leapraid_adapter *adapter)
+{
+	int rc;
+
+	adapter->notification_desc.msix_cpu_map_sz = num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		 kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			 GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+
+	adapter->adapter_attr.rq_cnt = 1;
+	adapter->notification_desc.iopoll_qdex =
+		 adapter->adapter_attr.rq_cnt;
+	adapter->notification_desc.iopoll_qcnt = 0;
+	dev_info(&adapter->pdev->dev,
+		 "Legacy Intr: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+	adapter->notification_desc.int_rqs =
+		 kcalloc(adapter->notification_desc.iopoll_qdex,
+		 sizeof(struct leapraid_int_rq), GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs) {
+		dev_err(&adapter->pdev->dev,
+			 "Legacy Intr: allocate %d intr rep queues failed!\n",
+			 adapter->notification_desc.iopoll_qdex);
+		return -ENOMEM;
+	}
+
+	rc = leapraid_setup_legacy_int(adapter);
+
+	return rc;
+}
+
+static int
+leapraid_set_msix(struct leapraid_adapter *adapter)
+{
+	int iopoll_qcnt = 0;
+	int msix_cnt, i, rc;
+
+	if (msix_disable == 1)
+		goto legacy_int;
+
+	msix_cnt = leapraid_msix_cnt(adapter->pdev);
+	if (msix_cnt <= 0) {
+		dev_info(&adapter->pdev->dev,
+			 "msix unsupported!\n");
+		goto legacy_int;
+	}
+
+	if (reset_devices)
+		adapter->adapter_attr.rq_cnt = 1;
+	else
+		adapter->adapter_attr.rq_cnt = min_t(int,
+			 num_online_cpus(), msix_cnt);
+
+	if (max_msix_vectors > 0)
+		adapter->adapter_attr.rq_cnt = min_t(int, max_msix_vectors,
+			 adapter->adapter_attr.rq_cnt);
+
+	if (adapter->adapter_attr.rq_cnt <= 1)
+		adapter->shost->host_tagset = 0;
+	if (adapter->shost->host_tagset) {
+		iopoll_qcnt = poll_queues;
+		if (iopoll_qcnt >= adapter->adapter_attr.rq_cnt)
+			iopoll_qcnt = 0;
+	}
+
+	if (iopoll_qcnt) {
+		adapter->notification_desc.blk_mq_poll_rqs =
+			 kcalloc(iopoll_qcnt,
+			 sizeof(struct leapraid_blk_mq_poll_rq), GFP_KERNEL);
+		if (!adapter->notification_desc.blk_mq_poll_rqs)
+			return -ENOMEM;
+		adapter->adapter_attr.rq_cnt =
+			 min(adapter->adapter_attr.rq_cnt +
+				 iopoll_qcnt, msix_cnt);
+	}
+
+	adapter->notification_desc.iopoll_qdex =
+		 adapter->adapter_attr.rq_cnt - iopoll_qcnt;
+
+	adapter->notification_desc.iopoll_qcnt = iopoll_qcnt;
+	dev_info(&adapter->pdev->dev,
+		 "MSIx: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+
+	adapter->notification_desc.int_rqs =
+		 kcalloc(adapter->notification_desc.iopoll_qdex,
+			 sizeof(struct leapraid_int_rq), GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs) {
+		dev_err(&adapter->pdev->dev,
+			 "MSIx: allocate %d interrupt reply queues failed!\n",
+			 adapter->notification_desc.iopoll_qdex);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.adapter
+			 = adapter;
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.msix_idx =
+			 i + adapter->notification_desc.iopoll_qdex;
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].rq.busy,
+				 0);
+		snprintf(adapter->notification_desc.blk_mq_poll_rqs[i].rq.name,
+			 LEAPRAID_NAME_LENGTH,
+			 "%s%u-MQ-Poll%u", LEAPRAID_DRIVER_NAME,
+			 adapter->adapter_attr.id, i);
+		atomic_set(&adapter->notification_desc.blk_mq_poll_rqs[i].busy,
+			 0);
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].pause,
+			 0);
+	}
+
+	adapter->notification_desc.msix_cpu_map_sz =
+		 num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		 kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			 GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+	memset(adapter->notification_desc.msix_cpu_map, 0,
+		 adapter->notification_desc.msix_cpu_map_sz);
+
+	adapter->notification_desc.msix_enable = true;
+	rc = leapraid_setup_irqs(adapter);
+	if (rc) {
+		leapraid_free_irq(adapter);
+		adapter->notification_desc.msix_enable = false;
+		goto legacy_int;
+	}
+
+	return 0;
+
+legacy_int:
+	rc = leapraid_set_legacy_int(adapter);
+
+	return rc;
+}
+
+static int
+leapraid_set_msi(struct leapraid_adapter *adapter)
+{
+	int iopoll_qcnt = 0;
+	int msi_cnt, i, rc;
+
+	if (msix_disable == 1)
+		goto legacy_int1;
+
+	msi_cnt = leapraid_msi_cnt(adapter->pdev);
+	if (msi_cnt <= 0) {
+		dev_info(&adapter->pdev->dev,
+			 "msix unsupported!\n");
+		goto legacy_int1;
+	}
+
+	if (reset_devices)
+		adapter->adapter_attr.rq_cnt = 1;
+	else
+		adapter->adapter_attr.rq_cnt = min_t(int,
+			 num_online_cpus(), msi_cnt);
+
+	if (max_msix_vectors > 0)
+		adapter->adapter_attr.rq_cnt = min_t(int, max_msix_vectors,
+			 adapter->adapter_attr.rq_cnt);
+
+	if (adapter->adapter_attr.rq_cnt <= 1)
+		adapter->shost->host_tagset = 0;
+	if (adapter->shost->host_tagset) {
+		iopoll_qcnt = poll_queues;
+		if (iopoll_qcnt >= adapter->adapter_attr.rq_cnt)
+			iopoll_qcnt = 0;
+	}
+
+	if (iopoll_qcnt) {
+		adapter->notification_desc.blk_mq_poll_rqs =
+			 kcalloc(iopoll_qcnt,
+			 sizeof(struct leapraid_blk_mq_poll_rq), GFP_KERNEL);
+		if (!adapter->notification_desc.blk_mq_poll_rqs)
+			return -ENOMEM;
+
+		adapter->adapter_attr.rq_cnt =
+			 min(adapter->adapter_attr.rq_cnt +
+				 iopoll_qcnt, msi_cnt);
+	}
+
+	adapter->notification_desc.iopoll_qdex =
+		 adapter->adapter_attr.rq_cnt - iopoll_qcnt;
+	rc = pci_alloc_irq_vectors_affinity(adapter->pdev,
+		1,
+		adapter->notification_desc.iopoll_qdex,
+		PCI_IRQ_MSI | PCI_IRQ_AFFINITY, NULL);
+	if (rc < 0) {
+		dev_err(&adapter->pdev->dev,
+			 "%d msi vectors alloacted failed!\n",
+		adapter->notification_desc.iopoll_qdex);
+		goto legacy_int1;
+	}
+	if (rc != adapter->notification_desc.iopoll_qdex) {
+		adapter->notification_desc.iopoll_qdex = rc;
+		adapter->adapter_attr.rq_cnt =
+			 adapter->notification_desc.iopoll_qdex + iopoll_qcnt;
+	}
+	adapter->notification_desc.iopoll_qcnt = iopoll_qcnt;
+	dev_info(&adapter->pdev->dev,
+		 "MSI: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+
+	adapter->notification_desc.int_rqs =
+		 kcalloc(adapter->notification_desc.iopoll_qdex,
+		 sizeof(struct leapraid_int_rq), GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs) {
+		dev_err(&adapter->pdev->dev,
+			 "MSI: allocate %d interrupt reply queues failed!\n",
+			 adapter->notification_desc.iopoll_qdex);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.adapter
+			 = adapter;
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.msix_idx =
+			 i + adapter->notification_desc.iopoll_qdex;
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].rq.busy,
+				 0);
+		snprintf(adapter->notification_desc.blk_mq_poll_rqs[i].rq.name,
+			 LEAPRAID_NAME_LENGTH,
+			 "%s%u-MQ-Poll%u", LEAPRAID_DRIVER_NAME,
+			 adapter->adapter_attr.id, i);
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].busy,
+				 0);
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].pause,
+				 0);
+	}
+
+	adapter->notification_desc.msix_cpu_map_sz =
+		 num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		 kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			 GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+	memset(adapter->notification_desc.msix_cpu_map, 0,
+		 adapter->notification_desc.msix_cpu_map_sz);
+
+	adapter->notification_desc.msix_enable = true;
+	rc = leapraid_setup_irqs(adapter);
+	if (rc) {
+		leapraid_free_irq(adapter);
+		adapter->notification_desc.msix_enable = false;
+		goto legacy_int1;
+	}
+
+	return 0;
+
+legacy_int1:
+	rc = leapraid_set_legacy_int(adapter);
+
+	return rc;
+}
+
+static int
+leapraid_set_notification(struct leapraid_adapter *adapter)
+{
+	int rc = 0;
+
+	if (interrupt_mode == 0) {
+		rc = leapraid_set_msix(adapter);
+		if (rc)
+			pr_err("%s enable MSI-X irq failed!\n", __func__);
+	} else if (interrupt_mode == 1) {
+		rc = leapraid_set_msi(adapter);
+		if (rc)
+			pr_err("%s enable MSI irq failed!\n", __func__);
+	} else if (interrupt_mode == 2) {
+		rc = leapraid_set_legacy_int(adapter);
+		if (rc)
+			pr_err("%s enable legacy irq failed!\n", __func__);
+	}
+
+	return rc;
+}
+
+static void
+leapraid_disable_pcie_and_notification(
+	struct leapraid_adapter *adapter)
+{
+	leapraid_free_irq(adapter);
+	leapraid_disable_pcie(adapter);
+}
+
+int
+leapraid_set_pcie_and_notification(
+	struct leapraid_adapter *adapter)
+{
+	int rc;
+
+	rc = leapraid_enable_pcie(adapter);
+	if (rc)
+		goto out_fail;
+
+	leapraid_mask_int(adapter);
+
+	rc = leapraid_set_notification(adapter);
+	if (rc)
+		goto out_fail;
+
+	pci_save_state(adapter->pdev);
+
+	return 0;
+
+out_fail:
+	leapraid_disable_pcie_and_notification(adapter);
+	return rc;
+}
+
+void
+leapraid_disable_controller(
+	struct leapraid_adapter *adapter)
+{
+	if (!adapter->iomem_base)
+		return;
+
+	leapraid_mask_int(adapter);
+
+	adapter->access_ctrl.shost_recovering = true;
+	leapraid_make_adapter_ready(adapter, PART_RESET);
+	adapter->access_ctrl.shost_recovering = false;
+
+	leapraid_disable_pcie_and_notification(adapter);
+}
+
+static int
+leapraid_adapter_unit_reset(
+	struct leapraid_adapter *adapter)
+{
+	int rc = 0;
+
+	dev_info(&adapter->pdev->dev, "fire unit reset\n");
+	writel(LEAPRAID_FUNC_ADAPTER_UNIT_RESET << LEAPRAID_DB_FUNC_SHIFT,
+		 &adapter->iomem_base->db);
+	if (leapraid_db_wait_ack_and_clear_int(adapter))
+		rc = -EFAULT;
+
+	if (!leapraid_wait_adapter_ready(adapter)) {
+		rc = -EFAULT;
+		goto out;
+	}
+out:
+	dev_info(&adapter->pdev->dev, "unit reset: %s\n",
+		 ((rc == 0) ? "SUCCESS" : "FAILED"));
+	return rc;
+}
+
+static int
+leapraid_make_adapter_ready(struct leapraid_adapter *adapter,
+	 enum reset_type type)
+{
+	u32 db;
+	int rc;
+	int count;
+
+	if (!leapraid_pci_active(adapter))
+		return 0;
+
+	count = 0;
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_RESET) {
+		while ((db & LEAPRAID_DB_MASK) != LEAPRAID_DB_READY) {
+			if (count++ == 10)
+				return -EFAULT;
+			ssleep(1);
+			db = leapraid_readl(&adapter->iomem_base->db);
+		}
+	}
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_READY)
+		return 0;
+
+	if (db & LEAPRAID_DB_USED)
+		goto full_reset;
+
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_FAULT)
+		goto full_reset;
+
+	if (type == FULL_RESET)
+		goto full_reset;
+
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_OPERATIONAL)
+		if (!(leapraid_adapter_unit_reset(adapter)))
+			return 0;
+
+full_reset:
+	rc = leapraid_host_diag_reset(adapter);
+	return rc;
+}
+
+static void
+leapraid_fw_log_exit(struct leapraid_adapter *adapter)
+{
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return;
+
+	if (adapter->fw_log_desc.fw_log_buffer) {
+		dma_free_coherent(&adapter->pdev->dev,
+			 LEAPRAID_SYS_LOG_BUF_SIZE,
+			 adapter->fw_log_desc.fw_log_buffer,
+			 adapter->fw_log_desc.fw_log_buffer_dma);
+		adapter->fw_log_desc.fw_log_buffer = NULL;
+	}
+}
+
+static int
+leapraid_fw_log_init(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_log_req adapter_log_req;
+	struct leapraid_adapter_log_rep adapter_log_rep;
+	u16 adapter_status;
+	u64 buf_addr;
+	u32 rc;
+
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return 0;
+
+	if (adapter->fw_log_desc.fw_log_buffer == NULL) {
+		adapter->fw_log_desc.fw_log_buffer =
+			 dma_alloc_coherent(&adapter->pdev->dev,
+				 (LEAPRAID_SYS_LOG_BUF_SIZE +
+					 LEAPRAID_SYS_LOG_BUF_RESERVE),
+				 &adapter->fw_log_desc.fw_log_buffer_dma,
+				 GFP_KERNEL);
+		if (!adapter->fw_log_desc.fw_log_buffer) {
+			dev_err(&adapter->pdev->dev,
+				 "%s: log buf alloc failed.\n",
+				 __func__);
+			return -ENOMEM;
+		}
+	}
+
+	memset(&adapter_log_req, 0, sizeof(struct leapraid_adapter_log_req));
+	adapter_log_req.func = LEAPRAID_FUNC_LOGBUF_INIT;
+	buf_addr = adapter->fw_log_desc.fw_log_buffer_dma;
+
+	adapter_log_req.mbox.w[0] =
+		 cpu_to_le32((u32)(buf_addr & 0xFFFFFFFF));
+	adapter_log_req.mbox.w[1] =
+		 cpu_to_le32((u32)((buf_addr >> 32) & 0xFFFFFFFF));
+	adapter_log_req.mbox.w[2] =
+		 cpu_to_le32(LEAPRAID_SYS_LOG_BUF_SIZE);
+	rc = leapraid_handshake_func(adapter,
+		 sizeof(struct leapraid_adapter_log_req),
+		 (u32 *)&adapter_log_req,
+		 sizeof(struct leapraid_adapter_log_rep),
+		 (u16 *)&adapter_log_rep);
+	if (rc != 0) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: handshake failed, rc=%d\n",
+			 __func__, rc);
+		return rc;
+	}
+
+	adapter_status =
+		 le16_to_cpu(adapter_log_rep.adapter_status)
+		 & LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev, "%s: failed!\n",
+			 __func__);
+		rc = -EIO;
+	}
+
+	return rc;
+}
+
+static void
+leapraid_free_host_memory(struct leapraid_adapter *adapter)
+{
+	int i;
+
+	if (adapter->mem_desc.task_desc) {
+		dma_free_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.task_desc_dma_size,
+			 adapter->mem_desc.task_desc,
+			 adapter->mem_desc.task_desc_dma);
+		adapter->mem_desc.task_desc = NULL;
+	}
+
+	if (adapter->mem_desc.sense_data) {
+		dma_free_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.io_qd * SCSI_SENSE_BUFFERSIZE,
+			 adapter->mem_desc.sense_data,
+			 adapter->mem_desc.sense_data_dma);
+		adapter->mem_desc.sense_data = NULL;
+	}
+
+	if (adapter->mem_desc.rep_msg) {
+		dma_free_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.rep_msg_qd
+				 * LEAPRAID_REPLY_SIEZ,
+			 adapter->mem_desc.rep_msg,
+			 adapter->mem_desc.rep_msg_dma);
+		adapter->mem_desc.rep_msg = NULL;
+	}
+
+	if (adapter->mem_desc.rep_msg_addr) {
+		dma_free_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.rep_msg_qd * 4,
+			 adapter->mem_desc.rep_msg_addr,
+			 adapter->mem_desc.rep_msg_addr_dma);
+		adapter->mem_desc.rep_msg_addr = NULL;
+	}
+
+	if (adapter->mem_desc.rep_desc_seg_maint) {
+		for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt;
+				 i++) {
+			if (adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg) {
+				dma_free_coherent(&adapter->pdev->dev,
+					(adapter->adapter_attr.rep_desc_qd *
+					LEAPRAID_REP_DESC_ENTRY_SIZE) *
+					LEAPRAID_REP_DESC_CHUNK_SIZE,
+					adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg,
+					adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg_dma);
+				adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg
+					 = NULL;
+			}
+		}
+
+		if (adapter->mem_desc.rep_desc_q_arr) {
+			dma_free_coherent(&adapter->pdev->dev,
+				 adapter->adapter_attr.rq_cnt * 16,
+				 adapter->mem_desc.rep_desc_q_arr,
+				 adapter->mem_desc.rep_desc_q_arr_dma);
+			adapter->mem_desc.rep_desc_q_arr = NULL;
+		}
+
+		for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt; i++)
+			kfree(adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint);
+		kfree(adapter->mem_desc.rep_desc_seg_maint);
+	}
+
+
+	kfree(adapter->mem_desc.taskid_to_uniq_tag);
+	adapter->mem_desc.taskid_to_uniq_tag = NULL;
+
+	dma_pool_destroy(adapter->mem_desc.sg_chain_pool);
+
+}
+
+static inline bool
+leapraid_is_in_same_4g_seg(dma_addr_t start, u32 size)
+{
+	return (upper_32_bits(start) == upper_32_bits(start + size - 1));
+}
+
+int
+leapraid_internal_init_cmd_priv(struct leapraid_adapter *adapter,
+	 struct leapraid_io_req_tracker *io_tracker)
+{
+	io_tracker->chain =
+		 dma_pool_alloc(adapter->mem_desc.sg_chain_pool,
+			 GFP_KERNEL,
+			 &io_tracker->chain_dma);
+
+	if (!io_tracker->chain)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int
+leapraid_internal_exit_cmd_priv(struct leapraid_adapter *adapter,
+	 struct leapraid_io_req_tracker *io_tracker)
+{
+	if (io_tracker && io_tracker->chain)
+		dma_pool_free(adapter->mem_desc.sg_chain_pool,
+			 io_tracker->chain,
+			 io_tracker->chain_dma);
+
+	return 0;
+}
+
+static int
+leapraid_request_host_memory(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_features *facts =
+		 &adapter->adapter_attr.features;
+	u16 rep_desc_q_cnt_allocated;
+	int i, j;
+	int rc;
+
+	/* sg table size */
+	adapter->shost->sg_tablesize = LEAPRAID_SG_DEPTH;
+	if (reset_devices)
+		adapter->shost->sg_tablesize =
+			 LEAPRAID_KDUMP_MIN_PHYS_SEGMENTS;
+	/* high priority cmds queue depth */
+	adapter->dynamic_task_desc.hp_cmd_qd = facts->hp_slot;
+	adapter->dynamic_task_desc.hp_cmd_qd = LEAPRAID_FIXED_HP_CMDS;
+	/* internal cmds queue depth */
+	adapter->dynamic_task_desc.inter_cmd_qd = LEAPRAID_FIXED_INTER_CMDS;
+	/* adapter cmds total queue depth */
+	if (reset_devices)
+		adapter->adapter_attr.adapter_total_qd = 64 +
+			 adapter->dynamic_task_desc.inter_cmd_qd +
+			 adapter->dynamic_task_desc.hp_cmd_qd;
+	else
+		adapter->adapter_attr.adapter_total_qd = facts->req_slot +
+			 adapter->dynamic_task_desc.hp_cmd_qd;
+	/* reply message queue depth */
+	adapter->adapter_attr.rep_msg_qd =
+		 adapter->adapter_attr.adapter_total_qd + 64;
+	/* reply descriptor queue depth */
+	adapter->adapter_attr.rep_desc_qd =
+		 round_up(adapter->adapter_attr.adapter_total_qd +
+		 adapter->adapter_attr.rep_msg_qd + 1, 16);
+	/* scsi cmd io depth */
+	adapter->adapter_attr.io_qd =
+		 adapter->adapter_attr.adapter_total_qd -
+		 adapter->dynamic_task_desc.hp_cmd_qd -
+		 adapter->dynamic_task_desc.inter_cmd_qd;
+	/* scsi host can queue */
+	adapter->shost->can_queue =
+		 adapter->adapter_attr.io_qd - 2;
+	adapter->driver_cmds.ctl_cmd.taskid =
+		 adapter->shost->can_queue + 1;
+	adapter->driver_cmds.driver_scsiio_cmd.taskid =
+		 adapter->shost->can_queue + 2;
+
+	/* allocate task descriptor */
+try_again:
+	adapter->adapter_attr.task_desc_dma_size =
+		 (adapter->adapter_attr.adapter_total_qd + 1)
+		 * LEAPRAID_REQUEST_SIZE;
+	adapter->mem_desc.task_desc =
+		 dma_alloc_coherent(&adapter->pdev->dev,
+		 adapter->adapter_attr.task_desc_dma_size,
+		 &adapter->mem_desc.task_desc_dma,
+		 GFP_KERNEL);
+	if (!adapter->mem_desc.task_desc) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to allocate task descriptor DMA!\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+	/* allocate chain message pool */
+	adapter->mem_desc.sg_chain_pool_size =
+		 LEAPRAID_DEFAULT_CHAINS_PER_IO * LEAPRAID_CHAIN_SEG_SIZE;
+	adapter->mem_desc.sg_chain_pool =
+		 dma_pool_create("leapraid chain pool",
+			 &adapter->pdev->dev,
+			 adapter->mem_desc.sg_chain_pool_size, 16, 0);
+	if (!adapter->mem_desc.sg_chain_pool) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to allocate chain message DMA!\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* allocate io tracker to ref scsi io */
+
+	adapter->mem_desc.taskid_to_uniq_tag =
+		 kcalloc(adapter->shost->can_queue, sizeof(u16), GFP_KERNEL);
+	if (!adapter->mem_desc.taskid_to_uniq_tag) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	adapter->dynamic_task_desc.hp_taskid =
+		 adapter->adapter_attr.io_qd + 1;
+	/* allocate static hp taskid */
+	adapter->driver_cmds.ctl_cmd.hp_taskid =
+		 adapter->dynamic_task_desc.hp_taskid;
+	adapter->driver_cmds.tm_cmd.hp_taskid =
+		 adapter->dynamic_task_desc.hp_taskid + 1;
+
+	adapter->dynamic_task_desc.inter_taskid =
+		 adapter->dynamic_task_desc.hp_taskid +
+		 adapter->dynamic_task_desc.hp_cmd_qd;
+	adapter->driver_cmds.scan_dev_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid;
+	adapter->driver_cmds.cfg_op_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 1;
+	adapter->driver_cmds.transport_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 2;
+	adapter->driver_cmds.timestamp_sync_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 3;
+	adapter->driver_cmds.raid_action_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 4;
+	adapter->driver_cmds.enc_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 5;
+	adapter->driver_cmds.notify_event_cmd.inter_taskid =
+		 adapter->dynamic_task_desc.inter_taskid + 6;
+	dev_info(&adapter->pdev->dev, "queue depth:\n");
+	dev_info(&adapter->pdev->dev, "	host->can_queue: %d\n",
+		 adapter->shost->can_queue);
+	dev_info(&adapter->pdev->dev, "	io_qd: %d\n",
+		 adapter->adapter_attr.io_qd);
+	dev_info(&adapter->pdev->dev, "	hpr_cmd_qd: %d\n",
+		 adapter->dynamic_task_desc.hp_cmd_qd);
+	dev_info(&adapter->pdev->dev, "	inter_cmd_qd: %d\n",
+		 adapter->dynamic_task_desc.inter_cmd_qd);
+	dev_info(&adapter->pdev->dev, "	adapter_total_qd: %d\n",
+		 adapter->adapter_attr.adapter_total_qd);
+
+	dev_info(&adapter->pdev->dev, "taskid range:\n");
+	dev_info(&adapter->pdev->dev,
+		 "	adapter->dynamic_task_desc.hp_taskid: %d\n",
+		 adapter->dynamic_task_desc.hp_taskid);
+	dev_info(&adapter->pdev->dev,
+		 "	adapter->dynamic_task_desc.inter_taskid: %d\n",
+		 adapter->dynamic_task_desc.inter_taskid);
+
+	/*
+	 * allocate sense dma, driver maintain
+	 * need in same 4GB segment
+	 */
+	adapter->mem_desc.sense_data =
+		 dma_alloc_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.io_qd * SCSI_SENSE_BUFFERSIZE,
+			 &adapter->mem_desc.sense_data_dma, GFP_KERNEL);
+	if (!adapter->mem_desc.sense_data) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to allocate sense data DMA!\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+	if (!leapraid_is_in_same_4g_seg(adapter->mem_desc.sense_data_dma,
+			 adapter->adapter_attr.io_qd
+				 * SCSI_SENSE_BUFFERSIZE)) {
+		dev_warn(&adapter->pdev->dev,
+			 "try 32 bit dma due to sense data is not in same 4g!\n");
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	/* reply frame, need in same 4GB segment */
+	adapter->mem_desc.rep_msg =
+		 dma_alloc_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.rep_msg_qd
+				 * LEAPRAID_REPLY_SIEZ,
+			 &adapter->mem_desc.rep_msg_dma,
+			 GFP_KERNEL);
+	if (!adapter->mem_desc.rep_msg) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to allocate reply message DMA!\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+	if (!leapraid_is_in_same_4g_seg(adapter->mem_desc.rep_msg_dma,
+		 adapter->adapter_attr.rep_msg_qd * LEAPRAID_REPLY_SIEZ)) {
+		dev_warn(&adapter->pdev->dev,
+			 "use 32 bit dma due to rep msg is not in same 4g!\n");
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	/* address of reply frame */
+	adapter->mem_desc.rep_msg_addr =
+		 dma_alloc_coherent(&adapter->pdev->dev,
+			 adapter->adapter_attr.rep_msg_qd * 4,
+			 &adapter->mem_desc.rep_msg_addr_dma,
+			 GFP_KERNEL);
+	if (!adapter->mem_desc.rep_msg_addr) {
+		dev_err(&adapter->pdev->dev,
+			 "failed to allocate reply message address DMA!\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+	adapter->adapter_attr.rep_desc_q_seg_cnt =
+		 DIV_ROUND_UP(adapter->adapter_attr.rq_cnt,
+		 LEAPRAID_REP_DESC_CHUNK_SIZE);
+	adapter->mem_desc.rep_desc_seg_maint =
+		 kcalloc(adapter->adapter_attr.rep_desc_q_seg_cnt,
+			 sizeof(struct leapraid_rep_desc_seg_maint),
+			 GFP_KERNEL);
+	if (!adapter->mem_desc.rep_desc_seg_maint) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rep_desc_q_cnt_allocated = 0;
+	for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt; i++) {
+		adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint =
+			 kcalloc(LEAPRAID_REP_DESC_CHUNK_SIZE,
+			 sizeof(struct leapraid_rep_desc_maint),
+			 GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg =
+			 dma_alloc_coherent(&adapter->pdev->dev,
+				 (adapter->adapter_attr.rep_desc_qd *
+				 LEAPRAID_REP_DESC_ENTRY_SIZE)
+					 * LEAPRAID_REP_DESC_CHUNK_SIZE,
+				 &adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg_dma,
+				 GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg) {
+			dev_err(&adapter->pdev->dev,
+				"failed to allocate reply descriptor segment DMA!\n");
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		for (j = 0; j < LEAPRAID_REP_DESC_CHUNK_SIZE; j++) {
+			if (rep_desc_q_cnt_allocated >=
+				 adapter->adapter_attr.rq_cnt)
+				break;
+			adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint[j].rep_desc
+				 = (void *)((u8 *)(
+					adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg)
+					 + j * (adapter->adapter_attr.rep_desc_qd
+					 * LEAPRAID_REP_DESC_ENTRY_SIZE));
+			adapter->mem_desc.rep_desc_seg_maint[
+				i].rep_desc_maint[j].rep_desc_dma
+				 = adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg_dma +
+				 j * (adapter->adapter_attr.rep_desc_qd
+					 * LEAPRAID_REP_DESC_ENTRY_SIZE);
+			rep_desc_q_cnt_allocated++;
+		}
+	}
+
+	if (!reset_devices) {
+		adapter->mem_desc.rep_desc_q_arr =
+			 dma_alloc_coherent(&adapter->pdev->dev,
+				 adapter->adapter_attr.rq_cnt * 16,
+				 &adapter->mem_desc.rep_desc_q_arr_dma,
+				 GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_q_arr) {
+			dev_err(&adapter->pdev->dev,
+				"failed to allocate reply descriptor queue array DMA!\n");
+			rc = -ENOMEM;
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	if (rc == -EAGAIN) {
+		leapraid_free_host_memory(adapter);
+		adapter->adapter_attr.use_32_dma_mask = true;
+		rc = dma_set_mask_and_coherent(&adapter->pdev->dev,
+			 DMA_BIT_MASK(32));
+		if (rc) {
+			dev_err(&adapter->pdev->dev,
+				 "failed to set 32 DMA mask\n");
+			return rc;
+		}
+		goto try_again;
+	}
+	return rc;
+}
+
+static int
+leapraid_alloc_dev_topo_bitmaps(struct leapraid_adapter *adapter)
+{
+	adapter->dev_topo.pd_hdls_sz
+		 = adapter->adapter_attr.features.max_dev_handle / 8;
+	if (adapter->adapter_attr.features.max_dev_handle % 8)
+		adapter->dev_topo.pd_hdls_sz++;
+	adapter->dev_topo.pd_hdls
+		 = kzalloc(adapter->dev_topo.pd_hdls_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.pd_hdls)
+		return -ENOMEM;
+
+	adapter->dev_topo.blocking_hdls
+		 = kzalloc(adapter->dev_topo.pd_hdls_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.blocking_hdls)
+		return -ENOMEM;
+
+	adapter->dev_topo.pending_dev_add_sz
+		 = adapter->adapter_attr.features.max_dev_handle / 8;
+	if (adapter->adapter_attr.features.max_dev_handle % 8)
+		adapter->dev_topo.pending_dev_add_sz++;
+	adapter->dev_topo.pending_dev_add
+		 = kzalloc(adapter->dev_topo.pending_dev_add_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.pending_dev_add)
+		return -ENOMEM;
+
+	adapter->dev_topo.dev_removing_sz
+		 = adapter->dev_topo.pending_dev_add_sz;
+	adapter->dev_topo.dev_removing
+		 = kzalloc(adapter->dev_topo.dev_removing_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.dev_removing)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void
+leapraid_free_dev_topo_bitmaps(struct leapraid_adapter *adapter)
+{
+	kfree(adapter->dev_topo.pd_hdls);
+	kfree(adapter->dev_topo.blocking_hdls);
+	kfree(adapter->dev_topo.pending_dev_add);
+	kfree(adapter->dev_topo.dev_removing);
+}
+
+static int
+leapraid_init_driver_cmds(struct leapraid_adapter *adapter)
+{
+	u32 buffer_size = 0;
+	void *buffer;
+
+	INIT_LIST_HEAD(&adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.scan_dev_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.scan_dev_cmd.cb_idx
+		 = LEAPRAID_SCAN_DEV_CB_IDX;
+	list_add_tail(&adapter->driver_cmds.scan_dev_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.cfg_op_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.cfg_op_cmd.cb_idx
+		 = LEAPRAID_CONFIG_CB_IDX;
+	mutex_init(&adapter->driver_cmds.cfg_op_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.cfg_op_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.transport_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.transport_cmd.cb_idx
+		 = LEAPRAID_TRANSPORT_CB_IDX;
+	mutex_init(&adapter->driver_cmds.transport_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.transport_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.timestamp_sync_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.timestamp_sync_cmd.cb_idx
+		 = LEAPRAID_TIMESTAMP_SYNC_CB_IDX;
+	mutex_init(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.timestamp_sync_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.raid_action_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.raid_action_cmd.cb_idx
+		 = LEAPRAID_RAID_ACTION_CB_IDX;
+	mutex_init(&adapter->driver_cmds.raid_action_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.raid_action_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.driver_scsiio_cmd.status
+		 = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.driver_scsiio_cmd.cb_idx
+		 = LEAPRAID_DRIVER_SCSIIO_CB_IDX;
+	mutex_init(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.driver_scsiio_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	buffer_size = sizeof(struct scsi_cmnd)
+		 + sizeof(struct leapraid_io_req_tracker)
+		 + SCSI_SENSE_BUFFERSIZE + sizeof(struct scatterlist);
+	buffer = kzalloc(buffer_size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	adapter->driver_cmds.internal_scmd = buffer;
+	buffer = (void *)((u8 *)buffer +
+		 sizeof(struct scsi_cmnd) +
+		 sizeof(struct leapraid_io_req_tracker));
+	adapter->driver_cmds.internal_scmd->sense_buffer =
+		 (unsigned char *)buffer;
+	buffer = (void *)((u8 *)buffer + SCSI_SENSE_BUFFERSIZE);
+	adapter->driver_cmds.internal_scmd->sdb.table.sgl =
+		 (struct scatterlist *)buffer;
+	buffer = (void *)((u8 *)buffer + sizeof(struct scatterlist));
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.enc_cmd.cb_idx = LEAPRAID_ENC_CB_IDX;
+	mutex_init(&adapter->driver_cmds.enc_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.enc_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.notify_event_cmd.status =
+		 LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.notify_event_cmd.cb_idx =
+		 LEAPRAID_NOTIFY_EVENT_CB_IDX;
+	mutex_init(&adapter->driver_cmds.notify_event_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.notify_event_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.ctl_cmd.status =
+		 LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.ctl_cmd.cb_idx =
+		 LEAPRAID_CTL_CB_IDX;
+	mutex_init(&adapter->driver_cmds.ctl_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.ctl_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.tm_cmd.cb_idx = LEAPRAID_TM_CB_IDX;
+	mutex_init(&adapter->driver_cmds.tm_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.tm_cmd.list,
+			 &adapter->driver_cmds.special_cmd_list);
+
+	return 0;
+}
+
+static void
+leapraid_unmask_evts(struct leapraid_adapter *adapter, u16 evt)
+{
+	if (evt >= 128)
+		return;
+
+	clear_bit(evt,
+		 (unsigned long *)adapter->fw_evt_s.leapraid_evt_masks);
+}
+
+static void
+leapraid_init_event_mask(struct leapraid_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		adapter->fw_evt_s.leapraid_evt_masks[i] = -1;
+	leapraid_unmask_evts(adapter,
+		 LEAPRAID_EVT_SAS_DISCOVERY);
+	leapraid_unmask_evts(adapter,
+		 LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST);
+	leapraid_unmask_evts(adapter,
+		 LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE);
+	leapraid_unmask_evts(adapter,
+		 LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE);
+	leapraid_unmask_evts(adapter,
+		 LEAPRAID_EVT_IR_CHANGE);
+}
+
+static void
+leapraid_prepare_adp_init_req(struct leapraid_adapter *adapter,
+	 struct leapraid_adapter_init_req *init_req)
+{
+	ktime_t cur_time;
+	int i;
+	u32 reply_post_free_ary_sz;
+
+	memset(init_req, 0, sizeof(struct leapraid_adapter_init_req));
+	init_req->func = LEAPRAID_FUNC_ADAPTER_INIT;
+	init_req->who_init = LEAPRAID_WHOINIT_HOST_DRIVER;
+	init_req->msg_ver = cpu_to_le16(0x0100);
+	init_req->header_ver = cpu_to_le16(0x0000);
+	if (adapter->notification_desc.msix_enable)
+		init_req->host_msix_vectors = adapter->adapter_attr.rq_cnt;
+
+	init_req->req_frame_size = cpu_to_le16(LEAPRAID_REQUEST_SIZE / 4);
+	init_req->rep_desc_qd =
+		 cpu_to_le16(adapter->adapter_attr.rep_desc_qd);
+	init_req->rep_msg_qd =
+		 cpu_to_le16(adapter->adapter_attr.rep_msg_qd);
+	init_req->sense_buffer_add_high =
+		 cpu_to_le32((u64) adapter->mem_desc.sense_data_dma >> 32);
+	init_req->rep_msg_dma_high =
+		 cpu_to_le32((u64) adapter->mem_desc.rep_msg_dma >> 32);
+	init_req->task_desc_base_addr =
+		 cpu_to_le64((u64) adapter->mem_desc.task_desc_dma);
+	init_req->rep_msg_addr_dma =
+		 cpu_to_le64((u64) adapter->mem_desc.rep_msg_addr_dma);
+	if (!reset_devices) {
+		reply_post_free_ary_sz = adapter->adapter_attr.rq_cnt * 16;
+		memset(adapter->mem_desc.rep_desc_q_arr,
+			 0, reply_post_free_ary_sz);
+
+		for (i = 0; i < adapter->adapter_attr.rq_cnt; i++) {
+			adapter->mem_desc.rep_desc_q_arr[i].rep_desc_base_addr =
+			 cpu_to_le64 ((u64) (adapter->mem_desc.rep_desc_seg_maint[
+				i / LEAPRAID_REP_DESC_CHUNK_SIZE].rep_desc_maint[
+					i % LEAPRAID_REP_DESC_CHUNK_SIZE].rep_desc_dma));
+		}
+
+		init_req->msg_flg =
+			 LEAPRAID_ADAPTER_INIT_MSGFLG_RDPQ_ARRAY_MODE;
+		init_req->rep_desc_q_arr_addr =
+			 cpu_to_le64((u64) adapter->mem_desc.rep_desc_q_arr_dma);
+	} else {
+		init_req->rep_desc_q_arr_addr =
+			 cpu_to_le64((u64)adapter->mem_desc.rep_desc_seg_maint[
+				0].rep_desc_maint[0].rep_desc_dma);
+	}
+	cur_time = ktime_get_real();
+	init_req->time_stamp = cpu_to_le64(ktime_to_ms(cur_time));
+}
+
+static int
+leapraid_send_adapter_init(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_init_req init_req;
+	struct leapraid_adapter_init_rep init_rep;
+	u16 adapter_status;
+	int rc = 0;
+
+	leapraid_prepare_adp_init_req(adapter, &init_req);
+
+	rc = leapraid_handshake_func(adapter,
+		 sizeof(struct leapraid_adapter_init_req),
+		 (u32 *) &init_req,
+		 sizeof(struct leapraid_adapter_init_rep),
+		 (u16 *) &init_rep);
+	if (rc != 0) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: handshake failed, rc=%d\n",
+			 __func__, rc);
+		return rc;
+	}
+
+	adapter_status =
+		 le16_to_cpu(init_rep.adapter_status) &
+			 LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: failed\n", __func__);
+		rc = -EIO;
+	}
+
+	adapter->timestamp_sync_cnt = 0;
+	return rc;
+}
+
+static int
+leapraid_cfg_pages(struct leapraid_adapter *adapter)
+{
+
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_io_unit_page1 *sas_io_unit_page1 = NULL;
+	struct leapraid_bios_page3 bios_page3;
+	struct leapraid_bios_page2 bios_page2;
+	int rc = 0;
+	int sz;
+
+	rc = leapraid_op_config_page(adapter, &bios_page3,
+		 cfgp1, cfgp2, GET_BIOS_PG3);
+	if (rc)
+		return rc;
+
+	rc = leapraid_op_config_page(adapter, &bios_page2,
+		 cfgp1, cfgp2, GET_BIOS_PG2);
+	if (rc)
+		return rc;
+
+	adapter->adapter_attr.bios_version
+		 = le32_to_cpu(bios_page3.bios_version);
+	adapter->adapter_attr.wideport_max_queue_depth
+		 = LEAPRAID_SAS_QUEUE_DEPTH;
+	adapter->adapter_attr.narrowport_max_queue_depth
+		 = LEAPRAID_SAS_QUEUE_DEPTH;
+	adapter->adapter_attr.sata_max_queue_depth
+		 = LEAPRAID_SATA_QUEUE_DEPTH;
+
+	adapter->boot_devs.requested_boot_dev.form =
+		 bios_page2.requested_boot_dev_form;
+	memcpy((void *)adapter->boot_devs.requested_boot_dev.pg_dev,
+		 (void *)&bios_page2.requested_boot_dev, 24);
+	adapter->boot_devs.requested_alt_boot_dev.form =
+		 bios_page2.requested_alt_boot_dev_form;
+	memcpy((void *)adapter->boot_devs.requested_alt_boot_dev.pg_dev,
+		 (void *)&bios_page2.requested_alt_boot_dev, 24);
+	adapter->boot_devs.current_boot_dev.form =
+		 bios_page2.current_boot_dev_form;
+	memcpy((void *)adapter->boot_devs.current_boot_dev.pg_dev,
+		 (void *)&bios_page2.current_boot_dev, 24);
+
+
+	sz = offsetof(struct leapraid_sas_io_unit_page1, phy_info);
+	sas_io_unit_page1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_page1) {
+		rc = -ENOMEM;
+		return rc;
+	}
+
+	cfgp1.size = sz;
+
+	rc = leapraid_op_config_page(adapter, sas_io_unit_page1,
+		 cfgp1, cfgp2, GET_SAS_IOUNIT_PG1);
+	if (rc)
+		goto out;
+
+	if (le16_to_cpu(sas_io_unit_page1->wideport_max_queue_depth))
+		adapter->adapter_attr.wideport_max_queue_depth =
+			le16_to_cpu(
+				sas_io_unit_page1->wideport_max_queue_depth);
+
+	if (le16_to_cpu(sas_io_unit_page1->narrowport_max_queue_depth))
+		adapter->adapter_attr.narrowport_max_queue_depth =
+			le16_to_cpu(
+				sas_io_unit_page1->narrowport_max_queue_depth);
+
+	if (sas_io_unit_page1->sata_max_queue_depth)
+		adapter->adapter_attr.sata_max_queue_depth =
+			sas_io_unit_page1->sata_max_queue_depth;
+
+out:
+	kfree(sas_io_unit_page1);
+	dev_info(&adapter->pdev->dev,
+		"max wp qd=%d, max np qd=%d, max sata qd=%d\n",
+		adapter->adapter_attr.wideport_max_queue_depth,
+		adapter->adapter_attr.narrowport_max_queue_depth,
+		adapter->adapter_attr.sata_max_queue_depth);
+	return rc;
+}
+
+static int
+leapraid_evt_notify(struct leapraid_adapter *adapter)
+{
+	struct leapraid_evt_notify_req *evt_notify_req;
+	int rc = 0;
+	int i;
+
+	mutex_lock(&adapter->driver_cmds.notify_event_cmd.mutex);
+	adapter->driver_cmds.notify_event_cmd.status = LEAPRAID_CMD_PENDING;
+	evt_notify_req =
+		 leapraid_get_task_desc(adapter,
+			 adapter->driver_cmds.notify_event_cmd.inter_taskid);
+	memset(evt_notify_req, 0, sizeof(struct leapraid_evt_notify_req));
+	evt_notify_req->func = LEAPRAID_FUNC_EVENT_NOTIFY;
+	for (i = 0; i < 4; i++)
+		evt_notify_req->evt_masks[i] =
+			 cpu_to_le32(adapter->fw_evt_s.leapraid_evt_masks[i]);
+	init_completion(&adapter->driver_cmds.notify_event_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.notify_event_cmd.inter_taskid);
+	wait_for_completion_timeout(
+		&adapter->driver_cmds.notify_event_cmd.done,
+		 30 * HZ);
+	if (!(adapter->driver_cmds.notify_event_cmd.status
+			 & LEAPRAID_CMD_DONE))
+		if (adapter->driver_cmds.notify_event_cmd.status
+				 & LEAPRAID_CMD_RESET)
+			rc = -EFAULT;
+	adapter->driver_cmds.notify_event_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.notify_event_cmd.mutex);
+
+	return rc;
+}
+
+
+int
+leapraid_scan_dev(struct leapraid_adapter *adapter, bool async_scan_dev)
+{
+	struct leapraid_scan_dev_req *scan_dev_req;
+	struct leapraid_scan_dev_rep *scan_dev_rep;
+	u16 adapter_status;
+	int rc = 0;
+
+	dev_info(&adapter->pdev->dev,
+		 "send device scan, async_scan_dev=%d!\n", async_scan_dev);
+
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_PENDING;
+	adapter->driver_cmds.scan_dev_cmd.async_scan_dev = async_scan_dev;
+	scan_dev_req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+	memset(scan_dev_req, 0, sizeof(struct leapraid_scan_dev_req));
+	scan_dev_req->func = LEAPRAID_FUNC_SCAN_DEV;
+
+	if (async_scan_dev) {
+		adapter->scan_dev_desc.first_scan_dev_fired = true;
+		leapraid_fire_task(adapter,
+			 adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+		return 0;
+	}
+
+	init_completion(&adapter->driver_cmds.scan_dev_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.scan_dev_cmd.done,
+		 300 * HZ);
+	if (!(adapter->driver_cmds.scan_dev_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev, "device scan timeout!\n");
+		if (adapter->driver_cmds.scan_dev_cmd.status
+			 & LEAPRAID_CMD_RESET)
+			rc = -EFAULT;
+		else
+			rc = -ETIME;
+		goto out;
+	}
+
+	scan_dev_rep = (void *)(&adapter->driver_cmds.scan_dev_cmd.reply);
+	adapter_status = le16_to_cpu(scan_dev_rep->adapter_status)
+		 & LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev, "device scan failure!\n");
+		rc = -EFAULT;
+		goto out;
+	}
+
+out:
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_NOT_USED;
+	dev_info(&adapter->pdev->dev,
+		 "device scan %s\n", ((rc == 0) ? "SUCCESS" : "FAILED"));
+	return rc;
+}
+
+
+static void
+leapraid_init_task_tracker(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dynamic_task_desc.task_lock, flags);
+
+	spin_unlock_irqrestore(&adapter->dynamic_task_desc.task_lock, flags);
+}
+
+static void
+leapraid_init_rep_msg_addr(struct leapraid_adapter *adapter)
+{
+	u32 reply_address;
+	int i;
+
+	for (i = 0, reply_address = (u32) adapter->mem_desc.rep_msg_dma;
+		 i < adapter->adapter_attr.rep_msg_qd; i++,
+		 reply_address += LEAPRAID_REPLY_SIEZ) {
+		adapter->mem_desc.rep_msg_addr[i] = cpu_to_le32(reply_address);
+	}
+}
+
+static void
+init_rep_desc(struct leapraid_rq *rq, int index,
+	 union leapraid_rep_desc_union *reply_post_free_contig)
+{
+	struct leapraid_adapter *adapter = rq->adapter;
+	int i;
+
+	if (!reset_devices)
+		rq->rep_desc =
+			 adapter->mem_desc.rep_desc_seg_maint[index
+			 / LEAPRAID_REP_DESC_CHUNK_SIZE].rep_desc_maint[index
+			 % LEAPRAID_REP_DESC_CHUNK_SIZE].rep_desc;
+	else
+		rq->rep_desc = reply_post_free_contig;
+
+	rq->rep_post_host_idx = 0;
+	for (i = 0; i < adapter->adapter_attr.rep_desc_qd; i++)
+		rq->rep_desc[i].words = cpu_to_le64(~0ULL);
+}
+
+static void
+leapraid_init_rep_desc(struct leapraid_adapter *adapter)
+{
+	union leapraid_rep_desc_union *reply_post_free_contig;
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	int i, index;
+
+	index = 0;
+	reply_post_free_contig =
+		 adapter->mem_desc.rep_desc_seg_maint[0].rep_desc_maint[0].rep_desc;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		init_rep_desc(&int_rq->rq, index, reply_post_free_contig);
+		if (!reset_devices)
+			index++;
+		else
+			reply_post_free_contig +=
+				 adapter->adapter_attr.rep_desc_qd;
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq = &adapter->notification_desc.blk_mq_poll_rqs[i];
+		init_rep_desc(&blk_mq_poll_rq->rq,
+			 index, reply_post_free_contig);
+		if (!reset_devices)
+			index++;
+		else
+			reply_post_free_contig +=
+				 adapter->adapter_attr.rep_desc_qd;
+	}
+}
+
+static void
+leapraid_init_bar_idx_regs(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	int i, j;
+
+	adapter->rep_msg_host_idx = adapter->adapter_attr.rep_msg_qd - 1;
+	writel(adapter->rep_msg_host_idx,
+		 &adapter->iomem_base->rep_msg_host_idx);
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		for (j = 0; j < REP_POST_HOST_IDX_REG_CNT; j++)
+			writel((int_rq->rq.msix_idx & 7)
+				 << LEAPRAID_RPHI_MSIX_IDX_SHIFT,
+				 &adapter->iomem_base->rep_post_reg_idx[j].idx);
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq =
+			 &adapter->notification_desc.blk_mq_poll_rqs[i];
+		for (j = 0; j < REP_POST_HOST_IDX_REG_CNT; j++)
+			writel((blk_mq_poll_rq->rq.msix_idx & 7)
+				 << LEAPRAID_RPHI_MSIX_IDX_SHIFT,
+				 &adapter->iomem_base->rep_post_reg_idx[j].idx);
+	}
+}
+
+static int
+leapraid_make_adapter_available(struct leapraid_adapter *adapter)
+{
+	int rc = 0;
+
+	leapraid_init_task_tracker(adapter);
+	leapraid_init_rep_msg_addr(adapter);
+
+	if (adapter->scan_dev_desc.driver_loading)
+		leapraid_configure_reply_queue_affinity(adapter);
+
+	leapraid_init_rep_desc(adapter);
+	rc = leapraid_send_adapter_init(adapter);
+	if (rc)
+		return rc;
+
+	leapraid_init_bar_idx_regs(adapter);
+	leapraid_unmask_int(adapter);
+	rc = leapraid_cfg_pages(adapter);
+	if (rc)
+		return rc;
+
+	rc = leapraid_evt_notify(adapter);
+	if (rc)
+		return rc;
+
+	if (!adapter->access_ctrl.shost_recovering) {
+		adapter->scan_dev_desc.wait_scan_dev_done = true;
+		rc = 0;
+		return rc;
+	}
+
+	rc = leapraid_scan_dev(adapter, false);
+	if (rc)
+		return rc;
+
+	return rc;
+}
+
+int
+leapraid_ctrl_init(struct leapraid_adapter *adapter)
+{
+	u32 cap;
+	int rc = 0;
+
+	rc = leapraid_set_pcie_and_notification(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	pci_set_drvdata(adapter->pdev, adapter->shost);
+
+	pcie_capability_read_dword(adapter->pdev, PCI_EXP_DEVCAP, &cap);
+
+	if (cap & PCI_EXP_DEVCAP_EXT_TAG) {
+		pcie_capability_set_word(adapter->pdev, PCI_EXP_DEVCTL,
+			 PCI_EXP_DEVCTL_EXT_TAG);
+	}
+
+	rc = leapraid_make_adapter_ready(adapter, PART_RESET);
+	if (rc)
+		goto out_free_resources;
+
+	rc = leapraid_get_adapter_features(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	rc = leapraid_fw_log_init(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	rc = leapraid_request_host_memory(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	init_waitqueue_head(&adapter->reset_desc.reset_wait_queue);
+
+	rc = leapraid_alloc_dev_topo_bitmaps(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	rc = leapraid_init_driver_cmds(adapter);
+	if (rc)
+		goto out_free_resources;
+
+	leapraid_init_event_mask(adapter);
+
+	rc = leapraid_make_adapter_available(adapter);
+	if (rc)
+		goto out_free_resources;
+	return 0;
+
+out_free_resources:
+	adapter->access_ctrl.host_removing = true;
+	leapraid_fw_log_exit(adapter);
+	leapraid_disable_controller(adapter);
+	leapraid_free_host_memory(adapter);
+	leapraid_free_dev_topo_bitmaps(adapter);
+	pci_set_drvdata(adapter->pdev, NULL);
+	return rc;
+}
+
+void
+leapraid_remove_ctrl(struct leapraid_adapter *adapter)
+{
+	leapraid_check_scheduled_fault_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	leapraid_fw_log_exit(adapter);
+	leapraid_disable_controller(adapter);
+	leapraid_free_host_memory(adapter);
+	leapraid_free_dev_topo_bitmaps(adapter);
+	leapraid_free_enc_list(adapter);
+	pci_set_drvdata(adapter->pdev, NULL);
+}
+
+void
+leapraid_free_internal_scsi_cmd(struct leapraid_adapter *adapter)
+{
+	mutex_lock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	kfree(adapter->driver_cmds.internal_scmd);
+	adapter->driver_cmds.internal_scmd = NULL;
+	mutex_unlock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+}
diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/leapraid_func.h
new file mode 100644
index 000000000000..432bd9b9d274
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -0,0 +1,1347 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+ * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
+ * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
+ * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
+ * PURPOSE. Each Recipient is solely responsible for determining
+ * the appropriateness of using and distributing the Program and
+ * assumes all risks associated with its exercise of rights under
+ * this Agreement, including but not limited to the risks and costs
+ * of program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
+ * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES
+ */
+
+#ifndef LEAPRAID_FUNC_H_INCLUDED
+#define LEAPRAID_FUNC_H_INCLUDED
+
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/poll.h>
+#include <linux/errno.h>
+#include <linux/ktime.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsicam.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_sas.h>
+
+#include "leapraid.h"
+
+
+
+#define LEAPRAID_REQUEST_SIZE				(128)
+#define LEAPRAID_REPLY_SIEZ					(128)
+#define LEAPRAID_CHAIN_SEG_SIZE				(128)
+#define LEAPRAID_MAX_SGES_IN_CHAIN			(7)
+#define LEAPRAID_DEFAULT_CHAINS_PER_IO		(19)
+#define LEAPRAID_DEFAULT_DIX_CHAINS_PER_IO	\
+	(2 * LEAPRAID_DEFAULT_CHAINS_PER_IO) /* TODO DIX */
+#define LEAPRAID_IEEE_SGE64_ENTRY_SIZE		(16)
+#define LEAPRAID_REP_DESC_CHUNK_SIZE		(16)
+#define LEAPRAID_REP_DESC_ENTRY_SIZE		(8)
+
+#define LEAPRAID_SYS_LOG_BUF_SIZE		(0x200000)
+#define LEAPRAID_SYS_LOG_BUF_RESERVE	(0x1000)
+
+#define LEAPRAID_DRIVER_NAME		"LeapRaid"
+#define LEAPRAID_NAME_LENGTH		(48)
+#define LEAPRAID_AUTHOR				"LeapIO Inc."
+#define LEAPRAID_DESCRIPTION		"LeapRaid Driver"
+#define LEAPRAID_DRIVER_VERSION		"2.00.00.02"
+#define LEAPRAID_MAJOR_VERSION		(2)
+#define LEAPRAID_MINOR_VERSION		(00)
+#define LEAPRAID_BUILD_VERSION		(00)
+#define LEAPRAID_RELEASE_VERSION	(02)
+
+#define LEAPRAID_VENDOR_ID		(0xD405)
+#define LEAPRAID_DEVID_HBA		(0x8200)
+#define LEAPRAID_DEVID_RAID		(0x8201)
+
+#define RAID_CHANNEL	(1)
+
+#define LEAPRAID_MAX_PHYS_SEGMENTS	SG_CHUNK_SIZE
+
+#define LEAPRAID_KDUMP_MIN_PHYS_SEGMENTS	(32)
+#define LEAPRAID_SG_DEPTH	LEAPRAID_MAX_PHYS_SEGMENTS
+
+#define LEAPRAID_CFP_DEFAULT_TIMEOUT	(15)
+
+#define LEAPRAID_TM_CMD_TIMEOUT		(30)
+
+#define LEAPRAID_SCAN_TIMEOUT_SEC	(300)
+#define LEAPRAID_SCAN_TIMEOUT		(LEAPRAID_SCAN_TIMEOUT_SEC * HZ)
+
+#define LEAPRAID_SET_PARAMETER_SYNC_TIMESTAMP	(0x81)
+
+#define LEAPRAID_CFG_REQ_RETRY_TIMES (2)
+
+#define leapraid_readl(addr) readl(addr)
+#define leapraid_check_reset(status) \
+	(!((status) & LEAPRAID_CMD_RESET))
+#define leapraid_is_end_dev(dev_type) \
+	(dev_type & LEAPRAID_DEVTYP_END_DEV \
+		&& ((dev_type & LEAPRAID_DEVTYP_SSP_TGT) \
+		|| (dev_type & LEAPRAID_DEVTYP_STP_TGT) \
+		|| (dev_type & LEAPRAID_DEVTYP_SATA_DEV)))
+
+#define LEAPRAID_PCIE_LOG_POLLING_INTERVAL	(1)
+#define LEAPRAID_FAULT_POLLING_INTERVAL		(1000)
+#define LEAPRAID_TIMESTAMP_SYNC_INTERVAL	(900)
+#define LEAPRAID_SMART_POLLING_INTERVAL		(300 * 1000)
+
+#define LEAPRAID_SATA_QUEUE_DEPTH	(32)
+#define LEAPRAID_SAS_QUEUE_DEPTH	(254)
+#define LEAPRAID_RAID_QUEUE_DEPTH	(128)
+
+#define LEAPRAID_MAX_SECTORS	(8192)
+
+#define LEAPRAID_INVALID_DEV_HANDLE		(0xFFFF)
+
+/**
+ * struct leapraid_adapter_features - Features and
+ * capabilities of a LeapRAID adapter
+ *
+ * @req_slot: Number of request slots supported by the adapter
+ * @hp_slot: Number of high-priority slots supported by the adapter
+ * @adapter_caps: Adapter capabilities
+ * @fw_version: Firmware version of the adapter
+ * @max_dev_handle: Maximum device supported by the adapter
+ */
+struct leapraid_adapter_features {
+	u16 req_slot;
+	u16 hp_slot;
+	u32 adapter_caps;
+	u32 fw_version;
+	u8 max_volumes;
+	u16 max_dev_handle;
+	u16 min_dev_handle;
+};
+
+/**
+ * struct leapraid_adapter_attr - Adapter attributes and capabilities
+ *
+ * @id: Adapter identifier
+ * @raid_support: Indicates if RAID is supported
+ * @bios_version: Version of the adapter BIOS
+ * @enable_mp: Indicates if multipath (MP) support is enabled
+ * @wideport_max_queue_depth: Maximum queue depth for wide ports
+ * @narrowport_max_queue_depth: Maximum queue depth for narrow ports
+ * @sata_max_queue_depth: Maximum queue depth for SATA
+ * @features: Detailed features of the adapter
+ * @adapter_total_qd: Total queue depth available on the adapter
+ * @io_qd: Queue depth allocated for I/O operations
+ * @rep_msg_qd: Queue depth for reply messages
+ * @rep_desc_qd: Queue depth for reply descriptors
+ * @rep_desc_q_seg_cnt: Number of segments in a reply descriptor queue
+ * @rq_cnt: Number of request queues
+ * @task_desc_dma_size: Size of task descriptor DMA memory
+ * @use_32_dma_mask: Indicates if 32-bit DMA mask is used
+ * @name: Adapter name string
+ */
+struct leapraid_adapter_attr {
+	u8 id;
+	bool raid_support;
+	u32 bios_version;
+	bool enable_mp;
+	u32 wideport_max_queue_depth;
+	u32 narrowport_max_queue_depth;
+	u32 sata_max_queue_depth;
+	struct leapraid_adapter_features features;
+	u32 adapter_total_qd;
+	u32 io_qd;
+	u32 rep_msg_qd;
+	u32 rep_desc_qd;
+	u32 rep_desc_q_seg_cnt;
+	u16 rq_cnt;
+	u32 task_desc_dma_size;
+	bool use_32_dma_mask;
+	char name[LEAPRAID_NAME_LENGTH];
+};
+
+/**
+ * struct leapraid_io_req_tracker - Track a SCSI I/O request
+ * for the adapter
+ *
+ * @taskid: Unique task ID for this I/O request
+ * @scmd: Pointer to the associated SCSI command
+ * @chain_list: List of chain frames associated with this request
+ * @msix_io: MSI-X vector assigned to this I/O request
+ * @chain: Pointer to the chain memory for this request
+ * @chain_dma: DMA address of the chain memory
+ */
+struct leapraid_io_req_tracker {
+	u16 taskid;
+	struct scsi_cmnd *scmd;
+	struct list_head chain_list;
+	u16 msix_io;
+	void *chain;
+	dma_addr_t chain_dma;
+};
+
+/**
+ * struct leapraid_task_tracker - Tracks a task in the adapter
+ *
+ * @taskid: Unique task ID for this tracker
+ * @cb_idx: Callback index associated with this task
+ * @tracker_list: Linked list node to chain this tracker in lists
+ */
+struct leapraid_task_tracker {
+	u16 taskid;
+	u8 cb_idx;
+	struct list_head tracker_list;
+};
+
+/**
+ * struct leapraid_rep_desc_maint - Maintains reply descriptor
+ * memory
+ *
+ * @rep_desc: Pointer to the reply descriptor
+ * @rep_desc_dma: DMA address of the reply descriptor
+ */
+struct leapraid_rep_desc_maint {
+	union leapraid_rep_desc_union *rep_desc;
+	dma_addr_t rep_desc_dma;
+};
+
+/**
+ * struct leapraid_rep_desc_seg_maint - Maintains reply descriptor
+ * segment memory
+ *
+ * @rep_desc_seg: Pointer to the reply descriptor segment
+ * @rep_desc_seg_dma: DMA address of the reply descriptor segment
+ * @rep_desc_maint: Pointer to the main reply descriptor structure
+ */
+struct leapraid_rep_desc_seg_maint {
+	void *rep_desc_seg;
+	dma_addr_t rep_desc_seg_dma;
+	struct leapraid_rep_desc_maint *rep_desc_maint;
+};
+
+/**
+ * struct leapraid_mem_desc - Memory descriptor for LeapRaid adapter
+ *
+ * @task_desc: Pointer to task descriptor
+ * @task_desc_dma: DMA address of task descriptor
+ * @sg_chain_pool: DMA pool for SGL chain allocations
+ * @sg_chain_pool_size: Size of the sg_chain_pool
+ * @taskid_to_uniq_tag: Mapping from task ID to unique tag
+ * @sense_data: Buffer for SCSI sense data
+ * @sense_data_dma: DMA address of sense_data buffer
+ * @rep_msg: Buffer for reply message
+ * @rep_msg_dma: DMA address of reply message buffer
+ * @rep_msg_addr: Pointer to reply message address
+ * @rep_msg_addr_dma: DMA address of reply message address
+ * @rep_desc_seg_maint: Pointer to reply descriptor segment
+ * @rep_desc_q_arr: Pointer to reply descriptor queue array
+ * @rep_desc_q_arr_dma: DMA address of reply descriptor queue array
+ */
+struct leapraid_mem_desc {
+	void *task_desc;
+	dma_addr_t task_desc_dma;
+	struct dma_pool *sg_chain_pool;
+	u16 sg_chain_pool_size;
+	u16 *taskid_to_uniq_tag;
+	u8 *sense_data;
+	dma_addr_t sense_data_dma;
+	u8 *rep_msg;
+	dma_addr_t rep_msg_dma;
+	__le32 *rep_msg_addr;
+	dma_addr_t rep_msg_addr_dma;
+	struct leapraid_rep_desc_seg_maint *rep_desc_seg_maint;
+	struct leapraid_rep_desc_q_arr *rep_desc_q_arr;
+	dma_addr_t rep_desc_q_arr_dma;
+};
+
+#define LEAPRAID_FIXED_INTER_CMDS	(7)
+#define LEAPRAID_FIXED_HP_CMDS		(2)
+#define LEAPRAID_INTER_HP_CMDS_DIF \
+	(LEAPRAID_FIXED_INTER_CMDS - LEAPRAID_FIXED_HP_CMDS)
+
+#define LEAPRAID_CMD_NOT_USED		(0x8000)
+#define LEAPRAID_CMD_DONE			(0x0001)
+#define LEAPRAID_CMD_PENDING		(0x0002)
+#define LEAPRAID_CMD_REPLY_VALID	(0x0004)
+#define LEAPRAID_CMD_RESET			(0x0008)
+
+/**
+ * enum LEAPRAID_CB_INDEX - Callback index for LeapRaid driver
+ *
+ * @LEAPRAID_SCAN_DEV_CB_IDX: Scan device callback index
+ * @LEAPRAID_CONFIG_CB_IDX: Configuration callback index
+ * @LEAPRAID_TRANSPORT_CB_IDX: Transport callback index
+ * @LEAPRAID_TIMESTAMP_SYNC_CB_IDX: Timestamp sync callback index
+ * @LEAPRAID_RAID_ACTION_CB_IDX: RAID action callback index
+ * @LEAPRAID_DRIVER_SCSIIO_CB_IDX: Driver SCSI I/O callback index
+ * @LEAPRAID_SAS_CTRL_CB_IDX: SAS controller callback index
+ * @LEAPRAID_ENC_CB_IDX: Encryption callback index
+ * @LEAPRAID_NOTIFY_EVENT_CB_IDX: Notify event callback index
+ * @LEAPRAID_CTL_CB_IDX: Control callback index
+ * @LEAPRAID_TM_CB_IDX: Task management callback index
+ */
+enum LEAPRAID_CB_INDEX {
+	LEAPRAID_SCAN_DEV_CB_IDX		= 0x1,
+	LEAPRAID_CONFIG_CB_IDX			= 0x2,
+	LEAPRAID_TRANSPORT_CB_IDX		= 0x3,
+	LEAPRAID_TIMESTAMP_SYNC_CB_IDX	= 0x4,
+	LEAPRAID_RAID_ACTION_CB_IDX		= 0x5,
+	LEAPRAID_DRIVER_SCSIIO_CB_IDX	= 0x6,
+	LEAPRAID_SAS_CTRL_CB_IDX		= 0x7,
+	LEAPRAID_ENC_CB_IDX				= 0x8,
+	LEAPRAID_NOTIFY_EVENT_CB_IDX	= 0x9,
+	LEAPRAID_CTL_CB_IDX				= 0xA,
+	LEAPRAID_TM_CB_IDX				= 0xB,
+	LEAPRAID_NUM_CB_IDXS
+};
+
+struct leapraid_default_reply {
+	u8 pad[LEAPRAID_REPLY_SIEZ];
+};
+
+struct leapraid_sense_buffer {
+	u8 pad[SCSI_SENSE_BUFFERSIZE];
+};
+
+/**
+ * struct leapraid_driver_cmd - Driver command tracking structure
+ *
+ * @reply: Default reply structure returned by the adapter
+ * @done: Completion object used to signal command completion
+ * @status: Status code returned by the firmware
+ * @taskid: Unique task identifier for this command
+ * @hp_taskid: Task identifier for high-priority commands
+ * @inter_taskid: Task identifier for internal commands
+ * @cb_idx: Callback index used to identify completion context
+ * @async_scan_dev: True if this command is for asynchronous device scan
+ * @sense: Sense buffer holding error information from device
+ * @mutex: Mutex to protect access to this command structure
+ * @list: List node for linking driver commands into lists
+ */
+struct leapraid_driver_cmd {
+	struct leapraid_default_reply reply;
+	struct completion done;
+	u16 status;
+	u16 taskid;
+	u16 hp_taskid;
+	u16 inter_taskid;
+	u8 cb_idx;
+	bool async_scan_dev;
+	struct leapraid_sense_buffer sense;
+	struct mutex mutex;
+	struct list_head list;
+};
+
+/**
+ * struct leapraid_driver_cmds - Collection of driver command objects
+ *
+ * @special_cmd_list: List head for tracking special driver commands
+ * @scan_dev_cmd: Command used for asynchronous device scan operations
+ * @cfg_op_cmd: Command for configuration operations
+ * @transport_cmd: Command for transport-level operations
+ * @timestamp_sync_cmd: Command for synchronizing timestamp with firmware
+ * @raid_action_cmd: Command for RAID-related management or action requests
+ * @driver_scsiio_cmd: Command used for internal SCSI I/O processing
+ * @enc_cmd: Command for enclosure management operations
+ * @notify_event_cmd: Command for asynchronous event notification handling
+ * @ctl_cmd: Command for generic control or maintenance operations
+ * @tm_cmd: Task management command
+ * @internal_scmd: Pointer to internal SCSI command used by the driver
+ */
+struct leapraid_driver_cmds {
+	struct list_head special_cmd_list;
+	struct leapraid_driver_cmd scan_dev_cmd;
+	struct leapraid_driver_cmd cfg_op_cmd;
+	struct leapraid_driver_cmd transport_cmd;
+	struct leapraid_driver_cmd timestamp_sync_cmd;
+	struct leapraid_driver_cmd raid_action_cmd;
+	struct leapraid_driver_cmd driver_scsiio_cmd;
+	struct leapraid_driver_cmd enc_cmd;
+	struct leapraid_driver_cmd notify_event_cmd;
+	struct leapraid_driver_cmd ctl_cmd;
+	struct leapraid_driver_cmd tm_cmd;
+	struct scsi_cmnd *internal_scmd;
+};
+
+/**
+ * struct leapraid_dynamic_task_desc - Dynamic task descriptor
+ *
+ * @task_lock: Spinlock to protect concurrent access
+ * @hp_taskid: Current high-priority task ID
+ * @hp_cmd_qd: Fixed command queue depth for high-priority tasks
+ * @inter_taskid: Current internal task ID
+ * @inter_cmd_qd: Fixed command queue depth for internal tasks
+ */
+struct leapraid_dynamic_task_desc {
+	spinlock_t task_lock;
+	u16 hp_taskid;
+	u16 hp_cmd_qd;
+	u16 inter_taskid;
+	u16 inter_cmd_qd;
+};
+
+/**
+ * struct leapraid_fw_evt_work - Firmware event work structure
+ *
+ * @list: Linked list node for queuing the work
+ * @adapter: Pointer to the associated LeapRaid adapter
+ * @work: Work structure used by the kernel workqueue
+ * @refcnt: Reference counter for managing the lifetime of this work
+ * @evt_data: Pointer to firmware event data
+ * @dev_handle: Device handle associated with the event
+ * @evt_type: Type of firmware event
+ * @ignore: Flag indicating whether the event should be ignored
+ */
+struct leapraid_fw_evt_work {
+	struct list_head list;
+	struct leapraid_adapter *adapter;
+	struct work_struct work;
+	struct kref refcnt;
+	void *evt_data;
+	u16 dev_handle;
+	u16 evt_type;
+	u8 ignore;
+};
+
+/**
+ * struct leapraid_fw_evt_struct - Firmware event handling structure
+ *
+ * @fw_evt_name: Name of the firmware event
+ * @fw_evt_thread: Workqueue used for processing firmware events
+ * @fw_evt_lock: Spinlock protecting access to the firmware event list
+ * @fw_evt_list: Linked list of pending firmware events
+ * @cur_evt: Pointer to the currently processing firmware event
+ * @fw_evt_cleanup: Flag indicating whether cleanup of events is in progress
+ * @leapraid_evt_masks: Array of event masks for filtering firmware events
+ */
+struct leapraid_fw_evt_struct {
+	char fw_evt_name[48];
+	struct workqueue_struct *fw_evt_thread;
+	spinlock_t fw_evt_lock;
+	struct list_head fw_evt_list;
+	struct leapraid_fw_evt_work *cur_evt;
+	int fw_evt_cleanup;
+	u32 leapraid_evt_masks[4];
+};
+
+/**
+ * struct leapraid_rq - Represents a LeapRaid request queue
+ *
+ * @adapter: Pointer to the associated LeapRaid adapter
+ * @msix_idx: MSI-X vector index used by this queue
+ * @rep_post_host_idx: Index of the last processed reply descriptor
+ * @rep_desc: Pointer to the reply descriptor associated with this queue
+ * @name: Name of the request queue
+ * @busy: Atomic counter indicating if the queue is busy
+ */
+struct leapraid_rq {
+	struct leapraid_adapter *adapter;
+	u8 msix_idx;
+	u32 rep_post_host_idx;
+	union leapraid_rep_desc_union *rep_desc;
+	char name[LEAPRAID_NAME_LENGTH];
+	atomic_t busy;
+};
+
+/**
+ * struct leapraid_int_rq - Internal request queue for a CPU
+ *
+ * @affinity_hint: CPU affinity mask for the queue
+ * @rq: Underlying LeapRaid request queue structure
+ */
+struct leapraid_int_rq {
+	cpumask_var_t affinity_hint;
+	struct leapraid_rq rq;
+};
+
+/**
+ * struct leapraid_blk_mq_poll_rq - Polling request for LeapRaid blk-mq
+ *
+ * @busy: Atomic flag indicating request is being processed
+ * @pause: Atomic flag to temporarily suspend polling
+ * @rq: The underlying LeapRaid request structure
+ */
+struct leapraid_blk_mq_poll_rq {
+	atomic_t busy;
+	atomic_t pause;
+	struct leapraid_rq rq;
+};
+
+/**
+ * struct leapraid_notification_desc - Notification
+ * descriptor for LeapRaid
+ *
+ * @iopoll_qdex: Index of the I/O polling queue
+ * @iopoll_qcnt: Count of I/O polling queues
+ * @msix_enable: Flag indicating MSI-X is enabled
+ * @msix_cpu_map: CPU map for MSI-X interrupts
+ * @msix_cpu_map_sz: Size of the MSI-X CPU map
+ * @int_rqs: Array of interrupt request queues
+ * @int_rqs_allocated: Count of allocated interrupt request queues
+ * @blk_mq_poll_rqs: Array of blk-mq polling requests
+ */
+struct leapraid_notification_desc {
+	u32 iopoll_qdex;
+	u32 iopoll_qcnt;
+	bool msix_enable;
+	u8 *msix_cpu_map;
+	u32 msix_cpu_map_sz;
+	struct leapraid_int_rq *int_rqs;
+	u32 int_rqs_allocated;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rqs;
+};
+
+/**
+ * struct leapraid_reset_desc - Reset descriptor for LeapRaid
+ *
+ * @fault_reset_wq: Workqueue for fault reset operations
+ * @fault_reset_work: Delayed work structure for fault reset
+ * @fault_reset_wq_name: Name of the fault reset workqueue
+ * @host_diag_mutex: Mutex for host diagnostic operations
+ * @adapter_reset_lock: Spinlock for adapter reset operations
+ * @adapter_reset_mutex: Mutex for adapter reset operations
+ * @adapter_link_resetting: Flag indicating if adapter link is resetting
+ * @adapter_reset_results: Results of the adapter reset operation
+ * @pending_io_cnt: Count of pending I/O operations
+ * @reset_wait_queue: Wait queue for reset operations
+ * @reset_cnt: Counter for reset operations
+ */
+struct leapraid_reset_desc {
+	struct workqueue_struct *fault_reset_wq;
+	struct delayed_work fault_reset_work;
+	char fault_reset_wq_name[48];
+	struct mutex host_diag_mutex;
+	spinlock_t adapter_reset_lock;
+	struct mutex adapter_reset_mutex;
+	bool adapter_link_resetting;
+	int adapter_reset_results;
+	int pending_io_cnt;
+	wait_queue_head_t reset_wait_queue;
+	u32 reset_cnt;
+};
+
+/**
+ * struct leapraid_scan_dev_desc - Scan device descriptor
+ * for LeapRaid
+ *
+ * @wait_scan_dev_done: Flag indicating if scan device operation is done
+ * @driver_loading: Flag indicating if driver is loading
+ * @first_scan_dev_fired: Flag indicating if first scan device operation fired
+ * @scan_dev_failed: Flag indicating if scan device operation failed
+ * @scan_start: Flag indicating if scan operation started
+ * @scan_start_failed: Count of failed scan start operations
+ */
+struct leapraid_scan_dev_desc {
+	bool wait_scan_dev_done;
+	bool driver_loading;
+	bool first_scan_dev_fired;
+	bool scan_dev_failed;
+	bool scan_start;
+	u16 scan_start_failed;
+};
+
+/**
+ * struct leapraid_access_ctrl - Access control structure for LeapRaid
+ *
+ * @pci_access_lock: Mutex for PCI access control
+ * @adapter_thermal_alert: Flag indicating if adapter thermal alert is active
+ * @shost_recovering: Flag indicating if host is recovering
+ * @host_removing: Flag indicating if host is being removed
+ * @pcie_recovering: Flag indicating if PCIe is recovering
+ */
+struct leapraid_access_ctrl {
+	struct mutex pci_access_lock;
+	bool adapter_thermal_alert;
+	bool shost_recovering;
+	bool host_removing;
+	bool pcie_recovering;
+};
+
+/**
+ * struct leapraid_fw_log_desc - Firmware log descriptor for LeapRaid
+ *
+ * @fw_log_buffer: Buffer for firmware log data
+ * @fw_log_buffer_dma: DMA address of the firmware log buffer
+ * @fw_log_wq_name: Name of the firmware log workqueue
+ * @fw_log_wq: Workqueue for firmware log operations
+ * @fw_log_work: Delayed work structure for firmware log
+ * @open_pcie_trace: Flag indicating if PCIe tracing is open
+ * @fw_log_init_flag: Flag indicating if firmware log is initialized
+ */
+struct leapraid_fw_log_desc {
+	u8 *fw_log_buffer;
+	dma_addr_t fw_log_buffer_dma;
+	char fw_log_wq_name[48];
+	struct workqueue_struct *fw_log_wq;
+	struct delayed_work fw_log_work;
+	int open_pcie_trace;
+	int fw_log_init_flag;
+};
+
+#define LEAPRAID_CARD_PORT_FLG_DIRTY	(0x01)
+#define LEAPRAID_CARD_PORT_FLG_NEW		(0x02)
+#define LEAPRAID_DISABLE_MP_PORT_ID		(0xFF)
+/**
+ * struct leapraid_card_port - Card port structure for LeapRaid
+ *
+ * @list: List head for card port
+ * @vphys_list: List head for virtual phy list
+ * @port_id: Port ID
+ * @sas_address: SAS address
+ * @phy_mask: Mask of phy
+ * @vphys_mask: Mask of virtual phy
+ * @flg: Flags for the port
+ */
+struct leapraid_card_port {
+	struct list_head list;
+	struct list_head vphys_list;
+	u8 port_id;
+	u64 sas_address;
+	u32 phy_mask;
+	u32 vphys_mask;
+	u8 flg;
+};
+
+/**
+ * struct leapraid_card_phy - Card phy structure for LeapRaid
+ *
+ * @port_siblings: List head for port siblings
+ * @card_port: Pointer to the card port
+ * @identify: SAS identify structure
+ * @remote_identify: Remote SAS identify structure
+ * @phy: SAS phy structure
+ * @phy_id: Phy ID
+ * @hdl: Handle for the port
+ * @attached_hdl: Handle for the attached port
+ * @phy_is_assigned: Flag indicating if phy is assigned
+ * @vphy: Flag indicating if virtual phy
+ */
+struct leapraid_card_phy {
+	struct list_head port_siblings;
+	struct leapraid_card_port *card_port;
+	struct sas_identify identify;
+	struct sas_identify remote_identify;
+	struct sas_phy *phy;
+	u8 phy_id;
+	u16 hdl;
+	u16 attached_hdl;
+	bool phy_is_assigned;
+	bool vphy;
+};
+
+/**
+ * struct leapraid_topo_node - SAS topology node for LeapRaid
+ *
+ * @list: List head for linking nodes
+ * @sas_port_list: List of SAS ports
+ * @card_port: Associated card port
+ * @card_phy: Associated card PHY
+ * @rphy: SAS remote PHY device
+ * @parent_dev: Parent device pointer
+ * @sas_address: SAS address of this node
+ * @sas_address_parent: Parent node's SAS address
+ * @phys_num: Number of physical links
+ * @hdl: Handle identifier
+ * @enc_hdl: Enclosure handle
+ * @enc_lid: Enclosure logical identifier
+ * @resp: Response status flag
+ */
+struct leapraid_topo_node {
+	struct list_head list;
+	struct list_head sas_port_list;
+	struct leapraid_card_port *card_port;
+	struct leapraid_card_phy *card_phy;
+	struct sas_rphy *rphy;
+	struct device *parent_dev;
+	u64 sas_address;
+	u64 sas_address_parent;
+	u8 phys_num;
+	u16 hdl;
+	u16 enc_hdl;
+	u64 enc_lid;
+	bool resp;
+};
+
+/**
+ * struct leapraid_dev_topo - LeapRaid device topology management structure
+ *
+ * @topo_node_lock: Spinlock for protecting topology node operations
+ * @sas_dev_lock: Spinlock for SAS device list access
+ * @raid_volume_lock: Spinlock for RAID volume list access
+ * @sas_id: SAS domain identifier
+ * @card: Main card topology node
+ * @exp_list: List of expander devices
+ * @enc_list: List of enclosure devices
+ * @sas_dev_list: List of SAS devices
+ * @sas_dev_init_list: List of SAS devices being initialized
+ * @raid_volume_list: List of RAID volumes
+ * @card_port_list: List of card ports
+ * @pd_hdls: Array of physical disk handles
+ * @dev_removing: Array tracking devices being removed
+ * @pending_dev_add: Array tracking devices pending addition
+ * @blocking_hdls: Array of blocking handles
+ */
+struct leapraid_dev_topo {
+	spinlock_t topo_node_lock;
+	spinlock_t sas_dev_lock;
+	spinlock_t raid_volume_lock;
+	int sas_id;
+	struct leapraid_topo_node card;
+	struct list_head exp_list;
+	struct list_head enc_list;
+	struct list_head sas_dev_list;
+	struct list_head sas_dev_init_list;
+	struct list_head raid_volume_list;
+	struct list_head card_port_list;
+	u16 pd_hdls_sz;
+	void *pd_hdls;
+	void *blocking_hdls;
+	u16 pending_dev_add_sz;
+	void *pending_dev_add;
+	u16 dev_removing_sz;
+	void *dev_removing;
+};
+
+
+/**
+ * struct leapraid_boot_dev - Boot device structure for LeapRaid
+ *
+ * @dev: Device pointer
+ * @chnl: Channel number
+ * @form: Form factor
+ * @pg_dev: Config page device content
+ */
+struct leapraid_boot_dev {
+	void *dev;
+	u8 chnl;
+	u8 form;
+	u8 pg_dev[24];
+};
+
+/**
+ * struct leapraid_boot_devs - Boot device management structure
+ * @requested_boot_dev: Requested primary boot device
+ * @requested_alt_boot_dev: Requested alternate boot device
+ * @current_boot_dev: Currently active boot device
+ */
+struct leapraid_boot_devs {
+	struct leapraid_boot_dev requested_boot_dev;
+	struct leapraid_boot_dev requested_alt_boot_dev;
+	struct leapraid_boot_dev current_boot_dev;
+};
+
+/**
+ * struct leapraid_smart_poll_desc - SMART polling descriptor
+ * @smart_poll_wq: Workqueue for SMART polling tasks
+ * @smart_poll_work: Delayed work for SMART polling operations
+ * @smart_poll_wq_name: Workqueue name string
+ */
+struct leapraid_smart_poll_desc {
+	struct workqueue_struct *smart_poll_wq;
+	struct delayed_work smart_poll_work;
+	char smart_poll_wq_name[48];
+};
+
+
+/**
+ * struct leapraid_adapter - Main LeapRaid adapter structure
+ * @list: List head for adapter management
+ * @shost: SCSI host structure
+ * @pdev: PCI device structure
+ * @iomem_base: I/O memory mapped base address
+ * @rep_msg_host_idx: Host index for reply messages
+ * @mask_int: Interrupt masking flag
+ * @timestamp_sync_cnt: Timestamp synchronization counter
+ * @adapter_attr: Adapter attributes
+ * @mem_desc: Memory descriptor
+ * @driver_cmds: Driver commands
+ * @dynamic_task_desc: Dynamic task descriptor
+ * @fw_evt_s: Firmware event structure
+ * @notification_desc: Notification descriptor
+ * @reset_desc: Reset descriptor
+ * @scan_dev_desc: Device scan descriptor
+ * @access_ctrl: Access control
+ * @fw_log_desc: Firmware log descriptor
+ * @dev_topo: Device topology
+ * @boot_devs: Boot devices
+ * @smart_poll_desc: SMART polling descriptor
+ */
+struct leapraid_adapter {
+	struct list_head list;
+	struct Scsi_Host *shost;
+	struct pci_dev *pdev;
+	struct leapraid_reg_base __iomem *iomem_base;
+	u32 rep_msg_host_idx;
+	bool mask_int;
+	u32 timestamp_sync_cnt;
+
+	struct leapraid_adapter_attr adapter_attr;
+	struct leapraid_mem_desc mem_desc;
+	struct leapraid_driver_cmds driver_cmds;
+	struct leapraid_dynamic_task_desc dynamic_task_desc;
+	struct leapraid_fw_evt_struct fw_evt_s;
+	struct leapraid_notification_desc notification_desc;
+	struct leapraid_reset_desc reset_desc;
+	struct leapraid_scan_dev_desc scan_dev_desc;
+	struct leapraid_access_ctrl access_ctrl;
+	struct leapraid_fw_log_desc fw_log_desc;
+	struct leapraid_dev_topo dev_topo;
+	struct leapraid_boot_devs boot_devs;
+	struct leapraid_smart_poll_desc smart_poll_desc;
+};
+
+union cfg_param_1 {
+	u32 form;
+	u32 size;
+	u32 phy_number;
+};
+
+union cfg_param_2 {
+	u32 handle;
+	u32 form_specific;
+};
+
+enum config_page_action {
+	GET_BIOS_PG2,
+	GET_BIOS_PG3,
+	GET_SAS_DEVICE_PG0,
+	GET_SAS_IOUNIT_PG0,
+	GET_SAS_IOUNIT_PG1,
+	GET_SAS_EXPANDER_PG0,
+	GET_SAS_EXPANDER_PG1,
+	GET_SAS_ENCLOSURE_PG0,
+	GET_PHY_PG0,
+	GET_RAID_VOLUME_PG0,
+	GET_RAID_VOLUME_PG1,
+	GET_PHY_DISK_PG0,
+};
+
+/**
+ * struct leapraid_enc_node - Enclosure node structure
+ * @list: List head for enclosure management
+ * @pg0: Enclosure page 0 data
+ */
+struct leapraid_enc_node {
+	struct list_head list;
+	struct leapraid_enc_p0 pg0;
+};
+
+/**
+ * struct leapraid_raid_volume - RAID volume structure
+ * @list: List head for volume management
+ * @starget: SCSI target structure
+ * @sdev: SCSI device structure
+ * @id: Volume ID
+ * @channel: SCSI channel
+ * @wwid: World Wide Identifier
+ * @hdl: Volume handle
+ * @vol_type: Volume type
+ * @pd_num: Number of physical disks
+ * @resp: Response status
+ * @dev_info: Device information
+ */
+struct leapraid_raid_volume {
+	struct list_head list;
+	struct scsi_target *starget;
+	struct scsi_device *sdev;
+	int id;
+	int channel;
+	u64 wwid;
+	u16 hdl;
+	u8 vol_type;
+	u8 pd_num;
+	u8 resp;
+	u32 dev_info;
+};
+
+#define LEAPRAID_TGT_FLG_RAID_MEMBER	(0x01)
+#define LEAPRAID_TGT_FLG_VOLUME			(0x02)
+/**
+ * struct leapraid_starget_priv - SCSI target private data
+ * @starget: SCSI target structure
+ * @sas_address: SAS address
+ * @hdl: Device handle
+ * @num_luns: Number of LUNs
+ * @flg: Flags
+ * @deleted: Deletion flag
+ * @tm_busy: Task management busy flag
+ * @card_port: Associated card port
+ * @sas_dev: SAS device structure
+ */
+struct leapraid_starget_priv {
+	struct scsi_target *starget;
+	u64 sas_address;
+	u16 hdl;
+	int num_luns;
+	u32 flg;
+	bool deleted;
+	bool tm_busy;
+	struct leapraid_card_port *card_port;
+	struct leapraid_sas_dev *sas_dev;
+};
+
+#define LEAPRAID_DEVICE_FLG_INIT	(0x01)
+/**
+ * struct leapraid_sdev_priv - SCSI device private data
+ * @starget_priv: Associated target private data
+ * @lun: Logical Unit Number
+ * @flg: Flags
+ * @block: Block flag
+ * @deleted: Deletion flag
+ * @sep: SEP flag
+ */
+struct leapraid_sdev_priv {
+	struct leapraid_starget_priv *starget_priv;
+	unsigned int lun;
+	u32 flg;
+	bool ncq;
+	bool block;
+	bool deleted;
+	bool sep;
+};
+
+/**
+ * struct leapraid_sas_dev - SAS device structure
+ * @list: List head for device management
+ * @starget: SCSI target structure
+ * @card_port: Associated card port
+ * @rphy: SAS remote PHY
+ * @refcnt: Reference count
+ * @id: Device ID
+ * @channel: SCSI channel
+ * @slot: Slot number
+ * @phy: PHY identifier
+ * @resp: Response status
+ * @led_on: LED state
+ * @sas_addr: SAS address
+ * @dev_name: Device name
+ * @hdl: Device handle
+ * @parent_sas_addr: Parent SAS address
+ * @enc_hdl: Enclosure handle
+ * @enc_lid: Enclosure logical ID
+ * @volume_hdl: Volume handle
+ * @volume_wwid: Volume WWID
+ * @dev_info: Device information
+ * @pend_sas_rphy_add: Pending SAS rphy addition flag
+ * @enc_level: Enclosure level
+ * @port_type: Port type
+ * @connector_name: Connector name
+ * @support_smart: SMART support flag
+ */
+struct leapraid_sas_dev {
+	struct list_head list;
+	struct scsi_target *starget;
+	struct leapraid_card_port *card_port;
+	struct sas_rphy *rphy;
+	struct kref refcnt;
+	int id;
+	int channel;
+	u16 slot;
+	u8 phy;
+	bool resp;
+	bool led_on;
+	u64 sas_addr;
+	u64 dev_name;
+	u16 hdl;
+	u64 parent_sas_addr;
+	u16 enc_hdl;
+	u64 enc_lid;
+	u16 volume_hdl;
+	u64 volume_wwid;
+	u32 dev_info;
+	u8 pend_sas_rphy_add;
+	u8 enc_level;
+	u8 port_type;
+	u8 connector_name[5];
+	bool support_smart;
+};
+
+static inline void leapraid_sdev_free(struct kref *ref)
+{
+	kfree(container_of(ref, struct leapraid_sas_dev, refcnt));
+}
+#define leapraid_sdev_get(sdev)	\
+	kref_get(&(sdev)->refcnt)
+#define leapraid_sdev_put(sdev)	\
+	kref_put(&(sdev)->refcnt, leapraid_sdev_free)
+
+/**
+ * struct leapraid_sas_port - SAS port structure
+ * @port_list: List head for port management
+ * @phy_list: List of PHYs in this port
+ * @port: SAS port structure
+ * @card_port: Associated card port
+ * @remote_identify: Remote device identification
+ * @rphy: SAS remote PHY
+ * @phys_num: Number of PHYs in this port
+ */
+struct leapraid_sas_port {
+	struct list_head port_list;
+	struct list_head phy_list;
+	struct sas_port *port;
+	struct leapraid_card_port *card_port;
+	struct sas_identify remote_identify;
+	struct sas_rphy *rphy;
+	u8 phys_num;
+};
+
+#define LEAPRAID_VPHY_FLG_DIRTY	(0x01)
+/**
+ * struct leapraid_vphy - Virtual PHY structure
+ * @list: List head for PHY management
+ * @sas_address: SAS address
+ * @phy_mask: PHY mask
+ * @flg: Flags
+ */
+struct leapraid_vphy {
+	struct list_head list;
+	u64 sas_address;
+	u32 phy_mask;
+	u8 flg;
+};
+
+struct leapraid_tgt_rst_list {
+	struct list_head list;
+	u16 handle;
+	u16 state;
+};
+
+struct leapraid_sc_list {
+	struct list_head list;
+	u16 handle;
+};
+
+struct sense_info {
+	u8 sense_key;
+	u8 asc;
+	u8 ascq;
+};
+
+struct leapraid_fw_log_info {
+	u32 user_position;
+	u32 adapter_position;
+};
+
+/**
+ * enum reset_type - Reset type enumeration
+ * @FULL_RESET: Full hardware reset
+ * @PART_RESET: Partial reset
+ */
+enum reset_type {
+	FULL_RESET,
+	PART_RESET,
+};
+
+enum leapraid_card_port_checking_flg {
+	CARD_PORT_FURTHER_CHECKING_NEEDED = 0,
+	CARD_PORT_SKIP_CHECKING,
+};
+
+enum leapraid_port_checking_state {
+	NEW_CARD_PORT = 0,
+	SAME_PORT_WITH_NOTHING_CHANGED,
+	SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS,
+	SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS,
+	SAME_ADDR_ONLY,
+};
+
+/**
+ * struct leapraid_card_port_feature - Card port feature
+ * @dirty_flg: Dirty flag indicator
+ * @same_addr: Same address flag
+ * @exact_phy: Exact PHY match flag
+ * @phy_overlap: PHY overlap bitmap
+ * @same_port: Same port flag
+ * @cur_chking_old_port: Current checking old port
+ * @expected_old_port: Expected old port
+ * @same_addr_port_count: Same address port count
+ * @checking_state: Port checking state
+ */
+struct leapraid_card_port_feature {
+	u8 dirty_flg;
+	bool same_addr;
+	bool exact_phy;
+	u32 phy_overlap;
+	bool same_port;
+	struct leapraid_card_port *cur_chking_old_port;
+	struct leapraid_card_port *expected_old_port;
+	int same_addr_port_count;
+	enum leapraid_port_checking_state checking_state;
+};
+
+#define SMP_REPORT_MANUFACTURER_INFORMATION_FRAME_TYPE	(0x40)
+#define SMP_REPORT_MANUFACTURER_INFORMATION_FUNC		(0x01)
+
+/**
+ * ref: SAS-2(INCITS 457-2010) 10.4.3.5
+ */
+struct leapraid_rep_manu_request {
+	u8 smp_frame_type;
+	u8 function;
+	u8 allocated_response_length;
+	u8 request_length;
+};
+
+/**
+ * ref: SAS-2(INCITS 457-2010) 10.4.3.5
+ */
+struct leapraid_rep_manu_reply {
+	u8 smp_frame_type;
+	u8 function;
+	u8 function_result;
+	u8 response_length;
+	u16 expander_change_count;
+	u8 r1[2];
+	u8 sas_format;
+	u8 r2[3];
+	u8 vendor_identification[SAS_EXPANDER_VENDOR_ID_LEN];
+	u8 product_identification[SAS_EXPANDER_PRODUCT_ID_LEN];
+	u8 product_revision_level[SAS_EXPANDER_PRODUCT_REV_LEN];
+	u8 component_vendor_identification[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u16 component_id;
+	u8 component_revision_level;
+	u8 r3;
+	u8 vendor_specific[8];
+};
+
+/**
+ * struct leapraid_scsi_cmd_desc - SCSI command descriptor
+ * @hdl: Device handle
+ * @lun: Logical Unit Number
+ * @raid_member: RAID member flag
+ * @dir: DMA data direction
+ * @data_length: Data transfer length
+ * @data_buffer: Data buffer pointer
+ * @cdb_length: CDB length
+ * @cdb: Command Descriptor Block
+ * @time_out: Timeout
+ */
+struct leapraid_scsi_cmd_desc {
+	u16 hdl;
+	u32 lun;
+	bool raid_member;
+	enum dma_data_direction dir;
+	u32 data_length;
+	void *data_buffer;
+	u8 cdb_length;
+	u8 cdb[32];
+	u8 time_out;
+};
+
+extern struct list_head leapraid_adapter_list;
+extern spinlock_t leapraid_adapter_lock;
+extern char driver_name[LEAPRAID_NAME_LENGTH];
+
+int leapraid_ctrl_init(struct leapraid_adapter *adapter);
+void leapraid_remove_ctrl(struct leapraid_adapter *adapter);
+void leapraid_check_scheduled_fault_start(
+	struct leapraid_adapter *adapter);
+void leapraid_check_scheduled_fault_stop(
+	struct leapraid_adapter *adapter);
+void leapraid_fw_log_start(struct leapraid_adapter *adapter);
+void leapraid_fw_log_stop(struct leapraid_adapter *adapter);
+int leapraid_set_pcie_and_notification(struct leapraid_adapter *adapter);
+void leapraid_disable_controller(struct leapraid_adapter *adapter);
+int leapraid_hard_reset_handler(struct leapraid_adapter *adapter,
+	 enum reset_type type);
+void leapraid_mask_int(struct leapraid_adapter *adapter);
+void leapraid_unmask_int(struct leapraid_adapter *adapter);
+u32 leapraid_get_adapter_state(struct leapraid_adapter *adapter);
+bool leapraid_pci_removed(struct leapraid_adapter *adapter);
+int leapraid_check_adapter_is_op(struct leapraid_adapter *adapter);
+void *leapraid_get_task_desc(struct leapraid_adapter *adapter,
+	 u16 taskid);
+void *leapraid_get_sense_buffer(struct leapraid_adapter *adapter,
+	 u16 taskid);
+__le32 leapraid_get_sense_buffer_dma(struct leapraid_adapter *adapter,
+	 u16 taskid);
+void *leapraid_get_reply_vaddr(struct leapraid_adapter *adapter,
+	 u32 phys_addr);
+u16 leapraid_alloc_scsiio_taskid(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd);
+void leapraid_free_taskid(struct leapraid_adapter *adapter, u16 taskid);
+struct leapraid_io_req_tracker *
+leapraid_get_io_tracker_from_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid);
+struct leapraid_io_req_tracker *
+leapraid_get_scmd_priv(struct scsi_cmnd *scmd);
+struct scsi_cmnd *
+leapraid_get_scmd_from_taskid(struct leapraid_adapter *adapter,
+	 u16 taskid);
+int leapraid_scan_dev(struct leapraid_adapter *adapter,
+	 bool async_scan_dev);
+void leapraid_scan_dev_done(struct leapraid_adapter *adapter);
+void leapraid_wait_cmds_done(struct leapraid_adapter *adapter);
+void leapraid_clean_active_scsi_cmds(struct leapraid_adapter *adapter);
+void leapraid_sync_irqs(struct leapraid_adapter *adapter, bool poll);
+int leapraid_rep_queue_handler(struct leapraid_rq *rq);
+int leapraid_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void leapraid_mq_polling_pause(struct leapraid_adapter *adapter);
+void leapraid_mq_polling_resume(struct leapraid_adapter *adapter);
+void leapraid_set_tm_flg(struct leapraid_adapter *adapter, u16 handle);
+void leapraid_clear_tm_flg(struct leapraid_adapter *adapter, u16 handle);
+void leapraid_async_turn_on_led(struct leapraid_adapter *adapter,
+	 u16 handle);
+int leapraid_issue_locked_tm(struct leapraid_adapter *adapter,
+	 u16 handle, uint channel, uint id,
+	 uint lun, u8 type, u16 taskid_task,
+	 u8 tr_method);
+int leapraid_issue_tm(struct leapraid_adapter *adapter,
+	 u16 handle, uint channel, uint id, uint lun, u8 type,
+	 u16 taskid_task, u8 tr_method);
+u8 leapraid_scsiio_done(struct leapraid_adapter *adapter,
+	 u16 taskid, u8 msix_index, u32 rep);
+int leapraid_get_volume_cap(struct leapraid_adapter *adapter,
+	 struct leapraid_raid_volume *raid_volume);
+int leapraid_internal_init_cmd_priv(struct leapraid_adapter *adapter,
+	 struct leapraid_io_req_tracker *io_tracker);
+int leapraid_internal_exit_cmd_priv(struct leapraid_adapter *adapter,
+	 struct leapraid_io_req_tracker *io_tracker);
+void leapraid_clean_active_fw_evt(struct leapraid_adapter *adapter);
+bool leapraid_scmd_find_by_lun(struct leapraid_adapter *adapter,
+	 int id, unsigned int lun, int channel);
+bool leapraid_scmd_find_by_tgt(struct leapraid_adapter *adapter,
+	 int id, int channel);
+struct leapraid_vphy *
+leapraid_get_vphy_by_phy(struct leapraid_card_port *port, u32 phy);
+struct leapraid_raid_volume *
+leapraid_raid_volume_find_by_id(struct leapraid_adapter *adapter,
+	 int id, int channel);
+struct leapraid_raid_volume *
+leapraid_raid_volume_find_by_hdl(struct leapraid_adapter *adapter,
+	 u16 handle);
+struct leapraid_topo_node *
+leapraid_exp_find_by_sas_address(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+	struct leapraid_adapter *adapter,
+		 u64 sas_address, struct sas_rphy *rphy);
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_by_addr(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_by_hdl(struct leapraid_adapter *adapter,
+	 u16 handle);
+struct leapraid_sas_dev *
+leapraid_get_sas_dev_from_tgt(struct leapraid_adapter *adapter,
+	 struct leapraid_starget_priv *tgt_priv);
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_from_tgt(struct leapraid_adapter *adapter,
+	 struct leapraid_starget_priv *tgt_priv);
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_hdl(struct leapraid_adapter *adapter,
+	 u16 handle);
+struct leapraid_sas_dev *
+leapraid_hold_lock_get_sas_dev_by_addr(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+struct leapraid_sas_dev *
+leapraid_get_next_sas_dev_from_init_list(struct leapraid_adapter *adapter);
+void leapraid_sas_dev_remove_by_sas_address(
+	struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+void leapraid_sas_dev_remove(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev);
+void leapraid_raid_volume_remove(struct leapraid_adapter *adapter,
+	 struct leapraid_raid_volume *raid_volume);
+void leapraid_exp_rm(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct leapraid_card_port *port);
+void leapraid_build_mpi_sg(struct leapraid_adapter *adapter,
+	 void *sge, dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size);
+void leapraid_build_ieee_nodata_sg(struct leapraid_adapter *adapter,
+	 void *sge);
+void leapraid_build_ieee_sg(struct leapraid_adapter *adapter,
+	 void *psge, dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size);
+int leapraid_build_scmd_ieee_sg(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd, u16 taskid);
+void leapraid_fire_scsi_io(struct leapraid_adapter *adapter,
+	 u16 taskid, u16 handle);
+void leapraid_fire_hpr_task(struct leapraid_adapter *adapter,
+	 u16 taskid, u16 msix_task);
+void leapraid_fire_task(struct leapraid_adapter *adapter,
+	 u16 taskid);
+int leapraid_cfg_get_volume_hdl(struct leapraid_adapter *adapter,
+	 u16 pd_handle, u16 *volume_handle);
+int leapraid_cfg_get_volume_wwid(struct leapraid_adapter *adapter,
+	 u16 volume_handle, u64 *wwid);
+int leapraid_op_config_page(struct leapraid_adapter *adapter,
+	 void *cfgp, union cfg_param_1 cfgp1,
+	 union cfg_param_2 cfgp2,
+	 enum config_page_action cfg_op);
+void leapraid_adjust_sdev_queue_depth(struct scsi_device *sdev,
+	 int qdepth);
+
+int leapraid_ctl_release(struct inode *inode, struct file *filep);
+void leapraid_ctl_init(void);
+void leapraid_ctl_exit(void);
+
+extern struct sas_function_template leapraid_transport_functions;
+extern struct scsi_transport_template *leapraid_transport_template;
+struct leapraid_sas_port *
+leapraid_transport_port_add(struct leapraid_adapter *adapter,
+	 u16 handle, u64 sas_address,
+	 struct leapraid_card_port *card_port);
+void leapraid_transport_port_remove(struct leapraid_adapter *adapter,
+	 u64 sas_address, u64 sas_address_parent,
+	 struct leapraid_card_port *card_port);
+void leapraid_transport_add_card_phy(struct leapraid_adapter *adapter,
+	 struct leapraid_card_phy *card_phy,
+	 struct leapraid_sas_phy_p0 *phy_pg0,
+	 struct device *parent_dev);
+int leapraid_transport_add_exp_phy(struct leapraid_adapter *adapter,
+	 struct leapraid_card_phy *card_phy,
+	 struct leapraid_exp_p1 *exp_pg1,
+	 struct device *parent_dev);
+void leapraid_transport_update_links(struct leapraid_adapter *adapter,
+	 u64 sas_address, u16 handle,
+	 u8 phy_number, u8 link_rate,
+	 struct leapraid_card_port *card_port);
+void leapraid_transport_detach_phy_to_port(
+	struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node,
+	 struct leapraid_card_phy *card_phy);
+void leapraid_transport_attach_phy_to_port(
+	struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *sas_node,
+	 struct leapraid_card_phy *card_phy,
+	 u64 sas_address,
+	 struct leapraid_card_port *card_port);
+int leapraid_queuecommand(struct Scsi_Host *shost,
+	 struct scsi_cmnd *scmd);
+void leapraid_smart_polling_start(struct leapraid_adapter *adapter);
+void leapraid_smart_polling_stop(struct leapraid_adapter *adapter);
+void leapraid_smart_fault_detect(struct leapraid_adapter *adapter,
+	 u16 hdl);
+void leapraid_free_internal_scsi_cmd(struct leapraid_adapter *adapter);
+
+#endif /* LEAPRAID_FUNC_H_INCLUDED */
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
new file mode 100644
index 000000000000..5c8180ba8264
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -0,0 +1,2390 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+ * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
+ * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
+ * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
+ * PURPOSE. Each Recipient is solely responsible for determining
+ * the appropriateness of using and distributing the Program and
+ * assumes all risks associated with its exercise of rights under
+ * this Agreement, including but not limited to the risks and costs
+ * of program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
+ * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES
+ */
+
+#include <linux/module.h>
+
+#include "leapraid_func.h"
+#include "leapraid.h"
+
+LIST_HEAD(leapraid_adapter_list);
+DEFINE_SPINLOCK(leapraid_adapter_lock);
+
+MODULE_AUTHOR(LEAPRAID_AUTHOR);
+MODULE_DESCRIPTION(LEAPRAID_DESCRIPTION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(LEAPRAID_DRIVER_VERSION);
+
+static int leapraid_ids;
+
+static int open_pcie_trace = 1;
+module_param(open_pcie_trace, int, 0644);
+MODULE_PARM_DESC(open_pcie_trace,
+	 "open_pcie_trace: default=1(open)/0(close)");
+
+static int enable_mp = 1;
+module_param(enable_mp, int, 0444);
+MODULE_PARM_DESC(enable_mp,
+	 "enable multipath on target device. default=1(enable)");
+
+
+static inline void
+leapraid_get_sense_data(char *sense, struct sense_info *data)
+{
+	bool desc_format = (sense[0] & 0x7F) >= 0x72;
+
+	if (desc_format) {
+		data->sense_key = sense[1] & 0x0F;
+		data->asc = sense[2];
+		data->ascq = sense[3];
+	} else {
+		data->sense_key = sense[2] & 0x0F;
+		data->asc = sense[12];
+		data->ascq = sense[13];
+	}
+}
+
+static struct Scsi_Host *
+pdev_to_shost(struct pci_dev *pdev)
+{
+	return pci_get_drvdata(pdev);
+}
+
+static struct leapraid_adapter *
+pdev_to_adapter(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+
+	if (!shost)
+		return NULL;
+
+	return shost_priv(shost);
+}
+
+struct leapraid_io_req_tracker *
+leapraid_get_scmd_priv(struct scsi_cmnd *scmd)
+{
+	return scsi_cmd_priv(scmd);
+}
+
+void
+leapraid_set_tm_flg(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+	bool skip = false;
+
+	/* don't break out of the loop */
+	shost_for_each_device(sdev, adapter->shost) {
+		if (skip)
+			continue;
+
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->hdl == hdl) {
+			sdev_priv->starget_priv->tm_busy = true;
+			skip = true;
+		}
+	}
+}
+
+void
+leapraid_clear_tm_flg(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+	bool skip = false;
+
+	/* don't break out of the loop */
+	shost_for_each_device(sdev, adapter->shost) {
+		if (skip)
+			continue;
+
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->hdl == hdl) {
+			sdev_priv->starget_priv->tm_busy = false;
+			skip = true;
+		}
+	}
+}
+
+static int
+leapraid_tm_cmd_map_status(struct leapraid_adapter *adapter,
+	 uint channel, uint id, uint lun, u8 type, u16 taskid_task)
+{
+	int rc = FAILED;
+
+	if (taskid_task <= adapter->shost->can_queue) {
+		switch (type) {
+		case LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET:
+		case LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET:
+			if (!leapraid_scmd_find_by_lun(
+				adapter, id, lun, channel))
+				rc = SUCCESS;
+			break;
+		case LEAPRAID_TM_TASKTYPE_TARGET_RESET:
+			if (!leapraid_scmd_find_by_tgt(adapter, id, channel))
+				rc = SUCCESS;
+			break;
+		default:
+			rc = SUCCESS;
+		}
+	}
+
+	if (taskid_task == adapter->driver_cmds.driver_scsiio_cmd.taskid) {
+		if ((adapter->driver_cmds.driver_scsiio_cmd.status
+			 & LEAPRAID_CMD_DONE)
+			 || (adapter->driver_cmds.driver_scsiio_cmd.status
+				 & LEAPRAID_CMD_NOT_USED))
+			rc = SUCCESS;
+	}
+
+	if (taskid_task == adapter->driver_cmds.ctl_cmd.hp_taskid) {
+		if ((adapter->driver_cmds.ctl_cmd.status & LEAPRAID_CMD_DONE)
+			 || (adapter->driver_cmds.ctl_cmd.status
+				 & LEAPRAID_CMD_NOT_USED))
+			rc = SUCCESS;
+	}
+
+	return rc;
+}
+
+static int
+leapraid_tm_post_processing(struct leapraid_adapter *adapter,
+	 u16 hdl, uint channel, uint id,
+	 uint lun, u8 type, u16 taskid_task)
+{
+	int rc;
+
+	rc = leapraid_tm_cmd_map_status(adapter,
+		 channel, id, lun, type, taskid_task);
+	if (rc == SUCCESS)
+		return rc;
+
+	leapraid_mask_int(adapter);
+	leapraid_sync_irqs(adapter, true);
+	leapraid_unmask_int(adapter);
+
+	rc = leapraid_tm_cmd_map_status(adapter,
+		 channel, id, lun, type, taskid_task);
+	return rc;
+}
+
+static void
+leapraid_build_tm_req(struct leapraid_scsi_tm_req *scsi_tm_req,
+	 u16 hdl, uint lun, u8 type, u8 tr_method, u16 target_taskid)
+{
+	memset(scsi_tm_req, 0, sizeof(*scsi_tm_req));
+	scsi_tm_req->func = LEAPRAID_FUNC_SCSI_TMF;
+	scsi_tm_req->dev_hdl = cpu_to_le16(hdl);
+	scsi_tm_req->task_type = type;
+	scsi_tm_req->msg_flg = tr_method;
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK
+		 || type == LEAPRAID_TM_TASKTYPE_QUERY_TASK)
+		scsi_tm_req->task_mid = cpu_to_le16(target_taskid);
+	int_to_scsilun(lun, (struct scsi_lun *)scsi_tm_req->lun);
+}
+
+int
+leapraid_issue_tm(struct leapraid_adapter *adapter,
+	 u16 hdl, uint channel, uint id, uint lun, u8 type,
+	 u16 target_taskid, u8 tr_method)
+{
+	struct leapraid_scsi_tm_req *scsi_tm_req;
+	struct leapraid_scsiio_req *scsiio_req;
+	struct leapraid_io_req_tracker *io_req_tracker = NULL;
+	u16 msix_task = 0;
+	bool issue_reset = false;
+	u32 db;
+	int rc;
+
+	lockdep_assert_held(&adapter->driver_cmds.tm_cmd.mutex);
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.host_removing
+		 || adapter->access_ctrl.pcie_recovering) {
+		dev_info(&adapter->pdev->dev,
+			 "%s %s: host is recovering, skip tm command!\n",
+			 __func__, adapter->adapter_attr.name);
+		return FAILED;
+	}
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if (db & LEAPRAID_DB_USED) {
+		dev_info(&adapter->pdev->dev,
+			 "%s unexpected db status, issuing hard reset!\n",
+			 adapter->adapter_attr.name);
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		return (!rc) ? SUCCESS : FAILED;
+	}
+
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_FAULT) {
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		return (!rc) ? SUCCESS : FAILED;
+	}
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK)
+		io_req_tracker =
+			 leapraid_get_io_tracker_from_taskid(adapter,
+				 target_taskid);
+
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_PENDING;
+	scsi_tm_req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.tm_cmd.hp_taskid);
+	leapraid_build_tm_req(scsi_tm_req,
+		 hdl, lun, type, tr_method, target_taskid);
+	memset((void *)(&adapter->driver_cmds.tm_cmd.reply),
+		 0, sizeof(struct leapraid_scsi_tm_rep));
+	leapraid_set_tm_flg(adapter, hdl);
+	init_completion(&adapter->driver_cmds.tm_cmd.done);
+	if ((type == LEAPRAID_TM_TASKTYPE_ABORT_TASK)
+		 && (io_req_tracker
+			 && (io_req_tracker->msix_io <
+				 adapter->adapter_attr.rq_cnt)))
+		msix_task = io_req_tracker->msix_io;
+	else
+		msix_task = 0;
+	leapraid_fire_hpr_task(adapter,
+		 adapter->driver_cmds.tm_cmd.hp_taskid, msix_task);
+	wait_for_completion_timeout(&adapter->driver_cmds.tm_cmd.done,
+		 LEAPRAID_TM_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.tm_cmd.status & LEAPRAID_CMD_DONE)) {
+		issue_reset =
+			 leapraid_check_reset(
+				adapter->driver_cmds.tm_cmd.status);
+		if (issue_reset) {
+			rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+			rc = (!rc) ? SUCCESS : FAILED;
+			goto out;
+		}
+	}
+
+	leapraid_sync_irqs(adapter, false);
+
+	switch (type) {
+	case LEAPRAID_TM_TASKTYPE_TARGET_RESET:
+	case LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET:
+	case LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET:
+		rc = leapraid_tm_post_processing(adapter,
+			 hdl, channel, id, lun, type, target_taskid);
+		break;
+	case LEAPRAID_TM_TASKTYPE_ABORT_TASK:
+		rc = SUCCESS;
+		scsiio_req = leapraid_get_task_desc(adapter, target_taskid);
+		if (le16_to_cpu(scsiio_req->dev_hdl) != hdl)
+			break;
+		dev_err(&adapter->pdev->dev, "%s abort failed, hdl=0x%04x\n",
+			 adapter->adapter_attr.name, hdl);
+		rc = FAILED;
+		break;
+	case LEAPRAID_TM_TASKTYPE_QUERY_TASK:
+		rc = SUCCESS;
+		break;
+	default:
+		rc = FAILED;
+		break;
+	}
+
+out:
+	leapraid_clear_tm_flg(adapter, hdl);
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_NOT_USED;
+	return rc;
+}
+
+int
+leapraid_issue_locked_tm(struct leapraid_adapter *adapter, u16 hdl,
+	 uint channel, uint id, uint lun, u8 type,
+	 u16 target_taskid, u8 tr_method)
+{
+	int rc;
+
+	mutex_lock(&adapter->driver_cmds.tm_cmd.mutex);
+	rc = leapraid_issue_tm(adapter, hdl, channel,
+		 id, lun, type, target_taskid, tr_method);
+	mutex_unlock(&adapter->driver_cmds.tm_cmd.mutex);
+
+	return rc;
+}
+
+void
+leapraid_smart_fault_detect(struct leapraid_adapter *adapter,
+	 u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_target *starget;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		goto out;
+	}
+
+	starget = sas_dev->starget;
+	starget_priv = starget->hostdata;
+	if ((starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER)
+		 || ((starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME))) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		goto out;
+	}
+
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	leapraid_async_turn_on_led(adapter, hdl);
+out:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+static void
+leapraid_process_sense_data(struct leapraid_adapter *adapter,
+	 struct leapraid_scsiio_rep *scsiio_rep, struct scsi_cmnd *scmd,
+	 u16 taskid)
+{
+	struct sense_info data;
+	const void *sense_data;
+	u32 sz;
+
+	if (!(scsiio_rep->scsi_state & LEAPRAID_SCSI_STATE_AUTOSENSE_VALID))
+		return;
+
+	sense_data = leapraid_get_sense_buffer(adapter, taskid);
+	sz = min_t(u32, SCSI_SENSE_BUFFERSIZE,
+		 le32_to_cpu(scsiio_rep->sense_count));
+
+	memcpy(scmd->sense_buffer, sense_data, sz);
+	leapraid_get_sense_data(scmd->sense_buffer, &data);
+	if (data.asc == 0x5D)
+		leapraid_smart_fault_detect(adapter,
+			 le16_to_cpu(scsiio_rep->dev_hdl));
+}
+
+static void
+leapraid_handle_data_underrun(struct leapraid_scsiio_rep *scsiio_rep,
+	 struct scsi_cmnd *scmd, u32 xfer_cnt)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+
+	scmd->result = (DID_OK << 16) | scsi_status;
+
+	if (scsi_state & LEAPRAID_SCSI_STATE_AUTOSENSE_VALID)
+		return;
+
+	if (xfer_cnt < scmd->underflow) {
+		if (scsi_status == SAM_STAT_BUSY)
+			scmd->result = SAM_STAT_BUSY;
+		else
+			scmd->result = DID_SOFT_ERROR << 16;
+	} else if (scsi_state & (LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED |
+		 LEAPRAID_SCSI_STATE_NO_SCSI_STATUS))
+		scmd->result = DID_SOFT_ERROR << 16;
+	else if (scsi_state & LEAPRAID_SCSI_STATE_TERMINATED)
+		scmd->result = DID_RESET << 16;
+	else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
+		scsiio_rep->scsi_state = LEAPRAID_SCSI_STATE_AUTOSENSE_VALID;
+		scsiio_rep->scsi_status = SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
+	}
+}
+
+static void
+leapraid_handle_success_status(struct leapraid_scsiio_rep *scsiio_rep,
+	 struct scsi_cmnd *scmd, u32 response_code)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+
+	scmd->result = (DID_OK << 16) | scsi_status;
+
+	if (response_code == LEAPRAID_TM_RSP_INVALID_FRAME ||
+		 (scsi_state & (LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED
+			 | LEAPRAID_SCSI_STATE_NO_SCSI_STATUS)))
+		scmd->result = DID_SOFT_ERROR << 16;
+	else if (scsi_state & LEAPRAID_SCSI_STATE_TERMINATED)
+		scmd->result = DID_RESET << 16;
+}
+
+static void
+leapraid_scsiio_done_dispatch(struct leapraid_adapter *adapter,
+	 struct leapraid_scsiio_rep *scsiio_rep,
+	 struct leapraid_sdev_priv *sdev_priv,
+	 struct scsi_cmnd *scmd,
+	 u16 taskid, u32 response_code)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+	u16 adapter_status;
+	u32 xfer_cnt;
+
+	adapter_status = le16_to_cpu(scsiio_rep->adapter_status)
+		 & LEAPRAID_ADAPTER_STATUS_MASK;
+
+	xfer_cnt = le32_to_cpu(scsiio_rep->transfer_count);
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
+
+	if (adapter_status == LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN &&
+		 xfer_cnt == 0 &&
+		 (scsi_status == LEAPRAID_SCSI_STATUS_BUSY ||
+			 scsi_status ==
+				 LEAPRAID_SCSI_STATUS_RESERVATION_CONFLICT ||
+			 scsi_status == LEAPRAID_SCSI_STATUS_TASK_SET_FULL)) {
+		adapter_status = LEAPRAID_ADAPTER_STATUS_SUCCESS;
+	}
+
+	switch (adapter_status) {
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DEVICE_NOT_THERE:
+		scmd->result = DID_NO_CONNECT << 16;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_BUSY:
+	case LEAPRAID_ADAPTER_STATUS_INSUFFICIENT_RESOURCES:
+		scmd->result = SAM_STAT_BUSY;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_RESIDUAL_MISMATCH:
+		if ((xfer_cnt == 0) || (scmd->underflow > xfer_cnt))
+			scmd->result = DID_SOFT_ERROR << 16;
+		else
+			scmd->result = (DID_OK << 16) | scsi_status;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_ADAPTER_TERMINATED:
+		if (sdev_priv->block) {
+			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			return;
+		}
+
+		if ((scmd->device->channel == RAID_CHANNEL) &&
+			 (scsi_state == (LEAPRAID_SCSI_STATE_TERMINATED |
+				 LEAPRAID_SCSI_STATE_NO_SCSI_STATUS))) {
+			scmd->result = DID_RESET << 16;
+			break;
+		}
+
+		scmd->result = DID_SOFT_ERROR << 16;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_TASK_TERMINATED:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_EXT_TERMINATED:
+		scmd->result = DID_RESET << 16;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN:
+		leapraid_handle_data_underrun(scsiio_rep, scmd, xfer_cnt);
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DATA_OVERRUN:
+		scsi_set_resid(scmd, 0);
+		leapraid_handle_success_status(scsiio_rep,
+			 scmd, response_code);
+		break;
+	case LEAPRAID_ADAPTER_STATUS_SCSI_RECOVERED_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SUCCESS:
+		leapraid_handle_success_status(scsiio_rep,
+			 scmd, response_code);
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_PROTOCOL_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_IO_DATA_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_TASK_MGMT_FAILED:
+	default:
+		scmd->result = DID_SOFT_ERROR << 16;
+		break;
+	}
+}
+
+u8
+leapraid_scsiio_done(struct leapraid_adapter *adapter, u16 taskid,
+	 u8 msix_index, u32 rep)
+{
+	struct leapraid_scsiio_rep *scsiio_rep = NULL;
+	struct leapraid_sdev_priv *sdev_priv = NULL;
+	struct scsi_cmnd *scmd = NULL;
+	u32 response_code = 0;
+
+	if (likely(taskid != adapter->driver_cmds.driver_scsiio_cmd.taskid))
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+	else
+		scmd = adapter->driver_cmds.internal_scmd;
+	if (scmd == NULL)
+		return 1;
+
+	scsiio_rep = leapraid_get_reply_vaddr(adapter, rep);
+	if (scsiio_rep == NULL) {
+		scmd->result = DID_OK << 16;
+		goto out;
+	}
+
+	sdev_priv = scmd->device->hostdata;
+	if (!sdev_priv || !sdev_priv->starget_priv ||
+		 sdev_priv->starget_priv->deleted) {
+		scmd->result = DID_NO_CONNECT << 16;
+		goto out;
+	}
+
+	if (scsiio_rep->scsi_state & LEAPRAID_SCSI_STATE_RESPONSE_INFO_VALID)
+		response_code = le32_to_cpu(scsiio_rep->resp_info) & 0xFF;
+
+	leapraid_process_sense_data(adapter, scsiio_rep, scmd, taskid);
+	leapraid_scsiio_done_dispatch(adapter, scsiio_rep, sdev_priv, scmd,
+		 taskid, response_code);
+
+out:
+	scsi_dma_unmap(scmd);
+	if (unlikely(taskid ==
+			 adapter->driver_cmds.driver_scsiio_cmd.taskid)) {
+		adapter->driver_cmds.driver_scsiio_cmd.status
+			 = LEAPRAID_CMD_DONE;
+		complete(&adapter->driver_cmds.driver_scsiio_cmd.done);
+		return 0;
+	}
+	leapraid_free_taskid(adapter, taskid);
+	scsi_done(scmd);
+	return 0;
+}
+
+static void
+leapraid_probe_raid(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume, *raid_volume_next;
+	int rc;
+
+	list_for_each_entry_safe(raid_volume, raid_volume_next,
+		 &adapter->dev_topo.raid_volume_list, list) {
+		if (raid_volume->starget)
+			continue;
+
+		rc = scsi_add_device(adapter->shost, RAID_CHANNEL,
+			 raid_volume->id, 0);
+		if (rc)
+			leapraid_raid_volume_remove(adapter, raid_volume);
+	}
+}
+
+static void
+leapraid_sas_dev_make_active(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_dev *sas_dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	if (!list_empty(&sas_dev->list)) {
+		list_del_init(&sas_dev->list);
+		leapraid_sdev_put(sas_dev);
+	}
+
+	leapraid_sdev_get(sas_dev);
+	list_add_tail(&sas_dev->list, &adapter->dev_topo.sas_dev_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void
+leapraid_probe_sas(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev;
+	bool added;
+
+	for (;;) {
+		sas_dev = leapraid_get_next_sas_dev_from_init_list(adapter);
+		if (!sas_dev)
+			break;
+
+		added = leapraid_transport_port_add(adapter, sas_dev->hdl,
+			 sas_dev->parent_sas_addr, sas_dev->card_port);
+
+		if (!added)
+			goto remove_dev;
+
+		if (!sas_dev->starget &&
+				 !adapter->scan_dev_desc.driver_loading) {
+			leapraid_transport_port_remove(
+				adapter, sas_dev->sas_addr,
+				 sas_dev->parent_sas_addr, sas_dev->card_port);
+			goto remove_dev;
+		}
+
+		leapraid_sas_dev_make_active(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+		continue;
+
+remove_dev:
+		leapraid_sas_dev_remove(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+static bool
+leapraid_get_boot_dev(struct leapraid_boot_dev *boot_dev,
+	 void **pdev, u32 *pchnl)
+{
+	if (boot_dev->dev) {
+		*pdev = boot_dev->dev;
+		*pchnl = boot_dev->chnl;
+		return true;
+	}
+	return false;
+}
+
+static void
+leapraid_probe_boot_dev(struct leapraid_adapter *adapter)
+{
+	void *dev = NULL;
+	u32 chnl;
+
+	if (leapraid_get_boot_dev(&adapter->boot_devs.requested_boot_dev,
+		 &dev, &chnl))
+		goto boot_dev_found;
+
+	if (leapraid_get_boot_dev(&adapter->boot_devs.requested_alt_boot_dev,
+		 &dev, &chnl))
+		goto boot_dev_found;
+
+	if (leapraid_get_boot_dev(&adapter->boot_devs.current_boot_dev,
+		 &dev, &chnl))
+		goto boot_dev_found;
+
+	return;
+
+boot_dev_found:
+	switch (chnl) {
+	case RAID_CHANNEL:
+	{
+		struct leapraid_raid_volume *raid_volume
+			 = (struct leapraid_raid_volume *)dev;
+
+		if (raid_volume->starget)
+			return;
+
+		/* TODO eedp */
+
+		if (scsi_add_device(adapter->shost, RAID_CHANNEL,
+				 raid_volume->id, 0))
+			leapraid_raid_volume_remove(adapter, raid_volume);
+		break;
+	}
+	default:
+	{
+		struct leapraid_sas_dev *sas_dev
+			 = (struct leapraid_sas_dev *)dev;
+		struct leapraid_sas_port *sas_port;
+		unsigned long flags;
+
+		if (sas_dev->starget)
+			return;
+
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		list_move_tail(&sas_dev->list,
+			 &adapter->dev_topo.sas_dev_list);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+		if (!sas_dev->card_port)
+			return;
+
+		sas_port = leapraid_transport_port_add(adapter, sas_dev->hdl,
+			 sas_dev->parent_sas_addr, sas_dev->card_port);
+		if (!sas_port)
+			leapraid_sas_dev_remove(adapter, sas_dev);
+		break;
+	}
+	}
+}
+
+static void
+leapraid_probe_devices(struct leapraid_adapter *adapter)
+{
+	leapraid_probe_boot_dev(adapter);
+
+	if (adapter->adapter_attr.raid_support) {
+		leapraid_probe_raid(adapter);
+		leapraid_probe_sas(adapter);
+	} else
+		leapraid_probe_sas(adapter);
+}
+
+void
+leapraid_scan_dev_done(struct leapraid_adapter *adapter)
+{
+	if (adapter->scan_dev_desc.wait_scan_dev_done) {
+		adapter->scan_dev_desc.wait_scan_dev_done = false;
+		leapraid_probe_devices(adapter);
+	}
+
+	leapraid_check_scheduled_fault_start(adapter);
+	leapraid_fw_log_start(adapter);
+	adapter->scan_dev_desc.driver_loading = false;
+	leapraid_smart_polling_start(adapter);
+}
+
+static void
+leapraid_ir_shutdown(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_act_req *raid_act_req;
+	struct leapraid_raid_act_rep *raid_act_rep;
+	struct leapraid_driver_cmd *raid_action_cmd;
+
+	if (!adapter || !adapter->adapter_attr.raid_support)
+		return;
+
+	if (list_empty(&adapter->dev_topo.raid_volume_list))
+		return;
+
+	if (leapraid_pci_removed(adapter))
+		return;
+
+	raid_action_cmd = &adapter->driver_cmds.raid_action_cmd;
+
+	mutex_lock(&raid_action_cmd->mutex);
+	raid_action_cmd->status = LEAPRAID_CMD_PENDING;
+
+	raid_act_req = leapraid_get_task_desc(adapter,
+		 raid_action_cmd->inter_taskid);
+	memset(raid_act_req, 0, sizeof(struct leapraid_raid_act_req));
+	raid_act_req->func = LEAPRAID_FUNC_RAID_ACTION;
+	raid_act_req->act = LEAPRAID_RAID_ACT_SYSTEM_SHUTDOWN_INITIATED;
+
+	dev_info(&adapter->pdev->dev, "ir shutdown start\n");
+	init_completion(&raid_action_cmd->done);
+	leapraid_fire_task(adapter, raid_action_cmd->inter_taskid);
+	wait_for_completion_timeout(&raid_action_cmd->done, 10 * HZ);
+
+	if (!(raid_action_cmd->status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: timeout waiting for ir shutdown\n", __func__);
+		goto out;
+	}
+
+	if (raid_action_cmd->status & LEAPRAID_CMD_REPLY_VALID) {
+		raid_act_rep = (void *)(&raid_action_cmd->reply);
+		dev_info(&adapter->pdev->dev,
+			 "ir shutdown done, adapter status=0x%04x\n",
+			 le16_to_cpu(raid_act_rep->adapter_status));
+	}
+
+out:
+	raid_action_cmd->status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&raid_action_cmd->mutex);
+}
+
+static const struct pci_device_id leapraid_pci_table[] = {
+	{ 0x1556, 0x1111, PCI_ANY_ID, PCI_ANY_ID },
+	{ LEAPRAID_VENDOR_ID, LEAPRAID_DEVID_HBA, PCI_ANY_ID, PCI_ANY_ID },
+	{ LEAPRAID_VENDOR_ID, LEAPRAID_DEVID_RAID, PCI_ANY_ID, PCI_ANY_ID },
+	{ 0, }
+};
+
+static inline bool
+leapraid_is_scmd_permitted(struct leapraid_adapter *adapter,
+	 struct scsi_cmnd *scmd)
+{
+	u8 opcode;
+
+	if (adapter->access_ctrl.pcie_recovering
+	 || adapter->access_ctrl.adapter_thermal_alert)
+		return false;
+
+	if (adapter->access_ctrl.host_removing) {
+		if (leapraid_pci_removed(adapter))
+			return false;
+
+		opcode = scmd->cmnd[0];
+		if ((opcode == SYNCHRONIZE_CACHE) || (opcode == START_STOP))
+			return true;
+		else
+			return false;
+	}
+	return true;
+}
+
+static bool
+leapraid_should_queuecommand(struct leapraid_adapter *adapter,
+			 struct leapraid_sdev_priv *sdev_priv,
+			 struct scsi_cmnd *scmd,
+			 int *rc)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	if (!sdev_priv || !sdev_priv->starget_priv)
+		goto no_connect;
+
+	if (!leapraid_is_scmd_permitted(adapter, scmd))
+		goto no_connect;
+
+	starget_priv = sdev_priv->starget_priv;
+	if (starget_priv->hdl == LEAPRAID_INVALID_DEV_HANDLE)
+		goto no_connect;
+
+	if (sdev_priv->block &&
+		scmd->device->host->shost_state == SHOST_RECOVERY &&
+		scmd->cmnd[0] == TEST_UNIT_READY) {
+		scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
+		goto done_out;
+	}
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->reset_desc.adapter_link_resetting) {
+		*rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	} else if (starget_priv->deleted || sdev_priv->deleted) {
+		goto no_connect;
+	} else if (starget_priv->tm_busy || sdev_priv->block) {
+		*rc = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto out;
+	}
+
+	return true;
+
+no_connect:
+	scmd->result = DID_NO_CONNECT << 16;
+done_out:
+	if (likely(scmd != adapter->driver_cmds.internal_scmd))
+		scsi_done(scmd);
+out:
+	return false;
+}
+
+static u32
+build_scsiio_req_control(struct scsi_cmnd *scmd,
+	 struct leapraid_sdev_priv *sdev_priv)
+{
+	u32 control;
+
+	switch (scmd->sc_data_direction) {
+	case DMA_FROM_DEVICE:
+		control = LEAPRAID_SCSIIO_CTRL_READ;
+		break;
+	case DMA_TO_DEVICE:
+		control = LEAPRAID_SCSIIO_CTRL_WRITE;
+		break;
+	default:
+		control = LEAPRAID_SCSIIO_CTRL_NODATATRANSFER;
+		break;
+	}
+
+	control |= LEAPRAID_SCSIIO_CTRL_SIMPLEQ;
+
+	if (sdev_priv->ncq &&
+		 (IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)))
+			 == IOPRIO_CLASS_RT))
+		control |= 0x800;
+
+	if (scmd->cmd_len == 32)
+		control |= 4 << LEAPRAID_SCSIIO_CTRL_ADDCDBLEN_SHIFT;
+
+	return control;
+}
+
+int
+leapraid_queuecommand(struct Scsi_Host *shost,
+	 struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(scmd->device->host);
+	struct leapraid_sdev_priv *sdev_priv = scmd->device->hostdata;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_scsiio_req *scsiio_req;
+	u32 control;
+	u16 taskid;
+	u16 hdl;
+	int rc = 0;
+
+	if (!leapraid_should_queuecommand(adapter, sdev_priv, scmd, &rc))
+		goto out;
+
+	starget_priv = sdev_priv->starget_priv;
+	hdl = starget_priv->hdl;
+	control = build_scsiio_req_control(scmd, sdev_priv);
+
+	if (unlikely(scmd == adapter->driver_cmds.internal_scmd))
+		taskid = adapter->driver_cmds.driver_scsiio_cmd.taskid;
+	else
+		taskid = leapraid_alloc_scsiio_taskid(adapter, scmd);
+	scsiio_req = leapraid_get_task_desc(adapter, taskid);
+
+	scsiio_req->func = LEAPRAID_FUNC_SCSIIO_REQ;
+	if (sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER)
+		scsiio_req->func = LEAPRAID_FUNC_RAID_SCSIIO_PASSTHROUGH;
+	else
+		scsiio_req->func = LEAPRAID_FUNC_SCSIIO_REQ;
+
+	scsiio_req->dev_hdl = cpu_to_le16(hdl);
+	scsiio_req->data_len = cpu_to_le32(scsi_bufflen(scmd));
+	scsiio_req->ctrl = cpu_to_le32(control);
+	scsiio_req->io_flg = cpu_to_le16(scmd->cmd_len);
+	scsiio_req->msg_flg
+		= LEAPRAID_SCSIIO_MSGFLG_SYSTEM_SENSE_ADDR;
+	scsiio_req->sense_buffer_len = SCSI_SENSE_BUFFERSIZE;
+	scsiio_req->sense_buffer_low_add =
+		leapraid_get_sense_buffer_dma(adapter, taskid);
+	scsiio_req->sgl_offset0
+		 = offsetof(struct leapraid_scsiio_req, sgl) / 4;
+	int_to_scsilun(sdev_priv->lun, (struct scsi_lun *)scsiio_req->lun);
+	memcpy(scsiio_req->cdb.cdb32, scmd->cmnd, scmd->cmd_len);
+	if (scsiio_req->data_len) {
+		if (leapraid_build_scmd_ieee_sg(adapter, scmd, taskid)) {
+			leapraid_free_taskid(adapter, taskid);
+			rc = SCSI_MLQUEUE_HOST_BUSY;
+			goto out;
+		}
+	} else
+		leapraid_build_ieee_nodata_sg(adapter, &scsiio_req->sgl);
+
+	if (likely(scsiio_req->func == LEAPRAID_FUNC_SCSIIO_REQ)) {
+		leapraid_fire_scsi_io(adapter, taskid,
+			 le16_to_cpu(scsiio_req->dev_hdl));
+	} else {
+		leapraid_fire_task(adapter, taskid);
+	}
+
+out:
+	return rc;
+}
+
+static int
+leapraid_init_cmd_priv(struct Scsi_Host *shost,
+	 struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_io_req_tracker *io_tracker;
+
+	io_tracker = leapraid_get_scmd_priv(scmd);
+	leapraid_internal_init_cmd_priv(adapter, io_tracker);
+
+	return 0;
+}
+
+static int
+leapraid_exit_cmd_priv(struct Scsi_Host *shost,
+	 struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_io_req_tracker *io_tracker;
+
+	io_tracker = leapraid_get_scmd_priv(scmd);
+	leapraid_internal_exit_cmd_priv(adapter, io_tracker);
+
+	return 0;
+}
+
+static int
+leapraid_error_handler(struct scsi_cmnd *scmd,
+	 const char *str, u8 type)
+{
+	struct leapraid_adapter *adapter = shost_priv(scmd->device->host);
+	struct scsi_target *starget = scmd->device->sdev_target;
+	struct leapraid_starget_priv *starget_priv = starget->hostdata;
+	struct leapraid_io_req_tracker *io_req_tracker = NULL;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev = NULL;
+	u16 hdl;
+	int rc;
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		io_req_tracker = leapraid_get_scmd_priv(scmd);
+		dev_info(&adapter->pdev->dev,
+			 "err handler: abort scmd 0x%p, pending %u ms, tout %u ms\n",
+			 scmd,
+			 jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
+			 (scsi_cmd_to_rq(scmd)->timeout / HZ) * 1000);
+	} else {
+		dev_info(&adapter->pdev->dev,
+			 "err handler: reset %s, scmd=0x%p\n", str, scmd);
+	}
+
+	if (leapraid_pci_removed(adapter)
+		 || adapter->access_ctrl.host_removing) {
+		dev_err(&adapter->pdev->dev,
+			 "err handler failed: %s, scmd=0x%p\n",
+			 (adapter->access_ctrl.host_removing ?
+			 "shost removed!" : "pci_dev removed!"), scmd);
+		if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK)
+			if (io_req_tracker && io_req_tracker->taskid)
+				leapraid_free_taskid(adapter,
+					 io_req_tracker->taskid);
+		scmd->result = DID_NO_CONNECT << 16;
+#ifdef FAST_IO_FAIL
+		rc = FAST_IO_FAIL;
+#else
+		rc = FAILED;
+#endif
+		goto out;
+	}
+
+	sdev_priv = scmd->device->hostdata;
+	if (!sdev_priv || !sdev_priv->starget_priv) {
+		dev_err(&adapter->pdev->dev,
+			 "%s sdev no longer exists! scmd=0x%p\n", str, scmd);
+		scmd->result = DID_NO_CONNECT << 16;
+		scsi_done(scmd);
+		rc = SUCCESS;
+		goto out;
+	}
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		if (io_req_tracker == NULL) {
+			dev_err(&adapter->pdev->dev,
+				 "no io tracker for scmd 0x%p, skip\n", scmd);
+			scmd->result = DID_RESET << 16;
+			rc = SUCCESS;
+			goto out;
+		}
+
+		if (sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER
+				 || sdev_priv->starget_priv->flg
+				 & LEAPRAID_TGT_FLG_VOLUME) {
+			dev_err(&adapter->pdev->dev,
+				 "skip RAID/VOLUME target, scmd=0x%p\n", scmd);
+			scmd->result = DID_RESET << 16;
+			rc = FAILED;
+			goto out;
+		}
+
+		hdl = sdev_priv->starget_priv->hdl;
+	} else {
+		hdl = 0;
+		if (sdev_priv->starget_priv->flg
+			 & LEAPRAID_TGT_FLG_RAID_MEMBER) {
+			sas_dev = leapraid_get_sas_dev_from_tgt(adapter,
+				 starget_priv);
+			if (sas_dev)
+				hdl = sas_dev->volume_hdl;
+		} else
+			hdl = sdev_priv->starget_priv->hdl;
+		if (!hdl) {
+			scmd->result = DID_RESET << 16;
+			rc = FAILED;
+			goto out;
+		}
+	}
+
+	rc = leapraid_issue_locked_tm(adapter, hdl,
+		 scmd->device->channel,
+		 scmd->device->id,
+		 (type == LEAPRAID_TM_TASKTYPE_TARGET_RESET ?
+		 0 : scmd->device->lun),
+		 type,
+		 (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK ?
+		 io_req_tracker->taskid : 0),
+		 LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+
+out:
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		dev_info(&adapter->pdev->dev,
+			 "abort task: %s, scmd=0x%p\n",
+			 ((rc == SUCCESS) ? "success" : "failed"), scmd);
+	} else {
+		dev_info(&adapter->pdev->dev,
+			 "%s reset: %s, scmd=0x%p\n",
+			 str, ((rc == SUCCESS) ? "success" : "failed"), scmd);
+		if (sas_dev)
+			leapraid_sdev_put(sas_dev);
+	}
+	return rc;
+}
+
+static int
+leapraid_eh_abort_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "device",
+		 LEAPRAID_TM_TASKTYPE_ABORT_TASK);
+}
+
+static int
+leapraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "device",
+		 LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET);
+}
+
+static int
+leapraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "target",
+		 LEAPRAID_TM_TASKTYPE_TARGET_RESET);
+}
+
+static int
+leapraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter
+		 = shost_priv(scmd->device->host);
+	int rc;
+
+	dev_info(&adapter->pdev->dev,
+			 "reset host, scmd=0x%p\n", scmd);
+	scsi_print_command(scmd);
+
+	if (adapter->scan_dev_desc.driver_loading
+		 || adapter->access_ctrl.host_removing) {
+		dev_err(&adapter->pdev->dev,
+			 "host reset failed: driver loading or host removing\n");
+		rc = FAILED;
+		goto out;
+	}
+
+	if (leapraid_hard_reset_handler(adapter, FULL_RESET) < 0)
+		rc = FAILED;
+	else
+		rc = SUCCESS;
+
+out:
+	dev_info(&adapter->pdev->dev, "reset host %s, scmd=0x%p\n",
+		 ((rc == SUCCESS) ? "success" : "failed"), scmd);
+	return rc;
+}
+
+static int
+leapraid_sdev_init(struct scsi_device *sdev)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *stgt_priv;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_adapter *adapter;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_target *tgt;
+	struct Scsi_Host *shost;
+	unsigned long flags;
+
+	sdev_priv =
+		 kzalloc(sizeof(*sdev_priv), GFP_KERNEL);
+	if (!sdev_priv)
+		return -ENOMEM;
+
+	sdev_priv->lun = sdev->lun;
+	sdev_priv->flg = LEAPRAID_DEVICE_FLG_INIT;
+	tgt = scsi_target(sdev);
+	stgt_priv = tgt->hostdata;
+	stgt_priv->num_luns++;
+	sdev_priv->starget_priv = stgt_priv;
+	sdev->hostdata = sdev_priv;
+	if ((stgt_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER))
+		sdev->no_uld_attach = 1;
+
+	shost = dev_to_shost(&tgt->dev);
+	adapter = shost_priv(shost);
+	if (tgt->channel == RAID_CHANNEL) {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		raid_volume =
+			 leapraid_raid_volume_find_by_id(adapter,
+				 tgt->id, tgt->channel);
+		if (raid_volume)
+			raid_volume->sdev = sdev;
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+			 flags);
+	}
+
+	if (!(stgt_priv->flg & LEAPRAID_TGT_FLG_VOLUME)) {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		sas_dev =
+			 leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+				 stgt_priv->sas_address, stgt_priv->card_port);
+		if (sas_dev && (sas_dev->starget == NULL)) {
+			sdev_printk(KERN_INFO, sdev,
+				 "%s: assign starget to sas_dev\n", __func__);
+			sas_dev->starget = tgt;
+		}
+
+		if (sas_dev)
+			leapraid_sdev_put(sas_dev);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	}
+	return 0;
+}
+
+static int
+leapraid_slave_cfg_volume(struct scsi_device *sdev,
+	 struct queue_limits *lim)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sdev_priv *sdev_priv;
+	unsigned long flags;
+	int qd;
+	u16 hdl;
+
+	sdev_priv = sdev->hostdata;
+	starget_priv = sdev_priv->starget_priv;
+	hdl = starget_priv->hdl;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume =
+		 leapraid_raid_volume_find_by_hdl(adapter, hdl);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+	if (!raid_volume)
+		return 1;
+
+	if (leapraid_get_volume_cap(adapter, raid_volume))
+		return 1;
+
+	qd = (raid_volume->dev_info & LEAPRAID_DEVTYP_SSP_TGT) ?
+		 LEAPRAID_SAS_QUEUE_DEPTH : LEAPRAID_SATA_QUEUE_DEPTH;
+	if (raid_volume->vol_type != LEAPRAID_VOL_TYPE_RAID0)
+		qd = LEAPRAID_RAID_QUEUE_DEPTH;
+
+	sdev_printk(KERN_INFO, sdev,
+		 "raid volume: hdl=0x%04x, wwid=0x%016llx\n",
+		 raid_volume->hdl, (unsigned long long)raid_volume->wwid);
+
+	if (shost->max_sectors > LEAPRAID_MAX_SECTORS)
+		lim->max_hw_sectors = LEAPRAID_MAX_SECTORS;
+
+	leapraid_adjust_sdev_queue_depth(sdev, qd);
+	return 0;
+}
+
+static int
+leapraid_slave_configure_extra(struct scsi_device *sdev,
+	 struct leapraid_sas_dev **psas_dev,
+	 u16 vol_hdl, u64 volume_wwid,
+	 bool *is_target_ssp, int *qd)
+{
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct Scsi_Host *shost = sdev->host;
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	unsigned long flags;
+
+	sdev_priv = sdev->hostdata;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	*is_target_ssp = false;
+	sas_dev =
+		 leapraid_hold_lock_get_sas_dev_by_addr(adapter,
+			 sdev_priv->starget_priv->sas_address,
+			 sdev_priv->starget_priv->card_port);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		return 1;
+	}
+
+	*psas_dev = sas_dev;
+	sas_dev->volume_hdl = vol_hdl;
+	sas_dev->volume_wwid = volume_wwid;
+	if (sas_dev->dev_info & LEAPRAID_DEVTYP_SSP_TGT) {
+		*qd = (sas_dev->port_type > 1) ?
+			 adapter->adapter_attr.wideport_max_queue_depth :
+			 adapter->adapter_attr.narrowport_max_queue_depth;
+		*is_target_ssp = true;
+		if (sas_dev->dev_info & LEAPRAID_DEVTYP_SEP)
+			sdev_priv->sep = true;
+	} else {
+		*qd = adapter->adapter_attr.sata_max_queue_depth;
+	}
+
+	sdev_printk(KERN_INFO, sdev,
+		 "sdev: dev name=0x%016llx, sas addr=0x%016llx\n",
+		 (unsigned long long)sas_dev->dev_name,
+		 (unsigned long long)sas_dev->sas_addr);
+	leapraid_sdev_put(sas_dev);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return 0;
+}
+
+static int
+leapraid_sdev_configure(struct scsi_device *sdev,
+	 struct queue_limits *lim)
+{
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct Scsi_Host *shost = sdev->host;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_adapter *adapter;
+	u16 hdl, vol_hdl = 0;
+	bool is_target_ssp = false;
+	u64 volume_wwid = 0;
+	int qd = 1;
+
+	adapter = shost_priv(shost);
+	sdev_priv = sdev->hostdata;
+	sdev_priv->flg &= ~LEAPRAID_DEVICE_FLG_INIT;
+	starget_priv = sdev_priv->starget_priv;
+	hdl = starget_priv->hdl;
+	if (starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME)
+		return leapraid_slave_cfg_volume(sdev, lim);
+
+	if (starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER) {
+		if (leapraid_cfg_get_volume_hdl(adapter, hdl, &vol_hdl))
+			return 1;
+
+		if (vol_hdl && leapraid_cfg_get_volume_wwid(adapter,
+			 vol_hdl, &volume_wwid))
+			return 1;
+	}
+
+	if (leapraid_slave_configure_extra(sdev, &sas_dev, vol_hdl,
+			 volume_wwid, &is_target_ssp, &qd))
+		return 1;
+
+	leapraid_adjust_sdev_queue_depth(sdev, qd);
+	if (is_target_ssp)
+		sas_read_port_mode_page(sdev);
+
+	return 0;
+}
+
+static void
+leapraid_sdev_destroy(struct scsi_device *sdev)
+{
+	struct leapraid_adapter *adapter;
+	struct Scsi_Host *shost;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *stgt;
+	unsigned long flags;
+
+	if (!sdev->hostdata)
+		return;
+
+	stgt = scsi_target(sdev);
+	starget_priv = stgt->hostdata;
+	starget_priv->num_luns--;
+	shost = dev_to_shost(&stgt->dev);
+	adapter = shost_priv(shost);
+	if (!(starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME)) {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		sas_dev =
+			 leapraid_hold_lock_get_sas_dev_from_tgt(adapter,
+				 starget_priv);
+		if (sas_dev && !starget_priv->num_luns)
+			sas_dev->starget = NULL;
+		if (sas_dev)
+			leapraid_sdev_put(sas_dev);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	}
+
+	kfree(sdev->hostdata);
+	sdev->hostdata = NULL;
+}
+
+static int
+leapraid_target_alloc_raid(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_raid_volume *raid_volume;
+	struct Scsi_Host *shost = dev_to_shost(&tgt->dev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	unsigned long flags;
+
+	starget_priv = (struct leapraid_starget_priv *)tgt->hostdata;
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume =
+		 leapraid_raid_volume_find_by_id(adapter, tgt->id,
+			 tgt->channel);
+	if (raid_volume) {
+		starget_priv->hdl = raid_volume->hdl;
+		starget_priv->sas_address = raid_volume->wwid;
+		starget_priv->flg |= LEAPRAID_TGT_FLG_VOLUME;
+		raid_volume->starget = tgt;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+	return 0;
+}
+
+static int
+leapraid_target_alloc_sas(struct scsi_target *tgt)
+{
+	struct sas_rphy *rphy;
+	struct Scsi_Host *shost;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_adapter *adapter;
+	struct leapraid_starget_priv *starget_priv;
+	unsigned long flags;
+
+	shost = dev_to_shost(&tgt->dev);
+	adapter = shost_priv(shost);
+	starget_priv = (struct leapraid_starget_priv *)tgt->hostdata;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	rphy = dev_to_rphy(tgt->dev.parent);
+	sas_dev =
+		 leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(adapter,
+			 rphy->identify.sas_address, rphy);
+	if (sas_dev) {
+		starget_priv->sas_dev = sas_dev;
+		starget_priv->card_port = sas_dev->card_port;
+		starget_priv->sas_address = sas_dev->sas_addr;
+		starget_priv->hdl = sas_dev->hdl;
+		sas_dev->channel = tgt->channel;
+		sas_dev->id = tgt->id;
+		sas_dev->starget = tgt;
+		if (test_bit(sas_dev->hdl,
+				 (unsigned long *)adapter->dev_topo.pd_hdls))
+			starget_priv->flg |= LEAPRAID_TGT_FLG_RAID_MEMBER;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	return 0;
+}
+
+static int
+leapraid_target_alloc(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	starget_priv =
+		 kzalloc(sizeof(struct leapraid_starget_priv), GFP_KERNEL);
+	if (!starget_priv)
+		return -ENOMEM;
+
+	tgt->hostdata = starget_priv;
+	starget_priv->starget = tgt;
+	starget_priv->hdl = LEAPRAID_INVALID_DEV_HANDLE;
+	if (tgt->channel == RAID_CHANNEL)
+		return leapraid_target_alloc_raid(tgt);
+
+	return leapraid_target_alloc_sas(tgt);
+}
+
+static void
+leapraid_target_destroy_raid(struct scsi_target *tgt)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct Scsi_Host *shost = dev_to_shost(&tgt->dev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	raid_volume =
+		 leapraid_raid_volume_find_by_id(adapter, tgt->id,
+			 tgt->channel);
+	if (raid_volume) {
+		raid_volume->starget = NULL;
+		raid_volume->sdev = NULL;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+static void
+leapraid_target_destroy_sas(struct scsi_target *tgt)
+{
+	struct leapraid_adapter *adapter;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_starget_priv *starget_priv;
+	struct Scsi_Host *shost;
+	unsigned long flags;
+
+	shost = dev_to_shost(&tgt->dev);
+	adapter = shost_priv(shost);
+	starget_priv = tgt->hostdata;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev =
+		 leapraid_hold_lock_get_sas_dev_from_tgt(adapter,
+			 starget_priv);
+	if (sas_dev && (sas_dev->starget == tgt)
+		 && (sas_dev->id == tgt->id)
+		 && (sas_dev->channel == tgt->channel))
+		sas_dev->starget = NULL;
+
+	if (sas_dev) {
+		starget_priv->sas_dev = NULL;
+		leapraid_sdev_put(sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void
+leapraid_target_destroy(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	starget_priv = tgt->hostdata;
+	if (!starget_priv)
+		return;
+
+	if (tgt->channel == RAID_CHANNEL) {
+		leapraid_target_destroy_raid(tgt);
+		goto out;
+	}
+
+	leapraid_target_destroy_sas(tgt);
+
+out:
+	kfree(starget_priv);
+	tgt->hostdata = NULL;
+}
+
+static bool
+leapraid_scan_check_status(struct leapraid_adapter *adapter,
+	 bool *need_hard_reset)
+{
+	u32 adapter_state;
+
+	if (adapter->scan_dev_desc.scan_start) {
+		adapter_state = leapraid_get_adapter_state(adapter);
+		if (adapter_state == LEAPRAID_DB_FAULT) {
+			*need_hard_reset = true;
+			return true;
+		}
+		return false;
+	}
+
+	if (adapter->driver_cmds.scan_dev_cmd.status & LEAPRAID_CMD_RESET) {
+		dev_err(&adapter->pdev->dev,
+			 "device scan: aborted due to reset\n");
+		adapter->driver_cmds.scan_dev_cmd.status
+			 = LEAPRAID_CMD_NOT_USED;
+		adapter->scan_dev_desc.driver_loading = false;
+		return true;
+	}
+
+	if (adapter->scan_dev_desc.scan_start_failed) {
+		dev_err(&adapter->pdev->dev,
+			 "device scan: failed with adapter_status=0x%08x\n",
+			 adapter->scan_dev_desc.scan_start_failed);
+		adapter->scan_dev_desc.driver_loading = false;
+		adapter->scan_dev_desc.wait_scan_dev_done = false;
+		adapter->access_ctrl.host_removing = true;
+		return true;
+	}
+
+	dev_info(&adapter->pdev->dev, "device scan: SUCCESS\n");
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_NOT_USED;
+	leapraid_scan_dev_done(adapter);
+	return true;
+}
+
+static int
+leapraid_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	bool need_hard_reset = false;
+
+	if (time >= LEAPRAID_SCAN_TIMEOUT) {
+		adapter->driver_cmds.scan_dev_cmd.status
+			 = LEAPRAID_CMD_NOT_USED;
+		dev_err(&adapter->pdev->dev,
+			 "device scan: failed with timeout 300s\n");
+		adapter->scan_dev_desc.driver_loading = false;
+		return 1;
+	}
+
+	if (!leapraid_scan_check_status(adapter, &need_hard_reset))
+		return 0;
+
+	if (need_hard_reset) {
+		adapter->driver_cmds.scan_dev_cmd.status
+			 = LEAPRAID_CMD_NOT_USED;
+		if (leapraid_hard_reset_handler(adapter, PART_RESET))
+			adapter->scan_dev_desc.driver_loading = false;
+	}
+
+	return 1;
+}
+
+static void
+leapraid_scan_start(struct Scsi_Host *shost)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	adapter->scan_dev_desc.scan_start = true;
+	leapraid_scan_dev(adapter, true);
+}
+
+static int
+leapraid_calc_max_queue_depth(struct scsi_device *sdev,
+	 int qdepth)
+{
+	struct Scsi_Host *shost;
+	int max_depth;
+
+	shost = sdev->host;
+	max_depth = shost->can_queue;
+
+	if (!sdev->tagged_supported)
+		max_depth = 1;
+
+	if (qdepth > max_depth)
+		qdepth = max_depth;
+
+	return qdepth;
+}
+
+static int
+leapraid_change_queue_depth(struct scsi_device *sdev,
+	 int qdepth)
+{
+	qdepth = leapraid_calc_max_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
+void
+leapraid_adjust_sdev_queue_depth(struct scsi_device *sdev,
+	 int qdepth)
+{
+	leapraid_change_queue_depth(sdev, qdepth);
+}
+
+
+static void
+leapraid_map_queues(struct Scsi_Host *shost)
+{
+	struct leapraid_adapter *adapter;
+	struct blk_mq_queue_map *queue_map;
+	int msix_queue_count;
+	int poll_queue_count;
+	int queue_offset;
+	int map_index;
+
+	adapter = (struct leapraid_adapter *)shost->hostdata;
+	if (shost->nr_hw_queues == 1)
+		goto out;
+
+	msix_queue_count = adapter->notification_desc.iopoll_qdex;
+	poll_queue_count = adapter->adapter_attr.rq_cnt - msix_queue_count;
+
+	queue_offset = 0;
+	for (map_index = 0; map_index < shost->nr_maps; map_index++) {
+		queue_map = &shost->tag_set.map[map_index];
+		queue_map->nr_queues = 0;
+
+		switch (map_index) {
+		case HCTX_TYPE_DEFAULT:
+			queue_map->nr_queues = msix_queue_count;
+			queue_map->queue_offset = queue_offset;
+			BUG_ON(!queue_map->nr_queues);
+			blk_mq_map_hw_queues(
+				queue_map, &adapter->pdev->dev, 0);
+			break;
+		case HCTX_TYPE_POLL:
+			queue_map->nr_queues = poll_queue_count;
+			queue_map->queue_offset = queue_offset;
+			blk_mq_map_queues(queue_map);
+			break;
+		default:
+			queue_map->queue_offset = queue_offset;
+			blk_mq_map_hw_queues(
+				queue_map, &adapter->pdev->dev, 0);
+			break;
+		}
+		queue_offset += queue_map->nr_queues;
+	}
+
+out:
+	return;
+}
+
+int
+leapraid_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct leapraid_adapter *adapter =
+		 (struct leapraid_adapter *) shost->hostdata;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	int num_entries;
+	int qid = queue_num - adapter->notification_desc.iopoll_qdex;
+
+	if (atomic_read(&adapter->notification_desc.blk_mq_poll_rqs[qid].pause)
+		 || !atomic_add_unless(
+			&adapter->notification_desc.blk_mq_poll_rqs[qid].busy,
+				 1, 1))
+		return 0;
+
+	blk_mq_poll_rq = &adapter->notification_desc.blk_mq_poll_rqs[qid];
+	num_entries = leapraid_rep_queue_handler(&blk_mq_poll_rq->rq);
+	atomic_dec(&adapter->notification_desc.blk_mq_poll_rqs[qid].busy);
+	return num_entries;
+}
+
+static int
+leapraid_bios_param(struct scsi_device *sdev,
+	 struct block_device *bdev,
+	 sector_t capacity,
+	 int geom[])
+{
+	int heads = 0;
+	int sectors = 0;
+	sector_t cylinders;
+
+	if (scsi_partsize(bdev, capacity, geom))
+		return 0;
+
+	if ((ulong) capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+	} else {
+		heads = 64;
+		sectors = 32;
+	}
+
+	cylinders = capacity;
+	sector_div(cylinders, heads * sectors);
+
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+	return 0;
+}
+
+static ssize_t
+fw_queue_depth_show(struct device *cdev, struct device_attribute *attr,
+	 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	return sysfs_emit(buf, "%02d\n",
+		 adapter->adapter_attr.features.req_slot);
+}
+
+static ssize_t
+host_sas_address_show(struct device *cdev, struct device_attribute *attr,
+	 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	return sysfs_emit(buf, "0x%016llx\n",
+		 (unsigned long long)adapter->dev_topo.card.sas_address);
+}
+
+
+static DEVICE_ATTR_RO(fw_queue_depth);
+static DEVICE_ATTR_RO(host_sas_address);
+
+static struct attribute *leapraid_shost_attrs[] = {
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_host_sas_address.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(leapraid_shost);
+
+static ssize_t
+sas_address_show(struct device *dev, struct device_attribute *attr,
+	 char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+
+	return sysfs_emit(buf, "0x%016llx\n",
+		 (unsigned long long)sas_device_priv_data->starget_priv->sas_address);
+}
+
+static ssize_t
+sas_device_handle_show(struct device *dev, struct device_attribute *attr,
+	 char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+
+	return sysfs_emit(buf, "0x%04x\n",
+		 sas_device_priv_data->starget_priv->hdl);
+}
+
+static ssize_t
+sas_ncq_show(struct device *dev, struct device_attribute *attr,
+	 char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+
+	return sysfs_emit(buf, "%d\n",
+		 sas_device_priv_data->ncq);
+}
+
+static ssize_t
+sas_ncq_store(struct device *dev, struct device_attribute *attr,
+	 const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+	struct scsi_vpd *vpd_pg89;
+	int ncq_op = 0;
+	bool ncq_supported = false;
+
+	if (kstrtoint(buf, 0, &ncq_op))
+		goto out;
+
+	rcu_read_lock();
+	vpd_pg89 = rcu_dereference(sdev->vpd_pg89);
+	if (!vpd_pg89 || vpd_pg89->len < 214) {
+		rcu_read_unlock();
+		goto out;
+	}
+
+	ncq_supported = (vpd_pg89->data[213] >> 4) & 1;
+	rcu_read_unlock();
+	if (ncq_supported)
+		sas_device_priv_data->ncq = ncq_op;
+	return strlen(buf);
+out:
+	return -EINVAL;
+}
+
+static DEVICE_ATTR_RO(sas_address);
+static DEVICE_ATTR_RO(sas_device_handle);
+
+static DEVICE_ATTR_RW(sas_ncq);
+
+static struct attribute *leapraid_sdev_attrs[] = {
+	&dev_attr_sas_address.attr,
+	&dev_attr_sas_device_handle.attr,
+	&dev_attr_sas_ncq.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(leapraid_sdev);
+
+static struct scsi_host_template leapraid_driver_template = {
+	.module = THIS_MODULE,
+	.name = "LEAPIO RAID Host",
+	.proc_name = LEAPRAID_DRIVER_NAME,
+	.queuecommand = leapraid_queuecommand,
+	.cmd_size = sizeof(struct leapraid_io_req_tracker),
+	.init_cmd_priv = leapraid_init_cmd_priv,
+	.exit_cmd_priv = leapraid_exit_cmd_priv,
+	.eh_abort_handler = leapraid_eh_abort_handler,
+	.eh_device_reset_handler = leapraid_eh_device_reset_handler,
+	.eh_target_reset_handler = leapraid_eh_target_reset_handler,
+	.eh_host_reset_handler = leapraid_eh_host_reset_handler,
+	.sdev_init = leapraid_sdev_init,
+	.sdev_destroy = leapraid_sdev_destroy,
+	.sdev_configure = leapraid_sdev_configure,
+	.target_alloc = leapraid_target_alloc,
+	.target_destroy = leapraid_target_destroy,
+	.scan_finished = leapraid_scan_finished,
+	.scan_start = leapraid_scan_start,
+	.change_queue_depth = leapraid_change_queue_depth,
+	.map_queues = leapraid_map_queues,
+	.mq_poll = leapraid_blk_mq_poll,
+	.bios_param = leapraid_bios_param,
+	.can_queue = 1,
+	.this_id = -1,
+	.sg_tablesize = LEAPRAID_SG_DEPTH,
+	.max_sectors = 32767,
+	.max_segment_size = 0xffffffff,
+	.cmd_per_lun = 128,
+	.shost_groups = leapraid_shost_groups,
+	.sdev_groups = leapraid_sdev_groups,
+	.track_queue_depth = 1,
+};
+
+static void
+leapraid_lock_init(struct leapraid_adapter *adapter)
+{
+	mutex_init(&adapter->reset_desc.adapter_reset_mutex);
+	mutex_init(&adapter->reset_desc.host_diag_mutex);
+	mutex_init(&adapter->access_ctrl.pci_access_lock);
+
+	spin_lock_init(&adapter->reset_desc.adapter_reset_lock);
+	spin_lock_init(&adapter->dynamic_task_desc.task_lock);
+	spin_lock_init(&adapter->dev_topo.sas_dev_lock);
+	spin_lock_init(&adapter->dev_topo.topo_node_lock);
+	spin_lock_init(&adapter->fw_evt_s.fw_evt_lock);
+	spin_lock_init(&adapter->dev_topo.raid_volume_lock);
+}
+
+static void
+leapraid_list_init(struct leapraid_adapter *adapter)
+{
+	INIT_LIST_HEAD(&adapter->dev_topo.sas_dev_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.card_port_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.sas_dev_init_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.exp_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.enc_list);
+	INIT_LIST_HEAD(&adapter->fw_evt_s.fw_evt_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.raid_volume_list);
+	INIT_LIST_HEAD(&adapter->dev_topo.card.sas_port_list);
+}
+
+static int
+leapraid_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct leapraid_adapter *adapter = NULL;
+	struct Scsi_Host *shost = NULL;
+	int iopoll_q_count = 0;
+	int rc;
+
+	shost = scsi_host_alloc(&leapraid_driver_template,
+		 sizeof(struct leapraid_adapter));
+	if (!shost)
+		return -ENODEV;
+
+	adapter = shost_priv(shost);
+	memset(adapter, 0, sizeof(struct leapraid_adapter));
+	adapter->adapter_attr.id = leapraid_ids++;
+
+	adapter->adapter_attr.enable_mp = enable_mp;
+
+	adapter = shost_priv(shost);
+	INIT_LIST_HEAD(&adapter->list);
+	spin_lock(&leapraid_adapter_lock);
+	list_add_tail(&adapter->list, &leapraid_adapter_list);
+	spin_unlock(&leapraid_adapter_lock);
+
+	adapter->shost = shost;
+	adapter->pdev = pdev;
+	adapter->fw_log_desc.open_pcie_trace = open_pcie_trace;
+	leapraid_lock_init(adapter);
+	leapraid_list_init(adapter);
+	sprintf(adapter->adapter_attr.name, "%s%d",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+
+	shost->max_cmd_len = 32;
+	shost->max_lun = 16384;
+	shost->transportt = leapraid_transport_template;
+	shost->unique_id = adapter->adapter_attr.id;
+
+
+	snprintf(adapter->fw_evt_s.fw_evt_name,
+		 sizeof(adapter->fw_evt_s.fw_evt_name),
+		 "fw_event_%s%d", LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->fw_evt_s.fw_evt_thread = alloc_ordered_workqueue(
+		adapter->fw_evt_s.fw_evt_name, 0);
+	if (!adapter->fw_evt_s.fw_evt_thread) {
+		rc = -ENODEV;
+		goto evt_wq_fail;
+	}
+
+	shost->host_tagset = 1;
+	adapter->scan_dev_desc.driver_loading = true;
+	if ((leapraid_ctrl_init(adapter))) {
+		rc = -ENODEV;
+		goto ctrl_init_fail;
+	}
+
+
+	shost->nr_hw_queues = 1;
+	if (shost->host_tagset) {
+		shost->nr_hw_queues = adapter->adapter_attr.rq_cnt;
+		iopoll_q_count =
+			 adapter->adapter_attr.rq_cnt
+				 - adapter->notification_desc.iopoll_qdex;
+		shost->nr_maps = iopoll_q_count ? 3 : 1;
+		dev_info(&adapter->pdev->dev,
+			 "max scsi io cmds %d shared with nr_hw_queues=%d\n",
+			 shost->can_queue, shost->nr_hw_queues);
+	}
+
+	rc = scsi_add_host(shost, &pdev->dev);
+	if (rc) {
+		spin_lock(&leapraid_adapter_lock);
+		list_del(&adapter->list);
+		spin_unlock(&leapraid_adapter_lock);
+		goto scsi_add_shost_fail;
+	}
+
+	scsi_scan_host(shost);
+	return 0;
+
+scsi_add_shost_fail:
+	leapraid_remove_ctrl(adapter);
+ctrl_init_fail:
+	destroy_workqueue(adapter->fw_evt_s.fw_evt_thread);
+evt_wq_fail:
+	spin_lock(&leapraid_adapter_lock);
+	list_del(&adapter->list);
+	spin_unlock(&leapraid_adapter_lock);
+	scsi_host_put(shost);
+	return rc;
+}
+
+static void
+leapraid_cleanup_lists(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume, *next_raid_volume;
+	struct leapraid_starget_priv *starget_priv_data;
+	struct leapraid_sas_port *leapraid_port, *next_port;
+	struct leapraid_card_port *port, *port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	list_for_each_entry_safe(raid_volume, next_raid_volume,
+		 &adapter->dev_topo.raid_volume_list, list) {
+		if (raid_volume->starget) {
+			starget_priv_data = raid_volume->starget->hostdata;
+			starget_priv_data->deleted = true;
+			scsi_remove_target(&raid_volume->starget->dev);
+		}
+		pr_info("removing hdl=0x%04x, wwid=0x%016llx\n",
+			 raid_volume->hdl,
+			 (unsigned long long)raid_volume->wwid);
+		leapraid_raid_volume_remove(adapter, raid_volume);
+	}
+
+	list_for_each_entry_safe(leapraid_port, next_port,
+		 &adapter->dev_topo.card.sas_port_list, port_list) {
+		if (leapraid_port->remote_identify.device_type
+			 == SAS_END_DEVICE)
+			leapraid_sas_dev_remove_by_sas_address(adapter,
+				 leapraid_port->remote_identify.sas_address,
+				 leapraid_port->card_port);
+		else if (leapraid_port->remote_identify.device_type ==
+			 SAS_EDGE_EXPANDER_DEVICE
+			 || leapraid_port->remote_identify.device_type ==
+			 SAS_FANOUT_EXPANDER_DEVICE)
+			leapraid_exp_rm(adapter,
+				 leapraid_port->remote_identify.sas_address,
+				 leapraid_port->card_port);
+	}
+
+	list_for_each_entry_safe(port, port_next,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (port->vphys_mask)
+			list_for_each_entry_safe(vphy, vphy_next,
+				 &port->vphys_list, list) {
+				list_del(&vphy->list);
+				kfree(vphy);
+			}
+		list_del(&port->list);
+		kfree(port);
+	}
+
+	if (adapter->dev_topo.card.phys_num) {
+		kfree(adapter->dev_topo.card.card_phy);
+		adapter->dev_topo.card.card_phy = NULL;
+		adapter->dev_topo.card.phys_num = 0;
+	}
+}
+
+static void
+leapraid_remove(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "unable to remove!\n");
+		return;
+	}
+
+	while (adapter->scan_dev_desc.driver_loading)
+		ssleep(1);
+
+	while (adapter->access_ctrl.shost_recovering)
+		ssleep(1);
+
+	adapter->access_ctrl.host_removing = true;
+
+	leapraid_wait_cmds_done(adapter);
+
+	leapraid_smart_polling_stop(adapter);
+	leapraid_free_internal_scsi_cmd(adapter);
+
+	if (leapraid_pci_removed(adapter)) {
+		leapraid_mq_polling_pause(adapter);
+		leapraid_clean_active_scsi_cmds(adapter);
+	}
+	leapraid_clean_active_fw_evt(adapter);
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+	wq = adapter->fw_evt_s.fw_evt_thread;
+	adapter->fw_evt_s.fw_evt_thread = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock,
+		 flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	leapraid_ir_shutdown(adapter);
+	sas_remove_host(shost);
+	leapraid_cleanup_lists(adapter);
+	leapraid_remove_ctrl(adapter);
+	spin_lock(&leapraid_adapter_lock);
+	list_del(&adapter->list);
+	spin_unlock(&leapraid_adapter_lock);
+	scsi_host_put(shost);
+}
+
+static void
+leapraid_shutdown(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "unable to shutdown!\n");
+		return;
+	}
+
+	adapter->access_ctrl.host_removing = true;
+	leapraid_wait_cmds_done(adapter);
+	leapraid_clean_active_fw_evt(adapter);
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	wq = adapter->fw_evt_s.fw_evt_thread;
+	adapter->fw_evt_s.fw_evt_thread = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	leapraid_ir_shutdown(adapter);
+	leapraid_disable_controller(adapter);
+}
+
+static pci_ers_result_t
+leapraid_pci_error_detected(struct pci_dev *pdev,
+	 pci_channel_state_t state)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "failed to error detected for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pr_err("%s: pci error detected, state=%d\n",
+		 adapter->adapter_attr.name, state);
+
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		adapter->access_ctrl.pcie_recovering = true;
+		scsi_block_requests(adapter->shost);
+		leapraid_smart_polling_stop(adapter);
+		leapraid_check_scheduled_fault_stop(adapter);
+		leapraid_fw_log_stop(adapter);
+		leapraid_disable_controller(adapter);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		adapter->access_ctrl.pcie_recovering = true;
+		leapraid_smart_polling_stop(adapter);
+		leapraid_check_scheduled_fault_stop(adapter);
+		leapraid_fw_log_stop(adapter);
+		leapraid_mq_polling_pause(adapter);
+		leapraid_clean_active_scsi_cmds(adapter);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t
+leapraid_pci_mmio_enabled(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			 "failed to enable mmio for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	dev_info(&pdev->dev, "%s: pci error mmio enabled\n",
+		 adapter->adapter_attr.name);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t
+leapraid_pci_slot_reset(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	int rc;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			 "failed to slot reset for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	dev_err(&pdev->dev, "%s pci error slot reset\n",
+		 adapter->adapter_attr.name);
+
+	adapter->access_ctrl.pcie_recovering = false;
+	adapter->pdev = pdev;
+	pci_restore_state(pdev);
+	if (leapraid_set_pcie_and_notification(adapter))
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	dev_info(&pdev->dev, "%s: hard reset triggered by pci slot reset\n",
+		 adapter->adapter_attr.name);
+	rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+	dev_info(&pdev->dev, "%s hard reset: %s\n",
+		 adapter->adapter_attr.name, (rc == 0) ? "success" : "failed");
+
+	return (rc == 0) ? PCI_ERS_RESULT_RECOVERED :
+		 PCI_ERS_RESULT_DISCONNECT;
+}
+
+static void
+leapraid_pci_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "failed to resume\n");
+		return;
+	}
+
+	dev_err(&pdev->dev, "PCI error resume!\n");
+	pci_aer_clear_nonfatal_status(pdev);
+	leapraid_check_scheduled_fault_start(adapter);
+	leapraid_fw_log_start(adapter);
+	scsi_unblock_requests(adapter->shost);
+	leapraid_smart_polling_start(adapter);
+}
+
+MODULE_DEVICE_TABLE(pci, leapraid_pci_table);
+static struct pci_error_handlers leapraid_err_handler = {
+	.error_detected = leapraid_pci_error_detected,
+	.mmio_enabled = leapraid_pci_mmio_enabled,
+	.slot_reset = leapraid_pci_slot_reset,
+	.resume = leapraid_pci_resume,
+};
+
+#ifdef CONFIG_PM
+static int
+leapraid_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	pci_power_t device_state;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			 "suspend failed, invalid host or adapter\n");
+		return -ENXIO;
+	}
+
+	leapraid_smart_polling_stop(adapter);
+	leapraid_check_scheduled_fault_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	scsi_block_requests(shost);
+	device_state = pci_choose_state(pdev, state);
+	leapraid_ir_shutdown(adapter);
+
+	dev_info(&pdev->dev,
+		 "entering PCI power state D%d, (slot=%s)\n",
+		 device_state, pci_name(pdev));
+
+	pci_save_state(pdev);
+	leapraid_disable_controller(adapter);
+	pci_set_power_state(pdev, device_state);
+	return 0;
+}
+
+static int
+leapraid_resume(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pdev_to_shost(pdev);
+	pci_power_t device_state = pdev->current_state;
+	int rc;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			 "resume failed, invalid host or adapter\n");
+		return -ENXIO;
+	}
+
+	dev_info(&pdev->dev,
+		 "resuming device %s, previous state D%d\n",
+		 pci_name(pdev), device_state);
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	adapter->pdev = pdev;
+	rc = leapraid_set_pcie_and_notification(
+		adapter);
+	if (rc)
+		return rc;
+
+	leapraid_hard_reset_handler(adapter,
+		 PART_RESET);
+	scsi_unblock_requests(shost);
+	leapraid_check_scheduled_fault_start(adapter);
+	leapraid_fw_log_start(adapter);
+	leapraid_smart_polling_start(adapter);
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+static struct pci_driver leapraid_driver = {
+	.name = LEAPRAID_DRIVER_NAME,
+	.id_table = leapraid_pci_table,
+	.probe = leapraid_probe,
+	.remove = leapraid_remove,
+	.shutdown = leapraid_shutdown,
+	.err_handler = &leapraid_err_handler,
+#ifdef CONFIG_PM
+	.suspend = leapraid_suspend,
+	.resume = leapraid_resume,
+#endif /* CONFIG_PM */
+};
+
+static int __init leapraid_init(void)
+{
+	int error;
+
+	pr_info("%s version %s loaded\n", LEAPRAID_DRIVER_NAME,
+		 LEAPRAID_DRIVER_VERSION);
+
+	leapraid_transport_template =
+		 sas_attach_transport(&leapraid_transport_functions);
+	if (!leapraid_transport_template)
+		return -ENODEV;
+
+	leapraid_ids = 0;
+
+	leapraid_ctl_init();
+
+	error = pci_register_driver(&leapraid_driver);
+	if (error)
+		sas_release_transport(leapraid_transport_template);
+
+	return error;
+}
+
+static void __exit leapraid_exit(void)
+{
+	pr_info("leapraid version %s unloading\n",
+		LEAPRAID_DRIVER_VERSION);
+
+	leapraid_ctl_exit();
+	pci_unregister_driver(&leapraid_driver);
+	sas_release_transport(leapraid_transport_template);
+}
+
+module_init(leapraid_init);
+module_exit(leapraid_exit);
diff --git a/drivers/scsi/leapraid/leapraid_transport.c b/drivers/scsi/leapraid/leapraid_transport.c
new file mode 100644
index 000000000000..1c6dcd09cd1d
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_transport.c
@@ -0,0 +1,1235 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 LeapIO Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+ * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
+ * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
+ * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
+ * PURPOSE. Each Recipient is solely responsible for determining
+ * the appropriateness of using and distributing the Program and
+ * assumes all risks associated with its exercise of rights under
+ * this Agreement, including but not limited to the risks and costs
+ * of program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
+ * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES
+ */
+
+#include <scsi/scsi_host.h>
+
+#include "leapraid_func.h"
+
+static struct leapraid_topo_node *
+leapraid_transport_sas_topo_node_find_by_sas_addr(
+	struct leapraid_adapter *adapter,
+	 u64 sas_addr, struct leapraid_card_port *card_port)
+{
+	if (adapter->dev_topo.card.sas_address == sas_addr)
+		return &adapter->dev_topo.card;
+	else
+		return leapraid_exp_find_by_sas_address(adapter,
+			 sas_addr, card_port);
+}
+
+static u8
+leapraid_get_port_id_by_expander(struct leapraid_adapter *adapter,
+	 struct sas_rphy *rphy)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock,
+		 flags);
+	list_for_each_entry(topo_node_exp, &adapter->dev_topo.exp_list,
+		 list) {
+		if (topo_node_exp->rphy == rphy) {
+			port_id = topo_node_exp->card_port->port_id;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+		 flags);
+
+	return port_id;
+}
+
+static u8
+leapraid_get_port_id_by_end_dev(struct leapraid_adapter *adapter,
+	 struct sas_rphy *rphy)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(adapter,
+		 rphy->identify.sas_address, rphy);
+	if (sas_dev) {
+		port_id = sas_dev->card_port->port_id;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	return port_id;
+}
+
+static u8
+leapraid_transport_get_port_id_by_rphy(struct leapraid_adapter *adapter,
+	 struct sas_rphy *rphy)
+{
+	if (!rphy)
+		return 0xFF;
+
+	switch (rphy->identify.device_type) {
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		return leapraid_get_port_id_by_expander(adapter, rphy);
+	case SAS_END_DEVICE:
+		return leapraid_get_port_id_by_end_dev(adapter, rphy);
+	default:
+		return 0xFF;
+	}
+}
+
+static enum sas_linkrate
+leapraid_transport_convert_phy_link_rate(u8 link_rate)
+{
+	unsigned int i;
+
+	#define SAS_RATE_12G SAS_LINK_RATE_12_0_GBPS
+
+	const struct linkrate_map {
+		u8 in;
+		enum sas_linkrate out;
+	} linkrate_table[] = {
+		{ LEAPRAID_SAS_NEG_LINK_RATE_1_5, SAS_LINK_RATE_1_5_GBPS },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_3_0, SAS_LINK_RATE_3_0_GBPS },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_6_0, SAS_LINK_RATE_6_0_GBPS },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_12_0, SAS_RATE_12G },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_PHY_DISABLED,
+			 SAS_PHY_DISABLED },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED,
+			 SAS_LINK_RATE_FAILED },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_PORT_SELECTOR,
+			 SAS_SATA_PORT_SELECTOR },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_SMP_RESETTING,
+			 SAS_LINK_RATE_UNKNOWN },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE,
+			 SAS_LINK_RATE_UNKNOWN },
+		{ LEAPRAID_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE,
+			 SAS_LINK_RATE_UNKNOWN },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(linkrate_table); i++) {
+		if (linkrate_table[i].in == link_rate)
+			return linkrate_table[i].out;
+	}
+
+	return SAS_LINK_RATE_UNKNOWN;
+}
+
+static void
+leapraid_set_identify_protocol_flags(u32 dev_info,
+	 struct sas_identify *identify)
+{
+	unsigned int i;
+
+	const struct protocol_mapping {
+		u32 mask;
+		u32 *target;
+		u32 protocol;
+	} mappings[] = {
+		{ LEAPRAID_DEVTYP_SSP_INIT,
+			 &identify->initiator_port_protocols,
+			 SAS_PROTOCOL_SSP },
+		{ LEAPRAID_DEVTYP_STP_INIT,
+			 &identify->initiator_port_protocols,
+			 SAS_PROTOCOL_STP },
+		{ LEAPRAID_DEVTYP_SMP_INIT,
+			 &identify->initiator_port_protocols,
+			 SAS_PROTOCOL_SMP },
+		{ LEAPRAID_DEVTYP_SATA_HOST,
+			 &identify->initiator_port_protocols,
+			 SAS_PROTOCOL_SATA },
+
+		{ LEAPRAID_DEVTYP_SSP_TGT, &identify->target_port_protocols,
+			 SAS_PROTOCOL_SSP },
+		{ LEAPRAID_DEVTYP_STP_TGT, &identify->target_port_protocols,
+			 SAS_PROTOCOL_STP },
+		{ LEAPRAID_DEVTYP_SMP_TGT, &identify->target_port_protocols,
+			 SAS_PROTOCOL_SMP },
+		{ LEAPRAID_DEVTYP_SATA_DEV, &identify->target_port_protocols,
+			 SAS_PROTOCOL_SATA },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(mappings); i++)
+		if ((dev_info & mappings[i].mask) && mappings[i].target)
+			*mappings[i].target |= mappings[i].protocol;
+}
+
+static int
+leapraid_transport_set_identify(struct leapraid_adapter *adapter,
+	 u16 hdl, struct sas_identify *identify)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_pg0;
+	u32 dev_info;
+
+	if ((adapter->access_ctrl.shost_recovering
+		 && !adapter->scan_dev_desc.driver_loading)
+		 || adapter->access_ctrl.pcie_recovering)
+		return -EFAULT;
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if ((leapraid_op_config_page(adapter, &sas_dev_pg0, cfgp1,
+		 cfgp2, GET_SAS_DEVICE_PG0)))
+		return -ENXIO;
+
+	memset(identify, 0, sizeof(struct sas_identify));
+	dev_info = le32_to_cpu(sas_dev_pg0.dev_info);
+	identify->sas_address = le64_to_cpu(sas_dev_pg0.sas_address);
+	identify->phy_identifier = sas_dev_pg0.phy_num;
+
+	switch (dev_info & LEAPRAID_DEVTYP_MASK_DEV_TYPE) {
+	case LEAPRAID_DEVTYP_NO_DEV:
+		identify->device_type = SAS_PHY_UNUSED;
+		break;
+	case LEAPRAID_DEVTYP_END_DEV:
+		identify->device_type = SAS_END_DEVICE;
+		break;
+	case LEAPRAID_DEVTYP_EDGE_EXPANDER:
+		identify->device_type = SAS_EDGE_EXPANDER_DEVICE;
+		break;
+	case LEAPRAID_DEVTYP_FANOUT_EXPANDER:
+		identify->device_type = SAS_FANOUT_EXPANDER_DEVICE;
+		break;
+	}
+
+	leapraid_set_identify_protocol_flags(dev_info,
+		 identify);
+
+	return 0;
+}
+
+static void
+leapraid_transport_exp_set_edev(struct leapraid_adapter *adapter,
+		 void *data_out, struct sas_expander_device *edev)
+{
+	struct leapraid_smp_passthrough_rep *smp_passthrough_rep;
+	struct leapraid_rep_manu_reply *rep_manu_reply;
+	u8 *component_id;
+
+	smp_passthrough_rep = (void *)(
+		&adapter->driver_cmds.transport_cmd.reply);
+	if (le16_to_cpu(smp_passthrough_rep->resp_data_len) !=
+		sizeof(struct leapraid_rep_manu_reply))
+		return;
+
+	rep_manu_reply
+		= data_out + sizeof(struct leapraid_rep_manu_request);
+	(void)strscpy(edev->vendor_id, rep_manu_reply->vendor_identification,
+		 SAS_EXPANDER_VENDOR_ID_LEN);
+	(void)strscpy(edev->product_id, rep_manu_reply->product_identification,
+		 SAS_EXPANDER_PRODUCT_ID_LEN);
+	(void)strscpy(edev->product_rev, rep_manu_reply->product_revision_level,
+		 SAS_EXPANDER_PRODUCT_REV_LEN);
+	edev->level = rep_manu_reply->sas_format & 1;
+	if (edev->level) {
+		(void)strscpy(edev->component_vendor_id,
+			 rep_manu_reply->component_vendor_identification,
+			 SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+
+		component_id = (u8 *) &rep_manu_reply->component_id;
+		edev->component_id = component_id[0] << 8 | component_id[1];
+		edev->component_revision_id =
+			 rep_manu_reply->component_revision_level;
+	}
+}
+
+static int
+leapraid_transport_exp_report_manu(struct leapraid_adapter *adapter,
+	 u64 sas_address, struct sas_expander_device *edev, u8 port_id)
+{
+	struct leapraid_smp_passthrough_req *smp_passthrough_req;
+	struct leapraid_rep_manu_request *rep_manu_request;
+	dma_addr_t h2c_dma_addr;
+	dma_addr_t c2h_dma_addr;
+	bool issue_reset = false;
+	void *data_out = NULL;
+	size_t c2h_size;
+	size_t h2c_size;
+	void *psge;
+	int rc = 0;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering) {
+		return -EFAULT;
+	}
+
+	mutex_lock(&adapter->driver_cmds.transport_cmd.mutex);
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_PENDING;
+	rc = leapraid_check_adapter_is_op(adapter);
+	if (rc)
+		goto out;
+
+	h2c_size = sizeof(struct leapraid_rep_manu_request);
+	c2h_size = sizeof(struct leapraid_rep_manu_reply);
+	data_out = dma_alloc_coherent(&adapter->pdev->dev,
+		 h2c_size + c2h_size, &h2c_dma_addr, GFP_ATOMIC);
+	if (!data_out) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rep_manu_request = data_out;
+	rep_manu_request->smp_frame_type =
+		 SMP_REPORT_MANUFACTURER_INFORMATION_FRAME_TYPE;
+	rep_manu_request->function = SMP_REPORT_MANUFACTURER_INFORMATION_FUNC;
+	rep_manu_request->allocated_response_length = 0;
+	rep_manu_request->request_length = 0;
+
+	smp_passthrough_req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.transport_cmd.inter_taskid);
+	memset(smp_passthrough_req, 0,
+		 sizeof(struct leapraid_smp_passthrough_req));
+	smp_passthrough_req->func = LEAPRAID_FUNC_SMP_PASSTHROUGH;
+	smp_passthrough_req->physical_port = port_id;
+	smp_passthrough_req->sas_address = cpu_to_le64(sas_address);
+	smp_passthrough_req->req_data_len = cpu_to_le16(h2c_size);
+	psge = &smp_passthrough_req->sgl;
+	c2h_dma_addr = h2c_dma_addr + sizeof(struct leapraid_rep_manu_request);
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+		 h2c_size, c2h_dma_addr, c2h_size);
+
+	init_completion(&adapter->driver_cmds.transport_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.transport_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.transport_cmd.done,
+		 10 * HZ);
+	if (!(adapter->driver_cmds.transport_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: smp passthrough to exp timeout\n",
+			 __func__);
+		if (!(adapter->driver_cmds.transport_cmd.status
+				 & LEAPRAID_CMD_RESET))
+			issue_reset = true;
+
+		goto hard_reset;
+	}
+
+	if (adapter->driver_cmds.transport_cmd.status
+			 & LEAPRAID_CMD_REPLY_VALID)
+		leapraid_transport_exp_set_edev(adapter, data_out, edev);
+
+hard_reset:
+	if (issue_reset)
+		leapraid_hard_reset_handler(adapter, FULL_RESET);
+out:
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_NOT_USED;
+	if (data_out)
+		dma_free_coherent(&adapter->pdev->dev, h2c_size + c2h_size,
+			 data_out, h2c_dma_addr);
+
+	mutex_unlock(&adapter->driver_cmds.transport_cmd.mutex);
+	return rc;
+}
+
+static void
+leapraid_transport_del_port(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port)
+{
+	dev_info(&sas_port->port->dev,
+		 "remove port: sas addr=0x%016llx\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address);
+	switch (sas_port->remote_identify.device_type) {
+	case SAS_END_DEVICE:
+		leapraid_sas_dev_remove_by_sas_address(adapter,
+			 sas_port->remote_identify.sas_address,
+			 sas_port->card_port);
+		break;
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		leapraid_exp_rm(adapter, sas_port->remote_identify.sas_address,
+			 sas_port->card_port);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+leapraid_transport_del_phy(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port,
+	 struct leapraid_card_phy *card_phy)
+{
+	dev_info(&card_phy->phy->dev,
+		 "remove phy: sas addr=0x%016llx, phy=%d\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address,
+		 card_phy->phy_id);
+	list_del(&card_phy->port_siblings);
+	sas_port->phys_num--;
+	sas_port_delete_phy(sas_port->port, card_phy->phy);
+	card_phy->phy_is_assigned = false;
+}
+
+static void
+leapraid_transport_add_phy(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port,
+	 struct leapraid_card_phy *card_phy)
+{
+	dev_info(&card_phy->phy->dev,
+		 "add phy: sas addr=0x%016llx, phy=%d\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address,
+		 card_phy->phy_id);
+	list_add_tail(&card_phy->port_siblings,
+		 &sas_port->phy_list);
+	sas_port->phys_num++;
+	sas_port_add_phy(sas_port->port, card_phy->phy);
+	card_phy->phy_is_assigned = true;
+}
+
+void
+leapraid_transport_attach_phy_to_port(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node,
+	 struct leapraid_card_phy *card_phy,
+	 u64 sas_address,
+	 struct leapraid_card_port *card_port)
+{
+	struct leapraid_sas_port *sas_port;
+	struct leapraid_card_phy *card_phy_srch;
+
+	if (card_phy->phy_is_assigned)
+		return;
+
+	if (!card_port)
+		return;
+
+	list_for_each_entry(sas_port, &topo_node->sas_port_list,
+		 port_list) {
+		if (sas_port->remote_identify.sas_address != sas_address)
+			continue;
+
+		if (sas_port->card_port != card_port)
+			continue;
+
+		list_for_each_entry(card_phy_srch, &sas_port->phy_list,
+			 port_siblings) {
+			if (card_phy_srch == card_phy)
+				return;
+		}
+		leapraid_transport_add_phy(adapter, sas_port, card_phy);
+		return;
+	}
+}
+
+void
+leapraid_transport_detach_phy_to_port(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node,
+	 struct leapraid_card_phy *target_card_phy)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+	struct leapraid_card_phy *cur_card_phy;
+
+	if (!target_card_phy->phy_is_assigned)
+		return;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+		 &topo_node->sas_port_list, port_list) {
+		list_for_each_entry(cur_card_phy, &sas_port->phy_list,
+			 port_siblings) {
+			if (cur_card_phy != target_card_phy)
+				continue;
+
+			if (sas_port->phys_num == 1
+				 && !adapter->access_ctrl.shost_recovering)
+				leapraid_transport_del_port(adapter, sas_port);
+			else
+				leapraid_transport_del_phy(adapter, sas_port,
+					 target_card_phy);
+			return;
+		}
+	}
+}
+
+static void
+leapraid_detach_phy_from_old_port(struct leapraid_adapter *adapter,
+	 struct leapraid_topo_node *topo_node, u64 sas_address,
+	 struct leapraid_card_port *card_port)
+{
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++) {
+		if (topo_node->card_phy[i].remote_identify.sas_address
+			 != sas_address
+			 || topo_node->card_phy[i].card_port != card_port)
+			continue;
+		if (topo_node->card_phy[i].phy_is_assigned)
+			leapraid_transport_detach_phy_to_port(
+				adapter, topo_node,
+				 &topo_node->card_phy[i]);
+	}
+}
+
+static struct leapraid_sas_port *
+leapraid_prepare_sas_port(struct leapraid_adapter *adapter,
+	 u16 handle, u64 sas_address, struct leapraid_card_port *card_port,
+	 struct leapraid_topo_node **out_topo_node)
+{
+	struct leapraid_topo_node *topo_node;
+	struct leapraid_sas_port *sas_port;
+	unsigned long flags;
+
+	sas_port = kzalloc(sizeof(*sas_port), GFP_KERNEL);
+	if (!sas_port)
+		return NULL;
+
+	INIT_LIST_HEAD(&sas_port->port_list);
+	INIT_LIST_HEAD(&sas_port->phy_list);
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node = leapraid_transport_sas_topo_node_find_by_sas_addr(
+		 adapter, sas_address, card_port);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (!topo_node) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: failed to find parent node for sas addr 0x%016llx!\n",
+			 __func__, sas_address);
+		kfree(sas_port);
+		return NULL;
+	}
+
+	if (leapraid_transport_set_identify(adapter, handle,
+		 &sas_port->remote_identify)) {
+		kfree(sas_port);
+		return NULL;
+	}
+
+	if (sas_port->remote_identify.device_type == SAS_PHY_UNUSED) {
+		kfree(sas_port);
+		return NULL;
+	}
+
+	sas_port->card_port = card_port;
+	*out_topo_node = topo_node;
+
+	return sas_port;
+}
+
+static int
+leapraid_bind_phys_and_vphy(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port,
+	 struct leapraid_topo_node *topo_node,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_vphy **out_vphy)
+{
+	struct leapraid_vphy *vphy = NULL;
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++) {
+		if (topo_node->card_phy[i].remote_identify.sas_address
+			 != sas_port->remote_identify.sas_address
+			 || topo_node->card_phy[i].card_port != card_port)
+			continue;
+
+		list_add_tail(&topo_node->card_phy[i].port_siblings,
+			 &sas_port->phy_list);
+		sas_port->phys_num++;
+
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num) {
+			if (!topo_node->card_phy[i].vphy) {
+				card_port->phy_mask |= BIT(i);
+				continue;
+			}
+
+			vphy = leapraid_get_vphy_by_phy(card_port, i);
+			if (!vphy)
+				return -1;
+		}
+	}
+
+	*out_vphy = vphy;
+	return sas_port->phys_num ? 0 : -1;
+}
+
+static struct sas_rphy *
+leapraid_create_and_register_rphy(struct leapraid_adapter *adapter,
+	 struct leapraid_sas_port *sas_port,
+	 struct leapraid_topo_node *topo_node,
+	 struct leapraid_card_port *card_port,
+	 struct leapraid_vphy *vphy)
+{
+	struct leapraid_sas_dev *sas_dev = NULL;
+	struct leapraid_card_phy *card_phy;
+	struct sas_port *port;
+	struct sas_rphy *rphy;
+
+	if (!topo_node->parent_dev)
+		return NULL;
+
+	port = sas_port_alloc_num(topo_node->parent_dev);
+	if (sas_port_add(port))
+		return NULL;
+
+	list_for_each_entry(card_phy, &sas_port->phy_list, port_siblings) {
+		sas_port_add_phy(port, card_phy->phy);
+		card_phy->phy_is_assigned = true;
+		card_phy->card_port = card_port;
+	}
+
+	if (sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_dev = leapraid_get_sas_dev_by_addr(adapter,
+			 sas_port->remote_identify.sas_address, card_port);
+		if (!sas_dev)
+			return NULL;
+		sas_dev->pend_sas_rphy_add = 1;
+		rphy = sas_end_device_alloc(port);
+		sas_dev->rphy = rphy;
+
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num) {
+			if (!vphy)
+				card_port->sas_address = sas_dev->sas_addr;
+			else
+				vphy->sas_address = sas_dev->sas_addr;
+		}
+
+	} else {
+		rphy = sas_expander_alloc(port,
+			 sas_port->remote_identify.device_type);
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num)
+			card_port->sas_address =
+				 sas_port->remote_identify.sas_address;
+	}
+
+	rphy->identify = sas_port->remote_identify;
+
+	if (sas_rphy_add(rphy))
+		dev_err(&adapter->pdev->dev,
+			 "%s: failed to add rphy\n", __func__);
+
+	if (sas_dev) {
+		sas_dev->pend_sas_rphy_add = 0;
+		leapraid_sdev_put(sas_dev);
+	}
+
+	sas_port->port = port;
+	return rphy;
+}
+
+struct leapraid_sas_port *
+leapraid_transport_port_add(struct leapraid_adapter *adapter,
+	 u16 hdl, u64 sas_address, struct leapraid_card_port *card_port)
+{
+	struct leapraid_card_phy *card_phy, *card_phy_next;
+	struct leapraid_topo_node *topo_node = NULL;
+	struct leapraid_sas_port *sas_port = NULL;
+	struct leapraid_vphy *vphy = NULL;
+	struct sas_rphy *rphy = NULL;
+	unsigned long flags;
+
+	if (!card_port)
+		return NULL;
+
+	sas_port = leapraid_prepare_sas_port(adapter, hdl, sas_address,
+		 card_port, &topo_node);
+	if (!sas_port)
+		return NULL;
+
+	leapraid_detach_phy_from_old_port(adapter, topo_node,
+		 sas_port->remote_identify.sas_address, card_port);
+
+	if (leapraid_bind_phys_and_vphy(adapter,
+		 sas_port, topo_node, card_port, &vphy))
+		goto out_fail;
+
+	rphy = leapraid_create_and_register_rphy(adapter, sas_port, topo_node,
+		 card_port, vphy);
+	if (!rphy)
+		goto out_fail;
+
+	dev_info(&rphy->dev,
+		 "%s: added dev: hdl=0x%04x, sas addr=0x%016llx\n",
+		 __func__, hdl,
+		 (unsigned long long)sas_port->remote_identify.sas_address);
+
+	sas_port->rphy = rphy;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_add_tail(&sas_port->port_list, &topo_node->sas_port_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (sas_port->remote_identify.device_type
+		 == LEAPRAID_DEVTYP_EDGE_EXPANDER
+		 || sas_port->remote_identify.device_type
+			 == LEAPRAID_DEVTYP_FANOUT_EXPANDER)
+		leapraid_transport_exp_report_manu(adapter,
+			 sas_port->remote_identify.sas_address,
+			 rphy_to_expander_device(rphy), card_port->port_id);
+
+	return sas_port;
+
+out_fail:
+	list_for_each_entry_safe(card_phy, card_phy_next,
+		 &sas_port->phy_list, port_siblings)
+		list_del(&card_phy->port_siblings);
+	kfree(sas_port);
+	return NULL;
+}
+
+static struct leapraid_sas_port *
+leapraid_find_and_remove_sas_port(struct leapraid_topo_node *topo_node,
+	 u64 sas_address, struct leapraid_card_port *remove_card_port,
+	 bool *found)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+		 &topo_node->sas_port_list, port_list) {
+		if (sas_port->remote_identify.sas_address != sas_address)
+			continue;
+
+		if (sas_port->card_port != remove_card_port)
+			continue;
+
+		*found = true;
+		list_del(&sas_port->port_list);
+		return sas_port;
+	}
+	return NULL;
+}
+
+static void
+leapraid_cleanup_card_port_and_vphys(struct leapraid_adapter *adapter,
+	u64 sas_address, struct leapraid_card_port *remove_card_port)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	if (remove_card_port->vphys_mask) {
+		list_for_each_entry_safe(vphy, vphy_next,
+			 &remove_card_port->vphys_list, list) {
+			if (vphy->sas_address != sas_address)
+				continue;
+
+			dev_info(&adapter->pdev->dev,
+				 "%s: remove vphy: %p from port: %p, port_id=%d\n",
+				 __func__, vphy, remove_card_port,
+					 remove_card_port->port_id);
+
+			remove_card_port->vphys_mask &= ~vphy->phy_mask;
+			list_del(&vphy->list);
+			kfree(vphy);
+		}
+
+		if (!remove_card_port->vphys_mask
+			 && !remove_card_port->sas_address) {
+			dev_info(&adapter->pdev->dev,
+				 "%s: remove empty hba_port: %p, port_id=%d\n",
+				 __func__,
+				 remove_card_port,
+				 remove_card_port->port_id);
+			list_del(&remove_card_port->list);
+			kfree(remove_card_port);
+			remove_card_port = NULL;
+		}
+	}
+
+	list_for_each_entry_safe(card_port, card_port_next,
+		 &adapter->dev_topo.card_port_list, list) {
+		if (card_port != remove_card_port)
+			continue;
+
+		if (card_port->sas_address != sas_address)
+			continue;
+
+		if (!remove_card_port->vphys_mask) {
+			dev_info(&adapter->pdev->dev,
+				 "%s: remove hba_port: %p, port_id=%d\n",
+				 __func__, card_port, card_port->port_id);
+			list_del(&card_port->list);
+			kfree(card_port);
+		} else {
+			dev_info(&adapter->pdev->dev,
+				 "%s: clear sas_address of hba_port: %p, port_id=%d\n",
+				 __func__, card_port, card_port->port_id);
+			remove_card_port->sas_address = 0;
+		}
+		break;
+	}
+}
+
+static void
+leapraid_clear_topo_node_phys(struct leapraid_topo_node *topo_node,
+	u64 sas_address)
+{
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++) {
+		if (topo_node->card_phy[i].remote_identify.sas_address
+			 == sas_address) {
+			memset(&topo_node->card_phy[i].remote_identify, 0,
+				 sizeof(struct sas_identify));
+			topo_node->card_phy[i].vphy = false;
+		}
+	}
+}
+
+void
+leapraid_transport_port_remove(struct leapraid_adapter *adapter,
+	 u64 sas_address, u64 sas_address_parent,
+	 struct leapraid_card_port *remove_card_port)
+{
+	struct leapraid_card_phy *card_phy, *card_phy_next;
+	struct leapraid_sas_port *sas_port = NULL;
+	struct leapraid_topo_node *topo_node;
+	unsigned long flags;
+	bool found = false;
+
+	if (!remove_card_port)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+
+	topo_node = leapraid_transport_sas_topo_node_find_by_sas_addr(
+		 adapter, sas_address_parent, remove_card_port);
+	if (!topo_node) {
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.topo_node_lock, flags);
+		return;
+	}
+
+	sas_port = leapraid_find_and_remove_sas_port(topo_node,
+		 sas_address, remove_card_port, &found);
+
+	if (!found) {
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.topo_node_lock, flags);
+		return;
+	}
+
+	if ((topo_node->hdl <= adapter->dev_topo.card.phys_num) &&
+		 adapter->adapter_attr.enable_mp)
+		leapraid_cleanup_card_port_and_vphys(adapter,
+			 sas_address, remove_card_port);
+
+	leapraid_clear_topo_node_phys(topo_node, sas_address);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	list_for_each_entry_safe(card_phy, card_phy_next,
+		 &sas_port->phy_list, port_siblings) {
+		card_phy->phy_is_assigned = false;
+		if (!adapter->access_ctrl.host_removing)
+			sas_port_delete_phy(sas_port->port, card_phy->phy);
+
+		list_del(&card_phy->port_siblings);
+	}
+
+	if (!adapter->access_ctrl.host_removing)
+		sas_port_delete(sas_port->port);
+
+	dev_info(&adapter->pdev->dev,
+		 "%s: removed sas_port for sas addr=0x%016llx\n",
+		 __func__, (unsigned long long)sas_address);
+
+	kfree(sas_port);
+}
+
+static void
+leapraid_init_sas_or_exp_phy(struct leapraid_adapter *adapter,
+	 struct leapraid_card_phy *card_phy,
+	 struct sas_phy *phy,
+	 struct leapraid_sas_phy_p0 *phy_pg0,
+	 struct leapraid_exp_p1 *exp_pg1)
+{
+	if (exp_pg1 && phy_pg0)
+		return;
+
+	if (!exp_pg1 && !phy_pg0)
+		return;
+
+	phy->identify = card_phy->identify;
+	phy->identify.phy_identifier = card_phy->phy_id;
+	phy->negotiated_linkrate = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->neg_link_rate &
+				 LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->neg_link_rate
+				 & LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL);
+	phy->minimum_linkrate_hw = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->hw_link_rate & LEAPRAID_SAS_HWRATE_MIN_RATE_MASK) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->hw_link_rate & LEAPRAID_SAS_HWRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate_hw = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->hw_link_rate >> 4) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->hw_link_rate >> 4);
+	phy->minimum_linkrate = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->p_link_rate & LEAPRAID_SAS_PRATE_MIN_RATE_MASK) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->p_link_rate & LEAPRAID_SAS_PRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->p_link_rate >> 4) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->p_link_rate >> 4);
+	phy->hostdata = card_phy->card_port;
+}
+
+void
+leapraid_transport_add_card_phy(struct leapraid_adapter *adapter,
+	struct leapraid_card_phy *card_phy,
+	struct leapraid_sas_phy_p0 *phy_pg0,
+	struct device *parent_dev)
+{
+	struct sas_phy *phy;
+
+	INIT_LIST_HEAD(&card_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, card_phy->phy_id);
+	if (!phy) {
+		dev_err(&adapter->pdev->dev,
+			 "%s sas_phy_alloc failed!\n", __func__);
+		return;
+	}
+
+	if ((leapraid_transport_set_identify(adapter, card_phy->hdl,
+		 &card_phy->identify))) {
+		dev_err(&adapter->pdev->dev,
+			 "%s set phy handle identify failed!\n", __func__);
+		sas_phy_free(phy);
+		return;
+	}
+
+	card_phy->attached_hdl = le16_to_cpu(phy_pg0->attached_dev_hdl);
+	if (card_phy->attached_hdl) {
+		if (leapraid_transport_set_identify(adapter,
+			 card_phy->attached_hdl, &card_phy->remote_identify)) {
+			dev_err(&adapter->pdev->dev,
+				"%s set phy attached handle identify failed!\n",
+				 __func__);
+			sas_phy_free(phy);
+			return;
+		}
+	}
+
+	leapraid_init_sas_or_exp_phy(adapter, card_phy,
+		 phy, phy_pg0, NULL);
+
+	if ((sas_phy_add(phy))) {
+		sas_phy_free(phy);
+		return;
+	}
+
+	card_phy->phy = phy;
+}
+
+int
+leapraid_transport_add_exp_phy(struct leapraid_adapter *adapter,
+	struct leapraid_card_phy *card_phy,
+	struct leapraid_exp_p1 *exp_pg1,
+	struct device *parent_dev)
+{
+	struct sas_phy *phy;
+
+	INIT_LIST_HEAD(&card_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, card_phy->phy_id);
+	if (!phy) {
+		dev_err(&adapter->pdev->dev,
+			 "%s sas_phy_alloc failed!\n", __func__);
+		return -EFAULT;
+	}
+
+	if ((leapraid_transport_set_identify(adapter, card_phy->hdl,
+		 &card_phy->identify))) {
+		dev_err(&adapter->pdev->dev,
+			 "%s set phy hdl identify failed!\n", __func__);
+		sas_phy_free(phy);
+		return -EFAULT;
+	}
+
+	card_phy->attached_hdl = le16_to_cpu(exp_pg1->attached_dev_hdl);
+	if (card_phy->attached_hdl) {
+		if (leapraid_transport_set_identify(
+			adapter, card_phy->attached_hdl,
+			 &card_phy->remote_identify)) {
+			dev_err(&adapter->pdev->dev,
+				"%s set phy attached hdl identify failed!\n", __func__);
+			sas_phy_free(phy);
+		}
+	}
+
+	leapraid_init_sas_or_exp_phy(adapter, card_phy,
+		 phy, NULL, exp_pg1);
+
+	if ((sas_phy_add(phy))) {
+		sas_phy_free(phy);
+		return -EFAULT;
+	}
+
+	card_phy->phy = phy;
+	return 0;
+}
+
+void
+leapraid_transport_update_links(struct leapraid_adapter *adapter,
+	 u64 sas_address, u16 hdl, u8 phy_index,
+	 u8 link_rate, struct leapraid_card_port *target_card_port)
+{
+	struct leapraid_topo_node *topo_node;
+	struct leapraid_card_phy *card_phy;
+	struct leapraid_card_port *card_port = NULL;
+	unsigned long flags;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node = leapraid_transport_sas_topo_node_find_by_sas_addr(adapter,
+		 sas_address, target_card_port);
+	if (!topo_node) {
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.topo_node_lock, flags);
+		return;
+	}
+
+	card_phy = &topo_node->card_phy[phy_index];
+	card_phy->attached_hdl = hdl;
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (hdl && (link_rate >= LEAPRAID_SAS_NEG_LINK_RATE_1_5)) {
+		leapraid_transport_set_identify(adapter,
+			 hdl, &card_phy->remote_identify);
+		if ((topo_node->hdl <= adapter->dev_topo.card.phys_num)
+			 && (adapter->adapter_attr.enable_mp)) {
+			list_for_each_entry(card_port,
+				 &adapter->dev_topo.card_port_list, list) {
+				if (card_port->sas_address == sas_address
+					 && card_port == target_card_port)
+					card_port->phy_mask
+						 |= BIT(card_phy->phy_id);
+			}
+		}
+		leapraid_transport_attach_phy_to_port(adapter,
+			 topo_node, card_phy,
+			 card_phy->remote_identify.sas_address,
+			 target_card_port);
+	} else
+		memset(&card_phy->remote_identify,
+			 0, sizeof(struct sas_identify));
+
+	if (card_phy->phy)
+		card_phy->phy->negotiated_linkrate
+			 = leapraid_transport_convert_phy_link_rate(link_rate);
+}
+
+static int
+leapraid_dma_map_buffer(struct device *dev, struct bsg_buffer *buf,
+	 dma_addr_t *dma_addr, size_t *dma_len, void **p)
+{
+	if (buf->sg_cnt > 1) {
+		*p = dma_alloc_coherent(dev, buf->payload_len,
+			 dma_addr, GFP_KERNEL);
+		if (!*p)
+			return -ENOMEM;
+
+		*dma_len = buf->payload_len;
+	} else {
+		if (!dma_map_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL))
+			return -ENOMEM;
+
+		*dma_addr = sg_dma_address(buf->sg_list);
+		*dma_len = sg_dma_len(buf->sg_list);
+		*p = NULL;
+	}
+	return 0;
+}
+
+static void
+leapraid_dma_unmap_buffer(struct device *dev,
+	 struct bsg_buffer *buf, dma_addr_t dma_addr, void *p)
+{
+	if (p)
+		dma_free_coherent(dev, buf->payload_len, p, dma_addr);
+	else
+		dma_unmap_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL);
+}
+
+static void
+leapraid_build_smp_task(struct leapraid_adapter *adapter,
+	 struct sas_rphy *rphy,
+	 dma_addr_t h2c_dma_addr, size_t h2c_size,
+	 dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	struct leapraid_smp_passthrough_req *smp_passthrough_req;
+	void *psge;
+
+	smp_passthrough_req = leapraid_get_task_desc(adapter,
+		 adapter->driver_cmds.transport_cmd.inter_taskid);
+	memset(smp_passthrough_req, 0, sizeof(*smp_passthrough_req));
+
+	smp_passthrough_req->func = LEAPRAID_FUNC_SMP_PASSTHROUGH;
+	smp_passthrough_req->physical_port =
+		 leapraid_transport_get_port_id_by_rphy(adapter, rphy);
+	smp_passthrough_req->sas_address = (rphy) ?
+		 cpu_to_le64(rphy->identify.sas_address) :
+		 cpu_to_le64(adapter->dev_topo.card.sas_address);
+	smp_passthrough_req->req_data_len = cpu_to_le16(h2c_size - 4);
+	psge = &smp_passthrough_req->sgl;
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size - 4,
+		 c2h_dma_addr, c2h_size - 4);
+}
+
+static int
+leapraid_send_smp_req(struct leapraid_adapter *adapter)
+{
+	dev_info(&adapter->pdev->dev,
+		 "%s: sending smp request\n", __func__);
+	init_completion(&adapter->driver_cmds.transport_cmd.done);
+	leapraid_fire_task(adapter,
+		 adapter->driver_cmds.transport_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.transport_cmd.done,
+		 10 * HZ);
+	if (!(adapter->driver_cmds.transport_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev, "%s: timeout\n", __func__);
+		if (!(adapter->driver_cmds.transport_cmd.status
+				 & LEAPRAID_CMD_RESET)) {
+			leapraid_hard_reset_handler(adapter, FULL_RESET);
+			return -ETIMEDOUT;
+		}
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "%s: smp request complete\n", __func__);
+	if (!(adapter->driver_cmds.transport_cmd.status
+		 & LEAPRAID_CMD_REPLY_VALID)) {
+		dev_err(&adapter->pdev->dev,
+			 "%s: smp request no reply\n", __func__);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static void
+leapraid_handle_smp_rep(struct leapraid_adapter *adapter,
+	struct bsg_job *job, void *addr_in, unsigned int *reslen)
+{
+	struct leapraid_smp_passthrough_rep *smp_passthrough_rep;
+
+	smp_passthrough_rep =
+		 (void *)(&adapter->driver_cmds.transport_cmd.reply);
+
+	dev_info(&adapter->pdev->dev, "%s: response data len=%d\n",
+		 __func__, le16_to_cpu(smp_passthrough_rep->resp_data_len));
+
+	memcpy(job->reply, smp_passthrough_rep, sizeof(*smp_passthrough_rep));
+	job->reply_len = sizeof(*smp_passthrough_rep);
+	*reslen = le16_to_cpu(smp_passthrough_rep->resp_data_len);
+
+	if (addr_in)
+		sg_copy_from_buffer(job->reply_payload.sg_list,
+			 job->reply_payload.sg_cnt, addr_in,
+			 job->reply_payload.payload_len);
+}
+
+static void
+leapraid_transport_smp_handler(struct bsg_job *job,
+	 struct Scsi_Host *shost, struct sas_rphy *rphy)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	dma_addr_t c2h_dma_addr;
+	dma_addr_t h2c_dma_addr;
+	void *addr_in = NULL;
+	void *addr_out = NULL;
+	size_t c2h_size;
+	size_t h2c_size;
+	int rc;
+	unsigned int reslen = 0;
+
+	if (adapter->access_ctrl.shost_recovering
+		 || adapter->access_ctrl.pcie_recovering) {
+		rc = -EFAULT;
+		goto done;
+	}
+
+	rc = mutex_lock_interruptible(
+		&adapter->driver_cmds.transport_cmd.mutex);
+	if (rc)
+		goto done;
+
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_PENDING;
+	rc = leapraid_dma_map_buffer(&adapter->pdev->dev,
+		 &job->request_payload,
+		 &h2c_dma_addr, &h2c_size, &addr_out);
+	if (rc)
+		goto release_lock;
+
+	if (addr_out)
+		sg_copy_to_buffer(job->request_payload.sg_list,
+			 job->request_payload.sg_cnt, addr_out,
+			 job->request_payload.payload_len);
+
+	rc = leapraid_dma_map_buffer(&adapter->pdev->dev,
+		 &job->reply_payload,
+		 &c2h_dma_addr, &c2h_size, &addr_in);
+	if (rc)
+		goto free_req_buf;
+
+	rc = leapraid_check_adapter_is_op(adapter);
+	if (rc)
+		goto free_rep_buf;
+
+	leapraid_build_smp_task(adapter, rphy,
+		 h2c_dma_addr, h2c_size, c2h_dma_addr, c2h_size);
+
+	rc = leapraid_send_smp_req(adapter);
+	if (rc)
+		goto free_rep_buf;
+
+	leapraid_handle_smp_rep(adapter, job, addr_in, &reslen);
+
+free_rep_buf:
+	leapraid_dma_unmap_buffer(&adapter->pdev->dev,
+		 &job->reply_payload, c2h_dma_addr, addr_in);
+free_req_buf:
+	leapraid_dma_unmap_buffer(&adapter->pdev->dev,
+		 &job->request_payload, h2c_dma_addr, addr_out);
+release_lock:
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.transport_cmd.mutex);
+done:
+	bsg_job_done(job, rc, reslen);
+}
+
+struct sas_function_template leapraid_transport_functions = {
+	.smp_handler = leapraid_transport_smp_handler,
+};
+
+struct scsi_transport_template *leapraid_transport_template;
-- 
2.25.1

