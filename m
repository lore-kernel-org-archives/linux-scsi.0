From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 07/11] megaraid_sas : Round down max sge supported by
 controller to power of two
Date: Sat, 6 Sep 2014 18:55:51 +0530
Message-ID: <201409061328.s86DS9XS013174@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:46624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbaIFOAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 10:00:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

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

---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65f617e..4593641 100644
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

