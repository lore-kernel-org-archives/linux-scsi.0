From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: PL3507 in daisy-chain - timeouts with disk spinup and "slow" disks
Date: Wed, 04 Jul 2007 21:38:38 +0200
Message-ID: <468BF73E.3020001@s5r6.in-berlin.de>
References: <9ef28c5d0707030225l3aa4587bx4aa6d99cd19762e9@mail.gmail.com>
	<9ef28c5d0707030246v698d12b2j841edaac7da8c9bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <9ef28c5d0707030246v698d12b2j841edaac7da8c9bd@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: mposch@gmail.com
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(Full quote for linux-scsi)

mposch@gmail.com wrote at linux1394-user:
> Hi,
> 
> I'm successfully running four IcyBox IB351-UE external enclosures in a
> daisy-chained configuration. All four boxes have the latest Prolific
> firmware from www.raidsonic.de installed.

Prolific based FireWire/USB combo devices are notorious for being sold
with ancient broken firmwares of their FireWire part (not of the USB
part), so it's good that you installed a recent firmware.  Do they have
release notes or release dates which you could compare with those of
Prolific's own firmware?
http://www.prolific.com.tw/eng/downloads.asp?ID=44

> Everything seems to work fairly well as long as the disks are running.
> However, to prevent from heat problems I'm using a script and sg_start
> from sg3_utils to spin down the drives if there is no change in
> /proc/diskstats for the specified disk. Basically, the command being
> executed is: sg_start 0 --pc=2 /dev/sdX
> 
> The --pc=2 (Power condotion) seems to be the only command which the
> Prolific chipset seems to support to spin up/down the disks.
> sg_start 1 --pc=0 /dev/sdX
> Always works without problems to "wake up" the disk again.
> 
> The problem (timeout errors) I'm getting manifests when the disks are
> being automatically spun up on disk access, and it happens only on
> "slow" disks. It also seems to happen more often when the OS is trying
> to write something to the disk - a simple fdisk -l always gets all
> disks up and running.

Occasional timeouts shouldn't be a problem.  The fact that the timeout
of the very first attempted command (which is accompanied by the SBP-2
protocol request of a "fetch agent reset") is followed-up by several
more timeouts, so that the SCSI subsystem eventually decides to take the
device offline, is IMO a hint on a fragile firmware.

Default timeouts of different kinds are hardwired in the SCSI subsystem.
 From linux/include/scsi.h:

#define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
#define START_STOP_TIMEOUT		(60 * HZ)
#define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
#define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
#define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )

There is also a writable sysfs attribute for each SCSI device of which
effects I am uncertain:
# ll /sys/bus/scsi/devices/0\:0\:0\:0/timeout
-rw-r--r-- 1 root root 4096 Jul  4 21:10
/sys/bus/scsi/devices/0:0:0:0/timeout
# cat /sys/bus/scsi/devices/0\:0\:0\:0/timeout
30

What if you set a higher value in there with "echo XYZ > ..."?

> To further explain, this is my /proc/scsi/scsi content:
> Host: scsi8 Channel: 00 Id: 00 Lun: 00
>  Vendor: IC35L040 Model: AVVN07-0         Rev:
>      Type:   Direct-Access-RBC                ANSI SCSI revision: 04
> Host: scsi9 Channel: 00 Id: 00 Lun: 00
>  Vendor: WDC WD25 Model: 00BB-00GUC0      Rev:
>      Type:   Direct-Access-RBC                ANSI SCSI revision: 04
> Host: scsi10 Channel: 00 Id: 00 Lun: 00
>  Vendor: Maxtor 6 Model: L080P0           Rev:
>      Type:   Direct-Access-RBC                ANSI SCSI revision: 04
> Host: scsi11 Channel: 00 Id: 00 Lun: 00
>  Vendor: WDC WD25 Model: 00BB-00RDA0      Rev:
>      Type:   Direct-Access-RBC                ANSI SCSI revision: 04
> 
> The WDC disks need about 6 to 10 seconds to spin up and get ready, all
> other disks are ready after about 3-5 seconds. The timeout errors only
> occur on the slower WDC disks. After that, the disk gets unusable
> (device offlined), but the case's LED continues to flash repeatedly,
> there is also audible disk access. This continues until the enclosure
> is powered off and on again.

Apparently the firmware is stuck in a loop, after the sbp2 driver told
it to abort that timed-out command and to start over when the next
command comes.

