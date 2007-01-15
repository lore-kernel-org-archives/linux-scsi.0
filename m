From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ieee1394: sbp2: remove bogus "emulated" host flag
Date: Mon, 15 Jan 2007 15:40:02 -0500
Message-ID: <45ABE6A2.10509@torque.net>
References: <tkrat.cd304ed480ae458e@s5r6.in-berlin.de> <59ad55d30701151141n72e3e99ey509d859c272b8bda@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbXAOUkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 15:40:31 -0500
In-Reply-To: <59ad55d30701151141n72e3e99ey509d859c272b8bda@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Kristian H=C3=B8gsberg wrote:
> On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> There is no emulation going on here.
> ...
>=20
>> -       .emulated                =3D 1,
>=20
> Not sure what this flag does, but I copied it over to fw-sbp2.c.  If
> it's bogus, I guess we should drop it from fw-sbp2.c too.

Kristian,
The 'emulated' flag dates from the original ide-scsi
driver (lk 2.0 series or earlier) when some app wanted
to know if there was a "real" SCSI cd drive attached
or a fudged one (i.e. ATAPI) via the ide-scsi bridging
driver. So it is unclear to me why the sbp driver
(and USB mass storage) sets emulated.

Hopefully if any app cares these days there are much
better ways to find out what the transport is. Also
now we have the transport the LLD can see
and the transport the device (i.e. logical unit) can
see; and they aren't necessarily the same. In the
case of a CD/DVD drive there is the GET CONFIGURATION
command for finding out what the lu can see:
$ sg_get_config /dev/hdc
  HL-DT-ST  RW/DVD GCC-4242N  0201
  Peripheral device type: cd/dvd
No current profile
=46eatures:
  Profile list feature
    version=3D0, persist=3D1, current=3D1 [0x0]
    available profiles [more recent typically higher in list]:
      profile: DVD-ROM , currentP=3D0
      profile: CD-ROM , currentP=3D0
      profile: CD-R , currentP=3D0
      profile: CD-RW , currentP=3D0
  Core feature
    version=3D0, persist=3D1, current=3D1 [0x1]
      Physical interface standard: ATAPI
=2E.....

So IMO 'emulated' is best retired.

Doug Gilbert

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
