From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [usb-storage] Re: usb disk recognized but fails
Date: Wed, 29 Jan 2014 14:07:08 +0100
Message-ID: <20140129140708.5bd372a1@free.fr>
References: <20140124075752.615F312D@centrum.cz>
	<Pine.LNX.4.44L0.1401241056050.1129-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48730 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaA2NHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 08:07:17 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401241056050.1129-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Milan Svoboda <milan.svoboda@centrum.cz>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, USB list <linux-usb@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Richard =?ISO-8859-15?Q?Sch=C3=BCtz?= <r.schtz@t-online.de>

Hi,

Le Fri, 24 Jan 2014 11:07:01 -0500,
Alan Stern <stern@rowland.harvard.edu> a =E9crit :

> Matthieu:
>=20
> Can you help with this problem?
>=20
>=20
> You were right; that driver caused the problem.
>=20
> Matthieu Castet wrote the Cypress-ATACB driver, so maybe he can help.
>=20
> As shown above, this device matches the last entry in the
> unusual_cypress.h file (the one named "Super Top").  Not shown here i=
s

The "Super Top" id were added later. When I did the driver I only
check the datasheet of the fisrt two entry.

Looking at the git log, we can see there already was corruption
detected by this entry [1].


Without knowing what chip is in the "super top" bridge, I propose to
remove the entry : it seems to cause too much trouble.

An alternative could be to enable it only for bcdDevice=20
1.60.

Matthieu

[1]
    USB: usb-storage: unusual_devs update for Super TOP SATA bridge
   =20
    The current entry in unusual_cypress.h for the Super TOP SATA bridg=
e devices
    seems to be causing corruption on newer revisions of this device.  =
This has
    been reported in Arch Linux and Fedora.  The original patch was tes=
ted on
    devices with bcdDevice of 1.60, whereas the newer devices report bc=
dDevice
    as 2.20.  Limit the UNUSUAL_DEV entry to devices less than 2.20.
   =20
    This fixes https://bugzilla.redhat.com/show_bug.cgi?id=3D909591
   =20
    The Arch Forum post on this is here:
        https://bbs.archlinux.org/viewtopic.php?id=3D152011
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
