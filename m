From: "jansen, frank" <jansen_frank@emc.com>
Subject: RE: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 8 Aug 2003 08:13:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <64655AAA92E6ED46B9AC9421260D96A5025BD653@srmanning.lss.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srexchimc2.lss.emc.com ([168.159.100.11]:3588 "EHLO
	srexchimc2.eng.emc.com") by vger.kernel.org with ESMTP
	id S271343AbTHHMNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 08:13:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?=27Josef_M=F6llers=27?= <josef.moellers@fujitsu-siemens.com>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>=20
> Christoph Hellwig wrote:
>=20
> > > 4. Configuration of this solution would be extremely=20
> important.  The
> > > idea here is to rely on the udev solution currently=20
> making its way into
> > > the kernel and essentially have a vendor specific multi-path
> > > configuration as a udev plug-in.
> > >
> > > 5. Vendor value add for specific devices could be encoded both as
> > > configuration (udev) pieces and plug-ins to the upper=20
> layer multi-path
> > > driver to activate any proprietary vendor specific=20
> configuration options
> > > that may be needed for specific solutions.
> >=20
> > What are examples of such value add?
>=20
> Some older EMC RAID boxes need a special "TRESPASS" command=20
> (implemented
> as a MODE SELECT) to switch the ownership of a LUN from one path
> ("Storage Processor") to the other. The newer ones do this
> automatically, though.

The delineation between the EMC boxes that require vs. not require
a "TRESPASS" command lies not with their age, but rather their family.
The CLARiiON family of Storage Arrays require a "TRESPASS" command to
move a LUN from one redundant Storage Processor (SP) to another.  On th=
e
other hand, Symmetrix Storage Arrays do not use any such behavior.  In
a nutshell, the Symmetrix is active on all paths, on which the LUN is
presented, whereas the CLARiiON is active on one SP and passive on the
other SP.

> Without the TRESPASS, you'd see the LUN (INQUIRY), but you can't do
> anything with it, even a simple READ CAPACITY fails.

This is correct.  Note, that it is not necessarily desirable to TRESPAS=
S
the LUN, as there may be an active path from the other SP to this or
another HBA on the host system.

> --=20
> Josef M=F6llers (Pinguinpfleger bei FSC)
> 	If failure had no penalty success would not be a prize
> 						-- T.  Pratchett
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
