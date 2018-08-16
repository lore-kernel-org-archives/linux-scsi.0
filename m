From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: remove unused variables dev and cpu
Date: Thu, 16 Aug 2018 14:33:20 +0100
Message-ID: <20180816133320.19682-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variables dev and cpu are not being used and are redundant and hence can
be removed.

Cleans up clang warnings:
warning: variable 'dev' set but not used [-Wunused-but-set-variable]
warning: variable 'cpu' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/aachba.c  | 7 -------
 drivers/scsi/aacraid/commsup.c | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 6e356325d8d9..bd7f352c28f3 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3480,7 +3480,6 @@ int aac_dev_ioctl(struct aac_dev *dev, int cmd, void __user *arg)
 
 static void aac_srb_callback(void *context, struct fib * fibptr)
 {
-	struct aac_dev *dev;
 	struct aac_srb_reply *srbreply;
 	struct scsi_cmnd *scsicmd;
 
@@ -3491,8 +3490,6 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 
 	BUG_ON(fibptr == NULL);
 
-	dev = fibptr->dev;
-
 	srbreply = (struct aac_srb_reply *) fib_data(fibptr);
 
 	scsicmd->sense_buffer[0] = '\0';  /* Initialize sense valid flag to false */
@@ -3921,13 +3918,11 @@ static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
 
 static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
 {
-	struct aac_dev *dev;
 	unsigned long byte_count = 0;
 	int nseg;
 	struct scatterlist *sg;
 	int i;
 
-	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
 	psg->count = 0;
 	psg->sg[0].addr = 0;
@@ -3963,14 +3958,12 @@ static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
 
 static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg)
 {
-	struct aac_dev *dev;
 	unsigned long byte_count = 0;
 	u64 addr;
 	int nseg;
 	struct scatterlist *sg;
 	int i;
 
-	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
 	psg->count = 0;
 	psg->sg[0].addr[0] = 0;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 6e1b022a823d..1e77d96a18f2 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2586,9 +2586,7 @@ int aac_acquire_irq(struct aac_dev *dev)
 void aac_free_irq(struct aac_dev *dev)
 {
 	int i;
-	int cpu;
 
-	cpu = cpumask_first(cpu_online_mask);
 	if (aac_is_src(dev)) {
 		if (dev->max_msix > 1) {
 			for (i = 0; i < dev->max_msix; i++)
-- 
2.17.1
