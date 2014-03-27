From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [linux-next] scsi_attach_vpd() warning at mm/page_alloc.c:2497
Date: Thu, 27 Mar 2014 17:42:19 +0300
Message-ID: <20140327144219.GB7022@swordfish.minsk.epam.com>
References: <20140327101734.GA7022@swordfish.minsk.epam.com>
 <1395930570.3718.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54961 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbaC0OqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 10:46:18 -0400
Content-Disposition: inline
In-Reply-To: <1395930570.3718.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On (03/27/14 07:29), James Bottomley wrote:
> On Thu, 2014-03-27 at 13:19 +0300, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > [    1.971778] ------------[ cut here ]------------
> > [    1.971960] WARNING: CPU: 1 PID: 6 at mm/page_alloc.c:2497 __alloc_pages_nodemask+0x1b9/0x693()
> > [    1.972246] Modules linked in: sd_mod ahci
> > [    1.972604] CPU: 1 PID: 6 Comm: kworker/u8:0 Not tainted 3.14.0-rc8-next-20140327-dbg-dirty #202
> > [    1.972890] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
> > [    1.973182] Workqueue: events_unbound async_run_entry_fn
> > [    1.973417]  0000000000000000 ffff8801534d5af0 ffffffff813ad822 0000000000000000
> > [    1.973994]  ffff8801534d5b28 ffffffff8103c03c ffffffff810ad4e5 00000000001000d0
> > [    1.974529]  ffffffff81656fc8 0000000000000000 ffffffff81656fc0 ffff8801534d5b38
> > [    1.975125] Call Trace:
> > [    1.975306]  [<ffffffff813ad822>] dump_stack+0x4e/0x7a
> > [    1.975488]  [<ffffffff8103c03c>] warn_slowpath_common+0x75/0x8e
> > [    1.975670]  [<ffffffff810ad4e5>] ? __alloc_pages_nodemask+0x1b9/0x693
> > [    1.975853]  [<ffffffff8103c0f4>] warn_slowpath_null+0x15/0x17
> > [    1.976035]  [<ffffffff810ad4e5>] __alloc_pages_nodemask+0x1b9/0x693
> > [    1.976220]  [<ffffffff81074220>] ? console_unlock+0x2dd/0x2fa
> > [    1.976404]  [<ffffffff812a08be>] ? scsi_execute_req_flags+0x9c/0xb3
> > [    1.976587]  [<ffffffff810ad9d1>] __get_free_pages+0x12/0x3f
> > [    1.976771]  [<ffffffff810d5c66>] __kmalloc+0x37/0x112
> > [    1.976951]  [<ffffffff8129b5f4>] scsi_attach_vpd+0x41/0x1a8
> > [    1.977133]  [<ffffffff812a3d81>] scsi_probe_and_add_lun+0x8ec/0xa21
> > [    1.977317]  [<ffffffff812a40f8>] __scsi_add_device+0xce/0x10a
> > [    1.977501]  [<ffffffff812b109a>] ata_scsi_scan_host+0x60/0x142
> > [    1.977683]  [<ffffffff812ad6e9>] async_port_probe+0x45/0x4a
> > [    1.977873]  [<ffffffff81057e18>] async_run_entry_fn+0x5a/0x110
> > [    1.978061]  [<ffffffff8104ee52>] process_one_work+0x1c9/0x2e9
> > [    1.978243]  [<ffffffff8104f3ec>] worker_thread+0x1d3/0x2bd
> > [    1.978424]  [<ffffffff8104f219>] ? rescuer_thread+0x27d/0x27d
> > [    1.978606]  [<ffffffff81053ab4>] kthread+0xd6/0xde
> > [    1.978786]  [<ffffffff810539de>] ? kthread_create_on_node+0x162/0x162
> > [    1.978970]  [<ffffffff813b2efc>] ret_from_fork+0x7c/0xb0
> > [    1.979151]  [<ffffffff810539de>] ? kthread_create_on_node+0x162/0x162
> > [    1.979334] ---[ end trace ca7c5bd74b0dca21 ]---
> > 
> > 
> > scsi_attach_vpd() (at pg0 label) attempts to firstly allocate 255 and later 134217730 bytes.
> 
> What device is this?  can you do a sg_inq -H -p 0 /dev/sda and email the
> results to see if there's a code error or the device really is sending
> data that's insane.


$ sudo sg_inq -H -p 0 /dev/sda
VPD INQUIRY, page code=0x00:
 00     00 00 00 07 00 80 83 89  b0 b1 b2                   ...........


acer aspire 5741G laptop

