From: Andrew Morton <akpm@osdl.org>
Subject: Re: [linux-usb-devel] Fw: Re: 2.6.10-rc2-mm3
Date: Tue, 23 Nov 2004 15:57:22 -0800
Message-ID: <20041123155722.0d18cecb.akpm@osdl.org>
References: <20041122162206.0d43cd30.akpm@osdl.org>
	<200411231539.37735.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:65163 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261670AbUKWXxh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 18:53:37 -0500
In-Reply-To: <200411231539.37735.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net, cova@ferrara.linux.it, linux-scsi@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
>
> On Monday 22 November 2004 16:22, Andrew Morton wrote:
> >=20
> > Please include linux-usb-devel on USB-related reports, thanks.
>=20
> This looks more related to those scsi or kobject problems
> for which I've seen patches recently.  I don't know whether
> mm3 has all of the patches though.
>=20
> Except for the problems that device had when enumerating.
> Those look like device faults that USB recovered from in
> the right ways, despites some scarey messages.=20

Well I'll cheerfully add linux-scsi to Cc: then ;)

Guys, does the below look familiar?  If so, do we know the status of th=
e
fixes?

Thanks.

>=20
>=20
> > Begin forwarded message:
> >=20
> > Date: Tue, 23 Nov 2004 00:56:11 +0100
> > From: Fabio Coatti <cova@ferrara.linux.it>
> > To: Andrew Morton <akpm@osdl.org>
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: 2.6.10-rc2-mm3
> >=20
> >=20
> > Alle 07:39, luned=EC 22 novembre 2004, Andrew Morton ha scritto:
> >=20
> > > 2.6.10-rc2-mm3
> >=20
> > Well; I've tested mm3 with my usb flash key; the behaviour is chang=
ed and=20
> > improved, but as expected by reading the previous thread there is s=
ome=20
> > issues; I'm reporting it, just in case.
> >=20
> > Now, after some tries (as before, it takes some tries to have the d=
evice=20
> > identified by the kernel, maybe some tight timeout...), as always I=
 get a=20
> > kobject problem but on removal I can  see a "BUG: atomic counter un=
derflow=20
> > at:"; anyway the box survives quite well and when device is inserte=
d (and=20
> > identified by the kernel, of course), is possible to mount and use =
it,=20
> > whitout usb subsystem lock on removal.
> >=20
> >=20
> > The (timeout?) problem is still here:
> >=20
> > Nov 23 00:09:32 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 =
evt 0008
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001803 POWER sig=3Dj  CSC CONNECT
> > Nov 23 00:09:32 kefk kernel: hub 5-0:1.0: port 3, status 0501, chan=
ge 0001,=20
> > 480 Mb/s
> > Nov 23 00:09:32 kefk kernel: hub 5-0:1.0: debounce: port 3: total 1=
00ms stable=20
> > 100ms status 0x501
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 high spe=
ed
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001005 POWER sig=3Dse0  PE CONNECT
> > Nov 23 00:09:32 kefk kernel: usb 5-3: new high speed USB device usi=
ng ehci_hcd=20
> > and address 3
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: devpath 3 ep0in=
 3strikes
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 full spe=
ed -->=20
> > companion
> > Nov 23 00:09:32 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 003801 POWER OWNER sig=3Dj  CONNECT
> > Nov 23 00:09:32 kefk kernel: uhci_hcd 0000:00:1d.1: wakeup_hc
> > Nov 23 00:09:32 kefk kernel: hub 2-0:1.0: state 5 ports 2 chg fffc =
evt 0002
> > Nov 23 00:09:32 kefk kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 0=
083,00
> > Nov 23 00:09:32 kefk kernel: hub 2-0:1.0: port 1, status 0101, chan=
ge 0001, 12=20
> > Mb/s
> > Nov 23 00:09:32 kefk kernel: hub 2-0:1.0: debounce: port 1: total 1=
00ms stable=20
> > 100ms status 0x101
> > Nov 23 00:09:32 kefk kernel: usb 2-1: new full speed USB device usi=
ng uhci_hcd=20
> > and address 2
> > Nov 23 00:09:32 kefk kernel: uhci_hcd 0000:00:1d.1: uhci_result_con=
trol:=20
> > failed with status 440000
> > Nov 23 00:09:32 kefk kernel: [f7a73240] link (37a731b2) element (37=
ab2040)
> > Nov 23 00:09:32 kefk kernel:   0: [f7ab2040] link (37ab2080) e0 Sta=
lled=20
> > CRC/Timeo Length=3D7 MaxLen=3D7 DT0 EndPt=3D0 Dev=3D0, PID=3D2d(SET=
UP) (buf=3D36edfba0)
> > Nov 23 00:09:32 kefk kernel:   1: [f7ab2080] link (37ab20c0) e3 SPD=
 Active=20
