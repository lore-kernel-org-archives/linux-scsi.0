From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT
 request
Date: Wed, 10 Nov 2010 15:04:53 -0800
Message-ID: <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2043 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

In the case the chip is undergoing different invasive operation
which requires a chip reset, all NOPOUT request during this period
must be silently dropped from queuing to the hardware.  This patch
will respond to libiscsi immediately with sent success.  Since the
request was not actually sent, the NOPIN wait timeout will get
triggered and another NOPOUT request will commence through the
proper channel.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b32baf8..507cd25 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1068,6 +1068,22 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
 	char *buf;
 	int data_len;
 
+	/*
+	 * Forcefully terminate all in progress connection recovery at the
+	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
+	 */
+	if (bnx2i_adapter_ready(bnx2i_conn->ep->hba)) {
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
+		    ISCSI_OP_NOOP_OUT)
+			/* This is a WA to indicate to libiscsi that the nopout
+			 * request was sent successfully without actually
+			 * submitting to the hardware.
+			 * Just silently drop the nopout request
+			 */
+			return 0;
+		else
+			return -EIO;
+	}
 	bnx2i_iscsi_prep_generic_pdu_bd(bnx2i_conn);
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
-- 
1.7.0.5


