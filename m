From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Thu, 8 Mar 2007 10:02:47 +0100
Message-ID: <20070308090247.GB9671@kernel.dk>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk> <20070308085209.GB4252@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:53336 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030352AbXCHJEB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 04:04:01 -0500
Content-Disposition: inline
In-Reply-To: <20070308085209.GB4252@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, Mar 08 2007, Andre Noll wrote:
> On 19:46, Jens Axboe wrote:
> > On Wed, Feb 28 2007, Andre Noll wrote:
> > > On 16:18, Andre Noll wrote:
> > > 
> > > > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > > > writing to both raid systems at the same time via lvm still locks up
> > > > the system within minutes.
> > > 
> > > Screenshot of the resulting kernel panic:
> > > 
> > > 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> > 
> > Do you have the full oops as well?
> 
> Unfortunately not, as there's no way to scroll up after a kernel panic
> (the screenshot was taken by using a KVM switch which just sends the
> video output over ethernet).

Do you still have the vmlinux? It'd be interesting to see what

$ gbd vmlinux
(gdb) l *cfq_dispatch_insert+0x28

says, here that'd be cfqq dereference. And that must be valid, it's set
on allocation time and only cleared after free. So unless lvm issues
private requests that aren't properly allocated, this whole thing looks
very bizarre.

-- 
Jens Axboe

