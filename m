From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Tue, 10 Sep 2002 09:03:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020910090357.A7765@eng2.beaverton.ibm.com>
References: <20020909095652.A21245@eng2.beaverton.ibm.com> <200209091734.g89HY5p11796@localhost.localdomain> <20020909184026.GD1334@beaverton.ibm.com> <20020910130201.GO2992@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020910130201.GO2992@marowsky-bree.de>; from lmb@suse.de on Tue, Sep 10, 2002 at 03:02:01PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 10, 2002 at 03:02:01PM +0200, Lars Marowsky-Bree wrote:
> On 2002-09-09T11:40:26,

> With multipathing, you want the lower level to hand you the error
> _immediately_ if there is some way it could be related to a path fail=
ure and
> no automatic retries should take place - so you can immediately mark =
the path
> as faulty and go to another.=20
>=20
> However, on a "access beyond end of device" or a clear read error, fa=
iling a
> path is a rather stupid idea, but instead the error should go up imme=
diately.
>=20
> This will need to be sorted regardless of the layer it is implemented=
 in.
>=20
> How far has this been already addressed in 2.5 ?
>=20

The current scsi multi-path code handles the above cases. There is
a scsi_path_decide_disposition() that fails paths independent of the
result of the IO. It is similiar to the current scsi_decide_disposition=
,
except it also fails the path. So for a check condition of media error,
the IO might be marked as SUCCESS (meaning completed with an error),
but the path would not be modified (there are more details than this).

> For user-space reprobing of failed paths, it may be vital to expose t=
he
> physical paths too. Then "reprobing" could be as simple as
>=20
> 	dd if=3D/dev/physical/path of=3D/dev/null count=3D1 && enable_path_a=
gain
>=20

Yes, that is a good idea, I was thinking that this should be done
via sg, and modify sg to allow path selection - so no matter what, sg
could be used to probe a path.  I have no plans to expose a user level
device for each path, but a device model "file" could be exposed for
the state of each path, and its state controlled via driverfs.

> I dislike reprobing in kernel space, in particular using live request=
s as
> the LVM1 patch by IBM does it.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
