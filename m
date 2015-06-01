From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 0/4] target: Eliminate se_port + t10_alua_tg_pt_gp_member
Date: Mon,  1 Jun 2015 08:21:12 +0000
Message-ID: <1433146876-20188-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is v3 series with HCH's recent changes to go ahead and drop
all se_port + t10_alua_tg_pt_gp_member usage within target-core in
favor of direct se_lun pointer dereference.

This includes the original patch + minor fixes, along with two other
improvements for killing off se_lun->lun_sep_lock via RCU pointer
access, and converting the remaining se_lun->lun_active busy-wait
special cases to existing percpu se_lun->lun_ref access.

Also included in the series is a recently discussed change to go
ahead and drop an unnecessary core_tpg_register() parameter, and
all associated target_core_fabric_ops forward declartions within
fabric driver code.

The series has been updated to follow Paul's recent comments for
RCU notiation using rcu_dereference_check() + rcu_dereference_raw()
for cases where dereference occurs outside of rcu_read_lock(),
with an external lock or reference already held.

The code is now sparse clean.

The changes since -v2 include:

  - Convert tpg_virt_lun0->lun_se_dev in spc_emulate_inquiry()
    to use rcu_access_pointer()
  - Convert se_lun->lun_se_dev in ALUA attribute code to use
    rcu_dereference_raw() w/ configfs reference comment
  - Convert se_lun->lun_se_dev in TPG remove lun code to use
    rcu_dereference_raw() w/ configfs reference comment
  - Convert se_lun->lun_se_dev in TPG add_node_to_devs() code to use
    rcu_dereference_check() w/ se_portal_gorup->tpg_lun_mutex
  - Convert se_lun->lun_se_dev in transport_lookup_cmd_lun() to use
    rcu_dereference_raw() w/ configfs reference comment
  - Convert se_lun->lun_se_dev in transport_lookup_tmr_lun() to use
    rcu_dereference_raw() w/ lun_ref FIXME
  - Convert se_lun->lun_se_dev in core_disable_device_list_for_node()
    to use rcu_dereference_raw() w/ configfs reference comment
  - Convert se_lun->lun_se_dev in core_dev_add_initiator_node_lun_acl()
    to use rcu_dereference_raw() w/ configfs reference comment
  - Convert se_lun->lun_se_dev in sbp_update_unit_directory() to use
    rcu_dereference_raw() w/ configfs reference comment
  - Adding missing sanity check in core_tpg_register() for
    se_tpg->se_tpg_tfo check + special case discovery usage comment

Please review.

--nab

Christoph Hellwig (1):
  target: Subsume se_port + t10_alua_tg_pt_gp_member into se_lun

Nicholas Bellinger (3):
  target: Drop lun_sep_lock for se_lun->lun_se_dev RCU usage
  target: Drop se_lun->lun_active for existing percpu lun_ref
  target: Drop unnecessary core_tpg_register TFO parameter

 drivers/infiniband/ulp/srpt/ib_srpt.c        |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   9 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   3 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   8 +-
 drivers/target/loopback/tcm_loop.c           |   5 +-
 drivers/target/sbp/sbp_target.c              |   9 +-
 drivers/target/target_core_alua.c            | 403 +++++++++++----------------
 drivers/target/target_core_alua.h            |  14 +-
 drivers/target/target_core_configfs.c        |  11 +-
 drivers/target/target_core_device.c          | 226 ++++-----------
 drivers/target/target_core_fabric_configfs.c |  32 +--
 drivers/target/target_core_file.c            |  11 +-
 drivers/target/target_core_iblock.c          |  10 +-
 drivers/target/target_core_internal.h        |  12 +-
 drivers/target/target_core_pr.c              |  57 ++--
 drivers/target/target_core_pscsi.c           |  11 +-
 drivers/target/target_core_rd.c              |  10 +-
 drivers/target/target_core_spc.c             |  48 ++--
 drivers/target/target_core_stat.c            | 374 ++++++++++---------------
 drivers/target/target_core_tpg.c             | 132 ++++++---
 drivers/target/target_core_transport.c       |  46 +--
 drivers/target/target_core_user.c            |  11 +-
 drivers/target/target_core_xcopy.c           |  17 +-
 drivers/target/tcm_fc/tfc_conf.c             |   5 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |   5 +-
 drivers/vhost/scsi.c                         |   4 +-
 drivers/xen/xen-scsiback.c                   |   5 +-
 include/target/target_core_base.h            |  77 +++--
 include/target/target_core_fabric.h          |   3 +-
 29 files changed, 638 insertions(+), 924 deletions(-)

-- 
1.9.1
