From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Fri, 27 Mar 2015 08:04:50 +0000
Message-ID: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36312 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbC0IF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:05:59 -0400
Received: by obbld8 with SMTP id ld8so13547760obb.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:05:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Hannes, HCH, & Sagi,

Here is an initial pass at the conversion of se_node_acl->device_list[]
to use RCU protected pointers for se_lun fast-path lookup code.

The big advantage with RCU is that transport_lookup_cmd_lun() can now
run completely lock-less using existing per-cpu se_lun->lun_ref logic.

Currently the new se_node_acl->lun_entry_hlist is still using an array
of pointers allocated at se_node_acl creation time.  The next step on
my end is to convert the entries to mempool allocation + rcu_head ->
call_rcu() asynchronous release.  Beyond that, RCU hlist support for
both NodeACL MappedLUN and TPG LUN tables is the final goal.

Some of the more interesting conversions so far are in target_core_pr.c
code for PROUT operations that lookup remote I_T LUNs and take configfs
dependencies.  This includes a new se_dev_entry->pr_ref to handle the
REGISTER w/ I_PORT descriptors + REGISTER_AND_MOVE special cases.

The series is broken up for review, and also includes a struct mutex
conversion of existing se_node_acl and se_portal_group LUN locks to
simplify a number of existing codepaths.

There are still a number of outstanding FIXMEs to address, and at this
point the series is stable enough to function with CONFIG_PROVE_RCU=y.
However, it still needs alot more testing with active I/O shutdown and
complex PR use cases.

Along with other cleanups, the target_* prefix rename discussed at LSF
is also included at the series end.

Please have a look.

--nab

Nicholas Bellinger (22):
  target: Convert transport_lookup_*_lun to RCU reader
  target: Convert enable/disable ->device_list to RCU updater
  target/device: Convert se_node_acl->device_list access to RCU reader
  target/configfs: Convert mappedlun link/unlink to RCU reader
  target/configfs: Convert SCSI MIB attrs to RCU reader
  target/spc: Convert REPORT_LUN + MODE_SENSE to RCU reader
  target/pscsi: Convert MODE_SENSE special case to RCU reader
  target/pr: Convert se_dev_entry to percpu-refcount for RCU
  target/pr: Convert registration check to RCU pointer
  target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
  target: Convert UNIT_ATTENTION logic to RCU reader
  target: Convert se_tpg->tpg_lun_lock to ->tpg_lun_mutex
  target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
  target: Convert se_node_acl->lun_entry_lock to ->lun_entry_mutex
  target: Convert core_tpg_deregister to use list splice
  target: Drop se_lun->lun_acl_list
  target: Drop core_tpg_clear_object_luns
  target: Rename TPG initiator_node_acl to target_* prefix
  target: Rename TPG register/deregister to target_* prefix
  target: Rename LUN lookup/add/remove to target_* prefix
  target: Rename se_node_acl->lun_entry_hlist to target_* prefix
  target: Rename se_port/se_device export to target_* prefix

 drivers/infiniband/ulp/srpt/ib_srpt.c        |  15 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  22 +-
 drivers/target/iscsi/iscsi_target.c          |  10 +-
 drivers/target/iscsi/iscsi_target_configfs.c |  17 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   4 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |  12 +-
 drivers/target/loopback/tcm_loop.c           |  14 +-
 drivers/target/sbp/sbp_target.c              |  34 ++-
 drivers/target/target_core_configfs.c        |   6 +-
 drivers/target/target_core_device.c          | 295 ++++++++++++++-------------
 drivers/target/target_core_fabric_configfs.c |  29 +--
 drivers/target/target_core_internal.h        |  24 +--
 drivers/target/target_core_pr.c              | 213 +++++++++++--------
 drivers/target/target_core_pscsi.c           |  14 +-
 drivers/target/target_core_spc.c             |  28 ++-
 drivers/target/target_core_stat.c            | 168 +++++++--------
 drivers/target/target_core_tpg.c             | 244 ++++++++++------------
 drivers/target/target_core_transport.c       |  24 +--
 drivers/target/target_core_ua.c              |  35 ++--
 drivers/target/tcm_fc/tfc_conf.c             |  16 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |  22 +-
 drivers/vhost/scsi.c                         |  18 +-
 drivers/xen/xen-scsiback.c                   |   8 +-
 include/target/target_core_base.h            |  23 +--
 include/target/target_core_fabric.h          |  21 +-
 25 files changed, 678 insertions(+), 638 deletions(-)

-- 
1.9.1

