From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors
 cap")
Date: Tue, 30 Dec 2014 11:19:07 -0500
Message-ID: <54A2D07B.4040607@interlog.com>
References: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1412301017060.30572-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>
Cc: "Kenneth R. Crudup" <kenny@panix.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On 14-12-30 10:34 AM, Alan Stern wrote:
> On Tue, 30 Dec 2014, Christoph Hellwig wrote:
>
>>> The only limits usb-storage imposes on max_sectors are those needed to
>>> work around bugs in the devices' USB bridges.  (Okay, there's also
>>> something for tape drive devices, but it probably doesn't belong in
>>> usb-storage -- it should be handled by the SCSI tape driver.)
>>>
>>> If the ATA layer needs to set a limit on max_sectors, why doesn't it
>>> simply go ahead and do so?
>>
>> Because the ATA layer doesn't control the device, the bridge does.
>> And it seems like it doesn't communicate the maximum transfer size
>> properly.
>
> _Is_ there any way to communicate the maximum transfer size?  I'm not
> aware of any SCSI command for it.  It isn't part of the USB
> mass-storage spec.

In SCSI, the VPD page 0xb0 (Block limits) has a "Maximum transfer
length" field (32 bits long). Its units are logical blocks. Useful
if >0 as 0 means "unreported".

USB to SATA bridges should comply with SAT. However SAT and SAT-2
don't even mention that VPD page. SAT-3 and SAT-4 mention that page
but have "unspecified" next to that field. Basically useless.


IMO about the best SATL is in the MPT SAS-2 and SAS-3 HBAs and
here is that page for a SAS expander attached SATA disk:

# sg_vpd -p bl /dev/sg3
Block limits VPD page (SBC):
   Write same non-zero (WSNZ): 0
   Maximum compare and write length: 0 blocks
   Optimal transfer length granularity: 0 blocks
   Maximum transfer length: 0 blocks
   Optimal transfer length: 0 blocks
   Maximum prefetch length: 0 blocks
   Maximum unmap LBA count: 0
   Maximum unmap block descriptor count: 0
   Optimal unmap granularity: 0
   Unmap granularity alignment valid: 0
   Unmap granularity alignment: 0
   Maximum write same length: 0x0 blocks
   Maximum atomic transfer length: 0
   Atomic alignment: 0
   Atomic transfer length granularity: 0
   Maximum atomic transfer length with atomic boundary: 0
   Maximum atomic boundary size: 0

Not sure why LSI/Avago even bothered even implementing
that page ...

Doug Gilbert


BTW here is the output of that page from a SAS SSD:

# sg_vpd -p bl /dev/sg5
Block limits VPD page (SBC):
   Write same non-zero (WSNZ): 0
   Maximum compare and write length: 0 blocks
   Optimal transfer length granularity: 8 blocks
   Maximum transfer length: 65535 blocks
   Optimal transfer length: 0 blocks
   Maximum prefetch length: 0 blocks
   Maximum unmap LBA count: 393216
   Maximum unmap block descriptor count: 512
   Optimal unmap granularity: 8
   Unmap granularity alignment valid: 0
   Unmap granularity alignment: 0
   Maximum write same length: 0x0 blocks
   Maximum atomic transfer length: 0
   Atomic alignment: 0
   Atomic transfer length granularity: 0
   Maximum atomic transfer length with atomic boundary: 0
   Maximum atomic boundary size: 0




