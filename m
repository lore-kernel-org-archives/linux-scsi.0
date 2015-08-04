From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  04/14] qla2xxx: Pause risc before manipulating risc semaphore.
Date: Tue, 4 Aug 2015 13:37:54 -0400
Message-ID: <1438709884-623-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:54044 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbbHDSXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:52 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6930966..5d04c8c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1287,6 +1287,9 @@ qla25xx_manipulate_risc_semaphore(scsi_qla_host_t *vha)
 	    vha->hw->pdev->subsystem_device != 0x0240)
 		return;
 
+	WRT_REG_DWORD(&vha->hw->iobase->isp24.hccr, HCCRX_SET_RISC_PAUSE);
+	udelay(100);
+
 attempt:
 	timeout_msec = TIMEOUT_SEMAPHORE;
 	n = timeout_msec / delta_msec;
-- 
1.7.7

