From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 0/3] CXL Flash Error Recovery and Superpipe
Date: Thu, 13 Aug 2015 21:47:23 -0500
Message-ID: <1439520443-56720-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:42955 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbbHNCsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 22:48:37 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 13 Aug 2015 22:48:36 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 6800E38C803B
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 22:48:33 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7E2mXfZ65404946
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 02:48:33 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7E2mW2F029315
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 22:48:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org
Cc: hch@infradead.org, imunsie@au1.ibm.com

This patch set is intended for the 4.3 release and adds support for
error recovery and the superpipe features provided by the IBM CXL
Flash adapter. The superpipe function was originally presented in an
RFC patch set in late April. To aid with the review of the superpipe
portion of these enhancements, we have further split it across the
last two patches in this set. Please reference the changelog below
for details on what has been altered from previous versions of this
patchset.

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

At a lower level, the cxlflash adapter requires some additional items
not found in a traditional SCSI HBA driver. These include the following:

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

This patch set depends on the original cxlflash patch from:

http://permalink.gmane.org/gmane.linux.scsi/102357

The following patches are bisectable:

Patch 1 contains base enablement of error recovery function.

Patch 2 contains base enablement of superpipe function.

Patch 3 adds support for segmentation of physical LUNs from user space.

v6 Changes:
- Incorporate comments from Michael Neuling
- Fix memory leak in create_context()
- Advertise ioctl version via sysfs

v5 Changes:
- Incorporate comments from Daniel Axtens
- Incorporate comments from Benjamin Herrenschmidt
- Incorporate comments from Michael Neuling
- Incorporate comments from Wendy Xiong
- Properly reflect (via rc) a failed reset
- Transition to failed state following a failed reset
- Added ioctl header validation
- Patch against upstreamed code to avoid conflicts
- Refine traces (use dev_* and selectively move traces to debug)
- Make context retrieval/release symmetric
- Inline comments clarifying abbreviations, global/local lun table
- Rename functions to properly reflect their actions
- Don't hide sizeof() behind a #define
- Add ioctl version
- Reorder ioctls to avoid sparse numbers in absence of vlun patch
- Rename clone ioctl to properly reflect it being vlun-specific
- Use actual record type instead of void *
- Remove trailing newlines from files
- Improved documentation of ioctls
- Split larger contiguous allocations into multiple allocations
- Split lun management function into separate file
- Re-use existing defines, instead of creating new ones
- Simplify locking of lun table
- Remove unnecessary gotos/labels
- Fix a LUN serialization bug

v4 Changes:
- Removes patch of legacy fixes/refactoring (to be posted as separate set)
- Incorporate comments from Brian King
- Incorporate comments from Daniel Axtens
- Remove duplication of EEH state machine
- Introduce adapter state machine
- Tuck ifdef inside header
- Remove unnecessary delay
- Check state after waiting in limbo
- Return the proper code in EEH callback
- Remove SCSI read/write command snooping
- Use cpu-endian-aware swap routines

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

Matthew R. Ochs (3):
  cxlflash: Base error recovery support
  cxlflash: Superpipe support
  cxlflash: Virtual LUN support

 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/powerpc/cxlflash.txt   |  318 ++++++
 drivers/scsi/cxlflash/Kconfig        |    2 +-
 drivers/scsi/cxlflash/Makefile       |    2 +-
 drivers/scsi/cxlflash/common.h       |   34 +-
 drivers/scsi/cxlflash/lunmgt.c       |  266 +++++
 drivers/scsi/cxlflash/main.c         |  221 +++-
 drivers/scsi/cxlflash/main.h         |    6 +-
 drivers/scsi/cxlflash/sislite.h      |   25 +-
 drivers/scsi/cxlflash/superpipe.c    | 2084 ++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h    |  147 +++
 drivers/scsi/cxlflash/vlun.c         | 1243 ++++++++++++++++++++
 drivers/scsi/cxlflash/vlun.h         |   86 ++
 include/uapi/scsi/Kbuild             |    1 +
 include/uapi/scsi/cxlflash_ioctl.h   |  174 +++
 15 files changed, 4584 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/lunmgt.c
 mode change 100755 => 100644 drivers/scsi/cxlflash/sislite.h
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 drivers/scsi/cxlflash/vlun.c
 create mode 100644 drivers/scsi/cxlflash/vlun.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

-- 
2.1.0

