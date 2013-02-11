From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] dc395x: uninitialized variable in device_alloc()
Date: Mon, 11 Feb 2013 22:03:18 +0300
Message-ID: <20130211190317.GA19768@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3BKTDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 14:03:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This bug was introduced back in bitkeeper days in 2003.  We use
"dcb->dev_mode" before it has been initialized.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 865c64f..fed486bf 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3747,13 +3747,13 @@ static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
 	dcb->max_command = 1;
 	dcb->target_id = target;
 	dcb->target_lun = lun;
+	dcb->dev_mode = eeprom->target[target].cfg0;
 #ifndef DC395x_NO_DISCONNECT
 	dcb->identify_msg =
 	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
 #else
 	dcb->identify_msg = IDENTIFY(0, lun);
 #endif
-	dcb->dev_mode = eeprom->target[target].cfg0;
 	dcb->inquiry7 = 0;
 	dcb->sync_mode = 0;
 	dcb->min_nego_period = clock_period[period_index];
