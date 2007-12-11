From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
	directory) (fwd)
Date: Tue, 11 Dec 2007 15:40:34 +0100
Message-ID: <1197384034.19679.13.camel@n2o.xs4all.nl>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz>
	 <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de>
	 <20071130021226T.tomof@acm.org>  <20071130103450.GC7697@1und1.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3808 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXLKPCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 10:02:43 -0500
In-Reply-To: <20071130103450.GC7697@1und1.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anders Henke <anders.henke@1und1.de>
Cc: FUJITA Tomonori <tomof@acm.org>, matthew@wil.cx, jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, miquels@cistron.nl

On Fri, 2007-11-30 at 11:34 +0100, Anders Henke wrote:
> Am 30.11.2007 schrieb FUJITA Tomonori:
> > > > > According to the 2.6.23-rc1 short-form changelog, there is
> > > > > one major edit on the dpt_i2o driver:
> > > > > 
> > > > > FUJITA Tomonori 
> > > > > 
> > > > >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > > > > 
> > > > > Stephen Rothwell 
> > > > >       dpt_i2o depends on virt_to_bus
> > > > > 
> > > > > Fujita, would you please take a look at this?
> > > > 
>
> In between, I've ruled out that the static assignment isn't
> source of the problem.  And due to some manually made "make clean" which 
> didn't clean enough, I've also pointed out the wrong patch - sorry,
> Fujita, definitely the right one which breaks my boxes is the dpt_i2o patch 
> from 2.6.23-rc2 to 2.6.23-rc3 (7 kb in Size) from Matthew Wilcox.
> 
> commit 55d9fcf57ba5ec427544fca7abc335cf3da78160
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Mon Jul 30 15:19:18 2007 -0600
> 
>     [SCSI] dpt_i2o: convert to SCSI hotplug model

I just noticed the same bug when I tried to update a 2.6.18 server to
2.6.23.9 .. also tried 2.6.24-rc4. The symptom I'm seeing is that init
segfaults, or can't be found .. anyway, driver/fs errors.

In the kernel config, under "processor type and features", I disabled
"64GB memory" support (changed to 4GB) and I also disabled "64 bit
Memory and IO resources" and the problem went away. Do you by any chance
happen to have those features enabled ?

The dpt_i2o driver is not 64-bit clean, it happens to work with
PAE/64-bit dma in earlier kernels but that might be by chance. Perhaps
the different initialization ordering exposes the problem.

I got the 64-bit dpt_i2o driver from Adaptec some time ago, and I have
added 64-bit support to the 2.6.23.1 dpt_i2o driver based on that
driver. I intended to submit it for 2.6.25 or so ... if I have some time
later today or tomorrow I'll try that next to see if that makes a
difference.

Mike.

