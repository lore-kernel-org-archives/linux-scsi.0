From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 14/35] qla2xxx: ISPFx00 unexpected resets during adapter boot sequence.
Date: Wed, 24 Sep 2014 03:08:17 -0400
Message-ID: <1411542518-2477-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:25885 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbaIXHmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:45 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Jan Kulich <jan.kulich@qlogic.com>

Signed-off-by: Jan Kulich <jan.kulich@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 274707d..698be01 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1551,7 +1551,10 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 			ha->mr.fw_reset_timer_tick =
 			    QLAFX00_MAX_RESET_INTERVAL;
 		}
-		ha->mr.old_aenmbx0_state = aenmbx0;
+		if (ha->mr.old_aenmbx0_state != aenmbx0) {
+			ha->mr.old_aenmbx0_state = aenmbx0;
+			ha->mr.fw_reset_timer_tick = QLAFX00_RESET_INTERVAL;
+		}
 		ha->mr.fw_reset_timer_tick--;
 	}
 	if (test_bit(FX00_CRITEMP_RECOVERY, &vha->dpc_flags)) {
-- 
1.7.7

