Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A3CECAAD5
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 23:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiIHXhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiIHXh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 19:37:27 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF33B965
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 16:36:12 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id iw17so254486plb.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 16:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nU0QpS6GAX7NRYFCt99LfcyFsNi6JzcSIa/PMPY8+yo=;
        b=nWpbnIbo2G6XdMjmA0aalUdodDFmGoPC2knHqlQwvPLkbBh5e3J+q4oBvP35BWeczz
         hPFxXh7BBEpNZMrSW2QUUkYDb5I+Ff37q3Q0c/v4wEnWg+aeyGMEVTH70vXQVGQvwF8e
         /sHZeKpTaftGOe67TF0w3e5zo/lrzCGDoo8MOHQNh1XWHvOHJ8tsziPOOANHnrCk/WMX
         ZrJITUZH35qAyluaGi+6SswJ4y0Skva36pDdI+/+hwNAPgZ/V7peZfZjWn0/xom/koZR
         rD/PhVV4t/6jltg4y9HFTorQ3jaVjNOyBaXO7nqXtW+OndDrOvlk/vq66/QzTVZpb30a
         BrVA==
X-Gm-Message-State: ACgBeo2T8f26mMbuG1kg520MDoi4R0+FciQifk/OzavqQlLkk0Db6NPm
        e5mjNG9J7BxZU4oqTwp9lx4=
X-Google-Smtp-Source: AA6agR482TBixxA1nkHWqfDOkg+4g/69/9VmliuK5b6jC2B5S/bhYsLfBodflIjq1vS43doikuT9Ng==
X-Received: by 2002:a17:90b:4acc:b0:1f5:7f05:12e8 with SMTP id mh12-20020a17090b4acc00b001f57f0512e8mr6473507pjb.92.1662680171581;
        Thu, 08 Sep 2022 16:36:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c18a:7410:112c:aa7c])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b0016c574aa0fdsm84259plg.76.2022.09.08.16.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 16:36:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 2/3] scsi: core: Introduce a new list for SCSI proc directory entries
Date:   Thu,  8 Sep 2022 16:35:59 -0700
Message-Id: <20220908233600.3043271-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220908233600.3043271-1-bvanassche@acm.org>
References: <20220908233600.3043271-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using scsi_host_template members to track the SCSI proc
directory entries, track these entries in a list. This patch changes the
time needed for looking up the proc dir pointer from O(1) into O(n). I
think this is acceptable since the number of SCSI host adapter types per
host is usually small (less than ten).

This patch has been tested by attaching two USB storage devices to a
qemu host:

$ grep -aH . /proc/scsi/usb-storage/*
/proc/scsi/usb-storage/7:   Host scsi7: usb-storage
/proc/scsi/usb-storage/7:       Vendor: QEMU
/proc/scsi/usb-storage/7:      Product: QEMU USB HARDDRIVE
/proc/scsi/usb-storage/7:Serial Number: 1-0000:00:02.1:00.0-6
/proc/scsi/usb-storage/7:     Protocol: Transparent SCSI
/proc/scsi/usb-storage/7:    Transport: Bulk
/proc/scsi/usb-storage/7:       Quirks: SANE_SENSE
/proc/scsi/usb-storage/8:   Host scsi8: usb-storage
/proc/scsi/usb-storage/8:       Vendor: QEMU
/proc/scsi/usb-storage/8:      Product: QEMU USB HARDDRIVE
/proc/scsi/usb-storage/8:Serial Number: 1-0000:00:02.1:00.0-7
/proc/scsi/usb-storage/8:     Protocol: Transparent SCSI
/proc/scsi/usb-storage/8:    Transport: Bulk
/proc/scsi/usb-storage/8:       Quirks: SANE_SENSE

This patch prepares for constifying most SCSI host templates.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_priv.h |   4 +-
 drivers/scsi/scsi_proc.c | 110 +++++++++++++++++++++++++++++++++------
 include/scsi/scsi_host.h |  12 -----
 3 files changed, 95 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f385b3f04d6e..be5d7c9b7f39 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -100,8 +100,8 @@ extern void scsi_evt_thread(struct work_struct *work);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
-extern void scsi_proc_hostdir_add(struct scsi_host_template *);
-extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
+extern void scsi_proc_hostdir_add(const struct scsi_host_template *);
+extern void scsi_proc_hostdir_rm(const struct scsi_host_template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
 extern int scsi_init_procfs(void);
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index eeb9261c93f7..e04db652a81e 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -43,8 +43,23 @@
 
 static struct proc_dir_entry *proc_scsi;
 
-/* Protect sht->present and sht->proc_dir */
+/* Protects scsi_proc_list */
 static DEFINE_MUTEX(global_host_template_mutex);
+static LIST_HEAD(scsi_proc_list);
+
+/**
+ * struct scsi_proc_entry - (host template, SCSI proc dir) association
+ * @entry: entry in scsi_proc_list.
+ * @sht: SCSI host template associated with the procfs directory.
+ * @proc_dir: procfs directory associated with the SCSI host template.
+ * @present: Number of SCSI hosts instantiated for @sht.
+ */
+struct scsi_proc_entry {
+	struct list_head	entry;
+	const struct scsi_host_template *sht;
+	struct proc_dir_entry	*proc_dir;
+	unsigned char		present;
+};
 
 static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
                            size_t count, loff_t *ppos)
