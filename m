From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Failure to reread partition tables on non-busy devices
Date: Mon, 18 Nov 2002 11:35:07 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD835BB.5050608@torque.net>
References: <20021118000505.GM3280@redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

Doug,
Your patch below fixes the problem I was seeing with fdisk
creating new partitions (on a scsi_debug ram disk) not being
visible outside fdisk.

Doug Gilbert

Doug Ledford wrote:
> This patch (almost certainly wrong BTW) makes it work.  Obviously, 
> somewhere there should be a call to invalidate_bdev(); that doesn't exist.  
> I'm not sure A) where that call should be and B) what checks there should 
> be to avoid calling invalidate_bdev() on a device that is busy.
> 
> fs/partitions/check.c:  1.85 1.86 dledford 02/11/17 17:22:37 (modified, 
> needs delta)
> 
> @@ -453,8 +453,8 @@ int rescan_partitions()
>  	struct parsed_partitions *state;
>  	int p, res;
>  
> -	if (!bdev->bd_invalidated)
> -		return 0;
> +	//if (!bdev->bd_invalidated)
> +	//	return 0;
>  	if (bdev->bd_part_count)
>  		return -EBUSY;
>  	res = invalidate_device(dev, 1);
> 



