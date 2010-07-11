From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
Subject: [PATCH] pmcraid : Remove unwanted cast for void * pointers
Date: Mon, 12 Jul 2010 00:42:00 +0530
Message-ID: <1278875520-18592-1-git-send-email-cyril.jayaprakash@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, vasu.dev@intel.com, akpm@linux-foundation.org, James.Bottomley@suse.de, anil_ravindranath@pmc-sierra.com, Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>

Patch to remove unwanted cast for void * pointers.

Signed-off-by: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
---
 drivers/scsi/pmcraid.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index c44e4ab..bd0b5a0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3324,8 +3324,7 @@ static int pmcraid_chr_open(struct inode *inode, struct file *filep)
  */
 static int pmcraid_chr_release(struct inode *inode, struct file *filep)
 {
-	struct pmcraid_instance *pinstance =
-		((struct pmcraid_instance *)filep->private_data);
+	struct pmcraid_instance *pinstance = filep->private_data;
 
 	filep->private_data = NULL;
 	fasync_helper(-1, filep, 0, &pinstance->aen_queue);
@@ -3344,7 +3343,7 @@ static int pmcraid_chr_fasync(int fd, struct file *filep, int mode)
 	struct pmcraid_instance *pinstance;
 	int rc;
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 	mutex_lock(&pinstance->aen_queue_lock);
 	rc = fasync_helper(fd, filep, mode, &pinstance->aen_queue);
 	mutex_unlock(&pinstance->aen_queue_lock);
@@ -3795,7 +3794,7 @@ static long pmcraid_chr_ioctl(
 		return retval;
 	}
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 
 	if (!pinstance) {
 		pmcraid_info("adapter instance is not found\n");
-- 
1.7.0.4
