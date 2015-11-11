From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/25] mpt3sas: Mergering mpt2sas & mpt3sas driver code
Date: Wed, 11 Nov 2015 14:04:55 +0100
Message-ID: <56433CF7.8040905@suse.de>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 11/11/2015 01:00 PM, Sreekanth Reddy wrote:
> Last time we have posted a set of patches which combine the mpt2sas
> and mpt3sas driver code. and we are generating two driver modules
> (i.e. two separate .ko's) from this Combined driver source.
>=20
> Now we have modified above Combined driver source (i.e. single driver
> source with two .ko's) to a Merged driver source (i.e. sing source wi=
th
> single .ko) which supports both LSI MPT Fusion SAS 2.0 and SAS 3.0
> generation HBAs.
>=20
> Here I am once again posting first 18 patches of Combined driver sour=
ce
> along with last 7 patches which converts this Combined driver source =
to
> Merged driver source.
>=20
> Here is the change list from Combined driver src to Merged driver src
> * Added SAS 2.0 HBA device IDs to the mpt3sas_pci_table pci table.
> * Created two separate SCSI host templates for SAS2 and SAS3 HBAs. So
>   that, during the driver load time driver can use
>   corresponding host template(based the pci device ID) while
>   registering a scsi host adapter instance for that pci device.
> * Registered two IOCTL devices, mpt2ctl is for SAS2 HBAs & mpt3ctl fo=
r
>   SAS3 HBAs. Also updated the code to make sure   that mpt2ctl device=
 to
>   process only those ioctl cmds issued for the SAS2 HBAs and mpt3ctl
>   device to process only those ioctl cmds issued for the SAS3 HBAs.
> * Added two separate ioc number indexing for SAS2 and SAS3 HBAs.
> * Replaced compile time check 'MPT2SAS_SCSI' to run time check
>   'hba_mpi_version_belonged' wherever needed.
> * Aliased this merged driver to mpt2sas using MODULE_ALIAS.so that
>   still user can load this merged driver with 'modprobe mpt2sas'.
> * Moved global variable 'driver_name' to per adapter instance variabl=
e.
> * Created two raid function templates and used corresponding raid
>   function templates based on the run time check
>   'hba_mpi_version_belonged'.
> * Moved mpt2sas_warpdrive.c file from mpt2sas to mpt3sas folder and
>   renamed it as mpt3sas_warpdrive.c.
> * Updated the Makefile to built as a mpt3sas_warpdrive.o file.
> * Added module parameter 'hbas_to_enumarate', which user can use this
>   merged driver as legacy mpt2sas driver or as a
>   legacy mpt3sas driver if needed.
>=20
>         Here are the available options for this module parameter
>            0 - Merged driver which enumerates both SAS 2.0 & SAS 3.0 =
HBAs
>            1 - Acts as legacy mpt2sas driver, which enumerates only S=
AS 2.0 HBAs
>            2 - Acts as legacy mpt3sas driver, which enumerates only S=
AS 3.0 HBAs
>=20
> * Added SCSI_MPT3SAS_MERGED config option, This Kconfig option is onl=
y
>   used for legacy mpt2sas/mpt3sas interoperability.
>=20
> In patch 5 (ie. mpt2sas: Removed .c and .h files from mpt2sas driver)
> we are just removing mpt2sas driver files. so one can just provide be=
low
> command if this patch is not reached to linux-scsi community mail lis=
t,
>=20
> "git rm drivers/scsi/mpt2sas/mpt2sas_base.*
> drivers/scsi/mpt2sas/mpt2sas_config.c
> drivers/scsi/mpt2sas/mpt2sas_ctl.*
> drivers/scsi/mpt2sas/mpt2sas_scsih.c
> drivers/scsi/mpt2sas/mpt2sas_transport.c
> drivers/scsi/mpt2sas/mpt2sas_debug.h"
>=20
> Thanks,
> Sreekanth
>=20
> Sreekanth Reddy (25):
>   mpt2sas: Use mpi headers from mpt3sas
>   mpt3sas: Added mpt2sas driver definitions
>   mpt3sas: Move Gen3 HBA's device registration with PCI, SML and IOCT=
L
>     related API's to a separate file
>   mpt2sas: Created mpt2sas_module.c file in which Gen2 HBA's are
>     registers with PCI, SML and IOCTLs
>   mpt2sas: Removed .c and .h files from mpt2sas driver
>   mpt3sas: Define 'hba_mpi_version_belonged' IOC variable
>   mpt2sas, mpt3sas : Removed SCSI_MPTXSAS_LOGGING entry from Kconfig
>   mpt3sas: For an IO, build MPI SGL LIST on GEN2 HBA's and build IEEE
>     SGL LIST on GEN3 HBA's
>   mpt3sas: Don't send PHYDISK_HIDDEN Raid Action request on SAS2 HBA'=
s
>   mpt3sas: Manage MSIX vectors according to HBA device type
>   mpt3sas: fix for driver fails EEH, recovery from injected pci bus
>     error
>   mpt3sas: Ported WarpDrive product SSS6200 support
>   mpt3sas: Ported the providing sysfs attribute to report Backup Rail
>     Monitor Status
>   mpt3sas: Refcount sas_device objects and fix unsafe list usage
>   mpt3sas: Refcount fw_events and fix unsafe list usage
>   mpt3sas: Added OEMs Gen2 PnP ID Branding names
>   mpt3sas: setpci reset kernel oops fix
>   mpt2sas, mpt3sas: Update the driver versions
>   mpt3sas: Single driver module which supports both SAS 2.0 & SAS 3.0
>     HBA's
>   mpt3sas: Moved Warpdriver specific functions to mpt3sas_warpdrive.c
>   mpt2sas: Removed mpt2sas folder
>   mpt3sas: Added a module parameter hbas_to_enumerate
>   mpt2sas: Removed mpt2sas entries from SCSI's Kconfig and Makefile
>   mpt3sas: Added SCSI_MPT3SAS_MERGED config option
>   mpt3sas: Bump mpt3sas driver version to 09.102.00.00
>=20
>  drivers/scsi/Kconfig                     |    1 -
>  drivers/scsi/Makefile                    |    1 -
>  drivers/scsi/mpt2sas/Kconfig             |   67 -
>  drivers/scsi/mpt2sas/Makefile            |    7 -
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
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 8855 --------------------=
----------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c | 2173 --------
>  drivers/scsi/mpt3sas/Kconfig             |   29 +-
>  drivers/scsi/mpt3sas/Makefile            |    3 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c      |  668 ++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  233 +-
>  drivers/scsi/mpt3sas/mpt3sas_config.c    |   42 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  259 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.h       |    6 +-
>  drivers/scsi/mpt3sas/mpt3sas_debug.h     |   16 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1555 ++++--
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |   18 +-
>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  344 ++
>  31 files changed, 2447 insertions(+), 30796 deletions(-)
>  delete mode 100644 drivers/scsi/mpt2sas/Kconfig
>  delete mode 100644 drivers/scsi/mpt2sas/Makefile
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
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_scsih.c
>  delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_transport.c
>  create mode 100644 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
>=20
=46inally!

Thank you so much for this work.
After reading through the entire series I've found that my
prior comments are in fact resolved with later patches.
So you can add my

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
