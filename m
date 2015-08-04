From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  03/14] qla2xxx: Use ssdid to gate semaphore manipulation.
Date: Tue, 4 Aug 2015 13:37:53 -0400
Message-ID: <1438709884-623-4-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62791 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbbHDSXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:51 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Execute qla25xx_manipulate_risc_semaphore() only for
ssdid 0x0175 and 0x0240.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 11f2f32..6930966 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1277,14 +1277,14 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
 static void
 qla25xx_manipulate_risc_semaphore(scsi_qla_host_t *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
 	uint32_t wd32 = 0;
 	uint delta_msec = 100;
 	uint elapsed_msec = 0;
 	uint timeout_msec;
 	ulong n;
 
-	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha))
+	if (vha->hw->pdev->subsystem_device != 0x0175 &&
+	    vha->hw->pdev->subsystem_device != 0x0240)
 		return;
 
 attempt:
-- 
1.7.7

