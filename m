From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/5] virtio-scsi: create a separate workqueue
Date: Wed, 7 Nov 2012 17:12:12 -0500 (EST)
Message-ID: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> patch 1-3,5 are some cleanups.
> patch 4: create a separate work queue for virtio-scsi
> to improve the performance, I tested with tmpfs backed
> disk, the config file is like below,

I think something else caused the improvement, because the code you
touched (complete_event) shouldn't ever run during a normal benchmark.
It's only used for hotplug/hot-unplug.

Nevertheless, I'll queue the cleanup patches.  Thanks for those.

Paolo

> [global]
> bsrange=4k-64k
> ioengine=libaio
> direct=1
> iodepth=4
> loops=10
> size=64M
> 
> Before:
> Disk stats (read/write):
>   sda: ios=6547/5275, merge=37/39, ticks=3144/2645, in_queue=5780,
>   util=81.62%
>   sdb: ios=6542/5277, merge=54/59, ticks=3234/3143, in_queue=6364,
>   util=84.50%
>   sdc: ios=6532/5244, merge=65/62, ticks=3440/3076, in_queue=6505,
>   util=86.83%
> 
> After:
> Disk stats (read/write):
>   sda: ios=6349/5318, merge=77/89, ticks=4820/3169, in_queue=7991,
>   util=90.62%
>   sdb: ios=6364/5358, merge=39/53, ticks=3810/2816, in_queue=6615,
>   util=84.63%
>   sdc: ios=6458/5352, merge=74/47, ticks=4425/3048, in_queue=7459,
>   util=88.41%
> 
> 
> Wanlong Gao (5):
>   virtio-scsi: remove the useless assignment
>   virtio-scsi: remove the needless variable gfp_mask
>   virtio-scsi: use pr_err instead of printk
>   virtio-scsi: create a separate work queue for virtio-scsi
>   virtio-scsi: tidy up the goto label in init()
> 
> 
> 
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: linux-scsi@vger.kernel.org
> Cc: kvm@vger.kernel.org
>  drivers/scsi/virtio_scsi.c | 43
>  +++++++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> --
> 1.8.0
> 
> 