> > Length=3D0 MaxLen=3D3f DT1 EndPt=3D0 Dev=3D0, PID=3D69(IN) (buf=3D3=
6252980)
> > Nov 23 00:09:32 kefk kernel:   2: [f7ab20c0] link (00000001) e3 IOC=
 Active=20
> > Length=3D0 MaxLen=3D7ff DT1 EndPt=3D0 Dev=3D0, PID=3De1(OUT) (buf=3D=
00000000)
> > Nov 23 00:09:32 kefk kernel:
> > Nov 23 00:09:32 kefk kernel: usb 2-1: device descriptor read/64, er=
ror -71
> > Nov 23 00:09:32 kefk kernel: uhci_hcd 0000:00:1d.1: uhci_result_con=
trol:=20
> > failed with status 440000
> > Nov 23 00:09:32 kefk kernel: [f7a73240] link (37a731b2) element (37=
ab2040)
> > Nov 23 00:09:32 kefk kernel:   0: [f7ab2040] link (37ab2080) e0 Sta=
lled=20
> > CRC/Timeo Length=3D7 MaxLen=3D7 DT0 EndPt=3D0 Dev=3D0, PID=3D2d(SET=
UP) (buf=3D36edfba0)
> > Nov 23 00:09:32 kefk kernel:   1: [f7ab2080] link (37ab20c0) e3 SPD=
 Active=20
> > Length=3D0 MaxLen=3D3f DT1 EndPt=3D0 Dev=3D0, PID=3D69(IN) (buf=3D3=
6252980)
> > Nov 23 00:09:32 kefk kernel:   2: [f7ab20c0] link (00000001) e3 IOC=
 Active=20
> > Length=3D0 MaxLen=3D7ff DT1 EndPt=3D0 Dev=3D0, PID=3De1(OUT) (buf=3D=
00000000)
> > Nov 23 00:09:32 kefk kernel:
> > Nov 23 00:09:33 kefk kernel: usb 2-1: device descriptor read/64, er=
ror -71
> > Nov 23 00:09:33 kefk kernel: usb 2-1: new full speed USB device usi=
ng uhci_hcd=20
> > and address 3
> > Nov 23 00:09:33 kefk kernel: uhci_hcd 0000:00:1d.1: uhci_result_con=
trol:=20
> > failed with status 440000
> > Nov 23 00:09:33 kefk kernel: [f7a73240] link (37a731b2) element (37=
ab2040)
> > Nov 23 00:09:33 kefk kernel:   0: [f7ab2040] link (37ab2080) e0 Sta=
lled=20
> > CRC/Timeo Length=3D7 MaxLen=3D7 DT0 EndPt=3D0 Dev=3D0, PID=3D2d(SET=
UP) (buf=3D36edfba0)
> > Nov 23 00:09:33 kefk kernel:   1: [f7ab2080] link (37ab20c0) e3 SPD=
 Active=20
> > Length=3D0 MaxLen=3D3f DT1 EndPt=3D0 Dev=3D0, PID=3D69(IN) (buf=3D3=
6252980)
> > Nov 23 00:09:33 kefk kernel:   2: [f7ab20c0] link (00000001) e3 IOC=
 Active=20
