From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mptfusion - adding back the spin locks in eh handle
	 rs
Date: Thu, 23 Jun 2005 16:06:25 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C02DD8E97@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59091 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262766AbVFWWGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 18:06:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Luben

Ok - So you agree that completing Task management request
in the same context as the eh threads is the way to go, right?

Because that is what this LLD is doing.  Have you had
a chance to look at our code?

That previous patch submitted by Jeff(I guess) was removing code which
enabled interrupts.  My patch was restoring it back to previous
working code which doesn't hang the driver.

The reason that the previous patch hangs the driver is we are issuing
the task managment request using interrupt mode, not polling.
Meaning it requires interrupts to be enabled. 
As you probably know, you can't go to sleep when interrupts are disabled.
All eh entry points are called with interrupts disabled. Take a look
at scsi_try_bus_device_reset (scsi_error.c).

Eric

Luben Tuikov wrote:
> 
> 
> On 06/23/05 16:12, Moore, Eric Dean wrote:
> > Ok, explain that to me why having our driver hang is a good thing.
> > The task managment requests to our firmware stack are done 
> in interrupt
> > mode,
> > thus we have sleep and have interrupts enabled in the eh 
> threads waiting on
> > the commands to complete.
> > Christoph H. requested this change about 6 months ago, 
> asking that we remove
> > our watchdog timers in the eh threads, in favor of this design.
> 
> Hi Eric,
> 
> It is up to the LLDD to know how to deliver a TMF to the device.
> Whether this is done purely in process context (iSCSI) or
> in mixed context is up to the LLDD.
> 
> Also, most often than not, you'd want to wait for the TMF to
> return (iSCSI), to know its status (although you can assume 
> it without fault).
> 
> Nevertheless, calling the eh routines in process context is the way
> to go. (in order to allow for "sleeping", on delivery you can 
> disable ints
> as appropriate for the hw)
> 
> 	Luben
> 
