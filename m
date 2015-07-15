From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 14:02:55 +0200
Message-ID: <55A64BEF.1020500@suse.de>
References: <1436959404-14035-1-git-send-email-hare@suse.de> <1436960108.31121.41.camel@HansenPartnership.com> <55A64980.3070304@suse.de> <20150715115609.GA22391@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbbGOMC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 08:02:57 -0400
In-Reply-To: <20150715115609.GA22391@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 07/15/2015 01:56 PM, Christoph Hellwig wrote:
> An array can't issue a reservation, the initiator needs to register
> it.  Right now the only way to do it is through SG_IO passthrough,
> which is a best luck effort it I/O isn't also using SG_IO and can't
> be properly supported because of that.
>=20
> However I will submit an in-kernel reservation API soon which will
> allow us to have that sort of control.  My current prototyp only allo=
ws
> for all-path reservations as I couldn't come up with a use case for
> per-path reservations, but if such a need should arise we can add it
> and take that into account in the multipathing code.
>=20
Which was my reasoning as well.
I would consider a per-path reservation in a multipath setup an
error, as the current multipath code is not able to handle this.
With the current code we will fail a path due to the reservation
conflict error, but whatever happens next depends on the type of
reservation and the used prioritizer/path checker.
It can be everything from 'just working' to recurrent path drops to
and I/O stall (as SET TARGET PORT GROUPS might return an reservation
conflict, too, so we wouldn't be able to switch to a working path...)

And implementing a per-path reservation in multipath is far from
trivial, so I'd rather not attempt this.
_Especially_ not as you're working on a in-kernel reservation code.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
