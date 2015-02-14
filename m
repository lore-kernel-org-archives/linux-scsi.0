From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/8] target: Check for LBA + sectors wrap-around in sbc_parse_cdb
Date: Sat, 14 Feb 2015 03:27:37 +0000
Message-ID: <1423884463-16797-3-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52829 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbbBNEBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2015 23:01:07 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so26870407obc.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 20:01:06 -0800 (PST)
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a check to sbc_parse_cdb() in order to detect when
an LBA + sector vs. end-of-device calculation wraps when the LBA is
sufficently large enough (eg: 0xFFFFFFFFFFFFFFFF).

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b26b52f..17259c0 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -982,7 +982,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		}
 check_lba:
 		end_lba = dev->transport->get_blocks(dev) + 1;
-		if (cmd->t_task_lba + sectors > end_lba) {
+		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
+		    ((cmd->t_task_lba + sectors) > end_lba)) {
 			pr_err("cmd exceeds last lba %llu "
 				"(lba %llu, sectors %u)\n",
 				end_lba, cmd->t_task_lba, sectors);
-- 
1.9.1

