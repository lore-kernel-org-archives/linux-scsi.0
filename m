From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 03/10] be2iscsi: Replace spin_unlock_bh with spin_lock
Date: Thu, 16 Mar 2017 08:54:38 +0530
Message-ID: <1489634685-4975-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35720 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wr0-f177.google.com with SMTP id g10so23124629wrg.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:21 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

spin_unlock_bh back_lock is used in beiscsi_eh_device_reset instead of
spin_lock.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 32b2713..ff48573 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -337,7 +337,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		inv_tbl->task[nents] = task;
 		nents++;
 	}
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock(&session->back_lock);
 	spin_unlock_bh(&session->frwd_lock);
 
 	rc = SUCCESS;
-- 
2.7.4
