From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/11] mpt2sas: Corrected conditional checks for Internal device Reset
Date: Wed, 17 Mar 2010 16:22:21 +0530
Message-ID: <20100317105210.GC21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57967 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab0CQLXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:23:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

bug fix in the handling of the internal device reset event
The reason code check in scsih_sas_device_status_change_event never
evaluates as true for internal device reset, hence driver never quiesce s IO
when firmware is sending a device reset. The fix is to change the
evaluate to:
if (event_data->ReasonCode !=
    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
   event_data->ReasonCode !=
    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
        return;

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b2d6d75..cd0f245 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4434,10 +4434,10 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 		     event_data);
 #endif
 
-	if (!(event_data->ReasonCode ==
+	if (event_data->ReasonCode !=
 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
-	   event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
+	   event_data->ReasonCode !=
+	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
