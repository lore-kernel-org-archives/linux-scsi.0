From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 4/7] qla4xxx: Use offset based on adapter type to set CHAP entry in flash
Date: Tue, 17 Sep 2013 07:54:47 -0400
Message-ID: <1379418890-1141-5-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:6860 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418Ab3IQMZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:18 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

To write a CHAP entry in adapter's flash calculate the offset based
on the type of adapter.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 5eef7d1..121be42 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1537,6 +1537,7 @@ static int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username,
 	int rval = QLA_ERROR;
 	uint32_t offset = 0;
 	struct ql4_chap_table *chap_table;
+	uint32_t chap_size = 0;
 	dma_addr_t chap_dma;
 
 	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
@@ -1554,7 +1555,20 @@ static int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username,
 	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN);
 	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
-	offset = FLASH_CHAP_OFFSET | (idx * sizeof(struct ql4_chap_table));
+
+	if (is_qla40XX(ha)) {
+		chap_size = MAX_CHAP_ENTRIES_40XX * sizeof(*chap_table);
+		offset = FLASH_CHAP_OFFSET;
+	} else { /* Single region contains CHAP info for both ports which is
+		  * divided into half for each port.
+		  */
+		chap_size = ha->hw.flt_chap_size / 2;
+		offset = FLASH_RAW_ACCESS_ADDR + (ha->hw.flt_region_chap << 2);
+		if (ha->port_num == 1)
+			offset += chap_size;
+	}
+
+	offset += (idx * sizeof(struct ql4_chap_table));
 	rval = qla4xxx_set_flash(ha, chap_dma, offset,
 				sizeof(struct ql4_chap_table),
 				FLASH_OPT_RMW_COMMIT);
-- 
1.7.1

