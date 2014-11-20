From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Thu, 20 Nov 2014 12:35:39 +0530
Message-ID: <1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:36841 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbaKTHNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:13:37 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so1982535pab.33
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:13:37 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

1. Removed the upper boundary restriction for the module parameter max_sgl_entries. Earlier, the max_sgl_entries was capped at the SCSI_MAX_SG_SEGMENTS kernel definition. With this change, the user would be able to set the max_sgl_entries to any value.
2. Added a print for the message log whenever the user sets the max_sgl_entries to a value greater than SCSI_MAX_SG_SEGMENTS to warn about the kernel definition overriding.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 9 ++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 13d1d5b..adb99e5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2492,9 +2492,12 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
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
+		ioc->shost->sg_tablesize = max_sgl_entries;
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f1918cf..35d4780 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2667,7 +2667,10 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 	if (sg_tablesize < MPT3SAS_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT3SAS_MIN_PHYS_SEGMENTS;
 	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS)
-		sg_tablesize = MPT3SAS_MAX_PHYS_SEGMENTS;
+		pr_warn(MPT3SAS_FMT
+		 "setting max_sgl_entries(%d), overriding kernel"
+		 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+		 max_sgl_entries, MPT3SAS_MAX_PHYS_SEGMENTS);
 	ioc->shost->sg_tablesize = sg_tablesize;
 
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
-- 
2.0.2

