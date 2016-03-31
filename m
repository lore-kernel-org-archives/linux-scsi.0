From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 3/3] qla2xxx: Fix a compiler warning
Date: Thu, 31 Mar 2016 09:30:28 -0700
Message-ID: <56FD50A4.2030902@sandisk.com>
References: <56FD5046.7000509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0093.outbound.protection.outlook.com ([65.55.169.93]:58690
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753533AbcCaQad (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 12:30:33 -0400
In-Reply-To: <56FD5046.7000509@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that gcc reports the following warning:

drivers/scsi/qla2xxx/qla_target.c:3094:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7158f9d..87b301d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3099,10 +3099,11 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	if (ha_locked) {
 		rc = __qlt_send_term_imm_notif(vha, imm);
 
+		if (rc == -ENOMEM) {
 #if 0	/* Todo  */
-		if (rc == -ENOMEM)
 			qlt_alloc_qfull_cmd(vha, imm, 0, 0);
 #endif
+		}
 		goto done;
 	}
 
-- 
2.7.4