> > Length=3D0 MaxLen=3D7ff DT1 EndPt=3D0 Dev=3D0, PID=3De1(OUT) (buf=3D=
00000000)
> > Nov 23 00:09:33 kefk kernel:
> > Nov 23 00:09:33 kefk kernel: usb 2-1: device descriptor read/64, er=
ror -71
> > Nov 23 00:09:33 kefk kernel: uhci_hcd 0000:00:1d.1: uhci_result_con=
trol:=20
> > failed with status 440000
> > Nov 23 00:09:33 kefk kernel: [f7a73240] link (37a731b2) element (37=
ab2040)
> > Nov 23 00:09:33 kefk kernel:   0: [f7ab2040] link (37ab2080) e0 Sta=
lled=20
> > CRC/Timeo Length=3D7 MaxLen=3D7 DT0 EndPt=3D0 Dev=3D0, PID=3D2d(SET=
UP) (buf=3D36edfba0)
> > Nov 23 00:09:33 kefk kernel:   1: [f7ab2080] link (37ab20c0) e3 SPD=
 Active=20
> > Length=3D0 MaxLen=3D3f DT1 EndPt=3D0 Dev=3D0, PID=3D69(IN) (buf=3D3=
6252980)
> > Nov 23 00:09:33 kefk kernel:   2: [f7ab20c0] link (00000001) e3 IOC=
 Active=20
> > Length=3D0 MaxLen=3D7ff DT1 EndPt=3D0 Dev=3D0, PID=3De1(OUT) (buf=3D=
00000000)
> > Nov 23 00:09:33 kefk kernel:
> > Nov 23 00:09:33 kefk kernel: usb 2-1: device descriptor read/64, er=
ror -71
> > Nov 23 00:09:33 kefk kernel: hub 2-0:1.0: state 5 ports 2 chg fffc =
evt 0002
> > Nov 23 00:09:38 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 =
evt 0008
> > Nov 23 00:09:38 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001002 POWER sig=3Dse0  CSC
> > Nov 23 00:09:38 kefk kernel: hub 5-0:1.0: port 3, status 0100, chan=
ge 0001, 12=20
> > Mb/s
> > Nov 23 00:09:38 kefk kernel: hub 5-0:1.0: debounce: port 3: total 1=
00ms stable=20
> > 100ms status 0x100
> > Nov 23 00:09:38 kefk kernel: hub 2-0:1.0: state 5 ports 2 chg fffc =
evt 0002
> > Nov 23 00:09:38 kefk kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 0=
082,00
> > Nov 23 00:09:38 kefk kernel: hub 2-0:1.0: port 1, status 0100, chan=
ge 0001, 12=20
> > Mb/s
> > Nov 23 00:09:38 kefk kernel: hub 2-0:1.0: debounce: port 1: total 1=
00ms stable=20
> > 100ms status 0x100
> > Nov 23 00:09:39 kefk kernel: uhci_hcd 0000:00:1d.1: suspend_hc
> > [...]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > After some tries, now it almost works (still double entry for sdb1 =
in logs):
> > Nov 23 00:10:11 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 =
evt 0008
> > Nov 23 00:10:11 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001803 POWER sig=3Dj  CSC CONNECT
> > Nov 23 00:10:11 kefk kernel: hub 5-0:1.0: port 3, status 0501, chan=
ge 0001,=20
> > 480 Mb/s
> > Nov 23 00:10:11 kefk kernel: hub 5-0:1.0: debounce: port 3: total 1=
00ms stable=20
> > 100ms status 0x501
> > Nov 23 00:10:11 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 high spe=
ed
> > Nov 23 00:10:11 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001005 POWER sig=3Dse0  PE CONNECT
> > Nov 23 00:10:11 kefk kernel: usb 5-3: new high speed USB device usi=
ng ehci_hcd=20
> > and address 7
> > Nov 23 00:10:11 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 high spe=
ed
> > Nov 23 00:10:11 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001005 POWER sig=3Dse0  PE CONNECT
> > Nov 23 00:10:11 kefk kernel: usb 5-3: new device strings: Mfr=3D1, =
Product=3D2,=20
> > SerialNumber=3D3
> > Nov 23 00:10:11 kefk kernel: usb 5-3: default language 0x0409
> > Nov 23 00:10:11 kefk kernel: usb 5-3: Product: Mass storage
> > Nov 23 00:10:11 kefk kernel: usb 5-3: Manufacturer: USB
> > Nov 23 00:10:11 kefk kernel: usb 5-3: SerialNumber: 142E19413C2FCA3=
4
> > Nov 23 00:10:11 kefk kernel: usb 5-3: hotplug
> > Nov 23 00:10:11 kefk kernel: usb 5-3: adding 5-3:1.0 (config #1, in=
terface 0)
> > Nov 23 00:10:11 kefk kernel: usb 5-3:1.0: hotplug
> > Nov 23 00:10:11 kefk kernel: Initializing USB Mass Storage driver..=
=2E
> > Nov 23 00:10:11 kefk kernel: usb-storage 5-3:1.0: usb_probe_interfa=
ce
> > Nov 23 00:10:11 kefk kernel: usb-storage 5-3:1.0: usb_probe_interfa=
ce - got id
> > Nov 23 00:10:11 kefk kernel: scsi3 : SCSI emulation for USB Mass St=
orage=20
> > devices
> > Nov 23 00:10:11 kefk kernel: usbcore: registered new driver usb-sto=
rage
> > Nov 23 00:10:11 kefk kernel: USB Mass Storage support registered.
> > Nov 23 00:10:11 kefk kernel: usb-storage: device found at 7
> > Nov 23 00:10:11 kefk kernel: usb-storage: waiting for device to set=
tle before=20
> > scanning
> > Nov 23 00:10:16 kefk kernel:   Vendor: 512MB     Model: USB2.0Flash=
Drive  Rev:=20
> > 2.00
> > Nov 23 00:10:16 kefk kernel:   Type:   Direct-Access               =
       ANSI=20
