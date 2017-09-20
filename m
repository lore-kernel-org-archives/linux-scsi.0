From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 1/1] [SCSI] fnic: Cocci spatch "simple_open"
Date: Thu, 21 Sep 2017 00:56:48 +0200
Message-ID: <1505948185999-1088654362-1-diffsplit-thomas@m3y3r.de>
References: <1505948185999-939794353-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505948185999-939794353-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This removes an open coded simple_open() function and replaces file operations
references to the function with simple_open() instead.
Found by coccinelle spatch "api/simple_open.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -108,24 +108,6 @@ void fnic_debugfs_terminate(void)
 }
 
 /*
- * fnic_trace_ctrl_open - Open the trace_enable file for fnic_trace
- *               Or Open fc_trace_enable file for fc_trace
- * @inode: The inode pointer.
- * @file: The file pointer to attach the trace enable/disable flag.
- *
- * Description:
- * This routine opens a debugsfs file trace_enable or fc_trace_enable.
- *
- * Returns:
- * This function returns zero if successful.
- */
-static int fnic_trace_ctrl_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-/*
  * fnic_trace_ctrl_read -
  *          Read  trace_enable ,fc_trace_enable
  *              or fc_trace_clear debugfs file
@@ -220,7 +202,7 @@ static ssize_t fnic_trace_ctrl_write(str
 
 static const struct file_operations fnic_trace_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.open = fnic_trace_ctrl_open,
+	.open = simple_open,
 	.read = fnic_trace_ctrl_read,
 	.write = fnic_trace_ctrl_write,
 };
