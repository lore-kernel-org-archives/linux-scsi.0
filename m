From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: Sym53C8xx Driver Hardening
Date: Thu, 25 Jul 2002 01:11:59 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020725005122.I4924-100000@localhost.my.domain>
References: <1027437862.31787.136.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1027437862.31787.136.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org


On 23 Jul 2002, Alan Cox wrote:

> On Tue, 2002-07-23 at 14:57, Rogier Wolff wrote:
> > Now it won't be as easy as this. But for instance in my firestream
> > driver, you sometimes put a value in a register in the chip, and if
> > later on you read it back, you want the chip to have left it
> > unmodified, or to have it changed in a predictable way. If the valu=
e
> > is unexpected, a panic is the right "way out".
>
> The high reliability people take a different view. I actually agree w=
ith
> them. It isnt about 'oops didnt happen' it is about controlling the
> failure case
>
> Suppose your firestream driver reports catacylsmic internal error
> status. Their argument is not that you should pretend life is good bu=
t
> that the driver should log a fault and shut off the chip as best it c=
an.
> So you might have a firestream_failed() function which did
>
> 	Disable master bit
> 	Put board into D3
> 	Wait
> 	Put board into running state
> 	Try to reset and configure it
> 	If this fails shove it in D3 and give up
>
> At this point the high reliability system is servicing the other link=
s
> it manages and flashing warning lights to the engineers, rather than
> completely down

By the way, the sym53c8xx_2 driver (and probably version 1 too) never
intentionnaly panics the system on hardware failure detection.
The couple of calls to panic you can see in the driver are related to
software unexpected situations.
In my opinion, serious high reliability requires special hardware suppo=
rt.

On serious harware error detected, the driver simply tries to reset
everything it can in order to have a chance to restart operations
properly. May-be it should count such events and give up in some way af=
ter
some given number of retries. If you just suggest such 'give up'
operations to disable the device this should be doable, but this will n=
ot
make upper layers aware of the situation and certainly not be what most
users expect. This MEANS that serious high reliability ALSO requires
special SOFTWARE support and USER utilities, and certainly NOT ONLY be
based on some questionnable trivial tinking in device drivers, in my
opinion.

  G=E9rard.






>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
