From: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] drivers/scsi: Check NULL for kmalloc() return
Date: Fri, 7 Aug 2009 22:33:36 +0200
Message-ID: <154e089b0908071333l1d19545ay2dfaee89366120a5@mail.gmail.com>
References: <20090807183953.GA22286@fencepost.gnu.org>
	 <Pine.LNX.4.64.0908072054080.8253@ask.diku.dk>
	 <20090807194429.GA23615@fencepost.gnu.org>
	 <Pine.LNX.4.64.0908072155260.8253@ask.diku.dk>
	 <20090807201700.GB23615@fencepost.gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:55022 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbZHGUl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 16:41:57 -0400
In-Reply-To: <20090807201700.GB23615@fencepost.gnu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Davidlohr Bueso A." <dave@gnu.org>
Cc: Julia Lawall <julia@diku.dk>, kraxel@bytesex.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Aug 7, 2009 at 22:17, Davidlohr Bueso A.<dave@gnu.org> wrote:
> On Fri, Aug 07, 2009 at 09:56:48PM +0200, Julia Lawall wrote:
>> On Fri, 7 Aug 2009, Davidlohr Bueso A. wrote:
>>
>> > On Fri, Aug 07, 2009 at 08:54:44PM +0200, Julia Lawall wrote:
>> > > On Fri, 7 Aug 2009, Davidlohr Bueso A. wrote:
>> > >
>> > > > Verify that ch->dt is not NULL before using it:
>> > > > ch-dt[elem] =3D value;
>> > >
>> > > It looks like buffer should be freed as well?
>> >
>> > The way I see it, this is done in ch_remove()
>>
>> I don't see that at all. =C2=A0buffer appears to be a variable that =
is local to
>> ch_readconfig and is passed down to other functions, but never saved
>> anywhere. =C2=A0Furthermore buffer is freed in the normal exit of th=
e function,
>> so it seems likely that it should be freed on an early exit as well.
>
> Sorry, misread, for some reason I thought you were talking about free=
ing ch->dt, correting patch.
>
> Thanks,
> Davidlohr
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>
> ---
> =C2=A0drivers/scsi/ch.c | =C2=A0 =C2=A06 ++++++
> =C2=A01 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 7b1633a..bb42ceb 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -353,6 +353,12 @@ ch_readconfig(scsi_changer *ch)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* look up the devices of the data transfe=
r elements */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ch->dt =3D kmalloc(ch->counts[CHET_DT]*siz=
eof(struct scsi_device),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 GFP_KERNEL);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!ch->dt) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(buffer);

kfree(buffer) ?

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (elem =3D 0; elem < ch->counts[CHET_DT=
]; elem++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0id =C2=A0=3D -=
1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lun =3D 0;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
