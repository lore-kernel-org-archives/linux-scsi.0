From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH RFC 0/2] IBM CXL Flash Adapter
Date: Sun, 26 Apr 2015 23:50:03 -0500
Message-ID: <1430110203-13229-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56522 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbD0Euh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2015 00:50:37 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 27 Apr 2015 00:50:36 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7E7D838C8051
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 00:50:33 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3R4oX2n56230080
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 04:50:33 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3R4oVXi007944
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 00:50:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: mikey@neuling.org, imunsie@au1.ibm.com

This patch set adds support for the IBM CXL flash (cxlflash) adapter. The
device is presented to the system as a SCSI adapter and may be accessed
and used via the normal filesystem paths. Also included is support for
a special mode that allows direct access from userspace.

The IBM Power processor architecture provides support for CAPI (Coherent
Accelerator Power Interface), which is available to certain PCIe slots
on Power 8 systems. CAPI can be thought of as a special tunneling
protocol through PCIe that allow PCIe adapters to look like special
purpose co-processors which can read or write an application's memory
and generate page faults. As a result, the host interface to an adapter
running in CAPI mode does not require data buffers to be mapped to the
device's memory (IOMMU bypass) nor does it require memory to be pinned.

Application specific accelerators are constructed by burning logic
to either an FPGA or ASIC that accelerates a certain function in
hardware. This logic is referred to as a an Accelerator Function Unit
or AFU. AFUs and their associated software are designed to leverage the
benefits that CAPI provides to reduce the burden on CPUs and achieve
higher performance. Examples of AFUs include compression, encryption,
sorting, etc.

The cxlflash adapter contains an AFU that enhances the performance of
accessing an external flash storage device by allowing userspace
applications to establish a 'superpipe' through which they may directly
access the storage, bypassing the traditional storage stack and reducing
pathlength per-I/O by more than an order of magnitude. The AFU also supports
a translation function that allows users to segment a physical device
into 'n' virtual devices [by programmatic means] and refer to these
segments as if they were a true physical device. This function enables
a more efficient use of a physical device and provides for a secure
multi-tenancy environment.

At a high-level, the cxlflash adapter looks and behaves very much like
a SCSI HBA. Like other SCSI adapters it understands SCSI CDBs and LUN
discovery. It also provides health monitoring, error recovery, and link
event reporting. It is for these reasons that we have decided to situate
support for the cxlflash adapter as a low level SCSI device driver.

At a lower level, the cxlflash adapter requires some additional items not
found in a traditional SCSI HBA driver. These include the following:

 - A programmatic API (implemented as ioctls) that user applications
 interact with when they desire to take advantage of the superpipe access
 from userspace. These ioctls allow the user to gain access to the CAPI
 resources (ie: interrupts, MMIO space, etc.) that are required to use
 the superpipe. Additionally, they allow applications to use the AFUs
 virtual partitioning function. Note that while the ioctls are new, under
 the covers they make use of existing functionality found in the cxl
 driver (drivers/misc/cxl).

 - A block allocation table (implemented as a bitmap) per physical
 device attached to the cxlflash adapter that is operating in the virtual
 partitioned mode. This table manages the segmentation of the physical
 device and is used to derive the entries found in the LUN mapping table.

 - A LUN mapping table that is shared with the AFU and used by the AFU
 to associate the resource handles referring to a specific virtual device
 with blocks on the physical device.

 - The ability to send a limited set of SCSI commands directly to the
 adapter to determine capacity and identification data as well as wipe
 blocks that are no longer in use when a virtual device is released. This
 set of commands includes READ_CAPACITY, INQUIRY, and WRITE_SAME.

Accompanying this adapter driver but not included here is a userspace
library (known as the block library) that will hide the interaction
between userspace and the cxlflash driver. Most (if not all) users will
chose to use this library when developing superpipe-aware applications.

The block library can be found on Github:

    https://github.com/mikehollinger/ibmcapikv

More technical details can be found within Documentation/powerpc/cxlflash.txt 

The following patches are bisectable and are dependent on support that has
not yet been merged in with the mainline.

This code may be found on Github:

    https://github.com/mikey/linux/tree/cxl/kernelapi

The forked (from cxl-kernelapi) cxlflash source may also be found on Github:

    https://github.com/mikehollinger/linux/tree/cflash/dev

Patch 1 contains support for only filesystem access.

Patch 2 adds support for userspace applications that wish to communicate
using the superpipe in lieu of filesystem access.

Any thoughts on our approach for supporing this adapter/function?

Matthew R. Ochs (2):
  cxlflash: Base support for IBM CXL Flash Adapter
  cxlflash: Support for superpipe I/O API

 Documentation/powerpc/cxlflash.txt |  275 +++++
 drivers/scsi/Kconfig               |    1 +
 drivers/scsi/Makefile              |    1 +
 drivers/scsi/cxlflash/Kconfig      |   11 +
 drivers/scsi/cxlflash/Makefile     |    4 +
 drivers/scsi/cxlflash/common.h     |  287 +++++
 drivers/scsi/cxlflash/main.c       | 2082 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h       |  125 +++
 drivers/scsi/cxlflash/sislite.h    |  407 +++++++
 drivers/scsi/cxlflash/superpipe.c  | 1673 +++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h  |   67 ++
 include/uapi/scsi/Kbuild           |    1 +
 include/uapi/scsi/cxlflash_ioctl.h |  133 +++
 13 files changed, 5067 insertions(+)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

-- 
2.1.0

