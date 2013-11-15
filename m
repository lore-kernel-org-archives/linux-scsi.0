From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Question on SCSI target scan
Date: Fri, 15 Nov 2013 23:53:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029547B9343@G9W0745.americas.hpqcorp.net>
References: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46625 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3KOXyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 18:54:52 -0500
In-Reply-To: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramesh Chikkanayakanahally <rcnagara@Brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>

That sounds similar to Broadcast (Asynchronous Event) in Serial Attache=
d=20
SCSI (SAS), which is defined as:
    "Originated by an SSP target port when an event occurs (e.g., a har=
d
    reset) that causes one or more unit attention conditions to be esta=
blished
    for one or more logical units accessible through the SSP target por=
t."

The SCSI architecture model neither mandates nor precludes SCSI transpo=
rt=20
protocols from defining such a mechanism.  FCP-4 (SCSI over Fibre Chann=
el)
doesn't mention using RSCN for that purpose, but it sounds like a
reasonable approach.

In SAS, there is no indication which SCSI target ports or logical unit(=
s) sent=20
the Broadcast, so sending the QUERY ASYNCHRONOUS EVENT task=20
management function to each logical unit is the quickest way to find th=
em.
Since Fibre Channel's RSCN only identifies the SCSI target port, you st=
ill=20
need to check all the logical units.

=46or each logical unit found with a pending unit attention condition, =
send
a command on which unit attention conditions are reported (a command=20
other than INQUIRY and REPORT LUNS).  REQUEST SENSE is a good choice;=20
it'll return GOOD status, return the unit attention condition as the=20
parameter data, and clear the unit attention condition.  Repeat sending
REQUEST SENSE until all the unit attention conditions have been reporte=
d;=20
there could be several queued up.

The additional sense code advises what to do next.  REPORTED LUNS=20
DATA HAS CHANGED means sending REPORT LUNS is appropriate.

Beware that just because the LUN inventory is the same doesn't mean
the logical units are the same.  A logical unit at LUN X might have bee=
n=20
deleted and another logical unit created and assigned to LUN X, but
now containing different content.  You need to check the logical unit
name (in the Device Identification VPD page) too.
---
Rob Elliott    HP Server Storage


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Ramesh Chikkanayakanahally
> Sent: Wednesday, 06 November, 2013 8:10 AM
> To: linux-scsi@vger.kernel.org
> Cc: jbottomley@parallels.com
> Subject: Question on SCSI target scan
>=20
> Hi,
>=20
> This question is related to scsi_transport_fc layer.
>=20
> Background:
> =A0=A0=A0 When new LUNs are added to a target, the target can send ch=
eck condition
> with SK/ASC/ASCQ indicating that the reported LUNS data has changed. =
Then
> the initiator can send the report LUNs command to discover the change=
s. But
> if there are currently no LUNs or in case there is no activity on exi=
sting LUNs,
> then this mechanism will not be efficient. So few target implementati=
ons
> seem to trigger RSCN with the Event qualifier set to zeroes (event no=
t
> specified) and Address format set to Port address of the effected tar=
get
> port. The expectation here is that, if the initiator had already logg=
ed into this
> target, it would verify the status of this target and if found online=
, it would
> issue report LUNs to discover the changes to LUNs. While this mechani=
sm
> does not comply with SCSI or FC standards, this looks like one of the=
 methods
> that is used by few target implementations. Assumption here is that, =
there is
> no other mechanism provided by SCSI or FC standards to achieve this.
>=20
> Question:
> =A0 The existing interfaces of scsi_transport_fc module does not seem=
 to
> provide a mechanism to trigger the SCSI target scan on a rport which =
is
> already registered using fc_remote_port_add() and is currently online=
 (not
> blocked or deleted). If this understanding is correct, would it be us=
eful to
> provide an interface that can be used to trigger the SCSI target scan=
 in the
> above mentioned scenario ?
>=20
> Could you please suggest ?
>=20
> Thanks,
> Ramesh C N
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
