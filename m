From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND] interest in blk-mq, scsi-mq, dm-cache, dm-thinp,
 dm-*
Date: Fri, 24 Jan 2014 08:12:18 +0100
Message-ID: <52E21252.6000701@suse.de>
References: <20140110182714.GA11731@redhat.com> <52D3CFB2.4010207@suse.de> <52E1D1FA.8000703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaAXHMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 02:12:21 -0500
In-Reply-To: <52E1D1FA.8000703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/24/2014 03:37 AM, Mike Christie wrote:
> On 01/13/2014 05:36 AM, Hannes Reinecke wrote:
>> On 01/10/2014 07:27 PM, Mike Snitzer wrote:
>>> I would like to attend to participate in discussions related to top=
ics
>>> listed in the subject.  As a maintainer of DM I'd be interested to
>>> learn/discuss areas that should become a development focus in the m=
onths
>>> following LSF.
>>>
>> +1
>>
>> I've been thinking on (re-) implementing multipathing on top of
>> blk-mq, and would like to discuss the probability of which.
>> There are some design decisions in blk-mq (eg statically allocating
>> the number of queues) which do not play well with that.
>>
>=20
> I think I have been thinking about going a completely different direc=
tion.
>=20
> The thing about dm-multipath is that request based adds the extra que=
ue
> locking and that of course is bad. In our testing it is a major perf
> issue. We got things like ioscheduling though.
>=20
Indeed. And without that we cannot do true load-balancing.

> If we went back to bio based multipathing then it turns out that when
> scsi also supports multiqueue then it all works pretty nicely. There =
is
> room for improvement in general like with some dm allocations being
> numa/cpu aware, but the request_queue locking issues we have go away =
and
> it is very simple code wise.
>=20
If and when.

The main issue I see with that is that it might take some time (if
ever) for SCSI LLDDs to go fully multiqueue.
In fact, I strongly suspect that only newer LLDDs will ever support
multiqueue; for the older cards the HW interface it too much tied
to single queue operations.

> We could go the route of making request based dm-multipath:
>=20
> 1. aware of underlying multiqueue devices. So just basically keep wha=
t
> we have more or less but then have dm-multipath make a request that c=
an
> be sent to a multiqueue device then call blk_mq_insert_request. This
> would all be hidden by nice interfaces that hide if it is multiqueue
> underlying device or not.
>=20
> 2. make dm-multipath do multiqueue (so implement map_queue, queue_rq,
> etc) and also making it aware of underlying multiqueue devices.
>=20
> #1 just keeps the existing request spin_lock problem so there is not
> much point other than just getting things working.
>=20
> #2 is a good deal of work and what does it end up buying us over just
> making multipath bio based. We lose iosched support. If we are going =
to
> make advanced multiqueue ioschedulers that rely on request structs th=
en
> #2 could be useful.
>=20

Obviously we need iosched support when going multiqueue.
I wouldn't dream of dropping them.

So my overall idea here is to move multipath over to block-mq,
making each path identical to one queue.
(As mentioned above, currently every single FC HBA exposes a single
HW queue anyway)
The ioschedulers would be moved to the map_queue function.

This approach has several issues which I would like to discuss:
- block-mq ctx allocation currently is static. This doesn't play
  well with multipathing, were paths (=3Dqueues) might get configured
  on-the-fly.
- Queues might be coming from different HBAs; one would need to
  audit the block-mq stuff if that's possible.

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
