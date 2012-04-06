From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Sat, 7 Apr 2012 00:01:27 +0800
Message-ID: <20120406160126.GA4835@localhost.amd.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
 <CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
 <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
 <20120405083245.GA19508@localhost.amd.com>
 <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55822
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab2DFIBl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 04:01:41 -0400
Content-Disposition: inline
In-Reply-To: <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>

Hi,

On Fri, Apr 06, 2012 at 02:10:31PM +0800, Lin Ming wrote:
> >
> > I prefer we do this in sr_block_ioctl.
> > Suppose the ODD is now runtime suspended and received an ioctl:
> > if the ioctl's cmd is CDROMEJECT, resume it.
> > For other cases, return an error code like EPERM.
> > When done, according to the result of ioctl: if success, leave it r=
esumed;
> > if failed, put it back to sleep.
> >
> > Something like this:
> >
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 5fc97d2..aa6e920 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -45,6 +45,7 @@
> > =A0#include <linux/blkdev.h>
> > =A0#include <linux/mutex.h>
> > =A0#include <linux/slab.h>
> > +#include <linux/pm_runtime.h>
> > =A0#include <asm/uaccess.h>
> >
> > =A0#include <scsi/scsi.h>
> > @@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device=
 *bdev, fmode_t mode, unsigned cmd,
> > =A0 =A0 =A0 =A0struct scsi_cd *cd =3D scsi_cd(bdev->bd_disk);
> > =A0 =A0 =A0 =A0struct scsi_device *sdev =3D cd->device;
> > =A0 =A0 =A0 =A0void __user *argp =3D (void __user *)arg;
> > - =A0 =A0 =A0 int ret;
> > + =A0 =A0 =A0 int ret, rpm_resumed =3D 0;
> >
> > =A0 =A0 =A0 =A0mutex_lock(&sr_mutex);
> >
> > + =A0 =A0 =A0 if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd =3D=3D CDROMEJECT) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_get_devic=
e(sdev);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rpm_resumed =3D 1;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EPERM;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 }
> > +
> > =A0 =A0 =A0 =A0/*
> > =A0 =A0 =A0 =A0 * Send SCSI addressing ioctls directly to mid level=
, send other
> > =A0 =A0 =A0 =A0 * ioctls to cdrom/block level.
> > @@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *=
bdev, fmode_t mode, unsigned cmd,
> > =A0 =A0 =A0 =A0ret =3D scsi_ioctl(sdev, cmd, argp);
> >
> > =A0out:
> > + =A0 =A0 =A0 if (rpm_resumed && ret)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_put_device(sdev);
> > +
> > =A0 =A0 =A0 =A0mutex_unlock(&sr_mutex);
> > =A0 =A0 =A0 =A0return ret;
> > =A0}
> >
> > Does this work?
>=20
> I have tested this patch.
> Unfortunately, this does not work.
>=20
> int fd =3D open("/dev/sr0", ...)
> ioctl(fd, COMMAND)
>=20
> Actually, the open() code path requires CDROM to be in active state, =
for example
>=20
> sr_block_open
>   cdrom_open
>     open_for_data
>        cdo->drive_status
>          scsi_test_unit_ready
>            scsi_execute_req
>=20
Hmm... This is not the case on my Linux box.
eject will use O_NONBLOCK when open, which would results in the
following code path:
sr_block_open
  cdrom_open
    cdi->ops->open(sr_open)
      done

Maybe your eject is old and doesn't use the O_NONBLOCK flag?
If it is the case, then we may need to avoid this solution since we
can't depend on the user space tools.

> I'm thinking 3 solutions.
>=20
> Solution 1:
> sr_block_open() always return failure in ZPODD state.
> But "eject /dev/sr0" won't work in this solution.
>=20
Right, so, not an option.

> Solution 2:
> sr_block_open() always return success in ZPODD state.
> Then we have to insert ODD status check in many entries accessing it.
> For example, sr_drive_status(), sr_check_events(),  sr_lock_door() et=
c.
> And only runtime resume ODD for some special case, for example,
> CDROMEJECT ioctl.
Sounds like pretty complicated :-)

>=20
> Solution 3:
> Runtime resume ODD in sr_block_open(), as Alan suggested.
> But the big problem is userspace will open ODD every seconds, so ODD
> is frequently
> resumed and we lose the expected power savings from ZPODD.
Yes, the udisks-daemon will constantly open the ODD's block device,
dunno why it would do this, need to check its code later.

Another problem I can think of doing suspend/resume in open/release is,
it's not that easy to determine if we should suspend the ODD in release
function. We may need to do some extra house keeping to achieve this
based on information like if the door is open and/or if there is media
inside, etc.

Thanks,
Aaron

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
