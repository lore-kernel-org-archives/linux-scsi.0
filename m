From: Oskar Andero <oskar.andero@sonymobile.com>
Subject: Re: [PATCH] scsi: fix null pointer dereference in sd_revalidate_disk
Date: Tue, 9 Apr 2013 14:32:19 +0200
Message-ID: <20130409123219.GL2481@caracas.corpusers.net>
References: <1362663400-9517-1-git-send-email-oskar.andero@sonymobile.com>
 <20130408114251.GK2481@caracas.corpusers.net>
 <1365439168.8689.10.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1633 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855Ab3DIMc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Apr 2013 08:32:27 -0400
Content-Disposition: inline
In-Reply-To: <1365439168.8689.10.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>, "Itou, Syunsuke X (Sony Mobile)" <Syunsuke.X.Itou@sonymobile.com>

Hi James,

On 18:39 Mon 08 Apr     , James Bottomley wrote:
> On Mon, 2013-04-08 at 13:42 +0200, Oskar Andero wrote:
> > On 14:36 Thu 07 Mar     , oskar.andero@sonymobile.com wrote:
> > > From: "syunsuke.x.itou" <syunsuke.x.itou@sonymobile.com>
> > > 
> > > By repeatadly connecting/disconnecting a USB masstorage device
> > > a null pointer dereference can be provoked. This is caused by
> > > sd_revalidate_disk() assuming sdkp to be a valid pointer. This
> > > patch adds a null pointer check.
> > > 
> > > Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > > Signed-off-by: syunsuke.x.itou <syunsuke.x.itou@sonymobile.com>
> > > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> > > ---
> > >  drivers/scsi/sd.c |    7 ++++++-
> > >  1 files changed, 6 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > index 7992635..49849ce 100644
> > > --- a/drivers/scsi/sd.c
> > > +++ b/drivers/scsi/sd.c
> > > @@ -1,6 +1,7 @@
> > >  /*
> > >   *      sd.c Copyright (C) 1992 Drew Eckhardt
> > >   *           Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
> > > + *           Copyright (C) 2013 Sony Mobile Communications AB.
> > >   *
> > >   *      Linux scsi disk driver
> > >   *              Initial versions: Drew Eckhardt
> > > @@ -2653,10 +2654,14 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
> > >  static int sd_revalidate_disk(struct gendisk *disk)
> > >  {
> > >  	struct scsi_disk *sdkp = scsi_disk(disk);
> > > -	struct scsi_device *sdp = sdkp->device;
> > > +	struct scsi_device *sdp;
> > >  	unsigned char *buffer;
> > >  	unsigned flush = 0;
> > >  
> > > +	if (!sdkp)
> > > +		return -ENODEV;
> > > +	sdp = sdkp->device;
> > > +
> > >  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
> > >  				      "sd_revalidate_disk\n"));
> > >  
> > > -- 
> > > 1.7.8.6
> > > 
> > 
> > Ping. Any input on the patch above?
> 
> For us to give input, the original patch would have to have been sent to
> linux-scsi ...

That's strange. Must have been lost in our mail servers. It explains
why I didn't find the patch in the archives though. :)

> However, I think it's not correct because it fixes a symptom, not the
> cause.  If sdkp can be null, that means something failed to get the
> reference that's required.  What's the stack trace?

This is the stack trace:

[...]
 [ 1896.454417] Unable to handle kernel NULL pointer dereference at virtual address 00000004
 [ 1896.461834] pgd = d7b20000
 [ 1896.464245] [00000004] *pgd=85bf6831, *pte=00000000, *ppte=00000000
 [ 1896.470471] Internal error: Oops: 17 [#1] PREEMPT SMP
 [ 1896.475537] Modules linked in:
 [ 1896.476392] hub 1-0:1.0: hub_port_status failed (err = -19)
 [ 1896.476422] hub 1-0:1.0: connect-debounce failed, port 1 disabled
 [ 1896.490248] 
 [ 1896.490279] CPU: 1    Tainted: G        W    (3.0.21-perf-gd3cbbb2-00351-gbcb8998 #1)
 [ 1896.490279] PC is at sd_revalidate_disk+0x1c/0x1720
 [ 1896.490309] LR is at rescan_partitions+0xb0/0x498
 [ 1896.490309] pc : [<c043e7ec>]    lr : [<c026a0e4>]    psr: a0000013
 [ 1896.490309] sp : d7b25c68  ip : 00000003  fp : 00000001
 [ 1896.490309] r10: e0822a00  r9 : 00000000  r8 : dce93c0c
 [ 1896.490309] r7 : 0000001f  r6 : dce93c00  r5 : dce93c00  r4 : 00000000
 [ 1896.490340] r3 : 271aed09  r2 : d7b25cd8  r1 : 00000000  r0 : dce93c00
 [ 1896.490340] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
 [ 1896.490340] Control: 10c5787d  Table: 9ef2006a  DAC: 00000015
[...]
 [ 1896.492049] [<c043e7ec>] (sd_revalidate_disk+0x1c/0x1720) from [<c026a0e4>] (rescan_partitions+0xb0/0x498)
 [ 1896.492049] [<c026a0e4>] (rescan_partitions+0xb0/0x498) from [<c024c648>] (__blkdev_get+0x154/0x320)
 [ 1896.492079] [<c024c648>] (__blkdev_get+0x154/0x320) from [<c024c688>] (__blkdev_get+0x194/0x320)
 [ 1896.492079] [<c024c688>] (__blkdev_get+0x194/0x320) from [<c024c9ec>] (blkdev_get+0x1d8/0x330)
 [ 1896.492110] [<c024c9ec>] (blkdev_get+0x1d8/0x330) from [<c021d03c>] (__dentry_open+0x220/0x338)
 [ 1896.492110] [<c021d03c>] (__dentry_open+0x220/0x338) from [<c021d204>] (nameidata_to_filp+0x50/0x5c)
 [ 1896.492140] [<c021d204>] (nameidata_to_filp+0x50/0x5c) from [<c022b244>] (do_last+0x7c8/0x8d4)
 [ 1896.492140] [<c022b244>] (do_last+0x7c8/0x8d4) from [<c022c12c>] (path_openat+0xc4/0x380)
 [ 1896.492171] [<c022c12c>] (path_openat+0xc4/0x380) from [<c022c4c8>] (do_filp_open+0x30/0x7c)
 [ 1896.492171] [<c022c4c8>] (do_filp_open+0x30/0x7c) from [<c021cc80>] (do_sys_open+0xd8/0x174)
 [ 1896.492201] [<c021cc80>] (do_sys_open+0xd8/0x174) from [<c0105e80>] (ret_fast_syscall+0x0/0x30)
 [ 1896.492201] Code: e5933000 e58d0024 e59041f0 e58d305c (e5940004) 

The patch above fixes the problem, but you might be right - maybe it only fixes the symptom.
Let me know if you have any suggestions or need more information!

-Oskar
