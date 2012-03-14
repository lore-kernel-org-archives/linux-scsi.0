From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
 -- should I be concerned?
Date: Thu, 15 Mar 2012 02:05:40 +0400
Message-ID: <4F611634.804@msgid.tls.msk.ru>
References: <4F5379F5.6010604@msgid.tls.msk.ru> <4F545EB5.1070700@msgid.tls.msk.ru> <4F54FE51.1010401@acm.org> <4F5F6E34.6070208@msgid.tls.msk.ru> <4F60EAAE.3070803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:38666 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031095Ab2CNWFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 18:05:44 -0400
In-Reply-To: <4F60EAAE.3070803@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 14.03.2012 22:59, Bart Van Assche wrote:
> On 03/13/12 15:56, Michael Tokarev wrote:
>> WARNING: at block/genhd.c:1474 __disk_unblock_events+0x123/0x130()
> 
> Does the patch below help ? This patch prevents that sd_probe_async()
> races with scsi_host_remove().

It does not change anything (new dmesg is shown below).  Note
the problem in my case happens when the system just discovers
scsi devices (all of which are static, so always present, and
there's no single hot-unpluggable device ever, like usb/cdrom
or whatever it can be - it is a server with 4 parallel scsi
disks inside it).  So there should be no _remove()s called.

The proble does not happen _always_, from 10 reboots it does
not happen about once or twice (so 10..20% it works without
a warning), so it is a race indeed.

Thank you!

/mjt

...
[    5.996733] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    5.996734]         <Adaptec 3950B Ultra2 SCSI adapter>
[    5.996735]         aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[    5.996736]
[    5.998033] aic7xxx 0000:01:07.1: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    5.999700] scsi 0:0:0:0: Direct-Access     SEAGATE  ST373207LW       0005 PQ: 0 ANSI: 3
[    5.999794] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[    5.999910] scsi target0:0:0: Beginning Domain Validation
[    6.005242] scsi target0:0:0: wide asynchronous
[    6.007717] scsi target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
[    6.009589] scsi target0:0:0: Domain Validation skipping write tests
[    6.009634] scsi target0:0:0: Ending Domain Validation
[    6.023158] scsi 0:0:1:0: Direct-Access     SEAGATE  ST373207LW       0005 PQ: 0 ANSI: 3
[    6.023220] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[    6.023284] scsi target0:0:1: Beginning Domain Validation
...
[    8.933059] sd 0:0:1:0: [sdb] Write Protect is off
[    8.933102] sd 0:0:1:0: [sdb] Mode Sense: ab 00 10 08
[    8.934812] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.934889] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.934968] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.935055] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.966949]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    8.968219]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
[    8.972419]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
[    8.973123]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 sdd8 >
[    9.056361] ------------[ cut here ]------------
[    9.056412] WARNING: at block/genhd.c:1474 __disk_unblock_events+0x123/0x130()
[    9.056471] Hardware name: System Product Name
[    9.056512] Modules linked in: aic7xxx(+) scsi_transport_spi sd_mod scsi_mod crc_t10dif
[    9.056686] Pid: 238, comm: blkid Not tainted 3.0.0-amd64 #3.0.23
[    9.056730] Call Trace:
[    9.056771]  [<ffffffff8104c0db>] ? warn_slowpath_common+0x7b/0xc0
[    9.056817]  [<ffffffff811d7fc3>] ? __disk_unblock_events+0x123/0x130
[    9.056863]  [<ffffffff8115fefa>] ? __blkdev_get+0x19a/0x420
[    9.056907]  [<ffffffff811604b0>] ? blkdev_get+0x330/0x330
[    9.056950]  [<ffffffff811601cb>] ? blkdev_get+0x4b/0x330
[    9.056993]  [<ffffffff811604b0>] ? blkdev_get+0x330/0x330
[    9.057037]  [<ffffffff8112bb36>] ? __dentry_open+0x156/0x320
[    9.057081]  [<ffffffff8113733e>] ? path_get+0x1e/0x30
[    9.057124]  [<ffffffff8113a7b0>] ? do_last+0xe0/0x8f0
[    9.057166]  [<ffffffff8113bd43>] ? path_openat+0xd3/0x420
[    9.057210]  [<ffffffff8113cf06>] ? user_path_at_empty+0x66/0xb0
[    9.057254]  [<ffffffff8113c1bd>] ? do_filp_open+0x4d/0xc0
[    9.057298]  [<ffffffff81131d8e>] ? vfs_fstatat+0x6e/0x80
[    9.057394]  [<ffffffff81147dbb>] ? alloc_fd+0x4b/0x130
[    9.057497]  [<ffffffff8112b781>] ? do_sys_open+0x101/0x1e0
[    9.057551]  [<ffffffff81360f60>] ? cstar_dispatch+0x7/0x2e
[    9.057594] ---[ end trace cd10fe0d127c59d2 ]---
[    9.087141] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.093295] sd 0:0:2:0: [sdc] Attached SCSI disk
[    9.106434] sd 0:0:1:0: [sdb] Attached SCSI disk
[    9.181850] sd 0:0:3:0: [sdd] Attached SCSI disk
[   11.210145] scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   11.210147]         <Adaptec 3950B Ultra2 SCSI adapter>
[   11.210148]         aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs


> ---
>  drivers/scsi/sd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..7161fc1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2544,6 +2544,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>  		  sdp->removable ? "removable " : "");
>  	scsi_autopm_put_device(sdp);
> +	scsi_host_put(sdp->host);
>  	put_device(&sdkp->dev);
>  }
>  
> @@ -2635,6 +2636,7 @@ static int sd_probe(struct device *dev)
>  	dev_set_drvdata(dev, sdkp);
>  
>  	get_device(&sdkp->dev);	/* prevent release before async_schedule */
> +	scsi_host_get(sdp->host);
>  	async_schedule(sd_probe_async, sdkp);
>  
>  	return 0;

