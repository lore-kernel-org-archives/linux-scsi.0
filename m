From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 3/4] megaraid_sas: raid6 also require cpuSel check same as raid5
Date: Fri, 10 Mar 2017 03:22:14 -0800
Message-ID: <1489144935-26567-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36097 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933765AbdCJLW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2017 06:22:56 -0500
Received: by mail-pf0-f172.google.com with SMTP id o126so40989857pfb.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 03:22:55 -0800 (PST)
In-Reply-To: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Without this fix, raid6 performance will not be an optimal.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ebd746e..f990ab4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2159,7 +2159,7 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 				cpu_sel = MR_RAID_CTX_CPUSEL_1;
 
 			if (is_stream_detected(rctx_g35) &&
-			    (raid->level == 5) &&
+			    ((raid->level == 5) || (raid->level == 6)) &&
 			    (raid->writeMode == MR_RL_WRITE_THROUGH_MODE) &&
 			    (cpu_sel == MR_RAID_CTX_CPUSEL_FCFS))
 				cpu_sel = MR_RAID_CTX_CPUSEL_0;
-- 
2.8.3
