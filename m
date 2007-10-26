From: Rob Landley <rob@landley.net>
Subject: Re: Questions about proc_scsi_write() in scsi_proc.c
Date: Fri, 26 Oct 2007 17:29:53 -0500
Message-ID: <200710261729.53400.rob@landley.net>
References: <200710261507.49284.rob@landley.net> <1193432977.3293.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52349
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756985AbXJZW35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 18:29:57 -0400
In-Reply-To: <1193432977.3293.76.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Friday 26 October 2007 4:09:37 pm James Bottomley wrote:
> On Fri, 2007-10-26 at 15:07 -0500, Rob Landley wrote:
> > I don't understanding this code:
> >
> > 1) for echo "scsi add-single-device 0 1 2 3" > /proc/scsi/scsi, is =
this
> > only for parallel scsi?
>
> No.
>
> >  I thought most modern busses (usb, sata, FC, firewire,
> > etc) dynamically assign these numbers and just use them as a unique
> > identifier ala kdev_t.  How would this work on one of the other dev=
ices?
>
> It's most often used to add or remove LUNs.

Ok, I'm unclear on what a LUN is.  All the devices I have lying around =
give me=20
a LUN of zero.  I used to think that a LUN was a bit like partition, an=
d=20
mostly used for CD changes.  The structure "scsi_target" seems to aggre=
gate=20
host/channel/target and I thought it referred to a device.

The earlier email between you, me, and Stefan, and myself said:

James Bottomley said:
> Stephan Richter said:
> > "lun" is a target-wide unique number to address a logical unit on a
> > target device. =C2=A0Its format is also a priori defined by the Lin=
ux SCSI
> > low-level API.

I think I understand that bit

> > It is possible to transform "Logical Unit Identifiers"=20
> > a.k.a. "Logical Unit Numbers" a.k.a. "LUNs" (which are either 8 byt=
es
> > wide or 2 bytes wide) into the format of the lun. =C2=A0(Logical Un=
it
> > Identifier is a property of all logical units of SCSI target device=
s.)

This is something totally different, and seems a bit like a MAC address=
?

> > The SCSI Architecture Model defines several different subspecies of=
 8
> > bytes wide LUNs. =C2=A0Some of these variants cannot be transformed=
 lossless
> > into the SCSI core's lun, but it appears that such variants of LUNs=
 are
> > not used in real hardware.
>
> Right, LUN has a specific transport independent meaning defined in SA=
M-3
> or SAM-4:
>
> http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf
> http://www.t10.org/ftp/t10/drafts/sam4/sam4r13.pdf

Unfortunately those two documents are 127 pages and 148 pages, respecti=
vely,=20
and I haven't had a chance to make any headway in them yet.

Every device I have that shows up as SCSI has shown up with a LUN of 0,=
 which=20
is target-wide unique because none of those targets have sub-functions =
that=20
need to be independently addressed as devices.

Is there an easy way to distinguish between "target-wide unique lun" an=
d this=20
Logical Unit Number device attribute that's either 8 bytes or 2 bytes w=
ide? =20
(Capitalization?)

> > 2) How do you trigger this?  /proc/scsi/scsi is read only even for =
root.
>
> root can still write to it.

Wow.  (Is this an idiosyncrasy of /proc, or a capability of root I've b=
een=20
unaware of all this time?)

> > 3) This bit is repeated in both the add and remove logic:
> >                 p =3D buffer + 23;
> >
> >                 host =3D simple_strtoul(p, &p, 0);
> >                 channel =3D simple_strtoul(p + 1, &p, 0);
> >                 id =3D simple_strtoul(p + 1, &p, 0);
> >                 lun =3D simple_strtoul(p + 1, &p, 0);
> >
> > So what happens if you echo "scsi add-single-device 0" > /proc/scsi=
/scsi
> > (or wherever file would trigger this function) so the read for chan=
nel
> > skips over the null terminator (I'm assuming there is one) and read=
s who
> > knows what?  Or what if instead of ending that with one 0, you end =
it
> > with enough zeroes to pad right up to PAGE_SIZE, so it reads the ne=
xt
> > page?  (I don't even know what the page protections are on that, de=
pends
> > how
> > __get_free_page(GFP_KERNEL) works...)
> >
> > Confused,
>
> It's relying on the user buffer being zero padded, but even if it isn=
't,
> there's not much that can go wrong.  It's also a deprecated interface=
=2E

Where do I find out what interfaces are deprecated?  (Is this written d=
own=20
somewhere?  Or do you just mean that the whole of /proc is moving to /s=
ys=20
where possible?)

> James

Thanks (still confused),

Rob
--=20
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
