From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH V2] st: fix potential null pointer dereference.
Date: Wed, 18 Nov 2015 15:32:44 +0100
Message-ID: <1447857164-2043-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793AbbKROcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Nov 2015 09:32:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

If cdev_add() returns an error, the code calls
cdev_del() passing the STm->cdevs[rew] pointer as parameter;
the problem is that the pointer has not been initialized yet.

This patch fixes the problem by moving the STm->cdevs[rew] pointer
initialization before the call to cdev_add().
It also sets STm->devs[rew] and STm->cdevs[rew] to NULL in
case of failure.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/st.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e0a1e52..2e52295 100644
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
@@ -4110,8 +4110,9 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	return 0;
 out_free:
 	cdev_del(STm->cdevs[rew]);
-	STm->cdevs[rew] = NULL;
 out:
+	STm->cdevs[rew] = NULL;
+	STm->devs[rew] = NULL;
 	return error;
 }
 
-- 
Maurizio Lombardi

