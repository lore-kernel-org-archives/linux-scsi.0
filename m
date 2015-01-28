From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: usb-storage URB use-after-free
Date: Wed, 28 Jan 2015 17:07:37 -0500
Message-ID: <54C95DA9.2050306@stratus.com>
References: <alpine.DEB.2.02.1501281702110.15974@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o142.mxlogic.net ([208.65.144.75]:58239 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbbA2CMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2015 21:12:54 -0500
In-Reply-To: <alpine.DEB.2.02.1501281702110.15974@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org

This one should have gone over to linux-usb.

-- Joe

On 01/28/2015 05:04 PM, Joe Lawrence wrote:
> Hello linux-usb,
> 
> We've hit a USB use-after-free on Stratus HW during device removal tests.
> We're running fio disk I/O to a scsi disk hanging off USB when the USB
> controller is hotplug removed.  This crash is very consistent (usually the
> first device pull during testing).  Without I/O, it may take days to
> encounter.
> 
> general protection fault: 0000 [#1] SMP
> ...
> CPU: 35 PID: 19626 Comm: kworker/u97:0 Tainted: PF       W  O--------------   3.10.0-210.el7.dev02.x86_64 #1
> Hardware name: Stratus ftServer 6800/G7LYY, BIOS BIOS Version 8.0:30 11/12/2014
> Workqueue: scsi_tmf_872 scmd_eh_abort_handler
> task: ffff88031bd91960 ti: ffff880981318000 task.ti: ffff880981318000
> RIP: 0010:[<ffffffff812d5e2d>]  [<ffffffff812d5e2d>] kobject_put+0xd/0x60
> RSP: 0018:ffff88098131bd28  EFLAGS: 00010002
> RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6c0b RCX: 00000001002f0009
> RDX: 000000000000002f RSI: ffffea0015719800 RDI: 6b6b6b6b6b6b6c0b
> RBP: ffff88098131bd30 R08: ffff88055c6622f0 R09: 00000001002f0008
> R10: ffff88085f407a80 R11: ffffffff81450503 R12: ffff8804bab6d248
> R13: 00000000ffffff98 R14: 0000000000000086 R15: 0000000000000c20
> FS:  0000000000000000(0000) GS:ffff88085fce0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2ebb5d6008 CR3: 0000001038dc5000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>  0000000000000000 ffff88098131bd40 ffffffff813cd327 ffff88098131bd50
>  ffffffff8140a65a ffff88098131bd78 ffffffff81416795 0000000000000000
>  ffff880414791968 ffff880414791978 ffff88098131bd88 ffffffff814175f6
> Call Trace:
>  [<ffffffff813cd327>] put_device+0x17/0x20
>  [<ffffffff8140a65a>] usb_put_dev+0x1a/0x20
>  [<ffffffff81416795>] usb_hcd_unlink_urb+0x65/0xe0
>  [<ffffffff814175f6>] usb_unlink_urb+0x26/0x50
>  [<ffffffff81418e92>] usb_sg_cancel+0x82/0xe0
>  [<ffffffffa0074e71>] usb_stor_stop_transport+0x31/0x50 [usb_storage]
>  [<ffffffffa0073b8d>] command_abort+0xcd/0xe0 [usb_storage]
>  [<ffffffff813f51ef>] scmd_eh_abort_handler+0xbf/0x480
>  [<ffffffff8108f06b>] process_one_work+0x17b/0x470
>  [<ffffffff8108fe4b>] worker_thread+0x11b/0x400
>  [<ffffffff8108fd30>] ? rescuer_thread+0x400/0x400
>  [<ffffffff8109722f>] kthread+0xcf/0xe0
>  [<ffffffff81097160>] ? kthread_create_on_node+0x140/0x140
>  [<ffffffff8161387c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff81097160>] ? kthread_create_on_node+0x140/0x140
> 
> from another crash, we know that the URB itself has been freed:
> 
> crash> struct -o urb | grep SIZE
> SIZE: 0xc0
> crash> p 0xc0/8
> $2 = 0x18
> crash> rd ffff880846df9248 0x18
> ffff880846df9248:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df9258:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df9268:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df9278:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df9288:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df9298:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92a8:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92b8:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92c8:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92d8:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92e8:  6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b   kkkkkkkkkkkkkkkk
> ffff880846df92f8:  6b6b6b6b6b6b6b6b a56b6b6b6b6b6b6b   kkkkkkkkkkkkkkk.
> 
> but the underlying usb_device->device is still present:
> 
> crash> struct usb_device ffff88084fd22e68
> ...
>   dev = {
>     parent = 0xffff881050c3d418, 
>     p = 0xffff88084ff27ae8, 
>     kobj = {
>       name = 0xffff88084ff071e0 "6-1", 
>       entry = {
>         next = 0xffff88084ff09568, 
>         prev = 0xffff88084ff09000
>       }, 
>       parent = 0xffff881050c3d428, 
>       kset = 0xffff8808540dc9f0, 
>       ktype = 0xffffffff819cc220 <device_ktype>, 
>       sd = 0xffff88084ff1b8b8, 
>       kref = {
>         refcount = {
>           counter = 0x8
>         }
>       }, 
>       state_initialized = 0x1, 
>       state_in_sysfs = 0x1, 
>       state_add_uevent_sent = 0x1, 
>       state_remove_uevent_sent = 0x0, 
>       uevent_suppress = 0x0
>     },
> ...
> 
> I added trace printing to usb_{alloc_urb,get_urb,free_urb} and urb_destroy
> showing the URB and the calling function, then crashed again:
> 
> ... snip ...
>      usb-storage-687   [000]   350.013212: bprint:               usb_alloc_urb : JL: usb_sg_init+0xe1 -> usb_alloc_urb(0xffff8808489b0a28)
>      usb-storage-687   [000]   350.013212: bprint:               usb_get_urb : JL: usb_hcd_submit_urb+0x3b -> usb_get_urb(0xffff8808489b0a28)
>    kworker/u97:2-703   [006]   380.656791: bprint:               usb_free_urb : JL: __usb_hcd_giveback_urb -> usb_free_urb(0xffff8808489b0a28)
>      usb-storage-687   [000]   380.656793: bprint:               usb_free_urb : JL: sg_clean+0x33 -> usb_free_urb(0xffff8808489b0a28)
>      usb-storage-687   [000]   380.656794: bprint:               urb_destroy : JL: usb_free_urb+0x40 -> urb_destroy(0xffff8808489b0a28)
> 
> crash> bt 703
> PID: 703    TASK: ffff8808497f8000  CPU: 6   COMMAND: "kworker/u97:2"
>  #0 [ffff8808497f7c10] die at ffffffff8101736b
>  #1 [ffff8808497f7c40] do_general_protection at ffffffff8160be4e
>  #2 [ffff8808497f7c70] general_protection at ffffffff8160b768
>     [exception RIP: kobject_put+0xd]
>     RIP: ffffffff812d69dd  RSP: ffff8808497f7d28  RFLAGS: 00010002
>     RAX: 0000000000000000  RBX: 6b6b6b6b6b6b6c0b  RCX: dead000000200200
>     RDX: ffff88085f400390  RSI: 0000000000000047  RDI: 6b6b6b6b6b6b6c0b
>     RBP: ffff8808497f7d30   R8: ffff88085f400390   R9: 00000001002f002e
>     R10: ffff88085f407a80  R11: ffffffff81450e03  R12: ffff8808489b0a28
>     R13: 00000000ffffff98  R14: 0000000000000086  R15: 0000000000000c20
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #3 [ffff8808497f7d38] put_device at ffffffff813cdc57
>  #4 [ffff8808497f7d48] usb_put_dev at ffffffff8140afda
>  #5 [ffff8808497f7d58] usb_hcd_unlink_urb at ffffffff81417115
>  #6 [ffff8808497f7d80] usb_unlink_urb at ffffffff814180d6
>  #7 [ffff8808497f7d90] usb_sg_cancel at ffffffff81419792
>  #8 [ffff8808497f7dc0] usb_stor_stop_transport at ffffffffa00a9e71 [usb_storage]
>  #9 [ffff8808497f7dd8] command_abort at ffffffffa00a8b8d [usb_storage]
> #10 [ffff8808497f7df8] scmd_eh_abort_handler at ffffffff813f5b5f
> #11 [ffff8808497f7e20] process_one_work at ffffffff8108f0ab
> #12 [ffff8808497f7e68] worker_thread at ffffffff8108fe8b
> #13 [ffff8808497f7ec8] kthread at ffffffff8109726f
> #14 [ffff8808497f7f50] ret_from_fork at ffffffff81613cbc
> 
> PID: 687    TASK: ffff88084c92a610  CPU: 0   COMMAND: "usb-storage"
>     [exception RIP: _raw_spin_lock_irq+0x38]
>     RIP: ffffffff8160b1d8  RSP: ffff88084cc23da0  RFLAGS: 00000002
>     RAX: 0000000000001d66  RBX: ffff88104cea1888  RCX: 0000000000008160
>     RDX: 0000000000008162  RSI: 0000000000008162  RDI: ffff88104cea1198
>     RBP: ffff88084cc23da0   R8: 0000000000001000   R9: 0000000100300023
>     R10: ffff88085f404240  R11: ffffffff81418e39  R12: ffff88084a878900
>     R13: ffff88104cea19f8  R14: 0000000000000003  R15: 0000000000000000
>     CS: 0010  SS: 0018
>  #0 [ffff88084cc23da8] usb_stor_invoke_transport at ffffffffa00a9fe2 [usb_storage]
>  #1 [ffff88084cc23e58] usb_stor_transparent_scsi_command at ffffffffa00a8c6e [usb_storage]
>  #2 [ffff88084cc23e68] usb_stor_control_thread at ffffffffa00ab6d8 [usb_storage]
>  #3 [ffff88084cc23ec8] kthread at ffffffff8109726f
>  #4 [ffff88084cc23f50] ret_from_fork at ffffffff81613cbc
> 
> It looks like usb_hcd_unlink_urb takes a reference out on the underlying
> device but not the URB, which in our test case consistently gets freed
> just before usb_hcd_unlink_urb tries to return a reference on urb->device. 
> 
> Maybe the URB is a reference count short when usb_hcd_unlink_urb calls
> unlink1?  Somewhere usb-storage missed taking out a ref?
> 
> A tourniquet hack-patch follows (probably inside out, as the URB should stay
> intact while usb_hcd_unlink_urb does its thing) and has been running a
> little over 30 surprise device removals under I/O without incident.
> 
> Any better suggestions?
> 
> -- Joe
> 
> -->8-- -->8-- -->8-- 
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 11cee55ae397..3a4ccc13f6a8 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1624,8 +1624,10 @@ int usb_hcd_unlink_urb (struct urb *urb, int status)
>  	/* Prevent the device and bus from going away while
>  	 * the unlink is carried out.  If they are already gone
>  	 * then urb->use_count must be 0, since disconnected
> -	 * devices can't have any active URBs.
> +	 * devices can't have any active URBs.  Nail down the
> +	 * URB while we're at it, too.
>  	 */
> +	usb_get_urb(urb);
>  	spin_lock_irqsave(&hcd_urb_unlink_lock, flags);
>  	if (atomic_read(&urb->use_count) > 0) {
>  		retval = 0;
> @@ -1643,6 +1645,7 @@ int usb_hcd_unlink_urb (struct urb *urb, int status)
>  	else if (retval != -EIDRM && retval != -EBUSY)
>  		dev_dbg(&urb->dev->dev, "hcd_unlink_urb %p fail %d\n",
>  				urb, retval);
> +	usb_put_urb(urb);
>  	return retval;
>  }
>  
> 
