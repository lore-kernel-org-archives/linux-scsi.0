From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 12:26:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020910122650.A13738@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909170847.A24352@eng2.beaverton.ibm.com> <20020910131606.GQ2992@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020910131606.GQ2992@marowsky-bree.de>; from lmb@suse.de on Tue, Sep 10, 2002 at 03:16:06PM +0200
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 10, 2002 at 03:16:06PM +0200, Lars Marowsky-Bree wrote:
> On 2002-09-09T17:08:47,
>    Patrick Mansfield <patmans@us.ibm.com> said:

> > Yes negotiation is at the adapter level, but that does not have to =
be tied
> > to a Scsi_Device. I need to search for Scsi_Device::hostdata usage =
to
> > figure out details, and to figure out if anything is broken in the =
current
> > scsi multi-path code - right now it requires the same adapter drive=
rs be
> > used and that certain Scsi_Host parameters are equal if multiple pa=
ths
> > to a Scsi_Device are found.
>=20
> This seems to be a serious limitation. There are good reasons for wan=
ting to
> use different HBAs for the different paths.

What reasons? Adapter upgrades/replacement on a live system? I can imag=
ine
someone using different HBAs so that they won't hit the same bug in bot=
h
HBAs, but that is a weak argument; I would think such systems would wan=
t
some type of cluster failover.

If the HBAs had the same memory and other limitations, it should functi=
on
OK, but it is hard to figure out exactly what might happen (if the HBAs=
 had
different error handling characteristics, handled timeouts differently,
etc.). It would be easy to get rid of the checking for the same drivers=
,
(the code actually checks for the same drivers via Scsi_Host::hostt, no=
t
the same hardware) - so it would allow multiple paths if the same drive=
r
is used for different HBA's.

> And the Scsi_Device might be quite different. Imagine something like =
two
> storage boxes which do internal replication among them; yes, you'd on=
ly want
> to use one of them normal (because the Cache-coherency traffic is goi=
ng to
> kill performance otherwise), but you can failover from one to the oth=
er even
> if they have different SCSI serials etc.

> And software RAID on top of multi-pathing is a typical example for a =
truely
> fault tolerant configuration.
>=20
> Thats obviously easier with md, and I assume your SCSI code can also =
do that
> nicely.

I haven't tried it, but I see no reason why it would not work.

> > Agreed, but having the block layer be everything is also wrong.
>=20
> Having the block device handling all block devices seems fairly reaso=
nable to
> me.

Note that scsi uses the block device layer (the request_queue_t) for
character devices - look at st.c, sg.c, and sr*.c, calls to scsi_do_req=
()
or scsi_wait_req() queue to the request_queue_t. Weird but it works - y=
ou can
open a CD via sr and sg at the same time.

> > My view is that md/volume manager multi-pathing is useful with 2.4.=
x, scsi
> > layer multi-path for 2.5.x, and this (perhaps with DASD) could then=
 evolve
> > into generic block level (or perhaps integrated with the device mod=
el)
> > multi-pathing support for use in 2.7.x. Do you agree or disagree wi=
th this
> > approach?
>=20
> Well, I guess 2.5/2.6 will have all the different multi-path implemen=
tations
> mentioned so far (EVMS, LVM2, md, scsi, proprietary) - they all have =
code and
> a userbase... All of them and future implementations can benefit from=
 better
> error handling and general cleanup, so that might be the best to do f=
or now.
>=20
> I think it is too soon to clean that up and consolidate the m-p appro=
aches,
> but I think it really ought to be consolidated in 2.7, and this seems=
 like a
> good time to start planning for that one.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>

The scsi multi-path code is not in 2.5.x, and I doubt it will be accept=
ed
without the support of James and others.

-- Patrick Mansfield
