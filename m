From: Douglas Gilbert <dougg@torque.net>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 11:21:36 -0400
Message-ID: <45F57000.8030604@torque.net>
References: <45F48809.2060908@emc.com>	<20070312000253.20eab1a3@lxorguk.ukuu.org.uk>	<45F4A268.3000405@garzik.org> <20070312122424.18ed86ce@lxorguk.ukuu.org.uk> <45F5565E.7010104@emc.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45F5565E.7010104@emc.com>
Sender: linux-ide-owner@vger.kernel.org
To: ric@emc.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
> Alan Cox wrote:
>>> First generation of 1K sector drives will continue to use the same
>>> 512-byte ATA sector size you are familiar with.  A single 512-byte
>>> write will cause the drive to perform a read-modify-write cycle. 
>>> This configuration is physical 1K sector, logical 512b sector.
>>
>> The problem case is "read-modify-screwup"
>>
>> At that point we've trashed the block we were writing (a well studied
>> recovery case), and we've blasted some previously sane, totally
>> unrelated sector of data out of existance. Thats why we need to know
>> ideally if they are doing the write to a different physical block when
>> they do this, so that we don't lose the old data. My guess is they won't
>> as it'll be hard.
> 
> I think that the firmware would have to do this in the drive's write
> cache and would always write the modified data back to the same physical
> sector (unless a media error forces a sector remap).
> 
> If firmware modifies the 7 512 byte sectors that it read to do the 1 512
> byte sector write, then we certainly would see what you describe happen.
> 
> In general, it would seem to be a bad idea to do allocate a different
> physical sector to underpin this king of read-modify-write since that
> would kill contiguous layout of files, etc.
> 
>>> A future configuration will change the logical ATA interface away
>>> from 512-byte sectors to 1K or 4K.  Here, it is impossible to read a
>>> quantity smaller than 1K or 4K, whatever the sector size is.
>>
>> That one I'm not worried about - other than "guess how Redmond decide to
>> make partition tables work" that one is mostly easy (be fun to see how
>> many controllers simply can't cope with the command formats)
>>
> 
> This will be interesting to find out. I will be sharing a panel with
> some BIOS & MS people, so I will update all on what I hear,

Ric,
Just to add a SCSI perspective, it looks like 4 KB sectored
disks will be almost exclusively ATA devices. It is being
done to improve capacity at the expensive of performance.
[SCSI/FC/SAS disks typically trade off capacity for better
performance.]

Support for disks with smaller logical block size than
physical block size has already been added to SBC-3. The
overview of this document gives a rationale:
www.t10.org/ftp/t10/document.06/06-034r5.pdf

SAT is now a standard and an agenda item for SAT-2 is
to wire ATA8-ACS's large sector size support to the
additions to SBC-3 mentioned above.


I'm not sure how this stuff plays with end to end data
protection :-)
Most SCSI disks currently allow formatting sizes of 512
up to 528 bytes per logical block.

Doug Gilbert



