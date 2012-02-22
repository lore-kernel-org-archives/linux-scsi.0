From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
Date: Tue, 21 Feb 2012 17:04:35 -0800
Message-ID: <20120222010435.GI12236@google.com>
References: <4F443E81.2060402@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F443E81.2060402@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Naveen Goswamy <naveen.goswamy@polymtl.ca>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, sgruszka@redhat.com, Huajun Li <huajun.li.lee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2012 at 10:01:53AM +0900, Jun'ichi Nomura wrote:
> Since 2.6.39 (1196f8b), when a driver returns -ENOMEDIUM for open(),
> __blkdev_get() calls rescan_partitions() to remove
> in-kernel partition structures and raise KOBJ_CHANGE uevent.
> 
> However it ends up calling driver's revalidate_disk without open
> and could cause oops.
> 
> In the case of SCSI:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Oopses are reported here:
> http://marc.info/?l=linux-scsi&m=132388619710052
> 
> This patch separates the partition invalidation from rescan_partitions()
> and use it for -ENOMEDIUM case. 
> 
> Reported-by: Huajun Li <huajun.li.lee@gmail.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you!

-- 
tejun
