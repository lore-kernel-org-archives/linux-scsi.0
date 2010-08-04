From: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 used!
Date: Wed, 04 Aug 2010 19:16:55 +1000
Message-ID: <4C593007.7040708@tuxonice.net>
References: <4C58C528.4000606@tuxonice.net> <4C592BFE.7070701@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C592BFE.7070701@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi.

On 04/08/10 18:59, Stefan Richter wrote:
> (adding Cc: linux-scsi)
>
> Nigel Cunningham wrote:
>> I've just given hibernation a go under 2.6.35, and at first I thought
>> there was some sort of hang in freezing processes. The computer sat
>> there for aaaaaages, apparently doing nothing. Switched from TuxOnIce to
>> swsusp to see if it was specific to my code but no - the problem was
>> there too. I used the nifty new kdb support to get a backtrace, which was:
>>
>> get_swap_page_of_type
>> discard_swap_cluster
>> blk_dev_issue_discard
>> wait_for_completion
>>
>> Adding a printk in discard swap cluster gives the following:
>>
>> [   46.758330] Discarding 256 pages from bdev 800003 beginning at page 640377.
>> [   47.003363] Discarding 256 pages from bdev 800003 beginning at page 640633.
>> [   47.246514] Discarding 256 pages from bdev 800003 beginning at page 640889.
>>
>> ...
>>
>> [  221.877465] Discarding 256 pages from bdev 800003 beginning at page 826745.
>> [  222.121284] Discarding 256 pages from bdev 800003 beginning at page 827001.
>> [  222.365908] Discarding 256 pages from bdev 800003 beginning at page 827257.
>> [  222.610311] Discarding 256 pages from bdev 800003 beginning at page 827513.
>>
>> So allocating 4GB of swap on my SSD now takes 176 seconds instead of
>> virtually no time at all. (This code is completely unchanged from 2.6.34).
>>
>> I have a couple of questions:
>>
>> 1) As far as I can see, there haven't been any changes in mm/swapfile.c
>> that would cause this slowdown, so something in the block layer has
>> (from my point of view) regressed. Is this a known issue?
>
> Perhaps ATA TRIM is enabled for this SSD in 2.6.35 but not in 2.6.34?
> Or the discard code has been changed to issue many moderately sized ATA
> TRIMs instead of a single huge one, and the former was much more optimal
> for your particular SSD?

Mmmm. Wonder how I tell. Something in dmesg or hdparm -I?

ata3.00: ATA-8: ARSSD56GBP, 1916, max UDMA/133
ata3.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ARSSD56GBP       1916 PQ: 0 ANSI: 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sda: sda1 sda2 sda3 sda4
sd 2:0:0:0: [sda] Attached SCSI disk

/dev/sda:

ATA device, with non-removable media
	Model Number:       ARSSD56GBP
	Serial Number:      DC2210200F1B40015
	Firmware Revision:  1916
Standards:
	Supported: 8 7 6 5
	Likely used: 8
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  500118192
	Logical  Sector size:                   512 bytes
	Physical Sector size:                   512 bytes
	device size with M = 1024*1024:      244198 MBytes
	device size with M = 1000*1000:      256060 MBytes (256 GB)
	cache/buffer size  = unknown
	Nominal Media Rotation Rate: Solid State Device
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 1	Current = 1
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	   *	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Software settings preservation
	   *	Data Set Management determinate TRIM supported
Security:
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct


>> 2) Why are we calling discard_swap_cluster anyway? The swap was unused
>> and we're allocating it. I could understand calling it when freeing
>> swap, but when allocating?
>
> At the moment when the administrator creates swap space, the kernel can
> assume that he has no use anymore for the data that may have existed
> previously at this space.  Hence instruct the SSD's flash translation
> layer to return all these blocks to the list of unused logical blocks
> which do not have to be read and backed up whenever another logical
> block within the same erase block is written to.
>
> However, I am surprised that this is done every time (?) when preparing
> for hibernation.

It's not hibernation per se. The discard code is called from a few 
places in swapfile.c in (afaict from a quick scan) both swap allocation 
and free paths.

Regards,

Nigel
