From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/5] hisi_sas: for v2 hw only set ITCT qw2 for SAS device
Date: Fri, 8 Apr 2016 17:23:14 +0800
Message-ID: <1460107395-24501-5-git-send-email-john.garry@huawei.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:2258 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbcDHJIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 05:08:32 -0400
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

This patch fixes the ITCT table setup as it should be
configured differently for SAS and SATA devices.
For SATA disks there is no need to set qw2 (already
zeroed).
Also, link parameters for Bus inactive limit, max
connection time limit, and reject to open limit timers
parameters are changed to match global config register,
MAX_CON_TIME_LIMIT_TIME, as recommended by hw team.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cc083b9..4276594 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -554,10 +554,11 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 	itct->sas_addr = __swab64(itct->sas_addr);
 
 	/* qw2 */
-	itct->qw2 = cpu_to_le64((500ULL << ITCT_HDR_INLT_OFF) |
-				(0xff00ULL << ITCT_HDR_BITLT_OFF) |
-				(0xff00ULL << ITCT_HDR_MCTLT_OFF) |
-				(0xff00ULL << ITCT_HDR_RTOLT_OFF));
+	if (!dev_is_sata(device))
+		itct->qw2 = cpu_to_le64((500ULL << ITCT_HDR_INLT_OFF) |
+					(0x1ULL << ITCT_HDR_BITLT_OFF) |
+					(0x32ULL << ITCT_HDR_MCTLT_OFF) |
+					(0x1ULL << ITCT_HDR_RTOLT_OFF));
 }
 
 static void free_device_v2_hw(struct hisi_hba *hisi_hba,
@@ -715,7 +716,7 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, HGC_SAS_TX_OPEN_FAIL_RETRY_CTRL, 0x7FF);
 	hisi_sas_write32(hisi_hba, OPENA_WT_CONTI_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, I_T_NEXUS_LOSS_TIME, 0x1F4);
-	hisi_sas_write32(hisi_hba, MAX_CON_TIME_LIMIT_TIME, 0x4E20);
+	hisi_sas_write32(hisi_hba, MAX_CON_TIME_LIMIT_TIME, 0x32);
 	hisi_sas_write32(hisi_hba, BUS_INACTIVE_LIMIT_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
 	hisi_sas_write32(hisi_hba, HGC_ERR_STAT_EN, 0x1);
-- 
1.9.1

