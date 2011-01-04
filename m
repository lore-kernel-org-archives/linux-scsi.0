From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/10] mpt2sas: Internal device reset complete event is not supported for older firmware prior to MPI Rev K
Date: Tue, 4 Jan 2011 11:34:17 +0530
Message-ID: <20110104060407.GC5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60040 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1ADGtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 01:49:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

The "internal device reset complete" event is not supported
for older firmware prior to MPI Rev K We added
a check in the driver so the "internal device reset" event is
ignored for older firmware.  When ignored, the tm_busy flag doesn't
get set nor cleared.  Without this fix, IO queues would be froozen
indefinetly after the "internal device reset" event, as the "complete" event
never sent to clear the flag.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 95d8274..a16f2a0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5002,6 +5002,12 @@ _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
 		     event_data);
 #endif
 
+	/* In MPI Revision K (0xC), the internal device reset complete was
+	 * implemented, so avoid setting tm_busy flag for older firmware.
+	 */
+	if ((ioc->facts.HeaderVersion >> 8) < 0xC)
+		return;
+
 	if (event_data->ReasonCode !=
 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
 	   event_data->ReasonCode !=
