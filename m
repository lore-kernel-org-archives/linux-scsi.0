From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Mon, 13 Nov 2017 01:14:38 -0500
Message-ID: <20171113011438.458369bf@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
        <20171112164234.48b5185c@Vantage.cJ>
        <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:59482 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdKMGN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Nov 2017 01:13:29 -0500
In-Reply-To: <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Astafyev <1@246060.ru>, Hans de Goede <hdegoede@redhat.com>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 13 Nov 2017 07:01:30 +0300
Andrey Astafyev <1@246060.ru> wrote:

> 13.11.2017 00:42, J=C3=A9r=C3=B4me Carretero =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> > Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2=20
> > uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
> > [...]
> > Do you see such things?
> > =20
> Hi, I've seen dmesg output like this so I've added my device to
> quirks list like any other Seagate USB drive.

Hi Andrey, Hans,


For my devices, adding US_FL_NO_ATA_1X to unusual_uas.h didn't
change anything, and while adding US_FL_IGNORE_UAS (using
quirks=3D0bc2:ab34:u,0bc2:ab38:u) there are still device resets,
but they cause shorter hangs in system activity (~1 second when
UAS was more like ~20).

Is the US_FL_NO_ATA_1X supposed to get rid of the R/W errors?
The first entry I saw about this quirk was so that the device can
be used at all (wouldn't be able to mount without it).


I'll follow up: when scrubbing the devices after a sequence of
experiments, there were checksum errors, so I'll retry with a more
reproducible sequence to try and get something more solid.
I wouldn't want to disable UAS just to see that reliability has
been reduced (one Arch bug report mentions something like that
https://bugs.archlinux.org/task/48362).


Regards,

--=20
J=C3=A9r=C3=B4me

PS: The controllers I tested do the same:

09:00.0 USB controller: Fresco Logic FL1100 USB 3.0 Host Controller (rev 10)
0c:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (=
rev 03)
