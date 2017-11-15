From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: Seagate External SMR drive USB resets (was: Re: [PATCH] uas:
 Add US_FL_NO_ATA_1X quirk for one more Seagate device)
Date: Wed, 15 Nov 2017 18:17:08 -0500
Message-ID: <20171115181708.0a5d9288@Vantage.cJ>
References: <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
        <1510785608.6323.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:52658 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932618AbdKOXP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Nov 2017 18:15:57 -0500
In-Reply-To: <1510785608.6323.10.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Jens <jens-bugzilla.kernel.org@spamfreemail.de>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,


On Thu, 16 Nov 2017 07:40:08 +0900
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2017-11-15 at 17:02 -0500, Alan Stern wrote:
> > On Wed, 15 Nov 2017, J=C3=A9r=C3=B4me Carretero wrote: =20
> > > >=C2=A0=C2=A0 Because with several of these drives / lots of activity=
 / =20
> > occasional =20
> > > >=C2=A0=C2=A0 issues, it looks like it will be hard to catch (yes I c=
an use
> > > > usbmon).
> > > >=C2=A0
> > > > - It looks like there is no configurable timeout for USB MSC =20
> > requests. =20
> > > >=C2=A0=C2=A0 Perhaps the device is not responding in time and this i=
s why =20
> > it's =20
> > > >=C2=A0=C2=A0 reset? =20
> >=20
> > Timeouts are set by the SCSI layer.=C2=A0 I believe they are rather long
> > (30 seconds, by default).=C2=A0 Presumably they are configurable,
> > although I would have to do some digging to figure out how. =20
>=20
> They're in /sys/class/scsi_device/<id>/device/timeout


I'll use wireshark to check the cause: for sure, the drives are not
"timing out" after 30 seconds (indeed the reported value
in /sys/class/scsi_device/.../timeout or /sys/block/*/device/timeout),
because I see (in dstat) that a disk is busy until the right about the
moment where its reset message appears.

Is it possible that the SCSI timeout doesn't get set into an USB URB
timeout (I'll check by myself, but asking doesn't hurt) ?


Thank you,

--=20
J=C3=A9r=C3=B4me
