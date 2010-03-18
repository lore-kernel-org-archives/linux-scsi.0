From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/12] mptfusion: mpt config will do Hard Reset based upon retry counts
Date: Thu, 18 Mar 2010 19:14:51 +0530
Message-ID: <20100318134437.GD22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60709 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab0CROPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:15:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

mpt_config would only attempt a MUR
before retrying the command. The driver will now retry a second
time with a hard reset before leaving the function.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a4f023b..a6a5701 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6456,10 +6456,15 @@ out:
 		issue_hard_reset = 0;
 		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
 		    ioc->name, __func__);
-		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+		if (retry_count == 0) {
+			if (mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP) != 0)
+				retry_count++;
+		} else
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+
 		mpt_free_msg_frame(ioc, mf);
 		/* attempt one retry for a timed out command */
-		if (!retry_count) {
+		if (retry_count < 2) {
 			printk(MYIOC_s_INFO_FMT
 			    "Attempting Retry Config request"
 			    " type 0x%x, page 0x%x,"
