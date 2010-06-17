From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 07/08] mptfusion: Added missing reset for ioc_reset_in_progress in SoftReset
Date: Thu, 17 Jun 2010 14:42:39 +0530
Message-ID: <20100617091229.GH29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44065 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805Ab0FQJsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:48:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Added missing part which will reset ioc_reset_in_progress before returning from SoftResetHandler.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 49005e1..d0855f2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6974,6 +6974,7 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	if (ioc->taskmgmt_in_progress) {
+		ioc->ioc_reset_in_progress = 0;
 		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 		return -1;
 	}
