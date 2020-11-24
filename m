Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF04CC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B760820857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgKXEgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:36:11 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:59174 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgKXEgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 23:36:10 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id C7448180A7FD1;
        Tue, 24 Nov 2020 04:36:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: silk95_52127e92736b
X-Filterd-Recvd-Size: 4437
Received: from joe-laptop.perches.com (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Nov 2020 04:36:08 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: pm8001: Convert pm8001_printk to pm8001_info
Date:   Mon, 23 Nov 2020 20:36:03 -0800
Message-Id: <69dc34ff63adfa60b3f203ed2d58143b5692af57.1606192458.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1606192458.git.joe@perches.com>
References: <cover.1606192458.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the more common logging style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 12 ++++++------
 drivers/scsi/pm8001/pm8001_sas.c  |  4 ++--
 drivers/scsi/pm8001/pm8001_sas.h  |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 13530d7fb8a6..38907f45c845 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1293,8 +1293,8 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	device_state = pci_choose_state(pdev, state);
-	pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
-		      pdev, pm8001_ha->name, device_state);
+	pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
+		    pdev, pm8001_ha->name, device_state);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
@@ -1318,16 +1318,16 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
 
-	pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
-		      pdev, pm8001_ha->name, device_state);
+	pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
+		    pdev, pm8001_ha->name, device_state);
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		pm8001_printk(pm8001_ha, "slot=%s Enable device failed during resume\n",
-			      pm8001_ha->name);
+		pm8001_info(pm8001_ha, "slot=%s Enable device failed during resume\n",
+			    pm8001_ha->name);
 		goto err_out_enable;
 	}
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 4562b0a5062a..d1e9dba2ef19 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1191,7 +1191,7 @@ int pm8001_abort_task(struct sas_task *task)
 	phy_id = pm8001_dev->attached_phy;
 	ret = pm8001_find_tag(task, &tag);
 	if (ret == 0) {
-		pm8001_printk(pm8001_ha, "no tag for task:%p\n", task);
+		pm8001_info(pm8001_ha, "no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
 	spin_lock_irqsave(&task->task_state_lock, flags);
@@ -1313,7 +1313,7 @@ int pm8001_abort_task(struct sas_task *task)
 		task->slow_task = NULL;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	if (rc != TMF_RESP_FUNC_COMPLETE)
-		pm8001_printk(pm8001_ha, "rc= %d\n", rc);
+		pm8001_info(pm8001_ha, "rc= %d\n", rc);
 	return rc;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 5266756a268b..f2c8cbad3853 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -70,14 +70,14 @@
 #define PM8001_DEVIO_LOGGING	0x100 /* development io message logging */
 #define PM8001_IOERR_LOGGING	0x200 /* development io err message logging */
 
-#define pm8001_printk(HBA, fmt, ...)					\
+#define pm8001_info(HBA, fmt, ...)					\
 	pr_info("%s:: %s  %d:" fmt,					\
 		(HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
 
 #define pm8001_dbg(HBA, level, fmt, ...)				\
 do {									\
 	if (unlikely((HBA)->logging_level & PM8001_##level##_LOGGING))	\
-		pm8001_printk(HBA, fmt, ##__VA_ARGS__);			\
+		pm8001_info(HBA, fmt, ##__VA_ARGS__);			\
 } while (0)
 
 #define PM8001_USE_TASKLET
-- 
2.26.0

