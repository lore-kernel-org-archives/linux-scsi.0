Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3A6C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 20:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiHLUq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 16:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiHLUq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 16:46:28 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3B399B68
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:26 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id d71so1689300pgc.13
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=hPJ2fB5cdGNu2CPUHJu9k5DUoqE/wxDkn/IsKtH+Sck=;
        b=hl4VADeNwAQqxIyOczaw+xYi+fOuv4nCe3MfZdFbAcCiZh6QIqDXsMM4y3V012jJ5G
         YVAj81MALBA2ACaPtk0Gclg1wR0HzjcSx3t0iWVlnqZzWl+Y276muWOC+4LXvmQaiJ0h
         wp2DAzdz0FmZsJn9ckfjooNZ9rOTKVdjC439Y75gqPXdTgY1F5kq3SLaKw/N9YLtTXOr
         aaKUIMsmklUuywSwdlLBogerTpvgYHioERDBpxl6IFVM6f+y6Pia6naVPLozgSKoSpYg
         P7jNbqLUdjda5CPbzmmrRhh4p7yzihtOqGQ55JLD47pWBfJ5FvGdrWKVi2Ny5cEwAzeI
         Nj5A==
X-Gm-Message-State: ACgBeo0MtMFzTTD9HH42gROhJpAn9gOyASppZGp/irpbP7kRnJNnQNnC
        +iQdFFC6lQg9Z74KoZEGNVM=
X-Google-Smtp-Source: AA6agR5gDrtehx78RBuxmZDcRQmnzLj6CD8Hp0YSZaVQD+tOjZgeRWdqOSFIx1A38IBRI9emhA/G7A==
X-Received: by 2002:a63:ec15:0:b0:41c:2669:1e54 with SMTP id j21-20020a63ec15000000b0041c26691e54mr4587385pgh.253.1660337185502;
        Fri, 12 Aug 2022 13:46:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2414:9f13:41de:d21d])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a4e8800b001ef7c7564fdsm243189pjh.21.2022.08.12.13.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 13:46:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Doug Gilbert <dgilbert@interlog.com>
Subject: [PATCH 3/4] scsi: core: Remove procfs support
Date:   Fri, 12 Aug 2022 13:45:52 -0700
Message-Id: <20220812204553.2202539-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220812204553.2202539-1-bvanassche@acm.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are equivalents for all /proc/scsi functionality in sysfs. The most
prominent user of /proc/scsi is the sg3_utils software package. Support
for systems without /proc/scsi was added to sg3_utils in 2008. Hence
remove procfs support from the SCSI core.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig        |  11 -
 drivers/scsi/Makefile       |   1 -
 drivers/scsi/hosts.c        |   5 -
 drivers/scsi/scsi.c         |   8 +-
 drivers/scsi/scsi_devinfo.c | 146 -----------
 drivers/scsi/scsi_priv.h    |  17 --
 drivers/scsi/scsi_proc.c    | 477 ------------------------------------
 drivers/scsi/sg.c           | 358 ---------------------------
 include/scsi/scsi_host.h    |   6 -
 9 files changed, 1 insertion(+), 1028 deletions(-)
 delete mode 100644 drivers/scsi/scsi_proc.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 955cb69a5418..4c04c3856f1c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -55,17 +55,6 @@ config SCSI_NETLINK
 	default	n
 	depends on NET
 
-config SCSI_PROC_FS
-	bool "legacy /proc/scsi/ support"
-	depends on SCSI && PROC_FS
-	default y
-	help
-	  This option enables support for the various files in
-	  /proc/scsi.  In Linux 2.6 this has been superseded by
-	  files in sysfs but many legacy applications rely on this.
-
-	  If unsure say Y.
-
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index f055bfd54a68..1946172282dd 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -161,7 +161,6 @@ scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
 scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
-scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_BLK_DEBUG_FS)	+= scsi_debugfs.o
 scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 26bf3b153595..ea4818d498f0 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -180,7 +180,6 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	flush_workqueue(shost->tmf_work_q);
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
-	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
@@ -295,7 +294,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_del_dev;
 
-	scsi_proc_host_add(shost);
 	scsi_autopm_put_host(shost);
 	return error;
 
@@ -327,8 +325,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
@@ -509,7 +505,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 			     "failed to create tmf workq\n");
 		goto fail;
 	}
