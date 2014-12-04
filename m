From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/4] [SCSI] Blacklist RSOC for Microsoft iSCSI target devices
Date: Wed,  3 Dec 2014 21:18:10 -0500
Message-ID: <1417659492-2679-2-git-send-email-martin.petersen@oracle.com>
References: <1417659492-2679-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40846 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaLDCT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 21:19:56 -0500
In-Reply-To: <1417659492-2679-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, stable@vger.kernel.org.#.v3.10+

The Microsoft iSCSI target does not support REPORT SUPPORTED OPERATION
CODES. Blacklist these devices so we don't attempt to send the command.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: jazz@deti74.ru
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: stable@vger.kernel.org # v3.10+
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 8c228e049bb6..db42c37e1230 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -210,6 +210,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
+	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
1.9.3

