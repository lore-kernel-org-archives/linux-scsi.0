From: "Raz Ben-Yehuda" <razb@bitband.com>
Subject: RE: Intel X25-M MLC SSD benchmarks
Date: Thu, 11 Dec 2008 00:12:37 +0200
Message-ID: <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
References: <20081210213937.GC25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20081210213937.GC25548@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 
-----Original Message-----
From: linux-ide-owner@vger.kernel.org
[mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Matthew Wilcox
Sent: Wednesday, December 10, 2008 11:40 PM
To: Raz Ben-Yehuda
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: Intel X25-M MLC SSD benchmarks

On Wed, Dec 10, 2008 at 11:15:12PM +0200, Raz Ben-Yehuda wrote:
> Hello
> I am wondering if anyone tried Intel new disks. I benchmark them and I
> am a bit confused.
> According to the spec a single disk should provide 70MB/s write and
250
> MB/s read. Reads are ok. I am reaching this number, but writes are
bad.
> With writes I am getting 20MB/s.
> I am using a dd for the test, and a deadline-line scheduler. 

What command exactly are you using, and have you tried using the no-op
elevator instead of deadline?  Also, what controller is it hooked up to?
I first thank you for your reply.
I did not want to dive into details because it does not matter. Whether
noop,deadline, deadline parameters...
As for the controller I used 4 different controllers. Adaptec,AHCI and
Intel as Integrated chips on the 1025W-UR supermicro motherboard, and a
4-th controller SuperMicro UIO Adaptec aac card.
All gave same results for most dd writes commands.
dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
other variants such erase block size ( 128K ) , several erase block size
and so on. Kernel is 2.6.18-8.el5.
I used all on a supermicro 1025W-UR. Disks have a SAS interface, 80GB. 
Also, I would like to note, I have 8 disks in array, while each one
perform READS 250 MB/s, together I degrade to 200 MB/s each. As for
writes I always reach 20 MB/s at best, from a single disk or 20x8 in
array.  
A disk in /proc/scsi/scsi identifies like this: 

Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: INTEL SSDSA2MH08 Rev: 045C
  Type:   Direct-Access                    ANSI SCSI revision: 05

And this is how my poor iostat looks:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.13   24.78    0.00   75.09


Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda               0.00         0.00         0.00          0          0
sda              33.00         0.00     11136.00          0      11136
sdb             126.00         0.00     42624.00          0      42624
sdc              87.00         0.00     29568.00          0      29568
sdd             122.00         0.00     41728.00          0      41728
sde             121.00         0.00     41344.00          0      41344
sdf             121.00         0.00     41448.00          0      41448
sdg             109.00         0.00     36736.00          0      36736
sdh              48.00         0.00     49152.00          0      49152

and this is lspci:

00:00.0 Host bridge: Intel Corporation 5400 Chipset Memory Controller
Hub (rev 20)
00:01.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 1
(rev 20)
00:03.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 3
(rev 20)
00:05.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 5
(rev 20)
00:07.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 7
(rev 20)
00:09.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 9
(rev 20)
00:0f.0 System peripheral: Intel Corporation 5400 Chipset QuickData
Technology Device (rev 20)
00:10.0 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.1 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.2 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.3 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.4 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:11.0 Host bridge: Intel Corporation 5400 Chipset CE/SF Registers (rev
20)
00:15.0 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:15.1 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:16.0 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:16.1 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller
(rev 09)
00:1f.2 RAID bus controller: Intel Corporation 631xESB/632xESB SATA RAID
Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
01:00.0 Ethernet controller: Intel Corporation 82598EB 10 Gigabit AT CX4
Network Connection (rev 01)
01:00.1 Ethernet controller: Intel Corporation 82598EB 10 Gigabit AT CX4
Network Connection (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01)
02:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01)
03:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01)
06:00.0 RAID bus controller: Adaptec AAC-RAID (rev 09)
07:00.0 Ethernet controller: Intel Corporation 82598EB 10 Gigabit AT CX4
Network Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation 82598EB 10 Gigabit AT CX4
Network Connection (rev 01)
08:00.0 Ethernet controller: Intel Corporation 82575EB Gigabit Network
Connection (rev 02)
08:00.1 Ethernet controller: Intel Corporation 82575EB Gigabit Network
Connection (rev 02)
09:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)



[



-- 
Matthew Wilcox				Intel Open Source Technology
Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
