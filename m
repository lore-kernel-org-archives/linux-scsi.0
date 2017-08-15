From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] ch: add refcounting
Date: Tue, 15 Aug 2017 16:28:49 +0200
Message-ID: <1502807329-75158-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752316AbdHOPIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 11:08:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

struct scsi_changer needs refcounting as the device
might be removed while the fd is still open.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index dad959f..b14583a 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -105,6 +105,7 @@
 static struct class * ch_sysfs_class;
 
 typedef struct {
+	struct kref         ref;
 	struct list_head    list;
 	int                 minor;
 	char                name[8];
@@ -563,13 +564,23 @@ static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 
 /* ------------------------------------------------------------------------ */
 
+static void ch_destroy(struct kref *ref)
+{
+	scsi_changer *ch = container_of(ref, scsi_changer, ref);
+
+	kfree(ch->dt);
+	kfree(ch);
+}
+
 static int
 ch_release(struct inode *inode, struct file *file)
 {
 	scsi_changer *ch = file->private_data;
 
 	scsi_device_put(ch->device);
+	ch->device = NULL;
 	file->private_data = NULL;
+	kref_put(&ch->ref, ch_destroy);
 	return 0;
 }
 
@@ -588,6 +599,7 @@ static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
+	kref_get(&ch->ref);
 	spin_unlock(&ch_index_lock);
 
 	file->private_data = ch;
@@ -935,8 +947,11 @@ static int ch_probe(struct device *dev)
 	}
 
 	mutex_init(&ch->lock);
+	kref_init(&ch->ref);
 	ch->device = sd;
-	ch_readconfig(ch);
+	ret = ch_readconfig(ch);
+	if (ret)
+		goto destroy_dev;
 	if (init)
 		ch_init_elem(ch);
 
@@ -944,6 +959,8 @@ static int ch_probe(struct device *dev)
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
 	return 0;
+destroy_dev:
+	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
 remove_idr:
 	idr_remove(&ch_index_idr, ch->minor);
 free_ch:
@@ -960,8 +977,7 @@ static int ch_remove(struct device *dev)
 	spin_unlock(&ch_index_lock);
 
 	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
-	kfree(ch->dt);
-	kfree(ch);
+	kref_put(&ch->ref, ch_destroy);
 	return 0;
 }
 
-- 
1.8.5.6
