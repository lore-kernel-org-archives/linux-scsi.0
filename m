From: su henry <henry.su.ati@gmail.com>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Tue, 29 Jun 2010 09:26:30 +0800
Message-ID: <AANLkTimiF6OERxDEBgYRk9odK5ukU6ln5J1019KjKCcZ@mail.gmail.com>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
	<1277474478.5234.98.camel@mulgrave.site>
	<AANLkTinKcEEj9Se_BBaDdYDLCaOLPXD66a22n4Hea4Bt@mail.gmail.com>
	<1277732531.10879.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62789 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0F2B0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 21:26:31 -0400
Received: by vws5 with SMTP id 5so764349vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2010 18:26:30 -0700 (PDT)
In-Reply-To: <1277732531.10879.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

On Mon, Jun 28, 2010 at 9:42 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Mon, 2010-06-28 at 15:35 +0800, su henry wrote:
>> On Fri, Jun 25, 2010 at 10:01 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > On Fri, 2010-06-25 at 18:15 +0800, su henry wrote:
>> >> From b221e73b802ccfe5338b575dc0ff3b687acdd6fa Mon Sep 17 00:00:00=
 2001
>> >> From: henry su <henry.su.ati@gmail.com>
>> >> Date: Fri, 25 Jun 2010 00:08:42 +0800
>> >> Subject: [PATCH RFC] support sata odd zero power
>> >>
>> >> In order to extend the battery life of Mobile PC system, the host=
 should remove
>> >> the power supply to the Optical Disc Drive (logical unit) when it=
 detects the
>> >> logical unit with no media and tray closed, and the host starts t=
he power
>> >> supply to the logical unit when it detects user action to the log=
ical unit that
>> >> the power supply is omitted.
>> >
>> >> The patch evaluates the _PS3 method to remove the power supply to=
 the ODD if
>> >> the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported by =
REQUEST SENSE
>> >> command for a Drawer, Tray or Pop-up type drive, or MEDIUM NOT PR=
ESENT -
>> >> TRAY CLOSED for a slot/caddy type drive; on the other hand, the p=
atch evaluates
>> >> the _PS0 method to restart the power supply to the ODD when the u=
ser
>> >> presses the
>> >> button on a tray type drive or inserts a CD to a slot/caddy type =
drive.
>> >>
>> >> PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used t=
o test
>> >> the patch on AMD SB800 platforms.
>> >>
>> >> Signed-off-by: Henry Su <henry.su.ati@gmail.com>
>> >
>> > The first observation I'd have is a big meta one: =A0This all need=
s to
>> > work on non ACPI systems ... given that it relies on unstubbed ACP=
I
>> > functions, I don't think it does, does it?
>> >
>> > What I'd suggest is confining it all to sr_acpi.c and hooking it i=
n to
>> > the test unit ready and init/exit ... that way the code only need =
be
>> > present if ACPI is.
>>
>> Yes, it only works on a systems that supports ACPI functions, and th=
at
>> system BIOS provides the _PS0/_PS3 method to start/stop the power
>> supply.
>>
>> Besides a new driver to support the zero power odd, another suggesti=
on
>> is adding the "#ifdef CONFIG_ACPI" in sr.c to separate the code.
>
> I didn't say add a new driver, I said add a new file to the existing
> driver ... it's already split into multiple files. =A0That way there'=
s no
> need to litter #ifdef CONFIG_ACPI to make this compile.
>

Yes, adding a new file(sr_acpi.c), just like the existing sr_vendor.c.

> James
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
