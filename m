From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Clarification for Persistent Reservation + All Registrants
Date: Sat, 13 Dec 2014 22:27:27 -0800
Message-ID: <1418538447.5431.56.camel@haakon3.risingtidesystems.com>
References: <1418425163.10743.61.camel@haakon3.risingtidesystems.com>
	 <1418428361.2270.13.camel@HansenPartnership.com>
	 <1418435595.10743.130.camel@haakon3.risingtidesystems.com>
	 <1418456023.2351.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1418456023.2351.1.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "t10@t10.org" <t10@t10.org>, target-devel <target-devel@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-12-13 at 08:33 +0100, James Bottomley wrote:
> On Fri, 2014-12-12 at 17:53 -0800, Nicholas A. Bellinger wrote:
> > On Sat, 2014-12-13 at 00:52 +0100, James Bottomley wrote:
> > > On Fri, 2014-12-12 at 14:59 -0800, Nicholas A. Bellinger wrote:
> > > > Hello T10/SCSI folks,
> > > > 
> > > > A question came up on the LIO target-devel mailing list recently wrt the
> > > > proper handling of Persistent Reservations + All Registrants logic in a
> > > > couple of different scenarios.

<SNIP>

> > > > How about when the explicit reservation is removed..?  Do the implicit
> > > > reservations need to remain in effect for the existing registrations,
> > > > even though the explicit reservation of All Registrants type no longer
> > > > exists..?
> > > 
> > > Again, I don't understand the distinction between implicit and explicit.
> > > For an all registrants reservation, all registered initiators are the
> > > reservation holder so any one of them may release the reservation.  Once
> > > the reservation is released, there's no reservation at all.
> > 
> > So some initiator still needs to perform the actual RESERVE, right..?
> 
> Yes, there's no reservation until a reserve is issued.
> 
> > That is, a number of registrations don't become 'implicit' reservation
> > holders until one initiator performs an 'explicit' RESERVE with type=All
> > Registrants.
> 
> Once one initiator issues an all registrants reservation, all registants
> become the reservation holder.
> 
> > > > The second point that Ilias raised is what should be the correct
> > > > R_HOLDER bit status for PRIN READ_FULL_STATUS descriptors when All
> > > > Registrants type is specified.  My original interpretation was that
> > > > R_HOLDER was to signal the explicit reservation holder obtained with
> > > > PR-OUT RESERVE, and not for the implicit reservations from the other
> > > > registrations.  Is this the correct approach..?
> > > 
> > > R_HOLDER is set for any initiator that would be defined to be the
> > > persistent reservation holder in section 5.6.9
> > > 
> > 
> > Well, section 5.6.9 only mentions the use of RESERVE, so that would seem
> > to indicate the original interpretation + current code for
> > READ_FULL_STATUS is correct.
> 
> It should be set for every registered initiator in the all registrants
> case (because they're all the reservation holder).
> 

Thanks for the clarification on this.

> > > > Also, does anyone have any experience with a host side implementation of
> > > > All Registrants to use as a reference for what's already out in the
> > > > wild..?
> > > 
> > > I know what was negotiated to support clustering (which is a pretty tiny
> > > subset).  However, I think your point of confusion is trying to
> > > distinguish between what you call implicit and explicit reservations ...
> > > there's no such thing.  There's only a reservation holder which may be
> > > many initiators, So it's binary: a given initiator either is or is not
> > > the reservation holder.  Section 5.6 needs to be read in that context.
> > > 
> > 
> > The confusion is around when registrations who don't issue an explicit
> > RESERVE become implicit reservation holders.  Is it when one initiator
> > does an explicit RESERVE + type=All Registrants, or is it when REGISTER
> > + type=All Registrants occurs..?
> 
> There is no reservation until a reserve command is issued.  Once an all
> registrants reservation is issued, by any registered initator, all
> registered initators then become the reservation holder.
> 

So based on the above, the issue raised by Ilias where once the original
All Registrants reservation is released, the other registrations lose
their 'implicit' reservation until someone does another RESERVE +
type=All Registrants is a bug.

Working on a proper bugfix for this now.

Thanks James!

--nab
