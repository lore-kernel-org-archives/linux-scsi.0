From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/3] BNX2I: Fixed packet error created when the sq_size
 is set to 16
Date: Mon, 16 May 2011 11:13:18 -0700
Message-ID: <1305569600-1523-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1860 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1EPSNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 14:13:37 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The number of chip's internal command cell, which is use to generate
SCSI cmd packets to the target, was not initialized correctly by
the driver when the sq_size is changed from the default 128.
This, in turn, will create a problem where the chip's transmit pipe
will erroneously reuse an old command cell that is no longer valid.
The fix is to correctly initialize the chip's command cell upon setup.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index f0b8951..a8a2b6b 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1274,6 +1274,7 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 	iscsi_init.dummy_buffer_addr_hi =
 		(u32) ((u64) hba->dummy_buf_dma >> 32);
 
+	hba->num_ccell = hba->max_sqes >> 1;
 	hba->ctx_ccell_tasks =
 			((hba->num_ccell & 0xFFFF) | (hba->max_sqes << 16));
 	iscsi_init.num_ccells_per_conn = hba->num_ccell;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1809f9c..7b4d1d0 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1208,6 +1208,9 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 	struct bnx2i_cmd *cmd = task->dd_data;
 	struct iscsi_cmd *hdr = (struct iscsi_cmd *) task->hdr;
 
+	if (bnx2i_conn->ep->num_active_cmds + 1 > hba->max_sqes)
+		return -ENOMEM;
+
 	/*
 	 * If there is no scsi_cmnd this must be a mgmt task
 	 */
-- 
1.7.0.5


