From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 21/23] qla2xxx: Don't process state change aen for reset owner.
Date: Fri,  8 Feb 2013 01:58:02 -0500
Message-ID: <1360306684-8286-22-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:39132 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760012Ab3BHHTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:12 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d62fd1a..cbf6a43 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -491,6 +491,8 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	if (mb[1] & IDC_DEVICE_STATE_CHANGE) {
 		ql_log(ql_log_info, vha, 0x506a,
 		    "IDC Device-State changed = 0x%x.\n", mb[4]);
+		if (ha->flags.nic_core_reset_owner)
+			return;
 		qla83xx_schedule_work(vha, MBA_IDC_AEN);
 	}
 }
-- 
1.7.7

