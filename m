From: giridhar.malavali@qlogic.com
Subject: [PATCH 5/6] qla2xxx: Prevent sending mbx commands from sysfs during isp reset.
Date: Fri, 19 Mar 2010 16:59:20 -0700
Message-ID: <1269043161-2265-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46304 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752289Ab0CSX7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:25 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

The fix prevents application path from sending get-firmware-state mbx command
during as isp reset.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 90d1e06..35a3252 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1274,7 +1274,11 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 	int rval = QLA_FUNCTION_FAILED;
 	uint16_t state[5];
 
-	if (!vha->hw->flags.eeh_busy)
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+		DEBUG2_3_11(printk("%s(%ld): isp reset in progress.\n",
+			__func__, vha->host_no));
+	else if (!vha->hw->flags.eeh_busy)
 		rval = qla2x00_get_firmware_state(vha, state);
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
-- 
1.6.2.rc1.30.gd43c

