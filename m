From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 38/39] ide: replace ->proc_fops with ->proc_show
Date: Thu, 19 Apr 2018 14:41:39 +0200
Message-ID: <20180419124140.9309-39-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Just set up the show callback in the tty_operations, and use
proc_create_single_data to create the file without additional
boilerplace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-cd.c          |  15 +---
 drivers/ide/ide-disk_proc.c   |  62 ++--------------
 drivers/ide/ide-floppy_proc.c |  17 +----
 drivers/ide/ide-proc.c        | 136 +++++-----------------------------
 drivers/ide/ide-tape.c        |  17 +----
 include/linux/ide.h           |   6 +-
 6 files changed, 31 insertions(+), 222 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5a8e8e3c22cd..b52a7bdace52 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1426,21 +1426,8 @@ static int idecd_capacity_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int idecd_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idecd_capacity_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idecd_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idecd_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static ide_proc_entry_t idecd_proc[] = {
-	{ "capacity", S_IFREG|S_IRUGO, &idecd_capacity_proc_fops },
+	{ "capacity", S_IFREG|S_IRUGO, idecd_capacity_proc_show },
 	{}
 };
 
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 82a36ced4e96..95d239b2f646 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -52,19 +52,6 @@ static int idedisk_cache_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int idedisk_cache_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_cache_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idedisk_cache_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_cache_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int idedisk_capacity_proc_show(struct seq_file *m, void *v)
 {
 	ide_drive_t*drive = (ide_drive_t *)m->private;
@@ -73,19 +60,6 @@ static int idedisk_capacity_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int idedisk_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_capacity_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idedisk_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int __idedisk_proc_show(struct seq_file *m, ide_drive_t *drive, u8 sub_cmd)
 {
 	u8 *buf;
@@ -114,43 +88,17 @@ static int idedisk_sv_proc_show(struct seq_file *m, void *v)
 	return __idedisk_proc_show(m, m->private, ATA_SMART_READ_VALUES);
 }
 
-static int idedisk_sv_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_sv_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idedisk_sv_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_sv_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int idedisk_st_proc_show(struct seq_file *m, void *v)
 {
 	return __idedisk_proc_show(m, m->private, ATA_SMART_READ_THRESHOLDS);
 }
 
-static int idedisk_st_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_st_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idedisk_st_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_st_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 ide_proc_entry_t ide_disk_proc[] = {
-	{ "cache",	  S_IFREG|S_IRUGO, &idedisk_cache_proc_fops	},
-	{ "capacity",	  S_IFREG|S_IRUGO, &idedisk_capacity_proc_fops	},
-	{ "geometry",	  S_IFREG|S_IRUGO, &ide_geometry_proc_fops	},
-	{ "smart_values", S_IFREG|S_IRUSR, &idedisk_sv_proc_fops	},
-	{ "smart_thresholds", S_IFREG|S_IRUSR, &idedisk_st_proc_fops	},
+	{ "cache",	  S_IFREG|S_IRUGO, idedisk_cache_proc_show	},
+	{ "capacity",	  S_IFREG|S_IRUGO, idedisk_capacity_proc_show	},
+	{ "geometry",	  S_IFREG|S_IRUGO, ide_geometry_proc_show	},
+	{ "smart_values", S_IFREG|S_IRUSR, idedisk_sv_proc_show		},
+	{ "smart_thresholds", S_IFREG|S_IRUSR, idedisk_st_proc_show	},
 	{}
 };
 
diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
index 471457ebea67..7f697ddb5fe5 100644
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -14,22 +14,9 @@ static int idefloppy_capacity_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int idefloppy_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idefloppy_capacity_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idefloppy_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idefloppy_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 ide_proc_entry_t ide_floppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO, &idefloppy_capacity_proc_fops	},
-	{ "geometry",	S_IFREG|S_IRUGO, &ide_geometry_proc_fops	},
+	{ "capacity",	S_IFREG|S_IRUGO, idefloppy_capacity_proc_show	},
+	{ "geometry",	S_IFREG|S_IRUGO, ide_geometry_proc_show		},
 	{}
 };
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index b3b8b8822d6a..45c997430332 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -56,19 +56,6 @@ static int ide_imodel_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ide_imodel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_imodel_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_imodel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_imodel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ide_mate_proc_show(struct seq_file *m, void *v)
 {
 	ide_hwif_t	*hwif = (ide_hwif_t *) m->private;
@@ -80,19 +67,6 @@ static int ide_mate_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ide_mate_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_mate_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_mate_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_mate_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ide_channel_proc_show(struct seq_file *m, void *v)
 {
 	ide_hwif_t	*hwif = (ide_hwif_t *) m->private;
@@ -101,19 +75,6 @@ static int ide_channel_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ide_channel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_channel_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_channel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_channel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ide_identify_proc_show(struct seq_file *m, void *v)
 {
 	ide_drive_t *drive = (ide_drive_t *)m->private;
@@ -141,19 +102,6 @@ static int ide_identify_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ide_identify_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_identify_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_identify_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_identify_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /**
  *	ide_find_setting	-	find a specific setting
  *	@st: setting table pointer
@@ -441,27 +389,14 @@ static const struct file_operations ide_settings_proc_fops = {
 	.write		= ide_settings_proc_write,
 };
 
-static int ide_capacity_proc_show(struct seq_file *m, void *v)
+int ide_capacity_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, "%llu\n", (long long)0x7fffffff);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ide_capacity_proc_show);
 
-static int ide_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_capacity_proc_show, NULL);
-}
-
-const struct file_operations ide_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-EXPORT_SYMBOL_GPL(ide_capacity_proc_fops);
-
-static int ide_geometry_proc_show(struct seq_file *m, void *v)
+int ide_geometry_proc_show(struct seq_file *m, void *v)
 {
 	ide_drive_t	*drive = (ide_drive_t *) m->private;
 
@@ -471,20 +406,7 @@ static int ide_geometry_proc_show(struct seq_file *m, void *v)
 			drive->bios_cyl, drive->bios_head, drive->bios_sect);
 	return 0;
 }
-
-static int ide_geometry_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_geometry_proc_show, PDE_DATA(inode));
-}
-
-const struct file_operations ide_geometry_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_geometry_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-EXPORT_SYMBOL(ide_geometry_proc_fops);
+EXPORT_SYMBOL(ide_geometry_proc_show);
 
 static int ide_dmodel_proc_show(struct seq_file *seq, void *v)
 {
@@ -495,19 +417,6 @@ static int ide_dmodel_proc_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int ide_dmodel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_dmodel_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_dmodel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_dmodel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ide_driver_proc_show(struct seq_file *m, void *v)
 {
 	ide_drive_t		*drive = (ide_drive_t *)m->private;
@@ -523,19 +432,6 @@ static int ide_driver_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int ide_driver_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_driver_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations ide_driver_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_driver_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int ide_media_proc_show(struct seq_file *m, void *v)
 {
 	ide_drive_t	*drive = (ide_drive_t *) m->private;
@@ -567,11 +463,10 @@ static const struct file_operations ide_media_proc_fops = {
 };
 
 static ide_proc_entry_t generic_drive_entries[] = {
-	{ "driver",	S_IFREG|S_IRUGO,	 &ide_driver_proc_fops	},
-	{ "identify",	S_IFREG|S_IRUSR,	 &ide_identify_proc_fops},
-	{ "media",	S_IFREG|S_IRUGO,	 &ide_media_proc_fops	},
-	{ "model",	S_IFREG|S_IRUGO,	 &ide_dmodel_proc_fops	},
-	{ "settings",	S_IFREG|S_IRUSR|S_IWUSR, &ide_settings_proc_fops},
+	{ "driver",	S_IFREG|S_IRUGO,	 ide_driver_proc_show	},
+	{ "identify",	S_IFREG|S_IRUSR,	 ide_identify_proc_show	},
+	{ "media",	S_IFREG|S_IRUGO,	 ide_media_proc_show	},
+	{ "model",	S_IFREG|S_IRUGO,	 ide_dmodel_proc_show	},
 	{}
 };
 
@@ -582,7 +477,7 @@ static void ide_add_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p
 	if (!dir || !p)
 		return;
 	while (p->name != NULL) {
-		ent = proc_create_data(p->name, p->mode, dir, p->proc_fops, data);
+		ent = proc_create_single_data(p->name, p->mode, dir, p->show, data);
 		if (!ent) return;
 		p++;
 	}
@@ -647,8 +542,12 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
-		if (drive->proc)
+		if (drive->proc) {
 			ide_add_proc_entries(drive->proc, generic_drive_entries, drive);
+			proc_create_data("setting", S_IFREG|S_IRUSR|S_IWUSR,
+					drive->proc, &ide_settings_proc_fops,
+					drive);
+		}
 		sprintf(name, "ide%d/%s", (drive->name[2]-'a')/2, drive->name);
 		ent = proc_symlink(drive->name, proc_ide_root, name);
 		if (!ent) return;
@@ -658,6 +557,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 void ide_proc_unregister_device(ide_drive_t *drive)
 {
 	if (drive->proc) {
+		remove_proc_entry("settings", drive->proc);
 		ide_remove_proc_entries(drive->proc, generic_drive_entries);
 		remove_proc_entry(drive->name, proc_ide_root);
 		remove_proc_entry(drive->name, drive->hwif->proc);
@@ -666,9 +566,9 @@ void ide_proc_unregister_device(ide_drive_t *drive)
 }
 
 static ide_proc_entry_t hwif_entries[] = {
-	{ "channel",	S_IFREG|S_IRUGO,	&ide_channel_proc_fops	},
-	{ "mate",	S_IFREG|S_IRUGO,	&ide_mate_proc_fops	},
-	{ "model",	S_IFREG|S_IRUGO,	&ide_imodel_proc_fops	},
+	{ "channel",	S_IFREG|S_IRUGO,	ide_channel_proc_show	},
+	{ "mate",	S_IFREG|S_IRUGO,	ide_mate_proc_show	},
+	{ "model",	S_IFREG|S_IRUGO,	ide_imodel_proc_show	},
 	{}
 };
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index fd57e8ccc47a..ac2c6820c65a 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1847,22 +1847,9 @@ static int idetape_name_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int idetape_name_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idetape_name_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations idetape_name_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idetape_name_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static ide_proc_entry_t idetape_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO,	&ide_capacity_proc_fops	},
-	{ "name",	S_IFREG|S_IRUGO,	&idetape_name_proc_fops	},
+	{ "capacity",	S_IFREG|S_IRUGO,	ide_capacity_proc_show	},
+	{ "name",	S_IFREG|S_IRUGO,	idetape_name_proc_show	},
 	{}
 };
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ca9d34feb572..752464f5a772 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -961,7 +961,7 @@ __IDE_PROC_DEVSET(_name, _min, _max, NULL, NULL)
 typedef struct {
 	const char	*name;
 	umode_t		mode;
-	const struct file_operations *proc_fops;
+	int (*show)(struct seq_file *, void *);
 } ide_proc_entry_t;
 
 void proc_ide_create(void);
@@ -973,8 +973,8 @@ void ide_proc_unregister_port(ide_hwif_t *);
 void ide_proc_register_driver(ide_drive_t *, struct ide_driver *);
 void ide_proc_unregister_driver(ide_drive_t *, struct ide_driver *);
 
-extern const struct file_operations ide_capacity_proc_fops;
-extern const struct file_operations ide_geometry_proc_fops;
+int ide_capacity_proc_show(struct seq_file *m, void *v);
+int ide_geometry_proc_show(struct seq_file *m, void *v);
 #else
 static inline void proc_ide_create(void) { ; }
 static inline void proc_ide_destroy(void) { ; }
-- 
2.17.0
