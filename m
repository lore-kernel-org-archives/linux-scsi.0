From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/9] target: se_node_acl + se_lun RCU conversions
Date: Fri, 22 May 2015 06:11:02 +0000
Message-ID: <1432275071-28882-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is -v2 series for converting LIO target se_node_acl + se_lun
mapping tables from fixed size arrays to dynamic RCU hlist_heads.

This turns fast-path I/O into a lock-less RCU reader using existing
percpu based se_lun->lun_ref logic, and converts the RCU updater
path to allow for an arbitrary number of LUNs for both types of
mappings within target-core.

This series also squashes a number of previous se_node_acl RCU
related changes into a single commit (#1) for easier review,
and to avoid potential bisect issues.

There have been a number of changes since -v1, including:

  - Mirror port->sep_rtpi in lun->lun_rtpi for RCU
  - Drop unnecessary synchronize_rcu() usage
  - Convert call_rcu() to kfree_rcu() usage
  - Move hlist_del_rcu head of rcu_assign_pointer in se_dev_entry
  - Drop unnecessary lookup deve in target_fabric_mappedlun_unlink()
  - Add target_lun_is_rdonly helper
  - Acquire lun_entry_mutex during core_disable_device_list_for_node
  - Drop TRANSPORT_LUNFLAGS_*_ACCESS usage
  - Pass se_dev_entry directly to core_disable_device_list_for_node
  - Convert sbp-target se_lun usage to use ->login_lun
  - Fix se_session dereference in spc_emulate_report_luns 
  - Fix testing for NULL instead of IS_ERR in fabric_make_lun()
  - Convert BUG_ON to EINVAL for wrong dynamic -> explicit ACL conversion 
  - Add missing hlist_del_rcu when swapping orig with new
  - Add HBA_FLAGS_INTERNAL_USE checks in add/remove lun

Please review.

--nab

Christoph Hellwig (1):
  target/pr: cleanup core_scsi3_pr_seq_non_holder

Nicholas Bellinger (8):
  target: Convert se_node_acl->device_list[] to RCU hlist
  target/pr: Use atomic bitop for se_dev_entry->pr_reg reservation check
  target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
  target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
  target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
  target: Convert core_tpg_deregister to use list splice
  target: Drop unused se_lun->lun_acl_list
  target: Only reset specific dynamic entries during lun_group creation

 drivers/target/iscsi/iscsi_target_tpg.c      |   2 -
 drivers/target/sbp/sbp_target.c              |  97 +++---
 drivers/target/sbp/sbp_target.h              |   2 +-
 drivers/target/target_core_configfs.c        |   6 +-
 drivers/target/target_core_device.c          | 452 +++++++++++----------------
 drivers/target/target_core_fabric_configfs.c |  75 +++--
 drivers/target/target_core_internal.h        |  17 +-
 drivers/target/target_core_pr.c              | 217 +++++++------
 drivers/target/target_core_pscsi.c           |   7 +-
 drivers/target/target_core_spc.c             |  18 +-
 drivers/target/target_core_stat.c            | 180 +++++------
 drivers/target/target_core_tpg.c             | 269 ++++------------
 drivers/target/target_core_transport.c       |  20 +-
 drivers/target/target_core_ua.c              |  51 ++-
 drivers/target/tcm_fc/tfc_conf.c             |   4 +-
 drivers/xen/xen-scsiback.c                   |  27 +-
 include/target/target_core_backend.h         |   2 +-
 include/target/target_core_base.h            |  38 +--
 include/target/target_core_fabric.h          |   1 -
 19 files changed, 634 insertions(+), 851 deletions(-)

-- 
1.9.1
