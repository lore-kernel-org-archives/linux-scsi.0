From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Wed, 22 Sep 2010 15:48:22 -0700
Message-ID: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Tomo-san, hch, jejb, mnc, boaz, jens, konrad, jlbec, joe, and Co,

The following is a reviewable series containing TCM Core and TCM_Loop v4.0.0-rc4 +
very lastest lio-core-2.6.git/lio-4.0 updates against a fresh v2.6.36-rc5 clone who's commit
log has been broken up to be reviewable rather than historical.  This code is intended
for mainline v2.6.37 acceptance and is currently going through the final public review.

The RFCv2 tree can be found in lio-4.0.git/rfcv2-for-37 here:

	http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=shortlog;h=refs/heads/rfcv2-for-37

Or can be pulled via:

        git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git rfcv2-for-37

The patches can also be found individually here:

        http://www.kernel.org/pub/linux/kernel/people/nab/TCM-v4-patches-for-v2.6.36-rc5/

The announcement for the changes between v4.0.0-rc3 -> rc4 is available here:

	http://lkml.org/lkml/2010/9/17/284

Note that this series has dropped the original ConfigFS ->check_link() patch, many thanks
to jlbec for making the case that this really was unnecessary.  Also note that patch #1
here is the scsi.h defs update that has been posted seperately to linux-scsi:

	http://marc.info/?l=linux-scsi&m=128513469032115&w=2

Please have a look at the code at your earliest convience.  As before, I will be making
any required changes into lio-core-2.6.git/lio-4.0, and respining this tree as necessary
for an upstream maintainer pull for v2.6.37.

Many, many thanks again to all of the folks who contributed.  It certainly would not
be possible without your help!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (21):
  scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] and
    VARIABLE_LENGTH_CMD service actions
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
 drivers/target/target_core_alua.c              | 1993 ++++++
 drivers/target/target_core_alua.h              |  142 +
 drivers/target/target_core_configfs.c          | 3334 +++++++++
 drivers/target/target_core_device.c            | 1705 +++++
 drivers/target/target_core_fabric_configfs.c   | 1001 +++
 drivers/target/target_core_fabric_lib.c        |  451 ++
 drivers/target/target_core_file.c              | 1197 ++++
 drivers/target/target_core_file.h              |   81 +
 drivers/target/target_core_hba.c               |  211 +
 drivers/target/target_core_hba.h               |   14 +
 drivers/target/target_core_iblock.c            | 1173 ++++
 drivers/target/target_core_iblock.h            |   44 +
 drivers/target/target_core_mib.c               | 1081 +++
 drivers/target/target_core_mib.h               |   31 +
 drivers/target/target_core_pr.c                | 4243 ++++++++++++
 drivers/target/target_core_pr.h                |   67 +
 drivers/target/target_core_pscsi.c             | 1569 +++++
 drivers/target/target_core_pscsi.h             |   69 +
 drivers/target/target_core_rd.c                | 1555 +++++
 drivers/target/target_core_rd.h                |   89 +
 drivers/target/target_core_scdb.c              |  158 +
 drivers/target/target_core_scdb.h              |   15 +
 drivers/target/target_core_tmr.c               |  405 ++
 drivers/target/target_core_tpg.c               |  830 +++
 drivers/target/target_core_transport.c         | 8860 ++++++++++++++++++++++++
 drivers/target/target_core_ua.c                |  332 +
 drivers/target/target_core_ua.h                |   36 +
 drivers/target/tcm_loop/Kbuild                 |   11 +
 drivers/target/tcm_loop/Kconfig                |   13 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  649 ++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   77 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  494 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   43 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  618 ++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 include/scsi/scsi.h                            |   28 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_base.h              | 1056 +++
 include/target/target_core_configfs.h          |   57 +
 include/target/target_core_device.h            |   66 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |  101 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   39 +
 include/target/target_core_transport.h         |  570 ++
 53 files changed, 36090 insertions(+), 0 deletions(-)
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
1.7.3
