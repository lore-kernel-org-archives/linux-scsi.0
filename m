From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 1/2] scsi: esas2r: Replace semaphore fm_api_semaphore with mutex
Date: Thu,  8 Jun 2017 15:37:30 +0530
Message-ID: <1496916451-6606-2-git-send-email-binoy.jayan@linaro.org>
References: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Rajendra <rnayak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The semaphore 'fm_api_semaphore' is used as a simple mutex, so
it should be written as one. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/scsi/esas2r/esas2r.h       | 2 +-
 drivers/scsi/esas2r/esas2r_init.c  | 2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index b6030e3..c5013de 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -945,7 +945,7 @@ struct esas2r_adapter {
 	struct list_head vrq_mds_head;
 	struct esas2r_mem_desc *vrq_mds;
 	int num_vrqs;
-	struct semaphore fm_api_semaphore;
+	struct mutex fm_api_mutex;
 	struct semaphore fs_api_semaphore;
 	struct semaphore nvram_semaphore;
 	struct atto_ioctl *local_atto_ioctl;
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 6432a50..ad85b33 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -327,7 +327,7 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	esas2r_debug("new adapter %p, name %s", a, a->name);
 	spin_lock_init(&a->request_lock);
 	spin_lock_init(&a->fw_event_lock);
-	sema_init(&a->fm_api_semaphore, 1);
+	mutex_init(&a->fm_api_mutex);
 	sema_init(&a->fs_api_semaphore, 1);
 	sema_init(&a->nvram_semaphore, 1);
 
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 2d4b7f0..c6b041a 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -110,7 +110,7 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
 {
 	struct esas2r_request *rq;
 
-	if (down_interruptible(&a->fm_api_semaphore)) {
+	if (mutex_lock_interruptible(&a->fm_api_mutex)) {
 		fi->status = FI_STAT_BUSY;
 		return;
 	}
@@ -173,7 +173,7 @@ static void do_fm_api(struct esas2r_adapter *a, struct esas2r_flash_img *fi)
 free_req:
 	esas2r_free_request(a, (struct esas2r_request *)rq);
 free_sem:
-	up(&a->fm_api_semaphore);
+	mutex_unlock(&a->fm_api_mutex);
 	return;
 
 }
-- 
Binoy Jayan
