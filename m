From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] ch: add refcounting
Date: Tue,  8 Apr 2014 08:27:17 +0200
Message-ID: <1396938437-29616-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaDHG1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2014 02:27:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'scsi_changer' structure needs refcounting, as the device
might be removed while the fd is still open.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2a32374..adb5426 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -102,6 +102,7 @@ do {									\
 static struct class * ch_sysfs_class;
 
 typedef struct {
+	struct kref         ref;
 	struct list_head    list;
 	int                 minor;
 	char                name[8];
@@ -565,13 +566,23 @@ static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 
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
 
@@ -590,6 +601,7 @@ ch_open(struct inode *inode, struct file *file)
 		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
+	kref_get(&ch->ref);
 	spin_unlock(&ch_index_lock);
 
 	file->private_data = ch;
@@ -931,6 +943,7 @@ static int ch_probe(struct device *dev)
 	}
 
 	mutex_init(&ch->lock);
+	kref_init(&ch->ref);
 	ch->device = sd;
 	ch_readconfig(ch);
 	if (init)
@@ -956,8 +969,7 @@ static int ch_remove(struct device *dev)
 	spin_unlock(&ch_index_lock);
 
 	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
-	kfree(ch->dt);
-	kfree(ch);
+	kref_put(&ch->ref, ch_destroy);
 	return 0;
 }
 
-- 
1.7.12.4

