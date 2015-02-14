From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/8] target: Fail UNMAP when emulate_tpu=0
Date: Sat, 14 Feb 2015 03:27:42 +0000
Message-ID: <1423884463-16797-8-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57524 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbbBNEBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2015 23:01:12 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so26906596obc.7
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 20:01:12 -0800 (PST)
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a check within sbc_parse_cdb() to fail a UNMAP op,
if the backend device has emulate_tpu disabled.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 0d307c3..9661a66 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -962,6 +962,11 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
+		if (!dev->dev_attrib.emulate_tpu) {
+			pr_err("Got UNMAP, but backend device has"
+			       " emulate_tpu disabled\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
 		size = get_unaligned_be16(&cdb[7]);
 		cmd->execute_cmd = ops->execute_unmap;
 		break;
-- 
1.9.1

