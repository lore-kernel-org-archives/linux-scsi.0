From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 19:34:32 +0200
Message-ID: <42D15C28.5030705@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28099 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261984AbVGJRfC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:35:02 -0400
In-Reply-To: <1121009100.5078.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ben Collins <bcollins@debian.org>, Jeff Garzik <jgarzik@pobox.com>

James Bottomley wrote:
> Could we have a few bug reports to try to diagnose, please?

I tested sbp2 with the logic as presently in 2.6.13-rc2 and added
printks everywhere where linux1394.org's old code would do a conversion.
The result:

DViCO Momobay FX-3A 3.5" HDD, based on TSB42AA9A bridge
-------------------------------------------------------
Jul 10 18:30:15 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 10 18:30:15 shuttle kernel: ieee1394: sbp2: Node 1-00:1023: Using 36byte inquiry workaround
Jul 10 18:30:16 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 10 18:30:17 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case INQUIRY, TYPE_RBC
Jul 10 18:30:17 shuttle kernel:   Vendor:  DViCO    Model: MOMOBAY FX-3A     Rev: REV1
Jul 10 18:30:17 shuttle kernel:   Type:   Unknown                            ANSI SCSI revision: 02

Then silence.

$ cat /sys/bus/scsi/devices/*/type
14

Side note: The FX-3A does not really need the inquiry workaround. It is just
matched like a Momobay CX-1 in sbp2's workarounds section. But the inquiry
hack is harmless when applied on the FX-3A.

DViCO Momobay CX-1 2.5" HDD, based on TSB42AA9 bridge
-----------------------------------------------------
Jul 10 19:15:16 shuttle kernel: scsi1 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 10 19:15:16 shuttle kernel: ieee1394: sbp2: Node 1-00:1023: Using 36byte inquiry workaround
Jul 10 19:15:18 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 10 19:15:18 shuttle kernel:   Vendor: "DViCO"   Model: MOMOBAY CX-1      Rev: REV2
Jul 10 19:15:18 shuttle kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jul 10 19:15:19 shuttle scsi.agent: disk at /devices/pci0000:00/0000:00:0c.0/fw-host1/0001041010004beb/0001041010004beb-0/host1/target1:0:0/1:0:0:0
Jul 10 19:15:19 shuttle kernel: SCSI device sda: 19640880 512-byte hdwr sectors (10056 MB)
Jul 10 19:15:19 shuttle kernel: sda: asking for cache data failed
Jul 10 19:15:19 shuttle kernel: sda: assuming drive cache: write through
Jul 10 19:15:19 shuttle kernel: SCSI device sda: 19640880 512-byte hdwr sectors (10056 MB)
Jul 10 19:15:19 shuttle kernel: sda: asking for cache data failed
Jul 10 19:15:19 shuttle kernel: sda: assuming drive cache: write through
Jul 10 19:15:19 shuttle kernel:  sda: sda1 sda2
Jul 10 19:15:19 shuttle kernel: Attached scsi disk sda at scsi1, channel 0, id 0, l

$ cat /sys/bus/scsi/devices/*/type
0

fdisk -l and hdparm -tT work flawlessly.

MacPower IceCube 800 3.5" HDD, based on OXUF922
-----------------------------------------------
Jul 10 19:25:32 shuttle kernel: scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case INQUIRY, TYPE_RBC
Jul 10 19:25:33 shuttle kernel:   Vendor: ST340083  Model: 2A                Rev: 3.01
Jul 10 19:25:33 shuttle kernel:   Type:   Unknown                            ANSI SCSI revision: 06
Jul 10 19:25:33 shuttle kernel: SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command: case MODE_SENSE, conversion device type
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case MODE_SENSE, TYPE_DISK or TYPE_RBC or TYPE_ROM
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command: case MODE_SENSE, conversion device type
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case MODE_SENSE, TYPE_DISK or TYPE_RBC or TYPE_ROM
Jul 10 19:25:33 shuttle kernel: SCSI device sda: drive cache: write back
Jul 10 19:25:33 shuttle kernel: SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command: case MODE_SENSE, conversion device type
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case MODE_SENSE, TYPE_DISK or TYPE_RBC or TYPE_ROM
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command: case MODE_SENSE, conversion device type
Jul 10 19:25:33 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response: case MODE_SENSE, TYPE_DISK or TYPE_RBC or TYPE_ROM
Jul 10 19:25:33 shuttle kernel: SCSI device sda: drive cache: write back
Jul 10 19:25:33 shuttle kernel:  sda: sda1
Jul 10 19:25:33 shuttle kernel: Attached scsi disk sda at scsi2, channel 0, id 0, lun 0

$ cat /sys/bus/scsi/devices/*/type
14

fdisk -l and hdparm -tT work flawlessly. sbp2_check_sbp2_command and
sbp2_check_sbp2_response are not logged while fdisk and hdparm access
the disk.


More data from other devices including CD-RWs (and from FX-3A without inquiry
hack) will follow later. Must reboot for some reason now.
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/
