From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 06/13] scsi: be2iscsi: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:38 +0530
Message-ID: <1506073905-12985-7-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36550 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:23 -0400
Received: by mail-pf0-f196.google.com with SMTP id f84so264953pfj.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:23 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b4542e7..5579454 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5708,9 +5708,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	 * Start UE detection here. UE before this will cause stall in probe
 	 * and eventually fail the probe.
 	 */
-	init_timer(&phba->hw_check);
-	phba->hw_check.function = beiscsi_hw_health_check;
-	phba->hw_check.data = (unsigned long)phba;
+	setup_timer(&phba->hw_check, beiscsi_hw_health_check,
+		    (unsigned long)phba);
 	mod_timer(&phba->hw_check,
 		  jiffies + msecs_to_jiffies(BEISCSI_UE_DETECT_INTERVAL));
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-- 
2.7.4
