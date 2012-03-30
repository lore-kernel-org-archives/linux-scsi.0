From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Fri, 30 Mar 2012 09:07:31 +0800
Message-ID: <20120330010730.GA27346@ladygaga>
References: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 29, 2012 at 11:00:18AM -0400, Alan Stern wrote:
> On Thu, 29 Mar 2012, Aaron Lu wrote:
>=20
> > >>> @@ -216,6 +244,11 @@ static unsigned int sr_check_events(struct=
 cdrom_device_info *cdi,
> > >>> =EF=BF=BD =EF=BF=BD =EF=BF=BD unsigned int events;
> > >>> =EF=BF=BD =EF=BF=BD =EF=BF=BD int ret;
> > >>>
> > >>> + =EF=BF=BD =EF=BF=BD /* Not necessary to check events if enter=
 ZPODD state */
> > >>> + =EF=BF=BD =EF=BF=BD if (cd->device->power_off &&
> > >>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD pm_runtime_suspended(&cd->device->=
sdev_gendev))
> > >>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD r=
eturn 0;
> > >>
> > >> The comment is wrong and the new code does the wrong thing. =EF=BF=
=BDYou _do_
> > >> have to check for events even in the ZPODD state, which means
> > >> sr_check_events must power-up the device if necessary.
> > >> sd_check_events in James Bottomley's scsi-misc tree now does the=
 right
> > >> thing; see commit 4e2247b2bd289f079349d6c69755f8cff4e31f2b.
> > >
> > > The problem is userspace(GNOME, for example) will check for event=
s
> > > every seconds.
> > > If sr is power up so frequently then we lost the expected power
> > > savings from ZPODD.
>=20
> That's true.  There's nothing you can do about it in the kernel; it's=
=20
> up to userspace to change the frequency of event polling.
>=20
> > Agreed.
> > BTW, it's udevd on my Linux box that changed the default poll msecs=
 kernel param
> > which caused sr_check_events being called every 2 seconds.
>=20
> Indeed.
>=20
> > > There are 2 events:
> > >
> > > DISK_EVENT_MEDIA_CHANGE
> > > DISK_EVENT_EJECT_REQUEST
> > >
> > > In current implementation, if sr is in ZPODD state, then it means
> > > there is no disk in the CDROM.
> > > So if sr is in ZPODD state, MEDIA_CHANGE would never happen.
>=20
> Sure it will: when the user inserts a disc.
>=20
> > > EJECT_REQUEST seems can be ignored, since there is no disk in the=
 CDROM at all.
> > >
> >=20
> > For the ODD to be put into suspend state, the conditions should be:
> > 1 tray closed
> > 2 no media inside
> > I think we missed the condition 1 check now.
> >=20
> > And if we follow the two conditions, the events can be safely ignor=
ed.
>=20
> No, they can't.  Otherwise the device won't power back up when the us=
er=20
> inserts a new disc.
>=20

The ODD is put to zero power state, so it can't react to the eject
button without being powered up back first ;-)
On current implementation, ACPI is used to power back up the ODD like t=
his:
1 User press the eject button;
2 A gpe event fired, and ACPI interrupt, and the corresponding gpe
handler runs and the ODD's ACPI handle is notified about DEVICE_WAKE_UP=
;
3 In ODD's acpi notify handler, we power back up it by scsi_autopm_get_=
device.
This is handled in the following Lin Ming's patch:
[PATCH v3 2/7] libata-acpi: add ata port runtime D3Cold support

> > What do you think of blocking events for it when going to suspend a=
nd unblocking
> > when resume? This could erase the unnecessary calls of the check ev=
ents function
> > when ODD is suspended.
> > But disk_(un)block_events are not exported and can't be used in sr
> > module. So I'm
> > not sure how to do this.
> >=20
> > Another thing to consider is, user might want to eject the tray by
> > software like the
> > eject /dev/sr0 command or some UI mouse clicks against the cdrom ic=
on. I'm still
> > thinking how to do this correctly.
>=20
> What's the problem?  Can't the user already eject the tray via=20
> software?
>=20

When the ODD is put to zero power state, it will not be able to handle
commands like CDROMEJECT. We have to power it up first and then handle
the ioctl request. Currently, we only power back up the ODD when user
press the eject button as explained above.

> > >>> @@ -260,6 +293,11 @@ static unsigned int sr_check_events(struct=
 cdrom_device_info *cdi,
> > >>> =EF=BF=BD =EF=BF=BD =EF=BF=BD cd->media_present =3D scsi_status=
_is_good(ret) ||
> > >>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD (scsi_sense_valid(&sshdr) && sshdr.asc !=3D 0x3a);
> > >>>
> > >>> + =EF=BF=BD =EF=BF=BD if (!cd->media_present && cd->device->pow=
er_off && !cd->poweroff_event) {
> > >>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD s=
csi_autopm_put_device(cd->device);
> > >>
> > >> You can see your mistake here. =EF=BF=BDYou call scsi_autopm_put=
_device here
> > >> without calling scsi_autopm_get_device earlier.
> > >
> > > Let me check this.
> >=20
> > I guess the earlier call of get device is this?
> >=20
> >  869 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> > ... ...
> >  891
> >  892        /* The following call will keep sdev active indefinitel=
y, until
> >  893         * its driver does a corresponding scsi_autopm_pm_devic=
e().  Only
> >  894         * drivers supporting autosuspend will do this.
> >  895         */
> >  896        scsi_autopm_get_device(sdev);
> >  897
>=20
> You have to do this correctly.  Currently sr doesn't support runtime =
PM=20
> at all.  If you do want to support it, then the driver should call=20
> scsi_autopm_put_device at the end of the probe routine (or whenever i=
t=20
> is ready to allow runtime suspends) and scsi_autopm_get_device at the=
=20
> start of the remove routine (or whenever it wants to prevent runtime=20
> suspends).
>=20
> The idea is that the driver is probed with the PM usage counter set t=
o
> 1, so a runtime suspend won't occur until you do a put.  Similarly, i=
n
> the remove routine, you must make sure that your gets and puts balanc=
e
> out.
>=20

Oh, I see, thanks for your clear explanation.

-Aaron


--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
