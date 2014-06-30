From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv3 0/8] target: Save memory on unused se_dev_entrys and se_luns
Date: Mon, 30 Jun 2014 16:39:39 -0700
Message-ID: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaF3Xjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 19:39:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

Hi nab, hch, and all,

This patchset reduces the amount of memory for se_dev_entry and se_lun
arrays by waiting to allocate array members until they are
created. This patch saves up to 261KB per TPG, and up to 65KB per
ACL. It also fixes a number of locking bugs around these data
structures.

Changes since v2, based on hch's review:
* Fix braces and add precondition checking in
  core_enable_device_list_for_node() in patch 2
* Move busy-loop outside of spinlock in 
  core_disable_device_list_for_node() in patch 3
* Merge patches 5 and 6

Against target-pending/for-next (3.16-rc2).

Thanks -- Regards -- Andy

Andy Grover (8):
  target: Add locking to some accesses to nacl.device_list
  target: Don't unlock/relock tpg_lun_lock in loop in add_node_to_devs
  target: Allocate se_dev_entrys in device list only when used
  target: core_tpg_post_dellun can return void
  target: Change core_dev_del_lun to take a se_lun instead of
    unpacked_lun
  target: Allocate se_luns only when used
  target: Remove core_tpg_release_virtual_lun0 function
  target: Refactor core_enable_device_list_for_node

 drivers/target/sbp/sbp_target.c              |   6 +-
 drivers/target/target_core_device.c          | 313 +++++++++++++--------------
 drivers/target/target_core_fabric_configfs.c |  35 +--
 drivers/target/target_core_internal.h        |   9 +-
 drivers/target/target_core_pr.c              |  40 +++-
 drivers/target/target_core_spc.c             |   2 +-
 drivers/target/target_core_tpg.c             | 189 +++-------------
 drivers/target/target_core_ua.c              |   3 +
 include/target/target_core_base.h            |  17 +-
 9 files changed, 248 insertions(+), 366 deletions(-)

-- 
1.9.3

