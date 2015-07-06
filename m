From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9] Integrate scsi_dh better into the scsi core V3
Date: Mon,  6 Jul 2015 16:14:56 +0200
Message-ID: <1436192105-44064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbGFOPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 10:15:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>

This series ties scsi_dh deeper into the scsi core, and fixes all kinds
of issues in it, most importantly the race between using and detaching
device handlers.

Changes since V1:
  - updated comments / strings based on review feedback
  - moved scsi_dh.c to drivers/scsi to fix the srcdir = objdir build
  - changed the old patch 2 to have saner handling of mismatching device
    handlers in dm.
  - dropped patch 1: not having a hw handler is fine if we don't plan to
    change it anyway
  - dropped patch 3: not necessary anymore.
Changes since V2:
  - Fixup issues during attaching device_handler from dm-multipath
  - Add patch to clarify scsi_dh_activate() error codes

Christoph Hellwig (8):
  dm-mpath, scsi_dh: don't let dm detach device handlers
  dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
  scsi_dh: move to drivers/scsi
  scsi_dh: integrate into the core SCSI code
  scsi_dh: move device matching to the core code
  scsi_dh: kill struct scsi_dh_data
  scsi_dh: add a common helper to get a scsi_device from a request_queue
  scsi_dh: don't allow to detach device handlers at runtime

Hannes Reinecke (1):
  scsi_dh: return individual errors in scsi_dh_activate()

 drivers/md/dm-mpath.c                       |  27 +-
 drivers/scsi/Makefile                       |   1 +
 drivers/scsi/device_handler/Kconfig         |   2 +-
 drivers/scsi/device_handler/Makefile        |   1 -
 drivers/scsi/device_handler/scsi_dh.c       | 621 ----------------------------
 drivers/scsi/device_handler/scsi_dh_alua.c  |  30 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  57 +--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  54 +--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  79 +---
 drivers/scsi/scsi_dh.c                      | 434 +++++++++++++++++++
 drivers/scsi/scsi_error.c                   |   6 +-
 drivers/scsi/scsi_lib.c                     |   6 +-
 drivers/scsi/scsi_priv.h                    |   9 +
 drivers/scsi/scsi_sysfs.c                   |  10 +
 include/scsi/scsi_device.h                  |  27 +-
 include/scsi/scsi_dh.h                      |  29 +-
 16 files changed, 528 insertions(+), 865 deletions(-)
 delete mode 100644 drivers/scsi/device_handler/scsi_dh.c
 create mode 100644 drivers/scsi/scsi_dh.c

-- 
1.8.5.2

