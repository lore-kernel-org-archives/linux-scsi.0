From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 14:35:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030819143552.K8420@sistina.com>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout05.sul.t-online.com ([194.25.134.82]:47013 "EHLO
	mailout05.sul.t-online.com") by vger.kernel.org with ESMTP
	id S270416AbTHSMmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 08:42:21 -0400
In-Reply-To: <1061290087.3f4200678f811@impt2-2.free.fr>; from christophe.varoqui@free.fr on Tue, Aug 19, 2003 at 12:48:07PM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: mauelshagen@sistina.com, mge@sistina.com, linux-scsi@vger.kernel.org

On Tue, Aug 19, 2003 at 12:48:07PM +0200, christophe.varoqui@free.fr wrote:
> Selon "Heinz J . Mauelshagen" <Heinz.Mauelshagen@t-online.de>:
> 
> > Ghosts should report EIO in case of an unstarted LUN anyway ?
> > In case they are started they are supposed to report EPERM on IO because
> > they don't support any.
> > 
> All I can say is that it blocks pvscan for a looong time. I havn't had the
> patience to see if it finaly abords.

:(
Then set up a device filter in lvm.conf to avoid access.

> 
> > Even reporting EPERM in both cases would be sufficient, because IO
> > will never make it through a ghost. Blocking makes no sense to me at all.
> > 
> That's the vendor-specific issue I talk about : other controlers certainly
> return errors, other activate the path on IO submission (with or without
> penalty). HSV simply blocks.

Well, error-reporting and handling in Linux is "weak" anyway.
More 2.7 work (as kernel hackers know) including standards for vendor
specific drivers ITR.

> 
> > There's various "flavours" where to put multipath into the io chain.
> > Kernel hacker conclusion is in device-mapper.
> > 
> No problem with that

:)

> 
> > Multipathing is a device-mapper target and therefore offers a general kernel
> > service to be used by arbitrary applications.
> > LVM2 is the one from us supporting that in the future.
> > 
> Does it mean the multipath tools from you will be packaged in the lvm compound
> binary, or as an independant set ?

In the LVM2 binray.

> 
> > Other LVM applications are free to implement a different model.
> > 
> > Device-mapper has no clue of volume management metadata. LVM2 has.
> >
> > We need better device recovery in Linux (which will happen in the Linux 2.7
> > series later). PV UUIDs enable LVM2 to discover PVs.
> > 
> Yes, but does it mean _your_ multipath tools will need PV UUIDs ?

Yes.

> Will these tools be relevant outside of LVM2 volume management scope, as for
> them to become "standard" ?

No restriction that the part of the LVM2 lib could, it's LGPLed.

> 
> > I much rather prefer a cleaner ghosts implementation not blocking
> > critical applications.
> > 
> The ghost behaviour being vendor-specific, policy belongs to userspace. If the
> vendor says the ghost does not respond to IO, then it's up to userland to
> instruct the kernel to not submit IO to it (ie set device mappings).

Sorry, this sounds like a workaround mess with arbitrary vendor specific
drivers and their behaviours. As said: we can filter such devices out
in LVM2.

> As you plan to package a set of userspace tools for multipath management, you
> should allow plugins implementing those policies.

Overkill because of missing standard(s). I much rather prefer
enhanced and correct error reporting.

And as said above: no need because we can easily filter out device nodes
which don't allow (IO) access.

> 
> regards,
> cvaroqui

-- 

Regards,
Heinz    -- The LVM Guy --

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Sistina Software Inc.
Senior Consultant/Developer                       Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@Sistina.com                           +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