> I have tested this in the following different cabling configurations
> (I'll use the scsi-numbers from above):
> 
> a)
> Host -- scsi8 -- scsi9 (WDC)
> Host -- scsi10 -- scsi11 (WDC)
> 
> b)
> Host -- scsi9 (WDC) -- scsi8
> Host -- scsi11 (WDC) -- scsi10
> 
> Interestingly, in Configuration b), when one of the WDC disks goes
> offline, scsi commands still seem to be able to travel through the
> Prolific device to scsi8/10. (I can still access the disks 8/10).

Yes, the cable topology doesn't influence this.  The FireWire link layer
controller/ SCSI target/ IDE bridge is on one chip, and the FireWire
physical interface is on another chip.  That phy chip is also a FireWire
repeater, transparently to the link layer controller.

> To sum things up:
> To me it seems that scsi write commands being sent disks have a
> shorter timeout than read commands. When the disk needs to be spun up
> the command times out and the disk goes offline (the kernel seems to
> force it offline). When a simple read command is being sent, it seems
> to be more "tolerant" to timeouts and waits until the disk is online.
> 
> Is there any way to change timeouts so that the kernel waits for the
> disk until it is up and running again? I'm willing to test
> everything...
> 
> Regards,
> Marc Posch
> 
>>From http://www.linux1394.org/trouble.php:
> 
> - kernel version:
>  2.6.20-16-generic (built from Ubuntu feisty kernel source)
> with patchset 2.6.20.y_ieee1394_v474.patch.bz2 (from
> http://me.in-berlin.de/~s5r6/linux1394/updates/2.6.20.y/) applied
> Same happens on unmodified 2.6.20-16-generic - the patchset was an
> attempt to resolve the problem
> - libraw version: libraw1394.so.8.1.1
> - driver: OHCI
> - relevant messages from dmesg:
> -------------------------------------------------
> Jul  2 07:52:12 doriath kernel: [52294.212000] ieee1394: sbp2: aborting sbp2 command
> Jul  2 07:52:12 doriath kernel: [52294.212000] sd 5:0:0:0:
> Jul  2 07:52:12 doriath kernel: [52294.212000]         command: Write(10): 2a 00 1d 1c 44 bf 00 00 08 00

That's a message from sbp2's SCSI command timeout handler
(.eh_abort_handler).

> Jul  2 07:52:22 doriath kernel: [52304.212000] ieee1394: sbp2: aborting sbp2 command
> Jul  2 07:52:22 doriath kernel: [52304.212000] sd 5:0:0:0:
> Jul  2 07:52:22 doriath kernel: [52304.212000]         command: Test Unit Ready: 00 00 00 00 00 00

Timeout handler again.

> Jul  2 07:52:22 doriath kernel: [52304.212000] ieee1394: sbp2: reset requested
> Jul  2 07:52:22 doriath kernel: [52304.212000] ieee1394: sbp2: generating sbp2 fetch agent reset

That's sbp2's SCSI device reset handler (.eh_device_reset_handler).  It
doesn't actually do anything what the timeout handler already tried to
do, so it's quite pointless.  When this gets called because the SCSI
subsystem didn't see a lot of success with the previous command abort
handler calls, the SBP-2 target firmware is probably already dead.

Maybe we should implement something more drastic in the device reset
handler --- e.g. an actual request for a reset similar to power reset.
I never tried this, so I don't know if that would really improve
anything.  I'll notify you when I'm in the mood to write a respective patch.

> Jul  2 07:52:32 doriath kernel: [52314.212000] ieee1394: sbp2: aborting sbp2 command
> Jul  2 07:52:32 doriath kernel: [52314.212000] sd 5:0:0:0:
> Jul  2 07:52:32 doriath kernel: [52314.212000]         command: Test Unit Ready: 00 00 00 00 00 00
> Jul  2 07:52:32 doriath kernel: [52314.212000] sd 5:0:0:0: scsi: Device offlined - not ready after error recovery
> Jul  2 07:52:32 doriath kernel: [52314.212000] sd 5:0:0:0: SCSI error: return code = 0x00050000
> Jul  2 07:52:32 doriath kernel: [52314.212000] end_request: I/O error, dev sdb, sector 488391871

SCSI subsystem finally gave up.

> -------------------------------------------------
> - adapter card model: PL3507
> - output of gscanbus:
> -------------------------------------------------
> Root
> ====
> SelfID Info
> -----------
> Physical ID: 4
> Link active: Yes
> Gap Count: 63
> PHY Speed: S400
> PHY Delay: <=144ns
> IRM Capable: Yes
> Power Class: +15W
> Port 0: Connected to child node
> Port 1: Connected to child node
> Init. reset: Yes
> 
> CSR ROM Info
> ------------
> GUID: 0x004063500006A853
> Node Capabilities: 0x000083C0
> Vendor ID: 0x00004063
> Unit Spec ID: 0x0000005E
> Unit SW Version: 0x00000001
> Model ID: 0x00000000
> Nr. Textual Leafes: 1
> 
> Vendor:  VIA TECHNOLOGIES, INC.
> Textual Leafes:
> Linux - ohci1394
> 
> AV/C Subunits
> -------------
> N/A
> 
> Channel A Child 1
> =================
> SelfID Info
> -----------
> Physical ID: 1
> Link active: Yes
> Gap Count: 63
> PHY Speed: S400
> PHY Delay: <=144ns
> IRM Capable: Yes
> Power Class: -10W
> Port 0: Connected to parent node
> Port 1: Connected to child node
> Init. reset: No
> 
> CSR ROM Info
> ------------
> GUID: 0x0050770E00001BB4
> Node Capabilities: 0x000083C0
> Vendor ID: 0x00005077
> Unit Spec ID: 0x0000609E
> Unit SW Version: 0x00010483
> Model ID: 0x00000001
> Nr. Textual Leafes: 1
> 
> Vendor:  PROLIFIC TECHNOLOGY, INC.
> Textual Leafes:
> Prolific PL3507 Combo Device
> 
> AV/C Subunits
> -------------
> N/A

Looks like RaidSonic actually delivered an original Prolific Firmware
and didn't even replace the vendor string.

> Channel A Child 2
> =================
> SelfID Info
> -----------
> Physical ID: 0
> Link active: Yes
> Gap Count: 63
> PHY Speed: S400
> PHY Delay: <=144ns
> IRM Capable: Yes
> Power Class: -10W
> Port 0: Connected to parent node
> Port 1: Not connected
> Init. reset: No
> 
> CSR ROM Info
> ------------
> GUID: 0x0050770E0000383E
> Node Capabilities: 0x000083C0
> Vendor ID: 0x00005077
> Unit Spec ID: 0x0000609E
> Unit SW Version: 0x00010483
> Model ID: 0x00000001
> Nr. Textual Leafes: 1
> 
> Vendor:  PROLIFIC TECHNOLOGY, INC.
> Textual Leafes:
> Prolific PL3507 Combo Device
> 
> AV/C Subunits
> -------------
> N/A
> 
> Channel B Child 1
> =================
> SelfID Info
> -----------
> Physical ID: 3
> Link active: Yes
> Gap Count: 63
> PHY Speed: S400
> PHY Delay: <=144ns
> IRM Capable: Yes
> Power Class: -10W
> Port 0: Connected to parent node
> Port 1: Connected to child node
> Init. reset: No
> 
> CSR ROM Info
> ------------
> GUID: 0x0050770E00003C09
> Node Capabilities: 0x000083C0
> Vendor ID: 0x00005077
> Unit Spec ID: 0x0000609E
> Unit SW Version: 0x00010483
> Model ID: 0x00000001
> Nr. Textual Leafes: 1
> 
> Vendor:  PROLIFIC TECHNOLOGY, INC.
> Textual Leafes:
> Prolific PL3507 Combo Device
> 
> AV/C Subunits
> -------------
> N/A
> 
> Channel B Child 2
> =================
> SelfID Info
> -----------
> Physical ID: 2
> Link active: Yes
> Gap Count: 63
> PHY Speed: S400
> PHY Delay: <=144ns
> IRM Capable: Yes
> Power Class: -10W
> Port 0: Connected to parent node
> Port 1: Not connected
> Init. reset: No
> 
> CSR ROM Info
> ------------
> GUID: 0x0050770E00003761
> Node Capabilities: 0x000083C0
> Vendor ID: 0x00005077
> Unit Spec ID: 0x0000609E
> Unit SW Version: 0x00010483
> Model ID: 0x00000001
> Nr. Textual Leafes: 1
> 
> Vendor:  PROLIFIC TECHNOLOGY, INC.
> Textual Leafes:
> Prolific PL3507 Combo Device
> 
> AV/C Subunits
> -------------
> N/A
> -------------------------------------------------
> - output of lspci
>  -------------------------------------------------
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8623 [Apollo CLE266]
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP]
> 00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
> 00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. VT8623 [Apollo CLE266] integrated CastleRock graphics (rev 03)
> -------------------------------------------------
> - version of application or utility: sg3_utils version 1.21

-- 
Stefan Richter
-=====-=-=== -=== --=--
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
