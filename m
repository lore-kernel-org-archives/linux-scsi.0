From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 11/35] qla2xxx: ISPFX00 avoid writing semaphore register in request_irqs().
Date: Thu, 25 Sep 2014 05:16:42 -0400
Message-ID: <1411636626-7566-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:59719 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbaIYJvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:17 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Semaphore register does not exist for ISPFx00.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a0992bf..223c1a8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3098,10 +3098,11 @@ skip_msi:
 	}
 
 clear_risc_ints:
+	if (IS_FWI2_CAPABLE(ha) || IS_QLAFX00(ha))
+		goto fail;
 
 	spin_lock_irq(&ha->hardware_lock);
-	if (!IS_FWI2_CAPABLE(ha))
-		WRT_REG_WORD(&reg->isp.semaphore, 0);
+	WRT_REG_WORD(&reg->isp.semaphore, 0);
 	spin_unlock_irq(&ha->hardware_lock);
 
 fail:
-- 
1.7.7

