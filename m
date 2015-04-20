From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 18/18] megaraid_sas : swap whole register in
 megasas_register_aen
Date: Mon, 20 Apr 2015 18:05:20 +0530
Message-ID: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:37696
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755218AbbDTNvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 09:51:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Swap the whole 32 bits we read from the hardware instead of swapping
just the 16bits we care about in place later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e863701..fa6c3c9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4923,8 +4923,9 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 
 	if (instance->aen_cmd) {
 
-		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];
-		prev_aen.members.locale = le16_to_cpu(prev_aen.members.locale);
+		prev_aen.word =
+			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
+		prev_aen.members.locale = prev_aen.members.locale;
 
 		/*
 		 * A class whose enum value is smaller is inclusive of all
-- 
1.7.1

