From: Dan Williams <dan.j.williams@intel.com>
Subject: [set1 PATCH 0/4] scsi, libsas,
 libata: fix up host_eh_scheduled usage
Date: Thu, 21 Jun 2012 23:25:22 -0700
Message-ID: <20120622062521.21162.31523.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761300Ab2FVGIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:08:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Set1 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

Libsas is more dependent on proper management of host_eh_scheduled
compared to what libata has typically exposed.  Libsas has multiple
ata_ports per Scsi_Host, while libata enforces 1:1.  Fix cases where
this distinction causes problems.

These have been submitted previously for 3.4 and 3.5.

---

Dan Williams (3):
      libata, libsas: introduce sched_eh and end_eh port ops
      scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
      scsi: cleanup setting task state in scsi_error_handler()

Maciej Trela (1):
      libsas: cleanup spurious calls to scsi_schedule_eh


 drivers/ata/libata-core.c           |    4 ++
 drivers/ata/libata-eh.c             |   57 ++++++++++++++++++++++++++++-------
 drivers/scsi/libsas/sas_ata.c       |   39 +++++++++++++++++++++---
 drivers/scsi/libsas/sas_discover.c  |    6 ++--
 drivers/scsi/libsas/sas_event.c     |   12 ++++---
 drivers/scsi/libsas/sas_init.c      |   14 ++++-----
 drivers/scsi/libsas/sas_scsi_host.c |   28 +++++++++++++----
 drivers/scsi/scsi_error.c           |   18 +++++++++--
 include/linux/libata.h              |    4 ++
 include/scsi/libsas.h               |    4 ++
 include/scsi/sas_ata.h              |    5 +++
 11 files changed, 149 insertions(+), 42 deletions(-)
