From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 12/17] mpt2sas: Added -ENOMEM return type when allocation fails
Date: Thu, 17 Jun 2010 13:47:29 +0530
Message-ID: <20100617081729.GM28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40014 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab0FQIxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:53:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

In the driver mpt2sas_base_attach subroutine, we need to add
support to return the proper error code when there are memory allocation
failures, e.g. returning -ENOMEM.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bb8acf7..d848744 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3634,8 +3634,10 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		ioc->pd_handles_sz++;
 	ioc->pd_handles = kzalloc(ioc->pd_handles_sz,
 	    GFP_KERNEL);
-	if (!ioc->pd_handles)
+	if (!ioc->pd_handles) {
+		r = -ENOMEM;
 		goto out_free_resources;
+	}
 
 	ioc->fwfault_debug = mpt2sas_fwfault_debug;
 
@@ -3676,6 +3678,13 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
+	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
+	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
+	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply) {
+		r = -ENOMEM;
+		goto out_free_resources;
+	}
+
 	init_completion(&ioc->shost_recovery_done);
 
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
