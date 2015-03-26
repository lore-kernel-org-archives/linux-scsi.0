From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 08/11] aacraid: IOCTL fix
Date: Thu, 26 Mar 2015 10:41:29 -0400
Message-ID: <1427380892-1978-9-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50360 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbbCZOs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:48:29 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add cfg IOCTL command fix

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |    1 +
 drivers/scsi/aacraid/comminit.c |    3 +++
 drivers/scsi/aacraid/linit.c    |    4 +++-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9b469a4..43d8076 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1222,6 +1222,7 @@ struct aac_dev
 	int			msi_enabled;	/* MSI/MSI-X enabled */
 	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
+	u8			adapter_shutdown;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 284b1c5..27432b9 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -231,6 +231,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
+	dev->adapter_shutdown = 1;
 	if ((dev->pdev->device == PMC_DEVICE_S7 ||
 	     dev->pdev->device == PMC_DEVICE_S8 ||
 	     dev->pdev->device == PMC_DEVICE_S9) &&
@@ -400,6 +401,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	}
 	dev->max_msix = 0;
 	dev->msi_enabled = 0;
+	dev->adapter_shutdown = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
 	  0, 0, 0, 0, 0, 0,
 	  status+0, status+1, status+2, status+3, status+4))
@@ -511,6 +513,7 @@ static void aac_define_int_mode(struct aac_dev *dev)
 
 	int i, msi_count;
 
+	msi_count = i = 0;
 	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
 	if (dev->max_msix == 0 ||
 	    dev->pdev->device == PMC_DEVICE_S6 ||
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 75c3501..36653a9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -713,7 +713,9 @@ static long aac_cfg_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	int ret;
-	if (!capable(CAP_SYS_RAWIO))
+	struct aac_dev *aac;
+	aac = (struct aac_dev *)file->private_data;
+	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
 		return -EPERM;
 	mutex_lock(&aac_mutex);
 	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
-- 
1.7.7.3

