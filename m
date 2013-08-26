From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 00/13] target: Add support for COMPARE_AND_WRITE (VAAI) emulation
Date: Mon, 26 Aug 2013 21:13:33 +0000
Message-ID: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62288 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3HZV3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 17:29:47 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so44573oag.28
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 14:29:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

Hi folks,

This series -v3 adds support to target-core for generic COMPARE_AND_WRITE
emulation as defined by SBC-3 using virtual (IBLOCK, FILEIO, RAMDISK)
backends.

COMPARE_AND_WRITE is a VMWare ESX VAAI primitive that is currently used
by VMFS to perform array side locking of filesystem extents.  The logic
is the functional equivilent of an atomic test and set, which allows a
cluster filesystem to scale across multiple clients by locking individual
regions, without having to obtain a traditional SCSI reservation for
exclusive access to the entire logical unit.

As this point, a se_device->caw_mutex is in place to synchronize
between sbc_compare_and_write() -> compare_and_write_callback() ->
compare_and_write_post() callbacks and failure paths, and the code is
fully functional.  The use of mutex_lock() -> mutex_unlock() across
multiple functions looks a bit strange, so comments have been added
to clarify the rather unusual looking usage.

Note this implemenation is currently limited to a single number of
logical blocks (NoLB).

v3 changes:
  
  - Refactor transport_generic_get_mem() to target_alloc_sgl() in
    order to accept parameters **sgl, *sgl_nents, length and zero_flag.
  - Make transport_generic_new_cmd() use target_alloc_sgl() to do
    SGL + page allocations for SCF_BIDI + SCF_COMPARE_AND_WRITE cases.

v2 changes:

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

Nicholas Bellinger (13):
  scsi: Add CDB definition for COMPARE_AND_WRITE
  target: Add return for se_cmd->transport_complete_callback
  target: Add TCM_MISCOMPARE_VERIFY sense handling
  target: Allow sbc_ops->execute_rw() to accept SGLs + data_direction
  target: Convert se_cmd->t_bidi_data_sg checks to use SCF_BIDI
  target: Refactor transport_generic_get_mem to target_alloc_sgl
  target: Do memory allocation for bidi commands using target_alloc_sgl
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
 drivers/target/target_core_transport.c |  115 ++++++++++++---
 include/scsi/scsi.h                    |    1 +
 include/target/target_core_backend.h   |    3 +-
 include/target/target_core_base.h      |   14 ++-
 include/target/target_core_fabric.h    |    1 +
 13 files changed, 371 insertions(+), 54 deletions(-)

-- 
1.7.2.5

