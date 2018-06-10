From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sd 6:0:0:0: [sdb] Unaligned partial completion (resid=12,
 sector_sz=512)
Date: Sat, 9 Jun 2018 20:10:25 -0400
Message-ID: <071361b8-96c0-17cd-d1d7-61ea6357eb83@interlog.com>
References: <c35dacb574365736229ff04d587abc0390ef7b78.camel@scientia.net>
 <f96c1329-929b-44a1-4c3a-74dbcedbbafe@infradead.org>
 <2cbab96cfb722ef8ad8f9fe6f5060226108cf033.camel@scientia.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2cbab96cfb722ef8ad8f9fe6f5060226108cf033.camel@scientia.net>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-06-09 07:50 PM, Christoph Anton Mitterer wrote:
> Thanks for CCing me to the right list.
> 
> Some further info:
> 
> I had two disks attached via the following USB/SATA bridge (twice the
> same, which in turn is connected via a USB3.0 hub):
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: new SuperSpeed USB device number 23 using xhci_hcd
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: New USB device found, idVendor=174c, idProduct=55aa
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: Product: ASMT1053
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: Manufacturer: asmedia
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: SerialNumber: 123456789012
> Jun 09 23:16:11 heisenberg kernel: usb 2-2.2: Device is not authorized for usage
> Jun 09 23:16:15 heisenberg kernel: usb-storage 2-2.2:1.0: USB Mass Storage device detected
> Jun 09 23:16:15 heisenberg kernel: usb-storage 2-2.2:1.0: Quirks match for vid 174c pid 55aa: 400000
> Jun 09 23:16:15 heisenberg kernel: scsi host7: usb-storage 2-2.2:1.0
> Jun 09 23:16:15 heisenberg kernel: usb 2-2.2: authorized to connect
> Jun 09 23:16:16 heisenberg kernel: scsi 7:0:0:0: Direct-Access     ASMT     2105             0    PQ: 0 ANSI: 6
> Jun 09 23:16:16 heisenberg kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
> Jun 09 23:16:16 heisenberg kernel: sd 7:0:0:0: [sdc] Spinning up disk...
> Jun 09 23:16:25 heisenberg kernel: ........ready
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] 4096-byte physical blocks
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] Write Protect is off
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] Mode Sense: 43 00 00 00
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Jun 09 23:16:25 heisenberg kernel:  sdc: sdc1 sdc2
> Jun 09 23:16:25 heisenberg kernel: sd 7:0:0:0: [sdc] Attached SCSI disk
> 
> 
> The errors only occurred on one of the two disks... but few times when
> I swapped the USB/SATA bridges between the two disks, because I wanted
> to see whether it's the bridge which is faulty.
> Since it happened with USB/SATA bridges swapped, I thought it couldn't
> be that, but rather the HDD.
> I tried again with the USB3.0 hub removed (and the bridges directly
> connected to USB3.0 ports of the notebook)... and the errors still
> appeared (on the same disk).
> 
> 
> Then, they suddenly went away, and despite quite some swapping around
> of bridges, cables, etc. ... it hasn't appeared again (though I stopped
> copying for today some 2 hours ago).
> 
> Another interesting fact: While I was copying in the first place, where
> the error occurred quite frequently,... the data must have been read
> correctly.
> The fs is btrfs (so there is checksumming) and in addition I have my
> own SHA512 sums, attached as XATTRs to the files, and for those that
> were already copied, they verified correctly.
> 
> 
> So my naive assumption would be that either I have some pretty new but
> somehow weirdly failing HDD, which sometimes shows these errors and
> sometimes not (yet, so far, giving the correct data)... or...
> there were some (also strange) connectivity issues (maybe something
> with the cables?) and when I swapped things around these got finally
> "resolved".
> 
> 
> So in addition to the basic question: What would the "Unaligned partial
> completion" mean, I wonder: Would any errors on the USB level (or
> below) show up as the block device level errors that I've seen?
> And what could explain that I still got the right data out? Retries
> that succeed? ECC?
> 
> Or should I rather backup ASAP and throw the device with the error
> messages away, too?

Hmmm, probably yes. But before you throw it away, try running 'smartctl -a'
(or 'smartctl -x') on it and record the output. Also try 'smartctl -t short'
(a short self-test) on it and then re-run '-a' to see what the self-test log
says. The disk should keep logs of the number of unrecovered read errors
(and recovered ones as well).

If the disk is only one year old, perhaps it might be covered by a warranty
from the manufacturer.

Doug Gilbert


> On Sat, 2018-06-09 at 15:21 -0700, Randy Dunlap wrote:
>> [adding linux-scsi mailing list]
>>
>>
>> On 06/09/2018 12:23 PM, Christoph Anton Mitterer wrote:
>>> Hey.
>>>
>>> I'm seeing these errors:
>>> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned
>>> partial completion (resid=16, sector_sz=512)
>>> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED
>>> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense
>>> Key : Medium Error [current]
>>> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add.
>>> Sense: Unrecovered read error
>>> Jun 09 21:13:22 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB:
>>> Read(16) 88 00 00 00 00 01 cd e6 de 40 00 00 00 e0 00 00
>>> Jun 09 21:13:22 heisenberg kernel: print_req_error: critical medium
>>> error, dev sdb, sector 7749426752
>>> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned
>>> partial completion (resid=12, sector_sz=512)
>>> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED
>>> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense
>>> Key : Medium Error [current]
>>> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add.
>>> Sense: Unrecovered read error
>>> Jun 09 21:13:31 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB:
>>> Read(16) 88 00 00 00 00 00 00 14 59 60 00 00 01 00 00 00
>>> Jun 09 21:13:31 heisenberg kernel: print_req_error: critical medium
>>> error, dev sdb, sector 1333600
>>> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] Unaligned
>>> partial completion (resid=12, sector_sz=512)
>>> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 FAILED
>>> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Sense
>>> Key : Medium Error [current]
>>> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 Add.
>>> Sense: Unrecovered read error
>>> Jun 09 21:13:53 heisenberg kernel: sd 6:0:0:0: [sdb] tag#0 CDB:
>>> Read(16) 88 00 00 00 00 00 c3 a2 56 80 00 00 01 00 00 00
>>> Jun 09 21:13:53 heisenberg kernel: print_req_error: critical medium
>>> error, dev sdb, sector 3282196096
>>>
>>> (many of them) on a Seagate 8TB Archive HDD.
>>> The disk is only a year old and barely used (since it's just one of
>>> the
>>> backups of my main data disks - and the primary disk another
>>> Seagate
>>> 8TB HDD broke just few days ago).
>>>
>>> I have connected them via USB/SATA bridge... and when I now started
>>> copying from the backup (which is sdb) to a fresh HDD I started
>>> seeing
>>> vast numbers of these errors.
>>>
>>> However, fsck, cp seem to do fine, and the data (as far as it has
>>> been
>>> copied) seems good (I have sha512 sums of all of it).
>>>
>>>
>>> Any ideas what "Unaligned partial completion" and these errors
>>> mean?
>>>
>>>
>>> Thanks,
>>> Chris.
>>>
>>
>>
> 
