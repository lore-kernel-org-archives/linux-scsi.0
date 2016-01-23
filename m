From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/3] target: Fix LUN_RESET active I/O + TMR handling
Date: Sat, 23 Jan 2016 01:37:44 +0000
Message-ID: <1453513067-23169-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33690 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbcAWBkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 20:40:21 -0500
Received: by mail-ob0-f171.google.com with SMTP id is5so77200505obc.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 17:40:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here is -v2 series to address two LUN_RESET active
I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
recently by Quinn & Co.  This bug can occur during
active I/O remote port TMR LUN_RESET with multi-port
LIO configurations.

To address this bug, it adds __target_check_io_state()
common handler for ABORT_TASK + LUN_RESET I/O abort
cases, and moves remaining se_cmd SGL page + release
into target_free_cmd_mem() to now be called directly
from the final target_release_cmd_kref() callback.

Following __target_check_io_state(), it also obtains
kref_get_unless_zero(&se_cmd->cmd_kref) for TMR descs
during LUN_RESET in core_tmr_drain_tmr_list(), in order
to utilize common transport_wait_for_tasks() code when
se_cmd + se_tmr_req descriptors are being aborted or
shutdown.

At this point the changes are able to survive multi-port
active I/O LUN_RESET using iscsi-target ports against
Linux + ESX hosts with TAS=1.

Note there is still a known issue wrt multi-port active
I/O LUN_RESET when se_session shutdown occurs at the
same time, that I'm still groking and will need to be
addressed for -v3 code.

Quinn + Co, please have a look at qla2xxx + TAS with
this series when you've got a moment, and let us know
how active I/O LUN_RESET works with your test-case.

Thank you,

--nab

v2 changes:
   - Fix TAS handling for multi-session se_node_acls
   - Change target_complete_cmd() to check for ABORTED || STOP
   - Avoid calling target_remove_from_state_list() with
     se_cmd->t_state_lock held in transport_cmd_check_stop()
   - Add missing target_free_cmd_mem() in target_put_sess_cmd()
     special case.
   - Add a more useful __target_check_io_state() comment
   - Use assert_spin_locked() + WARN_ON_ONCE() when necessary
   - Drop unnecessary !list_empty check

Nicholas Bellinger (3):
  target: Fix LUN_RESET active I/O handling for ACK_KREF
  target: Fix LUN_RESET active TMR descriptor handling
  target: Fix TAS handling for multi-session se_node_acls

 drivers/target/target_core_tmr.c       | 104 ++++++++++++++++++++++++---------
 drivers/target/target_core_transport.c |  73 ++++++++++++++---------
 include/target/target_core_base.h      |   1 +
 3 files changed, 122 insertions(+), 56 deletions(-)

-- 
1.9.1

