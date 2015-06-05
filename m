From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v4] IBM CXL Flash Adapter
Date: Fri,  5 Jun 2015 16:45:59 -0500
Message-ID: <1433540759-15237-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:52807 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbFEVrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2015 17:47:33 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 5 Jun 2015 15:47:33 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2DD4419D8040
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2015 15:38:32 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t55LktE133882256
	for <linux-scsi@vger.kernel.org>; Fri, 5 Jun 2015 14:46:55 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t55LlTnr013657
	for <linux-scsi@vger.kernel.org>; Fri, 5 Jun 2015 15:47:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

This patch adds support for the IBM CXL flash (cxlflash) adapter. The device
is presented to the system as a SCSI adapter and may be accessed and used via
the normal filesystem paths.

Note that the patch is dependent on support that has not yet been merged
in with the mainline (upstream process started).

In the interim, this code may be found on Github:

 https://github.com/mikey/linux/tree/cxl/kernelapi

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
 drivers/scsi/cxlflash/common.h  |  180 ++++
 drivers/scsi/cxlflash/main.c    | 2263 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h    |  104 ++
 drivers/scsi/cxlflash/sislite.h |  465 ++++++++
 8 files changed, 3027 insertions(+)
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

-- 
2.1.0

