From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Sat, 24 Jul 2004 20:19:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4102FC9D.1060100@optonline.net>
References: <40FD38A0.3000603@optonline.net> <20040720155928.GC10921@atrey.karlin.mff.cuni.cz> <40FD4CFA.6070603@optonline.net> <20040720174611.GI10921@atrey.karlin.mff.cuni.cz> <40FD6002.4070206@optonline.net> <1090347939.1993.7.camel@gaston> <40FD65C2.7060408@optonline.net> <1090350609.2003.9.camel@gaston> <40FD82B1.8030704@optonline.net> <1090356079.1993.12.camel@gaston> <40FD85A3.2060502@optonline.net> <1090357324.1993.15.camel@gaston> <410280E9.5040001@optonline.net> <1090684826.1963.6.camel@gaston> <41029215.1030406@optonline.net> <1090694118.1971.13.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.allegientsystems.com ([208.251.178.227]:65289 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S263429AbUGYATF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jul 2004 20:19:05 -0400
In-Reply-To: <1090694118.1971.13.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-scsi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>

Benjamin Herrenschmidt wrote:

> That's different, because the disks are actually registered as
> "struct device" childs of the bus, and thus get proper suspend/resume
> callbacks.

Ok, Seems like we rely on the BIOS a lot, here.

> Oh sure, the disks are in the loop, the problem happens with multipath
> and such which "breaks" the bus hiearchy somewhat. The queue management
> is part of the "functional" hierarchy (read: block layer) on top of
> SCSI disks, thus the disks will be the one getting the suspend callback,
> but they have to "notify" their functional parent (block layer, md, ...)
> to properly get the queues stopped.

All right, I can see where that's probably the easiest solution.

> IDE sort-of does that internally, by generating a special request that
> goes down the queue (in order to be properly ordered with whatever
> is pending in the queue, including pending tagged commands if any),
> and the "toplevel" IDE handling will stop processing the queue once
> that request got past, but it's a hackery that at this point is quite
> specific to drivers/ide/

The queued special command trick does mostly the same thing as the 
scsi_device_quiesce(), right? As far as I can tell, the only difference 
is that we attempt to drain the queue (and sometimes leave error 
handlers running) and they just pause it at some mostly sane stopping point.

Now correct me if I'm wrong, but it seems that with what we understand 
now, we are in a position that we could decide to make SCSI layer do the 
following on suspend, in this order:

scsi_device_quiesce();
{ LLD pause and flush work; aic7xxx will run the completion queue at 
this point }
blk_stop_queue();
{ LLD reset registers and shutdown, etc }

And once the MD problem is solved we will also need to do another call 
before blk_stop_queue().

Am I missing anything?

