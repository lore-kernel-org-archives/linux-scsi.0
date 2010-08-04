From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO: v4.0.0-rc2 for v2.6.35
Date: Wed, 04 Aug 2010 00:28:58 -0700
Message-ID: <1280906938.27787.38.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:43373 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758263Ab0HDHcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 03:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>

Greetings all,

TCM/LIO v4.0.0-rc2 for v2.6.35 has been tagged and pushed to lio-core-2.6.git/lio-4.0.

The change since -rc1 back on May 19th include the following major
items.  These include a number of cleanups recommend by hch which have
shaved ~1700 LOC off so far:

	*) Addition of TMR LUN_RESET support to TCM_Loop fabric module
	*) Active I/O shutdown bugfixes for TCM core
	*) A bugfix for session reinstatement with LIO-Target with AuthMethod=None
	*) Removal of all typedef usage
	*) Usage of open_bdev_exclusive() and close_bdev_exclusive() for IBLOCK (hch assist)
	*) Removal of claim/release support for FILEIO with struct block_device (hch assist)
	*) TFO ->claim_phydevice() and ->release_phydevice() (hch assist)
	*) Removal of legacy target_core_plugin.c logic for struct se_subsystem_api (hch assist)
	*) Convert IBLOCK, FILEIO, PSCSI, and STGT subsystem plugins to stand alone .ko objects (hch assist)
	
There will be more of these cleanups scheduled for -rc3, which will be released on
a shorter timeframe than rc1 -> rc2, sometime during the v2.6.36 merge window.

Here is the full log, and again a big thanks to hch for reviewing and
guidence with the v4.0 code.

Best,

--nab

