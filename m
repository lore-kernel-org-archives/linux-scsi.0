From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/23] advansys: scsi_q1->data_addr is little endian
Date: Fri, 24 Apr 2015 13:18:32 +0200
Message-ID: <1429874322-85488-15-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966708AbbDXLSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:51 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'data_addr' field is accessed by the board, and needs
to be kept in little endian format.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ad5c5f9..a6bc8aa 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8230,8 +8230,8 @@ AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
 	sg_head = scsiq->sg_head;
 	saved_data_addr = scsiq->q1.data_addr;
 	saved_data_cnt = scsiq->q1.data_cnt;
-	scsiq->q1.data_addr = sg_head->sg_list[0].addr;
-	scsiq->q1.data_cnt = sg_head->sg_list[0].bytes;
+	scsiq->q1.data_addr = cpu_to_le32(sg_head->sg_list[0].addr);
+	scsiq->q1.data_cnt = cpu_to_le32(sg_head->sg_list[0].bytes);
 #if CC_VERY_LONG_SG_LIST
 	/*
 	 * If sg_head->entry_cnt is greater than ASC_MAX_SG_LIST
@@ -8467,8 +8467,8 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		}
 #endif /* !CC_VERY_LONG_SG_LIST */
 		if (sg_entry_cnt == 1) {
-			scsiq->q1.data_addr = sg_head->sg_list[0].addr;
-			scsiq->q1.data_cnt = sg_head->sg_list[0].bytes;
+			scsiq->q1.data_addr = cpu_to_le32(sg_head->sg_list[0].addr);
+			scsiq->q1.data_cnt = cpu_to_le32(sg_head->sg_list[0].bytes);
 			scsiq->q1.cntl &= ~(QC_SG_HEAD | QC_SG_SWAP_QUEUE);
 		}
 		sg_entry_cnt_minus_one = sg_entry_cnt - 1;
-- 
1.8.5.2

