From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 15:02:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020910130201.GO2992@marowsky-bree.de>
References: <20020909095652.A21245@eng2.beaverton.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909184026.GD1334@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020909184026.GD1334@beaverton.ibm.com>
To: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2002-09-09T11:40:26,
   Mike Anderson <andmike@us.ibm.com> said:

> When you get into networking I believe we may get into path failover
> capability that is already implemented by the network stack. So the
> paths may not be visible to the block layer.

It depends. The block layer might need knowledge of the different paths=
 for
load balancing.

> The utility does transcend SCSI, but transport / device specific
> characteristics may make "true" generic implementations difficult.

I disagree. What makes "generic" implementations difficult is the absol=
utely
mediocre error reporting and handling from the lower layers.

With multipathing, you want the lower level to hand you the error
_immediately_ if there is some way it could be related to a path failur=
e and
no automatic retries should take place - so you can immediately mark th=
e path
as faulty and go to another.=20

However, on a "access beyond end of device" or a clear read error, fail=
ing a
path is a rather stupid idea, but instead the error should go up immedi=
ately.

This will need to be sorted regardless of the layer it is implemented i=
n.

How far has this been already addressed in 2.5 ?

> > > For sd, this means if you have n paths to each SCSI device, you a=
re
> > > limited to whatever limit sd has divided by n, right now 128 / n.
> > > Having four paths to a device is very reasonable, limiting us to =
32
> > > devices, but with the overhead of 128 devices.=20
> >=20
> > I really don't expect this to be true in 2.6.
> >=20
> While the device space may be increased in 2.6 you are still consumin=
g
> extra resources, but we do this in other places also.

=46or user-space reprobing of failed paths, it may be vital to expose t=
he
physical paths too. Then "reprobing" could be as simple as

	dd if=3D/dev/physical/path of=3D/dev/null count=3D1 && enable_path_aga=
in

I dislike reprobing in kernel space, in particular using live requests =
as
the LVM1 patch by IBM does it.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Immortality is an adequate definition of high availability for me.
	--- Gregory F. Pfister
