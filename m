From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Open-FCoE on linux-scsi
Date: Sun, 6 Jan 2008 13:14:28 +0900
Message-ID: <20080106131732H.tomof@acm.org>
References: <20080104205938U.fujita.tomonori@lab.ntt.co.jp>
	<08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>
	<477EC411.9040703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41459 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbYAFEOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 23:14:55 -0500
In-Reply-To: <477EC411.9040703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: vasu.dev@intel.com, fujita.tomonori@lab.ntt.co.jp, robert.w.love@intel.com, tomof@acm.org, yi.zou@intel.com, christopher.leech@intel.com, linux-scsi@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

On Sat, 05 Jan 2008 00:41:05 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Dev, Vasu wrote:
> [FUJITA Tomonori wrote:]
> >> Agreed. My FCoE initiator design would be something like:
> >>
> >> scsi-ml
> >> fcoe initiator driver
> >> libfcoe
> >> fc_transport_class (inclusing fcoe support)
> >>
> >> And FCoE HBA LLDs work like:
> >>
> >> scsi-ml
> >> FCoE HBA LLDs (some of them might use libfcoe)
> >> fc_transport_class (inclusing fcoe support)
>=20
> Wouldn't it make more sense to think of fc_transport_class as a FCP
> layer, sitting between scsi-ml and the various FC interconnect driver=
s
> (among them Openfc and maybe more FCoE drivers)?  I.e. you have SCSI
> command set layer -- SCSI core -- SCSI transport layer -- interconnec=
t
> layer.=B9

Oops, I should have depicted:

scsi-ml
fc_transport_class (inclusing fcoe support)
=46CoE HBA LLDs (some of them might use libfcoe)

As you pointed out, that's the correct layering from the perspective
of SCSI architecture. I put FCoE HBA LLDs over fc_transport_class just
because LLDs directly interact with scsi-ml to perform the main work,
queuecommand/done (as you explained in 1).


> I am not familiar with FCP/ FCoE/ FC-DA et al, but I guess the FCoE
> support in the FCP transport layer should then go to the extent of
> target discovery, login, lifetime management and representation of
> remote ports and so on as far as it pertains to FCP (the SCSI transpo=
rt
> protocol, FC-4 layer) independently of the interconnect (FC-3...FC-0
> layers).=B2
>=20
> [...]
> >> The FCoE LLD needs to exploit the exsting struct fc_rport and APIs=
=2E
> >=20
> > The openfc is software implementation of FC services such as FC log=
in
> > and target discovery and it is already using/exploiting  existing f=
c
> > transport class including fc_rport struct. You can see openfc using
> > fc_rport in openfc_queuecommand() and using fc transport API
> > fc_port_remote_add() for fc_rport.
>=20
> Hence, aren't there interconnect independent parts of target discover=
y
> and login which should be implemented in fc_transport_class?  The
> interconnect dependent parts would then live in LLD methods to be
> provided in struct fc_function_template.

Agreed. Then FCoE helper functions that aren't useful for all the FCoE
LLDs would go libfcoe like iscsi class does (and sas class also does,
I guess).


> I.e. not only make full use of the API of fc_transport_class, also th=
ink
> about changing the API _if_ necessary to become a more useful
> implementation of the interface below FC-4.
>=20
> -------
> =B9) The transport classes are of course not layers in such a sense t=
hat
> they would completely hide SCSI core from interconnect drivers.  They
> don't really have to; they nevertheless live at a higher level of
> abstraction than LLDs and a lower level of abstraction than SCSI core=
=2E
>=20
> (One obvious example that SCSI core is less hidden than it possibly
> could be can be seen by the struct fc_function_template methods havin=
g
> struct scsi_target * and struct Scsi_Host * arguments, instead of str=
uct
> fc_xyz * arguments.)
>=20
> =B2) I'm using the term interconnect from the SCSI perspective, not f=
rom
> the FC perspective.
> --=20
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D=3D--- ---=3D --=3D-=3D
> http://arcgraph.de/sr/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
