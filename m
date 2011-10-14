From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/37] target: Updates for v3.2-rc1 (round one)
Date: Fri, 14 Oct 2011 00:41:32 +0000
Message-ID: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33346 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1JNAnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:43:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This is the current set of target patches in the queue for v3.2-rc1.  This
includes a number of cleanups from Christoph and various folks, and a handful
of bugfixes from Roland & Co. that will eventually need to be queued to stable
as well.  There are really no controversial changes this time around, but
please have a look and let us know if anything needs more attention.

I'll plan to send a PULL request for these next week once the v3.2 window
offically opens up.

Thank you,

--nab

Andy Shevchenko (3):
  target: simplify target_parse_naa_6h_vendor_specific()
  iscsi-target: use native hex2bin for chap_string_to_hex
  tcm_fc: remove custom hex_to_bin in ft_parse_wwn

Christoph Hellwig (20):
  tfm_fc: use transport_handle_cdb_direct
  iscsi-target: always call transport_handle_cdb_direct
  target: remove transport_generic_handle_cdb
  target: don't opencode transport_release_cmd in
    transport_release_fe_cmd
  target: remove transport_free_se_cmd
  target: simplify transport_generic_remove
  target: simplify transport_put_cmd
  target: remove transport_generic_remove
  target: push session reinstatement out of transport_generic_free_cmd
  target: cleanup iblock bio submission
  target: cleanup pscsi request submission
  target: remove unused se_subsystem_api methods
  target: Cleanup unused target_core_base.h bits
  target: Cleanup unused se_task bits
  target: make more use of the task_flags field in se_task
  target: Remove unnecessary se_task members
  target: pack struct se_task more tightly
  target: make the ->get_cdb method optional
  target: replace ->get_cdb with a target_get_task_cdb helper
  target: remove the ->transport_split_cdb callback in se_cmd

Dan Carpenter (1):
  target: Make pscsi_create_virtdevice use ERR_CAST

Jesper Juhl (1):
  target: Remove unneeded version.h includes

Nicholas Bellinger (10):
  target: Re-org of core_tmr_lun_reset
  target: Prevent TRANSPORT_FREE_CMD_INTR processing in
    core_tmr_drain_cmd_list
  target: Fix transport_cmd_finish_abort queue removal bug
  target: Prevent transport_send_task_abort when CHECK_CONDITION status
  target: Remove session_reinstatement parameter from
    ->transport_wait_for_tasks
  target: Convert ->transport_wait_for_tasks usage to
    transport_generic_free_cmd
  iscsi-target: Remove SCF_SE_LUN_CMD flag abuses
  target: Merge transport_cmd_finish_abort_tmr into
    transport_cmd_finish_abort
  target: Remove legacy + unused device active I/O shutdown code
  loopback: Prevent uninitialized use of tl_tpg in
    tcm_loop_queuecommand

Roland Dreier (2):
  target: Prevent cmd->se_queue_node double add
  target: Have core_tmr_alloc_req() take an explicit GFP_xxx flag

 drivers/target/Makefile                      |    1 -
 drivers/target/iscsi/iscsi_target.c          |   39 +--
 drivers/target/iscsi/iscsi_target_auth.c     |   34 +--
 drivers/target/iscsi/iscsi_target_core.h     |    3 +
 drivers/target/iscsi/iscsi_target_erl2.c     |   49 +--
 drivers/target/iscsi/iscsi_target_tmr.c      |    2 +-
 drivers/target/iscsi/iscsi_target_util.c     |   20 +-
 drivers/target/iscsi/iscsi_target_util.h     |    1 +
 drivers/target/loopback/tcm_loop.c           |   18 +-
 drivers/target/target_core_alua.c            |    1 -
 drivers/target/target_core_cdb.c             |   78 +++-
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_file.c            |   23 +-
 drivers/target/target_core_file.h            |    4 +-
 drivers/target/target_core_iblock.c          |  203 ++-----
 drivers/target/target_core_iblock.h          |    2 -
 drivers/target/target_core_pr.c              |    1 -
 drivers/target/target_core_pscsi.c           |  281 ++++-------
 drivers/target/target_core_pscsi.h           |    1 -
 drivers/target/target_core_rd.c              |   19 +-
 drivers/target/target_core_rd.h              |    2 -
 drivers/target/target_core_scdb.c            |  105 ----
 drivers/target/target_core_scdb.h            |   10 -
 drivers/target/target_core_stat.c            |    1 -
 drivers/target/target_core_tmr.c             |  224 +++++---
 drivers/target/target_core_transport.c       |  751 ++++++--------------------
 drivers/target/target_core_ua.c              |    1 -
 drivers/target/tcm_fc/tfc_cmd.c              |   17 +-
 drivers/target/tcm_fc/tfc_conf.c             |   13 +-
 drivers/target/tcm_fc/tfc_io.c               |    1 -
 drivers/target/tcm_fc/tfc_sess.c             |    1 -
 include/target/target_core_base.h            |   55 +--
 include/target/target_core_tmr.h             |    2 +-
 include/target/target_core_transport.h       |   35 +-
 35 files changed, 640 insertions(+), 1360 deletions(-)
 delete mode 100644 drivers/target/target_core_scdb.c
 delete mode 100644 drivers/target/target_core_scdb.h

