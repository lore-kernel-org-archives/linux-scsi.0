From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 05/12] megaraid_sas : Set IO request timeout value
 provided by OS timeout for Tape devices
Date: Wed, 22 May 2013 12:31:18 +0530
Message-ID: <201305221231.r4MCVYrt012099@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:9877
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab3EVMbj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:31:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Set IO request timeout value provided by OS timeout for Tape devices.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a7d5668..750cbdf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1527,6 +1527,18 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		cmd->request_desc->SCSIIO.DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+		/*
+		 * If the command is for the tape device, set the
+		 * FP timeout to the os layer timeout value.
+		 */
+		if (scmd->device->type == TYPE_TAPE) {
+			if ((scmd->request->timeout / HZ) > 0xFFFF)
+				io_request->RaidContext.timeoutValue =
+					0xFFFF;
+			else
+				io_request->RaidContext.timeoutValue =
+					scmd->request->timeout / HZ;
+		}
 	} else {
 		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = device_id;