[    1.593890] ahci 0000:00:1f.2: version 3.0
[    1.594108] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.594169] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.594454] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems apst 
[    1.602452] scsi0 : ahci
[    1.602853] scsi1 : ahci
[    1.603574] scsi2 : ahci
[    1.603939] scsi3 : ahci
[    1.604185] ata1: SATA max UDMA/133 abar m2048@0xb4105000 port 0xb4105100 irq 43
[    1.604481] ata2: SATA max UDMA/133 abar m2048@0xb4105000 port 0xb4105180 irq 43
[    1.604765] ata3: DUMMY
[    1.604925] ata4: DUMMY
[    1.921966] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.922179] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.924100] ata1.00: ATA-8: WDC WD6400BEVT-22A0RT0, 01.01A01, max UDMA/133
[    1.924280] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.926662] ata1.00: configured for UDMA/133
[    1.927126] scsi 0:0:0:0: Direct-Access     ATA      WDC WD6400BEVT-2 01.0 PQ: 0 ANSI: 5
[    1.929700] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    1.930393] sd 0:0:0:0: [sda] Write Protect is off
[    1.930579] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.930822] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.938973] ata2.00: ATAPI: TSSTcorp CDDVDW TS-L633C, AC01, max UDMA/100
[    1.939154] ata2.00: applying bridge limits
[    1.957617] ata2.00: configured for UDMA/100
[    1.963032] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L633C  AC01 PQ: 0 ANSI: 5
[    1.971778] ------------[ cut here ]------------
[    1.971960] WARNING: CPU: 1 PID: 6 at mm/page_alloc.c:2497 __alloc_pages_nodemask+0x1b9/0x693()
[    1.972246] Modules linked in: sd_mod ahci
[    1.972604] CPU: 1 PID: 6 Comm: kworker/u8:0 Not tainted 3.14.0-rc8-next-20140327-dbg-dirty #202
[    1.972890] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[    1.973182] Workqueue: events_unbound async_run_entry_fn
[    1.973417]  0000000000000000 ffff8801534d5af0 ffffffff813ad822 0000000000000000
[    1.973994]  ffff8801534d5b28 ffffffff8103c03c ffffffff810ad4e5 00000000001000d0
[    1.974529]  ffffffff81656fc8 0000000000000000 ffffffff81656fc0 ffff8801534d5b38
[    1.975125] Call Trace:
[    1.975306]  [<ffffffff813ad822>] dump_stack+0x4e/0x7a
[    1.975488]  [<ffffffff8103c03c>] warn_slowpath_common+0x75/0x8e
[    1.975670]  [<ffffffff810ad4e5>] ? __alloc_pages_nodemask+0x1b9/0x693
[    1.975853]  [<ffffffff8103c0f4>] warn_slowpath_null+0x15/0x17
[    1.976035]  [<ffffffff810ad4e5>] __alloc_pages_nodemask+0x1b9/0x693
[    1.976220]  [<ffffffff81074220>] ? console_unlock+0x2dd/0x2fa
[    1.976404]  [<ffffffff812a08be>] ? scsi_execute_req_flags+0x9c/0xb3
[    1.976587]  [<ffffffff810ad9d1>] __get_free_pages+0x12/0x3f
[    1.976771]  [<ffffffff810d5c66>] __kmalloc+0x37/0x112
[    1.976951]  [<ffffffff8129b5f4>] scsi_attach_vpd+0x41/0x1a8
[    1.977133]  [<ffffffff812a3d81>] scsi_probe_and_add_lun+0x8ec/0xa21
[    1.977317]  [<ffffffff812a40f8>] __scsi_add_device+0xce/0x10a
[    1.977501]  [<ffffffff812b109a>] ata_scsi_scan_host+0x60/0x142
[    1.977683]  [<ffffffff812ad6e9>] async_port_probe+0x45/0x4a
[    1.977873]  [<ffffffff81057e18>] async_run_entry_fn+0x5a/0x110
[    1.978061]  [<ffffffff8104ee52>] process_one_work+0x1c9/0x2e9
[    1.978243]  [<ffffffff8104f3ec>] worker_thread+0x1d3/0x2bd
[    1.978424]  [<ffffffff8104f219>] ? rescuer_thread+0x27d/0x27d
[    1.978606]  [<ffffffff81053ab4>] kthread+0xd6/0xde
[    1.978786]  [<ffffffff810539de>] ? kthread_create_on_node+0x162/0x162
[    1.978970]  [<ffffffff813b2efc>] ret_from_fork+0x7c/0xb0
[    1.979151]  [<ffffffff810539de>] ? kthread_create_on_node+0x162/0x162
[    1.979334] ---[ end trace ca7c5bd74b0dca21 ]---
[    1.995170] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.995448] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.996053] sr 1:0:0:0: Attached scsi CD-ROM sr0


> > ---
> > 
> > general question,
> > 
> > scsi_attach_vpd() is sure that scsi_vpd_inquiry() returns `ret < 0' in case of
> > an error and `ret > 0' otherwise:
> > 
> > 	"Returns size of the vpd page on success or a negative error number."
> > 
> > while this is not exactly true.
> > 
> > scsi_vpd_inquiry() indeed can return -EINVAL, but usually it returns
> > scsi_execute_req()->scsi_execute_req_flags()->scsi_execute() status, which
> > has different error indication and can be, e.g. for failed blk_get_request()
> > in scsi_execute() or failed sense kzalloc() in scsi_execute_req_flags(),
> > `DRIVER_ERROR << 24'.
> 
> Yes, that looks to be the problem.  Can you test this patch?
> 


sure, will test.


	-ss

> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3241749..c4d632c 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -952,7 +952,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>  	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
>  				  len, NULL, 30 * HZ, 3, NULL);
>  	if (result)
> -		return result;
> +		return -EIO;
>  
>  	/* Sanity check that we got the page back that we asked for */
>  	if (buffer[1] != page)
> 
> 
