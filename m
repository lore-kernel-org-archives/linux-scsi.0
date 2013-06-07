From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/9] iscsi-target: Avoid unnecessary t_state_lock during unsolicited data-out check
Date: Fri,  7 Jun 2013 21:34:21 +0000
Message-ID: <1370640864-15568-7-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48621 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3FGVr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:57 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

In modern iscsi-target code, the setup and I/O submission is done within a
single process context, so there is no need to acquire se_cmd->t_state_lock while
checking SCF_SUPPORTED_SAM_OPCODE for determining when unsolicited data-out
should be dumped.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 262ef1f..24783ee 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1277,7 +1277,6 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
 	struct iscsi_data *hdr = (struct iscsi_data *)buf;
 	struct iscsi_cmd *cmd = NULL;
 	struct se_cmd *se_cmd;
-	unsigned long flags;
 	u32 payload_length = ntoh24(hdr->dlength);
 	int rc;
 
@@ -1356,14 +1355,9 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
 		 */
 
 		/* Something's amiss if we're not in WRITE_PENDING state... */
-		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
 		WARN_ON(se_cmd->t_state != TRANSPORT_WRITE_PENDING);
-		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
-
-		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
 		if (!(se_cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE))
 			dump_unsolicited_data = 1;
-		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
 
 		if (dump_unsolicited_data) {
 			/*
-- 
1.7.2.5

