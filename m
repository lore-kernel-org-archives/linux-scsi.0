Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0025C4740C
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 16:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CE221D6C
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 16:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfIIQ2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 12:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfIIQ2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Sep 2019 12:28:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E1F020EF;
        Mon,  9 Sep 2019 16:28:10 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-124-7.rdu2.redhat.com [10.10.124.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D2B75D6B7;
        Mon,  9 Sep 2019 16:28:09 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Date:   Mon,  9 Sep 2019 11:28:04 -0500
Message-Id: <20190909162804.5694-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Mon, 09 Sep 2019 16:28:10 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are several storage drivers like dm-multipath, iscsi, and nbd that
have userspace components that can run in the IO path. For example,
iscsi and nbd's userspace deamons may need to recreate a socket and/or
send IO on it, and dm-multipath's daemon multipathd may need to send IO
to figure out the state of paths and re-set them up.

In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the
memalloc_*_save/restore functions to control the allocation behavior,
but for userspace we would end up hitting a allocation that ended up
writing data back to the same device we are trying to allocate for.

This patch allows the userspace deamon to set the PF_MEMALLOC* flags
through procfs. It currently only supports PF_MEMALLOC_NOIO, but
depending on what other drivers and userspace file systems need, for
the final version I can add the other flags for that file or do a file
per flag or just do a memalloc_noio file.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 Documentation/filesystems/proc.txt |  6 ++++
 fs/proc/base.c                     | 53 ++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 99ca040e3f90..b5456a61a013 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -46,6 +46,7 @@ Table of Contents
   3.10  /proc/<pid>/timerslack_ns - Task timerslack value
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
+  3.13  /proc/<pid>/memalloc - Control task's memory reclaim behavior
 
   4	Configuring procfs
   4.1	Mount options
@@ -1980,6 +1981,11 @@ Example
  $ cat /proc/6753/arch_status
  AVX512_elapsed_ms:      8
 
+3.13 /proc/<pid>/memalloc - Control task's memory reclaim behavior
+-----------------------------------------------------------------------
+A value of "noio" indicates that when a task allocates memory it will not
+reclaim memory that requires starting phisical IO.
+
 Description
 -----------
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb8..c4faa3464602 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1223,6 +1223,57 @@ static const struct file_operations proc_oom_score_adj_operations = {
 	.llseek		= default_llseek,
 };
 
+static ssize_t memalloc_read(struct file *file, char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	struct task_struct *task;
+	ssize_t rc = 0;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	if (task->flags & PF_MEMALLOC_NOIO)
+		rc = simple_read_from_buffer(buf, count, ppos, "noio", 4);
+	put_task_struct(task);
+	return rc;
+}
+
+static ssize_t memalloc_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[5];
+	int rc = count;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count != sizeof(buffer) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	buffer[count] = '\0';
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	if (!strcmp(buffer, "noio")) {
+		task->flags |= PF_MEMALLOC_NOIO;
+	} else {
+		rc = -EINVAL;
+	}
+
+	put_task_struct(task);
+	return rc;
+}
+
+static const struct file_operations proc_memalloc_operations = {
+	.read		= memalloc_read,
+	.write		= memalloc_write,
+	.llseek		= default_llseek,
+};
+
 #ifdef CONFIG_AUDIT
 #define TMPBUFLEN 11
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -3097,6 +3148,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
 #endif
+	REG("memalloc", S_IRUGO|S_IWUSR, proc_memalloc_operations),
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3487,6 +3539,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
 #endif
+	REG("memalloc", S_IRUGO|S_IWUSR, proc_memalloc_operations),
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.21.0

