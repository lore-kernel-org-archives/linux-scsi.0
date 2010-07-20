From: akpm@linux-foundation.org
Subject: [patch 27/27] drivers/scsi/pmcraid.c: remove unwanted cast for void* pointers
Date: Tue, 20 Jul 2010 15:29:06 -0700
Message-ID: <201007202229.o6KMT69T021808@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932886Ab0GTW3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, cyril.jayaprakash@gmail.com

From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>

Signed-off-by: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/pmcraid.c~drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers
+++ a/drivers/scsi/pmcraid.c
@@ -3599,8 +3599,7 @@ static int pmcraid_chr_open(struct inode
  */
 static int pmcraid_chr_release(struct inode *inode, struct file *filep)
 {
-	struct pmcraid_instance *pinstance =
-		((struct pmcraid_instance *)filep->private_data);
+	struct pmcraid_instance *pinstance = filep->private_data;
 
 	filep->private_data = NULL;
 	fasync_helper(-1, filep, 0, &pinstance->aen_queue);
@@ -3619,7 +3618,7 @@ static int pmcraid_chr_fasync(int fd, st
 	struct pmcraid_instance *pinstance;
 	int rc;
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 	mutex_lock(&pinstance->aen_queue_lock);
 	rc = fasync_helper(fd, filep, mode, &pinstance->aen_queue);
 	mutex_unlock(&pinstance->aen_queue_lock);
@@ -4110,7 +4109,7 @@ static long pmcraid_chr_ioctl(
 		return retval;
 	}
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 
 	if (!pinstance) {
 		pmcraid_info("adapter instance is not found\n");
_
