From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Fri, 9 Apr 2004 12:57:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040409125737.A4996@beaverton.ibm.com>
References: <1081518779.2203.29.camel@mulgrave> <20040409095657.A2970@beaverton.ibm.com> <20040409101729.A3121@beaverton.ibm.com> <1081538374.2202.157.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:21167 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261668AbUDIT5m
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 15:57:42 -0400
Content-Disposition: inline
In-Reply-To: <1081538374.2202.157.camel@mulgrave>; from James.Bottomley@SteelEye.com on Fri, Apr 09, 2004 at 02:19:34PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Fri, Apr 09, 2004 at 02:19:34PM -0500, James Bottomley wrote:
> This looks odd.  I'm guessing that scsi_device_set_state+0xa3/0xe4 is
> right around the dev_printk() in the illegal: label?

Yep.

> I'm guessing it did this because the driver had already detached so the
> dev->driver->name deref is the NULL pointer one.
> 
> Really, we need to make dev_printk a lot more robust if it's actually
> going to be useful.  

IMO we should have a sdev_printk not using dev_printk, as during
scan/remove time we use all the normal code paths, and we don't have a
driver bound at those times. We could also bind a "dummy" driver and still
use dev_printk, but that could be problematic given the removing and
adding races.

> Can you fix it and then tell me what the illegal
> state transition actually was?

OK.

> I guess it's because we don't drop off the siblings list until release
> time, and the device was already being deleted.

I ran the delete a few seconds before the modprobe -r, the delete should
have been complete. The device being deleted was not open at the time.

Here is the stack and debug output:

scsi device <6:0:3:0> Illegal state transition deleted->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1646
Call Trace:
 [<c01ea4d8>] scsi_device_set_state+0xc8/0xd4
 [<c01ec38a>] scsi_remove_device+0xe/0x88
 [<c01eba32>] scsi_forget_host+0x32/0x60
 [<c01e57cd>] scsi_remove_host+0x19/0x48
 [<f88b5667>] qla2x00_remove_one+0x6f/0x8c [qla2xxx]
 [<f88cf022>] qla2300_remove_one+0xa/0x10 [qla2300]
 [<c01a5fe2>] pci_device_remove+0x1a/0x34
 [<c01c77aa>] device_release_driver+0x46/0x58
 [<c01c77d9>] driver_detach+0x1d/0x2c
 [<c01c79b5>] bus_remove_driver+0x29/0x5c
 [<c01c7ceb>] driver_unregister+0xb/0x1f
 [<c01a6166>] pci_unregister_driver+0xe/0x1c
 [<f88cf032>] qla2300_exit+0xa/0x10 [qla2300]
 [<c012d0d5>] sys_delete_module+0x141/0x174
 [<c01405f0>] sys_munmap+0x38/0x58
 [<c0106b93>] syscall_call+0x7/0xb
