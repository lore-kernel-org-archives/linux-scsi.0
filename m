From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: Sym53C8xx Driver Hardening
Date: Sat, 27 Jul 2002 00:25:25 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020726235003.V5056-100000@localhost.my.domain>
References: <10207251533.ZM1198000@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <10207251533.ZM1198000@classic.engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rogier Wolff <R.E.Wolff@BitWizard.nl>, "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org



On Thu, 25 Jul 2002, Jeremy Higdon wrote:

> On Jul 25,  1:11am, G=E9rard Roudier wrote:
> >
> > By the way, the sym53c8xx_2 driver (and probably version 1 too) nev=
er
> > intentionnaly panics the system on hardware failure detection.
> > The couple of calls to panic you can see in the driver are related =
to
> > software unexpected situations.
> > In my opinion, serious high reliability requires special hardware s=
upport.
> >
> > On serious harware error detected, the driver simply tries to reset
> > everything it can in order to have a chance to restart operations
> > properly. May-be it should count such events and give up in some wa=
y after
> > some given number of retries. If you just suggest such 'give up'
> > operations to disable the device this should be doable, but this wi=
ll not
> > make upper layers aware of the situation and certainly not be what =
most
> > users expect. This MEANS that serious high reliability ALSO require=
s
> > special SOFTWARE support and USER utilities, and certainly NOT ONLY=
 be
> > based on some questionnable trivial tinking in device drivers, in m=
y
> > opinion.
> >
> >   G=E9rard.
>
>
> Also, with some sorts of errors, one might suspect that the device ha=
s
> DMA'd data into the wrong place in memory.
>
> Generally, I think a crash is preferable to data corruption (i.e. no
> answer is better than a wrong answer), so in such cases, the driver
> might want to panic.

The sym53c8xx ensures that all possible path checkings against errors i=
t
has under control are enabled. If the drivers gets the error, then this
ideally means that it is not a fatal system error or user or O/S does n=
ot
want it to handled so. Otherwise, some NMI should occur and the system
should halt. So, my opinion is that a hardware error that could be hand=
led
as a system error but is not so should be considered as an invitation t=
o
try to recover. Hence, the answer of the driver is the appropriate one,=
 in
my opinion.

> If hardware can place a fence around DMA (such that DMA to unintended
> locations is impossible), then you might not want to panic in such
> situations, assuming that you can retry.

You may be dreaming there. At least, I never heard about such magic in
the PCI world.

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