@@ -83,6 +98,32 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
 				4 * PAGE_SIZE);
 }
 
+static struct scsi_proc_entry *
+__scsi_lookup_proc_entry(const struct scsi_host_template *sht)
+{
+	struct scsi_proc_entry *e;
+
+	lockdep_assert_held(&global_host_template_mutex);
+
+	list_for_each_entry(e, &scsi_proc_list, entry)
+		if (e->sht == sht)
+			return e;
+
+	return NULL;
+}
+
+static struct scsi_proc_entry *
+scsi_lookup_proc_entry(const struct scsi_host_template *sht)
+{
+	struct scsi_proc_entry *e;
+
+	mutex_lock(&global_host_template_mutex);
+	e = __scsi_lookup_proc_entry(sht);
+	mutex_unlock(&global_host_template_mutex);
+
+	return e;
+}
+
 /**
  * scsi_template_proc_dir() - returns the procfs dir for a SCSI host template
  * @sht: SCSI host template pointer.
@@ -90,7 +131,9 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
 struct proc_dir_entry *
 scsi_template_proc_dir(const struct scsi_host_template *sht)
 {
-	return sht->proc_dir;
+	struct scsi_proc_entry *e = scsi_lookup_proc_entry(sht);
+
+	return e ? e->proc_dir : NULL;
 }
 EXPORT_SYMBOL(scsi_template_proc_dir);
 
@@ -109,34 +152,56 @@ static const struct proc_ops proc_scsi_ops = {
  * Sets sht->proc_dir to the new directory.
  */
 
-void scsi_proc_hostdir_add(struct scsi_host_template *sht)
+void scsi_proc_hostdir_add(const struct scsi_host_template *sht)
 {
+	struct scsi_proc_entry *e;
+
 	if (!sht->show_info)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
-	if (!sht->present++) {
-		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
-        	if (!sht->proc_dir)
-			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-			       __func__, sht->proc_name);
+	e = __scsi_lookup_proc_entry(sht);
+	if (!e) {
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		if (!e)
+			goto unlock;
 	}
+	if (e->present++) {
+		e = NULL;
+		goto unlock;
+	}
+	e->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
+	if (!e->proc_dir) {
+		printk(KERN_ERR "%s: proc_mkdir failed for %s\n", __func__,
+		       sht->proc_name);
+		goto unlock;
+	}
+	e->sht = sht;
+	list_add_tail(&e->entry, &scsi_proc_list);
+	e = NULL;
+unlock:
 	mutex_unlock(&global_host_template_mutex);
+
+	kfree(e);
 }
 
 /**
  * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
  * @sht: owner of directory
  */
-void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
+void scsi_proc_hostdir_rm(const struct scsi_host_template *sht)
 {
+	struct scsi_proc_entry *e;
+
 	if (!sht->show_info)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
-	if (!--sht->present && sht->proc_dir) {
+	e = __scsi_lookup_proc_entry(sht);
+	if (e && !--e->present) {
 		remove_proc_entry(sht->proc_name, proc_scsi);
-		sht->proc_dir = NULL;
+		list_del(&e->entry);
+		kfree(e);
 	}
 	mutex_unlock(&global_host_template_mutex);
 }
@@ -148,16 +213,21 @@ void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
  */
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
-	struct scsi_host_template *sht = shost->hostt;
+	const struct scsi_host_template *sht = shost->hostt;
+	struct scsi_proc_entry *e;
 	struct proc_dir_entry *p;
 	char name[10];
 
-	if (!sht->proc_dir)
+	if (!sht->show_info)
+		return;
+
+	e = scsi_lookup_proc_entry(sht);
+	if (!e)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	p = proc_create_data(name, S_IRUGO | S_IWUSR,
-		sht->proc_dir, &proc_scsi_ops, shost);
+	p = proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
+			     &proc_scsi_ops, shost);
 	if (!p)
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __func__, shost->host_no,
@@ -170,13 +240,19 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
  */
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
+	const struct scsi_host_template *sht = shost->hostt;
+	struct scsi_proc_entry *e;
 	char name[10];
 
-	if (!shost->hostt->proc_dir)
+	if (!sht->show_info)
+		return;
+
+	e = scsi_lookup_proc_entry(sht);
+	if (!e)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	remove_proc_entry(name, shost->hostt->proc_dir);
+	remove_proc_entry(name, e->proc_dir);
 }
 /**
  * proc_print_scsidevice - return data about this host
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 030faca947d2..fb8184d87384 100644
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
@@ -423,12 +417,6 @@ struct scsi_host_template {
 	 */
 	short cmd_per_lun;
 
-	/*
-	 * present contains counter indicating how many boards of this
-	 * type were found when we did the scan.
-	 */
-	unsigned char present;
-
 	/* If use block layer to manage tags, this is tag allocation policy */
 	int tag_alloc_policy;
 
