From: Ric Wheeler <ric@emc.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 09:32:14 -0400
Message-ID: <45F5565E.7010104@emc.com>
References: <45F48809.2060908@emc.com>	<20070312000253.20eab1a3@lxorguk.ukuu.org.uk>	<45F4A268.3000405@garzik.org> <20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
>> First generation of 1K sector drives will continue to use the same 
>> 512-byte ATA sector size you are familiar with.  A single 512-byte write 
>> will cause the drive to perform a read-modify-write cycle.  This 
>> configuration is physical 1K sector, logical 512b sector.
> 
> The problem case is "read-modify-screwup"
> 
> At that point we've trashed the block we were writing (a well studied
> recovery case), and we've blasted some previously sane, totally
> unrelated sector of data out of existance. Thats why we need to know
> ideally if they are doing the write to a different physical block when
> they do this, so that we don't lose the old data. My guess is they won't
> as it'll be hard.

I think that the firmware would have to do this in the drive's write 
cache and would always write the modified data back to the same physical 
sector (unless a media error forces a sector remap).

If firmware modifies the 7 512 byte sectors that it read to do the 1 512 
byte sector write, then we certainly would see what you describe happen.

In general, it would seem to be a bad idea to do allocate a different 
physical sector to underpin this king of read-modify-write since that 
would kill contiguous layout of files, etc.

>> A future configuration will change the logical ATA interface away from 
>> 512-byte sectors to 1K or 4K.  Here, it is impossible to read a quantity 
>> smaller than 1K or 4K, whatever the sector size is.
> 
> That one I'm not worried about - other than "guess how Redmond decide to
> make partition tables work" that one is mostly easy (be fun to see how
> many controllers simply can't cope with the command formats)
> 

This will be interesting to find out. I will be sharing a panel with 
some BIOS & MS people, so I will update all on what I hear,

ric
