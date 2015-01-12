From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Mon, 12 Jan 2015 11:39:00 +0530
Message-ID: <1421042944-14988-7-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:53203 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbALGJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 01:09:58 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so30209883pad.3
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jan 2015 22:09:57 -0800 (PST)
In-Reply-To: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Change Set:

1. Extended the upper boundary restriction for the module parameter max_sgl_entries.
   Earlier, the max_sgl_entries was capped at the SCSI_MAX_SG_SEGMENTS kernel definition.
   With this change, the user would be able to set the max_sgl_entries to
   any value which is greater than SCSI_MAX_SG_SEGMENTS and less than the minimum of
   SCSI_MAX_SG_CHAIN_SEGMENTS & hardware limit(Calculated using IOCFacts's MaxChainDepth).

2. Added a print for the message log whenever the user sets the max_sgl_entries to a value
   greater than SCSI_MAX_SG_SEGMENTS to warn about the kernel definition overriding.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 10 +++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 ++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 13d1d5b..dc088ac 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2492,9 +2492,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	/* command line tunables  for max sgl entries */
 	if (max_sgl_entries != -1) {
-		ioc->shost->sg_tablesize = (max_sgl_entries <
-		    MPT2SAS_SG_DEPTH) ? max_sgl_entries :
-		    MPT2SAS_SG_DEPTH;
+		ioc->shost->sg_tablesize =  min_t(unsigned short,
+			     max_sgl_entries, SCSI_MAX_SG_CHAIN_SEGMENTS);
+		if (ioc->shost->sg_tablesize > MPT2SAS_SG_DEPTH)
+			printk(MPT2SAS_WARN_FMT
+			 "sg_tablesize(%u) is bigger than kernel defined"
+			 " SCSI_MAX_SG_SEGMENTS(%u)\n", ioc->name,
+			  ioc->shost->sg_tablesize, MPT2SAS_SG_DEPTH);
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f1918cf..0b8210b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2666,8 +2666,14 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 
 	if (sg_tablesize < MPT3SAS_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT3SAS_MIN_PHYS_SEGMENTS;
-	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS)
-		sg_tablesize = MPT3SAS_MAX_PHYS_SEGMENTS;
+	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS) {
+		sg_tablesize = min_t(unsigned short, sg_tablesize,
+				      SCSI_MAX_SG_CHAIN_SEGMENTS);
+		pr_warn(MPT3SAS_FMT
+		 "sg_tablesize(%u) is bigger than kernel"
+		 " defined SCSI_MAX_SG_SEGMENTS(%u)\n", ioc->name,
+		 sg_tablesize, MPT3SAS_MAX_PHYS_SEGMENTS);
+	}
 	ioc->shost->sg_tablesize = sg_tablesize;
 
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
-- 
2.0.2

