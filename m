From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What should be done with wrong warning "please use
	bus_type	methods." on sd, sr, st and osst?
Date: Tue, 25 Mar 2008 15:34:16 -0700
Message-ID: <1206484457.3273.27.camel@localhost.localdomain>
References: <47E7B40D.1000509@tremplin-utc.net>
	 <1206372247.3494.22.camel@localhost.localdomain>
	 <20080324175922.GB13816@kroah.com>
	 <1206382594.3494.76.camel@localhost.localdomain>
	 <47E97AC9.4030207@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49908 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbYCYWeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 18:34:23 -0400
In-Reply-To: <47E97AC9.4030207@tremplin-utc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>, Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>

On Tue, 2008-03-25 at 23:20 +0100, =C3=89ric Piel wrote:
> 24/03/08 19:16, James Bottomley wrote/a =C3=A9crit:
> > On Mon, 2008-03-24 at 10:59 -0700, Greg KH wrote:
> >> On Mon, Mar 24, 2008 at 10:24:07AM -0500, James Bottomley wrote:
> >>> A solution would be to duplicate the power management methods in =
the
> >>> scsi_driver structure, but this is a complete waste of space sinc=
e the
> >>> generic driver ones aren't going away (at least according to Kay =
and
> >>> Greg).  I still think the best thing to do is just to turn off th=
is
> >>> spurious warning.
> >> Do you have a patch that can detect the usage that you currently h=
ave so
> >> that I can change the warning message to not trigger if things are=
 set
> >> up that way instead?
> >=20
> > Well, my suggested fix would be the attached one since you and Kay =
seem
> > to be telling me that converting to bus_type X methods still leaves=
 us
> > free to reuse the driver X methods.  If you're planning on deprecat=
ing
> > the driver X methods, then sure, it makes sense for me to duplicate=
 them
> > in the scsi driver.
>=20
> I guess the problem with removing the warning is that in some other
> cases it could really be useful (searching on the web seems to show a
> couple of true positives).  I think Greg was more suggesting like add=
ing
> a flag ".i_know_what_i_am_doing" somewhere and putting it to 1 to
> disable the warning.

Sure, but I just see all the fallout from the false positive on SCSI
(Like about one email a week suggesting that I fix it), so I'm
complaining about my particular piece of this.

> Anyway, if the driver X methods are meaning something else, it makes
> sense to duplicate them specifically in the scsi driver structure. We=
 are
> basically talking about 8 bytes per scsi device, which can be conside=
red
> a fair trade-off if it allows to detect bugs in other places of the
> kernel. Following is an example of patch.

Well, what I'd like is to establish whether this usage is correct.  I d=
o
think that if the probe and remove methods aren't going away, then it
is,

> PS: Probably I'm an idiot, for the patch I didn't understand how to
> move ".remove" to scsi_driver, so I moved it to scsi_device... anyway=
 it's
> just an example in order to be sure that everyone is talking about th=
e
> same thing.

No ... it's a reasonable approach.  The struct scsi_device isn't quite
the right place to do it ... we have one struct scsi_driver for each UL=
D
(that's sd, sr, st etc,)  We have one struct scsi_device for every
device you have in the system (which can be thousands in an enterprise
system), so putting the method in struct scsi_device is a bit of
duplication overkill, but moving it to struct scsi_driver is very
feasible.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
