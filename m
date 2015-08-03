From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 0/4] CXL Flash Fixes, Error Recovery, and Superpipe
Date: Sun,  2 Aug 2015 23:31:31 -0500
Message-ID: <1438576291-32856-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:33193 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbbHCEc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 00:32:28 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sun, 2 Aug 2015 22:32:27 -0600
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 9F8A038C8026
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2015 00:32:25 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t734WPTr61604058
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2015 04:32:25 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t734WOIZ023678
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2015 00:32:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

This patch set is intended for the 4.3 release and adds support for
error recovery and the superpipe features provided by the IBM CXL
Flash adapter. The superpipe function was originally presented in an
RFC patch set in late April. To aid with the review of the superpipe
portion of these enhancements, we have further split it across the
last two patches in this set. Please reference the changelog below
for details on what has been altered from previous versions of this
patchset. Also included in the first patch of the series are several
bug fixes and refactoring of the previously submitted legacy I/O patch.

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

More technical details can be found in Documentation/powerpc/cxlflash.txt

The following patches are bisectable:

Patch 1 contains bug fixes and refactoring of the legacy I/O function.

Patch 2 contains base enablement of error recovery function.

Patch 3 contains base enablement of superpipe function.

Patch 4 adds support for segmentation of physical LUNs from user space.

v3 Changes:
- Add patch of legacy fixes/refactoring
- Fix enhanced I/O error handling bugs
- Incorporate review comments from Brian King
- Incorporate review comments from Wendy Xiong
- Transition more pr_* prints to dev_* prints
- Clarify functions through renaming and prolog details
- Remove unnecessary gotos/labels
- Use rq_timeout instead of defining own timeout
- Fix potential memory leaks
- Use existing services/macros instead of defining our own
- Make code more readable (ie: reduce multi-line statements)
- Manage layout of LUN table
- Add retry logic to context recovery
- Add ioctl range used by driver to ioctl reservation list

v2 Changes:
- Introduce support for enhanced I/O error handling
- Incorporate review comments from Mikey Neuling
- Incorporate review comments from Brian King
- Update/add serialization strategy for contexts
- Lock down LUN lists and global struct
- Make items that can be static, static
- Remove duplicate statements
- Make shared counters atomic
- Use correct memory barrier for LWSYNC
- Add cxlflash_ioctl.h to UAPI Kbuild
- Remove unnecessary initialization code
- Fix spelling/grammar errors
- Remove the slave_* routines
- Tone down branch hints
- Use scsi_execute() to issue SCSI commands
- Use existing SCSI defines
- Sleep instead of busy-wait
- Remove duplicate parenths
- Refine patch staging 

Matthew R. Ochs (4):
  cxlflash: Updates to legacy I/O
  cxlflash: Base error recovery support
  cxlflash: Superpipe support
  cxlflash: Virtual LUN support

 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/powerpc/cxlflash.txt   |  297 +++++
 drivers/scsi/cxlflash/Kconfig        |    2 +-
 drivers/scsi/cxlflash/Makefile       |    2 +-
 drivers/scsi/cxlflash/common.h       |   43 +-
 drivers/scsi/cxlflash/main.c         | 1517 +++++++++++++----------
 drivers/scsi/cxlflash/main.h         |    3 +-
 drivers/scsi/cxlflash/sislite.h      |    9 +-
 drivers/scsi/cxlflash/superpipe.c    | 2250 ++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h    |  145 +++
 drivers/scsi/cxlflash/vlun.c         | 1241 +++++++++++++++++++
 drivers/scsi/cxlflash/vlun.h         |   74 ++
 include/uapi/scsi/Kbuild             |    1 +
 include/uapi/scsi/cxlflash_ioctl.h   |  173 +++
 14 files changed, 5097 insertions(+), 661 deletions(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 drivers/scsi/cxlflash/vlun.c
 create mode 100644 drivers/scsi/cxlflash/vlun.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

-- 
2.1.0

