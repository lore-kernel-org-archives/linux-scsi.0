From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Linux Kernel 2.4.18 and 2.4.19 problems
Date: Fri, 19 Jul 2002 14:04:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020719140416.A25577@eng2.beaverton.ibm.com>
References: <20020719192607.GA13880@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020719192607.GA13880@stud.ntnu.no>; from tlan@stud.ntnu.no on Fri, Jul 19, 2002 at 09:26:07PM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jul 19, 2002 at 09:26:07PM +0200, Thomas Lang=E5s wrote:
> We've got a few Dell PowerEdge 2650 machines, and thought they would
> become nice fileservers, and we installed RedHat Linux 7.3 on them.
> So far, so good; after the installation, pretty much was downhill
> from there. With RedHat's 2.4.18-3 and 2.4.18-5 kernel we detect
> all disks connected through our QLogic FC 2200 HBA's, with=20
> vanilla 2.4.18 and 2.4.19-rc2, we detect nothing; and we've tried
> Qlogic's 6.0beta13 and 6.1beta2 drivers, as well as the driver
> that comes with redhat's release. We're currently running an almost
> identical configuration, only diff. is one HBA pr server, and
> the servers are 2550's and not 2650's.=20
>=20
> Ok, to sum up problems:
>=20
> With redhat kernels:
> * Disks found, _but_ after about 2-3 mins with heavy I/O on
>   FC HBA's the machine dies, and only thing working is cold boot
>=20
> With vanilla kernels:
> * Disks not found, so we don't know about I/O problems.
>=20
>=20
> Anyone have any ideas?
>=20
>=20
> Here's dmesg and lspci -vvvxx, if anything else is needed, please
> tell me, and I'll provide you with the info:
>=20
> test4:~# dmesg


> Processors: 4
> Kernel command line: auto BOOT_IMAGE=3Dlinux ro root=3D802 BOOT_FILE=3D=
/boot/bzImage-2.4.18-3 max_scsi_luns=3D128

So this is the dmesg for the redhat 2.4.18-3? You said above that
it found the disks, but, further down the qla driver inits and shows:

> qla2x00_set_info starts at address =3D f8836060
> qla2x00: Found  VID=3D1077 DID=3D2200 SSVID=3D1077 SSDID=3D2
> scsi1: Found a QLA2200  @ bus 2, device 0x4, irq 16, iobase 0xdc00
> scsi(1): Allocated 4096 SRB(s)
> PCI: Setting latency timer of device 02:04.0 to 64
> scsi(1): Configure NVRAM parameters...
> scsi(1): 64 Bit PCI Addressing Enabled
> scsi(1): Verifying loaded RISC code...
> scsi(1): Verifying chip...
> scsi(1): Waiting for LIP to complete...
> scsi(1): Cable is unplugged...
> qla2x00: Found  VID=3D1077 DID=3D2200 SSVID=3D1077 SSDID=3D2
> scsi2: Found a QLA2200  @ bus 2, device 0x5, irq 17, iobase 0xd800
> scsi(2): Allocated 4096 SRB(s)
> PCI: Setting latency timer of device 02:05.0 to 64
> scsi(2): Configure NVRAM parameters...
> scsi(2): 64 Bit PCI Addressing Enabled
> scsi(2): Verifying loaded RISC code...
> scsi(2): Verifying chip...
> scsi(2): Waiting for LIP to complete...
> scsi(2): Cable is unplugged...
> scsi1 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 2 devic=
e 4 irq 16
>         Firmware version:  2.02.03, Driver version 6.1b2
> scsi2 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 2 devic=
e 5 irq 17
>         Firmware version:  2.02.03, Driver version 6.1b2

It complains about "Cable is unplugged", and does not find any drives.=20
So, it looks like your redhat kernel is not finding any drives.

You might want to check the hardware and connections. I've seen the qla
(I'm using some beta6 with 2.5.25) get confused as to the state of the
adapter and its connection.

If you turn on scsi logging (be careful, if syslog is running you can g=
et
infinite logging), and insmod your driver, you might get some useful
information, I use:

	echo scsi log scan 5  >/proc/scsi/scsi

The above is safe to use with syslog running (since it logs the scsi
scanning that happens when the adapter comes up, but not all IO).

Also, cat /proc/scsi/scsi and /proc/scsi/qla*/[0-9] and see what they s=
how.

If the adapter appears to find devices, but scanning does not (likely
lun problems), try manually scanning for a device, for example:

	echo scsi add-single-device 1 0 0 0 >/proc/scsi/scsi

Where the numbering above is host, channel, target-id, and then lun.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
