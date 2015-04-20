From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 15/18] megaraid_sas : bytewise or should be done on native endian variables
Date: Mon, 20 Apr 2015 18:04:50 +0530
Message-ID: <201504201237.t3KCb2qu016707@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:25236
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755159AbbDTNvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 09:51:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7d34fe8..17ec153 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -651,7 +651,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 
 	frame_hdr = &cmd->frame->hdr;
 	frame_hdr->cmd_status = 0xFF;
-	frame_hdr->flags |= cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
+	frame_hdr->flags = cpu_to_le16(
+		le16_to_cpu(frame_hdr->flags) |
+		MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
 
 	init_frame->cmd	= MFI_CMD_INIT;
 	init_frame->cmd_status = 0xFF;
-- 
1.7.1

