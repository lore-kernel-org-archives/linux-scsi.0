From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Clarification for Persistent Reservation + All Registrants
Date: Sat, 13 Dec 2014 08:33:43 +0100
Message-ID: <1418456023.2351.1.camel@HansenPartnership.com>
References: <1418425163.10743.61.camel@haakon3.risingtidesystems.com>
	 <1418428361.2270.13.camel@HansenPartnership.com>
	 <1418435595.10743.130.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56832 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965655AbaLMHds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2014 02:33:48 -0500
In-Reply-To: <1418435595.10743.130.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "t10@t10.org" <t10@t10.org>, target-devel <target-devel@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2014-12-12 at 17:53 -0800, Nicholas A. Bellinger wrote:
> On Sat, 2014-12-13 at 00:52 +0100, James Bottomley wrote:
> > On Fri, 2014-12-12 at 14:59 -0800, Nicholas A. Bellinger wrote:
> > > Hello T10/SCSI folks,
> > > 
> > > A question came up on the LIO target-devel mailing list recently wrt the
> > > proper handling of Persistent Reservations + All Registrants logic in a
> > > couple of different scenarios.
> > 
> > I can tell you how it was originally designed over a decade ago to
> > support clustering products (being in the business then of negotiating
> > with the manufacturers).
> > 
> > > The crux of the confusion stems from how registrations are treated
> > > before an explicit PR-OUT RESERVE service action with All Registrants
> > > type occurs, and after that explicit PR-OUT RESERVE of All Registrants
> > > type has been released.
> > > 
> > > My original interpretation was that an explicit PR-OUT RESERVE with All
> > > Registrants type had to first occur before other non reservation holding
> > > registrations (existing or not) would gain the implicit reservation.
> > 
> > You seem to be asking in the presence of registrations would an
> > unregistered initiator receive a reservation conflict before the PR_OUT
> > RESERVE is issued?  The answer, categorially is no because there's no
> > reservation until a registered initiator establishes one.
> > 
> 
> Not exactly.  The question is if a RESERVE with type=All Registrants
> still needs to happen in order for the other registrations to have their
> 'implicit' reservation activated.
> 
> As mentioned below, the reasoning was because I'd only ever seen RESERVE
> populate the reservation TYPE field (eg: not REGISTER), which would
> imply that a 'explicit' RESERVE needs to happen from one initiator in
> order for the target to know if All Registrants logic needs to kick in
> for other existing + future registrations.

I'm not sure I can be more clear: You can't have a reservation without
and initiator issuing a reserve command.

The TYPE parameter is ignored for REGISTER (specified in table 116).

> > > This was primarily because the reservation type was not known until the
> > > explicit PR-OUT RESERVE occurred, and AFAICT at the time there where no
> > > host implementations that actually specified the reservation type at
> > > registration time.
> > > 
> > > So Is it correct to assume that one explicit PR-OUT RESERVE with All
> > > Registrants type needs to occur before other non reservation holding
> > > registrations gain an implicit reservation..?
> > 
> > I don't understand what you mean implicit reservation.  Once an all
> > registrants reservation is established, *all* registered initiators
> > become the reservation holder ... they're all equal.  This is mandated
> > in SPC-3 5.6.9
> 
> Implicit reservation meaning a registration for an I_T nexus to a device
> with a different I_T nexus holding an All Registrants reservation.
> 
> Eg, an I_T Nexus issued a RESERVE with type=All Registrants, and now the
> other I_T nexus with an active registration on the same device have an
> implicit reservation.

There's no such distinction in the standards; all registered initators
become the reservation holder once an all registrants reservation is
issued. 

> > > How about when the explicit reservation is removed..?  Do the implicit
> > > reservations need to remain in effect for the existing registrations,
> > > even though the explicit reservation of All Registrants type no longer
> > > exists..?
> > 
> > Again, I don't understand the distinction between implicit and explicit.
> > For an all registrants reservation, all registered initiators are the
> > reservation holder so any one of them may release the reservation.  Once
> > the reservation is released, there's no reservation at all.
> 
> So some initiator still needs to perform the actual RESERVE, right..?

Yes, there's no reservation until a reserve is issued.

> That is, a number of registrations don't become 'implicit' reservation
> holders until one initiator performs an 'explicit' RESERVE with type=All
> Registrants.

Once one initiator issues an all registrants reservation, all registants
become the reservation holder.

> > > The second point that Ilias raised is what should be the correct
> > > R_HOLDER bit status for PRIN READ_FULL_STATUS descriptors when All
> > > Registrants type is specified.  My original interpretation was that
> > > R_HOLDER was to signal the explicit reservation holder obtained with
> > > PR-OUT RESERVE, and not for the implicit reservations from the other
> > > registrations.  Is this the correct approach..?
> > 
> > R_HOLDER is set for any initiator that would be defined to be the
> > persistent reservation holder in section 5.6.9
> > 
> 
> Well, section 5.6.9 only mentions the use of RESERVE, so that would seem
> to indicate the original interpretation + current code for
> READ_FULL_STATUS is correct.

It should be set for every registered initiator in the all registrants
case (because they're all the reservation holder).

> > > Also, does anyone have any experience with a host side implementation of
> > > All Registrants to use as a reference for what's already out in the
> > > wild..?
> > 
> > I know what was negotiated to support clustering (which is a pretty tiny
> > subset).  However, I think your point of confusion is trying to
> > distinguish between what you call implicit and explicit reservations ...
> > there's no such thing.  There's only a reservation holder which may be
> > many initiators, So it's binary: a given initiator either is or is not
> > the reservation holder.  Section 5.6 needs to be read in that context.
> > 
> 
> The confusion is around when registrations who don't issue an explicit
> RESERVE become implicit reservation holders.  Is it when one initiator
> does an explicit RESERVE + type=All Registrants, or is it when REGISTER
> + type=All Registrants occurs..?

There is no reservation until a reserve command is issued.  Once an all
registrants reservation is issued, by any registered initator, all
registered initators then become the reservation holder.

James


