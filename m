From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] Qlogic's 16G FC/FCoE HBA support
Date: Wed, 21 May 2014 12:21:18 -0500
Message-ID: <201405211721.s4LHLIgE015972@wind.enjellic.com>
References: <steve.magnani@digidescorp.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:57072 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbaEURaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2014 13:30:05 -0400
In-Reply-To: Steve Magnani <steve.magnani@digidescorp.com>
       "Re: [Scst-devel] Qlogic's 16G FC/FCoE HBA support" (May 21,  7:40am)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Magnani <steve.magnani@digidescorp.com>, Duane Grigsby <duane.grigsby@qlogic.com>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

On May 21,  7:40am, Steve Magnani wrote:
} Subject: Re: [Scst-devel] Qlogic's 16G FC/FCoE HBA support

> Thanks Duane, and QLogic.

Hi, hope the day is going well for everyone.  A thank you to Qlogic
from us as well for this work.

I was going to reply back to Duane's note last night but after a 21+
hour work day I collapsed before I could do that, so Steve beat me to
it.

Comments below since we have a vested interest in all this too.

I've included linux-scsi on this since that is where the Qlogic driver
discussions/patches take place and Nicholas and company would seem to
have a vested interest in all this as well.

> I have just finished a merge of this code into my software platform, 
> which follows SCST trunk.
> If my analysis is correct, the QLogic tree's closest relatives are:
> 
> * [SCST]https://svn.code.sf.net/p/scst/svn/branches/2.2.x@4731
> * [mainline] linux-3.15-rc1

> I am very interested in how the two SCST code bases can be
> reunified. I think that's in everyone's interest, since the code in
> QLogic's tree supports dual initiator/target mode whereas the code
> currently in the SCST tree does not (I suspect due to FC login
> issues).

A year ago we had to bring up a big production FCOE storage network on
Qlogic hardware so we bit the bullet and did what we thought was
needed to 'fix' this problem.  We have done a lot of software
development and have yet to see anything good come from having
multiple divergent code bases attempting to solve the same problem.

Duane, I'm not sure how closely you and Qlogic follow all this, but
our fix was to follow the Linux kernel Qlogic driver model and write
an interface driver which allows SCST to platform on top of the
in-kernel Qlogic target support.  This solution is available at the
following URL:

	ftp://ftp.enjellic.com/pub/scst/sqa_driver-1.1.tar.gz

It uses the same callback infrastructure and support which the LIO
in-kernel SCSI target solution uses.  The only thing it 'needs' beyond
that is about a 6 line exported callback function from qla_target.c so
SCST can enumerate the interfaces which the driver core is supporting
target mode on.

Using this strategy both Linux based SCSI target communities are
sitting on the same driver base which seems like a 'good thing' long
term.  I believe Steve has tested this configuration and the dual
initiator/target mode is problematic with the in-kernel target but I'm
assuming support could either be integrated or added if in-kernel
support was aesthetically or politically impalatable.

I would gladly submit a patch to add the callback function but have
not done so since we don't have the time or voice strength for
political arguements.  I've heard that Qlogic 'controls' the Linux
kernel driver so I'm assuming if you were interested we could make
this happen.

The only fly in this ointment would be if Qlogic thinks there are some
kind of inherent deficiencies in the in-kernel target driver or
interface architecture which would make something like this
unpalatable.  I know we and others would certainly be interested in
knowing if this were the case since it raises issues with a lot of
people who are building storage solutions.

Since all of the relevant Qlogic target solutions are outgrowths of
what seems to be a common code base building on this common base would
seem to be to the advantage of everyone involved.

> Regards,
> ------------------------------------------------------------------------
>   Steven J. Magnani               "I claim this network for MARS!

Steve, thanks for bringing up the common codebase issue.

Best wishes to everyone, at least in the US, for a pleasant holiday
weekend.

Greg

}-- End of excerpt from Steve Magnani

As always,
Dr. G.W. Wettstein, Ph.D.   IDfusion.org
4206 N. 19th Ave.           Unified health identity architecture.
Fargo, ND  58102
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@idfusion.org
------------------------------------------------------------------------------
"My thoughts on the composition and effectiveness of the advisory
 committee?

 I think they are destined to accomplish about the same thing as what
 you would get from locking 9 chimpanzees in a room with an armed
 thermonuclear weapon and a can opener with orders to disarm it."
                                -- Dr. Greg Wettstein
                                   Resurrection
