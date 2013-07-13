From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [PATCH] fnic: use simple_open instead of fnic_trace_ctrl_open
Date: Sat, 13 Jul 2013 02:26:12 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B128A30FAF@xmb-rcd-x08.cisco.com>
References: <1373611808-4959-1-git-send-email-camelia.groza@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:54960 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3GMCjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jul 2013 22:39:04 -0400
In-Reply-To: <1373611808-4959-1-git-send-email-camelia.groza@gmail.com>
Content-Language: en-US
Content-ID: <6AB2DD2961C8FF4B8BF0670F32CE28A9@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Camelia Groza <camelia.groza@gmail.com>
Cc: "Suma Ramars (sramars)" <sramars@cisco.com>, "Brian Uchino (buchino)" <buchino@cisco.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 7/11/13 11:50 PM, "Camelia Groza" <camelia.groza@gmail.com> wrote:

>This removes the open coded fnic_trace_ctrl_open() function
>and replaces file operations references to the function
>with simple_open() instead.
>
>Found using coccinelle.
>
>Signed-off-by: Camelia Groza <camelia.groza@gmail.com>
>---
> drivers/scsi/fnic/fnic_debugfs.c |   19 +------------------
> 1 file changed, 1 insertion(+), 18 deletions(-)
>
>diff --git a/drivers/scsi/fnic/fnic_debugfs.c
>b/drivers/scsi/fnic/fnic_debugfs.c
>index cbcb012..ddc7e94 100644
>--- a/drivers/scsi/fnic/fnic_debugfs.c
>+++ b/drivers/scsi/fnic/fnic_debugfs.c
>@@ -25,23 +25,6 @@ static struct dentry *fnic_trace_debugfs_file;
> static struct dentry *fnic_trace_enable;
> 
> /*
>- * fnic_trace_ctrl_open - Open the trace_enable file
>- * @inode: The inode pointer.
>- * @file: The file pointer to attach the trace enable/disable flag.
>- *
>- * Description:
>- * This routine opens a debugsfs file trace_enable.
>- *
>- * Returns:
>- * This function returns zero if successful.
>- */
>-static int fnic_trace_ctrl_open(struct inode *inode, struct file *filp)
>-{
>-	filp->private_data = inode->i_private;
>-	return 0;
>-}
>-
>-/*
>  * fnic_trace_ctrl_read - Read a trace_enable debugfs file
>  * @filp: The file pointer to read from.
>  * @ubuf: The buffer to copy the data to.
>@@ -222,7 +205,7 @@ static int fnic_trace_debugfs_release(struct inode
>*inode,
> 
> static const struct file_operations fnic_trace_ctrl_fops = {
> 	.owner = THIS_MODULE,
>-	.open = fnic_trace_ctrl_open,
>+	.open = simple_open,
> 	.read = fnic_trace_ctrl_read,
> 	.write = fnic_trace_ctrl_write,
> };
>-- 
>1.7.10.4

Acked-by: Hiral Patel <hiralpat@cisco.com>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

