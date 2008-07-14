From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/13] block: implement and use {disk|part}_to_dev()
Date: Mon, 14 Jul 2008 16:48:01 +0900
Message-ID: <1216021693-483-2-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Implement and use {disk|part}_to_dev() and use them to access generic
device instead of directly dereferencing {disk|part}->dev.  To make
sure no user is left behind, rename generic devices fields to __dev.

This is in preparation of unifying partition 0 handling with other
partitions.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-sysfs.c          |    4 +-
 block/genhd.c              |   32 +++++++++---------
 drivers/block/aoe/aoeblk.c |    4 +-
 drivers/block/nbd.c        |    4 +-
 drivers/ide/ide-probe.c    |    2 +-
 drivers/md/dm.c            |    4 +-
 drivers/md/md.c            |   10 +++---
 fs/block_dev.c             |    4 +-
 fs/partitions/check.c      |   75 +++++++++++++++++++++++---------------------
 include/linux/genhd.h      |   20 ++++++-----
 10 files changed, 82 insertions(+), 77 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 304ec73..b9a6ed1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -310,7 +310,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (!q->request_fn)
 		return 0;
 
-	ret = kobject_add(&q->kobj, kobject_get(&disk->dev.kobj),
+	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
 			  "%s", "queue");
 	if (ret < 0)
 		return ret;
@@ -339,6 +339,6 @@ void blk_unregister_queue(struct gendisk *disk)
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
-		kobject_put(&disk->dev.kobj);
+		kobject_put(&disk_to_dev(disk)->kobj);
 	}
 }
diff --git a/block/genhd.c b/block/genhd.c
index e2deec2..c54f694 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -59,7 +59,7 @@ struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
 	rcu_read_lock();
 	part = rcu_dereference(disk->__part[partno - 1]);
 	if (part)
-		get_device(&part->dev);
+		get_device(part_to_dev(part));
 	rcu_read_unlock();
 
 	return part;
@@ -130,7 +130,7 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
 			continue;
 
-		get_device(&part->dev);
+		get_device(part_to_dev(part));
 		piter->part = part;
 		piter->idx++;
 		break;
@@ -434,7 +434,7 @@ static struct kobject *exact_match(dev_t devt, int *partno, void *data)
 {
 	struct gendisk *p = data;
 
-	return &p->dev.kobj;
+	return &disk_to_dev(p)->kobj;
 }
 
 static int exact_lock(dev_t devt, void *data)
@@ -458,7 +458,7 @@ void add_disk(struct gendisk *disk)
 	struct backing_dev_info *bdi;
 
 	disk->flags |= GENHD_FL_UP;
