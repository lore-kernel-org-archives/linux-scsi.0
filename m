From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] [SCSI]: constify function pointer tables
Date: Tue, 22 Jan 2008 20:54:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801222053460.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37116 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYAVTyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 14:54:54 -0500
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |   10 +++++-----
 drivers/scsi/sg.c                |    8 ++++----

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index d6a98bc..002f541 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -715,7 +715,7 @@ lpfc_debugfs_release(struct inode *inode, struct file *file)
 }
 
 #undef lpfc_debugfs_op_disc_trc
-static struct file_operations lpfc_debugfs_op_disc_trc = {
+static const struct file_operations lpfc_debugfs_op_disc_trc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_disc_trc_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -724,7 +724,7 @@ static struct file_operations lpfc_debugfs_op_disc_trc = {
 };
 
 #undef lpfc_debugfs_op_nodelist
-static struct file_operations lpfc_debugfs_op_nodelist = {
+static const struct file_operations lpfc_debugfs_op_nodelist = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_nodelist_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -733,7 +733,7 @@ static struct file_operations lpfc_debugfs_op_nodelist = {
 };
 
 #undef lpfc_debugfs_op_hbqinfo
-static struct file_operations lpfc_debugfs_op_hbqinfo = {
+static const struct file_operations lpfc_debugfs_op_hbqinfo = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_hbqinfo_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -742,7 +742,7 @@ static struct file_operations lpfc_debugfs_op_hbqinfo = {
 };
 
 #undef lpfc_debugfs_op_dumpslim
-static struct file_operations lpfc_debugfs_op_dumpslim = {
+static const struct file_operations lpfc_debugfs_op_dumpslim = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_dumpslim_open,
 	.llseek =       lpfc_debugfs_lseek,
@@ -751,7 +751,7 @@ static struct file_operations lpfc_debugfs_op_dumpslim = {
 };
 
 #undef lpfc_debugfs_op_slow_ring_trc
-static struct file_operations lpfc_debugfs_op_slow_ring_trc = {
+static const struct file_operations lpfc_debugfs_op_slow_ring_trc = {
 	.owner =        THIS_MODULE,
 	.open =         lpfc_debugfs_slow_ring_trc_open,
 	.llseek =       lpfc_debugfs_lseek,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f1871ea..c3f0e32 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1309,7 +1309,7 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 	}
 }
 
-static struct file_operations sg_fops = {
+static const struct file_operations sg_fops = {
 	.owner = THIS_MODULE,
 	.read = sg_read,
 	.write = sg_write,
@@ -2594,7 +2594,7 @@ static struct file_operations dev_fops = {
 	.open = sg_proc_open_dev,
 	.release = seq_release,
 };
-static struct seq_operations dev_seq_ops = {
+static const struct seq_operations dev_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2607,7 +2607,7 @@ static struct file_operations devstrs_fops = {
 	.open = sg_proc_open_devstrs,
 	.release = seq_release,
 };
-static struct seq_operations devstrs_seq_ops = {
+static const struct seq_operations devstrs_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
@@ -2620,7 +2620,7 @@ static struct file_operations debug_fops = {
 	.open = sg_proc_open_debug,
 	.release = seq_release,
 };
-static struct seq_operations debug_seq_ops = {
+static const struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
-- 
1.5.3.4

