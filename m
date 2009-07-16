From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH 2/2] Add interface to set default value to scsi timeout variables
Date: Thu, 16 Jul 2009 16:45:22 -0400
Message-ID: <4A5F9162.4050704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335AbZGPUpX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 16:45:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Introduce interfaces, scsi_mod module parameter (initparm) and
procfs (scsi/initparm) to define default values, timeout and
max_timeout_cnt, for the devices identified by vendor and model.

Default values can be registered through these interfaces with
the format of "v:m:t:c[,v:m:t:c]"
(v:vendor, m:model, t=timeout, c=max_timeout_cnt)

Example:

 * Load scsi module with default values, scsi timeout(10s) and
   maximum timeout count (1) for HITACHI/DF600.

    # insmod scsi_mod.ko initparm="HITACHI:DF600:10:1"

 * Show current default settings

    # cat /proc/scsi/initparm
    'HITACHI' 'DF600' timeout=10 max_timeout_cnt=1



Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/Makefile        |    3 
 drivers/scsi/scsi.c          |    8 -
 drivers/scsi/scsi_initparm.c |  338 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h     |    5 
 drivers/scsi/scsi_scan.c     |    2 
 5 files changed, 354 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/Makefile
===================================================================
--- linux-2.6.31-rc2-scsi-rc-fixes-2.6.orig/drivers/scsi/Makefile
+++ linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/Makefile
@@ -151,7 +151,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
+				   scsi_initparm.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
Index: linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.31-rc2-scsi-rc-fixes-2.6.orig/drivers/scsi/scsi.c
+++ linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi.c
@@ -1323,9 +1323,12 @@ static int __init init_scsi(void)
 	error = scsi_init_devinfo();
 	if (error)
 		goto cleanup_procfs;
-	error = scsi_init_hosts();
+	error = scsi_init_initparm();
 	if (error)
 		goto cleanup_devlist;
+	error = scsi_init_hosts();
+	if (error)
+		goto cleanup_config;
 	error = scsi_init_sysctl();
 	if (error)
 		goto cleanup_hosts;
@@ -1342,6 +1345,8 @@ cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
 	scsi_exit_hosts();
+cleanup_config:
+	scsi_exit_initparm();
 cleanup_devlist:
 	scsi_exit_devinfo();
 cleanup_procfs:
@@ -1360,6 +1365,7 @@ static void __exit exit_scsi(void)
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
+	scsi_exit_initparm();
 	scsi_exit_procfs();
 	scsi_exit_queue();
 }
