From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 18:09:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030819180948.N8420@sistina.com>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061302795.2134.7.camel@fuzzy>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout02.sul.t-online.com ([194.25.134.17]:26518 "EHLO
	mailout02.sul.t-online.com") by vger.kernel.org with ESMTP
	id S271283AbTHSQQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 12:16:13 -0400
In-Reply-To: <1061302795.2134.7.camel@fuzzy>; from James.Bottomley@steeleye.com on Tue, Aug 19, 2003 at 09:19:53AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: mauelshagen@sistina.com, christophe.varoqui@free.fr, mge@sistina.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Aug 19, 2003 at 09:19:53AM -0500, James Bottomley wrote:
> On Tue, 2003-08-19 at 04:51, Heinz J . Mauelshagen wrote:
> > On Tue, Aug 19, 2003 at 11:04:31AM +0200, christophe.varoqui@free.fr wrote:
> > No, device-mapper is designed completely generic (LVM2 as well BTW).
> > It will never contain any vendor specific hacks.
> 
> We don't need it to contain any vendor code, but we do need an interface
> for vendor specific additions.

In case there's no more you need than the given target methods in
device-mapper (e.g. mapping and endio methods), you've got it already :)

> 
> How arrays accomplish a path switch is highly vendor specific.  Some
> (like EMC) run all paths active, so nothing needs doing.  Others need a
> specific command sent to the array down the path before the switch can
> be done.

I know and those private policies should not be addressed
in device-mapper but much rather in userspace so that there's accessible
paths once mapping tables are activated.

> 
> > Ghosts should report EIO in case of an unstarted LUN anyway ?
> > In case they are started they are supposed to report EPERM on IO because
> > they don't support any.
> 
> This is awfully vendor specific again.  I know, for example, the HP MSA
> array will report a check condition, not ready.  I think we translate
> this to I/O error in the mid-layer (best we can do).

Ok, fair enough. We know that we need better error reporting and
handling in 2.7.
Plus we need some decent "basic" error reported by such smart devices
so that we don't end up with piles of vendor specific modules.

Now I hear you say: "No chance short term" ;)
Right, that's why I'ld like to cover such hassle in userspace rather than
in the kernel if possible.

> This is why we'll
> do a better job of error reporting in fastfail.

:)

> 
> James
> 

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
