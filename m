From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH RESEND] Eliminate extra 'out_free' label from fcoe_init
 function
Date: Fri, 2 Jun 2017 18:09:05 +0530
Message-ID: <8e1e75c4-3a80-00c3-2697-37fb1c86f7a1@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:38891 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFBMjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 08:39:10 -0400
Received: by mail-it0-f47.google.com with SMTP id r63so18483813itc.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jun 2017 05:39:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Dan Carpenter <dan.carpenter@oracle.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org

Simplify the check for return code of fcoe_if_init routine
in fcoe_init function such that we could eliminate need for
extra 'out_free' label and duplicate mutex_unlock statement.

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/fcoe/fcoe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ea21e7b..a2cf3d0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2523,14 +2523,13 @@ static int __init fcoe_init(void)
 	fcoe_dev_setup();
 
 	rc = fcoe_if_init();
+	mutex_unlock(&fcoe_config_mutex);
+
 	if (rc)
-		goto out_free;
+		goto out_destroy;
 
-	mutex_unlock(&fcoe_config_mutex);
 	return 0;
 
-out_free:
-	mutex_unlock(&fcoe_config_mutex);
 out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
