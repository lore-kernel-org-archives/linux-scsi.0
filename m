From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 19:33:09 +0100
Message-ID: <c6b1100b0906081133q5dc9671eu172a8a327c43cbd9@mail.gmail.com>
References: <200906061959.55592.chris2553@googlemail.com>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244480796.4079.301.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62464 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZFHSdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 14:33:09 -0400
In-Reply-To: <1244480796.4079.301.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

2009/6/8 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2009-06-08 at 09:21 -0700, Linus Torvalds wrote:
>>
>> On Mon, 8 Jun 2009, Chris Clayton wrote:
>> >
>> > OK. I reversed that change and built and installed the kernel. It =
has
>> > withstood 100 reboots without a panic. Additionally, I pulled the
>> > latest changes (that will be rc8-git5, I think) from kernel.org,
>> > reversed the change to that kernel and built and installed it. Tha=
t
>> > too withstood 100 reboots without a panic.
>> >
>> > Let me know if there's anything else I can do to help fix this.
>>
>> That's already pretty convincing.
>>
>> James, Arjan? The original oops message is here (a jpg screen captur=
e,
>> unable to open initial console):
>>
>> =A0 =A0 =A0 http://lkml.org/lkml/2009/6/6/142
>>
>> and it's this bug entry:
>>
>> =A0 =A0 =A0 Bug-Entry =A0 =A0 =A0 : http://bugzilla.kernel.org/show_=
bug.cgi?id=3D13474
>> =A0 =A0 =A0 Subject =A0 =A0 =A0 =A0 : Oops whilst booting
>> =A0 =A0 =A0 Submitter =A0 =A0 =A0 : Chris Clayton <chris2553@googlem=
ail.com>
>> =A0 =A0 =A0 Date =A0 =A0 =A0 =A0 =A0 =A0: 2009-06-06 18:59 (2 days o=
ld)
>> =A0 =A0 =A0 References =A0 =A0 =A0: http://marc.info/?l=3Dlinux-kern=
el&m=3D124431487924254&w=3D4
>>
>> and now bisected down to
>>
>> >> commit d5a877e8dd409d8c702986d06485c374b705d340
>> >> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> >> Date: =A0 Sun May 24 13:03:43 2009 -0700
>> >>
>> >> =A0 =A0 async: make sure independent async domains can't accident=
ally entangle
>>
>> please advice. Otherwise I'll have to revert.
>
> I think it's a bug in the async code. =A0It's providing cookies too h=
igh
> because it doesn't stop after it finds a running entry.
>
> Can we try this as the fix?
>
> James
>
> ---
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 5054030..e4909ee 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -97,7 +97,7 @@ static async_cookie_t =A0__lowest_in_progress(struc=
t list_head *running)
> =A0 =A0 =A0 =A0if (!list_empty(running)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D list_first_entry(running,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct async_entry, li=
st);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D entry->cookie;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return entry->cookie;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (!list_empty(&async_pending)) {
>

I can also confirm that a kernel with this patch applied has withstood
the 100-boot torture. I'll try Linus's version now and report back
asap.

Chris

--=20
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
