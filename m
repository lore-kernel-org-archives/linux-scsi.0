From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 00/10] target: se_node_acl + se_lun RCU conversions
Date: Tue, 26 May 2015 06:25:20 +0000
Message-ID: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is -v3 series for converting LIO target se_node_acl + se_lun
mapping tables from fixed size arrays to dynamic RCU hlist_heads.

This turns fast-path I/O into a lock-less RCU reader using existing
percpu based se_lun->lun_ref logic, and converts the RCU updater
path to allow for an arbitrary number of LUNs for both types of
mappings within target-core.

As per this afternoon's email thread, the se_dev_entry->pr_comp
has been left in place for se_dev_entry shutdown within patch #1.
This completion is still required in order to prevent the configfs
se_lun_acl->se_lun_group from being removed from out below the
core_scsi3_lunacl_depend_item() caller during the special-case PR
ALL_TG_PT=1 registration handling.

The changes based on -v2 series feedback from HCH & Co include:

  - Remove unused se_dev_entry->se_node_acl
  - Drop unnecessary check in lunacl_undepend_item
  - target: Drop bogus mutex_unlock in core_disable_device_list_for_node
  - Drop left-over se_lun->lun_status
  - target: Rename ->pr_regs to ->deve_flags + add bit definitions
  - target: Convert se_dev_entry stats to atomic_long_t
  - Avoid unnecessary PR target_nacl_find_deve() lookup in registration
  - Add se_lun->lun_index for RCU dev->dev_index usage in stat.c
  - Add various rcu_dereference and lockless_dereference RCU notation

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
 drivers/target/target_core_alua.c            |   2 +-
 drivers/target/target_core_configfs.c        |   6 +-
 drivers/target/target_core_device.c          | 477 +++++++++++----------------
 drivers/target/target_core_fabric_configfs.c |  75 ++---
 drivers/target/target_core_internal.h        |  17 +-
 drivers/target/target_core_pr.c              | 221 +++++++------
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
 20 files changed, 665 insertions(+), 885 deletions(-)

-- 
1.9.1
