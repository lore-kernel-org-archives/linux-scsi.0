From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Thu, 29 Mar 2012 13:45:07 +0800
Message-ID: <CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 28, 2012 at 10:33 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Wed, 28 Mar 2012, Lin Ming wrote:
>
>> ZPODD(Zero Power Optical Disk Drive) is a new feature in
>> SATA 3.1 specification. It provides a way to power off unused ODD.
>>
>> ZPODD support is checked in in sr_probe().
>> can_power_off flag is set during suspend if ZPODD is supported.
>>
>> ATA port's runtime suspend callback will actually power off the ODD
>> and its runtime resume callback will actually power on the ODD.
>>
>> When ODD is powered off(D3Cold state), inserting disk will trigger a
>> wakeup event(GPE). GPE AML handler notifies the associated device. T=
hen
>> ODD is resumed in the notify handler.
>
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>
>> @@ -80,12 +82,38 @@ static int sr_probe(struct device *);
>> =A0static int sr_remove(struct device *);
>> =A0static int sr_done(struct scsi_cmnd *);
>>
>> +static int sr_suspend(struct device *dev, pm_message_t mesg)
>> +{
>> + =A0 =A0 struct scsi_cd *cd;
>> +
>> + =A0 =A0 cd =3D dev_get_drvdata(dev);
>> + =A0 =A0 if (cd->device->power_off)
>> + =A0 =A0 =A0 =A0 =A0 =A0 dev->power.subsys_data->can_power_off =3D =
true;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static int sr_resume(struct device *dev)
>> +{
>> + =A0 =A0 struct scsi_cd *cd;
>> +
>> + =A0 =A0 cd =3D dev_get_drvdata(dev);
>> + =A0 =A0 if (cd->device->power_off) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 dev->power.subsys_data->can_power_off =3D =
false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cd->poweroff_event =3D 0;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> +}
>
> Calling this flag "can_power_off" makes these routines look very
> strange. =A0Either the device can power off or it can't, i.e., either=
 it
> supports ZPODD or it doesn't. =A0This doesn't change over time.
>
> If you rename the flag "may_power_off" then its meaning will be more
> clear.

OK, will rename it.

>
>> @@ -216,6 +244,11 @@ static unsigned int sr_check_events(struct cdro=
m_device_info *cdi,
>> =A0 =A0 =A0 unsigned int events;
>> =A0 =A0 =A0 int ret;
>>
>> + =A0 =A0 /* Not necessary to check events if enter ZPODD state */
>> + =A0 =A0 if (cd->device->power_off &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_suspended(&cd->=
device->sdev_gendev))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> The comment is wrong and the new code does the wrong thing. =A0You _d=
o_
> have to check for events even in the ZPODD state, which means
> sr_check_events must power-up the device if necessary.
> sd_check_events in James Bottomley's scsi-misc tree now does the righ=
t
> thing; see commit 4e2247b2bd289f079349d6c69755f8cff4e31f2b.

The problem is userspace(GNOME, for example) will check for events
every seconds.
If sr is power up so frequently then we lost the expected power
savings from ZPODD.

There are 2 events:

DISK_EVENT_MEDIA_CHANGE
DISK_EVENT_EJECT_REQUEST

In current implementation, if sr is in ZPODD state, then it means
there is no disk in the CDROM.
So if sr is in ZPODD state, MEDIA_CHANGE would never happen.

EJECT_REQUEST seems can be ignored, since there is no disk in the CDROM=
 at all.

>
>> +
>> =A0 =A0 =A0 /* no changer support */
>> =A0 =A0 =A0 if (CDSL_CURRENT !=3D slot)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> @@ -260,6 +293,11 @@ static unsigned int sr_check_events(struct cdro=
m_device_info *cdi,
>> =A0 =A0 =A0 cd->media_present =3D scsi_status_is_good(ret) ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (scsi_sense_valid(&sshdr) && sshdr.asc !=
=3D 0x3a);
>>
>> + =A0 =A0 if (!cd->media_present && cd->device->power_off && !cd->po=
weroff_event) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 scsi_autopm_put_device(cd->device);
>
> You can see your mistake here. =A0You call scsi_autopm_put_device her=
e
> without calling scsi_autopm_get_device earlier.

Let me check this.

Thanks for the review.
Lin Ming

>
> Alan Stern
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
