From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 02/15] aacraid: Use correct channel number for raw srb
Date: Thu, 16 Feb 2017 12:51:11 -0800
Message-ID: <20170216205124.20271-3-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0047.outbound.protection.outlook.com ([104.47.34.47]:35822
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754972AbdBQD2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:09 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
None

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
