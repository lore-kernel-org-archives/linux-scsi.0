From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Thu, 16 Dec 2010 19:47:44 -0800
Message-ID: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

It is my pleasure to announce TCM/LIO v4.0.0-rc6 for v2.6.37-rc6 has
been tagged and pushed into lio-core-2.6.git/lio-4.0 and master
branches.  It has been almost two months since the last -rc5 for .36-rc8
was released, and since that time a number of refactoring and cleanup
patch series from Christoph Hellwig have been merged to reduced the
target core logic and backend drivers by nearly ~4200 LOC!

A big thanks to Christoph for jumping on a number of areas that have
needed attention in target_core_transport.c for some time, and for being
the very first 'third party' kernel developer to pull ahead in the
TCM/LIO patch ranking for a single TCM/LIO release.   It was a good
race, and hch did very much earn his victory for this round (41 vs. 36)
in the final rankings attached below.

Also, I am proud to announce this is the first release of Target Core
code running with a publically available HW target fabric module.  The
tcm_qla2xxx and qla2xxx LLD code is now available from the
lio-core-2.6.git/tcm_qla2xxx branch, and more information about the
recent Alpha -> BETA release and the ongoing developers are available
here:

http://www.linux-iscsi.org/index.php/Qlogic

And the initial RFC patches here:

http://marc.info/?l=linux-scsi&m=129244523223528&w=2

There have also been a number of important bugfixes that have gone into
this release, so for folks running on earlier v4.0 code please consider
upgrading now..  Here is a brief list of the critical fixes from below:

*) tcm/iblock: Fix bio-set leak during bio exception handling (nab)

*) tcm/pscsi: Fix incorrect usage of head_of_queue with
    blk_execute_rq_nowait() (boaz)

*) tcm/pscsi: Fix failure case for __pscsi_map_task_SG() (nab)

*) tcm: Fix OOPs w/ task->task_sg_bidi[] for non BIDI operation (kiran)

*) target: Fix tfo->write_pending() fabric callback ordering (nab,
kiran, and others)

There has also been work in a number of branches where work is ongoing,
and not mentioned in the final stats below.  This includes Tomo-san's
work with the ibmvscsis module for IBM POWER VSCSI in branch
tcm_ibmvstgt, and Kiran Patil for his recent work in the
tcm_fc_ddp_offload branch for adding offload support for 10 Gb/sec Intel
NICs with TCM_FC/OpenFCOE target code that will be merged into TCM/LIO
upstream in a future release.

Kiran also found and fixed his first bug in upstream Target code, and
helped squash another long standing (since v2.x day) issue wrt to
interrupt context usage required for HW target mode within the
transport_generic_write_pending() callback.  He will be continuing to
test and improve the TCM_FC/OpenFCoE code on Intel 10 Gb/sec hardware,
and maintaining the DDP offload pieces for FCoE within
lio-core-2.6.git/tcm_fc_ddp_offload branch on kernel.org.  Thank you and
great work Kiran!

At this point v4.0 development will be slowing down, as I will only be
accepting critical fixes at this point for v4.0.0-rc7 as we move into
the testing and validation phase for .38 mainline code.  So please
folks, if anyone has immediate issues for v4.0 that need to be
considered, please make myself and other core target devels aware and we
will do our best to get them addressed.

Best Regards,

--nab

Christoph Hellwig (41):
  target: remove never changing indirections in se_cmd
  target: remove activate_device/deactivate_device
  target: remove SHUTDOWN_SIGS
  target: remove transport_generic_map_buffers_to_tasks
  target: clean up transport_subsystem_register
  target: remove dead blockdevice claim/release code
  target: remove transport_generic_free_device
  target: remove unused split_cdb_RW_* handlers
  target: remove dead call to transport_emulate_control_cdb in rd
    driver
  target: split CDB emulation out of target_core_transport.c
  target: take advantage of REQ_FUA in the iblock backend
  target: clean up cache flush / FUA handling in the file backend
  target: fix block limits VPD emulation
  target: remove unused exports
  target: simplify and speed up task allocation
  target: kill CONFIG_TCM_DEBUG_DEV
  target: remove dead DF_* flags
  target: Kconfig fixes
  target: rename Kbuild files to Makefile
  target: move iovec handling into the iscsi code
  target: simplify memory allocation
  target: simplify se_task mapping
  target-stgt: fix initializaiton
  target: remove dead backend methods
  target: simplify cmd to task mapping
  target: consolidate se_global externs
  target: remove core_get_hba/core_put_hba
  target: remove se_hba_cache
  target: simplify hba allocation and freeing
  target: simplify subsystem registration and lookup
  target: remove the unused type field in struct se_subsystem_api
  target: mark the transport_complete method optional
  target: remove some iscsi leftovers in core code
  target: remove unused snapshot attributes
  target-pscsi: query tape blocksize using scsi_execute_req
  target: always get capacity from ->get_blocks
  target-pscsi: get inquiry data using scsi_execute_req
  target: remove passthrough support
  target: remove unused get_dma_length subsystem method
  target: always assign t_task_lba in transport_generic_cmd_sequencer
  target: always assign se_cmd flags in transport_generic_cmd_sequencer

Kiran Patil (1):
  tcm: Fix OOPs w/ task->task_sg_bidi[] for non BIDI operation

