From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4] libsas updates for 2.6.40 (resend)
Date: Tue, 24 May 2011 13:17:43 -0700
Message-ID: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1EXTzl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 15:55:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, linux-ide@vger.kernel.org, edmund.nadolski@intel.com

This is a resend [1] of our pending libsas patch queue, plus one more for .40
consideration "libsas: Add option for SATA soft reset".  We're still
investigating whether having a soft reset handler will be beneficial for isci.
If it does we need an available hook in the .40 baseline, so we can
drop/hook-up our private implementation.  The only other change from the last
posting [2] is to drop the problematic locking in "libsas: fix/amend device
gone notification in sas_deform_port()".

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=130504487714639&w=2
[2]: http://marc.info/?l=linux-scsi&m=130444681502181&w=2

---

Dan Williams (3):
      libsas: flush initial device discovery before completing ->scan_finished()
      libsas: fix/amend device gone notification in sas_deform_port()
      libsas: check dev->gone before submitting sata i/o

Dave Jiang (1):
      libsas: Add option for SATA soft reset


 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/libsas/sas_ata.c       |   41 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_internal.h  |    2 +-
 drivers/scsi/libsas/sas_phy.c       |    4 ++-
 drivers/scsi/libsas/sas_port.c      |   21 ++++++++++--------
 drivers/scsi/libsas/sas_scsi_host.c |   14 ++++++------
 drivers/scsi/mvsas/mv_sas.c         |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
 include/scsi/libsas.h               |   14 ++++++++++++
 9 files changed, 79 insertions(+), 23 deletions(-)
