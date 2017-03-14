From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 3/9] be2iscsi: Replace spin_unlock_bh with spin_lock
Date: Tue, 14 Mar 2017 13:31:28 +0530
Message-ID: <1489478494-5432-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38090 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdCNICE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2017 04:02:04 -0400
Received: by mail-wm0-f52.google.com with SMTP id t189so57133124wmt.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 01:02:03 -0700 (PDT)
In-Reply-To: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
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
