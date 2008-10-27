From: Luciano Rocha <luciano@eurotux.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 15:18:18 +0000
Message-ID: <20081027151818.GA4044@bit.office.eurotux.com>
References: <20081027112803.GA4398@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from os.eurotux.com ([216.75.63.6]:33489 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYJ0PXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 11:23:20 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Oct 27, 2008 at 10:24:14AM -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Luciano Rocha wrote:
>=20
> > On Sat, Oct 25, 2008 at 03:50:07PM -0400, Alan Stern wrote:
> > > On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> > >=20
> > > > [Adding CCs]
> > > >=20
> > > > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > > >=20
> > > > > Hello,
> > > > >=20
> > > > > An external HDD, usb-encased, works fine under 2.6.26.5, but =
under
> > > > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [c=
urrent]'.
> > >=20
> > > You can use usbmon to capture the details of what happens when yo=
u plug
> > > in the drive.  Instructions are in the kernel source file
> > > Documentation/usb/usbmon.txt.
> > >=20
> >=20
> > Now in 2.6.27.4, same problem. The usb traffic is:
>=20
> This looks exactly like the "infinite retry" problem I warned about=20
> earlier.  Here are the important parts of the log.  For people who=20
> don't know how to interpret these messages, the CDB starts in the 16t=
h=20
> byte of the 31-byte messages.  For example, the first command here=20
> starts with 0x25 and so it is READ CAPACITY:
>=20
> > f21e7cc0 3570408174 S Bo:1:008:1 -115 31 =3D 55534243 06000000 0800=
0000 80000a25 00000000 00000000 00000000 000000
> > f21e7cc0 3570408264 C Bo:1:008:1 0 31 >
> > f21e72c0 3570408280 S Bi:1:008:2 -115 8 <
> > f21e72c0 3570408389 C Bi:1:008:2 0 8 =3D 2e9390b0 00000200
> > f21e7cc0 3570408400 S Bi:1:008:2 -115 13 <
> > f21e7cc0 3570408513 C Bi:1:008:2 0 13 =3D 55534253 06000000 0000000=
0 00
>=20
> The response is 0x2e9390b0.  In typical broken fashion, that is=20
> undoubtedly the total number of sectors rather than the highest secto=
r=20
> number.
>=20
> Later on the system tries to read the contents of what it thinks is t=
he=20
> last sector:

Hm, where in the code can I change it to return less that what it think=
s
is the last sector?

<snip>
>=20
> There's a patch which might help resolve this problem:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3D8bfa24727087d7252f9ecfb5fea2dfc92d797fbd
>=20

No luck. I'm going to try 2.6.28-rc2 now.

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
