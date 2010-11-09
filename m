From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Tue, 09 Nov 2010 10:15:34 -0800
Message-ID: <4CD98FC6.9000108@cisco.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:47527 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0KISPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 13:15:35 -0500
In-Reply-To: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 11/9/10 6:01 AM, Hillf Danton wrote:
> Ring buffers are setup for exchanging data between K and U spaces, but
> they could not survive multiple open operations.
> 
> The registered misc interface is monitored and prevented from multiple
> opens for fixing the vulnerability.
> 
> A typo, -BUSY, is also cleaned up.
> 
> btw, the ring buffers could be setup in a per file manner?
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/scsi_tgt_if.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/scsi_tgt_if.c	2010-11-09 21:42:48.000000000 +0800
> @@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
>  	if (!ev->hdr.status)
>  		tgt_ring_idx_inc(ring);
>  	else
> -		err = -BUSY;
> +		err = -EBUSY;
> 
>  	spin_unlock_irqrestore(&ring->tr_lock, flags);
> 
> @@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
>  	return err;
>  }
> 
> +static unsigned long tgt_open_cnt = 0;
> +
>  static int tgt_open(struct inode *inode, struct file *file)
>  {
> +	if (tgt_open_cnt)
> +		return -EBUSY;
> +	tgt_open_cnt++;

Since there's no locking, there's still a tiny hole where
simultaneous opens could succeed.  Consider using an atomic.
Good find and good fix otherwise.

> +
>  	tx_ring.tr_idx = rx_ring.tr_idx = 0;
> 
>  	cycle_kernel_lock();
>  	return 0;
>  }
> 
> +static int tgt_release(struct inode *inode, struct file *file)
> +{
> +	tgt_open_cnt--;
> +	return 0;
> +}
> +
>  static const struct file_operations tgt_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= tgt_open,
>  	.poll		= tgt_poll,
>  	.write		= tgt_write,
>  	.mmap		= tgt_mmap,
> +	.release	= tgt_release,
>  };
> 
>  static struct miscdevice tgt_miscdev = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
