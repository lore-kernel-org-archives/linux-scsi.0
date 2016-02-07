From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sun,  7 Feb 2016 03:17:57 +0000
Message-ID: <1454815082-15380-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34765 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcBGDVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2016 22:21:09 -0500
Received: by mail-oi0-f48.google.com with SMTP id w5so63383773oie.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Feb 2016 19:21:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here is -v4 series to address the set of of LUN_RESET
active I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
recently by Quinn & Co.  This can occur during active
I/O remote port TMR LUN_RESET with multi-port LIO
configurations.

To address this bug, we add a __target_check_io_state()
common handler for ABORT_TASK + LUN_RESET I/O abort
cases, and move the remaining se_cmd SGL page + release
into target_free_cmd_mem() to now be called directly
from final target_release_cmd_kref() callback.

It also adds a target_wait_free_cmd() helper and makes
transport_generic_free_cmd() aware of CMD_T_ABORTED
status during concurrent session disconnects, and
introduces CMD_T_FABRIC_STOP bit to signal this special
case.

Currently this series is running atop v4.5-rc1 + v3.14.y,
and with iscsi-target ports is able to survive active
I/O remote-port LUN resets, plus remote-port LUN_RESET
with concurrent simulated session disconnects.

At this point the changes are stable with iscsi-target
ports, and as Himanshu + Co can verify with tcm_qla2xxx
should be considered ready to merge for -rc4.

Please review + test.

--nab

v4 changes:

- Add explicit CMD_T_FABRIC_STOP check and drop cmd_wait_set
  bit set usage in __target_check_io_state().
- Set early CMD_T_TAS in __target_check_io_state to avoid
  potential race in transport_send_task_abort() with shutdown.
- Add fabric_stop + aborted checks in __transport_wait_for_tasks()
  in order to let TMR CMD_T_ABORTED se_cmd shutdown complete
  during concurrent session disconnect.
- Fix race with driver SCF_SEND_DELAYED_TAS handling when
  __transport_check_aborted_status() could happen before
  transport_send_task_abort() in TMR kthread context.

Nicholas Bellinger (5):
  target: Fix LUN_RESET active I/O handling for ACK_KREF
  target: Fix LUN_RESET active TMR descriptor handling
  target: Fix TAS handling for multi-session se_node_acls
  target: Fix remote-port TMR ABORT + se_cmd fabric stop
  target: Fix race with SCF_SEND_DELAYED_TAS handling

 drivers/target/target_core_tmr.c       | 139 ++++++++++++-----
 drivers/target/target_core_transport.c | 278 +++++++++++++++++++++++----------
 include/target/target_core_base.h      |   3 +
 3 files changed, 301 insertions(+), 119 deletions(-)

-- 
1.9.1

