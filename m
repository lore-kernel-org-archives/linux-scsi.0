From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/35] qla2xxx: ISPFX00 avoid writing semaphore register in request_irqs().
Date: Wed, 24 Sep 2014 03:08:14 -0400
Message-ID: <1411542518-2477-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38304 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbaIXHnP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:43:15 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
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
index 550a4a3..6b2fe18 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3103,10 +3103,11 @@ skip_msi:
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

