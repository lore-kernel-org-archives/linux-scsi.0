From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.20-rc1
Date: Fri, 20 Feb 2015 15:23:55 -0800
Message-ID: <1424474635.1477.41.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target updates for v3.20-rc1 code.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

A heads up that you'll hit two merge conflicts as reported by SFR in
linux-next recently within drivers/vhost/scsi.c code.

The first is a conflict with a pre-merge window bug-fix in commit
46243860 that is not included in target-pending/for-next:

  vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

The resolution should be obvious for this one.

http://marc.info/?l=linux-next&m=142285892408065&w=2

The second is a conflict with Al's recent tree-wide conversion to use
copy_from_user() in commit 57dd8a073:

  vhost: vhost_scsi_handle_vq() should just use copy_from_user()

For this, please use commit 09b13fa8c included in this PULL request:

  vhost/scsi: Add ANY_LAYOUT support in vhost_scsi_handle_vq

http://marc.info/?l=linux-next&m=142346903105188&w=2

Beyond those two minor conflicts, the highlights this round include:

  - Update vhost-scsi to support F_ANY_LAYOUT using mm/iov_iter.c logic, and
    signal VERSION_1 support (MST + Viro + nab)
  - Fix iscsi/iser-target to remove problematic active_ts_set usage (Gavin Guo)
  - Update iscsi/iser-target to support multi-sequence sendtargets (Sagi)
  - Fix original PR_APTPL_BUF_LEN 8k size limitation (Martin Svec)
  - Add missing WRITE_SAME end-of-device sanity check (Bart)
  - Check for LBA + sectors wrap-around in sbc_parse_cdb() (nab)
  - Other various minor SPC/SBC compliance fixes based upon Ronnie Sahlberg
    test suite (nab)

Thank you,

--nab

Andy Shevchenko (2):
  tcm_qla2xxx: print port name via %*phC
  iscsi-target: use '%*ph' specifier to dump hex buffer

Dan Carpenter (1):
  vhost/scsi: potential memory corruption

Nicholas Bellinger (19):
  vhost/scsi: Convert completion path to use copy_to_iter
  vhost/scsi: Fix incorrect early vhost_scsi_handle_vq failures
  vhost/scsi: Change vhost_scsi_map_to_sgl to accept iov ptr + len
  vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping prerequisites
  vhost/scsi: Add ANY_LAYOUT support in vhost_scsi_handle_vq
  vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
  vhost/scsi: Drop left-over scsi_tcq.h include
  vhost/scsi: Global tcm_vhost -> vhost_scsi rename
  iscsi-target: Drop problematic active_ts_list usage
  target: Fix PR_APTPL_BUF_LEN buffer size limitation
  iscsi-target: Avoid IN_LOGOUT failure case for iser-target
  target: Add missing WRITE_SAME end-of-device sanity check
  target: Check for LBA + sectors wrap-around in sbc_parse_cdb
  target: Fail I/O with PROTECT bit when protection is unsupported
  target: Perform PROTECT sanity checks for WRITE_SAME
  target: Add sanity checks for DPO/FUA bit usage
  target: Fail WRITE_SAME w/ UNMAP=1 when emulate_tpws=0
  target: Fail UNMAP when emulate_tpu=0
  target: Set LBPWS10 bit in Logical Block Provisioning EVPD

Nicholas Mc Guire (1):
  ib_srpt: wait_for_completion_timeout does not return negative status

Rasmus Villemoes (1):
  iser-target: Remove duplicate function names

Sagi Grimberg (8):
  iscsi-target: Move iscsi_target_[core,stat].h under linux include
  iser-target: Fix sparse warning
  iser-target: Fix typo in isert_put_text_rsp
  iser-target: Use WQ_UNBOUND for completion workqueue
  iscsi-target: Introduce session_get_next_ttt
  iscsi-target: Don't over-allocate sendtargets text resp buffer
  iser-target: Fix wrong allocation in the case of an empty text message
  iscsi/iser-target: Support multi-sequence sendtargets text response

 drivers/infiniband/ulp/isert/ib_isert.c           |   46 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c             |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |    4 +-
 drivers/target/iscsi/iscsi_target.c               |  105 +-
 drivers/target/iscsi/iscsi_target_auth.c          |    2 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |   17 +-
 drivers/target/iscsi/iscsi_target_core.h          |  883 -----------------
 drivers/target/iscsi/iscsi_target_datain_values.c |    2 +-
 drivers/target/iscsi/iscsi_target_device.c        |    2 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |    6 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |    2 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |    2 +-
 drivers/target/iscsi/iscsi_target_login.c         |    4 +-
 drivers/target/iscsi/iscsi_target_nego.c          |    2 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |    2 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |    2 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |    2 +-
 drivers/target/iscsi/iscsi_target_stat.c          |    4 +-
 drivers/target/iscsi/iscsi_target_stat.h          |   64 --
 drivers/target/iscsi/iscsi_target_tmr.c           |    2 +-
 drivers/target/iscsi/iscsi_target_tpg.c           |    2 +-
 drivers/target/iscsi/iscsi_target_tq.c            |   30 +-
 drivers/target/iscsi/iscsi_target_util.c          |   12 +-
 drivers/target/iscsi/iscsi_target_util.h          |    1 -
 drivers/target/target_core_file.c                 |    5 +
 drivers/target/target_core_iblock.c               |    5 +
 drivers/target/target_core_pr.c                   |   25 +-
 drivers/target/target_core_sbc.c                  |  140 ++-
 drivers/target/target_core_spc.c                  |    2 +-
 drivers/vhost/scsi.c                              | 1068 +++++++++++----------
 include/target/iscsi/iscsi_target_core.h          |  897 +++++++++++++++++
 include/target/iscsi/iscsi_target_stat.h          |   64 ++
 include/target/iscsi/iscsi_transport.h            |    2 +-
 include/target/target_core_base.h                 |    2 +-
 34 files changed, 1776 insertions(+), 1636 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_core.h
 delete mode 100644 drivers/target/iscsi/iscsi_target_stat.h
 create mode 100644 include/target/iscsi/iscsi_target_core.h
 create mode 100644 include/target/iscsi/iscsi_target_stat.h
