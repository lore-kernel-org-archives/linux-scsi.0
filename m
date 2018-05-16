From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/42] megaraid: simplify procfs code
Date: Wed, 16 May 2018 11:43:25 +0200
Message-ID: <20180516094346.20506-22-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use remove_proc_subtree to remove the whole subtree on cleanup, and
unwind the registration loop into individual calls.  Switch to use
proc_create_single.

Also don't bother handling proc_create* failures - the driver works
perfectly fine without the proc files, and the cleanup will handle
missing files gracefully.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid.c | 140 +++++++++++-----------------------------
 drivers/scsi/megaraid.h |  12 ----
 2 files changed, 36 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7195cff51d4c..91f5e2c68dbc 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2731,53 +2731,6 @@ proc_show_rdrv_40(struct seq_file *m, void *v)
 	return proc_show_rdrv(m, m->private, 30, 39);
 }
 
-
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int mega_proc_open(struct inode *inode, struct file *file)
-{
-	adapter_t *adapter = proc_get_parent_data(inode);
-	int (*show)(struct seq_file *, void *) = PDE_DATA(inode);
-
-	return single_open(file, show, adapter);
-}
-
-static const struct file_operations mega_proc_fops = {
-	.open		= mega_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-/*
- * Table of proc files we need to create.
- */
-struct mega_proc_file {
-	const char *name;
-	unsigned short ptr_offset;
-	int (*show) (struct seq_file *m, void *v);
-};
-
-static const struct mega_proc_file mega_proc_files[] = {
-	{ "config",	      offsetof(adapter_t, proc_read), proc_show_config },
-	{ "stat",	      offsetof(adapter_t, proc_stat), proc_show_stat },
-	{ "mailbox",	      offsetof(adapter_t, proc_mbox), proc_show_mbox },
-#if MEGA_HAVE_ENH_PROC
-	{ "rebuild-rate",     offsetof(adapter_t, proc_rr), proc_show_rebuild_rate },
-	{ "battery-status",   offsetof(adapter_t, proc_battery), proc_show_battery },
-	{ "diskdrives-ch0",   offsetof(adapter_t, proc_pdrvstat[0]), proc_show_pdrv_ch0 },
-	{ "diskdrives-ch1",   offsetof(adapter_t, proc_pdrvstat[1]), proc_show_pdrv_ch1 },
-	{ "diskdrives-ch2",   offsetof(adapter_t, proc_pdrvstat[2]), proc_show_pdrv_ch2 },
-	{ "diskdrives-ch3",   offsetof(adapter_t, proc_pdrvstat[3]), proc_show_pdrv_ch3 },
-	{ "raiddrives-0-9",   offsetof(adapter_t, proc_rdrvstat[0]), proc_show_rdrv_10 },
-	{ "raiddrives-10-19", offsetof(adapter_t, proc_rdrvstat[1]), proc_show_rdrv_20 },
-	{ "raiddrives-20-29", offsetof(adapter_t, proc_rdrvstat[2]), proc_show_rdrv_30 },
-	{ "raiddrives-30-39", offsetof(adapter_t, proc_rdrvstat[3]), proc_show_rdrv_40 },
-#endif
-	{ NULL }
-};
-
 /**
  * mega_create_proc_entry()
  * @index - index in soft state array
@@ -2788,31 +2741,45 @@ static const struct mega_proc_file mega_proc_files[] = {
 static void
 mega_create_proc_entry(int index, struct proc_dir_entry *parent)
 {
-	const struct mega_proc_file *f;
-	adapter_t	*adapter = hba_soft_state[index];
-	struct proc_dir_entry	*dir, *de, **ppde;
-	u8		string[16];
+	adapter_t *adapter = hba_soft_state[index];
+	struct proc_dir_entry *dir;
+	u8 string[16];
 
 	sprintf(string, "hba%d", adapter->host->host_no);
-
-	dir = adapter->controller_proc_dir_entry =
-		proc_mkdir_data(string, 0, parent, adapter);
-	if(!dir) {
+	dir = proc_mkdir_data(string, 0, parent, adapter);
+	if (!dir) {
 		dev_warn(&adapter->dev->dev, "proc_mkdir failed\n");
 		return;
 	}
 
-	for (f = mega_proc_files; f->name; f++) {
-		de = proc_create_data(f->name, S_IRUSR, dir, &mega_proc_fops,
-				      f->show);
-		if (!de) {
-			dev_warn(&adapter->dev->dev, "proc_create failed\n");
-			return;
-		}
-
-		ppde = (void *)adapter + f->ptr_offset;
-		*ppde = de;
-	}
+	proc_create_single_data("config", S_IRUSR, dir,
+			proc_show_config, adapter);
+	proc_create_single_data("stat", S_IRUSR, dir,
+			proc_show_stat, adapter);
+	proc_create_single_data("mailbox", S_IRUSR, dir,
+			proc_show_mbox, adapter);
+#if MEGA_HAVE_ENH_PROC
+	proc_create_single_data("rebuild-rate", S_IRUSR, dir,
+			proc_show_rebuild_rate, adapter);
+	proc_create_single_data("battery-status", S_IRUSR, dir,
+			proc_show_battery, adapter);
+	proc_create_single_data("diskdrives-ch0", S_IRUSR, dir,
+			proc_show_pdrv_ch0, adapter);
+	proc_create_single_data("diskdrives-ch1", S_IRUSR, dir,
+			proc_show_pdrv_ch1, adapter);
+	proc_create_single_data("diskdrives-ch2", S_IRUSR, dir,
+			proc_show_pdrv_ch2, adapter);
+	proc_create_single_data("diskdrives-ch3", S_IRUSR, dir,
+			proc_show_pdrv_ch3, adapter);
+	proc_create_single_data("raiddrives-0-9", S_IRUSR, dir,
+			proc_show_rdrv_10, adapter);
+	proc_create_single_data("raiddrives-10-19", S_IRUSR, dir,
+			proc_show_rdrv_20, adapter);
+	proc_create_single_data("raiddrives-20-29", S_IRUSR, dir,
+			proc_show_rdrv_30, adapter);
+	proc_create_single_data("raiddrives-30-39", S_IRUSR, dir,
+			proc_show_rdrv_40, adapter);
+#endif
 }
 
 #else
@@ -4580,6 +4547,7 @@ megaraid_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	adapter_t *adapter = (adapter_t *)host->hostdata;
+	char buf[12] = { 0 };
 
 	scsi_remove_host(host);
 
@@ -4594,44 +4562,8 @@ megaraid_remove_one(struct pci_dev *pdev)
 
 	mega_free_sgl(adapter);
 
-#ifdef CONFIG_PROC_FS
-	if (adapter->controller_proc_dir_entry) {
-		remove_proc_entry("stat", adapter->controller_proc_dir_entry);
-		remove_proc_entry("config",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("mailbox",
-				adapter->controller_proc_dir_entry);
-#if MEGA_HAVE_ENH_PROC
-		remove_proc_entry("rebuild-rate",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("battery-status",
-				adapter->controller_proc_dir_entry);
-
-		remove_proc_entry("diskdrives-ch0",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch1",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch2",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch3",
-				adapter->controller_proc_dir_entry);
-
-		remove_proc_entry("raiddrives-0-9",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-10-19",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-20-29",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-30-39",
-				adapter->controller_proc_dir_entry);
-#endif
-		{
-			char	buf[12] = { 0 };
-			sprintf(buf, "hba%d", adapter->host->host_no);
-			remove_proc_entry(buf, mega_proc_dir_entry);
-		}
-	}
-#endif
+	sprintf(buf, "hba%d", adapter->host->host_no);
+	remove_proc_subtree(buf, mega_proc_dir_entry);
 
 	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
 			adapter->mega_buffer, adapter->buf_dma_handle);
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 21eba2fd465a..18e85d9267ff 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -814,18 +814,6 @@ typedef struct {
 
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*controller_proc_dir_entry;
-	struct proc_dir_entry	*proc_read;
-	struct proc_dir_entry	*proc_stat;
-	struct proc_dir_entry	*proc_mbox;
-
-#if MEGA_HAVE_ENH_PROC
-	struct proc_dir_entry	*proc_rr;
-	struct proc_dir_entry	*proc_battery;
-#define MAX_PROC_CHANNELS	4
-	struct proc_dir_entry	*proc_pdrvstat[MAX_PROC_CHANNELS];
-	struct proc_dir_entry	*proc_rdrvstat[MAX_PROC_CHANNELS];
-#endif
-
 #endif
 
 	int	has_64bit_addr;		/* are we using 64-bit addressing */
-- 
2.17.0
