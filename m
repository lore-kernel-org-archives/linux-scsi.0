From: Hannes Reinecke <hare@suse.de>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Mon, 8 Feb 2016 08:32:26 +0100
Message-ID: <56B8448A.3000106@suse.de>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk>
 <1454886441.2329.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454886441.2329.27.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/08/2016 12:07 AM, James Bottomley wrote:
> On Sun, 2016-02-07 at 15:28 -0700, Jens Axboe wrote:
>> On 02/07/2016 09:04 AM, James Bottomley wrote:
>>> On Sun, 2016-02-07 at 10:22 +0100, Christoph Hellwig wrote:
>>>> Keith said it should be on by default, and I promised him to
>>>> change
>>>> it once we run into problems, which I guess this counts as.
>>>>
>>>> But just curious:  what distro are you using?  Upstream systemd
>>>> explicitly rejected using scsi_id for NVMe here:
>>>>
>>>> 	https://github.com/systemd/systemd/issues/1453
>>>>
>>>> and all my test systems don't do this either.
>>>
>>> This was SUSE (in my case, openSUSE Leap).  I just checked the
>>> source
>>> package; they patch the by-id rules back in for NVME:
>>>
>>> # PATCH-FIX-SUSE 1101-rules-persistent-device-names-for-NVMe
>>> -devices.patch (bsc#944132)
>>> Patch1101:      1101-rules-persistent-device-names-for-NVMe
>>> -devices.patch
>>>
>>> The bugzilla is giving access denied for bug id 944132, so it's
>>> likely
>>> some proprietary vendor problem.  The patch has no preamble, so
>>> it's
>>> hard to tell what they were thinking.
>>
>> I run root-on-nvme on my laptop, and I haven't observed any problems=
=2E
>=20
> Me too apparently.  It looks like this problem may be SUSE specific
> unless another distro has enabled this.  I can see why they would: yo=
u
> do need persistent names for devices, even NVMe ones.
>=20
>> Generally I hate for options to default y unless absolutely=20
>> necessary, it's a sure fire way to feature creep your kernel without=
=20
>> noticing. I don't think getting all hot about this issue is fair, if=
=20
>> the only known case is suse.
>=20
> Well, OK, I'm annoyed because it was a systemd system which means
> debugging boot failures are excruciatingly difficult so it took me a
> week and a half to find out what the problem was.  Perhaps I was a bi=
t
> rash to label this as an easily foreseen problem.
>=20
> I opened a bug against SUSE to tell them to turn it on:
>=20
> https://bugzilla.opensuse.org/show_bug.cgi?id=3D965497
>=20
> The second problem is that there's currently no way to transition to
> using the serial attribute the way the udev 60-persistent-storage.rul=
es
> are written, so if distros have some by-id hack, it will have to be
> maintained for a while.  I annotated the already closed bug on this i=
n
> systemd with the rules that work for me.
>=20
Why, but you can.
That's precisely what I did with the transition to sg_inq; I've
added a new set of rules (55-sg_inq.rules and 59-sg-symlinks.rules)
which will override the values from 60-persistent-storage.rules.

Do we have defined sysfs attributes for NVMe devices nowadays?
If so I'd be willing to create/send some sysfs rules for them.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
