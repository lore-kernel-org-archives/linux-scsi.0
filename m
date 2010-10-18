From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 18 Oct 2010 15:35:13 -0700
Message-ID: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

The following is the third reviewable series containing TCM Core and TCM_Loop v4.0.0-rc5 +
very lastest lio-core-2.6.git/lio-4.0 updates against a fresh v2.6.36-rc8 clone who's commit
log has been broken up to be reviewable rather than historical.  This code is intended
for mainline v2.6.37 acceptance and is currently going through the 3rd and final public review.

The RFCv3 tree can be found in lio-4.0.git/rfcv3-for-37 here:

        http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=shortlog;h=refs/heads/rfcv3-for-37

Or can be pulled via:

        git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git rfcv3-for-37

The patches can also be found individually here:

        http://www.kernel.org/pub/linux/kernel/people/nab/TCM-v4-patches-for-v2.6.36-rc8/

This mornings announcement for the changes between v4.0.0-rc4 -> rc5 is available here:

	http://lkml.org/lkml/2010/10/18/116

Finally, this same v4.0.0-rc5 / RFCv3 code has been merged in another branch named
lio-4.0.git/merge-for-37 with the following two commits:

	*) scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] and
		VARIABLE_LENGTH_CMD service actions
	*) tcm: Add TCM and TCM_Loop v4.0.0-rc5

which can be pulled directly from:

	git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git merge-for-37

At this point the plan is to defer any new features into v4.1 / .38 code, and focus
on any remaining bugs with TCM_Loop / LIO-Target, and continue on with the LIO-Target
-> iscsi_proto.h conversion.  I am also asking hch, jejb, tomo-san, mnc, hare and co
for a list of remaining recommended cleanups for the short term .37 merge.

As we have multiple in-progress TCM HW fabric modules underway that depend on this
code, there will be more testing in this area to make sure all of the functional items
within TCM for interfacing with mainline and out-of-tree target mode drivers.

hch, jejb and co.  Please let me know any other cleanup items you would like me
to address for the .37 merge.

Thanks!

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
  tcm: Add Kbuild and Kconfig for drivers/target and
    Documentation/target/
  tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

 Documentation/target/tcm_mod_builder.py        | 1094 +++
 Documentation/target/tcm_mod_builder.txt       |  145 +
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/target/Kbuild                          |   30 +
 drivers/target/Kconfig                         |   36 +
 drivers/target/target_core_alua.c              | 1993 +++++
 drivers/target/target_core_alua.h              |  142 +
 drivers/target/target_core_configfs.c          | 3499 +++++++++
 drivers/target/target_core_device.c            | 1816 +++++
 drivers/target/target_core_fabric_configfs.c   | 1001 +++
 drivers/target/target_core_fabric_lib.c        |  451 ++
 drivers/target/target_core_file.c              | 1052 +++
 drivers/target/target_core_file.h              |   81 +
 drivers/target/target_core_hba.c               |  211 +
 drivers/target/target_core_hba.h               |   14 +
 drivers/target/target_core_iblock.c            |  995 +++
 drivers/target/target_core_iblock.h            |   44 +
 drivers/target/target_core_mib.c               | 1081 +++
 drivers/target/target_core_mib.h               |   31 +
 drivers/target/target_core_pr.c                | 4243 +++++++++++
 drivers/target/target_core_pr.h                |   67 +
 drivers/target/target_core_pscsi.c             | 1583 ++++
 drivers/target/target_core_pscsi.h             |   73 +
 drivers/target/target_core_rd.c                | 1412 ++++
 drivers/target/target_core_rd.h                |   89 +
 drivers/target/target_core_scdb.c              |  158 +
 drivers/target/target_core_scdb.h              |   15 +
 drivers/target/target_core_tmr.c               |  405 ++
 drivers/target/target_core_tpg.c               |  830 +++
 drivers/target/target_core_transport.c         | 9262 ++++++++++++++++++++++++
 drivers/target/target_core_ua.c                |  332 +
 drivers/target/target_core_ua.h                |   36 +
 drivers/target/tcm_loop/Kbuild                 |   11 +
 drivers/target/tcm_loop/Kconfig                |   13 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  647 ++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   77 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  495 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   40 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  618 ++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 include/scsi/scsi.h                            |   28 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_base.h              | 1076 +++
 include/target/target_core_configfs.h          |   57 +
 include/target/target_core_device.h            |   73 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |  100 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   39 +
 include/target/target_core_transport.h         |  571 ++
 53 files changed, 36405 insertions(+), 0 deletions(-)
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
1.7.3.1
