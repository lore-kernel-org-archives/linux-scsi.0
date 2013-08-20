From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 5/9] target: Skip ->queue_data_in() callbacks for COMPARE_AND_WRITE
Date: Tue, 20 Aug 2013 20:07:56 +0000
Message-ID: <1377029280-19144-6-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:55945 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3HTUYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 16:24:04 -0400
Received: by mail-oa0-f50.google.com with SMTP id i4so1792135oah.37
        for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2013 13:24:03 -0700 (PDT)
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

COMPARE_AND_WRITE uses cmd->t_bidi_data_sg for it's READ payload
and cmd->data_direction == DMA_TO_DEVICE, but the payload is
only used for internal comparision, and never actually sent over
the wire.

So, check for this special case in to avoid TFO->queue_data_in()
within transport_complete_qf() + target_complete_ok_work() code.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f7dc479..60d1336 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1832,7 +1832,8 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		ret = cmd->se_tfo->queue_data_in(cmd);
 		break;
 	case DMA_TO_DEVICE:
-		if (cmd->t_bidi_data_sg) {
+		if (cmd->t_bidi_data_sg &&
+		    cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret < 0)
 				break;
@@ -1947,7 +1948,8 @@ static void target_complete_ok_work(struct work_struct *work)
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
-		if (cmd->t_bidi_data_sg) {
+		if (cmd->t_bidi_data_sg &&
+		    cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
 			if (cmd->se_lun->lun_sep) {
 				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
-- 
1.7.10.4

