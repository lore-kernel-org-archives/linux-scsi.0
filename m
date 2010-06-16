From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/11] qla4xxx: unblock iscsi session after setting ddb
	state online.
Date: Thu, 17 Jun 2010 02:20:17 +0530
Message-ID: <20100616205017.GA8129@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:20312
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S932528Ab0FPUvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 16:51:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Once the device goes *missing*, driver blocks the session
ie iscsi_block_session() to stall the I/O.  So after device
comes back *online*, driver needs to unblock the session ie
iscsi_unblock_session(), else I/Os will fail even if
ddb_state is ONLINE.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 8947743..1656522 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -993,6 +993,7 @@ int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host *ha)
 			DEBUG2(printk ("scsi%ld: %s: ddb index [%d] marked "
 				       "ONLINE\n", ha->host_no, __func__,
 				       ddb_entry->fw_ddb_index));
+			iscsi_unblock_session(ddb_entry->sess);
 		} else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
 			qla4xxx_mark_device_missing(ha, ddb_entry);
 	}
-- 
1.7.0.5

