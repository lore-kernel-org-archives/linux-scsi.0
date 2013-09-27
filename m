From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Race condition between "read CFQ stats" and "block device shutdown"
Date: Fri, 27 Sep 2013 07:59:04 +0200
Message-ID: <52451EA8.70606@suse.de>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com> <5226D661.7070301@suse.de> <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com> <20130904160723.GC26609@mtj.dyndns.org> <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com> <20130926135443.GC2480@htj.dyndns.org> <5244423A.2050107@suse.de> <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 09/26/2013 06:23 PM, Anatol Pomozov wrote:
> Hi
>=20
> On Thu, Sep 26, 2013 at 7:18 AM, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org> wrote=
:
>> On 09/26/2013 03:54 PM, Tejun Heo wrote:
>>> Hello, (cc'ing linux-scsi)
>>>
>>> On Wed, Sep 25, 2013 at 01:37:51PM -0700, Anatol Pomozov wrote:
>>>> Hi
>>>>
>>>> On Wed, Sep 4, 2013 at 9:07 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>>> Hello,
>>>>>
>>>>> On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
>>>>>> I am not an expect in block code, so I have a few questions here=
:
>>>>>>
>>>>>> - are we sure that this operation is atomic? What if blkg->q bec=
omes
>>>>>> dead right after we checked it, and blkg->q->queue_lock got inva=
lid so
>>>>>> we have the same crash as before?
>>>>>
>>>>> request_queue lock switching is something inherently broken in bl=
ock
>>>>> layer.  It's unsalvageable.
>>>>
>>>> Fully agree. The problem that request_queue->queue_lock is a share=
d
>>>> resource that concurrently modified/accessed. In this case (when o=
ne
>>>> thread changes, another thread access it) we need synchronization =
to
>>>> prevent race conditions. So we need a spin_lock to access queue_lo=
ck
>>>> spin_lock, otherwise we have a crash like one above...
>>>>
>>>>>  Maybe we can drop lock switching once blk-mq is fully merged.
>>>>
>>>> Could you please provide more information about it? What is the ti=
meline?
>>>
>>> I have no idea.  Hopefully, not too far out.  Jens would have bette=
r
>>> idea.
>>>
>>>> If there is an easy way to fix the race condition I would like to
>>>> help. Please give me some pointer what direction I should move.
>>>
>>> The first step would be identifying who are actually making use of
>>> lock switching, why and how much difference it would make for them =
to
>>> not do that.
>>>
>> Typically, the lock is being used by the block drivers to
>> synchronize access between some internal data structures and the
>> request queue itself. You don't actually _need_ to do it that way,
>> but removing the lock switching would involve quite some redesign of
>> these drivers.
>> Give that most of the are rather oldish I really wouldn't want to
>> touch them.
>=20
> Thanks for the info.
>=20
> We use modified version of "sbull" block device driver from GKH book.
> We use it for testing block device startup/shutdown path + CFQ
> manipulation.
>=20
> The sbull driver uses function
> blk_init_queue(..., &dev->qlock);
>=20
> it passes lock as a second parameter and function makes the lock
> swapping. According to your information passing lock to
> blk_init_queue() considered as an "old non recommended way" so we
> should modify our driver and avoid doing this. I'll take a look.
>=20
Yep. I would recommend to use the queue_lock directly whenever you
need to pull requests off the request_queue, and use your own lock
to protect any internal structures associated with handling the
request internally.

Yes, this _might_ involve some lock dancing between the queue_lock
and the internal lock, but has the advantage that the internal lock
typically it used far more often than the queue_lock itself.
So you might even get some speed advantage here as you reduce
contention on the queue_lock.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
