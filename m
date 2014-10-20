From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.18-rc2
Date: Mon, 20 Oct 2014 16:39:17 -0700
Message-ID: <1413848357.16343.35.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target updates for v3.18-rc2 code.  These where originally
destined for -rc1, but due to the combination of travel last week for
KVM Forum and my mistake of taking the three week merge window
literally, the pull request slipped..  Apologies for that.

A heads-up that you'll hit one minor conflict with scsi.git, that was
caught by sfr in linux-next here:

http://marc.info/?l=linux-next&m=141223868207635&w=2

Please go ahead and pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Things where reasonably quiet this round.  The highlights include:

  - New userspace backend driver (target_core_user.ko) by Shaohua Li
    and Andy Grover
  - A number of cleanups in target, iscsi-taret and qla_target code
    from Joern Engel
  - Fix an OOPs related to queue full handling with CHECK_CONDITION
    status from Quinn Tran
  - Fix to disable TX completion interrupt coalescing in iser-target,
    that was causing problems on some hardware
  - Fix for PR APTPL metadata handling with demo-mode ACLs

I'm most excited about the new backend driver that uses UIO + shared
memory ring to dispatch I/O and control commands into user-space.  This
was probably the most requested feature by users over the last couple of
years, and opens up a new area of development + porting of existing
user-space storage applications to LIO.  Thanks to Shaohua + Andy for
making this happen.

Also another honorable mention, a new Xen PV SCSI driver was merged via
the xen/tip.git tree recently, which puts us now at 10 target drivers in
upstream!  Thanks to David Vrabel + Juergen Gross for their work to get
this code merged.

Thank you,

--nab

Andreea-Cristina Bernat (1):
  tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Andy Grover (8):
  target: core_tpg_post_dellun can return void
  target: Change core_dev_del_lun to take a se_lun instead of
    unpacked_lun
  target: Remove core_tpg_release_virtual_lun0 function
  target: Remove unneeded check in sbc_parse_cdb
  uio: Export definition of struct uio_device
  target: Add documentation on the target userspace pass-through driver
  target: Add a user-passthrough backstore
  target/user: Recalculate pad size inside is_ring_space_avail()

Hannes Reinecke (1):
  tcm_loop: Fixup tag handling

Himangi Saraogi (1):
  target/configfs: Remove unnecessary null test

Joern Engel (20):
  iscsi-target: remove unused debug code
  iscsi-target: remove always-true conditions
  iscsi-target: simplify return statement
  iscsi-target: remove unnecessary check in iscsit_setup_np error path
  iscsi-target: use strlcpy in iscsit_collect_login_stats
  target: Fix possible memory leak in aptpl_metadata parsing
  target: Fix memory leak on error in target_fabric_make_mappedlun
  target: simplify target_fabric_make_lun error path
  target: fix pr_out length in iscsi_parse_pr_out_transport_id
  target: correctly handle match_int errors in FILEIO + PSCSI
  target: fix unused shift in core_scsi3_pri_report_capabilities
  target: simplify core_tmr_release_req()
  target: remove some smp_mb__after_atomic()s
  target: encapsulate smp_mb__after_atomic()
  target: simplify core_tmr_abort_task
  qla_target: remove unused parameter
  qla_target: make some global functions static
  qla_target: improve qlt_unmap_sg()
  qla_target: rearrange struct qla_tgt_prm
  qla_target: don't delete changed nacls

Nicholas Bellinger (5):
  iscsi-target: Drop duplicate __iscsi_target_login_thread check
  target/user: Fix up smatch warnings in tcmu_netlink_event
  target: Fix APTPL metadata handling for dynamic MappedLUNs
  target: Add force_pr_aptpl device attribute
  iser-target: Disable TX completion interrupt coalescing

Quinn Tran (1):
  target: Fix queue full status NULL pointer for
    SCF_TRANSPORT_TASK_SENSE

Rasmus Villemoes (1):
  target: target_core_ua_h: Add #define of include guard

Sagi Grimberg (1):
  iser-target: Fix smatch warning

Zach Brown (1):
  target/file: fix inclusive vfs_fsync_range() end

 Documentation/target/tcmu-design.txt         |  378 +++++++++
 drivers/infiniband/ulp/isert/ib_isert.c      |    6 +-
 drivers/scsi/qla2xxx/qla_target.c            |   35 +-
 drivers/scsi/qla2xxx/qla_target.h            |   12 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   11 +-
 drivers/target/Kconfig                       |    7 +
 drivers/target/Makefile                      |    1 +
 drivers/target/iscsi/iscsi_target.c          |    6 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   10 +-
 drivers/target/iscsi/iscsi_target_erl0.c     |    6 +-
 drivers/target/iscsi/iscsi_target_login.c    |    8 +-
 drivers/target/iscsi/iscsi_target_util.c     |    5 +-
 drivers/target/loopback/tcm_loop.c           |   29 +-
 drivers/target/target_core_alua.c            |   33 +-
 drivers/target/target_core_configfs.c        |   26 +-
 drivers/target/target_core_device.c          |   48 +-
 drivers/target/target_core_fabric_configfs.c |   13 +-
 drivers/target/target_core_fabric_lib.c      |    6 +-
 drivers/target/target_core_file.c            |   13 +-
 drivers/target/target_core_internal.h        |    6 +-
 drivers/target/target_core_pr.c              |  107 +--
 drivers/target/target_core_pr.h              |    2 +-
 drivers/target/target_core_pscsi.c           |   16 +-
 drivers/target/target_core_sbc.c             |    2 +-
 drivers/target/target_core_tmr.c             |   24 +-
 drivers/target/target_core_tpg.c             |   53 +-
 drivers/target/target_core_transport.c       |   27 +-
 drivers/target/target_core_ua.c              |   15 +-
 drivers/target/target_core_ua.h              |    1 +
 drivers/target/target_core_user.c            | 1167 ++++++++++++++++++++++++++
 drivers/target/tcm_fc/tfc_sess.c             |    2 +-
 drivers/uio/uio.c                            |   12 -
 include/linux/uio_driver.h                   |   12 +-
 include/target/target_core_base.h            |   17 +
 include/uapi/linux/Kbuild                    |    1 +
 include/uapi/linux/target_core_user.h        |  142 ++++
 36 files changed, 1941 insertions(+), 318 deletions(-)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 include/uapi/linux/target_core_user.h
