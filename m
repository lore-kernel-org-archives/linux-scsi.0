From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Tue, 18 Sep 2012 15:10:56 -0700
Message-ID: <1348006256-23551-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:47582 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755167Ab2IRWLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 18:11:03 -0400
Received: by pbbrr13 with SMTP id rr13so927205pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2012 15:11:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>

From: Roland Dreier <roland@purestorage.com>

The qla2xxx firmware actually expects the task management response
code in a CTIO IOCB with SCSI status mode 1 to be in little-endian
byte order, ie the response code should be the first byte in the
sense_data[] array.  The old code erroneously byte-swapped the
response code, which puts it in the wrong place on the wire and leads
to initiators thinking every task management request succeeds (since
they see 0 in the byte where they look for the response code).

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5b30132..41b74ba 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1403,7 +1403,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->u.status1.scsi_status =
 	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
 	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
-	((uint32_t *)ctio->u.status1.sense_data)[0] = cpu_to_be32(resp_code);
+	ctio->u.status1.sense_data[0] = resp_code;
 
 	qla2x00_start_iocbs(ha, ha->req);
 }
-- 
1.7.10.4

