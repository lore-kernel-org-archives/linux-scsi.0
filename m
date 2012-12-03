From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [PATCH -next] [SCSI] csiostor: convert to use simple_open()
Date: Mon, 3 Dec 2012 11:44:12 +0530
Message-ID: <50BC4334.5040706@chelsio.com>
References: <CAPgLHd93AaLhAxVktx3-PQ8VojVN5AnGfZHFic-hp5O4ceBrxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:23116 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LCGOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 01:14:35 -0500
In-Reply-To: <CAPgLHd93AaLhAxVktx3-PQ8VojVN5AnGfZHFic-hp5O4ceBrxQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/2/2012 5:21 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This removes an open coded simple_open() function and
> replaces file operations references to the function
> with simple_open() instead.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/csiostor/csio_init.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> index fdd408f..17cf5e1 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -57,16 +57,6 @@ static struct dentry *csio_debugfs_root;
>  static struct scsi_transport_template *csio_fcoe_transport;
>  static struct scsi_transport_template *csio_fcoe_transport_vport;
>  
> -/*
> - * debugfs support
> - */

Please retain this comment - it is needed for the rest of the debugfs code.

> -static int
> -csio_mem_open(struct inode *inode, struct file *file)
> -{
> -	file->private_data = inode->i_private;
> -	return 0;
> -}
> -
>  static ssize_t
>  csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  {
> @@ -110,7 +100,7 @@ csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  
>  static const struct file_operations csio_mem_debugfs_fops = {
>  	.owner   = THIS_MODULE,
> -	.open    = csio_mem_open,
> +	.open = simple_open,

It would be nice if you could indent this per the rest of the structure
members. The patch looks good otherwise.

Thanks!
Naresh.

