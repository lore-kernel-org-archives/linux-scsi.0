From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 0/9] target: Save memory on unused se_dev_entrys and se_luns
Date: Mon, 23 Jun 2014 16:55:29 -0700
Message-ID: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbaFWXzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2014 19:55:44 -0400
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
1.9.3

