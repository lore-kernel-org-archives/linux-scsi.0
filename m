From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/9] target: Optimizations + cleanups for v3.11
Date: Fri,  7 Jun 2013 21:34:15 +0000
Message-ID: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48565 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3FGVrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series contains a number of target optimizations added during
recent prototype scsi-mq performance profiling in order to avoid
unnecessary se_cmd->t_state_lock acquire/release in fast path I/O
submission and completion code.

All of the target optimizations are independent of driver code, so
all fabrics should benefit from these improvements.

Also included are two vhost/scsi specific patches, one in the same
vein to avoid unnecessary se_cmd->t_state_lock access, and the second
to convert vhost/scsi to proper cmd_kref TARGET_SCF_ACK_KREF usage.

Please have a look.

Thanks,

--nab

Nicholas Bellinger (9):
  target: Add transport_cmd_check_stop write_pending bit
  target: Drop unnecessary CMD_T_DEV_ACTIVE check from
    transport_lun_remove_cmd
  target: Remove legacy t_fe_count + avoid t_state_lock access in
    transport_put_cmd
  target: Avoid extra t_state_lock access in __target_execute_cmd
  target: Drop unnecessary t_state_lock access for
    SCF_SUPPORTED_SAM_OPCODE assignment
  iscsi-target: Avoid unnecessary t_state_lock during unsolicited
    data-out check
  target: Drop legacy se_cmd->check_release bit
  vhost/scsi: Drop unnecessary wait_for_tasks=true usage with
    transport_generic_free_cmd
  vhost/scsi: Convert to se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage

 drivers/target/iscsi/iscsi_target.c    |    6 ---
 drivers/target/target_core_tmr.c       |   12 +----
 drivers/target/target_core_transport.c |   72 ++++++++-----------------------
 drivers/vhost/scsi.c                   |   33 +++++++++------
 include/target/target_core_base.h      |    3 -
 5 files changed, 41 insertions(+), 85 deletions(-)

-- 
1.7.2.5

