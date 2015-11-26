From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: rescan VPD attributes
Date: Thu, 26 Nov 2015 08:08:47 +0100
Message-ID: <5656AFFF.3080403@suse.de>
References: <1447071868-8509-1-git-send-email-hare@suse.de> <DDB9C85B850785449757F9914A034FCB444E0362@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbbKZHIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 02:08:50 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB444E0362@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "Martin K. Petersen" <martin.Petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>

On 11/26/2015 06:07 AM, Seymour, Shane M wrote:
> Hi Hannes,
>=20
> I have one probably small nitpick about the patch. I'm not sure how l=
ikely what I've put below is likely
> to happen in real life though.
>=20
> Is there any chance at all that sdev->vpd_pg83_len could change when =
updated?
> If there's any chance of that I'd have expected that both the
length of and the pointer to the vpd data
> would need to be protected not just the pointer so someone would
have a consistent picture of the vpd
> and its length. Without that there is a race where someone could
be using a new length with the old vpd
> data. That leaves the potential for a length that exceeds the vpd
size if the new data is larger than
> the old data - I don't know how likely it is but wanted to at
least bring it up as something to consider.
>=20
Accesses to vpd_pgXX are rcu-protected, so we're ensured that we
always see a _valid_ copy. And we know that integer updates are
atomic, so we will always see a valid number in vpd_pgXX_len.
Both, vpd_pgXX and vpd_pgXX_len, are updated at the same place, and
under the same locks/mutexes. And as we're calling
'synchronize_rcu()' after updating vpd_pgXX, which needs to
synchronize against all CPUs, I would think that this would take
care of updating vpd_pgXX_len, too.

But you are right, we can get rid of vpd_pgXX_len and calculate it
from the data.
However, I'd like to do this with another patch after the ALUA
changes are in.

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
