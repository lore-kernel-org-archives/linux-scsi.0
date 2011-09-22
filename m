From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system
 is physically removed
Date: Thu, 22 Sep 2011 14:26:21 +0200
Message-ID: <4E7B296D.8020900@suse.de>
References: <BAY151-W32DCB4BAFEC97DD4913A12A1090@phx.gbl>	 <Pine.LNX.4.44L0.1109171330360.18455-100000@netrider.rowland.org> <1316386825.14749.207.camel@deadeye> <4E7841A4.8040104@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1IVMWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 08:22:18 -0400
In-Reply-To: <4E7841A4.8040104@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, jaxboe@fusionio.com, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Rocko Requin <rockorequin@hotmail.com>, tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/20/2011 09:32 AM, Jun'ichi Nomura wrote:
> On 09/19/11 08:00, Ben Hutchings wrote:
[ .. ]
>>
>> There have been reports of this in Debian going back to 2.6.39:
>>
>> http://bugs.debian.org/631187
>> http://bugs.debian.org/636263
>> http://bugs.debian.org/642043
>>
>> Plus possibly related crashes in elv_put_request after CD-ROM remova=
l:
>>
>> http://bugs.debian.org/633890
>> http://bugs.debian.org/634681
>> http://bugs.debian.org/636103
>>
>> The former was also reported in Ubuntu since their 2.6.38-10:
>>
>> https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796
>>
>> The result of the discussion there was that it appeared to be a
>> regression due to commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b=20
>> ("[SCSI] put stricter guards on queue dead checks") which was also
>> included in a stable update for 2.6.38.
>>
>> There was also a report on bugzilla.kernel.org, though no-one can se=
e
>> quite what that says now:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D38842
>>
>> I also reported most of the above to James Bottomley and linux-scsi
>> nearly 2 months ago, to no response.
>=20
> I've reported a similar oops related to the above commit:
>   [BUG] Oops when SCSI device under multipath is removed
>   https://lkml.org/lkml/2011/8/10/11
>=20
> Elevator being removed is the core of the problem.
> And the essential issue seems 2 different models of queue/driver rela=
tion
> implied by queue_lock.
>=20
> If reverting the commit is not an option,
> until somebody comes up to fix the essential issue,
> the patch below should close the regressions introduced by the commit=
=2E
>=20
Why do you have to do it that complicated?
Couldn't we just state that any external lock is being disconnected fro=
m
queue_lock after blk_cleanup_queue()?

Then something like this should suffice here:

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..a4ac005 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -367,10 +367,8 @@ void blk_cleanup_queue(struct request_queue *q)
        queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
        mutex_unlock(&q->sysfs_lock);

-       if (q->elevator)
-               elevator_exit(q->elevator);
-
-       blk_throtl_exit(q);
+       if (q->queue_lock !=3D q->__queue_lock)
+               q->queue_lock =3D q->__queue_lock;

        blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..a5a756b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -477,6 +477,11 @@ static void blk_release_queue(struct kobject *kobj=
)

        blk_sync_queue(q);

+       if (q->elevator)
+               elevator_exit(q->elevator);
+
+       blk_throtl_exit(q);
+
        if (rl->rq_pool)
                mempool_destroy(rl->rq_pool);


And yeah, I find it pretty annoying, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke              zSeries & Storage
hare@suse.de                  +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
