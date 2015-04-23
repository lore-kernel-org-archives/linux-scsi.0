From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 18/18] megaraid_sas : swap whole register in
 megasas_register_aen
Date: Thu, 23 Apr 2015 16:34:24 +0530
Message-ID: <201504231106.t3NB6ejI031024@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:61856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964830AbbDWLEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:04:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Swap the whole 32 bits we read from the hardware instead of swapping
just the 16bits we care about in place later.

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 351d0b7..8309e01 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4946,8 +4946,8 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 
 	if (instance->aen_cmd) {
 
-		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];
-		prev_aen.members.locale = le16_to_cpu(prev_aen.members.locale);
+		prev_aen.word =
+			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
 
 		/*
 		 * A class whose enum value is smaller is inclusive of all
-- 
1.7.1

