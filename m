From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 07/29] scsi: aacraid: Refactor reset_host store function
Date: Thu, 21 Dec 2017 09:33:58 -0800
Message-ID: <20171221173420.8213-8-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:42624
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753761AbdLUReh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:37 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Refactored the reset_host store function to make consistent across code
bases.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5eb0722..b2273e3 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1375,18 +1375,15 @@ static ssize_t aac_store_reset_adapter(struct device *device,
 				       const char *buf, size_t count)
 {
 	int retval = -EACCES;
-	int bled = 0;
-	struct aac_dev *aac;
-
 
 	if (!capable(CAP_SYS_ADMIN))
 		return retval;
 
-	aac = (struct aac_dev *)class_to_shost(device)->hostdata;
-	bled = buf[0] == '!' ? 1:0;
-	retval = aac_reset_adapter(aac, bled, IOP_HWSOFT_RESET);
+	retval = aac_reset_adapter(shost_priv(class_to_shost(device)),
+					buf[0] == '!', IOP_HWSOFT_RESET);
 	if (retval >= 0)
 		retval = count;
+
 	return retval;
 }
 
-- 
2.9.4
