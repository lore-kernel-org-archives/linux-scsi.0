From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 07/30] scsi: aacraid: Refactor reset_host store function
Date: Tue, 26 Dec 2017 20:34:28 -0800
Message-ID: <20171227043451.27813-8-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0055.outbound.protection.outlook.com ([104.47.41.55]:25600
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751495AbdL0EfG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:06 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Refactored the reset_host store function to make consistent across code
bases

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

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
