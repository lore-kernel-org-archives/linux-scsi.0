From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: QLogic (qla2100 / qlogicfc)
Date: Tue, 9 Mar 2004 21:39:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310053950.GA25105@praka.local.home>
References: <Pine.GSO.4.33.0403092023560.28488-100000@sweetums.bluetronic.net>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:32978 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262238AbUCJGB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 01:01:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0403092023560.28488-100000@sweetums.bluetronic.net>
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Tue, 09 Mar 2004, Ricky Beam wrote:

> [the facts]
> Both qla2100 and qlogicfc fail when attempting to format a 7 disk raid5
> array.  This is especially true if I format more than one array at a time
> (I actually tried up to 4.)  In my experience, both drivers are broken --
> one more inventively than the other.
> 

Ok, I'll see what I can do to help you out with the qla2xxx driver.

> Now for qla2100... It appears to work, but then trips over it's shoelaces
> and never manages to get back up.  A command times out:
> cmd_timeout: Entering sp->state = 2
> cmd_timeout: Found in ISP
> cmd_timeout: Entering sp->state = 2
> cmd_timeout: Found in ISP
> cmd_timeout: Leaving
> cmd_timeout: Leaving

Yes, but even before the timeouts occur, there appear to be some
questionable events occuring with the firmware:

	qla2100 0000:06:03.0: ISP System Error - mbx1=18d1h mbx2=ch mbx3=11h.
	qla2100 0000:06:03.0: Failed to dump firmware (256)!!!
	qla2x00: DPC handler waking up
	scsi(0): DPC handler
	scsi(0): dpc: sched qla2x00_abort_isp ha = f71481d4
	qla2100 0000:06:03.0: Performing ISP error recovery - ha= f71481d4.

The ISP2100 has not been a supported chip for some time now, but, I'll
see if I can get some information from the firmware group regarding
the events that led-up to this system-error.

I've also been gathering a short-dozen or so patches that I was
planning on forwarding to linux-scsi towards the end of the week.
When I get in tomorrow, I'd like to forward you a couple of them for
some additional testing, if you don't mind?

> [See also: http://sweetums.bluetronic.net/~jfbeam/QLogic/]
>  + kernel config (I turned preempt off; it made no difference)
>  + console messages (minicom.cap-X)
>  + qla_XXX.h (debug settings)
>  + qlogicfc driver + diff
> 

I appreciate your initiative in enabling some of the debug settings of
the driver and posting the resultant messages, it certainly makes
troubleshooting problems a bit easier.

Regards,
Andrew Vasquez
QLogic Corporation
