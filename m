From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] st: fix potential null pointer dereference.
Date: Wed, 18 Nov 2015 14:18:09 +0100
Message-ID: <1447852689-28736-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbbKRNSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Nov 2015 08:18:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

If cdev_add() returns an error, the code calls
cdev_del() passing the STm->cdevs[rew] pointer as parameter;
the problem is that the pointer has not been initialized yet.

This patch fixes the problem by moving the STm->cdevs[rew] pointer
initialization before the call to cdev_add().
It also sets STm->devs[rew] = NULL if device_create() fails, just to be
sure we won't end up calling device_unregister() with an invalid pointer.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/st.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e0a1e52..dff3bdb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4083,6 +4083,7 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	}
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &st_fops;
+	STm->cdevs[rew] = cdev;
 
 	error = cdev_add(cdev, cdev_devno, 1);
 	if (error) {
@@ -4091,7 +4092,6 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 		pr_err("st%d: Device not attached.\n", dev_num);
 		goto out_free;
 	}
-	STm->cdevs[rew] = cdev;
 
 	i = mode << (4 - ST_NBR_MODE_BITS);
 	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
@@ -4102,6 +4102,7 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	if (IS_ERR(dev)) {
 		pr_err("st%d: device_create failed\n", dev_num);
 		error = PTR_ERR(dev);
+		STm->devs[rew] = NULL;
 		goto out_free;
 	}
 
-- 
Maurizio Lombardi