> > SCSI revision: 02
> > Nov 23 00:10:16 kefk kernel: sdb: Unit Not Ready, sense:
> > Nov 23 00:10:16 kefk kernel: : Current: sense key=3D0x6
> > Nov 23 00:10:16 kefk kernel:     ASC=3D0x28 ASCQ=3D0x0
> > Nov 23 00:10:17 kefk kernel: sdb : READ CAPACITY failed.
> > Nov 23 00:10:17 kefk kernel: sdb : status=3D1, message=3D00, host=3D=
0, driver=3D08
> > Nov 23 00:10:17 kefk kernel: sd: Current: sense key=3D0x6
> > Nov 23 00:10:17 kefk kernel:     ASC=3D0x28 ASCQ=3D0x0
> > Nov 23 00:10:17 kefk kernel: sdb: test WP failed, assume Write Enab=
led
> > Nov 23 00:10:17 kefk kernel: sdb: assuming drive cache: write throu=
gh
> > Nov 23 00:10:17 kefk kernel: sdb: Unit Not Ready, sense:
> > Nov 23 00:10:17 kefk kernel: : Current: sense key=3D0x6
> > Nov 23 00:10:17 kefk kernel:     ASC=3D0x28 ASCQ=3D0x0
> > Nov 23 00:10:17 kefk kernel: SCSI device sdb: 1024000 512-byte hdwr=
 sectors=20
> > (524 MB)
> > Nov 23 00:10:17 kefk kernel: sdb: Write Protect is off
> > Nov 23 00:10:17 kefk kernel: sdb: Mode Sense: 03 00 00 00
> > Nov 23 00:10:17 kefk kernel: sdb: assuming drive cache: write throu=
gh
> > Nov 23 00:10:17 kefk kernel: SCSI device sdb: 1024000 512-byte hdwr=
 sectors=20
