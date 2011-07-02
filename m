From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 13:37:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
References: <1309609482.2554.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309609482.2554.8.camel@mulgrave>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Okay, I found the source of the problem.  Or more accurately, I found
two separate bugs.

The first bug is triggered in scsi_request_fn().  At the start of that
routine we have:

	struct scsi_device *sdev = q->queuedata;
	...

	if (!sdev) {
		printk("scsi: killing requests for dead queue\n");
		while ((req = blk_peek_request(q)) != NULL)
			scsi_kill_request(req, q);
		return;
	}

The problem is that blk_peek_request() calls scsi_prep_fn(), which 
does this:

	struct scsi_device *sdev = q->queuedata;
	int ret = BLKPREP_KILL;

	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
		ret = scsi_setup_blk_pc_cmnd(sdev, req);
	return scsi_prep_return(q, req, ret);

It doesn't check to see if sdev is NULL, nor does 
scsi_setup_blk_pc_cmnd().  That accounts for this error:

On Sat, 2 Jul 2011, James Bottomley wrote:

> On Sat, 2011-07-02 at 08:08 +0200, Andi Kleen wrote:
> > > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > > give the exact sequence of steps you went through to trigger the bug?
> > 
> > Connect USB storage device with builtin fake CD rom. Wait for udisk
> > to mount it. Pull cable. udisk does umount. Oops.
> > 
> > I also got a log of the refcounting now if you want it.
> 
> So I've got the log, but this is the relevant section:
> 
> ---
> usb 2-1.5: USB disconnect, device number 4
> sr 5:0:0:1: scsi put_device 13 from device_del+0x177/0x1c0
> sr 5:0:0:1: scsi put_device 12 from bsg_kref_release_function+0x28/0x30
> sr 5:0:0:1: scsi put_device 10 from device_del+0x177/0x1c0
> sr 5:0:0:1: scsi put_device 8 from device_del+0x177/0x1c0
> sr 5:0:0:1: scsi put_device 7 from scsi_device_cls_release+0x15/0x20
> sr 5:0:0:1: scsi put_device 6 from klist_children_put+0x12/0x20
> sr 5:0:0:1: scsi put_device 5 from klist_devices_put+0x12/0x20
> sr 5:0:0:1: scsi put_device 3 from device_del+0x177/0x1c0
> scsi: killing requests for dead queue
> BUG: sleeping function called from invalid context
> at /home/ak/lsrc/git/linux-2.6/arch/x86/mm/fault.c:1103
> in_atomic(): 0, irqs_disabled(): 1, pid: 2527, name: umount
> Pid: 2527, comm: umount Not tainted 3.0.0-rc5+ #8
> Call Trace:
>  [<ffffffff8103af8c>] __might_sleep+0xcc/0xf0
>  [<ffffffff8155af42>] do_page_fault+0x142/0x4c0
>  [<ffffffffa01d5385>] ? write_msg+0x105/0x120 [netconsole]
>  [<ffffffff810514f7>] ? __call_console_drivers+0x97/0xb0
>  [<ffffffff81079692>] ? up+0x32/0x50
>  [<ffffffff81557f5f>] page_fault+0x1f/0x30
>  [<ffffffff81389a70>] ? scsi_setup_blk_pc_cmnd+0x170/0x170
>  [<ffffffff81388e19>] ? scsi_prep_state_check+0x9/0x90
>  [<ffffffff8138992b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
>  [<ffffffff81389abd>] scsi_prep_fn+0x4d/0x60
>  [<ffffffff812847ad>] blk_peek_request+0xbd/0x230
>  [<ffffffff8138a1ea>] scsi_request_fn+0x44a/0x470
>  [<ffffffff8127e42b>] __blk_run_queue+0x1b/0x20
>  [<ffffffff812885a3>] blk_execute_rq_nowait+0x63/0xb0
>  [<ffffffff81288676>] blk_execute_rq+0x86/0xf0
>  [<ffffffff8128430d>] ? blk_get_request+0x6d/0xa0
>  [<ffffffff81389c6c>] scsi_execute+0xfc/0x160
>  [<ffffffff8138a40a>] scsi_execute_req+0xca/0x140
>  [<ffffffff81383ea8>] ioctl_internal_command.clone.4+0x68/0x1a0
>  [<ffffffff81103f82>] ? pagevec_lookup+0x22/0x30
>  [<ffffffff8138405e>] scsi_set_medium_removal+0x7e/0xb0
>  [<ffffffff8139b390>] sr_lock_door+0x20/0x30
>  [<ffffffff813c4d63>] cdrom_release+0xa3/0x260

An easy fix is to have scsi_prep_fn() check if sdev is NULL and return 
BLKPREP_KILL if it is.

The second bug, which hit me but apparently not any of you, is that the 
request_queue's elevator gets deallocated while it is still in use.  
That's because __scsi_remove_device() calls scsi_free_queue(), which 
does blk_cleanup_queue(), which calls elevator_exit(), even though the 
device file is still open and more requests will be submitted when the 
file is closed.

I'm not sure of the right fix for this.  One possibility is to move the 
scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
maybe the elevator_exit() call should be moved to blk_release_queue().

Also, I have no idea why this shows up with USB drives but not other 
SCSI transports.  A fluke of timing?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
