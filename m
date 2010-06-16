From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/11] qla4xxx: set driver ddb state correctly in
	process_ddb_changed
Date: Thu, 17 Jun 2010 02:19:44 +0530
Message-ID: <20100616204944.GA8117@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:19180
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S932369Ab0FPUvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 16:51:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

If fw ddb state is ACTIVE mark driver ddb stat as ONLINE and
unblock iscsi sesssion.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5510df8..8947743 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1487,7 +1487,10 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		      ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
 	if (old_fw_ddb_device_state == state &&
 	    state == DDB_DS_SESSION_ACTIVE) {
-		/* Do nothing, state not changed. */
+		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+			iscsi_unblock_session(ddb_entry->sess);
+		}
 		return QLA_SUCCESS;
 	}
 
-- 
1.7.0.5

