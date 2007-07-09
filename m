From: DervishD <lkml@dervishd.net>
Subject: Re: cdparanoia not setting count and/or reply_len properly
Date: Mon, 9 Jul 2007 13:30:25 +0200
Message-ID: <20070709113025.GB3015@DervishD>
References: <20070708103928.GA20349@DervishD> <4690DA1B.3010901@s5r6.in-berlin.de> <4691ACEA.8000607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757509AbXGILan@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4691ACEA.8000607@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

    Hi Douglas :)

 * Douglas Gilbert <dougg@torque.net> dixit:
> >>     I don't know if cdparanoia should be fixed, but certainly the
> >> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This w=
ay you
> >> will have the message if something goes wrong and you want more in=
fo,
> >> but in cases where the warning is harmless your log will be clean.=
=2E.
> >>
> >>     Anyway, this message is not for make suggestions, but for aski=
ng for
> >> information: why is this warning happening? naugthy cdparanoia? na=
ughty
> >> kernel? I'm a bit confused and I want to use my external DVD drive=
 for
> >> ripping from time to time, to "exercise" it...
>=20
> In Fedora 7 I see this:
>=20
> # cdparanoia --version
> cdparanoia III release 9.8 (March 23, 2001)
> (C) 2001 Monty <monty@xiph.org> and Xiphophorus

    Same version here.

> So, given that date, lk 2.4.2 was out but it was probably
> a bit early to start using the sg version 3 interface
> which first appeared in lk 2.4.1 . So that "lets annoy
> the user" message was added by someone who got burnt by
> the old sg version 2 interface and decided people needed
> to be warned. The warning comes from this code is sg.c :

    OK, grand. So it's cdparanoia's fault.

>         /*
>          * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFE=
R_FROM_DEV,
>          * but is is possible that the app intended SG_DXFER_TO_DEV, =
because the
> re
>          * is a non-zero input_size, so emit a warning.
>          */
>         if (hp->dxfer_direction =3D=3D SG_DXFER_TO_FROM_DEV)
>                 if (printk_ratelimit())
>                         printk(KERN_WARNING
>                                "sg_write: data in/out %d/%d bytes for=
 SCSI comma
> nd 0x%x--"
>                                "guessing data in;\n" KERN_WARNING "  =
 "
>                                "program %s not setting count and/or r=
eply_len pr
> operly\n",
>                                old_hdr.reply_len - (int)SZ_SG_HEADER,
>                                input_size, (unsigned int) cmnd[0],
>                                current->comm);

    Yes, I did read the code, and I didn't find any reason for it to
exist, but I didn't understand the purpose of SG_DXFER_TO_FROM_DEV.
Thanks for explaining this :))

> It is probably about time that cdparanoia was updated ...

    I think the same, but given that it works, Monty probably doesn't
have much motivation to update it. I don't know if the problem resides
in the cdparanoia program itself (so using the DAE problem from cdrkit
will fix the issue) or in the paranoia library. In this case, the
problem will affect any program using the library.

    Anyway, if you need any testing, just tell :)

    Thanks a lot!

    Ra=FAl N=FA=F1ez de Arenas Coronado

--=20
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
