From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix a memory leak
Date: Sat, 21 Nov 2015 04:22:40 +0200
Message-ID: <564FD570.5010902@dev.mellanox.co.il>
References: <564D02F2.5080200@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564D02F2.5080200-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 19/11/2015 01:00, Bart Van Assche wrote:
> If srp_connect_ch() returns a positive value then that is considered
> by its caller as a connection failure but this does not result in a
> scsi_host_put() call and additionally causes the srp_create_target()
> function to return a positive value while it should return a negative
> value. Avoid all this confusion and additionally fix a memory leak by
> ensuring that srp_connect_ch() always returns a value that is <= 0.
> This patch avoids that a rejected login triggers the following memory
> leak:
>
> unreferenced object 0xffff88021b24a220 (size 8):
>    comm "srp_daemon", pid 56421, jiffies 4295006762 (age 4240.750s)
>    hex dump (first 8 bytes):
>      68 6f 73 74 35 38 00 a5                          host58..
>    backtrace:
>      [<ffffffff8151014a>] kmemleak_alloc+0x7a/0xc0
>      [<ffffffff81165c1e>] __kmalloc_track_caller+0xfe/0x160
>      [<ffffffff81260d2b>] kvasprintf+0x5b/0x90
>      [<ffffffff81260e2d>] kvasprintf_const+0x8d/0xb0
>      [<ffffffff81254b0c>] kobject_set_name_vargs+0x3c/0xa0
>      [<ffffffff81337e3c>] dev_set_name+0x3c/0x40
>      [<ffffffff81355757>] scsi_host_alloc+0x327/0x4b0
>      [<ffffffffa03edc8e>] srp_create_target+0x4e/0x8a0 [ib_srp]
>      [<ffffffff8133778b>] dev_attr_store+0x1b/0x20
>      [<ffffffff811f27fa>] sysfs_kf_write+0x4a/0x60
>      [<ffffffff811f1e8e>] kernfs_fop_write+0x14e/0x180
>      [<ffffffff81176eef>] __vfs_write+0x2f/0xf0
>      [<ffffffff811771e4>] vfs_write+0xa4/0x100
>      [<ffffffff81177c64>] SyS_write+0x54/0xc0
>      [<ffffffff8151b257>] entry_SYSCALL_64_fastpath+0x12/0x6f
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
