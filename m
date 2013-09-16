From: <Sumit.Saxena@lsi.com>
Subject: [PATCH][SCSI] megaraid_sas: fixes for few endianess issues
Date: Mon, 16 Sep 2013 15:18:06 +0530
Message-ID: <201309160947.r8G9lwog002042@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:45512
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658Ab3IPKDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 06:03:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Fixed two issues in this patch-
1) In function megasas_get_pd_list(), data read(pd_addr->deviceId) from DMAed memory is converted to CPU's endianess.
2) While register AEN, removed some endianness conversion on some fields, since their endianess is already converted.


Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3020921..e62ff02 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3199,11 +3199,11 @@ megasas_get_pd_list(struct megasas_instance *instance)
 
 		for (pd_index = 0; pd_index < le32_to_cpu(ci->count); pd_index++) {
 
-			instance->pd_list[pd_addr->deviceId].tid	=
+			instance->pd_list[le16_to_cpu(pd_addr->deviceId)].tid	=
 				le16_to_cpu(pd_addr->deviceId);
-			instance->pd_list[pd_addr->deviceId].driveType	=
+			instance->pd_list[le16_to_cpu(pd_addr->deviceId)].driveType	=
 							pd_addr->scsiDevType;
-			instance->pd_list[pd_addr->deviceId].driveState	=
+			instance->pd_list[le16_to_cpu(pd_addr->deviceId)].driveState	=
 							MR_PD_STATE_SYSTEM;
 			pd_addr++;
 		}
@@ -3998,7 +3998,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 		 * values
 		 */
 		if ((prev_aen.members.class <= curr_aen.members.class) &&
-		    !((le16_to_cpu(prev_aen.members.locale) & curr_aen.members.locale) ^
+		    !((prev_aen.members.locale & curr_aen.members.locale) ^
 		      curr_aen.members.locale)) {
 			/*
 			 * Previously issued event registration includes
@@ -4006,7 +4006,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 			 */
 			return 0;
 		} else {
-			curr_aen.members.locale |= le16_to_cpu(prev_aen.members.locale);
+			curr_aen.members.locale |= prev_aen.members.locale;
 
 			if (prev_aen.members.class < curr_aen.members.class)
 				curr_aen.members.class = prev_aen.members.class;
@@ -4097,7 +4097,7 @@ static int megasas_start_aen(struct megasas_instance *instance)
 	class_locale.members.class = MR_EVT_CLASS_DEBUG;
 
 	return megasas_register_aen(instance,
-			le32_to_cpu(eli.newest_seq_num) + 1,
+			eli.newest_seq_num + 1,
 			class_locale.word);
 }
 

