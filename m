From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/18] mpt2sas, mpt3sas: Combine mpt2sas and mpt3sas
 driver code base
Date: Tue, 6 Oct 2015 02:46:29 -0700
Message-ID: <20151006094629.GA3863@infradead.org>
References: <1443628038-13552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443628038-13552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series seems to miss patch 5 which actually removes the mpt2sas
driver - it probably was too large for the list.  I also don't really like
the -DMPT2_SAS thing, but given that diver merges are painful I'd suggest
to merge it as-is and then see if we can convert it to build a mpt_common
module used by both drivers later.

Acked-by: Christoph Hellwig <hch@lst.de>

On Wed, Sep 30, 2015 at 09:17:00PM +0530, Sreekanth Reddy wrote:
> Combined mpt2sas and mpt3sas driver code base in such a way that
> still we can generate the two driver modules
> (i.e. mpt2sas.ko for SAS2 HBA's & mpt3sas.ko for SAS3 HBA's) individualy.
> 
> Sreekanth Reddy (18):
>   mpt2sas: Use mpi headers from mpt3sas
>   mpt3sas : Added mpt2sas driver definitions
>   mpt3sas: Move Gen3 HBA's device registration with PCI, SML and IOCTL
>     related API's to a separate file
>   mpt2sas: Created mpt2sas_module.c file in which Gen2 HBA's are
>     registers with PCI, SML and IOCTLs
>   mpt2sas: Removed .c and .h files from mpt2sas driver
>   mpt3sas: Define 'hba_mpi_version_belonged' IOC variable
>   mpt2sas, mpt3sas : Removed SCSI_MPTXSAS_LOGGING entry from Kconfig
>   mpt3sas: For an IO, build MPI SGL LIST on GEN2 HBA's and build IEEE
>     SGL LIST on GEN3 HBA's
>   mpt3as: Don't send PHYDISK_HIDDEN Raid Action request on SAS2 HBA's
>   mpt3sas: Manage MSIX vectors according to HBA device type
>   mpt3sas: fix for driver fails EEH, recovery from injected pci bus
>     error
>   mpt3sas : Ported WarpDrive product SSS6200 support
>   mpt3sas: Ported the providing sysfs attribute to report Backup Rail
>     Monitor Status
>   mpt3sas: Refcount sas_device objects and fix unsafe list usage
>   mpt3sas: Refcount fw_events and fix unsafe list usage
>   mpt3sas: Added OEMs Gen2 PnP ID Branding names
>   mpt3sas: setpci reset kernel oops fix
>   mpt2sas, mpt3sas: Update the driver versions
> 
>  drivers/scsi/mpt2sas/Kconfig             |    6 -
>  drivers/scsi/mpt2sas/Makefile            |   18 +-
>  drivers/scsi/mpt2sas/mpi/mpi2.h          | 1170 ----
>  drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h     | 3068 -----------
>  drivers/scsi/mpt2sas/mpi/mpi2_init.h     |  461 --
>  drivers/scsi/mpt2sas/mpi/mpi2_ioc.h      | 1708 ------
>  drivers/scsi/mpt2sas/mpi/mpi2_raid.h     |  366 --
>  drivers/scsi/mpt2sas/mpi/mpi2_sas.h      |  288 -
>  drivers/scsi/mpt2sas/mpi/mpi2_tool.h     |  481 --
>  drivers/scsi/mpt2sas/mpi/mpi2_type.h     |   61 -
>  drivers/scsi/mpt2sas/mpt2sas_base.c      | 4899 -----------------
>  drivers/scsi/mpt2sas/mpt2sas_base.h      | 1235 -----
>  drivers/scsi/mpt2sas/mpt2sas_config.c    | 1527 ------
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c       | 3101 -----------
>  drivers/scsi/mpt2sas/mpt2sas_ctl.h       |  419 --
>  drivers/scsi/mpt2sas/mpt2sas_debug.h     |  182 -
>  drivers/scsi/mpt2sas/mpt2sas_module.c    |  281 +
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 8855 ------------------------------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c | 2173 --------
>  drivers/scsi/mpt2sas/mpt2sas_warpdrive.c |  338 ++
>  drivers/scsi/mpt3sas/Kconfig             |    6 -
>  drivers/scsi/mpt3sas/Makefile            |    3 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c      |  663 ++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  256 +-
>  drivers/scsi/mpt3sas/mpt3sas_config.c    |   44 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  200 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.h       |    6 +-
>  drivers/scsi/mpt3sas/mpt3sas_debug.h     |   16 +-
>  drivers/scsi/mpt3sas/mpt3sas_module.c    |  253 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1268 +++--
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |   18 +-
>  31 files changed, 2635 insertions(+), 30735 deletions(-)
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_init.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_raid.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_sas.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_tool.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpi/mpi2_type.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_base.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_config.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_ctl.h
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_debug.h
>  create mode 100644 drivers/scsi/mpt2sas/mpt2sas_module.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_scsih.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_transport.c
>  create mode 100644 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
>  create mode 100644 drivers/scsi/mpt3sas/mpt3sas_module.c
> 
> -- 
> 2.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
