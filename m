From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: usb-storage URB use-after-free
Date: Fri, 30 Jan 2015 08:40:08 -0500
Message-ID: <20150130084008.55b7428b@jlaw-desktop.mno.stratus.com>
References: <54C95DA9.2050306@stratus.com>
	<Pine.LNX.4.44L0.1501291139380.1837-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:44659 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103AbbA3NkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2015 08:40:21 -0500
In-Reply-To: <Pine.LNX.4.44L0.1501291139380.1837-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 29 Jan 2015 11:42:18 -0500
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 28 Jan 2015, Joe Lawrence wrote:
> 
> > This one should have gone over to linux-usb.
> > 
> > -- Joe
> > 
> > On 01/28/2015 05:04 PM, Joe Lawrence wrote:
> > > Hello linux-usb,
> > > 
> > > We've hit a USB use-after-free on Stratus HW during device removal tests.
> > > We're running fio disk I/O to a scsi disk hanging off USB when the USB
> > > controller is hotplug removed.  This crash is very consistent (usually the
> > > first device pull during testing).  Without I/O, it may take days to
> > > encounter.
> > > 
> > > general protection fault: 0000 [#1] SMP
> > > ...
> > > CPU: 35 PID: 19626 Comm: kworker/u97:0 Tainted: PF       W  O--------------   3.10.0-210.el7.dev02.x86_64 #1
> > > Hardware name: Stratus ftServer 6800/G7LYY, BIOS BIOS Version 8.0:30 11/12/2014
> > > Workqueue: scsi_tmf_872 scmd_eh_abort_handler
> > > task: ffff88031bd91960 ti: ffff880981318000 task.ti: ffff880981318000
> > > RIP: 0010:[<ffffffff812d5e2d>]  [<ffffffff812d5e2d>] kobject_put+0xd/0x60
> > > RSP: 0018:ffff88098131bd28  EFLAGS: 00010002
> > > RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6c0b RCX: 00000001002f0009
> > > RDX: 000000000000002f RSI: ffffea0015719800 RDI: 6b6b6b6b6b6b6c0b
> > > RBP: ffff88098131bd30 R08: ffff88055c6622f0 R09: 00000001002f0008
> > > R10: ffff88085f407a80 R11: ffffffff81450503 R12: ffff8804bab6d248
> > > R13: 00000000ffffff98 R14: 0000000000000086 R15: 0000000000000c20
> > > FS:  0000000000000000(0000) GS:ffff88085fce0000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f2ebb5d6008 CR3: 0000001038dc5000 CR4: 00000000001407e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Stack:
> > >  0000000000000000 ffff88098131bd40 ffffffff813cd327 ffff88098131bd50
> > >  ffffffff8140a65a ffff88098131bd78 ffffffff81416795 0000000000000000
> > >  ffff880414791968 ffff880414791978 ffff88098131bd88 ffffffff814175f6
> > > Call Trace:
> > >  [<ffffffff813cd327>] put_device+0x17/0x20
> > >  [<ffffffff8140a65a>] usb_put_dev+0x1a/0x20
> > >  [<ffffffff81416795>] usb_hcd_unlink_urb+0x65/0xe0
> > >  [<ffffffff814175f6>] usb_unlink_urb+0x26/0x50
> > >  [<ffffffff81418e92>] usb_sg_cancel+0x82/0xe0
> > >  [<ffffffffa0074e71>] usb_stor_stop_transport+0x31/0x50 [usb_storage]
> > >  [<ffffffffa0073b8d>] command_abort+0xcd/0xe0 [usb_storage]
> > >  [<ffffffff813f51ef>] scmd_eh_abort_handler+0xbf/0x480
> > >  [<ffffffff8108f06b>] process_one_work+0x17b/0x470
> > >  [<ffffffff8108fe4b>] worker_thread+0x11b/0x400
> > >  [<ffffffff8108fd30>] ? rescuer_thread+0x400/0x400
> > >  [<ffffffff8109722f>] kthread+0xcf/0xe0
> > >  [<ffffffff81097160>] ? kthread_create_on_node+0x140/0x140
> > >  [<ffffffff8161387c>] ret_from_fork+0x7c/0xb0
> > >  [<ffffffff81097160>] ? kthread_create_on_node+0x140/0x140
> > > 
> > > from another crash, we know that the URB itself has been freed:
> 
> > > but the underlying usb_device->device is still present:
> 
> > > It looks like usb_hcd_unlink_urb takes a reference out on the underlying
> > > device but not the URB, which in our test case consistently gets freed
> > > just before usb_hcd_unlink_urb tries to return a reference on urb->device. 
> 
> The analysis looks correct.
> 
> > > Maybe the URB is a reference count short when usb_hcd_unlink_urb calls
> > > unlink1?  Somewhere usb-storage missed taking out a ref?
> 
> No; it's a simple use-after-free error.
> 
> > > A tourniquet hack-patch follows (probably inside out, as the URB should stay
> > > intact while usb_hcd_unlink_urb does its thing) and has been running a
> > > little over 30 surprise device removals under I/O without incident.
> > > 
> > > Any better suggestions?
> 
> Please try this instead.
> 
> Alan Stern
> 
> 
> 
> Index: usb-3.19/drivers/usb/core/hcd.c
> ===================================================================
> --- usb-3.19.orig/drivers/usb/core/hcd.c
> +++ usb-3.19/drivers/usb/core/hcd.c
> @@ -1618,6 +1618,7 @@ static int unlink1(struct usb_hcd *hcd,
>  int usb_hcd_unlink_urb (struct urb *urb, int status)
>  {
>  	struct usb_hcd		*hcd;
> +	struct usb_device	*udev = urb->dev;
>  	int			retval = -EIDRM;
>  	unsigned long		flags;
>  
> @@ -1629,20 +1630,19 @@ int usb_hcd_unlink_urb (struct urb *urb,
>  	spin_lock_irqsave(&hcd_urb_unlink_lock, flags);
>  	if (atomic_read(&urb->use_count) > 0) {
>  		retval = 0;
> -		usb_get_dev(urb->dev);
> +		usb_get_dev(udev);
>  	}
>  	spin_unlock_irqrestore(&hcd_urb_unlink_lock, flags);
>  	if (retval == 0) {
>  		hcd = bus_to_hcd(urb->dev->bus);
>  		retval = unlink1(hcd, urb, status);
> -		usb_put_dev(urb->dev);
> +		if (retval == 0)
> +			retval = -EINPROGRESS;
> +		else if (retval != -EIDRM && retval != -EBUSY)
> +			dev_dbg(&udev->dev, "hcd_unlink_urb %p fail %d\n",
> +					urb, retval);
> +		usb_put_dev(udev);
>  	}
> -
> -	if (retval == 0)
> -		retval = -EINPROGRESS;
> -	else if (retval != -EIDRM && retval != -EBUSY)
> -		dev_dbg(&urb->dev->dev, "hcd_unlink_urb %p fail %d\n",
> -				urb, retval);
>  	return retval;
>  }

Hi Alan,

Thanks for the confirmation and refined patch.  Caching the usb_device
pointer and moving the unlink1 return checking up looks good to me.

Your patch ran overnight tests with no problems.

Tested-off-by: Joe Lawrence <joe.lawrence@stratus.com>

-- Joe
