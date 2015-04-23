From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 15/18] megaraid_sas : bytewise or should be done on
 native endian variables
Date: Thu, 23 Apr 2015 16:33:39 +0530
Message-ID: <201504231105.t3NB5t0U030759@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:22279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933591AbbDWLDo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:03:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b995774..487cd34 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -621,7 +621,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 
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

