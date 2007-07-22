From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] final piece of the SCSI merge for 2.6.22
Date: Sun, 22 Jul 2007 13:28:53 -0500
Message-ID: <1185128933.3431.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37690 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758618AbXGVS24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 14:28:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This final piece contains driver updates (mainly qla2xx and the long
delayed ATA update for libsas) plus fix ups for bsg which Jens and Tomo
want to take through the scsi tree.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adam Radford (1):
      3w-9xxx: add support for 9690SA

Adrian Bunk (3):
      seagate: make seagate_st0x_detect() static
      wd33c93: cleanups
      small cleanups

Al Viro (1):
      iscsi_tcp: buggered kmalloc()

Andrew Vasquez (8):
      qla2xxx: Update version number to 8.02.00-k2.
      qla2xxx: Add ISP25XX support.
      qla2xxx: Use pci_try_set_mwi().
      qla2xxx: Use PCI-X/PCI-Express read control interfaces.
      qla2xxx: Re-factor isp_operations to static structures.
      qla2xxx: Correct setting of 'current' and 'supported' speeds duri=
ng FDMI r
      qla2xxx: Generalize iIDMA support.
      qla2xxx: Generalize FW-Interface-2 support.

Darrick J. Wong (13):
      sas_ata: Implement sas_task_abort for ATA devices
      sas_ata: Assign sas_task to scsi_cmnd to enable EH for ATA device=
s
      libsas: Unknown STP devices should be reported to libata as unkno=
wn.
      libsas: Accept SAM_GOOD for ATAPI devices in sas_ata_task_done
      sas_ata: Don't copy aic94xx's sactive to ata_port
      sas_ata: ata_post_internal should abort the sas_task
      sas_ata: sas_ata_qc_issue should return AC_ERR_*
      sas_ata: Satisfy libata qc function locking requirements
      aic94xx: Don't call pci_map_sg for already-mapped scatterlists
      Migrate libsas ATA code into a separate file
      libsas: support NCQ for SATA disks
      aic94xx: SATA tag mask not set correctly
      Add SATA support to libsas

David Miller (1):
      ESP: Increase ESP_BUS_TIMEOUT to 275.

=46UJITA Tomonori (5):
      bsg: unexport sg v3 helper functions
      bsg: fix bsg_unregister_queue
      libsas: kill unused smp_portal code
      libsas: add SAS management protocol handler
      transport_sas: add SAS management protocol support

Gwendal Grignou (1):
      mpt fusion: update Kconfig help

Heiko Carstens (1):
      zfcp: NULL vs 0 usage

James Bottomley (13):
      libsas: make ATA functions selectable by a config option
      bsg: make class backlinks
      bsg: fix bsg_register_queue error path
      libsas: fix scr_read/write users and update the libata documentat=
ion
      scsi_transport_sas: add destructor for bsg
      bsg: separate bsg and SCSI (so SCSI can be modular)
      libsas: fix lockdep issue with ATA
      libsas, aic94xx: fix dma mapping cockups with ATA
      libsas: fixup NCQ for SATA disks
      libsas: better error handling in sas_ex_discover_end_dev()
      aic94xx: add SATAPI support
      libsas: fix up sas_smp_phy_control()
      libsas: Add SATA support to STP piece for SATA on SAS expanders

Jan Engelhardt (1):
      Use menuconfig objects

Kristian H=C3=B8gsberg (1):
      Make scsi_host_template::proc_name const char * instead of char *=
=2E

Matthew Wilcox (1):
      a4000t, zorro7xx, mvme16x, bvme6000,sim710: xxx_device_remove see=
ms buggy

Prakash, Sathya (4):
      mpt fusion: add support for Brocade branded LSI FC HBA
      mpt fusion: deregister from transport layer if PCI registration f=
ailed
      add PCI_VENDOR_ID macro for Brocade in pci_ids.h
      mpt fusion: add sysfs attributes to display IOC parameters

Salyzyn, Mark (3):
      aacraid: add vpd to inquiry
      aacraid: incorrect dma mapping mask during blinkled recover or us=
er initia
      aacraid: correct valid container response in management ioctl

Shyam Sundar (1):
      qla2xxx: Validate mid-layer 'underflow' during check-condition ha=
ndling.

Swen Schillig (2):
      zfcp: code cleanup
      zfcp: Replace kmalloc/memset with kzalloc

