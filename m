From: Fabien Salvi <fabien@cri74.org>
Subject: Re: LSI MegaRAID on Tyan S2469 MB
Date: Fri, 30 Jan 2004 12:13:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401A3C68.3030001@cri74.org>
References: <S560698AbUA2MxV/20040129125322Z+855@sunkay.cs.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:62422 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263466AbUA3LN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 06:13:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: Steve Sutphen <steve@cs.ualberta.ca>
Cc: linux-scsi@vger.kernel.org, philipl@aslan.ab.ca



Steve Sutphen a =E9crit:
> I am having a difficult problem with an LSI MegaRAID 320-2 that is in=
stalled
> on a Tyan S2469 mother board with AMD Athlon's.  The disks that I am =
using
> are Seagate 147GB drives.=20
> The problem is that the MegaRAID slows to a crawl, and then slows so =
much
> that it times out and cannot complete the queued commands (for ever i=
t
> seems).
> I have verified that the controller is working.  I have not been able=
 to=20
> get it to fail when I move the controller, disk array, and boot disk=20
> to a different system with a Tyan S2466 motherboard (and dual Athlon'=
s).
>=20
> [...]

> My current theory is that there is some sort of incompatibility betwe=
en
> that motherboard (or perhaps the AMD chipset) and the LSI Logic MegaR=
AID
> controller. =20

You're right :)
See below...

> Does anyone have a similar system that is working?  Has anyone encoun=
tered
> similar problems?  What should I do next?

Yes, I have exactly the same problems with the same Motherboard and I'v=
e=20
got the solution !

In my system, I use a ICP-Vortex GDT8514 RAID controller in a Chenbro=20
chassis and get segmentation fault, core dumps, kernel panics, etc...

I've contacted Chenbro, ICP-Vortex and Tyan about the problem.
Chenbro seems not in cause.

ICP-Vortex say me to set J92 jumper (force the primary PCI bus to=20
operate at 33 Mhz) and it's the solution.

There seem to be a big problem with AMD chipset and 66Mhz bus.

If you look at the Tyan documentation, they say :

<<
Due to the tight PCI 66Mhz timing of the AMD-760 MPX chipset, it may be=
=20
necessary to set the bus to 33Mhz when using Multiple PCI cards.
 >>

ICP-Vortex said :

<<
we've found that the board seems to run stable (at least during our tes=
ts)
if J92 is set, if J92 is open similar effects came up.
We've tested the MSI K7D Master which didn't show these effetcs.
 >>

And Tyan :

<<
The problem is still directly with the ICP/Vortex device.  You should b=
e
able to run this card in 66MHz mode with the non-SCSI version of the bo=
ard.
The AMD chipset is very picky and tricky to program for and it would se=
em
that ICP/Vortex is still having issues with this.

Now these cards have been tested and found to work correctly without th=
e
problems you are seeing with your particular brand:

AMI Elite 1600
DPT SmartRAID PM1564U3
Mylex AcceleRAID 250
Adaptec 3210s
 >>

But, there is no way to make it work correctly at 66 Mhz.

Good luck !

PS: I'm interested to know if it will correct your problem.



--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
