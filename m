From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/7] iscsi-target: Fix padding breakage in iscsit_send_data_in
Date: Fri,  3 Jun 2011 18:18:13 -0700
Message-ID: <1307150298-23921-3-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:26458
	"HELO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752110Ab1FDBS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:18:56 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing cmd->padding assignment in iscsit_send_data_in()
that is required for proper iscsit_fe_sendpage_sg() operation.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 959f616..5a14318 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2508,7 +2508,6 @@ static int iscsit_send_data_in(
 	struct iscsi_datain_req *dr;
 	struct iscsi_data_rsp *hdr;
 	struct kvec *iov;
-	u32 padding;
 
 	memset(&datain, 0, sizeof(struct iscsi_datain));
 	dr = iscsit_get_datain_values(cmd, &datain);
@@ -2612,8 +2611,8 @@ static int iscsit_send_data_in(
 	iov_count += iov_ret;
 	tx_size += datain.length;
 
-	padding = ((-datain.length) & 3);
-	if (padding) {
+	cmd->padding = ((-datain.length) & 3);
+	if (cmd->padding) {
 		iov[iov_count].iov_base		= cmd->pad_bytes;
 		iov[iov_count++].iov_len	= cmd->padding;
 		tx_size += cmd->padding;
-- 
1.7.2.5

