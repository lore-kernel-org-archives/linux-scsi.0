From: su henry <henry.su.ati@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 18:42:46 +0800
Message-ID: <AANLkTilaI2G9jOtb49gUboNYVh2AiWtnzU-Z0_MxVURt@mail.gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
	<4C24B184.6050009@gmail.com>
	<AANLkTik1oiFzr-IpvaFQI75LfdTKkCaNEiRixOUsqen1@mail.gmail.com>
	<4C286590.50701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63117 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0F1Kmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 06:42:47 -0400
Received: by vws19 with SMTP id 19so1001396vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 03:42:46 -0700 (PDT)
In-Reply-To: <4C286590.50701@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

Hi tejun,

Thanks for the good suggestion, please see my comments inline.

On Mon, Jun 28, 2010 at 5:04 PM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> On 06/28/2010 10:43 AM, su henry wrote:
>>> Can you please align fields? =A0Also, single struct for the whole
>>> system? =A0I haven't read the spec but I don't think anybody would =
be
>>> defining things like this system-wide. =A0Right?
>>>
>>
>> My original though is to put this structure to cdrom_device_info, bu=
t
>> this structure should be firstly used by acpi_walk_namespace in
>> sr_init, and cdrom_device_info is allocated in sr_probe, that's why =
I
>> define a separate structure for the zero power odd.
>
> What prevents you from walking the acpi device tree from sr_probe()?
> Or even if you need to walk it from sr_init(), you still need to stor=
e
> the result and associate it with a specific cdrom device. =A0It is
> something which is specific to single device. =A0You can't use single
> global data structure for all devices like this.
>

In order to make sure we walk the name space one time only.

Because when the host starts the power supply to ODD, the driver will
start from sr_probe. I think it unnecessary to walk the acpi name
space when driver probes the device, so I  walk the acpi name space
from sr_init.

>>> bool?
>>
>> The return value of sr_test_unit_ready is int.
>
> I would still go for bool but it's a peripheral issue.
>
>>> This thing definitely belongs to struct scsi_cd. =A0What are the
>>> synchronization rules here? =A0Also, what happens if async notifica=
tion
>>> is in use? =A0How does the timer get activated then?
>>
>> This is a problem, any suggestions? Especially when the system goes =
to
>> S3/S4 state.
>
> Associate with specific device and using timer should work.
>

Considering the S3/S4 state, if we add a new timer for this, we should
also add the suspend/resume callbacks for the driver, and modify the
timer timeout(mod_timer) in the callback function.

>>>> + =A0 =A0 default:
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 /*tray/drawer/pop-up type*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* 3a/01(asc/ascq) means MEDIUM NOT PRES=
ENT - TRAY CLOSED */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (isvalid && (sshdr->asc =A0=3D=3D 0x3=
a &&
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sshdr->a=
scq =3D=3D 0x01)) {
>>>> +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Eject the tray for a =
tray type drive*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sr_zpodd_device.flag=
s & SR_ZPODD_NEED_EJECT) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_tray_=
move(cdi, 1);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd=
_device.flags &=3D ~SR_ZPODD_NEED_EJECT;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!(sr_zpodd_de=
vice.flags &
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 SR_ZPODD_NO_DISK)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd=
_device.flags |=3D SR_ZPODD_NO_DISK;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd=
_device.last_jiffies =3D jiffies;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (time_after(ji=
ffies,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 sr_zpodd_device.last_jiffies
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 + SR_NO_MEDIA_TIMEOUT)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpi_bus=
_set_power(sr_zpodd_device.handle,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ACPI_STATE_D3);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sr_zpodd_device.flags &=3D=
 ~SR_ZPODD_NO_DISK;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>>>> + =A0 =A0 }
>>>
>>> It would probably be better to separate decision making and updatin=
g
>>> states.
>>
>> When user pressing the button on a tray type drive, =A0driver should=
 set
>> a flag used to eject the tray in sr_media_change, if we use that
>> states here, we should a one more state "NEED_EJECT" for drive statu=
s.
>
> Oh, I meant the code. =A0ie. instead of
>
> =A0 =A0 =A0 =A0switch (device type) {
> =A0 =A0 =A0 =A0type a:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0something something
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0something something slightly different=
ly
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
>
> do something like the following,
>
> =A0 =A0 =A0 =A0switch (device type) {
> =A0 =A0 =A0 =A0type a:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0determine what to do
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0determine what to do slightly differen=
tly;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0do what has been determined;
>

Thanks for the advice.

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
