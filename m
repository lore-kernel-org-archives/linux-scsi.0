From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used for aha1542" at boot time
Date: Fri, 20 Feb 2004 09:38:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220083808.GA11822@suse.de>
References: <20040218171212.0eb6618a.akpm@osdl.org> <1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:34220 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267733AbUBTIiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 03:38:14 -0500
Content-Disposition: inline
In-Reply-To: <1077265837.1297.9.camel@felicia>
List-Id: linux-scsi@vger.kernel.org
To: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 20 2004, Dr. Ernst Molitor wrote:
> Dear James Bottomley, 
> 
> thank you very much for looking into the problem I have seen. 
> 
> Following to your kind suggestion, I have commented out the two "panic
> (... Buffers and physical address > 16Mb ...)" lines in the aha1542.c
> source and added "BUG();"-lines in their places. Booting the kernel
> built afterwards resulted in a bunch of messages; I haven't been able to
> read the first lines; this is what I could copy:
> 
> [<c02ee972>] scsi_request_fn+0x1c2/0x310
> [<c02aa35d>] __elv_add_request+0x2d/0x50
> [<c02aca14>] blk_insert_request+0x84/0xc0
> [<c02ed679>] scsi_insert_special_req+0x39/0x40
> [<c02ed8a9>] scsi_wait_req+0x69/0xb0
> [<c02ed7c0>] scsi_wait_done+0x0/0x80
> [<c0319980>] sr_do_ioctl+0x90/0x290
> [<c0319735>] sr_packet+0x25/0x40
> [<c0320262>] cdrom_is_mrw+0x52/0x80
> [<c03194b0>] get_capabilities+0x1d0/0x430
> [<c023d87f>] sprintf+0x1f/0x30
> [<c0318fd1>] sr_probe+0x1f/0x30
> [<c02a736d>] bus_match+0x3d/0x70
> [<c02a74ac>] driver_attach+0x5c/0xa0
> [<c02a77c6>] bus_add_driver+0xa6/0xc0
> [<c05422ff>] init_sr+0x2f/0x40
> [<c05289db>] do_initcalls+0x2b/0xa0
> [<c01317d2>] init_workqueues+0x12/0x29
> [<c01050ec>] init+0x4c/0x150
> [<c01050a0>] init+0x0/0x150
> [<c010719d>] kernel_thread_helper+0x5/0x18
>  
> Code: 0f 0b 3e 00 c2 5a 43 c0 89 ec 5d c3 8d 76 00 8d bc 28 00 00
> <0>Kernel panic: Attempted to kill init!
> 
> Please don't hesitate to contact me if I can be of any further help in
> this matter.

Hmm... James, sr_do_ioctl() used to do bouncing for private commands,
any reason it doesn't do that anymore?

-- 
Jens Axboe

