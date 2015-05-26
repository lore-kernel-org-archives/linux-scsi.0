From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/4] target: Eliminate se_port + t10_alua_tg_pt_gp_member
Date: Tue, 26 May 2015 06:57:21 +0000
Message-ID: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is v2 series with HCH's recent changes to go ahead and drop
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

The changes since -v1 include:

  - Move ->lun_se_dev assignments under se_device->se_port_lock
  - All proper call_rcu() in backend drivers to allow for read-side
    critical se_device RCU to complete
  - Add se_device->hba_index to clean up RCU dereferences within
    scsi_port_show_attr_inst() + scsi_tgt_port_show_attr_inst()
  - Add various rcu_dereference and lockless_dereference RCU notation

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
 drivers/target/sbp/sbp_target.c              |   2 +-
 drivers/target/target_core_alua.c            | 393 ++++++++++-----------------
 drivers/target/target_core_alua.h            |  14 +-
 drivers/target/target_core_configfs.c        |  11 +-
 drivers/target/target_core_device.c          | 205 +++-----------
 drivers/target/target_core_fabric_configfs.c |  32 +--
 drivers/target/target_core_file.c            |  11 +-
 drivers/target/target_core_iblock.c          |  10 +-
 drivers/target/target_core_internal.h        |  12 +-
 drivers/target/target_core_pr.c              |  50 ++--
 drivers/target/target_core_pscsi.c           |  11 +-
 drivers/target/target_core_rd.c              |  10 +-
 drivers/target/target_core_spc.c             |  48 ++--
 drivers/target/target_core_stat.c            | 374 ++++++++++---------------
 drivers/target/target_core_tpg.c             | 112 +++++---
 drivers/target/target_core_transport.c       |  46 +---
 drivers/target/target_core_user.c            |  11 +-
 drivers/target/target_core_xcopy.c           |  17 +-
 drivers/target/tcm_fc/tfc_conf.c             |   5 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |   5 +-
 drivers/vhost/scsi.c                         |   4 +-
 drivers/xen/xen-scsiback.c                   |   5 +-
 include/target/target_core_base.h            |  77 +++---
 include/target/target_core_fabric.h          |   3 +-
 29 files changed, 585 insertions(+), 912 deletions(-)

-- 
1.9.1
