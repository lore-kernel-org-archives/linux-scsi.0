From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [v2] scsi: fusion: fix string overflow warning
Date: Mon, 17 Jul 2017 14:00:00 +0200
Message-ID: <20170717120017.1269276-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:50881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdGQMAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2017 08:00:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: David Laight <David.Laight@aculab.com>, Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bhaktipriya Shridhar <bhaktipriya96@gmail.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

gcc points out a theorerical string overflow:

drivers/message/fusion/mptbase.c: In function 'mpt_detach':
drivers/message/fusion/mptbase.c:2103:17: error: '%s' directive writing up to 31 bytes into a region of size 28 [-Werror=format-overflow=]
sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
               ^~~~~
drivers/message/fusion/mptbase.c:2103:2: note: 'sprintf' output between 13 and 44 bytes into a destination of size 32

We can simply double the size of the local buffer here to be on the
safe side, and using snprintf() instead of sprintf() protects us
if ioc->name was not terminated properly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: also use snprintf
---
 drivers/message/fusion/mptbase.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 62cff5afc6bd..84eab28665f3 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2079,7 +2079,7 @@ void
 mpt_detach(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
-	char pname[32];
+	char pname[64];
 	u8 cb_idx;
 	unsigned long flags;
 	struct workqueue_struct *wq;
@@ -2100,11 +2100,11 @@ mpt_detach(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 	destroy_workqueue(wq);
 
-	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
+	snprintf(pname, sizeof(pname), MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
 	remove_proc_entry(pname, NULL);
-	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/info", ioc->name);
+	snprintf(pname, sizeof(pname), MPT_PROCFS_MPTBASEDIR "/%s/info", ioc->name);
 	remove_proc_entry(pname, NULL);
-	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
+	snprintf(pname, sizeof(pname), MPT_PROCFS_MPTBASEDIR "/%s", ioc->name);
 	remove_proc_entry(pname, NULL);
 
 	/* call per device driver remove entry point */
-- 
2.9.0
