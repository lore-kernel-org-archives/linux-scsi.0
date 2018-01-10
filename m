From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 2/2] scsi: aacraid: Delay for rescan worker needs to be 10 seconds
Date: Wed, 10 Jan 2018 13:13:10 -0800
Message-ID: <20180110211310.23876-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20180110211310.23876-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0077.outbound.protection.outlook.com ([104.47.32.77]:14976
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751438AbeAJVNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 16:13:25 -0500
In-Reply-To: <20180110211310.23876-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, esc-teamarcdriversvl@microsemi.com

The delay for the rescan worker needs to 10 seconds, missed the HZ in
there.

Fixes: a1367e4adee207fe (scsi: aacraid: Reschedule host scan in case of failure)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3e8bfcf..3ab3231 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1340,7 +1340,7 @@ struct fib {
 #define AAC_DEVTYPE_ARC_RAW		2
 #define AAC_DEVTYPE_NATIVE_RAW		3
 
-#define AAC_SAFW_RESCAN_DELAY  10
+#define AAC_SAFW_RESCAN_DELAY		(10 * HZ)
 
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
-- 
2.9.4
