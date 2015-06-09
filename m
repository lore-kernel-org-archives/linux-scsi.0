From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6] IBM CXL Flash Adapter
Date: Tue,  9 Jun 2015 17:15:28 -0500
Message-ID: <1433888128-7318-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:49618 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbFIWRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 18:17:09 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Jun 2015 18:17:08 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id B831E6E803C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2015 18:08:53 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t59MH60I64421918
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 22:17:06 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t59MH405022626
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2015 18:17:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

This patch adds support for the IBM CXL flash (cxlflash) adapter. The device
is presented to the system as a SCSI adapter and may be accessed and used via
the normal filesystem paths.

Note that the patch is dependent on support that has not yet been merged in
with the mainline. The core cxl changes needed for this are in mpe's powerpc
next branch queued up for 4.2. They are in linux next-20150605. To compile
this you'll need to pull in mpe's powerpc tree from:

git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git next

v6 Changes:
- Incorporate review comments from Brian King
- Add udelay back in while trying to obtain room to send command
- Add an event to workq to MMIO read and atomically update AFU command room
- Post an event to workq when unable to obtain room and returning host busy

v5 Changes:
- Incorporate review comments from Mikey Neuling and Brian King
- Add PCI and SCSI dependencies
- Fix error code to -ENODEV when cxl_get_phys_dev() fails
- Revise TMF handling in queuecommand() to not sleep
- Revise afu->room atomic strategy to avoid possible race condition

v4 Changes:
- Incorporate followup comments from Brian King
- Re-introduce wait queue with serialization for TMF commands
- Revise updating of AFU room to limit MMIO reads
- Add proper cleanup in paths where send_cmd() fails
- Don't set DID_ERROR when sense data is valid

v3 Changes:
- Incorporate Brian King review comments
- Update to latest candidate upstream CXL APIs
- Add several clarification comments
- Use debug facilities in linux/bug.h
- Correct a potential command corruption bug
- Refine SCSI error handling/reporting
- Serialize TMF events
- Remove unnecessary debug prints, parenthesis, and volatile keywords
- Update afu->room where appropriate
- Sleep instead of busy-wait for command completion
- Serialize AFU sync events, ensure process context only
- Pack structures shared with hardware

v2 Changes:
- Incorporate Mikey Neuling review comments
- Update to candidate upstream CXL APIs
- Add several clarification comments
- Renamed some structures for clarity
- Removed the 'cxlflash' prefix from internal functions
- Address endianness concerns/issues
- Remove unused code
- Revert to using pr_*/dev_* print services
- Remove unneeded locking and barrier instructions

Matthew R. Ochs (1):
  cxlflash: Base support for IBM CXL Flash Adapter

 drivers/scsi/Kconfig            |    1 +
 drivers/scsi/Makefile           |    1 +
 drivers/scsi/cxlflash/Kconfig   |   11 +
 drivers/scsi/cxlflash/Makefile  |    2 +
 drivers/scsi/cxlflash/common.h  |  181 +++
 drivers/scsi/cxlflash/main.c    | 2294 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h    |  104 ++
 drivers/scsi/cxlflash/sislite.h |  465 ++++++++
 8 files changed, 3059 insertions(+)
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

-- 
2.1.0

