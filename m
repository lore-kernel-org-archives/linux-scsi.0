From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 8/8] target: Set LBPWS10 bit in Logical Block Provisioning EVPD
Date: Sat, 14 Feb 2015 03:27:43 +0000
Message-ID: <1423884463-16797-9-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50873 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbbBNEBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2015 23:01:13 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so26291547obb.13
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 20:01:13 -0800 (PST)
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch sets the missing LBPWS10 bit within spc_emulate_evpd_b2()
in order to signal WRITE_SAME (10) w/ UNMAP support, following the
existing LBPWS bit to signal WRITE_SAME (16) w/ UNMAP support.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 1307600..f041f93 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -650,7 +650,7 @@ spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 	 * support the use of the WRITE SAME (16) command to unmap LBAs.
 	 */
 	if (dev->dev_attrib.emulate_tpws != 0)
-		buf[5] |= 0x40;
+		buf[5] |= 0x40 | 0x20;
 
 	return 0;
 }
-- 
1.9.1

