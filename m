From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Wed, 7 Oct 2009 17:08:40 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474ED95C8@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	<4AC9EE1B.7030702@suse.de> <1254785154.15826.18.camel@chandra-ubuntu>
	<4ACAFAF5.5000805@suse.de>
	<E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Qi,
	Yanling" <Yanling.Qi@lsi.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>
List-Id: linux-scsi@vger.kernel.org


Hi Hannes,
I have tested the patch you had sent. Failover works fine.=20

But, we are seeing problems during the failback. It is causing continues =
mode-select thrashing(ping pong).

Reason for this is, handler does not know if the mode select is coming fo=
r failover or failback. Every mode select will cause movement of all the =
Luns. It does not matter if the LUNs are on preferred path or not. On nex=
t polling interval, multipathd will find some Luns are not on preferred p=
ath and will initiate another failback. This will result in continues pin=
g pong. I have explained this with an EXAMPLE 1 below.

For failback to work properly, we have to have selective Lun level failov=
er.

There is also one more Cluster scenario where we could get into thrashing=
 with Controller Level failover. Please see the EXAMPLE 2 below.

We have been testing LUN level failover with device mapper for a while no=
w. It is working well for us and only problem we have is slower failovers=
 with big configurations(failover was taking about 12 minutes with 234 lu=
ns). LSI and IBM(Chandra) has been working on  asynchronous behavior for =
the past 3-4 months. I have tested all the patches Chandra has posted and=
 we have seen very good results(Failover takes only 1 minute with 234 lun=
s).

Also, these patches give the opportunity for other handlers to move to as=
ynchronous behavior if they wish to. We need your(and Linux community) he=
lp to review the patches and move forward on this issue.

Thanks
Babu Moger
LSI Corporation


Following are the two example where we could see mode-select thrashing..=20

EXAMPLE 1 (mode select thrashing with 2 Luns in single host)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Let's take a very simple example.

I have 2 Luns on my host. Host is seeing both the controllers with one pa=
th to each controller.

Lun 0 is owned by controller A and preferred owner is A.
Lun 1 is owned by controller B and preferred owned is B

Here is multipath -ll output..

mpath237 (3600a0b80000f519c0000cc8a48fc7d0b) dm-4 LSI,INF-01-00
[size=3D2.0G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D100][active]  =20
 \_ 1:0:0:0 sde 8:64  [active][ready] (controller A)
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:0 sdi 8:128 [active][ghost] (controller B)

mpath180 (3600a0b80000f519c0000cc9048fc7d7b) dm-5 LSI,INF-01-00
[size=3D2.0G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D100][active]  =20
 \_ 2:0:0:1 sdj 8:144 [active][ready] (controller B)
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:0:1 sdf 8:80  [active][ghost] (controller A)


1. Run I/O on both these Luns
2. Pull the cable connected to controller A.
3. Failover will happen and Lun 0 will move to controller B. Now both the=
 Luns are on controller B.
4. Connect the cable back on controller A.
5. multipath tool will detect the physical Luns on controller A and run t=
he priority test.
6. It will find that Lun 0 is not on preferred path and will initiate a f=
ailback.=20
   Because it is a controller level failover it will move the Lun 1 also =
to controller A.
   Now both the Luns are on controller A.
7. Multipath tool will come again and find Lun 1 not on preferred path an=
d initiate failback.
   This will both the Luns to controller B.
   This will continue forever.  =20



EXAMPLE 2: (mode select thrashing in cluster setup)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Let's take two node cluster environment where luns are visible across mul=
tiple nodes, although any given lun would only be accessible via one node=
 at a time.  If a cluster configuration were to get into a state where on=
e node only has visibility to one controller while another node only has =
visibility to the alternate, a =93thrashing=94 condition could happen.  T=
ake this example:

=95	32 luns have been mapped from the storage to all nodes.
=95	Luns 0-15 are owned by the =91A=92 controller and being accessed by n=
ode #1; luns 16-31 are owned by =91B=92 and mapped to node #2.
=95	Node #1 only has access to the =91A=92 controller; node #2 only has a=
ccess to the =91B=92 controller.

