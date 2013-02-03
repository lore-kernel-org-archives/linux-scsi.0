From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 45/62] scsi: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:46 -0800
Message-ID: <1359854463-2538-46-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/scsi/ch.c | 21 +++++++++------------
 drivers/scsi/sg.c | 43 +++++++++++++++++--------------------------
 drivers/scsi/st.c | 27 ++++++++-------------------
 3 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index a15474e..2a32374 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -895,7 +895,7 @@ static int ch_probe(struct device *dev)
 {
 	struct scsi_device *sd = to_scsi_device(dev);
 	struct device *class_dev;
-	int minor, ret = -ENOMEM;
+	int ret;
 	scsi_changer *ch;
 
 	if (sd->type != TYPE_MEDIUM_CHANGER)
@@ -905,22 +905,19 @@ static int ch_probe(struct device *dev)
 	if (NULL == ch)
 		return -ENOMEM;
 
-	if (!idr_pre_get(&ch_index_idr, GFP_KERNEL))
-		goto free_ch;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&ch_index_lock);
-	ret = idr_get_new(&ch_index_idr, ch, &minor);
+	ret = idr_alloc(&ch_index_idr, ch, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
 	spin_unlock(&ch_index_lock);
+	idr_preload_end();
 
-	if (ret)
+	if (ret < 0) {
+		if (ret == -ENOSPC)
+			ret = -ENODEV;
 		goto free_ch;
-
-	if (minor > CH_MAX_DEVS) {
-		ret = -ENODEV;
-		goto remove_idr;
 	}
 
-	ch->minor = minor;
+	ch->minor = ret;
 	sprintf(ch->name,"ch%d",ch->minor);
 
 	class_dev = device_create(ch_sysfs_class, dev,
@@ -944,7 +941,7 @@ static int ch_probe(struct device *dev)
 
 	return 0;
 remove_idr:
-	idr_remove(&ch_index_idr, minor);
+	idr_remove(&ch_index_idr, ch->minor);
 free_ch:
 	kfree(ch);
 	return ret;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index be2c9a6..9f0c465 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1391,24 +1391,23 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (!idr_pre_get(&sg_index_idr, GFP_KERNEL)) {
-		printk(KERN_WARNING "idr expansion Sg_device failure\n");
-		error = -ENOMEM;
-		goto out;
-	}
-
+	idr_preload(GFP_KERNEL);
 	write_lock_irqsave(&sg_index_lock, iflags);
 
-	error = idr_get_new(&sg_index_idr, sdp, &k);
-	if (error) {
-		write_unlock_irqrestore(&sg_index_lock, iflags);
-		printk(KERN_WARNING "idr allocation Sg_device failure: %d\n",
-		       error);
-		goto out;
+	error = idr_alloc(&sg_index_idr, sdp, 0, SG_MAX_DEVS, GFP_NOWAIT);
+	if (error < 0) {
+		if (error == -ENOSPC) {
+			sdev_printk(KERN_WARNING, scsidp,
+				    "Unable to attach sg device type=%d, minor number exceeds %d\n",
+				    scsidp->type, SG_MAX_DEVS - 1);
+			error = -ENODEV;
+		} else {
+			printk(KERN_WARNING
+			       "idr allocation Sg_device failure: %d\n", error);
+		}
+		goto out_unlock;
 	}
-
-	if (unlikely(k >= SG_MAX_DEVS))
-		goto overflow;
+	k = error;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
 	sprintf(disk->disk_name, "sg%d", k);
@@ -1420,25 +1419,17 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
+	error = 0;
 
+out_unlock:
 	write_unlock_irqrestore(&sg_index_lock, iflags);
+	idr_preload_end();
 
-	error = 0;
- out:
 	if (error) {
 		kfree(sdp);
 		return ERR_PTR(error);
 	}
 	return sdp;
-
- overflow:
-	idr_remove(&sg_index_idr, k);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	sdev_printk(KERN_WARNING, scsidp,
-		    "Unable to attach sg device type=%d, minor "
-		    "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
-	error = -ENODEV;
-	goto out;
 }
 
 static int
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 98156a9..7c6edca 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4076,7 +4076,7 @@ static int st_probe(struct device *dev)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *buffer;
-	int i, dev_num, error;
+	int i, error;
 	char *stp;
 
 	if (SDp->type != TYPE_TAPE)
@@ -4178,27 +4178,17 @@ static int st_probe(struct device *dev)
 	    tpnt->blksize_changed = 0;
 	mutex_init(&tpnt->lock);
 
-	if (!idr_pre_get(&st_index_idr, GFP_KERNEL)) {
-		pr_warn("st: idr expansion failed\n");
-		error = -ENOMEM;
-		goto out_put_disk;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&st_index_lock);
-	error = idr_get_new(&st_index_idr, tpnt, &dev_num);
+	error = idr_alloc(&st_index_idr, tpnt, 0, ST_MAX_TAPES + 1, GFP_NOWAIT);
 	spin_unlock(&st_index_lock);
-	if (error) {
+	idr_preload_end();
+	if (error < 0) {
 		pr_warn("st: idr allocation failed: %d\n", error);
 		goto out_put_disk;
 	}
-
-	if (dev_num > ST_MAX_TAPES) {
-		pr_err("st: Too many tape devices (max. %d).\n", ST_MAX_TAPES);
-		goto out_put_index;
-	}
-
-	tpnt->index = dev_num;
-	sprintf(disk->disk_name, "st%d", dev_num);
+	tpnt->index = error;
+	sprintf(disk->disk_name, "st%d", tpnt->index);
 
 	dev_set_drvdata(dev, tpnt);
 
@@ -4218,9 +4208,8 @@ static int st_probe(struct device *dev)
 
 out_remove_devs:
 	remove_cdevs(tpnt);
-out_put_index:
 	spin_lock(&st_index_lock);
-	idr_remove(&st_index_idr, dev_num);
+	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
 out_put_disk:
 	put_disk(disk);
-- 
1.8.1
