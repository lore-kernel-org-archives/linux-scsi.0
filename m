From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
Date: Wed, 21 Sep 2011 20:19:37 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D1A1150A637@SC-VEXCH4.marvell.com>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
	<20110920221051.1094.39578.stgit@localhost6.localdomain6>
	<F766E4F80769BD478052FB6533FA745D1A1150A607@SC-VEXCH4.marvell.com>
 <CABE8wwtthVnmzhsiNocQ8=475ae27GK0RyoryLhLgxhc0VWUEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwtthVnmzhsiNocQ8=475ae27GK0RyoryLhLgxhc0VWUEQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

> Subject: Re: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
>=20
> On Wed, Sep 21, 2011 at 7:26 PM, Xiangliang Yu <yuxiangl@marvell.com>=
 wrote:
> >
> >> Subject: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
> >>
> >> libsas now handles:
> >> 1/ limiting ata scanning to lun0
> >> 2/ maximizing the queue_depth of sas devices (up to 256, mvsas onl=
y
> >> =A0 =A0supports 64)
> >> 3/ changes to /sys/block/<sdX>/device/queue_depth for ata devices
> >>
> >> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >> =A0drivers/scsi/mvsas/mv_init.c | =A0 =A04 ++--
> >> =A0drivers/scsi/mvsas/mv_sas.c =A0| =A0 30 -----------------------=
-------
> >> =A0drivers/scsi/mvsas/mv_sas.h =A0| =A0 =A02 --
> >> =A03 files changed, 2 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_=
init.c
> >> index 4e9af66..052861b 100644
> >> --- a/drivers/scsi/mvsas/mv_init.c
> >> +++ b/drivers/scsi/mvsas/mv_init.c
> >> @@ -59,7 +59,7 @@ static struct scsi_host_template mvs_sht =3D {
> >> =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D DRV_NAME=
,
> >> =A0 =A0 =A0 .queuecommand =A0 =A0 =A0 =A0 =A0 =3D sas_queuecommand=
,
> >> =A0 =A0 =A0 .target_alloc =A0 =A0 =A0 =A0 =A0 =3D sas_target_alloc=
,
> >> - =A0 =A0 .slave_configure =A0 =A0 =A0 =A0=3D mvs_slave_configure,
> >> + =A0 =A0 .slave_configure =A0 =A0 =A0 =A0=3D sas_slave_configure,
> >> =A0 =A0 =A0 .slave_destroy =A0 =A0 =A0 =A0 =A0=3D sas_slave_destro=
y,
> >> =A0 =A0 =A0 .scan_finished =A0 =A0 =A0 =A0 =A0=3D mvs_scan_finishe=
d,
> >> =A0 =A0 =A0 .scan_start =A0 =A0 =A0 =A0 =A0 =A0 =3D mvs_scan_start=
,
> >> @@ -74,7 +74,7 @@ static struct scsi_host_template mvs_sht =3D {
> >> =A0 =A0 =A0 .use_clustering =A0 =A0 =A0 =A0 =3D ENABLE_CLUSTERING,
> >> =A0 =A0 =A0 .eh_device_reset_handler =3D sas_eh_device_reset_handl=
er,
> >> =A0 =A0 =A0 .eh_bus_reset_handler =A0 =3D sas_eh_bus_reset_handler=
,
> >> - =A0 =A0 .slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D mvs_slave_alloc,
> >> + =A0 =A0 .slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D sas_slave_alloc,
> >> =A0 =A0 =A0 .target_destroy =A0 =A0 =A0 =A0 =3D sas_target_destroy=
,
> >> -int mvs_slave_configure(struct scsi_device *sdev)
> >> -{
> >> - =A0 =A0 struct domain_device *dev =3D sdev_to_domain_dev(sdev);
> >> - =A0 =A0 int ret =3D sas_slave_configure(sdev);
> >> -
> >> - =A0 =A0 if (ret)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> >> - =A0 =A0 if (!dev_is_sata(dev)) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 sas_change_queue_depth(sdev,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_QUEUE_SIZE,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SCSI_QDEPTH_DEFAULT);
> >> - =A0 =A0 }
> >> - =A0 =A0 return 0;
> > Can you don't remove mvs_slave_configure function? Someday it will =
be useful,
> such as fixing some issue.
>=20
> That's exactly the point of the patch.  The isci driver encountered a
> bug that the mvsas driver had fixed in its private mvs_slave_alloc()
> routine.  If I had taken the same approach and "fixed" it with a
> isci_slave_alloc() routine that would still leave aic94xx or any othe=
r
> future libsas driver to rediscover the fix.
>=20
> If you later find a problem with sas_slave_configure() there's a good
> chance the fix will be applicable to all libsas drivers.  But if it i=
s
> truly a mvsas specific issue you can always re-introduce
> mvs_slave_configure().


Sound good.

