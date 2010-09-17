From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
Date: Fri, 17 Sep 2010 13:22:10 -0700
Message-ID: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Joe Eykholt <jeykholt@cisco.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Smart <James.Smart@Emulex.Com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Philipp Reisner <philipp.reisner@linbit.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vasu Dev <vasu.dev@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

It is my great pleasure to announce that TCM/LIO v4.0.0-rc4 for v2.6.36-rc4 has
been tagged and pushed into lio-core-2.6.git/lio-4.0.  The last weeks have been
really very busy and many gracious thanks go out to all of the individuals who
made comments and helped bring together this v4.0.0-rc4 release.  A list of the
major changes includes:

	*) Updates + bugfixes for tcm_fc (Joe Eykholt patches)
	*) Drop host_lock around struct scsi_cmnd->scsi_done() in tcm_loop (Vasu Dev assist)
	*) Add Extended INQUIRY Data VPD Page
	*) Numerous target_core_base.h cleanups (Konrad Rzeszutek Wilk assist)
	*) Add support for struct target_core_fabric_ops->new_cmd_map() optimization
	*) Add support for struct se_task->task_sg[] chaining for HW target mode
	   pci_map_sg() and friends.
	*) Convert msleep() to cpu_relax() usage in several tight loops.
	   (Konrad Rzeszutek Wilk assist)
	*) Add optimization to convert TCM Core and tcm_loop, lio-target and tcm_fc
           to use struct se_cmd descriptors from within fabric module dependent I/O
	   descriptors.  (Joe Eykholt assist)
	*) Convert lio-target to use libcrypto crc32c
	*) Add support to LIO-Target for SSE v4.2 (Nehalem) CRC32C offload instruction
	   (Mike Christie assist)
	*) Add support to LIO-Target for per iSCSI connection CPU scheduling affinity
	   (Phillip Reisner assist)
	*) Convert TCM Core to use include/linux/dma-mapping.h:enum dma_data_direction
	   (Boaz Harrosh assist)
	*) Add support for BIDI Commands and XDWRITE_READ_10 emulation (Boaz Harrosh assist)
	*) Add support for native 32-bit CDBs VARIABLE_LENGTH_CMD support and
           XDWRITE_READ_32 emulation (James Bottomley and Martin Petersen assist)

The shortlog and diffstat have been attached below for reference.

And a final thanks to the folks who contributed minor patches and/or comments, but where
not mentioned above.

Thank you!

--nab

Joe Eykholt (4):
  tcm_fc: handle new ft_recv interface from libfc
  tcm_fc: add missing method for tpg_check_prod_mode_write_protect
  tcm_fc: se_sess->se_acl not set
  tcm_fc: fix cmd leak

