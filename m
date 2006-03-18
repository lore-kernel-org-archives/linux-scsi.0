From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] link scsi_debug later
Date: Sat, 18 Mar 2006 11:07:32 -0800
Message-ID: <20060318110732.bbb2fe87.rdunlap@xenotime.net>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>
	<20060317212924.11a86800.akpm@osdl.org>
	<20060317221920.3c84fc65.rdunlap@xenotime.net>
	<441BA783.3030807@torque.net>
	<1142688164.3241.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:5567 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750822AbWCRTFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 14:05:30 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 11:05:28 -0800
In-Reply-To: <1142688164.3241.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, akpm@osdl.org, linux-scsi@vger.kernel.org

On Sat, 18 Mar 2006 07:22:44 -0600 James Bottomley wrote:

> On Sat, 2006-03-18 at 01:24 -0500, Douglas Gilbert wrote:
> > Ah, if scsi_debug is a module, nothing is going to
> > load it automatically (at least the PCI subsystem
> > won't load it). However if it is built in then
> > it will "steal" /dev/sda (if some other SCSI LLD
> > hasn't already got it). That would then cause
> > a SATA driver to get /dev/sdb ... That is enough
> > to cause a kernel parameter like "root=/dev/sda8"
> > to flounder and give the "could not find root filesystem"
> > error.
> 
> Is there actually any purpose for not compiling scsi_debug as a module?
> i.e. isn't the problem really that we simply shouldn't allow it to be
> built directly into the kernel and it should only be compilable as a
> module?

I don't see a need to be that restrictive about it.
As long as SCSI_DEBUG is last, it won't affect the device order
(boot or other devices), which is the problem IMO.

Yes, the scsi-debug device(s) could become different devices
depending on what other SCSI devices were found, so maybe someone's
scripts would have to change (scripts should be flexible :).
But that would also happen if SCSI_DEBUG=m.

Anyway, I'll let Doug/James decide.

---
~Randy
