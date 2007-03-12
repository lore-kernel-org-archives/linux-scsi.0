From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 04:27:55 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703120423360.4339@yvahk01.tjqt.qr>
References: <45F48809.2060908@emc.com> <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
 <45F4BEC4.5090402@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45F4BEC4.5090402@emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Mar 11 2007 22:45, Ric Wheeler wrote:
> Jan Engelhardt wrote:
>> On Mar 11 2007 18:51, Ric Wheeler wrote:
>> 
>> > During the recent IO/FS workshop, we spoke briefly about the
>> > coming change to a 4k sector size for disks on linux. If I
>> > recall correctly, the general feeling was that the impact was
>> > not significant since we already do most file system IO in 4k
>> > page sizes and should be fine as long as we partition drives
>> > correctly and avoid non-4k aligned partitions.
>> > 
>> 
>> Sorry about jumping right in, but what about an 'old-style'
>> partition table that relies on 512 as a unit?
>> 
>> 
> I think that the normal case would involve new drives which
> would need to be partitioned in 4k aligned partitions.
> Shouldn't that work regardless of the unit used in the
> partition table?

Assume this partition table on my current HD:

	Disk /dev/hdc: 251.0 GB, 251000193024 bytes
	255 heads, 63 sectors/track, 30515 cylinders
	Units = cylinders of 16065 * 512 = 8225280 bytes
	
	   Device Start  End      Blocks   Id  System
	/dev/hdc1   1     33      265041   82  Linux swap / Solaris
	/dev/hdc2  34  30515   244846665    5  Extended

That is, 255 * 63 * 30515 * 512 == roughly 251 GB.

Now, if this disk was copied byte per byte (/bin/dd) to a
4096-based disk, and Linux would start using a sector size of
4096, then I would suddenly have

255 * 63 * 30515 * 4096 == 2 TB

Although I would not mind the 2 TB, the partition table would
read quite differently (note the Blocks column which is
multiplied by 4 (512x4=4096))

           Device Start  End      Blocks   Id  System
        /dev/hdc1   1     33     1060164   82  Linux swap / Solaris
        /dev/hdc2  34  30515   979386660    5  Extended

Which would mean that the swap partition reaches into the real
data partition and would corrupt it.

That's what I am concerned about.


Jan
-- 
