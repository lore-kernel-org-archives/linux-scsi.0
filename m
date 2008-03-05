From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 16:14:03 -0300
Message-ID: <a7108f870803051114t5215905ble09577832cd8e99b@mail.gmail.com>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
	 <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
	 <1204734777.3047.40.camel@localhost.localdomain>
	 <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
	 <1204737026.3047.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:8420 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYCETOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 14:14:05 -0500
Received: by rv-out-0910.google.com with SMTP id k20so997751rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 11:14:04 -0800 (PST)
In-Reply-To: <1204737026.3047.45.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 3/5/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrot=
e:
> On Wed, 2008-03-05 at 13:52 -0300, Rodrigo Severo wrote:
>  > On 3/5/08, James Bottomley <James.Bottomley@hansenpartnership.com>=
 wrote:
>  > > On Wed, 2008-03-05 at 13:26 -0300, Rodrigo Severo wrote:
>  > >  > On 3/5/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
>  > >  > > Sounds like you have a bad SCSI cable or drive.
>  > >  > >
>  > >  > >  Do any of these drives work in any other OS environment?
>  > >  >
>  > >  > This same drive with this same cable with this same terminato=
r works
>  > >  > well with a 39160 (which usses another driver: the aic7xxx) o=
n the
>  > >  > same OS environment so I don't think this is a cable or drive=
 issue.
>  > >
>  > > That's only ultra 160 capable.  What happens if you take the spe=
eds for
>  > >  the drives down in the bios of the 29320?
>  >
>  > I changed the following values on  29320LPE from the previous defa=
ult ones:
>  >
>  > Sync Transfer Rate: 160
>  > Packetized: No
>  > QAS: No
>  >
>  > The error messages are unchanged.
>
> That does point further to card problems.
>
>  > >  > Besides I tested with four different cables (different models=
 and
>  > >  > manufactures, all pretend to be U320 compatible). The problem=
 is
>  > >  > unchanged when I use different cables and terminators.
>  > >  >
>  > >  > I also tested with several different disks (different models =
and
>  > >  > manufactures). The problem is still unchanged.
>  > >
>  > > It's sounding a bit more like a damaged board ... but try reduci=
ng the
>  > >  speed in the bios.
>  >
>  > As I said before, you have much more experience on SCSI issues but=
 I
>  > still can't see how a damaged SCSI board would work on one motherb=
oard
>  > model. Do you really think this is possible?
>
>
> Certainly ... depends on the problem ... for instance, you could have=
 a
>  damaged trace in the high 32 bits and not see the problem when you p=
ut
>  it in a 32 bit slot.  Likewise, it could be a capacitance problem on=
 the
>  traces and your motherboard that works has a lower PCI bus speed.

I have not mentioned that this board - the 29320LPE - is a 1x PCI
Express, not a PCI-X, please forgive me.

Back to the issue at hand, being a 1x PCI Express board there can be
no lines used when installed on one motherboard and not used when on
another motherboard AFAICT.

Also I am not aware of any different bus speeds for the PCI Express
bus I'm not a PCI Express specialist so I may be wrong here.

>  The fact that it works in one system tends to rule out software driv=
er
>  problems.  If you've tried different cables and reducing the speed, =
that
>  tends to eliminate the interconnect, so all that's left is the card =
(and
>  the motherboards, I suppose, although three failing would tend to ru=
le
>  them out).

I understand your line of reasoning.

But I think this is not the case as I gathered several reports on the
net from users with this same SCSI board having problems with several
chipsets and managing to make it work on some few specific
motherboards. This is what's happening to me.

As far as I can tell none managed to get a usefull statement from
Adaptec on the subject so I really can't tell if this is a SCSI board
problem, a chipset problem or even a driver problem. Several tried. I
did. Got absolutely no answer at all from Adaptec, only dead silence.

Anyway, I might have a broken SCSI board but the same exactly fact
that convinces you that the board is malfunctiong (work in one
motherboard and not in three others) is the kind of argument that I'm
sure Adaptec will use to argue the opposite: the SCSI board must be
working well if it works in one motherboard.

Here are some tests I already did:

On the motherboard that the PCI-e 29320LPE card worked I managed to
copy several (>70) giga of data copied onto disks connected to it and
then start the MySQL server that used this data. It worked for less
than a hour before I got a kernel panic. At this point I just changed
the SCSI board to a PCI-X 39160. I got another kernel panic in less
than a hour. I was using plain kernel 2.6.24.3. I got back to a Gentoo
specific kernel 2.6.22 and the same 39160 board is working perfect for
more than 48 hours. The PCI-e 29320LPE panics after 15 minutes or so
with this last kernel.

I didn't took note of the details of the kernel panics but they looked
quite the same to me: both the PCI-e 29320LPE and the PCI-X 39160.
This makes me believe there are other things wrong. I would like to
iron these out before I decide the new PCI-e 29320LPE is broken. I'm
just not sure how to do it.


Rodrigo Severo

--=20
-----------------------------------------------------------------------=
----------------
Rodrigo Severo

=46=E1brica de Id=E9ias
SBS Quadra 2 - Bloco S - Ed. Empire Center - Sala 1.301
Bras=EDlia - DF - CEP 70070-904
Tel. (61) 3321-1357       Fax (61) 3223-1712
-----------------------------------------------------------------------=
----------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
