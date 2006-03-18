From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] link scsi_debug later
Date: Sat, 18 Mar 2006 01:24:03 -0500
Message-ID: <441BA783.3030807@torque.net>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>	<20060317212924.11a86800.akpm@osdl.org> <20060317221920.3c84fc65.rdunlap@xenotime.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:32460 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1752066AbWCRGZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 01:25:51 -0500
In-Reply-To: <20060317221920.3c84fc65.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

Randy.Dunlap wrote:
> On Fri, 17 Mar 2006 21:29:24 -0800 Andrew Morton wrote:
> 
> 
>>"Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>>
>>>From: Randy Dunlap <rdunlap@xenotime.net>
>>>
>>>Link scsi-debug driver after SATA so that scsi-debug does not
>>>interfere with real SCSI device ordering.
>>>Yes, I was bitten by this.
>>>
>>
>>What does "bitten" mean?
> 
> 
> It means that I got the usual "VFS: could not find root filesystem on
> device (8,8)"  (or however it is spelled).
> Oh, and that I had to add netconsole to see what was causing it,
> but that is easy enough to do.
> 
> 
>>Is this a regression?
> 
> 
> It's probably been like this ever since SATA was added (libata)
> and only happens if SCSI_DEBUG=y (so I changed it to =m).
> I can't say that it's a regression since this occurred on a new
> machine.

Ah, if scsi_debug is a module, nothing is going to
load it automatically (at least the PCI subsystem
won't load it). However if it is built in then
it will "steal" /dev/sda (if some other SCSI LLD
hasn't already got it). That would then cause
a SATA driver to get /dev/sdb ... That is enough
to cause a kernel parameter like "root=/dev/sda8"
to flounder and give the "could not find root filesystem"
error.

A regression??
Hmm.

Doug Gilbert

