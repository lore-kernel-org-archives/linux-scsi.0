From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 10/14] megaraid_sas: Selectively apply stream detection based on IO type
Date: Fri,  5 Jan 2018 05:27:45 -0800
Message-ID: <1515158869-26693-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41565 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbeAEN3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:35 -0500
Received: by mail-pf0-f196.google.com with SMTP id j28so2179979pfk.8
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:35 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Performance improvement-
Current driver calls stream detection unconditionally for all IOs.
Stream Detection logic is not required for most of the fast path IO.
To improve performance, avoid stream detection logic and do it only if
required.
Below are the cases where stream detection is required in driver:
1. All non-FastPath IOs (IOs going to FW)
2. Fast Path reads sent to ReadAhead capable VDs.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 74dadd052be4..ef36f2ac7cb6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2664,16 +2664,6 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	praid_context = &io_request->RaidContext;
 
 	if (instance->adapter_type == VENTURA_SERIES) {
-		spin_lock_irqsave(&instance->stream_lock, spinlock_flags);
-		megasas_stream_detect(instance, cmd, &io_info);
-		spin_unlock_irqrestore(&instance->stream_lock, spinlock_flags);
-		/* In ventura if stream detected for a read and it is read ahead
-		 *  capable make this IO as LDIO
-		 */
-		if (is_stream_detected(&io_request->RaidContext.raid_context_g35) &&
-		    io_info.isRead && io_info.ra_capable)
-			fp_possible = false;
-
 		/* FP for Optimal raid level 1.
 		 * All large RAID-1 writes (> 32 KiB, both WT and WB modes)
 		 * are built by the driver as LD I/Os.
@@ -2699,6 +2689,20 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			}
 		}
 
+		if (!fp_possible ||
+		    (io_info.isRead && io_info.ra_capable)) {
+			spin_lock_irqsave(&instance->stream_lock,
+					  spinlock_flags);
+			megasas_stream_detect(instance, cmd, &io_info);
+			spin_unlock_irqrestore(&instance->stream_lock,
+					       spinlock_flags);
+			/* In ventura if stream detected for a read and it is
+			 * read ahead capable make this IO as LDIO
+			 */
+			if (is_stream_detected(&io_request->RaidContext.raid_context_g35))
+				fp_possible = false;
+		}
+
 		/* If raid is NULL, set CPU affinity to default CPU0 */
 		if (raid)
 			megasas_set_raidflag_cpu_affinity(praid_context,
-- 
2.14.1