And the diffstat:

 Documentation/DocBook/libata.tmpl   |    5=20
 block/Kconfig                       |    2=20
 block/bsg.c                         |   61 -
 block/scsi_ioctl.c                  |   13=20
 drivers/firewire/fw-sbp2.c          |    2=20
 drivers/message/fusion/Kconfig      |    1=20
 drivers/message/fusion/mptbase.c    |  382 ++++++++++--
 drivers/message/fusion/mptbase.h    |    9=20
 drivers/message/fusion/mptfc.c      |    3=20
 drivers/message/fusion/mptsas.c     |   72 ++
 drivers/message/fusion/mptscsih.c   |  153 ++++
 drivers/message/fusion/mptscsih.h   |    1=20
 drivers/message/fusion/mptspi.c     |    9=20
 drivers/s390/scsi/zfcp_aux.c        |    9=20
 drivers/s390/scsi/zfcp_def.h        |    1=20
 drivers/s390/scsi/zfcp_erp.c        |    3=20
 drivers/s390/scsi/zfcp_fsf.c        |    2=20
 drivers/s390/scsi/zfcp_qdio.c       |  113 +--
 drivers/scsi/3w-9xxx.c              |   67 +-
 drivers/scsi/3w-9xxx.h              |    5=20
 drivers/scsi/Kconfig                |   10=20
 drivers/scsi/a4000t.c               |    3=20
 drivers/scsi/aacraid/aachba.c       |  140 ++++
 drivers/scsi/aacraid/aacraid.h      |   14=20
 drivers/scsi/aacraid/commsup.c      |   16=20
 drivers/scsi/aic94xx/aic94xx_dev.c  |    2=20
 drivers/scsi/aic94xx/aic94xx_init.c |    3=20
 drivers/scsi/aic94xx/aic94xx_task.c |   20=20
 drivers/scsi/bvme6000_scsi.c        |    3=20
 drivers/scsi/esp_scsi.h             |    2=20
 drivers/scsi/iscsi_tcp.c            |    2=20
 drivers/scsi/libsas/Kconfig         |    7=20
 drivers/scsi/libsas/Makefile        |    1=20
 drivers/scsi/libsas/sas_ata.c       |  817 ++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_discover.c  |  402 ------------
 drivers/scsi/libsas/sas_expander.c  |  230 +++----
 drivers/scsi/libsas/sas_init.c      |    1=20
 drivers/scsi/libsas/sas_internal.h  |    3=20
 drivers/scsi/libsas/sas_scsi_host.c |   74 ++
 drivers/scsi/mvme16x_scsi.c         |    3=20
 drivers/scsi/pcmcia/Kconfig         |    7=20
 drivers/scsi/qla2xxx/qla_attr.c     |   33 -
 drivers/scsi/qla2xxx/qla_dbg.c      | 1114 +++++++++++++++++++++++++++=
++-------
 drivers/scsi/qla2xxx/qla_dbg.h      |   38 +
 drivers/scsi/qla2xxx/qla_def.h      |   22=20
 drivers/scsi/qla2xxx/qla_fw.h       |   36 +
 drivers/scsi/qla2xxx/qla_gbl.h      |    6=20
 drivers/scsi/qla2xxx/qla_gs.c       |   82 +-
 drivers/scsi/qla2xxx/qla_init.c     |  136 ++--
 drivers/scsi/qla2xxx/qla_inline.h   |    4=20
 drivers/scsi/qla2xxx/qla_iocb.c     |   10=20
 drivers/scsi/qla2xxx/qla_isr.c      |   55 +
 drivers/scsi/qla2xxx/qla_mbx.c      |   58 -
 drivers/scsi/qla2xxx/qla_os.c       |  380 +++++++-----
 drivers/scsi/qla2xxx/qla_sup.c      |   35 -
 drivers/scsi/qla2xxx/qla_version.h  |    2=20
 drivers/scsi/scsi_debug.c           |    2=20
 drivers/scsi/scsi_sysctl.c          |    1=20
 drivers/scsi/scsi_sysfs.c           |   16=20
 drivers/scsi/scsi_transport_fc.c    |    2=20
 drivers/scsi/scsi_transport_sas.c   |  125 ++++
 drivers/scsi/seagate.c              |    2=20
 drivers/scsi/sim710.c               |    3=20
 drivers/scsi/sr.c                   |    2=20
 drivers/scsi/wd33c93.c              |    4=20
 drivers/scsi/zorro7xx.c             |    3=20
 include/linux/blkdev.h              |    5=20
 include/linux/bsg.h                 |    4=20
 include/linux/libata.h              |    1=20
 include/linux/pci_ids.h             |    2=20
 include/scsi/libsas.h               |   15=20
 include/scsi/sas_ata.h              |   60 +
 include/scsi/scsi_host.h            |    2=20
 include/scsi/scsi_transport_sas.h   |   11=20
 74 files changed, 3649 insertions(+), 1295 deletions(-)

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
