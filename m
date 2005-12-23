From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 12:05:32 -0800
Message-ID: <20051223200532.GI1112@andrew-vasquezs-powerbook-g4-15.local>
References: <200512212359.jBLNxluV016971@hera.kernel.org> <20051222221329.5f317b8d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32934 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1161030AbVLWUFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:05:38 -0500
Content-Disposition: inline
In-Reply-To: <20051222221329.5f317b8d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, 22 Dec 2005, Andrew Morton wrote:

> > +	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
> > +	struct scsi_target *starget = wqw->starget;
> > +	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> > +	unsigned long flags;
> > +
> > +	kfree(wqw);
> > +
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +
> > +	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> > +		list_del_init(&starget->siblings);
> > +		spin_unlock_irqrestore(shost->host_lock, flags);
> > +		device_del(&starget->dev);
> > +		transport_unregister_device(&starget->dev);
> > +		put_device(&starget->dev);
> > +		return;
> > +
> > +	}
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> > +
> > +	return;
> > +}
> 
> Given that this can run an arbitrary amount of time later on, how do we
> know that *shost is still live?

Hmm, I'm getting the following OOPS (consistently):

	Unable to handle kernel paging request at virtual address 6b6b6beb
	 printing eip:
	c01900c2
	*pde = 00000000
	Oops: 0002 [#1]
	SMP 
	Modules linked in: qla2xxx scsi_transport_fc
	CPU:    2
	EIP:    0060:[<c01900c2>]    Not tainted VLI
	EFLAGS: 00010282   (2.6.15-rc6) 
	EIP is at sysfs_hash_and_remove+0x31/0x11f
	eax: 00000000   ebx: 6b6b6b6b   ecx: 00000000   edx: ee6aac68
	esi: 6b6b6b6b   edi: f8839d44   ebp: f8839cc0   esp: c1af7e98
	ds: 007b   es: 007b   ss: 0068
	Process events/2 (pid: 16, threadinfo=c1af7000 task=c1aef030)
	Stack: c03998d2 00000063 eb6a0e2c eb6a0e24 f8839d44 f8839cc0 c025877b e640aac0 
	       ee000f5c ee000f5c 00000000 f8839cc0 f332e178 eb6a0e24 c025ab08 c025ab39 
	       eb6a0e24 c0370606 eb6a0e00 f332e178 c1af7f00 e5a872dc c025a722 f332e178 
	Call Trace:
	 [<c025877b>] class_device_del+0x138/0x163
	 [<c025ab08>] transport_remove_classdev+0x0/0x68
	 [<c025ab39>] transport_remove_classdev+0x31/0x68
	 [<c0370606>] klist_next+0x42/0x5c
	 [<c025a722>] attribute_container_device_trigger+0xcb/0xe2
	 [<c020524a>] kobject_put+0x1e/0x22
	 [<c025ab87>] transport_remove_device+0x17/0x1b
	 [<c025ab08>] transport_remove_classdev+0x0/0x68
	 [<c0294874>] scsi_target_reap_work+0xa4/0xbb
	 [<c012bcca>] worker_thread+0x1bf/0x24a
	 [<c02947d0>] scsi_target_reap_work+0x0/0xbb
	 [<c0117960>] default_wake_function+0x0/0x12
	 [<c0117960>] default_wake_function+0x0/0x12
	 [<c012bb0b>] worker_thread+0x0/0x24a
	 [<c0130021>] kthread+0xa3/0xcd
	 [<c012ff7e>] kthread+0x0/0xcd
	 [<c0101119>] kernel_thread_helper+0x5/0xb
	Code: 08 8b 44 24 1c 8b 58 18 8b 70 60 85 db 75 08 83 c4 08 5b 5e 5f 5d c3 c7 44 24 04 63 00 00 00 c7 04 24 d2 98 39 c0 e8 e7 93  
	 <6>ACPI: PCI interrupt for device 0000:03:01.0 disabled
	SysRq : Emergency Sync
	Emergency Sync complete

with this commit applied.

See previous post:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=113536796621377&w=2

must be the sixth day...

--
av
