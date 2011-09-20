From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/5] libsas fixes discovered via isci-atapi enabling effort
Date: Tue, 20 Sep 2011 15:10:03 -0700
Message-ID: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1ITWKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2011 18:10:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com, JBottomley@parallels.com

While enabling atapi device support for isci we encountered a condition
whereby multiple srX devices (one for every possible LUN) were exported
by the midlayer.  Looking at other drivers showed that they had a local
workaround for this and other conditions in custom
->slave_{alloc|configure} methods.  Rather than add custom workaround
for isci this patchset uplevels those workarounds to libsas proper.

Patch 3/5 is tagged RFC as I do not know the original history behind
hard limiting libsas end devices to a queue_depth of 32.  At least mvsas
has been bumping this up to 64 on its own.

---

Dan Williams (5):
      libsas: disable scanning lun > 0 on ata devices
      libsas: fix ->change_queue_{depth|type} for sata devices
      libsas: dynamic queue depth
      mvsas: remove mvs_slave_{alloc|configure}
      pm8001: remove pm8001_slave_{alloc|configure}


 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-scsi.c           |   44 +++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_scsi_host.c |   42 +++++++++++++++++++--------------
 drivers/scsi/mvsas/mv_init.c        |    4 ++-
 drivers/scsi/mvsas/mv_sas.c         |   30 ------------------------
 drivers/scsi/mvsas/mv_sas.h         |    2 --
 drivers/scsi/pm8001/pm8001_init.c   |    4 ++-
 drivers/scsi/pm8001/pm8001_sas.c    |   31 +------------------------
 drivers/scsi/pm8001/pm8001_sas.h    |    2 --
 drivers/scsi/scsi_transport_sas.c   |   10 ++++++--
 include/linux/libata.h              |    2 ++
 11 files changed, 69 insertions(+), 103 deletions(-)
