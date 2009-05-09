From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] block: add alt_size
Date: Sat, 9 May 2009 18:26:56 +0200
Message-ID: <ac3eb2510905090926r4ac0bc52kb8639101f0c78d86@mail.gmail.com>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	<1241828002-12742-2-git-send-email-tj@kernel.org> <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
	<4A058D5C.6030206@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A058D5C.6030206@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com, dan.j.williams@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sat, May 9, 2009 at 16:04, Tejun Heo <tj@kernel.org> wrote:
> Kay Sievers wrote:
>> What does "alt_" stand for? I think that should be more descriptive =
in
>> an exported interface.
>
> Alternative.
>
>> And can we please keep the "size_*" in front of the name, so that th=
ey
>> group together?
>
> Maybe, but size_alt? =C2=A0Any better ideas?

"size_limit"
"size_restricted"
"size_clipped"
"size_constrain"

anything that ideally would express that this is smaller than the
actual "size", and that is is a "configured" value and not some
hardware property.

>> Also, values with magic block counts, while there is no way to get t=
he
>> blocksize with the same interface, are pretty weird. I think the
>> current "size" attribute is just a bug.
>
> Logical block size is fixed at 512 bytes. =C2=A0Offset and size are a=
lways
> represented in multiples of 512 bytes and only get converted to
> hardware block size in the lld.

Oh, good. Didn't know that this will always be 512, even for devices
with a native size larger than this.

>> Not sure, how that should be solved, by adding a "blocksize" attribu=
te
>> that is always in the same context as the current "size*" values, or
>> by just using bytes for new attributes here.
>>
>> Almost all tools I've seen using these attributes, have hardcoded *
>> 512 in there, which may cause trouble pretty soon. And this is mostl=
y
>> a failure of the interface and not of the users, I think.
>
> No, it will never break. =C2=A0It will always be 512.

Cool. No problem then. :)

> For userlevel exporting, it might have been better to use just bytes
> there as preformance isn't really an issue, but, well, it's already
> determined, so..

Right, but if it can not change, it's fine, I guess.

Thanks,
Kay
