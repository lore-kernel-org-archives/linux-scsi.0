From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] megaraid_sas: bytewise or should be done on native endian variables
Date: Sat, 10 Jan 2015 18:11:19 +0100
Message-ID: <1420909883-19479-7-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbbAJRMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:22 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 82439f9..b1e053b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -673,7 +673,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 
 	frame_hdr = &cmd->frame->hdr;
 	frame_hdr->cmd_status = 0xFF;
-	frame_hdr->flags |= cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
+	frame_hdr->flags = cpu_to_le16(
+		le16_to_cpu(frame_hdr->flags) |
+		MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
 
 	init_frame->cmd	= MFI_CMD_INIT;
 	init_frame->cmd_status = 0xFF;
-- 
1.9.1

