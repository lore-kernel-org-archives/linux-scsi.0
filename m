From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/22] qla2xxx: Correctly set mailboxes for extended init control block.
Date: Wed, 30 Oct 2013 03:38:11 -0400
Message-ID: <1383118709-5569-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:31030 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753164Ab3J3IMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:12:05 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a9aae50..ccc30d4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1214,7 +1214,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
 	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	if ((IS_QLA81XX(ha) || IS_QLA83XX(ha)) && ha->ex_init_cb->ex_version) {
+	if (ha->ex_init_cb && ha->ex_init_cb->ex_version) {
 		mcp->mb[1] = BIT_0;
 		mcp->mb[10] = MSW(ha->ex_init_cb_dma);
 		mcp->mb[11] = LSW(ha->ex_init_cb_dma);
-- 
1.7.7

