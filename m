From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Fri, 27 Jul 2007 18:30:03 -0400
Message-ID: <1185575403.3434.24.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51102 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758721AbXG0WaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 18:30:20 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

On Fri, 2007-07-27 at 16:16 -0600, Moore, Eric wrote:
> On Friday, July 27, 2007 10:21 AM, wrote: 
> > 
> > The way your module parameter works is slightly counter intuitive.  On
> > all our other drivers, you can write a value into 
> > 
> > /sys/module/<module>/parameters/<debug parameter>
> > 
> > And have it acted on immediately.  In yours, it seems only to work
> > before the host is probed (because after that, the value in the ioc
> > structure is what's used).
> 
> not true,  the debug parameter can be configured prior to the host being
> probed.

That's what I just said ... if you mean can be configured *after* the
host being probed, then I think the parameter needs a
module_param_call() so you can intercept the set and update the ioc
structures accordingly.

>     We have a command line option called mpt_debug_level, that
> can set the debug level from mptbase.ko.  That way you can enable
> certain debug during probe time prior to the loading of
> mptsas/mptfc/mptspi. Once those upper drivers are loaded, you can toggle
> off and on the debug via the shost_attrib. This is explained in
> mptdebug.h.

Yes, but my point was that most other module parameters are settable
from /sys as well ... this one has some strange rules.

> > 
> > The other question is are you really sure you actually want per host
> > debugging?  is the added flexibility in being able to turn it 
> > on and off
> > per host worth the problems of explaining to the users where 
> > to find the
> > parameter?  I've got to bet that 95% of the installations only have a
> > single fusion card anyway.  would it not be simpler just to have a
> > global module parameter that can be set and acted on from 
> > /sys/modules?
> > 
> 
> I like having the added flexibility, and potential customers may agree.
> Our driver stack support multiple bus protocols, unlike other vendors,
> and some customers may ship fibre, sas, and spi in a single systems..
> For my personal use, I like being able to have per host debugging, as I
> have multiple cards in my systems.    There are several cases I've
> debugged two controller case, when boot OS is on one controller, and the
> debug efforts on another, in that case I only want to concern myself
> with the debug in question, not boot OS.  The method of debug usesage is
> in mptdebug.h, so I would think people would look there, and figure it
> out.  I also have a script below that sets all the host debug sas chips.
> Does this sound reasonable? If not, let me know.

OK fair enough ... I'm just pointing out it's non standard.

I really think the module parameter has to be hooked to act as a global
setting, but otherwise, this looks fine.

James


