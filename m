From: Dan Williams <dan.j.williams@intel.com>
Subject: [set4 PATCH 0/4] libsas, libata: suspend / resume and "reset once"
Date: Thu, 21 Jun 2012 23:41:36 -0700
Message-ID: <20120622064135.21452.82833.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761329Ab2FVGY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:24:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Set4 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

Let libsas hook into the generic suspend resume infrastructure in
libata, and provide a common suspend/resume implementation for lldds to
reuse.

"Reset once" is not part of the suspend/resume work.  But it is relevant
to libsas users who need to wait for domain-wide ata error recovery and
want to limit the effort for known well-behaved devices.

These have been in -next for the past couple kernel cycles.

---

Artur Wojcik (1):
      isci: implement suspend/resume support

Dan Williams (3):
      libata: reset once
      libata: export ata_port suspend/resume infrastructure for sas
      libsas: suspend / resume support


 Documentation/kernel-parameters.txt |    3 +
 drivers/ata/libata-core.c           |   59 ++++++++++++++++++-----
 drivers/ata/libata-eh.c             |    2 +
 drivers/scsi/isci/host.c            |    2 -
 drivers/scsi/isci/host.h            |    2 -
 drivers/scsi/isci/init.c            |   58 ++++++++++++++++++++++-
 drivers/scsi/libsas/sas_ata.c       |   86 +++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c  |   69 +++++++++++++++++++++++----
 drivers/scsi/libsas/sas_dump.c      |    1 
 drivers/scsi/libsas/sas_event.c     |    4 +-
 drivers/scsi/libsas/sas_init.c      |   90 +++++++++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_internal.h  |    1 
 drivers/scsi/libsas/sas_phy.c       |   21 ++++++++
 drivers/scsi/libsas/sas_port.c      |   52 ++++++++++++++++++++
 include/linux/libata.h              |   12 +++++
 include/scsi/libsas.h               |   20 ++++++--
 include/scsi/sas_ata.h              |   10 ++++
 17 files changed, 458 insertions(+), 34 deletions(-)