Nicholas Bellinger (36):
  tcm: Fix missing TABs in drivers/target/Kconfig
  tcm/iblock: Fix bio-set leak during bio exception handling
  tcm/iblock: Update blkdev_issue_flush() parameter usage
  lio-target: Drop init_MUTEX*() wrapper usage
  tcm: Add transport_generic_handle_cdb_map() wrapper
  tcm: Move special PASSTHROUGH_CONTIG_TO_SG handling into internal TFO
    callbacks
  tcm: Drop ->max_cdb_len from struct se_dev_limits
  tcm/pscsi: Fix incorrect usage of head_of_queue with
    blk_execute_rq_nowait()
  tcm/pscsi: Drop unnecessary struct pscsi_plugin_task->pscsi_req_bidi
  tcm/pscsi: Remove legacy struct scsi_device->sector_size workaround
    for TYPE_DISK
  tcm/pscsi: Fix failure case for __pscsi_map_task_SG()
  tcm: Drop legacy struct se_subsystem_api->get_dev_info() caller
  tcm: Convert backstore ->set_configfs_dev_params() to use parser.h
  tcm: Convert target_core_dev_pr_store_attr_res_aptpl_metadata() to
    use parser.h
  tcm: drop transport_check_dev_params_delim()
  tcm/configfs: Rename target_core_hba_group_ops callers
  tcm_loop: Drop legacy host_lock usage in SHT->queuecommand() caller
  tcm: Add missing NULL match_table_t entries
  tcm: Drop unused DF_TRANSPORT_DMA_ALLOC caller
  target: fix conversion spec warning for sizeof() usage
  tcm_loop: Convert tcm_loop_queuecommand() to new parameter usage.
  target: simplify cmd to task mapping
  target: mark as much as possible static
  target: Add proper cast for sizeof() usage
  target: Fix up function pointer conditionals in
    transport_map_control_cmd_to_task()
  target: Push down iovec allocation into iSCSI target code
  target: Fix fallthrough bug for SAI READ_CAPACITY_16
  target: remove struct se_transform_info
  target-pscsi: Fix incorrect scsi_execute_req() usage
  target: Convert transport_dev_end_lba() to ->get_blocks()
  target-ramdisk: Add missing ->get_blocks for rd_mcp_template
  target: Remove dump_stack() for demo-mode LUN shutdown
  target: Fix tfo->write_pending() fabric callback ordering
  target: Convert se_nacl->nacl_sess_lock to use spin_lock_irq()
  target: Add debug wrappers for transport_do_task_sg_chain
  lio-core v4.0.0-rc6

 drivers/target/Kbuild                             |   34 -
 drivers/target/Kconfig                            |   47 +-
 drivers/target/Makefile                           |   31 +
 drivers/target/lio-target/Kbuild                  |   37 -
 drivers/target/lio-target/Kconfig                 |   31 +-
 drivers/target/lio-target/Makefile                |   36 +
 drivers/target/lio-target/iscsi_target.c          |  506 ++-
 drivers/target/lio-target/iscsi_target_configfs.c |    6 +-
 drivers/target/lio-target/iscsi_target_core.h     |    6 +-
 drivers/target/lio-target/iscsi_target_login.c    |   24 +-
 drivers/target/lio-target/iscsi_target_mib.h      |    1 -
 drivers/target/lio-target/iscsi_target_tpg.c      |    4 +-
 drivers/target/lio-target/iscsi_target_util.c     |   32 +-
 drivers/target/lio-target/iscsi_target_util.h     |   38 +-
 drivers/target/lio-target/iscsi_target_version.h  |    2 +-
 drivers/target/lio-target/iscsi_thread_queue.c    |   28 +-
 drivers/target/target_core_alua.c                 |   48 +-
 drivers/target/target_core_alua.h                 |   16 -
 drivers/target/target_core_cdb.c                  | 1131 +++++
 drivers/target/target_core_configfs.c             |  534 +--
 drivers/target/target_core_device.c               |  180 +-
 drivers/target/target_core_fabric_lib.c           |    8 +-
 drivers/target/target_core_file.c                 |  634 +---
 drivers/target/target_core_file.h                 |   33 +-
 drivers/target/target_core_hba.c                  |  190 +-
 drivers/target/target_core_hba.h                  |   11 +-
 drivers/target/target_core_iblock.c               |  483 +--
 drivers/target/target_core_iblock.h               |    8 +-
 drivers/target/target_core_mib.c                  |    5 +-
 drivers/target/target_core_mib.h                  |    2 -
 drivers/target/target_core_pr.c                   |   22 +-
 drivers/target/target_core_pscsi.c                |  742 ++--
 drivers/target/target_core_pscsi.h                |   10 +-
 drivers/target/target_core_rd.c                   |  477 +--
 drivers/target/target_core_rd.h                   |   20 +-
 drivers/target/target_core_scdb.c                 |   53 -
 drivers/target/target_core_scdb.h                 |    5 -
 drivers/target/target_core_stgt.c                 |  480 +--
 drivers/target/target_core_stgt.h                 |    7 +-
 drivers/target/target_core_tmr.c                  |   18 +-
 drivers/target/target_core_tpg.c                  |    6 +-
 drivers/target/target_core_transport.c            | 4773 ++++-----------------
 drivers/target/tcm_fc/Kbuild                      |   16 -
 drivers/target/tcm_fc/Kconfig                     |    5 +-
 drivers/target/tcm_fc/Makefile                    |   15 +
 drivers/target/tcm_fc/tfc_cmd.c                   |    9 +-
 drivers/target/tcm_fc/tfc_conf.c                  |    2 -
 drivers/target/tcm_loop/Kbuild                    |   11 -
 drivers/target/tcm_loop/Kconfig                   |   16 +-
 drivers/target/tcm_loop/Makefile                  |   11 +
 drivers/target/tcm_loop/tcm_loop_fabric.c         |   21 -
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c    |   25 +-
 include/target/target_core_base.h                 |  190 +-
 include/target/target_core_configfs.h             |    5 -
 include/target/target_core_device.h               |   12 -
 include/target/target_core_tpg.h                  |    4 -
 include/target/target_core_transport.h            |  267 +--
 57 files changed, 3788 insertions(+), 7580 deletions(-)
