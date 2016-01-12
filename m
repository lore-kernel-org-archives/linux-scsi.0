From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] target: Fix LUN_RESET active I/O + TMR handling
Date: Tue, 12 Jan 2016 10:24:03 +0000
Message-ID: <1452594245-921-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This -v1 series is to address two LUN_RESET active
I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
recently by Quinn & Co, that can occur during
active I/O LUN_RESET with single / multiple LIO
export port configs.

To address this bug, add __target_check_io_state()
common handler for ABORT_TASK + LUN_RESET I/O abort
cases, and move remaining se_cmd SGL page + release
into target_free_cmd_mem() to now be called directly
from the final target_release_cmd_kref() callback.

Following __target_check_io_state() code, also obtain
kref_get_unless_zero(&se_cmd->cmd_kref) for LUN_RESET
TMR abort in core_tmr_drain_tmr_list(), in order to
utilize common transport_wait_for_tasks() code
when se_tmr_req descriptors are being shutdown.

Note there are a few more cleanups to be had but
have been left off for the moment, ahead of these
specific fixes getting merged for v4.5-rc code.

Please review,

--nab

Nicholas Bellinger (2):
  target: Fix LUN_RESET active I/O handling for ACK_KREF
  target: Fix LUN_RESET active TMR descriptor handling

 drivers/target/target_core_tmr.c       | 96 +++++++++++++++++++++++++++-------
 drivers/target/target_core_transport.c | 66 ++++++++++++++---------
 include/target/target_core_base.h      |  1 +
 3 files changed, 118 insertions(+), 45 deletions(-)

-- 
1.9.1
