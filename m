From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] scsi_allocate_request() reference
Date: Tue, 22 Mar 2005 08:51:46 +0900
Message-ID: <20050321235146.GA7994@htj.dyndns.org>
References: <20050321132604.GA25452@suse.de> <1111417798.5504.8.camel@mulgrave> <20050321165751.GJ25452@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from rproxy.gmail.com ([64.233.170.194]:40925 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262227AbVCUXwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 18:52:38 -0500
Received: by rproxy.gmail.com with SMTP id y7so1100862rne
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2005 15:52:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050321165751.GJ25452@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 Hello, Jens.
 Hello, James.

On Mon, Mar 21, 2005 at 05:57:52PM +0100, Jens Axboe wrote:
> On Mon, Mar 21 2005, James Bottomley wrote:
> > On Mon, 2005-03-21 at 14:26 +0100, Jens Axboe wrote:
> > > scsi_allocate_request() doesn't hold a reference to the device that it
> > > points to, that is not good. This patch fixes that up.
> > 
> > Actually, I don't think this is correct.  The reference is taken when
> > the command is attached to a request in the scsi_request_fn function
> > after first checking that the entity is in a condition to have this
> > happen.
> 
> Where does this happen, specifically? I can verify that this patch
> solves at least one of the oopses I am seeing with hotplug. IMHO, the
> reference should be taken when you reference the device (ie ->sr_device
> is assigned in scsi_allocate_request()).

 I've been working on scsi hot plug/unplugging for a few days now but
I haven't seen any oops caused by reference count problems.  The only
oops I've seen looks like the following.  (using usb hdd)

Unable to handle kernel paging request at virtual address 20020070
 printing eip:
c02b925f
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: nfs lockd sunrpc sd_mod sata_sil libata e1000 eepro100 e100 mii tsdev floppy
CPU:    0
EIP:    0060:[<c02b925f>]    Not tainted VLI
EFLAGS: 00010246   (2.6.11-scsi-work-i386) 
EIP is at bus_reset+0x5f/0xe0
eax: 2002006c   ebx: f72b8e00   ecx: 00000001   edx: 00000001
esi: fffffffb   edi: 00000000   ebp: f76737c0   esp: f29d5ee0
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_13 (pid: 3775, threadinfo=f29d4000 task=f7479040)
Stack: c0340d04 00000066 f76737c0 00000286 00000000 f29d5f90 c027a308 f76737c0 
       00000286 f76737c0 00000000 00000000 c027a512 f76737c0 f763a400 00000000 
       f29d4000 f76737c0 f763a400 f29d5f88 f29d5f90 f763a400 c027aae4 f763a400 
Call Trace:
 [<c027a308>] scsi_try_bus_reset+0x58/0xf0
 [<c027a512>] scsi_eh_bus_reset+0x82/0x170
 [<c027aae4>] scsi_eh_ready_devs+0x64/0xa0
 [<c027ace1>] scsi_unjam_host+0xd1/0x200
 [<c0115e40>] default_wake_function+0x0/0x20
 [<c027af2f>] scsi_error_handler+0x11f/0x1d0
 [<c027ae10>] scsi_error_handler+0x0/0x1d0
 [<c0100f11>] kernel_thread_helper+0x5/0x14
Code: 24 04 0d 34 c0 e8 22 e9 e5 ff f0 ff 0b 0f 88 54 04 00 00 8b 43 28 be fb ff ff ff a9 00 00 20 00 75 14 8b 43 1c 8b 80 40 01 00 00 <80> 78 04 01 74 39 be f0 ff ff ff f0 ff 03 0f 8e 34 04 00 00 8b 

 This error is due to faulty cleanup/detach sequence in scsi layer.
More specifially, scsi_device_cancel() never gets called on hot-unplug
path.  If you have seen any oops with different reason, please share.

> 
> > The problem is that the device could have been torn down (surprise
> > ejection etc) when some of the routines that call scsi_allocate_request
> > run.  What's the actual problem this is trying to solve?
> 
> Same problem, SCSI blowing up with a hotplug device. Try with your
> pendrive, you should have no problem oopsing the kernel. As mentioned
> earlier in this thread, there are unsolvable reference counting problems
> between sdev and the request_queue right now.

 Currently, there are many issues even not including the reference
counting problem you're encountering.

 * scsi_device state is manipulated simultaneously without
   synchronization.
 * request cleanup doesn't synchronize with request processing
   and/or scsi_eh
 * when manual removal is requested via proc or sysfs no request
   cleanup is done.
 * things like domain validation need exclusive access, but
   currently, other special requests can enter during dv.
 * FS/PC requests become special requests after being requeued.

 I'm working on a new state machine with clean flushing.  I think it
will take a few more days.  The state machine will look like the
following.

 http://home-tj.org/scsi_state_machine.png

 Also, as drawing with dia was fun, I draw another diagram regarding
scsi midlayer.  This diagram helps thinking about how things are
referenced and where the roles are devided (scsi device/driver).

 http://home-tj.org/scsi_block_model.png

 Ignore todo notes below the diagram.

 So, please let me know about the reference counting problem you're
encountering.  I will incorporate it in the new state machine /
flushing patches.

 Thanks.

P.S. James, do you like the idea?

-- 
tejun

