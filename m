From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sat, 30 Jan 2016 05:36:57 +0000
Message-ID: <1454132222-29009-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36471 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcA3Fjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2016 00:39:51 -0500
Received: by mail-oi0-f51.google.com with SMTP id o124so60304102oia.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 21:39:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This is -v3 series to address three LUN_RESET active
I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
recently by Quinn & Co.  This can occur during active
I/O remote port TMR LUN_RESET with multi-port LIO
configurations.

To address this bug, it adds __target_check_io_state()
common handler for ABORT_TASK + LUN_RESET I/O abort
cases, and moves remaining se_cmd SGL page + release
into target_free_cmd_mem() to now be called directly
from the final target_release_cmd_kref() callback.

New for -v3, patch #4 is to address the case where
se_cmd driver level shutdown occurs while TMR
CMD_T_ABORTED is already happening.  It introduces
CMD_T_FABRIC_STOP to replace CMD_T_REQUEST_STOP,
and use existing ->cmd_wait_set + ->cmd->wait_comp
to handle this special case for existing drivers.

Note that #4 + #5 needs more testing, so likely
patch #1 + #3 will be pushed in the next -rc to
address the primary case, ahead of the other to
fix the special case and drop legacy left-overs.

Please review.

--nab

v3 changes:

- Drop unncessary braces in core_tmr_handle_tas_abort
- Drop misleading printk() during __target_check_io_state() failure
- Avoid calling target_remove_from_state_list() from
  transport_generic_free_cmd with cmd->t_state_lock held.
- Make TMR ABORTED use se_cmd->cmd_wait_set + ->cmd_wait_comp
  during shutdown.
- Take ->cmd_kref during target_sess_cmd_list_set_waiting(),
  and drop in target_wait_for_sess_cmds()
- Pass 'fabric_stop' to transport_wait_for_tasks(), and make
  transport_generic_free_cmd() aware of aborted + tas status
  bits.
- Drop left-over ->task_stop_comp + CMD_T_REQUEST_STOP

Nicholas Bellinger (5):
  target: Fix LUN_RESET active I/O handling for ACK_KREF
  target: Fix LUN_RESET active TMR descriptor handling
  target: Fix TAS handling for multi-session se_node_acls
  target: Fix remote-port TMR ABORT + se_cmd fabric stop
  target: Drop legacy se_cmd->task_stop_comp + REQUEST_STOP usage

 drivers/target/iscsi/iscsi_target_erl2.c |   3 +-
 drivers/target/target_core_internal.h    |   1 -
 drivers/target/target_core_tmr.c         | 137 ++++++++++++++++++-----
 drivers/target/target_core_transport.c   | 186 +++++++++++++++++--------------
 include/target/target_core_base.h        |   7 +-
 include/target/target_core_fabric.h      |   2 +-
 6 files changed, 220 insertions(+), 116 deletions(-)

-- 
1.9.1

