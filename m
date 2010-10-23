From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] Updated lio-4.0.git/merge-for-37-v2 branch for mainline
Date: Sat, 23 Oct 2010 16:52:41 -0700
Message-ID: <1287877961.25701.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linu
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, "Love, Robert W" <robert.w.love@intel.com>, Joe Eykholt <jeykholt@cisco.com>, Philipp Reisner <philipp.reisner@linbit.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>
List-Id: linux-scsi@vger.kernel.org

Greetings jejb, andrew, linus and co,

This patch contains a single commit / mergeable version of TCM/ConfigFS infrastructure
+ TCM_Loop v4.0.0-rc5+ code up to commit 3c4a5d31dd4b from lio-core-2.6.git/lio-4.0.
This patch has been generated this afternoon against Linus's latest 'for-37'
commit 35da7a307c535f containing Jen's + Christoph's + Tejun's for-2.6.37/core fixes
which effects target_core_iblock.c's usage of blkdev_issue_flush() for SYNCHRONIZE_CACHE
emulation.

So as there have been no further code comments and one bugfix outstanding for feedback
since RFCv3 awaiting Jen's and Christoph's freedback. please accept this as my formal merge
request for TCM/ConfigFS + TCM_Loop v4.0.0-rc5+ into a tree (comments..?) destined for
.37 mainline.  The pullable tree is here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-4.0.git merge-for-37-v2

which contains the following two commits:

scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] and VARIABLE_LENGTH_CMD service actions
tcm: Add TCM and TCM_Loop v4.0.0-rc5+ for .37

The 'git squashed' log of the main second patch as individual RFC commits appear as:

tcm: Add ConfigFS extended macro set
tcm: Add v4 base data structures and struct target_core_fabric_ops
tcm: Add SPC-4 explict and implict Asymmetric Logical Unit Access (ALUA)
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
tcm: Add generic ProtoID and TransportID fabric handlers for SAS, FC, and iSCSI
tcm: Add Kbuild and Kconfig for drivers/target and Documentation/target/
tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

The respective RFCv3, RFCv2 and RFCv1 patches of TCM v4.0 for .37 can be
found here:

[RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-kernel&m=128744135522606&w=2

[RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-kernel&m=128519571622744&w=2

[RFC 00/22] TCM Core and TCM_Loop patches for v2.6.37
http://marc.info/?l=linux-scsi&m=128316004105485&w=2

The individual TCM v4.0.0-rc announcements + changelogs can be found here:

[ANNOUNCE] TCM/LIO v4.0.0-rc5 for 2.6.36-rc8
http://marc.info/?l=linux-scsi&m=128739657813518&w=2

[ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
http://marc.info/?l=linux-scsi&m=128497455919041&w=2

[ANNOUNCE] TCM/LIO v4.0.0-rc3 for 2.6.36-rc3
http://marc.info/?l=linux-scsi&m=128312775110418&w=2

[ANNOUNCE] TCM/LIO: v4.0.0-rc2 for v2.6.35
http://marc.info/?l=linux-scsi&m=128090716528454&w=2

So at this point folks please let me know of any other items that
should be going into TCM v4.0.0-rc6 and I will follow up accordingly.

Once again a huge thanks goes out to everyone who has contributed
their time, review and code during the v4.0 development during the last
~10 months!!  A pull request would not be complete without at least
some recognition of the people who have helped get us to this point:

Christoph Hellwig, James Bottomley, Jens Axboe, FUJITA Tomonori,
Mike Christie, Hannes Reinecke, Joel Becker, Martin K. Petersen,
Boaz Harrosh, Joe Eykholt, Robert Love, Phillip Reisner, Doug Gilbert
Richard Sharpe, and Konrad Rzeszutek Wilk.

There are certainly many more folks beyond these extra-ordinarily
talented community members who have contributed their time, energy and
determination to improve this code and to push the upstream code it
depends upon within last year.  It would certainly not have been
possible (or as nearly as fun and challenging) as it has been thus far.

Thank you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
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
 drivers/target/target_core_iblock.c            | 1018 +++
 drivers/target/target_core_iblock.h            |   45 +
 drivers/target/target_core_mib.c               | 1081 +++
 drivers/target/target_core_mib.h               |   30 +
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
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  494 ++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   40 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  618 ++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 include/target/configfs_macros.h               |  147 +
 include/target/target_core_base.h              | 1076 +++
 include/target/target_core_configfs.h          |   57 +
 include/target/target_core_device.h            |   73 +
 include/target/target_core_fabric_configfs.h   |  106 +
 include/target/target_core_fabric_lib.h        |   28 +
 include/target/target_core_fabric_ops.h        |  100 +
 include/target/target_core_tmr.h               |   43 +
 include/target/target_core_tpg.h               |   39 +
 include/target/target_core_transport.h         |  570 ++
 52 files changed, 36398 insertions(+), 0 deletions(-)
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
