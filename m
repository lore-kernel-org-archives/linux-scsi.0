From: su henry <henry.su.ati@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 16:43:32 +0800
Message-ID: <AANLkTik1oiFzr-IpvaFQI75LfdTKkCaNEiRixOUsqen1@mail.gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
	<4C24B184.6050009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44711 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0F1Ine convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 04:43:34 -0400
Received: by vws19 with SMTP id 19so893123vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 01:43:33 -0700 (PDT)
In-Reply-To: <4C24B184.6050009@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

On Fri, Jun 25, 2010 at 9:39 PM, Tejun Heo <htejun@gmail.com> wrote:
> (cc'ing James)
>
> On 06/25/2010 12:15 PM, su henry wrote:
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -55,6 +55,7 @@
>> =A0#include <scsi/scsi_eh.h>
>> =A0#include <scsi/scsi_host.h>
>> =A0#include <scsi/scsi_ioctl.h> /* For the door lock/unlock commands=
 */
>> +#include <acpi/acpi_bus.h>
>>
>> =A0#include "scsi_logging.h"
>> =A0#include "sr.h"
>> @@ -89,6 +90,19 @@ static struct scsi_driver sr_template =3D {
>> =A0 =A0 =A0 .done =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D sr_done,
>> =A0};
>>
>> +static struct sr_zpodd_device_info {
>> + =A0 =A0 acpi_handle handle;
>> + =A0 =A0 mechtype_t mechtype;
>> +
>> +#define SR_NO_MEDIA_TIMEOUT =A0(120*HZ)
>> +#define SR_IS_ZPODD =A0 =A0 =A0 =A0 =A00x01
>> +#define SR_ZPODD_NO_DISK =A0 =A0 0x02
>> +#define SR_ZPODD_NEED_EJECT =A00x04
>> +
>> + =A0 =A0 u32 flags;
>
> It's more customary to use unsigned int.
>

Yes, it should be unsigned int.

>> + =A0 =A0 unsigned long last_jiffies;
>> +} sr_zpodd_device;
>
> Can you please align fields? =A0Also, single struct for the whole
> system? =A0I haven't read the spec but I don't think anybody would be
> defining things like this system-wide. =A0Right?
>

My original though is to put this structure to cdrom_device_info, but
this structure should be firstly used by acpi_walk_namespace in
sr_init, and cdrom_device_info is allocated in sr_probe, that's why I
define a separate structure for the zero power odd.

>> @@ -205,6 +219,7 @@ static int sr_media_change(struct
>> cdrom_device_info *cdi, int slot)
>> =A0 =A0 =A0 struct scsi_cd *cd =3D cdi->handle;
>> =A0 =A0 =A0 int retval;
>> =A0 =A0 =A0 struct scsi_sense_hdr *sshdr;
>> + =A0 =A0 int isvalid;
>
> bool?
>

The return value of sr_test_unit_ready is int.

>> =A0 =A0 =A0 if (CDSL_CURRENT !=3D slot) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no changer support */
>> @@ -213,7 +228,59 @@ static int sr_media_change(struct
>> cdrom_device_info *cdi, int slot)
>>
>> =A0 =A0 =A0 sshdr =3D =A0kzalloc(sizeof(*sshdr), GFP_KERNEL);
>> =A0 =A0 =A0 retval =3D sr_test_unit_ready(cd->device, sshdr);
>> - =A0 =A0 if (retval || (scsi_sense_valid(sshdr) &&
>> + =A0 =A0 isvalid =3D scsi_sense_valid(sshdr);
>> +
>> + =A0 =A0 if (!(sr_zpodd_device.flags & SR_IS_ZPODD))
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_not_zpodd_device;
>> +
>> + =A0 =A0 /* Remove the power supply to the drive with no media and
>> + =A0 =A0 =A0* tray closed for tray/drawer/pop-up type drive,
>> + =A0 =A0 =A0* or no media and tray open for caddy/slot type drive.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 switch (sr_zpodd_device.mechtype) {
>> + =A0 =A0 case mechtype_caddy:
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* 3a/02(asc/ascq) means MEDIUM NOT PRESEN=
T - TRAY OPEN */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (isvalid && (sshdr->asc =A0=3D=3D 0x3a =
&&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sshdr->asc=
q =3D=3D 0x02)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(sr_zpodd_device.flag=
s & SR_ZPODD_NO_DISK)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_d=
evice.flags |=3D SR_ZPODD_NO_DISK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_d=
evice.last_jiffies =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (time_after(jiff=
ies,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sr_zpodd_device.last_jiffies +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SR_NO_MEDIA_TIMEOUT)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_bus_s=
et_power(sr_zpodd_device.handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ACPI_STATE_D3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_device.flags &=3D=
 ~SR_ZPODD_NO_DISK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>
> This thing definitely belongs to struct scsi_cd. =A0What are the
> synchronization rules here? =A0Also, what happens if async notificati=
on
> is in use? =A0How does the timer get activated then?

This is a problem, any suggestions? Especially when the system goes to
S3/S4 state.

>
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*tray/drawer/pop-up type*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* 3a/01(asc/ascq) means MEDIUM NOT PRESEN=
T - TRAY CLOSED */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (isvalid && (sshdr->asc =A0=3D=3D 0x3a =
&&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sshdr->asc=
q =3D=3D 0x01)) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Eject the tray for a tr=
ay type drive*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sr_zpodd_device.flags =
& SR_ZPODD_NEED_EJECT) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_tray_mo=
ve(cdi, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_d=
evice.flags &=3D ~SR_ZPODD_NEED_EJECT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!(sr_zpodd_devi=
ce.flags &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 SR_ZPODD_NO_DISK)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_d=
evice.flags |=3D SR_ZPODD_NO_DISK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_d=
evice.last_jiffies =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (time_after(jiff=
ies,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sr_zpodd_device.last_jiffies
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 + SR_NO_MEDIA_TIMEOUT)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_bus_s=
et_power(sr_zpodd_device.handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ACPI_STATE_D3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_device.flags &=3D=
 ~SR_ZPODD_NO_DISK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 }
>
> It would probably be better to separate decision making and updating
> states.

When user pressing the button on a tray type drive,  driver should set
a flag used to eject the tray in sr_media_change, if we use that
states here, we should a one more state "NEED_EJECT" for drive status.

>
> Thanks.
>
> --
> tejun
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
