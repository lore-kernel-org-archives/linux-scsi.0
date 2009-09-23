From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 13/20] mpt2sas: Retrieve the ioc facts prior to putting the controller into READY state
Date: Wed, 23 Sep 2009 17:32:06 +0530
Message-ID: <20090923120206.GR6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51015 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbZIWMZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:25:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


The driver needs to retrieve the ioc facts prior to putting the controller
into READY state. The current design is calling ioc facts after putting the
controller into READY state, which means the driver is sending a diag reset
instead of message unit reset becuase the capability information is not yet
available.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 112da29..ecd96ed 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3545,11 +3545,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		return r;
 
 	pci_set_drvdata(ioc->pdev, ioc->shost);
-	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
 
-	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
+	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
 
