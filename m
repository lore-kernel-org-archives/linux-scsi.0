From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open-FCoE on linux-scsi
Date: Sat, 05 Jan 2008 00:41:05 +0100
Message-ID: <477EC411.9040703@s5r6.in-berlin.de>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com><477E1C69.9010203@s5r6.in-berlin.de> <20080104205938U.fujita.tomonori@lab.ntt.co.jp> <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60452 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYADXl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 18:41:59 -0500
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dev, Vasu" <vasu.dev@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Love, Robert W" <robert.w.love@intel.com>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org

Dev, Vasu wrote:
[FUJITA Tomonori wrote:]
>> Agreed. My FCoE initiator design would be something like:
>>
>> scsi-ml
>> fcoe initiator driver
>> libfcoe
>> fc_transport_class (inclusing fcoe support)
>>
>> And FCoE HBA LLDs work like:
>>
>> scsi-ml
>> FCoE HBA LLDs (some of them might use libfcoe)
>> fc_transport_class (inclusing fcoe support)

Wouldn't it make more sense to think of fc_transport_class as a FCP
layer, sitting between scsi-ml and the various FC interconnect drivers
(among them Openfc and maybe more FCoE drivers)?  I.e. you have SCSI
command set layer -- SCSI core -- SCSI transport layer -- interconnect
layer.=B9

I am not familiar with FCP/ FCoE/ FC-DA et al, but I guess the FCoE
support in the FCP transport layer should then go to the extent of
target discovery, login, lifetime management and representation of
remote ports and so on as far as it pertains to FCP (the SCSI transport
protocol, FC-4 layer) independently of the interconnect (FC-3...FC-0
layers).=B2

[...]
>> The FCoE LLD needs to exploit the exsting struct fc_rport and APIs.
>=20
> The openfc is software implementation of FC services such as FC login
> and target discovery and it is already using/exploiting  existing fc
> transport class including fc_rport struct. You can see openfc using
> fc_rport in openfc_queuecommand() and using fc transport API
> fc_port_remote_add() for fc_rport.

Hence, aren't there interconnect independent parts of target discovery
and login which should be implemented in fc_transport_class?  The
interconnect dependent parts would then live in LLD methods to be
provided in struct fc_function_template.

I.e. not only make full use of the API of fc_transport_class, also thin=
k
about changing the API _if_ necessary to become a more useful
implementation of the interface below FC-4.

-------
=B9) The transport classes are of course not layers in such a sense tha=
t
they would completely hide SCSI core from interconnect drivers.  They
don't really have to; they nevertheless live at a higher level of
abstraction than LLDs and a lower level of abstraction than SCSI core.

(One obvious example that SCSI core is less hidden than it possibly
could be can be seen by the struct fc_function_template methods having
struct scsi_target * and struct Scsi_Host * arguments, instead of struc=
t
fc_xyz * arguments.)

=B2) I'm using the term interconnect from the SCSI perspective, not fro=
m
the FC perspective.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--- ---=3D --=3D-=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
