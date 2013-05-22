From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 08/12] megaraid_sas : Set IoFlags to enable Fast Path for
 JBODs for 12 Gb/s controllers
Date: Wed, 22 May 2013 12:33:29 +0530
Message-ID: <201305221233.r4MCXiSk012619@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:12280
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab3EVMdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:33:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Set IoFlags to enable Fast Path for JBODs for Invader/Fury(12 Gb/s) controllers.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 73aa68e..c60f478 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1592,6 +1592,10 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 		io_request->RaidContext.RAIDFlags =
 			MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD <<
 			MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
+			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+			io_request->IoFlags |=
+				MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH;
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);

