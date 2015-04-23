From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 14/18] megaraid_sas : move endianess conversion into
 caller of megasas_get_seq_num
Date: Thu, 23 Apr 2015 16:33:24 +0530
Message-ID: <201504231105.t3NB5eic030682@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:30784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932980AbbDWLDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:03:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Converting structure fields in place is always a bad idea, and in this case
by moving it into the only caller we also only have to do a single byte
swap as most fields of this structure are never used.

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9299eaf..8407b9b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4891,11 +4891,11 @@ megasas_get_seq_num(struct megasas_instance *instance,
 		/*
 		 * Copy the data back into callers buffer
 		 */
-		eli->newest_seq_num = le32_to_cpu(el_info->newest_seq_num);
-		eli->oldest_seq_num = le32_to_cpu(el_info->oldest_seq_num);
-		eli->clear_seq_num = le32_to_cpu(el_info->clear_seq_num);
-		eli->shutdown_seq_num = le32_to_cpu(el_info->shutdown_seq_num);
-		eli->boot_seq_num = le32_to_cpu(el_info->boot_seq_num);
+		eli->newest_seq_num = el_info->newest_seq_num;
+		eli->oldest_seq_num = el_info->oldest_seq_num;
+		eli->clear_seq_num = el_info->clear_seq_num;
+		eli->shutdown_seq_num = el_info->shutdown_seq_num;
+		eli->boot_seq_num = el_info->boot_seq_num;
 	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
@@ -5055,7 +5055,7 @@ static int megasas_start_aen(struct megasas_instance *instance)
 	class_locale.members.class = MR_EVT_CLASS_DEBUG;
 
 	return megasas_register_aen(instance,
-			eli.newest_seq_num + 1,
+			le32_to_cpu(eli.newest_seq_num) + 1,
 			class_locale.word);
 }
 
-- 
1.7.1

