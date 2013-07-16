From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH v2 00/10] [RFC] SCSI: esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver
Date: Tue, 16 Jul 2013 09:46:52 -0400
Message-ID: <1373982422-3783-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:44527 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754423Ab3GPNr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jul 2013 09:47:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jseba@attotech.com, jbottomley@parallels.com, Bradley Grove <bgrove@attotech.com>


This is a new driver for ATTO Technology's ExpressSAS series of hardware RAID 
adapters.  It supports the following adapters:

    - ExpressSAS R60F
    - ExpressSAS R680
    - ExpressSAS R608
    - ExpressSAS R644

This patch is split into ten parts, all of which need to be applied to build 
the driver.

Changes since V1:

- We now use the kernel's list structs and alignment macros rather than our own 
implementations
- Fix to PCIe address size declaration when compiling on 32-bit architectures
- Use memcpy() instead opf memmove() where appropriate
- Fixes for big-endian architectures
- Removed unneeded MSI configuration code
- Simplified memory allocation during init
- Code formatting cleanup

Bradley Grove (10):
  [RFC] SCSI: esas2r: Add main header file
  [RFC] SCSI: esas2r: Add main file
  [RFC] SCSI: esas2r: Add initialization functions
  [RFC] SCSI: esas2r: Add device discovery and logging functions
  [RFC] SCSI: esas2r: Add interrupt and IO functions
  [RFC] SCSI: esas2r: Add flash and target database functions
  [RFC] SCSI: esas2r: Add IOCTL header file
  [RFC] SCSI: esas2r: Add IOCTL functions
  [RFC] SCSI: esas2r: Add ATTO VDA Firmware API headers and functions. 
    This API is used to control and manage the RAID adapter.
  [RFC] SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS files

 MAINTAINERS                         |    7 +
 drivers/scsi/Kconfig                |    1 +
 drivers/scsi/Makefile               |    1 +
 drivers/scsi/esas2r/Kconfig         |    6 +
 drivers/scsi/esas2r/Makefile        |    5 +
 drivers/scsi/esas2r/atioctl.h       | 1254 ++++++++++++++++++++
 drivers/scsi/esas2r/atvda.h         | 1320 +++++++++++++++++++++
 drivers/scsi/esas2r/esas2r.h        | 1442 +++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_disc.c   | 1190 +++++++++++++++++++
 drivers/scsi/esas2r/esas2r_flash.c  | 1516 ++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_init.c   | 1775 ++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_int.c    |  940 +++++++++++++++
 drivers/scsi/esas2r/esas2r_io.c     |  883 ++++++++++++++
 drivers/scsi/esas2r/esas2r_ioctl.c  | 2108 ++++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_log.c    |  255 ++++
 drivers/scsi/esas2r/esas2r_log.h    |  118 ++
 drivers/scsi/esas2r/esas2r_main.c   | 2169 +++++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_targdb.c |  306 +++++
 drivers/scsi/esas2r/esas2r_vda.c    |  523 +++++++++
 19 files changed, 15819 insertions(+)
 create mode 100644 drivers/scsi/esas2r/Kconfig
 create mode 100644 drivers/scsi/esas2r/Makefile
 create mode 100644 drivers/scsi/esas2r/atioctl.h
 create mode 100644 drivers/scsi/esas2r/atvda.h
 create mode 100644 drivers/scsi/esas2r/esas2r.h
 create mode 100644 drivers/scsi/esas2r/esas2r_disc.c
 create mode 100644 drivers/scsi/esas2r/esas2r_flash.c
 create mode 100644 drivers/scsi/esas2r/esas2r_init.c
 create mode 100644 drivers/scsi/esas2r/esas2r_int.c
 create mode 100644 drivers/scsi/esas2r/esas2r_io.c
 create mode 100644 drivers/scsi/esas2r/esas2r_ioctl.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.h
 create mode 100644 drivers/scsi/esas2r/esas2r_main.c
 create mode 100644 drivers/scsi/esas2r/esas2r_targdb.c
 create mode 100644 drivers/scsi/esas2r/esas2r_vda.c

-- 
1.8.1.4

