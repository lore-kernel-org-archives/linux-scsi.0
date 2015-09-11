From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 00/29] cxlflash: Miscellaneous bug fixes and corrections
Date: Fri, 11 Sep 2015 16:13:32 -0500
Message-ID: <1442006012-46803-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60951 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbIKVNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:13:51 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:13:50 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B8E6A19D8045
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:04:41 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLCg0G19333278
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:12:42 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLDjvv024229
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:13:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org

This patch set contains various fixes and corrections for issues that
were found during test and code review. The series is based upon the
code upstreamed in 4.3 and is intended for the rc phase. The entire
set is bisectable.

Manoj Kumar (3):
  cxlflash: Move global.mutex to caller of find_and_create_lun()
  cxlflash: Add a literal for units of max_sector
  cxlflash: Increase timeout value for read capacity to 30 seconds

Matthew R. Ochs (26):
  cxlflash: Obtain additional sdev reference
  cxlflash: Always attempt LUN table initialization
  cxlflash: Change rht_needs_ws from bool to u8
  cxlflash: Add ULL specifier to context encode mask
  cxlflash: Add ioctl drain
  cxlflash: Check for removal when processing interrupt
  cxlflash: Rename limbo to reset
  cxlflash: Make functions static
  cxlflash: Refine host/device attributes
  cxlflash: Refine print statements
  cxlflash: Protect TMF waitq with spinlock
  cxlflash: Only set resid when needed
  cxlflash: Rescan host following link up event
  cxlflash: Bypass async interrupt bits that are off
  cxlflash: Remove dual port online dependency
  cxlflash: Properly obtain AFU version and check it
  cxlflash: Correct usage of scsi_host_put()
  cxlflash: Move workq termination earlier on remove
  cxlflash: Recheck state after adapter reset
  cxlflash: Remove unnecessary scsi_block_requests
  cxlflash: Update function prologs
  cxlflash: Fix MMIO and endianness errors
  cxlflash: Drop context mutex while processing sense
  cxlflash: Spelling, grammar, and alignment changes
  cxlflash: Clear AFU RRQ following reset
  MAINTAINERS: Add cxlflash driver

 MAINTAINERS                       |    9 +
 drivers/scsi/cxlflash/common.h    |   28 +-
 drivers/scsi/cxlflash/lunmgt.c    |    9 +-
 drivers/scsi/cxlflash/main.c      | 1539 ++++++++++++++++++++-----------------
 drivers/scsi/cxlflash/main.h      |    1 +
 drivers/scsi/cxlflash/sislite.h   |    8 +-
 drivers/scsi/cxlflash/superpipe.c |  172 +++--
 drivers/scsi/cxlflash/superpipe.h |   11 +-
 drivers/scsi/cxlflash/vlun.c      |   39 +-
 9 files changed, 998 insertions(+), 818 deletions(-)

-- 
2.1.0

