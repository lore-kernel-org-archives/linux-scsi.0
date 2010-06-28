From: su henry <henry.su.ati@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 15:35:01 +0800
Message-ID: <AANLkTinKcEEj9Se_BBaDdYDLCaOLPXD66a22n4Hea4Bt@mail.gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
	<1277474478.5234.98.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43757 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0F1HfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 03:35:03 -0400
Received: by vws19 with SMTP id 19so833479vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 00:35:01 -0700 (PDT)
In-Reply-To: <1277474478.5234.98.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

On Fri, Jun 25, 2010 at 10:01 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Fri, 2010-06-25 at 18:15 +0800, su henry wrote:
>> From b221e73b802ccfe5338b575dc0ff3b687acdd6fa Mon Sep 17 00:00:00 20=
01
>> From: henry su <henry.su.ati@gmail.com>
>> Date: Fri, 25 Jun 2010 00:08:42 +0800
>> Subject: [PATCH RFC] support sata odd zero power
>>
>> In order to extend the battery life of Mobile PC system, the host sh=
ould remove
>> the power supply to the Optical Disc Drive (logical unit) when it de=
tects the
>> logical unit with no media and tray closed, and the host starts the =
power
>> supply to the logical unit when it detects user action to the logica=
l unit that
>> the power supply is omitted.
>
>> The patch evaluates the _PS3 method to remove the power supply to th=
e ODD if
>> the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported by REQ=
UEST SENSE
>> command for a Drawer, Tray or Pop-up type drive, or MEDIUM NOT PRESE=
NT -
>> TRAY CLOSED for a slot/caddy type drive; on the other hand, the patc=
h evaluates
>> the _PS0 method to restart the power supply to the ODD when the user
>> presses the
>> button on a tray type drive or inserts a CD to a slot/caddy type dri=
ve.
>>
>> PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used to t=
est
>> the patch on AMD SB800 platforms.
>>
>> Signed-off-by: Henry Su <henry.su.ati@gmail.com>
>
> The first observation I'd have is a big meta one: =A0This all needs t=
o
> work on non ACPI systems ... given that it relies on unstubbed ACPI
> functions, I don't think it does, does it?
>
> What I'd suggest is confining it all to sr_acpi.c and hooking it in t=
o
> the test unit ready and init/exit ... that way the code only need be
> present if ACPI is.

Yes, it only works on a systems that supports ACPI functions, and that
system BIOS provides the _PS0/_PS3 method to start/stop the power
supply.

Besides a new driver to support the zero power odd, another suggestion
is adding the "#ifdef CONFIG_ACPI" in sr.c to separate the code.

>
> [...]
>> @@ -786,6 +853,7 @@ static void get_capabilities(struct scsi_cd *cd)
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 n =3D data.header_length + data.block_descriptor_length;
>> + =A0 =A0 sr_zpodd_device.mechtype =3D buffer[n + 6] >> 5;
>> =A0 =A0 =A0 cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9])=
 / 176;
>> =A0 =A0 =A0 cd->readcd_known =3D 1;
>> =A0 =A0 =A0 cd->readcd_cdda =3D buffer[n + 5] & 0x01;
>
> This piece of data should probably be added to struct scsi_cd .. we
> already use it in the routine anyway for printing out the tray type.

Agree. It is fine to add the mechanism type to scsi_cd or cdrom_device_=
info.

>
> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
