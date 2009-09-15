From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Tue, 15 Sep 2009 15:57:39 +1000
Message-ID: <646765f40909142257t560b314dt74d4158a497f0460@mail.gmail.com>
References: <20090913040104.ab1d0b69.const@mimas.ru> <1252850453.23599.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.211.174]:54975 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZIOGEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 02:04:35 -0400
In-Reply-To: <1252850453.23599.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Constantin Baranov <const@mimas.ru>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 14, 2009 at 00:00, James Bottomley <James.Bottomley@suse.de=
> wrote:
> On Sun, 2009-09-13 at 04:01 +0500, Constantin Baranov wrote:
>> The scsitemp module attaches a device to each SCSI device
>> and registers it in hwmon. Currently the only method of
>> reading temperature is ATA SMART. Adding support of the
>> pure SCSI methods is provided.
>
> The code, as you wrote it looks fine.
>
> The basic problem are the effects. =A0Right at the moment it tries to=
 send
> an ATA_16 encapsulated SMART command to every SCSI device in the syst=
em.
> We simply can't allow this. =A0A huge number of SCSI presenting USB
> devices are known to lock up when they see either ATA_X encapsulation=
 or
> SMART commands. =A0It's not really even safe to send ATA_X to SCSI
> devices. =A0The modern ones should all error out fine, but the older =
ones
> are likely to be less tolerant.
>
> Finally, this:
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (attr[2] =3D=3D 194) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *temp =3D attr[7] * 10=
00;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>
> Smart attribute 194 is highly vendor specific ... for instance my new
> SATA drive doesn't implement it (it does implement 190 instead).
>
> So really, given the complexity of just obtaining the data and the
> problem of matching which data to obtain to which device you have, wh=
y
> not just use smartctl from userspace for monitoring? =A0you could eve=
n
> just plug into smartd, it seems to have most of the necessary heurist=
ics
> built in already.

There's even a util called hddtemp which handles all this and has a
database of smart attributes to use for most drives.

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
