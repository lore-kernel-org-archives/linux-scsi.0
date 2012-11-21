From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/19] qla2xxx: Clear unsupported 'states' during Get-FW-State queries.
Date: Wed, 21 Nov 2012 02:40:26 -0500
Message-ID: <1353483644-17262-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:53964 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752143Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Rather than returning stale mailbox values.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 48fca47..214c0e9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1971,6 +1971,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 		    "Waiting for LIP to complete.\n");
 
 	do {
+		memset(state, -1, sizeof(state));
 		rval = qla2x00_get_firmware_state(vha, state);
 		if (rval == QLA_SUCCESS) {
 			if (state[0] < FSTATE_LOSS_OF_SYNC) {
-- 
1.7.7

