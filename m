From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: Fri, 16 Jul 2004 19:51:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040716175118.GG11255@suse.de>
References: <20040716160224.GA2402@suse.de> <1089994751.4844.5.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:57809 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266565AbUGPRwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 13:52:37 -0400
Content-Disposition: inline
In-Reply-To: <1089994751.4844.5.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 16 2004, Pat LaVarre wrote:
> Jens A:
> 
> > Have you tested it works as expected as well, with
> > rw and ro media?
> 
> Ouch, yes, please, never assume I've tested unless I say so explicitly.
> 
> So far I've just seen the expected, with one rewritable and one
> read-only disc, in a pair of USB and PATAPI drives:
> 
> $ sudo plscsi /dev/scd0 /dev/hdd
> export PLSCSI=/dev/scd0       // B Iomega   RRD              DB76
> export PLSCSI=/dev/hdd        // @ Iomega   RRD              74.B
> $
> $ sudo blockdev --getro /dev/scd0 /dev/hdd
> 0
> 0
> $
> $ sudo dd of=/dev/scd0 bs=64K seek=0 count=1 if=/dev/zero
> dd: opening `/dev/scd0': Read-only file system
> $ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
> 1+0 records in
> 1+0 records out
> $
> $ # swap discs
> $
> $ sudo dd of=/dev/scd0 bs=64K seek=0 count=1 if=/dev/zero
> 1+0 records in
> 1+0 records out
> $ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
> dd: opening `/dev/hdd': Read-only file system
> $

Looks good, thanks.

> > looks perfect!
> 
> Excellent, I conclude I have understood correctly.

You have.

> > Have you tested ...
> 
> I trust you will tell me if I can help further.

I'll start by forwarding this patch, so it at least will work in 2.6.8.

-- 
Jens Axboe

