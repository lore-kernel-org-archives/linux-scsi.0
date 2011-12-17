From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT 3.2-rc PATCH 0/8] isci: platform and hardware enabling updates
Date: Fri, 16 Dec 2011 16:53:10 -0800
Message-ID: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1LQAxL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 19:53:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These are priority updates, targeted for inclusion in 3.2-final, for the
driver to honor the latest definition of oem parameters and support the
latest revision of silicon.  The oem parameter format (phy configuration
settings passed along from platform firmware) has been updated to
revision 1.3, current driver only supports 1.0.  The C1 silicon update
involves updates to the per-silicon-revision hard-coded phy tuning
recipes.

This also updates the driver version from v1.0 to v1.1 to remove the
stale EXPERIMENTAL tag and reflect the C1 level of silicon support.

A performance fix and a fix for a crash that can be triggered by
enabling a dev_dbg() statement are also included.

Please apply, or pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git fixes

...to receive:

Dan Williams (2):
      isci: cleanup oem parameter and recipe handling
      isci: update version to 1.1

Dave Jiang (1):
      isci: oem parameter format v1.1 (ssc select)

Jeff Skirvin (3):
      isci: update afe (analog-front-end) recipe for C1
      isci: oem parameter format v1.3 (cable select)
      isci: link speeds default to gen 2

Maciej Trela (1):
      isci: remove unused 'isci_tmf->device' field

Marcin Tomczak (1):
      isci: performance-fix, shorten default "no outbound task" timeout

 drivers/scsi/Kconfig                   |    5 -
 drivers/scsi/isci/firmware/create_fw.c |   53 +++---
 drivers/scsi/isci/firmware/create_fw.h |   13 ++-
 drivers/scsi/isci/host.c               |  277 ++++++++++++++++++++++++--------
 drivers/scsi/isci/host.h               |   27 +++-
 drivers/scsi/isci/init.c               |   25 +++-
 drivers/scsi/isci/isci.h               |    1 +
 drivers/scsi/isci/phy.c                |  137 +++++++++++-----
 drivers/scsi/isci/probe_roms.c         |    2 +-
 drivers/scsi/isci/probe_roms.h         |   89 ++++++++++-
 drivers/scsi/isci/task.c               |    2 +-
 drivers/scsi/isci/task.h               |    7 +-
 firmware/isci/isci_firmware.bin.ihex   |    2 +-
 13 files changed, 477 insertions(+), 163 deletions(-)

Thanks,
Dan
