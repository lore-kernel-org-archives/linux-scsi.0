From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 0/2] IBM CXL Flash Superpipe
Date: Fri, 19 Jun 2015 17:37:38 -0500
Message-ID: <1434753458-6179-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:58722 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbFSWje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 18:39:34 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 19 Jun 2015 16:39:33 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5D8966E803F
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 18:31:17 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5JMdUI847448306
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 22:39:30 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5JMdTdv011323
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 18:39:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

This patch set is intended for the 4.3 release and adds support for the
superpipe features provided by the IBM CXL Flash adapter. This function
was originally presented in an RFC patch set in late April. To ease the
digestion of these enhancements, we have further split it across the two
patches in this set.

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
hardware. This logic is referred to as an Accelerator Function Unit
or AFU. AFUs and their associated software are designed to leverage the
benefits that CAPI provides to reduce the burden on CPUs and achieve
higher performance. Examples of AFUs include compression, encryption,
sorting, etc.

The cxlflash adapter contains an AFU that enhances the performance of
accessing an external flash storage device by allowing user space
applications to establish a 'superpipe' through which they may directly
access the storage, bypassing the traditional storage stack and reducing
path length per-I/O by more than an order of magnitude. The AFU also
supports a translation function that allows users to segment a physical
device into 'n' virtual devices [by programmatic means] and refer to these
segments as if they were a true physical device. This function enables
a more efficient use of a physical device and provides for a secure
multi-tenant environment.

At a high-level, the cxlflash adapter looks and behaves very much like
a SCSI HBA. Like other SCSI adapters it understands SCSI CDBs and LUN
discovery. It also provides health monitoring, error recovery, and link
event reporting.

At a lower level, the cxlflash adapter requires some additional items not
found in a traditional SCSI HBA driver. These include the following:

- A programmatic API (implemented as ioctls) that user applications
interact with when they desire to take advantage of the superpipe access
from user space. These ioctls allow the user to gain access to the CAPI
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
set of commands includes READ_CAPACITY and WRITE_SAME.

Accompanying this adapter driver but not included here is a user space
library (known as the block library) that will hide the interaction
between user space and the cxlflash driver. Most (if not all) users will
chose to use this library when developing superpipe-aware applications.

The block library can be found on Github:

   https://github.com/mikehollinger/ibmcapikv

More technical details are found within Documentation/powerpc/cxlflash.txt

The following patches are bisectable:

Patch 1 contains base enablement of superpipe function.

Patch 2 adds support for segmentation of physical LUNs from user space.

Matthew R. Ochs (2):
  cxlflash: Base superpipe support
  cxlflash: Virtual LUN support

 Documentation/powerpc/cxlflash.txt |  298 ++++++
 drivers/scsi/cxlflash/Makefile     |    2 +-
 drivers/scsi/cxlflash/common.h     |   18 +
 drivers/scsi/cxlflash/main.c       |   12 +
 drivers/scsi/cxlflash/superpipe.c  | 1884 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h  |  210 ++++
 drivers/scsi/cxlflash/vlun.c       | 1096 +++++++++++++++++++++
 include/uapi/scsi/cxlflash_ioctl.h |  159 +++
 8 files changed, 3678 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 drivers/scsi/cxlflash/vlun.c
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
