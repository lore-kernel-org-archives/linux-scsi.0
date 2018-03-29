From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: General protection fault with use_blk_mq=1.
Date: Thu, 29 Mar 2018 07:13:11 +0200
Message-ID: <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
 <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
 <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>, "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> Il giorno 29 mar 2018, alle ore 05:22, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 3/28/18 9:13 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>> On 03/28/2018 06:02 PM, Jens Axboe wrote:
>>> On 3/28/18 5:03 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>>>> I am not subscribed to any of the lists on the To list here, please =
CC
>>>> me on any replies.
>>>>=20
>>>> I am encountering a fairly consistent crash anywhere from 15 =
minutes to
>>>> 12 hours after boot with scsi_mod.use_blk_mq=3D1 =
dm_mod.use_blk_mq=3D1>=20
>>>> The crash looks like:
>>>>=20
>>=20
>>>>=20
>>>> Looking through the code, I'd guess that this is dying inside
>>>> blkg_rwstat_add, which calls percpu_counter_add_batch, which is =
what RIP
>>>> is pointing at.
>>>=20
>>> Leaving the whole thing here for Paolo - it's crashing off insertion =
of
>>> a request coming out of SG_IO. Don't think we've seen this BFQ =
failure
>>> case before.
>>>=20
>>> You can mitigate this by switching the scsi-mq devices to =
mq-deadline
>>> instead.
>>>=20
>>=20
>> I'm thinking that I should also be able to mitigate it by disabling
>> CONFIG_DEBUG_BLK_CGROUP.
>>=20
>> That should remove that entire chunk of code.
>>=20
>> Of course, that won't help if this is actually a symptom of a bigger
>> problem.
>=20
> Yes, it's not a given that it will fully mask the issue at hand. But
> turning off BFQ has a much higher chance of working for you.
>=20
> This time actually CC'ing Paolo.
>=20

Hi Zephaniah,
if you are actually interested in the benefits of BFQ (low latency,
high responsiveness, fairness, ...) then it may be worth to try what
you yourself suggest: disabling CONFIG_DEBUG_BLK_CGROUP.  Also because
this option activates the heavy computation of debug cgroup statistics,
which probably you don't use.

In addition, the outcome of your attempt without
CONFIG_DEBUG_BLK_CGROUP would give us useful bisection information:
- if no failure occurs, then the issue is likely to be confined in
that debugging code (which, on the bright side, is likely to be of
occasional interest, for only a handful of developers)
- if the issue still shows up, then we may have new hints on this odd
failure

Finally, consider that this issue has been reported to disappear from
4.16 [1], and, as a plus, that the service quality of BFQ had a
further boost exactly from 4.16.

Looking forward to your feedback, in case you try BFQ without
CONFIG_DEBUG_BLK_CGROUP,
Paolo

[1] https://www.spinics.net/lists/linux-block/msg21422.html

>=20
> --=20
> Jens Axboe
