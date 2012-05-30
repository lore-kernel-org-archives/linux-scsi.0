From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 0/4] fix / cleanup async scsi scanning
Date: Wed, 30 May 2012 11:21:25 -0700
Message-ID: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab2E3SFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 14:05:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: mroos@linux.ee, JBottomley@parallels.com

Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
introduces a boot regression by moving sd probe work off of the global
async queue.  Using a local async domain hides the probe work from being
synchronized by wait_for_device_probe()->async_synchronize_full().

Fix this by teaching async_synchronize_full() to flush all async work
regardless of domain, and take the opportunity to convert scsi scanning
to async_schedule().  This enables wait_for_device_probe() to flush scsi
scanning work.

Changes since v1: http://marc.info/?l=linux-scsi&m=133793153025832&w=2

1/ Tested to fix the boot hang that Meelis reported with v1.  Reworked
   async_synchronize_full() to walk through all the active domains,
   otherwise we spin on !list_empty(async_domains) and prevent the async
   context from running.

2/ Added the ability for domains to opt-out of global syncing as
   requested by Arjan, but also needed for domains that don't want to worry
   about list corruption when the domain goes out of scope (stack-allocated
   domains).

---

Dan Williams (4):
      async: introduce 'async_domain' type
      async: make async_synchronize_full() flush all work regardless of domain
      scsi: queue async scan work to an async_schedule domain
      scsi: cleanup usages of scsi_complete_async_scans


 drivers/regulator/core.c      |    2 +
 drivers/scsi/libsas/sas_ata.c |    2 +
 drivers/scsi/scsi.c           |    4 ++
 drivers/scsi/scsi_priv.h      |    3 +-
 drivers/scsi/scsi_scan.c      |   24 +++----------
 drivers/scsi/scsi_wait_scan.c |   15 +++-----
 include/linux/async.h         |   36 +++++++++++++++++--
 include/scsi/scsi_scan.h      |   11 ------
 kernel/async.c                |   76 +++++++++++++++++++++++++++++++----------
 kernel/power/hibernate.c      |    8 ----
 kernel/power/user.c           |    2 -
 11 files changed, 107 insertions(+), 76 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h
