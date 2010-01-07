From: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()
Date: Thu, 7 Jan 2010 20:58:10 +0100
Message-ID: <25e057c01001071158n1755ee99iae17522e269aa1ff@mail.gmail.com>
References: <4B3B86CC.5010205@gmail.com> <4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753990Ab0AGT6e@vger.kernel.org>
In-Reply-To: <4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 7, 2010 at 8:31 PM, Moore, Eric <Eric.Moore@lsi.com> wrote:
> nack
>
> The code beyond this check is intended for either INTERNAL_DEVICE_RES=
ET or CMP_DEVICE_RESET. =C2=A0 If the reason code is something else, we=
 will want to return. =C2=A0There are 10 other types of reason codes be=
sides these two. This proposed patch means we return only when the reas=
on code is either INTERNAL_DEVICE_RESET or CMP_INTERNAL_RESET.
>
> Eric Moore

my patch is correct but my changelog was wrong. Sorry for the
confusion. It should have been:

Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESE=
T
this still evaluates to true.

you can test this with:

#include <stdio.h>

int main()
{
        int d;
        for (d=3D0;d<4;++d)
                printf("!(%d =3D=3D 1 && %d =3D=3D 2) =3D %d\n", d, d, =
!(d =3D=3D 1
&& d =3D=3D 2));
        for (d=3D0;d<4;++d)
                printf("!(%d =3D=3D 1 || %d =3D=3D 2) =3D %d\n", d, d, =
!(d =3D=3D 1
|| d =3D=3D 2));
        return 0;
}

Roel
