From: Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Wed, 16 Sep 2009 22:43:18 +0500
Message-ID: <20090916224318.72be99ac.const@mimas.ru>
References: <20090913040104.ab1d0b69.const@mimas.ru>
	<1252850453.23599.13.camel@mulgrave.site>
	<646765f40909142257t560b314dt74d4158a497f0460@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:49675 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZIPRnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 13:43:20 -0400
In-Reply-To: <646765f40909142257t560b314dt74d4158a497f0460@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 14 Sep 2009 17:00:20 +0200 Pavel Machek <pavel@ucw.cz> wrote:
> Well, having unified kernel<->user interface for temperature sensors
> makes sense.

This is my exact motivation.

On Tue, 15 Sep 2009 15:57:39 +1000 Julian Calaby <julian.calaby@gmail.c=
om> wrote:
> On Mon, Sep 14, 2009 at 00:00, James Bottomley <James.Bottomley@suse.=
de> wrote:
> > So really, given the complexity of just obtaining the data and the
> > problem of matching which data to obtain to which device you have, =
why
> > not just use smartctl from userspace for monitoring? =C2=A0you coul=
d even
> > just plug into smartd, it seems to have most of the necessary heuri=
stics
> > built in already.
>=20
> There's even a util called hddtemp which handles all this and has a
> database of smart attributes to use for most drives.

Of course, I know about both smartctl and hddtemp tools.

On Sun, 13 Sep 2009 09:00:53 -0500 James Bottomley <James.Bottomley@sus=
e.de> wrote:
> The basic problem are the effects.  Right at the moment it tries to s=
end
> an ATA_16 encapsulated SMART command to every SCSI device in the syst=
em.
> We simply can't allow this.  A huge number of SCSI presenting USB
> devices are known to lock up when they see either ATA_X encapsulation=
 or
> SMART commands.  It's not really even safe to send ATA_X to SCSI
> devices.  The modern ones should all error out fine, but the older on=
es
> are likely to be less tolerant.

I looked for reliable method of classifying devices. Unfortunately,
without success. Maybe it's better to disable automatic scanning and pr=
ovide
a user (udev) with ability to enable monitoring on explicitly pointed d=
evice.

> Smart attribute 194 is highly vendor specific ... for instance my new
> SATA drive doesn't implement it (it does implement 190 instead).

Unfortunately, every SMART attribute is either reserved or vendor speci=
fic
as per T13. AFAIK, 194 is the most popular. That's why I have chosen it
in the first version. However, attribute number (and interpretation met=
hod
as well) may become configurable. Moreover, we can use hddtemp database
to initially configure scsitemp. And use unified hwmon interface later =
:)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
