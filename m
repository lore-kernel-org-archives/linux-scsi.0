From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system
 is physically removed
Date: Thu, 22 Sep 2011 18:32:26 +0200
Message-ID: <4E7B631A.20605@suse.de>
References: <4E7B296D.8020900@suse.de> <Pine.LNX.4.44L0.1109221113380.2137-100000@iolanthe.rowland.org> <20110922162047.GD3431@oc1711230544.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1IVQ2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 12:28:24 -0400
In-Reply-To: <20110922162047.GD3431@oc1711230544.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Rocko Requin <rockorequin@hotmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Ben Hutchings <ben@decadent.org.uk>, jaxboe@fusionio.com, James Bottomley <James.Bottomley@HansenPartnership.com>, tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/22/2011 06:20 PM, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Sep 22, 2011 at 11:16:30AM -0400, Alan Stern wrote:
>> Rocko:
>>
>> Can you try testing this patch instead of all the patches I sent to=20
>> you (but keep Ted's patch)?
>>
>> Alan Stern
>>
>> On Thu, 22 Sep 2011, Hannes Reinecke wrote:
>>
>>> On 09/20/2011 09:32 AM, Jun'ichi Nomura wrote:
>>>> On 09/19/11 08:00, Ben Hutchings wrote:
>>> [ .. ]
>>>>>
>>>>> There have been reports of this in Debian going back to 2.6.39:
>>>>>
>>>>> http://bugs.debian.org/631187
>>>>> http://bugs.debian.org/636263
>>>>> http://bugs.debian.org/642043
>>>>>
>>>>> Plus possibly related crashes in elv_put_request after CD-ROM rem=
oval:
>>>>>
>>>>> http://bugs.debian.org/633890
>>>>> http://bugs.debian.org/634681
>>>>> http://bugs.debian.org/636103
>>>>>
>>>>> The former was also reported in Ubuntu since their 2.6.38-10:
>>>>>
>>>>> https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796
>>>>>
>>>>> The result of the discussion there was that it appeared to be a
>>>>> regression due to commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b=
=20
>>>>> ("[SCSI] put stricter guards on queue dead checks") which was als=
o
>>>>> included in a stable update for 2.6.38.
>>>>>
>>>>> There was also a report on bugzilla.kernel.org, though no-one can=
 see
>>>>> quite what that says now:
>>>>>
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D38842
>>>>>
>>>>> I also reported most of the above to James Bottomley and linux-sc=
si
>>>>> nearly 2 months ago, to no response.
>>>>
>>>> I've reported a similar oops related to the above commit:
>>>>   [BUG] Oops when SCSI device under multipath is removed
>>>>   https://lkml.org/lkml/2011/8/10/11
>>>>
>>>> Elevator being removed is the core of the problem.
>>>> And the essential issue seems 2 different models of queue/driver r=
elation
>>>> implied by queue_lock.
>>>>
>>>> If reverting the commit is not an option,
>>>> until somebody comes up to fix the essential issue,
>>>> the patch below should close the regressions introduced by the com=
mit.
>>>>
>>> Why do you have to do it that complicated?
>>> Couldn't we just state that any external lock is being disconnected=
 from
>>> queue_lock after blk_cleanup_queue()?
>>>
>>> Then something like this should suffice here:
>>
>>
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 90e1ffd..a4ac005 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -367,10 +367,8 @@ void blk_cleanup_queue(struct request_queue *q)
>>         queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
>>         mutex_unlock(&q->sysfs_lock);
>>
>> -       if (q->elevator)
>> -               elevator_exit(q->elevator);
>> -
>> -       blk_throtl_exit(q);
>> +       if (q->queue_lock !=3D q->__queue_lock)
>> +               q->queue_lock =3D q->__queue_lock;
>=20
> That should be &q->__queue_lock.
>=20
Why, but of course.
It's been fixed with the official patch
(cf block: Free queue resources at blk_release_queue())

Cheers,

Hannes
--=20
Dr. Hannes Reinecke              zSeries & Storage
hare@suse.de                  +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
