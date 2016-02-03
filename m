From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V6 07/10] aacraid: Created new mutex for ioctl path
Date: Wed, 3 Feb 2016 15:06:05 -0800
Message-ID: <1454540768-12271-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57329 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbcBCW4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 17:56:02 -0500
In-Reply-To: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com, RaghavaAditya.Renukunta@pmcs.com

aac_mutex was used to create protect the ioctl path for only the
compat path, it would be make more sense to place mutex in
aac_do_ioctl, which is the main ioctl function call that handles
all ioctl commands.

Created new mutex ioctl_mutex in struct aac_dev to protect switch
case in aac_do_ioctl and removed aac_mutex from aac_cfg_ioctl and
aac_compat_do_ioctl

Changes in V1:
Unlock ioctl_mutex incase of error
Fix compilation error with aac->adapter_shutdown

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/commctrl.c |  8 +++++++-
 drivers/scsi/aacraid/linit.c    | 13 ++++---------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 2916288..75bc65e 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1124,6 +1124,7 @@ struct aac_dev
 	struct fib		*free_fib;
 	spinlock_t		fib_lock;
 
+	struct mutex		ioctl_mutex;
 	struct aac_queue_block *queues;
 	/*
 	 *	The user API will use an IOCTL to register itself to receive
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 54195a1..ebf214b 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -855,13 +855,15 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 {
 	int status;
 
+	mutex_lock(&dev->ioctl_mutex);
+
 	/*
 	 *	HBA gets first crack
 	 */
 
 	status = aac_dev_ioctl(dev, cmd, arg);
 	if (status != -ENOTTY)
-		return status;
+		goto cleanup;
 
 	switch (cmd) {
 	case FSACTL_MINIPORT_REV_CHECK:
@@ -890,6 +892,10 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 		status = -ENOTTY;
 		break;
 	}
+
+cleanup:
+	mutex_unlock(&dev->ioctl_mutex);
+
 	return status;
 }
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 48e2a79..3f9c741 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -703,23 +703,18 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 static long aac_cfg_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
-	int ret;
-	struct aac_dev *aac;
-	aac = (struct aac_dev *)file->private_data;
+	struct aac_dev *aac = (struct aac_dev *)file->private_data;
+
 	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
 		return -EPERM;
-	mutex_lock(&aac_mutex);
-	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
-	mutex_unlock(&aac_mutex);
 
-	return ret;
+	return aac_do_ioctl(aac, cmd, (void __user *)arg);
 }
 
 #ifdef CONFIG_COMPAT
 static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
 {
 	long ret;
-	mutex_lock(&aac_mutex);
 	switch (cmd) {
 	case FSACTL_MINIPORT_REV_CHECK:
 	case FSACTL_SENDFIB:
@@ -753,7 +748,6 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	mutex_unlock(&aac_mutex);
 	return ret;
 }
 
@@ -1194,6 +1188,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
 
+	mutex_init(&aac->ioctl_mutex);
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-- 
1.9.1

