From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
 found
Date: Sun, 27 Jul 2014 17:36:35 +0200
Message-ID: <53D51C83.3020502@suse.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de> <53B6878C.502@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net> <20140726153612.GA6513@lst.de> <CADzpL0Rn+x6N=v123EBej_iZhTwmjMYZ4deeTeRG7_sxgXU9PQ@mail.gmail.com> <20140726161721.GA6743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaG0Pgj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2014 11:36:39 -0400
In-Reply-To: <20140726161721.GA6743@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

On 07/26/2014 06:17 PM, Christoph Hellwig wrote:
> On Sat, Jul 26, 2014 at 11:14:35AM -0500, Stephen Cameron wrote:
>> Hmm, I forgot that that patch was in there, I wasn't trying to keep =
pushing
>> it along.  From the previous discussion, I got the impression I was =
simply
>> wrong, and that this patch wasn't needed, so I had meant to drop it,=
 I just
>> forgot to actually drop it.
>
> It's more complicated - as Robert indicated you're tenically right, a=
lthough
> in practice it's not what the existing users expect.  If you have som=
e
> cycles for it I'd love to at lest get the per-LUN and per-target
> ramp up/down in ASAP.  We can then start looking into doing it even
> better based on the target response later on.
>
The current implementation is based on the needs of the FC HBAs, which=20
would need a way to throttle I/O to avoid flooding a target port.
The reason it was done per target is (from what I can tell) due to a=20
specific implementation from a large vendor which is using a=20
per-target-port request queue.
And more often than not defaulting to SCSI-2 conformance to be 'legacy=20
compatible'. So no way one could use any shiny new commands.

Having said that it has been quite some time since it's been=20
implemented, and it _might_ be that things have changed and we can get=20
away with a per-LUN throttling. As I doubt we'll get information about=20
this from the various storage vendors (at least not from those we've go=
t=20
issues with even today) we probably have to bite the bullet here and=20
test things out.

But hey, it's worth a shot anyway. So, storage vendors, speak up!

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
