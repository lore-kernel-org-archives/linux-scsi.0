From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 1/3] qla2xxx: Indicate out-of-memory with -ENOMEM
Date: Thu, 31 Mar 2016 09:29:35 -0700
Message-ID: <56FD506F.3010408@sandisk.com>
References: <56FD5046.7000509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:43221
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755847AbcCaQ3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 12:29:39 -0400
In-Reply-To: <56FD5046.7000509@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In the Linux kernel it is preferred to return a meaningful error code
instead of -1. This patch does not change the behavior of the caller of
qla82xx_pinit_from_rom().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b6b4cfd..54380b4 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1229,7 +1229,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	if (buf == NULL) {
 		ql_log(ql_log_fatal, vha, 0x010c,
 		    "Unable to allocate memory.\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < n; i++) {
-- 
2.7.4

