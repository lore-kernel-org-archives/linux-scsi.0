From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of block-integrity
Date: Tue, 07 Jan 2014 14:33:10 +0100
Message-ID: <52CC0216.5060900@suse.de>
References: <20131222192128.GA28532@infradead.org> <yq11u134rmt.fsf@sermon.lab.mkp.net> <52CBBABD.50902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaAGNdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 08:33:12 -0500
In-Reply-To: <52CBBABD.50902@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>, "Martin K. Petersen" <mkp@mkp.net>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On 01/07/2014 09:28 AM, Ric Wheeler wrote:
> On 12/23/2013 09:35 PM, Martin K. Petersen wrote:
>>>>>>> "Christoph" =3D=3D Christoph Hellwig <hch@infradead.org> writes=
:
>> Christoph> We have the block integrity code to support DIF/DIX in th=
e
>> Christoph> the tree for about 5 and a half years, and we still don't
>> Christoph> have a single consumer of it.
>>
>> What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp=
)
>> then integrity protection is active from the block layer down. The
>> only
>> code that's not currently being exercised are the tag interleaving
>> functions.  I was hoping the FS people would use them for back
>> pointers
>> but nobody seemed to bite.
>>
>>
>> Christoph> Given that we'll have a lot of work to do in this area
>> with
>> Christoph> block multiqueue I think it's time to either kill it
>> off for
>> Christoph> good or make sure we can actually use and test it.
>>
>> I don't understand why multiqueue would require a lot of work?
>> It's just
>> an extra scatterlist per request.
>>
>> And obviously, if there's anything that needs to be done in this are=
a
>> I'll be happy to do so...
>>
>=20
> One of the major knocks on linux file systems (except for btrfs)
> that I hear is the lack of full data path checksums. DIF/DIX + xfs
> or ext4 done right will give us another answer here.  I don't think
> it will be common, it is a request that comes in for very large
> storage customers most commonly.
>=20
> We do have devices that support this and are working to get more
> vendor testing done, so I would hate to see us throw out the code
> instead of fixing it up for the end users that see value here.
>=20
> I think that we can get this working & agree with the call to
> continue this discussion (here and at LSF :))
>=20
I would indeed like to have a discussion at LSF about the future of
DIX. DIF is not an issue, as most HBAs support it already and we
actually need it for proper connectivity.

DIX, OTOH, has been left dormant since time immemorial, with the
only known (supposed) user being Oracle.
(I actually talked to the DB/2 folks about it, and the response
was a polite feigned interest ...)

We need to come up with a concise story here (either integrate with
filesystems or have a userland interface), otherwise it's just dead
code and indeed should be removed.

Plus so far I've had exactly _one_ request for DIX, and even that
came from a company which has its own custom storage array firmware.
Making me wonder if DIF/DIX is really that important or more of an
tick-mark during procuring ...

Even so, it would warrant a discussion at LSF.

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