Index: linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_initparm.c
===================================================================
--- /dev/null
+++ linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_initparm.c
@@ -0,0 +1,338 @@
+/*
+ * scsi_initparm.c
+ *
+ * Written by Takahiro Yasui <tyasui@redhat.com>
+ *
+ * Based on the code from scsi_devinfo.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <scsi/scsi_device.h>
+
+#define MAX_VENDOR_LEN	8
+#define MAX_MODEL_LEN	16
+
+/*
+ * scsi_initparm_list: structure to hold device configrations
+ */
+struct scsi_initparm {
+	struct list_head list;
+	char vendor[MAX_VENDOR_LEN];
+	char model[MAX_MODEL_LEN];
+
+	int max_timeout_cnt;
+	int timeout;
+};
+
+static LIST_HEAD(scsi_initparm_list);
+static char initparm_str[256];
+
+/**
+ * find_initparm: find the entry with vender/model from scsi_initparm_list
+ *
+ * @vendor:     vendor string
+ * @model:      model (product) string
+ * @compatible: if true, vendor/model can include some additional characters,
+ *              but if not, vendor and model needs to to be exactly same.
+ *
+ * Returns: the entry address if found, NULL if not found.
+ **/
+static struct scsi_initparm *find_initparm(const unsigned char *vendor,
+					   const unsigned char *model,
+					   int compatible)
+{
+	struct scsi_initparm *parm;
+	int vlen, mlen;
+
+	list_for_each_entry(parm, &scsi_initparm_list, list) {
+		if (compatible) {
+			vlen = strnlen(parm->vendor, MAX_VENDOR_LEN);
+			mlen = strnlen(parm->model, MAX_MODEL_LEN);
+		} else {
+			vlen = MAX_VENDOR_LEN;
+			mlen = MAX_MODEL_LEN;
+		}
+
+		if (!strncmp(parm->vendor, vendor, vlen) &&
+		    !strncmp(parm->model, model, mlen))
+			return parm;
+	}
+
+	return NULL;
+}
+
+/**
+ * scsi_override_parms: update scsi device with registered values
+ * @sdev: vendor string
+ *
+ * Description:
+ *    If the entry with vender and mdoel is registered, scsi device
+ *    is updated with the values in the entry.
+ **/
+void scsi_override_parms(struct scsi_device *sdev)
+{
+	struct scsi_initparm *parm;
+
+	parm = find_initparm(sdev->vendor, sdev->model, 1);
+	if (!parm)
+		return;
+
+	blk_queue_rq_timeout(sdev->request_queue, parm->timeout * HZ);
+	sdev->max_timeout_cnt = parm->max_timeout_cnt;
+}
+
+static int scsi_initparm_list_add(char *vendor, char *model,
+				  char *opt1, char *opt2)
+{
+	struct scsi_initparm *parm;
+	unsigned long val;
+	int insert = 0;
+
+	parm = find_initparm(vendor, model, 0);
+	if (!parm) {
+		parm = kzalloc(sizeof(*parm), GFP_KERNEL);
+		if (!parm) {
+			printk(KERN_ERR "%s: no memory\n", __func__);
+			return -ENOMEM;
+		}
+
+		strncpy(parm->vendor, vendor, sizeof(parm->vendor));
+		strncpy(parm->model,  model, sizeof(parm->model));
+
+		insert = 1;
+	}
+
+
+	if (strict_strtoul(opt1, 0, &val)) {
+		printk(KERN_ERR "%s: bad string for timeout"
+		       " '%s' '%s' '%s' '%s'\n", __func__,
+		       vendor, model, opt1, opt2);
+		return -EINVAL;
+	}
+	parm->timeout = (int)val;
+
+
+	if (strict_strtoul(opt2, 0, &val)) {
+		printk(KERN_ERR "%s: bad string for max_timeout_cnt"
+		       " '%s' '%s' '%s' '%s'\n", __func__,
+		       vendor, model, opt1, opt2);
+		return -EINVAL;
+	}
+	parm->max_timeout_cnt = (int)val;
+
+	if (insert)
+		list_add(&parm->list, &scsi_initparm_list);
+
+	return 0;
+}
+
+/**
+ * scsi_initparm_list_add_str - parse parms and add/update the entry
+ *                              to/in the scsi_initparm_list
+ * @parms: string of init parameters to add
+ *
+ * Description:
+ *    Parse parms and add entries to the scsi_initparm_list.
+ *    parms is a format of "v:m:t:c[,v:m:t:c]"
+ *    (vendor(v), model(m), timeout(t) and max_timeout_cnt(c))
+ *
+ * Returns: 0 if OK, -error on failure.
+ **/
+static int scsi_initparm_list_add_str(char *parms)
+{
+	char *vendor, *model, *opt1, *opt2;
+	char *next, *next_check;
+	int res = 0;
+
+	next = parms;
+	if (next && next[0] == '"') {
+		next++;
+		next_check = ",\"";
+	} else
+		next_check = ",";
+
+	for (vendor = strsep(&next, ":"); vendor && (vendor[0] != '\0')
+		     && (res == 0); vendor = strsep(&next, ":")) {
+		opt1 = opt2 = NULL;
+
+		model = strsep(&next, ":");
+		if (model)
+			opt1 = strsep(&next, ":");
+		if (opt1)
+			opt2 = strsep(&next, next_check);
+
+		if (!model || !opt1 || !opt2) {
+			printk(KERN_ERR "%s: bad string '%s' '%s'"
+			       " '%s' '%s'\n", __func__,
+			       vendor, model, opt1, opt2);
+			res = -EINVAL;
+		} else
+			res = scsi_initparm_list_add(vendor, model,
+						     opt1, opt2);
+	}
+
+	return res;
+}
+
+#ifdef CONFIG_SCSI_PROC_FS
+static int initparm_seq_show(struct seq_file *m, void *v)
+{
+	struct scsi_initparm *p =
+		list_entry(v, struct scsi_initparm, list);
+
+	seq_printf(m, "'%." __stringify(MAX_VENDOR_LEN) "s' '%."
+		   __stringify(MAX_MODEL_LEN) "s'", p->vendor, p->model);
+	seq_printf(m, " timeout=%d", p->timeout);
+	seq_printf(m, " max_timeout_cnt=%d\n", p->max_timeout_cnt);
+
+	return 0;
+}
+
+static void *initparm_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return seq_list_start(&scsi_initparm_list, *pos);
+}
+
+static void *initparm_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &scsi_initparm_list, pos);
+}
+
+static void initparm_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations scsi_initparm_seq_ops = {
+	.start	= initparm_seq_start,
+	.next	= initparm_seq_next,
+	.stop	= initparm_seq_stop,
+	.show	= initparm_seq_show,
+};
+
+static int proc_initparm_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &scsi_initparm_seq_ops);
+}
+
+/**
+ * proc_scsi_initparm_write - add parms to scsi_initparm_list via /proc.
+ *
+ * Description:
+ *    Register parameters to the initparam list. Each parameter is
+ *    composed of vendor(v), model(m), timeout(t) and max_timeout_cnt(c).
+ *    To use, echo "v:m:t:c[,v:m:t:c]" > /proc/scsi/initparam
+ **/
+static ssize_t proc_initparm_write(struct file *file,
+				    const char __user *buf,
+				    size_t length, loff_t *ppos)
+{
+	char *buffer;
+	ssize_t err = length;
+
+	if (!buf || length > PAGE_SIZE)
+		return -EINVAL;
+
+	buffer = (char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	if (copy_from_user(buffer, buf, length)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	if (length < PAGE_SIZE)
+		buffer[length] = '\0';
+	else if (buffer[PAGE_SIZE-1]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	scsi_initparm_list_add_str(buffer);
+
+out:
+	free_page((unsigned long)buffer);
+	return err;
+}
+
+static const struct file_operations proc_initparm_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_initparm_open,
+	.read		= seq_read,
+	.write		= proc_initparm_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif /* CONFIG_SCSI_PROC_FS */
+
+module_param_string(initparm, initparm_str, sizeof(initparm_str), 0);
+MODULE_PARM_DESC(initparm,
+	"Register the default values of timeout(t) and max_timeout_cnt(c)"
+	" to devices indicated by vendor(v) and model(m)"
+	" initparam=v:m:t:c[,v:m:t:c]");
+
+/**
+ * scsi_init_initparm - set up the dynamic initparm list.
+ *
+ * Description:
+ *    This function is called from scsi.c:init_scsi to parse and
+ *    setup the module parameter and create proc entry.
+ **/
+int __init scsi_init_initparm(void)
+{
+#ifdef CONFIG_SCSI_PROC_FS
+	struct proc_dir_entry *p;
+#endif
+	int error;
+
+	error = scsi_initparm_list_add_str(initparm_str);
+	if (error)
+		return error;
+
+#ifdef CONFIG_SCSI_PROC_FS
+	p = proc_create("scsi/initparm", 0, NULL, &proc_initparm_fops);
+	if (!p)
+		return -ENOMEM;
+#endif
+	return 0;
+}
+
+/**
+ * scsi_exit_initparm - clean up the dynamic initparm list
+ *
+ * Description:
+ *    This function is called from scsi.c:exit_scsi to remove the proc
+ *    entry and the members of scsi_initparm_list.
+ **/
+void scsi_exit_initparm(void)
+{
+	struct list_head *lh, *lh_next;
+	struct scsi_initparm *parm;
+
+#ifdef CONFIG_SCSI_PROC_FS
+	remove_proc_entry("scsi/initparm", NULL);
+#endif
+
+	list_for_each_safe(lh, lh_next, &scsi_initparm_list) {
+		parm = list_entry(lh, struct scsi_initparm, list);
+		kfree(parm);
+	}
+}
Index: linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.31-rc2-scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_priv.h
+++ linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_priv.h
@@ -61,6 +61,11 @@ extern int scsi_dev_info_remove_list(int
 extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
+/* scsi_initparm.c */
+extern void scsi_override_parms(struct scsi_device *sdev);
+extern int __init scsi_init_initparm(void);
+extern void scsi_exit_initparm(void);
+
 /* scsi_error.c */
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
Index: linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.31-rc2-scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.31-rc2-scsi-rc-fixes-2.6/drivers/scsi/scsi_scan.c
@@ -926,6 +926,8 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
+	scsi_override_parms(sdev);
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {





