From: Jeff Garzik <jeff@garzik.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 10:26:32 -0400
Message-ID: <45F56318.9030505@garzik.org>
References: <45F48809.2060908@emc.com>	<20070312000253.20eab1a3@lxorguk.ukuu.org.uk>	<45F4A268.3000405@garzik.org> <20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
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

Strict ATA command set answer:  you will have no idea what goes on under 
the hood.  The current 512-b interface stays /exactly/ the same, save 
for a word or two in IDENTIFY DEVICE telling you the "secret" physical 
sector size.  If all your I/Os are aligned properly, then you need not 
worry about RMW cycles, as they will not occur.

Intuition answer:  they will use their firmware-internal standard code 
for scheduling reads and writes, and will only reallocate sectors as 
needed by media failure or similar events.

The "M" part of the modify cycle happens in disk ram.  So from the 
disk's point of view, a single 512-b write would require reading a 
single 1K hard sector, updating the contents in cache RAM, and then 
writing a single 1K hard sector.  The reading of the unknown half of the 
sector can be scheduled well in advance, usually, since writeback 
caching gives the drive plenty of time (relatively speaking) to optimize 
things.

Overall, it definitely adds a few more points of failure, but we can't 
do much at all about those points of failure.

In my own experiments on my own Fedora workstation, ~66% of IOs in Linux 
start on an odd sector, and ~33% started on even-numbered sectors.  For 
a 1K-sector drive with 'odd' alignment, the configuration Microsoft will 
likely want, that means the majority of disk transactions will avoid a 
RMW cycle, but a still-numerous minority will not.  I did not test 
transfer length, to see how many transfers /ended/ on an odd sector, 
thus determining how many RMW cycles the tail of an average I/O requires.



>> A future configuration will change the logical ATA interface away from 
>> 512-byte sectors to 1K or 4K.  Here, it is impossible to read a quantity 
>> smaller than 1K or 4K, whatever the sector size is.
> 
> That one I'm not worried about - other than "guess how Redmond decide to
> make partition tables work" that one is mostly easy (be fun to see how
> many controllers simply can't cope with the command formats)

Indeed...

	Jeff



