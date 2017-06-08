From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 2/2] scsi: esas2r: Replace semaphore fs_api_semaphore with mutex
Date: Thu,  8 Jun 2017 15:37:31 +0530
Message-ID: <1496916451-6606-3-git-send-email-binoy.jayan@linaro.org>
References: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35208 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdFHKH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2017 06:07:57 -0400
Received: by mail-pf0-f182.google.com with SMTP id l89so15608656pfi.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jun 2017 03:07:57 -0700 (PDT)
In-Reply-To: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Rajendra <rnayak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

The semaphore 'fs_api_semaphore' is used as a simple mutex, so
it should be written as one. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/scsi/esas2r/esas2r.h       | 2 +-
 drivers/scsi/esas2r/esas2r_init.c  | 2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index c5013de..1da6407 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -946,7 +946,7 @@ struct esas2r_adapter {
 	struct esas2r_mem_desc *vrq_mds;
 	int num_vrqs;
 	struct mutex fm_api_mutex;
-	struct semaphore fs_api_semaphore;
+	struct mutex fs_api_mutex;
 	struct semaphore nvram_semaphore;
 	struct atto_ioctl *local_atto_ioctl;
 	u8 fw_coredump_buff[ESAS2R_FWCOREDUMP_SZ];
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index ad85b33..5b14dd2 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -328,7 +328,7 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	spin_lock_init(&a->request_lock);
 	spin_lock_init(&a->fw_event_lock);
 	mutex_init(&a->fm_api_mutex);
-	sema_init(&a->fs_api_semaphore, 1);
+	mutex_init(&a->fs_api_mutex);
 	sema_init(&a->nvram_semaphore, 1);
 
 	esas2r_fw_event_off(a);
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index c6b041a..9762300 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1962,7 +1962,7 @@ int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count)
 			(struct esas2r_ioctl_fs *)a->fs_api_buffer;
 
 		/* If another flash request is already in progress, return. */
-		if (down_interruptible(&a->fs_api_semaphore)) {
+		if (mutex_lock_interruptible(&a->fs_api_mutex)) {
 busy:
 			fs->status = ATTO_STS_OUT_OF_RSRC;
 			return -EBUSY;
@@ -1978,7 +1978,7 @@ int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count)
 		rq = esas2r_alloc_request(a);
 		if (rq == NULL) {
 			esas2r_debug("esas2r_read_fs: out of requests");
-			up(&a->fs_api_semaphore);
+			mutex_unlock(&a->fs_api_mutex);
 			goto busy;
 		}
 
@@ -2006,7 +2006,7 @@ int esas2r_read_fs(struct esas2r_adapter *a, char *buf, long off, int count)
 		;
 dont_wait:
 		/* Free the request and keep going */
-		up(&a->fs_api_semaphore);
+		mutex_unlock(&a->fs_api_mutex);
 		esas2r_free_request(a, (struct esas2r_request *)rq);
 
 		/* Pick up possible error code from above */
-- 
Binoy Jayan
