From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Is scsi_reset_provider() overdoing it?
Date: Tue, 03 Jul 2007 17:07:58 +0300
Message-ID: <468A583E.7030701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44544 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758020AbXGCOIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 10:08:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


In scsi_error.c at scsi_reset_provider()
 Why do we need the uninitialized struct request hanging on
 the reset scsi_cmnd? It looks like we are bypassing block
 queues and directly going to llds. It also looks like llds
 understand not to touch any garbage request's fields during
 reset. Would it not be better to Just put a NULL instead?
 And while at it can I just put a DMA_NONE on this No-Data
 command?

Boaz

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9adb64a..4f6026d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1662,11 +1662,10 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 {
 	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
 	struct Scsi_Host *shost = dev->host;
-	struct request req;
 	unsigned long flags;
 	int rtn;
 
-	scmd->request = &req;
+	scmd->request = NULL;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
@@ -1678,7 +1677,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	scmd->cmd_len			= 0;
 
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
+	scmd->sc_data_direction		= DMA_NONE;
 
 	init_timer(&scmd->eh_timeout);
 
