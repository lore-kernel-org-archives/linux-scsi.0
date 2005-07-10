From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 21:26:02 +0200
Message-ID: <42D1764A.3060908@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave> <42D15C28.5030705@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:63693 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261162AbVGJT0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 15:26:18 -0400
In-Reply-To: <42D15C28.5030705@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ben Collins <bcollins@debian.org>, Jeff Garzik <jgarzik@pobox.com>

I wrote:
> I tested sbp2 with the logic as presently in 2.6.13-rc2 and added
> printks everywhere where linux1394.org's old code would do a conversi=
on.
> The result:

DViCO Momobay FX-3A 3.5" HDD, based on TSB42AA9A bridge
now without sbp2's 36byt inquiry workaround
-------------------------------------------------------
Jul 10 20:04:13 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SB=
P-2 Devices
Jul 10 20:04:14 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 devic=
e
Jul 10 20:04:14 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_respons=
e: case INQUIRY, TYPE_RBC
Jul 10 20:04:14 shuttle kernel:   Vendor:  DViCO    Model: MOMOBAY FX-3=
A     Rev: REV1
Jul 10 20:04:14 shuttle kernel:   Type:   Unknown                      =
      ANSI SCSI revision: 02

Then silence.
# cat /sys/bus/scsi/devices/*/type
14

MacPower IceCube 3.5" HDD (old FireWire 400 model), OXFW911 based
-----------------------------------------------------------------
Jul 10 20:05:12 shuttle kernel: scsi1 : SCSI emulation for IEEE-1394 SB=
P-2 Devices
Jul 10 20:05:14 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 devic=
e
Jul 10 20:05:14 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_respons=
e: case INQUIRY, TYPE_RBC
Jul 10 20:05:14 shuttle kernel:   Vendor: SAMSUNG   Model: SV1204H     =
      Rev:
Jul 10 20:05:14 shuttle kernel:   Type:   Unknown                      =
      ANSI SCSI revision: 06

Silence.
# cat /sys/bus/scsi/devices/*/type
14

AVLAB 1394b-to-IDE 2.5=E2=80=9D Drive Kit, INIC-2430F based
---------------------------------------------------
A few log lines appear, then the PC *reboots* right away. Happens consi=
stently.
Did not happen with the kernel I used before, 2.6.11.x + up-to-date lin=
ux1394.


MacPower Prefect II 5.25" DVD-RW, PL-3507 based
-----------------------------------------------
Jul 10 20:18:51 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SB=
P-2 Devices
Jul 10 20:18:52 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 devic=
e
Jul 10 20:18:52 shuttle kernel:   Vendor: PLEXTOR   Model: DVDR   PX-71=
6A    Rev: 1.08
Jul 10 20:18:52 shuttle kernel:   Type:   CD-ROM                       =
      ANSI SCSI revision: 02
Jul 10 20:18:52 shuttle scsi.agent: cdrom at /devices/pci0000:00/0000:0=
0:0c.0/fw-host1/0030e005003b00c8/0030e005003b00c8-0/host0/target0:0:0/0=
:0:0:0
Jul 10 20:18:52 shuttle kernel: sr0: scsi3-mmc drive: 40x/40x writer cd=
/rw xa/form2 cdda tray

# cat /sys/bus/scsi/devices/*/type
5

"cdrdao read-cd ..." and "cdrdao write --simulate ..." work.
No sbp2_check_command or _response is logged during cdrdao's runs.
scsi_host_dev_release is not called when the DVD-RW is disconnected, bu=
t
that is another story.

=46ormac CDRW 16/10/40, an old 5.25" enclosure with LSI bridge
------------------------------------------------------------
Jul 10 20:46:00 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SB=
P-2 Devices
Jul 10 20:46:02 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 devic=
e
Jul 10 20:46:02 shuttle kernel:   Vendor: TEAC      Model: CD-W516EB   =
      Rev: 1.0A
Jul 10 20:46:02 shuttle kernel:   Type:   CD-ROM                       =
      ANSI SCSI revision: 02
Jul 10 20:46:02 shuttle scsi.agent: cdrom at /devices/pci0000:00/0000:0=
0:0c.0/fw-host1/00a0b80300002142/00a0b80300002142-0/host0/target0:0:0/0=
:0:0:0
Jul 10 20:46:04 shuttle kernel: sr0: scsi3-mmc drive: 40x/40x writer cd=
/rw xa/form2 cdda tray

Same as above with type and cdrdao.

SmartDisk VST Portable CD-RW, unknown bridge
--------------------------------------------
Jul 10 20:58:05 shuttle kernel: scsi1 : SCSI emulation for IEEE-1394 SB=
P-2 Devices
Jul 10 20:58:14 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 devic=
e
Jul 10 20:58:14 shuttle kernel:   Vendor: TEAC      Model: CD-W28E     =
      Rev: 1.1A
Jul 10 20:58:14 shuttle kernel:   Type:   CD-ROM                       =
      ANSI SCSI revision: 02
Jul 10 20:58:14 shuttle kernel: sr1: scsi3-mmc drive: 24x/24x writer cd=
/rw xa/form2 cdda tray
Jul 10 20:58:14 shuttle kernel: Attached scsi generic sg1 at scsi1, cha=
nnel 0, id 0, lun 0,  type 5
Jul 10 20:58:15 shuttle scsi.agent: cdrom at /devices/pci0000:00/0000:0=
0:0a.0/fw-host0/00d0010500006823/00d0010500006823-0/host1/target1:0:0/1=
:0:0:0

Same again.

I will have a closer look at the silent 3.5" disks right away.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D=3D=3D -=3D-=3D-
http://arcgraph.de/sr/


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
