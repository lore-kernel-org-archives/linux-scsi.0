From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] scsi: qedf: use correct strncpy() size
Date: Fri,  2 Feb 2018 14:12:20 +0100
Message-ID: <20180202131225.1658853-7-arnd@arndb.de>
References: <20180202131225.1658853-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62784 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeBBNTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 08:19:20 -0500
In-Reply-To: <20180202131225.1658853-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Saurav Kashyap <saurav.kashyap@cavium.com>, "Dupuis, Chad" <chad.dupuis@cavium.com>, Arun Easi <arun.easi@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org

gcc-8 warns during link-time optimization that the strncpy() call
passes the size of the source buffer rather than the destination:

drivers/scsi/qedf/qedf_dbg.c: In function 'qedf_uevent_emit':
include/linux/string.h:253: error: 'strncpy' specified bound depends on the length of the source argument [-Werror=stringop-overflow=]

This changes it to strscpy() with the correct length, guaranteeing
a properly nul-terminated string of the right size.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qedf/qedf_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
index e023f5d0dc12..bd1cef25a900 100644
--- a/drivers/scsi/qedf/qedf_dbg.c
+++ b/drivers/scsi/qedf/qedf_dbg.c
@@ -160,7 +160,7 @@ qedf_uevent_emit(struct Scsi_Host *shost, u32 code, char *msg)
 	switch (code) {
 	case QEDF_UEVENT_CODE_GRCDUMP:
 		if (msg)
-			strncpy(event_string, msg, strlen(msg));
+			strscpy(event_string, msg, sizeof(event_string));
 		else
 			sprintf(event_string, "GRCDUMP=%u", shost->host_no);
 		break;
-- 
2.9.0
