From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: DM does not activate the paths if there are more
	than one path in path group during failover
Date: Tue, 11 Nov 2008 10:28:32 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BE75B98@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	<1226369188.14830.1180.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE75B77@cosmail01.lsi.com>
	<1226423419.14830.1192.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226423419.14830.1192.camel@chandra-ubuntu>
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
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: development <dm-devel@redhat.com>, "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>, device-mapper, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Here is full output of multipath -ll mpathf before the test.

[root@mymachine ~]# multipath -ll mpathf
error calling out /lib/udev/scsi_id -g -u -d /dev/sda
error calling out /lib/udev/scsi_id -g -u -d /dev/sdb
error calling out /lib/udev/scsi_id -g -u -d /dev/sdc
error calling out /lib/udev/scsi_id -g -u -d /dev/sdd
error calling out /lib/udev/scsi_id -g -u -d /dev/sdk
error calling out /lib/udev/scsi_id -g -u -d /dev/sdn
mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
[size=3D2.0G][features=3D0][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D200][active]
 \_ 3:0:0:0 sde 8:64  [active][ready]
 \_ 3:0:2:0 sdg 8:96  [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 3:0:1:0 sdf 8:80  [active][ghost]
 \_ 3:0:3:0 sdh 8:112 [active][ghost]

Thanks
Babu Moger

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
Sent: Tuesday, November 11, 2008 11:10 AM
To: Moger, Babu
Cc: linux-scsi@vger.kernel.org; device-mapper development; andmike@linux.=
vnet.ibm.com
Subject: RE: DM does not activate the paths if there are more than one pa=
th in path group during failover


On Tue, 2008-11-11 at 10:07 -0700, Moger, Babu wrote:
> Is your multipathd running?
>   Yes, multipathd deamon is running.
>
> BTW, why is the physical path state is showing "undef", it should be "g=
host" or "ready"
>
>   This is because i am running the mainstream multipath-tools. That is =
the reason you are seeing "undef".  I have reverted back to native tools =
and i am still seeing the problem. Here the output of multipath -ll with =
native tools.
>
> mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
> [size=3D2.0G][features=3D0][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 3:0:1:0 sdf 8:80  [active][ready]
>  \_ 3:0:3:0 sdh 8:112 [failed][ready]
>

can you send me the full o/p multipath -ll mpathf;

prio=3D0 means that this path group is connected to the passive
controller, in which case "failed" is correct.

>
>
> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Monday, November 10, 2008 8:06 PM
> To: Moger, Babu
> Cc: linux-scsi@vger.kernel.org; device-mapper development; andmike@linu=
x.vnet.ibm.com
> Subject: Re: DM does not activate the paths if there are more than one =
path in path group during failover
>
>
> On Mon, 2008-11-10 at 17:45 -0700, Moger, Babu wrote:
> > Hi All,
> >   I have noticed one more problem with device mapper today.
> >
> > Summary:  If there are more than one path in the path group, device m=
apper does not activate the all the paths during the failover. DM only ac=
tivates the first path in the path group. It does not call the function a=
ctivate_path for the second path (or third so on). This seems like a majo=
r problem for me. Current code does not keep track of whether the path is=
 already activated or not.  This leads DM using only first path and all o=
ther paths become unusable. This happens during the failover.
>
> We do not need to send activate to each "path" as all paths in a path g=
roup lead to the same controller and that controller is activated when th=
e activate is sent on the first path itself.
>
> Is your multipathd running ?
>
> BTW, why is the physical path state is showing "undef", it should be "g=
host" or "ready"
> >
> > Test case.
> > 1. Start the IO with all the paths.
> > 2. Fail the active path.
> > 3. Failover (mode select) will happen and passive path will be
> > activated 4. Only first path in path group is activated and other pat=
hs will be failed. I would expect the DM to activate all the paths in the=
 path group. However this does not happen.
> >
> > Output of multipath -ll before the test.
> >
> > mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
> > [size=3D2.0G][features=3D0][hwhandler=3D1 rdac][rw] \_ round-robin 0
> > [prio=3D4][enabled]  \_ 3:0:0:0 sde 8:64  [active][undef] running  \_
> > 3:0:2:0 sdg 8:96  [active][undef] running \_ round-robin 0
> > [prio=3D2][enabled]  \_ 3:0:1:0 sdf 8:80  [active][undef] running  \_
> > 3:0:3:0 sdh 8:112 [active][undef] running
> >
> >
> > Output of multipath -ll after the test. Notice that second path has f=
ailed.
> >
> > mpathf (3600a0b80000f519c0000cc8a48fc7d0b) dm-2 LSI,INF-01-00
> > [size=3D2.0G][features=3D0][hwhandler=3D1 rdac][rw] \_ round-robin 0
> > [prio=3D2][enabled]  \_ 3:0:1:0 sdf 8:80  [active][undef] running  \_
> > 3:0:3:0 sdh 8:112 [failed][undef] running
> >
> >
> > Here is the patch, I have used to work-around the problem. I am sure
> > this is not the place we want to add the fix. However, this patch
> > should give you understanding of the problem. This patch will set the
> > flags
> > m->pg_init_required and m->queue_io whenever D-M select new path in t=
he path group whenever the repeat_count is exhausted.
> >
> > --- linux-2.6.28-rc4/drivers/md/dm-mpath.c.orig 2008-11-10
> > 17:50:24.000000000 -0600
> > +++ linux-2.6.28-rc4/drivers/md/dm-mpath.c      2008-11-10 17:51:36.0=
00000000 -0600
> > @@ -245,6 +245,10 @@ static int __choose_path_in_pg(struct mu
> >         if (!path)
> >                 return -ENXIO;
> >
> > +       /* Set the pg_init_required flag to activate this path */
> > +       m->pg_init_required =3D 1;
> > +       m->queue_io =3D 1;
> > +
> >         m->current_pgpath =3D path_to_pgpath(path);
> >
> >         if (m->current_pg !=3D pg)
> >
> >
> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
