From: Luciano Rocha <luciano@eurotux.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Tue, 28 Oct 2008 16:37:22 +0000
Message-ID: <20081028163722.GA4374@bit.office.eurotux.com>
References: <20081027165306.GA3875@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810271605190.2190-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from os.eurotux.com ([216.75.63.6]:50984 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYJ1RF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 13:05:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810271605190.2190-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Oct 27, 2008 at 04:10:02PM -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, Luciano Rocha wrote:
>=20
> > > The patches are here:
> > >=20
> > > 	http://marc.info/?l=3Dlinux-scsi&m=3D122443015406309&w=3D2
> > >=20
> > > They are based on 2.6.27, not 2.6.28-rc.
> >=20
> > I've tested them (on 2.6.27.4), but I still get the bug. That email=
 mentions:
> > "Neither patch addresses the infinite-retry problem; I wanted
> > to keep the issues separate."
> >=20
> > So am I missing some other patch?
> >=20
> > 2.6.28-rc2 is also buggy.
>=20
> Okay, I tried the same sort of experiment in 2.6.27.4 and got the sam=
e
> result as you did.  I was able to fix it by applying the 8bfa24727
> commit mentioned earlier together with the patch below.

I tried it, but I get some I/O errors with it.

With 8bfa24727 and this patch, I get:

[   94.289819] usb 1-2.1.1: new high speed USB device using ehci_hcd an=
d address 8
[   94.493891] usb 1-2.1.1: configuration #1 chosen from 1 choice
[   94.537884] usbcore: registered new interface driver libusual
[   94.611888] Initializing USB Mass Storage driver...
[   94.612704] scsi2 : SCSI emulation for USB Mass Storage devices
[   94.619835] usbcore: registered new interface driver usb-storage
[   94.619891] USB Mass Storage support registered.
[   94.622190] usb-storage: device found at 8
[   94.622232] usb-storage: waiting for device to settle before scannin=
g
[   99.622933] scsi 2:0:0:0: Direct-Access     SAMSUNG  HD400LD        =
  WQ10 PQ: 0 ANSI: 0
[   99.627569] usb-storage: device scan complete
[   99.657746] Driver 'sd' needs updating - please use bus_type methods
[   99.661428] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (4=
00088 MB)
[   99.662551] sd 2:0:0:0: [sda] Write Protect is off
[   99.662662] sd 2:0:0:0: [sda] Mode Sense: 03 00 00 00
[   99.662702] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   99.666582] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (4=
00088 MB)
[   99.672877] sd 2:0:0:0: [sda] Write Protect is off
[   99.672884] sd 2:0:0:0: [sda] Mode Sense: 03 00 00 00
[   99.672886] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   99.672890]  sda: sda1
[   99.683592] sd 2:0:0:0: [sda] Attached SCSI disk
[   99.704160] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   99.808029] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.808040] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.808051] end_request: I/O error, dev sda, sector 781422768
[   99.808056] Buffer I/O error on device sda, logical block 781422768
[   99.837771] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.837780] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.837790] end_request: I/O error, dev sda, sector 781422768
[   99.837794] Buffer I/O error on device sda, logical block 781422768
[   99.838775] end_request: I/O error, dev sda, sector 781422761
[   99.838781] Buffer I/O error on device sda, logical block 781422761
[   99.838784] Buffer I/O error on device sda, logical block 781422762
[   99.838786] Buffer I/O error on device sda, logical block 781422763
[   99.838789] Buffer I/O error on device sda, logical block 781422764
[   99.838791] Buffer I/O error on device sda, logical block 781422765
[   99.838793] Buffer I/O error on device sda, logical block 781422766
[   99.838796] Buffer I/O error on device sda, logical block 781422767
[   99.839525] end_request: I/O error, dev sda, sector 781422762
[   99.839530] Buffer I/O error on device sda, logical block 781422762
[   99.847527] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.847539] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.847554] end_request: I/O error, dev sda, sector 781422768
[   99.864923] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.864942] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.864967] end_request: I/O error, dev sda, sector 781422768
[   99.883038] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.883047] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.883058] end_request: I/O error, dev sda, sector 781422768
[   99.884239] end_request: I/O error, dev sda, sector 781422763
[   99.901645] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.901655] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.901665] end_request: I/O error, dev sda, sector 781422768
[   99.925027] sd 2:0:0:0: [sda] Sense Key : No Sense [current]=20
[   99.925036] sd 2:0:0:0: [sda] Add. Sense: No additional sense inform=
ation
[   99.925046] end_request: I/O error, dev sda, sector 781422768
[  119.957384] kjournald starting.  Commit interval 5 seconds
[  119.962246] EXT3 FS on dm-5, internal journal
[  119.962267] EXT3-fs: mounted filesystem with ordered data mode.

Oddly enough, with the other patch you sent me fixing the reported
number of sectors (*), on top of this one, I also get I/O errors:


