From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH] SCSI:implement PM for st
Date: Mon, 16 Jan 2012 09:31:33 +0100
Message-ID: <201201160931.33777.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab2API3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 03:29:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?iso-8859-1?q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

>From 595fa6688232fd68f221fc2734545d3e995c465a Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Sun, 15 Jan 2012 00:16:51 +0100
Subject: [PATCH] SCSI:implement PM for st

This implements basic power management for SCSI tapes.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/st.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9b28f39..9262cdf 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1177,6 +1177,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 static int st_open(struct inode *inode, struct file *filp)
 {
 	int i, retval = (-EIO);
+	int resumed = 0;
 	struct scsi_tape *STp;
 	struct st_partstat *STps;
 	int dev = TAPE_NR(inode);
@@ -1211,6 +1212,11 @@ static int st_open(struct inode *inode, struct file *filp)
 	write_unlock(&st_dev_arr_lock);
 	STp->rew_at_close = STp->autorew_dev = (iminor(inode) & 0x80) == 0;
 
+	if (scsi_autopm_get_device(STp->device) < 0) {
+		retval = -EIO;
+		goto err_out;
+	}
+	resumed = 1;
 	if (!scsi_block_when_processing_errors(STp->device)) {
 		retval = (-ENXIO);
 		goto err_out;
@@ -1258,6 +1264,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	normalize_buffer(STp->buffer);
 	STp->in_use = 0;
 	scsi_tape_put(STp);
+	if (resumed)
+		scsi_autopm_put_device(STp->device);
 	mutex_unlock(&st_mutex);
 	return retval;
 
@@ -1391,6 +1399,7 @@ static int st_release(struct inode *inode, struct file *filp)
 	write_lock(&st_dev_arr_lock);
 	STp->in_use = 0;
 	write_unlock(&st_dev_arr_lock);
+	scsi_autopm_put_device(STp->device);
 	scsi_tape_put(STp);
 
 	return result;
@@ -4154,6 +4163,7 @@ static int st_probe(struct device *dev)
 		if (error)
 			goto out_free_tape;
 	}
+	scsi_autopm_put_device(SDp);
 
 	sdev_printk(KERN_NOTICE, SDp,
 		    "Attached scsi tape %s\n", tape_name(tpnt));
@@ -4201,6 +4211,7 @@ static int st_remove(struct device *dev)
 	struct scsi_tape *tpnt;
 	int i, j, mode;
 
+	scsi_autopm_get_device(SDp);
 	write_lock(&st_dev_arr_lock);
 	for (i = 0; i < st_dev_max; i++) {
 		tpnt = scsi_tapes[i];
-- 
1.7.1

