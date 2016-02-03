From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V6 08/10] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 3 Feb 2016 15:06:06 -0800
Message-ID: <1454540768-12271-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:38075 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695AbcBCW4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 17:56:02 -0500
In-Reply-To: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

while driver removal is in progress or PCI shutdown is invoked, driver
kills AIF aacraid thread, but IOCTL requests from the management tools
re-start AIF thread leading to IOP_RESET.

Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.

Changes in V2:
Set adapter_shutdown flag before shutdown command is sent to \
controller

Changes in V3:
Call aac_send_shut_shutdown first thing in __aac_shutdown
Convert adapter_shutdown to atomic_t variable to prevent \
SMP coherency issues(race conditions)

Changes in V4:
Used mutex to protect ioctl path and adapter_shutdown to prevent \
race conditions.

Changes in V5:
Moved replacement of aac_mutex with ioctl_mutex to previous patch

Changes in V6:
Unlock ioctl_mutex if adpater_shutdown is set

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/commctrl.c | 5 +++++
 drivers/scsi/aacraid/comminit.c | 6 ++++--
 drivers/scsi/aacraid/linit.c    | 5 +++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index ebf214b..4b3bb52 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -857,6 +857,11 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 
 	mutex_lock(&dev->ioctl_mutex);
 
+	if (dev->adapter_shutdown) {
+		status = -EACCES;
+		goto cleanup;
+	}
+
 	/*
 	 *	HBA gets first crack
 	 */
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 0e954e3..2b4e753 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -212,8 +212,11 @@ int aac_send_shutdown(struct aac_dev * dev)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
 
-	cmd = (struct aac_close *) fib_data(fibctx);
+	mutex_lock(&dev->ioctl_mutex);
+	dev->adapter_shutdown = 1;
+	mutex_unlock(&dev->ioctl_mutex);
 
+	cmd = (struct aac_close *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(VM_CloseAll);
 	cmd->cid = cpu_to_le32(0xfffffffe);
 
@@ -229,7 +232,6 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
-	dev->adapter_shutdown = 1;
 	if ((dev->pdev->device == PMC_DEVICE_S7 ||
 	     dev->pdev->device == PMC_DEVICE_S8 ||
 	     dev->pdev->device == PMC_DEVICE_S9) &&
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3f9c741..334f2a6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -705,7 +705,7 @@ static long aac_cfg_ioctl(struct file *file,
 {
 	struct aac_dev *aac = (struct aac_dev *)file->private_data;
 
-	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	return aac_do_ioctl(aac, cmd, (void __user *)arg);
@@ -1072,6 +1072,8 @@ static void __aac_shutdown(struct aac_dev * aac)
 	int i;
 	int cpu;
 
+	aac_send_shutdown(aac);
+
 	if (aac->aif_thread) {
 		int i;
 		/* Clear out events first */
@@ -1083,7 +1085,6 @@ static void __aac_shutdown(struct aac_dev * aac)
 		}
 		kthread_stop(aac->thread);
 	}
-	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
 	cpu = cpumask_first(cpu_online_mask);
 	if (aac->pdev->device == PMC_DEVICE_S6 ||
-- 
1.9.1