[  127.047323] usb 1-2.1.1: new high speed USB device using ehci_hcd an=
d address 13
[  127.240694] usb 1-2.1.1: configuration #1 chosen from 1 choice
[  127.241178] scsi3 : SCSI emulation for USB Mass Storage devices
[  127.241752] usb-storage: device found at 13
[  127.241924] usb-storage: waiting for device to settle before scannin=
g
[  132.242710] scsi 3:0:0:0: Direct-Access     SAMSUNG  HD400LD        =
  WQ10 PQ: 0 ANSI: 0
[  132.244195] sd 3:0:0:0: [sda] 781422768 512-byte hardware sectors (4=
00088 MB)
[  132.245070] sd 3:0:0:0: [sda] Write Protect is off
[  132.245162] sd 3:0:0:0: [sda] Mode Sense: 03 00 00 00
[  132.245190] sd 3:0:0:0: [sda] Assuming drive cache: write through
[  132.245929] sd 3:0:0:0: [sda] 781422768 512-byte hardware sectors (4=
00088 MB)
[  132.246686] sd 3:0:0:0: [sda] Write Protect is off
[  132.246691] sd 3:0:0:0: [sda] Mode Sense: 03 00 00 00
[  132.246693] sd 3:0:0:0: [sda] Assuming drive cache: write through
[  132.246696]  sda: sda1
[  132.272924] sd 3:0:0:0: [sda] Attached SCSI disk
[  132.273058] sd 3:0:0:0: Attached scsi generic sg0 type 0
[  132.273297] usb-storage: device scan complete
[  132.325802] end_request: I/O error, dev sda, sector 781422761
[  132.325815] __ratelimit: 6 callbacks suppressed
[  132.325818] Buffer I/O error on device sda, logical block 97677845
[  132.327676] end_request: I/O error, dev sda, sector 781422761
[  132.327689] Buffer I/O error on device sda, logical block 97677845
[  132.328302] end_request: I/O error, dev sda, sector 781422761
[  132.328314] Buffer I/O error on device sda, logical block 97677845
[  132.328926] end_request: I/O error, dev sda, sector 781422761
[  132.328938] Buffer I/O error on device sda, logical block 97677845
[  132.329551] end_request: I/O error, dev sda, sector 781422761
[  132.329557] Buffer I/O error on device sda, logical block 97677845
[  132.330176] end_request: I/O error, dev sda, sector 781422761
[  132.330188] Buffer I/O error on device sda, logical block 97677845
[  132.330800] end_request: I/O error, dev sda, sector 781422761
[  132.330807] Buffer I/O error on device sda, logical block 97677845
[  132.345053] end_request: I/O error, dev sda, sector 781422761
[  132.345065] Buffer I/O error on device sda, logical block 97677845
[  132.345926] end_request: I/O error, dev sda, sector 781422761
[  132.345938] Buffer I/O error on device sda, logical block 97677845
[  136.743629] kjournald starting.  Commit interval 5 seconds
[  136.744951] EXT3 FS on dm-5, internal journal
[  136.745039] EXT3-fs: mounted filesystem with ordered data mode.

Without this patch, but still with the (*) one, everything seems fine:

[   90.680299] usb 1-2.1.1: new high speed USB device using ehci_hcd an=
d address 8
[   90.873674] usb 1-2.1.1: configuration #1 chosen from 1 choice
[   91.493054] usbcore: registered new interface driver libusual
[   91.582207] Initializing USB Mass Storage driver...
[   91.582696] scsi2 : SCSI emulation for USB Mass Storage devices
[   91.584473] usbcore: registered new interface driver usb-storage
[   91.584582] USB Mass Storage support registered.
[   91.585032] usb-storage: device found at 8
[   91.585039] usb-storage: waiting for device to settle before scannin=
g
[   96.584772] scsi 2:0:0:0: Direct-Access     SAMSUNG  HD400LD        =
  WQ10 PQ: 0 ANSI: 0
[   96.585058] usb-storage: device scan complete
[   96.623106] Driver 'sd' needs updating - please use bus_type methods
[   96.624120] sd 2:0:0:0: [sda] 781422768 512-byte hardware sectors (4=
00088 MB)
[   96.624869] sd 2:0:0:0: [sda] Write Protect is off
[   96.624876] sd 2:0:0:0: [sda] Mode Sense: 03 00 00 00
[   96.624880] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   96.625615] sd 2:0:0:0: [sda] 781422768 512-byte hardware sectors (4=
00088 MB)
[   96.626365] sd 2:0:0:0: [sda] Write Protect is off
[   96.626371] sd 2:0:0:0: [sda] Mode Sense: 03 00 00 00
[   96.626375] sd 2:0:0:0: [sda] Assuming drive cache: write through
[   96.626379]  sda: sda1
[   96.638218] sd 2:0:0:0: [sda] Attached SCSI disk
[   96.662312] sd 2:0:0:0: Attached scsi generic sg0 type 0
[  107.078870] kjournald starting.  Commit interval 5 seconds
[  107.080071] EXT3 FS on dm-5, internal journal
[  107.080082] EXT3-fs: mounted filesystem with ordered data mode.

Do you wish me to test anything else?

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
