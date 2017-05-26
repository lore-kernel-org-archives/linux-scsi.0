From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/1] scsi: scsi_debug: Avoid PI being disabled when TGPS is enabled
Date: Fri, 26 May 2017 12:59:35 -0400
Message-ID: <20170526165935.19543-1-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38976 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEZQ7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2017 12:59:54 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4QGxofU018571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 16:59:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4QGxo1E010657
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 16:59:50 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4QGxn9K007815
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 16:59:50 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

It was not possible to enable both T10 PI and TGPS because they share
the same byte in the INQUIRY response. Logically OR the TPGS value
instead of using assignment.

Reported-by: Ritika Srivastava <ritika.srivastava@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3650fe..b945d187873f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1404,7 +1404,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
 	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
 	if (sdebug_vpd_use_hostno == 0)
-		arr[5] = 0x10; /* claim: implicit TGPS */
+		arr[5] |= 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
-- 
2.13.0
