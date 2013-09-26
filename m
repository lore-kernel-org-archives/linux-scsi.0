From: Hannes Reinecke <hare@suse.de>
Subject: Re: Race condition between "read CFQ stats" and "block device shutdown"
Date: Thu, 26 Sep 2013 16:18:34 +0200
Message-ID: <5244423A.2050107@suse.de>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com> <5226D661.7070301@suse.de> <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com> <20130904160723.GC26609@mtj.dyndns.org> <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com> <20130926135443.GC2480@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3IZOSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 10:18:37 -0400
In-Reply-To: <20130926135443.GC2480@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On 09/26/2013 03:54 PM, Tejun Heo wrote:
> Hello, (cc'ing linux-scsi)
>=20
> On Wed, Sep 25, 2013 at 01:37:51PM -0700, Anatol Pomozov wrote:
>> Hi
>>
>> On Wed, Sep 4, 2013 at 9:07 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Hello,
>>>
>>> On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
>>>> I am not an expect in block code, so I have a few questions here:
>>>>
>>>> - are we sure that this operation is atomic? What if blkg->q becom=
es
>>>> dead right after we checked it, and blkg->q->queue_lock got invali=
d so
>>>> we have the same crash as before?
>>>
>>> request_queue lock switching is something inherently broken in bloc=
k
>>> layer.  It's unsalvageable.
>>
>> Fully agree. The problem that request_queue->queue_lock is a shared
>> resource that concurrently modified/accessed. In this case (when one
>> thread changes, another thread access it) we need synchronization to
>> prevent race conditions. So we need a spin_lock to access queue_lock
>> spin_lock, otherwise we have a crash like one above...
>>
>>>  Maybe we can drop lock switching once blk-mq is fully merged.
>>
>> Could you please provide more information about it? What is the time=
line?
>=20
> I have no idea.  Hopefully, not too far out.  Jens would have better
> idea.
>=20
>> If there is an easy way to fix the race condition I would like to
>> help. Please give me some pointer what direction I should move.
>=20
> The first step would be identifying who are actually making use of
> lock switching, why and how much difference it would make for them to
> not do that.
>=20
Typically, the lock is being used by the block drivers to
synchronize access between some internal data structures and the
request queue itself. You don't actually _need_ to do it that way,
but removing the lock switching would involve quite some redesign of
these drivers.
Give that most of the are rather oldish I really wouldn't want to
touch them.

However, none of the modern devices should be using this lock
switching, so I would just ignore it.
EG SCSI most definitely doesn't use it.

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
