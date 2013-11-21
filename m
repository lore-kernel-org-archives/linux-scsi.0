From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.13-rc1
Date: Thu, 21 Nov 2013 10:42:28 -0800
Message-ID: <1385059348.4307.93.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target updates for the v3.13-rc1 merge window.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

A heads up that you'll run into a small conflict between commit
c9e8d128f and commit 5e9dd373 (already upstream) that allows
lib/percpu-refcount.c symbols to be used by external modules.  Please
resolve using the latter commit.

So aside from that minor bit, things have been quiet this round with
mostly bugfixes, percpu conversions, and other minor iscsi-target
conformance testing changes.

The highlights include:

  - Add demo_mode_discovery attribute for iscsi-target (Thomas)
  - Convert tcm_fc(FCoE) to use percpu-ida pre-allocation
  - Add send completion interrupt coalescing for ib_isert
  - Convert target-core to use percpu-refcounting for se_lun
  - Fix mutex_trylock usage bug in iscsit_increment_maxcmdsn 
  - tcm_loop updates (Hannes)
  - target-core ALUA cleanups + prep for v3.14 SCSI Referrals
    support. (Hannes)

v3.14 is currently shaping to be a busy development cycle in target
land, with initial support for T10 Referrals and T10 DIF currently on
the roadmap.

Thank you,

--nab

Andy Grover (6):
  target: Remove TF_CIT_TMPL macro
  target/iscsi: Remove iscsi dereferencing macros
  target/iscsi: Remove macros that contain typecasts
  target/qla2xxx: Remove QLA_TPG_ATTRIB macro
  target: Pass through I/O topology for block backstores
  target: Core does not need blkdev.h

Eric Seppanen (2):
  iscsi-target: fix extract_param to handle buffer length corner case
  iscsi-target: chap auth shouldn't match username with trailing
    garbage

Hannes Reinecke (11):
  tcm_loop: Check for valid hba in tcm_loop_drop_nexus()
  tcm_loop: Implement transport offline
  tcm_loop: separate out tcm_loop_issue_tmr
  tcm_loop: TCQ and command abort support
  tcm_loop: Implement target reset
  target core: rename (ex,im)plict -> (ex,im)plicit
  target_core_alua: spellcheck
  target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
  target_core_alua: Store supported ALUA states
  target_core_alua: Make supported states configurable
  target_core_configfs: split up ALUA supported states

Nicholas Bellinger (15):
  tcm_fc: Convert to per-cpu command map pre-allocation of ft_cmd
  ib_isert: Add support for completion interrupt coalescing
  iscsi-target: Do not generate REJECTs for zero-length DataOUT
  percpu-refcount: Add EXPORT_SYMBOL to use percpu_ref from modules
  target: Add percpu refcounting for se_lun access
  target: Drop left-over se_lun->lun_cmd_list shutdown code
  target: Add per device xcopy_lun for copy offload I/O
  iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
  ib_isert: Avoid duplicate iscsit_increment_maxcmdsn call
  iscsi-target: Reject unsupported multi PDU text command sequence
  target: Fix delayed Task Aborted Status (TAS) handling bug
  target: Convert se_device statistics to atomic_long_t
  iscsi-target: Convert iscsi_session statistics to atomic_long_t
  iscsi-target: Do not reject non-immediate CmdSNs exceeding MaxCmdSN
  iscsi-target: Expose default_erl as TPG attribute

Nick Swenson (1):
  percpu_ida: Removing unused arguement from alloc_local_tag

Randy Dunlap (1):
  percpu-refcount: Add percpu-refcount.o to obj-y

Thomas Glanzmann (3):
  iscsi-target: Add new TPG attribute
  target: Export symbol core_tpg_check_initiator_node_acl
  iscsi-target: Implement demo_mode_discovery logic

Vu Pham (1):
  iser-target: Avoid using FRMR for single dma entry requests

 Documentation/target/tcm_mod_builder.py        |   18 +-
 drivers/infiniband/ulp/isert/ib_isert.c        |   99 +++++++---
 drivers/infiniband/ulp/isert/ib_isert.h        |    6 +
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   10 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |   56 +++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h             |    2 -
 drivers/target/iscsi/iscsi_target.c            |   90 ++++-----
 drivers/target/iscsi/iscsi_target_auth.c       |    7 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   86 +++++----
 drivers/target/iscsi/iscsi_target_core.h       |   34 ++--
 drivers/target/iscsi/iscsi_target_device.c     |    6 +-
 drivers/target/iscsi/iscsi_target_erl0.c       |   12 +-
 drivers/target/iscsi/iscsi_target_login.c      |   17 +-
 drivers/target/iscsi/iscsi_target_nego.c       |   10 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c |    5 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.h |    3 +-
 drivers/target/iscsi/iscsi_target_stat.c       |   22 ++-
 drivers/target/iscsi/iscsi_target_tpg.c        |   42 +++-
 drivers/target/iscsi/iscsi_target_tpg.h        |    2 +
 drivers/target/iscsi/iscsi_target_util.c       |   20 +-
 drivers/target/loopback/tcm_loop.c             |  242 +++++++++++++++++++----
 drivers/target/loopback/tcm_loop.h             |    6 +
 drivers/target/sbp/sbp_target.c                |   18 +-
 drivers/target/target_core_alua.c              |  150 ++++++++-------
 drivers/target/target_core_alua.h              |   33 ++--
 drivers/target/target_core_configfs.c          |  123 ++++++++++--
 drivers/target/target_core_device.c            |   35 ++--
 drivers/target/target_core_fabric_configfs.c   |   38 ++--
 drivers/target/target_core_file.c              |    2 +-
 drivers/target/target_core_iblock.c            |   43 +++++
 drivers/target/target_core_internal.h          |    4 +-
 drivers/target/target_core_pr.c                |   24 +--
 drivers/target/target_core_rd.c                |    1 -
 drivers/target/target_core_sbc.c               |   12 +-
 drivers/target/target_core_spc.c               |   17 +-
 drivers/target/target_core_stat.c              |   16 +-
 drivers/target/target_core_tmr.c               |    4 +-
 drivers/target/target_core_tpg.c               |   41 ++--
 drivers/target/target_core_transport.c         |  244 ++----------------------
 drivers/target/target_core_ua.h                |    2 +-
 drivers/target/target_core_xcopy.c             |   19 +-
 drivers/target/tcm_fc/tcm_fc.h                 |    1 +
 drivers/target/tcm_fc/tfc_cmd.c                |   18 +-
 drivers/target/tcm_fc/tfc_conf.c               |   18 +-
 drivers/target/tcm_fc/tfc_sess.c               |    3 +-
 drivers/usb/gadget/tcm_usb_gadget.c            |   18 +-
 drivers/vhost/scsi.c                           |   18 +-
 include/target/target_core_backend.h           |    5 +
 include/target/target_core_base.h              |   84 ++++----
 include/target/target_core_configfs.h          |    1 -
 include/target/target_core_fabric.h            |    2 +
 lib/Makefile                                   |    4 +-
 lib/percpu-refcount.c                          |    3 +
 lib/percpu_ida.c                               |    5 +-
 54 files changed, 1012 insertions(+), 789 deletions(-)
