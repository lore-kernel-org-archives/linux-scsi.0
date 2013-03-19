From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/1] aacraid: Dual firmware image support
Date: Tue, 19 Mar 2013 12:37:26 +0530
Message-ID: <1363676846-2189-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43930 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab3CSMtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Mar 2013 08:49:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim.Leubner@pmcs.com, Tony.Ruiz@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Hi Tomas,

Thanks for your review comments.
I have used sslep(10) instead udelay in this patch.

Hi James,

Patch description:
This patch adds dual flash firmware support for Series 7 and above controllers.

Regards,
Mahesh

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |    6 +++++-
 drivers/scsi/aacraid/comminit.c |    2 +-
 drivers/scsi/aacraid/src.c      |   26 +++++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index a6f7190..9323d05 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 30000
+# define AAC_DRIVER_BUILD 30200
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -1918,6 +1918,10 @@ extern struct aac_common aac_config;
 #define	MONITOR_PANIC			0x00000020
 #define	KERNEL_UP_AND_RUNNING		0x00000080
 #define	KERNEL_PANIC			0x00000100
+#define	FLASH_UPD_PENDING		0x00002000
+#define	FLASH_UPD_SUCCESS		0x00004000
+#define	FLASH_UPD_FAILED		0x00008000
+#define	FWUPD_TIMEOUT			(5 * 60)
 
 /*
  *	Doorbell bit defines
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 3f75995..177b094 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -214,7 +214,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	cmd = (struct aac_close *) fib_data(fibctx);
 
 	cmd->command = cpu_to_le32(VM_CloseAll);
-	cmd->cid = cpu_to_le32(0xffffffff);
+	cmd->cid = cpu_to_le32(0xfffffffe);
 
 	status = aac_fib_send(ContainerCommand,
 			  fibctx,
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index e2e3492..0f56d8d 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -703,6 +703,28 @@ int aac_srcv_init(struct aac_dev *dev)
 		!aac_src_restart_adapter(dev, 0))
 		++restart;
 	/*
+	 *	Check to see if flash update is running.
+	 *	Wait for the adapter to be up and running. Wait up to 5 minutes
+	 */
+	status = src_readl(dev, MUnit.OMR);
+	if (status & FLASH_UPD_PENDING) {
+		start = jiffies;
+		do {
+			status = src_readl(dev, MUnit.OMR);
+			if (time_after(jiffies, start+HZ*FWUPD_TIMEOUT)) {
+				printk(KERN_ERR "%s%d: adapter flash update failed.\n",
+					dev->name, instance);
+				goto error_iounmap;
+			}
+		} while (!(status & FLASH_UPD_SUCCESS) &&
+			 !(status & FLASH_UPD_FAILED));
+		/* Delay 10 seconds.
+		 * Because right now FW is doing a soft reset,
+		 * do not read scratch pad register at this time
+		 */
+		ssleep(10);
+	}
+	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	status = src_readl(dev, MUnit.OMR);
@@ -730,7 +752,9 @@ int aac_srcv_init(struct aac_dev *dev)
 	/*
 	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
 	 */
-	while (!((status = src_readl(dev, MUnit.OMR)) & KERNEL_UP_AND_RUNNING)) {
+	while (!((status = src_readl(dev, MUnit.OMR)) &
+		KERNEL_UP_AND_RUNNING) ||
+		status == 0xffffffff) {
 		if ((restart &&
 		  (status & (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
 		  time_after(jiffies, start+HZ*startup_timeout)) {
-- 
1.7.7.6

