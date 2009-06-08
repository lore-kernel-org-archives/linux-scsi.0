From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 18:45:51 +0100
Message-ID: <c6b1100b0906081045t47c77b94ubc89d450c3a75147@mail.gmail.com>
References: <200906061959.55592.chris2553@googlemail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244479879.4079.284.camel@mulgrave.site>
	 <1244480790.2716.7.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45965 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFHRpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 13:45:51 -0400
In-Reply-To: <1244480790.2716.7.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

2009/6/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:

> But reverting your patch Or if we return like this also fix chris
> problem :
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 94dd36f..3b492cb 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -96,15 +96,13 @@ static async_cookie_t =A0__lowest_in_progress(str=
uct list_head *running)
> =A0 =A0 =A0 =A0if (!list_empty(running)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D list_first_entry(running,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct async_entry, li=
st);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D entry->cookie;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return entry->cookie;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (!list_empty(&async_pending)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_entry(entry, &async_pend=
ing, list)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (entry->running =3D=3D=
 running) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 entry->cookie;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (entry->running =3D=3D=
 running)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
entry->cookie;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return ret;
>
>
>

I can confirm that a kernel built with Jaswinder's patch applied
survived 200 boots without a panic.

Chris

--=20
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samue=
l
Johnson
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