-	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
+	disk_to_dev(disk)->devt = MKDEV(disk->major, disk->first_minor);
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
@@ -466,7 +466,7 @@ void add_disk(struct gendisk *disk)
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));
-	sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
+	sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj, "bdi");
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -474,7 +474,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partitions/check.c */
 
 void unlink_gendisk(struct gendisk *disk)
 {
-	sysfs_remove_link(&disk->dev.kobj, "bdi");
+	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
@@ -623,7 +623,7 @@ static void *part_next(struct seq_file *seqf, void *v, loff_t *pos)
 	struct gendisk *gp = v;
 	struct device *dev;
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
+	list_for_each_entry(dev, &disk_to_dev(gp)->node, node) {
 		if (&dev->node == &block_class.devices)
 			return NULL;
 		if (dev->type == &disk_type)
@@ -644,7 +644,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	struct hd_struct *part;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->dev.node == block_class.devices.next)
+	if (&disk_to_dev(sgp)->node == block_class.devices.next)
 		seq_puts(seqf, "major   minor   #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
@@ -881,7 +881,7 @@ static void *diskstats_next(struct seq_file *seqf, void *v, loff_t *pos)
 	struct device *dev;
 
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
+	list_for_each_entry(dev, &disk_to_dev(gp)->node, node) {
 		if (&dev->node == &block_class.devices)
 			return NULL;
 		if (dev->type == &disk_type)
@@ -903,7 +903,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	/*
-	if (&gp->dev.kobj.entry == block_class.devices.next)
+	if (&disk_to_dev(gp)->kobj.entry == block_class.devices.next)
 		seq_puts(seqf,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
@@ -971,7 +971,7 @@ static void media_change_notify_thread(struct work_struct *work)
 	 * set enviroment vars to indicate which event this is for
 	 * so that user space will know to go check the media status.
 	 */
-	kobject_uevent_env(&gd->dev.kobj, KOBJ_CHANGE, envp);
+	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
 	put_device(gd->driverfs_dev);
 }
 
@@ -1063,9 +1063,9 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		disk->minors = minors;
 		disk->ext_minors = ext_minors;
 		rand_initialize_disk(disk);
-		disk->dev.class = &block_class;
-		disk->dev.type = &disk_type;
-		device_initialize(&disk->dev);
+		disk_to_dev(disk)->class = &block_class;
+		disk_to_dev(disk)->type = &disk_type;
+		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
 	}
@@ -1087,7 +1087,7 @@ struct kobject *get_disk(struct gendisk *disk)
 	owner = disk->fops->owner;
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj = kobject_get(&disk->dev.kobj);
+	kobj = kobject_get(&disk_to_dev(disk)->kobj);
 	if (kobj == NULL) {
 		module_put(owner);
 		return NULL;
@@ -1101,7 +1101,7 @@ EXPORT_SYMBOL(get_disk);
 void put_disk(struct gendisk *disk)
 {
 	if (disk)
-		kobject_put(&disk->dev.kobj);
+		kobject_put(&disk_to_dev(disk)->kobj);
 }
 
 EXPORT_SYMBOL(put_disk);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 0c39782..3edb6cb 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -109,12 +109,12 @@ static const struct attribute_group attr_group = {
 static int
 aoedisk_add_sysfs(struct aoedev *d)
 {
-	return sysfs_create_group(&d->gd->dev.kobj, &attr_group);
+	return sysfs_create_group(&disk_to_dev(d->gd)->kobj, &attr_group);
 }
 void
 aoedisk_rm_sysfs(struct aoedev *d)
 {
-	sysfs_remove_group(&d->gd->dev.kobj, &attr_group);
+	sysfs_remove_group(&disk_to_dev(d->gd)->kobj, &attr_group);
 }
 
 static int
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ad98dda..00337c8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -403,7 +403,7 @@ static int nbd_do_it(struct nbd_device *lo)
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	ret = sysfs_create_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
 		return ret;
@@ -412,7 +412,7 @@ static int nbd_do_it(struct nbd_device *lo)
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 26e68b6..2e020de 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1133,7 +1133,7 @@ static struct kobject *exact_match(dev_t dev, int *part, void *data)
 {
 	struct gendisk *p = data;
 	*part &= (1 << PARTN_BITS) - 1;
-	return &p->dev.kobj;
+	return &disk_to_dev(p)->kobj;
 }
 
 static int exact_lock(dev_t dev, void *data)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f76fb06..47d92be 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1136,7 +1136,7 @@ static void event_callback(void *context)
 	list_splice_init(&md->uevent_list, &uevents);
 	spin_unlock_irqrestore(&md->uevent_lock, flags);
 
-	dm_send_uevents(&uevents, &md->disk->dev.kobj);
+	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
@@ -1593,7 +1593,7 @@ out:
  *---------------------------------------------------------------*/
 void dm_kobject_uevent(struct mapped_device *md)
 {
-	kobject_uevent(&md->disk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&disk_to_dev(md->disk)->kobj, KOBJ_CHANGE);
 }
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2580ac1..4d6ef34 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1416,9 +1416,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 		goto fail;
 
 	if (rdev->bdev->bd_part)
-		ko = &rdev->bdev->bd_part->dev.kobj;
+		ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
 	else
-		ko = &rdev->bdev->bd_disk->dev.kobj;
+		ko = &disk_to_dev(rdev->bdev->bd_disk)->kobj;
 	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
 		kobject_del(&rdev->kobj);
 		goto fail;
@@ -3327,8 +3327,8 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	add_disk(disk);
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
-	error = kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->dev.kobj,
-				     "%s", "md");
+	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
+				     &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error)
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);
@@ -3608,7 +3608,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
-	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5d38203..5f177bd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -543,9 +543,9 @@ EXPORT_SYMBOL(bd_release);
 static struct kobject *bdev_get_kobj(struct block_device *bdev)
 {
 	if (bdev->bd_contains != bdev)
-		return kobject_get(&bdev->bd_part->dev.kobj);
+		return kobject_get(&part_to_dev(bdev->bd_part)->kobj);
 	else
-		return kobject_get(&bdev->bd_disk->dev.kobj);
+		return kobject_get(&disk_to_dev(bdev->bd_disk)->kobj);
 }
 
 static struct kobject *bdev_get_holder(struct block_device *bdev)
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 78be967..d12ac7d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -308,7 +308,7 @@ static inline void partition_sysfs_add_subdir(struct hd_struct *p)
 {
 	struct kobject *k;
 
-	k = kobject_get(&p->dev.kobj);
+	k = kobject_get(&part_to_dev(p)->kobj);
 	p->holder_dir = kobject_create_and_add("holders", k);
 	kobject_put(k);
 }
