From: Hannes Reinecke <hare@suse.de>
Subject: Re: RE: [PATCH 0/4] scsi_dh: Make
	scsi_dh_activate	asynchronous
Date: Fri, 09 Oct 2009 11:44:31 +0200
Message-ID: <4ACF05FF.2030401@suse.de>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>	<4AC9EE1B.7030702@suse.de>
	<1254785154.15826.18.camel@chandra-ubuntu>	<4ACAFAF5.5000805@suse.de>
	<E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF474ED95C8@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474ED95C8@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, device-mapper development <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Qi,
	Yanling" <Yanling.Qi@lsi.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Moger, Babu wrote:
> Hi Hannes,
> I have tested the patch you had sent. Failover works fine.=20
>=20
> But, we are seeing problems during the failback. It is causing continue=
s mode-select thrashing(ping pong).
>=20
> Reason for this is, handler does not know if the mode select is coming =
for failover or failback. Every mode select will cause movement of all th=
e Luns. It does not matter if the LUNs are on preferred path or not. On n=
ext polling interval, multipathd will find some Luns are not on preferred=
 path and will initiate another failback. This will result in continues p=
ing pong. I have explained this with an EXAMPLE 1 below.
>=20
> For failback to work properly, we have to have selective Lun level fail=
over.
>=20
> There is also one more Cluster scenario where we could get into thrashi=
ng with Controller Level failover. Please see the EXAMPLE 2 below.
>=20
> We have been testing LUN level failover with device mapper for a while =
now. It is working well for us and only problem we have is slower failove=
rs with big configurations(failover was taking about 12 minutes with 234 =
luns). LSI and IBM(Chandra) has been working on  asynchronous behavior fo=
r the past 3-4 months. I have tested all the patches Chandra has posted a=
nd we have seen very good results(Failover takes only 1 minute with 234 l=
uns).
>=20
> Also, these patches give the opportunity for other handlers to move to =
asynchronous behavior if they wish to. We need your(and Linux community) =
help to review the patches and move forward on this issue.
>=20
> Thanks
> Babu Moger
> LSI Corporation
>=20
>=20
> Following are the two example where we could see mode-select thrashing.=
.=20
>=20
> EXAMPLE 1 (mode select thrashing with 2 Luns in single host)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> Let's take a very simple example.
>=20
> I have 2 Luns on my host. Host is seeing both the controllers with one =
path to each controller.
>=20
> Lun 0 is owned by controller A and preferred owner is A.
> Lun 1 is owned by controller B and preferred owned is B
>=20
> Here is multipath -ll output..
>=20
> mpath237 (3600a0b80000f519c0000cc8a48fc7d0b) dm-4 LSI,INF-01-00
> [size=3D2.0G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D100][active]  =20
>  \_ 1:0:0:0 sde 8:64  [active][ready] (controller A)
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 2:0:0:0 sdi 8:128 [active][ghost] (controller B)
>=20
> mpath180 (3600a0b80000f519c0000cc9048fc7d7b) dm-5 LSI,INF-01-00
> [size=3D2.0G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D100][active]  =20
>  \_ 2:0:0:1 sdj 8:144 [active][ready] (controller B)
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:0:1 sdf 8:80  [active][ghost] (controller A)
>=20
>=20
> 1. Run I/O on both these Luns
> 2. Pull the cable connected to controller A.
> 3. Failover will happen and Lun 0 will move to controller B. Now both t=
he Luns are on controller B.
> 4. Connect the cable back on controller A.
> 5. multipath tool will detect the physical Luns on controller A and run=
 the priority test.
> 6. It will find that Lun 0 is not on preferred path and will initiate a=
 failback.=20
>    Because it is a controller level failover it will move the Lun 1 als=
o to controller A.
>    Now both the Luns are on controller A.
> 7. Multipath tool will come again and find Lun 1 not on preferred path =
and initiate failback.
>    This will both the Luns to controller B.
>    This will continue forever.  =20
>=20
Hmm. Yes, correct.
After all, the patch I sent was meant to be a proof of concept, not a ful=
ly fledged
solution. (In fact, I'm quite surprised it worked so well :-)

What about modifying the LUN select code to switch all _visible_ LUNs (ie=
 all LUNs which
are _not_ on the preferred path) in one go?
That way we wouldn't run into this issue.

>=20
>=20
> EXAMPLE 2: (mode select thrashing in cluster setup)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> Let's take two node cluster environment where luns are visible across m=
ultiple nodes, although any
> given lun would only be accessible via one node at a time.  If a cluste=
r configuration were to get
> into a state where one node only has visibility to one controller while=
 another node only has
> visibility to the alternate, a =93thrashing=94 condition could happen. =
 Take this example:
>=20
> =95	32 luns have been mapped from the storage to all nodes.
> =95	Luns 0-15 are owned by the =91A=92 controller and being accessed by=
 node #1; luns 16-31 are owned by =91B=92 and mapped to node #2.
> =95	Node #1 only has access to the =91A=92 controller; node #2 only has=
 access to the =91B=92 controller.
>=20
> Let=92s say Node #1 decides to access lun 16.  Because it does not have=
 visibility to the =91B=92 controller
> it must issue a volume transfer request.  With Controller failover solu=
tion the volume transfer request
> would also move luns 17-31.  If node #2 were accessing those luns they =
would receive ownership errors,
> causing a volume transfer request to move them back.  However, this als=
o moves lun 16 from =91A=92 back to =91B=92,
> causing node #1 to do the volume transfer request again=85..etc. =20
>=20
Again, I think this can be solved by just moving the LUNS _not_ on the pr=
eferred path.
The difference between the existing solution would be to move all LUNs no=
t on the preferred path in
on go, instead of moving the LUNs one by one.

Will see to draw up a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
