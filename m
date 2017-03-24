From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v3 03/10] be2iscsi: Replace spin_unlock_bh with spin_lock
Date: Fri, 24 Mar 2017 14:11:42 +0530
Message-ID: <1490344909-29541-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34809 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754246AbdCXImc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:42:32 -0400
Received: by mail-qk0-f179.google.com with SMTP id p64so5690704qke.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:42:13 -0700 (PDT)
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

spin_unlock_bh back_lock is used in beiscsi_eh_device_reset instead of
spin_lock.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com> tomash
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
