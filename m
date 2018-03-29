From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
Subject: Re: General protection fault with use_blk_mq=1.
Date: Thu, 29 Mar 2018 02:12:39 -0700
Message-ID: <0a96375b-5a2e-e828-fa1f-a14af192be4c@aehallh.com>
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
 <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
 <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
 <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lB5lpsYNudRQbnvCa5GSZAeI4OY55eDRs"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lB5lpsYNudRQbnvCa5GSZAeI4OY55eDRs
Content-Type: multipart/mixed; boundary="HA3ciq3VPsgDAdrkx1KE2ahbDdy3Q9ZhF";
 protected-headers="v1"
From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
To: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org
Message-ID: <0a96375b-5a2e-e828-fa1f-a14af192be4c@aehallh.com>
Subject: Re: General protection fault with use_blk_mq=1.
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
 <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
 <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
 <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>
In-Reply-To: <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>

--HA3ciq3VPsgDAdrkx1KE2ahbDdy3Q9ZhF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03/28/2018 10:13 PM, Paolo Valente wrote:
>=20
>=20
>> Il giorno 29 mar 2018, alle ore 05:22, Jens Axboe <axboe@kernel.dk> ha=
 scritto:
>>
>> On 3/28/18 9:13 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>>> On 03/28/2018 06:02 PM, Jens Axboe wrote:
>>>> On 3/28/18 5:03 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>>>>> I am not subscribed to any of the lists on the To list here, please=
 CC
>>>>> me on any replies.
>>>>>
>>>>> I am encountering a fairly consistent crash anywhere from 15 minute=
s to
>>>>> 12 hours after boot with scsi_mod.use_blk_mq=3D1 dm_mod.use_blk_mq=3D=
1>=20
>>>>> The crash looks like:
>>>>>
>>>
>>>>>
>>>>> Looking through the code, I'd guess that this is dying inside
>>>>> blkg_rwstat_add, which calls percpu_counter_add_batch, which is wha=
t RIP
>>>>> is pointing at.
>>>>
>>>> Leaving the whole thing here for Paolo - it's crashing off insertion=
 of
>>>> a request coming out of SG_IO. Don't think we've seen this BFQ failu=
re
>>>> case before.
>>>>
>>>> You can mitigate this by switching the scsi-mq devices to mq-deadlin=
e
>>>> instead.
>>>>
>>>
>>> I'm thinking that I should also be able to mitigate it by disabling
>>> CONFIG_DEBUG_BLK_CGROUP.
>>>
>>> That should remove that entire chunk of code.
>>>
>>> Of course, that won't help if this is actually a symptom of a bigger
>>> problem.
>>
>> Yes, it's not a given that it will fully mask the issue at hand. But
>> turning off BFQ has a much higher chance of working for you.
>>
>> This time actually CC'ing Paolo.
>>
>=20
> Hi Zephaniah,
> if you are actually interested in the benefits of BFQ (low latency,
> high responsiveness, fairness, ...) then it may be worth to try what
> you yourself suggest: disabling CONFIG_DEBUG_BLK_CGROUP.  Also because
> this option activates the heavy computation of debug cgroup statistics,=

> which probably you don't use.

I definitely am.
>=20
> In addition, the outcome of your attempt without
> CONFIG_DEBUG_BLK_CGROUP would give us useful bisection information:
> - if no failure occurs, then the issue is likely to be confined in
> that debugging code (which, on the bright side, is likely to be of
> occasional interest, for only a handful of developers)
> - if the issue still shows up, then we may have new hints on this odd
> failure
>=20
> Finally, consider that this issue has been reported to disappear from
> 4.16 [1], and, as a plus, that the service quality of BFQ had a
> further boost exactly from 4.16.

I look forward to that either way then.
>=20
> Looking forward to your feedback, in case you try BFQ without
> CONFIG_DEBUG_BLK_CGROUP,

I'm running that now, judging from the past if it survives until
tomorrow evening then we're good, so I should hopefully know in the next
day.

Thank you,
Zephaniah E. Loss-Cutler-Hull.

> Paolo
>=20
> [1] https://www.spinics.net/lists/linux-block/msg21422.html
>=20
>>
>> --=20
>> Jens Axboe
>=20



--HA3ciq3VPsgDAdrkx1KE2ahbDdy3Q9ZhF--

--lB5lpsYNudRQbnvCa5GSZAeI4OY55eDRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJavK4SAAoJEJMemkxvB+Y8XqoP/2CkP3w/B6pSYhDSDd8lrwUy
Ago4fVmi5VGwfIsT+1nuHUJL/vYc8L9jbSfr2g2v36nd94mPLQac8Xuawbp26XOh
eIZtWlBrUcCXuZqRqsA1OfVBFa9zBL6AjvKMdAqDhuF6ONfmRKFzS5OUQKHkMeYS
Ujyt7rUquQzpVw3+64Ki5cc80Jpw337ahFMQ/H1red36NVjw/d5Fe97waDPD+oM9
CF6/cyLHudcMcLhIbyHnomPaMGtSIpBAfV1IjkiDmnV9HgNtaSo1Mkd0RfFdKn4+
9hjT8hRxKz2Q3BF02ncKPOPctKTN12QObcF38vg+3ggMfFSU+GYA+oU8LzjsdXuk
sUi1BZMVVJhZ+8RF56+MlMEoZ61nUiV/XHiN88qD0kbdH0i1zrH4DskrpzWIioup
V/lIaGpOb2a+AJogc5RboWqhPekQRZYcWBHlNrh1b11doM8t+BcNN20r343YFMWg
GVSKABvom69f+nqbTpqYncI7pz+ocdu5qDVysgx3NUPRAWXW0+kz8vn5YAakr5TB
z7qJRqv1EUVg/e6z0tng3VcEQD/Uf5YFyB4PKhKlXJxENZpJrvrVWkZGEePQ+v2+
P9pVD54vBW7wSUAnYaQ/6cuXrWbxUsOzPVGafC3a7Nka1OD8zjBMwnsVtStJ5poE
6I0JqAtBnHP0EbOPj8pk
=hGyE
-----END PGP SIGNATURE-----

--lB5lpsYNudRQbnvCa5GSZAeI4OY55eDRs--
