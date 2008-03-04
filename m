From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: scsi: fix target reset handling
Date: Tue, 04 Mar 2008 12:00:34 -0600
Message-ID: <1204653634.3091.47.camel@localhost.localdomain>
References: <47CD68F9.5060108@cs.wisc.edu>
	 <664A4EBB07F29743873A87CF62C26D70D55464@NAMAIL4.ad.lsil.com>
	 <61DA31637BAF774FB13AC59B6381C080A9CFC1@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49262 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761135AbYCDSAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 13:00:43 -0500
In-Reply-To: <61DA31637BAF774FB13AC59B6381C080A9CFC1@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hagan, Steve" <Steve.Hagan@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx, "Rivera, Peter" <Peter.Rivera@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tue, 2008-03-04 at 10:40 -0700, Hagan, Steve wrote:
> Windows (StorPort drivers) supports LUN, target, and bus resets in a
> hierarchical fashion.  If an I/O times out, Storport will issue a LUN
> reset first.  If that fails, it will escalate to a target reset.  If
> that fails, it will escalate to a bus reset.
> 
> What does "fail" mean?

Fail means the driver was unable to perform the action.  i.e failure of
a LUN reset means we couldn't get the TMF out.

>   If the TM request returns with a non-success
> status, or if there are outstanding I/O's for the scope of the reset
> remaining after we receive the TM reply, then the reset is considered
> failed.

Outstanding I/O is a dubious point.  Your driver could have outstanding
I/O for the LUN after a LUN reset, but if the device correctly executed
it, it will have cleared its queue.

>   Our miniport driver will return error status back to Storport
> and it will escalate to the next level of reset.  A bus reset cannot be
> failed back to Storport.  If a bus reset fails (as above) then the only
> recourse if for the miniport to do a hard reset of the adapter and
> return all outstanding I/O's with reset status.

That's pretty much what the default error handler does.

James


