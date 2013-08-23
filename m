From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH v4 00/10] SCSI: esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver
Date: Fri, 23 Aug 2013 10:35:44 -0400
Message-ID: <1377268554-25898-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:40939 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754001Ab3HWOgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2013 10:36:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>


This is a new driver for ATTO Technology's ExpressSAS series of hardware RAID 
adapters.  It supports the following adapters:

    - ExpressSAS R60F
    - ExpressSAS R680
    - ExpressSAS R608
    - ExpressSAS R644

This patch is split into ten parts, all of which need to be applied to build 
the driver.

Changes Since V3:
- Addressed some warnings reported by checkpatch script, mostly whitespace

Changes since V2:

- Fix spurious ioctl error logging and memory corruption occuring with
non-IO VDA requests
- Use kernel's schedule_timeout_interruptable() rather than our own own 
stall function
- Removed a UDP socket based interface used by our closed source configuration 
tool

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
  SCSI: esas2r: Add main header file
  SCSI: esas2r: Add main file
  SCSI: esas2r: Add initialization functions
  SCSI: esas2r: Add device discovery and logging functions
  SCSI: esas2r: Add interrupt and IO functions
  SCSI: esas2r: Add flash and target database functions
  SCSI: esas2r: Add IOCTL header file
  SCSI: esas2r: Add IOCTL functions
  SCSI: esas2r: Add ATTO VDA Firmware API headers and functions.  This
    API is used to control and manage the RAID adapter.
  SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS files

 MAINTAINERS                         |    7 +
 drivers/scsi/Kconfig                |    1 +
 drivers/scsi/Makefile               |    1 +
 drivers/scsi/esas2r/Kconfig         |    6 +
 drivers/scsi/esas2r/Makefile        |    5 +
 drivers/scsi/esas2r/atioctl.h       | 1254 +++++++++++++++++++++
 drivers/scsi/esas2r/atvda.h         | 1320 ++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r.h        | 1441 ++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_disc.c   | 1190 ++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_flash.c  | 1514 +++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_init.c   | 1773 +++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_int.c    |  941 ++++++++++++++++
 drivers/scsi/esas2r/esas2r_io.c     |  883 +++++++++++++++
 drivers/scsi/esas2r/esas2r_ioctl.c  | 2110 +++++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_log.c    |  255 +++++
 drivers/scsi/esas2r/esas2r_log.h    |  118 ++
 drivers/scsi/esas2r/esas2r_main.c   | 2032 +++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_targdb.c |  306 +++++
 drivers/scsi/esas2r/esas2r_vda.c    |  523 +++++++++
 19 files changed, 15680 insertions(+)
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

