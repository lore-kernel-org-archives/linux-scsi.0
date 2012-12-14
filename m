From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.8-rc1
Date: Fri, 14 Dec 2012 15:53:42 -0800
Message-ID: <1355529222.31680.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target updates for v3.8-rc1 merge window code.  Please go
ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Just a heads up that there is a minor merge conflict that you'll
encounter in target_handle_task_attr() code, that sfr has been carrying
a fix for recently within -next.  After dropping the HEAD section, the
resolution should look like:

http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=50f966ab0a8630cacb46bb382cd2822a5c1448ac

It has been a very busy development cycle this time around in target
land, with the highlights including:

 - Kill struct se_subsystem_dev, in favor of direct se_device usage (hch)
 - Simplify reservations code by combining SPC-3 + SCSI-2 support 
   for virtual backends only (hch)
 - Simplify ALUA code for virtual only backends, and remove left
   over abstractions (hch)
 - Pass sense_reason_t as return value for I/O submission path (hch)
 - Refactor MODE_SENSE emulation to allow for easier addition of
   new mode pages. (roland)
 - Add emulation of MODE_SELECT (roland)
 - Fix bug in handling of ExpStatSN wrap-around (steve)
 - Fix bug in TMR ABORT_TASK lookup in qla2xxx target (steve)
 - Add WRITE_SAME w/ UNMAP=0 support for IBLOCK backends (nab)
 - Convert ib_srpt to use modern target_submit_cmd caller +
   drop legacy ioctx->kref usage (nab)
 - Convert ib_srpt to use modern target_submit_tmr caller (nab)
 - Add link_magic for fabric allow_link destination target_items
   for symlinks within target_core_fabric_configfs.c code (nab)
 - Allocate pointers in instead of full structs for
   config_group->default_groups (sebastian)
 - Fix 32-bit highmem breakage for FILEIO (sebastian)

All told, hch was able to shave off another ~1K LOC by killing the
se_subsystem_dev abstraction, along with a number of PR + ALUA
simplifications.  Also, a nice patch by Roland is the refactoring of
MODE_SENSE handling, along with the addition of initial MODE_SELECT
emulation support for virtual backends.

Sebastian found a long-standing issue wrt to allocation of full
config_group instead of pointers for config_group->default_group[]
setup in a number of areas, which ends up saving memory with big
configurations.  He also managed to fix another long-standing BUG wrt to
broken 32-bit highmem support within the FILEIO backend driver.

Thank you again to everyone who contributed this round!

--nab

Andy Grover (1):
  target/iscsi_target: Add NodeACL tags for initiator group support

Chris Boot (2):
  sbp-target: use simple assignment in tgt_agent_rw_agent_state()
  sbp-target: fix error path in sbp_make_tpg()

Christoph Hellwig (11):
  target: kill struct se_subsystem_dev
  target: rename spc_ops
  target: move REPORT LUNS emulation to target_core_spc.c
  target/pscsi: call spc_emulate_report_luns directly
  target: provide generic sbc device type/revision helpers
  pscsi: fix REPORT LUNS handling
  target: kill dev->dev_task_attr_type
  target: simplify reservations code
  target: simplify alua support
  target: remove ->get_device_rev
  target: pass sense_reason as a return value

Dan Carpenter (1):
  target: update error handling for sbc_setup_write_same()

Fengguang Wu (1):
  target/pscsi: Make pscsi_configure_device + target_release_session
    static

Kees Cook (1):
  sbp-target: remove depends on CONFIG_EXPERIMENTAL

Nicholas Bellinger (14):
  target: Fix incorrect starting offset after MODE_SENSE refactoring
  target: Fix incorrect inversion of TPGS_EXPLICT_ALUA check
  target: Fix possible TFO->write_pending() sense_reason_t silent WRITE
    corruption
  target: Fix exception path pr_reg put regression for PR RELEASE
  target: Change sbc_emulate_noop to return sense_reason_t
  target/sbc: Seperate WRITE_SAME based on UNMAP flag in sbc_ops
  target: Add/check max_write_same_len device attribute + update block
    limits VPD
  target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation support
  target: Update copyright information to 2012
  target/iblock: Forward declare bio helpers
  target: Make spc_get_write_same_sectors return sector_t
  ib_srpt: Convert I/O path to target_submit_cmd + drop legacy
    ioctx->kref
  ib_srpt: Convert TMR path to target_submit_tmr
  target: Add link_magic for fabric allow_link destination target_items

