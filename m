From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [PATCH -next v2] [SCSI] csiostor: convert to use simple_open()
Date: Mon, 3 Dec 2012 12:23:23 +0530
Message-ID: <50BC4C63.2040101@chelsio.com>
References: <CAPgLHd9L_m1qPO3cjnwOJAWmtWjERd5aGK-qPs-yRd9z3fXXCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:6189 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2LCGxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 01:53:38 -0500
In-Reply-To: <CAPgLHd9L_m1qPO3cjnwOJAWmtWjERd5aGK-qPs-yRd9z3fXXCQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/3/2012 11:52 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> This removes an open coded simple_open() function and
> replaces file operations references to the function
> with simple_open() instead.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/csiostor/csio_init.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> index fdd408f..c9336b3 100644
> --- a/drivers/scsi/csiostor/csio_init.c
> +++ b/drivers/scsi/csiostor/csio_init.c
> @@ -60,13 +60,6 @@ static struct scsi_transport_template *csio_fcoe_transport_vport;
>  /*
>   * debugfs support
>   */
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
> @@ -110,7 +103,7 @@ csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  
>  static const struct file_operations csio_mem_debugfs_fops = {
>  	.owner   = THIS_MODULE,
> -	.open    = csio_mem_open,
> +	.open    = simple_open,
>  	.read    = csio_mem_read,
>  	.llseek  = default_llseek,
>  };
> 
>

Acked-by: Naresh Kumar Inna <naresh@chelsio.com>

Thanks,
Naresh.
