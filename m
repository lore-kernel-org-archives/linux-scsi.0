From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of block-integrity
Date: Thu, 09 Jan 2014 12:19:34 +0100
Message-ID: <52CE85C6.8000405@suse.de>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de>	<yq1a9f7wjqr.fsf@sermon.lab.mkp.net> <52CCFADB.6080909@suse.de> <yq1lhyqv6ns.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAIJRB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 04:17:01 -0500
In-Reply-To: <yq1lhyqv6ns.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>

On 01/08/2014 04:23 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>
> Hannes,
>
> Hannes> As there is no user (apart from oracleasm) no-one can attach
> Hannes> protection information to any data, so even the most dedicate=
d
> Hannes> admin cannot exercise this path, let alone find issues here.
>
> That's not how it works!
>
> If the filesystem has not attached protection information to a bio th=
e
> block layer will do it for you. The block layer generates protection
> information for writes and verifies it for reads. That's how it's wor=
ked
> since day one. The code is there, it is used by everyone with a
> DIX-capable HBA. See Documentation/block/data-integrity.txt.
>
> Normal applications do not want to have to deal with generating
> protection information, using an async I/O model, keeping completion
> state around for extended periods of time to figure out whether the I=
/O
> actually completed or not and so on. So the kernel-to-platter protect=
ion
> scheme we have in place now is good enough.
>
Ah. I stand corrected.
Sorry.

> That doesn't mean that I'm not interested in augmenting libaio. I
> am. Very. And I know of several applications that are keen to use
> it. But getting page cache passthrough and filesystem interaction
> working is non-trivial. That's what has inhibited progress, not
> extending the libaio API.
>
Same here. Actually I _like_ DIX, but the missing libaio / userland API=
=20
makes it very hard to utilize it.

> Hannes> Doug Gilbert and I are currently discussing LID4 / ROD Token
> Hannes> copy for sg3_utils and the block layer, so any patches would =
be
> Hannes> very helpful here.
>
> I'm only doing LID1 right now. Any particular reason you are explorin=
g
> LID4 and ROD?
>
Yes. LID4/ROD token is far easier to use (conceptually).
With LID1/XCopy you have the ambiguity on where to actually send the=20
command to; the spec is silent in this area.
Also for LID1/XCopy you have three steps:
- Query the source disk
- Query the target disk
- Send the command to either source or target
Which is very awkward and one has to think really carefully on how to=20
implement this without all sorts of layering violations.
And you have to mix-and-match between all the various xcopy descriptors=
;
if there's only one it's easy enough, but when several things are=20
getting interesting.

With LID4/ROD Token copy you basically have _two_ steps:
- Get the ROD Token from the source device
- Send the ROD Token to the target device

Which is far easier (conceptually).
Or that's the hope, anyway.
Also, the ROD Token in principle has an independent lifetime, so
you could take an arbitrary amount of time between those steps.
It might expire, though, but then failure is always an option when
working with copy offload.

As said, Doug and me are working on putting this into sg3_utils, then
we'll have a better idea on the actual workings.

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
