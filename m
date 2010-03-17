From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 08/11] mpt2sas: return -ENOMEM if memory allocation failed.
Date: Wed, 17 Mar 2010 16:26:48 +0530
Message-ID: <20100317105638.GI21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34597 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429Ab0CQL1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:27:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added proper return type values in case memory allocation failed.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d3326e7..287f845 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3577,8 +3577,10 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
 	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
-	if (!ioc->pfacts)
+	if (!ioc->pfacts) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
 		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
@@ -3624,6 +3626,13 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->ctl_cmds.mutex);
 
+	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
+	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
+	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply) {
+		r = -ENOMEM;
+		goto out_free_resources;
+	}
+
 	init_completion(&ioc->shost_recovery_done);
 
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
