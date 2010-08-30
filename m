From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 30 Aug 2010 11:54:11 +0200
Message-ID: <4C7B7FC3.1050701@suse.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org> <4C6C34E0.3050601@vlnb.net> <4C6CFEAA.1060004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C6CFEAA.1060004@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
>=20
> On 08/18/2010 09:30 PM, Vladislav Bolkhovitin wrote:
>> Basically, I measured how iSCSI link utilization depends from amount
>> of queued commands and queued data size. This is why I made it as a
>> table. From it you can see which improvement you will have removing
>> queue draining after 1, 2, 4, etc. commands depending of commands
>> sizes.
>>
>> For instance, on my previous XFS rm example, where rm of 4 files
>> took 3.5 minutes with nobarrier option, I could see that XFS was
>> sending 1-3 32K commands in a row. From my table you can see that if
>> it sent all them at once without draining, it would have about
>> 150-200% speed increase.
>=20
> You compared barrier off/on.  Of course, it will make a big
> difference.  I think good part of that gain should be realized by the
> currently proposed patchset which removes draining.  What's needed to
> be demonstrated is the difference between ordered-by-waiting and
> ordered-by-tag.  We've never had code to do that properly.
>=20
> The original ordered-by-tag we had only applied tag ordering to two o=
r
> three command sequences inside a barrier, which doesn't amount to muc=
h
> (and could even be harmful as it imposes draining of all simple
> commands inside the device only to reduce issue latencies for a few
> commands).  You'll need to hook into filesystem and somehow export th=
e
> ordering information down to the driver so that whatever needs
> ordering is sent out as ordered commands.
>=20
> As I've wrote multiple times, I'm pretty skeptical it will bring much=
=2E
> Ordered tag mandates draining inside the device just like the origina=
l
> barrier implementation.  Sure, it's done at a lower layer and command
> issue latencies will be reduced thanks to that but ordered-by-waiting
> doesn't require _any_ draining at all.  The whole pipeline can be kep=
t
> full all the time.  I'm often wrong tho, so please feel free to go
> ahead and prove me wrong.  :-)
>=20
Actually, I thought about ordered tag writes, too.
But eventually I had to give up on this for a simple reason:
Ordered tag controls the ordering on the SCSI _TARGET_. But for a
meaningful implementation we need to control the ordering all the way
down from ->queuecommand(). Which means we have three areas we need
to cover here:
- driver (ie between ->queuecommand() and passing it off to the firmwar=
e)
- firmware
- fabric

Sadly, the latter two are really hard to influence. And, what's more,
with the new/modern CNAs with multiple queues and possible multiple
routes to the target it becomes impossible to guarantee ordering.
So using ordered tags for FibreChannel is not going to work, which
makes implementing it a bit of a pointless exercise for me.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
