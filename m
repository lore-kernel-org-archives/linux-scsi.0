From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/21] target patches for .39 scsi-misc (v3)
Date: Mon, 14 Mar 2011 04:05:54 -0700
Message-ID: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

This is an updated 'for-39' target series consisting of the two previous
series posted here:

[PATCH 00/14] target patches for .39 scsi-misc (v2)
http://marc.info/?l=linux-scsi&m=129866341626173&w=2

[PATCH 0/5] target updates for scsi-post-merge .39 (round one)
http://marc.info/?l=linux-scsi&m=129887410814785&w=2

This series contains a few new minor fixes that have reported to linux-scsi
in the last week since the original posting.  The most interesting pieces
of this series are the new configfs based statistics groups and first mainline
target fabric module (TCM_Loop).  The breakdown consists of:

Patches #1 -> #16 are non critical bugfixes and minor improvements from
.38 that have been queued as .39 misc items upon your request.

Patches #17 -> #20 involve the addition of new ConfigFS context based
statistics groups in target_core_stat.c following RFC-4455 to address
the removal of the legacy ProcFS based target_core_mib.c in .38 code.

And patch #21 adds the TCM_Loop virtual SCSI LLD module that was originally
reviewed and intended for .38 code.  This module currently supports
high level port emulation for SAS, FC and iSCSI ProtoIdents.

This series is against .38-rc8, and is also available directly here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-misc-v3

Please review and merge for into scsi-misc headed for mainline .39.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Axel Lin (1):
  target: Add __init/__exit annotation for
    target_core_[init,exit]_configfs

Christoph Hellwig (1):
  target: remove EXTRA_CFLAGS

Dan Carpenter (2):
  target: Minor sparse warning fixes and annotations
  target: Convert rd_build_device_space() to use errno

Fubo Chen (2):
  target: Remove unnecessary hba_dev_list walk and se_clear_dev_ports
    legacy code
  target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

Jesper Juhl (2):
  target: Fix match_strdup() memory leaks
  target: Avoid mem leak and needless work in transport_generic_get_mem

Nicholas Bellinger (12):
  target: tcm_mod_builder.py generated Makefile cleanups
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove spurious double cast from structure macro accessors
  target: Convert TMR REQ/RSP definitions to target namespace
  target: Fix bogus return in transport_add_device_to_core_hba failure
    path
  target: Fix FILEIO fd_buffered_io= token typo
  target core v4.0.0-rc7-ml
  target: add initial device backend context target_core_stat.c code
  target: add initial fabric port context target_core_stat.c code
  target: add initial fabric MappedLUN context target_core_stat.c code
  target: Add fabric_stat_group for fabric module statistics
    default_group
  tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

Roland Dreier (1):
  target: Fix memory leak on error path in pscsi_alloc_task

 Documentation/target/tcm_mod_builder.py        |   18 +-
 drivers/target/Kconfig                         |    2 +
 drivers/target/Makefile                        |    7 +-
 drivers/target/target_core_configfs.c          |  117 ++-
 drivers/target/target_core_device.c            |   40 +-
 drivers/target/target_core_fabric_configfs.c   |  209 +++-
 drivers/target/target_core_fabric_lib.c        |    1 +
 drivers/target/target_core_file.c              |   28 +-
 drivers/target/target_core_hba.c               |   15 +-
 drivers/target/target_core_iblock.c            |   28 +-
 drivers/target/target_core_pscsi.c             |   22 +-
 drivers/target/target_core_rd.c                |   15 +-
 drivers/target/target_core_rd.h                |    2 -
 drivers/target/target_core_stat.c              | 1810 ++++++++++++++++++++++++
 drivers/target/target_core_stat.h              |    8 +
 drivers/target/target_core_transport.c         |   37 +-
 drivers/target/tcm_loop/Kconfig                |   11 +
 drivers/target/tcm_loop/Makefile               |    5 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  643 +++++++++
 drivers/target/tcm_loop/tcm_loop_core.h        |  141 ++
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  472 ++++++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  574 ++++++++
 include/target/target_core_base.h              |   73 +-
 include/target/target_core_configfs.h          |    4 +
 include/target/target_core_fabric_ops.h        |    2 +-
 include/target/target_core_tmr.h               |   52 +-
 include/target/target_core_transport.h         |    4 +
 27 files changed, 4151 insertions(+), 189 deletions(-)
 create mode 100644 drivers/target/target_core_stat.c
 create mode 100644 drivers/target/target_core_stat.h
 create mode 100644 drivers/target/tcm_loop/Kconfig
 create mode 100644 drivers/target/tcm_loop/Makefile
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_core.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c

-- 
1.7.4.1
