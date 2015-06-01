From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 00/10] target: se_node_acl + se_lun RCU conversions
Date: Mon,  1 Jun 2015 08:07:35 +0000
Message-ID: <1433146066-19798-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is -v4 series for converting LIO target se_node_acl + se_lun
mapping tables from fixed size arrays to dynamic RCU (read-copy-update)
hlist_heads.

This turns fast-path I/O into a lock-less RCU reader using existing
percpu based se_lun->lun_ref logic, and converts the RCU updater
path to allow for an arbitrary number of LUNs for both types of
mappings within target-core.

The series has been updated to follow Paul's recent comments for
RCU notiation using rcu_dereference_check() for cases where a
dereference occurs outside of rcu_read_lock(), with an external
lock or reference already held.  The code is now sparse clean.

This includes the following changes since -v3:

  - Convert se_dev_entry->se_lun usage in se_dev_entry updater path
    to use rcu_dereference_check() w/ se_node_acl->lun_entry_mutex
  - Convert se_dev_entry->se_lun_acl in ALUA for do_transition_tg_pt_work()
    to use rcu_dereference_check() w/ se_lun->lun_deve_lock
  - Convert se_dev_entry->se_lun in PR ALL_TG_PT=1 special case to
    use rcu_dereference_check() w/ se_dev_entry->pr_kref.refcount
  - Convert se_dev_entry->se_lun_acl in PR for lun_acl_*depend_item()
    to use rcu_dereference_check() w/ se_dev_entry->pr_kref.refcount

Please review.

--nab

Christoph Hellwig (1):
  target/pr: cleanup core_scsi3_pr_seq_non_holder

Nicholas Bellinger (9):
  target: Convert se_node_acl->device_list[] to RCU hlist
  target/pr: Use atomic bitop for se_dev_entry->deve_flags reservation
    check
  target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
  target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
  target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
  target: Convert core_tpg_deregister to use list splice
  target: Drop unused se_lun->lun_acl_list
  target: Only reset specific dynamic entries during lun_group creation
  target: Drop left-over se_lun->lun_status

 drivers/target/iscsi/iscsi_target_tpg.c      |   2 -
 drivers/target/sbp/sbp_target.c              |  97 +++---
 drivers/target/sbp/sbp_target.h              |   2 +-
 drivers/target/target_core_alua.c            |   3 +-
 drivers/target/target_core_configfs.c        |   6 +-
 drivers/target/target_core_device.c          | 480 +++++++++++----------------
 drivers/target/target_core_fabric_configfs.c |  75 ++---
 drivers/target/target_core_internal.h        |  17 +-
 drivers/target/target_core_pr.c              | 231 +++++++------
 drivers/target/target_core_pscsi.c           |   7 +-
 drivers/target/target_core_spc.c             |  18 +-
 drivers/target/target_core_stat.c            | 197 +++++------
 drivers/target/target_core_tpg.c             | 271 ++++-----------
 drivers/target/target_core_transport.c       |  20 +-
 drivers/target/target_core_ua.c              |  51 ++-
 drivers/target/tcm_fc/tfc_conf.c             |   4 +-
 drivers/xen/xen-scsiback.c                   |  27 +-
 include/target/target_core_backend.h         |   2 +-
 include/target/target_core_base.h            |  53 ++-
 include/target/target_core_fabric.h          |   1 -
 20 files changed, 680 insertions(+), 884 deletions(-)

-- 
1.9.1
