From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/9] target: Add support for COMPARE_AND_WRITE (VAAI) emulation
Date: Tue, 20 Aug 2013 20:07:51 +0000
Message-ID: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Hi folks,

This series adds support to target-core for generic COMPARE_AND_WRITE
emulation as defined by SBC-3 using virtual (IBLOCK, FILEIO, RAMDISK)
backends.

COMPARE_AND_WRITE is a VMWare ESX VAAI primitive that is currently used
by VMFS to perform array side locking of filesystem extents.  The logic
is the functional equivilent of an atomic test and set, which allows a
cluster filesystem to scale across multiple clients by locking individual
regions, without having to obtain a traditional SCSI reservation for
exclusive access to the entire logical unit.

This implemenation is currently limited to a single number of logical
block (NoLB).

It's also currently lacking the necessary sychronization between I/O
submission of COMPARE_AND_WRITE verify instance and write instance
user data, which is still being worked on in order to avoid additional
overhead in the main I/O fast path.

Please review as v3.12 material.

Thanks!

--nab

Nicholas Bellinger (9):
  scsi: Add CDB definition for COMPARE_AND_WRITE
  target: Add return for se_cmd->transport_complete_callback
  target: Add memory allocation for bidirectional commands
  target: Add TCM_MISCOMPARE_VERIFY sense handling
  target: Skip ->queue_data_in() callbacks for COMPARE_AND_WRITE
  target: Allow sbc_ops->execute_rw() to accept SGLs + data_direction
  target: Add transport_reset_sgl_orig() for COMPARE_AND_WRITE
  target: Add support for COMPARE_AND_WRITE emulation
  tcm_qla2xxx: Add special case for COMPARE_AND_WRITE data_direction

 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    9 +-
 drivers/target/target_core_file.c      |    6 +-
 drivers/target/target_core_iblock.c    |    6 +-
 drivers/target/target_core_rd.c        |    6 +-
 drivers/target/target_core_sbc.c       |  205 +++++++++++++++++++++++++++++---
 drivers/target/target_core_transport.c |  109 ++++++++++++++++-
 include/scsi/scsi.h                    |    1 +
 include/target/target_core_backend.h   |    3 +-
 include/target/target_core_base.h      |    9 +-
 9 files changed, 317 insertions(+), 37 deletions(-)

-- 
1.7.10.4