Let=92s say Node #1 decides to access lun 16.  Because it does not have v=
isibility to the =91B=92 controller it must issue a volume transfer reque=
st.  With Controller failover solution the volume transfer request would =
also move luns 17-31.  If node #2 were accessing those luns they would re=
ceive ownership errors, causing a volume transfer request to move them ba=
ck.  However, this also moves lun 16 from =91A=92 back to =91B=92, causin=
g node #1 to do the volume transfer request again=85..etc. =20




> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Moger, Babu
> Sent: Tuesday, October 06, 2009 2:46 PM
> To: Hannes Reinecke; sekharan@linux.vnet.ibm.com
> Cc: michaelc@cs.wisc.edu; Stankey, Robert; linux-scsi@vger.kernel.org;
> Dachepalli, Sudhir; dm-devel@redhat.com; Chauhan, Vijay;
> Benoit_Arthur@emc.com; Qi, Yanling; Eddie.Williams@steeleye.com
> Subject: [dm-devel] RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
> asynchronous
>=20
> Thanks Hannes and Chandra for your patches and feedback.  Right now we
> are internally discussing the pros and cons of both these approaches.
> We will respond to all your question once we arrive at the conclusion.
>=20
> Also adding our Team (Bob Stankey, Sudhir, Yanling, Vijay ) in the
> response.
>=20
> Thanks
> Babu Moger
>=20
> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> > Sent: Tuesday, October 06, 2009 3:08 AM
> > To: sekharan@linux.vnet.ibm.com
> > Cc: linux-scsi@vger.kernel.org; dm-devel@redhat.com; Moger, Babu;
> > michaelc@cs.wisc.edu; Benoit_Arthur@emc.com;
> > Eddie.Williams@steeleye.com; berthiaume_wayne@emc.com
> > Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
> >
> > Chandra Seetharaman wrote:
> > > On Mon, 2009-10-05 at 15:01 +0200, Hannes Reinecke wrote:
> > >
> > > Thanks for the comment and the patch. I will try the patch.
> > >
> > >> Hmm. IIRC we added the synchronous mode by request of LSI/IBM, as
> > the RDAC
> > >> handler could only support on MODE SELECT command at a time.
> > >> If LSI checked this, okay, no objections.
> > >
> > > The original patch (for rdac) came from LSI (Moger Babu), I made
> > changes
> > > to the infrastructure and to the code to fit them together.
> > >
> > >> However: The main reason why we're getting flooded with MODE
> SELECT
> > commands
> > >> is that the RDAC handler switches _each LUN_, not the entire
> > controller.
> > >> Seeing that the controller simply cannot cope with the resulting
> > MODE SELECT
> > >> flood wouldn't it be more sensible to switch the entire controller
> > here?
> > >
> > > I see your point of view.... but here is the rationale...
> > >
> > > When we originally added the rdac support (as dm_rdac), we decided
> > this
> > > way consciously for the following reasons:
> > >  1. we do not know which link is broken (hba-ctlr or ctlr-lun).
> > >     The way it is currently implemented, both these cases are
> > handled.
> > Quite. But if the ctlr-lun link is broken, we really should receive
> > and appropriate error code, which then could be handled in dm-rdac
> > appropriately. After all, the controller is still accessible and
> > so we don't have to guess what happened (which is all what multipath
> > is about). So I doubt we need to worry about this.
> >
> > >  2. multipath layer to decide what to do and this module to just do
> > >     what it was told.
> > Yep.
> >
> > >  3. since multipath sends pg_init only if there is any IO sent to
> the
> > >     lun, (with the current implementation) we don't have to change
> > >     ownership (back and forth) of all the luns if the user is using
> > only
> > >     a handful.
> > Well, yes. But if the implementation is such that changing ownership
> > for all LUNs is about as efficient as changing an individual LUN (or,
> > as the case might be, as _inefficient_ :-), surely it's better to
> > save us some coding here.
> >
> > >  4. to be consistent with LSI's original driver (which does one lun
> > at a
> > >     time).
> > :-/ That's unfair.
> > But it still has the drawback that it doesn't scale; given enough
> LUNs
> > and
> > access patterns you _inevitably_ have to send MODE SELECT commands
> for
> > each LUN, ie you only delay this issue.
> > Only by switching all LUNs you can avoid this.
> >
> > Cheers,
> >
> > Hannes
> > --
> > Dr. Hannes Reinecke		      zSeries & Storage
> > hare@suse.de			      +49 911 74053 688
> > SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
