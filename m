Received: from mail-m49235.qiye.163.com (mail-m49235.qiye.163.com [45.254.49.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825427B35B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774000; cv=none; b=VrR1dRyo02y1fNsJAMnjKNl3S2joUZUXXdLVKctMj1ZcYCkkfGIQQD+C4odrnqi/3b+U+MuonwNW22Zz098QXn2LJYnOmneQD00nPH5o47+nyvZeYBJSzw9X97Peecg/LOMPvSvgAe98+m4w2ZNZgH/e8Hs/dQpT/YKASCzZBc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774000; c=relaxed/simple;
	bh=WUDGycHzOSbKmABFNCvE+yeCe3QYVrGKRvMjuHg/Eh4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUvYOnqKF6BITwJax3KGWsQNYS3JjeLblQhMNfNAkckujgB6VlxED06bf05CROnApILT3L/bHCLB29s+GDllVVXM0MDasMEDnLulSRHvq2TvONWhT1XmCbdIYcd+W5H4oZ9TuV9R3uicNxKHpkc8gdKq79EkMdhDELvtVvEX68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=bBDB1XlY; arc=none smtp.client-ip=45.254.49.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="bBDB1XlY"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 42e501437;
	Thu, 18 Jun 2026 16:37:14 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	qtian@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: leapraid: Add new SCSI driver
Date: Thu, 18 Jun 2026 16:37:12 +0800
Message-Id: <82bebf733ce5719706847e91c079ff4bd08ae635.1781767278.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1781767278.git.doubled@leap-io-kernel.com>
References: <cover.1781767278.git.doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed9e0965d03aekunmd3a9a65045f49b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGRpCVkhNQ04eQktKGUxJS1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=bBDB1XlYmnfdHDrN9SPwXP0IHL2idQ9Sx7NCrHIzVxtQA1asTRy+Q+hDbvZpb5XPWogTX6lVPbUGJJhbXoBrI0xbuM5r/3aISI4YX8mdJCE/S+mXmrTWjyD6dWncgNk7azZP5XQakxIhVkcR9O750171+0Te+Yp8kPSo2uYi/Th1HRawe/hBmknAs7S0We7qIlIg0K6s3PjvvSuaQeur1f60nDZGcMx9qrPutPupDIhDnUtNfi12HMijl1L+YLji5FNRWmv4nWJhFp2f2UmS0HrQ7m2MvkmXjBsM16ur40tyPK81BoQQyLbBMJ97n/Rmr50dsRVocHv6Aa6muy5AEg==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=M5DkqGQMrHl0BEByU64zHf74Qw2ST98CJRf+tFnNmh0=;
	h=date:mime-version:subject:message-id:from;

The LeapRAID driver provides support for LeapRAID PCIe RAID controllers,
enabling communication between the host operating system, firmware, and
hardware for efficient storage management.

The driver is organized into several logical modules, each with a clear
responsibility:

leapraid_os.c: Integrates with the Linux SCSI subsystem, handling host
template callbacks, PCIe device probing, and initialization.

leapraid_func.c: Contains low-level routines for firmware/hardware
interaction, interrupt handling, and reset logic.

leapraid_app.c: Provides the ioctl interface for user-space tools.

leapraid_transport.c: Manages interactions with the SCSI transport
layer for SAS PHYs and ports.

leapraid_func.h: Contains internal definitions shared among driver
modules.

leapraid.h: Contains low-level hardware definitions for
driver/firmware interaction.

The leapraid_probe() function orchestrates the setup: it allocates the
adapter structure and SCSI host, configures hardware interfaces, and
registers it with the SCSI mid-layer. Following registration,
scsi_scan_host() is invoked to initiate device discovery, with firmware
reporting devices via interrupt-driven events.

This initial commit provides the necessary infrastructure for
subsequent development of full I/O path handling, error recovery,
and advanced management features.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
 MAINTAINERS                                |    7 +
 drivers/scsi/Kconfig                       |    1 +
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/leapraid/Kconfig              |   14 +
 drivers/scsi/leapraid/Makefile             |   10 +
 drivers/scsi/leapraid/leapraid.h           | 2050 +++++
 drivers/scsi/leapraid/leapraid_app.c       |  699 ++
 drivers/scsi/leapraid/leapraid_func.c      | 8980 ++++++++++++++++++++
 drivers/scsi/leapraid/leapraid_func.h      | 1558 ++++
 drivers/scsi/leapraid/leapraid_os.c        | 2516 ++++++
 drivers/scsi/leapraid/leapraid_transport.c | 1387 +++
 11 files changed, 17223 insertions(+)
 create mode 100644 drivers/scsi/leapraid/Kconfig
 create mode 100644 drivers/scsi/leapraid/Makefile
 create mode 100644 drivers/scsi/leapraid/leapraid.h
 create mode 100644 drivers/scsi/leapraid/leapraid_app.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.h
 create mode 100644 drivers/scsi/leapraid/leapraid_os.c
 create mode 100644 drivers/scsi/leapraid/leapraid_transport.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..da3ee829d5e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14507,6 +14507,13 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/hardening
 F:	scripts/leaking_addresses.pl
 
+LEAPIO SCSI RAID DRIVER
+M:	Dongdong Hao <doubled@leap-io-kernel.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	Documentation/scsi/leapraid.rst
+F:	drivers/scsi/leapraid/
+
 LED SUBSYSTEM
 M:	Lee Jones <lee@kernel.org>
 M:	Pavel Machek <pavel@kernel.org>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c3042393af23..4a2af0f702e1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -499,6 +499,7 @@ source "drivers/scsi/esas2r/Kconfig"
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt3sas/Kconfig"
 source "drivers/scsi/mpi3mr/Kconfig"
+source "drivers/scsi/leapraid/Kconfig"
 source "drivers/scsi/smartpqi/Kconfig"
 
 config SCSI_HPTIOP
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb226..098f35219e7d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -91,6 +91,7 @@ obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_HPSA)		+= hpsa.o
+obj-$(CONFIG_SCSI_LEAPRAID) += leapraid/
 obj-$(CONFIG_SCSI_SMARTPQI)	+= smartpqi/
 obj-$(CONFIG_SCSI_SYM53C8XX_2)	+= sym53c8xx_2/
 obj-$(CONFIG_SCSI_ZALON)	+= zalon7xx.o
diff --git a/drivers/scsi/leapraid/Kconfig b/drivers/scsi/leapraid/Kconfig
new file mode 100644
index 000000000000..f4ece78f80d3
--- /dev/null
+++ b/drivers/scsi/leapraid/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+config SCSI_LEAPRAID
+	tristate "LeapIO RAID Adapter"
+	depends on PCI && SCSI
+	select SCSI_SAS_ATTRS
+	help
+	  This driver supports LeapIO PCIe-based storage
+	  and RAID controllers.
+
+	  <http://www.leap-io.com>
+
+	  To compile this driver as a module, choose M here: the
+	  resulting kernel module will be named leapraid.
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
index 000000000000..c9f403efb84f
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid.h
@@ -0,0 +1,2050 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
+#ifndef LEAPRAID_H
+#define LEAPRAID_H
+
+/* Doorbell register definitions. */
+#define LEAPRAID_DB_RESET       0x00000000
+#define LEAPRAID_DB_READY       0x10000000
+#define LEAPRAID_DB_OPERATIONAL 0x20000000
+#define LEAPRAID_DB_FAULT       0x40000000
+
+#define LEAPRAID_DB_MASK        0xF0000000
+
+#define LEAPRAID_DB_OVER_TEMPERATURE    0x2810
+
+#define LEAPRAID_DB_USED                0x08000000
+#define LEAPRAID_DB_DATA_MASK           0x0000FFFF
+#define LEAPRAID_DB_FUNC_SHIFT          24
+#define LEAPRAID_DB_ADD_DWORDS_SHIFT    16
+
+/* Maximum number of retries waiting for doorbell to become ready. */
+#define LEAPRAID_DB_RETRY_COUNT_MAX    10
+/* Maximum number of retries waiting for doorbell to become operational. */
+#define LEAPRAID_DB_WAIT_OP_SHORT   10
+#define LEAPRAID_DB_WAIT_OP_LONG   200
+
+/* Maximum number of retries waiting for host to end recovery. */
+#define LEAPRAID_WAIT_SHOST_RECOVERY   400
+
+/* Diagnostic register definitions. */
+#define LEAPRAID_DIAG_WRITE_ENABLE      0x00000080
+#define LEAPRAID_DIAG_RESET             0x00000004
+
+/* Interrupt status register definitions. */
+#define LEAPRAID_HOST2ADAPTER_DB_STATUS 0x80000000
+#define LEAPRAID_ADAPTER2HOST_DB_STATUS 0x00000001
+
+/* The number of debug register. */
+#define LEAPRAID_DEBUGLOG_SZ_MAX    16
+#define LEAPRAID_DEBUGLOG_DWORDS_PER_LINE 4
+
+/* Reply post host register definitions. */
+#define REP_POST_HOST_IDX_REG_CNT 16
+#define LEAPRAID_RPHI_MSIX_IDX_SHIFT    24
+
+/* Virtual PHY flags. */
+#define LEAPRAID_SAS_PHYINFO_VPHY       0x00001000
+
+/* Linux driver init firmware. */
+#define LEAPRAID_WHOINIT_LINUX_DRIVER    0x04
+
+/* Reply descriptor post queue array mode. */
+#define LEAPRAID_ADAPTER_INIT_MSGFLG_RDPQ_ARRAY_MODE    0x01
+
+/* Request description flags. */
+#define LEAPRAID_REQ_DESC_FLG_SCSI_IO   0x00
+#define LEAPRAID_REQ_DESC_FLG_HPR       0x06
+#define LEAPRAID_REQ_DESC_FLG_DFLT_TYPE 0x08
+
+/* Reply description flags. */
+#define LEAPRAID_RPY_DESC_FLG_TYPE_MASK                 0x0F
+#define LEAPRAID_RPY_DESC_FLG_SCSI_IO_SUCCESS           0x00
+#define LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY             0x01
+#define LEAPRAID_RPY_DESC_FLG_FP_SCSI_IO_SUCCESS        0x06
+#define LEAPRAID_RPY_DESC_FLG_UNUSED                    0x0F
+
+/* Request and reply messages share the same set of function codes.
+ *
+ * Note: SCSIIO (SCSI I/O) represents SCSI I/O operations and is used
+ * consistently throughout the driver for all SCSI command handling.
+ */
+#define LEAPRAID_FUNC_SCSIIO                    0x00
+#define LEAPRAID_FUNC_SCSI_TMF                  0x01
+#define LEAPRAID_FUNC_ADAPTER_INIT              0x02
+#define LEAPRAID_FUNC_GET_ADAPTER_FEATURES      0x03
+#define LEAPRAID_FUNC_CONFIG_OP                 0x04
+#define LEAPRAID_FUNC_SCAN_DEV                  0x06
+#define LEAPRAID_FUNC_EVENT_NOTIFY              0x07
+#define LEAPRAID_FUNC_FW_DOWNLOAD               0x09
+#define LEAPRAID_FUNC_FW_UPLOAD                 0x12
+#define LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH   0x16
+#define LEAPRAID_FUNC_SCSI_ENC_PROCESSOR        0x18
+#define LEAPRAID_FUNC_SMP_PASSTHROUGH           0x1A
+#define LEAPRAID_FUNC_SAS_IO_UNIT_CTRL          0x1B
+#define LEAPRAID_FUNC_SCSIIO_SATA_PASSTHROUGH   0x1C
+#define LEAPRAID_FUNC_ADAPTER_UNIT_RESET        0x40
+#define LEAPRAID_FUNC_HANDSHAKE                 0x42
+#define LEAPRAID_FUNC_LOGBUF_INIT               0x57
+
+/* Adapter status values. */
+#define LEAPRAID_ADAPTER_STATUS_MASK                    0x7FFF
+#define LEAPRAID_ADAPTER_STATUS_SUCCESS                 0x0000
+#define LEAPRAID_ADAPTER_STATUS_BUSY                    0x0002
+#define LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR          0x0004
+#define LEAPRAID_ADAPTER_STATUS_INSUFFICIENT_RESOURCES  0x0006
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_ACTION   0x0020
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_TYPE     0x0021
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE     0x0022
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_DATA     0x0023
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_NO_DEFAULTS      0x0024
+#define LEAPRAID_ADAPTER_STATUS_CONFIG_CANT_COMMIT      0x0025
+#define LEAPRAID_ADAPTER_STATUS_SCSI_RECOVERED_ERROR    0x0040
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DEVICE_NOT_THERE   0x0043
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DATA_OVERRUN       0x0044
+#define LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN      0x0045
+#define LEAPRAID_ADAPTER_STATUS_SCSI_IO_DATA_ERROR      0x0046
+#define LEAPRAID_ADAPTER_STATUS_SCSI_PROTOCOL_ERROR     0x0047
+#define LEAPRAID_ADAPTER_STATUS_SCSI_TASK_TERMINATED    0x0048
+#define LEAPRAID_ADAPTER_STATUS_SCSI_RESIDUAL_MISMATCH  0x0049
+#define LEAPRAID_ADAPTER_STATUS_SCSI_TASK_MGMT_FAILED   0x004A
+#define LEAPRAID_ADAPTER_STATUS_SCSI_ADAPTER_TERMINATED 0x004B
+#define LEAPRAID_ADAPTER_STATUS_SCSI_EXT_TERMINATED     0x004C
+
+/* SGE flags. */
+#define LEAPRAID_SGE_FLG_LAST_ONE       0x80
+#define LEAPRAID_SGE_FLG_EOB            0x40
+#define LEAPRAID_SGE_FLG_EOL            0x01
+#define LEAPRAID_SGE_FLG_SHIFT          24
+#define LEAPRAID_SGE_FLG_SIMPLE_ONE     0x10
+#define LEAPRAID_SGE_FLG_SYSTEM_ADDR    0x00
+#define LEAPRAID_SGE_FLG_H2C            0x04
+#define LEAPRAID_SGE_FLG_32             0x00
+#define LEAPRAID_SGE_FLG_64             0x02
+
+#define LEAPRAID_IEEE_SGE_FLG_EOL               0x40
+#define LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE        0x00
+#define LEAPRAID_IEEE_SGE_FLG_CHAIN_ONE         0x80
+#define LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR       0x00
+
+#define LEAPRAID_SGE_NO_DATA_ADDR -1
+#define LEAPRAID_SGE_OFFSET_SIZE  4
+
+/* The type of page. */
+#define LEAPRAID_CFG_PT_IO_UNIT         0x00
+#define LEAPRAID_CFG_PT_ADAPTER         0x01
+#define LEAPRAID_CFG_PT_BIOS            0x02
+#define LEAPRAID_CFG_PT_RAID_VOLUME     0x08
+#define LEAPRAID_CFG_PT_MANUFACTURING   0x09
+#define LEAPRAID_CFG_PT_RAID_PHYSDISK   0x0A
+#define LEAPRAID_CFG_PT_EXTENDED        0x0F
+
+/* The type of extended page. */
+#define LEAPRAID_CFG_EXTPT_SAS_IO_UNIT  0x10
+#define LEAPRAID_CFG_EXTPT_SAS_EXP      0x11
+#define LEAPRAID_CFG_EXTPT_SAS_DEV      0x12
+#define LEAPRAID_CFG_EXTPT_SAS_PHY      0x13
+#define LEAPRAID_CFG_EXTPT_ENC          0x15
+#define LEAPRAID_CFG_EXTPT_RAID_CONFIG  0x16
+
+/* Config page address. */
+#define LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP     0x00000000
+#define LEAPRAID_SAS_ENC_CFG_PGAD_HDL           0x10000000
+#define LEAPRAID_SAS_DEV_CFG_PGAD_HDL           0x20000000
+#define LEAPRAID_SAS_EXP_CFG_PGAD_HDL_PHY_NUM   0x10000000
+#define LEAPRAID_SAS_EXP_CFD_PGAD_HDL           0x20000000
+#define LEAPRAID_SAS_EXP_CFG_PGAD_PHYNUM_SHIFT  16
+#define LEAPRAID_RAID_VOL_CFG_PGAD_HDL          0x10000000
+#define LEAPRAID_SAS_PHY_CFG_PGAD_PHY_NUMBER    0x00000000
+#define LEAPRAID_PHYSDISK_CFG_PGAD_PHYSDISKNUM  0x10000000
+
+/* Config page operations. */
+#define LEAPRAID_CFG_ACT_PAGE_HEADER    0x00
+#define LEAPRAID_CFG_ACT_PAGE_READ_CUR  0x01
+#define LEAPRAID_CFG_ACT_PAGE_WRITE_CUR 0x02
+
+/* BIOS page number. */
+#define LEAPRAID_CFG_PAGE_NUM_BIOS2     0x2
+#define LEAPRAID_CFG_PAGE_NUM_BIOS3     0x3
+
+/* Manufacturing page number. */
+#define LEAPRAID_CFG_PAGE_NUM_MANU0     0x0
+
+/* SAS device page number. */
+#define LEAPRAID_CFG_PAGE_NUM_DEV0      0x0
+
+/* SAS device page 0 flags. */
+#define LEAPRAID_SAS_DEV_P0_FLG_SATA_SMART      0x0040
+#define LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID 0x0002
+#define LEAPRAID_SAS_DEV_P0_FLG_DEV_PRESENT     0x0001
+#define LEAPRAID_SAS_DEV_P0_CON_NAME_LEN        4
+
+/* SAS I/O unit page number. */
+#define LEAPRAID_CFG_PAGE_NUM_IOUNIT0   0x0
+#define LEAPRAID_CFG_PAGE_NUM_IOUNIT1   0x1
+
+/* SAS expander page number. */
+#define LEAPRAID_CFG_PAGE_NUM_EXP0      0x0
+#define LEAPRAID_CFG_PAGE_NUM_EXP1      0x1
+
+/* SAS enclosure page number. */
+#define LEAPRAID_CFG_PAGE_NUM_ENC0      0x0
+
+/* SAS PHY page number. */
+#define LEAPRAID_CFG_PAGE_NUM_PHY0      0x0
+
+/* RAID volume page number. */
+#define LEAPRAID_CFG_PAGE_NUM_VOL0      0x0
+#define LEAPRAID_CFG_PAGE_NUM_VOL1      0x1
+
+/* Physical disk page number. */
+#define LEAPRAID_CFG_PAGE_NUM_PD0       0x0
+
+#define LEAPRAID_CFG_UNIT_SIZE  4
+
+/* Raid volume type and state. */
+#define LEAPRAID_VOL_STATE_ONLINE       0x03
+#define LEAPRAID_VOL_STATE_DEGRADED     0x04
+#define LEAPRAID_VOL_STATE_OPTIMAL      0x05
+#define LEAPRAID_VOL_TYPE_RAID0         0x00
+#define LEAPRAID_VOL_TYPE_RAID1E        0x01
+#define LEAPRAID_VOL_TYPE_RAID1         0x02
+#define LEAPRAID_VOL_TYPE_RAID10        0x05
+#define LEAPRAID_VOL_TYPE_UNKNOWN       0xFF
+
+/* Raid volume element flags. */
+#define LEAPRAID_RAIDCFG_P0_EFLG_MASK_ELEMENT_TYPE      0x000F
+#define LEAPRAID_RAIDCFG_P0_EFLG_VOL_PHYS_DISK_ELEMENT  0x0001
+#define LEAPRAID_RAIDCFG_P0_EFLG_HOT_SPARE_ELEMENT      0x0002
+#define LEAPRAID_RAIDCFG_P0_EFLG_OCE_ELEMENT            0x0003
+
+/* SAS negotiated link rates. */
+#define LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL        0x0F
+#define LEAPRAID_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE    0x00
+#define LEAPRAID_SAS_NEG_LINK_RATE_PHY_DISABLED         0x01
+#define LEAPRAID_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED   0x02
+#define LEAPRAID_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE    0x03
+#define LEAPRAID_SAS_NEG_LINK_RATE_PORT_SELECTOR        0x04
+#define LEAPRAID_SAS_NEG_LINK_RATE_SMP_RESETTING        0x05
+#define LEAPRAID_SAS_NEG_LINK_RATE_SHIFT                4
+
+#define LEAPRAID_SAS_NEG_LINK_RATE_1_5  0x08
+#define LEAPRAID_SAS_NEG_LINK_RATE_3_0  0x09
+#define LEAPRAID_SAS_NEG_LINK_RATE_6_0  0x0A
+#define LEAPRAID_SAS_NEG_LINK_RATE_12_0 0x0B
+
+#define LEAPRAID_SAS_PRATE_MIN_RATE_MASK        0x0F
+#define LEAPRAID_SAS_HWRATE_MIN_RATE_MASK       0x0F
+
+/*
+ * Control flags for a SCSI I/O Request.
+ */
+#define LEAPRAID_SCSIIO_CTRL_CDB_32BYTE         4
+#define LEAPRAID_SCSIIO_CTRL_CDB_LEN_SHIFT      26
+#define LEAPRAID_SCSIIO_CTRL_NODATATRANSFER     0x00000000
+#define LEAPRAID_SCSIIO_CTRL_WRITE              0x01000000
+#define LEAPRAID_SCSIIO_CTRL_READ               0x02000000
+#define LEAPRAID_SCSIIO_CTRL_BIDIRECTIONAL      0x03000000
+#define LEAPRAID_SCSIIO_CTRL_SIMPLEQ            0x00000000
+#define LEAPRAID_SCSIIO_CTRL_ORDEREDQ           0x00000200
+#define LEAPRAID_SCSIIO_CTRL_CMDPRI             0x00000800
+
+/* SCSI state and status. */
+#define LEAPRAID_SCSI_STATUS_BUSY                       0x08
+#define LEAPRAID_SCSI_STATUS_RESERVATION_CONFLICT       0x18
+#define LEAPRAID_SCSI_STATUS_TASK_SET_FULL              0x28
+
+#define LEAPRAID_SCSI_STATE_RESPONSE_INFO_VALID 0x10
+#define LEAPRAID_SCSI_STATE_TERMINATED          0x08
+#define LEAPRAID_SCSI_STATE_NO_SCSI_STATUS      0x04
+#define LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED    0x02
+#define LEAPRAID_SCSI_STATE_AUTOSENSE_VALID     0x01
+
+/* SCSI task management defines. */
+#define LEAPRAID_TM_TASKTYPE_ABORT_TASK         0x01
+#define LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET      0x02
+#define LEAPRAID_TM_TASKTYPE_TARGET_RESET       0x03
+#define LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET 0x05
+#define LEAPRAID_TM_TASKTYPE_CLEAR_TASK_SET     0x06
+#define LEAPRAID_TM_TASKTYPE_QUERY_TASK         0x07
+#define LEAPRAID_TM_TASKTYPE_CLEAR_ACA          0x08
+#define LEAPRAID_TM_TASKTYPE_QUERY_TASK_SET     0x09
+#define LEAPRAID_TM_TASKTYPE_QUERY_ASYNC_EVENT  0x0A
+
+#define LEAPRAID_TM_MSGFLAGS_LINK_RESET         0x00
+#define LEAPRAID_TM_RSP_INVALID_FRAME           0x02
+
+/* SCSI enclosure processor request defines. */
+#define LEAPRAID_SEP_REQ_ACT_WRITE_STATUS               0x00
+#define LEAPRAID_SEP_REQ_FLG_DEVHDL_ADDRESS             0x00
+#define LEAPRAID_SEP_REQ_FLG_ENCLOSURE_SLOT_ADDRESS     0x01
+#define LEAPRAID_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT     0x00000040
+
+/* The capabilities of the adapter. */
+#define LEAPRAID_ADAPTER_FEATURES_CAP_ATOMIC_REQ                0x00080000
+#define LEAPRAID_ADAPTER_FEATURES_CAP_INTEGRATED_RAID           0x00001000
+
+/* Event code definitions for the firmware. */
+#define LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE      0x000F
+#define LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST       0x001C
+#define LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE 0x001D
+#define LEAPRAID_EVT_IR_CHANGE          0x0020
+#define LEAPRAID_EVT_TURN_ON_PFA_LED    0xFFFC
+#define LEAPRAID_EVT_SCAN_DEV_DONE      0xFFFD
+#define LEAPRAID_EVT_REMOVE_DEAD_DEV    0xFFFF
+#define LEAPRAID_MAX_EVENT_NUM          128
+
+#define LEAPRAID_EVT_SAS_DEV_STAT_RC_INTERNAL_DEV_RESET         0x08
+#define LEAPRAID_EVT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET     0x0E
+
+/* RAID configuration change event. */
+#define LEAPRAID_EVT_IR_RC_VOLUME_ADD                   0x01
+#define LEAPRAID_EVT_IR_RC_VOLUME_DELETE                0x02
+#define LEAPRAID_EVT_IR_RC_PD_HIDDEN_TO_ADD             0x03
+#define LEAPRAID_EVT_IR_RC_PD_UNHIDDEN_TO_DELETE        0x04
+#define LEAPRAID_EVT_IR_RC_PD_CREATED_TO_HIDE           0x05
+#define LEAPRAID_EVT_IR_RC_PD_DELETED_TO_EXPOSE         0x06
+#define LEAPRAID_EVT_IR_RC_VOLUME_HIDE                  0x0A
+#define LEAPRAID_EVT_IR_RC_VOLUME_UNHIDE                0x0B
+
+/* SAS topology change event. */
+#define LEAPRAID_EVT_SAS_TOPO_ES_NO_EXPANDER    0x00
+#define LEAPRAID_EVT_SAS_TOPO_ES_ADDED          0x01
+#define LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING 0x02
+#define LEAPRAID_EVT_SAS_TOPO_ES_RESPONDING     0x03
+
+#define LEAPRAID_EVT_SAS_TOPO_RC_MASK                   0x0F
+#define LEAPRAID_EVT_SAS_TOPO_RC_TARG_ADDED             0x01
+#define LEAPRAID_EVT_SAS_TOPO_RC_TARG_NOT_RESPONDING    0x02
+
+/* Enclosure device status change event. */
+#define LEAPRAID_EVT_SAS_ENCL_RC_ADDED          0x01
+#define LEAPRAID_EVT_SAS_ENCL_RC_NOT_RESPONDING 0x02
+
+/* Device type and identifiers. */
+#define LEAPRAID_DEVTYP_SEP             0x00004000
+#define LEAPRAID_DEVTYP_SSP_TGT         0x00000400
+#define LEAPRAID_DEVTYP_STP_TGT         0x00000200
+#define LEAPRAID_DEVTYP_SMP_TGT         0x00000100
+#define LEAPRAID_DEVTYP_SATA_DEV        0x00000080
+#define LEAPRAID_DEVTYP_SSP_INIT        0x00000040
+#define LEAPRAID_DEVTYP_STP_INIT        0x00000020
+#define LEAPRAID_DEVTYP_SMP_INIT        0x00000010
+#define LEAPRAID_DEVTYP_SATA_HOST       0x00000008
+
+#define LEAPRAID_DEVTYP_MASK_DEV_TYPE   0x00000007
+#define LEAPRAID_DEVTYP_NO_DEV          0x00000000
+#define LEAPRAID_DEVTYP_END_DEV         0x00000001
+#define LEAPRAID_DEVTYP_EDGE_EXPANDER   0x00000002
+#define LEAPRAID_DEVTYP_FANOUT_EXPANDER 0x00000003
+
+/* SAS control operation. */
+#define LEAPRAID_SAS_OP_PHY_LINK_RESET  0x06
+#define LEAPRAID_SAS_OP_PHY_HARD_RESET  0x07
+#define LEAPRAID_SAS_OP_SET_PARAMETER   0x0F
+
+/* Boot device defines */
+#define LEAPRAID_BOOTDEV_FORM_MASK      0x0F
+#define LEAPRAID_BOOTDEV_FORM_NONE      0x00
+#define LEAPRAID_BOOTDEV_FORM_SAS_WWID  0x05
+#define LEAPRAID_BOOTDEV_FORM_ENC_SLOT  0x06
+#define LEAPRAID_BOOTDEV_FORM_DEV_NAME  0x07
+
+/**
+ * struct leapraid_reg_base - Register layout of the LeapRAID controller
+ *
+ * @db: Doorbell register used to signal commands or status to firmware.
+ * @ws: Write sequence register for synchronizing doorbell operations.
+ * @host_diag: Diagnostic register used for status or debug reporting.
+ * @r1: Reserved.
+ * @host_int_status: Interrupt status register reporting active interrupts.
+ * @host_int_mask: Interrupt mask register enabling or disabling sources.
+ * @r2: Reserved.
+ * @rep_msg_host_idx: Reply message index for the next available reply slot.
+ * @r3: Reserved.
+ * @debug_log: DebugLog registers for firmware debug and diagnostic output.
+ * @r4: Reserved.
+ * @atomic_req_desc_post: Atomic register for single descriptor posting.
+ * @adapter_log_buf_pos: Adapter log buffer write position.
+ * @host_log_buf_pos: Host log buffer write position.
+ * @r5: Reserved.
+ * @rep_post_reg_idx: Array of reply post index registers, one per queue.
+ *                    The number of entries is defined by
+ *                    REP_POST_HOST_IDX_REG_CNT.
+ */
+struct leapraid_reg_base {
+	__le32 db;
+	__le32 ws;
+	__le32 host_diag;
+	__le32 r1[9];
+	__le32 host_int_status;
+	__le32 host_int_mask;
+	__le32 r2[4];
+	__le32 rep_msg_host_idx;
+	__le32 r3[13];
+	__le32 debug_log[LEAPRAID_DEBUGLOG_SZ_MAX];
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
+/**
+ * struct leapraid_atomic_req_desc - Atomic request descriptor
+ *
+ * @flg: Descriptor flag indicating the type of request (e.g. SCSI I/O).
+ * @msix_idx: MSI-X vector index used for interrupt routing.
+ * @taskid: Unique task identifier associated with this request.
+ */
+struct leapraid_atomic_req_desc {
+	u8 flg;
+	u8 msix_idx;
+	__le16 taskid;
+};
+
+/**
+ * union leapraid_rep_desc_union - Unified reply descriptor format
+ *
+ * @dflt_rep: Default reply descriptor containing basic completion info.
+ * @dflt_rep.rep_flg: Reply flag indicating reply type or status.
+ * @dflt_rep.msix_idx: MSI-X index for interrupt routing.
+ * @dflt_rep.taskid: Task identifier matching the submitted request.
+ * @r1: Reserved.
+ *
+ * @addr_rep: Address reply descriptor used when firmware returns a
+ *            memory address associated with the reply.
+ * @addr_rep.rep_flg: Reply flag indicating reply type or status.
+ * @addr_rep.msix_idx: MSI-X index for interrupt routing.
+ * @addr_rep.taskid: Task identifier matching the submitted request.
+ * @addr_rep.rep_frame_addr: Physical address of the reply frame.
+ *
+ * @words: Raw 64-bit representation of the reply descriptor.
+ * @u: Alternative access using 32-bit low/high words.
+ * @u.low: Lower 32 bits of the descriptor.
+ * @u.high: Upper 32 bits of the descriptor.
+ */
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
+/**
+ * struct leapraid_req - Generic request header
+ *
+ * @func_dep1: Function-dependent parameter (low 16 bits).
+ * @r1: Reserved.
+ * @func: Function code identifying the command type.
+ * @r2: Reserved.
+ */
+struct leapraid_req {
+	__le16 func_dep1;
+	u8 r1;
+	u8 func;
+	u8 r2[8];
+};
+
+/**
+ * struct leapraid_rep - Generic reply header
+ *
+ * @r1: Reserved.
+ * @msg_len: Length of the reply message in bytes.
+ * @function: Function code corresponding to the request.
+ * @r2: Reserved.
+ * @adapter_status: Status code reported by the adapter.
+ * @r3: Reserved.
+ */
+struct leapraid_rep {
+	u8 r1[2];
+	u8 msg_len;
+	u8 function;
+	u8 r2[10];
+	__le16 adapter_status;
+	u8 r3[4];
+};
+
+/**
+ * struct leapraid_sge_simple32 - 32-bit simple scatter-gather entry
+ *
+ * @flg_and_len: Combined field for flags and segment length.
+ * @addr: 32-bit physical address of the data buffer.
+ */
+struct leapraid_sge_simple32 {
+	__le32 flg_and_len;
+	__le32 addr;
+};
+
+/**
+ * struct leapraid_sge_simple64 - 64-bit simple scatter-gather entry
+ *
+ * @flg_and_len: Combined field for flags and segment length.
+ * @addr: 64-bit physical address of the data buffer.
+ */
+struct leapraid_sge_simple64 {
+	__le32 flg_and_len;
+	__le64 addr;
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_sge_simple_union - Unified 32/64-bit SGE representation
+ *
+ * @flg_and_len: Combined field for flags and segment length.
+ * @u.addr32: 32-bit address field.
+ * @u.addr64: 64-bit address field.
+ */
+struct leapraid_sge_simple_union {
+	__le32 flg_and_len;
+	union {
+		__le32 addr32;
+		__le64 addr64;
+	} u;
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_sge_chain_union - Chained scatter-gather entry
+ *
+ * @len: Length of the chain descriptor.
+ * @next_chain_offset: Offset to the next SGE chain.
+ * @flg: Flags indicating chain or termination properties.
+ * @u.addr32: 32-bit physical address.
+ * @u.addr64: 64-bit physical address.
+ */
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
+/**
+ * struct leapraid_ieee_sge_simple32 - IEEE 32-bit simple SGE format
+ *
+ * @addr: 32-bit physical address of the data buffer.
+ * @flg_and_len: Combined field for flags and data length.
+ */
+struct leapraid_ieee_sge_simple32 {
+	__le32 addr;
+	__le32 flg_and_len;
+};
+
+/**
+ * struct leapraid_ieee_sge_simple64 - IEEE 64-bit simple SGE format
+ *
+ * @addr: 64-bit physical address of the data buffer.
+ * @len: Length of the data segment.
+ * @r1: Reserved.
+ * @flg: Flags indicating transfer properties.
+ */
+struct leapraid_ieee_sge_simple64 {
+	__le64 addr;
+	__le32 len;
+	u8 r1[3];
+	u8 flg;
+} __packed __aligned(4);
+
+/**
+ * union leapraid_ieee_sge_simple_union - Unified IEEE SGE format
+ *
+ * @simple32: IEEE 32-bit simple SGE entry.
+ * @simple64: IEEE 64-bit simple SGE entry.
+ */
+union leapraid_ieee_sge_simple_union {
+	struct leapraid_ieee_sge_simple32 simple32;
+	struct leapraid_ieee_sge_simple64 simple64;
+};
+
+/**
+ * union leapraid_ieee_sge_chain_union - Unified IEEE SGE chain format
+ *
+ * @chain32: IEEE 32-bit chain SGE entry.
+ * @chain64: IEEE 64-bit chain SGE entry.
+ */
+union leapraid_ieee_sge_chain_union {
+	struct leapraid_ieee_sge_simple32 chain32;
+	struct leapraid_ieee_sge_simple64 chain64;
+};
+
+/**
+ * struct leapraid_chain64_ieee_sg - 64-bit IEEE chain SGE descriptor
+ *
+ * @addr: Physical address of the next chain segment.
+ * @len: Length of the current SGE.
+ * @r1: Reserved.
+ * @next_chain_offset: Offset to the next chain element.
+ * @flg: Flags that describe SGE attributes.
+ */
+struct leapraid_chain64_ieee_sg {
+	__le64 addr;
+	__le32 len;
+	u8 r1[2];
+	u8 next_chain_offset;
+	u8 flg;
+} __packed __aligned(4);
+
+/**
+ * union leapraid_ieee_sge_io_union - IEEE-style SGE union for I/O
+ *
+ * @ieee_simple: Simple IEEE SGE descriptor.
+ * @ieee_chain: IEEE chain SGE descriptor.
+ */
+union leapraid_ieee_sge_io_union {
+	struct leapraid_ieee_sge_simple64 ieee_simple;
+	struct leapraid_chain64_ieee_sg ieee_chain;
+};
+
+/**
+ * union leapraid_simple_sge_union - Union of simple SGE descriptors
+ *
+ * @leapraid_simple: LeapRAID simple SGE.
+ * @ieee_simple: IEEE-style simple SGE.
+ */
+union leapraid_simple_sge_union {
+	struct leapraid_sge_simple_union leapraid_simple;
+	union leapraid_ieee_sge_simple_union ieee_simple;
+};
+
+/**
+ * union leapraid_sge_io_union - Combined SGE union for all I/O types
+ *
+ * @leapraid_simple: LeapRAID simple SGE format.
+ * @leapraid_chain: LeapRAID chain SGE format.
+ * @ieee_simple: IEEE simple SGE format.
+ * @ieee_chain: IEEE chain SGE format.
+ */
+union leapraid_sge_io_union {
+	struct leapraid_sge_simple_union leapraid_simple;
+	struct leapraid_sge_chain_union leapraid_chain;
+	union leapraid_ieee_sge_simple_union ieee_simple;
+	union leapraid_ieee_sge_chain_union ieee_chain;
+};
+
+/**
+ * struct leapraid_cfg_pg_header - Standard configuration page header
+ *
+ * @r1: Reserved.
+ * @page_len: Length of the page in 4-byte units.
+ * @page_num: Page number.
+ * @page_type: Page type.
+ */
+struct leapraid_cfg_pg_header {
+	u8 r1;
+	u8 page_len;
+	u8 page_num;
+	u8 page_type;
+};
+
+/**
+ * struct leapraid_cfg_ext_pg_header - Extended configuration page header
+ *
+ * @r1: Reserved.
+ * @r2: Reserved.
+ * @page_num: Page number.
+ * @page_type: Page type.
+ * @ext_page_len: Extended page length.
+ * @ext_page_type: Extended page type.
+ * @r3: Reserved.
+ */
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
+/**
+ * struct leapraid_cfg_req - Configuration request message
+ *
+ * @action: Requested action type.
+ * @sgl_flag: SGL flag field.
+ * @chain_offset: Offset to next chain SGE.
+ * @func: Function code.
+ * @ext_page_len: Extended page length.
+ * @ext_page_type: Extended page type.
+ * @msg_flag: Message flags.
+ * @r1: Reserved.
+ * @header: Configuration page header.
+ * @page_addr: Address of the page buffer.
+ * @page_buf_sge: SGE describing the page buffer.
+ */
+struct leapraid_cfg_req {
+	u8 action;
+	u8 sgl_flag;
+	u8 chain_offset;
+	u8 func;
+	__le16 ext_page_len;
+	u8 ext_page_type;
+	u8 msg_flag;
+	u8 r1[12];
+	struct leapraid_cfg_pg_header header;
+	__le32 page_addr;
+	union leapraid_sge_io_union page_buf_sge;
+};
+
+/**
+ * struct leapraid_cfg_rep - Configuration reply message
+ *
+ * @action: Action type from the request.
+ * @r1: Reserved.
+ * @msg_len: Message length in bytes.
+ * @func: Function code.
+ * @ext_page_len: Extended page length.
+ * @ext_page_type: Extended page type.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @adapter_status: Adapter status code.
+ * @r3: Reserved.
+ * @header: Configuration page header.
+ */
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
+/**
+ * struct leapraid_boot_dev_format_sas_wwid - Boot device identified by wwid
+ *
+ * @sas_addr: SAS address of the device.
+ * @lun: Logical unit number.
+ * @r1: Reserved.
+ */
+struct leapraid_boot_dev_format_sas_wwid {
+	__le64 sas_addr;
+	u8 lun[8];
+	u8 r1[8];
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_boot_dev_format_enc_slot - identified by enclosure
+ *
+ * @enc_lid: Enclosure logical ID.
+ * @r1: Reserved.
+ * @slot_num: Slot number in the enclosure.
+ * @r2: Reserved.
+ */
+struct leapraid_boot_dev_format_enc_slot {
+	__le64 enc_lid;
+	u8 r1[8];
+	__le16 slot_num;
+	u8 r2[6];
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_boot_dev_format_dev_name - Boot device by device name
+ *
+ * @dev_name: Device name identifier.
+ * @lun: Logical unit number.
+ * @r1: Reserved.
+ */
+struct leapraid_boot_dev_format_dev_name {
+	__le64 dev_name;
+	u8 lun[8];
+	u8 r1[8];
+} __packed __aligned(4);
+
+/**
+ * union leapraid_boot_dev_format - Boot device format union
+ *
+ * @sas_wwid: Format using SAS WWID and LUN.
+ * @enc_slot: Format using enclosure slot and ID.
+ * @dev_name: Format using device name and LUN.
+ */
+union leapraid_boot_dev_format {
+	struct leapraid_boot_dev_format_sas_wwid sas_wwid;
+	struct leapraid_boot_dev_format_enc_slot enc_slot;
+	struct leapraid_boot_dev_format_dev_name dev_name;
+};
+
+/**
+ * struct leapraid_manufacturing_p0 - Manufacturing configuration page 0
+ *
+ * @header: Configuration page header.
+ * @chip_name: Chip name as a 16-byte ASCII string.
+ * @chip_revision: Chip revision as an 8-byte ASCII string.
+ * @board_name: Board name as a 16-byte ASCII string.
+ * @board_assembly: Board assembly as a 16-byte ASCII string.
+ * @board_tracer_number: Board tracer number as a 16-byte ASCII string.
+ */
+struct leapraid_manufacturing_p0 {
+	struct leapraid_cfg_pg_header header;
+	u8 chip_name[16];
+	u8 chip_revision[8];
+	u8 board_name[16];
+	u8 board_assembly[16];
+	u8 board_tracer_number[16];
+};
+
+/**
+ * struct leapraid_bios_page2 - BIOS configuration page 2
+ *
+ * @header: Configuration page header.
+ * @r1: Reserved.
+ * @requested_boot_dev_form: Format type of the requested boot device.
+ * @r2: Reserved.
+ * @requested_boot_dev: Boot device requested by BIOS or user.
+ * @requested_alt_boot_dev_form: Format of the alternate boot device.
+ * @r3: Reserved.
+ * @requested_alt_boot_dev: Alternate boot device requested.
+ * @current_boot_dev_form: Format type of the active boot device.
+ * @r4: Reserved.
+ * @current_boot_dev: Currently active boot device in use.
+ */
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
+/**
+ * struct leapraid_bios_page3 - BIOS configuration page 3
+ *
+ * @header: Configuration page header.
+ * @r1: Reserved.
+ * @bios_version: BIOS firmware version number.
+ * @r2: Reserved.
+ */
+struct leapraid_bios_page3 {
+	struct leapraid_cfg_pg_header header;
+	u8 r1[4];
+	__le32 bios_version;
+	u8 r2[84];
+};
+
+/**
+ * struct leapraid_raidvol0_phys_disk - Physical disk in RAID volume
+ *
+ * @r1: Reserved.
+ * @phys_disk_num: Physical disk number within the RAID volume.
+ * @r2: Reserved.
+ */
+struct leapraid_raidvol0_phys_disk {
+	u8 r1[2];
+	u8 phys_disk_num;
+	u8 r2;
+};
+
+/**
+ * struct leapraid_raidvol_p0 - RAID volume configuration page 0
+ *
+ * @header: Configuration page header.
+ * @dev_hdl: Device handle for the RAID volume.
+ * @volume_state: State of the RAID volume.
+ * @volume_type: RAID type.
+ * @r1: Reserved.
+ * @num_phys_disks: Number of physical disks in the volume.
+ * @r2: Reserved.
+ * @phys_disk: Array of physical disks in this volume.
+ */
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
+/**
+ * struct leapraid_raidvol_p1 - RAID volume configuration page 1
+ *
+ * @header: Configuration page header.
+ * @dev_hdl: Device handle of the RAID volume.
+ * @r1: Reserved.
+ * @wwid: World-wide identifier for the volume.
+ * @r2: Reserved.
+ */
+struct leapraid_raidvol_p1 {
+	struct leapraid_cfg_pg_header header;
+	__le16 dev_hdl;
+	u8 r1[42];
+	__le64 wwid;
+	u8 r2[8];
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_raidpd_p0 - Physical disk configuration page 0
+ *
+ * @header: Configuration page header.
+ * @dev_hdl: Device handle of the physical disk.
+ * @r1: Reserved.
+ * @phys_disk_num: Physical disk number.
+ * @r2: Reserved.
+ */
+struct leapraid_raidpd_p0 {
+	struct leapraid_cfg_pg_header header;
+	__le16 dev_hdl;
+	u8 r1;
+	u8 phys_disk_num;
+	u8 r2[112];
+};
+
+/**
+ * struct leapraid_sas_io_unit0_phy_info - PHY info for SAS I/O unit
+ *
+ * @port: Port number the PHY belongs to.
+ * @port_flg: Flags describing port status.
+ * @phy_flg: Flags describing PHY status.
+ * @neg_link_rate: Negotiated link rate of the PHY.
+ * @controller_phy_dev_info: Controller PHY device info.
+ * @attached_dev_hdl: Handle of attached device.
+ * @controller_dev_hdl: Handle of the controller device.
+ * @r1: Reserved.
+ */
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
+/**
+ * struct leapraid_sas_io_unit_p0 - SAS I/O unit configuration page 0
+ *
+ * @header: Extended configuration page header.
+ * @r1: Reserved.
+ * @phy_num: Number of PHYs in this unit.
+ * @r2: Reserved.
+ * @phy_info: Array of PHY information.
+ */
+struct leapraid_sas_io_unit_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[4];
+	u8 phy_num;
+	u8 r2[3];
+	struct leapraid_sas_io_unit0_phy_info phy_info[];
+};
+
+/**
+ * struct leapraid_exp_p0 - SAS expander page 0
+ *
+ * @header: Extended page header.
+ * @physical_port: Physical port number.
+ * @r1: Reserved.
+ * @enc_hdl: Enclosure handle.
+ * @sas_address: SAS address of the expander.
+ * @r2: Reserved.
+ * @dev_hdl: Device handle of this expander.
+ * @parent_dev_hdl: Device handle of parent expander.
+ * @r3: Reserved.
+ * @phy_num: Number of PHYs.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_exp_p1 - SAS expander page 1
+ *
+ * @header: Extended page header.
+ * @r1: Reserved.
+ * @p_link_rate: PHY link rate.
+ * @hw_link_rate: Hardware supported link rate.
+ * @attached_dev_hdl: Attached device handle.
+ * @r2: Reserved.
+ * @neg_link_rate: Negotiated link rate.
+ * @r3: Reserved.
+ */
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
+/**
+ * struct leapraid_sas_dev_p0 - SAS device page 0
+ *
+ * @header: Extended configuration page header.
+ * @slot: Slot number.
+ * @enc_hdl: Enclosure handle.
+ * @sas_address: SAS address.
+ * @parent_dev_hdl: Parent device handle.
+ * @phy_num: Number of PHYs.
+ * @r1: Reserved.
+ * @dev_hdl: Device handle.
+ * @r2: Reserved.
+ * @dev_info: Device information.
+ * @flg: Flags.
+ * @physical_port: Physical port number.
+ * @max_port_connections: Maximum port connections.
+ * @dev_name: Device name.
+ * @port_groups: Number of port groups.
+ * @r3: Reserved.
+ * @enc_level: Enclosure level.
+ * @connector_name: Connector identifier.
+ * @r4: Reserved.
+ */
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
+	u8 connector_name[LEAPRAID_SAS_DEV_P0_CON_NAME_LEN];
+	u8 r4[4];
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_sas_phy_p0 - SAS PHY configuration page 0
+ *
+ * @header: Extended configuration page header.
+ * @r1: Reserved.
+ * @attached_dev_hdl: Handle of attached device.
+ * @r2: Reserved.
+ * @p_link_rate: PHY link rate.
+ * @hw_link_rate: Hardware supported link rate.
+ * @r3: Reserved.
+ * @phy_info: PHY information.
+ * @neg_link_rate: Negotiated link rate.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_enc_p0 - SAS enclosure page 0
+ *
+ * @header: Extended configuration page header.
+ * @r1: Reserved.
+ * @enc_lid: Enclosure logical ID.
+ * @r2: Reserved.
+ * @enc_hdl: Enclosure handle.
+ * @r3: Reserved.
+ */
+struct leapraid_enc_p0 {
+	struct leapraid_cfg_ext_pg_header header;
+	u8 r1[4];
+	__le64 enc_lid;
+	u8 r2[2];
+	__le16 enc_hdl;
+	u8 r3[15];
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_raid_cfg_p0_element - RAID configuration element
+ *
+ * @element_flg: Element flags.
+ * @vol_dev_hdl: Volume device handle.
+ * @r1: Reserved.
+ * @phys_disk_dev_hdl: Physical disk device handle.
+ */
+struct leapraid_raid_cfg_p0_element {
+	__le16 element_flg;
+	__le16 vol_dev_hdl;
+	u8 r1[2];
+	__le16 phys_disk_dev_hdl;
+};
+
+/**
+ * struct leapraid_raid_cfg_p0 - RAID configuration page 0
+ *
+ * @header: Extended configuration page header.
+ * @r1: Reserved.
+ * @cfg_num: Configuration number.
+ * @r2: Reserved.
+ * @elements_num: Number of RAID elements.
+ * @r3: Reserved.
+ * @cfg_element: Array of RAID elements.
+ */
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
+/**
+ * union leapraid_mpi_scsi_io_cdb_union - SCSI I/O CDB or simple SGE
+ *
+ * @cdb32: 32-byte SCSI command descriptor block.
+ * @sge: Simple SGE format.
+ */
+union leapraid_mpi_scsi_io_cdb_union {
+	u8 cdb32[32];
+	struct leapraid_sge_simple_union sge;
+};
+
+/**
+ * struct leapraid_mpi_scsiio_req - MPI SCSI I/O request
+ *
+ * @dev_hdl: Device handle for the target.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @msg_flg: Message flags.
+ * @r2: Reserved.
+ * @sense_buffer_low_add: Lower 32-bit address of sense buffer.
+ * @dma_flag: DMA flags.
+ * @r3: Reserved.
+ * @sense_buffer_len: Sense buffer length.
+ * @r4: Reserved.
+ * @sgl_offset0..3: SGL offsets.
+ * @skip_count: Bytes to skip before transfer.
+ * @data_len: Length of data transfer.
+ * @bi_dir_data_len: Bi-directional transfer length.
+ * @io_flg: I/O flags.
+ * @eedp_flag: End-to-end data protection flags.
+ * @eedp_block_size: End-to-end data protection block size.
+ * @r5: Reserved.
+ * @secondary_ref_tag: Secondary reference tag.
+ * @secondary_app_tag: Secondary application tag.
+ * @app_tag_trans_mask: Application tag mask.
+ * @lun: Logical Unit Number.
+ * @ctrl: Control flags.
+ * @cdb: SCSI Command Descriptor Block or simple SGE.
+ * @sgl: Scatter-gather list.
+ */
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
+/**
+ * union leapraid_scsi_io_cdb_union - SCSI I/O CDB or IEEE simple SGE
+ *
+ * @cdb32: 32-byte SCSI CDB.
+ * @sge: IEEE simple 64-bit SGE.
+ */
+union leapraid_scsi_io_cdb_union {
+	u8 cdb32[32];
+	struct leapraid_ieee_sge_simple64 sge;
+};
+
+/**
+ * struct leapraid_scsiio_req - SCSI I/O request
+ *
+ * @dev_hdl: Device handle.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @msg_flg: Message flags.
+ * @r2: Reserved.
+ * @sense_buffer_low_add: Lower 32-bit address of sense buffer.
+ * @dma_flag: DMA flag.
+ * @r3: Reserved.
+ * @sense_buffer_len: Sense buffer length.
+ * @r4: Reserved.
+ * @sgl_offset0-3: SGL offsets.
+ * @skip_count: Bytes to skip before transfer.
+ * @data_len: Length of data transfer.
+ * @bi_dir_data_len: Bi-directional transfer length.
+ * @io_flg: I/O flags.
+ * @eedp_flag: End-to-end data protection flags.
+ * @eedp_block_size: End-to-end data protection block size.
+ * @r5: Reserved.
+ * @secondary_ref_tag: Secondary reference tag.
+ * @secondary_app_tag: Secondary application tag.
+ * @app_tag_trans_mask: Application tag mask.
+ * @lun: Logical Unit Number.
+ * @ctrl: Control flags.
+ * @cdb: SCSI Command Descriptor Block or simple SGE.
+ * @sgl: Scatter-gather list.
+ */
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
+/**
+ * struct leapraid_scsiio_rep - SCSI I/O response
+ *
+ * @dev_hdl: Device handle.
+ * @msg_len: Length of response message.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @msg_flg: Message flags.
+ * @r2: Reserved.
+ * @scsi_status: SCSI status.
+ * @scsi_state: SCSI state.
+ * @adapter_status: Adapter status.
+ * @r3: Reserved.
+ * @transfer_count: Number of bytes transferred.
+ * @sense_count: Number of sense bytes.
+ * @resp_info: Additional response info.
+ * @task_tag: Task identifier.
+ * @scsi_status_qualifier: SCSI status qualifier.
+ * @bi_dir_trans_count: Bi-directional transfer count.
+ * @r4: Reserved.
+ */
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
+	__le32 r4[3];
+};
+
+/**
+ * struct leapraid_scsi_tm_req - SCSI Task Management request
+ *
+ * @dev_hdl: Device handle.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @task_type: Task management function type.
+ * @r2: Reserved.
+ * @msg_flg: Message flags.
+ * @r3: Reserved.
+ * @lun: Logical Unit Number.
+ * @r4: Reserved.
+ * @task_mid: Task identifier.
+ * @r5: Reserved.
+ */
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
+/**
+ * struct leapraid_scsi_tm_rep - SCSI Task Management response
+ *
+ * @dev_hdl: Device handle.
+ * @msg_len: Length of response message.
+ * @func: Function code.
+ * @resp_code: Response code.
+ * @task_type: Task management type.
+ * @r1: Reserved.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @adapter_status: Adapter status.
+ * @r3: Reserved.
+ * @termination_count: Count of terminated tasks.
+ * @response_info: Additional response info.
+ */
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
+/**
+ * struct leapraid_sep_req - SEP (SCSI Enclosure Processor) request
+ *
+ * @dev_hdl: Device handle.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @act: Action to perform.
+ * @flg: Flags.
+ * @r1: Reserved.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @slot_status: Slot status.
+ * @r3: Reserved.
+ * @slot: Slot number.
+ * @enc_hdl: Enclosure handle.
+ */
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
+/**
+ * struct leapraid_sep_rep - SEP response
+ *
+ * @dev_hdl: Device handle.
+ * @msg_len: Message length.
+ * @func: Function code.
+ * @act: Action performed.
+ * @flg: Flags.
+ * @msg_flag: Message flags.
+ * @r1: Reserved.
+ * @adapter_status: Adapter status.
+ * @r2: Reserved.
+ * @slot_status: Slot status.
+ * @r3: Reserved.
+ * @slot: Slot number.
+ * @enc_hdl: Enclosure handle.
+ */
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
+/**
+ * struct leapraid_adapter_init_req - Adapter initialization request
+ *
+ * @who_init: Initiator of the initialization.
+ * @r1: Reserved.
+ * @chain_offset: Chain offset.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flg: Message flags.
+ * @r3: Reserved.
+ * @msg_ver: Message version.
+ * @header_ver: Header version.
+ * @host_buf_addr: Host buffer address (non adapter-ref).
+ * @r4: Reserved.
+ * @host_buf_size: Host buffer size (non adapter-ref).
+ * @host_msix_vectors: Number of host MSI-X vectors.
+ * @r6: Reserved.
+ * @req_frame_size: Request frame size.
+ * @rep_desc_qd: Reply descriptor queue depth.
+ * @rep_msg_qd: Reply message queue depth.
+ * @sense_buffer_add_high: High 32-bit of sense buffer address.
+ * @rep_msg_dma_high: High 32-bit of reply message DMA address.
+ * @task_desc_base_addr: Base address of task descriptors.
+ * @rep_desc_q_arr_addr: Address of reply descriptor queue array.
+ * @rep_msg_addr_dma: Reply message DMA address.
+ * @time_stamp: Timestamp.
+ */
+struct leapraid_adapter_init_req {
+	u8 who_init;
+	u8 r1;
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flg;
+	__le32 driver_ver;
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
+/**
+ * struct leapraid_rep_desc_q_arr - Reply descriptor queue array
+ *
+ * @rep_desc_base_addr: Base address of the reply descriptors.
+ * @r1: Reserved.
+ */
+struct leapraid_rep_desc_q_arr {
+	__le64 rep_desc_base_addr;
+	__le64 r1;
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_adapter_init_rep - Adapter initialization reply
+ *
+ * @who_init: Initiator of the initialization.
+ * @r1: Reserved.
+ * @msg_len: Length of reply message.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ * @adapter_status: Adapter status.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_adapter_log_req - Adapter log request
+ *
+ * @action: Action code.
+ * @type: Log type.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * r1: Reserved.
+ * @msg_flag: Message flags.
+ * r2: Reserved.
+ * @mbox: Mailbox for command-specific parameters.
+ * @sge: Scatter-gather entry for data buffer.
+ */
+struct leapraid_adapter_log_req {
+	u8 action;
+	u8 type;
+	u8 chain_offset;
+	u8 func;
+	u8 r1[3];
+	u8 msg_flag;
+	u8 r2[4];
+	union {
+		u8	b[12];
+		__le16	s[6];
+		__le32	w[3];
+	} mbox;
+	struct leapraid_sge_simple64 sge;
+} __packed __aligned(4);
+
+/**
+ * struct leapraid_adapter_log_rep - Adapter log reply
+ *
+ * @action: Action code echoed.
+ * @type: Log type echoed.
+ * @msg_len: Length of message.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @adapter_status: Status returned by adapter.
+ */
+struct leapraid_adapter_log_rep {
+	u8 action;
+	u8 type;
+	u8 msg_len;
+	u8 func;
+	u8 r1[3];
+	u8 msg_flag;
+	u8 r2[6];
+	__le16 adapter_status;
+};
+
+/**
+ * struct leapraid_adapter_features_req - Request adapter features
+ *
+ * @r1: Reserved.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ */
+struct leapraid_adapter_features_req {
+	u8 r1[2];
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[4];
+};
+
+/**
+ * struct leapraid_adapter_features_rep - Adapter features reply
+ *
+ * @msg_ver: Message version.
+ * @msg_len: Length of reply message.
+ * @func: Function code.
+ * @header_ver: Header version.
+ * @r1: Reserved.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @adapter_status: Adapter status.
+ * @r3: Reserved.
+ * @who_init: Who initialized the adapter.
+ * @r4: Reserved.
+ * @max_msix_vectors: Max MSI-X vectors supported.
+ * @req_slot: Number of request slots.
+ * @r5: Reserved.
+ * @adapter_caps: Adapter capabilities.
+ * @fw_version: Firmware version.
+ * @sas_wide_max_qdepth: Max wide SAS queue depth.
+ * @sas_narrow_max_qdepth: Max narrow SAS queue depth.
+ * @r6: Reserved.
+ * @hp_slot: Number of high-priority slots.
+ * @r7: Reserved.
+ * @max_volumes: Maximum supported volumes.
+ * @max_dev_hdl: Maximum device handle.
+ * @r8: Reserved.
+ * @min_dev_hdl: Minimum device handle.
+ * @r9: Reserved.
+ */
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
+/**
+ * struct leapraid_scan_dev_req - Request to scan devices
+ *
+ * @r1: Reserved.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ */
+struct leapraid_scan_dev_req {
+	u8 r1[2];
+	u8 chain_offset;
+	u8 func;
+	u8 r2[3];
+	u8 msg_flag;
+	u8 r3[4];
+};
+
+/**
+ * struct leapraid_scan_dev_rep - Scan devices reply
+ *
+ * @r1: Reserved.
+ * @msg_len: Length of message.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ * @adapter_status: Adapter status.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_evt_notify_req - Event notification request
+ *
+ * @r1: Reserved.
+ * @chain_offset: Offset for chained SGE.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ * @evt_masks: Event masks to enable notifications.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_evt_notify_rep - Event notification reply
+ *
+ * @evt_data_len: Length of event data.
+ * @msg_len: Length of message.
+ * @func: Function code.
+ * @r1: Reserved.
+ * @r2: Reserved.
+ * @msg_flag: Message flags.
+ * @r3: Reserved.
+ * @adapter_status: Adapter status.
+ * @r4: Reserved.
+ * @evt: Event code.
+ * @r5: Reserved.
+ * @evt_data: Event data array.
+ */
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
+/**
+ * struct leapraid_evt_data_sas_dev_status_change - SAS device status change
+ *
+ * @task_tag: Task identifier.
+ * @reason_code: Reason for status change.
+ * @physical_port: Physical port number.
+ * @r1: Reserved.
+ * @dev_hdl: Device handle.
+ * @r2: Reserved.
+ * @sas_address: SAS address of device.
+ * @lun: Logical unit Number.
+ */
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
+/**
+ * struct leapraid_evt_data_ir_change - IR (Integrated RAID) change event data
+ *
+ * @r1: Reserved.
+ * @reason_code: Reason for IR change.
+ * @r2: Reserved.
+ * @vol_dev_hdl: Volume device handle.
+ * @phys_disk_dev_hdl: Physical disk device handle.
+ */
+struct leapraid_evt_data_ir_change {
+	u8 r1;
+	u8 reason_code;
+	u8 r2[2];
+	__le16 vol_dev_hdl;
+	__le16 phys_disk_dev_hdl;
+};
+
+/**
+ * struct leapraid_evt_data_sas_disc - SAS discovery event data
+ *
+ * @r1: Reserved.
+ * @reason_code: Reason for discovery event.
+ * @physical_port: Physical port number where event occurred.
+ * @r2: Reserved.
+ */
+struct leapraid_evt_data_sas_disc {
+	u8 r1;
+	u8 reason_code;
+	u8 physical_port;
+	u8 r2[5];
+};
+
+/**
+ * struct leapraid_evt_sas_topo_phy_entry - SAS topology PHY entry
+ *
+ * @attached_dev_hdl: Device handle attached to PHY.
+ * @link_rate: Current link rate.
+ * @phy_status: PHY status flags.
+ */
+struct leapraid_evt_sas_topo_phy_entry {
+	__le16 attached_dev_hdl;
+	u8 link_rate;
+	u8 phy_status;
+};
+
+/**
+ * struct leapraid_evt_data_sas_topo_change_list - SAS topology change list
+ *
+ * @encl_hdl: Enclosure handle.
+ * @exp_dev_hdl: Expander device handle.
+ * @num_phys: Number of PHYs in this entry.
+ * @r1: Reserved.
+ * @entry_num: Entry index.
+ * @start_phy_num: Start PHY number.
+ * @exp_status: Expander status.
+ * @physical_port: Physical port number.
+ * @phy: Array of SAS PHY entries.
+ */
+struct leapraid_evt_data_sas_topo_change_list {
+	__le16 encl_hdl;
+	__le16 exp_dev_hdl;
+	u8 num_phys;
+	u8 r1[3];
+	u8 entry_num;
+	u8 start_phy_num;
+	u8 exp_status;
+	u8 physical_port;
+	struct leapraid_evt_sas_topo_phy_entry phy[];
+};
+
+/**
+ * struct leapraid_evt_data_sas_enc_dev_status_change -
+ * SAS enclosure device status
+ *
+ * @enc_hdl: Enclosure handle.
+ * @reason_code: Reason code for status change.
+ * @physical_port: Physical port number.
+ * @encl_logical_id: Enclosure logical ID.
+ * @num_slots: Number of slots in enclosure.
+ * @start_slot: First affected slot.
+ * @phy_bits: Bitmap of affected PHYs.
+ */
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
+/**
+ * struct leapraid_io_unit_ctrl_req - I/O unit control request
+ *
+ * @op: Operation code.
+ * @r1: Reserved.
+ * @chain_offset: SGE chain offset.
+ * @func: Function code.
+ * @dev_hdl: Device handle.
+ * @adapter_para: Adapter parameter selector.
+ * @msg_flag: Message flags.
+ * @r2: Reserved.
+ * @phy_num: PHY number.
+ * @r3: Reserved.
+ * @adapter_para_value: Value for adapter parameter.
+ * @adapter_para_value2: Optional second parameter value.
+ * @r4: Reserved.
+ */
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
+/**
+ * struct leapraid_io_unit_ctrl_rep - I/O unit control reply
+ *
+ * @op: Operation code echoed.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @dev_hdl: Device handle.
+ * @r2: Reserved.
+ */
+struct leapraid_io_unit_ctrl_rep {
+	u8 op;
+	u8 r1[2];
+	u8 func;
+	__le16 dev_hdl;
+	u8 r2[14];
+};
+
+/**
+ * struct leapraid_raid_act_req - RAID action request
+ *
+ * @act: RAID action code.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @r2: Reserved.
+ * @phys_disk_num: Number of physical disks involved.
+ * @r3: Reserved.
+ * @action_data_sge: SGE describing action-specific data.
+ */
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
+/**
+ * struct leapraid_raid_act_rep - RAID action reply
+ *
+ * @act: RAID action code echoed.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @vol_dev_hdl: Volume device handle.
+ * @r2: Reserved
+ * @adapter_status: Status returned by adapter.
+ * @r3: Reserved.
+ */
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
+/**
+ * struct leapraid_smp_passthrough_req - SMP passthrough request
+ *
+ * @passthrough_flg: Passthrough flags.
+ * @physical_port: Target PHY port.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @req_data_len: Request data length.
+ * @r2: Reserved.
+ * @sas_address: SAS address of target device.
+ * @r3: Reserved.
+ * @sgl: Scatter-gather list describing request buffer.
+ */
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
+/**
+ * struct leapraid_smp_passthrough_rep - SMP passthrough reply
+ *
+ * @passthrough_flg: Passthrough flags echoed.
+ * @physical_port: Target PHY port.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @resp_data_len: Length of response data.
+ * @r2: Reserved.
+ * @adapter_status: Adapter status.
+ * @r3: Reserved.
+ */
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
+/**
+ * struct leapraid_sas_io_unit_ctrl_req - SAS I/O unit control request
+ *
+ * @op: Operation code.
+ * @r1: Reserved.
+ * @func: Function code.
+ * @dev_hdl: Device handle.
+ * @r2: Reserved.
+ */
+struct leapraid_sas_io_unit_ctrl_req {
+	u8 op;
+	u8 r1[2];
+	u8 func;
+	__le16 dev_hdl;
+	u8 r2[38];
+};
+
+#endif /* LEAPRAID_H */
diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
new file mode 100644
index 000000000000..3200e5a919bf
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -0,0 +1,699 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
+#include <linux/compat.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+
+#include "leapraid_func.h"
+
+/* IOCTL device file name. */
+#define LEAPRAID_DEV_NAME       "leapraid_ctl"
+
+/* IOCTL version. */
+#define LEAPRAID_IOCTL_VERSION  0x07
+
+/* IOCTL commands. */
+#define LEAPRAID_ADAPTER_INFO   17
+#define LEAPRAID_COMMAND        20
+#define LEAPRAID_EVENTQUERY     21
+#define LEAPRAID_EVENTREPORT    23
+
+/**
+ * struct leapraid_ioctl_header - IOCTL command header
+ *
+ * @adapter_id : Adapter identifier.
+ * @port_number: Port identifier.
+ * @max_data_size: Maximum data size for transfer.
+ */
+struct leapraid_ioctl_header {
+	u32 adapter_id;
+	u32 port_number;
+	u32 max_data_size;
+};
+
+/**
+ * struct leapraid_ioctl_diag_reset - Diagnostic reset request
+ *
+ * @hdr: Common IOCTL header.
+ */
+struct leapraid_ioctl_diag_reset {
+	struct leapraid_ioctl_header hdr;
+};
+
+/**
+ * struct leapraid_ioctl_pci_info - PCI device information
+ *
+ * @u: Union holding PCI bus/device/function information.
+ * @u.bits.dev: PCI device number.
+ * @u.bits.func: PCI function number.
+ * @u.bits.bus: PCI bus number.
+ * @u.word: Combined representation of PCI BDF.
+ * @seg_id: PCI segment identifier.
+ */
+struct leapraid_ioctl_pci_info {
+	union {
+		struct {
+			u32 dev:5;
+			u32 func:3;
+			u32 bus:24;
+		} bits;
+		u32 word;
+	} u;
+	u32 seg_id;
+};
+
+/**
+ * struct leapraid_ioctl_adapter_info - Adapter information for IOCTL
+ *
+ * @hdr: IOCTL header.
+ * @adapter_type: Adapter type identifier.
+ * @port_number: Port number.
+ * @pci_id: PCI device ID.
+ * @revision: Revision number.
+ * @sub_dev: Subsystem device ID.
+ * @sub_vendor: Subsystem vendor ID.
+ * @r0: Reserved.
+ * @fw_ver: Firmware version.
+ * @bios_ver: BIOS version.
+ * @driver_ver: Driver version.
+ * @r1: Reserved.
+ * @scsi_id: SCSI ID.
+ * @r2: Reserved.
+ * @pci_info: PCI information structure.
+ */
+struct leapraid_ioctl_adapter_info {
+	struct leapraid_ioctl_header hdr;
+	u32 adapter_type;
+	u32 port_number;
+	u32 pci_id;
+	u32 revision;
+	u32 sub_dev;
+	u32 sub_vendor;
+	u32 r0;
+	u32 fw_ver;
+	u32 bios_ver;
+	u8 driver_ver[32];
+	u8 r1;
+	u8 scsi_id;
+	u16 r2;
+	struct leapraid_ioctl_pci_info pci_info;
+};
+
+/**
+ * struct leapraid_ioctl_command - IOCTL command structure
+ *
+ * @hdr: IOCTL header.
+ * @timeout: Command timeout.
+ * @rep_msg_buf_ptr: User pointer to reply message buffer.
+ * @c2h_buf_ptr: User pointer to card-to-host data buffer.
+ * @h2c_buf_ptr: User pointer to host-to-card data buffer.
+ * @sense_data_ptr: User pointer to sense data buffer.
+ * @max_rep_bytes: Maximum reply bytes.
+ * @c2h_size: Card-to-host data size.
+ * @h2c_size: Host-to-card data size.
+ * @max_sense_bytes: Maximum sense data bytes.
+ * @data_sge_offset: Data SGE offset.
+ * @mf: Message frame data (flexible array).
+ */
+struct leapraid_ioctl_command {
+	struct leapraid_ioctl_header hdr;
+	u32 timeout;
+	void __user *rep_msg_buf_ptr;
+	void __user *c2h_buf_ptr;
+	void __user *h2c_buf_ptr;
+	void __user *sense_data_ptr;
+	u32 max_rep_bytes;
+	u32 c2h_size;
+	u32 h2c_size;
+	u32 max_sense_bytes;
+	u32 data_sge_offset;
+	u8 mf[];
+};
+
+static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
+{
+	struct leapraid_adapter *adapter;
+
+	spin_lock(&leapraid_adapter_lock);
+	list_for_each_entry(adapter, &leapraid_adapter_list, list) {
+		if (adapter->adapter_attr.id == adapter_id) {
+			spin_unlock(&leapraid_adapter_lock);
+			return adapter;
+		}
+	}
+	spin_unlock(&leapraid_adapter_lock);
+
+	return NULL;
+}
+
+static void leapraid_ctl_scsiio_cmd(struct leapraid_adapter *adapter,
+				    void *ctl_sp_mpi_req,
+				    u16 taskid,
+				    dma_addr_t h2c_dma_addr, size_t h2c_size,
+				    dma_addr_t c2h_dma_addr, size_t c2h_size,
+				    u16 dev_hdl, void *psge)
+{
+	struct leapraid_mpi_scsiio_req *scsiio_request = ctl_sp_mpi_req;
+
+	scsiio_request->sense_buffer_len = SCSI_SENSE_BUFFERSIZE;
+	scsiio_request->sense_buffer_low_add =
+		leapraid_get_sense_buffer_dma(adapter, taskid);
+	memset(&adapter->driver_cmds.ctl_cmd.sense,
+	       0, SCSI_SENSE_BUFFERSIZE);
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+			       h2c_size, c2h_dma_addr, c2h_size);
+	if (scsiio_request->func == LEAPRAID_FUNC_SCSIIO)
+		leapraid_fire_scsi_io(adapter, taskid, dev_hdl);
+	else
+		leapraid_fire_task(adapter, taskid);
+}
+
+static int leapraid_ctl_smp_passthrough_cmd(struct leapraid_adapter *adapter,
+					    void *ctl_sp_req,
+					    u16 taskid,
+					    dma_addr_t h2c_dma_addr,
+					    size_t h2c_size,
+					    dma_addr_t c2h_dma_addr,
+					    size_t c2h_size,
+					    void *psge, void *h2c)
+{
+	struct leapraid_smp_passthrough_req *smp_pt_req = ctl_sp_req;
+	u8 *data;
+
+	if (!adapter->adapter_attr.enable_mp)
+		smp_pt_req->physical_port = LEAPRAID_DISABLE_MP_PORT_ID;
+	if (smp_pt_req->passthrough_flg & LEAPRAID_SMP_PT_FLAG_SGL_PTR)
+		data = (u8 *)&smp_pt_req->sgl;
+	else
+		data = h2c;
+
+	if (!(smp_pt_req->passthrough_flg & LEAPRAID_SMP_PT_FLAG_SGL_PTR) &&
+	    h2c_size <= 10) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Invalid request size=%zu\n",
+			__func__, h2c_size);
+		return -EINVAL;
+	}
+
+	if (data[1] == SMP_PHY_CONTROL &&
+	    (data[10] == SMP_PHY_CONTROL_LINK_RESET ||
+	     data[10] == SMP_PHY_CONTROL_HARD_RESET))
+		adapter->reset_desc.adapter_link_resetting = 1;
+
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+			       h2c_size, c2h_dma_addr, c2h_size);
+	leapraid_fire_task(adapter, taskid);
+	return 0;
+}
+
+static void leapraid_ctl_sas_io_unit_ctrl_cmd(struct leapraid_adapter *adapter,
+					      void *ctl_sp_req,
+					      dma_addr_t h2c_dma_addr,
+					      size_t h2c_size,
+					      dma_addr_t c2h_dma_addr,
+					      size_t c2h_size,
+					      void *psge, u16 taskid)
+{
+	struct leapraid_sas_io_unit_ctrl_req *sas_io_unit_ctl_req = ctl_sp_req;
+
+	if (sas_io_unit_ctl_req->op == LEAPRAID_SAS_OP_PHY_HARD_RESET ||
+	    sas_io_unit_ctl_req->op == LEAPRAID_SAS_OP_PHY_LINK_RESET)
+		adapter->reset_desc.adapter_link_resetting = 1;
+	leapraid_build_mpi_sg(adapter, psge, h2c_dma_addr,
+			      h2c_size, c2h_dma_addr, c2h_size);
+	leapraid_fire_task(adapter, taskid);
+}
+
+static int leapraid_ctl_do_command(struct leapraid_adapter *adapter,
+				   struct leapraid_ioctl_command *karg,
+				   void __user *mf)
+{
+	struct leapraid_req *leap_mpi_req;
+	struct leapraid_req *ctl_sp_mpi_req;
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
+	int rc;
+
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					  __func__);
+	if (rc)
+		return rc;
+
+	leap_mpi_req = kzalloc(LEAPRAID_REQUEST_SIZE, GFP_KERNEL);
+	if (!leap_mpi_req)
+		return -ENOMEM;
+
+	if (karg->data_sge_offset > (UINT_MAX / LEAPRAID_SGE_OFFSET_SIZE) ||
+	    karg->data_sge_offset * LEAPRAID_SGE_OFFSET_SIZE >
+	    LEAPRAID_REQUEST_SIZE) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Invalid data_sge_offset=%u\n",
+			__func__, karg->data_sge_offset);
+		rc = -EINVAL;
+		goto out_cleanup;
+	}
+
+	if (copy_from_user(leap_mpi_req, mf,
+			   karg->data_sge_offset * LEAPRAID_SGE_OFFSET_SIZE)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to copy request message from user\n",
+			__func__);
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+	taskid = adapter->driver_cmds.ctl_cmd.taskid;
+
+	adapter->driver_cmds.ctl_cmd.status = LEAPRAID_CMD_PENDING;
+	memset(&adapter->driver_cmds.ctl_cmd.reply, 0,
+	       LEAPRAID_REPLY_SIZE);
+	ctl_sp_mpi_req = leapraid_get_task_desc(adapter, taskid);
+	memset(ctl_sp_mpi_req, 0, LEAPRAID_REQUEST_SIZE);
+	memcpy(ctl_sp_mpi_req,
+	       leap_mpi_req,
+	       karg->data_sge_offset * LEAPRAID_SGE_OFFSET_SIZE);
+
+	if (ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSIIO ||
+	    ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH ||
+	    ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSIIO_SATA_PASSTHROUGH) {
+		dev_hdl = le16_to_cpu(ctl_sp_mpi_req->func_dep1);
+		if (!dev_hdl ||
+		    dev_hdl > adapter->adapter_attr.features.max_dev_handle) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Invalid device handle\n", __func__);
+			rc = -EINVAL;
+			goto out_cleanup;
+		}
+	}
+
+	if (WARN_ON(ctl_sp_mpi_req->func == LEAPRAID_FUNC_SCSI_TMF)) {
+		rc = -EINVAL;
+		goto out_cleanup;
+	}
+
+	h2c_size = karg->h2c_size;
+	c2h_size = karg->c2h_size;
+	if (h2c_size) {
+		h2c = dma_alloc_coherent(&adapter->pdev->dev, h2c_size,
+					 &h2c_dma_addr, GFP_KERNEL);
+		if (!h2c) {
+			rc = -ENOMEM;
+			goto out_cleanup;
+		}
+		if (copy_from_user(h2c, karg->h2c_buf_ptr, h2c_size)) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Failed to copy h2c from user\n",
+				__func__);
+			rc = -EFAULT;
+			goto out_cleanup;
+		}
+	}
+	if (c2h_size) {
+		c2h = dma_alloc_coherent(&adapter->pdev->dev, c2h_size,
+					 &c2h_dma_addr, GFP_KERNEL);
+		if (!c2h) {
+			rc = -ENOMEM;
+			goto out_cleanup;
+		}
+	}
+
+	psge = (void *)ctl_sp_mpi_req + (karg->data_sge_offset *
+					 LEAPRAID_SGE_OFFSET_SIZE);
+	init_completion(&adapter->driver_cmds.ctl_cmd.done);
+
+	switch (ctl_sp_mpi_req->func) {
+	case LEAPRAID_FUNC_SCSIIO:
+	case LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH:
+		leapraid_ctl_scsiio_cmd(adapter, ctl_sp_mpi_req, taskid,
+					h2c_dma_addr, h2c_size,
+					c2h_dma_addr, c2h_size,
+					dev_hdl, psge);
+		break;
+	case LEAPRAID_FUNC_SMP_PASSTHROUGH:
+		if (!h2c) {
+			rc = -EINVAL;
+			goto out_cleanup;
+		}
+		rc = leapraid_ctl_smp_passthrough_cmd(adapter,
+						      ctl_sp_mpi_req, taskid,
+						      h2c_dma_addr, h2c_size,
+						      c2h_dma_addr, c2h_size,
+						      psge, h2c);
+		if (rc)
+			goto out_cleanup;
+		break;
+	case LEAPRAID_FUNC_SCSIIO_SATA_PASSTHROUGH:
+		leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size,
+				       c2h_dma_addr, c2h_size);
+		leapraid_fire_task(adapter, taskid);
+		break;
+	case LEAPRAID_FUNC_FW_DOWNLOAD:
+	case LEAPRAID_FUNC_FW_UPLOAD:
+		leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size,
+				       c2h_dma_addr, c2h_size);
+		leapraid_fire_task(adapter, taskid);
+		break;
+	case LEAPRAID_FUNC_SAS_IO_UNIT_CTRL:
+		leapraid_ctl_sas_io_unit_ctrl_cmd(adapter, ctl_sp_mpi_req,
+						  h2c_dma_addr, h2c_size,
+						  c2h_dma_addr, c2h_size,
+						  psge, taskid);
+		break;
+	default:
+		leapraid_build_mpi_sg(adapter, psge, h2c_dma_addr,
+				      h2c_size, c2h_dma_addr, c2h_size);
+		leapraid_fire_task(adapter, taskid);
+		break;
+	}
+
+	timeout = karg->timeout;
+	if (timeout < LEAPRAID_CTL_CMD_TIMEOUT)
+		timeout = LEAPRAID_CTL_CMD_TIMEOUT;
+	if (!wait_for_completion_timeout(&adapter->driver_cmds.ctl_cmd.done,
+					 timeout * HZ)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: ctl_cmd timeout, status=0x%x\n",
+			__func__, adapter->driver_cmds.ctl_cmd.status);
+		leapraid_log_req_context(adapter, taskid, ctl_sp_mpi_req);
+	}
+
+	if ((leap_mpi_req->func == LEAPRAID_FUNC_SMP_PASSTHROUGH ||
+	     leap_mpi_req->func == LEAPRAID_FUNC_SAS_IO_UNIT_CTRL) &&
+	    adapter->reset_desc.adapter_link_resetting)
+		adapter->reset_desc.adapter_link_resetting = 0;
+
+	if (!(adapter->driver_cmds.ctl_cmd.status & LEAPRAID_CMD_DONE)) {
+		issue_reset =
+			leapraid_check_reset(
+				adapter->driver_cmds.ctl_cmd.status);
+		goto reset;
+	}
+
+	if (c2h_size && copy_to_user(karg->c2h_buf_ptr, c2h, c2h_size)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to copy c2h to user\n", __func__);
+		rc = -ENODATA;
+		goto out_cleanup;
+	}
+	if (karg->max_rep_bytes) {
+		sz = min_t(u32, karg->max_rep_bytes, LEAPRAID_REPLY_SIZE);
+		if (copy_to_user(karg->rep_msg_buf_ptr,
+				 &adapter->driver_cmds.ctl_cmd.reply,
+				 sz)) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Failed to copy reply to user\n",
+				__func__);
+			rc = -ENODATA;
+			goto out_cleanup;
+		}
+	}
+
+	if (karg->max_sense_bytes &&
+	    (leap_mpi_req->func == LEAPRAID_FUNC_SCSIIO ||
+	     leap_mpi_req->func == LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH)) {
+		if (!karg->sense_data_ptr)
+			goto out_cleanup;
+
+		sz = min_t(u32, karg->max_sense_bytes, SCSI_SENSE_BUFFERSIZE);
+		if (copy_to_user(karg->sense_data_ptr,
+				 &adapter->driver_cmds.ctl_cmd.sense,
+				 sz)) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Failed to copy sense data to user\n",
+				__func__);
+			rc = -ENODATA;
+			goto out_cleanup;
+		}
+	}
+reset:
+	if (issue_reset) {
+		rc = -ENODATA;
+		if (leap_mpi_req->func == LEAPRAID_FUNC_SCSIIO ||
+		    leap_mpi_req->func ==
+		    LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH ||
+		    leap_mpi_req->func ==
+		    LEAPRAID_FUNC_SCSIIO_SATA_PASSTHROUGH) {
+			dev_err(&adapter->pdev->dev,
+				"Fire tgt reset, hdl=0x%04x\n",
+				le16_to_cpu(leap_mpi_req->func_dep1));
+			leapraid_issue_locked_tm(
+				adapter,
+				le16_to_cpu(leap_mpi_req->func_dep1), 0, 0, 0,
+				LEAPRAID_TM_TASKTYPE_TARGET_RESET, taskid,
+				LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+		} else {
+			dev_info(&adapter->pdev->dev,
+				 "%s:%d: call hard_reset\n",
+				 __func__, __LINE__);
+			leapraid_hard_reset_handler(adapter, FULL_RESET);
+		}
+	}
+out_cleanup:
+	if (c2h)
+		dma_free_coherent(&adapter->pdev->dev, c2h_size,
+				  c2h, c2h_dma_addr);
+	if (h2c)
+		dma_free_coherent(&adapter->pdev->dev, h2c_size,
+				  h2c, h2c_dma_addr);
+	kfree(leap_mpi_req);
+	adapter->driver_cmds.ctl_cmd.status = LEAPRAID_CMD_NOT_USED;
+	return rc;
+}
+
+static int leapraid_ctl_get_adapter_info(struct leapraid_adapter *adapter,
+					 void __user *arg)
+{
+	struct leapraid_ioctl_adapter_info *karg;
+	u8 revision;
+	int rc = 0;
+
+	karg = kzalloc_obj(*karg);
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
+
+	snprintf(karg->driver_ver, sizeof(karg->driver_ver), "%s-%s",
+		 LEAPRAID_DRIVER_NAME, LEAPRAID_DRIVER_VERSION);
+
+	karg->adapter_type = LEAPRAID_IOCTL_VERSION;
+	karg->bios_ver = adapter->adapter_attr.bios_version;
+	if (copy_to_user(arg, karg,
+			 sizeof(struct leapraid_ioctl_adapter_info))) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to copy info to user\n", __func__);
+		rc = -EFAULT;
+		goto free_buf;
+	}
+
+free_buf:
+	kfree(karg);
+	return rc;
+}
+
+static int leapraid_ctl_ioctl_main(struct file *file, unsigned int cmd,
+				   void __user *arg)
+{
+	struct leapraid_ioctl_header ioctl_header;
+	struct leapraid_adapter *adapter;
+	struct leapraid_ioctl_command __user *uarg;
+	struct leapraid_ioctl_command karg;
+	int rc = -ENOIOCTLCMD;
+
+	if (copy_from_user(&ioctl_header, arg,
+			   sizeof(struct leapraid_ioctl_header))) {
+		pr_err("%s:%s: Failed to copy header from user\n",
+		       LEAPRAID_DRIVER_NAME, __func__);
+		return -EFAULT;
+	}
+
+	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id);
+	if (!adapter)
+		return -EFAULT;
+
+	if (atomic_read(&adapter->overheat_desc.thermal_alert)) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed, thermal_alert=%d\n",
+			 __func__,
+			 atomic_read(&adapter->overheat_desc.thermal_alert));
+		return -EFAULT;
+	}
+
+	mutex_lock(&adapter->access_ctrl.pci_access_lock);
+
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_LONG,
+					  __func__);
+	if (rc)
+		goto unlock;
+
+	if (!wait_event_timeout(adapter->access_ctrl.shost_recover_wq,
+				!adapter->access_ctrl.shost_recover_async,
+				LEAPRAID_WAIT_SHOST_RECOVERY * HZ)) {
+		dev_warn(&adapter->pdev->dev,
+			 "Timeout waiting for shost recovery async\n");
+		rc = -EAGAIN;
+		goto unlock;
+	}
+
+	if (adapter->access_ctrl.pcie_recovering ||
+	    adapter->scan_dev_desc.driver_loading ||
+	    adapter->access_ctrl.host_removing) {
+		rc = -EAGAIN;
+		goto unlock;
+	}
+
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&adapter->driver_cmds.ctl_cmd.mutex)) {
+			rc = -EAGAIN;
+			goto unlock;
+		}
+	} else if (mutex_lock_interruptible(&adapter->driver_cmds
+					    .ctl_cmd.mutex)) {
+		rc = -ERESTARTSYS;
+		goto unlock;
+	}
+
+	switch (_IOC_NR(cmd)) {
+	case LEAPRAID_ADAPTER_INFO:
+		if (_IOC_SIZE(cmd) ==
+		    sizeof(struct leapraid_ioctl_adapter_info))
+			rc = leapraid_ctl_get_adapter_info(adapter, arg);
+		break;
+	case LEAPRAID_COMMAND:
+		if (copy_from_user(&karg, arg, sizeof(karg))) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Failed to copy data from user\n",
+				__func__);
+			rc = -EFAULT;
+			break;
+		}
+
+		if (karg.hdr.adapter_id != ioctl_header.adapter_id) {
+			rc = -EINVAL;
+			break;
+		}
+
+		if (_IOC_SIZE(cmd) == sizeof(struct leapraid_ioctl_command)) {
+			uarg = arg;
+			rc = leapraid_ctl_do_command(adapter, &karg,
+						     &uarg->mf);
+			if (rc)
+				dev_warn(&adapter->pdev->dev,
+					 "%s: IOCTL cmd failed rc=%d\n",
+					 __func__, rc);
+		}
+		break;
+	case LEAPRAID_EVENTQUERY:
+	case LEAPRAID_EVENTREPORT:
+		rc = 0;
+		break;
+	default:
+		dev_err(&adapter->pdev->dev,
+			"Unknown IOCTL opcode=0x%08x\n", cmd);
+		break;
+	}
+	mutex_unlock(&adapter->driver_cmds.ctl_cmd.mutex);
+
+unlock:
+	mutex_unlock(&adapter->access_ctrl.pci_access_lock);
+	return rc;
+}
+
+static long leapraid_ctl_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	return leapraid_ctl_ioctl_main(file, cmd, (void __user *)arg);
+}
+
+static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct leapraid_adapter *adapter;
+	/* Userspace passes the adapter ID via vma->vm_pgoff. */
+	u32 adapter_id = vma->vm_pgoff;
+	unsigned long length;
+	int rc;
+
+	length = vma->vm_end - vma->vm_start;
+
+	adapter = leapraid_ctl_lookup_adapter(adapter_id);
+	if (!adapter) {
+		pr_err("%s: No adapter found!\n", __func__);
+		return -EINVAL;
+	}
+
+	if (length > (LEAPRAID_SYS_LOG_BUF_SIZE +
+		      LEAPRAID_SYS_LOG_BUF_RESERVE)) {
+		dev_err(&adapter->pdev->dev,
+			"Requested mapping size is too large!\n");
+		return -EINVAL;
+	}
+
+	if (!adapter->fw_log_desc.fw_log_buffer) {
+		dev_err(&adapter->pdev->dev, "No log buffer!\n");
+		return -EINVAL;
+	}
+
+	vma->vm_pgoff = 0;
+
+	rc = dma_mmap_coherent(&adapter->pdev->dev, vma,
+			       adapter->fw_log_desc.fw_log_buffer,
+			       adapter->fw_log_desc.fw_log_buffer_dma,
+			       length);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to map memory to user space!\n");
+		return rc;
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
+int leapraid_ctl_init(void)
+{
+	if (misc_register(&leapraid_ctl_dev) < 0) {
+		pr_err("%s Can't register misc device\n",
+		       LEAPRAID_DRIVER_NAME);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+void leapraid_ctl_exit(void)
+{
+	misc_deregister(&leapraid_ctl_dev);
+}
diff --git a/drivers/scsi/leapraid/leapraid_func.c b/drivers/scsi/leapraid/leapraid_func.c
new file mode 100644
index 000000000000..d4df48fee87a
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_func.c
@@ -0,0 +1,8980 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
+#include <linux/module.h>
+
+#include "leapraid_func.h"
+
+static int msix_disable;
+module_param(msix_disable, int, 0444);
+MODULE_PARM_DESC(msix_disable,
+		 "disable msix routed interrupts (default=0)");
+
+static int smart_poll;
+module_param(smart_poll, int, 0444);
+MODULE_PARM_DESC(smart_poll,
+		 "check SATA drive health via SMART polling: (default=0)");
+
+static int interrupt_mode;
+module_param(interrupt_mode, int, 0444);
+MODULE_PARM_DESC(interrupt_mode,
+		 "intr mode: 0 is MSI-X, 1 is MSI, 2 is legacy. (default=0)");
+
+static int poll_queues;
+module_param(poll_queues, int, 0444);
+MODULE_PARM_DESC(poll_queues,
+		 "specifies the number of queues for io_uring poll mode.");
+
+static int max_msix_vectors = LEAPRAID_INVALID_MSIX_VECTORS;
+module_param(max_msix_vectors, int, 0444);
+MODULE_PARM_DESC(max_msix_vectors, "max msix vectors");
+
+static void leapraid_remove_device(struct leapraid_adapter *adapter,
+				   struct leapraid_sas_dev *sas_dev);
+static void leapraid_set_led(struct leapraid_adapter *adapter,
+			     struct leapraid_sas_dev *sas_dev, bool on);
+static void leapraid_ublk_io_dev(struct leapraid_adapter *adapter,
+				 u64 sas_address,
+				 struct leapraid_card_port *port);
+static void leapraid_clear_cached_boot_dev(struct leapraid_adapter *adapter,
+					   void *dev, u32 chnl);
+static int leapraid_make_adapter_available(struct leapraid_adapter *adapter);
+static int leapraid_fw_log_init(struct leapraid_adapter *adapter);
+static bool leapraid_should_skip_poll_work(struct leapraid_adapter *adapter);
+static int leapraid_make_adapter_ready(struct leapraid_adapter *adapter,
+				       enum reset_type type);
+
+static noinline bool leapraid_shost_in_recovery(struct Scsi_Host *shost)
+{
+	enum scsi_host_state state;
+
+	state = READ_ONCE(shost->shost_state);
+	return state == SHOST_RECOVERY ||
+	       state == SHOST_CANCEL_RECOVERY ||
+	       state == SHOST_DEL_RECOVERY ||
+	       shost->tmf_in_progress;
+}
+
+static void leapraid_debug_log_info(struct leapraid_adapter *adapter)
+{
+	struct leapraid_reg_base __iomem *iomem_base = adapter->iomem_base;
+	u32 debug_log[LEAPRAID_DEBUGLOG_SZ_MAX];
+	bool changed = false;
+	int i;
+
+	if (leapraid_should_skip_poll_work(adapter))
+		return;
+
+	for (i = 0; i < LEAPRAID_DEBUGLOG_SZ_MAX; i++) {
+		debug_log[i] = leapraid_readl(&iomem_base->debug_log[i]);
+		if (debug_log[i] != adapter->fw_log_desc.pre_debug_log[i])
+			changed = true;
+	}
+
+	if (!changed)
+		return;
+
+	memcpy(adapter->fw_log_desc.pre_debug_log,
+	       debug_log,
+	       sizeof(debug_log));
+
+	for (i = 0; i < LEAPRAID_DEBUGLOG_SZ_MAX;
+	     i += LEAPRAID_DEBUGLOG_DWORDS_PER_LINE)
+		dev_warn(&adapter->pdev->dev,
+			 "debug_log[%d-%d]: 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			 i,
+			 i + LEAPRAID_DEBUGLOG_DWORDS_PER_LINE - 1,
+			 debug_log[i],
+			 debug_log[i + 1],
+			 debug_log[i + 2],
+			 debug_log[i + 3]);
+}
+
+static inline bool leapraid_is_end_dev(u32 dev_type)
+{
+	return (dev_type & LEAPRAID_DEVTYP_END_DEV) &&
+		((dev_type & LEAPRAID_DEVTYP_SSP_TGT) ||
+		 (dev_type & LEAPRAID_DEVTYP_STP_TGT) ||
+		 (dev_type & LEAPRAID_DEVTYP_SATA_DEV));
+}
+
+bool leapraid_pci_removed(struct leapraid_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	u32 vendor_id;
+
+	if (pci_bus_read_config_dword(pdev->bus,
+				      pdev->devfn,
+				      PCI_VENDOR_ID,
+				      &vendor_id))
+		return true;
+
+	return (vendor_id & LEAPRAID_PCI_VENDOR_ID_MASK) !=
+		LEAPRAID_VENDOR_ID;
+}
+
+static bool leapraid_pci_active(struct leapraid_adapter *adapter)
+{
+	return !(adapter->access_ctrl.pcie_recovering ||
+		leapraid_pci_removed(adapter));
+}
+
+void *leapraid_get_reply_vaddr(struct leapraid_adapter *adapter, u32 rep_paddr)
+{
+	if (!rep_paddr)
+		return NULL;
+
+	return adapter->mem_desc.rep_msg +
+		(rep_paddr - (u32)adapter->mem_desc.rep_msg_dma);
+}
+
+void *leapraid_get_task_desc(struct leapraid_adapter *adapter, u16 taskid)
+{
+	return adapter->mem_desc.task_desc +
+			taskid * LEAPRAID_REQUEST_SIZE;
+}
+
+void *leapraid_get_sense_buffer(struct leapraid_adapter *adapter, u16 taskid)
+{
+	return adapter->mem_desc.sense_data +
+			(taskid - 1) * SCSI_SENSE_BUFFERSIZE;
+}
+
+__le32 leapraid_get_sense_buffer_dma(struct leapraid_adapter *adapter,
+				     u16 taskid)
+{
+	return cpu_to_le32(adapter->mem_desc.sense_data_dma +
+			   ((taskid - 1) * SCSI_SENSE_BUFFERSIZE));
+}
+
+void leapraid_mask_int(struct leapraid_adapter *adapter)
+{
+	u32 reg;
+
+	adapter->mask_int = 1;
+	reg = leapraid_readl(&adapter->iomem_base->host_int_mask);
+	reg |= LEAPRAID_TO_SYS_DB_MASK + LEAPRAID_REPLY_INT_MASK +
+		LEAPRAID_RESET_IRQ_MASK;
+	writel(reg, &adapter->iomem_base->host_int_mask);
+	leapraid_readl(&adapter->iomem_base->host_int_mask);
+}
+
+void leapraid_unmask_int(struct leapraid_adapter *adapter)
+{
+	u32 reg;
+
+	reg = leapraid_readl(&adapter->iomem_base->host_int_mask);
+	reg &= ~LEAPRAID_REPLY_INT_MASK;
+	writel(reg, &adapter->iomem_base->host_int_mask);
+	adapter->mask_int = 0;
+}
+
+static void leapraid_overheat_suspend(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	struct Scsi_Host *shost;
+	struct pci_dev *pdev;
+
+	if (!adapter)
+		return;
+
+	pdev = adapter->pdev;
+	shost = pci_get_drvdata(pdev);
+	if (!shost) {
+		dev_warn(&pdev->dev,
+			 "Overheat suspend failed, invalid host or adapter\n");
+		return;
+	}
+
+	wq = adapter->overheat_desc.fault_overheat_wq;
+	if (!wq)
+		return;
+
+	if (atomic_cmpxchg(&adapter->overheat_desc.thermal_alert, 0, 1))
+		return;
+
+	queue_work(wq, &adapter->overheat_desc.fault_overheat_work);
+}
+
+static void leapraid_stop_adapter_on_fault(struct leapraid_adapter *adapter,
+					   u32 db)
+{
+	u32 adapter_state = db & LEAPRAID_DB_MASK;
+	bool fault_1 = false;
+	bool fault_2 = false;
+
+	fault_1 = adapter_state == LEAPRAID_DB_MASK;
+	fault_2 = adapter_state == LEAPRAID_DB_FAULT &&
+		  (db & LEAPRAID_DB_DATA_MASK) == LEAPRAID_DB_OVER_TEMPERATURE;
+
+	if (!fault_1 && !fault_2)
+		return;
+
+	if (fault_1)
+		dev_err(&adapter->pdev->dev,
+			"%s: Doorbell status 0xFFFF!\n", __func__);
+	else
+		dev_err(&adapter->pdev->dev,
+			"%s: Adapter overheating detected!\n", __func__);
+
+	leapraid_overheat_suspend(adapter);
+}
+
+u32 leapraid_get_adapter_state(struct leapraid_adapter *adapter)
+{
+	u32 db;
+	u32 adapter_state;
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	adapter_state = db & LEAPRAID_DB_MASK;
+	leapraid_stop_adapter_on_fault(adapter, db);
+	return adapter_state;
+}
+
+static bool leapraid_wait_adapter_ready(struct leapraid_adapter *adapter)
+{
+	u32 cur_state;
+	u32 cnt;
+
+	for (cnt = LEAPRAID_ADAPTER_READY_MAX_RETRY; cnt > 0; cnt--) {
+		cur_state = leapraid_get_adapter_state(adapter);
+
+		if (cur_state == LEAPRAID_DB_READY)
+			return true;
+		if (cur_state == LEAPRAID_DB_FAULT)
+			break;
+		usleep_range(LEAPRAID_ADAPTER_READY_SLEEP_MIN_US,
+			     LEAPRAID_ADAPTER_READY_SLEEP_MAX_US);
+	}
+
+	return false;
+}
+
+static int leapraid_db_wait_int_host(struct leapraid_adapter *adapter)
+{
+	u32 cnt;
+
+	for (cnt = LEAPRAID_DB_WAIT_MAX_RETRY; cnt > 0; cnt--) {
+		if (leapraid_readl(&adapter->iomem_base->host_int_status) &
+		    LEAPRAID_ADAPTER2HOST_DB_STATUS)
+			return 0;
+
+		udelay(LEAPRAID_DB_WAIT_DELAY_US);
+	}
+
+	return -EFAULT;
+}
+
+static int leapraid_db_wait_ack_and_clear_int(struct leapraid_adapter *adapter)
+{
+	u32 adapter_state;
+	u32 int_status;
+	u32 cnt;
+
+	for (cnt = LEAPRAID_ADAPTER_READY_MAX_RETRY; cnt > 0; cnt--) {
+		int_status =
+			leapraid_readl(&adapter->iomem_base->host_int_status);
+
+		if (int_status == 0xFFFFFFFF)
+			return -EFAULT;
+
+		if (!(int_status & LEAPRAID_HOST2ADAPTER_DB_STATUS))
+			return 0;
+
+		if (int_status & LEAPRAID_ADAPTER2HOST_DB_STATUS) {
+			adapter_state = leapraid_get_adapter_state(adapter);
+			if (adapter_state == LEAPRAID_DB_FAULT)
+				return -EFAULT;
+		}
+
+		usleep_range(LEAPRAID_ADAPTER_READY_SLEEP_MIN_US,
+			     LEAPRAID_ADAPTER_READY_SLEEP_MAX_US);
+	}
+
+	return -EFAULT;
+}
+
+static int leapraid_handshake_func(struct leapraid_adapter *adapter,
+				   int req_bytes, u32 *req,
+				   int rep_bytes, u16 *rep)
+{
+	int failed, i;
+
+	if (leapraid_readl(&adapter->iomem_base->db) & LEAPRAID_DB_USED) {
+		dev_err(&adapter->pdev->dev, "doorbell used\n");
+		return -EFAULT;
+	}
+
+	if (leapraid_readl(&adapter->iomem_base->host_int_status) &
+	    LEAPRAID_ADAPTER2HOST_DB_STATUS)
+		writel(0, &adapter->iomem_base->host_int_status);
+
+	writel(((LEAPRAID_FUNC_HANDSHAKE << LEAPRAID_DB_FUNC_SHIFT) |
+		((req_bytes / LEAPRAID_DWORDS_BYTE_SIZE) <<
+		LEAPRAID_DB_ADD_DWORDS_SHIFT)),
+	       &adapter->iomem_base->db);
+
+	if (leapraid_db_wait_int_host(adapter)) {
+		dev_err(&adapter->pdev->dev, "%d: Wait db interrupt timeout\n",
+			__LINE__);
+		return -EFAULT;
+	}
+
+	writel(0, &adapter->iomem_base->host_int_status);
+
+	if (leapraid_db_wait_ack_and_clear_int(adapter)) {
+		dev_err(&adapter->pdev->dev, "%d: Wait ack failure\n",
+			__LINE__);
+		return -EFAULT;
+	}
+
+	for (i = 0, failed = 0;
+	     i < req_bytes / LEAPRAID_DWORDS_BYTE_SIZE && !failed;
+	     i++) {
+		writel((u32)req[i], &adapter->iomem_base->db);
+		if (leapraid_db_wait_ack_and_clear_int(adapter))
+			failed = 1;
+	}
+	if (failed) {
+		dev_err(&adapter->pdev->dev, "%d: Wait ack failure\n",
+			__LINE__);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < rep_bytes / LEAPRAID_WORD_BYTE_SIZE; i++) {
+		if (leapraid_db_wait_int_host(adapter)) {
+			dev_err(&adapter->pdev->dev,
+				"%d: Wait db interrupt timeout\n", __LINE__);
+			return -EFAULT;
+		}
+		rep[i] = (u16)(leapraid_readl(&adapter->iomem_base->db)
+			       & LEAPRAID_DB_DATA_MASK);
+		writel(0, &adapter->iomem_base->host_int_status);
+	}
+
+	if (leapraid_db_wait_int_host(adapter)) {
+		dev_err(&adapter->pdev->dev, "%d: Wait db interrupt timeout\n",
+			__LINE__);
+		return -EFAULT;
+	}
+
+	writel(0, &adapter->iomem_base->host_int_status);
+
+	return 0;
+}
+
+int leapraid_check_adapter_is_op(struct leapraid_adapter *adapter, int wait,
+				 const char *caller)
+{
+	int wait_count;
+
+	for (wait_count = wait; wait_count > 0; wait_count--) {
+		if (leapraid_pci_removed(adapter)) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: PCI device removed\n", __func__);
+			return -EFAULT;
+		}
+
+		if (leapraid_get_adapter_state(adapter) ==
+		    LEAPRAID_DB_OPERATIONAL)
+			return 0;
+
+		dev_dbg(&adapter->pdev->dev,
+			"%s: Wait for adapter to become op status(cnt=%d)\n",
+			caller, wait - wait_count);
+
+		ssleep(1);
+	}
+
+	dev_err(&adapter->pdev->dev,
+		"%s: Adapter failed to become op state, last state=%d\n",
+		caller, leapraid_get_adapter_state(adapter));
+
+	return -EFAULT;
+}
+
+struct leapraid_io_req_tracker *leapraid_get_io_tracker_from_taskid(
+		struct leapraid_adapter *adapter, u16 taskid)
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
+		return scsi_cmd_priv(scmd);
+
+	return NULL;
+}
+
+static u8 leapraid_get_cb_idx(struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_driver_cmd *sp_cmd;
+	u8 cb_idx = 0xFF;
+
+	if (WARN_ON(!taskid))
+		return cb_idx;
+
+	list_for_each_entry(sp_cmd, &adapter->driver_cmds.special_cmd_list,
+			    list)
+		if (taskid == sp_cmd->taskid ||
+		    taskid == sp_cmd->hp_taskid ||
+		    taskid == sp_cmd->inter_taskid)
+			return sp_cmd->cb_idx;
+
+	WARN_ON(cb_idx == 0xFF);
+	return cb_idx;
+}
+
+struct scsi_cmnd *leapraid_get_scmd_from_taskid(
+					struct leapraid_adapter *adapter,
+					u16 taskid)
+{
+	struct leapraid_scsiio_req *leap_mpi_req;
+	struct leapraid_io_req_tracker *st;
+	struct scsi_cmnd *scmd;
+	u32 uniq_tag;
+
+	if (taskid <= 0 || taskid > adapter->shost->can_queue)
+		return NULL;
+
+	uniq_tag = adapter->mem_desc.taskid_to_uniq_tag[taskid - 1] <<
+		 BLK_MQ_UNIQUE_TAG_BITS | (taskid - 1);
+	leap_mpi_req = leapraid_get_task_desc(adapter, taskid);
+	if (!leap_mpi_req->dev_hdl)
+		return NULL;
+
+	scmd = scsi_host_find_tag(adapter->shost, uniq_tag);
+	if (scmd) {
+		st = scsi_cmd_priv(scmd);
+		if (st && st->taskid == taskid)
+			return scmd;
+	}
+
+	return NULL;
+}
+
+u16 leapraid_alloc_scsiio_taskid(struct leapraid_adapter *adapter,
+				 struct scsi_cmnd *scmd)
+{
+	struct leapraid_io_req_tracker *request;
+	u16 taskid;
+	u32 tag = scsi_cmd_to_rq(scmd)->tag;
+	u32 unique_tag;
+
+	unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	tag = blk_mq_unique_tag_to_tag(unique_tag);
+	adapter->mem_desc.taskid_to_uniq_tag[tag] =
+		blk_mq_unique_tag_to_hwq(unique_tag);
+
+	request = scsi_cmd_priv(scmd);
+	taskid = tag + 1;
+	request->taskid = taskid;
+	request->scmd = scmd;
+	return taskid;
+}
+
+static void leapraid_check_pending_io(struct leapraid_adapter *adapter)
+{
+	if (adapter->access_ctrl.shost_recovering &&
+	    adapter->reset_desc.pending_io_cnt) {
+		if (adapter->reset_desc.pending_io_cnt == 1)
+			wake_up(&adapter->reset_desc.reset_wait_queue);
+		adapter->reset_desc.pending_io_cnt--;
+	}
+}
+
+static void leapraid_clear_io_tracker(
+		struct leapraid_adapter *adapter,
+		struct leapraid_io_req_tracker *io_tracker)
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
+static bool leapraid_is_fixed_taskid(struct leapraid_adapter *adapter,
+				     u16 taskid)
+{
+	struct leapraid_driver_cmds *driver_cmds = &adapter->driver_cmds;
+
+	return (taskid == driver_cmds->ctl_cmd.taskid ||
+		taskid == driver_cmds->driver_scsiio_cmd.taskid ||
+		taskid == driver_cmds->tm_cmd.hp_taskid ||
+		taskid == driver_cmds->ctl_cmd.hp_taskid ||
+		taskid == driver_cmds->scan_dev_cmd.inter_taskid ||
+		taskid == driver_cmds->timestamp_sync_cmd.inter_taskid ||
+		taskid == driver_cmds->transport_cmd.inter_taskid ||
+		taskid == driver_cmds->cfg_op_cmd.inter_taskid ||
+		taskid == driver_cmds->enc_cmd.inter_taskid ||
+		taskid == driver_cmds->notify_event_cmd.inter_taskid);
+}
+
+void leapraid_free_taskid(struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_io_req_tracker *io_tracker;
+	void *task_desc;
+
+	if (leapraid_is_fixed_taskid(adapter, taskid))
+		return;
+
+	if (taskid <= adapter->shost->can_queue) {
+		io_tracker = leapraid_get_io_tracker_from_taskid(adapter,
+								 taskid);
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
+static u8 leapraid_get_msix_idx(struct leapraid_adapter *adapter,
+				struct scsi_cmnd *scmd)
+{
+	if (scmd && adapter->shost->nr_hw_queues > 1) {
+		u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+
+		return blk_mq_unique_tag_to_hwq(tag);
+	}
+	return adapter->notification_desc.msix_cpu_map[raw_smp_processor_id()];
+}
+
+static u8 leapraid_get_and_set_msix_idx_from_taskid(
+		struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_io_req_tracker *io_tracker = NULL;
+
+	if (taskid <= adapter->shost->can_queue)
+		io_tracker = leapraid_get_io_tracker_from_taskid(adapter,
+								 taskid);
+
+	if (!io_tracker)
+		return leapraid_get_msix_idx(adapter, NULL);
+
+	io_tracker->msix_io = leapraid_get_msix_idx(adapter, io_tracker->scmd);
+
+	return io_tracker->msix_io;
+}
+
+void leapraid_fire_scsi_io(struct leapraid_adapter *adapter, u16 taskid,
+			   u16 handle)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_SCSI_IO;
+	desc.msix_idx = leapraid_get_and_set_msix_idx_from_taskid(adapter,
+								  taskid);
+	desc.taskid = cpu_to_le16(taskid);
+	writel((__force u32)cpu_to_le32(*((u32 *)&desc)),
+	       &adapter->iomem_base->atomic_req_desc_post);
+}
+
+void leapraid_fire_hpr_task(struct leapraid_adapter *adapter, u16 taskid,
+			    u16 msix_task)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_HPR;
+	desc.msix_idx = msix_task;
+	desc.taskid = cpu_to_le16(taskid);
+	writel((__force u32)cpu_to_le32(*((u32 *)&desc)),
+	       &adapter->iomem_base->atomic_req_desc_post);
+}
+
+void leapraid_fire_task(struct leapraid_adapter *adapter, u16 taskid)
+{
+	struct leapraid_atomic_req_desc desc;
+
+	desc.flg = LEAPRAID_REQ_DESC_FLG_DFLT_TYPE;
+	desc.msix_idx = leapraid_get_and_set_msix_idx_from_taskid(adapter,
+								  taskid);
+	desc.taskid = cpu_to_le16(taskid);
+	writel((__force u32)cpu_to_le32(*((u32 *)&desc)),
+	       &adapter->iomem_base->atomic_req_desc_post);
+}
+
+void leapraid_clean_active_scsi_cmds(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_req_tracker *io_tracker;
+	struct scsi_cmnd *scmd;
+	void *task_desc;
+	u16 taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		io_tracker = scsi_cmd_priv(scmd);
+		if (io_tracker && io_tracker->taskid == 0)
+			continue;
+
+		scsi_dma_unmap(scmd);
+		task_desc = leapraid_get_task_desc(adapter, taskid);
+		memset(task_desc, 0, LEAPRAID_REQUEST_SIZE);
+		leapraid_clear_io_tracker(adapter, io_tracker);
+		if (!leapraid_pci_active(adapter) ||
+		    adapter->reset_desc.adapter_reset_results != 0 ||
+		    atomic_read(&adapter->overheat_desc.thermal_alert) ||
+		    adapter->access_ctrl.host_removing)
+			scmd->result = DID_NO_CONNECT << 16;
+		else
+			scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+		scsi_done(scmd);
+	}
+}
+
+static void leapraid_clean_active_driver_cmd(struct leapraid_driver_cmd *cmd)
+{
+	if (cmd->status & LEAPRAID_CMD_PENDING) {
+		cmd->status |= LEAPRAID_CMD_RESET;
+		complete(&cmd->done);
+	}
+}
+
+static void leapraid_clean_active_driver_cmds(struct leapraid_adapter *adapter)
+{
+	struct leapraid_driver_cmds *driver_cmds;
+
+	driver_cmds = &adapter->driver_cmds;
+	leapraid_clean_active_driver_cmd(&driver_cmds->timestamp_sync_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->driver_scsiio_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->tm_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->transport_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->enc_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->notify_event_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->cfg_op_cmd);
+	leapraid_clean_active_driver_cmd(&driver_cmds->ctl_cmd);
+
+	if (driver_cmds->scan_dev_cmd.status & LEAPRAID_CMD_PENDING) {
+		adapter->scan_dev_desc.scan_dev_failed = 1;
+		driver_cmds->scan_dev_cmd.status |= LEAPRAID_CMD_RESET;
+		if (adapter->scan_dev_desc.driver_loading) {
+			adapter->scan_dev_desc.scan_start_failed =
+				LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR;
+			adapter->scan_dev_desc.scan_start = 0;
+		} else {
+			complete(&driver_cmds->scan_dev_cmd.done);
+		}
+	}
+}
+
+static void leapraid_clean_active_cmds(struct leapraid_adapter *adapter)
+{
+	leapraid_clean_active_driver_cmds(adapter);
+	leapraid_clean_active_fw_evt(adapter);
+	leapraid_clean_active_scsi_cmds(adapter);
+}
+
+static void leapraid_tgt_not_responding(struct leapraid_adapter *adapter,
+					u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags = 0;
+	u32 adapter_state;
+
+	if (adapter->access_ctrl.pcie_recovering)
+		return;
+
+	adapter_state = leapraid_get_adapter_state(adapter);
+	if (adapter_state != LEAPRAID_DB_OPERATIONAL)
+		return;
+
+	if (!hdl || hdl > adapter->adapter_attr.features.max_dev_handle ||
+	    test_bit(hdl, adapter->dev_topo.pd_hdls))
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev && sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = 1;
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
+static void leapraid_tgt_rst_send(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_card_port *port;
+	u64 sas_address;
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
+	if (!hdl || hdl > adapter->adapter_attr.features.max_dev_handle ||
+	    test_bit(hdl, adapter->dev_topo.pd_hdls))
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev && sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = 1;
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
+static inline void leapraid_single_mpi_sg_append(
+				struct leapraid_adapter *adapter,
+				void *sge,
+				u32 flag_and_len,
+				dma_addr_t dma_addr)
+{
+	if (adapter->adapter_attr.use_32_dma_mask) {
+		struct leapraid_sge_simple32 *sge32 = sge;
+
+		sge32->flg_and_len =
+			cpu_to_le32(flag_and_len |
+				    (LEAPRAID_SGE_FLG_32 |
+				     LEAPRAID_SGE_FLG_SYSTEM_ADDR) <<
+				    LEAPRAID_SGE_FLG_SHIFT);
+		sge32->addr = cpu_to_le32(dma_addr);
+	} else {
+		struct leapraid_sge_simple64 *sge64 = sge;
+
+		sge64->flg_and_len =
+			cpu_to_le32(flag_and_len |
+				    (LEAPRAID_SGE_FLG_64 |
+				     LEAPRAID_SGE_FLG_SYSTEM_ADDR) <<
+				    LEAPRAID_SGE_FLG_SHIFT);
+		sge64->addr = cpu_to_le64(dma_addr);
+	}
+}
+
+static inline void leapraid_single_ieee_sg_append(void *sge, u8 flag,
+						  u8 next_chain_offset,
+						  u32 len,
+						  dma_addr_t dma_addr)
+{
+	struct leapraid_chain64_ieee_sg *ieee_sg = sge;
+
+	ieee_sg->flg = flag;
+	ieee_sg->next_chain_offset = next_chain_offset;
+	ieee_sg->len = cpu_to_le32(len);
+	ieee_sg->addr = cpu_to_le64(dma_addr);
+}
+
+static void leapraid_build_nodata_mpi_sg(struct leapraid_adapter *adapter,
+					 void *sge)
+{
+	leapraid_single_mpi_sg_append(adapter,
+				      sge,
+				      (LEAPRAID_SGE_FLG_LAST_ONE |
+					LEAPRAID_SGE_FLG_EOB |
+					LEAPRAID_SGE_FLG_EOL |
+					LEAPRAID_SGE_FLG_SIMPLE_ONE) <<
+					LEAPRAID_SGE_FLG_SHIFT,
+					LEAPRAID_SGE_NO_DATA_ADDR);
+}
+
+void leapraid_build_mpi_sg(struct leapraid_adapter *adapter, void *sge,
+			   dma_addr_t h2c_dma_addr, size_t h2c_size,
+			   dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	if (h2c_size && !c2h_size) {
+		leapraid_single_mpi_sg_append(adapter,
+					      sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_LAST_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_EOL |
+						LEAPRAID_SGE_FLG_H2C) <<
+					       LEAPRAID_SGE_FLG_SHIFT) |
+					       h2c_size,
+					      h2c_dma_addr);
+	} else if (!h2c_size && c2h_size) {
+		leapraid_single_mpi_sg_append(adapter,
+					      sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_LAST_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_EOL) <<
+						LEAPRAID_SGE_FLG_SHIFT) |
+						c2h_size,
+					      c2h_dma_addr);
+	} else if (h2c_size && c2h_size) {
+		leapraid_single_mpi_sg_append(adapter,
+					      sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_H2C) <<
+					       LEAPRAID_SGE_FLG_SHIFT) |
+					      h2c_size,
+					      h2c_dma_addr);
+		if (adapter->adapter_attr.use_32_dma_mask)
+			sge += sizeof(struct leapraid_sge_simple32);
+		else
+			sge += sizeof(struct leapraid_sge_simple64);
+		leapraid_single_mpi_sg_append(adapter,
+					      sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_LAST_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_EOL) <<
+						LEAPRAID_SGE_FLG_SHIFT) |
+						c2h_size,
+					      c2h_dma_addr);
+	} else {
+		leapraid_build_nodata_mpi_sg(adapter, sge);
+	}
+}
+
+void leapraid_build_ieee_nodata_sg(struct leapraid_adapter *adapter, void *sge)
+{
+	leapraid_single_ieee_sg_append(sge,
+				       (LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE |
+					LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR |
+					LEAPRAID_IEEE_SGE_FLG_EOL),
+					0,
+					0,
+					LEAPRAID_SGE_NO_DATA_ADDR);
+}
+
+int leapraid_build_scmd_ieee_sg(struct leapraid_adapter *adapter,
+				struct scsi_cmnd *scmd, u16 taskid)
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
+	io_tracker = scsi_cmd_priv(scmd);
+	scsiio_req = leapraid_get_task_desc(adapter, taskid);
+	scmd_sg_cur = scsi_sglist(scmd);
+	sg_entries_left = scsi_dma_map(scmd);
+	if (sg_entries_left < 0)
+		return -ENOMEM;
+	sg_entry_cur = &scsiio_req->sgl;
+	if (sg_entries_left <= LEAPRAID_SGL_INLINE_THRESHOLD)
+		goto fill_last_seg;
+
+	scsiio_req->chain_offset = LEAPRAID_CHAIN_OFFSET_DWORDS;
+	leapraid_single_ieee_sg_append(sg_entry_cur,
+				       LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE |
+				       LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+				       0, sg_dma_len(scmd_sg_cur),
+				       sg_dma_address(scmd_sg_cur));
+	scmd_sg_cur = sg_next(scmd_sg_cur);
+	sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+	sg_entries_left--;
+
+	host_chain_cursor = 0;
+	host_chain = io_tracker->chain +
+		host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+	host_chain_dma = io_tracker->chain_dma +
+		host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+	host_chain_cursor += 1;
+	for (;;) {
+		sg_entries_in_cur_seg =
+			(sg_entries_left <= LEAPRAID_MAX_SGES_IN_CHAIN) ?
+				sg_entries_left : LEAPRAID_MAX_SGES_IN_CHAIN;
+		chain_offset_in_cur_seg =
+			(sg_entries_left == (int)sg_entries_in_cur_seg) ?
+				0 : sg_entries_in_cur_seg;
+		chain_len_in_cur_seg = sg_entries_in_cur_seg *
+			LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+		if (chain_offset_in_cur_seg)
+			chain_len_in_cur_seg += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+
+		leapraid_single_ieee_sg_append(
+			sg_entry_cur,
+			LEAPRAID_IEEE_SGE_FLG_CHAIN_ONE |
+			LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+			chain_offset_in_cur_seg, chain_len_in_cur_seg,
+			host_chain_dma);
+		sg_entry_cur = host_chain;
+		if (!chain_offset_in_cur_seg)
+			goto fill_last_seg;
+
+		while (sg_entries_in_cur_seg) {
+			leapraid_single_ieee_sg_append(
+				sg_entry_cur,
+				LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE |
+				LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR,
+				0, sg_dma_len(scmd_sg_cur),
+				sg_dma_address(scmd_sg_cur));
+			scmd_sg_cur = sg_next(scmd_sg_cur);
+			sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+			sg_entries_left--;
+			sg_entries_in_cur_seg--;
+		}
+		host_chain = io_tracker->chain +
+			host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+		host_chain_dma = io_tracker->chain_dma +
+			host_chain_cursor * LEAPRAID_CHAIN_SEG_SIZE;
+		host_chain_cursor += 1;
+	}
+
+fill_last_seg:
+	while (sg_entries_left > 0) {
+		u32 flags = LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE |
+			LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR;
+		if (sg_entries_left == 1)
+			flags |= LEAPRAID_IEEE_SGE_FLG_EOL;
+		leapraid_single_ieee_sg_append(sg_entry_cur, flags,
+					       0, sg_dma_len(scmd_sg_cur),
+					       sg_dma_address(scmd_sg_cur));
+		scmd_sg_cur = sg_next(scmd_sg_cur);
+		sg_entry_cur += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+		sg_entries_left--;
+	}
+	return 0;
+}
+
+void leapraid_build_ieee_sg(struct leapraid_adapter *adapter, void *sge,
+			    dma_addr_t h2c_dma_addr, size_t h2c_size,
+			    dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	u32 base_flag;
+	u32 flag;
+
+	base_flag = LEAPRAID_IEEE_SGE_FLG_SIMPLE_ONE |
+			LEAPRAID_IEEE_SGE_FLG_SYSTEM_ADDR;
+
+	if (h2c_size && !c2h_size) {
+		flag = base_flag | LEAPRAID_IEEE_SGE_FLG_EOL;
+
+		leapraid_single_ieee_sg_append(sge,
+					       flag,
+					       0,
+					       h2c_size,
+					       h2c_dma_addr);
+	} else if (!h2c_size && c2h_size) {
+		flag = base_flag | LEAPRAID_IEEE_SGE_FLG_EOL;
+
+		leapraid_single_ieee_sg_append(sge,
+					       flag,
+					       0,
+					       c2h_size,
+					       c2h_dma_addr);
+	} else if (h2c_size && c2h_size) {
+		leapraid_single_ieee_sg_append(sge,
+					       base_flag,
+					       0,
+					       h2c_size,
+					       h2c_dma_addr);
+		sge += LEAPRAID_IEEE_SGE64_ENTRY_SIZE;
+
+		flag = base_flag | LEAPRAID_IEEE_SGE_FLG_EOL;
+		leapraid_single_ieee_sg_append(sge,
+					       flag,
+					       0,
+					       c2h_size,
+					       c2h_dma_addr);
+	} else {
+		leapraid_build_ieee_nodata_sg(adapter, sge);
+	}
+}
+
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_from_tgt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_starget_priv *tgt_priv)
+{
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	if (tgt_priv->sas_dev)
+		leapraid_sdev_get(tgt_priv->sas_dev);
+
+	return tgt_priv->sas_dev;
+}
+
+struct leapraid_sas_dev *leapraid_get_sas_dev_from_tgt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_starget_priv *tgt_priv)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_from_tgt(adapter, tgt_priv);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+static struct leapraid_card_port *leapraid_get_port_by_id(
+		struct leapraid_adapter *adapter,
+		u8 port_id, bool skip_dirty)
+{
+	struct leapraid_card_port *port;
+	struct leapraid_card_port *dirty_port = NULL;
+
+	if (!adapter->adapter_attr.enable_mp)
+		port_id = LEAPRAID_DISABLE_MP_PORT_ID;
+
+	list_for_each_entry(port, &adapter->dev_topo.card_port_list, list) {
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
+		port = kzalloc_obj(*port, GFP_ATOMIC);
+		if (!port) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Failed to alloc port\n", __func__);
+			return NULL;
+		}
+
+		port->port_id = LEAPRAID_DISABLE_MP_PORT_ID;
+		list_add_tail(&port->list, &adapter->dev_topo.card_port_list);
+		return port;
+	}
+
+	return NULL;
+}
+
+struct leapraid_vphy *leapraid_get_vphy_by_phy(struct leapraid_card_port *port,
+					       u32 phy_seq_num)
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
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+		struct leapraid_adapter *adapter,
+		u64 sas_address,
+		struct sas_rphy *rphy)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list, list)
+		if (sas_dev->sas_addr == sas_address &&
+		    sas_dev->rphy == rphy) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+			    list)
+		if (sas_dev->sas_addr == sas_address &&
+		    sas_dev->rphy == rphy) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_addr(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	if (!port) {
+		dev_warn(&adapter->pdev->dev, "%s: Invalid port\n", __func__);
+		return NULL;
+	}
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list, list)
+		if (sas_dev->sas_addr == sas_address &&
+		    sas_dev->card_port == port) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+			    list)
+		if (sas_dev->sas_addr == sas_address &&
+		    sas_dev->card_port == port) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *leapraid_get_sas_dev_by_addr(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	if (!port) {
+		dev_warn(&adapter->pdev->dev, "%s: Invalid port\n", __func__);
+		return NULL;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(adapter, sas_address,
+							 port);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_hdl(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	assert_spin_locked(&adapter->dev_topo.sas_dev_lock);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list, list)
+		if (sas_dev->hdl == hdl) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_init_list,
+			    list)
+		if (sas_dev->hdl == hdl) {
+			leapraid_sdev_get(sas_dev);
+			return sas_dev;
+		}
+
+	return NULL;
+}
+
+struct leapraid_sas_dev *leapraid_get_sas_dev_by_hdl(
+		struct leapraid_adapter *adapter, u16 hdl)
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
+void leapraid_sas_dev_remove(struct leapraid_adapter *adapter,
+			     struct leapraid_sas_dev *sas_dev)
+{
+	unsigned long flags;
+	bool del_from_list;
+
+	if (!sas_dev) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid SAS device\n", __func__);
+		return;
+	}
+
+	del_from_list = false;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	if (!list_empty(&sas_dev->list)) {
+		list_del_init(&sas_dev->list);
+		del_from_list = true;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list) {
+		leapraid_clear_cached_boot_dev(adapter, sas_dev, 0);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+static void leapraid_sas_dev_remove_by_hdl(struct leapraid_adapter *adapter,
+					   u16 hdl)
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
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev && (!list_empty(&sas_dev->list))) {
+		list_del_init(&sas_dev->list);
+		del_from_list = true;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list) {
+		leapraid_remove_device(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+void leapraid_sas_dev_remove_by_sas_address(struct leapraid_adapter *adapter,
+					    u64 sas_address,
+					    struct leapraid_card_port *port)
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
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(adapter, sas_address,
+							 port);
+	if (sas_dev && (!list_empty(&sas_dev->list))) {
+		list_del_init(&sas_dev->list);
+		del_from_list = true;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (del_from_list) {
+		leapraid_remove_device(adapter, sas_dev);
+		leapraid_sdev_put(sas_dev);
+	}
+}
+
+struct leapraid_raid_volume *leapraid_raid_volume_find_by_id(
+		struct leapraid_adapter *adapter, uint id, uint channel)
+{
+	struct leapraid_raid_volume *raid_volume;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+			    list) {
+		if (raid_volume->id == id && raid_volume->channel == channel) {
+			leapraid_raid_volume_get(raid_volume);
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock, flags);
+			return raid_volume;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	return NULL;
+}
+
+struct leapraid_raid_volume *leapraid_raid_volume_find_by_hdl(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_raid_volume *raid_volume;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+			    list) {
+		if (raid_volume->hdl == hdl) {
+			leapraid_raid_volume_get(raid_volume);
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock, flags);
+			return raid_volume;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	return NULL;
+}
+
+static struct leapraid_raid_volume *leapraid_raid_volume_find_by_wwid(
+		struct leapraid_adapter *adapter, u64 wwid)
+{
+	struct leapraid_raid_volume *raid_volume;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_for_each_entry(raid_volume, &adapter->dev_topo.raid_volume_list,
+			    list) {
+		if (raid_volume->wwid == wwid) {
+			leapraid_raid_volume_get(raid_volume);
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock, flags);
+			return raid_volume;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	return NULL;
+}
+
+static void leapraid_raid_volume_add(struct leapraid_adapter *adapter,
+				     struct leapraid_raid_volume *raid_volume)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	leapraid_raid_volume_get(raid_volume);
+	list_add_tail(&raid_volume->list, &adapter->dev_topo.raid_volume_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+}
+
+void leapraid_raid_volume_remove(struct leapraid_adapter *adapter,
+				 struct leapraid_raid_volume *raid_volume)
+{
+	unsigned long flags;
+	bool del_from_list = false;
+
+	if (!raid_volume) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid RAID volume\n", __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	if (!list_empty(&raid_volume->list)) {
+		list_del_init(&raid_volume->list);
+		del_from_list = true;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	leapraid_clear_cached_boot_dev(adapter, raid_volume, RAID_CHANNEL);
+	if (del_from_list)
+		leapraid_raid_volume_put(raid_volume);
+}
+
+static struct leapraid_enc_node *leapraid_enc_find_by_hdl(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_enc_node *enc_dev;
+
+	list_for_each_entry(enc_dev, &adapter->dev_topo.enc_list, list)
+		if (le16_to_cpu(enc_dev->pg0.enc_hdl) == hdl)
+			return enc_dev;
+
+	return NULL;
+}
+
+struct leapraid_topo_node *leapraid_exp_find_by_sas_address(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, struct leapraid_card_port *port)
+{
+	struct leapraid_topo_node *sas_exp;
+
+	if (!port) {
+		dev_warn(&adapter->pdev->dev, "%s: Invalid port\n", __func__);
+		return NULL;
+	}
+
+	list_for_each_entry(sas_exp, &adapter->dev_topo.exp_list, list)
+		if (sas_exp->sas_address == sas_address &&
+		    sas_exp->card_port == port)
+			return sas_exp;
+
+	dev_warn(&adapter->pdev->dev,
+		 "%s: No expander found for SAS addr=0x%016llx port=%p\n",
+		 __func__, (unsigned long long)sas_address, port);
+	return NULL;
+}
+
+bool leapraid_scmd_find_by_tgt(struct leapraid_adapter *adapter, uint id,
+			       uint channel)
+{
+	struct scsi_cmnd *scmd;
+	int taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		if (scmd->device->id == id && scmd->device->channel == channel)
+			return true;
+	}
+
+	return false;
+}
+
+bool leapraid_scmd_find_by_lun(struct leapraid_adapter *adapter, uint id,
+			       unsigned int lun, uint channel)
+{
+	struct scsi_cmnd *scmd;
+	int taskid;
+
+	for (taskid = 1; taskid <= adapter->shost->can_queue; taskid++) {
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+		if (!scmd)
+			continue;
+
+		if (scmd->device->id == id &&
+		    scmd->device->channel == channel &&
+		    scmd->device->lun == lun)
+			return true;
+	}
+
+	return false;
+}
+
+static struct leapraid_topo_node *leapraid_exp_find_by_hdl(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_topo_node *sas_exp;
+
+	list_for_each_entry(sas_exp, &adapter->dev_topo.exp_list, list)
+		if (sas_exp->hdl == hdl)
+			return sas_exp;
+
+	return NULL;
+}
+
+static enum leapraid_card_port_checking_flg leapraid_get_card_port_feature(
+		struct leapraid_card_port *old_card_port,
+		struct leapraid_card_port *card_port,
+		struct leapraid_card_port_feature *feature)
+{
+	feature->dirty_flg =
+		old_card_port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY;
+	feature->same_addr =
+		old_card_port->sas_address == card_port->sas_address;
+	feature->exact_phy =
+		old_card_port->phy_mask == card_port->phy_mask;
+	feature->phy_overlap =
+		old_card_port->phy_mask & card_port->phy_mask;
+	feature->same_port =
+		old_card_port->port_id == card_port->port_id;
+	feature->cur_chking_old_port = old_card_port;
+
+	if (!feature->dirty_flg || !feature->same_addr)
+		return CARD_PORT_SKIP_CHECKING;
+
+	return CARD_PORT_FURTHER_CHECKING_NEEDED;
+}
+
+static bool leapraid_process_card_port_feature(
+		struct leapraid_card_port_feature *feature)
+{
+	struct leapraid_card_port *old_card_port;
+
+	old_card_port = feature->cur_chking_old_port;
+	if (feature->exact_phy) {
+		feature->checking_state = SAME_PORT_WITH_NOTHING_CHANGED;
+		feature->expected_old_port = old_card_port;
+		return true;
+	}
+
+	if (feature->phy_overlap) {
+		if (feature->same_port) {
+			feature->checking_state =
+				SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS;
+			feature->expected_old_port = old_card_port;
+		} else if (feature->checking_state !=
+			   SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS) {
+			feature->checking_state =
+				SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS;
+			feature->expected_old_port = old_card_port;
+		}
+	} else if (feature->checking_state !=
+		   SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS &&
+		   feature->checking_state !=
+		   SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS) {
+		feature->checking_state = SAME_ADDR_ONLY;
+		feature->expected_old_port = old_card_port;
+		feature->same_addr_port_count++;
+	}
+
+	return false;
+}
+
+static int leapraid_check_card_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_card_port *card_port,
+		struct leapraid_card_port **expected_card_port,
+		int *count)
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
+	list_for_each_entry(old_card_port, &adapter->dev_topo.card_port_list,
+			    list) {
+		if (leapraid_get_card_port_feature(old_card_port, card_port,
+						   &feature))
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
+static void leapraid_del_phy_part_of_anther_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_card_port *card_port_table, int index,
+		u8 port_count, int offset)
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
+			leapraid_transport_detach_phy_to_port(
+				adapter,
+				card_topo_node,
+				&card_topo_node->card_phy[offset]);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		card_port_table[index].phy_mask |= BIT(offset);
+}
+
+static void leapraid_add_or_del_phys_from_existing_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_card_port *card_port,
+		struct leapraid_card_port *card_port_table,
+		int index, u8 port_count)
+{
+	struct leapraid_topo_node *card_topo_node;
+	u32 phy_mask_diff;
+	u32 offset;
+
+	card_topo_node = &adapter->dev_topo.card;
+	phy_mask_diff = card_port->phy_mask ^
+		card_port_table[index].phy_mask;
+	for (offset = 0; offset < adapter->dev_topo.card.phys_num; offset++) {
+		if (!(phy_mask_diff & BIT(offset)))
+			continue;
+
+		if (!(card_port_table[index].phy_mask & BIT(offset))) {
+			leapraid_del_phy_part_of_anther_port(adapter,
+							     card_port_table,
+							     index, port_count,
+							     offset);
+			continue;
+		}
+
+		if (card_topo_node->card_phy[offset].phy_is_assigned)
+			leapraid_transport_detach_phy_to_port(
+				adapter,
+				card_topo_node,
+				&card_topo_node->card_phy[offset]);
+
+		leapraid_transport_attach_phy_to_port(
+			adapter,
+			card_topo_node,
+			&card_topo_node->card_phy[offset],
+			card_port->sas_address,
+			card_port);
+	}
+}
+
+struct leapraid_sas_dev *leapraid_get_next_sas_dev_from_init_list(
+		struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	if (!list_empty(&adapter->dev_topo.sas_dev_init_list)) {
+		sas_dev = list_first_entry(&adapter->dev_topo.sas_dev_init_list,
+					   struct leapraid_sas_dev,
+					   list);
+		leapraid_sdev_get(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return sas_dev;
+}
+
+static bool leapraid_check_boot_dev_internal(u64 sas_address, u64 dev_name,
+					     u64 enc_lid, u16 slot,
+					     struct leapraid_boot_dev *boot_dev,
+					     u8 form)
+{
+	struct leapraid_boot_dev_format_sas_wwid *wwid;
+	struct leapraid_boot_dev_format_enc_slot *es;
+	struct leapraid_boot_dev_format_dev_name *dn;
+	void *pg_dev;
+
+	if (!boot_dev)
+		return false;
+
+	pg_dev = boot_dev->pg_dev;
+	switch (form & LEAPRAID_BOOTDEV_FORM_MASK) {
+	case LEAPRAID_BOOTDEV_FORM_SAS_WWID:
+		wwid = pg_dev;
+
+		if (!sas_address)
+			return false;
+
+		return sas_address == le64_to_cpu(wwid->sas_addr);
+	case LEAPRAID_BOOTDEV_FORM_ENC_SLOT:
+		es = pg_dev;
+
+		if (!enc_lid)
+			return false;
+
+		return (enc_lid == le64_to_cpu(es->enc_lid) &&
+			slot == le16_to_cpu(es->slot_num));
+	case LEAPRAID_BOOTDEV_FORM_DEV_NAME:
+		dn = pg_dev;
+
+		if (!dev_name)
+			return false;
+
+		return dev_name == le64_to_cpu(dn->dev_name);
+	case LEAPRAID_BOOTDEV_FORM_NONE:
+	default:
+		return false;
+	}
+}
+
+void leapraid_boot_dev_get(void *dev, u32 chnl)
+{
+	if (!dev)
+		return;
+
+	if (chnl == RAID_CHANNEL)
+		leapraid_raid_volume_get((struct leapraid_raid_volume *)dev);
+	else
+		leapraid_sdev_get((struct leapraid_sas_dev *)dev);
+}
+
+void leapraid_boot_dev_put(void *dev, u32 chnl)
+{
+	if (!dev)
+		return;
+
+	if (chnl == RAID_CHANNEL)
+		leapraid_raid_volume_put((struct leapraid_raid_volume *)dev);
+	else
+		leapraid_sdev_put((struct leapraid_sas_dev *)dev);
+}
+
+static void leapraid_try_set_boot_dev(struct leapraid_boot_dev *boot_dev,
+				      u64 sas_addr, u64 dev_name,
+				      u64 enc_lid, u16 slot,
+				      void *dev, u32 chnl)
+{
+	bool matched = false;
+
+	if (boot_dev->dev)
+		return;
+
+	matched = leapraid_check_boot_dev_internal(sas_addr, dev_name, enc_lid,
+						   slot, boot_dev,
+						   boot_dev->form);
+	if (matched) {
+		leapraid_boot_dev_get(dev, chnl);
+		boot_dev->dev = dev;
+		boot_dev->chnl = chnl;
+	}
+}
+
+static void leapraid_clear_boot_dev(struct leapraid_adapter *adapter,
+				    struct leapraid_boot_dev *boot_dev,
+				    void *dev, u32 chnl)
+{
+	void *cached_dev;
+	u32 cached_chnl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->boot_devs.lock, flags);
+	if (boot_dev->dev != dev || boot_dev->chnl != chnl)
+		goto out_unlock;
+
+	cached_dev = boot_dev->dev;
+	cached_chnl = boot_dev->chnl;
+	boot_dev->dev = NULL;
+	boot_dev->chnl = 0;
+	spin_unlock_irqrestore(&adapter->boot_devs.lock, flags);
+	leapraid_boot_dev_put(cached_dev, cached_chnl);
+	return;
+
+out_unlock:
+	spin_unlock_irqrestore(&adapter->boot_devs.lock, flags);
+}
+
+static void leapraid_clear_cached_boot_dev(struct leapraid_adapter *adapter,
+					   void *dev, u32 chnl)
+{
+	leapraid_clear_boot_dev(adapter,
+				&adapter->boot_devs.requested_boot_dev,
+				dev, chnl);
+	leapraid_clear_boot_dev(adapter,
+				&adapter->boot_devs.requested_alt_boot_dev,
+				dev, chnl);
+	leapraid_clear_boot_dev(adapter,
+				&adapter->boot_devs.current_boot_dev,
+				dev, chnl);
+}
+
+static void leapraid_check_boot_dev(struct leapraid_adapter *adapter,
+				    void *dev, u32 chnl)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_sas_dev *sas_dev;
+	u64 sas_addr;
+	u64 dev_name = 0;
+	u64 enc_lid = 0;
+	u16 slot = 0;
+
+	if (!adapter->scan_dev_desc.driver_loading)
+		return;
+
+	switch (chnl) {
+	case RAID_CHANNEL:
+		raid_volume = dev;
+		sas_addr = raid_volume->wwid;
+		break;
+	default:
+		sas_dev = dev;
+		sas_addr = sas_dev->sas_addr;
+		dev_name = sas_dev->dev_name;
+		enc_lid = sas_dev->enc_lid;
+		slot = sas_dev->slot;
+		break;
+	}
+
+	leapraid_try_set_boot_dev(&adapter->boot_devs.requested_boot_dev,
+				  sas_addr, dev_name, enc_lid,
+				  slot, dev, chnl);
+	leapraid_try_set_boot_dev(&adapter->boot_devs.requested_alt_boot_dev,
+				  sas_addr, dev_name, enc_lid,
+				  slot, dev, chnl);
+	leapraid_try_set_boot_dev(&adapter->boot_devs.current_boot_dev,
+				  sas_addr, dev_name, enc_lid,
+				  slot, dev, chnl);
+}
+
+static const char *leapraid_func_name(u8 func)
+{
+	switch (func) {
+	case LEAPRAID_FUNC_SCSIIO:
+		return "SCSIIO";
+	case LEAPRAID_FUNC_SCSI_TMF:
+		return "SCSI_TMF";
+	case LEAPRAID_FUNC_ADAPTER_INIT:
+		return "ADAPTER_INIT";
+	case LEAPRAID_FUNC_GET_ADAPTER_FEATURES:
+		return "GET_ADAPTER_FEATURES";
+	case LEAPRAID_FUNC_CONFIG_OP:
+		return "CONFIG_OP";
+	case LEAPRAID_FUNC_SCAN_DEV:
+		return "SCAN_DEV";
+	case LEAPRAID_FUNC_EVENT_NOTIFY:
+		return "EVENT_NOTIFY";
+	case LEAPRAID_FUNC_FW_DOWNLOAD:
+		return "FW_DOWNLOAD";
+	case LEAPRAID_FUNC_FW_UPLOAD:
+		return "FW_UPLOAD";
+	case LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH:
+		return "SCSIIO_RAID_PASSTHROUGH";
+	case LEAPRAID_FUNC_SCSI_ENC_PROCESSOR:
+		return "SCSI_ENC_PROCESSOR";
+	case LEAPRAID_FUNC_SMP_PASSTHROUGH:
+		return "SMP_PASSTHROUGH";
+	case LEAPRAID_FUNC_SAS_IO_UNIT_CTRL:
+		return "SAS_IO_UNIT_CTRL";
+	case LEAPRAID_FUNC_SCSIIO_SATA_PASSTHROUGH:
+		return "SCSIIO_SATA_PASSTHROUGH";
+	case LEAPRAID_FUNC_ADAPTER_UNIT_RESET:
+		return "ADAPTER_UNIT_RESET";
+	case LEAPRAID_FUNC_HANDSHAKE:
+		return "HANDSHAKE";
+	case LEAPRAID_FUNC_LOGBUF_INIT:
+		return "LOGBUF_INIT";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_cfg_action_name(u8 action)
+{
+	switch (action) {
+	case LEAPRAID_CFG_ACT_PAGE_HEADER:
+		return "PAGE_HEADER";
+	case LEAPRAID_CFG_ACT_PAGE_READ_CUR:
+		return "PAGE_READ_CUR";
+	case LEAPRAID_CFG_ACT_PAGE_WRITE_CUR:
+		return "PAGE_WRITE_CUR";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_cfg_page_type_name(u8 page_type)
+{
+	switch (page_type) {
+	case LEAPRAID_CFG_PT_IO_UNIT:
+		return "IO_UNIT";
+	case LEAPRAID_CFG_PT_ADAPTER:
+		return "ADAPTER";
+	case LEAPRAID_CFG_PT_BIOS:
+		return "BIOS";
+	case LEAPRAID_CFG_PT_RAID_VOLUME:
+		return "RAID_VOLUME";
+	case LEAPRAID_CFG_PT_MANUFACTURING:
+		return "MANUFACTURING";
+	case LEAPRAID_CFG_PT_RAID_PHYSDISK:
+		return "RAID_PHYSDISK";
+	case LEAPRAID_CFG_PT_EXTENDED:
+		return "EXTENDED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_cfg_ext_page_type_name(u8 ext_page_type)
+{
+	switch (ext_page_type) {
+	case LEAPRAID_CFG_EXTPT_SAS_IO_UNIT:
+		return "SAS_IO_UNIT";
+	case LEAPRAID_CFG_EXTPT_SAS_EXP:
+		return "SAS_EXPANDER";
+	case LEAPRAID_CFG_EXTPT_SAS_DEV:
+		return "SAS_DEVICE";
+	case LEAPRAID_CFG_EXTPT_SAS_PHY:
+		return "SAS_PHY";
+	case LEAPRAID_CFG_EXTPT_ENC:
+		return "ENCLOSURE";
+	case LEAPRAID_CFG_EXTPT_RAID_CONFIG:
+		return "RAID_CONFIG";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_sep_action_name(u8 action)
+{
+	switch (action) {
+	case LEAPRAID_SEP_REQ_ACT_WRITE_STATUS:
+		return "WRITE_STATUS";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_sas_op_name(u8 op)
+{
+	switch (op) {
+	case LEAPRAID_SAS_OP_PHY_LINK_RESET:
+		return "PHY_LINK_RESET";
+	case LEAPRAID_SAS_OP_PHY_HARD_RESET:
+		return "PHY_HARD_RESET";
+	case LEAPRAID_SAS_OP_SET_PARAMETER:
+		return "SET_PARAMETER";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_io_param_name(u8 adapter_param)
+{
+	switch (adapter_param) {
+	case LEAPRAID_SET_PARAMETER_SYNC_TIMESTAMP:
+		return "SYNC_TIMESTAMP";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static const char *leapraid_tm_type_name(u8 task_type)
+{
+	switch (task_type) {
+	case LEAPRAID_TM_TASKTYPE_ABORT_TASK:
+		return "ABORT_TASK";
+	case LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET:
+		return "ABORT_TASK_SET";
+	case LEAPRAID_TM_TASKTYPE_TARGET_RESET:
+		return "TARGET_RESET";
+	case LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET:
+		return "LOGICAL_UNIT_RESET";
+	case LEAPRAID_TM_TASKTYPE_CLEAR_TASK_SET:
+		return "CLEAR_TASK_SET";
+	case LEAPRAID_TM_TASKTYPE_QUERY_TASK:
+		return "QUERY_TASK";
+	case LEAPRAID_TM_TASKTYPE_CLEAR_ACA:
+		return "CLEAR_ACA";
+	case LEAPRAID_TM_TASKTYPE_QUERY_TASK_SET:
+		return "QUERY_TASK_SET";
+	case LEAPRAID_TM_TASKTYPE_QUERY_ASYNC_EVENT:
+		return "QUERY_ASYNC_EVENT";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+void leapraid_log_req_context(struct leapraid_adapter *adapter, u16 smid,
+			      const void *req_data)
+{
+	const struct leapraid_req *req = req_data;
+
+	if (!adapter || !adapter->pdev || !req_data)
+		return;
+
+	switch (req->func) {
+	case LEAPRAID_FUNC_CONFIG_OP: {
+		const struct leapraid_cfg_req *cfg_req = req_data;
+
+		dev_err(&adapter->pdev->dev,
+			"cfg-req: smid=%u func=0x%02x(%s) action=0x%02x(%s)\n",
+			smid, req->func, leapraid_func_name(req->func),
+			cfg_req->action,
+			leapraid_cfg_action_name(cfg_req->action));
+		dev_err(&adapter->pdev->dev,
+			"cfg-req: page_type=0x%02x(%s) page_num=%u\n",
+			cfg_req->header.page_type,
+			leapraid_cfg_page_type_name(cfg_req->header.page_type),
+			cfg_req->header.page_num);
+		if (cfg_req->header.page_type == LEAPRAID_CFG_PT_EXTENDED)
+			dev_err(&adapter->pdev->dev,
+				"cfg-req: ext_page_type=0x%02x(%s)\n",
+				cfg_req->ext_page_type,
+				leapraid_cfg_ext_page_type_name(
+					cfg_req->ext_page_type));
+		dev_err(&adapter->pdev->dev, "cfg-req: page_addr=0x%08x\n",
+			le32_to_cpu(cfg_req->page_addr));
+		break;
+	}
+	case LEAPRAID_FUNC_SCSI_TMF: {
+		const struct leapraid_scsi_tm_req *tm_req = req_data;
+
+		dev_err(&adapter->pdev->dev,
+			"scsi_tm:: smid=%u func=0x%02x(%s) task=0x%02x(%s)\n",
+			smid, req->func, leapraid_func_name(req->func),
+			tm_req->task_type,
+			leapraid_tm_type_name(tm_req->task_type));
+		dev_err(&adapter->pdev->dev,
+			"scsi_tm:: dev_hdl=0x%04x task_mid=%u\n",
+			le16_to_cpu(tm_req->dev_hdl),
+			le16_to_cpu(tm_req->task_mid));
+		break;
+	}
+	case LEAPRAID_FUNC_SCSI_ENC_PROCESSOR: {
+		const struct leapraid_sep_req *sep_req = req_data;
+
+		dev_err(&adapter->pdev->dev,
+			"sep: smid=%u func=0x%02x(%s) action=0x%02x(%s)\n",
+			smid, req->func, leapraid_func_name(req->func),
+			sep_req->act,
+			leapraid_sep_action_name(sep_req->act));
+		dev_err(&adapter->pdev->dev,
+			"sep: dev_hdl=0x%04x slot=%u enc_hdl=0x%04x\n",
+			le16_to_cpu(sep_req->dev_hdl),
+			le16_to_cpu(sep_req->slot),
+			le16_to_cpu(sep_req->enc_hdl));
+		break;
+	}
+	case LEAPRAID_FUNC_SAS_IO_UNIT_CTRL: {
+		const struct leapraid_io_unit_ctrl_req *io_req = req_data;
+
+		dev_err(&adapter->pdev->dev,
+			"ctl_cmd: smid=%u func=0x%02x(%s) action=0x%02x(%s)\n",
+			smid, req->func, leapraid_func_name(req->func),
+			io_req->op, leapraid_sas_op_name(io_req->op));
+		dev_err(&adapter->pdev->dev,
+			"ctl_cmd: dev_hdl=0x%04x param=0x%02x(%s)\n",
+			le16_to_cpu(io_req->dev_hdl),
+			io_req->adapter_para,
+			leapraid_io_param_name(io_req->adapter_para));
+		break;
+	}
+	case LEAPRAID_FUNC_SMP_PASSTHROUGH: {
+		const struct leapraid_smp_passthrough_req *smp_req = req_data;
+
+		dev_err(&adapter->pdev->dev,
+			"smp_cmd: smid=%u func=0x%02x(%s) action=0x%02x\n",
+			smid, req->func, leapraid_func_name(req->func),
+			smp_req->passthrough_flg);
+		dev_err(&adapter->pdev->dev,
+			"smp_cmd: port=%u req_len=%u\n",
+			smp_req->physical_port,
+			le16_to_cpu(smp_req->req_data_len));
+		dev_err(&adapter->pdev->dev, "smp_cmd: sas_addr=0x%016llx\n",
+			(unsigned long long)le64_to_cpu(smp_req->sas_address));
+		break;
+	}
+	default:
+		dev_err(&adapter->pdev->dev,
+			"cmd: smid=%u func=0x%02x(%s)\n",
+			smid, req->func, leapraid_func_name(req->func));
+		break;
+	}
+}
+
+static void leapraid_build_and_fire_cfg_req(
+		struct leapraid_adapter *adapter,
+		struct leapraid_cfg_req *leap_mpi_cfgp_req,
+		struct leapraid_cfg_rep *leap_mpi_cfgp_rep)
+{
+	struct leapraid_cfg_req *local_leap_cfg_req;
+	u16 smid;
+
+	memset(leap_mpi_cfgp_rep, 0, sizeof(struct leapraid_cfg_rep));
+	memset(&adapter->driver_cmds.cfg_op_cmd.reply, 0,
+	       sizeof(struct leapraid_cfg_rep));
+	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_PENDING;
+	smid = adapter->driver_cmds.cfg_op_cmd.inter_taskid;
+	local_leap_cfg_req = leapraid_get_task_desc(adapter, smid);
+	memcpy(local_leap_cfg_req, leap_mpi_cfgp_req,
+	       sizeof(struct leapraid_cfg_req));
+	init_completion(&adapter->driver_cmds.cfg_op_cmd.done);
+	leapraid_fire_task(adapter, smid);
+	wait_for_completion_timeout(&adapter->driver_cmds.cfg_op_cmd.done,
+				    LEAPRAID_CFG_OP_TIMEOUT * HZ);
+}
+
+static int leapraid_req_cfg_func(struct leapraid_adapter *adapter,
+				 struct leapraid_cfg_req *leap_mpi_cfgp_req,
+				 struct leapraid_cfg_rep *leap_mpi_cfgp_rep,
+				 void *target_cfg_pg, void *real_cfg_pg_addr,
+				 u16 target_real_cfg_pg_sz)
+{
+	u32 adapter_status = UINT_MAX;
+	bool issue_reset = false;
+	u16 smid;
+	u8 retry_cnt;
+	int rc;
+
+	retry_cnt = 0;
+	mutex_lock(&adapter->driver_cmds.cfg_op_cmd.mutex);
+	smid = adapter->driver_cmds.cfg_op_cmd.inter_taskid;
+retry:
+	if (retry_cnt) {
+		if (retry_cnt > LEAPRAID_CFG_REQ_RETRY_TIMES) {
+			rc = -EFAULT;
+			goto out_cleanup;
+		}
+		dev_warn(&adapter->pdev->dev,
+			 "cfg-req: Retry request, cnt=%u\n", retry_cnt);
+	}
+
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					  __func__);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"cfg-req: Adapter not operational\n");
+		goto out_cleanup;
+	}
+
+	leapraid_build_and_fire_cfg_req(adapter, leap_mpi_cfgp_req,
+					leap_mpi_cfgp_rep);
+	if (!(adapter->driver_cmds.cfg_op_cmd.status & LEAPRAID_CMD_DONE)) {
+		retry_cnt++;
+		if (adapter->driver_cmds.cfg_op_cmd.status &
+		    LEAPRAID_CMD_RESET) {
+			dev_warn(&adapter->pdev->dev,
+				 "cfg-req: CMD fail due to hard reset\n");
+			goto retry;
+		}
+
+		if (adapter->access_ctrl.shost_recovering ||
+		    adapter->access_ctrl.pcie_recovering) {
+			dev_err(&adapter->pdev->dev,
+				"cfg-req: pending in %s, status=0x%x\n",
+				adapter->access_ctrl.shost_recovering ?
+				"shost recovery" : "pcie recovery",
+				adapter->driver_cmds.cfg_op_cmd.status);
+			leapraid_log_req_context(adapter, smid,
+						 leap_mpi_cfgp_req);
+			issue_reset = false;
+			rc = -EFAULT;
+		} else {
+			dev_err(&adapter->pdev->dev,
+				"cfg-req: timeout, status=0x%x, reset\n",
+				adapter->driver_cmds.cfg_op_cmd.status);
+			leapraid_log_req_context(adapter, smid,
+						 leap_mpi_cfgp_req);
+			issue_reset = true;
+		}
+
+		goto out_cleanup;
+	}
+
+	if (adapter->driver_cmds.cfg_op_cmd.status &
+	    LEAPRAID_CMD_REPLY_VALID) {
+		memcpy(leap_mpi_cfgp_rep,
+		       &adapter->driver_cmds.cfg_op_cmd.reply,
+		       sizeof(struct leapraid_cfg_rep));
+		adapter_status = le16_to_cpu(
+			leap_mpi_cfgp_rep->adapter_status) &
+			LEAPRAID_ADAPTER_STATUS_MASK;
+		if (adapter_status == LEAPRAID_ADAPTER_STATUS_SUCCESS &&
+		    target_cfg_pg && real_cfg_pg_addr &&
+		    target_real_cfg_pg_sz &&
+		    leap_mpi_cfgp_req->action ==
+		    LEAPRAID_CFG_ACT_PAGE_READ_CUR)
+			memcpy(target_cfg_pg, real_cfg_pg_addr,
+			       target_real_cfg_pg_sz);
+		if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+			if (adapter_status !=
+			    LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE)
+				dev_err(&adapter->pdev->dev,
+					"cfg-rep: adapter_status=0x%x\n",
+					adapter_status);
+			rc = -EFAULT;
+		}
+	} else {
+		dev_err(&adapter->pdev->dev, "cfg-rep: Reply invalid\n");
+		rc = -EFAULT;
+	}
+
+out_cleanup:
+	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.cfg_op_cmd.mutex);
+	if (issue_reset) {
+		if (adapter->scan_dev_desc.first_scan_dev_fired) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s:%d cfg-req: Failure, issuing reset\n",
+				 __func__, __LINE__);
+			leapraid_hard_reset_handler(adapter, FULL_RESET);
+		} else {
+			dev_warn(&adapter->pdev->dev,
+				 "cfg-req: CMD fail in init, skip reset\n");
+		}
+		rc = -EFAULT;
+	}
+	return rc;
+}
+
+static int leapraid_request_cfg_pg_header(
+		struct leapraid_adapter *adapter,
+		struct leapraid_cfg_req *leap_mpi_cfgp_req,
+		struct leapraid_cfg_rep *leap_mpi_cfgp_rep)
+{
+	return leapraid_req_cfg_func(adapter, leap_mpi_cfgp_req,
+				     leap_mpi_cfgp_rep, NULL, NULL, 0);
+}
+
+static int leapraid_request_cfg_pg(struct leapraid_adapter *adapter,
+				   struct leapraid_cfg_req *leap_mpi_cfgp_req,
+				   struct leapraid_cfg_rep *leap_mpi_cfgp_rep,
+				   void *target_cfg_pg, void *real_cfg_pg_addr,
+				   u16 target_real_cfg_pg_sz)
+{
+	return leapraid_req_cfg_func(adapter, leap_mpi_cfgp_req,
+				     leap_mpi_cfgp_rep, target_cfg_pg,
+				     real_cfg_pg_addr, target_real_cfg_pg_sz);
+}
+
+int leapraid_op_config_page(struct leapraid_adapter *adapter,
+			    void *target_cfg_pg, union cfg_param_1 cfgp1,
+			    union cfg_param_2 cfgp2,
+			    enum config_page_action cfg_op)
+{
+	struct leapraid_cfg_req leap_mpi_cfgp_req;
+	struct leapraid_cfg_rep leap_mpi_cfgp_rep;
+	u16 real_cfg_pg_sz;
+	void *real_cfg_pg_addr;
+	dma_addr_t real_cfg_pg_dma = 0;
+	u32 __page_size;
+	int rc;
+
+	memset(&leap_mpi_cfgp_req, 0, sizeof(struct leapraid_cfg_req));
+	leap_mpi_cfgp_req.func = LEAPRAID_FUNC_CONFIG_OP;
+	leap_mpi_cfgp_req.action = LEAPRAID_CFG_ACT_PAGE_HEADER;
+
+	switch (cfg_op) {
+	case GET_BIOS_PG3:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_BIOS;
+		leap_mpi_cfgp_req.header.page_num =
+			LEAPRAID_CFG_PAGE_NUM_BIOS3;
+		__page_size = sizeof(struct leapraid_bios_page3);
+		break;
+	case GET_BIOS_PG2:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_BIOS;
+		leap_mpi_cfgp_req.header.page_num =
+			LEAPRAID_CFG_PAGE_NUM_BIOS2;
+		__page_size = sizeof(struct leapraid_bios_page2);
+		break;
+	case GET_MANUFACTURING_PG0:
+		leap_mpi_cfgp_req.header.page_type =
+			LEAPRAID_CFG_PT_MANUFACTURING;
+		leap_mpi_cfgp_req.header.page_num =
+			LEAPRAID_CFG_PAGE_NUM_MANU0;
+		__page_size = sizeof(struct leapraid_manufacturing_p0);
+		break;
+	case GET_SAS_DEVICE_PG0:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type = LEAPRAID_CFG_EXTPT_SAS_DEV;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_DEV0;
+		__page_size = sizeof(struct leapraid_sas_dev_p0);
+		break;
+	case GET_SAS_IOUNIT_PG0:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type =
+			LEAPRAID_CFG_EXTPT_SAS_IO_UNIT;
+		leap_mpi_cfgp_req.header.page_num =
+			LEAPRAID_CFG_PAGE_NUM_IOUNIT0;
+		__page_size = cfgp1.size;
+		break;
+	case GET_SAS_IOUNIT_PG1:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type =
+			LEAPRAID_CFG_EXTPT_SAS_IO_UNIT;
+		leap_mpi_cfgp_req.header.page_num =
+			LEAPRAID_CFG_PAGE_NUM_IOUNIT1;
+		__page_size = cfgp1.size;
+		break;
+	case GET_SAS_EXPANDER_PG0:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type = LEAPRAID_CFG_EXTPT_SAS_EXP;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_EXP0;
+		__page_size = sizeof(struct leapraid_exp_p0);
+		break;
+	case GET_SAS_EXPANDER_PG1:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type = LEAPRAID_CFG_EXTPT_SAS_EXP;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_EXP1;
+		__page_size = sizeof(struct leapraid_exp_p1);
+		break;
+	case GET_SAS_ENCLOSURE_PG0:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type = LEAPRAID_CFG_EXTPT_ENC;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_ENC0;
+		__page_size = sizeof(struct leapraid_enc_p0);
+		break;
+	case GET_PHY_PG0:
+		leap_mpi_cfgp_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+		leap_mpi_cfgp_req.ext_page_type = LEAPRAID_CFG_EXTPT_SAS_PHY;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_PHY0;
+		__page_size = sizeof(struct leapraid_sas_phy_p0);
+		break;
+	case GET_RAID_VOLUME_PG0:
+		leap_mpi_cfgp_req.header.page_type =
+			LEAPRAID_CFG_PT_RAID_VOLUME;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_VOL0;
+		__page_size = cfgp1.size;
+		break;
+	case GET_RAID_VOLUME_PG1:
+		leap_mpi_cfgp_req.header.page_type =
+			LEAPRAID_CFG_PT_RAID_VOLUME;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_VOL1;
+		__page_size = sizeof(struct leapraid_raidvol_p1);
+		break;
+	case GET_PHY_DISK_PG0:
+		leap_mpi_cfgp_req.header.page_type =
+			LEAPRAID_CFG_PT_RAID_PHYSDISK;
+		leap_mpi_cfgp_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_PD0;
+		__page_size = sizeof(struct leapraid_raidpd_p0);
+		break;
+	default:
+		dev_err(&adapter->pdev->dev,
+			"Unsupported config page action=%d!\n", cfg_op);
+		return -EINVAL;
+	}
+
+	leapraid_build_nodata_mpi_sg(adapter,
+				     &leap_mpi_cfgp_req.page_buf_sge);
+	rc = leapraid_request_cfg_pg_header(adapter,
+					    &leap_mpi_cfgp_req,
+					    &leap_mpi_cfgp_rep);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"cfg-req: Header failed rc=%dn", rc);
+		return rc;
+	}
+
+	if (cfg_op == GET_SAS_DEVICE_PG0 ||
+	    cfg_op == GET_SAS_EXPANDER_PG0 ||
+	    cfg_op == GET_SAS_ENCLOSURE_PG0 ||
+	    cfg_op == GET_RAID_VOLUME_PG1)
+		leap_mpi_cfgp_req.page_addr = cpu_to_le32(cfgp1.form |
+							  cfgp2.handle);
+	else if (cfg_op == GET_PHY_DISK_PG0)
+		leap_mpi_cfgp_req.page_addr = cpu_to_le32(cfgp1.form |
+							  cfgp2.form_specific);
+	else if (cfg_op == GET_RAID_VOLUME_PG0)
+		leap_mpi_cfgp_req.page_addr =
+			cpu_to_le32(cfgp2.handle |
+				    LEAPRAID_RAID_VOL_CFG_PGAD_HDL);
+	else if (cfg_op == GET_SAS_EXPANDER_PG1)
+		leap_mpi_cfgp_req.page_addr =
+			cpu_to_le32(cfgp2.handle |
+				    (cfgp1.phy_number <<
+				     LEAPRAID_SAS_EXP_CFG_PGAD_PHYNUM_SHIFT) |
+				    LEAPRAID_SAS_EXP_CFG_PGAD_HDL_PHY_NUM);
+	else if (cfg_op == GET_PHY_PG0)
+		leap_mpi_cfgp_req.page_addr = cpu_to_le32(cfgp1.phy_number |
+			LEAPRAID_SAS_PHY_CFG_PGAD_PHY_NUMBER);
+
+	leap_mpi_cfgp_req.action = LEAPRAID_CFG_ACT_PAGE_READ_CUR;
+
+	leap_mpi_cfgp_req.header.page_num = leap_mpi_cfgp_rep.header.page_num;
+	leap_mpi_cfgp_req.header.page_type =
+		leap_mpi_cfgp_rep.header.page_type;
+	leap_mpi_cfgp_req.header.page_len = leap_mpi_cfgp_rep.header.page_len;
+	leap_mpi_cfgp_req.ext_page_len = leap_mpi_cfgp_rep.ext_page_len;
+	leap_mpi_cfgp_req.ext_page_type = leap_mpi_cfgp_rep.ext_page_type;
+
+	real_cfg_pg_sz = (leap_mpi_cfgp_req.header.page_len) ?
+		leap_mpi_cfgp_req.header.page_len * sizeof(u32) :
+		le16_to_cpu(leap_mpi_cfgp_rep.ext_page_len) * sizeof(u32);
+	real_cfg_pg_addr = dma_alloc_coherent(&adapter->pdev->dev,
+					      real_cfg_pg_sz,
+					      &real_cfg_pg_dma,
+					      GFP_KERNEL);
+	if (!real_cfg_pg_addr)
+		return -ENOMEM;
+
+	if (leap_mpi_cfgp_req.action == LEAPRAID_CFG_ACT_PAGE_WRITE_CUR) {
+		leapraid_single_mpi_sg_append(adapter,
+					      &leap_mpi_cfgp_req.page_buf_sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_LAST_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_EOL |
+						LEAPRAID_SGE_FLG_H2C) <<
+						LEAPRAID_SGE_FLG_SHIFT) |
+					       real_cfg_pg_sz,
+					      real_cfg_pg_dma);
+		memcpy(real_cfg_pg_addr, target_cfg_pg,
+		       min_t(u16, real_cfg_pg_sz, __page_size));
+	} else {
+		memset(target_cfg_pg, 0, __page_size);
+		leapraid_single_mpi_sg_append(adapter,
+					      &leap_mpi_cfgp_req.page_buf_sge,
+					      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+						LEAPRAID_SGE_FLG_LAST_ONE |
+						LEAPRAID_SGE_FLG_EOB |
+						LEAPRAID_SGE_FLG_EOL) <<
+						LEAPRAID_SGE_FLG_SHIFT) |
+					       real_cfg_pg_sz,
+					      real_cfg_pg_dma);
+		memset(real_cfg_pg_addr, 0,
+		       min_t(u16, real_cfg_pg_sz, __page_size));
+	}
+
+	rc = leapraid_request_cfg_pg(adapter,
+				     &leap_mpi_cfgp_req,
+				     &leap_mpi_cfgp_rep,
+				     target_cfg_pg,
+				     real_cfg_pg_addr,
+				     min_t(u16, real_cfg_pg_sz, __page_size));
+	if (rc) {
+		u32 status;
+
+		status = le16_to_cpu(leap_mpi_cfgp_rep.adapter_status) &
+				     LEAPRAID_ADAPTER_STATUS_MASK;
+		if (status != LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE)
+			dev_err(&adapter->pdev->dev,
+				"cfg-req: rc=%d, pg_info: 0x%x, 0x%x, %d\n",
+				rc, leap_mpi_cfgp_req.header.page_type,
+				leap_mpi_cfgp_req.ext_page_type,
+				leap_mpi_cfgp_req.header.page_num);
+	}
+
+	if (real_cfg_pg_addr)
+		dma_free_coherent(&adapter->pdev->dev,
+				  real_cfg_pg_sz,
+				  real_cfg_pg_addr,
+				  real_cfg_pg_dma);
+
+	return rc;
+}
+
+static int leapraid_cfg_find_vol_in_page(
+		struct leapraid_raid_cfg_p0 *raid_cfg_p0,
+		u16 pd_hdl, u16 *vol_hdl)
+{
+	u16 elements = raid_cfg_p0->elements_num;
+	int i;
+
+	for (i = 0; i < elements; i++) {
+		struct leapraid_raid_cfg_p0_element *elem;
+		u16 type;
+
+		elem = &raid_cfg_p0->cfg_element[i];
+
+		type = le16_to_cpu(elem->element_flg) &
+		       LEAPRAID_RAIDCFG_P0_EFLG_MASK_ELEMENT_TYPE;
+
+		switch (type) {
+		case LEAPRAID_RAIDCFG_P0_EFLG_VOL_PHYS_DISK_ELEMENT:
+		case LEAPRAID_RAIDCFG_P0_EFLG_OCE_ELEMENT: {
+			u16 phys_hdl;
+
+			phys_hdl = le16_to_cpu(elem->phys_disk_dev_hdl);
+			if (phys_hdl == pd_hdl) {
+				*vol_hdl = le16_to_cpu(elem->vol_dev_hdl);
+				return 0;
+			}
+			break;
+		}
+		case LEAPRAID_RAIDCFG_P0_EFLG_HOT_SPARE_ELEMENT:
+			*vol_hdl = 0;
+			return 0;
+
+		default:
+			break;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int leapraid_cfg_get_volume_hdl_dispatch(
+		struct leapraid_adapter *adapter,
+		struct leapraid_cfg_req *cfg_req,
+		struct leapraid_cfg_rep *cfg_rep,
+		struct leapraid_raid_cfg_p0 *raid_cfg_p0,
+		void *real_cfg_pg_addr,
+		u16 real_cfg_pg_sz,
+		u16 raid_cfg_p0_sz,
+		u16 pd_hdl, u16 *vol_hdl)
+{
+	u16 adapter_status;
+	int config_num;
+	int rc;
+
+	config_num = 0xFF;
+	while (true) {
+		cfg_req->page_addr =
+			cpu_to_le32(config_num +
+				    LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP);
+		rc = leapraid_request_cfg_pg(
+			adapter, cfg_req, cfg_rep,
+			raid_cfg_p0, real_cfg_pg_addr,
+			min_t(u16, real_cfg_pg_sz, raid_cfg_p0_sz));
+		adapter_status = le16_to_cpu(cfg_rep->adapter_status) &
+			LEAPRAID_ADAPTER_STATUS_MASK;
+		if (rc) {
+			if (adapter_status ==
+			    LEAPRAID_ADAPTER_STATUS_CONFIG_INVALID_PAGE) {
+				*vol_hdl = 0;
+				return 0;
+			}
+			return rc;
+		}
+
+		if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
+			return LEAPRAID_OPERATION_FAILED;
+
+		rc = leapraid_cfg_find_vol_in_page(raid_cfg_p0,
+						   pd_hdl,
+						   vol_hdl);
+		if (rc != -ENOENT)
+			return rc;
+
+		config_num = raid_cfg_p0->cfg_num;
+	}
+	return 0;
+}
+
+int leapraid_cfg_get_volume_hdl(struct leapraid_adapter *adapter,
+				u16 pd_hdl, u16 *vol_hdl)
+{
+	struct leapraid_raid_cfg_p0 *raid_cfg_p0;
+	struct leapraid_cfg_req cfg_req;
+	struct leapraid_cfg_rep cfg_rep;
+	dma_addr_t real_cfg_pg_dma = 0;
+	void *real_cfg_pg_addr;
+	u16 real_cfg_pg_sz;
+	int rc, raid_cfg_p0_sz;
+
+	*vol_hdl = 0;
+	memset(&cfg_req, 0, sizeof(struct leapraid_cfg_req));
+	cfg_req.func = LEAPRAID_FUNC_CONFIG_OP;
+	cfg_req.action = LEAPRAID_CFG_ACT_PAGE_HEADER;
+	cfg_req.header.page_type = LEAPRAID_CFG_PT_EXTENDED;
+	cfg_req.ext_page_type = LEAPRAID_CFG_EXTPT_RAID_CONFIG;
+	cfg_req.header.page_num = LEAPRAID_CFG_PAGE_NUM_VOL0;
+
+	leapraid_build_nodata_mpi_sg(adapter, &cfg_req.page_buf_sge);
+	rc = leapraid_request_cfg_pg_header(adapter, &cfg_req, &cfg_rep);
+	if (rc)
+		return rc;
+
+	cfg_req.action = LEAPRAID_CFG_ACT_PAGE_READ_CUR;
+	raid_cfg_p0_sz = le16_to_cpu(cfg_rep.ext_page_len) *
+		LEAPRAID_CFG_UNIT_SIZE;
+	raid_cfg_p0 = kmalloc(raid_cfg_p0_sz, GFP_KERNEL);
+	if (!raid_cfg_p0)
+		return -ENOMEM;
+
+	real_cfg_pg_sz = (cfg_req.header.page_len) ?
+		cfg_req.header.page_len * LEAPRAID_CFG_UNIT_SIZE :
+		le16_to_cpu(cfg_rep.ext_page_len) * LEAPRAID_CFG_UNIT_SIZE;
+
+	real_cfg_pg_addr = dma_alloc_coherent(&adapter->pdev->dev,
+					      real_cfg_pg_sz, &real_cfg_pg_dma,
+					      GFP_KERNEL);
+	if (!real_cfg_pg_addr) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	memset(raid_cfg_p0, 0, raid_cfg_p0_sz);
+	leapraid_single_mpi_sg_append(adapter,
+				      &cfg_req.page_buf_sge,
+				      ((LEAPRAID_SGE_FLG_SIMPLE_ONE |
+					LEAPRAID_SGE_FLG_LAST_ONE |
+					LEAPRAID_SGE_FLG_EOB |
+					LEAPRAID_SGE_FLG_EOL) <<
+				       LEAPRAID_SGE_FLG_SHIFT) |
+				      real_cfg_pg_sz,
+				      real_cfg_pg_dma);
+	memset(real_cfg_pg_addr, 0,
+	       min_t(u16, real_cfg_pg_sz, raid_cfg_p0_sz));
+
+	rc = leapraid_cfg_get_volume_hdl_dispatch(adapter,
+						  &cfg_req, &cfg_rep,
+						  raid_cfg_p0,
+						  real_cfg_pg_addr,
+						  real_cfg_pg_sz,
+						  raid_cfg_p0_sz,
+						  pd_hdl, vol_hdl);
+
+out_free:
+	if (real_cfg_pg_addr)
+		dma_free_coherent(&adapter->pdev->dev,
+				  real_cfg_pg_sz, real_cfg_pg_addr,
+				  real_cfg_pg_dma);
+	kfree(raid_cfg_p0);
+	return rc;
+}
+
+static int leapraid_get_adapter_phys(struct leapraid_adapter *adapter,
+				     u8 *nr_phys)
+{
+	struct leapraid_sas_io_unit_p0 sas_io_unit_page0;
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	int rc;
+
+	*nr_phys = 0;
+	cfgp1.size = sizeof(struct leapraid_sas_io_unit_p0);
+	rc = leapraid_op_config_page(adapter, &sas_io_unit_page0, cfgp1,
+				     cfgp2, GET_SAS_IOUNIT_PG0);
+	if (rc)
+		return rc;
+
+	*nr_phys = sas_io_unit_page0.phy_num;
+
+	return 0;
+}
+
+static int leapraid_cfg_get_number_pds(struct leapraid_adapter *adapter,
+				       u16 hdl, u8 *num_pds)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p0 raidvol_p0;
+	int rc;
+
+	*num_pds = 0;
+	cfgp1.size = sizeof(struct leapraid_raidvol_p0);
+	cfgp2.handle = hdl;
+	rc = leapraid_op_config_page(adapter, &raidvol_p0, cfgp1,
+				     cfgp2, GET_RAID_VOLUME_PG0);
+	if (!rc)
+		*num_pds = raidvol_p0.num_phys_disks;
+
+	return rc;
+}
+
+int leapraid_cfg_get_volume_wwid(struct leapraid_adapter *adapter,
+				 u16 vol_hdl, u64 *wwid)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p1 raidvol_p1;
+	int rc;
+
+	*wwid = 0;
+	cfgp1.form = LEAPRAID_RAID_VOL_CFG_PGAD_HDL;
+	cfgp2.handle = vol_hdl;
+	rc = leapraid_op_config_page(adapter, &raidvol_p1, cfgp1,
+				     cfgp2, GET_RAID_VOLUME_PG1);
+	if (!rc)
+		*wwid = le64_to_cpu(raidvol_p1.wwid);
+
+	return rc;
+}
+
+static int leapraid_get_sas_io_unit_page0(
+		struct leapraid_adapter *adapter,
+		struct leapraid_sas_io_unit_p0 *sas_io_unit_p0,
+		u16 sas_iou_pg0_sz)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+
+	cfgp1.size = sas_iou_pg0_sz;
+	return leapraid_op_config_page(adapter, sas_io_unit_p0, cfgp1,
+				       cfgp2, GET_SAS_IOUNIT_PG0);
+}
+
+static int leapraid_get_sas_address(struct leapraid_adapter *adapter,
+				    u16 hdl, u64 *sas_address)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+
+	*sas_address = 0;
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if (leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1,
+				    cfgp2, GET_SAS_DEVICE_PG0))
+		return -ENXIO;
+
+	if (hdl <= adapter->dev_topo.card.phys_num &&
+	    (!(le32_to_cpu(sas_dev_p0.dev_info) & LEAPRAID_DEVTYP_SEP)))
+		*sas_address = adapter->dev_topo.card.sas_address;
+	else
+		*sas_address = le64_to_cpu(sas_dev_p0.sas_address);
+
+	return 0;
+}
+
+int leapraid_get_volume_cap(struct leapraid_adapter *adapter,
+			    struct leapraid_raid_volume *raid_volume)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_raidvol_p0 *raidvol_p0;
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_raidpd_p0 raidpd_p0;
+	u8 num_pds;
+	u16 sz;
+	int rc = 0;
+
+	if (leapraid_cfg_get_number_pds(adapter, raid_volume->hdl,
+					&num_pds) || !num_pds)
+		return -EFAULT;
+
+	raid_volume->pd_num = num_pds;
+	sz = offsetof(struct leapraid_raidvol_p0, phys_disk) +
+		(num_pds * sizeof(struct leapraid_raidvol0_phys_disk));
+	raidvol_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!raidvol_p0)
+		return -ENOMEM;
+
+	cfgp1.size = sz;
+	cfgp2.handle = raid_volume->hdl;
+	if (leapraid_op_config_page(adapter, raidvol_p0, cfgp1, cfgp2,
+				    GET_RAID_VOLUME_PG0)) {
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+	raid_volume->vol_type = raidvol_p0->volume_type;
+	cfgp1.form = LEAPRAID_PHYSDISK_CFG_PGAD_PHYSDISKNUM;
+	cfgp2.form_specific = raidvol_p0->phys_disk[0].phys_disk_num;
+	if (!(leapraid_op_config_page(adapter, &raidpd_p0, cfgp1, cfgp2,
+				      GET_PHY_DISK_PG0))) {
+		cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+		cfgp2.handle = le16_to_cpu(raidpd_p0.dev_hdl);
+		if (!(leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1,
+					      cfgp2, GET_SAS_DEVICE_PG0)))
+			raid_volume->dev_info =
+				le32_to_cpu(sas_dev_p0.dev_info);
+	}
+
+out_cleanup:
+	kfree(raidvol_p0);
+	return rc;
+}
+
+static bool leapraid_should_skip_poll_work(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+	bool skip;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	skip = adapter->access_ctrl.shost_recovering ||
+		adapter->access_ctrl.pcie_recovering ||
+		adapter->access_ctrl.host_removing;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+
+	return skip;
+}
+
+static void leapraid_fw_log_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter = container_of(work,
+		struct leapraid_adapter, fw_log_desc.fw_log_work.work);
+	struct leapraid_fw_log_info *infom;
+	struct leapraid_reg_base __iomem *iomem_base;
+	unsigned long flags;
+
+	if (leapraid_should_skip_poll_work(adapter))
+		goto scheduled_timer;
+
+	infom = (struct leapraid_fw_log_info *)
+		(adapter->fw_log_desc.fw_log_buffer +
+		 LEAPRAID_SYS_LOG_BUF_SIZE);
+
+	iomem_base = adapter->iomem_base;
+	if (adapter->fw_log_desc.fw_log_init_flag == 0) {
+		infom->user_position =
+			leapraid_readl(&iomem_base->host_log_buf_pos);
+		infom->adapter_position =
+			leapraid_readl(&iomem_base->adapter_log_buf_pos);
+		adapter->fw_log_desc.fw_log_init_flag++;
+	}
+
+	writel(infom->user_position, &iomem_base->host_log_buf_pos);
+	infom->adapter_position =
+		leapraid_readl(&iomem_base->adapter_log_buf_pos);
+
+scheduled_timer:
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (adapter->fw_log_desc.fw_log_wq)
+		queue_delayed_work(
+			adapter->fw_log_desc.fw_log_wq,
+			&adapter->fw_log_desc.fw_log_work,
+			msecs_to_jiffies(LEAPRAID_PCIE_LOG_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+}
+
+void leapraid_fw_log_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	wq = adapter->fw_log_desc.fw_log_wq;
+	adapter->fw_log_desc.fw_log_wq = NULL;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (wq) {
+		if (!cancel_delayed_work_sync(&adapter->fw_log_desc
+					      .fw_log_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
+void leapraid_fw_log_start(struct leapraid_adapter *adapter)
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
+			  leapraid_fw_log_work);
+	snprintf(adapter->fw_log_desc.fw_log_wq_name,
+		 sizeof(adapter->fw_log_desc.fw_log_wq_name),
+		 "poll_%s%u_fw_log",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->fw_log_desc.fw_log_wq =
+		create_singlethread_workqueue(
+			adapter->fw_log_desc.fw_log_wq_name);
+	if (!adapter->fw_log_desc.fw_log_wq)
+		return;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (adapter->fw_log_desc.fw_log_wq)
+		queue_delayed_work(
+			adapter->fw_log_desc.fw_log_wq,
+			&adapter->fw_log_desc.fw_log_work,
+			msecs_to_jiffies(LEAPRAID_PCIE_LOG_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+}
+
+static void leapraid_timestamp_sync(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_unit_ctrl_req *io_unit_ctrl_req;
+	ktime_t current_time;
+	bool issue_reset = false;
+	u64 time_stamp;
+	u16 smid;
+
+	mutex_lock(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+	adapter->driver_cmds.timestamp_sync_cmd.status = LEAPRAID_CMD_PENDING;
+	smid = adapter->driver_cmds.timestamp_sync_cmd.inter_taskid;
+	io_unit_ctrl_req = leapraid_get_task_desc(adapter, smid);
+	memset(io_unit_ctrl_req, 0, sizeof(struct leapraid_io_unit_ctrl_req));
+	io_unit_ctrl_req->func = LEAPRAID_FUNC_SAS_IO_UNIT_CTRL;
+	io_unit_ctrl_req->op = LEAPRAID_SAS_OP_SET_PARAMETER;
+	io_unit_ctrl_req->adapter_para = LEAPRAID_SET_PARAMETER_SYNC_TIMESTAMP;
+
+	current_time = ktime_get_real();
+	time_stamp = ktime_to_ms(current_time);
+
+	io_unit_ctrl_req->adapter_para_value =
+		cpu_to_le32(time_stamp & 0xFFFFFFFF);
+	io_unit_ctrl_req->adapter_para_value2 =
+		cpu_to_le32(time_stamp >> 32);
+	init_completion(&adapter->driver_cmds.timestamp_sync_cmd.done);
+	leapraid_fire_task(adapter, smid);
+	leapraid_debug_log_info(adapter);
+	wait_for_completion_timeout(&adapter->driver_cmds
+					.timestamp_sync_cmd.done,
+				    LEAPRAID_TIMESTAMP_SYNC_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.timestamp_sync_cmd.status &
+	      LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: timestamp sync timeout, status=0x%x\n",
+			__func__,
+			adapter->driver_cmds.timestamp_sync_cmd.status);
+		leapraid_log_req_context(adapter, smid, io_unit_ctrl_req);
+		issue_reset =
+			leapraid_check_reset(
+				adapter->driver_cmds.timestamp_sync_cmd.status);
+	}
+
+	if (issue_reset) {
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		leapraid_hard_reset_handler(adapter, FULL_RESET);
+	}
+
+	adapter->driver_cmds.timestamp_sync_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+}
+
+static void leapraid_check_scheduled_fault_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter;
+	unsigned long flags;
+	u32 adapter_state;
+	int rc;
+
+	adapter = container_of(work, struct leapraid_adapter,
+			       reset_desc.fault_reset_work.work);
+
+	if (leapraid_should_skip_poll_work(adapter))
+		goto scheduled_timer;
+
+	adapter_state = leapraid_get_adapter_state(adapter);
+	if (adapter_state != LEAPRAID_DB_OPERATIONAL) {
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset 0x%x\n",
+			 __func__, __LINE__, adapter_state);
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		adapter_state = leapraid_get_adapter_state(adapter);
+		if (rc && adapter_state != LEAPRAID_DB_OPERATIONAL) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Hard reset failed, state=0x%x rc=%d\n",
+				__func__, adapter_state, rc);
+			return;
+		}
+	}
+
+	if (++adapter->timestamp_sync_cnt >=
+	    LEAPRAID_TIMESTAMP_SYNC_INTERVAL) {
+		adapter->timestamp_sync_cnt = 0;
+		leapraid_timestamp_sync(adapter);
+	}
+
+scheduled_timer:
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (adapter->reset_desc.fault_reset_wq)
+		queue_delayed_work(
+			adapter->reset_desc.fault_reset_wq,
+			&adapter->reset_desc.fault_reset_work,
+			msecs_to_jiffies(LEAPRAID_FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+}
+
+void leapraid_check_scheduled_fault_start(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	if (adapter->reset_desc.fault_reset_wq)
+		return;
+
+	adapter->timestamp_sync_cnt = 0;
+	INIT_DELAYED_WORK(&adapter->reset_desc.fault_reset_work,
+			  leapraid_check_scheduled_fault_work);
+	snprintf(adapter->reset_desc.fault_reset_wq_name,
+		 sizeof(adapter->reset_desc.fault_reset_wq_name),
+		 "poll_%s%u_status",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+	adapter->reset_desc.fault_reset_wq =
+		create_singlethread_workqueue(
+			adapter->reset_desc.fault_reset_wq_name);
+	if (!adapter->reset_desc.fault_reset_wq) {
+		dev_err(&adapter->pdev->dev,
+			"Create single thread workqueue failed!\n");
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (adapter->reset_desc.fault_reset_wq)
+		queue_delayed_work(
+			adapter->reset_desc.fault_reset_wq,
+			&adapter->reset_desc.fault_reset_work,
+			msecs_to_jiffies(LEAPRAID_FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+}
+
+void leapraid_check_scheduled_fault_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	wq = adapter->reset_desc.fault_reset_wq;
+	adapter->reset_desc.fault_reset_wq = NULL;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+
+	if (!wq)
+		return;
+
+	if (!cancel_delayed_work_sync(&adapter->reset_desc.fault_reset_work))
+		flush_workqueue(wq);
+	destroy_workqueue(wq);
+}
+
+static bool leapraid_ready_for_scsi_io(struct leapraid_adapter *adapter,
+				       u16 hdl)
+{
+	if (adapter->access_ctrl.pcie_recovering ||
+	    adapter->access_ctrl.shost_recovering) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed, pcie_recovering=%d shost_recovering=%d\n",
+			__func__,
+			adapter->access_ctrl.pcie_recovering,
+			adapter->access_ctrl.shost_recovering);
+		return false;
+	}
+
+	if (leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					 __func__))
+		return false;
+
+	if (hdl == LEAPRAID_INVALID_DEV_HANDLE) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Device handle is invalid\n", __func__);
+		return false;
+	}
+
+	return true;
+}
+
+static int leapraid_dispatch_scsi_io(struct leapraid_adapter *adapter,
+				     struct leapraid_scsi_cmd_desc *cmd_desc)
+{
+	struct scsi_device *sdev;
+	struct scsi_device *target_sdev = NULL;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_cmnd *scmd;
+	void *dma_buffer = NULL;
+	dma_addr_t dma_addr;
+	bool issue_reset = false;
+	int rc;
+
+	if (WARN_ON(!adapter->driver_cmds.internal_scmd))
+		return -EINVAL;
+
+	if (!leapraid_ready_for_scsi_io(adapter, cmd_desc->hdl))
+		return -EINVAL;
+
+	mutex_lock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	if (adapter->driver_cmds.driver_scsiio_cmd.status !=
+	    LEAPRAID_CMD_NOT_USED) {
+		dev_err(&adapter->pdev->dev,
+			"%s: scsiio cmd busy\n", __func__);
+		rc = -EAGAIN;
+		goto out_cleanup;
+	}
+	adapter->driver_cmds.driver_scsiio_cmd.status = LEAPRAID_CMD_PENDING;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+
+		if (sdev_priv->starget_priv->hdl == cmd_desc->hdl &&
+		    sdev_priv->lun == cmd_desc->lun) {
+			target_sdev = sdev;
+			break;
+		}
+	}
+
+	if (!target_sdev) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Device not found\n", __func__);
+		rc = -ENXIO;
+		goto out_cleanup;
+	}
+
+	if (cmd_desc->data_length) {
+		dma_buffer = dma_alloc_coherent(&adapter->pdev->dev,
+						cmd_desc->data_length,
+						&dma_addr, GFP_ATOMIC);
+		if (!dma_buffer) {
+			rc = -ENOMEM;
+			goto out_cleanup;
+		}
+		if (cmd_desc->dir == DMA_TO_DEVICE)
+			memcpy(dma_buffer, cmd_desc->data_buffer,
+			       cmd_desc->data_length);
+	}
+
+	scmd = adapter->driver_cmds.internal_scmd;
+	scmd->device = target_sdev;
+	scmd->cmd_len = cmd_desc->cdb_length;
+	memcpy(scmd->cmnd, cmd_desc->cdb, cmd_desc->cdb_length);
+	scmd->sc_data_direction = cmd_desc->dir;
+	scmd->sdb.length = cmd_desc->data_length;
+	scmd->sdb.table.nents = 1;
+	scmd->sdb.table.orig_nents = 1;
+	sg_init_one(scmd->sdb.table.sgl, dma_buffer, cmd_desc->data_length);
+	init_completion(&adapter->driver_cmds.driver_scsiio_cmd.done);
+	if (leapraid_queuecommand(adapter->shost, scmd)) {
+		adapter->driver_cmds.driver_scsiio_cmd.status &=
+			~LEAPRAID_CMD_PENDING;
+		complete(&adapter->driver_cmds.driver_scsiio_cmd.done);
+		dev_err(&adapter->pdev->dev,
+			"%s: queuecommand failed\n", __func__);
+		rc = -EINVAL;
+		goto out_cleanup;
+	}
+
+	wait_for_completion_timeout(&adapter->driver_cmds
+				    .driver_scsiio_cmd.done,
+				    cmd_desc->time_out * HZ);
+
+	if (!(adapter->driver_cmds.driver_scsiio_cmd.status &
+	    LEAPRAID_CMD_DONE)) {
+		issue_reset =
+			leapraid_check_reset(
+				adapter->driver_cmds.driver_scsiio_cmd.status);
+		rc = -ENODATA;
+		goto reset;
+	}
+
+	rc = adapter->driver_cmds.internal_scmd->result;
+	if (!rc && cmd_desc->dir == DMA_FROM_DEVICE)
+		memcpy(cmd_desc->data_buffer, dma_buffer,
+		       cmd_desc->data_length);
+
+reset:
+	if (issue_reset) {
+		rc = -ENODATA;
+		dev_err(&adapter->pdev->dev, "fire tgt reset: hdl=0x%04x\n",
+			cmd_desc->hdl);
+		leapraid_issue_locked_tm(
+			adapter, cmd_desc->hdl, 0, 0, 0,
+			LEAPRAID_TM_TASKTYPE_TARGET_RESET,
+			adapter->driver_cmds.driver_scsiio_cmd.taskid,
+			LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+	}
+out_cleanup:
+	if (target_sdev)
+		scsi_device_put(target_sdev);
+
+	if (dma_buffer)
+		dma_free_coherent(&adapter->pdev->dev,
+				  cmd_desc->data_length,
+				  dma_buffer,
+				  dma_addr);
+
+	adapter->driver_cmds.driver_scsiio_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	return rc;
+}
+
+static int leapraid_dispatch_logsense(struct leapraid_adapter *adapter,
+				      u16 hdl, u32 lun)
+{
+	struct leapraid_scsi_cmd_desc *desc;
+	char *buf;
+	int rc;
+
+	desc = kzalloc_obj(*desc);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->hdl = hdl;
+	desc->lun = lun;
+	desc->data_length = LEAPRAID_LOGSENSE_DATA_LENGTH;
+	desc->dir = DMA_FROM_DEVICE;
+	desc->cdb_length = LEAPRAID_LOGSENSE_CDB_LENGTH;
+	desc->cdb[0] = LOG_SENSE;
+	desc->cdb[2] = LEAPRAID_LOGSENSE_CDB_CODE;
+	desc->cdb[8] = desc->data_length;
+	desc->raid_member = 0;
+	desc->time_out = LEAPRAID_LOGSENSE_TIMEOUT;
+
+	desc->data_buffer = kzalloc(desc->data_length, GFP_KERNEL);
+	if (!desc->data_buffer) {
+		kfree(desc);
+		return -ENOMEM;
+	}
+
+	rc = leapraid_dispatch_scsi_io(adapter, desc);
+	buf = desc->data_buffer;
+
+	if (!rc && buf[8] == LEAPRAID_LOGSENSE_SMART_CODE)
+		leapraid_smart_fault_detect(adapter, hdl);
+
+	kfree(desc->data_buffer);
+	kfree(desc);
+
+	return rc;
+}
+
+static bool leapraid_smart_poll_check(struct leapraid_adapter *adapter,
+				      struct leapraid_sdev_priv *sdev_priv,
+				      u32 reset_flg)
+{
+	struct leapraid_sas_dev *sas_dev;
+
+	if (!sdev_priv || !sdev_priv->starget_priv->card_port)
+		return false;
+
+	sas_dev = leapraid_get_sas_dev_by_addr(
+			adapter,
+			sdev_priv->starget_priv->sas_address,
+			sdev_priv->starget_priv->card_port);
+	if (!sas_dev || !sas_dev->support_smart)
+		goto out_fail;
+
+	if (reset_flg)
+		sas_dev->led_on = 0;
+	else if (sas_dev->led_on)
+		goto out_fail;
+
+	if (sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER ||
+	    sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME ||
+	    sdev_priv->block)
+		goto out_fail;
+
+	leapraid_sdev_put(sas_dev);
+	return true;
+
+out_fail:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+	return false;
+}
+
+static void leapraid_sata_smart_poll_work(struct work_struct *work)
+{
+	struct leapraid_adapter *adapter =
+		container_of(work, struct leapraid_adapter,
+			     smart_poll_desc.smart_poll_work.work);
+	struct scsi_device *sdev;
+	struct leapraid_sdev_priv *sdev_priv;
+	bool reset_flg = false;
+
+	if (leapraid_should_skip_poll_work(adapter))
+		goto scheduled_timer;
+
+	if (leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					 __func__))
+		goto scheduled_timer;
+
+	if (adapter->reset_desc.last_reset_cnt < adapter->reset_desc.reset_cnt)
+		reset_flg = true;
+
+	adapter->reset_desc.last_reset_cnt = adapter->reset_desc.reset_cnt;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (leapraid_smart_poll_check(adapter, sdev_priv, reset_flg))
+			leapraid_dispatch_logsense(adapter,
+						   sdev_priv->starget_priv->hdl,
+						   sdev_priv->lun);
+	}
+
+scheduled_timer:
+	if (adapter->smart_poll_desc.smart_poll_wq)
+		queue_delayed_work(
+			adapter->smart_poll_desc.smart_poll_wq,
+			&adapter->smart_poll_desc.smart_poll_work,
+			msecs_to_jiffies(LEAPRAID_SMART_POLLING_INTERVAL));
+}
+
+void leapraid_smart_polling_start(struct leapraid_adapter *adapter)
+{
+	if (adapter->smart_poll_desc.smart_poll_wq || !smart_poll)
+		return;
+
+	INIT_DELAYED_WORK(&adapter->smart_poll_desc.smart_poll_work,
+			  leapraid_sata_smart_poll_work);
+
+	snprintf(adapter->smart_poll_desc.smart_poll_wq_name,
+		 sizeof(adapter->smart_poll_desc.smart_poll_wq_name),
+		 "poll_%s%u_smart_poll",
+		 LEAPRAID_DRIVER_NAME,
+		 adapter->adapter_attr.id);
+	adapter->smart_poll_desc.smart_poll_wq =
+		create_singlethread_workqueue(
+			adapter->smart_poll_desc.smart_poll_wq_name);
+	if (!adapter->smart_poll_desc.smart_poll_wq)
+		return;
+	queue_delayed_work(adapter->smart_poll_desc.smart_poll_wq,
+			   &adapter->smart_poll_desc.smart_poll_work,
+			   msecs_to_jiffies(LEAPRAID_SMART_POLLING_INTERVAL));
+}
+
+void leapraid_smart_polling_stop(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+	struct leapraid_smart_poll_desc *desc;
+
+	desc =  &adapter->smart_poll_desc;
+	if (!desc->smart_poll_wq)
+		return;
+
+	wq = desc->smart_poll_wq;
+	desc->smart_poll_wq = NULL;
+	if (wq) {
+		if (!cancel_delayed_work_sync(&desc->smart_poll_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
+static void leapraid_overheat_work(struct work_struct *work)
+{
+	struct leapraid_overheat_desc *desc;
+	struct leapraid_adapter *adapter;
+	struct workqueue_struct *wq;
+	struct Scsi_Host *shost;
+	struct pci_dev *pdev;
+	unsigned long flags;
+
+	desc = container_of(work, struct leapraid_overheat_desc,
+			    fault_overheat_work);
+	adapter = container_of(desc, struct leapraid_adapter, overheat_desc);
+	pdev = adapter->pdev;
+	shost = pci_get_drvdata(pdev);
+
+	if (!shost) {
+		dev_err(&pdev->dev,
+			"Overheat processing failed: invalid host/adapter\n");
+		atomic_set(&adapter->overheat_desc.thermal_alert, 0);
+		wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		return;
+	}
+
+	if (adapter->access_ctrl.host_removing) {
+		atomic_set(&adapter->overheat_desc.thermal_alert, 0);
+		wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		return;
+	}
+
+	adapter->access_ctrl.host_removing = 1;
+	adapter->access_ctrl.shost_recover_async = 0;
+	adapter->scan_dev_desc.scan_start = 0;
+	adapter->scan_dev_desc.wait_scan_dev_done = 0;
+	adapter->scan_dev_desc.driver_loading = 0;
+	wake_up(&adapter->access_ctrl.shost_recover_wq);
+	wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+
+	leapraid_mask_int(adapter);
+
+	leapraid_smart_polling_stop(adapter);
+	leapraid_check_scheduled_fault_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	leapraid_mq_polling_pause(adapter);
+
+	leapraid_clean_active_cmds(adapter);
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	wq = adapter->fw_evt_s.fw_evt_thread;
+	adapter->fw_evt_s.fw_evt_thread = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	sas_remove_host(shost);
+	leapraid_cleanup_lists(adapter);
+	atomic_set(&adapter->overheat_desc.thermal_alert, 0);
+	wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+	dev_err(&pdev->dev, "%s: Suspend adapter due to overheat\n", __func__);
+}
+
+static void leapraid_overheat_init(struct leapraid_adapter *adapter)
+{
+	if (adapter->overheat_desc.fault_overheat_wq)
+		return;
+
+	atomic_set(&adapter->overheat_desc.thermal_alert, 0);
+	snprintf(adapter->overheat_desc.fault_overheat_wq_name,
+		 sizeof(adapter->overheat_desc.fault_overheat_wq_name),
+		 "driver_%s%u_overheat",
+		 LEAPRAID_DRIVER_NAME,
+		 adapter->adapter_attr.id);
+	adapter->overheat_desc.fault_overheat_wq =
+		create_singlethread_workqueue(
+			adapter->overheat_desc.fault_overheat_wq_name);
+	if (!adapter->overheat_desc.fault_overheat_wq) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to create overheat workqueue\n");
+		return;
+	}
+
+	INIT_WORK(&adapter->overheat_desc.fault_overheat_work,
+		  leapraid_overheat_work);
+}
+
+void leapraid_overheat_cleanup(struct leapraid_adapter *adapter)
+{
+	struct workqueue_struct *wq;
+
+	wq = xchg(&adapter->overheat_desc.fault_overheat_wq, NULL);
+	if (!wq)
+		return;
+
+	cancel_work_sync(&adapter->overheat_desc.fault_overheat_work);
+	destroy_workqueue(wq);
+}
+
+static void leapraid_fw_work(struct leapraid_adapter *adapter,
+			     struct leapraid_fw_evt_work *fw_evt);
+
+static void leapraid_fw_evt_free(struct kref *r)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+
+	fw_evt = container_of(r, struct leapraid_fw_evt_work, refcnt);
+
+	kfree(fw_evt->evt_data);
+	kfree(fw_evt);
+}
+
+static void leapraid_fw_evt_get(struct leapraid_fw_evt_work *fw_evt)
+{
+	kref_get(&fw_evt->refcnt);
+}
+
+static void leapraid_fw_evt_put(struct leapraid_fw_evt_work *fw_work)
+{
+	kref_put(&fw_work->refcnt, leapraid_fw_evt_free);
+}
+
+static struct leapraid_fw_evt_work *leapraid_alloc_fw_evt_work(void)
+{
+	struct leapraid_fw_evt_work *fw_evt =
+		kzalloc(sizeof(*fw_evt), GFP_ATOMIC);
+
+	if (fw_evt)
+		kref_init(&fw_evt->refcnt);
+
+	return fw_evt;
+}
+
+static void leapraid_run_fw_evt_work(struct work_struct *work)
+{
+	struct leapraid_fw_evt_work *fw_evt =
+		container_of(work, struct leapraid_fw_evt_work, work);
+
+	leapraid_fw_work(fw_evt->adapter, fw_evt);
+}
+
+static void leapraid_fw_evt_add(struct leapraid_adapter *adapter,
+				struct leapraid_fw_evt_work *fw_evt)
+{
+	unsigned long flags;
+
+	if (!adapter->fw_evt_s.fw_evt_thread)
+		return;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	leapraid_fw_evt_get(fw_evt);
+	INIT_LIST_HEAD(&fw_evt->list);
+	list_add_tail(&fw_evt->list, &adapter->fw_evt_s.fw_evt_list);
+	INIT_WORK(&fw_evt->work, leapraid_run_fw_evt_work);
+	leapraid_fw_evt_get(fw_evt);
+	queue_work(adapter->fw_evt_s.fw_evt_thread, &fw_evt->work);
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+}
+
+static void leapraid_del_fw_evt_from_list(struct leapraid_adapter *adapter,
+					  struct leapraid_fw_evt_work *fw_evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (!list_empty(&fw_evt->list)) {
+		list_del_init(&fw_evt->list);
+		leapraid_fw_evt_put(fw_evt);
+	}
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+}
+
+static struct leapraid_fw_evt_work *leapraid_next_fw_evt(
+		struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_evt = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (!list_empty(&adapter->fw_evt_s.fw_evt_list)) {
+		fw_evt = list_first_entry(&adapter->fw_evt_s.fw_evt_list,
+					  struct leapraid_fw_evt_work, list);
+		list_del_init(&fw_evt->list);
+	}
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	return fw_evt;
+}
+
+void leapraid_clean_active_fw_evt(struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+	unsigned long flags;
+	bool in_fw_evt_context;
+	bool rc;
+
+	if ((list_empty(&adapter->fw_evt_s.fw_evt_list) &&
+	     !adapter->fw_evt_s.cur_evt) || !adapter->fw_evt_s.fw_evt_thread)
+		return;
+
+	adapter->fw_evt_s.fw_evt_cleanup = 1;
+	if (adapter->access_ctrl.shost_recovering &&
+	    adapter->fw_evt_s.cur_evt)
+		adapter->fw_evt_s.cur_evt->ignore = 1;
+
+	while ((fw_evt = leapraid_next_fw_evt(adapter))) {
+		rc = cancel_work_sync(&fw_evt->work);
+		if (rc)
+			leapraid_fw_evt_put(fw_evt);
+		leapraid_fw_evt_put(fw_evt);
+	}
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	fw_evt = adapter->fw_evt_s.cur_evt;
+	if (fw_evt) {
+		in_fw_evt_context = adapter->fw_evt_s.cur_evt_task == current;
+		leapraid_fw_evt_get(fw_evt);
+	}
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (fw_evt) {
+		if (!in_fw_evt_context)
+			cancel_work_sync(&fw_evt->work);
+		leapraid_fw_evt_put(fw_evt);
+	}
+
+	adapter->fw_evt_s.fw_evt_cleanup = 0;
+}
+
+static void leapraid_internal_dev_ublk(struct scsi_device *sdev,
+				       struct leapraid_sdev_priv *sdev_priv)
+{
+	int rc;
+
+	sdev_printk(KERN_WARNING, sdev,
+		    "hdl 0x%04x: Now internal unblkg dev\n",
+		    sdev_priv->starget_priv->hdl);
+	sdev_priv->block = 0;
+	rc = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+	if (rc == -EINVAL) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "hdl 0x%04x: unblkg failed, rc=%d\n",
+			    sdev_priv->starget_priv->hdl, rc);
+		sdev_priv->block = 1;
+		rc = scsi_internal_device_block_nowait(sdev);
+		if (rc)
+			sdev_printk(KERN_WARNING, sdev,
+				    "hdl 0x%04x: Earlier ublkg err, rc=%d\n",
+				    sdev_priv->starget_priv->hdl, rc);
+
+		sdev_priv->block = 0;
+		rc = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+		if (rc)
+			sdev_printk(KERN_WARNING, sdev,
+				    "hdl 0x%04x: ublkg failed again, rc=%d\n",
+				    sdev_priv->starget_priv->hdl, rc);
+	}
+}
+
+static void leapraid_ublk_io_dev(struct leapraid_adapter *adapter,
+				 u64 sas_addr,
+				 struct leapraid_card_port *card_port)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv || !sdev_priv->starget_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->sas_address != sas_addr)
+			continue;
+
+		if (sdev_priv->starget_priv->card_port != card_port)
+			continue;
+
+		if (sdev_priv->block)
+			leapraid_internal_dev_ublk(sdev, sdev_priv);
+
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+	}
+}
+
+static void leapraid_ublk_io_all_dev(struct leapraid_adapter *adapter)
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
+		sdev_printk(KERN_WARNING, sdev, "hdl 0x%04x: blkg...\n",
+			    sdev_priv->starget_priv->hdl);
+		leapraid_internal_dev_ublk(sdev, sdev_priv);
+		continue;
+	}
+}
+
+static void leapraid_internal_dev_blk(
+		struct scsi_device *sdev,
+		struct leapraid_sdev_priv *sdev_priv)
+{
+	int rc;
+
+	sdev_printk(KERN_INFO, sdev, "Internal blkg hdl 0x%04x\n",
+		    sdev_priv->starget_priv->hdl);
+	sdev_priv->block = 1;
+	rc = scsi_internal_device_block_nowait(sdev);
+	if (rc == -EINVAL)
+		sdev_printk(KERN_WARNING, sdev,
+			    "hdl 0x%04x: blkg failed, rc=%d\n",
+			    rc, sdev_priv->starget_priv->hdl);
+}
+
+static void leapraid_imm_blkio_to_end_dev(struct leapraid_adapter *adapter,
+					  struct leapraid_sas_port *sas_port)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(
+		adapter,
+		sas_port->remote_identify.sas_address,
+		sas_port->card_port);
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
+					    "skip dev blk: sep hdl 0x%04x\n",
+					    sdev_priv->starget_priv->hdl);
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
+static void leapraid_imm_blkio_set_end_dev_blk_hdls(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_sas_port *sas_port;
+
+	list_for_each_entry(sas_port,
+			    &topo_node_exp->sas_port_list, port_list) {
+		if (sas_port->remote_identify.device_type == SAS_END_DEVICE)
+			leapraid_imm_blkio_to_end_dev(adapter, sas_port);
+	}
+}
+
+static void leapraid_imm_blkio_to_kids_attchd_to_ex(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node_exp);
+
+static void leapraid_imm_blkio_to_sib_exp(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_topo_node *topo_node_exp_sib;
+	struct leapraid_sas_port *sas_port;
+
+	list_for_each_entry(sas_port,
+			    &topo_node_exp->sas_port_list, port_list) {
+		if (sas_port->remote_identify.device_type ==
+			 SAS_EDGE_EXPANDER_DEVICE ||
+		    sas_port->remote_identify.device_type ==
+			 SAS_FANOUT_EXPANDER_DEVICE) {
+			topo_node_exp_sib =
+				leapraid_exp_find_by_sas_address(
+					adapter,
+					sas_port->remote_identify.sas_address,
+					sas_port->card_port);
+			leapraid_imm_blkio_to_kids_attchd_to_ex(
+				adapter,
+				topo_node_exp_sib);
+		}
+	}
+}
+
+static void leapraid_imm_blkio_to_kids_attchd_to_ex(
+				struct leapraid_adapter *adapter,
+				struct leapraid_topo_node *topo_node_exp)
+{
+	if (!topo_node_exp)
+		return;
+
+	leapraid_imm_blkio_set_end_dev_blk_hdls(adapter, topo_node_exp);
+
+	leapraid_imm_blkio_to_sib_exp(adapter, topo_node_exp);
+}
+
+static void leapraid_report_sdev_directly(struct leapraid_adapter *adapter,
+					  struct leapraid_sas_dev *sas_dev)
+{
+	struct leapraid_sas_port *sas_port;
+
+	sas_port = leapraid_transport_port_add(adapter,
+					       sas_dev->hdl,
+					       sas_dev->parent_sas_addr,
+					       sas_dev->card_port);
+	if (!sas_port) {
+		leapraid_sas_dev_remove(adapter, sas_dev);
+		return;
+	}
+
+	if (!sas_dev->starget) {
+		if (!adapter->scan_dev_desc.driver_loading) {
+			leapraid_transport_port_remove(
+				adapter,
+				sas_dev->sas_addr,
+				sas_dev->parent_sas_addr,
+				sas_dev->card_port);
+			leapraid_sas_dev_remove(adapter, sas_dev);
+		}
+		return;
+	}
+}
+
+static struct leapraid_sas_dev *leapraid_init_sas_dev(
+		struct leapraid_adapter *adapter,
+		struct leapraid_sas_dev_p0 *sas_dev_pg0,
+		struct leapraid_card_port *card_port, u16 hdl,
+		u64 parent_sas_addr, u64 sas_addr, u32 dev_info)
+{
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_enc_node *enc_dev;
+	unsigned long flags;
+
+	sas_dev = kzalloc_obj(*sas_dev);
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
+	sas_dev->port_connection = sas_dev_pg0->max_port_connections;
+	sas_dev->slot = sas_dev->enc_hdl ? le16_to_cpu(sas_dev_pg0->slot) : 0;
+	sas_dev->support_smart = (le16_to_cpu(sas_dev_pg0->flg) &
+				  LEAPRAID_SAS_DEV_P0_FLG_SATA_SMART);
+	if (le16_to_cpu(sas_dev_pg0->flg) &
+	    LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID) {
+		sas_dev->enc_level = sas_dev_pg0->enc_level;
+		memcpy(sas_dev->connector_name,
+		       sas_dev_pg0->connector_name,
+		       LEAPRAID_SAS_DEV_P0_CON_NAME_LEN);
+		sas_dev->connector_name[LEAPRAID_SAS_DEV_P0_CON_NAME_LEN] =
+			'\0';
+	} else {
+		sas_dev->enc_level = 0;
+		sas_dev->connector_name[0] = '\0';
+	}
+	if (sas_dev->enc_hdl) {
+		spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+		enc_dev = leapraid_enc_find_by_hdl(adapter, sas_dev->enc_hdl);
+		if (enc_dev)
+			sas_dev->enc_lid = le64_to_cpu(enc_dev->pg0.enc_lid);
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+	}
+	dev_info(&adapter->pdev->dev,
+		 "add dev: hdl=0x%x, SAS addr=0x%016llx, port connect=0x%x\n",
+		 hdl, sas_dev->sas_addr, sas_dev->port_connection);
+
+	return sas_dev;
+}
+
+static void leapraid_add_dev(struct leapraid_adapter *adapter, u16 hdl)
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
+	if (leapraid_op_config_page(adapter, &sas_dev_pg0,
+				    cfgp1, cfgp2, GET_SAS_DEVICE_PG0))
+		return;
+
+	dev_info = le32_to_cpu(sas_dev_pg0.dev_info);
+	if (!(leapraid_is_end_dev(dev_info)))
+		return;
+
+	sas_addr = le64_to_cpu(sas_dev_pg0.sas_address);
+	if (!(le16_to_cpu(sas_dev_pg0.flg) &
+	      LEAPRAID_SAS_DEV_P0_FLG_DEV_PRESENT))
+		return;
+
+	port_id = sas_dev_pg0.physical_port;
+	card_port = leapraid_get_port_by_id(adapter, port_id, false);
+	if (!card_port)
+		return;
+
+	sas_dev = leapraid_get_sas_dev_by_addr(adapter, sas_addr, card_port);
+	if (sas_dev) {
+		leapraid_sdev_put(sas_dev);
+		return;
+	}
+
+	if (leapraid_get_sas_address(adapter,
+				     le16_to_cpu(sas_dev_pg0.parent_dev_hdl),
+				     &parent_sas_addr))
+		return;
+
+	sas_dev = leapraid_init_sas_dev(adapter, &sas_dev_pg0, card_port,
+					hdl, parent_sas_addr, sas_addr,
+					dev_info);
+	if (!sas_dev)
+		return;
+
+	if (adapter->scan_dev_desc.wait_scan_dev_done) {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_sdev_get(sas_dev);
+		list_add_tail(&sas_dev->list,
+			      &adapter->dev_topo.sas_dev_init_list);
+		leapraid_check_boot_dev(adapter, sas_dev, 0);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	} else {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_sdev_get(sas_dev);
+		list_add_tail(&sas_dev->list, &adapter->dev_topo.sas_dev_list);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		leapraid_report_sdev_directly(adapter, sas_dev);
+	}
+	leapraid_sdev_put(sas_dev);
+}
+
+static void leapraid_remove_device(struct leapraid_adapter *adapter,
+				   struct leapraid_sas_dev *sas_dev)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	leapraid_clear_cached_boot_dev(adapter, sas_dev, 0);
+	if (sas_dev->led_on) {
+		leapraid_set_led(adapter, sas_dev, false);
+		sas_dev->led_on = 0;
+	}
+
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget_priv = sas_dev->starget->hostdata;
+		starget_priv->deleted = 1;
+		leapraid_ublk_io_dev(adapter,
+				     sas_dev->sas_addr, sas_dev->card_port);
+		starget_priv->hdl = LEAPRAID_INVALID_DEV_HANDLE;
+	}
+
+	leapraid_transport_port_remove(adapter,
+				       sas_dev->sas_addr,
+				       sas_dev->parent_sas_addr,
+				       sas_dev->card_port);
+
+	dev_info(&adapter->pdev->dev,
+		 "remove dev: hdl=0x%04x, SAS addr=0x%016llx\n",
+		 sas_dev->hdl, (unsigned long long)sas_dev->sas_addr);
+}
+
+static struct leapraid_vphy *leapraid_alloc_vphy(
+		struct leapraid_adapter *adapter,
+		u8 port_id, u8 phy_num)
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
+	vphy = kzalloc_obj(*vphy);
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
+static int leapraid_add_port_to_card_port_list(
+					struct leapraid_adapter *adapter,
+					u8 port_id, bool refresh)
+{
+	struct leapraid_card_port *card_port;
+
+	card_port = leapraid_get_port_by_id(adapter, port_id, false);
+	if (card_port)
+		return 0;
+	card_port = kzalloc_obj(*card_port);
+	if (!card_port)
+		return -ENOMEM;
+
+	card_port->port_id = port_id;
+	dev_dbg(&adapter->pdev->dev,
+		"port: %d is added to card_port list\n",
+		card_port->port_id);
+
+	if (refresh && adapter->access_ctrl.shost_recovering)
+		card_port->flg = LEAPRAID_CARD_PORT_FLG_NEW;
+	list_add_tail(&card_port->list, &adapter->dev_topo.card_port_list);
+	return 0;
+}
+
+static int leapraid_add_card_phy(struct leapraid_adapter *adapter,
+				 struct leapraid_sas_io_unit_p0 *iou,
+				 int i)
+{
+	struct leapraid_sas_phy_p0 phy_pg0;
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_topo_node *card = &adapter->dev_topo.card;
+	u8 port_id;
+
+	cfgp1.phy_number = i;
+
+	if (leapraid_op_config_page(adapter, &phy_pg0,
+				    cfgp1, cfgp2, GET_PHY_PG0))
+		return -EINVAL;
+
+	port_id = iou->phy_info[i].port;
+
+	if (leapraid_add_port_to_card_port_list(adapter, port_id, false))
+		return -EINVAL;
+
+	if ((le32_to_cpu(phy_pg0.phy_info) &
+	     LEAPRAID_SAS_PHYINFO_VPHY) &&
+	    ((phy_pg0.neg_link_rate >>
+	      LEAPRAID_SAS_NEG_LINK_RATE_SHIFT) >=
+	     LEAPRAID_SAS_NEG_LINK_RATE_1_5)) {
+		if (!leapraid_alloc_vphy(adapter, port_id, i))
+			return -ENOMEM;
+
+		card->card_phy[i].vphy = 1;
+	}
+
+	card->card_phy[i].hdl = card->hdl;
+	card->card_phy[i].phy_id = i;
+	card->card_phy[i].card_port =
+		leapraid_get_port_by_id(adapter, port_id, false);
+
+	leapraid_transport_add_card_phy(adapter,
+					&card->card_phy[i],
+					&phy_pg0,
+					card->parent_dev);
+
+	return 0;
+}
+
+static int leapraid_refresh_card_phy(struct leapraid_adapter *adapter,
+				     struct leapraid_sas_io_unit_p0 *iou,
+				     int i)
+{
+	struct leapraid_topo_node *card = &adapter->dev_topo.card;
+	struct leapraid_sas_phy_p0 phy_pg0;
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	u16 attached_hdl;
+	u32 dev_info;
+	u8 link_rate;
+	u8 port_id;
+
+	link_rate = iou->phy_info[i].neg_link_rate >>
+		LEAPRAID_SAS_NEG_LINK_RATE_SHIFT;
+	port_id = iou->phy_info[i].port;
+	if (leapraid_add_port_to_card_port_list(adapter, port_id, true))
+		return -EINVAL;
+
+	dev_info = le32_to_cpu(iou->phy_info[i].controller_phy_dev_info);
+	if (dev_info & LEAPRAID_DEVTYP_SEP &&
+	    link_rate >= LEAPRAID_SAS_NEG_LINK_RATE_1_5) {
+		cfgp1.phy_number = i;
+
+		if (leapraid_op_config_page(adapter, &phy_pg0,
+					    cfgp1, cfgp2, GET_PHY_PG0))
+			return 0;
+
+		if (le32_to_cpu(phy_pg0.phy_info) &
+		    LEAPRAID_SAS_PHYINFO_VPHY &&
+		    !leapraid_alloc_vphy(adapter, port_id, i))
+			return -EINVAL;
+
+		card->card_phy[i].vphy = 1;
+	}
+
+	card->card_phy[i].hdl = card->hdl;
+
+	attached_hdl = le16_to_cpu(iou->phy_info[i].attached_dev_hdl);
+	if (attached_hdl && link_rate < LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+		link_rate = LEAPRAID_SAS_NEG_LINK_RATE_1_5;
+
+	card->card_phy[i].card_port =
+		leapraid_get_port_by_id(adapter, port_id, false);
+
+	if (!card->card_phy[i].phy) {
+		cfgp1.phy_number = i;
+		if (leapraid_op_config_page(adapter, &phy_pg0,
+					    cfgp1, cfgp2, GET_PHY_PG0))
+			return 0;
+
+		card->card_phy[i].phy_id = i;
+
+		leapraid_transport_add_card_phy(adapter,
+						&card->card_phy[i],
+						&phy_pg0,
+						card->parent_dev);
+		return 0;
+	}
+
+	leapraid_transport_update_links(adapter,
+					card->sas_address,
+					attached_hdl,
+					i,
+					link_rate,
+					card->card_phy[i].card_port);
+
+	return 0;
+}
+
+static void leapraid_sas_host_add(struct leapraid_adapter *adapter,
+				  bool refresh)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_pg0;
+	struct leapraid_enc_p0 enc_pg0;
+	struct leapraid_sas_io_unit_p0 *sas_iou_pg0;
+	u16 sas_iou_pg0_sz;
+	u8 phys_num;
+	int i;
+	int rc;
+
+	if (!refresh) {
+		if (leapraid_get_adapter_phys(adapter, &phys_num) || !phys_num)
+			return;
+
+		adapter->dev_topo.card.card_phy =
+			kcalloc(phys_num,
+				sizeof(struct leapraid_card_phy), GFP_KERNEL);
+		if (!adapter->dev_topo.card.card_phy)
+			return;
+
+		adapter->dev_topo.card.phys_num = phys_num;
+	}
+
+	sas_iou_pg0_sz =
+		offsetof(struct leapraid_sas_io_unit_p0, phy_info) +
+			 (adapter->dev_topo.card.phys_num *
+			  sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iou_pg0 = kzalloc(sas_iou_pg0_sz, GFP_KERNEL);
+	if (!sas_iou_pg0)
+		return;
+
+	if (leapraid_get_sas_io_unit_page0(adapter,
+					   sas_iou_pg0,
+					   sas_iou_pg0_sz))
+		goto out_free;
+
+	adapter->dev_topo.card.parent_dev = &adapter->shost->shost_gendev;
+	adapter->dev_topo.card.hdl =
+		le16_to_cpu(sas_iou_pg0->phy_info[0].controller_dev_hdl);
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if (!refresh) /* add */
+			rc = leapraid_add_card_phy(adapter, sas_iou_pg0, i);
+		else /* refresh */
+			rc = leapraid_refresh_card_phy(adapter,
+						       sas_iou_pg0,
+						       i);
+		if (rc)
+			goto out_free;
+	}
+
+	if (!refresh) {
+		cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+		cfgp2.handle = adapter->dev_topo.card.hdl;
+		if (leapraid_op_config_page(adapter, &sas_dev_pg0, cfgp1,
+					    cfgp2, GET_SAS_DEVICE_PG0))
+			goto out_free;
+
+		adapter->dev_topo.card.enc_hdl =
+			le16_to_cpu(sas_dev_pg0.enc_hdl);
+		adapter->dev_topo.card.sas_address =
+			le64_to_cpu(sas_dev_pg0.sas_address);
+		dev_info(&adapter->pdev->dev,
+			 "add host: hdl=0x%04x, SAS addr=0x%016llx, phy=%d\n",
+			 adapter->dev_topo.card.hdl,
+			 (unsigned long long)adapter->dev_topo.card.sas_address,
+			 adapter->dev_topo.card.phys_num);
+
+		if (adapter->dev_topo.card.enc_hdl) {
+			cfgp1.form = LEAPRAID_SAS_ENC_CFG_PGAD_HDL;
+			cfgp2.handle = adapter->dev_topo.card.enc_hdl;
+			if (!(leapraid_op_config_page(adapter, &enc_pg0,
+						      cfgp1, cfgp2,
+						      GET_SAS_ENCLOSURE_PG0)))
+				adapter->dev_topo.card.enc_lid =
+					le64_to_cpu(enc_pg0.enc_lid);
+		}
+	}
+out_free:
+	kfree(sas_iou_pg0);
+}
+
+static int leapraid_internal_exp_add(struct leapraid_adapter *adapter,
+				     struct leapraid_exp_p0 *exp_pg0,
+				     union cfg_param_1 *cfgp1,
+				     union cfg_param_2 *cfgp2,
+				     u16 hdl)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_sas_port *sas_port = NULL;
+	struct leapraid_enc_node *enc_dev;
+	struct leapraid_exp_p1 exp_pg1;
+	int ret;
+	int rc;
+	unsigned long flags;
+	u8 port_id;
+	u16 parent_handle;
+	u64 sas_addr_parent;
+	int i;
+
+	port_id = exp_pg0->physical_port;
+	parent_handle = le16_to_cpu(exp_pg0->parent_dev_hdl);
+
+	rc = leapraid_get_sas_address(adapter,
+				      parent_handle, &sas_addr_parent);
+	if (rc)
+		return rc;
+	topo_node_exp = kzalloc_obj(*topo_node_exp);
+	if (!topo_node_exp)
+		return -ENOMEM;
+
+	topo_node_exp->hdl = hdl;
+	topo_node_exp->phys_num = exp_pg0->phy_num;
+	topo_node_exp->sas_address_parent = sas_addr_parent;
+	topo_node_exp->sas_address = le64_to_cpu(exp_pg0->sas_address);
+	topo_node_exp->card_port =
+		leapraid_get_port_by_id(adapter, port_id, false);
+	if (!topo_node_exp->card_port) {
+		rc = -EPERM;
+		goto out_fail;
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "add exp: saddr=0x%016llx, hdl=0x%04x, phdl=0x%04x, phy=%d\n",
+		 (unsigned long long)topo_node_exp->sas_address,
+		 hdl, parent_handle,
+		 topo_node_exp->phys_num);
+	if (!topo_node_exp->phys_num) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Invalid PHY num from exp_pg0\n", __func__);
+		rc = -EPERM;
+		goto out_fail;
+	}
+
+	topo_node_exp->card_phy =
+		kcalloc(topo_node_exp->phys_num,
+			sizeof(struct leapraid_card_phy), GFP_KERNEL);
+	if (!topo_node_exp->card_phy) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to alloc expander phy array, count=%u\n",
+			__func__, topo_node_exp->phys_num);
+		rc = -EPERM;
+		goto out_fail;
+	}
+
+	INIT_LIST_HEAD(&topo_node_exp->sas_port_list);
+	sas_port = leapraid_transport_port_add(adapter, hdl, sas_addr_parent,
+					       topo_node_exp->card_port);
+	if (!sas_port) {
+		rc = -EPERM;
+		goto out_fail;
+	}
+
+	topo_node_exp->parent_dev = &sas_port->rphy->dev;
+	topo_node_exp->rphy = sas_port->rphy;
+	for (i = 0; i < topo_node_exp->phys_num; i++) {
+		cfgp1->phy_number = i;
+		cfgp2->handle = hdl;
+		if (leapraid_op_config_page(adapter, &exp_pg1, *cfgp1, *cfgp2,
+					    GET_SAS_EXPANDER_PG1)) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Failed to get exp_pg1, phy=%d\n",
+				__func__, i);
+			rc = -EPERM;
+			goto out_fail;
+		}
+
+		topo_node_exp->card_phy[i].hdl = hdl;
+		topo_node_exp->card_phy[i].phy_id = i;
+		topo_node_exp->card_phy[i].card_port =
+			leapraid_get_port_by_id(adapter, port_id, false);
+		ret = leapraid_transport_add_exp_phy(
+				adapter,
+				&topo_node_exp->card_phy[i],
+				&exp_pg1,
+				topo_node_exp->parent_dev);
+		if (ret) {
+			rc = -EPERM;
+			goto out_fail;
+		}
+	}
+
+	if (topo_node_exp->enc_hdl) {
+		spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+		enc_dev = leapraid_enc_find_by_hdl(adapter,
+						   topo_node_exp->enc_hdl);
+		if (enc_dev)
+			topo_node_exp->enc_lid =
+				le64_to_cpu(enc_dev->pg0.enc_lid);
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_add_tail(&topo_node_exp->list, &adapter->dev_topo.exp_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+	return 0;
+
+out_fail:
+	if (sas_port)
+		leapraid_transport_port_remove(adapter,
+					       topo_node_exp->sas_address,
+					       sas_addr_parent,
+					       topo_node_exp->card_port);
+	kfree(topo_node_exp->card_phy);
+	kfree(topo_node_exp);
+	return rc;
+}
+
+static int leapraid_exp_add(struct leapraid_adapter *adapter, u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_exp_p0 exp_pg0;
+	u16 parent_handle;
+	u64 sas_addr, sas_addr_parent;
+	unsigned long flags;
+	u8 port_id;
+	int rc;
+
+	if (!hdl) {
+		dev_warn(&adapter->pdev->dev, "%s: Invalid hdl\n", __func__);
+		return -EPERM;
+	}
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.pcie_recovering) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed, shost_recovering=%d pcie_recovering=%d\n",
+			 __func__, adapter->access_ctrl.shost_recovering,
+			adapter->access_ctrl.pcie_recovering);
+		return -EPERM;
+	}
+
+	cfgp1.form = LEAPRAID_SAS_EXP_CFD_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if (leapraid_op_config_page(adapter, &exp_pg0, cfgp1, cfgp2,
+				    GET_SAS_EXPANDER_PG0))
+		return -EPERM;
+
+	parent_handle = le16_to_cpu(exp_pg0.parent_dev_hdl);
+	if (leapraid_get_sas_address(adapter, parent_handle, &sas_addr_parent))
+		return -EPERM;
+
+	port_id = exp_pg0.physical_port;
+	if (sas_addr_parent != adapter->dev_topo.card.sas_address) {
+		spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+		topo_node_exp =
+			leapraid_exp_find_by_sas_address(
+				adapter,
+				sas_addr_parent,
+				leapraid_get_port_by_id(adapter,
+							port_id,
+							false));
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
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
+		leapraid_exp_find_by_sas_address(
+			adapter,
+			sas_addr,
+			leapraid_get_port_by_id(adapter, port_id, false));
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (topo_node_exp)
+		return 0;
+
+	return leapraid_internal_exp_add(adapter, &exp_pg0, &cfgp1,
+					 &cfgp2, hdl);
+}
+
+static void leapraid_exp_node_rm(struct leapraid_adapter *adapter,
+				 struct leapraid_topo_node *topo_node_exp)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+	unsigned long flags;
+	int port_id;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+				 &topo_node_exp->sas_port_list,
+				 port_list) {
+		if (adapter->access_ctrl.shost_recovering)
+			return;
+
+		switch (sas_port->remote_identify.device_type) {
+		case SAS_END_DEVICE:
+			leapraid_sas_dev_remove_by_sas_address(
+				adapter,
+				sas_port->remote_identify.sas_address,
+				sas_port->card_port);
+			break;
+		case SAS_EDGE_EXPANDER_DEVICE:
+		case SAS_FANOUT_EXPANDER_DEVICE:
+			leapraid_exp_rm(
+				adapter,
+				sas_port->remote_identify.sas_address,
+				sas_port->card_port);
+			break;
+		default:
+			break;
+		}
+	}
+
+	port_id = topo_node_exp->card_port->port_id;
+	leapraid_transport_port_remove(adapter, topo_node_exp->sas_address,
+				       topo_node_exp->sas_address_parent,
+				       topo_node_exp->card_port);
+	dev_info(&adapter->pdev->dev,
+		 "removing exp: port=%d, SAS addr=0x%016llx, hdl=0x%04x\n",
+		 port_id, (unsigned long long)topo_node_exp->sas_address,
+		 topo_node_exp->hdl);
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_del(&topo_node_exp->list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+	kfree(topo_node_exp->card_phy);
+	kfree(topo_node_exp);
+}
+
+void leapraid_exp_rm(struct leapraid_adapter *adapter, u64 sas_addr,
+		     struct leapraid_card_port *port)
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
+							 sas_addr,
+							 port);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (topo_node_exp)
+		leapraid_exp_node_rm(adapter, topo_node_exp);
+}
+
+static void leapraid_internal_sas_topo_chg_evt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_card_port *card_port,
+		struct leapraid_topo_node *topo_node_exp,
+		struct leapraid_fw_evt_work *fw_evt,
+		u64 sas_addr, u8 max_phys)
+{
+	struct leapraid_evt_data_sas_topo_change_list *evt_data;
+	u8 phy_number;
+	u8 link_rate;
+	u16 reason_code;
+	u16 hdl;
+	int i;
+
+	evt_data = fw_evt->evt_data;
+	for (i = 0; i < evt_data->entry_num; i++) {
+		if (fw_evt->ignore)
+			return;
+
+		if (adapter->access_ctrl.host_removing ||
+		    adapter->access_ctrl.pcie_recovering)
+			return;
+
+		phy_number = evt_data->start_phy_num + i;
+		if (phy_number >= max_phys)
+			continue;
+
+		reason_code = evt_data->phy[i].phy_status &
+			LEAPRAID_EVT_SAS_TOPO_RC_MASK;
+
+		hdl = le16_to_cpu(evt_data->phy[i].attached_dev_hdl);
+		if (!hdl ||
+		    hdl > adapter->adapter_attr.features.max_dev_handle) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Invalid device handle\n", __func__);
+			continue;
+		}
+		link_rate = evt_data->phy[i].link_rate >>
+			LEAPRAID_SAS_NEG_LINK_RATE_SHIFT;
+		switch (reason_code) {
+		case LEAPRAID_EVT_SAS_TOPO_RC_TARG_ADDED:
+			if (adapter->access_ctrl.shost_recovering)
+				break;
+			leapraid_transport_update_links(adapter, sas_addr,
+							hdl, phy_number,
+							link_rate, card_port);
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
+	if (evt_data->exp_status == LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING &&
+	    topo_node_exp)
+		leapraid_exp_rm(adapter, sas_addr, card_port);
+}
+
+static void leapraid_sas_topo_chg_evt(struct leapraid_adapter *adapter,
+				      struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_card_port *card_port;
+	struct leapraid_evt_data_sas_topo_change_list *evt_data;
+	u16 phdl;
+	u8 max_phys;
+	u64 sas_addr;
+	unsigned long flags;
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.host_removing ||
+	    adapter->access_ctrl.pcie_recovering)
+		return;
+
+	evt_data = fw_evt->evt_data;
+	leapraid_sas_host_add(adapter, adapter->dev_topo.card.phys_num > 0);
+
+	if (fw_evt->ignore)
+		return;
+
+	phdl = le16_to_cpu(evt_data->exp_dev_hdl);
+	card_port = leapraid_get_port_by_id(adapter,
+					    evt_data->physical_port,
+					    false);
+	if (evt_data->exp_status == LEAPRAID_EVT_SAS_TOPO_ES_ADDED &&
+	    leapraid_exp_add(adapter, phdl) != 0)
+		return;
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
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
+		return;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	leapraid_internal_sas_topo_chg_evt(adapter, card_port,
+					   topo_node_exp, fw_evt,
+					   sas_addr, max_phys);
+}
+
+static void leapraid_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
+{
+	sdev->no_uld_attach = no_uld_attach ? 1 : 0;
+	sdev_printk(KERN_INFO, sdev,
+		    "%s RAID component to upper layer\n",
+		    sdev->no_uld_attach ? "hide" : "expose");
+	WARN_ON(scsi_device_reprobe(sdev));
+}
+
+static void leapraid_sas_pd_add(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
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
+	if (!hdl || hdl > adapter->adapter_attr.features.max_dev_handle) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid device handle\n", __func__);
+		return;
+	}
+
+	set_bit(hdl, adapter->dev_topo.pd_hdls);
+	sas_dev = leapraid_get_sas_dev_by_hdl(adapter, hdl);
+	if (sas_dev) {
+		leapraid_sdev_put(sas_dev);
+		dev_warn(&adapter->pdev->dev,
+			 "Dev handle 0x%x already exists\n", hdl);
+		return;
+	}
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if (leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1, cfgp2,
+				    GET_SAS_DEVICE_PG0)) {
+		dev_warn(&adapter->pdev->dev, "Failed to read dev page0\n");
+		return;
+	}
+
+	parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+	if (!leapraid_get_sas_address(adapter, parent_hdl, &sas_address))
+		leapraid_transport_update_links(adapter, sas_address, hdl,
+						sas_dev_p0.phy_num,
+						LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+			 leapraid_get_port_by_id(adapter,
+						 sas_dev_p0.physical_port,
+						 false));
+	leapraid_add_dev(adapter, hdl);
+}
+
+static void leapraid_sas_pd_delete(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+	leapraid_sas_dev_remove_by_hdl(adapter, hdl);
+}
+
+static void leapraid_sas_pd_hide(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *starget = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u64 volume_wwid = 0;
+	u16 volume_hdl;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+	if (!hdl || hdl > adapter->adapter_attr.features.max_dev_handle) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid device handle\n", __func__);
+		return;
+	}
+	leapraid_cfg_get_volume_hdl(adapter, hdl, &volume_hdl);
+	if (volume_hdl)
+		leapraid_cfg_get_volume_wwid(adapter,
+					     volume_hdl,
+					     &volume_wwid);
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		return;
+	}
+
+	set_bit(hdl, adapter->dev_topo.pd_hdls);
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget = sas_dev->starget;
+		starget_priv = starget->hostdata;
+		starget_priv->flg |= LEAPRAID_TGT_FLG_RAID_MEMBER;
+		sas_dev->volume_hdl = volume_hdl;
+		sas_dev->volume_wwid = volume_wwid;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	if (starget) {
+		starget_for_each_device(starget,
+					(void *)LEAPRAID_NO_ULD_ATTACH_FLAG,
+					leapraid_reprobe_lun);
+	}
+
+	leapraid_sdev_put(sas_dev);
+}
+
+static void leapraid_sas_pd_expose(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *starget = NULL;
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->phys_disk_dev_hdl);
+	if (!hdl || hdl > adapter->adapter_attr.features.max_dev_handle) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid device handle\n", __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_hdl(adapter, hdl);
+	if (!sas_dev) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s:%d: sas_dev not found, hdl=0x%x\n",
+			 __func__, __LINE__, hdl);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		return;
+	}
+
+	sas_dev->volume_hdl = 0;
+	sas_dev->volume_wwid = 0;
+	clear_bit(hdl, adapter->dev_topo.pd_hdls);
+	if (sas_dev->starget && sas_dev->starget->hostdata) {
+		starget = sas_dev->starget;
+		starget_priv = starget->hostdata;
+		starget_priv->flg &= ~LEAPRAID_TGT_FLG_RAID_MEMBER;
+		sas_dev->led_on = 0;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	if (starget) {
+		starget_for_each_device(starget,
+					LEAPRAID_ULD_ATTACH_FLAG,
+					leapraid_reprobe_lun);
+	}
+
+	leapraid_sdev_put(sas_dev);
+}
+
+static void leapraid_sas_vol_visibility(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct scsi_device *sdev;
+	bool reprobe_flg = false;
+	bool sdev_held = false;
+	unsigned long flags;
+	u16 hdl;
+	u8 rc;
+
+	hdl = le16_to_cpu(evt_data->vol_dev_hdl);
+	rc = evt_data->reason_code;
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, hdl);
+	if (!raid_volume) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s:%d: Volume handle 0x%x not found\n",
+			 __func__, __LINE__, hdl);
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	sdev = raid_volume->sdev;
+	if (!sdev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+		leapraid_raid_volume_put(raid_volume);
+		dev_warn(&adapter->pdev->dev,
+			 "%s:%d: Volume handle 0x%x has no sdev\n",
+			 __func__, __LINE__, hdl);
+		return;
+	}
+
+	if (sdev->no_uld_attach &&
+	    rc == LEAPRAID_EVT_IR_RC_VOLUME_UNHIDE) {
+		sdev->no_uld_attach = 0;
+		reprobe_flg = true;
+	} else if (!sdev->no_uld_attach &&
+		   rc == LEAPRAID_EVT_IR_RC_VOLUME_HIDE) {
+		sdev->no_uld_attach = 1;
+		reprobe_flg = true;
+	}
+
+	if (reprobe_flg && !scsi_device_get(sdev))
+		sdev_held = true;
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+	leapraid_raid_volume_put(raid_volume);
+
+	if (!reprobe_flg) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s:rc(0x%x): Request matches, skipping\n",
+			 __func__, rc);
+		return;
+	}
+
+	if (!sdev_held) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed to hold sdev for reprobe, hdl=0x%x\n",
+			 __func__, hdl);
+		return;
+	}
+
+	if (sdev->no_uld_attach)
+		sdev_printk(KERN_INFO, sdev, "hide vol\n");
+	else
+		sdev_printk(KERN_INFO, sdev, "unhide vol\n");
+
+	WARN_ON(scsi_device_reprobe(sdev));
+	scsi_device_put(sdev);
+}
+
+static void leapraid_sas_volume_add(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	struct leapraid_raid_volume *raid_volume;
+	unsigned long flags;
+	u64 wwid;
+	u16 hdl;
+
+	hdl = le16_to_cpu(evt_data->vol_dev_hdl);
+
+	if (leapraid_cfg_get_volume_wwid(adapter, hdl, &wwid)) {
+		dev_warn(&adapter->pdev->dev, "Failed to read volume page1\n");
+		return;
+	}
+
+	if (!wwid) {
+		dev_warn(&adapter->pdev->dev, "Invalid WWID(handle=0x%x)\n",
+			 hdl);
+		return;
+	}
+
+	raid_volume = leapraid_raid_volume_find_by_wwid(adapter, wwid);
+	if (raid_volume) {
+		dev_warn(&adapter->pdev->dev,
+			 "Volume handle 0x%x already exists\n", hdl);
+		leapraid_raid_volume_put(raid_volume);
+		return;
+	}
+
+	raid_volume = kzalloc(sizeof(*raid_volume), GFP_KERNEL);
+	if (!raid_volume)
+		return;
+
+	INIT_LIST_HEAD(&raid_volume->list);
+	kref_init(&raid_volume->refcnt);
+	raid_volume->id = adapter->dev_topo.sas_id++;
+	raid_volume->channel = RAID_CHANNEL;
+	raid_volume->hdl = hdl;
+	raid_volume->wwid = wwid;
+	leapraid_raid_volume_add(adapter, raid_volume);
+	if (!adapter->scan_dev_desc.wait_scan_dev_done) {
+		if (scsi_add_device(adapter->shost, RAID_CHANNEL,
+				    raid_volume->id, 0))
+			leapraid_raid_volume_remove(adapter, raid_volume);
+		dev_info(&adapter->pdev->dev,
+			 "add RAID volume: hdl=0x%x, wwid=0x%llx\n", hdl, wwid);
+	} else {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		leapraid_check_boot_dev(adapter, raid_volume, RAID_CHANNEL);
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+	}
+	leapraid_raid_volume_put(raid_volume);
+}
+
+static void leapraid_sas_volume_delete_by_ptr(
+		struct leapraid_adapter *adapter,
+		struct leapraid_raid_volume *raid_volume)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct scsi_target *starget = NULL;
+	unsigned long flags;
+	bool in_list;
+
+	if (!raid_volume)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	in_list = !list_empty(&raid_volume->list);
+	if (in_list && raid_volume->starget) {
+		starget = raid_volume->starget;
+		starget_priv = starget->hostdata;
+		if (starget_priv)
+			starget_priv->deleted = 1;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	if (!in_list)
+		return;
+
+	dev_info(&adapter->pdev->dev,
+		 "delete RAID volume: hdl=0x%x, wwid=0x%llx\n",
+		 raid_volume->hdl, raid_volume->wwid);
+	leapraid_raid_volume_remove(adapter, raid_volume);
+
+	if (starget)
+		scsi_remove_target(&starget->dev);
+}
+
+static void leapraid_sas_volume_delete(struct leapraid_adapter *adapter,
+				       u16 hdl)
+{
+	struct leapraid_raid_volume *raid_volume;
+
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, hdl);
+	if (!raid_volume) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s:%d: Volume handle 0x%x not found\n",
+			 __func__, __LINE__, hdl);
+		return;
+	}
+
+	leapraid_sas_volume_delete_by_ptr(adapter, raid_volume);
+	leapraid_raid_volume_put(raid_volume);
+}
+
+static void leapraid_sas_ir_chg_evt(struct leapraid_adapter *adapter,
+				    struct leapraid_fw_evt_work *fw_evt)
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
+					   le16_to_cpu(evt_data->vol_dev_hdl));
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
+	case LEAPRAID_EVT_IR_RC_VOLUME_HIDE:
+	case LEAPRAID_EVT_IR_RC_VOLUME_UNHIDE:
+		leapraid_sas_vol_visibility(adapter, evt_data);
+		break;
+	default:
+		break;
+	}
+}
+
+static void leapraid_sas_enc_dev_stat_add_node(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_enc_node *enc_node;
+	struct leapraid_enc_node *enc_exist;
+	unsigned long flags;
+	int rc;
+
+	enc_node = kzalloc_obj(*enc_node);
+	if (!enc_node)
+		return;
+
+	cfgp1.form = LEAPRAID_SAS_ENC_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	rc = leapraid_op_config_page(adapter, &enc_node->pg0, cfgp1, cfgp2,
+				     GET_SAS_ENCLOSURE_PG0);
+	if (rc) {
+		kfree(enc_node);
+		return;
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+	enc_exist = leapraid_enc_find_by_hdl(adapter, hdl);
+	if (enc_exist) {
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+		kfree(enc_node);
+		return;
+	}
+	list_add_tail(&enc_node->list, &adapter->dev_topo.enc_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+}
+
+static void leapraid_sas_enc_dev_stat_del_node(
+		struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_enc_node *enc_node;
+	unsigned long flags;
+
+	if (!hdl)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+	enc_node = leapraid_enc_find_by_hdl(adapter, hdl);
+	if (enc_node)
+		list_del(&enc_node->list);
+	spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+
+	kfree(enc_node);
+}
+
+static void leapraid_sas_enc_dev_stat_chg_evt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_evt_data_sas_enc_dev_status_change *evt_data;
+	u16 enc_hdl;
+
+	if (adapter->access_ctrl.shost_recovering)
+		return;
+
+	evt_data = fw_evt->evt_data;
+	enc_hdl = le16_to_cpu(evt_data->enc_hdl);
+	switch (evt_data->reason_code) {
+	case LEAPRAID_EVT_SAS_ENCL_RC_ADDED:
+		if (enc_hdl)
+			leapraid_sas_enc_dev_stat_add_node(adapter, enc_hdl);
+		break;
+	case LEAPRAID_EVT_SAS_ENCL_RC_NOT_RESPONDING:
+		leapraid_sas_enc_dev_stat_del_node(adapter, enc_hdl);
+		break;
+	default:
+		break;
+	}
+}
+
+static void leapraid_remove_unresp_sas_end_dev(
+		struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev, *sas_dev_next;
+	unsigned long flags;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	list_for_each_entry_safe(sas_dev, sas_dev_next,
+				 &adapter->dev_topo.sas_dev_init_list, list) {
+		if (sas_dev->rphy || sas_dev->pend_sas_rphy_add)
+			continue;
+
+		list_del_init(&sas_dev->list);
+		leapraid_clear_cached_boot_dev(adapter, sas_dev, 0);
+		leapraid_sdev_put(sas_dev);
+	}
+	list_for_each_entry_safe(sas_dev, sas_dev_next,
+				 &adapter->dev_topo.sas_dev_list, list) {
+		if (!sas_dev->resp)
+			list_move_tail(&sas_dev->list, &head);
+		else
+			sas_dev->resp = 0;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	list_for_each_entry_safe(sas_dev, sas_dev_next, &head, list) {
+		leapraid_remove_device(adapter, sas_dev);
+		list_del_init(&sas_dev->list);
+		leapraid_sdev_put(sas_dev);
+	}
+
+	dev_warn(&adapter->pdev->dev,
+		 "Unresponsive SAS end devices removed\n");
+}
+
+static void leapraid_remove_unresp_raid_volumes(
+		struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+	struct leapraid_raid_volume *raid_volume, *raid_volume_next;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_for_each_entry_safe(raid_volume, raid_volume_next,
+				 &adapter->dev_topo.raid_volume_list, list) {
+		if (!raid_volume->resp)
+			list_move_tail(&raid_volume->list, &head);
+		else
+			raid_volume->resp = 0;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	list_for_each_entry_safe(raid_volume, raid_volume_next, &head, list) {
+		leapraid_sas_volume_delete_by_ptr(adapter, raid_volume);
+	}
+
+	dev_warn(&adapter->pdev->dev,
+		 "Unresponsive RAID volumes removed\n");
+}
+
+static void leapraid_remove_unresp_sas_exp(struct leapraid_adapter *adapter)
+{
+	struct leapraid_topo_node *topo_node_exp, *topo_node_exp_next;
+	unsigned long flags;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
+				 &adapter->dev_topo.exp_list, list) {
+		if (!topo_node_exp->resp)
+			list_move_tail(&topo_node_exp->list, &head);
+		else
+			topo_node_exp->resp = 0;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	list_for_each_entry_safe(topo_node_exp, topo_node_exp_next,
+				 &head, list)
+		leapraid_exp_node_rm(adapter, topo_node_exp);
+
+	dev_warn(&adapter->pdev->dev,
+		 "Unresponsive SAS expanders removed\n");
+}
+
+static void leapraid_remove_unresp_dev(struct leapraid_adapter *adapter)
+{
+	leapraid_remove_unresp_sas_end_dev(adapter);
+	if (adapter->adapter_attr.raid_support)
+		leapraid_remove_unresp_raid_volumes(adapter);
+	leapraid_remove_unresp_sas_exp(adapter);
+	leapraid_ublk_io_all_dev(adapter);
+}
+
+static void leapraid_del_dirty_vphy(struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	list_for_each_entry_safe(card_port, card_port_next,
+				 &adapter->dev_topo.card_port_list, list) {
+		if (!card_port->vphys_mask)
+			continue;
+
+		list_for_each_entry_safe(vphy, vphy_next,
+					 &card_port->vphys_list, list) {
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
+static void leapraid_del_dirty_card_port(struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+
+	list_for_each_entry_safe(card_port, card_port_next,
+				 &adapter->dev_topo.card_port_list, list) {
+		if (!(card_port->flg & LEAPRAID_CARD_PORT_FLG_DIRTY) ||
+		    card_port->flg & LEAPRAID_CARD_PORT_FLG_NEW)
+			continue;
+
+		list_del(&card_port->list);
+		kfree(card_port);
+	}
+}
+
+static void leapraid_update_dev_qdepth(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_adapter_attr *attr;
+	struct scsi_device *sdev;
+	u16 qdepth;
+
+	attr = &adapter->adapter_attr;
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv || !sdev_priv->starget_priv)
+			continue;
+		sas_dev = sdev_priv->starget_priv->sas_dev;
+		if (sas_dev && sas_dev->dev_info & LEAPRAID_DEVTYP_SSP_TGT)
+			qdepth = (sas_dev->port_connection > 1) ?
+				attr->wideport_max_queue_depth :
+				attr->narrowport_max_queue_depth;
+		else if (sas_dev && sas_dev->dev_info &
+			 LEAPRAID_DEVTYP_SATA_DEV)
+			qdepth = attr->sata_max_queue_depth;
+		else
+			continue;
+
+		leapraid_change_queue_depth(sdev, qdepth);
+	}
+}
+
+static void leapraid_update_exp_links(struct leapraid_adapter *adapter,
+				      struct leapraid_topo_node *topo_node_exp,
+				      u16 hdl)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_exp_p1 exp_p1;
+	int i;
+
+	cfgp2.handle = hdl;
+	for (i = 0; i < topo_node_exp->phys_num; i++) {
+		cfgp1.phy_number = i;
+		if (leapraid_op_config_page(adapter, &exp_p1, cfgp1, cfgp2,
+					    GET_SAS_EXPANDER_PG1))
+			return;
+
+		leapraid_transport_update_links(
+			adapter,
+			topo_node_exp->sas_address,
+			le16_to_cpu(exp_p1.attached_dev_hdl),
+			i,
+			exp_p1.neg_link_rate >>
+				LEAPRAID_SAS_NEG_LINK_RATE_SHIFT,
+			topo_node_exp->card_port);
+	}
+}
+
+static void leapraid_scan_exp_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_topo_node *topo_node_exp;
+	struct leapraid_exp_p0 exp_p0;
+	unsigned long flags;
+	u16 hdl;
+	u8 port_id;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+	     !leapraid_op_config_page(adapter, &exp_p0, cfgp1, cfgp2,
+				      GET_SAS_EXPANDER_PG0);
+	     cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(exp_p0.dev_hdl);
+		port_id = exp_p0.physical_port;
+		spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+		topo_node_exp =
+			leapraid_exp_find_by_sas_address(
+				adapter,
+				le64_to_cpu(exp_p0.sas_address),
+				leapraid_get_port_by_id(adapter,
+							port_id,
+							false));
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
+
+		if (topo_node_exp) {
+			leapraid_update_exp_links(adapter, topo_node_exp, hdl);
+		} else {
+			leapraid_exp_add(adapter, hdl);
+
+			dev_info(&adapter->pdev->dev,
+				 "add exp: hdl=0x%04x, SAS addr=0x%016llx\n",
+				 hdl,
+				 (unsigned long long)le64_to_cpu(
+					exp_p0.sas_address));
+		}
+	}
+}
+
+static void leapraid_scan_phy_disks_after_reset(
+		struct leapraid_adapter *adapter)
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
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (phys_disk_num = 0xFF, cfgp2.form_specific = phys_disk_num;
+	     !leapraid_op_config_page(adapter, &raidpd_p0,
+				      cfgp1, cfgp2, GET_PHY_DISK_PG0);
+	     cfgp2.form_specific = phys_disk_num) {
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
+		if (leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1_extra,
+					    cfgp2_extra, GET_SAS_DEVICE_PG0) !=
+					    0)
+			continue;
+
+		parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+		if (!leapraid_get_sas_address(adapter,
+					      parent_hdl,
+					      &sas_addr)) {
+			port_id = sas_dev_p0.physical_port;
+			leapraid_transport_update_links(
+				adapter, sas_addr, hdl,
+				sas_dev_p0.phy_num,
+				LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+				leapraid_get_port_by_id(
+					adapter, port_id, false));
+			if (!hdl || hdl >
+			    adapter->adapter_attr.features.max_dev_handle) {
+				dev_warn(&adapter->pdev->dev,
+					 "%s: Invalid device handle\n",
+					 __func__);
+			} else {
+				set_bit(hdl, adapter->dev_topo.pd_hdls);
+				leapraid_add_dev(adapter, hdl);
+
+				dev_info(&adapter->pdev->dev,
+					 "add pd hdl=0x%04x saddr=0x%016llx\n",
+					 hdl,
+					 (unsigned long long)le64_to_cpu(
+						sas_dev_p0.sas_address));
+			}
+		}
+	}
+}
+
+static void leapraid_scan_vol_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union cfg_param_1 cfgp1_extra = {0};
+	union cfg_param_2 cfgp2_extra = {0};
+	struct leapraid_evt_data_ir_change evt_data;
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_raidvol_p1 *vol_p1;
+	struct leapraid_raidvol_p0 *vol_p0;
+	u16 hdl;
+
+	vol_p0 = kzalloc_obj(*vol_p0);
+	if (!vol_p0)
+		return;
+
+	vol_p1 = kzalloc_obj(*vol_p1);
+	if (!vol_p1) {
+		kfree(vol_p0);
+		return;
+	}
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+	     !leapraid_op_config_page(adapter, vol_p1, cfgp1,
+				      cfgp2, GET_RAID_VOLUME_PG1);
+	     cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(vol_p1->dev_hdl);
+		raid_volume = leapraid_raid_volume_find_by_wwid(
+				adapter,
+				le64_to_cpu(vol_p1->wwid));
+		if (raid_volume) {
+			leapraid_raid_volume_put(raid_volume);
+			continue;
+		}
+
+		cfgp1_extra.size = sizeof(struct leapraid_raidvol_p0);
+		cfgp2_extra.handle = hdl;
+		if (leapraid_op_config_page(adapter, vol_p0, cfgp1_extra,
+					    cfgp2_extra, GET_RAID_VOLUME_PG0))
+			continue;
+
+		if (vol_p0->volume_state == LEAPRAID_VOL_STATE_OPTIMAL ||
+		    vol_p0->volume_state == LEAPRAID_VOL_STATE_ONLINE ||
+		    vol_p0->volume_state == LEAPRAID_VOL_STATE_DEGRADED) {
+			memset(&evt_data, 0,
+			       sizeof(struct leapraid_evt_data_ir_change));
+			evt_data.reason_code = LEAPRAID_EVT_IR_RC_VOLUME_ADD;
+			evt_data.vol_dev_hdl = vol_p1->dev_hdl;
+			leapraid_sas_volume_add(adapter, &evt_data);
+			dev_info(&adapter->pdev->dev,
+				 "add volume: hdl=0x%04x\n",
+				 vol_p1->dev_hdl);
+		}
+	}
+
+	kfree(vol_p0);
+	kfree(vol_p1);
+}
+
+static void leapraid_scan_sas_dev_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	struct leapraid_sas_dev *sas_dev;
+	u16 hdl, parent_hdl;
+	u64 sas_address;
+	u8 port_id;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+	     !leapraid_op_config_page(adapter, &sas_dev_p0, cfgp1, cfgp2,
+				      GET_SAS_DEVICE_PG0);
+	     cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(sas_dev_p0.dev_hdl);
+		if (!hdl ||
+		    hdl > adapter->adapter_attr.features.max_dev_handle) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Invalid device handle\n", __func__);
+			continue;
+		}
+
+		if (!(leapraid_is_end_dev(le32_to_cpu(sas_dev_p0.dev_info))))
+			continue;
+
+		port_id = sas_dev_p0.physical_port;
+		sas_dev = leapraid_get_sas_dev_by_addr(
+				adapter,
+				le64_to_cpu(sas_dev_p0.sas_address),
+				leapraid_get_port_by_id(
+					adapter,
+					port_id,
+					false));
+		if (sas_dev) {
+			leapraid_sdev_put(sas_dev);
+			continue;
+		}
+
+		parent_hdl = le16_to_cpu(sas_dev_p0.parent_dev_hdl);
+		if (!leapraid_get_sas_address(adapter, parent_hdl,
+					      &sas_address)) {
+			leapraid_transport_update_links(
+				adapter,
+				sas_address,
+				hdl,
+				sas_dev_p0.phy_num,
+				LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+				leapraid_get_port_by_id(adapter,
+							port_id,
+							false));
+			leapraid_add_dev(adapter, hdl);
+			dev_info(&adapter->pdev->dev,
+				 "Add SAS dev: hdl=0x%04x, saddr=0x%016llx\n",
+				 hdl,
+				 (unsigned long long)le64_to_cpu(
+					sas_dev_p0.sas_address));
+		}
+	}
+}
+
+static void leapraid_scan_all_dev_after_reset(struct leapraid_adapter *adapter)
+{
+	leapraid_sas_host_add(adapter, adapter->dev_topo.card.phys_num > 0);
+	leapraid_scan_exp_after_reset(adapter);
+	if (adapter->adapter_attr.raid_support) {
+		leapraid_scan_phy_disks_after_reset(adapter);
+		leapraid_scan_vol_after_reset(adapter);
+	}
+	leapraid_scan_sas_dev_after_reset(adapter);
+}
+
+static void leapraid_hardreset_async_logic(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	leapraid_remove_unresp_dev(adapter);
+	leapraid_del_dirty_vphy(adapter);
+	leapraid_del_dirty_card_port(adapter);
+	leapraid_update_dev_qdepth(adapter);
+	leapraid_scan_all_dev_after_reset(adapter);
+
+	if (adapter->scan_dev_desc.driver_loading)
+		leapraid_scan_dev_done(adapter);
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	adapter->access_ctrl.shost_recover_async = 0;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+	wake_up(&adapter->access_ctrl.shost_recover_wq);
+}
+
+static int leapraid_send_enc_cmd(struct leapraid_adapter *adapter,
+				 struct leapraid_sep_rep *sep_rep,
+				 struct leapraid_sep_req *sep_req)
+{
+	void *req;
+	bool reset_flg = false;
+	int rc;
+	u16 smid;
+
+	mutex_lock(&adapter->driver_cmds.enc_cmd.mutex);
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					  __func__);
+	if (rc)
+		goto unlock;
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_PENDING;
+	smid = adapter->driver_cmds.enc_cmd.inter_taskid;
+	req = leapraid_get_task_desc(adapter, smid);
+	memset(req, 0, LEAPRAID_REQUEST_SIZE);
+	memcpy(req, sep_req, sizeof(struct leapraid_sep_req));
+	init_completion(&adapter->driver_cmds.enc_cmd.done);
+	leapraid_fire_task(adapter, smid);
+	wait_for_completion_timeout(&adapter->driver_cmds.enc_cmd.done,
+				    LEAPRAID_ENC_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.enc_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: SEP command timeout, status=0x%x\n",
+			__func__, adapter->driver_cmds.enc_cmd.status);
+		leapraid_log_req_context(adapter, smid, sep_req);
+		reset_flg =
+			leapraid_check_reset(
+				adapter->driver_cmds.enc_cmd.status);
+		rc = -EFAULT;
+		goto do_hard_reset;
+	}
+
+	if (adapter->driver_cmds.enc_cmd.status & LEAPRAID_CMD_REPLY_VALID)
+		memcpy(sep_rep, &adapter->driver_cmds.enc_cmd.reply,
+		       sizeof(struct leapraid_sep_rep));
+do_hard_reset:
+	if (reset_flg) {
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		leapraid_hard_reset_handler(adapter, FULL_RESET);
+	}
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_NOT_USED;
+unlock:
+	mutex_unlock(&adapter->driver_cmds.enc_cmd.mutex);
+	return rc;
+}
+
+static void leapraid_set_led(struct leapraid_adapter *adapter,
+			     struct leapraid_sas_dev *sas_dev, bool on)
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
+		u32 status = LEAPRAID_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT;
+
+		sep_req.slot_status = cpu_to_le32(status);
+		sep_req.dev_hdl = cpu_to_le16(sas_dev->hdl);
+		sep_req.flg = LEAPRAID_SEP_REQ_FLG_DEVHDL_ADDRESS;
+		if (leapraid_send_enc_cmd(adapter, &sep_rep, &sep_req)) {
+			leapraid_sdev_put(sas_dev);
+			return;
+		}
+
+		sas_dev->led_on = 1;
+		leapraid_sdev_put(sas_dev);
+	} else {
+		sep_req.slot_status = 0;
+		sep_req.slot = cpu_to_le16(sas_dev->slot);
+		sep_req.dev_hdl = 0;
+		sep_req.enc_hdl = cpu_to_le16(sas_dev->enc_hdl);
+		sep_req.flg = LEAPRAID_SEP_REQ_FLG_ENCLOSURE_SLOT_ADDRESS;
+		leapraid_send_enc_cmd(adapter, &sep_rep, &sep_req);
+	}
+}
+
+static int leapraid_wait_adapter_recovery(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	while (leapraid_shost_in_recovery(adapter->shost) ||
+	       READ_ONCE(adapter->access_ctrl.shost_recovering)) {
+		if (READ_ONCE(adapter->access_ctrl.host_removing) ||
+		    READ_ONCE(adapter->fw_evt_s.fw_evt_cleanup)) {
+			spin_lock_irqsave(
+				&adapter->reset_desc.adapter_reset_lock,
+				flags);
+			adapter->access_ctrl.shost_recover_async = 0;
+			spin_unlock_irqrestore(
+				&adapter->reset_desc.adapter_reset_lock,
+				flags);
+
+			wake_up(&adapter->access_ctrl.shost_recover_wq);
+
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Failed, shost %d, host %d\n",
+				 __func__,
+				 adapter->access_ctrl.shost_recovering,
+				 adapter->access_ctrl.host_removing);
+
+			return -EFAULT;
+		}
+
+		wait_event_timeout(
+			adapter->access_ctrl.recovery_waitq,
+			(!leapraid_shost_in_recovery(adapter->shost) &&
+			 !READ_ONCE(adapter->access_ctrl.shost_recovering)),
+			msecs_to_jiffies(1000));
+	}
+
+	return 0;
+}
+
+static void leapraid_fw_work(struct leapraid_adapter *adapter,
+			     struct leapraid_fw_evt_work *fw_evt)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	adapter->fw_evt_s.cur_evt = fw_evt;
+	adapter->fw_evt_s.cur_evt_task = current;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	leapraid_del_fw_evt_from_list(adapter, fw_evt);
+	if (adapter->access_ctrl.host_removing ||
+	    adapter->access_ctrl.pcie_recovering) {
+		spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+		leapraid_fw_evt_put(fw_evt);
+		adapter->fw_evt_s.cur_evt = NULL;
+		adapter->fw_evt_s.cur_evt_task = NULL;
+		spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+		return;
+	}
+	switch (fw_evt->evt_type) {
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
+		if (leapraid_wait_adapter_recovery(adapter))
+			goto out_cleanup;
+
+		leapraid_hardreset_async_logic(adapter);
+		break;
+	case LEAPRAID_EVT_TURN_ON_PFA_LED:
+		sas_dev = leapraid_get_sas_dev_by_hdl(adapter,
+						      fw_evt->dev_handle);
+		leapraid_set_led(adapter, sas_dev, true);
+		break;
+	case LEAPRAID_EVT_SCAN_DEV_DONE:
+		adapter->scan_dev_desc.scan_start = 0;
+		break;
+	default:
+		break;
+	}
+out_cleanup:
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	leapraid_fw_evt_put(fw_evt);
+	adapter->fw_evt_s.cur_evt = NULL;
+	adapter->fw_evt_s.cur_evt_task = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+}
+
+static void leapraid_sas_dev_stat_chg_evt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_sas_dev_status_change *event_data)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sas_dev *sas_dev;
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
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(
+			adapter,
+			sas_address,
+			leapraid_get_port_by_id(adapter,
+						event_data->physical_port,
+						false));
+	if (!sas_dev || !sas_dev->starget)
+		goto out_unlock;
+
+	starget_priv = sas_dev->starget->hostdata;
+	if (starget_priv) {
+		switch (event_data->reason_code) {
+		case LEAPRAID_EVT_SAS_DEV_STAT_RC_INTERNAL_DEV_RESET:
+			starget_priv->tm_busy = 1;
+			break;
+		case LEAPRAID_EVT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET:
+			starget_priv->tm_busy = 0;
+			break;
+		}
+	}
+
+out_unlock:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void leapraid_set_volume_delete_flag(struct leapraid_adapter *adapter,
+					    u16 handle)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *sas_target_priv_data;
+	unsigned long flags;
+
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, handle);
+	if (raid_volume) {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		if (raid_volume->starget &&
+		    raid_volume->starget->hostdata) {
+			sas_target_priv_data = raid_volume->starget->hostdata;
+			sas_target_priv_data->deleted = 1;
+		}
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+		leapraid_raid_volume_put(raid_volume);
+	}
+}
+
+static void leapraid_check_ir_change_evt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_ir_change *evt_data)
+{
+	u16 phys_disk_dev_hdl;
+
+	switch (evt_data->reason_code) {
+	case LEAPRAID_EVT_IR_RC_VOLUME_DELETE:
+		leapraid_set_volume_delete_flag(
+			adapter,
+			le16_to_cpu(evt_data->vol_dev_hdl));
+		break;
+	case LEAPRAID_EVT_IR_RC_PD_UNHIDDEN_TO_DELETE:
+		phys_disk_dev_hdl =
+			le16_to_cpu(evt_data->phys_disk_dev_hdl);
+		if (!phys_disk_dev_hdl ||
+		    phys_disk_dev_hdl >
+		    adapter->adapter_attr.features.max_dev_handle) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Invalid device handle\n", __func__);
+		} else {
+			clear_bit(phys_disk_dev_hdl,
+				  adapter->dev_topo.pd_hdls);
+			leapraid_tgt_rst_send(adapter, phys_disk_dev_hdl);
+		}
+		break;
+	}
+}
+
+static void leapraid_topo_del_evts_process_exp_status(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_sas_topo_change_list *evt_data)
+{
+	struct leapraid_fw_evt_work *fw_evt = NULL;
+	struct leapraid_evt_data_sas_topo_change_list *loc_evt_data;
+	unsigned long flags;
+	u16 exp_hdl;
+
+	exp_hdl = le16_to_cpu(evt_data->exp_dev_hdl);
+
+	switch (evt_data->exp_status) {
+	case LEAPRAID_EVT_SAS_TOPO_ES_NOT_RESPONDING:
+		spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+		list_for_each_entry(fw_evt,
+				    &adapter->fw_evt_s.fw_evt_list, list) {
+			if (fw_evt->evt_type !=
+			    LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST ||
+			    fw_evt->ignore)
+				continue;
+
+			loc_evt_data = fw_evt->evt_data;
+			if ((loc_evt_data->exp_status ==
+			     LEAPRAID_EVT_SAS_TOPO_ES_ADDED ||
+			     loc_evt_data->exp_status ==
+			     LEAPRAID_EVT_SAS_TOPO_ES_RESPONDING) &&
+			    le16_to_cpu(loc_evt_data->exp_dev_hdl) == exp_hdl)
+				fw_evt->ignore = 1;
+		}
+		spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+		break;
+	default:
+		break;
+	}
+}
+
+static void leapraid_check_topo_del_evts(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_data_sas_topo_change_list *evt_data)
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
+		reason_code = evt_data->phy[i].phy_status &
+				LEAPRAID_EVT_SAS_TOPO_RC_MASK;
+		if (reason_code ==
+		    LEAPRAID_EVT_SAS_TOPO_RC_TARG_NOT_RESPONDING)
+			leapraid_tgt_not_responding(adapter, hdl);
+	}
+	leapraid_topo_del_evts_process_exp_status(adapter, evt_data);
+}
+
+static bool leapraid_async_process_evt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_notify_rep *event_notify_rep)
+{
+	u16 evt = le16_to_cpu(event_notify_rep->evt);
+	bool exit_flag = false;
+
+	switch (evt) {
+	case LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE:
+		leapraid_sas_dev_stat_chg_evt(
+			adapter,
+			(struct leapraid_evt_data_sas_dev_status_change
+				*)event_notify_rep->evt_data);
+		break;
+	case LEAPRAID_EVT_IR_CHANGE:
+		leapraid_check_ir_change_evt(
+			adapter,
+			(struct leapraid_evt_data_ir_change
+				*)event_notify_rep->evt_data);
+		break;
+	case LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST:
+		leapraid_check_topo_del_evts(
+			adapter,
+			(struct leapraid_evt_data_sas_topo_change_list
+				*)event_notify_rep->evt_data);
+		if (adapter->access_ctrl.shost_recovering) {
+			exit_flag = true;
+			return exit_flag;
+		}
+		break;
+	case LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE:
+		break;
+	default:
+		exit_flag = true;
+		return exit_flag;
+	}
+
+	return exit_flag;
+}
+
+static void leapraid_async_evt_cb_enqueue(
+		struct leapraid_adapter *adapter,
+		struct leapraid_evt_notify_rep *evt_notify_rep)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+	u16 evt_sz;
+
+	fw_evt = leapraid_alloc_fw_evt_work();
+	if (!fw_evt)
+		return;
+
+	evt_sz = le16_to_cpu(evt_notify_rep->evt_data_len) * sizeof(u32);
+	fw_evt->evt_data = kmemdup(evt_notify_rep->evt_data,
+				   evt_sz, GFP_ATOMIC);
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
+static void leapraid_async_evt_cb(struct leapraid_adapter *adapter,
+				  u8 msix_index, u32 rep_paddr)
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
+static void leapraid_handle_async_event(struct leapraid_adapter *adapter,
+					u8 msix_index, u32 reply)
+{
+	struct leapraid_evt_notify_rep *leap_mpi_rep =
+		leapraid_get_reply_vaddr(adapter, reply);
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
+void leapraid_async_turn_on_led(struct leapraid_adapter *adapter, u16 handle)
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
+static void leapraid_hardreset_barrier(struct leapraid_adapter *adapter)
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
+static void leapraid_scan_dev_complete(struct leapraid_adapter *adapter)
+{
+	struct leapraid_fw_evt_work *fw_evt;
+
+	fw_evt = leapraid_alloc_fw_evt_work();
+	if (!fw_evt)
+		return;
+
+	fw_evt->evt_type = LEAPRAID_EVT_SCAN_DEV_DONE;
+	fw_evt->adapter = adapter;
+	leapraid_fw_evt_add(adapter, fw_evt);
+	leapraid_fw_evt_put(fw_evt);
+}
+
+static void leapraid_handle_scan_cb(struct leapraid_adapter *adapter,
+				    struct leapraid_driver_cmd *cmd,
+				    struct leapraid_rep *rep)
+{
+	u16 status;
+
+	cmd->status &= ~LEAPRAID_CMD_PENDING;
+
+	status = le16_to_cpu(rep->adapter_status) &
+		 LEAPRAID_ADAPTER_STATUS_MASK;
+	if (status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
+		adapter->scan_dev_desc.scan_dev_failed = 1;
+
+	if (!cmd->async_scan_dev) {
+		complete(&cmd->done);
+		return;
+	}
+
+	if (status == LEAPRAID_ADAPTER_STATUS_SUCCESS)
+		leapraid_scan_dev_complete(adapter);
+	else
+		adapter->scan_dev_desc.scan_start_failed = status;
+}
+
+static void leapraid_handle_ctl_cb(struct leapraid_adapter *adapter,
+				   struct leapraid_rep *rep,
+				   u16 taskid)
+{
+	struct leapraid_scsiio_rep *scsiio_reply;
+
+	if (rep->function != LEAPRAID_FUNC_SCSIIO &&
+	    rep->function != LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH)
+		return;
+
+	scsiio_reply = (struct leapraid_scsiio_rep *)rep;
+	if (!(scsiio_reply->scsi_state &
+	      LEAPRAID_SCSI_STATE_AUTOSENSE_VALID))
+		return;
+
+	memcpy(&adapter->driver_cmds.ctl_cmd.sense,
+	       leapraid_get_sense_buffer(adapter, taskid),
+	       min_t(u32, SCSI_SENSE_BUFFERSIZE,
+		     le32_to_cpu(scsiio_reply->sense_count)));
+}
+
+static bool leapraid_driver_cmds_done(struct leapraid_adapter *adapter,
+				      u16 taskid, u8 msix_index,
+				      u32 rep_paddr, u8 cb_idx)
+{
+	struct leapraid_rep *leap_mpi_rep =
+		leapraid_get_reply_vaddr(adapter, rep_paddr);
+	struct leapraid_driver_cmd *sp_cmd, *_sp_cmd = NULL;
+	u8 reply_len;
+
+	list_for_each_entry(sp_cmd, &adapter->driver_cmds.special_cmd_list,
+			    list)
+		if (cb_idx == sp_cmd->cb_idx) {
+			_sp_cmd = sp_cmd;
+			break;
+		}
+
+	if (WARN_ON(!_sp_cmd))
+		return true;
+	if (WARN_ON(_sp_cmd->status == LEAPRAID_CMD_NOT_USED))
+		return true;
+	if (WARN_ON(taskid != _sp_cmd->hp_taskid &&
+		    taskid != _sp_cmd->taskid &&
+		    taskid != _sp_cmd->inter_taskid))
+		return true;
+	_sp_cmd->status |= LEAPRAID_CMD_DONE;
+	if (leap_mpi_rep) {
+		reply_len = leap_mpi_rep->msg_len * sizeof(u32);
+		if (reply_len > LEAPRAID_REPLY_SIZE)
+			reply_len = LEAPRAID_REPLY_SIZE;
+		memcpy(&_sp_cmd->reply, leap_mpi_rep, reply_len);
+		_sp_cmd->status |= LEAPRAID_CMD_REPLY_VALID;
+
+		if (_sp_cmd->cb_idx == LEAPRAID_SCAN_DEV_CB_IDX) {
+			leapraid_handle_scan_cb(adapter, _sp_cmd,
+						leap_mpi_rep);
+			return true;
+		}
+
+		if (_sp_cmd->cb_idx == LEAPRAID_CTL_CB_IDX)
+			leapraid_handle_ctl_cb(adapter, leap_mpi_rep, taskid);
+	}
+
+	_sp_cmd->status &= ~LEAPRAID_CMD_PENDING;
+	complete(&_sp_cmd->done);
+
+	return true;
+}
+
+static void leapraid_complete_task(struct leapraid_adapter *adapter,
+				   u16 taskid, u8 msix_idx, u32 rep)
+{
+	if (taskid <= adapter->shost->can_queue ||
+	    taskid == adapter->driver_cmds.driver_scsiio_cmd.taskid) {
+		if (leapraid_scsiio_done(adapter, taskid, msix_idx, rep))
+			leapraid_free_taskid(adapter, taskid);
+		return;
+	}
+
+	if (leapraid_driver_cmds_done(adapter, taskid, msix_idx, rep,
+				      leapraid_get_cb_idx(adapter, taskid)))
+		leapraid_free_taskid(adapter, taskid);
+}
+
+static void leapraid_request_descript_handler(
+		struct leapraid_adapter *adapter,
+		union leapraid_rep_desc_union *rpf,
+		u8 req_desc_type, u8 msix_idx)
+{
+	u32 rep;
+	u16 taskid;
+
+	rep = 0;
+	taskid = le16_to_cpu(rpf->dflt_rep.taskid);
+	switch (req_desc_type) {
+	case LEAPRAID_RPY_DESC_FLG_FP_SCSI_IO_SUCCESS:
+	case LEAPRAID_RPY_DESC_FLG_SCSI_IO_SUCCESS:
+		leapraid_complete_task(adapter, taskid, msix_idx, 0);
+		break;
+	case LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY:
+		rep = le32_to_cpu(rpf->addr_rep.rep_frame_addr);
+		if (rep > (u32)adapter->mem_desc.rep_msg_dma +
+			   adapter->adapter_attr.rep_msg_qd *
+			   LEAPRAID_REPLY_SIZE ||
+		    rep < (u32)adapter->mem_desc.rep_msg_dma)
+			rep = 0;
+
+		if (taskid)
+			leapraid_complete_task(adapter, taskid, msix_idx, rep);
+		else
+			leapraid_handle_async_event(adapter, msix_idx, rep);
+
+		if (!rep)
+			return;
+
+		adapter->rep_msg_host_idx =
+			(adapter->rep_msg_host_idx ==
+				(adapter->adapter_attr.rep_msg_qd - 1)) ?
+					0 : adapter->rep_msg_host_idx + 1;
+		adapter->mem_desc.rep_msg_addr[adapter->rep_msg_host_idx] =
+			cpu_to_le32(rep);
+		wmb(); /* Make sure that all write ops are in order */
+		writel(adapter->rep_msg_host_idx,
+		       &adapter->iomem_base->rep_msg_host_idx);
+
+		break;
+	default:
+		break;
+	}
+}
+
+int leapraid_rep_queue_handler(struct leapraid_rq *rq)
+{
+	struct leapraid_adapter *adapter = rq->adapter;
+	union leapraid_rep_desc_union *rep_desc;
+	u8 req_desc_type;
+	u64 finish_cmds;
+	u8 msix_idx;
+
+	msix_idx = rq->msix_idx;
+	finish_cmds = 0;
+	if (!atomic_add_unless(&rq->busy, LEAPRAID_BUSY_LIMIT,
+			       LEAPRAID_BUSY_LIMIT))
+		return finish_cmds;
+
+	rep_desc = &rq->rep_desc[rq->rep_post_host_idx];
+	req_desc_type = rep_desc->dflt_rep.rep_flg &
+				LEAPRAID_RPY_DESC_FLG_TYPE_MASK;
+	if (req_desc_type == LEAPRAID_RPY_DESC_FLG_UNUSED) {
+		atomic_dec(&rq->busy);
+		return finish_cmds;
+	}
+
+	for (;;) {
+		if (rep_desc->u.low == UINT_MAX ||
+		    rep_desc->u.high == UINT_MAX)
+			break;
+
+		leapraid_request_descript_handler(adapter, rep_desc,
+						  req_desc_type, msix_idx);
+		dev_dbg(&adapter->pdev->dev,
+			"LEAPRAID_SCSIIO: Handled Desc taskid %d, msix %d\n",
+			rep_desc->dflt_rep.taskid, msix_idx);
+		rep_desc->words = cpu_to_le64(ULLONG_MAX);
+		rq->rep_post_host_idx =
+			(rq->rep_post_host_idx ==
+				(adapter->adapter_attr.rep_desc_qd -
+					LEAPRAID_BUSY_LIMIT)) ?
+					0 : rq->rep_post_host_idx + 1;
+		req_desc_type =
+			rq->rep_desc[rq->rep_post_host_idx].dflt_rep.rep_flg &
+					LEAPRAID_RPY_DESC_FLG_TYPE_MASK;
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
+	writel(rq->rep_post_host_idx | ((msix_idx & LEAPRAID_MSIX_GROUP_MASK) <<
+					LEAPRAID_RPHI_MSIX_IDX_SHIFT),
+	       &adapter->iomem_base->rep_post_reg_idx[
+		       msix_idx / LEAPRAID_MSIX_GROUP_SIZE].idx);
+	atomic_dec(&rq->busy);
+	return finish_cmds;
+}
+
+static irqreturn_t leapraid_irq_handler(int irq, void *bus_id)
+{
+	struct leapraid_rq *rq = bus_id;
+	struct leapraid_adapter *adapter = rq->adapter;
+
+	dev_dbg(&adapter->pdev->dev,
+		"LEAPRAID_SCSIIO: Receive a interrupt, irq %d msix %d\n",
+		irq, rq->msix_idx);
+
+	if (adapter->mask_int)
+		return IRQ_NONE;
+
+	return (leapraid_rep_queue_handler(rq) > 0 ?
+		 IRQ_HANDLED : IRQ_NONE);
+}
+
+void leapraid_sync_irqs(struct leapraid_adapter *adapter, bool poll)
+{
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	unsigned int i;
+
+	if (!adapter->notification_desc.msix_enable)
+		return;
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.host_removing ||
+	    adapter->access_ctrl.pcie_recovering)
+		return;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		if (adapter->access_ctrl.shost_recovering ||
+		    adapter->access_ctrl.host_removing ||
+		    adapter->access_ctrl.pcie_recovering)
+			return;
+
+		if (int_rq->rq.msix_idx == 0)
+			continue;
+
+		synchronize_irq(pci_irq_vector(adapter->pdev,
+					       int_rq->rq.msix_idx));
+		if (poll)
+			leapraid_rep_queue_handler(&int_rq->rq);
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq =
+			&adapter->notification_desc.blk_mq_poll_rqs[i];
+		if (adapter->access_ctrl.shost_recovering ||
+		    adapter->access_ctrl.host_removing ||
+		    adapter->access_ctrl.pcie_recovering)
+			return;
+
+		if (blk_mq_poll_rq->rq.msix_idx == 0)
+			continue;
+
+		leapraid_rep_queue_handler(&blk_mq_poll_rq->rq);
+	}
+}
+
+void leapraid_mq_polling_pause(struct leapraid_adapter *adapter)
+{
+	struct leapraid_notification_desc *desc;
+	int iopoll_q_count;
+	int qid;
+
+	desc = &adapter->notification_desc;
+	iopoll_q_count = adapter->adapter_attr.rq_cnt - desc->iopoll_qdex;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(&desc->blk_mq_poll_rqs[qid].pause, 1);
+
+	for (qid = 0; qid < iopoll_q_count; qid++) {
+		while (atomic_read(&desc->blk_mq_poll_rqs[qid].busy)) {
+			cpu_relax();
+			udelay(LEAPRAID_IO_POLL_DELAY_US);
+		}
+	}
+}
+
+void leapraid_mq_polling_resume(struct leapraid_adapter *adapter)
+{
+	struct leapraid_notification_desc *desc;
+	int iopoll_q_count;
+	int qid;
+
+	desc = &adapter->notification_desc;
+	iopoll_q_count = adapter->adapter_attr.rq_cnt - desc->iopoll_qdex;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(&desc->blk_mq_poll_rqs[qid].pause, 0);
+}
+
+static int leapraid_unlock_host_diag(struct leapraid_adapter *adapter,
+				     u32 *host_diag)
+{
+	const u32 unlock_seq[] = {
+		LEAPRAID_WRSEQ_FLUSH_KEY_VALUE,
+		LEAPRAID_WRSEQ_1ST_KEY_VALUE,
+		LEAPRAID_WRSEQ_2ND_KEY_VALUE,
+		LEAPRAID_WRSEQ_3RD_KEY_VALUE,
+		LEAPRAID_WRSEQ_4TH_KEY_VALUE,
+		LEAPRAID_WRSEQ_5TH_KEY_VALUE,
+		LEAPRAID_WRSEQ_6TH_KEY_VALUE
+	};
+
+	const int max_retries = LEAPRAID_UNLOCK_RETRY_LIMIT;
+	int retry = 0;
+	unsigned int i;
+
+	*host_diag = 0;
+	while (retry++ <= max_retries) {
+		for (i = 0; i < ARRAY_SIZE(unlock_seq); i++)
+			writel(unlock_seq[i], &adapter->iomem_base->ws);
+
+		msleep(LEAPRAID_UNLOCK_SLEEP_MS);
+
+		*host_diag = leapraid_readl(&adapter->iomem_base->host_diag);
+		if (*host_diag & LEAPRAID_DIAG_WRITE_ENABLE)
+			return 0;
+	}
+
+	dev_err(&adapter->pdev->dev, "Try host reset timeout!\n");
+	return -EFAULT;
+}
+
+static int leapraid_host_diag_reset(struct leapraid_adapter *adapter)
+{
+	u32 host_diag;
+
+	pci_cfg_access_lock(adapter->pdev);
+
+	mutex_lock(&adapter->reset_desc.host_diag_mutex);
+	if (leapraid_unlock_host_diag(adapter, &host_diag))
+		goto out_cleanup;
+
+	writel(host_diag | LEAPRAID_DIAG_RESET,
+	       &adapter->iomem_base->host_diag);
+
+	msleep(LEAPRAID_MSLEEP_EXTRA_LONG_MS);
+	msleep(LEAPRAID_MSLEEP_NORMAL_MS);
+
+	host_diag = leapraid_readl(&adapter->iomem_base->host_diag);
+	if (host_diag == LEAPRAID_INVALID_HOST_DIAG_VAL ||
+	    host_diag & LEAPRAID_DIAG_RESET)
+		goto out_cleanup;
+
+	writel(0x0, &adapter->iomem_base->ws);
+	mutex_unlock(&adapter->reset_desc.host_diag_mutex);
+	if (!leapraid_wait_adapter_ready(adapter))
+		goto out_failed;
+
+	pci_cfg_access_unlock(adapter->pdev);
+	return 0;
+
+out_cleanup:
+	mutex_unlock(&adapter->reset_desc.host_diag_mutex);
+out_failed:
+	pci_cfg_access_unlock(adapter->pdev);
+	dev_err(&adapter->pdev->dev, "Host diag failed\n");
+	return -EFAULT;
+}
+
+static int leapraid_find_matching_port(
+		struct leapraid_card_port *card_port_table,
+		u8 count, u8 port_id, u64 sas_addr)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		if (card_port_table[i].port_id == port_id &&
+		    card_port_table[i].sas_address == sas_addr)
+			return i;
+
+	return LEAPRAID_INVALID_INDEX;
+}
+
+static u8 leapraid_fill_card_port_table(
+		struct leapraid_adapter *adapter,
+		struct leapraid_sas_io_unit_p0 *sas_iounit_p0,
+		struct leapraid_card_port *new_card_port_table)
+{
+	u8 port_entry_num = 0, port_id;
+	u16 attached_hdl;
+	u64 attached_sas_addr;
+	int i, idx;
+
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if (sas_iounit_p0->phy_info[i].neg_link_rate >>
+		    LEAPRAID_SAS_NEG_LINK_RATE_SHIFT <
+		    LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+			continue;
+
+		attached_hdl = le16_to_cpu(sas_iounit_p0->phy_info[i]
+					   .attached_dev_hdl);
+		if (leapraid_get_sas_address(adapter,
+					     attached_hdl,
+					     &attached_sas_addr) != 0)
+			continue;
+
+		port_id = sas_iounit_p0->phy_info[i].port;
+
+		idx = leapraid_find_matching_port(new_card_port_table,
+						  port_entry_num,
+						  port_id,
+						  attached_sas_addr);
+		if (idx >= 0) {
+			new_card_port_table[idx].phy_mask |= BIT(i);
+		} else {
+			new_card_port_table[port_entry_num].port_id = port_id;
+			new_card_port_table[port_entry_num].phy_mask = BIT(i);
+			new_card_port_table[port_entry_num].sas_address =
+				attached_sas_addr;
+			port_entry_num++;
+		}
+	}
+
+	return port_entry_num;
+}
+
+static u8 leapraid_set_new_card_port_table_after_reset(
+		struct leapraid_adapter *adapter,
+		struct leapraid_card_port *new_card_port_table)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_io_unit_p0 *sas_iounit_p0;
+	u8 port_entry_num = 0;
+	u16 sz;
+
+	sz = offsetof(struct leapraid_sas_io_unit_p0, phy_info) +
+		(adapter->dev_topo.card.phys_num *
+		 sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iounit_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_p0)
+		return port_entry_num;
+
+	cfgp1.size = sz;
+	if (leapraid_op_config_page(adapter, sas_iounit_p0, cfgp1, cfgp2,
+				    GET_SAS_IOUNIT_PG0) != 0)
+		goto out_free;
+
+	port_entry_num = leapraid_fill_card_port_table(adapter,
+						       sas_iounit_p0,
+						       new_card_port_table);
+out_free:
+	kfree(sas_iounit_p0);
+	return port_entry_num;
+}
+
+static void leapraid_update_existing_port(struct leapraid_adapter *adapter,
+					  struct leapraid_card_port *new_table,
+					  int entry_idx, int port_entry_num)
+{
+	struct leapraid_card_port *matched_card_port;
+	int matched_code;
+	int count, lcount = 0;
+	u64 sas_addr;
+	int i;
+
+	matched_code = leapraid_check_card_port(adapter,
+						&new_table[entry_idx],
+						&matched_card_port,
+						&count);
+
+	if (!matched_card_port)
+		return;
+
+	if (matched_code == SAME_PORT_WITH_PARTIALLY_CHANGED_PHYS ||
+	    matched_code == SAME_ADDR_WITH_PARTIALLY_CHANGED_PHYS) {
+		leapraid_add_or_del_phys_from_existing_port(adapter,
+							    matched_card_port,
+							    new_table,
+							    entry_idx,
+							    port_entry_num);
+	} else if (matched_code == SAME_ADDR_ONLY) {
+		sas_addr = new_table[entry_idx].sas_address;
+		for (i = 0; i < port_entry_num; i++)
+			if (new_table[i].sas_address == sas_addr)
+				lcount++;
+
+		if (count > 1 || lcount > 1)
+			return;
+
+		leapraid_add_or_del_phys_from_existing_port(adapter,
+							    matched_card_port,
+							    new_table,
+							    entry_idx,
+							    port_entry_num);
+	}
+
+	if (matched_card_port->port_id != new_table[entry_idx].port_id)
+		matched_card_port->port_id = new_table[entry_idx].port_id;
+
+	matched_card_port->flg &= ~LEAPRAID_CARD_PORT_FLG_DIRTY;
+	matched_card_port->phy_mask = new_table[entry_idx].phy_mask;
+}
+
+static void leapraid_update_card_port_after_reset(
+		struct leapraid_adapter *adapter)
+{
+	struct leapraid_card_port *new_card_port_table;
+	struct leapraid_card_port *matched_card_port;
+	u8 port_entry_num;
+	u8 nr_phys;
+	int i;
+
+	if (leapraid_get_adapter_phys(adapter, &nr_phys) || !nr_phys)
+		return;
+
+	if (!adapter->dev_topo.card.card_phy) {
+		adapter->dev_topo.card.card_phy =
+			kcalloc(nr_phys, sizeof(struct leapraid_card_phy),
+				GFP_KERNEL);
+		if (!adapter->dev_topo.card.card_phy)
+			return;
+	}
+
+	adapter->dev_topo.card.phys_num = nr_phys;
+
+	new_card_port_table = kcalloc(adapter->dev_topo.card.phys_num,
+				      sizeof(struct leapraid_card_port),
+				      GFP_KERNEL);
+	if (!new_card_port_table)
+		return;
+
+	port_entry_num =
+		leapraid_set_new_card_port_table_after_reset(
+			adapter,
+			new_card_port_table);
+	if (!port_entry_num)
+		goto out_free_port_table;
+
+	list_for_each_entry(matched_card_port,
+			    &adapter->dev_topo.card_port_list, list)
+		matched_card_port->flg |= LEAPRAID_CARD_PORT_FLG_DIRTY;
+
+	matched_card_port = NULL;
+	for (i = 0; i < port_entry_num; i++)
+		leapraid_update_existing_port(adapter,
+					      new_card_port_table,
+					      i, port_entry_num);
+out_free_port_table:
+	kfree(new_card_port_table);
+}
+
+static bool leapraid_is_valid_vphy(
+		struct leapraid_adapter *adapter,
+		struct leapraid_sas_io_unit_p0 *sas_io_unit_p0,
+		int phy_index)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_phy_p0 phy_p0;
+	u32 dev_info;
+
+	if (sas_io_unit_p0->phy_info[phy_index].neg_link_rate >>
+	    LEAPRAID_SAS_NEG_LINK_RATE_SHIFT <
+	    LEAPRAID_SAS_NEG_LINK_RATE_1_5)
+		return false;
+
+	dev_info = le32_to_cpu(sas_io_unit_p0->phy_info[phy_index]
+			       .controller_phy_dev_info);
+	if (!(dev_info & LEAPRAID_DEVTYP_SEP))
+		return false;
+
+	cfgp1.phy_number = phy_index;
+	if (leapraid_op_config_page(adapter, &phy_p0, cfgp1, cfgp2,
+				    GET_PHY_PG0))
+		return false;
+
+	if (!(le32_to_cpu(phy_p0.phy_info) & LEAPRAID_SAS_PHYINFO_VPHY))
+		return false;
+
+	return true;
+}
+
+static void leapraid_update_vphy_binding(struct leapraid_adapter *adapter,
+					 struct leapraid_card_port *card_port,
+					 struct leapraid_vphy *vphy,
+					 int phy_index, u8 may_new_port_id,
+					 u64 attached_sas_addr)
+{
+	struct leapraid_card_port *may_new_card_port;
+	struct leapraid_sas_dev *sas_dev;
+
+	may_new_card_port = leapraid_get_port_by_id(adapter,
+						    may_new_port_id,
+						    true);
+	if (!may_new_card_port) {
+		may_new_card_port = kzalloc_obj(*may_new_card_port);
+		if (!may_new_card_port)
+			return;
+		may_new_card_port->port_id = may_new_port_id;
+		dev_err(&adapter->pdev->dev,
+			"%s: New card port %p added, port=%d\n",
+			__func__, may_new_card_port, may_new_port_id);
+		list_add_tail(&may_new_card_port->list,
+			      &adapter->dev_topo.card_port_list);
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
+						       attached_sas_addr,
+						       card_port);
+		if (sas_dev) {
+			sas_dev->card_port = may_new_card_port;
+			leapraid_sdev_put(sas_dev);
+		}
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
+static void leapraid_update_vphys_after_reset(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_io_unit_p0 *sas_iounit_p0;
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
+				 &adapter->dev_topo.card_port_list, list) {
+		if (!card_port->vphys_mask)
+			continue;
+
+		list_for_each_entry_safe(vphy, vphy_next,
+					 &card_port->vphys_list, list)
+			vphy->flg |= LEAPRAID_VPHY_FLG_DIRTY;
+	}
+
+	sz = offsetof(struct leapraid_sas_io_unit_p0, phy_info) +
+		(adapter->dev_topo.card.phys_num *
+		 sizeof(struct leapraid_sas_io_unit0_phy_info));
+	sas_iounit_p0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_p0)
+		return;
+
+	cfgp1.size = sz;
+	if (leapraid_op_config_page(adapter, sas_iounit_p0, cfgp1, cfgp2,
+				    GET_SAS_IOUNIT_PG0) != 0)
+		goto out_free;
+
+	for (i = 0; i < adapter->dev_topo.card.phys_num; i++) {
+		if (!leapraid_is_valid_vphy(adapter, sas_iounit_p0, i))
+			continue;
+
+		attached_hdl =
+			le16_to_cpu(sas_iounit_p0->phy_info[i]
+					.attached_dev_hdl);
+		if (leapraid_get_sas_address(adapter, attached_hdl,
+					     &attached_sas_addr) != 0)
+			continue;
+
+		found = false;
+		card_port = NULL;
+		card_port_next = NULL;
+		list_for_each_entry_safe(card_port, card_port_next,
+					 &adapter->dev_topo.card_port_list,
+					 list) {
+			if (!card_port->vphys_mask)
+				continue;
+
+			list_for_each_entry_safe(vphy, vphy_next,
+						 &card_port->vphys_list,
+						 list) {
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
+				leapraid_update_vphy_binding(adapter,
+							     card_port,
+							     vphy,
+							     i,
+							     port_id,
+							     attached_sas_addr);
+
+				found = true;
+				break;
+			}
+			if (found)
+				break;
+		}
+	}
+out_free:
+	kfree(sas_iounit_p0);
+}
+
+static void leapraid_mark_all_dev_deleted(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, adapter->shost) {
+		sdev_priv = sdev->hostdata;
+		if (sdev_priv && sdev_priv->starget_priv)
+			sdev_priv->starget_priv->deleted = 1;
+	}
+}
+
+static void leapraid_free_enc_list(struct leapraid_adapter *adapter)
+{
+	struct leapraid_enc_node *enc_dev, *enc_dev_next;
+	LIST_HEAD(free_list);
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+	list_splice_init(&adapter->dev_topo.enc_list, &free_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+
+	list_for_each_entry_safe(enc_dev, enc_dev_next, &free_list, list) {
+		list_del(&enc_dev->list);
+		kfree(enc_dev);
+	}
+}
+
+static void leapraid_rebuild_enc_list_after_reset(
+		struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_enc_node *enc_node;
+	u16 enc_hdl;
+	unsigned long flags;
+	int rc;
+
+	leapraid_free_enc_list(adapter);
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (enc_hdl = 0xFFFF; ; enc_hdl = le16_to_cpu(enc_node->pg0.enc_hdl)) {
+		enc_node = kzalloc_obj(*enc_node);
+		if (!enc_node)
+			return;
+
+		cfgp2.handle = enc_hdl;
+		rc = leapraid_op_config_page(adapter, &enc_node->pg0, cfgp1,
+					     cfgp2, GET_SAS_ENCLOSURE_PG0);
+		if (rc) {
+			kfree(enc_node);
+			return;
+		}
+
+		spin_lock_irqsave(&adapter->dev_topo.enc_lock, flags);
+		list_add_tail(&enc_node->list, &adapter->dev_topo.enc_list);
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, flags);
+	}
+}
+
+static void leapraid_mark_resp_sas_dev(struct leapraid_adapter *adapter,
+				       struct leapraid_sas_dev_p0 *sas_dev_p0)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_enc_node *enc_node = NULL;
+	struct leapraid_card_port *card_port;
+	struct leapraid_sas_dev *sas_dev;
+	struct scsi_target *starget;
+	unsigned long flags;
+	unsigned long enc_flags = 0;
+	u16 enc_hdl;
+	u64 enc_lid = 0;
+
+	card_port = leapraid_get_port_by_id(adapter, sas_dev_p0->physical_port,
+					    false);
+	enc_hdl = le16_to_cpu(sas_dev_p0->enc_hdl);
+	if (enc_hdl) {
+		spin_lock_irqsave(&adapter->dev_topo.enc_lock, enc_flags);
+		enc_node = leapraid_enc_find_by_hdl(adapter, enc_hdl);
+		if (enc_node)
+			enc_lid = le64_to_cpu(enc_node->pg0.enc_lid);
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, enc_flags);
+		if (!enc_node)
+			dev_info(&adapter->pdev->dev,
+				 "enc hdl 0x%04x has no matched enc dev\n",
+				 enc_hdl);
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	list_for_each_entry(sas_dev, &adapter->dev_topo.sas_dev_list, list) {
+		if (sas_dev->sas_addr != le64_to_cpu(sas_dev_p0->sas_address) ||
+		    sas_dev->slot != le16_to_cpu(sas_dev_p0->slot) ||
+		    sas_dev->card_port != card_port)
+			continue;
+
+		sas_dev->resp = 1;
+		starget = sas_dev->starget;
+		if (starget && starget->hostdata) {
+			starget_priv = starget->hostdata;
+			starget_priv->tm_busy = 0;
+			starget_priv->deleted = 0;
+		} else {
+			starget_priv = NULL;
+		}
+
+		if (starget) {
+			starget_printk(
+				KERN_INFO, starget,
+				"dev: hdl=0x%04x saddr=0x%016llx port_id=%d\n",
+				sas_dev->hdl,
+				(unsigned long long)sas_dev->sas_addr,
+				sas_dev->card_port->port_id);
+			if (sas_dev->enc_hdl != 0)
+				starget_printk(
+					KERN_INFO,
+					starget,
+					"enc info: enc_lid=0x%016llx slot=%d\n",
+					(unsigned long long)sas_dev->enc_lid,
+					sas_dev->slot);
+		}
+
+		if (le16_to_cpu(sas_dev_p0->flg) &
+		    LEAPRAID_SAS_DEV_P0_FLG_ENC_LEVEL_VALID) {
+			sas_dev->enc_level = sas_dev_p0->enc_level;
+			memcpy(sas_dev->connector_name,
+			       sas_dev_p0->connector_name,
+			       LEAPRAID_SAS_DEV_P0_CON_NAME_LEN);
+			sas_dev->connector_name[
+				LEAPRAID_SAS_DEV_P0_CON_NAME_LEN] = '\0';
+		} else {
+			sas_dev->enc_level = 0;
+			sas_dev->connector_name[0] = '\0';
+		}
+
+		sas_dev->enc_hdl = enc_hdl;
+		sas_dev->enc_lid = enc_lid;
+
+		if (sas_dev->hdl == le16_to_cpu(sas_dev_p0->dev_hdl))
+			goto unlock;
+
+		dev_info(&adapter->pdev->dev,
+			 "hdl changed: 0x%04x -> 0x%04x\n",
+			 sas_dev->hdl, sas_dev_p0->dev_hdl);
+		sas_dev->hdl = le16_to_cpu(sas_dev_p0->dev_hdl);
+		if (starget_priv)
+			starget_priv->hdl = le16_to_cpu(sas_dev_p0->dev_hdl);
+
+		goto unlock;
+	}
+unlock:
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+}
+
+static void leapraid_search_resp_sas_dev(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_p0;
+	u32 device_info;
+
+	if (list_empty(&adapter->dev_topo.sas_dev_list))
+		return;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (cfgp2.handle = 0xFFFF;
+	     !leapraid_op_config_page(adapter, &sas_dev_p0,
+				      cfgp1, cfgp2, GET_SAS_DEVICE_PG0);
+	     cfgp2.handle = le16_to_cpu(sas_dev_p0.dev_hdl)) {
+		device_info = le32_to_cpu(sas_dev_p0.dev_info);
+		if (!(leapraid_is_end_dev(device_info)))
+			continue;
+
+		leapraid_mark_resp_sas_dev(adapter, &sas_dev_p0);
+	}
+}
+
+static void leapraid_mark_resp_raid_volume(struct leapraid_adapter *adapter,
+					   u64 wwid, u16 hdl)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *starget_priv = NULL;
+	struct scsi_target *starget;
+	unsigned long flags;
+	u64 volume_wwid;
+	u16 old_hdl;
+
+	raid_volume = leapraid_raid_volume_find_by_wwid(adapter, wwid);
+	if (!raid_volume)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	if (!raid_volume->starget) {
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+		leapraid_raid_volume_put(raid_volume);
+		return;
+	}
+
+	starget = raid_volume->starget;
+	if (starget->hostdata) {
+		starget_priv = starget->hostdata;
+		starget_priv->deleted = 0;
+	}
+
+	raid_volume->resp = 1;
+	volume_wwid = raid_volume->wwid;
+	old_hdl = raid_volume->hdl;
+	if (old_hdl != hdl) {
+		raid_volume->hdl = hdl;
+		if (starget_priv)
+			starget_priv->hdl = hdl;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	starget_printk(KERN_INFO, starget,
+		       "raid volume: hdl=0x%04x, wwid=0x%016llx\n",
+		       hdl, (unsigned long long)volume_wwid);
+	if (old_hdl != hdl)
+		dev_info(&adapter->pdev->dev,
+			 "hdl changed: 0x%04x -> 0x%04x\n",
+			 old_hdl, hdl);
+
+	leapraid_raid_volume_put(raid_volume);
+}
+
+static void leapraid_search_resp_raid_volume(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_1 cfgp1_extra = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union cfg_param_2 cfgp2_extra = {0};
+	struct leapraid_raidvol_p1 raidvol_p1;
+	struct leapraid_raidvol_p0 raidvol_p0;
+	struct leapraid_raidpd_p0 raidpd_p0;
+	unsigned long flags;
+	u16 hdl;
+	u8 phys_disk_num;
+	bool is_empty;
+
+	if (!adapter->adapter_attr.raid_support)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	is_empty = list_empty(&adapter->dev_topo.raid_volume_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+	if (is_empty)
+		return;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+	     !leapraid_op_config_page(adapter, &raidvol_p1, cfgp1, cfgp2,
+				      GET_RAID_VOLUME_PG1);
+	     cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(raidvol_p1.dev_hdl);
+		cfgp1_extra.size = sizeof(struct leapraid_raidvol_p0);
+		cfgp2_extra.handle = hdl;
+		if (leapraid_op_config_page(adapter, &raidvol_p0, cfgp1_extra,
+					    cfgp2_extra, GET_RAID_VOLUME_PG0))
+			continue;
+
+		if (raidvol_p0.volume_state == LEAPRAID_VOL_STATE_OPTIMAL ||
+		    raidvol_p0.volume_state == LEAPRAID_VOL_STATE_ONLINE ||
+		    raidvol_p0.volume_state == LEAPRAID_VOL_STATE_DEGRADED)
+			leapraid_mark_resp_raid_volume(
+				adapter,
+				le64_to_cpu(raidvol_p1.wwid),
+				hdl);
+	}
+
+	memset(adapter->dev_topo.pd_hdls, 0, adapter->dev_topo.pd_hdls_sz);
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (phys_disk_num = 0xFF, cfgp2.form_specific = phys_disk_num;
+	     !leapraid_op_config_page(adapter, &raidpd_p0, cfgp1, cfgp2,
+				      GET_PHY_DISK_PG0);
+	     cfgp2.form_specific = phys_disk_num) {
+		phys_disk_num = raidpd_p0.phys_disk_num;
+		hdl = le16_to_cpu(raidpd_p0.dev_hdl);
+		if (!hdl ||
+		    hdl > adapter->adapter_attr.features.max_dev_handle)
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Invalid device handle\n", __func__);
+		else
+			set_bit(hdl, adapter->dev_topo.pd_hdls);
+	}
+}
+
+static void leapraid_mark_resp_exp(struct leapraid_adapter *adapter,
+				   struct leapraid_exp_p0 *exp_pg0)
+{
+	struct leapraid_enc_node *enc_node = NULL;
+	struct leapraid_topo_node *topo_node_exp;
+	u16 enc_hdl = le16_to_cpu(exp_pg0->enc_hdl);
+	u64 sas_address = le64_to_cpu(exp_pg0->sas_address);
+	u16 hdl = le16_to_cpu(exp_pg0->dev_hdl);
+	u8 port_id = exp_pg0->physical_port;
+	struct leapraid_card_port *card_port = leapraid_get_port_by_id(adapter,
+								       port_id,
+								       false);
+	unsigned long flags;
+	unsigned long enc_flags = 0;
+	u64 enc_lid = 0;
+	int i;
+
+	if (enc_hdl) {
+		spin_lock_irqsave(&adapter->dev_topo.enc_lock, enc_flags);
+		enc_node = leapraid_enc_find_by_hdl(adapter, enc_hdl);
+		if (enc_node)
+			enc_lid = le64_to_cpu(enc_node->pg0.enc_lid);
+		spin_unlock_irqrestore(&adapter->dev_topo.enc_lock, enc_flags);
+	}
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_for_each_entry(topo_node_exp, &adapter->dev_topo.exp_list, list) {
+		if (topo_node_exp->sas_address != sas_address ||
+		    topo_node_exp->card_port != card_port)
+			continue;
+
+		topo_node_exp->resp = 1;
+		topo_node_exp->enc_hdl = enc_hdl;
+		topo_node_exp->enc_lid = enc_lid;
+		if (topo_node_exp->hdl == hdl)
+			goto unlock;
+
+		dev_info(&adapter->pdev->dev,
+			 "hdl changed: 0x%04x -> 0x%04x\n",
+			 topo_node_exp->hdl, hdl);
+		topo_node_exp->hdl = hdl;
+		for (i = 0; i < topo_node_exp->phys_num; i++)
+			topo_node_exp->card_phy[i].hdl = hdl;
+		goto unlock;
+	}
+unlock:
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+}
+
+static void leapraid_search_resp_exp(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_exp_p0 exp_p0;
+	u64 sas_address;
+	u16 hdl;
+	u8 port;
+
+	if (list_empty(&adapter->dev_topo.exp_list))
+		return;
+
+	cfgp1.form = LEAPRAID_SAS_CFG_PGAD_GET_NEXT_LOOP;
+	for (hdl = 0xFFFF, cfgp2.handle = hdl;
+	     !leapraid_op_config_page(adapter, &exp_p0, cfgp1, cfgp2,
+				      GET_SAS_EXPANDER_PG0);
+	     cfgp2.handle = hdl) {
+		hdl = le16_to_cpu(exp_p0.dev_hdl);
+		sas_address = le64_to_cpu(exp_p0.sas_address);
+		port = exp_p0.physical_port;
+
+		dev_dbg(&adapter->pdev->dev,
+			"exp detected: hdl=0x%04x, sas=0x%016llx, port=%u",
+			hdl, (unsigned long long)sas_address,
+			adapter->adapter_attr.enable_mp ? port :
+				LEAPRAID_DISABLE_MP_PORT_ID);
+		leapraid_mark_resp_exp(adapter, &exp_p0);
+	}
+}
+
+void leapraid_wait_cmds_done(struct leapraid_adapter *adapter)
+{
+	struct leapraid_io_req_tracker *io_req_tracker;
+	unsigned long flags;
+	u16 i;
+
+	adapter->reset_desc.pending_io_cnt = 0;
+	if (!leapraid_pci_active(adapter)) {
+		dev_err(&adapter->pdev->dev,
+			"%s %s: PCI error, device reset or unplugged!\n",
+			adapter->adapter_attr.name, __func__);
+		return;
+	}
+
+	if (leapraid_get_adapter_state(adapter) != LEAPRAID_DB_OPERATIONAL)
+		return;
+
+	spin_lock_irqsave(&adapter->dynamic_task_desc.task_lock, flags);
+	for (i = 1; i <= adapter->shost->can_queue; i++) {
+		io_req_tracker = leapraid_get_io_tracker_from_taskid(adapter,
+								     i);
+		if (io_req_tracker && io_req_tracker->taskid != 0 &&
+		    io_req_tracker->scmd)
+			adapter->reset_desc.pending_io_cnt++;
+	}
+	spin_unlock_irqrestore(&adapter->dynamic_task_desc.task_lock, flags);
+
+	if (!adapter->reset_desc.pending_io_cnt)
+		return;
+
+	wait_event_timeout(adapter->reset_desc.reset_wait_queue,
+			   adapter->reset_desc.pending_io_cnt == 0,
+			   LEAPRAID_IO_CMD_TIMEOUT * HZ);
+}
+
+int leapraid_hard_reset_handler(struct leapraid_adapter *adapter,
+				enum reset_type type)
+{
+	unsigned long flags;
+	bool wake = false;
+	int rc;
+
+	mutex_lock(&adapter->reset_desc.adapter_reset_mutex);
+
+	if (!leapraid_pci_active(adapter)) {
+		if (leapraid_pci_removed(adapter)) {
+			dev_info(&adapter->pdev->dev,
+				 "pci_dev removed, pause poll, clean cmds\n");
+			leapraid_mq_polling_pause(adapter);
+			leapraid_clean_active_scsi_cmds(adapter);
+			leapraid_mq_polling_resume(adapter);
+		}
+		dev_err(&adapter->pdev->dev, "PCIe unavailable!\n");
+		mutex_unlock(&adapter->reset_desc.adapter_reset_mutex);
+		return -ENXIO;
+	}
+
+	dev_info(&adapter->pdev->dev, "Starting hard reset\n");
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	adapter->access_ctrl.shost_recovering = 1;
+	adapter->access_ctrl.shost_recover_async = 1;
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+
+	leapraid_wait_cmds_done(adapter);
+	leapraid_mask_int(adapter);
+	leapraid_mq_polling_pause(adapter);
+	rc = leapraid_make_adapter_ready(adapter, type);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to make adapter ready, rc=%d\n", rc);
+		goto out_cleanup;
+	}
+
+	rc = leapraid_fw_log_init(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Firmware log init failed\n");
+		goto out_cleanup;
+	}
+
+	leapraid_clean_active_cmds(adapter);
+	if (adapter->scan_dev_desc.driver_loading &&
+	    adapter->scan_dev_desc.scan_dev_failed) {
+		dev_err(&adapter->pdev->dev,
+			"Previous device scan failed or driver loading\n");
+		adapter->access_ctrl.host_removing = 1;
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+	rc = leapraid_make_adapter_available(adapter);
+	if (!rc) {
+		dev_info(&adapter->pdev->dev,
+			 "Adapter is now available, rebuilding topology\n");
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
+out_cleanup:
+	if (rc)
+		dev_err(&adapter->pdev->dev, "Hard reset failed\n");
+
+	spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock, flags);
+	adapter->reset_desc.adapter_reset_results = rc;
+	adapter->access_ctrl.shost_recovering = 0;
+	wake_up(&adapter->access_ctrl.recovery_waitq);
+	if (rc) {
+		adapter->access_ctrl.shost_recover_async = 0;
+		wake = true;
+	}
+	spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock, flags);
+	if (wake)
+		wake_up(&adapter->access_ctrl.shost_recover_wq);
+
+	adapter->reset_desc.reset_cnt++;
+	mutex_unlock(&adapter->reset_desc.adapter_reset_mutex);
+
+	if (rc)
+		leapraid_clean_active_scsi_cmds(adapter);
+	leapraid_mq_polling_resume(adapter);
+
+	return rc;
+}
+
+static int leapraid_get_adapter_features(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_features_req leap_mpi_req;
+	struct leapraid_adapter_features_rep leap_mpi_rep;
+	u8 fw_major, fw_minor, fw_build, fw_release;
+	u32 req_sz;
+	u32 rep_sz;
+	u32 db;
+	int r;
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if (db & LEAPRAID_DB_USED ||
+	    (db & LEAPRAID_DB_MASK) == LEAPRAID_DB_FAULT) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Doorbell used or fault\n", __func__);
+		return -EFAULT;
+	}
+
+	if ((db & LEAPRAID_DB_MASK) != LEAPRAID_DB_READY &&
+	    (db & LEAPRAID_DB_MASK) != LEAPRAID_DB_OPERATIONAL &&
+	    !leapraid_wait_adapter_ready(adapter)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: adapter not ready\n", __func__);
+		return -EFAULT;
+	}
+
+	req_sz = sizeof(struct leapraid_adapter_features_req);
+	rep_sz = sizeof(struct leapraid_adapter_features_rep);
+	memset(&leap_mpi_req, 0, req_sz);
+	memset(&leap_mpi_rep, 0, rep_sz);
+	leap_mpi_req.func = LEAPRAID_FUNC_GET_ADAPTER_FEATURES;
+	r = leapraid_handshake_func(adapter,
+				    req_sz,
+				    (u32 *)&leap_mpi_req,
+				    rep_sz,
+				    (u16 *)&leap_mpi_rep);
+	if (r) {
+		dev_err(&adapter->pdev->dev,
+			"%s %s: Handshake failed, r=%d\n",
+			adapter->adapter_attr.name, __func__, r);
+		return r;
+	}
+
+	memset(&adapter->adapter_attr.features, 0,
+	       sizeof(struct leapraid_adapter_features));
+	adapter->adapter_attr.features.req_slot =
+		le16_to_cpu(leap_mpi_rep.req_slot);
+	adapter->adapter_attr.features.hp_slot =
+		le16_to_cpu(leap_mpi_rep.hp_slot);
+	adapter->adapter_attr.features.adapter_caps =
+		le32_to_cpu(leap_mpi_rep.adapter_caps);
+	adapter->adapter_attr.features.max_msix_vectors =
+		leap_mpi_rep.max_msix_vectors;
+	adapter->adapter_attr.features.max_volumes =
+		leap_mpi_rep.max_volumes;
+	if (!adapter->adapter_attr.features.max_volumes)
+		adapter->adapter_attr.features.max_volumes =
+			LEAPRAID_MAX_VOLUMES_DEFAULT;
+	adapter->adapter_attr.features.max_dev_handle =
+		le16_to_cpu(leap_mpi_rep.max_dev_hdl);
+	if (!adapter->adapter_attr.features.max_dev_handle)
+		adapter->adapter_attr.features.max_dev_handle =
+			LEAPRAID_MAX_DEV_HANDLE_DEFAULT;
+	adapter->adapter_attr.features.min_dev_handle =
+		le16_to_cpu(leap_mpi_rep.min_dev_hdl);
+	if (adapter->adapter_attr.features.adapter_caps &
+	    LEAPRAID_ADAPTER_FEATURES_CAP_INTEGRATED_RAID)
+		adapter->adapter_attr.raid_support = 1;
+	adapter->adapter_attr.wideport_max_queue_depth =
+		le16_to_cpu(leap_mpi_rep.sas_wide_max_qdepth) ?
+		le16_to_cpu(leap_mpi_rep.sas_wide_max_qdepth) :
+		LEAPRAID_SAS_QUEUE_DEPTH;
+	adapter->adapter_attr.narrowport_max_queue_depth =
+		le16_to_cpu(leap_mpi_rep.sas_narrow_max_qdepth) ?
+		le16_to_cpu(leap_mpi_rep.sas_narrow_max_qdepth) :
+		LEAPRAID_SAS_QUEUE_DEPTH;
+	adapter->adapter_attr.sata_max_queue_depth =
+		leap_mpi_rep.sata_max_qdepth ?
+		leap_mpi_rep.sata_max_qdepth :
+		LEAPRAID_SATA_QUEUE_DEPTH;
+	adapter->adapter_attr.raid_volume_max_queue_depth =
+		LEAPRAID_RAID_QUEUE_DEPTH;
+	dev_info(&adapter->pdev->dev,
+		 "max: wp qd=%d, np qd=%d, SATA qd=%d, raid qd=%d\n",
+		 adapter->adapter_attr.wideport_max_queue_depth,
+		 adapter->adapter_attr.narrowport_max_queue_depth,
+		 adapter->adapter_attr.sata_max_queue_depth,
+		 adapter->adapter_attr.raid_volume_max_queue_depth);
+	if (WARN_ON(!(adapter->adapter_attr.features.adapter_caps &
+		      LEAPRAID_ADAPTER_FEATURES_CAP_ATOMIC_REQ)))
+		return -EFAULT;
+	adapter->adapter_attr.features.fw_version =
+		le32_to_cpu(leap_mpi_rep.fw_version);
+
+	fw_major = (adapter->adapter_attr.features.fw_version >>
+		    LEAPRAID_VER_MAJOR_SHIFT) & LEAPRAID_VER_MASK;
+	fw_minor = (adapter->adapter_attr.features.fw_version >>
+		    LEAPRAID_VER_MINOR_SHIFT) & LEAPRAID_VER_MASK;
+	fw_build = (adapter->adapter_attr.features.fw_version >>
+		    LEAPRAID_VER_BUILD_SHIFT)  & LEAPRAID_VER_MASK;
+	fw_release =
+		adapter->adapter_attr.features.fw_version & LEAPRAID_VER_MASK;
+
+	dev_info(&adapter->pdev->dev,
+		 "Firmware version: %u.%u.%u.%u (0x%08x)\n",
+		 fw_major, fw_minor, fw_build, fw_release,
+		 adapter->adapter_attr.features.fw_version);
+
+	if (fw_major < 2) {
+		dev_err(&adapter->pdev->dev,
+			"Unsupported firmware major version, requires >= 2\n");
+		return -EFAULT;
+	}
+	adapter->shost->max_id = LEAPRAID_INVALID_INITIAL_VALUE;
+
+	return 0;
+}
+
+static inline void leapraid_disable_pcie(struct leapraid_adapter *adapter)
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
+static int leapraid_enable_pcie(struct leapraid_adapter *adapter)
+{
+	u64 dma_mask;
+	int rc;
+
+	rc = pci_enable_device(adapter->pdev);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Failed to enable PCI device\n");
+		return rc;
+	}
+
+	rc = pci_request_regions(adapter->pdev, LEAPRAID_DRIVER_NAME);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to obtain PCI resources\n");
+		return rc;
+	}
+
+	if (sizeof(dma_addr_t) > 4) {
+		dma_mask = DMA_BIT_MASK(DMA_64_BITS);
+		adapter->adapter_attr.use_32_dma_mask = 0;
+	} else {
+		dma_mask = DMA_BIT_MASK(DMA_32_BITS);
+		adapter->adapter_attr.use_32_dma_mask = 1;
+	}
+
+	rc = dma_set_mask_and_coherent(&adapter->pdev->dev, dma_mask);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to set %lld DMA mask\n", dma_mask);
+		return rc;
+	}
+	adapter->iomem_base = ioremap(pci_resource_start(adapter->pdev, 0),
+				      sizeof(struct leapraid_reg_base));
+	if (!adapter->iomem_base) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to map memory for controller registers\n");
+		return -ENOMEM;
+	}
+
+	pci_set_master(adapter->pdev);
+
+	return 0;
+}
+
+static void leapraid_cpus_on_irq(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	unsigned int i, base_group, this_group;
+	unsigned int cpu, nr_cpus, total_msix, index;
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
+	     index++) {
+		int_rq = &adapter->notification_desc.int_rqs[index];
+
+		if (cpu >= nr_cpus)
+			break;
+
+		this_group = base_group +
+				(index < (nr_cpus % total_msix) ? 1 : 0);
+
+		for (i = 0 ; i < this_group ; i++) {
+			adapter->notification_desc.msix_cpu_map[cpu] =
+				int_rq->rq.msix_idx;
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
+	}
+}
+
+static void leapraid_map_msix_to_cpu(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	const cpumask_t *affinity_mask;
+	int cpu;
+	u32 i;
+
+	if (!adapter->adapter_attr.rq_cnt)
+		return;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		affinity_mask = pci_irq_get_affinity(adapter->pdev,
+						     int_rq->rq.msix_idx);
+		if (!affinity_mask) {
+			dev_warn(&adapter->pdev->dev,
+				 "%s: IRQ affinity NULL, msix_idx=%d\n",
+				 __func__, int_rq->rq.msix_idx);
+			goto out_apply_irq_affinity;
+		}
+
+		for_each_cpu_and(cpu, affinity_mask, cpu_online_mask) {
+			if (cpu >= adapter->notification_desc.msix_cpu_map_sz)
+				break;
+
+			adapter->notification_desc.msix_cpu_map[cpu] =
+				int_rq->rq.msix_idx;
+		}
+	}
+	return;
+out_apply_irq_affinity:
+	leapraid_cpus_on_irq(adapter);
+}
+
+static void leapraid_configure_reply_queue_affinity(
+		struct leapraid_adapter *adapter)
+{
+	if (!adapter || !adapter->notification_desc.msix_enable)
+		return;
+
+	leapraid_map_msix_to_cpu(adapter);
+}
+
+static void leapraid_free_irq(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	unsigned int i;
+	int irq;
+
+	for (i = 0; adapter->notification_desc.int_rqs &&
+	     i < adapter->notification_desc.int_rqs_allocated; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		if (!int_rq)
+			continue;
+
+		irq = pci_irq_vector(adapter->pdev, int_rq->rq.msix_idx);
+		irq_set_affinity_hint(irq, NULL);
+		free_irq(irq, &int_rq->rq);
+	}
+	adapter->notification_desc.int_rqs_allocated = 0;
+
+	if (adapter->notification_desc.irq_vectors_allocated) {
+		pci_free_irq_vectors(adapter->pdev);
+		adapter->notification_desc.irq_vectors_allocated = 0;
+	}
+
+	adapter->notification_desc.msix_enable = 0;
+
+	kfree(adapter->notification_desc.blk_mq_poll_rqs);
+	adapter->notification_desc.blk_mq_poll_rqs = NULL;
+
+	kfree(adapter->notification_desc.int_rqs);
+	adapter->notification_desc.int_rqs = NULL;
+
+	kfree(adapter->notification_desc.msix_cpu_map);
+	adapter->notification_desc.msix_cpu_map = NULL;
+	adapter->notification_desc.msix_cpu_map_sz = 0;
+	adapter->notification_desc.iopoll_qdex = 0;
+	adapter->notification_desc.iopoll_qcnt = 0;
+}
+
+static int leapraid_setup_irqs(struct leapraid_adapter *adapter)
+{
+	unsigned int i;
+	int rc = 0;
+
+	if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_MSIX) {
+		rc = pci_alloc_irq_vectors_affinity(
+			adapter->pdev,
+			adapter->notification_desc.iopoll_qdex,
+			adapter->notification_desc.iopoll_qdex,
+			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, NULL);
+		if (rc < 0) {
+			dev_err(&adapter->pdev->dev,
+				"%d MSI/MSIX vectors allocated failed!\n",
+				adapter->notification_desc.iopoll_qdex);
+			return rc;
+		}
+
+		adapter->notification_desc.irq_vectors_allocated = 1;
+		adapter->notification_desc.irq_mode =
+				LEAPRAID_INTERRUPT_MODE_MSIX;
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		adapter->notification_desc.int_rqs[i].rq.adapter = adapter;
+		adapter->notification_desc.int_rqs[i].rq.msix_idx = i;
+		atomic_set(&adapter->notification_desc.int_rqs[i].rq.busy, 0);
+		if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_MSIX)
+			snprintf(adapter->notification_desc.int_rqs[i].rq.name,
+				 LEAPRAID_NAME_LENGTH, "%s%u-MSIx%u",
+				 LEAPRAID_DRIVER_NAME,
+				 adapter->adapter_attr.id, i);
+		else if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_MSI)
+			snprintf(adapter->notification_desc.int_rqs[i].rq.name,
+				 LEAPRAID_NAME_LENGTH, "%s%u-MSI%u",
+				 LEAPRAID_DRIVER_NAME,
+				 adapter->adapter_attr.id, i);
+
+		rc = request_irq(pci_irq_vector(adapter->pdev, i),
+				 leapraid_irq_handler,
+				 IRQF_SHARED,
+				 adapter->notification_desc.int_rqs[i].rq.name,
+				 &adapter->notification_desc.int_rqs[i].rq);
+		if (rc) {
+			dev_err(&adapter->pdev->dev,
+				"MSI/MSIx: request_irq %s failed!\n",
+				adapter->notification_desc.int_rqs[i].rq.name);
+			return rc;
+		}
+		adapter->notification_desc.int_rqs_allocated++;
+	}
+
+	return 0;
+}
+
+static int leapraid_setup_legacy_int(struct leapraid_adapter *adapter)
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
+	rc = pci_alloc_irq_vectors_affinity(
+		adapter->pdev,
+		adapter->notification_desc.iopoll_qdex,
+		adapter->notification_desc.iopoll_qdex,
+		PCI_IRQ_INTX | PCI_IRQ_AFFINITY,
+		NULL);
+	if (rc < 0) {
+		dev_err(&adapter->pdev->dev,
+			"Legacy irq allocated failed!\n");
+		return rc;
+	}
+
+	adapter->notification_desc.irq_vectors_allocated = 1;
+	adapter->notification_desc.irq_mode = LEAPRAID_INTERRUPT_MODE_LEGACY;
+	rc = request_irq(pci_irq_vector(adapter->pdev, 0),
+			 leapraid_irq_handler,
+			 IRQF_SHARED,
+			 adapter->notification_desc.int_rqs[0].rq.name,
+			 &adapter->notification_desc.int_rqs[0].rq);
+	if (rc) {
+		irq_set_affinity_hint(pci_irq_vector(adapter->pdev, 0), NULL);
+		pci_free_irq_vectors(adapter->pdev);
+		adapter->notification_desc.irq_vectors_allocated = 0;
+		dev_err(&adapter->pdev->dev,
+			"Legacy Int: request_irq %s failed!\n",
+			adapter->notification_desc.int_rqs[0].rq.name);
+		return -EBUSY;
+	}
+	adapter->notification_desc.int_rqs_allocated = 1;
+	return rc;
+}
+
+static int leapraid_set_legacy_int(struct leapraid_adapter *adapter)
+{
+	adapter->notification_desc.msix_cpu_map_sz = num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+
+	adapter->adapter_attr.rq_cnt = 1;
+	adapter->notification_desc.iopoll_qdex =
+		adapter->adapter_attr.rq_cnt;
+	adapter->notification_desc.iopoll_qcnt = 0;
+	dev_info(&adapter->pdev->dev,
+		 "Legacy Intr: req queue cnt=%d intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+	adapter->notification_desc.int_rqs =
+		kcalloc(adapter->notification_desc.iopoll_qdex,
+			sizeof(struct leapraid_int_rq), GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs)
+		return -ENOMEM;
+
+	return leapraid_setup_legacy_int(adapter);
+}
+
+static int leapraid_set_msix(struct leapraid_adapter *adapter)
+{
+	int iopoll_qcnt = 0;
+	unsigned int i;
+	int rc, msix_cnt;
+
+	if (msix_disable == 1)
+		goto apply_legacy_int;
+
+	msix_cnt = pci_msix_vec_count(adapter->pdev);
+	if (msix_cnt <= 0 ||
+	    adapter->adapter_attr.features.max_msix_vectors == 0) {
+		dev_info(&adapter->pdev->dev, "MSIX unsupported!\n");
+		goto apply_legacy_int;
+	}
+
+	msix_cnt = min_t(int, msix_cnt,
+			 adapter->adapter_attr.features.max_msix_vectors);
+
+	if (reset_devices)
+		adapter->adapter_attr.rq_cnt = 1;
+	else
+		adapter->adapter_attr.rq_cnt = min_t(int,
+						     num_online_cpus(),
+						     msix_cnt);
+
+	if (max_msix_vectors > 0)
+		adapter->adapter_attr.rq_cnt = min_t(
+			int, max_msix_vectors, adapter->adapter_attr.rq_cnt);
+
+	if (adapter->adapter_attr.rq_cnt <= 1)
+		adapter->shost->host_tagset = 0;
+	if (adapter->shost->host_tagset) {
+		iopoll_qcnt = poll_queues;
+		if (iopoll_qcnt >= adapter->adapter_attr.rq_cnt)
+			iopoll_qcnt = 0;
+	}
+	if (iopoll_qcnt) {
+		adapter->notification_desc.blk_mq_poll_rqs =
+			kcalloc(iopoll_qcnt,
+				sizeof(struct leapraid_blk_mq_poll_rq),
+				GFP_KERNEL);
+		if (!adapter->notification_desc.blk_mq_poll_rqs)
+			return -ENOMEM;
+		adapter->adapter_attr.rq_cnt =
+			min(adapter->adapter_attr.rq_cnt + iopoll_qcnt,
+			    msix_cnt);
+	}
+
+	adapter->notification_desc.iopoll_qdex =
+		adapter->adapter_attr.rq_cnt - iopoll_qcnt;
+
+	adapter->notification_desc.iopoll_qcnt = iopoll_qcnt;
+	dev_info(&adapter->pdev->dev,
+		 "MSIx: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+
+	adapter->notification_desc.int_rqs =
+		kcalloc(adapter->notification_desc.iopoll_qdex,
+			sizeof(struct leapraid_int_rq), GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs)
+		return -ENOMEM;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.adapter =
+			adapter;
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.msix_idx =
+			i + adapter->notification_desc.iopoll_qdex;
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].rq.busy,
+			0);
+		snprintf(adapter->notification_desc.blk_mq_poll_rqs[i].rq.name,
+			 LEAPRAID_NAME_LENGTH,
+			 "%s%u-MQ-Poll%u", LEAPRAID_DRIVER_NAME,
+			 adapter->adapter_attr.id, i);
+		atomic_set(&adapter->notification_desc.blk_mq_poll_rqs[i].busy,
+			   0);
+		atomic_set(&adapter->notification_desc.blk_mq_poll_rqs[i].pause,
+			   0);
+	}
+
+	adapter->notification_desc.msix_cpu_map_sz =
+		num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+
+	memset(adapter->notification_desc.msix_cpu_map, 0,
+	       adapter->notification_desc.msix_cpu_map_sz);
+
+	adapter->notification_desc.msix_enable = 1;
+	rc = leapraid_setup_irqs(adapter);
+	if (rc) {
+		leapraid_free_irq(adapter);
+		adapter->notification_desc.msix_enable = 0;
+		goto apply_legacy_int;
+	}
+
+	return 0;
+
+apply_legacy_int:
+	return leapraid_set_legacy_int(adapter);
+}
+
+static int leapraid_set_msi(struct leapraid_adapter *adapter)
+{
+	int iopoll_qcnt = 0;
+	unsigned int i;
+	int rc, msi_cnt;
+
+	if (msix_disable == 1)
+		goto apply_legacy_int;
+
+	msi_cnt = pci_msi_vec_count(adapter->pdev);
+	if (msi_cnt <= 0 ||
+	    adapter->adapter_attr.features.max_msix_vectors == 0) {
+		dev_info(&adapter->pdev->dev, "MSI unsupported!\n");
+		goto apply_legacy_int;
+	}
+
+	msi_cnt = min_t(int, msi_cnt,
+			adapter->adapter_attr.features.max_msix_vectors);
+
+	if (reset_devices)
+		adapter->adapter_attr.rq_cnt = 1;
+	else
+		adapter->adapter_attr.rq_cnt = min_t(int,
+						     num_online_cpus(),
+						     msi_cnt);
+
+	if (max_msix_vectors > 0)
+		adapter->adapter_attr.rq_cnt = min_t(
+			int, max_msix_vectors, adapter->adapter_attr.rq_cnt);
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
+			kcalloc(iopoll_qcnt,
+				sizeof(struct leapraid_blk_mq_poll_rq),
+				GFP_KERNEL);
+		if (!adapter->notification_desc.blk_mq_poll_rqs)
+			return -ENOMEM;
+
+		adapter->adapter_attr.rq_cnt =
+			 min(adapter->adapter_attr.rq_cnt + iopoll_qcnt,
+			     msi_cnt);
+	}
+
+	adapter->notification_desc.iopoll_qdex =
+		adapter->adapter_attr.rq_cnt - iopoll_qcnt;
+	rc = pci_alloc_irq_vectors_affinity(
+		adapter->pdev,
+		1,
+		adapter->notification_desc.iopoll_qdex,
+		PCI_IRQ_MSI | PCI_IRQ_AFFINITY, NULL);
+	if (rc < 0) {
+		dev_err(&adapter->pdev->dev,
+			"%d MSI vectors allocated failed!\n",
+			adapter->notification_desc.iopoll_qdex);
+		leapraid_free_irq(adapter);
+		goto apply_legacy_int;
+	}
+	adapter->notification_desc.irq_vectors_allocated = 1;
+	adapter->notification_desc.irq_mode = LEAPRAID_INTERRUPT_MODE_MSI;
+	if (rc != adapter->notification_desc.iopoll_qdex) {
+		adapter->notification_desc.iopoll_qdex = rc;
+		adapter->adapter_attr.rq_cnt =
+			adapter->notification_desc.iopoll_qdex + iopoll_qcnt;
+	}
+	adapter->notification_desc.iopoll_qcnt = iopoll_qcnt;
+	dev_info(&adapter->pdev->dev,
+		 "MSI: req queue cnt=%d, intr=%d/poll=%d rep queues!\n",
+		 adapter->adapter_attr.rq_cnt,
+		 adapter->notification_desc.iopoll_qdex,
+		 adapter->notification_desc.iopoll_qcnt);
+
+	adapter->notification_desc.int_rqs =
+		kcalloc(adapter->notification_desc.iopoll_qdex,
+			sizeof(struct leapraid_int_rq),
+			GFP_KERNEL);
+	if (!adapter->notification_desc.int_rqs)
+		return -ENOMEM;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.adapter =
+			adapter;
+		adapter->notification_desc.blk_mq_poll_rqs[i].rq.msix_idx =
+			i + adapter->notification_desc.iopoll_qdex;
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].rq.busy,
+			0);
+		snprintf(adapter->notification_desc.blk_mq_poll_rqs[i].rq.name,
+			 LEAPRAID_NAME_LENGTH,
+			 "%s%u-MQ-Poll%u", LEAPRAID_DRIVER_NAME,
+			 adapter->adapter_attr.id, i);
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].busy,
+			0);
+		atomic_set(
+			&adapter->notification_desc.blk_mq_poll_rqs[i].pause,
+			0);
+	}
+
+	adapter->notification_desc.msix_cpu_map_sz = num_online_cpus();
+	adapter->notification_desc.msix_cpu_map =
+		kzalloc(adapter->notification_desc.msix_cpu_map_sz,
+			GFP_KERNEL);
+	if (!adapter->notification_desc.msix_cpu_map)
+		return -ENOMEM;
+	memset(adapter->notification_desc.msix_cpu_map, 0,
+	       adapter->notification_desc.msix_cpu_map_sz);
+
+	adapter->notification_desc.msix_enable = 1;
+	rc = leapraid_setup_irqs(adapter);
+	if (rc) {
+		leapraid_free_irq(adapter);
+		adapter->notification_desc.msix_enable = 0;
+		goto apply_legacy_int;
+	}
+
+	return 0;
+
+apply_legacy_int:
+	return leapraid_set_legacy_int(adapter);
+}
+
+static int leapraid_set_notification(struct leapraid_adapter *adapter)
+{
+	int rc = 0;
+
+	if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_MSIX) {
+		rc = leapraid_set_msix(adapter);
+		if (rc)
+			dev_err(&adapter->pdev->dev,
+				"%s: Enable MSI-X irq failed!\n", __func__);
+	} else if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_MSI) {
+		rc = leapraid_set_msi(adapter);
+		if (rc)
+			dev_err(&adapter->pdev->dev,
+				"%s: Enable MSI irq failed!\n", __func__);
+	} else if (interrupt_mode == LEAPRAID_INTERRUPT_MODE_LEGACY) {
+		rc = leapraid_set_legacy_int(adapter);
+		if (rc)
+			dev_err(&adapter->pdev->dev,
+				"%s: Enable legacy irq failed!\n", __func__);
+	}
+
+	return rc;
+}
+
+int leapraid_set_pcie_and_notification(struct leapraid_adapter *adapter)
+{
+	int rc;
+
+	rc = leapraid_enable_pcie(adapter);
+	if (rc)
+		goto out_fail;
+
+	leapraid_mask_int(adapter);
+
+	rc = leapraid_make_adapter_ready(adapter, PART_RESET);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Make adapter ready failure\n");
+		goto out_fail;
+	}
+
+	rc = leapraid_get_adapter_features(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Get adapter feature failure\n");
+		goto out_fail;
+	}
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
+	leapraid_free_irq(adapter);
+	leapraid_disable_pcie(adapter);
+	return rc;
+}
+
+void leapraid_disable_controller(struct leapraid_adapter *adapter)
+{
+	if (!adapter->iomem_base)
+		return;
+
+	leapraid_mask_int(adapter);
+
+	adapter->access_ctrl.shost_recovering = 1;
+	leapraid_make_adapter_ready(adapter, PART_RESET);
+	adapter->access_ctrl.shost_recovering = 0;
+	wake_up(&adapter->access_ctrl.recovery_waitq);
+
+	leapraid_free_irq(adapter);
+	leapraid_disable_pcie(adapter);
+}
+
+static int leapraid_adapter_unit_reset(struct leapraid_adapter *adapter)
+{
+	int rc = 0;
+
+	writel(LEAPRAID_FUNC_ADAPTER_UNIT_RESET << LEAPRAID_DB_FUNC_SHIFT,
+	       &adapter->iomem_base->db);
+	if (leapraid_db_wait_ack_and_clear_int(adapter))
+		rc = -EFAULT;
+
+	if (!leapraid_wait_adapter_ready(adapter)) {
+		dev_err(&adapter->pdev->dev, "unit reset failed\n");
+		return -EFAULT;
+	}
+
+	return rc;
+}
+
+static int leapraid_make_adapter_ready(struct leapraid_adapter *adapter,
+				       enum reset_type type)
+{
+	u32 db;
+	int count;
+
+	if (!leapraid_pci_active(adapter))
+		return 0;
+
+	count = 0;
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_RESET) {
+		while ((db & LEAPRAID_DB_MASK) != LEAPRAID_DB_READY) {
+			if (count++ == LEAPRAID_DB_RETRY_COUNT_MAX) {
+				dev_err(&adapter->pdev->dev,
+					"Wait adapter ready timeout\n");
+				return -EFAULT;
+			}
+			ssleep(1);
+			db = leapraid_readl(&adapter->iomem_base->db);
+			dev_info(&adapter->pdev->dev,
+				 "Wait adapter ready, count=%d, db=0x%x\n",
+				 count, db);
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
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_OPERATIONAL &&
+	    !leapraid_adapter_unit_reset(adapter))
+		return 0;
+
+full_reset:
+	return leapraid_host_diag_reset(adapter);
+}
+
+static void leapraid_fw_log_exit(struct leapraid_adapter *adapter)
+{
+	if (!adapter->fw_log_desc.open_pcie_trace)
+		return;
+
+	if (adapter->fw_log_desc.fw_log_buffer) {
+		dma_free_coherent(&adapter->pdev->dev,
+				  (LEAPRAID_SYS_LOG_BUF_SIZE +
+				   LEAPRAID_SYS_LOG_BUF_RESERVE),
+				  adapter->fw_log_desc.fw_log_buffer,
+				  adapter->fw_log_desc.fw_log_buffer_dma);
+		adapter->fw_log_desc.fw_log_buffer = NULL;
+	}
+}
+
+static int leapraid_fw_log_init(struct leapraid_adapter *adapter)
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
+	if (!adapter->fw_log_desc.fw_log_buffer) {
+		adapter->fw_log_desc.fw_log_buffer =
+			dma_alloc_coherent(
+				&adapter->pdev->dev,
+				(LEAPRAID_SYS_LOG_BUF_SIZE +
+				 LEAPRAID_SYS_LOG_BUF_RESERVE),
+				&adapter->fw_log_desc.fw_log_buffer_dma,
+				GFP_KERNEL);
+		if (!adapter->fw_log_desc.fw_log_buffer)
+			return -ENOMEM;
+	}
+
+	memset(&adapter_log_req, 0, sizeof(struct leapraid_adapter_log_req));
+	adapter_log_req.func = LEAPRAID_FUNC_LOGBUF_INIT;
+	buf_addr = adapter->fw_log_desc.fw_log_buffer_dma;
+
+	adapter_log_req.mbox.w[0] =
+		cpu_to_le32((u32)(buf_addr & 0xFFFFFFFF));
+	adapter_log_req.mbox.w[1] =
+		cpu_to_le32((u32)((buf_addr >> 32) & 0xFFFFFFFF));
+	adapter_log_req.mbox.w[2] =
+		cpu_to_le32(LEAPRAID_SYS_LOG_BUF_SIZE);
+	rc = leapraid_handshake_func(adapter,
+				     sizeof(struct leapraid_adapter_log_req),
+				     (u32 *)&adapter_log_req,
+				     sizeof(struct leapraid_adapter_log_rep),
+				     (u16 *)&adapter_log_rep);
+	if (rc != 0) {
+		dev_err(&adapter->pdev->dev, "%s: Handshake failed, rc=%d\n",
+			__func__, rc);
+		return rc;
+	}
+
+	adapter_status = le16_to_cpu(adapter_log_rep.adapter_status) &
+			LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev, "%s: failed!\n", __func__);
+		rc = -EIO;
+	}
+
+	return rc;
+}
+
+static void leapraid_free_host_memory(struct leapraid_adapter *adapter)
+{
+	unsigned int i;
+
+	if (adapter->mem_desc.task_desc) {
+		dma_free_coherent(&adapter->pdev->dev,
+				  adapter->adapter_attr.task_desc_dma_size,
+				  adapter->mem_desc.task_desc,
+				  adapter->mem_desc.task_desc_dma);
+		adapter->mem_desc.task_desc = NULL;
+	}
+
+	if (adapter->mem_desc.sense_data) {
+		dma_free_coherent(
+			&adapter->pdev->dev,
+			adapter->adapter_attr.io_qd * SCSI_SENSE_BUFFERSIZE,
+			adapter->mem_desc.sense_data,
+			adapter->mem_desc.sense_data_dma);
+		adapter->mem_desc.sense_data = NULL;
+	}
+
+	if (adapter->mem_desc.rep_msg) {
+		dma_free_coherent(
+			&adapter->pdev->dev,
+			adapter->adapter_attr.rep_msg_qd * LEAPRAID_REPLY_SIZE,
+			adapter->mem_desc.rep_msg,
+			adapter->mem_desc.rep_msg_dma);
+		adapter->mem_desc.rep_msg = NULL;
+	}
+
+	if (adapter->mem_desc.rep_msg_addr) {
+		dma_free_coherent(&adapter->pdev->dev,
+				  adapter->adapter_attr.rep_msg_qd *
+				  LEAPRAID_REP_MSG_ADDR_SIZE,
+				  adapter->mem_desc.rep_msg_addr,
+				  adapter->mem_desc.rep_msg_addr_dma);
+		adapter->mem_desc.rep_msg_addr = NULL;
+	}
+
+	if (adapter->mem_desc.rep_desc_seg_maint) {
+		for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt;
+		     i++) {
+			if (adapter->mem_desc.rep_desc_seg_maint[i]
+			    .rep_desc_seg) {
+				dma_free_coherent(
+					&adapter->pdev->dev,
+					(adapter->adapter_attr.rep_desc_qd *
+					 LEAPRAID_REP_DESC_ENTRY_SIZE) *
+					LEAPRAID_REP_DESC_CHUNK_SIZE,
+					adapter->mem_desc.rep_desc_seg_maint[i]
+						.rep_desc_seg,
+					adapter->mem_desc.rep_desc_seg_maint[i]
+						.rep_desc_seg_dma);
+				adapter->mem_desc.rep_desc_seg_maint[i]
+					.rep_desc_seg = NULL;
+			}
+		}
+
+		if (adapter->mem_desc.rep_desc_q_arr) {
+			dma_free_coherent(
+				&adapter->pdev->dev,
+				adapter->adapter_attr.rq_cnt *
+				LEAPRAID_REP_RQ_CNT_SIZE,
+				adapter->mem_desc.rep_desc_q_arr,
+				adapter->mem_desc.rep_desc_q_arr_dma);
+			adapter->mem_desc.rep_desc_q_arr = NULL;
+		}
+
+		for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt; i++)
+			kfree(adapter->mem_desc.rep_desc_seg_maint[i]
+				.rep_desc_maint);
+		kfree(adapter->mem_desc.rep_desc_seg_maint);
+	}
+
+	kfree(adapter->mem_desc.taskid_to_uniq_tag);
+	adapter->mem_desc.taskid_to_uniq_tag = NULL;
+
+	dma_pool_destroy(adapter->mem_desc.sg_chain_pool);
+}
+
+static inline bool leapraid_is_in_same_4g_seg(dma_addr_t start, u32 size)
+{
+	return upper_32_bits(start) == upper_32_bits(start + size - 1);
+}
+
+int leapraid_internal_init_cmd_priv(struct leapraid_adapter *adapter,
+				    struct leapraid_io_req_tracker *io_tracker)
+{
+	io_tracker->chain =
+		dma_pool_alloc(adapter->mem_desc.sg_chain_pool,
+			       GFP_KERNEL,
+			       &io_tracker->chain_dma);
+
+	if (!io_tracker->chain)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void leapraid_internal_exit_cmd_priv(struct leapraid_adapter *adapter,
+				     struct leapraid_io_req_tracker *io_tracker)
+{
+	if (io_tracker && io_tracker->chain)
+		dma_pool_free(adapter->mem_desc.sg_chain_pool,
+			      io_tracker->chain,
+			      io_tracker->chain_dma);
+}
+
+static int leapraid_request_host_memory(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_features *facts =
+			&adapter->adapter_attr.features;
+	u16 rep_desc_q_cnt_allocated;
+	unsigned int i, j;
+	int rc;
+
+	/* Scatter-gather table size. */
+	adapter->shost->sg_tablesize = LEAPRAID_SG_DEPTH;
+	if (reset_devices)
+		adapter->shost->sg_tablesize =
+				LEAPRAID_KDUMP_MIN_PHYS_SEGMENTS;
+	/* High-priority commands queue depth. */
+	adapter->dynamic_task_desc.hp_cmd_qd = LEAPRAID_FIXED_HP_CMDS;
+	/* Internal commands queue depth. */
+	adapter->dynamic_task_desc.inter_cmd_qd = LEAPRAID_FIXED_INTER_CMDS;
+	/* Adapter commands total queue depth. */
+	if (reset_devices)
+		adapter->adapter_attr.adapter_total_qd =
+			LEAPRAID_DEFAULT_CMD_QD_OFFSET +
+			adapter->dynamic_task_desc.inter_cmd_qd +
+			adapter->dynamic_task_desc.hp_cmd_qd;
+	else
+		adapter->adapter_attr.adapter_total_qd = facts->req_slot +
+				adapter->dynamic_task_desc.hp_cmd_qd;
+	/* Reply message queue depth. */
+	adapter->adapter_attr.rep_msg_qd =
+		adapter->adapter_attr.adapter_total_qd +
+		LEAPRAID_DEFAULT_CMD_QD_OFFSET;
+	/* Reply descriptor queue depth. */
+	adapter->adapter_attr.rep_desc_qd =
+		round_up(adapter->adapter_attr.adapter_total_qd +
+			 adapter->adapter_attr.rep_msg_qd +
+			 LEAPRAID_TASKID_OFFSET_CTRL_CMD,
+			 LEAPRAID_REPLY_QD_ALIGNMENT);
+	/* SCSI command I/O depth. */
+	adapter->adapter_attr.io_qd =
+		adapter->adapter_attr.adapter_total_qd -
+		adapter->dynamic_task_desc.hp_cmd_qd -
+		adapter->dynamic_task_desc.inter_cmd_qd;
+	/* SCSI host can queue. */
+	adapter->shost->can_queue = adapter->adapter_attr.io_qd -
+		LEAPRAID_TASKID_OFFSET_SCSIIO_CMD;
+	adapter->driver_cmds.ctl_cmd.taskid = adapter->shost->can_queue +
+		LEAPRAID_TASKID_OFFSET_CTRL_CMD;
+	adapter->driver_cmds.driver_scsiio_cmd.taskid =
+		adapter->shost->can_queue +
+		LEAPRAID_TASKID_OFFSET_SCSIIO_CMD;
+
+	/* Allocate task descriptor. */
+try_again:
+	adapter->adapter_attr.task_desc_dma_size =
+		(adapter->adapter_attr.adapter_total_qd +
+			LEAPRAID_TASKID_OFFSET_CTRL_CMD) *
+		LEAPRAID_REQUEST_SIZE;
+	adapter->mem_desc.task_desc =
+		dma_alloc_coherent(&adapter->pdev->dev,
+				   adapter->adapter_attr.task_desc_dma_size,
+				   &adapter->mem_desc.task_desc_dma,
+				   GFP_KERNEL);
+	if (!adapter->mem_desc.task_desc)
+		return -ENOMEM;
+
+	/* Allocate chain message pool. */
+	adapter->mem_desc.sg_chain_pool_size =
+		LEAPRAID_DEFAULT_CHAINS_PER_IO * LEAPRAID_CHAIN_SEG_SIZE;
+	adapter->mem_desc.sg_chain_pool =
+		dma_pool_create("leapraid chain pool",
+				&adapter->pdev->dev,
+				adapter->mem_desc.sg_chain_pool_size,
+				LEAPRAID_DMA_ALIGN, 0);
+	if (!adapter->mem_desc.sg_chain_pool)
+		return -ENOMEM;
+
+	/* Allocate I/O tracker to SCSI I/O. */
+
+	adapter->mem_desc.taskid_to_uniq_tag =
+		kcalloc(adapter->shost->can_queue, sizeof(u16), GFP_KERNEL);
+	if (!adapter->mem_desc.taskid_to_uniq_tag)
+		return -ENOMEM;
+
+	adapter->dynamic_task_desc.hp_taskid =
+		adapter->adapter_attr.io_qd +
+		LEAPRAID_HP_TASKID_OFFSET_CTL_CMD;
+	/* Allocate static high-priority task ID. */
+	adapter->driver_cmds.ctl_cmd.hp_taskid =
+		adapter->dynamic_task_desc.hp_taskid;
+	adapter->driver_cmds.tm_cmd.hp_taskid =
+		adapter->dynamic_task_desc.hp_taskid +
+		LEAPRAID_HP_TASKID_OFFSET_TM_CMD;
+
+	adapter->dynamic_task_desc.inter_taskid =
+		adapter->dynamic_task_desc.hp_taskid +
+		adapter->dynamic_task_desc.hp_cmd_qd;
+	adapter->driver_cmds.scan_dev_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid;
+	adapter->driver_cmds.cfg_op_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid +
+		LEAPRAID_TASKID_OFFSET_CFG_OP_CMD;
+	adapter->driver_cmds.transport_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid +
+		LEAPRAID_TASKID_OFFSET_TRANSPORT_CMD;
+	adapter->driver_cmds.timestamp_sync_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid +
+		LEAPRAID_TASKID_OFFSET_TIMESTAMP_SYNC_CMD;
+	adapter->driver_cmds.enc_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid +
+		LEAPRAID_TASKID_OFFSET_ENC_CMD;
+	adapter->driver_cmds.notify_event_cmd.inter_taskid =
+		adapter->dynamic_task_desc.inter_taskid +
+		LEAPRAID_TASKID_OFFSET_NOTIFY_EVENT_CMD;
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
+	 * Allocate sense data DMA buffer.
+	 * Constraint: Must reside within the same 4GB segment
+	 * (driver-maintained).
+	 */
+	adapter->mem_desc.sense_data =
+		dma_alloc_coherent(
+			&adapter->pdev->dev,
+			adapter->adapter_attr.io_qd * SCSI_SENSE_BUFFERSIZE,
+			&adapter->mem_desc.sense_data_dma,
+			GFP_KERNEL);
+	if (!adapter->mem_desc.sense_data)
+		return -ENOMEM;
+
+	if (!leapraid_is_in_same_4g_seg(adapter->mem_desc.sense_data_dma,
+					adapter->adapter_attr.io_qd *
+					SCSI_SENSE_BUFFERSIZE)) {
+		dev_warn(&adapter->pdev->dev,
+			 "Try 32bit DMA: Sense not in same 4G\n");
+		rc = -EAGAIN;
+		goto out_fail;
+	}
+
+	/*
+	 * Allocate reply frame buffer.
+	 * Constraint: Must reside in the same 4GB segment as the sense DMA.
+	 */
+	adapter->mem_desc.rep_msg =
+		dma_alloc_coherent(&adapter->pdev->dev,
+				   adapter->adapter_attr.rep_msg_qd *
+				   LEAPRAID_REPLY_SIZE,
+				   &adapter->mem_desc.rep_msg_dma,
+				   GFP_KERNEL);
+	if (!adapter->mem_desc.rep_msg)
+		return -ENOMEM;
+	if (!leapraid_is_in_same_4g_seg(adapter->mem_desc.rep_msg_dma,
+					adapter->adapter_attr.rep_msg_qd *
+					LEAPRAID_REPLY_SIZE)) {
+		dev_warn(&adapter->pdev->dev,
+			 "Use 32 bit DMA due to rep msg is not in same 4g!\n");
+		rc = -EAGAIN;
+		goto out_fail;
+	}
+
+	/* Address of reply frame. */
+	adapter->mem_desc.rep_msg_addr =
+		dma_alloc_coherent(&adapter->pdev->dev,
+				   adapter->adapter_attr.rep_msg_qd *
+				   LEAPRAID_REP_MSG_ADDR_SIZE,
+				   &adapter->mem_desc.rep_msg_addr_dma,
+				   GFP_KERNEL);
+	if (!adapter->mem_desc.rep_msg_addr)
+		return -ENOMEM;
+	adapter->adapter_attr.rep_desc_q_seg_cnt =
+		DIV_ROUND_UP(adapter->adapter_attr.rq_cnt,
+			     LEAPRAID_REP_DESC_CHUNK_SIZE);
+	adapter->mem_desc.rep_desc_seg_maint =
+		kcalloc(adapter->adapter_attr.rep_desc_q_seg_cnt,
+			sizeof(struct leapraid_rep_desc_seg_maint),
+			GFP_KERNEL);
+	if (!adapter->mem_desc.rep_desc_seg_maint)
+		return -ENOMEM;
+
+	rep_desc_q_cnt_allocated = 0;
+	for (i = 0; i < adapter->adapter_attr.rep_desc_q_seg_cnt; i++) {
+		adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint =
+			kcalloc(LEAPRAID_REP_DESC_CHUNK_SIZE,
+				sizeof(struct leapraid_rep_desc_maint),
+				GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_maint)
+			return -ENOMEM;
+
+		adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg =
+			dma_alloc_coherent(
+				&adapter->pdev->dev,
+				(adapter->adapter_attr.rep_desc_qd *
+				LEAPRAID_REP_DESC_ENTRY_SIZE) *
+				LEAPRAID_REP_DESC_CHUNK_SIZE,
+				&adapter->mem_desc.rep_desc_seg_maint[i]
+					.rep_desc_seg_dma,
+				GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_seg_maint[i].rep_desc_seg)
+			return -ENOMEM;
+
+		for (j = 0; j < LEAPRAID_REP_DESC_CHUNK_SIZE; j++) {
+			if (rep_desc_q_cnt_allocated >=
+			    adapter->adapter_attr.rq_cnt)
+				break;
+			adapter->mem_desc
+				.rep_desc_seg_maint[i]
+				.rep_desc_maint[j]
+				.rep_desc =
+					(void *)((u8 *)(
+					adapter->mem_desc
+						.rep_desc_seg_maint[i]
+						.rep_desc_seg) +
+					j *
+					(adapter->adapter_attr.rep_desc_qd *
+						LEAPRAID_REP_DESC_ENTRY_SIZE));
+			adapter->mem_desc
+				.rep_desc_seg_maint[i]
+				.rep_desc_maint[j]
+				.rep_desc_dma =
+					adapter->mem_desc
+						.rep_desc_seg_maint[i]
+						.rep_desc_seg_dma +
+					j *
+					(adapter->adapter_attr.rep_desc_qd *
+						LEAPRAID_REP_DESC_ENTRY_SIZE);
+			rep_desc_q_cnt_allocated++;
+		}
+	}
+
+	if (!reset_devices) {
+		adapter->mem_desc.rep_desc_q_arr =
+			dma_alloc_coherent(
+				&adapter->pdev->dev,
+				adapter->adapter_attr.rq_cnt *
+				LEAPRAID_REP_RQ_CNT_SIZE,
+				&adapter->mem_desc.rep_desc_q_arr_dma,
+				GFP_KERNEL);
+		if (!adapter->mem_desc.rep_desc_q_arr)
+			return -ENOMEM;
+	}
+
+	return 0;
+out_fail:
+	if (rc == -EAGAIN) {
+		leapraid_free_host_memory(adapter);
+		adapter->adapter_attr.use_32_dma_mask = 1;
+		rc = dma_set_mask_and_coherent(&adapter->pdev->dev,
+					       DMA_BIT_MASK(DMA_32_BITS));
+		if (rc) {
+			dev_err(&adapter->pdev->dev,
+				"Failed to set 32 DMA mask\n");
+			return rc;
+		}
+		goto try_again;
+	}
+	return rc;
+}
+
+static int leapraid_alloc_dev_topo_bitmaps(struct leapraid_adapter *adapter)
+{
+	u16 pd_hdls_sz;
+
+	pd_hdls_sz =
+		BITS_TO_LONGS(
+			adapter->adapter_attr.features.max_dev_handle + 1) *
+		sizeof(unsigned long);
+
+	adapter->dev_topo.pd_hdls_sz = pd_hdls_sz;
+	adapter->dev_topo.pd_hdls =
+		kzalloc(adapter->dev_topo.pd_hdls_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.pd_hdls)
+		return -ENOMEM;
+
+	adapter->dev_topo.blocking_hdls =
+		kzalloc(adapter->dev_topo.pd_hdls_sz, GFP_KERNEL);
+	if (!adapter->dev_topo.blocking_hdls)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void leapraid_free_dev_topo_bitmaps(struct leapraid_adapter *adapter)
+{
+	kfree(adapter->dev_topo.pd_hdls);
+	kfree(adapter->dev_topo.blocking_hdls);
+}
+
+static int leapraid_init_driver_cmds(struct leapraid_adapter *adapter)
+{
+	u32 buffer_size;
+	void *buffer;
+
+	INIT_LIST_HEAD(&adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.scan_dev_cmd.cb_idx = LEAPRAID_SCAN_DEV_CB_IDX;
+	list_add_tail(&adapter->driver_cmds.scan_dev_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.cfg_op_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.cfg_op_cmd.cb_idx = LEAPRAID_CONFIG_CB_IDX;
+	mutex_init(&adapter->driver_cmds.cfg_op_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.cfg_op_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.transport_cmd.cb_idx = LEAPRAID_TRANSPORT_CB_IDX;
+	mutex_init(&adapter->driver_cmds.transport_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.transport_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.timestamp_sync_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.timestamp_sync_cmd.cb_idx =
+		LEAPRAID_TIMESTAMP_SYNC_CB_IDX;
+	mutex_init(&adapter->driver_cmds.timestamp_sync_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.timestamp_sync_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.raid_action_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.raid_action_cmd.cb_idx =
+		LEAPRAID_RAID_ACTION_CB_IDX;
+	mutex_init(&adapter->driver_cmds.raid_action_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.raid_action_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.driver_scsiio_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.driver_scsiio_cmd.cb_idx =
+		LEAPRAID_DRIVER_SCSIIO_CB_IDX;
+	mutex_init(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.driver_scsiio_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	buffer_size = sizeof(struct scsi_cmnd) +
+		sizeof(struct leapraid_io_req_tracker) +
+		SCSI_SENSE_BUFFERSIZE +
+		sizeof(struct scatterlist);
+	buffer = kzalloc(buffer_size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	adapter->driver_cmds.internal_scmd = buffer;
+	buffer = (u8 *)buffer + sizeof(struct scsi_cmnd) +
+			sizeof(struct leapraid_io_req_tracker);
+	adapter->driver_cmds.internal_scmd->sense_buffer =
+			(unsigned char *)buffer;
+	buffer = (u8 *)buffer + SCSI_SENSE_BUFFERSIZE;
+	adapter->driver_cmds.internal_scmd->sdb.table.sgl =
+			(struct scatterlist *)buffer;
+	buffer = (u8 *)buffer + sizeof(struct scatterlist);
+
+	adapter->driver_cmds.enc_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.enc_cmd.cb_idx = LEAPRAID_ENC_CB_IDX;
+	mutex_init(&adapter->driver_cmds.enc_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.enc_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.notify_event_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.notify_event_cmd.cb_idx =
+		LEAPRAID_NOTIFY_EVENT_CB_IDX;
+	mutex_init(&adapter->driver_cmds.notify_event_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.notify_event_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.ctl_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.ctl_cmd.cb_idx = LEAPRAID_CTL_CB_IDX;
+	mutex_init(&adapter->driver_cmds.ctl_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.ctl_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_NOT_USED;
+	adapter->driver_cmds.tm_cmd.cb_idx = LEAPRAID_TM_CB_IDX;
+	mutex_init(&adapter->driver_cmds.tm_cmd.mutex);
+	list_add_tail(&adapter->driver_cmds.tm_cmd.list,
+		      &adapter->driver_cmds.special_cmd_list);
+
+	return 0;
+}
+
+static void leapraid_unmask_evts(struct leapraid_adapter *adapter, u16 evt)
+{
+	if (evt >= LEAPRAID_MAX_EVENT_NUM)
+		return;
+
+	clear_bit(evt, (unsigned long *)adapter->fw_evt_s.leapraid_evt_masks);
+}
+
+static void leapraid_init_event_mask(struct leapraid_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < LEAPRAID_EVT_MASK_COUNT; i++)
+		adapter->fw_evt_s.leapraid_evt_masks[i] =
+			LEAPRAID_INVALID_INITIAL_VALUE;
+
+	leapraid_unmask_evts(adapter, LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST);
+	leapraid_unmask_evts(adapter, LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE);
+	leapraid_unmask_evts(adapter, LEAPRAID_EVT_SAS_DEV_STATUS_CHANGE);
+	leapraid_unmask_evts(adapter, LEAPRAID_EVT_IR_CHANGE);
+}
+
+static void leapraid_prepare_adapter_init_req(
+		struct leapraid_adapter *adapter,
+		struct leapraid_adapter_init_req *init_req)
+{
+	ktime_t cur_time;
+	int i, chunk;
+	u32 reply_post_free_ary_sz;
+
+	memset(init_req, 0, sizeof(struct leapraid_adapter_init_req));
+	init_req->func = LEAPRAID_FUNC_ADAPTER_INIT;
+	init_req->who_init = LEAPRAID_WHOINIT_LINUX_DRIVER;
+	init_req->msg_ver = cpu_to_le16(LEAPRAID_MSG_VERSION);
+	init_req->header_ver = cpu_to_le16(LEAPRAID_HEADER_VERSION);
+	init_req->driver_ver =
+		cpu_to_le32((LEAPRAID_MAJOR_VERSION <<
+				LEAPRAID_VER_MAJOR_SHIFT) |
+			(LEAPRAID_MINOR_VERSION << LEAPRAID_VER_MINOR_SHIFT) |
+			(LEAPRAID_BUILD_VERSION << LEAPRAID_VER_BUILD_SHIFT) |
+			LEAPRAID_RELEASE_VERSION);
+	if (adapter->notification_desc.msix_enable)
+		init_req->host_msix_vectors = adapter->adapter_attr.rq_cnt;
+
+	init_req->req_frame_size =
+		cpu_to_le16(LEAPRAID_REQUEST_SIZE / LEAPRAID_DWORDS_BYTE_SIZE);
+	init_req->rep_desc_qd =
+		cpu_to_le16(adapter->adapter_attr.rep_desc_qd);
+	init_req->rep_msg_qd =
+		cpu_to_le16(adapter->adapter_attr.rep_msg_qd);
+	init_req->sense_buffer_add_high =
+		cpu_to_le32((u64)adapter->mem_desc.sense_data_dma >> 32);
+	init_req->rep_msg_dma_high =
+		cpu_to_le32((u64)adapter->mem_desc.rep_msg_dma >> 32);
+	init_req->task_desc_base_addr =
+		cpu_to_le64((u64)adapter->mem_desc.task_desc_dma);
+	init_req->rep_msg_addr_dma =
+		cpu_to_le64((u64)adapter->mem_desc.rep_msg_addr_dma);
+	if (!reset_devices) {
+		reply_post_free_ary_sz =
+			adapter->adapter_attr.rq_cnt * LEAPRAID_REP_RQ_CNT_SIZE;
+		memset(adapter->mem_desc.rep_desc_q_arr, 0,
+		       reply_post_free_ary_sz);
+
+		chunk = LEAPRAID_REP_DESC_CHUNK_SIZE;
+		for (i = 0; i < adapter->adapter_attr.rq_cnt; i++)
+			adapter->mem_desc.rep_desc_q_arr[i].rep_desc_base_addr =
+				cpu_to_le64 ((u64)adapter->mem_desc
+					     .rep_desc_seg_maint[i / chunk]
+					     .rep_desc_maint[i % chunk]
+					     .rep_desc_dma);
+
+		init_req->msg_flg =
+			LEAPRAID_ADAPTER_INIT_MSGFLG_RDPQ_ARRAY_MODE;
+		init_req->rep_desc_q_arr_addr =
+			cpu_to_le64((u64)adapter->mem_desc.rep_desc_q_arr_dma);
+	} else {
+		init_req->rep_desc_q_arr_addr =
+			cpu_to_le64((u64)adapter->mem_desc
+					.rep_desc_seg_maint[0]
+					.rep_desc_maint[0]
+					.rep_desc_dma);
+	}
+	cur_time = ktime_get_real();
+	init_req->time_stamp = cpu_to_le64(ktime_to_ms(cur_time));
+}
+
+static int leapraid_send_adapter_init(struct leapraid_adapter *adapter)
+{
+	struct leapraid_adapter_init_req init_req;
+	struct leapraid_adapter_init_rep init_rep;
+	u16 adapter_status;
+	int rc;
+
+	leapraid_prepare_adapter_init_req(adapter, &init_req);
+
+	rc = leapraid_handshake_func(adapter,
+				     sizeof(struct leapraid_adapter_init_req),
+				     (u32 *)&init_req,
+				     sizeof(struct leapraid_adapter_init_rep),
+				     (u16 *)&init_rep);
+	if (rc != 0) {
+		dev_err(&adapter->pdev->dev, "%s: Handshake failed, rc=%d\n",
+			__func__, rc);
+		return rc;
+	}
+
+	adapter_status =
+		le16_to_cpu(init_rep.adapter_status) &
+		LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev, "%s: failed\n", __func__);
+		rc = -EIO;
+	}
+
+	adapter->timestamp_sync_cnt = 0;
+	return rc;
+}
+
+static int leapraid_cfg_pages(struct leapraid_adapter *adapter)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	union {
+		struct leapraid_manufacturing_p0 manufacturing_page0;
+		struct leapraid_bios_page3 bios_page3;
+		struct leapraid_bios_page2 bios_page2;
+	} cfg_page;
+	int rc;
+
+	rc = leapraid_op_config_page(adapter, &cfg_page.bios_page3, cfgp1,
+				     cfgp2, GET_BIOS_PG3);
+	if (rc)
+		return rc;
+
+	adapter->adapter_attr.bios_version =
+		le32_to_cpu(cfg_page.bios_page3.bios_version);
+
+	rc = leapraid_op_config_page(adapter, &cfg_page.bios_page2, cfgp1,
+				     cfgp2, GET_BIOS_PG2);
+	if (rc)
+		return rc;
+
+	adapter->boot_devs.requested_boot_dev.form =
+		cfg_page.bios_page2.requested_boot_dev_form;
+	memcpy(adapter->boot_devs.requested_boot_dev.pg_dev,
+	       &cfg_page.bios_page2.requested_boot_dev,
+	       LEAPRAID_BOOT_DEV_SIZE);
+	adapter->boot_devs.requested_alt_boot_dev.form =
+		cfg_page.bios_page2.requested_alt_boot_dev_form;
+	memcpy(adapter->boot_devs.requested_alt_boot_dev.pg_dev,
+	       &cfg_page.bios_page2.requested_alt_boot_dev,
+	       LEAPRAID_BOOT_DEV_SIZE);
+	adapter->boot_devs.current_boot_dev.form =
+		cfg_page.bios_page2.current_boot_dev_form;
+	memcpy(adapter->boot_devs.current_boot_dev.pg_dev,
+	       &cfg_page.bios_page2.current_boot_dev,
+	       LEAPRAID_BOOT_DEV_SIZE);
+
+	rc = leapraid_op_config_page(adapter, &cfg_page.manufacturing_page0,
+				     cfgp1, cfgp2, GET_MANUFACTURING_PG0);
+	if (rc)
+		return rc;
+
+	snprintf(adapter->adapter_attr.board_name,
+		 sizeof(adapter->adapter_attr.board_name),
+		 "%.*s",
+		 (int)sizeof(cfg_page.manufacturing_page0.board_name),
+		 cfg_page.manufacturing_page0.board_name);
+	return rc;
+}
+
+static int leapraid_evt_notify(struct leapraid_adapter *adapter)
+{
+	struct leapraid_evt_notify_req *evt_notify_req;
+	struct leapraid_evt_notify_rep *evt_notify_rep;
+	u16 adapter_status;
+	int rc = 0;
+	int i;
+
+	mutex_lock(&adapter->driver_cmds.notify_event_cmd.mutex);
+	adapter->driver_cmds.notify_event_cmd.status = LEAPRAID_CMD_PENDING;
+	evt_notify_req =
+		leapraid_get_task_desc(
+			adapter,
+			adapter->driver_cmds.notify_event_cmd.inter_taskid);
+	memset(evt_notify_req, 0, sizeof(struct leapraid_evt_notify_req));
+	evt_notify_req->func = LEAPRAID_FUNC_EVENT_NOTIFY;
+	for (i = 0; i < LEAPRAID_EVT_MASK_COUNT; i++)
+		evt_notify_req->evt_masks[i] =
+			cpu_to_le32(adapter->fw_evt_s.leapraid_evt_masks[i]);
+	init_completion(&adapter->driver_cmds.notify_event_cmd.done);
+	leapraid_fire_task(adapter,
+			   adapter->driver_cmds.notify_event_cmd.inter_taskid);
+	wait_for_completion_timeout(
+		&adapter->driver_cmds.notify_event_cmd.done,
+		LEAPRAID_NOTIFY_EVENT_CMD_TIMEOUT * HZ);
+
+	if (!(adapter->driver_cmds.notify_event_cmd.status &
+	      LEAPRAID_CMD_DONE)) {
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+	if (!(adapter->driver_cmds.notify_event_cmd.status &
+	      LEAPRAID_CMD_REPLY_VALID)) {
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+	evt_notify_rep = (void *)&adapter->driver_cmds.notify_event_cmd.reply;
+	adapter_status = le16_to_cpu(evt_notify_rep->adapter_status) &
+			 LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS)
+		rc = -EFAULT;
+
+out_cleanup:
+	adapter->driver_cmds.notify_event_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.notify_event_cmd.mutex);
+
+	return rc;
+}
+
+int leapraid_scan_dev(struct leapraid_adapter *adapter, bool async_scan_dev)
+{
+	struct leapraid_scan_dev_req *scan_dev_req;
+	struct leapraid_scan_dev_rep *scan_dev_rep;
+	u16 adapter_status;
+	int rc = 0;
+
+	dev_info(&adapter->pdev->dev,
+		 "Send device scan, async_scan_dev=%d!\n", async_scan_dev);
+
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_PENDING;
+	adapter->driver_cmds.scan_dev_cmd.async_scan_dev = async_scan_dev;
+	scan_dev_req =
+		leapraid_get_task_desc(
+			adapter,
+			adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+	memset(scan_dev_req, 0, sizeof(struct leapraid_scan_dev_req));
+	scan_dev_req->func = LEAPRAID_FUNC_SCAN_DEV;
+
+	if (async_scan_dev) {
+		adapter->scan_dev_desc.first_scan_dev_fired = 1;
+		leapraid_fire_task(
+			adapter,
+			adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+		return 0;
+	}
+
+	init_completion(&adapter->driver_cmds.scan_dev_cmd.done);
+	leapraid_fire_task(adapter,
+			   adapter->driver_cmds.scan_dev_cmd.inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.scan_dev_cmd.done,
+				    LEAPRAID_SCAN_DEV_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.scan_dev_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev, "Device scan timeout!\n");
+		if (adapter->driver_cmds.scan_dev_cmd.status &
+		    LEAPRAID_CMD_RESET)
+			rc = -EFAULT;
+		else
+			rc = -ETIME;
+		goto out_cleanup;
+	}
+
+	scan_dev_rep = (void *)&adapter->driver_cmds.scan_dev_cmd.reply;
+	adapter_status =
+		le16_to_cpu(scan_dev_rep->adapter_status) &
+		LEAPRAID_ADAPTER_STATUS_MASK;
+	if (adapter_status != LEAPRAID_ADAPTER_STATUS_SUCCESS) {
+		dev_err(&adapter->pdev->dev, "Device scan failure!\n");
+		rc = -EFAULT;
+		goto out_cleanup;
+	}
+
+out_cleanup:
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_NOT_USED;
+	return rc;
+}
+
+static void leapraid_init_task_tracker(struct leapraid_adapter *adapter)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->dynamic_task_desc.task_lock, flags);
+
+	spin_unlock_irqrestore(&adapter->dynamic_task_desc.task_lock, flags);
+}
+
+static void leapraid_init_rep_msg_addr(struct leapraid_adapter *adapter)
+{
+	u32 reply_address;
+	unsigned int i;
+
+	for (i = 0, reply_address = (u32)adapter->mem_desc.rep_msg_dma;
+	     i < adapter->adapter_attr.rep_msg_qd;
+	     i++, reply_address += LEAPRAID_REPLY_SIZE)
+		adapter->mem_desc.rep_msg_addr[i] = cpu_to_le32(reply_address);
+}
+
+static void init_rep_desc(
+		struct leapraid_rq *rq,
+		int index,
+		union leapraid_rep_desc_union *reply_post_free_contig)
+{
+	struct leapraid_adapter *adapter = rq->adapter;
+	unsigned int i;
+
+	if (!reset_devices)
+		rq->rep_desc =
+			adapter->mem_desc
+				.rep_desc_seg_maint[index /
+					LEAPRAID_REP_DESC_CHUNK_SIZE]
+				.rep_desc_maint[index %
+					LEAPRAID_REP_DESC_CHUNK_SIZE]
+				.rep_desc;
+	else
+		rq->rep_desc = reply_post_free_contig;
+
+	rq->rep_post_host_idx = 0;
+	for (i = 0; i < adapter->adapter_attr.rep_desc_qd; i++)
+		rq->rep_desc[i].words = cpu_to_le64(ULLONG_MAX);
+}
+
+static void leapraid_init_rep_desc(struct leapraid_adapter *adapter)
+{
+	union leapraid_rep_desc_union *reply_post_free_contig;
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	unsigned int i;
+	int index;
+
+	index = 0;
+	reply_post_free_contig = adapter->mem_desc
+					.rep_desc_seg_maint[0]
+					.rep_desc_maint[0]
+					.rep_desc;
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		init_rep_desc(&int_rq->rq, index, reply_post_free_contig);
+		if (!reset_devices)
+			index++;
+		else
+			reply_post_free_contig +=
+				adapter->adapter_attr.rep_desc_qd;
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq = &adapter->notification_desc.blk_mq_poll_rqs[i];
+		init_rep_desc(&blk_mq_poll_rq->rq,
+			      index, reply_post_free_contig);
+		if (!reset_devices)
+			index++;
+		else
+			reply_post_free_contig +=
+				adapter->adapter_attr.rep_desc_qd;
+	}
+}
+
+static void leapraid_init_bar_idx_regs(struct leapraid_adapter *adapter)
+{
+	struct leapraid_int_rq *int_rq;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	unsigned int i, j;
+
+	adapter->rep_msg_host_idx = adapter->adapter_attr.rep_msg_qd - 1;
+	writel(adapter->rep_msg_host_idx,
+	       &adapter->iomem_base->rep_msg_host_idx);
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qdex; i++) {
+		int_rq = &adapter->notification_desc.int_rqs[i];
+		for (j = 0; j < REP_POST_HOST_IDX_REG_CNT; j++)
+			writel((int_rq->rq.msix_idx & 7) <<
+				LEAPRAID_RPHI_MSIX_IDX_SHIFT,
+				&adapter->iomem_base->rep_post_reg_idx[j].idx);
+	}
+
+	for (i = 0; i < adapter->notification_desc.iopoll_qcnt; i++) {
+		blk_mq_poll_rq =
+			&adapter->notification_desc.blk_mq_poll_rqs[i];
+		for (j = 0; j < REP_POST_HOST_IDX_REG_CNT; j++)
+			writel((blk_mq_poll_rq->rq.msix_idx & 7) <<
+				LEAPRAID_RPHI_MSIX_IDX_SHIFT,
+				&adapter->iomem_base->rep_post_reg_idx[j].idx);
+	}
+}
+
+static int leapraid_make_adapter_available(struct leapraid_adapter *adapter)
+{
+	int rc;
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
+		adapter->scan_dev_desc.wait_scan_dev_done = 1;
+		return 0;
+	}
+
+	return leapraid_scan_dev(adapter, false);
+}
+
+int leapraid_ctrl_init(struct leapraid_adapter *adapter)
+{
+	u32 cap;
+	int rc;
+
+	rc = leapraid_set_pcie_and_notification(adapter);
+	if (rc)
+		goto out_free;
+
+	pci_set_drvdata(adapter->pdev, adapter->shost);
+
+	pcie_capability_read_dword(adapter->pdev, PCI_EXP_DEVCAP, &cap);
+
+	if (cap & PCI_EXP_DEVCAP_EXT_TAG)
+		pcie_capability_set_word(adapter->pdev, PCI_EXP_DEVCTL,
+					 PCI_EXP_DEVCTL_EXT_TAG);
+
+	rc = leapraid_fw_log_init(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "FW log init failure\n");
+		goto out_free;
+	}
+
+	rc = leapraid_request_host_memory(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Request host memory failure\n");
+		goto out_free;
+	}
+
+	init_waitqueue_head(&adapter->reset_desc.reset_wait_queue);
+	init_waitqueue_head(&adapter->access_ctrl.shost_recover_wq);
+
+	rc = leapraid_alloc_dev_topo_bitmaps(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Alloc topo bitmaps failure\n");
+		goto out_free;
+	}
+
+	rc = leapraid_init_driver_cmds(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev, "Init driver cmds failure\n");
+		goto out_free;
+	}
+
+	leapraid_init_event_mask(adapter);
+
+	rc = leapraid_make_adapter_available(adapter);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"Make adapter available failure\n");
+		goto out_free;
+	}
+
+	leapraid_overheat_init(adapter);
+	if (!adapter->overheat_desc.fault_overheat_wq) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	adapter->access_ctrl.host_removing = 1;
+	leapraid_fw_log_exit(adapter);
+	leapraid_free_internal_scsi_cmd(adapter);
+	leapraid_disable_controller(adapter);
+	leapraid_free_host_memory(adapter);
+	leapraid_free_dev_topo_bitmaps(adapter);
+	pci_set_drvdata(adapter->pdev, NULL);
+	return rc;
+}
+
+void leapraid_remove_ctrl(struct leapraid_adapter *adapter)
+{
+	leapraid_overheat_cleanup(adapter);
+	leapraid_check_scheduled_fault_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	leapraid_fw_log_exit(adapter);
+	leapraid_free_internal_scsi_cmd(adapter);
+	leapraid_disable_controller(adapter);
+	leapraid_free_host_memory(adapter);
+	leapraid_free_dev_topo_bitmaps(adapter);
+	leapraid_free_enc_list(adapter);
+	pci_set_drvdata(adapter->pdev, NULL);
+}
+
+void leapraid_free_internal_scsi_cmd(struct leapraid_adapter *adapter)
+{
+	mutex_lock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+	kfree(adapter->driver_cmds.internal_scmd);
+	adapter->driver_cmds.internal_scmd = NULL;
+	mutex_unlock(&adapter->driver_cmds.driver_scsiio_cmd.mutex);
+}
diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/leapraid_func.h
new file mode 100644
index 000000000000..eb8449169469
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -0,0 +1,1558 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
+#ifndef LEAPRAID_FUNC_H_INCLUDED
+#define LEAPRAID_FUNC_H_INCLUDED
+
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/poll.h>
+#include <linux/atomic.h>
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
+/* Request and reply buffer size. */
+#define LEAPRAID_REQUEST_SIZE                   128
+#define LEAPRAID_REPLY_SIZE                     128
+#define LEAPRAID_CHAIN_SEG_SIZE                 128
+#define LEAPRAID_MAX_SGES_IN_CHAIN              7
+#define LEAPRAID_DEFAULT_CHAINS_PER_IO          19
+#define LEAPRAID_DEFAULT_DIX_CHAINS_PER_IO      \
+	(2 * LEAPRAID_DEFAULT_CHAINS_PER_IO) /* TODO DIX */
+#define LEAPRAID_IEEE_SGE64_ENTRY_SIZE          16
+#define LEAPRAID_REP_DESC_CHUNK_SIZE            16
+#define LEAPRAID_REP_DESC_ENTRY_SIZE            8
+#define LEAPRAID_REP_MSG_ADDR_SIZE              4
+#define LEAPRAID_REP_RQ_CNT_SIZE                16
+
+#define LEAPRAID_SYS_LOG_BUF_SIZE       0x200000
+#define LEAPRAID_SYS_LOG_BUF_RESERVE    0x1000
+
+/* Driver version and name. */
+#define LEAPRAID_DRIVER_NAME            "LeapRAID"
+#define LEAPRAID_NAME_LENGTH            48
+#define LEAPRAID_BOARD_NAME_LENGTH      17
+#define LEAPRAID_AUTHOR                 "LeapIO Inc."
+#define LEAPRAID_DESCRIPTION            "LeapRAID Driver"
+#define LEAPRAID_DRIVER_VERSION         "2.00.01.05"
+#define LEAPRAID_MAJOR_VERSION          2
+#define LEAPRAID_MINOR_VERSION          00
+#define LEAPRAID_BUILD_VERSION          01
+#define LEAPRAID_RELEASE_VERSION        05
+#define LEAPRAID_MSG_VERSION            0x1021
+#define LEAPRAID_HEADER_VERSION         0x0000
+
+/* Device ID. */
+#define LEAPRAID_VENDOR_ID      0xD405
+#define LEAPRAID_DEVID_HBA      0x8200
+#define LEAPRAID_SUBVENDOR_ID   0xD405
+#define LEAPRAID_SUBDEVID_HBA   0x8200
+
+#define LEAPRAID_PCI_VENDOR_ID_MASK     0xFFFF
+
+ /* RAID virtual channel ID. */
+#define RAID_CHANNEL    1
+
+/* Scatter-gather (SG) segment limits. */
+#define LEAPRAID_MAX_PHYS_SEGMENTS      SG_CHUNK_SIZE
+
+#define LEAPRAID_KDUMP_MIN_PHYS_SEGMENTS        32
+#define LEAPRAID_SG_DEPTH                       LEAPRAID_MAX_PHYS_SEGMENTS
+
+/* Firmware and config page operations. */
+#define LEAPRAID_SET_PARAMETER_SYNC_TIMESTAMP   0x81
+#define LEAPRAID_CFG_REQ_RETRY_TIMES    2
+
+/* Hardware access helpers. */
+#define leapraid_readl(addr) readl(addr)
+#define leapraid_check_reset(status) \
+	(!((status) & LEAPRAID_CMD_RESET))
+
+/* Polling intervals. */
+#define LEAPRAID_PCIE_LOG_POLLING_INTERVAL      1
+#define LEAPRAID_FAULT_POLLING_INTERVAL         1000
+#define LEAPRAID_TIMESTAMP_SYNC_INTERVAL        900
+#define LEAPRAID_SMART_POLLING_INTERVAL         (300 * 1000)
+
+/* Init mask. */
+#define LEAPRAID_RESET_IRQ_MASK 0x40000000
+#define LEAPRAID_REPLY_INT_MASK 0x00000008
+#define LEAPRAID_TO_SYS_DB_MASK 0x00000001
+
+/* Queue depth. */
+#define LEAPRAID_SATA_QUEUE_DEPTH       32
+#define LEAPRAID_SAS_QUEUE_DEPTH        64
+#define LEAPRAID_RAID_QUEUE_DEPTH       64
+
+/* Target probe flag. */
+#define LEAPRAID_NO_ULD_ATTACH_FLAG 1
+#define LEAPRAID_ULD_ATTACH_FLAG    0
+
+/* SCSI device and queue limits. */
+#define LEAPRAID_MAX_SECTORS            2048
+#define LEAPRAID_MAX_CDB_LEN            32
+#define LEAPRAID_MAX_LUNS               16384
+#define LEAPRAID_CAN_QUEUE_MIN          1
+#define LEAPRAID_THIS_ID_NONE           -1
+#define LEAPRAID_CMD_PER_LUN            128
+#define LEAPRAID_MAX_SEGMENT_SIZE       0xffffffff
+
+/* SCSI sense and ASC/ASCQ and disk geometry configuration. */
+#define DESC_FORMAT_THRESHOLD                   0x72
+#define SENSE_KEY_MASK                          0x0F
+#define SCSI_SENSE_RESPONSE_CODE_MASK           0x7F
+#define ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED       0x5D
+#define LEAPRAID_LARGE_DISK_THRESHOLD           0x200000UL
+#define LEAPRAID_LARGE_DISK_HEADS               255
+#define LEAPRAID_LARGE_DISK_SECTORS             63
+#define LEAPRAID_SMALL_DISK_HEADS               64
+#define LEAPRAID_SMALL_DISK_SECTORS             32
+
+/* SMP (Serial Management Protocol). */
+#define LEAPRAID_SMP_PT_FLAG_SGL_PTR            0x80
+#define LEAPRAID_SMP_FRAME_HEADER_SIZE          4
+#define LEAPRAID_SCSI_HOST_SHIFT                16
+#define LEAPRAID_SCSI_DRIVER_SHIFT              24
+
+/* SCSI ASC/ASCQ definitions. */
+#define LEAPRAID_SCSI_ASCQ_DEFAULT              0x00
+#define LEAPRAID_SCSI_ASC_POWER_ON_RESET        0x29
+#define LEAPRAID_SCSI_ASC_INVALID_CMD_CODE      0x20
+#define LEAPRAID_SCSI_ASCQ_POWER_ON_RESET       0x07
+
+/* VPD Page 0x89 (ATA Information). */
+#define LEAPRAID_VPD_PAGE_ATA_INFO      0x89
+#define LEAPRAID_VPD_PG89_MAX_LEN       255
+#define LEAPRAID_VPD_PG89_MIN_LEN       214
+
+/* Byte index for NCQ support flag in VPD page 0x89. */
+#define LEAPRAID_VPD_PG89_NCQ_BYTE_IDX  213
+#define LEAPRAID_VPD_PG89_NCQ_BIT_SHIFT 4
+#define LEAPRAID_VPD_PG89_NCQ_BIT_MASK  0x1
+
+/* Readiness polling: max retries, sleep µs between. */
+#define LEAPRAID_ADAPTER_READY_MAX_RETRY        15000
+#define LEAPRAID_ADAPTER_READY_SLEEP_MIN_US     1000
+#define LEAPRAID_ADAPTER_READY_SLEEP_MAX_US     1100
+
+/* Doorbell wait parameters. */
+#define LEAPRAID_DB_WAIT_MAX_RETRY      20000
+#define LEAPRAID_DB_WAIT_DELAY_US       500
+
+/* Basic data size definitions. */
+#define LEAPRAID_DWORDS_BYTE_SIZE       4
+#define LEAPRAID_WORD_BYTE_SIZE         2
+
+/* SGL threshold and chain offset. */
+#define LEAPRAID_SGL_INLINE_THRESHOLD   2
+#define LEAPRAID_CHAIN_OFFSET_DWORDS    7
+
+/* MSI-X group size and mask. */
+#define LEAPRAID_MSIX_GROUP_SIZE        8
+#define LEAPRAID_MSIX_GROUP_MASK        7
+
+/* Basic constants and limits.   */
+#define LEAPRAID_BUSY_LIMIT             1
+#define LEAPRAID_INVALID_HOST_DIAG_VAL  0xFFFFFFFF
+
+/* Retry/Sleep configuration. */
+#define LEAPRAID_WRSEQ_FLUSH_KEY_VALUE  0x0
+#define LEAPRAID_WRSEQ_1ST_KEY_VALUE    0xF
+#define LEAPRAID_WRSEQ_2ND_KEY_VALUE    0x4
+#define LEAPRAID_WRSEQ_3RD_KEY_VALUE    0xB
+#define LEAPRAID_WRSEQ_4TH_KEY_VALUE    0x2
+#define LEAPRAID_WRSEQ_5TH_KEY_VALUE    0x7
+#define LEAPRAID_WRSEQ_6TH_KEY_VALUE    0xD
+#define LEAPRAID_UNLOCK_RETRY_LIMIT     20
+#define LEAPRAID_UNLOCK_SLEEP_MS        100
+#define LEAPRAID_MSLEEP_NORMAL_MS       100
+#define LEAPRAID_MSLEEP_EXTRA_LONG_MS   500
+#define LEAPRAID_IO_POLL_DELAY_US       500
+
+/* Device/Volume configuration. */
+#define LEAPRAID_MAX_VOLUMES_DEFAULT    32
+#define LEAPRAID_MAX_DEV_HANDLE_DEFAULT 2048
+#define LEAPRAID_INVALID_DEV_HANDLE     0xFFFF
+
+/* Commands queue depth. */
+#define LEAPRAID_DEFAULT_CMD_QD_OFFSET  64
+#define LEAPRAID_REPLY_QD_ALIGNMENT     16
+/* Task ID offset. */
+#define LEAPRAID_TASKID_OFFSET_CTRL_CMD         1
+#define LEAPRAID_TASKID_OFFSET_SCSIIO_CMD       2
+#define LEAPRAID_TASKID_OFFSET_CFG_OP_CMD               1
+#define LEAPRAID_TASKID_OFFSET_TRANSPORT_CMD            2
+#define LEAPRAID_TASKID_OFFSET_TIMESTAMP_SYNC_CMD       3
+#define LEAPRAID_TASKID_OFFSET_ENC_CMD                  4
+#define LEAPRAID_TASKID_OFFSET_NOTIFY_EVENT_CMD         5
+
+/* Task ID offset for high-priority. */
+#define LEAPRAID_HP_TASKID_OFFSET_CTL_CMD       0
+#define LEAPRAID_HP_TASKID_OFFSET_TM_CMD        1
+
+/* Event/Boot configuration. */
+#define LEAPRAID_EVT_MASK_COUNT 4
+#define LEAPRAID_BOOT_DEV_SIZE  24
+
+/* Commands timeout. */
+#define LEAPRAID_UNIFIED_TIMEOUT               30
+#define LEAPRAID_CFG_OP_TIMEOUT                LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_CTL_CMD_TIMEOUT               LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_SCAN_DEV_CMD_TIMEOUT          300
+#define LEAPRAID_TIMESTAMP_SYNC_CMD_TIMEOUT    LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_ENC_CMD_TIMEOUT               LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_IO_CMD_TIMEOUT                LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_NOTIFY_EVENT_CMD_TIMEOUT      LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_TM_CMD_TIMEOUT                LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_TRANSPORT_CMD_TIMEOUT         LEAPRAID_UNIFIED_TIMEOUT
+
+/* Logsense command definitions. */
+#define LEAPRAID_LOGSENSE_DATA_LENGTH   16
+#define LEAPRAID_LOGSENSE_CDB_LENGTH    10
+#define LEAPRAID_LOGSENSE_CDB_CODE      0x6F
+#define LEAPRAID_LOGSENSE_TIMEOUT       LEAPRAID_UNIFIED_TIMEOUT
+#define LEAPRAID_LOGSENSE_SMART_CODE    0x5D
+
+/* Host DMA cap. */
+#define DMA_32_BITS    32
+#define DMA_64_BITS    64
+#define LEAPRAID_DMA_ALIGN    16
+
+/* Values used to represent an invalid. */
+#define LEAPRAID_INVALID_INDEX         -1
+#define LEAPRAID_INVALID_MSIX_VECTORS  -1
+#define LEAPRAID_INVALID_INITIAL_VALUE -1
+#define LEAPRAID_OPERATION_FAILED      -1
+
+/* Version shift and mask. */
+#define LEAPRAID_VER_MAJOR_SHIFT 24
+#define LEAPRAID_VER_MINOR_SHIFT 16
+#define LEAPRAID_VER_BUILD_SHIFT 8
+#define LEAPRAID_VER_MASK        0xFF
+
+/* Interrupt type. */
+#define LEAPRAID_INTERRUPT_MODE_MSIX 0
+#define LEAPRAID_INTERRUPT_MODE_MSI  1
+#define LEAPRAID_INTERRUPT_MODE_LEGACY 2
+
+/* SMP link reset. */
+#define SMP_PHY_CONTROL_LINK_RESET    0x01
+#define SMP_PHY_CONTROL_HARD_RESET    0x02
+#define SMP_PHY_CONTROL_DISABLE       0x03
+
+/**
+ * struct leapraid_adapter_features - Adapter features/capabilities.
+ *
+ * @req_slot: Number of request slots supported by the adapter.
+ * @hp_slot: Number of high-priority slots supported by the adapter.
+ * @adapter_caps: Adapter capabilities.
+ * @fw_version: Firmware version of the adapter.
+ * @max_dev_handle: Maximum device handle supported by the adapter.
+ * @min_dev_handle: Minimum device handle supported by the adapter.
+ */
+struct leapraid_adapter_features {
+	u16 req_slot;
+	u16 hp_slot;
+	u32 adapter_caps;
+	u32 fw_version;
+	u8 max_msix_vectors;
+	u8 max_volumes;
+	u16 max_dev_handle;
+	u16 min_dev_handle;
+};
+
+/**
+ * struct leapraid_adapter_attr - Adapter attributes and capabilities
+ *
+ * @id: Adapter identifier.
+ * @raid_support: Indicates if RAID is supported.
+ * @bios_version: Version of the adapter BIOS.
+ * @enable_mp: Indicates if multipath (MP) support is enabled.
+ * @wideport_max_queue_depth: Maximum queue depth for wide ports.
+ * @narrowport_max_queue_depth: Maximum queue depth for narrow ports.
+ * @sata_max_queue_depth: Maximum queue depth for SATA.
+ * @raid_volume_max_queue_depth: Maximum queue depth for RAID volumes.
+ * @features: Detailed features of the adapter.
+ * @adapter_total_qd: Total queue depth available on the adapter.
+ * @io_qd: Queue depth allocated for I/O operations.
+ * @rep_msg_qd: Queue depth for reply messages.
+ * @rep_desc_qd: Queue depth for reply descriptors.
+ * @rep_desc_q_seg_cnt: Number of segments in a reply descriptor queue.
+ * @rq_cnt: Number of request queues.
+ * @task_desc_dma_size: Size of task descriptor DMA memory.
+ * @use_32_dma_mask: Indicates if 32-bit DMA mask is used.
+ * @name: Adapter name string.
+ * @board_name: Board name retrieved from manufacturing page 0.
+ */
+struct leapraid_adapter_attr {
+	u8 id;
+	u8 raid_support;
+	u32 bios_version;
+	u8 enable_mp;
+	u32 wideport_max_queue_depth;
+	u32 narrowport_max_queue_depth;
+	u32 sata_max_queue_depth;
+	u32 raid_volume_max_queue_depth;
+	struct leapraid_adapter_features features;
+	u32 adapter_total_qd;
+	u32 io_qd;
+	u32 rep_msg_qd;
+	u32 rep_desc_qd;
+	u32 rep_desc_q_seg_cnt;
+	u16 rq_cnt;
+	u32 task_desc_dma_size;
+	u8 use_32_dma_mask;
+	char name[LEAPRAID_NAME_LENGTH];
+	char board_name[LEAPRAID_BOARD_NAME_LENGTH];
+};
+
+/**
+ * struct leapraid_io_req_tracker - Track a SCSI I/O request for the adapter
+ *
+ * @taskid: Unique task ID for this I/O request.
+ * @scmd: Pointer to the associated SCSI command.
+ * @chain_list: List of chain frames associated with this request.
+ * @msix_io: MSI-X vector assigned to this I/O request.
+ * @chain: Pointer to the chain memory for this request.
+ * @chain_dma: DMA address of the chain memory.
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
+ * @taskid: Unique task ID for this tracker.
+ * @cb_idx: Callback index associated with this task.
+ * @tracker_list: Linked list node to chain this tracker in lists.
+ */
+struct leapraid_task_tracker {
+	u16 taskid;
+	u8 cb_idx;
+	struct list_head tracker_list;
+};
+
+/**
+ * struct leapraid_rep_desc_maint - Maintains reply descriptor memory
+ *
+ * @rep_desc: Pointer to the reply descriptor.
+ * @rep_desc_dma: DMA address of the reply descriptor.
+ */
+struct leapraid_rep_desc_maint {
+	union leapraid_rep_desc_union *rep_desc;
+	dma_addr_t rep_desc_dma;
+};
+
+/**
+ * struct leapraid_rep_desc_seg_maint -
+ * Maintains reply descriptor segment memory
+ *
+ * @rep_desc_seg: Pointer to the reply descriptor segment.
+ * @rep_desc_seg_dma: DMA address of the reply descriptor segment.
+ * @rep_desc_maint: Pointer to the main reply descriptor structure.
+ */
+struct leapraid_rep_desc_seg_maint {
+	void *rep_desc_seg;
+	dma_addr_t rep_desc_seg_dma;
+	struct leapraid_rep_desc_maint *rep_desc_maint;
+};
+
+/**
+ * struct leapraid_mem_desc - Memory descriptor for LeapRAID adapter
+ *
+ * @task_desc: Pointer to task descriptor.
+ * @task_desc_dma: DMA address of task descriptor.
+ * @sg_chain_pool: DMA pool for SGL chain allocations.
+ * @sg_chain_pool_size: Size of the sg_chain_pool.
+ * @taskid_to_uniq_tag: Mapping from task ID to unique tag.
+ * @sense_data: Buffer for SCSI sense data.
+ * @sense_data_dma: DMA address of sense_data buffer.
+ * @rep_msg: Buffer for reply message.
+ * @rep_msg_dma: DMA address of reply message buffer.
+ * @rep_msg_addr: Pointer to reply message address.
+ * @rep_msg_addr_dma: DMA address of reply message address.
+ * @rep_desc_seg_maint: Pointer to reply descriptor segment.
+ * @rep_desc_q_arr: Pointer to reply descriptor queue array.
+ * @rep_desc_q_arr_dma: DMA address of reply descriptor queue array.
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
+/* internal cmd description */
+#define LEAPRAID_FIXED_INTER_CMDS       6
+#define LEAPRAID_FIXED_HP_CMDS          2
+
+#define LEAPRAID_CMD_NOT_USED           0x8000
+#define LEAPRAID_CMD_DONE               0x0001
+#define LEAPRAID_CMD_PENDING            0x0002
+#define LEAPRAID_CMD_REPLY_VALID        0x0004
+#define LEAPRAID_CMD_RESET              0x0008
+
+/**
+ * enum LEAPRAID_CB_INDEX - Callback index for LeapRAID driver
+ *
+ * @LEAPRAID_SCAN_DEV_CB_IDX: Scan device callback index.
+ * @LEAPRAID_CONFIG_CB_IDX: Configuration callback index.
+ * @LEAPRAID_TRANSPORT_CB_IDX: Transport callback index.
+ * @LEAPRAID_TIMESTAMP_SYNC_CB_IDX: Timestamp sync callback index.
+ * @LEAPRAID_RAID_ACTION_CB_IDX: RAID action callback index.
+ * @LEAPRAID_DRIVER_SCSIIO_CB_IDX: Driver SCSI I/O callback index.
+ * @LEAPRAID_SAS_CTRL_CB_IDX: SAS controller callback index.
+ * @LEAPRAID_ENC_CB_IDX: Encryption callback index.
+ * @LEAPRAID_NOTIFY_EVENT_CB_IDX: Notify event callback index.
+ * @LEAPRAID_CTL_CB_IDX: Control callback index.
+ * @LEAPRAID_TM_CB_IDX: Task management callback index.
+ */
+enum LEAPRAID_CB_INDEX {
+	LEAPRAID_SCAN_DEV_CB_IDX	= 0x1,
+	LEAPRAID_CONFIG_CB_IDX		= 0x2,
+	LEAPRAID_TRANSPORT_CB_IDX	= 0x3,
+	LEAPRAID_TIMESTAMP_SYNC_CB_IDX	= 0x4,
+	LEAPRAID_RAID_ACTION_CB_IDX	= 0x5,
+	LEAPRAID_DRIVER_SCSIIO_CB_IDX	= 0x6,
+	LEAPRAID_SAS_CTRL_CB_IDX	= 0x7,
+	LEAPRAID_ENC_CB_IDX		= 0x8,
+	LEAPRAID_NOTIFY_EVENT_CB_IDX	= 0x9,
+	LEAPRAID_CTL_CB_IDX		= 0xA,
+	LEAPRAID_TM_CB_IDX		= 0xB,
+	LEAPRAID_NUM_CB_IDXS
+};
+
+/**
+ * struct leapraid_default_reply - Default reply frame buffer
+ * @pad: Raw reply data buffer returned by firmware.
+ *
+ * This structure represents a generic reply frame used by the firmware
+ * when no specific reply format is required. The buffer size is defined
+ * by LEAPRAID_REPLY_SIZE and stores the raw reply data.
+ */
+struct leapraid_default_reply {
+	u8 pad[LEAPRAID_REPLY_SIZE];
+};
+
+/**
+ * struct leapraid_sense_buffer - SCSI sense data buffer
+ * @pad: Buffer used to store sense data returned by a SCSI command.
+ *
+ * This buffer holds the sense data provided by a device.The size is
+ * defined by SCSI_SENSE_BUFFERSIZE.
+ */
+struct leapraid_sense_buffer {
+	u8 pad[SCSI_SENSE_BUFFERSIZE];
+};
+
+/**
+ * struct leapraid_driver_cmd - Driver command tracking structure
+ *
+ * @reply: Default reply structure returned by the adapter.
+ * @done: Completion object used to signal command completion.
+ * @status: Status code returned by the firmware.
+ * @taskid: Unique task identifier for this command.
+ * @hp_taskid: Task identifier for high-priority commands.
+ * @inter_taskid: Task identifier for internal commands.
+ * @cb_idx: Callback index used to identify completion context.
+ * @async_scan_dev: True if this command is for asynchronous device scan.
+ * @sense: Sense buffer holding error information from device.
+ * @mutex: Mutex to protect access to this command structure.
+ * @list: List node for linking driver commands into lists.
+ */
+struct leapraid_driver_cmd {
+	struct leapraid_default_reply reply;
+	struct completion done;
+	u16 status;
+	u16 taskid;
+	u16 hp_taskid;
+	u16 inter_taskid;
+	u8 cb_idx;
+	u8 async_scan_dev;
+	struct leapraid_sense_buffer sense;
+	struct mutex mutex; /* Mutex for driver cmd */
+	struct list_head list;
+};
+
+/**
+ * struct leapraid_driver_cmds - Collection of driver command objects
+ *
+ * @special_cmd_list: List head for tracking special driver commands.
+ * @scan_dev_cmd: Command used for asynchronous device scan operations.
+ * @cfg_op_cmd: Command for configuration operations.
+ * @transport_cmd: Command for transport-level operations.
+ * @timestamp_sync_cmd: Command for synchronizing timestamp with firmware.
+ * @raid_action_cmd: Command for RAID-related management or action requests.
+ * @driver_scsiio_cmd: Command used for internal SCSI I/O processing.
+ * @enc_cmd: Command for enclosure management operations.
+ * @notify_event_cmd: Command for asynchronous event notification handling.
+ * @ctl_cmd: Command for generic control or maintenance operations.
+ * @tm_cmd: Task management command.
+ * @internal_scmd: Pointer to internal SCSI command used by the driver.
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
+ * @task_lock: Spinlock to protect concurrent access.
+ * @hp_taskid: Current high-priority task ID.
+ * @hp_cmd_qd: Fixed command queue depth for high-priority tasks.
+ * @inter_taskid: Current internal task ID.
+ * @inter_cmd_qd: Fixed command queue depth for internal tasks.
+ */
+struct leapraid_dynamic_task_desc {
+	spinlock_t task_lock; /* protects dynamic task */
+	u16 hp_taskid;
+	u16 hp_cmd_qd;
+	u16 inter_taskid;
+	u16 inter_cmd_qd;
+};
+
+/**
+ * struct leapraid_fw_evt_work - Firmware event work structure
+ *
+ * @list: Linked list node for queuing the work.
+ * @adapter: Pointer to the associated LeapRAID adapter.
+ * @work: Work structure used by the kernel workqueue.
+ * @refcnt: Reference counter for managing the lifetime of this work.
+ * @evt_data: Pointer to firmware event data.
+ * @dev_handle: Device handle associated with the event.
+ * @evt_type: Type of firmware event.
+ * @ignore: Flag indicating whether the event should be ignored.
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
+ * @fw_evt_name: Name of the firmware event.
+ * @fw_evt_thread: Workqueue used for processing firmware events.
+ * @fw_evt_lock: Spinlock protecting access to the firmware event list.
+ * @fw_evt_list: Linked list of pending firmware events.
+ * @cur_evt: Pointer to the currently processing firmware event.
+ * @cur_evt_task: Task currently executing @cur_evt work.
+ * @fw_evt_cleanup: Flag indicating whether cleanup of events is in progress.
+ * @leapraid_evt_masks: Array of event masks for filtering firmware events.
+ */
+struct leapraid_fw_evt_struct {
+	u32 leapraid_evt_masks[4];
+	char fw_evt_name[48];
+	struct workqueue_struct *fw_evt_thread;
+	spinlock_t fw_evt_lock; /* protects firmware event */
+	struct list_head fw_evt_list;
+	struct leapraid_fw_evt_work *cur_evt;
+	struct task_struct *cur_evt_task;
+	u8 fw_evt_cleanup;
+};
+
+/**
+ * struct leapraid_rq - Represents a LeapRAID request queue
+ *
+ * @adapter: Pointer to the associated LeapRAID adapter.
+ * @msix_idx: MSI-X vector index used by this queue.
+ * @rep_post_host_idx: Index of the last processed reply descriptor.
+ * @rep_desc: Pointer to the reply descriptor associated with this queue.
+ * @name: Name of the request queue.
+ * @busy: Atomic counter indicating if the queue is busy.
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
+ * @affinity_hint: CPU affinity mask for the queue.
+ * @rq: Underlying LeapRAID request queue structure.
+ */
+struct leapraid_int_rq {
+	cpumask_var_t affinity_hint;
+	struct leapraid_rq rq;
+};
+
+/**
+ * struct leapraid_blk_mq_poll_rq - Polling request for LeapRAID blk-mq
+ *
+ * @busy: Atomic flag indicating request is being processed.
+ * @pause: Atomic flag to temporarily suspend polling.
+ * @rq: The underlying LeapRAID request structure.
+ */
+struct leapraid_blk_mq_poll_rq {
+	atomic_t busy;
+	atomic_t pause;
+	struct leapraid_rq rq;
+};
+
+/**
+ * struct leapraid_notification_desc - Notification descriptor for LeapRAID
+ *
+ * @iopoll_qdex: Index of the I/O polling queue.
+ * @iopoll_qcnt: Count of I/O polling queues.
+ * @msix_enable: Flag indicating MSI-X is enabled.
+ * @irq_vectors_allocated: Flag indicating PCI IRQ vectors are allocated.
+ * @irq_mode: Actual interrupt mode used for allocated PCI IRQ vectors.
+ * @msix_cpu_map: CPU map for MSI-X interrupts.
+ * @msix_cpu_map_sz: Size of the MSI-X CPU map.
+ * @int_rqs: Array of interrupt request queues.
+ * @int_rqs_allocated: Count of allocated interrupt request queues.
+ * @blk_mq_poll_rqs: Array of blk-mq polling requests.
+ */
+struct leapraid_notification_desc {
+	u32 iopoll_qdex;
+	u32 iopoll_qcnt;
+	u8 msix_enable;
+	u8 irq_vectors_allocated;
+	u8 irq_mode;
+	u8 *msix_cpu_map;
+	u32 msix_cpu_map_sz;
+	struct leapraid_int_rq *int_rqs;
+	u32 int_rqs_allocated;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rqs;
+};
+
+/**
+ * struct leapraid_overheat_desc - Overheat descriptor for LeapRAID
+ *
+ * @fault_overheat_wq: Workqueue for adapter thermal overheat operations.
+ * @fault_overheat_work: Work structure for thermal overheat.
+ * @thermal_alert: Flag indicating if adapter thermal alert is active.
+ * @fault_overheat_wq_name: Name of the fault overheat workqueue.
+ */
+struct leapraid_overheat_desc {
+	struct workqueue_struct *fault_overheat_wq;
+	struct work_struct fault_overheat_work;
+	atomic_t thermal_alert;
+	char fault_overheat_wq_name[48];
+};
+
+/**
+ * struct leapraid_reset_desc - Reset descriptor for LeapRAID
+ *
+ * @fault_reset_wq: Workqueue for fault reset operations.
+ * @fault_reset_work: Delayed work structure for fault reset.
+ * @fault_reset_wq_name: Name of the fault reset workqueue.
+ * @host_diag_mutex: Mutex for host diagnostic operations.
+ * @adapter_reset_lock: Spinlock for adapter reset operations.
+ * @adapter_reset_mutex: Mutex for adapter reset operations.
+ * @adapter_link_resetting: Flag indicating if adapter link is resetting.
+ * @adapter_reset_results: Results of the adapter reset operation.
+ * @pending_io_cnt: Count of pending I/O operations.
+ * @reset_wait_queue: Wait queue for reset operations.
+ * @reset_cnt: Counter for reset operations.
+ * @last_reset_cnt: Last observed adapter reset counter.
+ */
+struct leapraid_reset_desc {
+	struct workqueue_struct *fault_reset_wq;
+	struct delayed_work fault_reset_work;
+	char fault_reset_wq_name[48];
+	struct mutex host_diag_mutex; /* Mutex for operations. */
+	spinlock_t adapter_reset_lock; /* Protects adapter reset state. */
+	struct mutex adapter_reset_mutex; /* Serializes adapter reset. */
+	u8 adapter_link_resetting;
+	int adapter_reset_results;
+	int pending_io_cnt;
+	wait_queue_head_t reset_wait_queue;
+	u32 reset_cnt;
+	u32 last_reset_cnt;
+};
+
+/**
+ * struct leapraid_scan_dev_desc - Scan device descriptor for LeapRAID
+ *
+ * @wait_scan_dev_done: Flag indicating if scan device operation is done.
+ * @driver_loading: Flag indicating if driver is loading.
+ * @first_scan_dev_fired: Flag indicating if first scan device operation fired.
+ * @scan_dev_failed: Flag indicating if scan device operation failed.
+ * @scan_start: Flag indicating if scan operation started.
+ * @scan_start_failed: Count of failed scan start operations.
+ */
+struct leapraid_scan_dev_desc {
+	u8 wait_scan_dev_done;
+	u8 driver_loading;
+	wait_queue_head_t wait_driver_loading;
+	u8 first_scan_dev_fired;
+	u8 scan_dev_failed;
+	u8 scan_start;
+	u16 scan_start_failed;
+};
+
+/**
+ * struct leapraid_access_ctrl - Access control structure for LeapRAID
+ *
+ * @pci_access_lock: Mutex for PCI access control.
+ * @shost_recovering: Flag indicating if host is recovering.
+ * @shost_recover_async: Flag indicating if host is recovering
+ *                       and the 0xFFFF event.
+ * @shost_recover_wq: Wait queue for threads waiting on shost_recover_async.
+ * @host_removing: Flag indicating if host is being removed.
+ * @pcie_recovering: Flag indicating if PCIe is recovering.
+ */
+struct leapraid_access_ctrl {
+	struct mutex pci_access_lock; /* serializes PCI register access. */
+	u8 shost_recovering;
+	wait_queue_head_t recovery_waitq;
+	u8 shost_recover_async;
+	wait_queue_head_t shost_recover_wq;
+	u8 host_removing;
+	u8 pcie_recovering;
+};
+
+/**
+ * struct leapraid_fw_log_desc - Firmware log descriptor for LeapRAID
+ *
+ * @fw_log_buffer: Buffer for firmware log data.
+ * @fw_log_buffer_dma: DMA address of the firmware log buffer.
+ * @fw_log_wq_name: Name of the firmware log workqueue.
+ * @fw_log_wq: Workqueue for firmware log operations.
+ * @fw_log_work: Delayed work structure for firmware log.
+ * @open_pcie_trace: Flag indicating if PCIe tracing is open.
+ * @fw_log_init_flag: Flag indicating if firmware log is initialized.
+ * @pre_debug_log: Last DebugLog register snapshot for change detection.
+ */
+struct leapraid_fw_log_desc {
+	u8 *fw_log_buffer;
+	dma_addr_t fw_log_buffer_dma;
+	char fw_log_wq_name[48];
+	struct workqueue_struct *fw_log_wq;
+	struct delayed_work fw_log_work;
+	int open_pcie_trace;
+	int fw_log_init_flag;
+	u32 pre_debug_log[LEAPRAID_DEBUGLOG_SZ_MAX];
+};
+
+#define LEAPRAID_CARD_PORT_FLG_DIRTY	0x01
+#define LEAPRAID_CARD_PORT_FLG_NEW	0x02
+#define LEAPRAID_DISABLE_MP_PORT_ID	0xFF
+/**
+ * struct leapraid_card_port - Card port structure for LeapRAID
+ *
+ * @list: List head for card port.
+ * @vphys_list: List head for virtual PHY list.
+ * @port_id: Port ID.
+ * @sas_address: SAS address.
+ * @phy_mask: Mask of PHY.
+ * @vphys_mask: Mask of virtual PHY.
+ * @flg: Flags for the port.
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
+ * struct leapraid_card_phy - Card PHY structure for LeapRAID
+ *
+ * @port_siblings: List head for port siblings.
+ * @card_port: Pointer to the card port.
+ * @identify: SAS identify structure.
+ * @remote_identify: Remote SAS identify structure.
+ * @phy: SAS PHY structure.
+ * @phy_id: PHY ID.
+ * @hdl: Handle for the port.
+ * @attached_hdl: Handle for the attached port.
+ * @phy_is_assigned: Flag indicating if PHY is assigned.
+ * @vphy: Flag indicating if virtual PHY.
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
+	u8 phy_is_assigned;
+	u8 vphy;
+};
+
+/**
+ * struct leapraid_topo_node - SAS topology node for LeapRAID
+ *
+ * @list: List head for linking nodes.
+ * @sas_port_list: List of SAS ports.
+ * @card_port: Associated card port.
+ * @card_phy: Associated card PHY.
+ * @rphy: SAS remote PHY device.
+ * @parent_dev: Parent device pointer.
+ * @sas_address: SAS address of this node.
+ * @sas_address_parent: Parent node's SAS address.
+ * @phys_num: Number of physical links.
+ * @hdl: Handle identifier.
+ * @enc_hdl: Enclosure handle.
+ * @enc_lid: Enclosure logical identifier.
+ * @resp: Response status flag.
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
+	u8 resp;
+};
+
+/**
+ * struct leapraid_dev_topo - LeapRAID device topology management structure
+ *
+ * @topo_node_lock: Spinlock for protecting topology node operations.
+ * @sas_dev_lock: Spinlock for SAS device list access.
+ * @raid_volume_lock: Spinlock for RAID volume list access.
+ * @enc_lock: Spinlock for enclosure device list access.
+ * @sas_id: SAS domain identifier.
+ * @card: Main card topology node.
+ * @exp_list: List of expander devices.
+ * @enc_list: List of enclosure devices.
+ * @sas_dev_list: List of SAS devices.
+ * @sas_dev_init_list: List of SAS devices being initialized.
+ * @raid_volume_list: List of RAID volumes.
+ * @card_port_list: List of card ports.
+ * @pd_hdls: Array of physical disk handles.
+ * @blocking_hdls: Array of blocking handles.
+ */
+struct leapraid_dev_topo {
+	spinlock_t topo_node_lock; /* Protects topology node. */
+	spinlock_t sas_dev_lock; /* Protects SAS device list access. */
+	spinlock_t raid_volume_lock; /* Protects RAID volume list access. */
+	spinlock_t enc_lock; /* Protects enclosure device list access. */
+	int sas_id;
+	struct leapraid_topo_node card;
+	struct list_head exp_list;
+	struct list_head enc_list;
+	struct list_head sas_dev_list;
+	struct list_head sas_dev_init_list;
+	struct list_head raid_volume_list;
+	struct list_head card_port_list;
+	u16 pd_hdls_sz;
+	unsigned long *pd_hdls;
+	unsigned long *blocking_hdls;
+};
+
+/**
+ * struct leapraid_boot_dev - Boot device structure for LeapRAID
+ *
+ * @dev: Device pointer.
+ * @chnl: Channel number.
+ * @form: Form factor.
+ * @pg_dev: Config page device content.
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
+ *
+ * @lock: Spinlock protecting boot device cache access.
+ * @requested_boot_dev: Requested primary boot device.
+ * @requested_alt_boot_dev: Requested alternate boot device.
+ * @current_boot_dev: Currently active boot device.
+ */
+struct leapraid_boot_devs {
+	spinlock_t lock; /* protects boot dev */
+	struct leapraid_boot_dev requested_boot_dev;
+	struct leapraid_boot_dev requested_alt_boot_dev;
+	struct leapraid_boot_dev current_boot_dev;
+};
+
+/**
+ * struct leapraid_smart_poll_desc - SMART polling descriptor
+ *
+ * @smart_poll_wq: Workqueue for SMART polling tasks.
+ * @smart_poll_work: Delayed work for SMART polling operations.
+ * @smart_poll_wq_name: Workqueue name string.
+ */
+struct leapraid_smart_poll_desc {
+	struct workqueue_struct *smart_poll_wq;
+	struct delayed_work smart_poll_work;
+	char smart_poll_wq_name[48];
+};
+
+/**
+ * struct leapraid_adapter - Main LeapRAID adapter structure
+ *
+ * @list: List head for adapter management.
+ * @shost: SCSI host structure.
+ * @pdev: PCI device structure.
+ * @iomem_base: I/O memory mapped base address.
+ * @rep_msg_host_idx: Host index for reply messages.
+ * @mask_int: Interrupt masking flag.
+ * @timestamp_sync_cnt: Timestamp synchronization counter.
+ * @adapter_attr: Adapter attributes.
+ * @mem_desc: Memory descriptor.
+ * @driver_cmds: Driver commands.
+ * @dynamic_task_desc: Dynamic task descriptor.
+ * @fw_evt_s: Firmware event structure.
+ * @notification_desc: Notification descriptor.
+ * @reset_desc: Reset descriptor.
+ * @scan_dev_desc: Device scan descriptor.
+ * @access_ctrl: Access control.
+ * @fw_log_desc: Firmware log descriptor.
+ * @dev_topo: Device topology.
+ * @boot_devs: Boot devices.
+ * @smart_poll_desc: SMART polling descriptor.
+ * @overheat_desc: Overheat processing descriptor.
+ */
+struct leapraid_adapter {
+	struct list_head list;
+	struct Scsi_Host *shost;
+	struct pci_dev *pdev;
+	struct leapraid_reg_base __iomem *iomem_base;
+	u32 rep_msg_host_idx;
+	u8 mask_int;
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
+	struct leapraid_overheat_desc overheat_desc;
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
+	GET_MANUFACTURING_PG0,
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
+ *
+ * @list: List head for enclosure management.
+ * @pg0: Enclosure page 0 data.
+ */
+struct leapraid_enc_node {
+	struct list_head list;
+	struct leapraid_enc_p0 pg0;
+};
+
+/**
+ * struct leapraid_raid_volume - RAID volume structure
+ *
+ * @list: List head for volume management.
+ * @refcnt: Reference count.
+ * @starget: SCSI target structure.
+ * @sdev: SCSI device structure.
+ * @id: Volume ID.
+ * @channel: SCSI channel.
+ * @wwid: World wide Identifier.
+ * @hdl: Volume handle.
+ * @vol_type: Volume type.
+ * @pd_num: Number of physical disks.
+ * @resp: Response status.
+ * @dev_info: Device information.
+ */
+struct leapraid_raid_volume {
+	struct list_head list;
+	struct kref refcnt;
+	struct scsi_target *starget;
+	struct scsi_device *sdev;
+	unsigned int id;
+	unsigned int channel;
+	u64 wwid;
+	u16 hdl;
+	u8 vol_type;
+	u8 pd_num;
+	u8 resp;
+	u32 dev_info;
+};
+
+static inline void leapraid_raid_volume_free(struct kref *ref)
+{
+	kfree(container_of(ref, struct leapraid_raid_volume, refcnt));
+}
+
+#define leapraid_raid_volume_get(volume) \
+	kref_get(&(volume)->refcnt)
+#define leapraid_raid_volume_put(volume) \
+	kref_put(&(volume)->refcnt, leapraid_raid_volume_free)
+
+#define LEAPRAID_TGT_FLG_RAID_MEMBER	0x01
+#define LEAPRAID_TGT_FLG_VOLUME		0x02
+#define LEAPRAID_NO_ULD_ATTACH		1
+/**
+ * struct leapraid_starget_priv - SCSI target private data
+ *
+ * @starget: SCSI target structure.
+ * @sas_address: SAS address.
+ * @hdl: Device handle.
+ * @num_luns: Number of LUNs.
+ * @flg: Flags.
+ * @deleted: Deletion flag.
+ * @tm_busy: Task management busy flag.
+ * @card_port: Associated card port.
+ * @sas_dev: SAS device structure.
+ */
+struct leapraid_starget_priv {
+	struct scsi_target *starget;
+	u64 sas_address;
+	u16 hdl;
+	int num_luns;
+	u32 flg;
+	u8 deleted;
+	u8 tm_busy;
+	struct leapraid_card_port *card_port;
+	struct leapraid_sas_dev *sas_dev;
+};
+
+#define LEAPRAID_DEVICE_FLG_INIT	0x01
+/**
+ * struct leapraid_sdev_priv - SCSI device private data
+ *
+ * @starget_priv: Associated target private data.
+ * @lun: Logical Unit Number.
+ * @flg: Flags.
+ * @block: Block flag.
+ * @deleted: Deletion flag.
+ * @sep: SEP flag.
+ */
+struct leapraid_sdev_priv {
+	struct leapraid_starget_priv *starget_priv;
+	unsigned int lun;
+	u32 flg;
+	u8 ncq;
+	u8 block;
+	u8 deleted;
+	u8 sep;
+};
+
+/**
+ * struct leapraid_sas_dev - SAS device structure
+ *
+ * @list: List head for device management.
+ * @starget: SCSI target structure.
+ * @card_port: Associated card port.
+ * @rphy: SAS remote PHY.
+ * @refcnt: Reference count.
+ * @id: Device ID.
+ * @channel: SCSI channel.
+ * @slot: Slot number.
+ * @phy: PHY identifier.
+ * @resp: Response status.
+ * @led_on: LED state.
+ * @sas_addr: SAS address.
+ * @dev_name: Device name.
+ * @hdl: Device handle.
+ * @parent_sas_addr: Parent SAS address.
+ * @enc_hdl: Enclosure handle.
+ * @enc_lid: Enclosure logical ID.
+ * @volume_hdl: Volume handle.
+ * @volume_wwid: Volume WWID.
+ * @dev_info: Device information.
+ * @pend_sas_rphy_add: Pending SAS remote PHY addition flag.
+ * @enc_level: Enclosure level.
+ * @port_connection: Port connection.
+ * @connector_name: Connector name.
+ * @support_smart: SMART support flag.
+ */
+struct leapraid_sas_dev {
+	struct list_head list;
+	struct scsi_target *starget;
+	struct leapraid_card_port *card_port;
+	struct sas_rphy *rphy;
+	struct kref refcnt;
+	unsigned int id;
+	unsigned int channel;
+	u16 slot;
+	u8 phy;
+	u8 resp;
+	u8 led_on;
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
+	u8 port_connection;
+	u8 connector_name[LEAPRAID_SAS_DEV_P0_CON_NAME_LEN + 1];
+	u8 support_smart;
+};
+
+static inline void leapraid_sdev_free(struct kref *ref)
+{
+	kfree(container_of(ref, struct leapraid_sas_dev, refcnt));
+}
+
+#define leapraid_sdev_get(sdev)	kref_get(&(sdev)->refcnt)
+#define leapraid_sdev_put(sdev)	kref_put(&(sdev)->refcnt, leapraid_sdev_free)
+
+void leapraid_boot_dev_get(void *dev, u32 chnl);
+void leapraid_boot_dev_put(void *dev, u32 chnl);
+
+/**
+ * struct leapraid_sas_port - SAS port structure
+ *
+ * @port_list: List head for port management.
+ * @phy_list: List of PHYs in this port.
+ * @port: SAS port structure.
+ * @card_port: Associated card port.
+ * @remote_identify: Remote device identification.
+ * @rphy: SAS remote PHY.
+ * @phys_num: Number of PHYs in this port.
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
+#define LEAPRAID_VPHY_FLG_DIRTY	0x01
+/**
+ * struct leapraid_vphy - Virtual PHY structure
+ *
+ * @list: List head for PHY management.
+ * @sas_address: SAS address.
+ * @phy_mask: PHY mask.
+ * @flg: Flags.
+ */
+struct leapraid_vphy {
+	struct list_head list;
+	u64 sas_address;
+	u32 phy_mask;
+	u8 flg;
+};
+
+/**
+ * struct leapraid_tgt_rst_list - Target reset tracking entry
+ * @list: List node used to link reset entries.
+ * @handle: Device handle of the target being reset.
+ * @state: Current state of the target reset operation.
+ *
+ * Each entry represents a target device that is undergoing or has
+ * undergone a target reset operation.
+ */
+struct leapraid_tgt_rst_list {
+	struct list_head list;
+	u16 handle;
+	u16 state;
+};
+
+/**
+ * struct sense_info - Parsed SCSI sense information
+ * @sense_key: Sense key extracted from sense data.
+ * @asc: Additional Sense Code (ASC).
+ * @ascq: Additional Sense Code Qualifier (ASCQ).
+ *
+ * This structure stores key fields parsed from SCSI sense data to
+ * simplify error handling and reporting.
+ */
+struct sense_info {
+	u8 sense_key;
+	u8 asc;
+	u8 ascq;
+};
+
+/**
+ * struct leapraid_fw_log_info - Firmware log position information
+ * @user_position: Current log read position used by the driver.
+ * @adapter_position: Current log write position maintained by firmware.
+ *
+ * This structure tracks firmware log buffer positions used for retrieving
+ * log entries from the adapter.
+ */
+struct leapraid_fw_log_info {
+	u32 user_position;
+	u32 adapter_position;
+};
+
+/**
+ * enum reset_type - Reset type enumeration
+ *
+ * @FULL_RESET: Full hardware reset.
+ * @PART_RESET: Partial reset.
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
+ *
+ * @dirty_flg: Dirty flag indicator.
+ * @same_addr: Same address flag.
+ * @exact_phy: Exact PHY match flag.
+ * @phy_overlap: PHY overlap bitmap.
+ * @same_port: Same port flag.
+ * @cur_chking_old_port: Current checking old port.
+ * @expected_old_port: Expected old port.
+ * @same_addr_port_count: Same address port count.
+ * @checking_state: Port checking state.
+ */
+struct leapraid_card_port_feature {
+	u8 dirty_flg;
+	u8 same_addr;
+	u8 exact_phy;
+	u32 phy_overlap;
+	u8 same_port;
+	struct leapraid_card_port *cur_chking_old_port;
+	struct leapraid_card_port *expected_old_port;
+	int same_addr_port_count;
+	enum leapraid_port_checking_state checking_state;
+};
+
+#define SMP_REPORT_MANUFACTURER_INFORMATION_FRAME_TYPE	0x40
+#define SMP_REPORT_MANUFACTURER_INFORMATION_FUNC	0x01
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
+	u8 comp_vendor_identification[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u16 component_id;
+	u8 component_revision_level;
+	u8 r3;
+	u8 vendor_specific[8];
+};
+
+/**
+ * struct leapraid_scsi_cmd_desc - SCSI command descriptor
+ *
+ * @hdl: Device handle.
+ * @lun: Logical Unit Number.
+ * @raid_member: RAID member flag.
+ * @dir: DMA data direction.
+ * @data_length: Data transfer length.
+ * @data_buffer: Data buffer pointer.
+ * @cdb_length: CDB length.
+ * @cdb: Command Descriptor Block.
+ * @time_out: Timeout.
+ */
+struct leapraid_scsi_cmd_desc {
+	u16 hdl;
+	u32 lun;
+	u8 raid_member;
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
+void leapraid_check_scheduled_fault_start(struct leapraid_adapter *adapter);
+void leapraid_check_scheduled_fault_stop(struct leapraid_adapter *adapter);
+void leapraid_fw_log_start(struct leapraid_adapter *adapter);
+void leapraid_fw_log_stop(struct leapraid_adapter *adapter);
+int leapraid_set_pcie_and_notification(struct leapraid_adapter *adapter);
+void leapraid_disable_controller(struct leapraid_adapter *adapter);
+int leapraid_hard_reset_handler(struct leapraid_adapter *adapter,
+				enum reset_type type);
+void leapraid_mask_int(struct leapraid_adapter *adapter);
+void leapraid_unmask_int(struct leapraid_adapter *adapter);
+u32 leapraid_get_adapter_state(struct leapraid_adapter *adapter);
+bool leapraid_pci_removed(struct leapraid_adapter *adapter);
+int leapraid_check_adapter_is_op(struct leapraid_adapter *adapter, int wait,
+				 const char *caller);
+void *leapraid_get_task_desc(struct leapraid_adapter *adapter, u16 taskid);
+void *leapraid_get_sense_buffer(struct leapraid_adapter *adapter, u16 taskid);
+__le32 leapraid_get_sense_buffer_dma(struct leapraid_adapter *adapter,
+				     u16 taskid);
+void *leapraid_get_reply_vaddr(struct leapraid_adapter *adapter,
+			       u32 phys_addr);
+u16 leapraid_alloc_scsiio_taskid(struct leapraid_adapter *adapter,
+				 struct scsi_cmnd *scmd);
+void leapraid_free_taskid(struct leapraid_adapter *adapter, u16 taskid);
+struct leapraid_io_req_tracker *leapraid_get_io_tracker_from_taskid(
+		struct leapraid_adapter *adapter, u16 taskid);
+struct scsi_cmnd *leapraid_get_scmd_from_taskid(
+		struct leapraid_adapter *adapter, u16 taskid);
+int leapraid_scan_dev(struct leapraid_adapter *adapter, bool async_scan_dev);
+void leapraid_scan_dev_done(struct leapraid_adapter *adapter);
+void leapraid_cleanup_lists(struct leapraid_adapter *adapter);
+void leapraid_wait_cmds_done(struct leapraid_adapter *adapter);
+void leapraid_clean_active_scsi_cmds(struct leapraid_adapter *adapter);
+void leapraid_sync_irqs(struct leapraid_adapter *adapter, bool poll);
+int leapraid_rep_queue_handler(struct leapraid_rq *rq);
+int leapraid_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void leapraid_mq_polling_pause(struct leapraid_adapter *adapter);
+void leapraid_mq_polling_resume(struct leapraid_adapter *adapter);
+void leapraid_set_tm_flg(struct leapraid_adapter *adapter, u16 handle);
+void leapraid_clear_tm_flg(struct leapraid_adapter *adapter, u16 handle);
+void leapraid_async_turn_on_led(struct leapraid_adapter *adapter, u16 handle);
+int leapraid_issue_locked_tm(struct leapraid_adapter *adapter, u16 handle,
+			     uint channel, uint id, uint lun, u8 type,
+			     u16 taskid_task, u8 tr_method);
+int leapraid_issue_tm(struct leapraid_adapter *adapter, u16 handle,
+		      uint channel, uint id, uint lun, u8 type,
+		      u16 taskid_task, u8 tr_method);
+bool leapraid_scsiio_done(struct leapraid_adapter *adapter, u16 taskid,
+			  u8 msix_index, u32 rep);
+int leapraid_get_volume_cap(struct leapraid_adapter *adapter,
+			    struct leapraid_raid_volume *raid_volume);
+int leapraid_internal_init_cmd_priv(
+		struct leapraid_adapter *adapter,
+		struct leapraid_io_req_tracker *io_tracker);
+void leapraid_internal_exit_cmd_priv(
+		struct leapraid_adapter *adapter,
+		struct leapraid_io_req_tracker *io_tracker);
+void leapraid_clean_active_fw_evt(struct leapraid_adapter *adapter);
+bool leapraid_scmd_find_by_lun(struct leapraid_adapter *adapter,
+			       uint id, unsigned int lun, uint channel);
+bool leapraid_scmd_find_by_tgt(struct leapraid_adapter *adapter,
+			       uint id, uint channel);
+struct leapraid_vphy *leapraid_get_vphy_by_phy(struct leapraid_card_port *port,
+					       u32 phy);
+struct leapraid_raid_volume *leapraid_raid_volume_find_by_id(
+		struct leapraid_adapter *adapter, uint id, uint channel);
+struct leapraid_raid_volume *leapraid_raid_volume_find_by_hdl(
+		struct leapraid_adapter *adapter, u16 handle);
+struct leapraid_topo_node *leapraid_exp_find_by_sas_address(
+		struct leapraid_adapter *adapter, u64 sas_address,
+		struct leapraid_card_port *port);
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, struct sas_rphy *rphy);
+struct leapraid_sas_dev *leapraid_get_sas_dev_by_addr(
+		struct leapraid_adapter *adapter, u64 sas_address,
+		struct leapraid_card_port *port);
+struct leapraid_sas_dev *leapraid_get_sas_dev_by_hdl(
+		struct leapraid_adapter *adapter, u16 handle);
+struct leapraid_sas_dev *leapraid_get_sas_dev_from_tgt(
+		struct leapraid_adapter *adapter,
+		struct leapraid_starget_priv *tgt_priv);
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_from_tgt(
+		struct leapraid_adapter *adapter,
+		 struct leapraid_starget_priv *tgt_priv);
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_hdl(
+		struct leapraid_adapter *adapter, u16 handle);
+struct leapraid_sas_dev *leapraid_hold_lock_get_sas_dev_by_addr(
+		struct leapraid_adapter *adapter, u64 sas_address,
+		struct leapraid_card_port *port);
+struct leapraid_sas_dev *leapraid_get_next_sas_dev_from_init_list(
+		struct leapraid_adapter *adapter);
+void leapraid_sas_dev_remove_by_sas_address(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, struct leapraid_card_port *port);
+void leapraid_sas_dev_remove(struct leapraid_adapter *adapter,
+			     struct leapraid_sas_dev *sas_dev);
+void leapraid_raid_volume_remove(struct leapraid_adapter *adapter,
+				 struct leapraid_raid_volume *raid_volume);
+void leapraid_exp_rm(struct leapraid_adapter *adapter,
+		     u64 sas_address, struct leapraid_card_port *port);
+void leapraid_build_mpi_sg(struct leapraid_adapter *adapter,
+			   void *sge, dma_addr_t h2c_dma_addr, size_t h2c_size,
+			   dma_addr_t c2h_dma_addr, size_t c2h_size);
+void leapraid_build_ieee_nodata_sg(struct leapraid_adapter *adapter,
+				   void *sge);
+void leapraid_build_ieee_sg(struct leapraid_adapter *adapter,
+			    void *psge, dma_addr_t h2c_dma_addr,
+			    size_t h2c_size, dma_addr_t c2h_dma_addr,
+			    size_t c2h_size);
+int leapraid_build_scmd_ieee_sg(struct leapraid_adapter *adapter,
+				struct scsi_cmnd *scmd, u16 taskid);
+void leapraid_fire_scsi_io(struct leapraid_adapter *adapter,
+			   u16 taskid, u16 handle);
+void leapraid_fire_hpr_task(struct leapraid_adapter *adapter, u16 taskid,
+			    u16 msix_task);
+void leapraid_fire_task(struct leapraid_adapter *adapter, u16 taskid);
+int leapraid_cfg_get_volume_hdl(struct leapraid_adapter *adapter,
+				u16 pd_handle, u16 *volume_handle);
+int leapraid_cfg_get_volume_wwid(struct leapraid_adapter *adapter,
+				 u16 volume_handle, u64 *wwid);
+int leapraid_op_config_page(struct leapraid_adapter *adapter,
+			    void *cfgp, union cfg_param_1 cfgp1,
+			    union cfg_param_2 cfgp2,
+			    enum config_page_action cfg_op);
+void leapraid_log_req_context(struct leapraid_adapter *adapter, u16 smid,
+			      const void *req_data);
+
+int leapraid_change_queue_depth(struct scsi_device *sdev, int qdepth);
+
+int leapraid_ctl_release(struct inode *inode, struct file *filep);
+int leapraid_ctl_init(void);
+void leapraid_ctl_exit(void);
+
+extern struct sas_function_template leapraid_transport_functions;
+extern struct scsi_transport_template *leapraid_transport_template;
+struct leapraid_sas_port *leapraid_transport_port_add(
+		struct leapraid_adapter *adapter, u16 handle, u64 sas_address,
+		struct leapraid_card_port *card_port);
+void leapraid_transport_port_remove(struct leapraid_adapter *adapter,
+				    u64 sas_address, u64 sas_address_parent,
+				    struct leapraid_card_port *card_port);
+void leapraid_transport_add_card_phy(struct leapraid_adapter *adapter,
+				     struct leapraid_card_phy *card_phy,
+				     struct leapraid_sas_phy_p0 *phy_pg0,
+				     struct device *parent_dev);
+int leapraid_transport_add_exp_phy(struct leapraid_adapter *adapter,
+				   struct leapraid_card_phy *card_phy,
+				   struct leapraid_exp_p1 *exp_pg1,
+				   struct device *parent_dev);
+void leapraid_transport_update_links(struct leapraid_adapter *adapter,
+				     u64 sas_address, u16 handle,
+				     u8 phy_number, u8 link_rate,
+				     struct leapraid_card_port *card_port);
+void leapraid_transport_detach_phy_to_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node,
+		struct leapraid_card_phy *card_phy);
+void leapraid_transport_attach_phy_to_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *sas_node,
+		struct leapraid_card_phy *card_phy,
+		u64 sas_address,
+		struct leapraid_card_port *card_port);
+enum scsi_qc_status leapraid_queuecommand(struct Scsi_Host *shost,
+					  struct scsi_cmnd *scmd);
+void leapraid_smart_polling_start(struct leapraid_adapter *adapter);
+void leapraid_smart_polling_stop(struct leapraid_adapter *adapter);
+void leapraid_overheat_cleanup(struct leapraid_adapter *adapter);
+void leapraid_smart_fault_detect(struct leapraid_adapter *adapter, u16 hdl);
+void leapraid_free_internal_scsi_cmd(struct leapraid_adapter *adapter);
+
+#endif /* LEAPRAID_FUNC_H_INCLUDED */
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
new file mode 100644
index 000000000000..c59551eddb03
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -0,0 +1,2516 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
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
+static atomic_t leapraid_ids = ATOMIC_INIT(0);
+
+static int open_pcie_trace = 1;
+module_param(open_pcie_trace, int, 0644);
+MODULE_PARM_DESC(open_pcie_trace, "Default=1(open)/0(close)");
+
+static int enable_mp = 1;
+module_param(enable_mp, int, 0444);
+MODULE_PARM_DESC(enable_mp,
+		 "Enable multipath on target device. default=1(enable)");
+
+static inline void leapraid_get_sense_data(char *sense,
+					   struct sense_info *data)
+{
+	bool desc_format = (sense[0] & SCSI_SENSE_RESPONSE_CODE_MASK) >=
+			    DESC_FORMAT_THRESHOLD;
+
+	if (desc_format) {
+		data->sense_key = sense[1] & SENSE_KEY_MASK;
+		data->asc = sense[2];
+		data->ascq = sense[3];
+	} else {
+		data->sense_key = sense[2] & SENSE_KEY_MASK;
+		data->asc = sense[12];
+		data->ascq = sense[13];
+	}
+}
+
+static struct leapraid_adapter *pdev_to_adapter(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+
+	if (!shost)
+		return NULL;
+
+	return shost_priv(shost);
+}
+
+void leapraid_set_tm_flg(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+	bool skip = false;
+
+	/* Iterate over all devices. */
+	shost_for_each_device(sdev, adapter->shost) {
+		if (skip)
+			continue;
+
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->hdl == hdl) {
+			sdev_priv->starget_priv->tm_busy = 1;
+			skip = true;
+		}
+	}
+}
+
+void leapraid_clear_tm_flg(struct leapraid_adapter *adapter, u16 hdl)
+{
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_device *sdev;
+	bool skip = false;
+
+	/* Iterate over all devices. */
+	shost_for_each_device(sdev, adapter->shost) {
+		if (skip)
+			continue;
+
+		sdev_priv = sdev->hostdata;
+		if (!sdev_priv)
+			continue;
+
+		if (sdev_priv->starget_priv->hdl == hdl) {
+			sdev_priv->starget_priv->tm_busy = 0;
+			skip = true;
+		}
+	}
+}
+
+static int leapraid_tm_cmd_map_status(struct leapraid_adapter *adapter,
+				      uint channel,
+				      uint id,
+				      uint lun,
+				      u8 type,
+				      u16 taskid_task)
+{
+	int rc = FAILED;
+
+	if (taskid_task <= adapter->shost->can_queue) {
+		switch (type) {
+		case LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET:
+		case LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET:
+			if (!leapraid_scmd_find_by_lun(adapter, id, lun,
+						       channel))
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
+	if (taskid_task == adapter->driver_cmds.driver_scsiio_cmd.taskid &&
+	    (adapter->driver_cmds.driver_scsiio_cmd.status &
+	     LEAPRAID_CMD_DONE ||
+	     adapter->driver_cmds.driver_scsiio_cmd.status &
+	     LEAPRAID_CMD_NOT_USED))
+		rc = SUCCESS;
+
+	if (taskid_task == adapter->driver_cmds.ctl_cmd.hp_taskid &&
+	    (adapter->driver_cmds.ctl_cmd.status &
+	     LEAPRAID_CMD_DONE ||
+	     adapter->driver_cmds.ctl_cmd.status &
+	     LEAPRAID_CMD_NOT_USED))
+		rc = SUCCESS;
+
+	return rc;
+}
+
+static int leapraid_tm_post_processing(struct leapraid_adapter *adapter,
+				       u16 hdl, uint channel, uint id,
+				       uint lun, u8 type, u16 taskid_task)
+{
+	int rc;
+
+	rc = leapraid_tm_cmd_map_status(adapter, channel, id, lun,
+					type, taskid_task);
+	if (rc == SUCCESS)
+		return rc;
+
+	leapraid_mask_int(adapter);
+	leapraid_sync_irqs(adapter, true);
+	leapraid_unmask_int(adapter);
+
+	return leapraid_tm_cmd_map_status(adapter, channel, id, lun, type,
+					  taskid_task);
+}
+
+static void leapraid_build_tm_req(struct leapraid_scsi_tm_req *scsi_tm_req,
+				  u16 hdl, uint lun, u8 type, u8 tr_method,
+				  u16 target_taskid)
+{
+	memset(scsi_tm_req, 0, sizeof(*scsi_tm_req));
+	scsi_tm_req->func = LEAPRAID_FUNC_SCSI_TMF;
+	scsi_tm_req->dev_hdl = cpu_to_le16(hdl);
+	scsi_tm_req->task_type = type;
+	scsi_tm_req->msg_flg = tr_method;
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK ||
+	    type == LEAPRAID_TM_TASKTYPE_QUERY_TASK)
+		scsi_tm_req->task_mid = cpu_to_le16(target_taskid);
+	int_to_scsilun(lun, (struct scsi_lun *)scsi_tm_req->lun);
+}
+
+int leapraid_issue_tm(struct leapraid_adapter *adapter, u16 hdl, uint channel,
+		      uint id, uint lun, u8 type,
+		      u16 target_taskid, u8 tr_method)
+{
+	struct leapraid_scsi_tm_req *scsi_tm_req;
+	struct leapraid_scsiio_req *scsiio_req;
+	struct leapraid_io_req_tracker *io_req_tracker = NULL;
+	u16 msix_task;
+	u16 taskid;
+	bool issue_reset = false;
+	u32 db;
+	int rc;
+
+	lockdep_assert_held(&adapter->driver_cmds.tm_cmd.mutex);
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.host_removing ||
+	    adapter->access_ctrl.pcie_recovering) {
+		dev_info(&adapter->pdev->dev,
+			 "%s %s: Host is recovering, skip tm command!\n",
+			 __func__, adapter->adapter_attr.name);
+		return FAILED;
+	}
+
+	db = leapraid_readl(&adapter->iomem_base->db);
+	if (db & LEAPRAID_DB_USED) {
+		dev_info(&adapter->pdev->dev,
+			 "%s Unexpected db status, issuing hard reset!\n",
+			 adapter->adapter_attr.name);
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		return !rc ? SUCCESS : FAILED;
+	}
+
+	if ((db & LEAPRAID_DB_MASK) == LEAPRAID_DB_FAULT) {
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+		return !rc ? SUCCESS : FAILED;
+	}
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK)
+		io_req_tracker =
+			leapraid_get_io_tracker_from_taskid(adapter,
+							    target_taskid);
+
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_PENDING;
+	scsi_tm_req =
+		leapraid_get_task_desc(adapter,
+				       adapter->driver_cmds.tm_cmd.hp_taskid);
+	leapraid_build_tm_req(scsi_tm_req, hdl, lun, type, tr_method,
+			      target_taskid);
+	memset(&adapter->driver_cmds.tm_cmd.reply, 0,
+	       sizeof(struct leapraid_scsi_tm_rep));
+	leapraid_set_tm_flg(adapter, hdl);
+	init_completion(&adapter->driver_cmds.tm_cmd.done);
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK &&
+	    io_req_tracker &&
+	    io_req_tracker->msix_io < adapter->adapter_attr.rq_cnt)
+		msix_task = io_req_tracker->msix_io;
+	else
+		msix_task = 0;
+	taskid = adapter->driver_cmds.tm_cmd.hp_taskid;
+	leapraid_fire_hpr_task(adapter, taskid, msix_task);
+	wait_for_completion_timeout(&adapter->driver_cmds.tm_cmd.done,
+				    LEAPRAID_TM_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.tm_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: TM cmd timeout, status=0x%x\n",
+			__func__, adapter->driver_cmds.tm_cmd.status);
+		leapraid_log_req_context(adapter, taskid, scsi_tm_req);
+		issue_reset =
+			leapraid_check_reset(
+				adapter->driver_cmds.tm_cmd.status);
+		if (issue_reset) {
+			dev_info(&adapter->pdev->dev,
+				 "%s:%d: call hard_reset\n",
+				 __func__, __LINE__);
+			rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+			rc = !rc ? SUCCESS : FAILED;
+			goto out_cleanup;
+		}
+	}
+
+	leapraid_sync_irqs(adapter, false);
+
+	switch (type) {
+	case LEAPRAID_TM_TASKTYPE_TARGET_RESET:
+	case LEAPRAID_TM_TASKTYPE_ABRT_TASK_SET:
+	case LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET:
+		rc = leapraid_tm_post_processing(adapter, hdl, channel, id,
+						 lun, type, target_taskid);
+		break;
+	case LEAPRAID_TM_TASKTYPE_ABORT_TASK:
+		rc = SUCCESS;
+		scsiio_req = leapraid_get_task_desc(adapter, target_taskid);
+		if (le16_to_cpu(scsiio_req->dev_hdl) != hdl)
+			break;
+		dev_err(&adapter->pdev->dev, "%s: Abort failed, hdl=0x%04x\n",
+			adapter->adapter_attr.name, hdl);
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
+out_cleanup:
+	leapraid_clear_tm_flg(adapter, hdl);
+	adapter->driver_cmds.tm_cmd.status = LEAPRAID_CMD_NOT_USED;
+	return rc;
+}
+
+int leapraid_issue_locked_tm(struct leapraid_adapter *adapter, u16 hdl,
+			     uint channel, uint id, uint lun, u8 type,
+			     u16 target_taskid, u8 tr_method)
+{
+	int rc;
+
+	mutex_lock(&adapter->driver_cmds.tm_cmd.mutex);
+	rc = leapraid_issue_tm(adapter, hdl, channel, id, lun, type,
+			       target_taskid, tr_method);
+	mutex_unlock(&adapter->driver_cmds.tm_cmd.mutex);
+
+	return rc;
+}
+
+void leapraid_smart_fault_detect(struct leapraid_adapter *adapter, u16 hdl)
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
+		return;
+	}
+
+	starget = sas_dev->starget;
+	starget_priv = starget ? starget->hostdata : NULL;
+	if (!starget_priv) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		goto release_sdev;
+	}
+
+	if (starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER ||
+	    starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		goto release_sdev;
+	}
+
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	leapraid_async_turn_on_led(adapter, hdl);
+release_sdev:
+	if (sas_dev)
+		leapraid_sdev_put(sas_dev);
+}
+
+static void leapraid_process_sense_data(struct leapraid_adapter *adapter,
+					struct leapraid_scsiio_rep *scsiio_rep,
+					struct scsi_cmnd *scmd, u16 taskid)
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
+		   le32_to_cpu(scsiio_rep->sense_count));
+
+	memcpy(scmd->sense_buffer, sense_data, sz);
+	leapraid_get_sense_data(scmd->sense_buffer, &data);
+	if (data.asc == ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED)
+		leapraid_smart_fault_detect(adapter,
+					    le16_to_cpu(scsiio_rep->dev_hdl));
+}
+
+static void leapraid_handle_data_underrun(
+		struct leapraid_scsiio_rep *scsiio_rep,
+		struct scsi_cmnd *scmd, u32 xfer_cnt)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+
+	scmd->result = (DID_OK << LEAPRAID_SCSI_HOST_SHIFT) | scsi_status;
+
+	if (scsi_state & LEAPRAID_SCSI_STATE_AUTOSENSE_VALID)
+		return;
+
+	if (xfer_cnt < scmd->underflow) {
+		if (scsi_status == SAM_STAT_BUSY)
+			scmd->result = SAM_STAT_BUSY;
+		else
+			scmd->result = DID_SOFT_ERROR <<
+				LEAPRAID_SCSI_HOST_SHIFT;
+	} else if (scsi_state & (LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED |
+				 LEAPRAID_SCSI_STATE_NO_SCSI_STATUS)) {
+		scmd->result = DID_SOFT_ERROR << LEAPRAID_SCSI_HOST_SHIFT;
+	} else if (scsi_state & LEAPRAID_SCSI_STATE_TERMINATED) {
+		scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+	} else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
+		scsiio_rep->scsi_state = LEAPRAID_SCSI_STATE_AUTOSENSE_VALID;
+		scsiio_rep->scsi_status = SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
+				 LEAPRAID_SCSI_ASC_INVALID_CMD_CODE,
+				 LEAPRAID_SCSI_ASCQ_DEFAULT);
+	}
+}
+
+static void leapraid_handle_success_status(
+		struct leapraid_scsiio_rep *scsiio_rep,
+		struct scsi_cmnd *scmd,
+		u32 response_code)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+
+	scmd->result = (DID_OK << LEAPRAID_SCSI_HOST_SHIFT) | scsi_status;
+
+	if (response_code == LEAPRAID_TM_RSP_INVALID_FRAME ||
+	    (scsi_state & (LEAPRAID_SCSI_STATE_AUTOSENSE_FAILED |
+			   LEAPRAID_SCSI_STATE_NO_SCSI_STATUS)))
+		scmd->result = DID_SOFT_ERROR << LEAPRAID_SCSI_HOST_SHIFT;
+	else if (scsi_state & LEAPRAID_SCSI_STATE_TERMINATED)
+		scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+}
+
+static void leapraid_scsiio_done_dispatch(
+		struct leapraid_adapter *adapter,
+		struct leapraid_scsiio_rep *scsiio_rep,
+		struct leapraid_sdev_priv *sdev_priv,
+		struct scsi_cmnd *scmd,
+		u16 taskid, u32 response_code)
+{
+	u8 scsi_status = scsiio_rep->scsi_status;
+	u8 scsi_state = scsiio_rep->scsi_state;
+	u16 adapter_status;
+	u32 xfer_cnt;
+	u32 sz;
+
+	adapter_status = le16_to_cpu(scsiio_rep->adapter_status) &
+				     LEAPRAID_ADAPTER_STATUS_MASK;
+
+	xfer_cnt = le32_to_cpu(scsiio_rep->transfer_count);
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
+
+	if (adapter_status == LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN &&
+	    xfer_cnt == 0 &&
+	    (scsi_status == LEAPRAID_SCSI_STATUS_BUSY ||
+	    scsi_status == LEAPRAID_SCSI_STATUS_RESERVATION_CONFLICT ||
+	    scsi_status == LEAPRAID_SCSI_STATUS_TASK_SET_FULL))
+		adapter_status = LEAPRAID_ADAPTER_STATUS_SUCCESS;
+
+	switch (adapter_status) {
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DEVICE_NOT_THERE:
+		scmd->result = DID_NO_CONNECT << LEAPRAID_SCSI_HOST_SHIFT;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_BUSY:
+	case LEAPRAID_ADAPTER_STATUS_INSUFFICIENT_RESOURCES:
+		scmd->result = SAM_STAT_BUSY;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_RESIDUAL_MISMATCH:
+		if (xfer_cnt == 0 || scmd->underflow > xfer_cnt)
+			scmd->result = DID_SOFT_ERROR <<
+				LEAPRAID_SCSI_HOST_SHIFT;
+		else
+			scmd->result = (DID_OK << LEAPRAID_SCSI_HOST_SHIFT) |
+				scsi_status;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_ADAPTER_TERMINATED:
+		if (sdev_priv->block) {
+			scmd->result = DID_TRANSPORT_DISRUPTED <<
+				LEAPRAID_SCSI_HOST_SHIFT;
+			return;
+		}
+
+		if (scmd->device->channel == RAID_CHANNEL &&
+		    scsi_state == (LEAPRAID_SCSI_STATE_TERMINATED |
+				    LEAPRAID_SCSI_STATE_NO_SCSI_STATUS)) {
+			scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+			break;
+		}
+
+		scmd->result = DID_SOFT_ERROR << LEAPRAID_SCSI_HOST_SHIFT;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_TASK_TERMINATED:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_EXT_TERMINATED:
+		scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DATA_UNDERRUN:
+		leapraid_handle_data_underrun(scsiio_rep, scmd, xfer_cnt);
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_DATA_OVERRUN:
+		scsi_set_resid(scmd, 0);
+		leapraid_handle_success_status(scsiio_rep, scmd,
+					       response_code);
+		break;
+	case LEAPRAID_ADAPTER_STATUS_SCSI_RECOVERED_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SUCCESS:
+		leapraid_handle_success_status(scsiio_rep, scmd,
+					       response_code);
+		break;
+
+	case LEAPRAID_ADAPTER_STATUS_SCSI_PROTOCOL_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_INTERNAL_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_IO_DATA_ERROR:
+	case LEAPRAID_ADAPTER_STATUS_SCSI_TASK_MGMT_FAILED:
+	default:
+		scmd->result = DID_SOFT_ERROR << LEAPRAID_SCSI_HOST_SHIFT;
+		break;
+	}
+
+	if (!scmd->result)
+		return;
+
+	scsi_print_command(scmd);
+	dev_warn(&adapter->pdev->dev,
+		 "SCSI I/O: hdl=0x%x, status: 0x%x, 0x%x, 0x%x\n",
+		 le16_to_cpu(scsiio_rep->dev_hdl), adapter_status,
+		 scsi_status, scsi_state);
+
+	if (scsi_state & LEAPRAID_SCSI_STATE_AUTOSENSE_VALID) {
+		struct scsi_sense_hdr sshdr;
+
+		sz = min_t(u32, SCSI_SENSE_BUFFERSIZE,
+			   le32_to_cpu(scsiio_rep->sense_count));
+		if (scsi_normalize_sense(scmd->sense_buffer, sz,
+					 &sshdr))
+			dev_warn(&adapter->pdev->dev,
+				 "Sense: key=0x%x asc=0x%x ascq=0x%x\n",
+				 sshdr.sense_key, sshdr.asc,
+				 sshdr.ascq);
+		else
+			dev_warn(&adapter->pdev->dev,
+				 "Sense: Invalid sense data\n");
+	}
+}
+
+bool leapraid_scsiio_done(struct leapraid_adapter *adapter, u16 taskid,
+			  u8 msix_index, u32 rep)
+{
+	struct leapraid_scsiio_rep *scsiio_rep;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct scsi_cmnd *scmd;
+	u32 response_code = 0;
+
+	if (likely(taskid != adapter->driver_cmds.driver_scsiio_cmd.taskid))
+		scmd = leapraid_get_scmd_from_taskid(adapter, taskid);
+	else
+		scmd = adapter->driver_cmds.internal_scmd;
+	if (!scmd)
+		return true;
+
+	scsiio_rep = leapraid_get_reply_vaddr(adapter, rep);
+	if (!scsiio_rep) {
+		scmd->result = DID_OK << LEAPRAID_SCSI_HOST_SHIFT;
+		goto out_scsiio_done;
+	}
+
+	sdev_priv = scmd->device->hostdata;
+	if (!sdev_priv ||
+	    !sdev_priv->starget_priv ||
+	    sdev_priv->starget_priv->deleted) {
+		scmd->result = DID_NO_CONNECT << LEAPRAID_SCSI_HOST_SHIFT;
+		goto out_scsiio_done;
+	}
+
+	if (scsiio_rep->scsi_state & LEAPRAID_SCSI_STATE_RESPONSE_INFO_VALID)
+		response_code = le32_to_cpu(scsiio_rep->resp_info) & 0xFF;
+
+	leapraid_process_sense_data(adapter, scsiio_rep, scmd, taskid);
+	leapraid_scsiio_done_dispatch(adapter, scsiio_rep, sdev_priv, scmd,
+				      taskid, response_code);
+
+out_scsiio_done:
+	scsi_dma_unmap(scmd);
+	if (unlikely(taskid ==
+		     adapter->driver_cmds.driver_scsiio_cmd.taskid)) {
+		adapter->driver_cmds.driver_scsiio_cmd.status =
+			LEAPRAID_CMD_DONE;
+		complete(&adapter->driver_cmds.driver_scsiio_cmd.done);
+		return false;
+	}
+	leapraid_free_taskid(adapter, taskid);
+	scsi_done(scmd);
+	return false;
+}
+
+static void leapraid_probe_raid(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume, *next_raid_volume;
+	unsigned long flags;
+	LIST_HEAD(head);
+	int rc;
+
+	spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+	list_splice_init(&adapter->dev_topo.raid_volume_list, &head);
+	spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock, flags);
+
+	list_for_each_entry_safe(raid_volume, next_raid_volume, &head, list) {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		list_move_tail(&raid_volume->list,
+			       &adapter->dev_topo.raid_volume_list);
+		if (raid_volume->starget) {
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock, flags);
+			continue;
+		}
+
+		leapraid_raid_volume_get(raid_volume);
+		spin_unlock_irqrestore(
+			&adapter->dev_topo.raid_volume_lock, flags);
+
+		rc = scsi_add_device(adapter->shost, RAID_CHANNEL,
+				     raid_volume->id, 0);
+		if (rc)
+			leapraid_raid_volume_remove(adapter, raid_volume);
+
+		leapraid_raid_volume_put(raid_volume);
+	}
+}
+
+static void leapraid_sas_dev_make_active(struct leapraid_adapter *adapter,
+					 struct leapraid_sas_dev *sas_dev)
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
+static void leapraid_probe_sas(struct leapraid_adapter *adapter)
+{
+	struct leapraid_sas_dev *sas_dev;
+	bool added;
+
+	for (;;) {
+		sas_dev = leapraid_get_next_sas_dev_from_init_list(adapter);
+		if (!sas_dev)
+			break;
+		added = leapraid_transport_port_add(adapter,
+						    sas_dev->hdl,
+						    sas_dev->parent_sas_addr,
+						    sas_dev->card_port);
+		if (!added)
+			goto remove_dev;
+
+		if (!sas_dev->starget &&
+		    !adapter->scan_dev_desc.driver_loading) {
+			leapraid_transport_port_remove(adapter,
+						       sas_dev->sas_addr,
+						       sas_dev->parent_sas_addr,
+						       sas_dev->card_port);
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
+static bool leapraid_get_boot_dev(struct leapraid_adapter *adapter,
+				  struct leapraid_boot_dev *boot_dev,
+				  void **pdev, u32 *pchnl)
+{
+	unsigned long flags;
+	void *dev;
+	u32 chnl;
+
+	spin_lock_irqsave(&adapter->boot_devs.lock, flags);
+	if (!boot_dev->dev) {
+		spin_unlock_irqrestore(&adapter->boot_devs.lock, flags);
+		return false;
+	}
+
+	dev = boot_dev->dev;
+	chnl = boot_dev->chnl;
+	leapraid_boot_dev_get(dev, chnl);
+	spin_unlock_irqrestore(&adapter->boot_devs.lock, flags);
+
+	*pdev = dev;
+	*pchnl = chnl;
+	return true;
+}
+
+static void leapraid_probe_boot_dev(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_sas_dev *sas_dev;
+	struct leapraid_sas_port *sport;
+	unsigned long flags;
+	void *dev = NULL;
+	u32 chnl;
+
+	if (leapraid_get_boot_dev(adapter,
+				  &adapter->boot_devs.requested_boot_dev,
+				  &dev, &chnl))
+		goto boot_dev_found;
+
+	if (leapraid_get_boot_dev(adapter,
+				  &adapter->boot_devs.requested_alt_boot_dev,
+				  &dev, &chnl))
+		goto boot_dev_found;
+
+	if (leapraid_get_boot_dev(adapter,
+				  &adapter->boot_devs.current_boot_dev,
+				  &dev, &chnl))
+		goto boot_dev_found;
+
+	return;
+
+boot_dev_found:
+	switch (chnl) {
+	case RAID_CHANNEL:
+		raid_volume = dev;
+
+		if (raid_volume->starget)
+			break;
+
+		/* TODO eedp */
+
+		if (scsi_add_device(adapter->shost, RAID_CHANNEL,
+				    raid_volume->id, 0))
+			leapraid_raid_volume_remove(adapter, raid_volume);
+		break;
+	default:
+		sas_dev = dev;
+
+		if (sas_dev->starget)
+			break;
+
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		list_move_tail(&sas_dev->list,
+			       &adapter->dev_topo.sas_dev_list);
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+		if (!sas_dev->card_port)
+			break;
+
+		sport = leapraid_transport_port_add(adapter, sas_dev->hdl,
+						    sas_dev->parent_sas_addr,
+						    sas_dev->card_port);
+		if (!sport)
+			leapraid_sas_dev_remove(adapter, sas_dev);
+		break;
+	}
+
+	leapraid_boot_dev_put(dev, chnl);
+}
+
+static void leapraid_probe_devices(struct leapraid_adapter *adapter)
+{
+	leapraid_probe_boot_dev(adapter);
+
+	if (adapter->adapter_attr.raid_support) {
+		leapraid_probe_raid(adapter);
+		leapraid_probe_sas(adapter);
+	} else {
+		leapraid_probe_sas(adapter);
+	}
+}
+
+void leapraid_scan_dev_done(struct leapraid_adapter *adapter)
+{
+	if (adapter->scan_dev_desc.wait_scan_dev_done) {
+		adapter->scan_dev_desc.wait_scan_dev_done = 0;
+		leapraid_probe_devices(adapter);
+	}
+
+	adapter->scan_dev_desc.scan_start = 0;
+
+	leapraid_check_scheduled_fault_start(adapter);
+	leapraid_fw_log_start(adapter);
+	adapter->scan_dev_desc.driver_loading = 0;
+	wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+	leapraid_smart_polling_start(adapter);
+}
+
+static const struct pci_device_id leapraid_pci_table[] = {
+	{ PCI_DEVICE_SUB(LEAPRAID_VENDOR_ID, LEAPRAID_DEVID_HBA,
+			 LEAPRAID_SUBVENDOR_ID,
+			 LEAPRAID_SUBDEVID_HBA) },
+	{ 0, }
+};
+
+static inline bool leapraid_is_scmd_permitted(struct leapraid_adapter *adapter,
+					      struct scsi_cmnd *scmd)
+{
+	u8 opcode;
+
+	if (adapter->access_ctrl.pcie_recovering ||
+	    atomic_read(&adapter->overheat_desc.thermal_alert))
+		return false;
+
+	if (adapter->access_ctrl.host_removing) {
+		if (leapraid_pci_removed(adapter))
+			return false;
+
+		opcode = scmd->cmnd[0];
+		return opcode == SYNCHRONIZE_CACHE || opcode == START_STOP;
+	}
+	return true;
+}
+
+static bool leapraid_should_queuecommand(struct leapraid_adapter *adapter,
+					 struct leapraid_sdev_priv *sdev_priv,
+					 struct scsi_cmnd *scmd,
+					 enum scsi_qc_status *rc)
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
+	    scmd->device->host->shost_state == SHOST_RECOVERY &&
+	    scmd->cmnd[0] == TEST_UNIT_READY) {
+		scsi_build_sense(scmd, 0, UNIT_ATTENTION,
+				 LEAPRAID_SCSI_ASC_POWER_ON_RESET,
+				 LEAPRAID_SCSI_ASCQ_POWER_ON_RESET);
+		goto scsiio_done;
+	}
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->reset_desc.adapter_link_resetting) {
+		*rc = SCSI_MLQUEUE_HOST_BUSY;
+		return false;
+	}
+
+	if (starget_priv->deleted || sdev_priv->deleted)
+		goto no_connect;
+
+	if (starget_priv->tm_busy || sdev_priv->block) {
+		*rc = SCSI_MLQUEUE_DEVICE_BUSY;
+		return false;
+	}
+
+	return true;
+
+no_connect:
+	scmd->result = DID_NO_CONNECT << LEAPRAID_SCSI_HOST_SHIFT;
+scsiio_done:
+	if (likely(scmd != adapter->driver_cmds.internal_scmd))
+		scsi_done(scmd);
+	else
+		*rc = LEAPRAID_OPERATION_FAILED;
+
+	return false;
+}
+
+static u32 build_scsiio_req_control(struct scsi_cmnd *scmd,
+				    struct leapraid_sdev_priv *sdev_priv)
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
+	    (IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd))) ==
+	     IOPRIO_CLASS_RT))
+		control |= LEAPRAID_SCSIIO_CTRL_CMDPRI;
+	if (scmd->cmd_len == 32)
+		control |= LEAPRAID_SCSIIO_CTRL_CDB_32BYTE <<
+				LEAPRAID_SCSIIO_CTRL_CDB_LEN_SHIFT;
+
+	return control;
+}
+
+enum scsi_qc_status leapraid_queuecommand(struct Scsi_Host *shost,
+					  struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(scmd->device->host);
+	struct leapraid_sdev_priv *sdev_priv = scmd->device->hostdata;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_scsiio_req *scsiio_req;
+	u32 control;
+	u16 taskid;
+	u16 hdl;
+	enum scsi_qc_status rc = 0;
+
+	if (!leapraid_should_queuecommand(adapter, sdev_priv, scmd, &rc))
+		return rc;
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
+	scsiio_req->func = LEAPRAID_FUNC_SCSIIO;
+	if (sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER)
+		scsiio_req->func = LEAPRAID_FUNC_SCSIIO_RAID_PASSTHROUGH;
+	else
+		scsiio_req->func = LEAPRAID_FUNC_SCSIIO;
+
+	scsiio_req->dev_hdl = cpu_to_le16(hdl);
+	scsiio_req->data_len = cpu_to_le32(scsi_bufflen(scmd));
+	scsiio_req->ctrl = cpu_to_le32(control);
+	scsiio_req->io_flg = cpu_to_le16(scmd->cmd_len);
+	scsiio_req->msg_flg = 0;
+	scsiio_req->sense_buffer_len = SCSI_SENSE_BUFFERSIZE;
+	scsiio_req->sense_buffer_low_add =
+		leapraid_get_sense_buffer_dma(adapter, taskid);
+	scsiio_req->sgl_offset0 =
+		offsetof(struct leapraid_scsiio_req, sgl) /
+		LEAPRAID_DWORDS_BYTE_SIZE;
+	int_to_scsilun(sdev_priv->lun, (struct scsi_lun *)scsiio_req->lun);
+	memcpy(scsiio_req->cdb.cdb32, scmd->cmnd, scmd->cmd_len);
+	if (scsiio_req->data_len) {
+		if (leapraid_build_scmd_ieee_sg(adapter, scmd, taskid)) {
+			leapraid_free_taskid(adapter, taskid);
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
+	} else {
+		leapraid_build_ieee_nodata_sg(adapter, &scsiio_req->sgl);
+	}
+
+	if (likely(scsiio_req->func == LEAPRAID_FUNC_SCSIIO))
+		leapraid_fire_scsi_io(adapter, taskid,
+				      le16_to_cpu(scsiio_req->dev_hdl));
+	else
+		leapraid_fire_task(adapter, taskid);
+
+	dev_dbg(&adapter->pdev->dev,
+		"LEAPRAID_SCSIIO: Send Descriptor taskid %d, req type 0x%x\n",
+		taskid, scsiio_req->func);
+	return rc;
+}
+
+static int leapraid_init_cmd_priv(struct Scsi_Host *shost,
+				  struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_io_req_tracker *io_tracker;
+
+	io_tracker = scsi_cmd_priv(scmd);
+	leapraid_internal_init_cmd_priv(adapter, io_tracker);
+
+	return 0;
+}
+
+static int leapraid_exit_cmd_priv(struct Scsi_Host *shost,
+				  struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_io_req_tracker *io_tracker;
+
+	io_tracker = scsi_cmd_priv(scmd);
+	leapraid_internal_exit_cmd_priv(adapter, io_tracker);
+
+	return 0;
+}
+
+static int leapraid_error_handler(struct scsi_cmnd *scmd,
+				  const char *str, u8 type)
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
+	dev_info(&adapter->pdev->dev,
+		 "EH enter: type=%s, scmd=0x%p, req tag=%d\n", str, scmd,
+		 scsi_cmd_to_rq(scmd)->tag);
+	scsi_print_command(scmd);
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		io_req_tracker = scsi_cmd_priv(scmd);
+		dev_info(&adapter->pdev->dev,
+			 "EH ABORT: scmd=0x%p, pend=%ums, tout=%ums, tag=%d\n",
+			 scmd,
+			 jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
+			 (scsi_cmd_to_rq(scmd)->timeout / HZ) * 1000,
+			 scsi_cmd_to_rq(scmd)->tag);
+	}
+
+	if (leapraid_pci_removed(adapter) ||
+	    adapter->access_ctrl.host_removing) {
+		dev_err(&adapter->pdev->dev,
+			"EH %s failed: %s scmd=0x%p\n", str,
+			(adapter->access_ctrl.host_removing ?
+			"shost removing!" : "pci_dev removed!"), scmd);
+		if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK &&
+		    io_req_tracker && io_req_tracker->taskid)
+			leapraid_free_taskid(adapter, io_req_tracker->taskid);
+		scmd->result = DID_NO_CONNECT << LEAPRAID_SCSI_HOST_SHIFT;
+#ifdef FAST_IO_FAIL
+		rc = FAST_IO_FAIL;
+#else
+		rc = FAILED;
+#endif
+		goto out_eh_done;
+	}
+
+	sdev_priv = scmd->device->hostdata;
+	if (!sdev_priv || !sdev_priv->starget_priv) {
+		dev_warn(&adapter->pdev->dev,
+			 "EH %s: SAS dev or starget gone, scmd=0x%p\n",
+			 str, scmd);
+		scmd->result = DID_NO_CONNECT << LEAPRAID_SCSI_HOST_SHIFT;
+		scsi_done(scmd);
+		rc = SUCCESS;
+		goto out_eh_done;
+	}
+
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		if (!io_req_tracker) {
+			dev_warn(&adapter->pdev->dev,
+				 "EH ABORT: No I/O tracker, scmd 0x%p\n", scmd);
+			scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+			rc = SUCCESS;
+			goto out_eh_done;
+		}
+
+		if (sdev_priv->starget_priv->flg &
+			LEAPRAID_TGT_FLG_RAID_MEMBER ||
+		    sdev_priv->starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME) {
+			dev_err(&adapter->pdev->dev,
+				"EH ABORT: Skip RAID/VOLUME, scmd=0x%p\n",
+				scmd);
+			scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+			rc = FAILED;
+			goto out_eh_done;
+		}
+
+		hdl = sdev_priv->starget_priv->hdl;
+	} else {
+		hdl = 0;
+		if (sdev_priv->starget_priv->flg &
+		    LEAPRAID_TGT_FLG_RAID_MEMBER) {
+			sas_dev = leapraid_get_sas_dev_from_tgt(adapter,
+								starget_priv);
+			if (sas_dev)
+				hdl = sas_dev->volume_hdl;
+		} else {
+			hdl = sdev_priv->starget_priv->hdl;
+		}
+
+		if (!hdl) {
+			dev_err(&adapter->pdev->dev,
+				"EH %s failed: Target handle 0, scmd=0x%p\n",
+				str, scmd);
+			scmd->result = DID_RESET << LEAPRAID_SCSI_HOST_SHIFT;
+			rc = FAILED;
+			goto out_eh_done;
+		}
+	}
+
+	dev_info(&adapter->pdev->dev,
+		 "EH issue TM: type=%s, scmd=0x%p, hdl=0x%x\n",
+		 str, scmd, hdl);
+
+	rc = leapraid_issue_locked_tm(
+			adapter,
+			hdl,
+			scmd->device->channel,
+			scmd->device->id,
+			(type == LEAPRAID_TM_TASKTYPE_TARGET_RESET ?
+				0 : scmd->device->lun),
+			type,
+			(type == LEAPRAID_TM_TASKTYPE_ABORT_TASK ?
+				io_req_tracker->taskid : 0),
+			LEAPRAID_TM_MSGFLAGS_LINK_RESET);
+
+out_eh_done:
+	if (type == LEAPRAID_TM_TASKTYPE_ABORT_TASK) {
+		if (rc)
+			dev_err(&adapter->pdev->dev,
+				"EH ABORT result: failed, scmd=0x%p\n",
+				scmd);
+	} else {
+		if (rc)
+			dev_err(&adapter->pdev->dev,
+				"EH %s result: failed, scmd=0x%p\n",
+				str, scmd);
+		if (sas_dev)
+			leapraid_sdev_put(sas_dev);
+	}
+	return rc;
+}
+
+static int leapraid_eh_abort_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "ABORT TASK",
+				      LEAPRAID_TM_TASKTYPE_ABORT_TASK);
+}
+
+static int leapraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "UNIT RESET",
+				      LEAPRAID_TM_TASKTYPE_LOGICAL_UNIT_RESET);
+}
+
+static int leapraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
+{
+	return leapraid_error_handler(scmd, "TARGET RESET",
+				      LEAPRAID_TM_TASKTYPE_TARGET_RESET);
+}
+
+static int leapraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
+{
+	struct leapraid_adapter *adapter = shost_priv(scmd->device->host);
+	int rc;
+
+	dev_info(&adapter->pdev->dev,
+		 "EH HOST RESET enter: scmd=%p, req tag=%d\n",
+		 scmd,
+		 scsi_cmd_to_rq(scmd)->tag);
+	scsi_print_command(scmd);
+
+	if (adapter->scan_dev_desc.driver_loading ||
+	    adapter->access_ctrl.host_removing) {
+		dev_err(&adapter->pdev->dev,
+			"EH HOST RESET failed: %s scmd=0x%p\n",
+			(adapter->access_ctrl.host_removing ?
+			"shost removing!" : "driver loading!"), scmd);
+		rc = FAILED;
+		goto out_host_reset_done;
+	}
+
+	dev_info(&adapter->pdev->dev, "%s:%d: Issuing hard reset\n",
+		 __func__, __LINE__);
+	if (leapraid_hard_reset_handler(adapter, FULL_RESET) < 0)
+		rc = FAILED;
+	else
+		rc = SUCCESS;
+
+out_host_reset_done:
+	if (rc)
+		dev_err(&adapter->pdev->dev,
+			"EH HOST RESET result: failed, scmd=0x%p\n",
+			scmd);
+	return rc;
+}
+
+static int leapraid_sdev_init(struct scsi_device *sdev)
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
+	sdev_priv = kzalloc_obj(*sdev_priv);
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
+	if (stgt_priv->flg & LEAPRAID_TGT_FLG_RAID_MEMBER)
+		sdev->no_uld_attach = LEAPRAID_NO_ULD_ATTACH;
+
+	shost = dev_to_shost(&tgt->dev);
+	adapter = shost_priv(shost);
+	if (tgt->channel == RAID_CHANNEL) {
+		raid_volume = leapraid_raid_volume_find_by_id(adapter,
+							      tgt->id,
+							      tgt->channel);
+		if (raid_volume) {
+			spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock,
+					  flags);
+			raid_volume->sdev = sdev;
+			spin_unlock_irqrestore(
+				&adapter->dev_topo.raid_volume_lock, flags);
+			leapraid_raid_volume_put(raid_volume);
+		}
+	}
+
+	if (!(stgt_priv->flg & LEAPRAID_TGT_FLG_VOLUME)) {
+		spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+		sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(
+				adapter,
+				stgt_priv->sas_address,
+				stgt_priv->card_port);
+		if (sas_dev && !sas_dev->starget) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: Assign starget to sas_dev\n",
+				    __func__);
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
+static bool leapraid_slave_cfg_volume(struct scsi_device *sdev,
+				      struct queue_limits *lim)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sdev_priv *sdev_priv;
+	int qd;
+	u16 hdl;
+
+	sdev_priv = sdev->hostdata;
+	starget_priv = sdev_priv->starget_priv;
+	hdl = starget_priv->hdl;
+
+	raid_volume = leapraid_raid_volume_find_by_hdl(adapter, hdl);
+	if (!raid_volume) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: RAID volume not found, hdl=0x%x\n",
+			    __func__, hdl);
+		return 1;
+	}
+
+	if (leapraid_get_volume_cap(adapter, raid_volume)) {
+		sdev_printk(KERN_ERR, sdev,
+			    "%s: Failed to get volume cap, hdl=0x%x\n",
+			    __func__, hdl);
+		leapraid_raid_volume_put(raid_volume);
+		return 1;
+	}
+
+	qd = (raid_volume->dev_info & LEAPRAID_DEVTYP_SSP_TGT) ?
+		adapter->adapter_attr.narrowport_max_queue_depth :
+		adapter->adapter_attr.sata_max_queue_depth;
+	if (raid_volume->vol_type != LEAPRAID_VOL_TYPE_RAID0)
+		qd = adapter->adapter_attr.raid_volume_max_queue_depth;
+
+	sdev_printk(KERN_INFO, sdev,
+		    "RAID volume: hdl=0x%04x, wwid=0x%016llx\n",
+		    raid_volume->hdl, (unsigned long long)raid_volume->wwid);
+
+	if (shost->max_sectors > LEAPRAID_MAX_SECTORS)
+		lim->max_hw_sectors = LEAPRAID_MAX_SECTORS;
+
+	leapraid_change_queue_depth(sdev, qd);
+	leapraid_raid_volume_put(raid_volume);
+	return 0;
+}
+
+static bool leapraid_slave_configure_extra(struct scsi_device *sdev,
+					   struct leapraid_sas_dev **psas_dev,
+					   u16 vol_hdl, u64 volume_wwid,
+					   bool *is_target_ssp, int *qd)
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
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr(
+			adapter,
+			sdev_priv->starget_priv->sas_address,
+			sdev_priv->starget_priv->card_port);
+	if (!sas_dev) {
+		spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: SAS dev not found, sas=0x%llx\n",
+			    __func__, sdev_priv->starget_priv->sas_address);
+		return 1;
+	}
+
+	*psas_dev = sas_dev;
+	sas_dev->volume_hdl = vol_hdl;
+	sas_dev->volume_wwid = volume_wwid;
+	if (sas_dev->dev_info & LEAPRAID_DEVTYP_SSP_TGT) {
+		*qd = (sas_dev->port_connection > 1) ?
+			adapter->adapter_attr.wideport_max_queue_depth :
+			adapter->adapter_attr.narrowport_max_queue_depth;
+		*is_target_ssp = true;
+		if (sas_dev->dev_info & LEAPRAID_DEVTYP_SEP)
+			sdev_priv->sep = 1;
+	} else {
+		*qd = adapter->adapter_attr.sata_max_queue_depth;
+	}
+
+	sdev_printk(KERN_INFO, sdev,
+		    "device name=0x%016llx, SAS addr=0x%016llx\n",
+		    (unsigned long long)sas_dev->dev_name,
+		    (unsigned long long)sas_dev->sas_addr);
+	leapraid_sdev_put(sas_dev);
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+	return 0;
+}
+
+static int leapraid_sdev_configure(struct scsi_device *sdev,
+				   struct queue_limits *lim)
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
+		if (leapraid_cfg_get_volume_hdl(adapter, hdl, &vol_hdl)) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: Get volume hdl failed, hdl=0x%x\n",
+				    __func__, hdl);
+			return 1;
+		}
+
+		if (vol_hdl && leapraid_cfg_get_volume_wwid(adapter, vol_hdl,
+							    &volume_wwid)) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: Get wwid failed, volume_hdl=0x%x\n",
+				    __func__, vol_hdl);
+			return 1;
+		}
+	}
+
+	if (leapraid_slave_configure_extra(sdev, &sas_dev, vol_hdl,
+					   volume_wwid, &is_target_ssp, &qd)) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: slave_configure_extra failed\n", __func__);
+		return 1;
+	}
+
+	leapraid_change_queue_depth(sdev, qd);
+	if (is_target_ssp)
+		sas_read_port_mode_page(sdev);
+
+	return 0;
+}
+
+static void leapraid_sdev_destroy(struct scsi_device *sdev)
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
+		sas_dev = leapraid_hold_lock_get_sas_dev_from_tgt(adapter,
+								  starget_priv);
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
+static int leapraid_target_alloc_raid(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_raid_volume *raid_volume;
+	struct Scsi_Host *shost = dev_to_shost(&tgt->dev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	unsigned long flags;
+
+	starget_priv = tgt->hostdata;
+	raid_volume = leapraid_raid_volume_find_by_id(adapter, tgt->id,
+						      tgt->channel);
+	if (raid_volume) {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		starget_priv->hdl = raid_volume->hdl;
+		starget_priv->sas_address = raid_volume->wwid;
+		starget_priv->flg |= LEAPRAID_TGT_FLG_VOLUME;
+		raid_volume->starget = tgt;
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+		leapraid_raid_volume_put(raid_volume);
+	}
+	return 0;
+}
+
+static int leapraid_target_alloc_sas(struct scsi_target *tgt)
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
+	starget_priv = tgt->hostdata;
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	rphy = dev_to_rphy(tgt->dev.parent);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+			adapter,
+			rphy->identify.sas_address,
+			rphy);
+	if (sas_dev) {
+		starget_priv->sas_dev = sas_dev;
+		starget_priv->card_port = sas_dev->card_port;
+		starget_priv->sas_address = sas_dev->sas_addr;
+		starget_priv->hdl = sas_dev->hdl;
+		sas_dev->channel = tgt->channel;
+		sas_dev->id = tgt->id;
+		sas_dev->starget = tgt;
+		if (sas_dev->hdl &&
+		    sas_dev->hdl <=
+		    adapter->adapter_attr.features.max_dev_handle &&
+		    test_bit(sas_dev->hdl, adapter->dev_topo.pd_hdls))
+			starget_priv->flg |= LEAPRAID_TGT_FLG_RAID_MEMBER;
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	return 0;
+}
+
+static int leapraid_target_alloc(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	starget_priv = kzalloc_obj(*starget_priv);
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
+static void leapraid_target_destroy_raid(struct scsi_target *tgt)
+{
+	struct leapraid_raid_volume *raid_volume;
+	struct Scsi_Host *shost = dev_to_shost(&tgt->dev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	unsigned long flags;
+
+	raid_volume = leapraid_raid_volume_find_by_id(adapter, tgt->id,
+						      tgt->channel);
+	if (raid_volume) {
+		spin_lock_irqsave(&adapter->dev_topo.raid_volume_lock, flags);
+		raid_volume->starget = NULL;
+		raid_volume->sdev = NULL;
+		spin_unlock_irqrestore(&adapter->dev_topo.raid_volume_lock,
+				       flags);
+		leapraid_raid_volume_put(raid_volume);
+	}
+}
+
+static void leapraid_target_destroy_sas(struct scsi_target *tgt)
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
+	sas_dev = leapraid_hold_lock_get_sas_dev_from_tgt(adapter,
+							  starget_priv);
+	if (sas_dev &&
+	    sas_dev->starget == tgt &&
+	    sas_dev->id == tgt->id &&
+	    sas_dev->channel == tgt->channel)
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
+static void leapraid_target_destroy(struct scsi_target *tgt)
+{
+	struct leapraid_starget_priv *starget_priv;
+
+	starget_priv = tgt->hostdata;
+	if (!starget_priv)
+		return;
+
+	if (tgt->channel == RAID_CHANNEL) {
+		leapraid_target_destroy_raid(tgt);
+		goto out_free;
+	}
+
+	leapraid_target_destroy_sas(tgt);
+
+out_free:
+	kfree(starget_priv);
+	tgt->hostdata = NULL;
+}
+
+static bool leapraid_scan_check_status(struct leapraid_adapter *adapter,
+				       bool *need_hard_reset)
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
+			"Device scan: Aborted due to reset\n");
+		adapter->driver_cmds.scan_dev_cmd.status =
+			LEAPRAID_CMD_NOT_USED;
+		adapter->scan_dev_desc.driver_loading = 0;
+		wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		return true;
+	}
+
+	if (adapter->scan_dev_desc.scan_start_failed) {
+		dev_err(&adapter->pdev->dev,
+			"Device scan: Failed with adapter_status=0x%08x\n",
+			adapter->scan_dev_desc.scan_start_failed);
+		adapter->scan_dev_desc.driver_loading = 0;
+		wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		adapter->scan_dev_desc.wait_scan_dev_done = 0;
+		adapter->access_ctrl.host_removing = 1;
+		return true;
+	}
+
+	adapter->driver_cmds.scan_dev_cmd.status = LEAPRAID_CMD_NOT_USED;
+	leapraid_scan_dev_done(adapter);
+	return true;
+}
+
+static int leapraid_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+	bool need_hard_reset = false;
+
+	if (time >= (LEAPRAID_SCAN_DEV_CMD_TIMEOUT * HZ)) {
+		adapter->driver_cmds.scan_dev_cmd.status =
+			LEAPRAID_CMD_NOT_USED;
+		dev_err(&adapter->pdev->dev,
+			"Device scan: Failed with timeout 300s\n");
+		adapter->scan_dev_desc.driver_loading = 0;
+		wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		return 1;
+	}
+
+	if (!leapraid_scan_check_status(adapter, &need_hard_reset))
+		return 0;
+
+	if (need_hard_reset) {
+		adapter->driver_cmds.scan_dev_cmd.status =
+			LEAPRAID_CMD_NOT_USED;
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		if (leapraid_hard_reset_handler(adapter, PART_RESET)) {
+			adapter->scan_dev_desc.driver_loading = 0;
+			wake_up(&adapter->scan_dev_desc.wait_driver_loading);
+		}
+	}
+
+	return 1;
+}
+
+static void leapraid_scan_start(struct Scsi_Host *shost)
+{
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	adapter->scan_dev_desc.scan_start = 1;
+	leapraid_scan_dev(adapter, true);
+}
+
+static u32 leapraid_get_raid_qd(struct leapraid_adapter *adapter,
+				const struct leapraid_raid_volume *raid_volume,
+				bool default_qd)
+{
+	const struct leapraid_adapter_attr *attr = &adapter->adapter_attr;
+
+	if (raid_volume->vol_type != LEAPRAID_VOL_TYPE_RAID0)
+		return default_qd ? LEAPRAID_RAID_QUEUE_DEPTH :
+			attr->raid_volume_max_queue_depth;
+
+	if (raid_volume->dev_info & LEAPRAID_DEVTYP_SSP_TGT)
+		return default_qd ? LEAPRAID_SAS_QUEUE_DEPTH :
+			attr->narrowport_max_queue_depth;
+
+	return default_qd ? LEAPRAID_SATA_QUEUE_DEPTH :
+		attr->sata_max_queue_depth;
+}
+
+static int leapraid_calc_max_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	struct Scsi_Host *shost;
+	struct leapraid_adapter *adapter;
+	struct leapraid_starget_priv *starget_priv;
+	struct leapraid_sdev_priv *sdev_priv;
+	struct leapraid_raid_volume *raid_volume;
+	struct leapraid_sas_dev *sas_dev;
+	int max_depth;
+	u32 default_qdepth = 0;
+	u32 fw_qdepth = 0;
+
+	shost = sdev->host;
+	adapter = shost_priv(shost);
+	max_depth = shost->can_queue;
+
+	sdev_priv = sdev->hostdata;
+	if (!sdev_priv)
+		goto out_tag_check;
+
+	starget_priv = sdev_priv->starget_priv;
+	if (!starget_priv)
+		goto out_tag_check;
+
+	if (starget_priv->flg & LEAPRAID_TGT_FLG_VOLUME) {
+		raid_volume = leapraid_raid_volume_find_by_hdl(
+					adapter, starget_priv->hdl);
+		if (raid_volume) {
+			default_qdepth = leapraid_get_raid_qd(
+					adapter, raid_volume, true);
+			fw_qdepth = leapraid_get_raid_qd(
+					adapter, raid_volume, false);
+			leapraid_raid_volume_put(raid_volume);
+		}
+		goto out_limit_check;
+	}
+
+	sas_dev = leapraid_get_sas_dev_from_tgt(adapter, starget_priv);
+	if (sas_dev) {
+		if (sas_dev->dev_info & LEAPRAID_DEVTYP_SSP_TGT) {
+			default_qdepth = LEAPRAID_SAS_QUEUE_DEPTH;
+			fw_qdepth = (sas_dev->port_connection > 1) ?
+			      adapter->adapter_attr.wideport_max_queue_depth :
+			      adapter->adapter_attr.narrowport_max_queue_depth;
+		}
+		if (sas_dev->dev_info & LEAPRAID_DEVTYP_SATA_DEV) {
+			default_qdepth = LEAPRAID_SATA_QUEUE_DEPTH;
+			fw_qdepth = adapter->adapter_attr.sata_max_queue_depth;
+		}
+		leapraid_sdev_put(sas_dev);
+	}
+
+out_limit_check:
+	if (fw_qdepth > shost->can_queue && default_qdepth)
+		fw_qdepth = default_qdepth;
+
+	if (fw_qdepth)
+		max_depth = min_t(int, max_depth, fw_qdepth);
+
+out_tag_check:
+	if (!sdev->tagged_supported)
+		max_depth = 1;
+
+	if (qdepth > max_depth)
+		qdepth = max_depth;
+
+	return qdepth;
+}
+
+int leapraid_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	qdepth = leapraid_calc_max_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
+static void leapraid_map_queues(struct Scsi_Host *shost)
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
+		return;
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
+			WARN_ON_ONCE(!queue_map->nr_queues);
+			blk_mq_map_hw_queues(queue_map,
+					     &adapter->pdev->dev, 0);
+			break;
+		case HCTX_TYPE_POLL:
+			queue_map->nr_queues = poll_queue_count;
+			queue_map->queue_offset = queue_offset;
+			blk_mq_map_queues(queue_map);
+			break;
+		default:
+			queue_map->queue_offset = queue_offset;
+			blk_mq_map_hw_queues(queue_map,
+					     &adapter->pdev->dev, 0);
+			break;
+		}
+		queue_offset += queue_map->nr_queues;
+	}
+}
+
+int leapraid_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct leapraid_adapter *adapter =
+		(struct leapraid_adapter *)shost->hostdata;
+	struct leapraid_blk_mq_poll_rq *blk_mq_poll_rq;
+	int num_entries;
+	int qid = queue_num - adapter->notification_desc.iopoll_qdex;
+
+	blk_mq_poll_rq = &adapter->notification_desc.blk_mq_poll_rqs[qid];
+	if (atomic_read(&blk_mq_poll_rq->pause) ||
+	    !atomic_add_unless(&blk_mq_poll_rq->busy, 1, 1))
+		return 0;
+
+	num_entries = leapraid_rep_queue_handler(&blk_mq_poll_rq->rq);
+	atomic_dec(&blk_mq_poll_rq->busy);
+	return num_entries;
+}
+
+static int leapraid_bios_param(struct scsi_device *sdev,
+			       struct gendisk *disk, sector_t capacity,
+			       int geom[])
+{
+	int heads;
+	int sectors;
+	sector_t cylinders;
+
+	if (scsi_partsize(disk, capacity, geom))
+		return 0;
+
+	if ((ulong)capacity >= LEAPRAID_LARGE_DISK_THRESHOLD) {
+		heads = LEAPRAID_LARGE_DISK_HEADS;
+		sectors = LEAPRAID_LARGE_DISK_SECTORS;
+	} else {
+		heads = LEAPRAID_SMALL_DISK_HEADS;
+		sectors = LEAPRAID_SMALL_DISK_SECTORS;
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
+static ssize_t fw_queue_depth_show(struct device *cdev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	return sysfs_emit(buf, "%02d\n",
+			  adapter->adapter_attr.features.req_slot);
+}
+
+static ssize_t host_sas_address_show(struct device *cdev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	return sysfs_emit(buf, "0x%016llx\n",
+		(unsigned long long)adapter->dev_topo.card.sas_address);
+}
+
+static ssize_t board_name_show(struct device *cdev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct leapraid_adapter *adapter = shost_priv(shost);
+
+	return sysfs_emit(buf, "%s\n", adapter->adapter_attr.board_name);
+}
+
+static DEVICE_ATTR_RO(fw_queue_depth);
+static DEVICE_ATTR_RO(host_sas_address);
+static DEVICE_ATTR_RO(board_name);
+
+static struct attribute *leapraid_shost_attrs[] = {
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_host_sas_address.attr,
+	&dev_attr_board_name.attr,
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(leapraid_shost);
+
+static ssize_t sas_address_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+	u64 sas_address;
+
+	if (!sas_device_priv_data || !sas_device_priv_data->starget_priv) {
+		dev_err(&sdev->sdev_gendev,
+			"%s: Invalid sdev_priv or starget_priv\n", __func__);
+		return -EINVAL;
+	}
+
+	sas_address = sas_device_priv_data->starget_priv->sas_address;
+
+	return sysfs_emit(buf, "0x%016llx\n", (unsigned long long)sas_address);
+}
+
+static ssize_t sas_device_handle_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+
+	if (!sas_device_priv_data || !sas_device_priv_data->starget_priv) {
+		dev_err(&sdev->sdev_gendev,
+			"%s: Invalid sdev_priv or starget_priv\n", __func__);
+		return -EINVAL;
+	}
+
+	return sysfs_emit(buf, "0x%04x\n",
+			  sas_device_priv_data->starget_priv->hdl);
+}
+
+static ssize_t sas_ncq_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+
+	if (!sas_device_priv_data) {
+		dev_err(&sdev->sdev_gendev,
+			"%s: Invalid sdev_priv\n", __func__);
+		return -EINVAL;
+	}
+
+	return sysfs_emit(buf, "%d\n", sas_device_priv_data->ncq);
+}
+
+static ssize_t sas_ncq_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
+	struct scsi_vpd *vpd_pg89;
+	int ncq_op;
+	bool ncq_supported;
+
+	if (!sas_device_priv_data) {
+		dev_err(&sdev->sdev_gendev,
+			"%s: Invalid sdev_priv\n", __func__);
+		return -EINVAL;
+	}
+
+	if (kstrtoint(buf, 0, &ncq_op))
+		return -EINVAL;
+
+	if (ncq_op != 0 && ncq_op != 1) {
+		dev_err(&sdev->sdev_gendev,
+			"%s: Invalid NCQ value %d (only 0/1 allowed)\n",
+			__func__, ncq_op);
+		return -EINVAL;
+	}
+
+	rcu_read_lock();
+	vpd_pg89 = rcu_dereference(sdev->vpd_pg89);
+	if (!vpd_pg89 || vpd_pg89->len < LEAPRAID_VPD_PG89_MIN_LEN) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	ncq_supported = (vpd_pg89->data[LEAPRAID_VPD_PG89_NCQ_BYTE_IDX] >>
+			 LEAPRAID_VPD_PG89_NCQ_BIT_SHIFT) &
+			LEAPRAID_VPD_PG89_NCQ_BIT_MASK;
+	rcu_read_unlock();
+	if (ncq_supported)
+		sas_device_priv_data->ncq = ncq_op;
+	return count;
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
+	.can_queue = LEAPRAID_CAN_QUEUE_MIN,
+	.this_id = LEAPRAID_THIS_ID_NONE,
+	.sg_tablesize = LEAPRAID_SG_DEPTH,
+	.max_sectors = LEAPRAID_MAX_SECTORS,
+	.max_segment_size = LEAPRAID_MAX_SEGMENT_SIZE,
+	.cmd_per_lun = LEAPRAID_CMD_PER_LUN,
+	.shost_groups = leapraid_shost_groups,
+	.sdev_groups = leapraid_sdev_groups,
+	.track_queue_depth = 1,
+};
+
+static void leapraid_lock_init(struct leapraid_adapter *adapter)
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
+	spin_lock_init(&adapter->dev_topo.enc_lock);
+	spin_lock_init(&adapter->boot_devs.lock);
+}
+
+static void leapraid_list_init(struct leapraid_adapter *adapter)
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
+static int leapraid_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct leapraid_adapter *adapter;
+	struct Scsi_Host *shost;
+	int iopoll_q_count;
+	int rc;
+
+	shost = scsi_host_alloc(&leapraid_driver_template,
+				sizeof(struct leapraid_adapter));
+	if (!shost) {
+		dev_err(&pdev->dev,
+			"%s: SCSI host alloc failed\n", __func__);
+		return -ENODEV;
+	}
+
+	adapter = shost_priv(shost);
+	memset(adapter, 0, sizeof(struct leapraid_adapter));
+
+	init_waitqueue_head(&adapter->access_ctrl.recovery_waitq);
+	adapter->adapter_attr.id = atomic_inc_return(&leapraid_ids) - 1;
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
+	snprintf(adapter->adapter_attr.name, LEAPRAID_NAME_LENGTH, "%s%d",
+		 LEAPRAID_DRIVER_NAME, adapter->adapter_attr.id);
+
+	shost->max_cmd_len = LEAPRAID_MAX_CDB_LEN;
+	shost->max_lun = LEAPRAID_MAX_LUNS;
+	shost->transportt = leapraid_transport_template;
+	shost->unique_id = adapter->adapter_attr.id;
+
+	snprintf(adapter->fw_evt_s.fw_evt_name,
+		 sizeof(adapter->fw_evt_s.fw_evt_name),
+		 "fw_event_%s%d", LEAPRAID_DRIVER_NAME,
+		 adapter->adapter_attr.id);
+	adapter->fw_evt_s.fw_evt_thread =
+		alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
+	if (!adapter->fw_evt_s.fw_evt_thread) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to create fw event workqueue\n", __func__);
+		rc = -ENODEV;
+		goto evt_wq_fail;
+	}
+
+	shost->host_tagset = 1;
+	init_waitqueue_head(&adapter->scan_dev_desc.wait_driver_loading);
+	adapter->scan_dev_desc.driver_loading = 1;
+	if (leapraid_ctrl_init(adapter)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Adapter init failed\n", __func__);
+		rc = -ENODEV;
+		goto ctrl_init_fail;
+	}
+
+	shost->nr_hw_queues = 1;
+	if (shost->host_tagset) {
+		shost->nr_hw_queues = adapter->adapter_attr.rq_cnt;
+		iopoll_q_count = adapter->adapter_attr.rq_cnt -
+				 adapter->notification_desc.iopoll_qdex;
+		shost->nr_maps = iopoll_q_count ? 3 : 1;
+		dev_info(&adapter->pdev->dev,
+			 "Max scsi I/O cmds %d shared with nr_hw_queues=%d\n",
+			 shost->can_queue, shost->nr_hw_queues);
+	}
+
+	rc = scsi_add_host(shost, &pdev->dev);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: SCSI host add failed\n", __func__);
+		goto scsi_add_shost_fail;
+	}
+
+	scsi_scan_host(shost);
+	return 0;
+
+scsi_add_shost_fail:
+	leapraid_remove_ctrl(adapter);
+ctrl_init_fail:
+	leapraid_overheat_cleanup(adapter);
+	destroy_workqueue(adapter->fw_evt_s.fw_evt_thread);
+evt_wq_fail:
+	spin_lock(&leapraid_adapter_lock);
+	list_del(&adapter->list);
+	spin_unlock(&leapraid_adapter_lock);
+	scsi_host_put(shost);
+	return rc;
+}
+
+void leapraid_cleanup_lists(struct leapraid_adapter *adapter)
+{
+	struct leapraid_raid_volume *raid_volume, *next_raid_volume;
+	struct leapraid_starget_priv *starget_priv_data;
+	struct leapraid_sas_port *leapraid_port, *next_port;
+	struct leapraid_card_port *port, *port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	list_for_each_entry_safe(raid_volume, next_raid_volume,
+				 &adapter->dev_topo.raid_volume_list, list) {
+		if (raid_volume->starget) {
+			starget_priv_data = raid_volume->starget->hostdata;
+			if (starget_priv_data)
+				starget_priv_data->deleted = 1;
+			scsi_remove_target(&raid_volume->starget->dev);
+		}
+		dev_info(&adapter->pdev->dev,
+			 "removing hdl=0x%04x, wwid=0x%016llx\n",
+			 raid_volume->hdl,
+			 (unsigned long long)raid_volume->wwid);
+		leapraid_raid_volume_remove(adapter, raid_volume);
+	}
+
+	list_for_each_entry_safe(leapraid_port, next_port,
+				 &adapter->dev_topo.card.sas_port_list,
+				 port_list) {
+		if (leapraid_port->remote_identify.device_type ==
+		    SAS_END_DEVICE)
+			leapraid_sas_dev_remove_by_sas_address(
+				adapter,
+				leapraid_port->remote_identify.sas_address,
+				leapraid_port->card_port);
+		else if (leapraid_port->remote_identify.device_type ==
+				SAS_EDGE_EXPANDER_DEVICE ||
+			 leapraid_port->remote_identify.device_type ==
+				SAS_FANOUT_EXPANDER_DEVICE)
+			leapraid_exp_rm(
+				adapter,
+				leapraid_port->remote_identify.sas_address,
+				leapraid_port->card_port);
+	}
+
+	list_for_each_entry_safe(port, port_next,
+				 &adapter->dev_topo.card_port_list, list) {
+		if (port->vphys_mask)
+			list_for_each_entry_safe(vphy, vphy_next,
+						 &port->vphys_list, list) {
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
+static void leapraid_remove(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "Unable to remove!\n");
+		return;
+	}
+
+	wait_event(adapter->scan_dev_desc.wait_driver_loading,
+		   !adapter->scan_dev_desc.driver_loading);
+	wait_event(adapter->scan_dev_desc.wait_driver_loading,
+		   !atomic_read(&adapter->overheat_desc.thermal_alert));
+
+	adapter->access_ctrl.host_removing = 1;
+
+	leapraid_wait_cmds_done(adapter);
+
+	leapraid_smart_polling_stop(adapter);
+
+	if (leapraid_pci_removed(adapter)) {
+		leapraid_mq_polling_pause(adapter);
+		leapraid_clean_active_scsi_cmds(adapter);
+	}
+	leapraid_clean_active_fw_evt(adapter);
+
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	wq = adapter->fw_evt_s.fw_evt_thread;
+	adapter->fw_evt_s.fw_evt_thread = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	sas_remove_host(shost);
+	leapraid_cleanup_lists(adapter);
+	leapraid_remove_ctrl(adapter);
+	spin_lock(&leapraid_adapter_lock);
+	list_del(&adapter->list);
+	spin_unlock(&leapraid_adapter_lock);
+	scsi_host_put(shost);
+}
+
+static void leapraid_shutdown(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "Unable to shutdown!\n");
+		return;
+	}
+
+	adapter->access_ctrl.host_removing = 1;
+	leapraid_wait_cmds_done(adapter);
+	leapraid_clean_active_fw_evt(adapter);
+	leapraid_overheat_cleanup(adapter);
+	leapraid_fw_log_stop(adapter);
+	spin_lock_irqsave(&adapter->fw_evt_s.fw_evt_lock, flags);
+	wq = adapter->fw_evt_s.fw_evt_thread;
+	adapter->fw_evt_s.fw_evt_thread = NULL;
+	spin_unlock_irqrestore(&adapter->fw_evt_s.fw_evt_lock, flags);
+	if (wq)
+		destroy_workqueue(wq);
+
+	leapraid_disable_controller(adapter);
+}
+
+static pci_ers_result_t leapraid_pci_error_detected(struct pci_dev *pdev,
+						    pci_channel_state_t state)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "Failed to error detected for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	dev_err(&pdev->dev, "%s: PCI error detected, state=%d\n",
+		adapter->adapter_attr.name, state);
+
+	switch (state) {
+	case pci_channel_io_normal:
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		adapter->access_ctrl.pcie_recovering = 1;
+		scsi_block_requests(adapter->shost);
+		leapraid_overheat_cleanup(adapter);
+		leapraid_smart_polling_stop(adapter);
+		leapraid_check_scheduled_fault_stop(adapter);
+		leapraid_fw_log_stop(adapter);
+		leapraid_disable_controller(adapter);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		adapter->access_ctrl.pcie_recovering = 1;
+		leapraid_overheat_cleanup(adapter);
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
+static pci_ers_result_t leapraid_pci_mmio_enabled(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			"Failed to enable mmio for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	dev_info(&pdev->dev, "%s: PCI error mmio enabled\n",
+		 adapter->adapter_attr.name);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t leapraid_pci_slot_reset(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	int rc;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			"Failed to slot reset for device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	dev_err(&pdev->dev, "%s PCI error slot reset\n",
+		adapter->adapter_attr.name);
+
+	adapter->pdev = pdev;
+	pci_restore_state(pdev);
+	if (leapraid_set_pcie_and_notification(adapter)) {
+		dev_err(&pdev->dev,
+			"%s: Failed to set PCIe state and notification\n",
+			__func__);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	adapter->access_ctrl.pcie_recovering = 0;
+	dev_info(&pdev->dev, "%s: Hard reset triggered by PCI slot reset\n",
+		 adapter->adapter_attr.name);
+	dev_info(&adapter->pdev->dev, "%s: %d: call hard_reset\n",
+		 __func__, __LINE__);
+	rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+	if (rc)
+		dev_err(&pdev->dev, "%s hard reset: failed\n",
+			adapter->adapter_attr.name);
+
+	return rc == 0 ? PCI_ERS_RESULT_RECOVERED :
+		 PCI_ERS_RESULT_DISCONNECT;
+}
+
+static void leapraid_pci_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev, "Failed to resume\n");
+		return;
+	}
+
+	dev_err(&pdev->dev, "PCI error resume!\n");
+
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
+static int leapraid_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	pci_power_t device_state;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			"Suspend failed, invalid host or adapter\n");
+		return -ENXIO;
+	}
+
+	leapraid_overheat_cleanup(adapter);
+	leapraid_smart_polling_stop(adapter);
+	leapraid_check_scheduled_fault_stop(adapter);
+	leapraid_fw_log_stop(adapter);
+	scsi_block_requests(shost);
+	device_state = pci_choose_state(pdev, state);
+
+	dev_info(&pdev->dev, "Entering PCI power state D%d, (slot=%s)\n",
+		 device_state, pci_name(pdev));
+
+	pci_save_state(pdev);
+	leapraid_disable_controller(adapter);
+	pci_set_power_state(pdev, device_state);
+	return 0;
+}
+
+static int leapraid_resume(struct pci_dev *pdev)
+{
+	struct leapraid_adapter *adapter = pdev_to_adapter(pdev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	pci_power_t device_state = pdev->current_state;
+	int rc;
+
+	if (!shost || !adapter) {
+		dev_err(&pdev->dev,
+			"Resume failed, invalid host or adapter\n");
+		return -ENXIO;
+	}
+
+	dev_info(&pdev->dev,
+		 "Resuming device %s, previous state D%d\n",
+		 pci_name(pdev), device_state);
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	adapter->pdev = pdev;
+	rc = leapraid_set_pcie_and_notification(adapter);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: Failed to set PCIe state and notification\n",
+			__func__);
+		return rc;
+	}
+
+	dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+		 __func__, __LINE__);
+	rc = leapraid_hard_reset_handler(adapter, PART_RESET);
+	if (rc) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Hard reset failed during resume, rc=%d\n",
+			__func__, rc);
+		return rc;
+	}
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
+	pr_info("%s initializing\n", LEAPRAID_DRIVER_NAME);
+
+	leapraid_transport_template =
+		sas_attach_transport(&leapraid_transport_functions);
+	if (!leapraid_transport_template) {
+		pr_err("%s: Failed to attach SAS transport\n",
+		       LEAPRAID_DRIVER_NAME);
+		return -ENODEV;
+	}
+
+	error = pci_register_driver(&leapraid_driver);
+	if (error) {
+		pr_err("%s: PCI driver registration failed: %d\n",
+		       LEAPRAID_DRIVER_NAME, error);
+		sas_release_transport(leapraid_transport_template);
+		return error;
+	}
+
+	error = leapraid_ctl_init();
+	if (error) {
+		pci_unregister_driver(&leapraid_driver);
+		sas_release_transport(leapraid_transport_template);
+		return error;
+	}
+
+	return 0;
+}
+
+static void __exit leapraid_exit(void)
+{
+	pr_info("%s exiting\n", LEAPRAID_DRIVER_NAME);
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
index 000000000000..f48218c71e47
--- /dev/null
+++ b/drivers/scsi/leapraid/leapraid_transport.c
@@ -0,0 +1,1387 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 LeapIO Tech Inc.
+ *
+ * LeapRAID storage and RAID controller driver.
+ */
+#include <scsi/scsi_host.h>
+
+#include "leapraid_func.h"
+
+static struct leapraid_topo_node *leapraid_transport_topo_node_by_sas_addr(
+		struct leapraid_adapter *adapter,
+		u64 sas_addr,
+		struct leapraid_card_port *card_port)
+{
+	if (adapter->dev_topo.card.sas_address == sas_addr)
+		return &adapter->dev_topo.card;
+
+	return leapraid_exp_find_by_sas_address(adapter, sas_addr, card_port);
+}
+
+static u8 leapraid_get_port_id_by_expander(struct leapraid_adapter *adapter,
+					   struct sas_rphy *rphy)
+{
+	struct leapraid_topo_node *topo_node_exp;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_for_each_entry(topo_node_exp, &adapter->dev_topo.exp_list, list) {
+		if (topo_node_exp->rphy == rphy) {
+			port_id = topo_node_exp->card_port->port_id;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	return port_id;
+}
+
+static u8 leapraid_get_port_id_by_end_dev(struct leapraid_adapter *adapter,
+					  struct sas_rphy *rphy)
+{
+	struct leapraid_sas_dev *sas_dev;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	spin_lock_irqsave(&adapter->dev_topo.sas_dev_lock, flags);
+	sas_dev = leapraid_hold_lock_get_sas_dev_by_addr_and_rphy(
+			adapter,
+			rphy->identify.sas_address,
+			rphy);
+	if (sas_dev) {
+		port_id = sas_dev->card_port->port_id;
+		leapraid_sdev_put(sas_dev);
+	}
+	spin_unlock_irqrestore(&adapter->dev_topo.sas_dev_lock, flags);
+
+	return port_id;
+}
+
+static u8 leapraid_transport_get_port_id_by_rphy(
+		struct leapraid_adapter *adapter,
+		struct sas_rphy *rphy)
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
+static enum sas_linkrate leapraid_transport_convert_phy_link_rate(u8 link_rate)
+{
+	unsigned int i;
+
+	#define SAS_RATE_12G SAS_LINK_RATE_12_0_GBPS
+
+	const struct linkrate_map {
+		u8 in;
+		enum sas_linkrate out;
+	} linkrate_table[] = {
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_1_5,
+			SAS_LINK_RATE_1_5_GBPS
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_3_0,
+			SAS_LINK_RATE_3_0_GBPS
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_6_0,
+			SAS_LINK_RATE_6_0_GBPS
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_12_0,
+			SAS_RATE_12G
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_PHY_DISABLED,
+			SAS_PHY_DISABLED
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED,
+			SAS_LINK_RATE_FAILED
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_PORT_SELECTOR,
+			SAS_SATA_PORT_SELECTOR
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_SMP_RESETTING,
+			SAS_LINK_RATE_UNKNOWN
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE,
+			SAS_LINK_RATE_UNKNOWN
+		},
+		{
+			LEAPRAID_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE,
+			SAS_LINK_RATE_UNKNOWN
+		},
+	};
+
+	for (i = 0; i < ARRAY_SIZE(linkrate_table); i++)
+		if (linkrate_table[i].in == link_rate)
+			return linkrate_table[i].out;
+
+	return SAS_LINK_RATE_UNKNOWN;
+}
+
+static void leapraid_set_identify_protocol_flags(u32 dev_info,
+						 struct sas_identify *identify)
+{
+	unsigned int i;
+
+	const struct protocol_mapping {
+		u32 mask;
+		u32 *target;
+		u32 protocol;
+	} mappings[] = {
+		{
+			LEAPRAID_DEVTYP_SSP_INIT,
+			&identify->initiator_port_protocols,
+			SAS_PROTOCOL_SSP
+		},
+		{
+			LEAPRAID_DEVTYP_STP_INIT,
+			&identify->initiator_port_protocols,
+			SAS_PROTOCOL_STP
+		},
+		{
+			LEAPRAID_DEVTYP_SMP_INIT,
+			&identify->initiator_port_protocols,
+			SAS_PROTOCOL_SMP
+		},
+		{
+			LEAPRAID_DEVTYP_SATA_HOST,
+			&identify->initiator_port_protocols,
+			SAS_PROTOCOL_SATA
+		},
+		{
+			LEAPRAID_DEVTYP_SSP_TGT,
+			&identify->target_port_protocols,
+			SAS_PROTOCOL_SSP
+		},
+		{
+			LEAPRAID_DEVTYP_STP_TGT,
+			&identify->target_port_protocols,
+			SAS_PROTOCOL_STP
+		},
+		{
+			LEAPRAID_DEVTYP_SMP_TGT,
+			&identify->target_port_protocols,
+			SAS_PROTOCOL_SMP
+		},
+		{
+			LEAPRAID_DEVTYP_SATA_DEV,
+			&identify->target_port_protocols,
+			SAS_PROTOCOL_SATA
+		},
+	};
+
+	for (i = 0; i < ARRAY_SIZE(mappings); i++)
+		if (dev_info & mappings[i].mask && mappings[i].target)
+			*mappings[i].target |= mappings[i].protocol;
+}
+
+static int leapraid_transport_set_identify(struct leapraid_adapter *adapter,
+					   u16 hdl,
+					   struct sas_identify *identify)
+{
+	union cfg_param_1 cfgp1 = {0};
+	union cfg_param_2 cfgp2 = {0};
+	struct leapraid_sas_dev_p0 sas_dev_pg0;
+	u32 dev_info;
+
+	if ((adapter->access_ctrl.shost_recovering &&
+	     !adapter->scan_dev_desc.driver_loading) ||
+	    adapter->access_ctrl.pcie_recovering) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed, shost_recovering=%d pcie_recovering=%d\n",
+			 __func__,
+			 adapter->access_ctrl.shost_recovering,
+			 adapter->access_ctrl.pcie_recovering);
+		return -EFAULT;
+	}
+
+	cfgp1.form = LEAPRAID_SAS_DEV_CFG_PGAD_HDL;
+	cfgp2.handle = hdl;
+	if (leapraid_op_config_page(adapter, &sas_dev_pg0, cfgp1,
+				    cfgp2, GET_SAS_DEVICE_PG0))
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
+	leapraid_set_identify_protocol_flags(dev_info, identify);
+
+	return 0;
+}
+
+static void leapraid_transport_exp_set_edev(struct leapraid_adapter *adapter,
+					    void *data_out,
+					    struct sas_expander_device *edev)
+{
+	struct leapraid_smp_passthrough_rep *smp_passthrough_rep;
+	struct leapraid_rep_manu_reply *rep_manu_reply;
+	u8 *component_id;
+
+	smp_passthrough_rep =
+		(void *)&adapter->driver_cmds.transport_cmd.reply;
+	if (le16_to_cpu(smp_passthrough_rep->resp_data_len) !=
+	    sizeof(struct leapraid_rep_manu_reply))
+		return;
+
+	rep_manu_reply = data_out + sizeof(struct leapraid_rep_manu_request);
+
+	memcpy(edev->vendor_id, rep_manu_reply->vendor_identification,
+	       SAS_EXPANDER_VENDOR_ID_LEN);
+	edev->vendor_id[SAS_EXPANDER_VENDOR_ID_LEN] = '\0';
+
+	memcpy(edev->product_id, rep_manu_reply->product_identification,
+	       SAS_EXPANDER_PRODUCT_ID_LEN);
+	edev->product_id[SAS_EXPANDER_PRODUCT_ID_LEN] = '\0';
+
+	memcpy(edev->product_rev, rep_manu_reply->product_revision_level,
+	       SAS_EXPANDER_PRODUCT_REV_LEN);
+	edev->product_rev[SAS_EXPANDER_PRODUCT_REV_LEN] = '\0';
+
+	edev->level = rep_manu_reply->sas_format & 1;
+	if (edev->level) {
+		memcpy(edev->component_vendor_id,
+		       rep_manu_reply->comp_vendor_identification,
+		       SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+		edev->component_vendor_id[
+			SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN] = '\0';
+
+		component_id = (u8 *)&rep_manu_reply->component_id;
+		edev->component_id = component_id[0] << 8 | component_id[1];
+		edev->component_revision_id =
+			rep_manu_reply->component_revision_level;
+	}
+}
+
+static int leapraid_transport_exp_report_manu(struct leapraid_adapter *adapter,
+					      u64 sas_address,
+					      struct sas_expander_device *edev,
+					      u8 port_id)
+{
+	struct leapraid_smp_passthrough_req *smp_passthrough_req;
+	struct leapraid_rep_manu_request *rep_manu_request;
+	dma_addr_t h2c_dma_addr;
+	dma_addr_t c2h_dma_addr;
+	bool issue_reset = false;
+	void *data_out = NULL;
+	u16 inter_taskid;
+	size_t c2h_size;
+	size_t h2c_size;
+	void *psge;
+	int rc;
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.pcie_recovering) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed, shost_recovering=%d pcie_recovering=%d\n",
+			 __func__,
+			 adapter->access_ctrl.shost_recovering,
+			 adapter->access_ctrl.pcie_recovering);
+		return -EFAULT;
+	}
+
+	mutex_lock(&adapter->driver_cmds.transport_cmd.mutex);
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_PENDING;
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					  __func__);
+	if (rc)
+		goto out_cleanup;
+
+	h2c_size = sizeof(struct leapraid_rep_manu_request);
+	c2h_size = sizeof(struct leapraid_rep_manu_reply);
+	data_out = dma_alloc_coherent(&adapter->pdev->dev,
+				      h2c_size + c2h_size,
+				      &h2c_dma_addr,
+				      GFP_ATOMIC);
+	if (!data_out) {
+		rc = -ENOMEM;
+		goto out_cleanup;
+	}
+
+	rep_manu_request = data_out;
+	rep_manu_request->smp_frame_type =
+		SMP_REPORT_MANUFACTURER_INFORMATION_FRAME_TYPE;
+	rep_manu_request->function = SMP_REPORT_MANUFACTURER_INFORMATION_FUNC;
+	rep_manu_request->allocated_response_length = 0;
+	rep_manu_request->request_length = 0;
+
+	inter_taskid = adapter->driver_cmds.transport_cmd.inter_taskid;
+	smp_passthrough_req = leapraid_get_task_desc(adapter, inter_taskid);
+	memset(smp_passthrough_req, 0,
+	       sizeof(struct leapraid_smp_passthrough_req));
+	smp_passthrough_req->func = LEAPRAID_FUNC_SMP_PASSTHROUGH;
+	smp_passthrough_req->physical_port = port_id;
+	smp_passthrough_req->sas_address = cpu_to_le64(sas_address);
+	smp_passthrough_req->req_data_len = cpu_to_le16(h2c_size);
+	psge = &smp_passthrough_req->sgl;
+	c2h_dma_addr = h2c_dma_addr + sizeof(struct leapraid_rep_manu_request);
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size,
+			       c2h_dma_addr, c2h_size);
+
+	init_completion(&adapter->driver_cmds.transport_cmd.done);
+	leapraid_fire_task(adapter, inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.transport_cmd.done,
+				    LEAPRAID_TRANSPORT_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.transport_cmd.status & LEAPRAID_CMD_DONE)) {
+		rc = -ETIMEDOUT;
+		dev_err(&adapter->pdev->dev,
+			"%s: SMP passthrough timeout, st=0x%x\n",
+			__func__, adapter->driver_cmds.transport_cmd.status);
+		leapraid_log_req_context(adapter, inter_taskid,
+					 smp_passthrough_req);
+		if (!(adapter->driver_cmds.transport_cmd.status &
+		      LEAPRAID_CMD_RESET))
+			issue_reset = true;
+
+		goto hard_reset;
+	}
+
+	if (adapter->driver_cmds.transport_cmd.status &
+	    LEAPRAID_CMD_REPLY_VALID)
+		leapraid_transport_exp_set_edev(adapter, data_out, edev);
+
+hard_reset:
+	if (issue_reset) {
+		dev_info(&adapter->pdev->dev, "%s:%d: call hard_reset\n",
+			 __func__, __LINE__);
+		rc = leapraid_hard_reset_handler(adapter, FULL_RESET);
+	}
+out_cleanup:
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_NOT_USED;
+	if (data_out)
+		dma_free_coherent(&adapter->pdev->dev, h2c_size + c2h_size,
+				  data_out, h2c_dma_addr);
+
+	mutex_unlock(&adapter->driver_cmds.transport_cmd.mutex);
+	return rc;
+}
+
+static void leapraid_transport_del_port(struct leapraid_adapter *adapter,
+					struct leapraid_sas_port *sas_port)
+{
+	dev_info(&sas_port->port->dev,
+		 "Remove port: SAS addr=0x%016llx\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address);
+	switch (sas_port->remote_identify.device_type) {
+	case SAS_END_DEVICE:
+		leapraid_sas_dev_remove_by_sas_address(
+			adapter,
+			sas_port->remote_identify.sas_address,
+			sas_port->card_port);
+		break;
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		leapraid_exp_rm(adapter, sas_port->remote_identify.sas_address,
+				sas_port->card_port);
+		break;
+	default:
+		break;
+	}
+}
+
+static void leapraid_transport_del_phy(struct leapraid_adapter *adapter,
+				       struct leapraid_sas_port *sas_port,
+				       struct leapraid_card_phy *card_phy)
+{
+	dev_info(&card_phy->phy->dev,
+		 "Remove PHY: SAS addr=0x%016llx, phy=%d\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address,
+		 card_phy->phy_id);
+	list_del(&card_phy->port_siblings);
+	sas_port->phys_num--;
+	sas_port_delete_phy(sas_port->port, card_phy->phy);
+	card_phy->phy_is_assigned = 0;
+}
+
+static void leapraid_transport_add_phy(struct leapraid_adapter *adapter,
+				       struct leapraid_sas_port *sas_port,
+				       struct leapraid_card_phy *card_phy)
+{
+	dev_info(&card_phy->phy->dev,
+		 "Add PHY: SAS addr=0x%016llx, phy=%d\n",
+		 (unsigned long long)sas_port->remote_identify.sas_address,
+		 card_phy->phy_id);
+	list_add_tail(&card_phy->port_siblings, &sas_port->phy_list);
+	sas_port->phys_num++;
+	sas_port_add_phy(sas_port->port, card_phy->phy);
+	card_phy->phy_is_assigned = 1;
+}
+
+void leapraid_transport_attach_phy_to_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node,
+		struct leapraid_card_phy *card_phy,
+		u64 sas_address,
+		struct leapraid_card_port *card_port)
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
+	list_for_each_entry(sas_port, &topo_node->sas_port_list, port_list) {
+		if (sas_port->remote_identify.sas_address != sas_address)
+			continue;
+
+		if (sas_port->card_port != card_port)
+			continue;
+
+		list_for_each_entry(card_phy_srch, &sas_port->phy_list,
+				    port_siblings) {
+			if (card_phy_srch == card_phy)
+				return;
+		}
+		leapraid_transport_add_phy(adapter, sas_port, card_phy);
+		return;
+	}
+}
+
+void leapraid_transport_detach_phy_to_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node,
+		struct leapraid_card_phy *target_card_phy)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+	struct leapraid_card_phy *cur_card_phy;
+
+	if (!target_card_phy->phy_is_assigned)
+		return;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+				 &topo_node->sas_port_list, port_list) {
+		list_for_each_entry(cur_card_phy, &sas_port->phy_list,
+				    port_siblings) {
+			if (cur_card_phy != target_card_phy)
+				continue;
+
+			if (sas_port->phys_num == 1 &&
+			    !adapter->access_ctrl.shost_recovering)
+				leapraid_transport_del_port(adapter, sas_port);
+			else
+				leapraid_transport_del_phy(adapter, sas_port,
+							   target_card_phy);
+			return;
+		}
+	}
+}
+
+static void leapraid_detach_phy_from_old_port(
+		struct leapraid_adapter *adapter,
+		struct leapraid_topo_node *topo_node,
+		u64 sas_address,
+		struct leapraid_card_port *card_port)
+{
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++) {
+		if (topo_node->card_phy[i].remote_identify.sas_address !=
+			sas_address ||
+		    topo_node->card_phy[i].card_port != card_port)
+			continue;
+		if (topo_node->card_phy[i].phy_is_assigned)
+			leapraid_transport_detach_phy_to_port(
+				adapter,
+				topo_node,
+				&topo_node->card_phy[i]);
+	}
+}
+
+static struct leapraid_sas_port *leapraid_prepare_sas_port(
+		struct leapraid_adapter *adapter,
+		u16 handle, u64 sas_address,
+		struct leapraid_card_port *card_port,
+		struct leapraid_topo_node **out_topo_node)
+{
+	struct leapraid_topo_node *topo_node;
+	struct leapraid_sas_port *sas_port;
+	unsigned long flags;
+
+	sas_port = kzalloc_obj(*sas_port);
+	if (!sas_port) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed alloc sas_port\n", __func__);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&sas_port->port_list);
+	INIT_LIST_HEAD(&sas_port->phy_list);
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node = leapraid_transport_topo_node_by_sas_addr(adapter,
+							     sas_address,
+							     card_port);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (!topo_node) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to locate parent for SAS 0x%016llx!\n",
+			__func__, sas_address);
+		goto out_cleanup;
+	}
+
+	if (leapraid_transport_set_identify(adapter, handle,
+					    &sas_port->remote_identify))
+		goto out_cleanup;
+
+	if (sas_port->remote_identify.device_type == SAS_PHY_UNUSED) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Failed, device type is SAS_PHY_UNUSED\n",
+			 __func__);
+		goto out_cleanup;
+	}
+
+	sas_port->card_port = card_port;
+	*out_topo_node = topo_node;
+
+	return sas_port;
+
+out_cleanup:
+	kfree(sas_port);
+	return NULL;
+}
+
+static int leapraid_bind_phys_and_vphy(struct leapraid_adapter *adapter,
+				       struct leapraid_sas_port *sas_port,
+				       struct leapraid_topo_node *topo_node,
+				       struct leapraid_card_port *card_port,
+				       struct leapraid_vphy **out_vphy)
+{
+	struct leapraid_vphy *vphy = NULL;
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++) {
+		if (topo_node->card_phy[i].remote_identify.sas_address !=
+			sas_port->remote_identify.sas_address ||
+		    topo_node->card_phy[i].card_port != card_port)
+			continue;
+
+		list_add_tail(&topo_node->card_phy[i].port_siblings,
+			      &sas_port->phy_list);
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
+				return LEAPRAID_OPERATION_FAILED;
+		}
+	}
+
+	*out_vphy = vphy;
+	return sas_port->phys_num ? 0 : LEAPRAID_OPERATION_FAILED;
+}
+
+static struct sas_rphy *leapraid_create_and_register_rphy(
+		struct leapraid_adapter *adapter,
+		struct leapraid_sas_port *sas_port,
+		struct leapraid_topo_node *topo_node,
+		struct leapraid_card_port *card_port,
+		struct leapraid_vphy *vphy)
+{
+	struct leapraid_sas_dev *sas_dev = NULL;
+	struct leapraid_card_phy *card_phy;
+	struct sas_port *port;
+	struct sas_rphy *rphy;
+
+	if (sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_dev = leapraid_get_sas_dev_by_addr(
+				adapter,
+				sas_port->remote_identify.sas_address,
+				card_port);
+		if (!sas_dev)
+			return NULL;
+		sas_dev->pend_sas_rphy_add = 1;
+	}
+
+	if (!topo_node->parent_dev) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: topo_node parent device is NULL\n",  __func__);
+		goto cleanup_sas_dev;
+	}
+
+	port = sas_port_alloc_num(topo_node->parent_dev);
+	if (!port) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to allocate SAS port\n", __func__);
+		goto cleanup_sas_dev;
+	}
+
+	if (sas_port_add(port)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to add SAS port\n", __func__);
+		goto out_delete_port;
+	}
+
+	list_for_each_entry(card_phy, &sas_port->phy_list, port_siblings) {
+		sas_port_add_phy(port, card_phy->phy);
+		card_phy->phy_is_assigned = 1;
+		card_phy->card_port = card_port;
+	}
+
+	if (sas_dev) {
+		rphy = sas_end_device_alloc(port);
+		sas_dev->rphy = rphy;
+
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num) {
+			if (!vphy)
+				card_port->sas_address = sas_dev->sas_addr;
+			else
+				vphy->sas_address = sas_dev->sas_addr;
+		}
+	} else {
+		rphy = sas_expander_alloc(
+				port,
+				sas_port->remote_identify.device_type);
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num)
+			card_port->sas_address =
+				sas_port->remote_identify.sas_address;
+	}
+
+	if (!rphy) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to allocate RPHY\n", __func__);
+		goto cleanup_card_phy;
+	}
+
+	rphy->identify = sas_port->remote_identify;
+
+	if (sas_rphy_add(rphy)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to add RPHY\n", __func__);
+		if (sas_dev)
+			sas_dev->rphy = NULL;
+
+		sas_rphy_free(rphy);
+		goto cleanup_card_phy;
+	}
+	sas_port->port = port;
+
+	if (sas_dev) {
+		sas_dev->pend_sas_rphy_add = 0;
+		leapraid_sdev_put(sas_dev);
+	}
+
+	return rphy;
+
+cleanup_card_phy:
+	if (topo_node->hdl <= adapter->dev_topo.card.phys_num) {
+		if (!vphy)
+			card_port->sas_address = 0;
+		else
+			vphy->sas_address = 0;
+	}
+
+	list_for_each_entry(card_phy, &sas_port->phy_list, port_siblings) {
+		card_phy->phy_is_assigned = 0;
+		card_phy->card_port = NULL;
+	}
+
+out_delete_port:
+	sas_port_delete(port);
+
+cleanup_sas_dev:
+	if (sas_dev) {
+		sas_dev->pend_sas_rphy_add = 0;
+		leapraid_sdev_put(sas_dev);
+	}
+	return NULL;
+}
+
+struct leapraid_sas_port *leapraid_transport_port_add(
+		struct leapraid_adapter *adapter,
+		u16 hdl, u64 sas_address,
+		struct leapraid_card_port *card_port)
+{
+	struct leapraid_card_phy *card_phy, *card_phy_next;
+	struct leapraid_topo_node *topo_node = NULL;
+	struct leapraid_sas_port *sas_port;
+	struct leapraid_vphy *vphy = NULL;
+	struct sas_rphy *rphy;
+	unsigned long flags;
+
+	if (!card_port) {
+		dev_warn(&adapter->pdev->dev,
+			 "%s: Invalid card_port\n", __func__);
+		return NULL;
+	}
+
+	sas_port = leapraid_prepare_sas_port(adapter, hdl, sas_address,
+					     card_port, &topo_node);
+	if (!sas_port)
+		return NULL;
+
+	leapraid_detach_phy_from_old_port(
+		adapter,
+		topo_node,
+		sas_port->remote_identify.sas_address,
+		card_port);
+
+	if (leapraid_bind_phys_and_vphy(adapter, sas_port, topo_node,
+					card_port, &vphy)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to bind phy to vphy\n", __func__);
+		goto out_fail;
+	}
+
+	rphy = leapraid_create_and_register_rphy(adapter, sas_port, topo_node,
+						 card_port, vphy);
+	if (!rphy) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed to create rphy\n", __func__);
+		goto out_fail;
+	}
+
+	dev_info(&rphy->dev,
+		 "%s: Added dev: hdl=0x%04x, SAS addr=0x%016llx\n",
+		 __func__, hdl,
+		 (unsigned long long)sas_port->remote_identify.sas_address);
+
+	sas_port->rphy = rphy;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	list_add_tail(&sas_port->port_list, &topo_node->sas_port_list);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (sas_port->remote_identify.device_type ==
+	    SAS_EDGE_EXPANDER_DEVICE ||
+	    sas_port->remote_identify.device_type ==
+	    SAS_FANOUT_EXPANDER_DEVICE)
+		leapraid_transport_exp_report_manu(
+			adapter,
+			sas_port->remote_identify.sas_address,
+			rphy_to_expander_device(rphy),
+			card_port->port_id);
+
+	return sas_port;
+
+out_fail:
+	list_for_each_entry_safe(card_phy, card_phy_next,
+				 &sas_port->phy_list, port_siblings) {
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num &&
+		    !card_phy->vphy)
+			card_port->phy_mask &= ~BIT(card_phy->phy_id);
+
+		list_del_init(&card_phy->port_siblings);
+	}
+
+	kfree(sas_port);
+	return NULL;
+}
+
+static struct leapraid_sas_port *leapraid_find_and_remove_sas_port(
+		struct leapraid_topo_node *topo_node,
+		u64 sas_address,
+		struct leapraid_card_port *remove_card_port,
+		bool *found)
+{
+	struct leapraid_sas_port *sas_port, *sas_port_next;
+
+	list_for_each_entry_safe(sas_port, sas_port_next,
+				 &topo_node->sas_port_list, port_list) {
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
+static void leapraid_cleanup_card_port_and_vphys(
+		struct leapraid_adapter *adapter,
+		u64 sas_address,
+		struct leapraid_card_port *remove_card_port)
+{
+	struct leapraid_card_port *card_port, *card_port_next;
+	struct leapraid_vphy *vphy, *vphy_next;
+
+	if (remove_card_port->vphys_mask) {
+		list_for_each_entry_safe(vphy, vphy_next,
+					 &remove_card_port->vphys_list, list) {
+			if (vphy->sas_address != sas_address)
+				continue;
+
+			dev_dbg(&adapter->pdev->dev,
+				"%s: Remove vphy=%p from port=%p port_id=%d\n",
+				__func__, vphy, remove_card_port,
+				remove_card_port->port_id);
+
+			remove_card_port->vphys_mask &= ~vphy->phy_mask;
+			list_del(&vphy->list);
+			kfree(vphy);
+		}
+
+		if (!remove_card_port->vphys_mask &&
+		    !remove_card_port->sas_address) {
+			dev_dbg(&adapter->pdev->dev,
+				"%s: Remove empty hba_port: %p, port_id=%d\n",
+				__func__,
+				remove_card_port,
+				remove_card_port->port_id);
+			list_del(&remove_card_port->list);
+			kfree(remove_card_port);
+			remove_card_port = NULL;
+		}
+	}
+
+	list_for_each_entry_safe(card_port, card_port_next,
+				 &adapter->dev_topo.card_port_list, list) {
+		if (card_port != remove_card_port)
+			continue;
+
+		if (card_port->sas_address != sas_address)
+			continue;
+
+		if (!remove_card_port->vphys_mask) {
+			dev_dbg(&adapter->pdev->dev,
+				"%s: Remove hba_port: %p, port_id=%d\n",
+				__func__, card_port, card_port->port_id);
+			list_del(&card_port->list);
+			kfree(card_port);
+		} else {
+			dev_dbg(&adapter->pdev->dev,
+				"Clear sas_address of port=%p, port_id=%d\n",
+				card_port, card_port->port_id);
+			remove_card_port->sas_address = 0;
+		}
+		break;
+	}
+}
+
+static void leapraid_clear_topo_node_phys(struct leapraid_topo_node *topo_node,
+					  u64 sas_address)
+{
+	int i;
+
+	for (i = 0; i < topo_node->phys_num; i++)
+		if (topo_node->card_phy[i].remote_identify.sas_address ==
+		    sas_address) {
+			memset(&topo_node->card_phy[i].remote_identify, 0,
+			       sizeof(struct sas_identify));
+			topo_node->card_phy[i].vphy = 0;
+		}
+}
+
+void leapraid_transport_port_remove(
+		struct leapraid_adapter *adapter,
+		u64 sas_address,
+		u64 sas_address_parent,
+		struct leapraid_card_port *remove_card_port)
+{
+	struct leapraid_card_phy *card_phy, *card_phy_next;
+	struct leapraid_sas_port *sas_port;
+	struct leapraid_topo_node *topo_node;
+	unsigned long flags;
+	bool found = false;
+
+	if (!remove_card_port)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+
+	topo_node = leapraid_transport_topo_node_by_sas_addr(adapter,
+							     sas_address_parent,
+							     remove_card_port);
+	if (!topo_node) {
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
+		return;
+	}
+
+	sas_port = leapraid_find_and_remove_sas_port(topo_node, sas_address,
+						     remove_card_port, &found);
+
+	if (!found) {
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
+		return;
+	}
+
+	if (topo_node->hdl <= adapter->dev_topo.card.phys_num &&
+	    adapter->adapter_attr.enable_mp)
+		leapraid_cleanup_card_port_and_vphys(adapter, sas_address,
+						     remove_card_port);
+
+	leapraid_clear_topo_node_phys(topo_node, sas_address);
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	list_for_each_entry_safe(card_phy, card_phy_next,
+				 &sas_port->phy_list, port_siblings) {
+		card_phy->phy_is_assigned = 0;
+		if (!adapter->access_ctrl.host_removing)
+			sas_port_delete_phy(sas_port->port, card_phy->phy);
+
+		list_del(&card_phy->port_siblings);
+	}
+
+	if (!adapter->access_ctrl.host_removing)
+		sas_port_delete(sas_port->port);
+
+	dev_dbg(&adapter->pdev->dev,
+		"%s: Removed sas_port for SAS addr=0x%016llx\n",
+		__func__, (unsigned long long)sas_address);
+
+	kfree(sas_port);
+}
+
+static void leapraid_init_sas_or_exp_phy(struct leapraid_adapter *adapter,
+					 struct leapraid_card_phy *card_phy,
+					 struct sas_phy *phy,
+					 struct leapraid_sas_phy_p0 *phy_pg0,
+					 struct leapraid_exp_p1 *exp_pg1)
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
+		leapraid_transport_convert_phy_link_rate(
+			phy_pg0->neg_link_rate &
+			LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->neg_link_rate &
+			LEAPRAID_SAS_NEG_LINK_RATE_MASK_PHYSICAL);
+	phy->minimum_linkrate_hw = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->hw_link_rate &
+			LEAPRAID_SAS_HWRATE_MIN_RATE_MASK) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->hw_link_rate &
+			LEAPRAID_SAS_HWRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate_hw = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->hw_link_rate >>
+			 LEAPRAID_SAS_NEG_LINK_RATE_SHIFT) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->hw_link_rate >>
+			 LEAPRAID_SAS_NEG_LINK_RATE_SHIFT);
+	phy->minimum_linkrate = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->p_link_rate &
+			LEAPRAID_SAS_PRATE_MIN_RATE_MASK) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->p_link_rate &
+			LEAPRAID_SAS_PRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate = phy_pg0 ?
+		 leapraid_transport_convert_phy_link_rate(
+			phy_pg0->p_link_rate >>
+			 LEAPRAID_SAS_NEG_LINK_RATE_SHIFT) :
+		 leapraid_transport_convert_phy_link_rate(
+			exp_pg1->p_link_rate >>
+			 LEAPRAID_SAS_NEG_LINK_RATE_SHIFT);
+	phy->hostdata = card_phy->card_port;
+}
+
+void leapraid_transport_add_card_phy(struct leapraid_adapter *adapter,
+				     struct leapraid_card_phy *card_phy,
+				     struct leapraid_sas_phy_p0 *phy_pg0,
+				     struct device *parent_dev)
+{
+	struct sas_phy *phy;
+	int ret;
+
+	INIT_LIST_HEAD(&card_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, card_phy->phy_id);
+	if (!phy) {
+		dev_err(&adapter->pdev->dev,
+			"%s: sas_phy_alloc failed!\n", __func__);
+		return;
+	}
+
+	if (leapraid_transport_set_identify(adapter, card_phy->hdl,
+					    &card_phy->identify)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Set PHY handle identify failed!\n", __func__);
+		sas_phy_free(phy);
+		return;
+	}
+
+	card_phy->attached_hdl = le16_to_cpu(phy_pg0->attached_dev_hdl);
+	if (card_phy->attached_hdl) {
+		ret = leapraid_transport_set_identify(
+				adapter,
+				card_phy->attached_hdl,
+				&card_phy->remote_identify);
+		if (ret) {
+			dev_err(&adapter->pdev->dev,
+				"%s: Set PHY attached hdl identify failed!\n",
+				__func__);
+			sas_phy_free(phy);
+			return;
+		}
+	}
+
+	leapraid_init_sas_or_exp_phy(adapter, card_phy, phy, phy_pg0, NULL);
+
+	if (sas_phy_add(phy)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: SAS PHY add failed!\n", __func__);
+		sas_phy_free(phy);
+		return;
+	}
+
+	card_phy->phy = phy;
+}
+
+int leapraid_transport_add_exp_phy(struct leapraid_adapter *adapter,
+				   struct leapraid_card_phy *card_phy,
+				   struct leapraid_exp_p1 *exp_pg1,
+				   struct device *parent_dev)
+{
+	struct sas_phy *phy;
+	int ret;
+
+	INIT_LIST_HEAD(&card_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, card_phy->phy_id);
+	if (!phy) {
+		dev_err(&adapter->pdev->dev,
+			"%s: sas_phy_alloc failed!\n", __func__);
+		return -EFAULT;
+	}
+
+	if (leapraid_transport_set_identify(adapter, card_phy->hdl,
+					    &card_phy->identify)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Set PHY hdl identify failed!\n", __func__);
+		sas_phy_free(phy);
+		return -EFAULT;
+	}
+
+	card_phy->attached_hdl = le16_to_cpu(exp_pg1->attached_dev_hdl);
+	if (card_phy->attached_hdl) {
+		ret = leapraid_transport_set_identify(
+				adapter,
+				card_phy->attached_hdl,
+				&card_phy->remote_identify);
+		if (ret)
+			dev_warn(&adapter->pdev->dev,
+				 "%s: Set PHY attached hdl identify failed!\n",
+				 __func__);
+	}
+
+	leapraid_init_sas_or_exp_phy(adapter, card_phy, phy, NULL, exp_pg1);
+
+	if (sas_phy_add(phy)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: SAS PHY add failed!\n", __func__);
+		sas_phy_free(phy);
+		return -EFAULT;
+	}
+
+	card_phy->phy = phy;
+	return 0;
+}
+
+void leapraid_transport_update_links(
+		struct leapraid_adapter *adapter,
+		u64 sas_address, u16 hdl, u8 phy_index,
+		u8 link_rate, struct leapraid_card_port *target_card_port)
+{
+	struct leapraid_topo_node *topo_node;
+	struct leapraid_card_phy *card_phy;
+	struct leapraid_card_port *card_port;
+	unsigned long flags;
+
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.pcie_recovering)
+		return;
+
+	spin_lock_irqsave(&adapter->dev_topo.topo_node_lock, flags);
+	topo_node = leapraid_transport_topo_node_by_sas_addr(adapter,
+							     sas_address,
+							     target_card_port);
+	if (!topo_node) {
+		spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock,
+				       flags);
+		return;
+	}
+
+	card_phy = &topo_node->card_phy[phy_index];
+	card_phy->attached_hdl = hdl;
+	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
+
+	if (hdl && link_rate >= LEAPRAID_SAS_NEG_LINK_RATE_1_5) {
+		leapraid_transport_set_identify(adapter, hdl,
+						&card_phy->remote_identify);
+		if (topo_node->hdl <= adapter->dev_topo.card.phys_num &&
+		    adapter->adapter_attr.enable_mp) {
+			list_for_each_entry(card_port,
+					    &adapter->dev_topo.card_port_list,
+					    list) {
+				if (card_port->sas_address == sas_address &&
+				    card_port == target_card_port)
+					card_port->phy_mask |=
+						BIT(card_phy->phy_id);
+			}
+		}
+		leapraid_transport_attach_phy_to_port(
+			adapter,
+			topo_node,
+			card_phy,
+			card_phy->remote_identify.sas_address,
+			target_card_port);
+	} else {
+		memset(&card_phy->remote_identify, 0,
+		       sizeof(struct sas_identify));
+	}
+
+	if (card_phy->phy)
+		card_phy->phy->negotiated_linkrate =
+			leapraid_transport_convert_phy_link_rate(link_rate);
+}
+
+static int leapraid_dma_map_buffer(struct device *dev, struct bsg_buffer *buf,
+				   dma_addr_t *dma_addr,
+				   size_t *dma_len, void **p)
+{
+	if (buf->sg_cnt > 1) {
+		*p = dma_alloc_coherent(dev, buf->payload_len, dma_addr,
+					GFP_KERNEL);
+		if (!*p)
+			return -ENOMEM;
+
+		*dma_len = buf->payload_len;
+	} else {
+		if (!dma_map_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL)) {
+			dev_err(dev,
+				"%s: Failed to map sg buffer for dma\n",
+				__func__);
+			return -ENOMEM;
+		}
+
+		*dma_addr = sg_dma_address(buf->sg_list);
+		*dma_len = sg_dma_len(buf->sg_list);
+		*p = NULL;
+	}
+	return 0;
+}
+
+static void leapraid_dma_unmap_buffer(struct device *dev,
+				      struct bsg_buffer *buf,
+				      dma_addr_t dma_addr,
+				      void *p)
+{
+	if (p)
+		dma_free_coherent(dev, buf->payload_len, p, dma_addr);
+	else
+		dma_unmap_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL);
+}
+
+static void leapraid_build_smp_task(struct leapraid_adapter *adapter,
+				    struct sas_rphy *rphy,
+				    dma_addr_t h2c_dma_addr, size_t h2c_size,
+				    dma_addr_t c2h_dma_addr, size_t c2h_size)
+{
+	struct leapraid_smp_passthrough_req *smp_passthrough_req;
+	u16 inter_taskid;
+	void *psge;
+
+	inter_taskid = adapter->driver_cmds.transport_cmd.inter_taskid;
+	smp_passthrough_req = leapraid_get_task_desc(adapter, inter_taskid);
+	memset(smp_passthrough_req, 0, sizeof(*smp_passthrough_req));
+
+	smp_passthrough_req->func = LEAPRAID_FUNC_SMP_PASSTHROUGH;
+	smp_passthrough_req->physical_port =
+		leapraid_transport_get_port_id_by_rphy(adapter, rphy);
+	smp_passthrough_req->sas_address = (rphy) ?
+		cpu_to_le64(rphy->identify.sas_address) :
+		cpu_to_le64(adapter->dev_topo.card.sas_address);
+	smp_passthrough_req->req_data_len =
+		cpu_to_le16(h2c_size - LEAPRAID_SMP_FRAME_HEADER_SIZE);
+	psge = &smp_passthrough_req->sgl;
+	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
+			       h2c_size - LEAPRAID_SMP_FRAME_HEADER_SIZE,
+			       c2h_dma_addr,
+			       c2h_size - LEAPRAID_SMP_FRAME_HEADER_SIZE);
+}
+
+static int leapraid_send_smp_req(struct leapraid_adapter *adapter)
+{
+	const struct leapraid_smp_passthrough_req *smp_passthrough_req;
+	u16 inter_taskid;
+
+	dev_dbg(&adapter->pdev->dev,
+		"%s: Sending smp request\n", __func__);
+	inter_taskid = adapter->driver_cmds.transport_cmd.inter_taskid;
+	smp_passthrough_req = leapraid_get_task_desc(adapter, inter_taskid);
+	init_completion(&adapter->driver_cmds.transport_cmd.done);
+	leapraid_fire_task(adapter, inter_taskid);
+	wait_for_completion_timeout(&adapter->driver_cmds.transport_cmd.done,
+				    LEAPRAID_TRANSPORT_CMD_TIMEOUT * HZ);
+	if (!(adapter->driver_cmds.transport_cmd.status & LEAPRAID_CMD_DONE)) {
+		dev_err(&adapter->pdev->dev, "%s: timeout, st=0x%x\n",
+			__func__, adapter->driver_cmds.transport_cmd.status);
+		leapraid_log_req_context(adapter, inter_taskid,
+					 smp_passthrough_req);
+		if (!(adapter->driver_cmds.transport_cmd.status &
+		      LEAPRAID_CMD_RESET)) {
+			dev_dbg(&adapter->pdev->dev,
+				"%s:%d: call hard_reset\n",
+				__func__, __LINE__);
+			leapraid_hard_reset_handler(adapter, FULL_RESET);
+			return -ETIMEDOUT;
+		}
+	}
+
+	dev_dbg(&adapter->pdev->dev, "%s: SMP request complete\n", __func__);
+	if (!(adapter->driver_cmds.transport_cmd.status &
+	      LEAPRAID_CMD_REPLY_VALID)) {
+		dev_err(&adapter->pdev->dev,
+			"%s: SMP request no reply\n", __func__);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static void leapraid_handle_smp_rep(struct leapraid_adapter *adapter,
+				    struct bsg_job *job, void *addr_in,
+				    unsigned int *reslen)
+{
+	struct leapraid_smp_passthrough_rep *smp_passthrough_rep;
+
+	smp_passthrough_rep =
+		(void *)&adapter->driver_cmds.transport_cmd.reply;
+
+	dev_dbg(&adapter->pdev->dev, "%s: Response data len=%d\n",
+		__func__, le16_to_cpu(smp_passthrough_rep->resp_data_len));
+
+	memcpy(job->reply, smp_passthrough_rep, sizeof(*smp_passthrough_rep));
+	job->reply_len = sizeof(*smp_passthrough_rep);
+	*reslen = le16_to_cpu(smp_passthrough_rep->resp_data_len);
+
+	if (addr_in)
+		sg_copy_from_buffer(job->reply_payload.sg_list,
+				    job->reply_payload.sg_cnt, addr_in,
+				    job->reply_payload.payload_len);
+}
+
+static void leapraid_transport_smp_handler(struct bsg_job *job,
+					   struct Scsi_Host *shost,
+					   struct sas_rphy *rphy)
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
+	if (adapter->access_ctrl.shost_recovering ||
+	    adapter->access_ctrl.pcie_recovering) {
+		dev_err(&adapter->pdev->dev,
+			"%s: Failed, shost_recovering=%d pcie_recovering=%d\n",
+			__func__,
+			adapter->access_ctrl.shost_recovering,
+			adapter->access_ctrl.pcie_recovering);
+		rc = -EFAULT;
+		goto exit_bsg_job;
+	}
+
+	rc = mutex_lock_interruptible(&adapter->driver_cmds
+				      .transport_cmd.mutex);
+	if (rc)
+		goto exit_bsg_job;
+
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_PENDING;
+	rc = leapraid_dma_map_buffer(&adapter->pdev->dev,
+				     &job->request_payload,
+				     &h2c_dma_addr, &h2c_size, &addr_out);
+	if (rc)
+		goto release_lock;
+
+	if (addr_out)
+		sg_copy_to_buffer(job->request_payload.sg_list,
+				  job->request_payload.sg_cnt, addr_out,
+				  job->request_payload.payload_len);
+
+	rc = leapraid_dma_map_buffer(&adapter->pdev->dev, &job->reply_payload,
+				     &c2h_dma_addr, &c2h_size, &addr_in);
+	if (rc)
+		goto free_req_buf;
+
+	rc = leapraid_check_adapter_is_op(adapter, LEAPRAID_DB_WAIT_OP_SHORT,
+					  __func__);
+	if (rc)
+		goto free_rep_buf;
+
+	leapraid_build_smp_task(adapter, rphy, h2c_dma_addr,
+				h2c_size, c2h_dma_addr, c2h_size);
+
+	rc = leapraid_send_smp_req(adapter);
+	if (rc)
+		goto free_rep_buf;
+
+	leapraid_handle_smp_rep(adapter, job, addr_in, &reslen);
+
+free_rep_buf:
+	leapraid_dma_unmap_buffer(&adapter->pdev->dev, &job->reply_payload,
+				  c2h_dma_addr, addr_in);
+free_req_buf:
+	leapraid_dma_unmap_buffer(&adapter->pdev->dev, &job->request_payload,
+				  h2c_dma_addr, addr_out);
+release_lock:
+	adapter->driver_cmds.transport_cmd.status = LEAPRAID_CMD_NOT_USED;
+	mutex_unlock(&adapter->driver_cmds.transport_cmd.mutex);
+exit_bsg_job:
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