Nicholas Bellinger (63):
  tcm/pscsi: Convert struct bio->bi_rw assignment to use REQ_WRITE
  tcm/fileio: Bump version to v4.0
  tcm: Remove copyright info from includes
  tcm: Update copyright information
  tcm_fc: Fix build failure with gcc 4.3.2
  tcm_fc: fix misuse of kunmap_atomic()
  tcm_fc: Change version to 0.3
  tcm_loop: Drop host_lock around struct scsi_cmnd->scsi_done()
  tcm: Add support for Extended INQUIRY Data VPD Page
  tcm: Remove legacy struct se_lun->lun_type usage
  tcm: Remove legacy DEV_STATUS_THR_* defines
  tcm: Convert TCM base defines to enums, round 1
  tcm: Convert NAF_DYNAMIC_NODE_ACL to struct
    se_node_acl->dynamic_node_acl bitfield
  tcm: Convert MAP_SG_KMAP to struct se_map_sg->sg_kmap_active bitfield
  tcm: Convert TCM base defines to enums, round 2:
  tcm: Convert DEF_PR_REGISTERED to struct
    se_dev_entry->def_pr_registered bitfield
  tcm: Convert PRF_ISID_PRESENT_AT_REG to struct
    t10_pr_registration->isid_present_at_reg bitfield
  tcm: Convert struct se_cmd->scsi_sense_reason enum and add TCM_*
    prefix
  tcm: Add comments for t10_alua_index_t, t10_task_attr_index_t and
    t10_reservations_index_t
  tcm/pr: Add proper comment for struct
    t10_reservation_template->pr_res_holder
  tcm/alua: Move (*t10_*)() callers into struct t10_reservation_ops
  tcm: Cleanups for struct se_transport_task usage
  tcm: Add support for TRANSPORT_NEW_CMD_MAP
  tcm: Add support for struct target_core_fabric_ops->task_sg_chaining
  tcm/ramdisk: Add special case for TFO->task_sg_chaining=1 with
    RAMDISK_DR
  tcm: Convert struct se_node_acl->device_list_lock to spin_*lock_irq()
  tcm: Convert struct se_device->dev_status_lock to spin_*lock_irq()
  tcm_loop: Convert to use new optimized TFO->new_cmd_map() caller
  tcm_loop: Convert to using root_device_register() and
    root_device_unregister()
  tcm_loop: Use IS_ERR() conditional for root_device_register()
  tcm: Move remaining structure member related defs into related
    structures
  tcm: Add enum names and comments to target_core_base.h
  tcm/alua: Cleanups for target_core_alua.c
  tcm: Convert to cpu_relax() for atomic_read() in tight loops
  tcm: Add support for fabric module provided struct se_cmd descriptors
  tcm_loop: Convert to pre-allocated struct se_cmd descriptors
  lio-target: Convert to use pre-allocated struct se_cmd descriptors
  tcm_fc: Convert to use pre-allocated struct se_cmd descriptors
  lio-target: Convert to use libcrypto crc32c
  lio-target: Add support for Intel Nehalem crc32-intel libcrypto
    offload
  lio-target: Convert to use bitmap for handling thread_id allocation
  lio-target: Add support for per iSCSI connection CPU scheduling
    affinity
  tcm: Convert SE_DIRECTION_* to use enum dma_data_direction
  tcm_loop: Convert to use enum dma_data_direction
  tcm_fc: Convert to use enum dma_data_direction
  lio-target: Convert ISCSI_* data_direction macros to enum
    dma_data_direction
  tcm: Convert handful of target_core_base.h structure members to enums
  tcm: Convert to use include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE
  tcm: Update TRANSPORT_SENSE_BUFFER define comment
  tcm: Fix TRANSPORT_NEW_CMD_MAP failure case
  tcm_loop: Fix tcm_loop_new_cmd_map() failure return values
  tcm_loop: Fix TMR release patch OOPS
  tcm: Add support for BIDI operation and XDWRITE_READ_10 emulation
  tcm_loop: Add DMA_BIDIRECTIONAL CDB support
  tcm_loop: Remove BUGs() from I_T Nexus fallback code
  tcm: Remove DMA_BIDIRECTIONAL for BIDI-COMMANDS
  tcm_loop: Remove DMA_BIDIRECTIONAL usage for BIDI-COMMANDS
  tcm: Rename transport_xor_callback() to transport_complete_callback()
  lio-target: Enable crc32c_x86_offload=1 by default
  lio-target: Fix comment for TA_CRC32C_X86_OFFLOAD
  tcm: Add native 32-byte CDB support
  tcm: Add VARIABLE_LENGTH_CMD support w/ XDWRITE_READ_32 emulation
  tcm_loop: Enable 32-byte CDB support in virtual SCSI LLD

 drivers/target/lio-target/Kbuild                  |    1 -
 drivers/target/lio-target/iscsi_crc.c             |  171 ----
 drivers/target/lio-target/iscsi_crc.h             |    9 -
 drivers/target/lio-target/iscsi_target.c          |  453 ++++++++---
 drivers/target/lio-target/iscsi_target.h          |    1 +
 drivers/target/lio-target/iscsi_target_configfs.c |    6 +
 drivers/target/lio-target/iscsi_target_core.h     |   40 +-
 drivers/target/lio-target/iscsi_target_erl0.c     |    4 +-
 drivers/target/lio-target/iscsi_target_erl1.c     |   15 +-
 drivers/target/lio-target/iscsi_target_erl2.c     |    3 +-
 drivers/target/lio-target/iscsi_target_login.c    |   99 +++-
 drivers/target/lio-target/iscsi_target_login.h    |    1 +
 drivers/target/lio-target/iscsi_target_mib.c      |    6 +-
 drivers/target/lio-target/iscsi_target_nego.c     |   18 +-
 drivers/target/lio-target/iscsi_target_tmr.c      |   36 +-
 drivers/target/lio-target/iscsi_target_tpg.c      |   19 +
 drivers/target/lio-target/iscsi_target_tpg.h      |    1 +
 drivers/target/lio-target/iscsi_target_util.c     |   56 +-
 drivers/target/lio-target/iscsi_thread_queue.c    |   58 ++-
 drivers/target/lio-target/iscsi_thread_queue.h    |    5 +
 drivers/target/target_core_alua.c                 |  133 ++--
 drivers/target/target_core_alua.h                 |   14 +-
 drivers/target/target_core_configfs.c             |    8 +-
 drivers/target/target_core_device.c               |  133 ++--
 drivers/target/target_core_fabric_configfs.c      |    8 +-
 drivers/target/target_core_fabric_lib.c           |    5 +-
 drivers/target/target_core_file.c                 |    6 +-
 drivers/target/target_core_file.h                 |   34 +-
 drivers/target/target_core_hba.c                  |    4 +-
 drivers/target/target_core_hba.h                  |   29 -
 drivers/target/target_core_iblock.c               |    8 +-
 drivers/target/target_core_iblock.h               |   29 +-
 drivers/target/target_core_mib.c                  |   38 +-
 drivers/target/target_core_mib.h                  |   26 -
 drivers/target/target_core_pr.c                   |   53 +-
 drivers/target/target_core_pscsi.c                |   21 +-
 drivers/target/target_core_pscsi.h                |   32 +-
 drivers/target/target_core_rd.c                   |   55 +-
 drivers/target/target_core_rd.h                   |   32 +-
 drivers/target/target_core_scdb.c                 |   42 +-
 drivers/target/target_core_scdb.h                 |   31 +-
 drivers/target/target_core_stgt.c                 |    4 +-
 drivers/target/target_core_stgt.h                 |   30 +-
 drivers/target/target_core_tmr.c                  |    4 +-
 drivers/target/target_core_tpg.c                  |   64 +-
 drivers/target/target_core_transport.c            |  909 ++++++++++++++++-----
 drivers/target/target_core_ua.c                   |   24 +-
 drivers/target/tcm_fc/tcm_fc.h                    |    8 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |  137 ++--
 drivers/target/tcm_fc/tfc_conf.c                  |   13 +-
 drivers/target/tcm_fc/tfc_io.c                    |   29 +-
 drivers/target/tcm_fc/tfc_sess.c                  |   15 +-
 drivers/target/tcm_loop/tcm_loop_configfs.c       |   35 +-
 drivers/target/tcm_loop/tcm_loop_core.h           |   12 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c         |   91 +--
 drivers/target/tcm_loop/tcm_loop_fabric.h         |    2 -
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c    |  243 +++----
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h    |    2 +-
 include/target/target_core_base.h                 |  475 ++++++-----
 include/target/target_core_configfs.h             |   27 -
 include/target/target_core_device.h               |   28 -
 include/target/target_core_fabric_ops.h           |   12 +
 include/target/target_core_tpg.h                  |   34 +-
 include/target/target_core_transport.h            |   47 +-
 64 files changed, 2200 insertions(+), 1788 deletions(-)
