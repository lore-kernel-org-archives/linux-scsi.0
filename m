From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/12] mptfusion: Proper bus_type check is added
Date: Thu, 18 Mar 2010 19:20:38 +0530
Message-ID: <20100318135026.GF22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53769 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab0CROVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:21:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added proper bus_type check before processing event/ reset handler.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ebf6ae0..35dd8e9 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1352,6 +1352,9 @@ mptfc_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	unsigned long flags;
 	int rc=1;
 
+	if (ioc->bus_type != FC)
+		return 0;
+
 	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
 			ioc->name, event));
 
@@ -1390,7 +1393,7 @@ mptfc_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 	unsigned long	flags;
 
 	rc = mptscsih_ioc_reset(ioc,reset_phase);
-	if (rc == 0)
+	if ((ioc->bus_type != FC) || (!rc))
 		return rc;
 
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 80d7f7d..493e0c0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4778,6 +4778,9 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 	struct fw_event_work *fw_event;
 	unsigned long delay;
 
+	if (ioc->bus_type != SAS)
+		return 0;
+
 	/* events turned off due to host reset or driver unloading */
 	if (ioc->fw_events_off)
 		return 0;
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 69f4257..763d080 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1151,6 +1151,9 @@ mptspi_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
 	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 
+	if (ioc->bus_type != SPI)
+		return 0;
+
 	if (hd && event ==  MPI_EVENT_INTEGRATED_RAID) {
 		int reason
 			= (le32_to_cpu(pEvReply->Data[0]) & 0x00FF0000) >> 16;
@@ -1282,6 +1285,8 @@ mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	if ((ioc->bus_type != SPI) || (!rc))
+		return rc;
 
 	/* only try to do a renegotiation if we're properly set up
 	 * if we get an ioc fault on bringup, ioc->sh will be NULL */
