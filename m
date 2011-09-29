From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/5] isci updates for 3.2
Date: Wed, 28 Sep 2011 18:47:36 -0700
Message-ID: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63830 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab1I2Brr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:47:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org

This series functionally depends on the pending libsas fix for ata lun
scanning.  For convenience those updates have been queued to
"git://github.com:djbw/linux.git libsas".

The following changes since commit 7705375e944ea94be7941b740efd0a77bb109cb1:

  libsas: remove unused ata_task_resp fields (2011-09-28 18:06:10 -0700)

are available in the git repository at:
  git://github.com:djbw/linux.git isci

The prominent update in this set is atapi support.  The rest are small
bug fixes and feature enhancements.  More error handling and command
termination fixes are in the works.

Dan Williams (2):
      isci: atapi support
      isci: export phy events via ->lldd_control_phy()

Jeff Skirvin (3):
      isci: SATA/STP I/O is only returned in the normal path to libsas
      isci: fix decode of DONE_CRC_ERR TC completion status
      isci: The port state should be set to stopping on the last phy.

 drivers/scsi/aic94xx/aic94xx_scb.c  |    1 +
 drivers/scsi/isci/phy.c             |   11 ++
 drivers/scsi/isci/port.c            |    2 +-
 drivers/scsi/isci/remote_device.c   |   24 +++
 drivers/scsi/isci/remote_device.h   |    9 +
 drivers/scsi/isci/request.c         |  330 +++++++++++++++++++++++++++++++++--
 drivers/scsi/isci/request.h         |   28 +++-
 drivers/scsi/isci/task.h            |   19 ++
 drivers/scsi/libsas/sas_init.c      |   13 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 drivers/scsi/mvsas/mv_sas.c         |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c    |    2 +-
 include/scsi/libsas.h               |    5 +
 include/scsi/sas.h                  |    1 +
 14 files changed, 424 insertions(+), 25 deletions(-)
