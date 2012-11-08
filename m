From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
Date: Thu,  8 Nov 2012 20:07:15 +0000
Message-ID: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series for-3.8 adds support for proper WRITE_SAME w/ UNMAP=0 emulation
for IBLOCK device backends to follow MKP's WRITE_SAME patches that have
been merged for v3.7-rc1.

Currently it uses a bio_add_page() call for each sector in order to allow
scatterlist w/ page offsets to work, as blkdev_issue_write_same() currently
assumes underlying hw support + zero page offset.

So far it has been tested on target-pending/for-next code with iscsi-target
and tcm_loop fabric ports.

Please review,

--nab

Nicholas Bellinger (3):
  target/sbc: Make WRITE_SAME check differentiate between UNMAP=[1,0]
  target: Add max_write_same_len device attribute
  target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation support

 drivers/target/target_core_configfs.c |    4 ++
 drivers/target/target_core_device.c   |   11 +++++
 drivers/target/target_core_iblock.c   |   78 +++++++++++++++++++++++++++++---
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_sbc.c      |   19 +++-----
 drivers/target/target_core_spc.c      |    8 +++-
 include/target/target_core_base.h     |    4 ++
 7 files changed, 104 insertions(+), 21 deletions(-)

-- 
1.7.2.5
