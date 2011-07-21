From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 000/103] target: Updates for v3.1-rc1
Date: Thu, 21 Jul 2011 00:04:36 -0700
Message-ID: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.150]:24187 "HELO
	nm5-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab1GUG7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 02:59:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@hera.kernel.org>

From: Nicholas Bellinger <nab@hera.kernel.org>

Hello folks,

This is the first set of pending drivers/target/ updates for the v3.1
merge window.  It contains updates for drivers/target core and
loopback + tcm_fc modules and get mainline synced up with the latest
lio-core-2.6.git/master v4.1.0-rc1 HEAD as requested by hch.

I'll be squashing these into a proper GIT PULL to Linus shortly, so
please let me know if anything else is missing and/or needs to be
addressed for the first round of v3.1 updates.

The 3.1-pending branch is available directly via git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.1-pending

Thank you!

--nab

Andy Grover (66):
  target: use errno values instead of returning -1 for everything
  target: Rename transport_calc_sg_num to transport_init_task_sg
  target: Fix leak in error path in transport_init_task_sg
  target: Remove pscsi_get_sh() in _pscsi.c
  target: Make two runtime checks into WARN_ONs
  target: Remove hba queue depth and convert to spin_lock_irq usage
  target: dev->dev_status_queue_obj is unused
  target: Make struct se_queue_req.cmd type struct se_cmd *
  target: Remove __transport_get_qr_from_queue()
  target: Rename se_dev->g_se_dev_list to se_dev_node
  target: Remove struct se_global
  target: Simplify scsi mib index table code
  target: Make dev_queue_obj a member of se_device instead of a pointer
  target: remove extraneous returns at end of void functions
  target: Ensure transport_dump_vpd_ident_type returns null-terminated
    str
  target: Function pointers don't need to use '&' to be assigned
  target: Fix comment in __transport_execute_tasks()
  target: Misc style cleanups
  target: rename struct pr_reservation_template to pr_reservation
  target: Remove #defines that just perform indirection
  target: Inline transport_get_task_from_execute_queue()
  target: Remove unneeded casts to void*
  target: Rename get_lun_for_{cmd,tmr} to lookup_{cmd,tmr}_lun
  target: Make t_task a member of se_cmd, not a pointer
  target: Handle functions returning "-2"
  target: Use cmd->se_dev over cmd->se_lun->lun_se_dev
  target: Embed qr in struct se_cmd
  target: Replace embedded struct se_queue_req with a list_head
  target: Rename list_heads that are nodes in struct se_cmd to "*_node"
  target: Fold transport_device_setup_cmd() into lookup_{tmr,cmd}_lun()
  target: Make t_mem_list and t_mem_list_bidi members of t_task
  target: Add comment & cleanup transport_map_sg_to_mem()
  target: Remove unneeded checks in transport_free_pages()
  target: Replace custom sg<->buf functions with lib funcs
  target: Simplify sector limiting code
  target: get_cdb should never return NULL
  target: Simplify transport_memcpy_se_mem_read_contig
  target: Use assignment rather than increment for t_task_cdbs
  target: Don't pass dma_size to generic_get_mem
  target: Pass sg with type scatterlist in transport_map_sg_to_mem
  target: Move task_sg_num next to task_sg in struct se_task
  target: inline struct se_transport_task into struct se_cmd
  target: Change name & semantics of transport_get_sectors()
  target: Remove unused members of se_cmd
  target: Rename se_cmd.t_task_cdbs to t_task_list_num
  target: Fix some spelling
  target: Remove unused var from transport_generic_do_tmr
  target: map_sg_to_mem: return sg_count in return value
  target/pscsi: Use min_t for sector limits
  target/pscsi: Unused param for pscsi_get_bio()
  target: Rename get_cdb_count to allocate_tasks
  target: Remove ifdeffed code in t_g_process_write
  target: Pass 2nd param of transport_split_cdb by value
  target: Make all control CDBs scatter-gather
  target: Enforce 1 page max for control cdb buffer sizes
  target: Remove direct ramdisk code
  target: Eliminate usage of struct se_mem
  target: Rename task_sg_num to task_sg_nents
  target: Remove custom debug macros for pr_debug. Use pr_err().
  target: Remove custom debug macros in non-iscsi fabrics
  target: Set WSNZ=1 in block limits VPD. Abort if WRITE_SAME sectors =
    0
  target: Remove transport do_se_mem_map callback
  target: Further simplify transport_free_pages
  target: Redo task allocation return value handling
  target: Remove extra parentheses
  target: change alloc_task call to take *cdb, not *cmd

Andy Shevchenko (2):
  target: fix typo Assoication -> Association
  target: remove custom hex2bin() implementation