@@ -317,7 +317,7 @@ static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 {
 	struct kobject *k;
 
-	k = kobject_get(&disk->dev.kobj);
+	k = kobject_get(&disk_to_dev(disk)->kobj);
 	disk->holder_dir = kobject_create_and_add("holders", k);
 	disk->slave_dir = kobject_create_and_add("slaves", k);
 	kobject_put(k);
@@ -330,7 +330,7 @@ static void delete_partition_rcu_cb(struct rcu_head *head)
 	part->start_sect = 0;
 	part->nr_sects = 0;
 	part_stat_set_all(part, 0);
-	put_device(&part->dev);
+	put_device(part_to_dev(part));
 }
 
 
@@ -345,7 +345,7 @@ void delete_partition(struct gendisk *disk, int partno)
 	blk_free_devt(part_devt(part));
 	rcu_assign_pointer(disk->__part[partno-1], NULL);
 	kobject_put(part->holder_dir);
-	device_del(&part->dev);
+	device_del(part_to_dev(part));
 
 	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
 }
@@ -363,6 +363,9 @@ int add_partition(struct gendisk *disk, int partno,
 {
 	struct hd_struct *p = NULL;
 	dev_t devt = MKDEV(0, 0);
+	struct device *ddev = disk_to_dev(disk);
+	struct device *pdev;
+	const char *dname;
 	int err;
 
 	if (disk->__part[partno - 1]) {
@@ -376,49 +379,48 @@ int add_partition(struct gendisk *disk, int partno,
 		goto fail;
 	if (!init_part_stats(p))
 		goto fail;
+	pdev = part_to_dev(p);
 
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = disk->policy;
 
-	if (isdigit(disk->dev.bus_id[strlen(disk->dev.bus_id)-1]))
-		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-		"%sp%d", disk->dev.bus_id, partno);
+	dname = dev_name(ddev);
+	if (isdigit(dname[strlen(dname) - 1]))
+		snprintf(pdev->bus_id, BUS_ID_SIZE, "%sp%d", dname, partno);
 	else
-		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-			 "%s%d", disk->dev.bus_id, partno);
+		snprintf(pdev->bus_id, BUS_ID_SIZE, "%s%d", dname, partno);
 
-	device_initialize(&p->dev);
-	p->dev.class = &block_class;
-	p->dev.type = &part_type;
-	p->dev.parent = &disk->dev;
+	device_initialize(pdev);
+	pdev->class = &block_class;
+	pdev->type = &part_type;
+	pdev->parent = ddev;
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
 		goto fail;
-	p->dev.devt = devt;
+	pdev->devt = devt;
 
 	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(disk->__part[partno-1], p);
 
 	/* delay uevent until 'holders' subdir is created */
-	p->dev.uevent_suppress = 1;
-	err = device_add(&p->dev);
+	pdev->uevent_suppress = 1;
+	err = device_add(pdev);
 	if (err)
 		goto fail;
 
 	partition_sysfs_add_subdir(p);
-	p->dev.uevent_suppress = 0;
+	pdev->uevent_suppress = 0;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
-		err = device_create_file(&p->dev, &dev_attr_whole_disk);
-		printk(" %s: failed to create sysfs attrs (%d)\n",
-		       dev_name(&p->dev), err);
+		err = device_create_file(pdev, &dev_attr_whole_disk);
+		printk(" %s: failed to create sysfs attrs (%d)\n", dname, err);
 	}
 
 	/* suppress uevent if the disk supresses it */
-	if (!disk->dev.uevent_suppress)
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+	if (!ddev->uevent_suppress)
+		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return 0;
 
@@ -433,30 +435,31 @@ int add_partition(struct gendisk *disk, int partno,
 /* Not exported, helper to add_disk(). */
 void register_disk(struct gendisk *disk)
 {
+	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 	char *s;
 	int err;
 
-	disk->dev.parent = disk->driverfs_dev;
+	ddev->parent = disk->driverfs_dev;
 
-	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
+	strlcpy(ddev->bus_id, disk->disk_name, KOBJ_NAME_LEN);
 	/* ewww... some of these buggers have / in the name... */
-	s = strchr(disk->dev.bus_id, '/');
+	s = strchr(ddev->bus_id, '/');
 	if (s)
 		*s = '!';
 
 	/* delay uevents, until we scanned partition table */
-	disk->dev.uevent_suppress = 1;
+	ddev->uevent_suppress = 1;
 
-	if (device_add(&disk->dev))
+	if (device_add(ddev))
 		return;
 #ifndef CONFIG_SYSFS_DEPRECATED
-	err = sysfs_create_link(block_depr, &disk->dev.kobj,
-				kobject_name(&disk->dev.kobj));
+	err = sysfs_create_link(block_depr, &ddev->kobj,
+				kobject_name(&ddev->kobj));
 	if (err) {
-		device_del(&disk->dev);
+		device_del(ddev);
 		return;
 	}
 #endif
@@ -482,13 +485,13 @@ void register_disk(struct gendisk *disk)
 
 exit:
 	/* announce disk after possible partitions are created */
-	disk->dev.uevent_suppress = 0;
-	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);
+	ddev->uevent_suppress = 0;
+	kobject_uevent(&ddev->kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
 	disk_part_iter_start(&piter, disk, 0);
 	while ((part = disk_part_iter_next(&piter)))
-		kobject_uevent(&part->dev.kobj, KOBJ_ADD);
+		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_stop(&piter);
 }
 
@@ -519,7 +522,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		return -EIO;
 
 	/* tell userspace that the media / partition table may have changed */
-	kobject_uevent(&disk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
@@ -589,7 +592,7 @@ void del_gendisk(struct gendisk *disk)
 	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
 #ifndef CONFIG_SYSFS_DEPRECATED
-	sysfs_remove_link(block_depr, disk->dev.bus_id);
+	sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 #endif
-	device_del(&disk->dev);
+	device_del(disk_to_dev(disk));
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index cb6d9a7..96d7ac5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -15,9 +15,11 @@
 
 #ifdef CONFIG_BLOCK
 
-#define kobj_to_dev(k) container_of(k, struct device, kobj)
-#define dev_to_disk(device) container_of(device, struct gendisk, dev)
-#define dev_to_part(device) container_of(device, struct hd_struct, dev)
+#define kobj_to_dev(k)		container_of((k), struct device, kobj)
+#define dev_to_disk(device)	container_of((device), struct gendisk, __dev)
+#define dev_to_part(device)	container_of((device), struct hd_struct, __dev)
+#define disk_to_dev(disk)	(&((disk)->__dev))
+#define part_to_dev(part)	(&((part)->__dev))
 
 extern struct device_type part_type;
 extern struct kobject *block_depr;
@@ -88,7 +90,7 @@ struct disk_stats {
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
-	struct device dev;
+	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -140,7 +142,7 @@ struct gendisk {
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
-	struct device dev;
+	struct device __dev;
 	struct kobject *holder_dir;
 	struct kobject *slave_dir;
 
@@ -161,7 +163,7 @@ struct gendisk {
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
 {
 	if (likely(part))
-		return dev_to_disk((part)->dev.parent);
+		return dev_to_disk(part_to_dev(part)->parent);
 	return NULL;
 }
 
@@ -172,12 +174,12 @@ static inline int disk_max_parts(struct gendisk *disk)
 
 static inline dev_t disk_devt(struct gendisk *disk)
 {
-	return disk->dev.devt;
+	return disk_to_dev(disk)->devt;
 }
 
 static inline dev_t part_devt(struct hd_struct *part)
 {
-	return part->dev.devt;
+	return part_to_dev(part)->devt;
 }
 
 extern struct hd_struct *disk_get_part(struct gendisk *disk, int partno);
@@ -185,7 +187,7 @@ extern struct hd_struct *disk_get_part(struct gendisk *disk, int partno);
 static inline void disk_put_part(struct hd_struct *part)
 {
 	if (likely(part))
-		put_device(&part->dev);
+		put_device(part_to_dev(part));
 }
 
 /*
-- 
1.5.4.5

