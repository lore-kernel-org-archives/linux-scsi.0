From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] Eliminate extra 'out_free' label from fcoe_init function
Date: Thu, 1 Jun 2017 17:41:06 +0530
Message-ID: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35362 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdFAMLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 08:11:11 -0400
Received: by mail-it0-f41.google.com with SMTP id f72so35338617ite.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 05:11:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Laurence Oberman <loberman@redhat.com>

Simplify the check for return code of fcoe_if_init routine
in fcoe_init function such that we could eliminate need for
extra 'out_free' label.

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/fcoe/fcoe.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ea21e7b..fb2a4c9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2523,13 +2523,11 @@ static int __init fcoe_init(void)
 	fcoe_dev_setup();
 
 	rc = fcoe_if_init();
-	if (rc)
-		goto out_free;
-
-	mutex_unlock(&fcoe_config_mutex);
-	return 0;
+	if (rc == 0) {
+		mutex_unlock(&fcoe_config_mutex);
+		return 0;
+	}
 
-out_free:
 	mutex_unlock(&fcoe_config_mutex);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