Christoph Hellwig (6):
  target: remove the always-noop ->new_cmd_failure method
  target: remove the unused SCF_SE_DISABLE_ONLINE_CHECK flag
  target: remove the unused SCF_CMD_PASSTHROUGH_NOALLOC flag
  target: remove the unused SCF_EMULATE_SYNC_UNMAP flag
  target: remove the unused SCF_EMULATE_SYNC_CACHE flag
  target: merge release_cmd methods

Dan Carpenter (1):
  tcm_loop: off by one in tcm_loop_make_naa_tpg()

Fubo Chen (1):
  target: Check LUN numbers in transport_get_lun_for_[cmd,tmr]

Jesper Juhl (2):
  loopback: Remove duplicate scsi/scsi_tcq.h include
  loopback: Fix memory leak in tcm_loop_make_scsi_hba()

Nicholas Bellinger (17):
  target: Minor header comment fixes
  target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions in scsi.h
  target: Remove unnecessary *cdb transport_get_lun_for_cmd parameter
  target: Remove unused su_group usage in fabric register/dergister
  target: Fix double test of inquiry_prod
  target: Fix WRITE_SAME_16 t_task_lba assignment bug
  target: Fix WRITE_SAME_[16,32] number of blocks=0 case
  tcm_fc: Makefile cleanups
  tcm_fc: Convert to wake_up_process and schedule_timeout_interruptible
  target: Make transport_generic_new_cmd() available for iscsi-target
  target: Remove fabric callback to allocate iovecs
  target: Fix transport_generic_new_cmd WRITE comment
  target: Add transport_handle_cdb_direct optimization
  target: Add SCF_EMULATE_QUEUE_FULL -> transport_handle_queue_full
  target/iblock: Use request_queue->nr_request for se_device defaults
  target: ->map_task_SG conversion to ->map_control_SG and
    ->map_data_SG
  target: Update QUEUE ALGORITHM MODIFIER control page default

Roland Dreier (7):
  target: Make transport_lookup_cmd_lun() locking IRQ-safe
  target: Make se_dev_check_online() locking IRQ-safe
  target: Make se_tmr_lock IRQ-safe
  target/iblock: Remove unused iblock_dev members
  target: Allow for built-in target modules
  target: Fix reporting of supported VPD pages
  target: Implement Block Device Characteristics VPD page

Stefan Hajnoczi (1):
  loopback: Only build tcm_loop as module

 drivers/target/loopback/Kconfig              |    9 +-
 drivers/target/loopback/tcm_loop.c           |  207 +-
 drivers/target/loopback/tcm_loop.h           |    6 -
 drivers/target/target_core_alua.c            |  426 ++--
 drivers/target/target_core_cdb.c             |  457 ++--
 drivers/target/target_core_configfs.c        |  667 +++---
 drivers/target/target_core_device.c          |  819 +++---
 drivers/target/target_core_fabric_configfs.c |  122 +-
 drivers/target/target_core_fabric_lib.c      |   27 +-
 drivers/target/target_core_file.c            |  149 +-
 drivers/target/target_core_file.h            |    4 -
 drivers/target/target_core_hba.c             |   37 +-
 drivers/target/target_core_iblock.c          |  199 +-
 drivers/target/target_core_iblock.h          |    9 -
 drivers/target/target_core_pr.c              |  862 ++++---
 drivers/target/target_core_pr.h              |    2 +-
 drivers/target/target_core_pscsi.c           |  316 +--
 drivers/target/target_core_pscsi.h           |    4 +-
 drivers/target/target_core_rd.c              |  483 +---
 drivers/target/target_core_rd.h              |    4 -
 drivers/target/target_core_scdb.c            |   20 +-
 drivers/target/target_core_scdb.h            |   10 +-
 drivers/target/target_core_stat.c            |  112 +-
 drivers/target/target_core_tmr.c             |  185 +-
 drivers/target/target_core_tpg.c             |  206 +-
 drivers/target/target_core_transport.c       | 3688 ++++++++++----------------
 drivers/target/target_core_ua.c              |   62 +-
 drivers/target/tcm_fc/Makefile               |   17 +-
 drivers/target/tcm_fc/tcm_fc.h               |   25 -
 drivers/target/tcm_fc/tfc_cmd.c              |  114 +-
 drivers/target/tcm_fc/tfc_conf.c             |   47 +-
 drivers/target/tcm_fc/tfc_io.c               |  130 +-
 drivers/target/tcm_fc/tfc_sess.c             |   18 +-
 include/target/target_core_base.h            |  226 +-
 include/target/target_core_device.h          |    6 +-
 include/target/target_core_fabric_ops.h      |    9 +-
 include/target/target_core_transport.h       |   43 +-
 37 files changed, 4089 insertions(+), 5638 deletions(-)

-- 
1.7.6

