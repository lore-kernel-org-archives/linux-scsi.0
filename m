From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: 09 Apr 2004 14:19:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081538374.2202.157.camel@mulgrave>
References: <1081518779.2203.29.camel@mulgrave>
	<20040409095657.A2970@beaverton.ibm.com>
	<20040409101729.A3121@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261668AbUDITTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 15:19:36 -0400
In-Reply-To: <20040409101729.A3121@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Fri, 2004-04-09 at 12:17, Patrick Mansfield wrote:
> I spoke a bit too soon, a remove module is giving me an oops.
> 
> Running scsi-misc-2.6 + this patch. I did not try scsi-misc-2.6 plain.
> 
> I loaded the qla2300 module, removed a single lun via the sysfs interface,
> and then rmmod qla2300.
> 
> Let me know if you need any other information.
> 
> elm3b79.beaverton.ibm.com login: Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> c01ea4b3
> *pde = 33da1001
> Oops: 0000 [#1]
> SMP 
> CPU:    2
> EIP:    0060:[<c01ea4b3>]    Not tainted
> EFLAGS: 00010286   (2.6.5-rc2) 
> EIP is at scsi_device_set_state+0xa3/0xe4
> eax: 00000000   ebx: 00000004   ecx: 00000003   edx: 00000018
> esi: f416f000   edi: c02eae38   ebp: f3d22000   esp: f3d23e94
> ds: 007b   es: 007b   ss: 0068
> Process modprobe (pid: 1493, threadinfo=f3d22000 task=f3e6a6d0)
> Stack: f416f1e0 c02b5688 c02b5690 00000003 f416f000 f4182000 c01ec39a f416f000 
>        00000003 f3e40000 f4182000 c01eba42 f416f000 f3e40000 f4ba0c44 c01e57cd 
>        f3e40000 f3e40000 f3e40000 00000000 f3e401c8 f88af667 f3e40000 f3e400e8 
> Call Trace:
>  [<c01ec39a>] scsi_remove_device+0xe/0x88
>  [<c01eba42>] scsi_forget_host+0x32/0x60

This looks odd.  I'm guessing that scsi_device_set_state+0xa3/0xe4 is
right around the dev_printk() in the illegal: label?

I'm guessing it did this because the driver had already detached so the
dev->driver->name deref is the NULL pointer one.

Really, we need to make dev_printk a lot more robust if it's actually
going to be useful.  Can you fix it and then tell me what the illegal
state transition actually was?

I guess it's because we don't drop off the siblings list until release
time, and the device was already being deleted.

Thanks,

James


