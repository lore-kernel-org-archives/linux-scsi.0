From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH v2 00/15] isci update for 3.3 (part1)
Date: Wed, 04 Jan 2012 01:32:23 -0800
Message-ID: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab2ADJcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:32:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These are the updates to the isci driver that have no conflicts with the
pending libsas updates [1].  A follow-on set is based on the new
sas_get_local_phy() interface [2], as well as the ability to schedule a
libata-eh managed reset via sas_ata_schedule_reset().

It includes a rebased version of the platform / silicon support updates
submitted a couple weeks back [3].  These patches were rebased to account for
the movement of isci_firmware.bin to linux-firmware.git.

The new patches are fixups for wide-ported targets and other
miscellaneous updates.

[1]: http://marc.info/?l=linux-scsi&m=132460922902788&w=2
[2]: http://marc.info/?l=linux-scsi&m=132460936902872&w=2
[3]: http://marc.info/?l=linux-scsi&m=132408329807210&w=2

---
The following changes since commit 7061bba1da7acb837d6a982648a8306ddc9d7409:

  [SCSI] bfa: fix endian and bit field check bug (2011-12-12 23:48:08 +0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git devel

Bartek Nowakowski (1):
      isci: enable wide port targets

Ben Hutchings (1):
      isci, firmware: Remove isci fallback parameter blob and generator

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

Marcin Tomczak (6):
      isci: performance-fix, shorten default "no outbound task" timeout
      isci: Fix IO fails when pull cable from phy in x4 wideport in MPC mode.
      isci: allow more time for wide port targets
      isci: fix io failures while wide port links are coming up
      isci: fix start OOB
      isci: fix, prevent port from getting stuck in the 'configuring' state


 drivers/scsi/Kconfig                   |    5 
 drivers/scsi/isci/firmware/Makefile    |   19 --
 drivers/scsi/isci/firmware/README      |   36 ---
 drivers/scsi/isci/firmware/create_fw.c |   99 ---------
 drivers/scsi/isci/firmware/create_fw.h |   77 -------
 drivers/scsi/isci/host.c               |  340 +++++++++++++++++++++++++-------
 drivers/scsi/isci/host.h               |   27 ++-
 drivers/scsi/isci/init.c               |   25 ++
 drivers/scsi/isci/isci.h               |    1 
 drivers/scsi/isci/phy.c                |  172 ++++++++++------
 drivers/scsi/isci/port.c               |  104 +++++-----
 drivers/scsi/isci/port.h               |   10 +
 drivers/scsi/isci/port_config.c        |   35 ++-
 drivers/scsi/isci/probe_roms.c         |    2 
 drivers/scsi/isci/probe_roms.h         |   89 ++++++++
 drivers/scsi/isci/remote_device.c      |   10 +
 drivers/scsi/isci/task.c               |    2 
 drivers/scsi/isci/task.h               |    7 -
 firmware/Makefile                      |    1 
 firmware/isci/isci_firmware.bin.ihex   |   16 --
 20 files changed, 610 insertions(+), 467 deletions(-)
 delete mode 100644 drivers/scsi/isci/firmware/Makefile
 delete mode 100644 drivers/scsi/isci/firmware/README
 delete mode 100644 drivers/scsi/isci/firmware/create_fw.c
 delete mode 100644 drivers/scsi/isci/firmware/create_fw.h
 delete mode 100644 firmware/isci/isci_firmware.bin.ihex
