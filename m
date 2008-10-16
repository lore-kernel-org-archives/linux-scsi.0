From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/1] cciss: fix regression, sysfs symlink missing
Date: Thu, 16 Oct 2008 15:50:25 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C019B4891@GVW0547EXC.americas.hpqcorp.net>
References: <20081014184649.GA12212@roadking.ldev.net>
 <48F75C10.2000904@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:40851 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYJPPuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 11:50:55 -0400
In-Reply-To: <48F75C10.2000904@hp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brunelle, Alan" <Alan.Brunelle@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "JensAxboejens.axboe@oracle.com" <JensAxboejens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, "dchapman@redhat.com" <dchapman@redhat.com>, "hare@novell.com" <hare@novell.com>, "Garza, Sandy" <Sandy.Garza@hp.com>, "Skweres, Karen" <Karen.Skweres@hp.com>



> -----Original Message-----
> From: Brunelle, Alan
> Sent: Thursday, October 16, 2008 10:22 AM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; JensAxboejens.axboe@oracle.com; LKML;
> LKML-scsi; dchapman@redhat.com; hare@novell.com; Garza,
> Sandy; Skweres, Karen
> Subject: Re: [PATCH 1/1] cciss: fix regression, sysfs symlink missing
>
> Mike Miller wrote:
> > Patch 1 of 1
> >
> > This patch fixes a regression where the device symlink to the pci
> > address is not created. Offending commit
> > 6ae5ce8e8d4de666f31286808d2285aa6a50fa40,
> > cciss: rmove redundant code.
> >
> > Please consider this for inclusion.
> >
> > signed-off-by: Mike Miller <mike.miller@hp.com>
> >
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index
> > 1e1f915..44fb98e 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -1365,6 +1365,7 @@ static void
> cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
> >       disk->first_minor = drv_index << NWD_SHIFT;
> >       disk->fops = &cciss_fops;
> >       disk->private_data = &h->drv[drv_index];
> > +     disk->driverfs_dev = &(hba[drv_index]->pdev->dev);
> >
> >       /* Set up queue information */
> >       blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
> Hi Mike -
>
> I'm finding that
>
> hba[drv_index]
>
> (for any index) is NULL, and I'm getting the NULL pointer
> dereference bug shown below.
>
> I'm using Linus' tree up to:
>
> 6c5e51dae2c37127e00be392f40842e08077e96a

Alan,
Hmmm, I'm wondering why we didn't see this. Yes, Andrew, we did test the code! Thanks for the info, I'll have a fix up shortly.

-- mikem

>
> patched with your patch here.
>
> To determine this, I simply did:
>
>         if (hba[drv_index] == NULL)
>                 printk("cciss_add_disk(%d) hba null\n", drv_index);
>         else if (hba[drv_index]->pdev == NULL)
>                 printk("cciss_add_disk(%d) hba->pdev null\n",
> drv_index);
>         else
>                 disk->driverfs_dev = &(hba[drv_index]->pdev->dev);
>
> and find:
>
> cciss_add_disk(1) hba null
> cciss_add_disk(2) hba null
> cciss_add_disk(3) hba null
> cciss_add_disk(4) hba null
> cciss_add_disk(5) hba null
> cciss_add_disk(6) hba null
> cciss_add_disk(7) hba null
>
> in the dmesg log after boot...
>
> Regards,
> Alan
>
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000020
> IP: [<ffffffffa00ae506>] cciss_add_disk+0x80/0x10f [cciss]
> PGD 87b069067 PUD 87b06a067 PMD 0
> Oops: 0000 [1] SMP
> CPU 0
> Modules linked in: cciss(+) sd_mod scsi_mod ext3 jbd uhci_hcd
> ohci_hcd ehci_hcd
> Pid: 1852, comm: insmod Not tainted 2.6.27 #1
> RIP: 0010:[<ffffffffa00ae506>]  [<ffffffffa00ae506>]
> cciss_add_disk+0x80/0x10f [cciss]
> RSP: 0018:ffff88087b03fc38  EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff88087b005000 RCX: 00000000fffffffb
> RDX: ffff88087b03f967 RSI: 00000000ffffffff RDI: ffff88087b0027c0
> RBP: ffff88087b140000 R08: 0000000000000000 R09: ffff88087b03f900
> R10: 0000000000000000 R11: ffffffffa00ae74a R12: 0000000000000001
> R13: ffff88087b140000 R14: ffff88087b140040 R15: ffff88087b140000
> FS:  0000000000682850(0063) GS:ffffffff80703a80(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000020 CR3: 000000087b010000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400 Process insmod (pid: 1852, threadinfo
> ffff88087b03e000, task
> ffff88087b94c2c0)
> Stack:  ffff88087b980680 ffff88087bc45170 ffff88087b1400f0
> ffff88107cf88000  ffff88087bc45140 ffffffffa00af3da
> ffff880800000083 0000000000000000  0000000100000040
> 0000000800000000 ffff88087b110000 00000001802d0c5d Call Trace:
>  [<ffffffffa00af3da>] ? rebuild_lun_table+0x5b8/0x6c7 [cciss]
>  [<ffffffffa00b188d>] ? cciss_init_one+0x988/0xb3d [cciss]
> [<ffffffff8032e84c>] ? pci_device_probe+0xb6/0x105
> [<ffffffff80398ae0>] ? driver_probe_device+0xd0/0x14d
> [<ffffffff80398ba3>] ? __driver_attach+0x46/0x6d
> [<ffffffff80398b5d>] ? __driver_attach+0x0/0x6d
> [<ffffffff80398283>] ? bus_for_each_dev+0x44/0x6f
> [<ffffffff803986b9>] ? bus_add_driver+0xb4/0x203
> [<ffffffff80398dff>] ? driver_register+0x8d/0x101
> [<ffffffffa00c3000>] ? cciss_init+0x0/0x2e [cciss]
> [<ffffffff8032eaab>] ? __pci_register_driver+0x5a/0x8b
> [<ffffffffa00c3000>] ? cciss_init+0x0/0x2e [cciss]
> [<ffffffff80209041>] ? _stext+0x41/0x110
> [<ffffffff8025428f>] ? sys_init_module+0x9e/0x1ab
> [<ffffffff8020be0b>] ? system_call_fastpath+0x16/0x1b
>
>
> Code: 03 44 89 e0 4d 63 e4 4d 89 e6 c1 e0 04 49 c1 e6 06 89
> 43 04 4b 8d
> 84 2e 90 00 00 00 4d 01 ee 48 89 43 48 4a 8b 04 e5 80 13 0c
> a0 <48> 8b 40 20 48 83 e8 80 48 89 43 60 49 8b 45 20 48 8b 70
> 58 e8 RIP  [<ffffffffa00ae506>] cciss_add_disk+0x80/0x10f
> [cciss]  RSP <ffff88087b03fc38>
> CR2: 0000000000000020
> ---[ end trace 12ad011b32e7c85e ]---
>
>
