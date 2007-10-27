From: Rob Landley <rob@landley.net>
Subject: [PATCH 9/15] Update kerneldoc comments in drivers/scsi/scsi_proc.c
Date: Fri, 26 Oct 2007 23:13:28 -0500
Message-ID: <200710262313.28715.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35980
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753956AbXJ0DNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:13:44 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 322F473938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:16:28 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_proc.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_proc.c |  110 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 2 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_proc.c	Fri Oct 26 22:44:42 2007 -0500
@@ -45,6 +45,16 @@ static struct proc_dir_entry *proc_scsi;
 /* Protect sht->present and sht->proc_dir */
 static DEFINE_MUTEX(global_host_template_mutex);
 
+/**
+ * proc_scsi_read - handle read from /proc by calling host's proc_info() command
+ * @buffer: passed to proc_info
+ * @start: passed to proc_info
+ * @offset: passed to proc_info
+ * @length: passed to proc_info
+ * @eof: returns whether length read was less than requested
+ * @data: pointer to a &struct Scsi_Host
+ */
+
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
 {
@@ -57,6 +67,13 @@ static int proc_scsi_read(char *buffer, 
 	return n;
 }
 
+/**
+ * proc_scsi_write_proc - Handle write to /proc by calling host's proc_info()
+ * @file: not used
+ * @buf: source of data to write.
+ * @count: number of bytes (at most PROC_BLOCK_SIZE) to write.
+ * @data: pointer to &struct Scsi_Host
+ */
 static int proc_scsi_write_proc(struct file *file, const char __user *buf,
                            unsigned long count, void *data)
 {
@@ -79,6 +96,13 @@ out:
 	free_page((unsigned long)page);
 	return ret;
 }
+
+/**
+ * scsi_proc_hostdir_add - Create directory in /proc for a scsi host
+ * @sht: owner of this directory
+ *
+ * Sets sht->proc_dir to the new directory.
+ */
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
@@ -97,6 +121,10 @@ void scsi_proc_hostdir_add(struct scsi_h
 	mutex_unlock(&global_host_template_mutex);
 }
 
+/**
+ * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
+ * @sht: owner of directory
+ */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
 	if (!sht->proc_info)
@@ -110,6 +138,11 @@ void scsi_proc_hostdir_rm(struct scsi_ho
 	mutex_unlock(&global_host_template_mutex);
 }
 
+
+/**
+ * scsi_proc_host_add - Add entry for this host to appropriate /proc dir
+ * @shost: host to add
+ */
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
 	struct scsi_host_template *sht = shost->hostt;
@@ -133,6 +166,10 @@ void scsi_proc_host_add(struct Scsi_Host
 	p->owner = sht->module;
 }
 
+/**
+ * scsi_proc_host_rm - remove this host's entry from /proc
+ * @shost: which host
+ */
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	char name[10];
@@ -143,7 +180,14 @@ void scsi_proc_host_rm(struct Scsi_Host 
 	sprintf(name,"%d", shost->host_no);
 	remove_proc_entry(name, shost->hostt->proc_dir);
 }
-
+/**
+ * proc_print_scsidevice - return data about this host
+ * @dev: A scsi device
+ * @data: &struct seq_file to output to.
+ *
+ * Description: prints Host, Channel, Id, Lun, Vendor, Model, Rev, Type,
+ * and revision.
+ */
 static int proc_print_scsidevice(struct device *dev, void *data)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -189,6 +233,21 @@ static int proc_print_scsidevice(struct 
 	return 0;
 }
 
+/**
+ * scsi_add_single_device - Respond to user request to probe for/add device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi add-single-device" to /proc/scsi/scsi.
+ *
+ * does scsi_host_lookup() and either user_scan() if that transport
+ * type supports it, or else scsi_scan_host_selected()
+ *
+ * Note: this seems to be aimed exclusively at SCSI parallel busses.
+ */
+
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct Scsi_Host *shost;
@@ -206,6 +265,16 @@ static int scsi_add_single_device(uint h
 	return error;
 }
 
+/**
+ * scsi_remove_single_device - Respond to user request to remove a device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi remove-single-device" to
+ * /proc/scsi/scsi.  Does a scsi_device_lookup() and scsi_remove_device()
+ */
 static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev;
@@ -226,6 +295,25 @@ static int scsi_remove_single_device(uin
 	return error;
 }
 
+/**
+ * proc_scsi_write - handle writes to /proc/scsi/scsi
+ * @file: not used
+ * @buf: buffer to write
+ * @length: length of buf, at most PAGE_SIZE
+ * @ppos: not used
+ *
+ * Description: this provides a legacy mechanism to add or remove devices by
+ * Host, Channel, ID, and Lun.  To use,
+ * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
+ * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
+ * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
+ *
+ * Note: this seems to be aimed at parallel SCSI. Most modern busses (USB,
+ * SATA, Firewire, Fibre Channel, etc) dynamically assign these values to
+ * provide a unique identifier and nothing more.
+ */
+
+
 static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 			       size_t length, loff_t *ppos)
 {
@@ -291,6 +379,11 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
+/**
+ * proc_scsi_show - show contents of /proc/scsi/scsi (attached devices)
+ * @s: output goes here
+ * @p: not used
+ */
 static int proc_scsi_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "Attached devices:\n");
@@ -298,10 +391,17 @@ static int proc_scsi_show(struct seq_fil
 	return 0;
 }
 
+/**
+ * proc_scsi_open - glue function
+ * @inode: not used
+ * @file: passed to single_open()
+ *
+ * Associates proc_scsi_show with this file
+ */
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
-	 * We don't really needs this for the write case but it doesn't
+	 * We don't really need this for the write case but it doesn't
 	 * harm either.
 	 */
 	return single_open(file, proc_scsi_show, NULL);
@@ -315,6 +415,9 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
+/**
+ * scsi_init_procfs - create scsi and scsi/scsi in procfs
+ */
 int __init scsi_init_procfs(void)
 {
 	struct proc_dir_entry *pde;
@@ -336,6 +439,9 @@ err1:
 	return -ENOMEM;
 }
 
+/**
+ * scsi_exit_procfs - Remove scsi/scsi and scsi from procfs
+ */
 void scsi_exit_procfs(void)
 {
 	remove_proc_entry("scsi/scsi", NULL);

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
