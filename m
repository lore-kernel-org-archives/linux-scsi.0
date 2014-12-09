From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: RE: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Tue,  9 Dec 2014 18:57:23 +0530
Message-ID: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

> Shouldn't you be capping at SCSI_MAX_SG_CHAIN_SEGMENTS (or the actual hw
> limit)?

Agreed. And set the Upper limit to SCSI_MAX_SG_CHAIN_SEGMENTS.

Change Set:

1. Extended the upper boundary restriction for the module parameter max_sgl_entries.
   Earlier, the max_sgl_entries was capped at the SCSI_MAX_SG_SEGMENTS kernel definition.
   With this change, the user would be able to set the max_sgl_entries to
   any value which is greater than SCSI_MAX_SG_SEGMENTS and less than the minimum of
   SCSI_MAX_SG_CHAIN_SEGMENTS & hardware limit(Calculated using IOCFacts's MaxChainDepth).

2. Added a print for the message log whenever the user sets the max_sgl_entries to a value
   greater than SCSI_MAX_SG_SEGMENTS to warn about the kernel definition overriding.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 10 +++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 ++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 58e4521..ca3b564 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2486,9 +2486,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	/* command line tunables  for max sgl entries */
 	if (max_sgl_entries != -1) {
-		ioc->shost->sg_tablesize = (max_sgl_entries <
-		    MPT2SAS_SG_DEPTH) ? max_sgl_entries :
-		    MPT2SAS_SG_DEPTH;
+		if (max_sgl_entries > MPT2SAS_SG_DEPTH)
+			printk(MPT2SAS_WARN_FMT
+			 "setting max_sgl_entries(%d), overriding kernel"
+			 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+			  max_sgl_entries, MPT2SAS_SG_DEPTH);
+		ioc->shost->sg_tablesize =  min_t(unsigned short,
+			     max_sgl_entries, SCSI_MAX_SG_CHAIN_SEGMENTS);
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1560115..96db582 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2659,8 +2659,14 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 
 	if (sg_tablesize < MPT3SAS_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT3SAS_MIN_PHYS_SEGMENTS;
-	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS)
-		sg_tablesize = MPT3SAS_MAX_PHYS_SEGMENTS;
+	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS) {
+		pr_warn(MPT3SAS_FMT
+		 "setting max_sgl_entries(%d), overriding kernel"
+		 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+		 max_sgl_entries, MPT3SAS_MAX_PHYS_SEGMENTS);
+		sg_tablesize = min_t(unsigned short, sg_tablesize,
+				      SCSI_MAX_SG_CHAIN_SEGMENTS);
+	}
 	ioc->shost->sg_tablesize = sg_tablesize;
 
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
-- 
2.0.2
