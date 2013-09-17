From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
Date: Tue, 17 Sep 2013 10:42:00 -0400
Message-ID: <52386A38.2050401@windriver.com>
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com> <52386730.4060508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52386730.4060508@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi list <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 13-09-17 10:29 AM, Hannes Reinecke wrote:
> On 09/17/2013 04:13 AM, Doug Ledford wrote:
>> Yes, this driver is well past ready to be removed.
>>
>> Acked-by: Doug Ledford <dledford@redhat.com>
>>
>> Sent from my ASUS Pad
>>
>> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>>
>>> After getting warnings in an allyesconfig build[1] from this
>>> driver, I decided to remind myself just how old it was, and
>>> whether it warranted fixing.  In the Kconfig help text, I found:
>>>
>>>  "This driver will eventually be phased out entirely"
>>>
>>> Going back to the history archive, I see the line was added[2]
>>> in Feb 2002, when we moved from v2.4.2.1 ---> v2.4.2.2
>>>
>>> So, with over a decade of notification, and multiple major releases
>>> since then, I think we can justify removing this.  Currently we hav=
e
>>> people wasting time building it during routine testing, and then
>>> wasting more time re-researching the known reported warnings, only =
to
>>> find that nobody really is willing to integrate the fixes[3] for it=
=2E
>>>
>>> A quick search didn't seem to indicate any active user base for it.
>>> If someone happens to have a quirky _old_ card that the eleven year
>>> old "new" driver doesn't work with, then it is entirely reasonable
>>> that they stick with a kernel version that predates this removal.
>>>
>>> [1] drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_regist=
er=E2=80=99:
>>>    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value =E2=80=98=
257=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitc=
h]
>>>    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value =E2=80=98=
513=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitc=
h]
>>>    drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_load_se=
eprom=E2=80=99:
>>>    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value =E2=80=98=
257=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitc=
h]
>>>    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value =E2=80=98=
513=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitc=
h]
>>>
>>> [2] http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git co=
mmit 44e8778c
>>>
>>> [3] https://lkml.org/lkml/2012/10/29/215
>>>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: Doug Ledford <dledford@redhat.com>
>>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>=20
> However, if we do this we're removing support for any non-PCI based
> adapters. I personally doubt that there are any installations left
> running on (E)ISA or VLB. But we should be clear on this.

Is the Kconfig text for the "new" driver wrong then?  It says:

 ---------------------
config SCSI_AIC7XXX
        tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
        depends on (PCI || EISA) && SCSI
        select SCSI_SPI_ATTRS
        ---help---
        This driver supports all of Adaptec's Fast through Ultra 160 PC=
I
        based SCSI controllers as well as the aic7770 based EISA and VL=
B
        SCSI controllers (the 274x and 284x series).
 ---------------------

So, as long as you'd enabled either of PCI or EISA, a VLB card should
work too.  (Of course you are correct in doubting that anyone is genuin=
ely
using a 486 VLB system with ~16MB RAM, so it is largely a moot point.)

[I probably could delete that "(New Driver)" text as part of this commi=
t too].

Thanks,
Paul.
--

>=20
> In general I'm in favour removing obsolete drivers, so
>=20
> Acked-by: Hannes Reinecke <hare@suse.de>
>=20
> Cheers,
>=20
> Hannes
>=20
