From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: need help diagnosing sym53c1010-33/Fujitstu MAN3367MP/raid1
 lockups
Date: Wed, 10 Jul 2002 03:23:52 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020710024132.F4372-100000@localhost.my.domain>
References: <1026207164.10874.8402.camel@palm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1026207164.10874.8402.camel@palm>
List-Id: linux-scsi@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: linux-scsi@vger.kernel.org


On 9 Jul 2002, Philip Hands wrote:

> On Tue, 2002-07-02 at 03:00, G=E9rard Roudier wrote:
> >
> > Just quoting a couple of relevant error messages:
> >
> > > Jul  3 09:18:54 comet kernel: sym0:0: ERROR (0:48) (a-2c-0) (27/1=
8/c0) @ (scripta 220:84000000).
> >
> > SIST=3D0x48  bit 0x8 means SCSI GROSS ERROR.
> >
> > > Jul  3 09:25:23 comet kernel: sym0:1: ERROR (81:0) (e-ae-0) (3e/1=
8/80) @ (scripta 80:1e000000).
> >
> > DSTAT=3D0x81  bit 0x1 means ILLEGAL INSTRUCTION DETECTED
> >
> > Can be the result of the device asserting the SCSI REQ signal when =
the
> > initiator is expecting it to release the SCSI BUS.
> >
> > Some other error messages indicate some bad relection which is extr=
emally
> > severe in SCSI.
> >
> > I would recommend you to check the SCSI BUS.. Switch cable and/or
> > terminators for example, etc...
>
> I've tried 3 cables, and two terminators, all bought brand-new, from
> separate sources.

I didn't suggest you to purchase this much expensive hardware. I imagin=
ed
that you may have had more than one SCSI BUS and could switch parts
between them.

> Is it really that common for SCSI cables to be defective?

In presence of SCSI errors, the more common cause is some flaw on the
SCSI BUS and cables and terminators are the cheaper and the more handy
things to check by simply trying another instance of each.

> If so, is there a better way of testing them than simply buying more =
&
> more until something works?

Unless you have access to sophisticated analyzers and are able to use i=
t
properly, switching parts is the only simple way to find which one is
defective. Obviously, if it gets expensive, we want to try a more cleve=
r
method.

> What are the chances that either the controller or the drives could b=
e
> the problem?  Is there some way of diagnosing them (other than buying
> replacements, which seems like an expensive, and possibly fruitless
> approach)?

If you have one instance of each part and have to buy replacement for
each, indeed the switch method is painful.

> Sorry for the trivial questions, but it seems strange to me that what=
 is
> supposed to be a broken setup could achieve almost theoretical maximu=
m
> transfer rates when TCQ is switched off, but starts spewing errors at=
 an
> enormous rate when TCQ is switched on.

TCQ leads to a significantly different IO pattern due to IO overlapping=
=2E
Obviously, any of the involved softwares and hardwares can be biten by
this pattern but not by the smoother one corresponding to TCQ disabled.

Speaking about the SCSI BUS (everything connected together and talking
using the SCSI protocol), it may have enough electrical margin for the
no-TCQ IO pattern but not for the TCQ enabled IO pattern. At least, it =
was
what the error messages you reported seemed to indicate.

Now that we know that cable and terminators are ok, you may try, for
example, to lower the data transfer speed. This will reduce the stress =
for
all the parts connected to the SCSI BUS and will allow more margin for
SCSI signaling. Result can give some new clue.

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
