From: Douglas Gilbert <dougg@torque.net>
Subject: Re: cdparanoia not setting count and/or reply_len properly
Date: Sun, 08 Jul 2007 23:35:06 -0400
Message-ID: <4691ACEA.8000607@torque.net>
References: <20070708103928.GA20349@DervishD> <4690DA1B.3010901@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759459AbXGIDfy@vger.kernel.org>
In-Reply-To: <4690DA1B.3010901@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> DervishD wrote at lkml:
>>     Hi all :)
>>
>>     I know, this has been treated on the list before (year 2005) but
>> without any real solution I'm aware of.
>>
>>     I'm running kernel 2.6.20.14, and I have an ATAPI DVD writer tha=
t I
>> use with an IDE-to-USB adapter, so it appears as an SCSI drive to th=
e
>> kernel.
>>
>>     Anytime I rip anything with it, the log fills with the same mess=
age:
>> some numbers about a certain number of bytes and the old friend mess=
age
>> that I've put in the subject.
>>
>>     I assume that the warning makes sense, but the fact is that my l=
og
>> is full with the same message, the ripping is correct (so cdparanoia=
 is
>> working OK WRT ripping) and if weren't for the printk_ratelimit, the
>> system will freeze.
>>
>>     I don't know if cdparanoia should be fixed, but certainly the
>> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way=
 you
>> will have the message if something goes wrong and you want more info=
,
>> but in cases where the warning is harmless your log will be clean...
>>
>>     Anyway, this message is not for make suggestions, but for asking=
 for
>> information: why is this warning happening? naugthy cdparanoia? naug=
hty
>> kernel? I'm a bit confused and I want to use my external DVD drive f=
or
>> ripping from time to time, to "exercise" it...
>>
>>     Thanks a lot in advance :)
>>
>>     Ra=FAl N=FA=F1ez de Arenas Coronado
>>
>=20
> This question is better asked at lsml.  (Therefore I'm quoting in ful=
l.)

In Fedora 7 I see this:

# cdparanoia --version
cdparanoia III release 9.8 (March 23, 2001)
(C) 2001 Monty <monty@xiph.org> and Xiphophorus

Report bugs to paranoia@xiph.org
http://www.xiph.org/paranoia/


So, given that date, lk 2.4.2 was out but it was probably
a bit early to start using the sg version 3 interface
which first appeared in lk 2.4.1 . So that "lets annoy
the user" message was added by someone who got burnt by
the old sg version 2 interface and decided people needed
to be warned. The warning comes from this code is sg.c :

        /*
         * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_=
=46ROM_DEV,
         * but is is possible that the app intended SG_DXFER_TO_DEV, be=
cause the
re
         * is a non-zero input_size, so emit a warning.
         */
        if (hp->dxfer_direction =3D=3D SG_DXFER_TO_FROM_DEV)
                if (printk_ratelimit())
                        printk(KERN_WARNING
                               "sg_write: data in/out %d/%d bytes for S=
CSI comma
nd 0x%x--"
                               "guessing data in;\n" KERN_WARNING "   "
                               "program %s not setting count and/or rep=
ly_len pr
operly\n",
                               old_hdr.reply_len - (int)SZ_SG_HEADER,
                               input_size, (unsigned int) cmnd[0],
                               current->comm);

That code wasn't written be me and I would gladly remove it.
=46or anyone who has read the sg driver documentation,
SG_DXFER_TO_FROM_DEV implies a _read_ from the device. The
reason SG_DXFER_TO_FROM_DEV exists is for backward
compatibility to the sg version 1 interface. It was a hack to
get around the fact that the SCSI subsystem didn't report short
reads (what folks should use 'resid' for) back in those days.


It is probably about time that cdparanoia was updated ...

Doug Gilbert
