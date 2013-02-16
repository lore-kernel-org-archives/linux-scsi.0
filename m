From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/5] pmcraid: check for exceeding the max adapters limit
Date: Sat, 16 Feb 2013 23:27:58 +0900
Message-ID: <1361024879-12934-4-git-send-email-akinobu.mita@gmail.com>
References: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO2d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:28:33 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so995609pbc.19
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:28:32 -0800 (PST)
In-Reply-To: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Add proper check for running out of bitmap slot and disallow exceeding
the max adapters limit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 583ec82..e3b68d9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5372,8 +5372,10 @@ static unsigned short pmcraid_get_minor(void)
 {
 	int minor;
 
-	minor = find_first_zero_bit(pmcraid_minor, sizeof(pmcraid_minor));
-	__set_bit(minor, pmcraid_minor);
+	minor = find_first_zero_bit(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
+	if (minor < PMCRAID_MAX_ADAPTERS)
+		__set_bit(minor, pmcraid_minor);
+
 	return minor;
 }
 
@@ -5399,6 +5401,9 @@ static int pmcraid_setup_chrdev(struct pmcraid_instance *pinstance)
 	int error;
 
 	minor = pmcraid_get_minor();
+	if (minor >= PMCRAID_MAX_ADAPTERS)
+		return -EBUSY;
+
 	cdev_init(&pinstance->cdev, &pmcraid_fops);
 	pinstance->cdev.owner = THIS_MODULE;
 
-- 
1.8.1

