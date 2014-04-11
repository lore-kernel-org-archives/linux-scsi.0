From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 24/42] qla2xxx: ISP8044 poll ipmdio bus timeout improvement.
Date: Fri, 11 Apr 2014 16:54:29 -0400
Message-ID: <1397249687-32666-25-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:40727 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbaDKVcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:39 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 75e947a..e5b4a40 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -175,18 +175,17 @@ qla8044_poll_wait_ipmdio_bus_idle(struct scsi_qla_host *vha,
 	uint32_t temp;
 
 	/* jiffies after 100 msecs */
-	timeout = jiffies + (HZ / 1000) * TIMEOUT_100_MS;
+	timeout = jiffies + msecs_to_jiffies(TIMEOUT_100_MS);
 	do {
 		temp = qla8044_ipmdio_rd_reg(vha, addr1, addr3, mask, addr2);
 		if ((temp & 0x1) != 1)
 			break;
-	} while (!time_after_eq(jiffies, timeout));
-
-	if (time_after_eq(jiffies, timeout)) {
-		ql_log(ql_log_warn, vha, 0xb152,
-		    "Error in processing mdiobus idle\n");
-		return -1;
-	}
+		if (time_after_eq(jiffies, timeout)) {
+			ql_log(ql_log_warn, vha, 0xb152,
+			    "Error in processing mdiobus idle\n");
+			return -1;
+		}
+	} while (1);
 
 	return 0;
 }
-- 
1.7.7

