From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 07/11] megaraid_sas : Round down max sge supported
 by controller to power of two
Date: Fri, 12 Sep 2014 18:57:43 +0530
Message-ID: <201409121330.s8CDU5el022435@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0073.outbound.protection.outlook.com ([65.55.169.73]:43264
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755023AbaILNmt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:42:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Resending the patch. Addressed the review comments from Tomas Henzl.

Round down the max sge to power of two. 

Earlier max sge limit is 70 SGE, which will allow block layer to send 280K IO frame.
It is optimal to provide max IO size aligned to the smallest possible stripe size.
E.a 
Consider that we have configured RAID Volumes which does not allow Fast Path across the stripe.
Raid volume with stripe size = 256K, will have peformance hit if we get io frame of size 280K.
Driver will not send IO frame large than stripe size to the Fast Path.
Also, FW will convert 280K frame into 256K + 24K. This is an additional overhead. 

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ed24a84..d35ac34 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1001,8 +1001,8 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	fusion->max_sge_in_chain =
 		MEGASAS_MAX_SZ_CHAIN_FRAME / sizeof(union MPI2_SGE_IO_UNION);
 
-	instance->max_num_sge = fusion->max_sge_in_main_msg +
-		fusion->max_sge_in_chain - 2;
+	instance->max_num_sge = rounddown_pow_of_two(
+		fusion->max_sge_in_main_msg + fusion->max_sge_in_chain - 2);
 
 	/* Used for pass thru MFI frame (DCMD) */
 	fusion->chain_offset_mfi_pthru =
-- 
1.8.3.1

