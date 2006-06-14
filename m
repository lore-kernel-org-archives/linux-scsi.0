From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Wed, 14 Jun 2006 09:21:31 +0200
Message-ID: <448FB8FB.7040300@suse.de>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com>	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>	 <448F1403.6090903@sgi.com> <1150228960.3441.72.camel@mulgrave.il.steeleye.com> <448F31B0.5000104@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51147 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932210AbWFNHVp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 03:21:45 -0400
In-Reply-To: <448F31B0.5000104@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

Michael Reed wrote:
>=20
> James Bottomley wrote:
>> Since the rest of
>> our infrastructure is already event driven, or migrating that way, I
>> really don't see value in introducing an anomaly like this purely fo=
r
>> fibre channel.
>=20
> It's tough on fibre channel, being first.  :)
>=20
> Among the benefits of this patch is the purchase of time.  With the f=
c
> infrastructure the way it is, you're assured of forcing developers to
> "publish or perish".  That may be the intended desire.  It just doesn=
't
> seem fair to the users who have to deal with this.  It makes sense to
> me to implement the event driven infrastructure in such a way that
> it's more complete when released.  If infrastructure is going to be
> removed, then "applications" have to be adjusted to accommodate this.
> It shouldn't be, oh by the way, your driver/app is now broken, hurry =
up
> and fix it or your users will complain.  [End Of Rant].  My patch
> buys time.  Change the default so that the remove on disconnect has
> to be consciously overridden.  Remove the variable when the supportin=
g
> infrastructure is in place.  Put out a message indicating that the
> option of not removing the infrastructure is "going away" in a future
> release.  Provide an orderly transition.  Insure domestic tranquility=
=2E
> Promote the general welfare.  :)  I'm happy to adjust the patch
> to accommodate any of these suggestions if they are deemed acceptable=
=2E
>=20
And I can only _strongly_ agree with Mike here.
Yes, the infrastructure is moving towards dynamic device configuration.
But no, we're not there yet. Not by a long way.
Neither of the current volume managers (ie LVM2, EVMS, and even md to
some extend) are capable of dynamic reconfiguration.
Of course they sort of work nowadays, but the general idea of LVM2 and
EVMS is still that _all_ devices are available during setup.

And I don't even want to _think_ of the implications of running 'vgscan=
'
from a udev rule. So Mike's patch would allow those application to run
properly for the time being.

In general I agree with the dev_loss_tmo mechanism. But by enforcing it
we'll only make it easier for the developers of LVM2 et al to put the
blame on us (on the grounds of 'you broke it, you fix it') instead of
coaxing them to change their applications to accept dynamic device
configuration.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
