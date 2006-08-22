From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Tue, 22 Aug 2006 13:53:16 -0700
Message-ID: <20060822205315.GA16638@us.ibm.com>
References: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:24276 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750740AbWHVUyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 16:54:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7MKsi5i017269
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 16:54:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7MKsi4i275258
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 16:54:44 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7MKsi44024061
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 16:54:44 -0400
Content-Disposition: inline
In-Reply-To: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> While abusing my sas topology (to try to get it to give me errors) I
> came across this one with STP tasks:
> 
> When the aic94xx loses a task in sas_execute_tasks(), the timeout fires
> and wakes the waiter (this leaves the task set pending and aborted).  In
> response, sas_execute_task() tries to call lldd_abort_task()
> (asd_abort_task()) on it.  Here we panic failing the BUG_ON(!list_empty)
> check in aic94xx_hwi.h:asd_ascb_free().
> 
> What happens is that the abort comes back with TF_TMF_NO_CTX + 0xFF00
> from the sequencer, which asd_abort_task() treats as success and then
> panics because the original task is still active.
> 
> Either the abort function or the sequencer code is clearly wrong, but
> not having access to the sequencer to look, I can't tell.  What should 
> this return mean from the sequencer?  My suspicion is that it means the
> STP task abort isn't actually formulated properly.
> 

Does this help any? While Alexis and I where working on a expander timeout
issue the abort was never working for us. I compared the adp abort and the
aic94xx abort code and made these changes. This appears to make the abort
work for us now. A few lines of the changes are not related to the abort.
YMMV, a better solution would be to know the exact format of the abort.

-andmike
--
Michael Anderson
andmike@us.ibm.com

[EXPERIMENTAL PATCH]
This patch is a port of some of the abort_task and timeout changes present
in the adp driver, but not present in the aic94xx driver.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/aic94xx/aic94xx_sas.h |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_sas.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_sas.h	2006-07-14 14:54:31.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_sas.h	2006-07-14 15:19:38.000000000 -0700
@@ -777,7 +777,7 @@ struct asd_phy {
 
 /* COMINIT timer */
 #define ASD_TEN_MILLISEC_TIMEOUT  0x2710
-#define ASD_COMINIT_TIMEOUT ASD_TEN_MILLISEC_TIMEOUT
+#define ASD_COMINIT_TIMEOUT 	  0x000F4240
 
 /* 1 sec */
 #define ASD_SMP_RCV_TIMEOUT       0x000F4240
Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_tmf.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-06-23 11:12:01.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-07-14 15:17:52.000000000 -0700
@@ -375,6 +375,7 @@ int asd_abort_task(struct sas_task *task
 	case SAS_PROTO_SSP:
 		scb->abort_task.proto_conn_rate  = (1 << 4); /* SSP */
 		scb->abort_task.proto_conn_rate |= task->dev->linkrate;
+		scb->abort_task.flags |= (1U << 2);
 		break;
 	case SAS_PROTO_SMP:
 		break;
@@ -399,9 +400,9 @@ int asd_abort_task(struct sas_task *task
 	scb->abort_task.sister_scb = cpu_to_le16(0xFFFF);
 	scb->abort_task.conn_handle = cpu_to_le16(
 		(u16)(unsigned long)task->dev->lldd_dev);
-	scb->abort_task.retry_count = 1;
+	scb->abort_task.retry_count = 3;
 	scb->abort_task.index = cpu_to_le16((u16)tascb->tc_index);
-	scb->abort_task.itnl_to = cpu_to_le16(ITNL_TIMEOUT_CONST);
+/*	scb->abort_task.itnl_to = cpu_to_le16(ITNL_TIMEOUT_CONST); */
 
 	res = asd_enqueue_internal(ascb, asd_tmf_tasklet_complete,
 				   asd_tmf_timedout);
@@ -534,7 +535,7 @@ static int asd_initiate_ssp_tmf(struct d
 	scb->ssp_tmf.conn_handle= cpu_to_le16((u16)(unsigned long)
 					      dev->lldd_dev);
 	scb->ssp_tmf.retry_count = 1;
-	scb->ssp_tmf.itnl_to = cpu_to_le16(ITNL_TIMEOUT_CONST);
+
 	if (tmf == TMF_QUERY_TASK)
 		scb->ssp_tmf.index = cpu_to_le16(index);
 