Roland Dreier (8):
  iscsi-target: Use list_first_entry() where appropriate
  target: Refactor MODE SENSE emulation
  target: Implement mode page 0x1c, "Informational Exceptions"
  target: Add emulation for MODE SELECT
  iscsi-target: Fix potential deadlock on lock taken in timer
  iscsi-target: Always send a response before terminating iSCSI
    connection
  target: Clean up logic in transport_put_cmd()
  target: Clean up flow in transport_check_aborted_status()

Sachin Kamat (1):
  iscsi_target: Remove redundant null check before kfree

Sebastian Andrzej Siewior (6):
  target/configfs: allocate pointers instead of full struct for
    default_groups
  target/configfs: allocate only 6 slots for dev_cg->default_groups
  target/configfs: use kmalloc() instead of kzalloc() for default
    groups
  target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
  target/file: merge fd_do_readv() and fd_do_writev()
  iscsi-target: use kstrdup() for iscsi_param

Steve Hodgson (2):
  iscsi-target: Fix bug in handling of ExpStatSN ACK during u32
    wrap-around
  qla2xxx: Look up LUN for abort requests

Wei Yongjun (1):
  iscsit: use GFP_ATOMIC under spin lock

Yi Zou (1):
  target/tcm_fc: fix the lockdep warning due to inconsistent lock state

 drivers/infiniband/ulp/srpt/ib_srpt.c          |  178 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.h          |    1 -
 drivers/scsi/qla2xxx/qla_target.c              |   21 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |    4 +-
 drivers/target/iscsi/iscsi_target.c            |   84 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   28 +-
 drivers/target/iscsi/iscsi_target_core.h       |    2 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   11 +-
 drivers/target/iscsi/iscsi_target_erl2.c       |    2 +-
 drivers/target/iscsi/iscsi_target_login.c      |   18 +-
 drivers/target/iscsi/iscsi_target_nego.c       |   10 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tq.c         |    3 +-
 drivers/target/iscsi/iscsi_target_util.c       |    8 +-
 drivers/target/loopback/tcm_loop.h             |    1 -
 drivers/target/sbp/Kconfig                     |    2 +-
 drivers/target/sbp/sbp_target.c                |   24 +-
 drivers/target/target_core_alua.c              |  346 +++----
 drivers/target/target_core_alua.h              |    9 +-
 drivers/target/target_core_configfs.c          |  705 ++++----------
 drivers/target/target_core_device.c            |  710 ++++++--------
 drivers/target/target_core_fabric_configfs.c   |   37 +-
 drivers/target/target_core_fabric_lib.c        |    3 +-
 drivers/target/target_core_file.c              |  279 ++----
 drivers/target/target_core_file.h              |    2 +
 drivers/target/target_core_hba.c               |    9 +-
 drivers/target/target_core_iblock.c            |  501 +++++-----
 drivers/target/target_core_iblock.h            |    1 +
 drivers/target/target_core_internal.h          |   16 +-
 drivers/target/target_core_pr.c                | 1225 ++++++++++--------------
 drivers/target/target_core_pr.h                |   10 +-
 drivers/target/target_core_pscsi.c             |  349 +++-----
 drivers/target/target_core_pscsi.h             |    2 +-
 drivers/target/target_core_rd.c                |  126 +--
 drivers/target/target_core_rd.h                |    1 +
 drivers/target/target_core_sbc.c               |  185 ++--
 drivers/target/target_core_spc.c               |  572 ++++++++----
 drivers/target/target_core_stat.c              |  312 ++-----
 drivers/target/target_core_tmr.c               |    9 +-
 drivers/target/target_core_tpg.c               |   29 +-
 drivers/target/target_core_transport.c         |  673 ++++---------
 drivers/target/target_core_ua.c                |   20 +-
 drivers/target/target_core_ua.h                |    2 +-
 drivers/target/tcm_fc/tfc_sess.c               |    2 +-
 drivers/vhost/tcm_vhost.c                      |    4 -
 include/target/target_core_backend.h           |   49 +-
 include/target/target_core_base.h              |  212 ++---
 include/target/target_core_fabric.h            |   15 +-
 49 files changed, 2844 insertions(+), 3988 deletions(-)
