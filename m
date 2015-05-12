From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 00/12] target: TPG/NodeACL LUN table conversion to RCU hlist
Date: Tue, 12 May 2015 09:25:24 +0000
Message-ID: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This patch converts target-core from traditional fixed size arrays for
TPG LUN and NodeACL MappedLUNs tables to modern read-copy-update (RCU)
logic using hlist_head primitives.

This includes the changes necessary for performing se_dev_entry + se_lun
allocation + call_rcu() release within RCU updater path code, fast-path
conversion of transport_lookup_*_lun() to lock-less RCU reader using
existing percpu_ref, and a handful of fabric configfs and CDB emulation
related RCU reader changes.

It allows for an arbitrary number of entries per hlist_head, but for the
moment is still enforcing TRANSPORT_MAX_LUNS_PER_TPG following what
user-space expects.  It also converts non-fast path RCU updater code to
use blocking struct mutex instead of spinlocks for both hlist_heads.

Note that sbp-target is broken atm due to the way it's using se_lun
directly, and will be fixed up soon.

Please review.

--nab

Nicholas Bellinger (12):
  target: Convert se_node_acl->device_list[] to RCU hlist
  target: Convert REPORT_LUN + MODE_SENSE to RCU reader
  target/configfs: Convert mappedlun + SCSI MIBs to RCU reader
  target: Convert UNIT_ATTENTION logic to RCU reader
  target: Convert transport_lookup_*_lun to RCU reader
  target/pr: Convert se_dev_entry to kref for RCU
  target/pr: Convert registration check to RCU pointer
  target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
  target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
  target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
  target: Convert core_tpg_deregister to use list splice
  target: Drop unused se_lun->lun_acl_list

 drivers/target/iscsi/iscsi_target_tpg.c      |   2 -
 drivers/target/sbp/sbp_target.c              |  16 +-
 drivers/target/target_core_configfs.c        |   6 +-
 drivers/target/target_core_device.c          | 409 ++++++++++++---------------
 drivers/target/target_core_fabric_configfs.c |  65 +++--
 drivers/target/target_core_internal.h        |   9 +-
 drivers/target/target_core_pr.c              | 210 ++++++++------
 drivers/target/target_core_pscsi.c           |  17 +-
 drivers/target/target_core_spc.c             |  27 +-
 drivers/target/target_core_stat.c            | 180 ++++++------
 drivers/target/target_core_tpg.c             | 249 +++++-----------
 drivers/target/target_core_transport.c       |  20 +-
 drivers/target/target_core_ua.c              |  51 ++--
 drivers/target/tcm_fc/tfc_conf.c             |   4 +-
 drivers/xen/xen-scsiback.c                   |  27 +-
 include/target/target_core_base.h            |  31 +-
 include/target/target_core_fabric.h          |   1 -
 17 files changed, 633 insertions(+), 691 deletions(-)

-- 
1.9.1
