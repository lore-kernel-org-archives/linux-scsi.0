From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/42] qla2xxx: Wait for reset completion without lock for ISPFX00.
Date: Fri, 11 Apr 2014 16:54:06 -0400
Message-ID: <1397249687-32666-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:9722 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 0aaf6a9..c1df39a 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -572,12 +572,13 @@ qlafx00_soc_cpu_reset(scsi_qla_host_t *vha)
 	/* Kick in Core0 to start boot process */
 	QLAFX00_SET_HBA_SOC_REG(ha, SOC_SW_RST_CONTROL_REG_CORE0, (0xF00));
 
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	/* Wait 10secs for soft-reset to complete. */
 	for (cnt = 10; cnt; cnt--) {
 		msleep(1000);
 		barrier();
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 /**
-- 
1.7.7