Nicholas Bellinger (36):
  [TCM]: Add TGCS_* defs for transport_generic_cmd_sequencer() return
    values
  [TCM]: Add common TAS abort handler for core_tmr_lun_reset()
  [TCM]: Make abort completion handlers use
    transport_cmd_check_stop_to_fabric()
  [TCM]: Fix incorrect SCF_CMD_PASSTHROUGH check in
    transport_send_task_abort()
  [TCM_Loop]: Add support for SCSI LLD eh_device_reset_handler
  [TCM_Loop]: Add support for SCSI LLD change_queue_depth
  [TCM_Loop]: Add proper I_T nexus usage for I/O path and
    tcm_loop_drop_nexus()
  [TCM]: Fix compile uninitialized variable warnings in
    core_scsi3_emulate_pro_register()
  [TCM]: Remove unused variables in target_core_fabric_configfs.c
  [TCM_Loop]: Move kconfig options into drivers/target/tcm_loop/Kconfig
  tcm_fc: Update ft_sess_create() to use kref_init()
  tcm: Add T_TASK(cmd)->transport_dev_active usage for active I/O
    shutdown
  tcm: Active I/O shutdown support for
    transport_generic_wait_for_tasks()
  tcm: Active I/O shutdown support for transport_lun_wait_for_tasks()
  tcm: Active I/O shutdown support for
    transport_clear_lun_from_sessions()
  lio-target: Call iscsi_tpg_disable_portal_group() for discovery tpg
    during module shutdown
  tcm: Add TMR exception handling bugfixes
  lio-target: Handle active TMRs in iscsi_release_commands_from_conn()
  lio-target: Fix session reinstatement bug for CSG=0 -> CSG=1 state
    change w AuthMethod=None
  tcm: Remove legacy se_obj_lun_type_t API interface
  tcm: Convert target_core_base.h typedefs to struct se_$FOO
  tcm: Convert remaining TCM subsystem plugin typedefs to struct
    se_$FOO
  lio-target: Convert typedefs in drivers/target/lio-target/ to use
    struct $FOO
  tcm: Remove #define FOO_C macros from source files
  lio-target: Remove #define FOO_C macros from source files
  tcm:  Convert TCM subsystem plugins to static struct se_subsystem_api
    usage
  tcm: Remove SNMP_SUPPORT stubs
  tcm: Move unnecessary include/target includes into drivers/target/
  lio-target: Remove internal div64.c logic
  lio-target: Remove iscsi_linux_defs.h include
  tcm/iblock: Add open_bdev_exclusive() and close_bdev_exclusive()
    usage
  tcm/fileio: Remove struct fd_dev->fd_bd usage
  tcm: Removal of TFO ->claim_phydevice() and ->release_phydevice()
  tcm: Remove legacy target_core_plugin.c logic for TCM subsystem
    plugins
  tcm: Update IBLOCK, FILEIO, PSCSI and STGT subsystem modules
  lio-core v4.0.0-rc2

 drivers/target/Kbuild                              |   46 +-
 drivers/target/Kconfig                             |   62 +-
 drivers/target/lio-target/Kbuild                   |    8 +-
 drivers/target/lio-target/div64.c                  |   16 -
 drivers/target/lio-target/iscsi_auth_chap.c        |   37 +-
 drivers/target/lio-target/iscsi_auth_chap.h        |    8 +-
 drivers/target/lio-target/iscsi_auth_kernel.h      |   22 +-
 drivers/target/lio-target/iscsi_crc.h              |    2 -
 drivers/target/lio-target/iscsi_debug_opcodes.c    |    2 -
 drivers/target/lio-target/iscsi_debug_opcodes.h    |    2 -
 drivers/target/lio-target/iscsi_linux_defs.h       |   38 -
 drivers/target/lio-target/iscsi_parameters.c       |  152 +-
 drivers/target/lio-target/iscsi_parameters.h       |   70 +-
 drivers/target/lio-target/iscsi_protocol.h         |   10 +-
 drivers/target/lio-target/iscsi_seq_and_pdu_list.c |   92 +-
 drivers/target/lio-target/iscsi_seq_and_pdu_list.h |   36 +-
 drivers/target/lio-target/iscsi_serial.c           |    5 -
 drivers/target/lio-target/iscsi_target.c           |  555 +++----
 drivers/target/lio-target/iscsi_target.h           |   76 +-
 drivers/target/lio-target/iscsi_target_configfs.c  |  232 ++--
 drivers/target/lio-target/iscsi_target_core.h      |  338 ++--
 .../target/lio-target/iscsi_target_datain_values.c |   79 +-
 .../target/lio-target/iscsi_target_datain_values.h |   16 +-
 drivers/target/lio-target/iscsi_target_debugerl.c  |   49 +-
 drivers/target/lio-target/iscsi_target_debugerl.h  |   16 +-
 drivers/target/lio-target/iscsi_target_device.c    |   30 +-
 drivers/target/lio-target/iscsi_target_device.h    |    8 +-
 drivers/target/lio-target/iscsi_target_discovery.c |   18 +-
 drivers/target/lio-target/iscsi_target_discovery.h |    4 +-
 drivers/target/lio-target/iscsi_target_erl0.c      |  116 +-
 drivers/target/lio-target/iscsi_target_erl0.h      |   24 +-
 drivers/target/lio-target/iscsi_target_erl1.c      |  170 +-
 drivers/target/lio-target/iscsi_target_erl1.h      |   44 +-
 drivers/target/lio-target/iscsi_target_erl2.c      |   86 +-
 drivers/target/lio-target/iscsi_target_erl2.h      |   26 +-
 drivers/target/lio-target/iscsi_target_login.c     |  131 +-
 drivers/target/lio-target/iscsi_target_login.h     |    8 +-
 drivers/target/lio-target/iscsi_target_mib.c       |  141 +-
 drivers/target/lio-target/iscsi_target_mib.h       |   20 +-
 drivers/target/lio-target/iscsi_target_nego.c      |   98 +-
 drivers/target/lio-target/iscsi_target_nego.h      |   10 +-
 .../target/lio-target/iscsi_target_nodeattrib.c    |   56 +-
 .../target/lio-target/iscsi_target_nodeattrib.h    |   18 +-
 drivers/target/lio-target/iscsi_target_tmr.c       |  168 +-
 drivers/target/lio-target/iscsi_target_tmr.h       |   16 +-
 drivers/target/lio-target/iscsi_target_tpg.c       |  274 ++--
 drivers/target/lio-target/iscsi_target_tpg.h       |  110 +-
 drivers/target/lio-target/iscsi_target_util.c      |  326 ++--
 drivers/target/lio-target/iscsi_target_util.h      |  132 +-
 drivers/target/lio-target/iscsi_target_version.h   |    2 +-
 drivers/target/lio-target/iscsi_thread_queue.c     |   60 +-
 drivers/target/lio-target/iscsi_thread_queue.h     |   30 +-
 drivers/target/target_core_alua.c                  |  324 ++--
 drivers/target/target_core_alua.h                  |  134 ++
 drivers/target/target_core_configfs.c              |  454 +++---
 drivers/target/target_core_device.c                |  362 ++---
 drivers/target/target_core_fabric_configfs.c       |  184 +-
 drivers/target/target_core_fabric_lib.c            |   56 +-
 drivers/target/target_core_file.c                  |  396 +++---
 drivers/target/target_core_file.h                  |  111 ++
 drivers/target/target_core_hba.c                   |   63 +-
 drivers/target/target_core_hba.h                   |   43 +
 drivers/target/target_core_iblock.c                |  466 +++---
 drivers/target/target_core_iblock.h                |   70 +
 drivers/target/target_core_mib.c                   |   81 +-
 drivers/target/target_core_mib.h                   |   57 +
 drivers/target/target_core_plugin.c                |  326 ----
 drivers/target/target_core_pr.c                    |  560 +++---
 drivers/target/target_core_pr.h                    |   67 +
 drivers/target/target_core_pscsi.c                 |  412 +++--
 drivers/target/target_core_pscsi.h                 |   97 +
 drivers/target/target_core_rd.c                    |  419 +++--
 drivers/target/target_core_rd.h                    |  119 ++
 drivers/target/target_core_scdb.c                  |    7 +-
 drivers/target/target_core_scdb.h                  |   42 +
 drivers/target/target_core_seobj.c                 |  522 +------
 drivers/target/target_core_seobj.h                 |   47 +
 drivers/target/target_core_stgt.c                  |  283 ++--
 drivers/target/target_core_stgt.h                  |   85 +
 drivers/target/target_core_tmr.c                   |  148 +-
 drivers/target/target_core_tpg.c                   |  187 +--
 drivers/target/target_core_transport.c             | 1835 ++++++++++----------
 drivers/target/target_core_ua.c                    |   62 +-
 drivers/target/target_core_ua.h                    |   36 +
 drivers/target/tcm_fc/Kbuild                       |    4 -
 drivers/target/tcm_fc/tcm_fc.h                     |   48 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |   42 +-
 drivers/target/tcm_fc/tfc_conf.c                   |   58 +-
 drivers/target/tcm_fc/tfc_io.c                     |   22 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   18 +-
 drivers/target/tcm_loop/Kconfig                    |   13 +
 drivers/target/tcm_loop/tcm_loop_configfs.c        |   63 +-
 drivers/target/tcm_loop/tcm_loop_core.h            |   24 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c          |   95 +-
 drivers/target/tcm_loop/tcm_loop_fabric.h          |   66 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c     |  174 ++-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h     |    6 +-
 include/target/target_core_alua.h                  |  134 --
 include/target/target_core_base.h                  |  479 +++---
 include/target/target_core_configfs.h              |    4 +-
 include/target/target_core_device.h                |   89 +-
 include/target/target_core_fabric_configfs.h       |   16 +-
 include/target/target_core_fabric_lib.h            |   36 +-
 include/target/target_core_fabric_ops.h            |  116 +-
 include/target/target_core_file.h                  |  223 ---
 include/target/target_core_hba.h                   |   43 -
 include/target/target_core_iblock.h                |  173 --
 include/target/target_core_mib.h                   |   57 -
 include/target/target_core_plugin.h                |   73 -
 include/target/target_core_pr.h                    |   67 -
 include/target/target_core_pscsi.h                 |  202 ---
 include/target/target_core_rd.h                    |  259 ---
 include/target/target_core_scdb.h                  |   42 -
 include/target/target_core_seobj.h                 |  114 --
 include/target/target_core_stgt.h                  |  198 ---
 include/target/target_core_tmr.h                   |    8 +-
 include/target/target_core_tpg.h                   |   48 +-
 include/target/target_core_transport.h             |  416 +++---
 include/target/target_core_transport_plugin.h      |   67 -
 include/target/target_core_ua.h                    |   36 -
 120 files changed, 6986 insertions(+), 8697 deletions(-)


