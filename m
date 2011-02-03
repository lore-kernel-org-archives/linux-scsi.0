From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/06] mptfusion: Remove bus reset for mptsas module
Date: Thu, 3 Feb 2011 15:31:51 +0530
Message-ID: <20110203100142.GD23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49013 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab1BCKsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 05:48:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Bus reset is not required for SAS Controller. It is valid for mptspi and mptfc, but for mptsas
it is not required. It is an extra work for Error handling escallation for mptsas.
Removing bus reset from error handling will eventually speedup Error handling for SAS controller.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d89d027..c4bf181 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1976,7 +1976,6 @@ static struct scsi_host_template mptsas_driver_template = {
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
-	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SAS_CAN_QUEUE,
