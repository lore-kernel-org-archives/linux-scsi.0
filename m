From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/40] acpi/battery: simplify procfs code
Date: Wed, 25 Apr 2018 17:48:04 +0200
Message-ID: <20180425154827.32251-18-hch@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-1-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Use remove_proc_subtree to remove the whole subtree on cleanup, and
unwind the registration loop into individual calls.  Switch to use
proc_create_seq where applicable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/battery.c | 121 +++++++++--------------------------------
 1 file changed, 26 insertions(+), 95 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index bdb24d636d9a..76550689ce10 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -81,14 +81,6 @@ MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 #ifdef CONFIG_ACPI_PROCFS_POWER
 extern struct proc_dir_entry *acpi_lock_battery_dir(void);
 extern void *acpi_unlock_battery_dir(struct proc_dir_entry *acpi_battery_dir);
-
-enum acpi_battery_files {
-	info_tag = 0,
-	state_tag,
-	alarm_tag,
-	ACPI_BATTERY_NUMFILES,
-};
-
 #endif
 
 static const struct acpi_device_id battery_device_ids[] = {
@@ -985,9 +977,10 @@ static const char *acpi_battery_units(const struct acpi_battery *battery)
 		"mA" : "mW";
 }
 
-static int acpi_battery_print_info(struct seq_file *seq, int result)
+static int acpi_battery_info_proc_show(struct seq_file *seq, void *offset)
 {
 	struct acpi_battery *battery = seq->private;
+	int result = acpi_battery_update(battery, false);
 
 	if (result)
 		goto end;
@@ -1041,9 +1034,10 @@ static int acpi_battery_print_info(struct seq_file *seq, int result)
 	return result;
 }
 
-static int acpi_battery_print_state(struct seq_file *seq, int result)
+static int acpi_battery_state_proc_show(struct seq_file *seq, void *offset)
 {
 	struct acpi_battery *battery = seq->private;
+	int result = acpi_battery_update(battery, false);
 
 	if (result)
 		goto end;
@@ -1088,9 +1082,10 @@ static int acpi_battery_print_state(struct seq_file *seq, int result)
 	return result;
 }
 
-static int acpi_battery_print_alarm(struct seq_file *seq, int result)
+static int acpi_battery_alarm_proc_show(struct seq_file *seq, void *offset)
 {
 	struct acpi_battery *battery = seq->private;
+	int result = acpi_battery_update(battery, false);
 
 	if (result)
 		goto end;
@@ -1142,82 +1137,22 @@ static ssize_t acpi_battery_write_alarm(struct file *file,
 	return result;
 }
 
-typedef int(*print_func)(struct seq_file *seq, int result);
-
-static print_func acpi_print_funcs[ACPI_BATTERY_NUMFILES] = {
-	acpi_battery_print_info,
-	acpi_battery_print_state,
-	acpi_battery_print_alarm,
-};
-
-static int acpi_battery_read(int fid, struct seq_file *seq)
+static int acpi_battery_alarm_proc_open(struct inode *inode, struct file *file)
 {
-	struct acpi_battery *battery = seq->private;
-	int result = acpi_battery_update(battery, false);
-	return acpi_print_funcs[fid](seq, result);
+	return single_open(file, acpi_battery_alarm_proc_show, PDE_DATA(inode));
 }
 
-#define DECLARE_FILE_FUNCTIONS(_name) \
-static int acpi_battery_read_##_name(struct seq_file *seq, void *offset) \
-{ \
-	return acpi_battery_read(_name##_tag, seq); \
-} \
-static int acpi_battery_##_name##_open_fs(struct inode *inode, struct file *file) \
-{ \
-	return single_open(file, acpi_battery_read_##_name, PDE_DATA(inode)); \
-}
-
-DECLARE_FILE_FUNCTIONS(info);
-DECLARE_FILE_FUNCTIONS(state);
-DECLARE_FILE_FUNCTIONS(alarm);
-
-#undef DECLARE_FILE_FUNCTIONS
-
-#define FILE_DESCRIPTION_RO(_name) \
-	{ \
-	.name = __stringify(_name), \
-	.mode = S_IRUGO, \
-	.ops = { \
-		.open = acpi_battery_##_name##_open_fs, \
-		.read = seq_read, \
-		.llseek = seq_lseek, \
-		.release = single_release, \
-		.owner = THIS_MODULE, \
-		}, \
-	}
-
-#define FILE_DESCRIPTION_RW(_name) \
-	{ \
-	.name = __stringify(_name), \
-	.mode = S_IFREG | S_IRUGO | S_IWUSR, \
-	.ops = { \
-		.open = acpi_battery_##_name##_open_fs, \
-		.read = seq_read, \
-		.llseek = seq_lseek, \
-		.write = acpi_battery_write_##_name, \
-		.release = single_release, \
-		.owner = THIS_MODULE, \
-		}, \
-	}
-
-static const struct battery_file {
-	struct file_operations ops;
-	umode_t mode;
-	const char *name;
-} acpi_battery_file[] = {
-	FILE_DESCRIPTION_RO(info),
-	FILE_DESCRIPTION_RO(state),
-	FILE_DESCRIPTION_RW(alarm),
+static const struct file_operations acpi_battery_alarm_fops = {
+	.owner		= THIS_MODULE,
+	.open		= acpi_battery_alarm_proc_open,
+	.read		= seq_read,
+	.write		= acpi_battery_write_alarm,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
 
-#undef FILE_DESCRIPTION_RO
-#undef FILE_DESCRIPTION_RW
-
 static int acpi_battery_add_fs(struct acpi_device *device)
 {
-	struct proc_dir_entry *entry = NULL;
-	int i;
-
 	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for battery is loaded,"
 			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
 	if (!acpi_device_dir(device)) {
@@ -1227,28 +1162,24 @@ static int acpi_battery_add_fs(struct acpi_device *device)
 			return -ENODEV;
 	}
 
-	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i) {
-		entry = proc_create_data(acpi_battery_file[i].name,
-					 acpi_battery_file[i].mode,
-					 acpi_device_dir(device),
-					 &acpi_battery_file[i].ops,
-					 acpi_driver_data(device));
-		if (!entry)
-			return -ENODEV;
-	}
+	if (!proc_create_single_data("info", S_IRUGO, acpi_device_dir(device),
+			acpi_battery_info_proc_show, acpi_driver_data(device)))
+		return -ENODEV;
+	if (!proc_create_single_data("state", S_IRUGO, acpi_device_dir(device),
+			acpi_battery_state_proc_show, acpi_driver_data(device)))
+		return -ENODEV;
+	if (!proc_create_data("alarm", S_IFREG | S_IRUGO | S_IWUSR,
+			acpi_device_dir(device), &acpi_battery_alarm_fops,
+			acpi_driver_data(device)))
+		return -ENODEV;
 	return 0;
 }
 
 static void acpi_battery_remove_fs(struct acpi_device *device)
 {
-	int i;
 	if (!acpi_device_dir(device))
 		return;
-	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i)
-		remove_proc_entry(acpi_battery_file[i].name,
-				  acpi_device_dir(device));
-
-	remove_proc_entry(acpi_device_bid(device), acpi_battery_dir);
+	remove_proc_subtree(acpi_device_bid(device), acpi_battery_dir);
 	acpi_device_dir(device) = NULL;
 }
 
-- 
2.17.0
