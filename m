From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Sat, 11 Jun 2016 15:10:06 +0200
Message-ID: <575C0DAE.7070502@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com> <yq160tgfoqr.fsf@sermon.lab.mkp.net>
 <575BE182.5010304@suse.de> <yq11t44f0hi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbcFKNKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 09:10:09 -0400
In-Reply-To: <yq11t44f0hi.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

On 06/11/2016 01:06 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>
> Hannes> Because we're checking the wrong limit.
>
> The original code checked that the request was smaller than both
> max_sectors and max_hw_sectors so it would have failed here as well.
>
> Hannes> blk_queue_get_max_sectors() is checking limits.max_sectors(),
> Hannes> but the requests are already fully formed and can extend up t=
o
> Hannes> limits.max_hw_sectors().
>
> We should not be issuing REQ_TYPE_FS requests larger than max_sectors=
=2E
> How did we get here?
>
Well, the primary issue is that 'blk_cloned_rq_check_limits()' doesn't=20
check for BLOCK_PC, so this particular check would be applied for every=
=20
request.

But as it turns out, even adding a check for BLOCK_PC doesn't help, so=20
we're indeed seeing REQ_TYPE_FS requests with larger max_sector counts.

As to _why_ this happens I frankly have no idea. I have been staring at=
=20
this particular code for over a year now (I've got another bug pending=20
where we hit the _other_ if clause), but to no avail.
So I've resolved to drop the check altogether, seeing that max_sector=20
size is _not_ something which gets changed during failover.
Therefore if the max_sector count is wrong for the cloned request it wa=
s=20
already wrong for the original request, and we should've errored it out=
=20
far earlier.
The max_segments count, OTOH, _might_ change during failover (different=
=20
hardware has different max_segments setting, and this is being changed=20
during sg mapping), so there is some value to be had from testing it he=
re.

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
