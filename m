From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Fri, 6 Apr 2012 14:10:31 +0800
Message-ID: <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
	<CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
	<CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
	<CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
	<20120405083245.GA19508@localhost.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120405083245.GA19508@localhost.amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 5, 2012 at 4:32 PM, Aaron Lu <aaron.lu@amd.com> wrote:
> Hi,
>
> On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
>> >
>> > Another thing to consider is, user might want to eject the tray by
>> > software like the
>> > eject /dev/sr0 command or some UI mouse clicks against the cdrom i=
con. I'm still
>> > thinking how to do this correctly.
>>
>> Assume eject /dev/sr0 is implemented as:
>>
>> int fd =3D open("/dev/sr0", ...)
>> ioctl(fd, CDROMEJECT)
>>
>
> Indeed, it is implemented as this :-)
>
>> We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
>>
>
> I prefer we do this in sr_block_ioctl.
> Suppose the ODD is now runtime suspended and received an ioctl:
> if the ioctl's cmd is CDROMEJECT, resume it.
> For other cases, return an error code like EPERM.
> When done, according to the result of ioctl: if success, leave it res=
umed;
> if failed, put it back to sleep.
>
> Something like this:
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..aa6e920 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -45,6 +45,7 @@
> =A0#include <linux/blkdev.h>
> =A0#include <linux/mutex.h>
> =A0#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> =A0#include <asm/uaccess.h>
>
> =A0#include <scsi/scsi.h>
> @@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device *=
bdev, fmode_t mode, unsigned cmd,
> =A0 =A0 =A0 =A0struct scsi_cd *cd =3D scsi_cd(bdev->bd_disk);
> =A0 =A0 =A0 =A0struct scsi_device *sdev =3D cd->device;
> =A0 =A0 =A0 =A0void __user *argp =3D (void __user *)arg;
> - =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 int ret, rpm_resumed =3D 0;
>
> =A0 =A0 =A0 =A0mutex_lock(&sr_mutex);
>
> + =A0 =A0 =A0 if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd =3D=3D CDROMEJECT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_get_device(=
sdev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rpm_resumed =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EPERM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Send SCSI addressing ioctls directly to mid level, =
send other
> =A0 =A0 =A0 =A0 * ioctls to cdrom/block level.
> @@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *bd=
ev, fmode_t mode, unsigned cmd,
> =A0 =A0 =A0 =A0ret =3D scsi_ioctl(sdev, cmd, argp);
>
> =A0out:
> + =A0 =A0 =A0 if (rpm_resumed && ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_put_device(sdev);
> +
> =A0 =A0 =A0 =A0mutex_unlock(&sr_mutex);
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> Does this work?

I have tested this patch.
Unfortunately, this does not work.

int fd =3D open("/dev/sr0", ...)
ioctl(fd, COMMAND)

Actually, the open() code path requires CDROM to be in active state, fo=
r example

sr_block_open
  cdrom_open
    open_for_data
       cdo->drive_status
         scsi_test_unit_ready
           scsi_execute_req

I'm thinking 3 solutions.

Solution 1:
sr_block_open() always return failure in ZPODD state.
But "eject /dev/sr0" won't work in this solution.

Solution 2:
sr_block_open() always return success in ZPODD state.
Then we have to insert ODD status check in many entries accessing it.
=46or example, sr_drive_status(), sr_check_events(),  sr_lock_door() et=
c.
And only runtime resume ODD for some special case, for example,
CDROMEJECT ioctl.

Solution 3:
Runtime resume ODD in sr_block_open(), as Alan suggested.
But the big problem is userspace will open ODD every seconds, so ODD
is frequently
resumed and we lose the expected power savings from ZPODD.

Any other idea?

Thanks,
Lin Ming
