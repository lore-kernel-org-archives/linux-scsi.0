From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 02/16] aacraid: Use correct channel number for raw srb
Date: Tue, 14 Feb 2017 12:44:32 -0800
Message-ID: <20170214204446.14808-3-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0049.outbound.protection.outlook.com ([104.47.41.49]:60578
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751479AbdBODWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:32 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

The channel being used for raw srb commands is retrieved from the utility
sent fibs and is converted into physical channel id. The driver does not
need to to do this since the management utility sends the correct channel
id in the first place and in addition the driver sets inaccurate
information in the cmd sent to the firmware and gets an invalid response.

Fixed by using channel id from srb command.

Cc: stable@vger.kernel.org
Fixes: 423400e64d377c0 ("scsi: aacraid: Include HBA direct interface")
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 614842a..f6afd50 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -580,7 +580,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	chn = aac_logical_to_phys(user_srbcmd->channel);
+	chn = user_srbcmd->channel;
 	if (chn < AAC_MAX_BUSES && user_srbcmd->id < AAC_MAX_TARGETS &&
 		dev->hba_map[chn][user_srbcmd->id].devtype ==
 		AAC_DEVTYPE_NATIVE_RAW) {
-- 
2.7.4
