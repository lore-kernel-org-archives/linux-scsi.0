From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Fri, 2 Apr 2004 16:11:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040403001105.GC1472@us.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:26093 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261396AbUDCAL2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 19:11:28 -0500
Content-Disposition: inline
In-Reply-To: <1080949016.1804.161.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> ===== drivers/scsi/sr.c 1.103 vs edited =====
> --- 1.103/drivers/scsi/sr.c	Fri Apr  2 11:30:44 2004
> +++ edited/drivers/scsi/sr.c	Fri Apr  2 17:29:06 2004
> @@ -424,8 +424,19 @@
>  
>  static int sr_block_release(struct inode *inode, struct file *file)
>  {
> +	int ret;
>  	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
> -	return cdrom_release(&cd->cdi, file);
> +	struct scsi_device *sdev = cd->device;
> +	ret = cdrom_release(&cd->cdi, file);
> +	if(ret)
> +		return ret;

It looks like cdrom_release always returns 0? Is there some other patch
outstanding that changes this.

-andmike
--
Michael Anderson
andmike@us.ibm.com