> > (524 MB)
> > Nov 23 00:10:17 kefk kernel: sdb: Write Protect is off
> > Nov 23 00:10:17 kefk kernel: sdb: Mode Sense: 03 00 00 00
> > Nov 23 00:10:17 kefk kernel: sdb: assuming drive cache: write throu=
gh
> > Nov 23 00:10:17 kefk kernel:  sdb: sdb1
> > Nov 23 00:10:17 kefk kernel:  sdb: sdb1
> > Nov 23 00:10:17 kefk kernel: kobject_register failed for sdb1 (-17)
> > Nov 23 00:10:17 kefk kernel:  [bitmap_scnlistprintf+191/292]=20
> > kobject_register+0x51/0x5f
> > Nov 23 00:10:17 kefk kernel:  [<c01f28eb>] kobject_register+0x51/0x=
5f
> > Nov 23 00:10:17 kefk kernel:  [stat_open+45/154] add_partition+0xbb=
/0xf0
> > Nov 23 00:10:17 kefk kernel:  [<c0185208>] add_partition+0xbb/0xf0
> > Nov 23 00:10:17 kefk kernel:  [cmdline_read_proc+9/103]=20
> > register_disk+0xee/0x11d
> > Nov 23 00:10:17 kefk kernel:  [<c0185380>] register_disk+0xee/0x11d
> > Nov 23 00:10:17 kefk kernel:  [unregister_blkdev+144/232] add_disk+=
0x36/0x41
> > Nov 23 00:10:17 kefk kernel:  [<c02577d6>] add_disk+0x36/0x41
> > Nov 23 00:10:17 kefk kernel:  [unregister_blkdev+70/232] exact_matc=
h+0x0/0x7
> > Nov 23 00:10:17 kefk kernel:  [<c025778c>] exact_match+0x0/0x7
> > Nov 23 00:10:17 kefk kernel:  [unregister_blkdev+77/232] exact_lock=
+0x0/0xd
> > Nov 23 00:10:17 kefk kernel:  [<c0257793>] exact_lock+0x0/0xd
> > Nov 23 00:10:17 kefk kernel:  [sd_remove+76/82] sd_probe+0x224/0x32=
f
> > Nov 23 00:10:17 kefk kernel:  [<c02982c5>] sd_probe+0x224/0x32f
> > Nov 23 00:10:17 kefk kernel:  [msdos_partition+391/804]=20
> > sysfs_make_dirent+0x1c/0x89
> > Nov 23 00:10:17 kefk kernel:  [<c0186927>] sysfs_make_dirent+0x1c/0=
x89
> > Nov 23 00:10:17 kefk kernel:  [__lock_text_end+370/4802] _spin_lock=
+0x23/0x5e
> > Nov 23 00:10:17 kefk kernel:  [<c031f36c>] _spin_lock+0x23/0x5e
> > Nov 23 00:10:17 kefk kernel:  [__bus_for_each_drv+81/114]=20
> > driver_probe_device+0x29/0x6a
> > Nov 23 00:10:17 kefk kernel:  [<c024efa0>] driver_probe_device+0x29=
/0x6a
> > Nov 23 00:10:17 kefk kernel:  [bus_for_each_drv+28/74] device_attac=
h+0x46/0xaa
> > Nov 23 00:10:17 kefk kernel:  [<c024f027>] device_attach+0x46/0xaa
> > Nov 23 00:10:17 kefk kernel:  [fcntl_setlk+333/707] dput+0x76/0x209
> > Nov 23 00:10:17 kefk kernel:  [<c0168de2>] dput+0x76/0x209
> > Nov 23 00:10:17 kefk kernel:  [device_add_attrs+32/161]=20
> > bus_add_device+0x55/0x97
> > Nov 23 00:10:17 kefk kernel:  [<c024f2ee>] bus_add_device+0x55/0x97
> > Nov 23 00:10:17 kefk kernel:  [device_remove_file+12/61] device_add=
+0xb9/0x15c
> > Nov 23 00:10:17 kefk kernel:  [<c024e2ee>] device_add+0xb9/0x15c
> > Nov 23 00:10:17 kefk kernel:  [scsi_sysfs_add_sdev+651/777]=20
> > scsi_sysfs_add_sdev+0xa0/0x309
> > Nov 23 00:10:17 kefk kernel:  [<c0276649>] scsi_sysfs_add_sdev+0xa0=
/0x309
> > Nov 23 00:10:17 kefk kernel:  [scsi_probe_and_add_lun+292/425]=20
> > scsi_add_lun+0x2d9/0x32f
> > Nov 23 00:10:17 kefk kernel:  [<c02751fc>] scsi_add_lun+0x2d9/0x32f
> > Nov 23 00:10:17 kefk kernel:  [scsi_sequential_lun_scan+142/239]=20
> > scsi_probe_and_add_lun+0xbd/0x1c2
> > Nov 23 00:10:17 kefk kernel:  [<c027530f>] scsi_probe_and_add_lun+0=
xbd/0x1c2
> > Nov 23 00:10:17 kefk kernel:  [scsi_scan_host_selected+180/199]=20
> > scsi_scan_target+0x9a/0x106
> > Nov 23 00:10:17 kefk kernel:  [<c0275a89>] scsi_scan_target+0x9a/0x=
106
> > Nov 23 00:10:17 kefk kernel:  [scsi_free_host_dev+51/64]=20
> > scsi_scan_channel+0x7c/0x9a
> > Nov 23 00:10:17 kefk kernel:  [<c0275b71>] scsi_scan_channel+0x7c/0=
x9a
> > Nov 23 00:10:17 kefk kernel:  [check_set+39/139]=20
> > scsi_scan_host_selected+0x6e/0xc7
> > Nov 23 00:10:17 kefk kernel:  [<c0275bfd>] scsi_scan_host_selected+=
0x6e/0xc7
> > Nov 23 00:10:17 kefk kernel:  [scsi_scan+22/193] scsi_scan_host+0x2=
1/0x25
> > Nov 23 00:10:17 kefk kernel:  [<c0275c77>] scsi_scan_host+0x21/0x25
> > Nov 23 00:10:17 kefk kernel:  [pg0+946558698/1069159424]=20
> > usb_stor_scan_thread+0x13a/0x14b [usb_storage]
> > Nov 23 00:10:17 kefk kernel:  [<f8b126ea>] usb_stor_scan_thread+0x1=
3a/0x14b=20
> > [usb_storage]
> > Nov 23 00:10:17 kefk kernel:  [do_timer_gettime+232/297]=20
> > autoremove_wake_function+0x0/0x43
> > Nov 23 00:10:17 kefk kernel:  [<c012d031>] autoremove_wake_function=
+0x0/0x43
> > Nov 23 00:10:17 kefk kernel:  [copy_thread+542/592] ret_from_fork+0=
x6/0x14
> > Nov 23 00:10:17 kefk kernel:  [<c0102506>] ret_from_fork+0x6/0x14
> > Nov 23 00:10:17 kefk kernel:  [do_timer_gettime+232/297]=20
> > autoremove_wake_function+0x0/0x43
> > Nov 23 00:10:17 kefk kernel:  [<c012d031>] autoremove_wake_function=
+0x0/0x43
> > Nov 23 00:10:17 kefk kernel:  [pg0+946558384/1069159424]=20
> > usb_stor_scan_thread+0x0/0x14b [usb_storage]
> > Nov 23 00:10:17 kefk kernel:  [<f8b125b0>] usb_stor_scan_thread+0x0=
/0x14b=20
> > [usb_storage]
> > Nov 23 00:10:17 kefk kernel:  [huft_build+637/1249]=20
> > kernel_thread_helper+0x5/0xb
> > Nov 23 00:10:17 kefk kernel:  [<c01008a5>] kernel_thread_helper+0x5=
/0xb
> > Nov 23 00:10:17 kefk kernel: Attached scsi removable disk sdb at sc=
si3,=20
> > channel 0, id 0, lun 0
> > Nov 23 00:10:17 kefk kernel: Attached scsi generic sg4 at scsi3, ch=
annel 0, id=20
> > 0, lun 0,  type 0
> > Nov 23 00:10:17 kefk kernel: usb-storage: device scan complete
> > Nov 23 00:10:17 kefk scsi.agent[7398]: disk=20
> > at /devices/pci0000:00/0000:00:1d.7/usb5/5-3/5-3:1.0/host3/target3:=
0:0/3:0:0:0
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > device removal:
> > Nov 23 00:10:26 kefk kernel: hub 5-0:1.0: state 5 ports 8 chg ff00 =
evt 0008
> > Nov 23 00:10:26 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port =
3 status=20
> > 001002 POWER sig=3Dse0  CSC
> > Nov 23 00:10:26 kefk kernel: hub 5-0:1.0: port 3, status 0100, chan=
ge 0001, 12=20
> > Mb/s
> > Nov 23 00:10:26 kefk kernel: usb 5-3: USB disconnect, address 7
> > Nov 23 00:10:26 kefk kernel: usb 5-3: usb_disable_device nuking all=
 URBs
