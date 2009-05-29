From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 14/17] mpt fusion: [2.6.30-rc6][Reviewed] Put IOC into ready state if it not already in ready state
Date: Fri, 29 May 2009 16:53:14 +0530
Message-ID: <20090529112308.GO10181@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:41956 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbZE2Lod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 07:44:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Put IOC into ready state if it is not already.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index ed54f07..29901f0 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2667,6 +2667,22 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		}
 	}
 
+	/*
+	 * Put the controller into ready state (if its not already)
+	 */
+	if (mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_READY) {
+		if (!SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET,
+		    CAN_SLEEP)) {
+			if (mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_READY)
+				printk(MYIOC_s_ERR_FMT "%s:  IOC msg unit "
+				    "reset failed to put ioc in ready state!\n",
+				    ioc->name, __func__);
+		} else
+			printk(MYIOC_s_ERR_FMT "%s:  IOC msg unit reset "
+			    "failed!\n", ioc->name, __func__);
+	}
+
+
 	/* Disable adapter interrupts! */
 	synchronize_irq(ioc->pcidev->irq);
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
