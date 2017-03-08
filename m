From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2 0/5] Dynamic growing data area support
Date: Wed,  8 Mar 2017 16:45:38 +0800
Message-ID: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

These are based on Mike's leatest tcmu patches.

Changed for V2:
- The [PATCHv2 1/5] just fixes some small spelling and other mistakes.
  And as the initial patch, here sets cmd area to 8M and data area to
  1G(1M fixed and 1023M growing)

- The [PATCHv2 2/5] is a new one, adding global data block pool support.
  The max total size of the pool is 2G and all the targets will get
  growing blocks from here.
  Test this using multi-targets at the same time.

- The [PATCHv2 3/5] changed nothing, respin it to avoid the conflict.

- The [PATCHv2 4/5] and [PATCHv2 5/5] are new ones.


Xiubo Li (5):
  target/user: Add dynamic growing data area feature support
  target/user: Add global data block pool support
  target/user: Fix possible overwrite of t_data_sg's last iov[]
  target/user: Fix wrongly calculating of the base_command_size
  target/user: Clean up tcmu_queue_cmd_ring

 drivers/target/target_core_user.c | 573 +++++++++++++++++++++++++++++++-------
 1 file changed, 478 insertions(+), 95 deletions(-)

-- 
1.8.3.1
