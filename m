From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Partitions not detected with firewire - 36 bytes offset - PL-3507
Date: Tue, 7 Jun 2016 15:15:54 +0200
Message-ID: <20160607151554.5b33bc0c@kant>
References: <4379835.Lnu4rjdqZg@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <4379835.Lnu4rjdqZg@debian>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Fab Stz <fabstz-it@yahoo.fr>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Adding Cc: lsml, quoting your message in full.

On Jun 02 Fab Stz wrote at linux1394-user:
> Hello
> 
> I have a external hard drive box (brand SQP : www.sqp.fr, more details
> below) with USB & Firewire support. The chipset is a PL-3507.
> 
> On MaxOS X or windows (eg win10), if I connect through USB or FW, my
> partitions are displayed and the disk is well detected. In Linux (kernel
> 4.5.3) with USB, disk and partitions are well detected. However when
> connected through firewire, the disk is well detected but not the
> partitions.
> 
> By investigating the issue I came to that thread
> [ https://sourceforge.net/p/linux1394/mailman/message/13218958/ ] which
> I read carefuly. I also have an offset when running dd on the disk.
> There are 36 additional bytes (value : 0x00) at the begining of the disk
> when connected through FW compared to USB. That may explain the fact
> that the partitions are not found. BTW, it is a GUID Partition Table in
> my case.
> 
> I checked the firmware, it is dated 2004/Oct/06. According to the
> release notes of the firmware, there was a fix in firmware 2004/Mar/24
> labeled " Fixed cannot mount HDD in Linux RedHat. Must use kernel
> v2.4.20 and above. [1394] ". So I supposed upgrading wouldn't bring
> anything. Nevertheless, I tried upgrading the firmware to a more recent
> one [2004/Nov/09 or even 2006/Apr/20], but upgrade was rejected. The
> above thread mentioned that some boards have a zero resistor preventing
> upgrade. I searched for the zero resistance R72
> (http://club.cdfreaks.com/showthread.php?p=957178), but on my board
> there isn't any. So I don't see how to upgrade the firmware.
> 
> My questions are :
> - could it be a bug in linux driver ?
> - is it that my device is not well detected ? Or is there any workaround
> in the kernel for buggy devices which doesn't match my particular
> device ? It's vendor/device id are when connected as USB idVendor=0025,
> idProduct=3507 (usualy for prolific it is idVendor=067b, idProduct=3507)
> - do you have any other clue to make it work, or upgrade the firmware,
> or determine which zero resistor has to be removed ?
> - is there some way to tell linux to start reading the disk with an
> offset of 36 bytes or ignore these 36 bytes?
> 
> You can find below all technical details.
> 
> Thank you

First a few theoretical thoughts on why the device works under Windows and
OS X but not under Linux:

The first SCSI request which the Linux kernel issues contains the INQUIRY
command.  You are seeing results from INQUIRY in the dmesg portion below.
There is for example a quirk parameter which control how the kernel reads
the INQUIRY response, but it seems to me that this is not relevant here.
(BLIST_INQUIRY_36 from
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/scsi/scsi_devinfo.h)

Next you are also seeing results from a command which the kernel sent
subsequently, MODE SENSE.  MODE SENSE can request various so-called mode
pages.  Most of them are optional, and some buggy firmwares react badly
when asked for a mode page that they don't know about.  There are some
quirk flags which relate to that sort of device bugs
(BLIST_MS_SKIP_PAGE_08, BLIST_MS_SKIP_PAGE_3F, BLIST_USE_10_BYTE_MS,
BLIST_MS_192_BYTES_FOR_3F) but I doubt that you need any of those.

Next, the sd driver should issue READ_CAPACITY to determine medium size
(or maybe this happened already before MODE SENSE, I would have to look
that up in drivers/scsi/sd.c).  Then the block layer(?) should issue a
READ command of some sort in order to fetch the partition table.

If the Linux kernel performs anything of the above in only the tiniest
different way than Windows does it, a buggy firmware like the typical
firmwares of the FireWire portion of PL-3507, the firmware will start
sending malformed results or flat out freeze.

AFAIR this series of commands which the kernel issues, the subsequent
commands come from userland.

And again, if Linux userland sends commands which Windows kernel or
Windows userland do not send (or do not send with such and such parameters
or in this or that particular order of sequence), PL-3507 firmwares will
take offense and go belly-up.

One example would be that userland sends another INQUIRY request.  Which
would be perfectly standards conforming but is highly dangerous for
PL-3507.

The 36 bytes offset which you observed happens to be the same number of
bytes as the length of a typical INQUIRY response buffer.  Coincidence?

So,
  - the SCSI layer and block layer of the Linux kerne could issue commands
    which the PL-3507's firmware cannot handle, but this can be influenced
    to some degree by specifying quirk flags to SCSI core.  (I don't
    remember right now how to do that precisely.)
  - Or Linux userland could issue commands which crash the firmware.

To investigate the latter possibility, you could boot into a minimal
single-user command line and try to use the disk from there.  Consult your
distribution's documentation on how to get into single-user mode.  If that
works, then there is some sort of device probing going on in your regular
userland which upsets the firmware.  E.g. the mentioned double INQUIRY.

Back to your questions, in particular the one about handling the 36 byte
offset:  I do not know of a readily usable quirk flag for this.
Furthermore, I think it would be hard to implement.  The kernel would need
to detect the moment from which on the devise starts to add that offset to
its responses.  Perhaps this moment can be easily and reliably detected,
or perhaps not.

> 
> 
> * kernel version : Linux debian 4.5.0-0.bpo.2-amd64 #1 SMP Debian 4.5.3-2~bpo8+1 (2016-05-13) x86_64 GNU/Linux
> 
> * which kernel drivers you are using (lsmod | grep -e 1394 -e firewire)
> firewire_sbp2          24576  0 
> scsi_mod              229376  7 sg,uas,usb_storage,libata,sd_mod,sr_mod,firewire_sbp2
> firewire_ohci          40960  0 
> firewire_core          65536  2 firewire_ohci,firewire_sbp2
> crc_itu_t              16384  1 firewire_core
> 
> 
> * relevant messages from dmesg
> [66693.391283] firewire_core 0000:02:00.0: phy config: new root=ffc1, gap_count=5
> [66697.227221] firewire_core 0000:02:00.0: phy config: new root=ffc1, gap_count=5
> [66697.666381] firewire_core 0000:02:00.0: created device fw1: GUID 0000190e0000026e, S400
> [66697.844315] scsi host5: SBP-2 IEEE-1394
> [66697.844445] firewire_sbp2 fw1.0: workarounds 0x20 (firmware_revision 0x012804, model_id 0x000001)
> [66698.044800] firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
> [66698.045542] scsi 5:0:0:0: Direct-Access-RBC SAMSUNG  SP0842N               PQ: 0 ANSI: 4
> [66698.045892] sd 5:0:0:0: Attached scsi generic sg3 type 14
> [66698.046476] sd 5:0:0:0: [sdc] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> [66698.046591] sd 5:0:0:0: [sdc] Write Protect is off
> [66698.046596] sd 5:0:0:0: [sdc] Mode Sense: 11 00 00 00
> [66698.046868] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [66698.055440] sd 5:0:0:0: [sdc] Attached SCSI disk

Are there no further messages from the SCSI drivers or block layer drivers?

> * make and model of FireWire peripheral : SQP BOIT-XPCOMPO
> 
> * adapter card model and/or OHCI chipset
> 02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev 46) (prog-if 10 [OHCI])
>         Subsystem: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
>         Flags: bus master, stepping, medium devsel, latency 64, IRQ 16
>         Memory at fdcff000 (32-bit, non-prefetchable) [size=2K]
>         I/O ports at ef00 [size=128]
>         Capabilities: <access denied>
>         Kernel driver in use: firewire_ohci
> 
> * output of lspci
> 00:00.0 Host bridge: Intel Corporation 82946GZ/PL/GL Memory Controller Hub (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82946GZ/PL/GL PCI Express Root Port (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82946GZ/GL Integrated Graphics Controller (rev 02)
> 00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller (rev 01)
> 00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 (rev 01)
> 00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 (rev 01)
> 00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 (rev 01)
> 00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 (rev 01)
> 00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
> 00:1f.2 IDE interface: Intel Corporation NM10/ICH7 Family SATA Controller [IDE mode] (rev 01)
> 00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 01)
> 02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev 46)
> 02:08.0 Ethernet controller: Intel Corporation NM10/ICH7 Family LAN Controller (rev 01)

Of these devices, the VIA controller is of course involved (and this
model, the VIA VT6306, is a very common one, and there are no known
unhandled issues related to VT6306 and SBP-2 usage), and one of the PCI
bridges.  I don't know whether there are potential issues with these
bridges, but to me your problem looks like it happens on a lot higher
level (i.e. transport protocol and how the buggy PL-3507 firmware handles
it).

> 
> * versions of libraries (libraw1394...), application or utility (if applicable) 
> libraw1394 : v2.1.0
> 

libraw1394 is not involved in accesses to SBP-2/SBP-3 devices.
The software stack basically looks like this:
  firewire-ohci
    firewire-core
      firewire-sbp2
        SCSI core
          sd
            block layer
              userland
-- 
Stefan Richter
-======----- -==- --===
http://arcgraph.de/sr/

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
