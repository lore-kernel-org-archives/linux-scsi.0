From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/7] mptsas : Change DEFINED value of can queue for FC and SAS devices.
Date: Wed, 5 Aug 2009 12:48:44 +0530
Message-ID: <20090805071832.GB14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:60979 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbZHEHjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:39:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Change DEFINED value of can queue for FC and SAS devices.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1c8514d..73810fa 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -157,8 +157,9 @@
 /*
  *	Try to keep these at 2^N-1
  */
-#define MPT_FC_CAN_QUEUE	127
+#define MPT_FC_CAN_QUEUE	1024
 #define MPT_SCSI_CAN_QUEUE	127
+#define MPT_SAS_CAN_QUEUE	127
 
 /*
  * Set the MAX_SGE value based on user input.
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 55ff252..c03968b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1891,7 +1891,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
-	.can_queue			= MPT_FC_CAN_QUEUE,
+	.can_queue			= MPT_SAS_CAN_QUEUE,
 	.this_id			= -1,
 	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
 	.max_sectors			= 8192,