-	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
  fail:
 	/*
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..8c2f441c3159 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -797,12 +797,9 @@ static int __init init_scsi(void)
 {
 	int error;
 
-	error = scsi_init_procfs();
-	if (error)
-		goto cleanup_queue;
 	error = scsi_init_devinfo();
 	if (error)
-		goto cleanup_procfs;
+		goto cleanup_queue;
 	error = scsi_init_hosts();
 	if (error)
 		goto cleanup_devlist;
@@ -824,8 +821,6 @@ static int __init init_scsi(void)
 	scsi_exit_hosts();
 cleanup_devlist:
 	scsi_exit_devinfo();
-cleanup_procfs:
-	scsi_exit_procfs();
 cleanup_queue:
 	scsi_exit_queue();
 	printk(KERN_ERR "SCSI subsystem failed to initialize, error = %d\n",
@@ -840,7 +835,6 @@ static void __exit exit_scsi(void)
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
-	scsi_exit_procfs();
 	scsi_exit_queue();
 }
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c7080454aea9..a96043d2d9d1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -618,137 +618,6 @@ blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL(scsi_get_device_flags_keyed);
 
-#ifdef CONFIG_SCSI_PROC_FS
-struct double_list {
-	struct list_head *top;
-	struct list_head *bottom;
-};
-
-static int devinfo_seq_show(struct seq_file *m, void *v)
-{
-	struct double_list *dl = v;
-	struct scsi_dev_info_list_table *devinfo_table =
-		list_entry(dl->top, struct scsi_dev_info_list_table, node);
-	struct scsi_dev_info_list *devinfo =
-		list_entry(dl->bottom, struct scsi_dev_info_list,
-			   dev_info_list);
-
-	if (devinfo_table->scsi_dev_info_list.next == dl->bottom &&
-	    devinfo_table->name)
-		seq_printf(m, "[%s]:\n", devinfo_table->name);
-
-	seq_printf(m, "'%.8s' '%.16s' 0x%llx\n",
-		   devinfo->vendor, devinfo->model, devinfo->flags);
-	return 0;
-}
-
-static void *devinfo_seq_start(struct seq_file *m, loff_t *ppos)
-{
-	struct double_list *dl = kmalloc(sizeof(*dl), GFP_KERNEL);
-	loff_t pos = *ppos;
-
-	if (!dl)
-		return NULL;
-
-	list_for_each(dl->top, &scsi_dev_info_list) {
-		struct scsi_dev_info_list_table *devinfo_table =
-			list_entry(dl->top, struct scsi_dev_info_list_table,
-				   node);
-		list_for_each(dl->bottom, &devinfo_table->scsi_dev_info_list)
-			if (pos-- == 0)
-				return dl;
-	}
-
-	kfree(dl);
-	return NULL;
-}
-
-static void *devinfo_seq_next(struct seq_file *m, void *v, loff_t *ppos)
-{
-	struct double_list *dl = v;
-	struct scsi_dev_info_list_table *devinfo_table =
-		list_entry(dl->top, struct scsi_dev_info_list_table, node);
-
-	++*ppos;
-	dl->bottom = dl->bottom->next;
-	while (&devinfo_table->scsi_dev_info_list == dl->bottom) {
-		dl->top = dl->top->next;
-		if (dl->top == &scsi_dev_info_list) {
-			kfree(dl);
-			return NULL;
-		}
-		devinfo_table = list_entry(dl->top,
-					   struct scsi_dev_info_list_table,
-					   node);
-		dl->bottom = devinfo_table->scsi_dev_info_list.next;
-	}
-
-	return dl;
-}
-
-static void devinfo_seq_stop(struct seq_file *m, void *v)
-{
-	kfree(v);
-}
-
-static const struct seq_operations scsi_devinfo_seq_ops = {
-	.start	= devinfo_seq_start,
-	.next	= devinfo_seq_next,
-	.stop	= devinfo_seq_stop,
-	.show	= devinfo_seq_show,
-};
-
-static int proc_scsi_devinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &scsi_devinfo_seq_ops);
-}
-
-/*
- * proc_scsi_dev_info_write - allow additions to scsi_dev_info_list via /proc.
- *
- * Description: Adds a black/white list entry for vendor and model with an
- * integer value of flag to the scsi device info list.
- * To use, echo "vendor:model:flag" > /proc/scsi/device_info
- */
-static ssize_t proc_scsi_devinfo_write(struct file *file,
-				       const char __user *buf,
-				       size_t length, loff_t *ppos)
-{
-	char *buffer;
-	ssize_t err = length;
-
-	if (!buf || length>PAGE_SIZE)
-		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-	if (copy_from_user(buffer, buf, length)) {
-		err =-EFAULT;
-		goto out;
-	}
-
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1]) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	scsi_dev_info_list_add_str(buffer);
-
-out:
-	free_page((unsigned long)buffer);
-	return err;
-}
-
-static const struct proc_ops scsi_devinfo_proc_ops = {
-	.proc_open	= proc_scsi_devinfo_open,
-	.proc_read	= seq_read,
-	.proc_write	= proc_scsi_devinfo_write,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-#endif /* CONFIG_SCSI_PROC_FS */
-
 module_param_string(dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
 MODULE_PARM_DESC(dev_flags,
 	 "Given scsi_dev_flags=vendor:model:flags[,v:m:f] add black/white"
@@ -764,10 +633,6 @@ MODULE_PARM_DESC(default_dev_flags,
  **/
 void scsi_exit_devinfo(void)
 {
-#ifdef CONFIG_SCSI_PROC_FS
-	remove_proc_entry("scsi/device_info", NULL);
-#endif
-
 	scsi_dev_info_remove_list(SCSI_DEVINFO_GLOBAL);
 }
 
@@ -846,9 +711,6 @@ EXPORT_SYMBOL(scsi_dev_info_remove_list);
  */
 int __init scsi_init_devinfo(void)
 {
-#ifdef CONFIG_SCSI_PROC_FS
-	struct proc_dir_entry *p;
-#endif
 	int error, i;
 
 	error = scsi_dev_info_add_list(SCSI_DEVINFO_GLOBAL, NULL);
@@ -869,14 +731,6 @@ int __init scsi_init_devinfo(void)
 			goto out;
 	}
 
-#ifdef CONFIG_SCSI_PROC_FS
-	p = proc_create("scsi/device_info", 0, NULL, &scsi_devinfo_proc_ops);
-	if (!p) {
-		error = -ENOMEM;
-		goto out;
-	}
-#endif /* CONFIG_SCSI_PROC_FS */
-
  out:
 	if (error)
 		scsi_exit_devinfo();
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 429663bd78ec..e58f0922bf32 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -98,23 +98,6 @@ extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 
-/* scsi_proc.c */
-#ifdef CONFIG_SCSI_PROC_FS
-extern void scsi_proc_hostdir_add(struct scsi_host_template *);
-extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
-extern void scsi_proc_host_add(struct Scsi_Host *);
-extern void scsi_proc_host_rm(struct Scsi_Host *);
-extern int scsi_init_procfs(void);
-extern void scsi_exit_procfs(void);
-#else
-# define scsi_proc_hostdir_add(sht)	do { } while (0)
-# define scsi_proc_hostdir_rm(sht)	do { } while (0)
-# define scsi_proc_host_add(shost)	do { } while (0)
-# define scsi_proc_host_rm(shost)	do { } while (0)
-# define scsi_init_procfs()		(0)
-# define scsi_exit_procfs()		do { } while (0)
-#endif /* CONFIG_PROC_FS */
-
 /* scsi_scan.c */
 void scsi_enable_async_suspend(struct device *dev);
 extern int scsi_complete_async_scans(void);
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
deleted file mode 100644
index 95aee1ad1383..000000000000
--- a/drivers/scsi/scsi_proc.c
+++ /dev/null
@@ -1,477 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * linux/drivers/scsi/scsi_proc.c
- *
- * The functions in this file provide an interface between
- * the PROC file system and the SCSI device drivers
- * It is mainly used for debugging, statistics and to pass 
- * information directly to the lowlevel driver.
- *
- * (c) 1995 Michael Neuffer neuffer@goofy.zdv.uni-mainz.de 
- * Version: 0.99.8   last change: 95/09/13
- * 
- * generic command parser provided by: 
- * Andreas Heilwagen <crashcar@informatik.uni-koblenz.de>
- *
- * generic_proc_info() support of xxxx_info() by:
- * Michael A. Griffith <grif@acm.org>
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/proc_fs.h>
-#include <linux/errno.h>
-#include <linux/blkdev.h>
-#include <linux/seq_file.h>
-#include <linux/mutex.h>
-#include <linux/gfp.h>
-#include <linux/uaccess.h>
-
-#include <scsi/scsi.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_transport.h>
-
-#include "scsi_priv.h"
-#include "scsi_logging.h"
-
-
-/* 4K page size, but our output routines, use some slack for overruns */
-#define PROC_BLOCK_SIZE (3*1024)
-
-static struct proc_dir_entry *proc_scsi;
-
-/* Protect sht->present and sht->proc_dir */
-static DEFINE_MUTEX(global_host_template_mutex);
-
-static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
-                           size_t count, loff_t *ppos)
-{
-	struct Scsi_Host *shost = pde_data(file_inode(file));
-	ssize_t ret = -ENOMEM;
-	char *page;
-    
-	if (count > PROC_BLOCK_SIZE)
-		return -EOVERFLOW;
-
-	if (!shost->hostt->write_info)
-		return -EINVAL;
-
-	page = (char *)__get_free_page(GFP_KERNEL);
-	if (page) {
-		ret = -EFAULT;
-		if (copy_from_user(page, buf, count))
-			goto out;
-		ret = shost->hostt->write_info(shost, page, count);
-	}
-out:
-	free_page((unsigned long)page);
-	return ret;
-}
-
-static int proc_scsi_show(struct seq_file *m, void *v)
-{
-	struct Scsi_Host *shost = m->private;
-	return shost->hostt->show_info(m, shost);
-}
-
-static int proc_scsi_host_open(struct inode *inode, struct file *file)
-{
-	return single_open_size(file, proc_scsi_show, pde_data(inode),
-				4 * PAGE_SIZE);
-}
-
-static const struct proc_ops proc_scsi_ops = {
-	.proc_open	= proc_scsi_host_open,
-	.proc_release	= single_release,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_write	= proc_scsi_host_write
-};
-
-/**
- * scsi_proc_hostdir_add - Create directory in /proc for a scsi host
- * @sht: owner of this directory
- *
- * Sets sht->proc_dir to the new directory.
- */
-
-void scsi_proc_hostdir_add(struct scsi_host_template *sht)
-{
-	if (!sht->show_info)
-		return;
-
-	mutex_lock(&global_host_template_mutex);
-	if (!sht->present++) {
-		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
-        	if (!sht->proc_dir)
-			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-			       __func__, sht->proc_name);
-	}
-	mutex_unlock(&global_host_template_mutex);
-}
-
-/**
- * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
- * @sht: owner of directory
- */
-void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
-{
-	if (!sht->show_info)
-		return;
-
-	mutex_lock(&global_host_template_mutex);
-	if (!--sht->present && sht->proc_dir) {
-		remove_proc_entry(sht->proc_name, proc_scsi);
-		sht->proc_dir = NULL;
-	}
-	mutex_unlock(&global_host_template_mutex);
-}
-
-
-/**
- * scsi_proc_host_add - Add entry for this host to appropriate /proc dir
- * @shost: host to add
- */
-void scsi_proc_host_add(struct Scsi_Host *shost)
-{
-	struct scsi_host_template *sht = shost->hostt;
-	struct proc_dir_entry *p;
-	char name[10];
-
-	if (!sht->proc_dir)
-		return;
-
-	sprintf(name,"%d", shost->host_no);
-	p = proc_create_data(name, S_IRUGO | S_IWUSR,
-		sht->proc_dir, &proc_scsi_ops, shost);
-	if (!p)
-		printk(KERN_ERR "%s: Failed to register host %d in"
-		       "%s\n", __func__, shost->host_no,
-		       sht->proc_name);
-}
-
-/**
- * scsi_proc_host_rm - remove this host's entry from /proc
- * @shost: which host
- */
-void scsi_proc_host_rm(struct Scsi_Host *shost)
-{
-	char name[10];
-
-	if (!shost->hostt->proc_dir)
-		return;
-
-	sprintf(name,"%d", shost->host_no);
-	remove_proc_entry(name, shost->hostt->proc_dir);
-}
-/**
- * proc_print_scsidevice - return data about this host
- * @dev: A scsi device
- * @data: &struct seq_file to output to.
- *
- * Description: prints Host, Channel, Id, Lun, Vendor, Model, Rev, Type,
- * and revision.
- */
-static int proc_print_scsidevice(struct device *dev, void *data)
-{
-	struct scsi_device *sdev;
-	struct seq_file *s = data;
-	int i;
-
-	if (!scsi_is_sdev_device(dev))
-		goto out;
-
-	sdev = to_scsi_device(dev);
-	seq_printf(s,
-		"Host: scsi%d Channel: %02d Id: %02d Lun: %02llu\n  Vendor: ",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	for (i = 0; i < 8; i++) {
-		if (sdev->vendor[i] >= 0x20)
-			seq_putc(s, sdev->vendor[i]);
-		else
-			seq_putc(s, ' ');
-	}
-
-	seq_puts(s, " Model: ");
-	for (i = 0; i < 16; i++) {
-		if (sdev->model[i] >= 0x20)
-			seq_putc(s, sdev->model[i]);
-		else
-			seq_putc(s, ' ');
-	}
-
-	seq_puts(s, " Rev: ");
-	for (i = 0; i < 4; i++) {
-		if (sdev->rev[i] >= 0x20)
-			seq_putc(s, sdev->rev[i]);
-		else
-			seq_putc(s, ' ');
-	}
-
-	seq_putc(s, '\n');
-
-	seq_printf(s, "  Type:   %s ", scsi_device_type(sdev->type));
-	seq_printf(s, "               ANSI  SCSI revision: %02x",
-			sdev->scsi_level - (sdev->scsi_level > 1));
-	if (sdev->scsi_level == 2)
-		seq_puts(s, " CCS\n");
-	else
-		seq_putc(s, '\n');
-
-out:
-	return 0;
-}
-
-/**
- * scsi_add_single_device - Respond to user request to probe for/add device
- * @host: user-supplied decimal integer
- * @channel: user-supplied decimal integer
- * @id: user-supplied decimal integer
- * @lun: user-supplied decimal integer
- *
- * Description: called by writing "scsi add-single-device" to /proc/scsi/scsi.
- *
- * does scsi_host_lookup() and either user_scan() if that transport
- * type supports it, or else scsi_scan_host_selected()
- *
- * Note: this seems to be aimed exclusively at SCSI parallel busses.
- */
-
-static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
-{
-	struct Scsi_Host *shost;
-	int error = -ENXIO;
-
-	shost = scsi_host_lookup(host);
-	if (!shost)
-		return error;
-
-	if (shost->transportt->user_scan)
-		error = shost->transportt->user_scan(shost, channel, id, lun);
-	else
-		error = scsi_scan_host_selected(shost, channel, id, lun,
-						SCSI_SCAN_MANUAL);
-	scsi_host_put(shost);
-	return error;
-}
-
-/**
- * scsi_remove_single_device - Respond to user request to remove a device
- * @host: user-supplied decimal integer
- * @channel: user-supplied decimal integer
- * @id: user-supplied decimal integer
- * @lun: user-supplied decimal integer
- *
- * Description: called by writing "scsi remove-single-device" to
- * /proc/scsi/scsi.  Does a scsi_device_lookup() and scsi_remove_device()
- */
-static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
-{
-	struct scsi_device *sdev;
-	struct Scsi_Host *shost;
-	int error = -ENXIO;
-
-	shost = scsi_host_lookup(host);
-	if (!shost)
-		return error;
-	sdev = scsi_device_lookup(shost, channel, id, lun);
-	if (sdev) {
-		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
-		error = 0;
-	}
-
-	scsi_host_put(shost);
-	return error;
-}
-
-/**
- * proc_scsi_write - handle writes to /proc/scsi/scsi
- * @file: not used
- * @buf: buffer to write
- * @length: length of buf, at most PAGE_SIZE
- * @ppos: not used
- *
- * Description: this provides a legacy mechanism to add or remove devices by
- * Host, Channel, ID, and Lun.  To use,
- * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
- * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
- * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
- *
- * Note: this seems to be aimed at parallel SCSI. Most modern busses (USB,
- * SATA, Firewire, Fibre Channel, etc) dynamically assign these values to
- * provide a unique identifier and nothing more.
- */
-
-
-static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
-			       size_t length, loff_t *ppos)
-{
-	int host, channel, id, lun;
-	char *buffer, *p;
-	int err;
-
-	if (!buf || length > PAGE_SIZE)
-		return -EINVAL;
-
-	buffer = (char *)__get_free_page(GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	err = -EFAULT;
-	if (copy_from_user(buffer, buf, length))
-		goto out;
-
-	err = -EINVAL;
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1])
-		goto out;
-
-	/*
-	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
-	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 */
-	if (!strncmp("scsi add-single-device", buffer, 22)) {
-		p = buffer + 23;
-
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
-
-		err = scsi_add_single_device(host, channel, id, lun);
-
-	/*
-	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
-	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 */
-	} else if (!strncmp("scsi remove-single-device", buffer, 25)) {
-		p = buffer + 26;
-
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
-
-		err = scsi_remove_single_device(host, channel, id, lun);
-	}
-
-	/*
-	 * convert success returns so that we return the 
-	 * number of bytes consumed.
-	 */
-	if (!err)
-		err = length;
-
- out:
-	free_page((unsigned long)buffer);
-	return err;
-}
-
-static inline struct device *next_scsi_device(struct device *start)
-{
-	struct device *next = bus_find_next_device(&scsi_bus_type, start);
-
-	put_device(start);
-	return next;
-}
-
-static void *scsi_seq_start(struct seq_file *sfile, loff_t *pos)
-{
-	struct device *dev = NULL;
-	loff_t n = *pos;
-
-	while ((dev = next_scsi_device(dev))) {
-		if (!n--)
-			break;
-		sfile->private++;
-	}
-	return dev;
-}
-
-static void *scsi_seq_next(struct seq_file *sfile, void *v, loff_t *pos)
-{
-	(*pos)++;
-	sfile->private++;
-	return next_scsi_device(v);
-}
-
-static void scsi_seq_stop(struct seq_file *sfile, void *v)
-{
-	put_device(v);
-}
-
-static int scsi_seq_show(struct seq_file *sfile, void *dev)
-{
-	if (!sfile->private)
-		seq_puts(sfile, "Attached devices:\n");
-
-	return proc_print_scsidevice(dev, sfile);
-}
-
-static const struct seq_operations scsi_seq_ops = {
-	.start	= scsi_seq_start,
-	.next	= scsi_seq_next,
-	.stop	= scsi_seq_stop,
-	.show	= scsi_seq_show
-};
-
-/**
- * proc_scsi_open - glue function
- * @inode: not used
- * @file: passed to single_open()
- *
- * Associates proc_scsi_show with this file
- */
-static int proc_scsi_open(struct inode *inode, struct file *file)
-{
-	/*
-	 * We don't really need this for the write case but it doesn't
-	 * harm either.
-	 */
-	return seq_open(file, &scsi_seq_ops);
-}
-
-static const struct proc_ops scsi_scsi_proc_ops = {
-	.proc_open	= proc_scsi_open,
-	.proc_read	= seq_read,
-	.proc_write	= proc_scsi_write,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-
-/**
- * scsi_init_procfs - create scsi and scsi/scsi in procfs
- */
-int __init scsi_init_procfs(void)
-{
-	struct proc_dir_entry *pde;
-
-	proc_scsi = proc_mkdir("scsi", NULL);
-	if (!proc_scsi)
-		goto err1;
-
-	pde = proc_create("scsi/scsi", 0, NULL, &scsi_scsi_proc_ops);
-	if (!pde)
-		goto err2;
-
-	return 0;
-
-err2:
-	remove_proc_entry("scsi", NULL);
-err1:
-	return -ENOMEM;
-}
-
-/**
- * scsi_exit_procfs - Remove scsi/scsi and scsi from procfs
- */
-void scsi_exit_procfs(void)
-{
-	remove_proc_entry("scsi/scsi", NULL);
-	remove_proc_entry("scsi", NULL);
-}
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 340b050ad28d..e7bc490d51d2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -62,13 +62,6 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 
 #include "scsi_logging.h"
 
-#ifdef CONFIG_SCSI_PROC_FS
-#include <linux/proc_fs.h>
-static char *sg_version_date = "20140603";
-
-static int sg_proc_init(void);
-#endif
-
 #define SG_ALLOW_DIO_DEF 0
 
 #define SG_MAX_DEVS 32768
@@ -1684,9 +1677,6 @@ init_sg(void)
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
-#ifdef CONFIG_SCSI_PROC_FS
-		sg_proc_init();
-#endif				/* CONFIG_SCSI_PROC_FS */
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
@@ -1700,9 +1690,6 @@ static void __exit
 exit_sg(void)
 {
 	unregister_sg_sysctls();
-#ifdef CONFIG_SCSI_PROC_FS
-	remove_proc_subtree("scsi/sg", NULL);
-#endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
 	class_destroy(sg_sysfs_class);
 	sg_sysfs_valid = 0;
@@ -2259,31 +2246,6 @@ sg_remove_sfp(struct kref *kref)
 	schedule_work(&sfp->ew.work);
 }
 
-#ifdef CONFIG_SCSI_PROC_FS
-static int
-sg_idr_max_id(int id, void *p, void *data)
-{
-	int *k = data;
-
-	if (*k < id)
-		*k = id;
-
-	return 0;
-}
-
-static int
-sg_last_dev(void)
-{
-	int k = -1;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	idr_for_each(&sg_index_idr, sg_idr_max_id, &k);
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return k + 1;		/* origin 1 */
-}
-#endif
-
 /* must be called with sg_index_lock held */
 static Sg_device *sg_lookup_dev(int dev)
 {
@@ -2312,325 +2274,5 @@ sg_get_dev(int dev)
 	return sdp;
 }
 
-#ifdef CONFIG_SCSI_PROC_FS
-static int sg_proc_seq_show_int(struct seq_file *s, void *v);
-
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
-static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
-			          size_t count, loff_t *off);
-static const struct proc_ops adio_proc_ops = {
-	.proc_open	= sg_proc_single_open_adio,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_write	= sg_proc_write_adio,
-	.proc_release	= single_release,
-};
-
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
-static ssize_t sg_proc_write_dressz(struct file *filp, 
-		const char __user *buffer, size_t count, loff_t *off);
-static const struct proc_ops dressz_proc_ops = {
-	.proc_open	= sg_proc_single_open_dressz,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_write	= sg_proc_write_dressz,
-	.proc_release	= single_release,
-};
-
-static int sg_proc_seq_show_version(struct seq_file *s, void *v);
-static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v);
-static int sg_proc_seq_show_dev(struct seq_file *s, void *v);
-static void * dev_seq_start(struct seq_file *s, loff_t *pos);
-static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos);
-static void dev_seq_stop(struct seq_file *s, void *v);
-static const struct seq_operations dev_seq_ops = {
-	.start = dev_seq_start,
-	.next  = dev_seq_next,
-	.stop  = dev_seq_stop,
-	.show  = sg_proc_seq_show_dev,
-};
-
-static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v);
-static const struct seq_operations devstrs_seq_ops = {
-	.start = dev_seq_start,
-	.next  = dev_seq_next,
-	.stop  = dev_seq_stop,
-	.show  = sg_proc_seq_show_devstrs,
-};
-
-static int sg_proc_seq_show_debug(struct seq_file *s, void *v);
-static const struct seq_operations debug_seq_ops = {
-	.start = dev_seq_start,
-	.next  = dev_seq_next,
-	.stop  = dev_seq_stop,
-	.show  = sg_proc_seq_show_debug,
-};
-
-static int
-sg_proc_init(void)
-{
-	struct proc_dir_entry *p;
-
-	p = proc_mkdir("scsi/sg", NULL);
-	if (!p)
-		return 1;
-
-	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops);
-	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
-	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_proc_ops);
-	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
-	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
-	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
-	proc_create_single("version", S_IRUGO, p, sg_proc_seq_show_version);
-	return 0;
-}
-
-
-static int sg_proc_seq_show_int(struct seq_file *s, void *v)
-{
-	seq_printf(s, "%d\n", *((int *)s->private));
-	return 0;
-}
-
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
-}
-
-static ssize_t 
-sg_proc_write_adio(struct file *filp, const char __user *buffer,
-		   size_t count, loff_t *off)
-{
-	int err;
-	unsigned long num;
-
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-	err = kstrtoul_from_user(buffer, count, 0, &num);
-	if (err)
-		return err;
-	sg_allow_dio = num ? 1 : 0;
-	return count;
-}
-
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_big_buff);
-}
-
-static ssize_t 
-sg_proc_write_dressz(struct file *filp, const char __user *buffer,
-		     size_t count, loff_t *off)
-{
-	int err;
-	unsigned long k = ULONG_MAX;
-
-	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-		return -EACCES;
-
-	err = kstrtoul_from_user(buffer, count, 0, &k);
-	if (err)
-		return err;
-	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
-		sg_big_buff = k;
-		return count;
-	}
-	return -ERANGE;
-}
-
-static int sg_proc_seq_show_version(struct seq_file *s, void *v)
-{
-	seq_printf(s, "%d\t%s [%s]\n", sg_version_num, SG_VERSION_STR,
-		   sg_version_date);
-	return 0;
-}
-
-static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
-{
-	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
-	return 0;
-}
-
-struct sg_proc_deviter {
-	loff_t	index;
-	size_t	max;
-};
-
-static void * dev_seq_start(struct seq_file *s, loff_t *pos)
-{
-	struct sg_proc_deviter * it = kmalloc(sizeof(*it), GFP_KERNEL);
-
-	s->private = it;
-	if (! it)
-		return NULL;
-
-	it->index = *pos;
-	it->max = sg_last_dev();
-	if (it->index >= it->max)
-		return NULL;
-	return it;
-}
-
-static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct sg_proc_deviter * it = s->private;
-
-	*pos = ++it->index;
-	return (it->index < it->max) ? it : NULL;
-}
-
-static void dev_seq_stop(struct seq_file *s, void *v)
-{
-	kfree(s->private);
-}
-
-static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
-{
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
-	struct scsi_device *scsidp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if ((NULL == sdp) || (NULL == sdp->device) ||
-	    (atomic_read(&sdp->detaching)))
-		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
-	else {
-		scsidp = sdp->device;
-		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
-			      scsidp->host->host_no, scsidp->channel,
-			      scsidp->id, scsidp->lun, (int) scsidp->type,
-			      1,
-			      (int) scsidp->queue_depth,
-			      (int) scsi_device_busy(scsidp),
-			      (int) scsi_device_online(scsidp));
-	}
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return 0;
-}
-
-static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
-{
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
-	struct scsi_device *scsidp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	scsidp = sdp ? sdp->device : NULL;
-	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
-		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
-			   scsidp->vendor, scsidp->model, scsidp->rev);
-	else
-		seq_puts(s, "<no active device>\n");
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return 0;
-}
-
-/* must be called while holding sg_index_lock */
-static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
-{
-	int k, new_interface, blen, usg;
-	Sg_request *srp;
-	Sg_fd *fp;
-	const sg_io_hdr_t *hp;
-	const char * cp;
-	unsigned int ms;
-
-	k = 0;
-	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
-		k++;
-		read_lock(&fp->rq_list_lock); /* irqs already disabled */
-		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k,
-			   jiffies_to_msecs(fp->timeout),
-			   fp->reserve.bufflen,
-			   (int) fp->reserve.k_use_sg, 0);
-		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
-			   (int) fp->cmd_q, (int) fp->force_packid,
-			   (int) fp->keep_orphan);
-		list_for_each_entry(srp, &fp->rq_list, entry) {
-			hp = &srp->header;
-			new_interface = (hp->interface_id == '\0') ? 0 : 1;
-			if (srp->res_used) {
-				if (new_interface &&
-				    (SG_FLAG_MMAP_IO & hp->flags))
-					cp = "     mmap>> ";
-				else
-					cp = "     rb>> ";
-			} else {
-				if (SG_INFO_DIRECT_IO_MASK & hp->info)
-					cp = "     dio>> ";
-				else
-					cp = "     ";
-			}
-			seq_puts(s, cp);
-			blen = srp->data.bufflen;
-			usg = srp->data.k_use_sg;
-			seq_puts(s, srp->done ?
-				 ((1 == srp->done) ?  "rcv:" : "fin:")
-				  : "act:");
-			seq_printf(s, " id=%d blen=%d",
-				   srp->header.pack_id, blen);
-			if (srp->done)
-				seq_printf(s, " dur=%d", hp->duration);
-			else {
-				ms = jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=%d/%d",
-					(new_interface ? hp->timeout :
-						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
-			}
-			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
-				   (int) srp->data.cmd_opcode);
-		}
-		if (list_empty(&fp->rq_list))
-			seq_puts(s, "     No requests active\n");
-		read_unlock(&fp->rq_list_lock);
-	}
-}
-
-static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
-{
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
-	Sg_device *sdp;
-	unsigned long iflags;
-
-	if (it && (0 == it->index))
-		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
-			   (int)it->max, sg_big_buff);
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (NULL == sdp)
-		goto skip;
-	read_lock(&sdp->sfd_lock);
-	if (!list_empty(&sdp->sfds)) {
-		seq_printf(s, " >>> device=%s ", sdp->name);
-		if (atomic_read(&sdp->detaching))
-			seq_puts(s, "detaching pending close ");
-		else if (sdp->device) {
-			struct scsi_device *scsidp = sdp->device;
-
-			seq_printf(s, "%d:%d:%d:%llu   em=%d",
-				   scsidp->host->host_no,
-				   scsidp->channel, scsidp->id,
-				   scsidp->lun,
-				   scsidp->host->hostt->emulated);
-		}
-		seq_printf(s, " sg_tablesize=%d excl=%d open_cnt=%d\n",
-			   sdp->sg_tablesize, sdp->exclude, sdp->open_cnt);
-		sg_proc_debug_helper(s, sdp);
-	}
-	read_unlock(&sdp->sfd_lock);
-skip:
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return 0;
-}
-
-#endif				/* CONFIG_SCSI_PROC_FS */
-
 module_init(init_sg);
 module_exit(exit_sg);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b6e41ee3d566..44af60cc19f3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -357,12 +357,6 @@ struct scsi_host_template {
 	 */
 	const char *proc_name;
 
-	/*
-	 * Used to store the procfs directory if a driver implements the
-	 * show_info method.
-	 */
-	struct proc_dir_entry *proc_dir;
-
 	/*
 	 * This determines if we will use a non-interrupt driven
 	 * or an interrupt driven scheme.  It is set to the maximum number
