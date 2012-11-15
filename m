From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
Date: Thu, 15 Nov 2012 20:13:56 +0000
Message-ID: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This -v2 series for-3.8 adds support for proper WRITE_SAME w/ UNMAP=0 emulation
for IBLOCK device backends to follow MKP's WRITE_SAME client patches that have
been merged in v3.7-rc1.

Currently it uses a bio_add_page() call for each sector in order to allow
scatterlist w/ page offsets to work, as blkdev_issue_write_same() currently
assumes underlying hw support + zero page offset.

This -v2 includes the following changes requested by hch to v1:

 - Drop the SCF_WRITE_SAME_DISCARD flag
 - Add sbc_ops handler specific to WRITE_SAME w/ UNMAP=1
 - Move max_write_same_len sanity check from IBLOCK into sbc code
 - Add SGL check for single sector in iblock_execute_write_same()

I'm testing these changes now against iscsi-target + tcm_loop ports on
target-pending/for-next.  Please review.

Thanks!

--nab

Nicholas Bellinger (3):
  target/sbc: Seperate WRITE_SAME based on UNMAP flag in sbc_ops
  target: Add/check max_write_same_len device attribute + update block
    limits VPD
  target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation support

 drivers/target/target_core_configfs.c |    4 ++
 drivers/target/target_core_device.c   |   11 ++++
 drivers/target/target_core_iblock.c   |   91 ++++++++++++++++++++++++++++++---
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_sbc.c      |   59 +++++++++++----------
 drivers/target/target_core_spc.c      |    8 +++-
 include/target/target_core_backend.h  |    1 +
 include/target/target_core_base.h     |    3 +
 8 files changed, 142 insertions(+), 36 deletions(-)

-- 
1.7.2.5
