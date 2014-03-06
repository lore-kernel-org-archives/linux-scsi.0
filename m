From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/6] target: Save memory on unused se_dev_entrys and se_luns
Date: Thu,  6 Mar 2014 14:15:25 -0800
Message-ID: <1394144131-31499-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaCFWPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2014 17:15:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi nab and everyone,

This patchset reduces the amount of memory for se_dev_entry and se_lun
arrays by waiting to allocate array members, and includes some related
simplification patches too. This is a rework of a few patches I submitted
in December in a larger series, but keeping it simple by sticking with
fixed-size arrays for device_list and tpg_lun_list for now.

Testing: created and removed luns and mapped luns, worked ok.

Regards -- Andy

Andy Grover (6):
  target: Allocate se_dev_entrys in device list only when used
  target: core_tpg_post_dellun can return void
  target: Change core_dev_del_lun to take a se_lun instead of
    unpacked_lun
  target: Rename core_tpg_post_dellun to remove_lun
  target: Allocate se_luns only when used
  target: Remove core_tpg_release_virtual_lun0 function

 drivers/target/sbp/sbp_target.c              |   6 +-
 drivers/target/target_core_device.c          | 206 ++++++++++-----------------
 drivers/target/target_core_fabric_configfs.c |  25 ++--
 drivers/target/target_core_internal.h        |   9 +-
 drivers/target/target_core_spc.c             |   2 +-
 drivers/target/target_core_tpg.c             | 154 +++++---------------
 include/target/target_core_base.h            |  13 +-
 7 files changed, 136 insertions(+), 279 deletions(-)

-- 
1.8.5.3

