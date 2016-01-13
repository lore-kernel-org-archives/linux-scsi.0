From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 17:18:50 +0100
Message-ID: <569678EA.3000000@suse.de>
References: <56961493.5010901@suse.de> <56962BDB.4080509@dev.mellanox.co.il>
 <20160113154243.GA2563@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbcAMQSy (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 11:18:54 -0500
In-Reply-To: <20160113154243.GA2563@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 01/13/2016 04:42 PM, Mike Snitzer wrote:
> On Wed, Jan 13 2016 at  5:50am -0500,
> Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>
>> Another (adjacent) topic is multipath performance with blk-mq.
>>
>> As I said, I've been looking at nvme multipathing support and
>> initial measurements show huge contention on the multipath lock
>> which really defeats the entire point of blk-mq...
>>
>> I have yet to report this as my work is still in progress. I'm not s=
ure
>> if it's a topic on it's own but I'd love to talk about that as well.=
=2E.
>
> This sounds like you aren't actually using blk-mq for the top-level D=
M
> multipath queue.  And your findings contradicts what I heard from Kei=
th
> Busch when I developed request-based DM's blk-mq support, from commit
> bfebd1cdb497 ("dm: add full blk-mq support to request-based DM"):
>
>       "Just providing a performance update. All my fio tests are gett=
ing
>        roughly equal performance whether accessed through the raw blo=
ck
>        device or the multipath device mapper (~470k IOPS). I could on=
ly push
>        ~20% of the raw iops through dm before this conversion, so thi=
s latest
>        tree is looking really solid from a performance standpoint."
>
>>> But in the end we should be able to do strip down the current (rath=
er
>>> complex) multipath-tools to just handle topology changes; everythin=
g
>>> else will be done internally.
>>
>> I'd love to see that happening.
>
> Honestly, this needs to be a hardened plan that is hashed out _before=
_
> LSF and then findings presented.  It is a complete waste of time to
> debate nuance with Hannes in a one hour session.
>
> Until I implemented the above DM core changes hch and Hannes were ver=
y
> enthusiastic to throw away the existing DM multipath and multipath-to=
ols
> code (the old .request_fn queue lock bottleneck being the straw that
> broke the camel's back).  Seems Hannes' enthusiasm hasn't tempered bu=
t
> his hand-waving is still in full form.
>
> Details matter.  I have no doubts aspects of what we have could be
> improved but I really fail to see how moving multipathing to blk-mq i=
s a
> constructive way forward.
>
So what is your plan?
Move the full blk-mq infrastructure into device-mapper?

 From my perspective, blk-mq and multipath I/O handling have a lot=20
in common (the ->map_queue callback is in effect the same ->map_rq=20
does), so I still think it should be possible to leverage that directly=
=2E
But for that to happen we would need to address some of the=20
mentioned issues like individual queue failures and dynamic queue=20
remapping; my hope is that they'll be implemented in the course of=20
NVMe over fabrics.

Also note that my proposal is more with the infrastructure=20
surrounding multipathing (ie topology detection and setup), so it's=20
somewhat orthogonal to your proposal.

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
