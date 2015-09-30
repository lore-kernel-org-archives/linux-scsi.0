From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 00/18] mpt2sas, mpt3sas: Combine mpt2sas and mpt3sas driver code base
Date: Wed, 30 Sep 2015 21:17:00 +0530
Message-ID: <1443628038-13552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35096 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbI3Prv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 11:47:51 -0400
Received: by pacfv12 with SMTP id fv12so45115576pac.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 08:47:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Combined mpt2sas and mpt3sas driver code base in such a way that
still we can generate the two driver modules
(i.e. mpt2sas.ko for SAS2 HBA's & mpt3sas.ko for SAS3 HBA's) individualy.

Sreekanth Reddy (18):
  mpt2sas: Use mpi headers from mpt3sas
  mpt3sas : Added mpt2sas driver definitions
  mpt3sas: Move Gen3 HBA's device registration with PCI, SML and IOCTL
    related API's to a separate file
  mpt2sas: Created mpt2sas_module.c file in which Gen2 HBA's are
    registers with PCI, SML and IOCTLs
  mpt2sas: Removed .c and .h files from mpt2sas driver
  mpt3sas: Define 'hba_mpi_version_belonged' IOC variable
  mpt2sas, mpt3sas : Removed SCSI_MPTXSAS_LOGGING entry from Kconfig
  mpt3sas: For an IO, build MPI SGL LIST on GEN2 HBA's and build IEEE
    SGL LIST on GEN3 HBA's
  mpt3as: Don't send PHYDISK_HIDDEN Raid Action request on SAS2 HBA's
  mpt3sas: Manage MSIX vectors according to HBA device type
  mpt3sas: fix for driver fails EEH, recovery from injected pci bus
    error
  mpt3sas : Ported WarpDrive product SSS6200 support
  mpt3sas: Ported the providing sysfs attribute to report Backup Rail
    Monitor Status
  mpt3sas: Refcount sas_device objects and fix unsafe list usage
  mpt3sas: Refcount fw_events and fix unsafe list usage
  mpt3sas: Added OEMs Gen2 PnP ID Branding names
  mpt3sas: setpci reset kernel oops fix
  mpt2sas, mpt3sas: Update the driver versions

 drivers/scsi/mpt2sas/Kconfig             |    6 -
 drivers/scsi/mpt2sas/Makefile            |   18 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h          | 1170 ----
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h     | 3068 -----------
 drivers/scsi/mpt2sas/mpi/mpi2_init.h     |  461 --
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h      | 1708 ------
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h     |  366 --
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h      |  288 -
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h     |  481 --
 drivers/scsi/mpt2sas/mpi/mpi2_type.h     |   61 -
 drivers/scsi/mpt2sas/mpt2sas_base.c      | 4899 -----------------
 drivers/scsi/mpt2sas/mpt2sas_base.h      | 1235 -----
 drivers/scsi/mpt2sas/mpt2sas_config.c    | 1527 ------
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       | 3101 -----------
 drivers/scsi/mpt2sas/mpt2sas_ctl.h       |  419 --
 drivers/scsi/mpt2sas/mpt2sas_debug.h     |  182 -
 drivers/scsi/mpt2sas/mpt2sas_module.c    |  281 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 8855 ------------------------------
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 2173 --------
 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c |  338 ++
 drivers/scsi/mpt3sas/Kconfig             |    6 -
 drivers/scsi/mpt3sas/Makefile            |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  663 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  256 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |   44 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  200 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h       |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h     |   16 +-
 drivers/scsi/mpt3sas/mpt3sas_module.c    |  253 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1268 +++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c |   18 +-
 31 files changed, 2635 insertions(+), 30735 deletions(-)
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_init.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_raid.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_sas.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_tool.h
 delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_type.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_config.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.h
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_debug.h
 create mode 100644 drivers/scsi/mpt2sas/mpt2sas_module.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_scsih.c
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_transport.c
 create mode 100644 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_module.c

-- 
2.0.2