> > Nov 23 00:10:26 kefk kernel: usb 5-3: unregistering interface 5-3:1=
=2E0
> > Nov 23 00:10:26 kefk kernel: BUG: atomic counter underflow at:
> > Nov 23 00:10:26 kefk kernel:  [create_dir+25/68] kref_put+0x48/0x92
> > Nov 23 00:10:26 kefk kernel:  [<c01f33aa>] kref_put+0x48/0x92
> > Nov 23 00:10:26 kefk kernel:  [storenote+15/185] del_gendisk+0x1d/0=
xd5
> > Nov 23 00:10:26 kefk kernel:  [<c0185588>] del_gendisk+0x1d/0xd5
> > Nov 23 00:10:26 kefk kernel:  [sr_media_change+27/157] sd_remove+0x=
17/0x52
> > Nov 23 00:10:26 kefk kernel:  [<c02983e7>] sd_remove+0x17/0x52
> > Nov 23 00:10:26 kefk kernel:  [device_attach+108/170]=20
> > device_release_driver+0x6d/0x6f
> > Nov 23 00:10:26 kefk kernel:  [<c024f17d>] device_release_driver+0x=
6d/0x6f
> > Nov 23 00:10:26 kefk kernel:  [device_remove_attrs+20/90]=20
> > bus_remove_device+0x53/0x90
> > Nov 23 00:10:26 kefk kernel:  [<c024f383>] bus_remove_device+0x53/0=
x90
> > Nov 23 00:10:26 kefk kernel:  [device_add+177/348] device_del+0x54/=
0x91
> > Nov 23 00:10:26 kefk kernel:  [<c024e416>] device_del+0x54/0x91
> > Nov 23 00:10:26 kefk kernel:  [scsi_sysfs_add_host+233/303]=20
> > scsi_remove_device+0x4e/0xab
> > Nov 23 00:10:26 kefk kernel:  [<c0276900>] scsi_remove_device+0x4e/=
0xab
> > Nov 23 00:10:26 kefk kernel:  [scsi_scan+71/193] scsi_forget_host+0=
x2d/0x4f
> > Nov 23 00:10:26 kefk kernel:  [<c0275ca8>] scsi_forget_host+0x2d/0x=
4f
> > Nov 23 00:10:26 kefk kernel:  [scsi_device_lookup+63/106]=20
> > scsi_remove_host+0x8/0x7c
> > Nov 23 00:10:26 kefk kernel:  [<c026fbbb>] scsi_remove_host+0x8/0x7=
c
> > Nov 23 00:10:26 kefk kernel:  [pg0+946559379/1069159424]=20
> > storage_disconnect+0x7b/0x8d [usb_storage]
> > Nov 23 00:10:26 kefk kernel:  [<f8b12993>] storage_disconnect+0x7b/=
0x8d=20
> > [usb_storage]
> > Nov 23 00:10:26 kefk kernel:  [usb_epnum_to_ep_desc+74/145]=20
> > usb_unbind_interface+0x5e/0x60
> > Nov 23 00:10:26 kefk kernel:  [<c02a415d>] usb_unbind_interface+0x5=
e/0x60
> > Nov 23 00:10:26 kefk kernel:  [device_attach+108/170]=20
> > device_release_driver+0x6d/0x6f
> > Nov 23 00:10:26 kefk kernel:  [<c024f17d>] device_release_driver+0x=
6d/0x6f
> > Nov 23 00:10:26 kefk kernel:  [device_remove_attrs+20/90]=20
> > bus_remove_device+0x53/0x90
> > Nov 23 00:10:26 kefk kernel:  [<c024f383>] bus_remove_device+0x53/0=
x90
> > Nov 23 00:10:26 kefk kernel:  [device_add+177/348] device_del+0x54/=
0x91
> > Nov 23 00:10:26 kefk kernel:  [<c024e416>] device_del+0x54/0x91
> > Nov 23 00:10:26 kefk kernel:  [usb_set_interface+31/431]=20
> > usb_disable_device+0xda/0x147
> > Nov 23 00:10:26 kefk kernel:  [<c02abf27>] usb_disable_device+0xda/=
0x147
> > Nov 23 00:10:26 kefk kernel:  [show_string+24/170] usb_disconnect+0=
xa8/0x188
> > Nov 23 00:10:26 kefk kernel:  [<c02a6969>] usb_disconnect+0xa8/0x18=
8
> > Nov 23 00:10:26 kefk kernel:  [hub_events+52/1270]=20
> > hub_port_connect_change+0x344/0x477
> > Nov 23 00:10:26 kefk kernel:  [<c02a7e1e>] hub_port_connect_change+=
0x344/0x477
> > Nov 23 00:10:26 kefk kernel:  [led_work+187/369] clear_port_feature=
+0x48/0x4d
> > Nov 23 00:10:26 kefk kernel:  [<c02a5100>] clear_port_feature+0x48/=
0x4d
> > Nov 23 00:10:26 kefk kernel:  [hub_events+1169/1270] hub_events+0x3=
2a/0x4f6
> > Nov 23 00:10:26 kefk kernel:  [<c02a827b>] hub_events+0x32a/0x4f6
> > Nov 23 00:10:26 kefk kernel:  [usb_hub_cleanup+35/40] hub_thread+0x=
35/0x10e
> > Nov 23 00:10:26 kefk kernel:  [<c02a847c>] hub_thread+0x35/0x10e
> > Nov 23 00:10:26 kefk kernel:  [do_timer_gettime+232/297]=20
> > autoremove_wake_function+0x0/0x43
> > Nov 23 00:10:26 kefk kernel:  [<c012d031>] autoremove_wake_function=
+0x0/0x43
> > Nov 23 00:10:26 kefk kernel:  [copy_thread+542/592] ret_from_fork+0=
x6/0x14
> > Nov 23 00:10:26 kefk kernel:  [<c0102506>] ret_from_fork+0x6/0x14
> > Nov 23 00:10:26 kefk kernel:  [do_timer_gettime+232/297]=20
> > autoremove_wake_function+0x0/0x43
> > Nov 23 00:10:26 kefk kernel:  [<c012d031>] autoremove_wake_function=
+0x0/0x43
> > Nov 23 00:10:26 kefk kernel:  [usb_hub_init+89/107] hub_thread+0x0/=
0x10e
> > Nov 23 00:10:26 kefk kernel:  [<c02a8447>] hub_thread+0x0/0x10e
> > Nov 23 00:10:26 kefk kernel:  [huft_build+637/1249]=20
> > kernel_thread_helper+0x5/0xb
> > Nov 23 00:10:26 kefk kernel:  [<c01008a5>] kernel_thread_helper+0x5=
/0xb
> > Nov 23 00:10:26 kefk kernel: usb 5-3:1.0: hotplug
> > Nov 23 00:10:26 kefk kernel: usb 5-3: unregistering device
> > Nov 23 00:10:26 kefk kernel: usb 5-3: hotplug
> > Nov 23 00:10:26 kefk kernel: hub 5-0:1.0: debounce: port 3: total 1=
00ms stable=20
> > 100ms status 0x100
> >=20
> > HTH
> >=20
> >=20
> > --=20
> > Fabio Coatti       http://members.ferrara.linux.it/cova    =20
> > Ferrara Linux Users Group           http://ferrara.linux.it
> > GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
> > Old SysOps never die... they simply forget their password.
> >=20
> >=20
> > -------------------------------------------------------
> > SF email is sponsored by - The IT Product Guide
> > Read honest & candid reviews on hundreds of IT Products from real u=
sers.
> > Discover which products truly live up to the hype. Start reading no=
w.=20
> > http://productguide.itmanagersjournal.com/
> > _______________________________________________
> > linux-usb-devel@lists.sourceforge.net
> > To unsubscribe, use the last form field at:
> > https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
> >=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
