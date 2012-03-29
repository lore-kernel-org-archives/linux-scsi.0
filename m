From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Thu, 29 Mar 2012 11:00:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
References: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 29 Mar 2012, Aaron Lu wrote:

> >>> @@ -216,6 +244,11 @@ static unsigned int sr_check_events(struct c=
drom_device_info *cdi,
> >>> =A0 =A0 =A0 unsigned int events;
> >>> =A0 =A0 =A0 int ret;
> >>>
> >>> + =A0 =A0 /* Not necessary to check events if enter ZPODD state *=
/
> >>> + =A0 =A0 if (cd->device->power_off &&
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_suspended(&c=
d->device->sdev_gendev))
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >>
> >> The comment is wrong and the new code does the wrong thing. =A0You=
 _do_
> >> have to check for events even in the ZPODD state, which means
> >> sr_check_events must power-up the device if necessary.
> >> sd_check_events in James Bottomley's scsi-misc tree now does the r=
ight
> >> thing; see commit 4e2247b2bd289f079349d6c69755f8cff4e31f2b.
> >
> > The problem is userspace(GNOME, for example) will check for events
> > every seconds.
> > If sr is power up so frequently then we lost the expected power
> > savings from ZPODD.

That's true.  There's nothing you can do about it in the kernel; it's=20
up to userspace to change the frequency of event polling.

> Agreed.
> BTW, it's udevd on my Linux box that changed the default poll msecs k=
ernel param
> which caused sr_check_events being called every 2 seconds.

Indeed.

> > There are 2 events:
> >
> > DISK_EVENT_MEDIA_CHANGE
> > DISK_EVENT_EJECT_REQUEST
> >
> > In current implementation, if sr is in ZPODD state, then it means
> > there is no disk in the CDROM.
> > So if sr is in ZPODD state, MEDIA_CHANGE would never happen.

Sure it will: when the user inserts a disc.

> > EJECT_REQUEST seems can be ignored, since there is no disk in the C=
DROM at all.
> >
>=20
> For the ODD to be put into suspend state, the conditions should be:
> 1 tray closed
> 2 no media inside
> I think we missed the condition 1 check now.
>=20
> And if we follow the two conditions, the events can be safely ignored=
=2E

No, they can't.  Otherwise the device won't power back up when the user=
=20
inserts a new disc.

> What do you think of blocking events for it when going to suspend and=
 unblocking
> when resume? This could erase the unnecessary calls of the check even=
ts function
> when ODD is suspended.
> But disk_(un)block_events are not exported and can't be used in sr
> module. So I'm
> not sure how to do this.
>=20
> Another thing to consider is, user might want to eject the tray by
> software like the
> eject /dev/sr0 command or some UI mouse clicks against the cdrom icon=
=2E I'm still
> thinking how to do this correctly.

What's the problem?  Can't the user already eject the tray via=20
software?

> >>> @@ -260,6 +293,11 @@ static unsigned int sr_check_events(struct c=
drom_device_info *cdi,
> >>> =A0 =A0 =A0 cd->media_present =3D scsi_status_is_good(ret) ||
> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (scsi_sense_valid(&sshdr) && sshdr.as=
c !=3D 0x3a);
> >>>
> >>> + =A0 =A0 if (!cd->media_present && cd->device->power_off && !cd-=
>poweroff_event) {
> >>> + =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_put_device(cd->device);
> >>
> >> You can see your mistake here. =A0You call scsi_autopm_put_device =
here
> >> without calling scsi_autopm_get_device earlier.
> >
> > Let me check this.
>=20
> I guess the earlier call of get device is this?
>=20
>  869 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> ... ...
>  891
>  892        /* The following call will keep sdev active indefinitely,=
 until
>  893         * its driver does a corresponding scsi_autopm_pm_device(=
).  Only
>  894         * drivers supporting autosuspend will do this.
>  895         */
>  896        scsi_autopm_get_device(sdev);
>  897

You have to do this correctly.  Currently sr doesn't support runtime PM=
=20
at all.  If you do want to support it, then the driver should call=20
scsi_autopm_put_device at the end of the probe routine (or whenever it=20
is ready to allow runtime suspends) and scsi_autopm_get_device at the=20
start of the remove routine (or whenever it wants to prevent runtime=20
suspends).

The idea is that the driver is probed with the PM usage counter set to
1, so a runtime suspend won't occur until you do a put.  Similarly, in
the remove routine, you must make sure that your gets and puts balance
out.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
