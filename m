From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 00/12] target: Add support for COMPARE_AND_WRITE (VAAI) emulation
Date: Thu, 22 Aug 2013 04:53:58 +0000
Message-ID: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Hi folks,

This series -v2 adds support to target-core for generic COMPARE_AND_WRITE
emulation as defined by SBC-3 using virtual (IBLOCK, FILEIO, RAMDISK)
backends.

COMPARE_AND_WRITE is a VMWare ESX VAAI primitive that is currently used
by VMFS to perform array side locking of filesystem extents.  The logic
is the functional equivilent of an atomic test and set, which allows a
cluster filesystem to scale across multiple clients by locking individual
regions, without having to obtain a traditional SCSI reservation for
exclusive access to the entire logical unit.

Note this implemenation is currently limited to a single number of
logical blocks (NoLB).

As this point, a se_device->caw_mutex is in place to synchronize
between sbc_compare_and_write() -> compare_and_write_callback() ->
compare_and_write_post() callbacks and failure paths, and the code is
fully functional.  The use of mutex_lock() -> mutex_unlock() across
multiple functions looks a bit strange, so comments have been added
to clarify the rather unusual looking usage.

The one point that was not addressed in hch's comments was dropping
se_cmd->execute_rw(), which ended up not being possible considering
that sbc_ops is not accessable beyond setup in sbc_parse_cdb(), and
saving this pointer in se_cmd would end up defeating the purpose of
the abstraction between SPC/SBC code.

The full changes for -v2 from hch's comments include:

  - Add SCF_COMPARE_AND_WRITE command flag
  - Use sbc_execute_rw() for normal cmd->execute_rw() submission
    with expected se_cmd members.
  - Use SCF_COMPARE_AND_WRITE instead of CDB based check for
    calculating length in transport_generic_get_mem_bidi().
  - Use SCF_COMPARE_AND_WRITE in transport_generic_new_cmd()
    for determing when to call transport_generic_get_mem_bidi()
  - Make __target_execute_cmd() available as extern for WRITE
    I/O submission within compare_and_write_callback()
  - Set SCF_COMPARE_AND_WRITE and cmd->execute_cmd() to
    sbc_compare_and_write() during setup in sbc_parse_cdb()
  - Use sbc_compare_and_write() for initial READ submission with
    DMA_FROM_DEVICE
  - Reset cmd->execute_cmd() to sbc_execute_rw() for write instance
    user-data in compare_and_write_callback()
  - Drop SCF_BIDI command flag usage
  - Set TRANSPORT_PROCESSING + transport_state flags before write
    instance submission, and convert to __target_execute_cmd()
  - Prevent sbc_get_size() from being being called twice to
    generate incorrect size in sbc_parse_cdb()
  - Enforce se_device->caw_mutex synchronization between initial
    READ I/O submission, and final WRITE I/O completion.
  - Drop tcm_qla2xxx patch, and will include as seperate patch
    for common target_reverse_dma_direction().

Please review as v3.12 material.

Thanks!

--nab

Nicholas Bellinger (12):
  scsi: Add CDB definition for COMPARE_AND_WRITE
  target: Add return for se_cmd->transport_complete_callback
  target: Add TCM_MISCOMPARE_VERIFY sense handling
  target: Allow sbc_ops->execute_rw() to accept SGLs + data_direction
  target: Convert se_cmd->t_bidi_data_sg checks to use SCF_BIDI
  target: Add memory allocation for bidirectional commands
  target: Add transport_reset_sgl_orig() for COMPARE_AND_WRITE
  target: Make __target_execute_cmd() available as extern
  target: Add MAXIMUM COMPARE AND WRITE LENGTH in Block Limits VPD
  target: Add support for COMPARE_AND_WRITE emulation
  target: Add compare_and_write_post() completion callback fall through
  target: Release COMPARE_AND_WRITE mutex in generic failure path

 drivers/target/target_core_configfs.c  |    4 +
 drivers/target/target_core_device.c    |   15 ++
 drivers/target/target_core_file.c      |    6 +-
 drivers/target/target_core_iblock.c    |    6 +-
 drivers/target/target_core_internal.h  |    1 +
 drivers/target/target_core_rd.c        |    6 +-
 drivers/target/target_core_sbc.c       |  248 +++++++++++++++++++++++++++++--
 drivers/target/target_core_spc.c       |    5 +
 drivers/target/target_core_transport.c |  117 ++++++++++++++-
 include/scsi/scsi.h                    |    1 +
 include/target/target_core_backend.h   |    3 +-
 include/target/target_core_base.h      |   14 ++-
 include/target/target_core_fabric.h    |    1 +
 13 files changed, 390 insertions(+), 37 deletions(-)

-- 
1.7.2.5
