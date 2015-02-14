From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/8] target: Fail WRITE_SAME w/ UNMAP=1 when emulate_tpws=0
Date: Sat, 14 Feb 2015 03:27:41 +0000
Message-ID: <1423884463-16797-7-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50878 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbbBNEBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2015 23:01:11 -0500
Received: by mail-ob0-f172.google.com with SMTP id nt9so26905441obb.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 20:01:10 -0800 (PST)
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a check within sbc_setup_write_same() to fail a
WRITE_SAME w/ UNMAP=1 op, if the backend device has emulate_tpws
disabled.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 856e800..0d307c3 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -293,6 +293,11 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 		if (!ops->execute_write_same_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
+		if (!dev->dev_attrib.emulate_tpws) {
+			pr_err("Got WRITE_SAME w/ UNMAP=1, but backend device"
+			       " has emulate_tpws disabled\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
 		cmd->execute_cmd = ops->execute_write_same_unmap;
 		return 0;
 	}
-- 
1.9.1

