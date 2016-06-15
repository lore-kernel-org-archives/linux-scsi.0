From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Wed, 15 Jun 2016 12:33:54 +0200
Message-ID: <57612F12.5070505@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
 <575C0DAE.7070502@suse.de> <yq17fdrcjs3.fsf@sermon.lab.mkp.net>
 <5760F6BC.60109@suse.de> <576127FC.9020608@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbcFOKd4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 06:33:56 -0400
In-Reply-To: <576127FC.9020608@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, Brian King <brking@linux.vnet.ibm.com>

On 06/15/2016 12:03 PM, Jens Axboe wrote:
> On 06/15/2016 08:33 AM, Hannes Reinecke wrote:
>> And as I've mentioned before: what is the purpose of this check?
>>
>> 'max_sectors' and 'max_hw_sectors' are checked during request assemb=
ly,
>> and those limits are not changed even after calling
>> blk_recalc_rq_segments(). And if we go over any device-imposed
>> restrictions we'll be getting an I/O error from the driver anyway.
>> So why have it at all?
>=20
> You don't know that to be the case. The driver asked for certain limi=
ts,
> the core MUST obey them. The driver should not need to check for thes=
e
> limits, outside of in a BUG_ON() like manner.
>=20
Okay.
But again, what is the purpose of this check?
I do agree that we need to do a sanity check after we're recalculated
the sg elements, but we never recalculate the overall size of the reque=
st.
So why do we check only max_sector_size?
Why not max_segment_size?
Surely the queue limits can be different for that, too?

>> Especially as the system boots happily with this check removed...
>=20
> That's the case for you, but you can't assume this to be the case in
> general.
>=20
> There's a _lot_ of hand waving in this thread, Hannes. How do we
> reproduce this? We need to get this fixed for real, not just delete s=
ome
> check that triggers for you and that it just happens to work without.
> That's not how you fix problems.
>=20
Well. Yes, I know.
This issue is ATM only ever reproduced on ppc64le running on ibmvfc. An=
d
has been reported by a customer to us.
So there is not much I can do with reproducing here, sadly.

Maybe Brian King has some ideas/possibilities for this.
Brian, can you reproduce this with latest upstream kernel?
If so, can you file a bug at kernel.org?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
