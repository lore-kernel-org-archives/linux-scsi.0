From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] block: Check that queue is alive in
 blk_insert_cloned_request()
Date: Mon, 11 Jul 2011 22:09:45 -0400
Message-ID: <20110712020945.GB30965@redhat.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1GLCKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 22:10:52 -0400
Content-Disposition: inline
In-Reply-To: <1310166270-23196-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 04:04:30PM -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> This fixes crashes such as the below that I see when the storage
> underlying a dm-multipath device is hot-removed.  The problem is that
> dm requeues a request to a device whose block queue has already been
> cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> is alive, but rather goes ahead and tries to queue the request.  This
> ends up dereferencing the elevator that was already freed in
> blk_cleanup_queue().
> 
>     general protection fault: 0000 [#1] SMP 
>     CPU 7 
>     Modules linked in: kvm_intel kvm serio_raw i7core_edac edac_core ioatdma dca pci_stub ses enclosure usbhid usb_storage qla2xxx mpt2sas ahci hid uas libahci e1000e scsi_transport_fc scsi_transport_sas mlx4_core raid_class scsi_tgt
>     RIP: 0010:[<ffffffff81233867>]  [<ffffffff81233867>] elv_drain_elevator+0x27/0x80
>     RSP: 0018:ffff880614e9fa48  EFLAGS: 00010096
>     RAX: 6b6b6b6b6b6b6b6b RBX: ffff880610bb0000 RCX: 0000000000000000
>     RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff880610bb0000
>     RBP: ffff880614e9fa58 R08: 0000000000000000 R09: 0000000000000001
>     R10: ffff880c0a7dca70 R11: ffff880615622440 R12: ffff880610bb0000
>     R13: 0000000000000002 R14: 0000000000000002 R15: ffff880c0db01160
>     FS:  00007fe46457a760(0000) GS:ffff880c3fc20000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 00007fe463c86330 CR3: 0000000c0cc0c000 CR4: 00000000000006e0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>     Process blkid (pid: 12458, threadinfo ffff880614e9e000, task ffff8806190eae20)
>     Stack:
>      ffff880c0d9f03c8 ffff880c0d9f03c8 ffff880614e9fa88 ffffff
>      ffff880c0d9f03c8 ffff880610bb0000 0000000000000002 ffffc9
>      ffff880614e9fab8 ffffffff812366fd ffff880614e9fad8 ffff88
>     Call Trace:
>      [<ffffffff812339a8>] __elv_add_request+0xe8/0x280
>      [<ffffffff812366fd>] add_acct_request+0x3d/0x50
>      [<ffffffff81236775>] blk_insert_cloned_request+0x65/0x90
>      [<ffffffff813b8d4e>] dm_dispatch_request+0x3e/0x70
>      [<ffffffff813ba850>] dm_request_fn+0x160/0x250
>      [<ffffffff81236e88>] queue_unplugged+0x48/0xd0
>      [<ffffffff8123b03d>] blk_flush_plug_list+0x1ed/0x250

Roland,

IIUC, this crash can happen even without dm-multipath being in picture.
Because it looks like it can happen that we have put requests on 
plug list and then device is hot removed which ends up cleaning elevator
and then blk_flush_plug_list() is called. 

Can you please try it without multipath target.

Thanks
Vivek
