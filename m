From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 00/22] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 30 Aug 2010 02:19:54 -0700
Message-ID: <1283159994-6536-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Tomo-san, hch, jejb, mnc, boaz, and Co,

The following is a reviewable series containing TCM Core and TCM_Loop v4.0.0-rc3
against a fresh v2.6.36-rc3 clone who's commit log has been broken up to be reviewable,
rather than historical.  This code is intended for mainline v2.6.37 acceptance, and
is currently going through a final round of public review.

The tree can be found here:

	git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git master

The patches can also be found individually here:

	http://www.kernel.org/pub/linux/kernel/people/nab/TCM-v4-patches-for-v2.6.36-rc3/

Please have a look at the code at your earliest convience.  I will be making any
required changes into lio-core-2.6.git/lio-4.0, and respining this tree as necessary
for an upstream maintainer pull for v2.6.37.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (22):
  scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action
    definitions
  configfs: Add struct configfs_item_operations->check_link() in
    configfs_unlink()
  tcm: Add ConfigFS extended macro set
  tcm: Add v4 base data structures and struct target_core_fabric_ops
  tcm: Add SPC-4 explict and implict Asymmetric Logical Unit Access
    (ALUA)
  tcm: Add ConfigFS subsystem backstore infrastructure
  tcm: Add fabric and subsystem transport engine core
  tcm: Add HBA core infrastructure
  tcm: Add device core infrastructure
  tcm: Add target portal group infrastructure
  tcm: Add SPC-4 compliant Persistent Reservations (PR)
  tcm: Add Task Management infrastructure
  tcm: Add UNIT_ATTENTION infrastructure support
  tcm: Add SCSI MIB statistics support
  tcm: Add FILEIO subsystem plugin
  tcm: Add IBLOCK subsystem plugin
  tcm: Add PSCSI subsystem plugin
  tcm: Add RAMDISK_DR and RAMDISK_MCP subsystem plugins
  tcm: Add generic fabric independent ConfigFS infrastructure
  tcm: Add generic ProtoID and TransportID fabric handlers for SAS, FC,
    and iSCSI
  tcm: Add Kbuild and Kconfig for drivers/target,
    Documentation/target/tcm_mod_builder.py
  tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

 Documentation/target/tcm_mod_builder.py        | 1039 +++
 Documentation/target/tcm_mod_builder.txt       |  138 +
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/target/Kbuild                          |   30 +
 drivers/target/Kconfig                         |   36 +
 drivers/target/target_core_alua.c              | 1986 ++++++
 drivers/target/target_core_alua.h              |  134 +
 drivers/target/target_core_configfs.c          | 3334 ++++++++++
 drivers/target/target_core_device.c            | 1736 +++++
 drivers/target/target_core_fabric_configfs.c   |  979 +++
 drivers/target/target_core_fabric_lib.c        |  452 ++
 drivers/target/target_core_file.c              | 1185 ++++
 drivers/target/target_core_file.h              |   81 +
 drivers/target/target_core_hba.c               |  211 +
 drivers/target/target_core_hba.h               |   14 +
 drivers/target/target_core_iblock.c            | 1173 ++++
 drivers/target/target_core_iblock.h            |   44 +
 drivers/target/target_core_mib.c               | 1063 +++
 drivers/target/target_core_mib.h               |   31 +
 drivers/target/target_core_pr.c                | 4244 ++++++++++++
 drivers/target/target_core_pr.h                |   67 +
 drivers/target/target_core_pscsi.c             | 1510 +++++
 drivers/target/target_core_pscsi.h             |   68 +
 drivers/target/target_core_rd.c                | 1518 +++++
 drivers/target/target_core_rd.h                |   89 +
 drivers/target/target_core_scdb.c              |  149 +
 drivers/target/target_core_scdb.h              |   13 +
 drivers/target/target_core_tmr.c               |  405 ++
 drivers/target/target_core_tpg.c               |  844 +++
 drivers/target/target_core_transport.c         | 8272 ++++++++++++++++++++++++
 drivers/target/target_core_ua.c                |  332 +
 drivers/target/target_core_ua.h                |   36 +
 drivers/target/tcm_loop/Kbuild                 |   11 +
 drivers/target/tcm_loop/Kconfig                |   13 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  676 ++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   79 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  567 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   45 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  659 ++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 fs/configfs/symlink.c                          |   13 +
 include/linux/configfs.h                       |    1 +
 include/scsi/scsi.h                            |   24 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_base.h              |  985 +++
 include/target/target_core_configfs.h          |   57 +
 include/target/target_core_device.h            |   67 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |   89 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   38 +
 include/target/target_core_transport.h         |  560 ++
 55 files changed, 35436 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/target/tcm_mod_builder.py
 create mode 100644 Documentation/target/tcm_mod_builder.txt
 create mode 100644 drivers/target/Kbuild
 create mode 100644 drivers/target/Kconfig
 create mode 100644 drivers/target/target_core_alua.c
 create mode 100644 drivers/target/target_core_alua.h
 create mode 100644 drivers/target/target_core_configfs.c
 create mode 100644 drivers/target/target_core_device.c
 create mode 100644 drivers/target/target_core_fabric_configfs.c
 create mode 100644 drivers/target/target_core_fabric_lib.c
 create mode 100644 drivers/target/target_core_file.c
 create mode 100644 drivers/target/target_core_file.h
 create mode 100644 drivers/target/target_core_hba.c
 create mode 100644 drivers/target/target_core_hba.h
 create mode 100644 drivers/target/target_core_iblock.c
 create mode 100644 drivers/target/target_core_iblock.h
 create mode 100644 drivers/target/target_core_mib.c
 create mode 100644 drivers/target/target_core_mib.h
 create mode 100644 drivers/target/target_core_pr.c
 create mode 100644 drivers/target/target_core_pr.h
 create mode 100644 drivers/target/target_core_pscsi.c
 create mode 100644 drivers/target/target_core_pscsi.h
 create mode 100644 drivers/target/target_core_rd.c
 create mode 100644 drivers/target/target_core_rd.h
 create mode 100644 drivers/target/target_core_scdb.c
 create mode 100644 drivers/target/target_core_scdb.h
 create mode 100644 drivers/target/target_core_tmr.c
 create mode 100644 drivers/target/target_core_tpg.c
 create mode 100644 drivers/target/target_core_transport.c
 create mode 100644 drivers/target/target_core_ua.c
 create mode 100644 drivers/target/target_core_ua.h
 create mode 100644 drivers/target/tcm_loop/Kbuild
 create mode 100644 drivers/target/tcm_loop/Kconfig
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_core.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h
 create mode 100644 include/target/configfs_macros.h
 create mode 100644 include/target/target_core_base.h
 create mode 100644 include/target/target_core_configfs.h
 create mode 100644 include/target/target_core_device.h
 create mode 100644 include/target/target_core_fabric_configfs.h
 create mode 100644 include/target/target_core_fabric_lib.h
 create mode 100644 include/target/target_core_fabric_ops.h
 create mode 100644 include/target/target_core_tmr.h
 create mode 100644 include/target/target_core_tpg.h
 create mode 100644 include/target/target_core_transport.h

-- 
1.7.2.2
