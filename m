From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 00/37] cxlflash: Miscellaneous bug fixes and corrections
Date: Wed, 21 Oct 2015 15:08:54 -0500
Message-ID: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44507 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbbJUUKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:10:32 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:10:31 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B4C5E3E4003B
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:10:27 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LK96GS9568656
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:09:06 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKAPGg000627
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:10:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

This patch set contains various fixes and corrections for issues that
were found during test and code review. The series is based upon the
code upstreamed in 4.3 (rebased to Dan Carpenter's 9/22 patch) and is
intended for 4.4. The entire set is bisectable. Please reference the
changelog below for details on what has been altered from previous
versions of this patch set.

v6 Changes:
- Added patch to avoid corrupting the port selection mask
- Added patch to properly initialize the TMF spin lock
- Added patch to remove possibility of skipping context cleanup
- No change to patches present in v5

v5 Changes:
- Incorporate comments from Daniel Axtens
- Incorporate comments from Andrew Donnellan
- Added additional clarifications to several commit messages
- Specified some return codes as failures in "Fix function prolog..."
- Made port online failure noisier in "Remove dual port online..."
- Added patch to properly cleanup when encountering an unsupported AFU
- Added patch to escalate a link reset on login timeout

v4 Changes:
- Incorporate comments from Brian King
- Removed unnecessary check_state() parameter from "Fix to avoid CXL..."
- Added patch to fix potential deadlock on EEH
- Removed patch to avoid state change collision
- Changed fops initialization location in "Fix to avoid corrupting..."

v3 Changes:
- Rebased the series on top of patch by Dan Carpenter ("a couple off...")
- Incorporate comments from David Laight
- Incorporate comments from Tomas Henzl
- Incorporate comments from Brian King
- Removed patch to stop interrupt processing on remove
- Removed double scsi_device_put() from "Fix potential oops"
- Fixed usage of scnprintf() in "Refine host/device attributes"
- Removed unnecessary parenthesis from "Fix read capacity timeout"
- Added patch to use correct operator for doubling delay
- Changed location of cancel_work_sync() in "Fix to prevent workq..."
- Removed local mutex from cxlflash_afu_sync() in "Fix to avoid state..."
- Added patch to correctly identify a failed function in a trace
- Added patch to fix a fops corruption bug

v2 Changes:
- Incorporate comments from Ian Munsie
- Rework commit messages to be more descriptive
- Add state change serialization patch

Manoj Kumar (5):
  cxlflash: Fix to avoid invalid port_sel value
  cxlflash: Replace magic numbers with literals
  cxlflash: Fix read capacity timeout
  cxlflash: Fix to double the delay each time
  cxlflash: Fix to escalate to LINK_RESET on login timeout

Matthew R. Ochs (32):
  cxlflash: Fix potential oops following LUN removal
  cxlflash: Fix data corruption when vLUN used over multiple cards
  cxlflash: Fix to avoid sizeof(bool)
  cxlflash: Fix context encode mask width
  cxlflash: Fix to avoid CXL services during EEH
  cxlflash: Correct naming of limbo state and waitq
  cxlflash: Make functions static
  cxlflash: Refine host/device attributes
  cxlflash: Fix to avoid spamming the kernel log
  cxlflash: Fix to avoid stall while waiting on TMF
  cxlflash: Fix location of setting resid
  cxlflash: Fix host link up event handling
  cxlflash: Fix async interrupt bypass logic
  cxlflash: Remove dual port online dependency
  cxlflash: Fix AFU version access/storage and add check
  cxlflash: Correct usage of scsi_host_put()
  cxlflash: Fix to prevent workq from accessing freed memory
  cxlflash: Correct behavior in device reset handler following EEH
  cxlflash: Remove unnecessary scsi_block_requests
  cxlflash: Fix function prolog parameters and return codes
  cxlflash: Fix MMIO and endianness errors
  cxlflash: Fix to prevent EEH recovery failure
  cxlflash: Correct spelling, grammar, and alignment mistakes
  cxlflash: Fix to prevent stale AFU RRQ
  MAINTAINERS: Add cxlflash driver
  cxlflash: Fix to avoid corrupting adapter fops
  cxlflash: Correct trace string
  cxlflash: Fix to avoid potential deadlock on EEH
  cxlflash: Fix to avoid leaving dangling interrupt resources
  cxlflash: Fix to avoid corrupting port selection mask
  cxlflash: Fix to avoid lock instrumentation rejection
  cxlflash: Fix to avoid bypassing context cleanup

 MAINTAINERS                       |    9 +
 drivers/scsi/cxlflash/common.h    |   30 +-
 drivers/scsi/cxlflash/lunmgt.c    |   45 +-
 drivers/scsi/cxlflash/main.c      | 1550 ++++++++++++++++++++-----------------
 drivers/scsi/cxlflash/main.h      |    1 +
 drivers/scsi/cxlflash/sislite.h   |    8 +-
 drivers/scsi/cxlflash/superpipe.c |  209 +++--
 drivers/scsi/cxlflash/superpipe.h |   14 +-
 drivers/scsi/cxlflash/vlun.c      |   68 +-
 9 files changed, 1075 insertions(+), 859 deletions(-)

-- 
2.1.0

