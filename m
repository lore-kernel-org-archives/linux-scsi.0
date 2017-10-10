From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 02/10] be2iscsi: Fix return value in mgmt_open_connection
Date: Tue, 10 Oct 2017 16:18:12 +0530
Message-ID: <1507632500-26445-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:49860 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdJJKso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:44 -0400
Received: by mail-pf0-f180.google.com with SMTP id l188so16806910pfc.6
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:44 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

mgmt_open_connection is expected to return tag not errno.

In error case, just return invalid tag 0.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index c737753..af6ee43 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -156,7 +156,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BG_%d : unknown addr family %d\n",
 			    dst_addr->sa_family);
-		return -EINVAL;
+		return 0;
 	}
 
 	phwi_ctrlr = phba->phwi_ctrlr;
-- 
2.7.4
