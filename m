From: Steven Dake <sdake@mvista.com>
Subject: New model for managing dev_t's for partitionable block devices
Date: Tue, 28 Jan 2003 10:09:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E36B946.2050308@mvista.com>
References: <3E2DC21D.9010204@torque.net>	 <20030123183131.GA2126@nbkurt.garloff.de>	 <20030123221805.A2468@infradead.org>	 <20030124182952.GF20972@ca-server1.us.oracle.com>	 <20030127225125.A13617@infradead.org> <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Joel Becker <Joel.Becker@oracle.com>, Kurt Garloff <kurt@garloff.de>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-kernel@kernel.vger.org

I was thinking of an entirely new model for partitionable block devices. 
 Here is how it would work:

Each physical disk would be assigned a minor number in a group of 
majors.  So assume a major was chosen of 150, 151, 152, 153, there would 
be a total of 1024 physical disks that could be mapped.  Then the device 
mapper code could be used to provide partition devices in another 
major/group of majors.

The advantage of this technique is that instead of wasting tons of 
minors on partitions that are never used, partitions could be 
dynamically allocated out of the minor list, allowing for thousands of 
disks with varying numbers of partitions each.  Further instead of each 
block device (such as i2o, scsi, etc) having their own set of majors for 
each partitionable disk (which wastes dev_t address space) everything 
would be compressed into the same set of majors.

As an example, Lets assume we want 4096 total disks with 16384 total 
partitions (4 partitions per disk, where it is likely to be less):

That is:
4096 disks / 256 disks * 1 major = 16 majors
16384 partitions / 256 partitions * 1 major = 64 majors
total of 80 majors

To allow a similiar configuration in the current block device setup, 
with just the SCSI disk major,
4096 disks / 16 disks * 1 major = 256 majors

Now, assume we have 4096 disks available for i2o, scsi, compaq raid, etc 
etc, we are talking about lots of majors that go way beyond the current 
addressable 16 bytes.

The only downside is addressing the disks in hotswap (ie: how do you 
know what disk is where?)  This can be achieved through per-subsystem 
devfs mapping (ie: linking /dev/scsi/hostX/... to /dev/disc0) or 
userspace utilities that scan the disk devices (such as those that would 
be in /dev/disk) and determine which disks are what.

Thanks
-steve

Alan Cox wrote:

>On Mon, 2003-01-27 at 22:51, Christoph Hellwig wrote:
>  
>
>>Currently it's compiled in, and the trivial change to make it use
>>register_blkdev with a 0 major argument until all globally unused majors
>>are gone is left to the reader..
>>    
>>
>
>Which leaves the non trivial change of figuring out a usable security
>model when doing that. I've yet to see one
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

