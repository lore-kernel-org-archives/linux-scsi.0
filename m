From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 0/9] target: Save memory on unused se_dev_entrys and se_luns
Date: Mon, 10 Mar 2014 15:45:44 -0700
Message-ID: <1394491553-3939-1-git-send-email-agrover@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi nab, hch, and all,

This patchset reduces the amount of memory for se_dev_entry and se_lun
arrays by waiting to allocate array members, and includes some related
simplification patches too. This is a rework of a few patches I submitted
in December in a larger series, but keeping it simple by sticking with
fixed-size arrays for device_list and tpg_lun_list for now.

Testing: created and removed luns and mapped luns, worked ok.

Changes in v2:
  Added patches 1-2, which ensure locking around the arrays
  Added patch 9, refactors enable_device_list_for_node
  Patch 7/6 folded into series

Regards -- Andy

Andy Grover (9):
  target: Add locking to some accesses to nacl.device_list
  target: Don't unlock/relock tpg_lun_lock in loop in add_node_to_devs
  target: Allocate se_dev_entrys in device list only when used
  target: core_tpg_post_dellun can return void
  target: Change core_dev_del_lun to take a se_lun instead of
    unpacked_lun
  target: Rename core_tpg_post_dellun to remove_lun
  target: Allocate se_luns only when used
  target: Remove core_tpg_release_virtual_lun0 function
  target: Refactor core_enable_device_list_for_node

 drivers/target/sbp/sbp_target.c              |   6 +-
 drivers/target/target_core_device.c          | 311 +++++++++++++--------------
 drivers/target/target_core_fabric_configfs.c |  35 +--
 drivers/target/target_core_internal.h        |   9 +-
 drivers/target/target_core_pr.c              |  40 +++-
 drivers/target/target_core_spc.c             |   2 +-
 drivers/target/target_core_tpg.c             | 189 ++++------------
 drivers/target/target_core_ua.c              |   3 +
 include/target/target_core_base.h            |  17 +-
 9 files changed, 246 insertions(+), 366 deletions(-)

-- 
1.8.5.3
