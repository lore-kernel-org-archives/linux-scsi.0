From: Steven Dake <sdake@mvista.com>
Subject: Re: New model for managing dev_t's for partitionable block devices
Date: Wed, 29 Jan 2003 09:45:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E380532.2010900@mvista.com>
References: <OFD9CDB238.908E6C3C-ON87256CBD.00070A30-88256CBD.00095D4B@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OFD9CDB238.908E6C3C-ON87256CBD.00070A30-88256CBD.00095D4B@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>, Christoph Hellwig <hch@infradead.org>, Joel Becker <Joel.Becker@oracle.com>, Kurt Garloff <kurt@garloff.de>, linux-kernel@kernel.vger.org, Linux SCSI list <linux-scsi@vger.kernel.org>



Bryan Henderson wrote:

>
>
>  
>
>>the device
>>mapper code could be used to provide partition devices in another
>>major/group of majors.
>>    
>>
>
>If I understand what you're saying, this has been discussed before.  I
>don't know what the device mapper code is, but it's actually quite elegant
>if it is a regular device driver that derives multiple logical disk drives
>from a single physical one in the same way that the md device driver
>derives a single logical disk drive from multiple physical ones.  The
>layering is cleaner that way.
>  
>
this is exactly how lvm works.

>The last time I remember this discussed, it was as a solution to the
>problem of a device driver presuming to access at initialization time a
>partition map that didn't really exist.  I don't remember the details, but
>this particular device wasn't ready to handle data reads until some time
>after initialization.  You ought to be able to initialize a device that you
>plan to use only as a raw device without Linux attempting to make
>partitions on it.
>
>As I recall, there weren't any fundamental objections to this.
>
>  
>
>>partitions could be dynamically allocated out of the minor list
>>    
>>
>
>Doesn't this exacerbate the Linux SCSI drive name binding problem?  It's
>bad enough that when you remove your /dev/sda and reboot, your /dev/sdc
>becomes /dev/sdb.  With this, it sounds like when you delete a partition on
>/dev/sda, your partitions on /dev/sdb change names.
>  
>
This is a problem with hotswap of course, and shouldn't be solved by the 
kernel putting the same device always in the same major/minor.  A 
userspace application should query the OS and build the device nodes 
based upon scsi serial number, FC port WWN, or access path 
(host/channel/id/lun).  The current "MAKEDEV" works fine for people with 
and ide disk and cdrom, but for real systems with lots of disks and 
hotswap capabilities, static naming just doesn't work (as you have 
said).  :)  Devfs solves the naming problem by using access path 
automatically within the OS.  Downside of this methodology is that 
access permissions are not persistent between reboots (which is one 
significant limitation of devfs).  There is a utility called scsidev 
which does the above of building device nodes based upon serial number 
instead of dumb /dev/sda.

>  
>
>>As an example, Lets assume we want 4096 total disks with 16384 total
>>partitions (4 partitions per disk, where it is likely to be less):
>>    
>>
>
>We should keep in mind that as a practical matter, someone with 4096
>physical disks is unlikely to be partitioning at all.  Partitions are for
>the poor person who has only a handful of physical disks and wants to
>divide his data into more pieces than that.  Also note that if you have
>4096 "physical" devices, they probably aren't very physical at all --
>there's some subsystem on the other end of the SCSI link that carves
>variable-size devices out of a pool of storage.  Hence, even less reason
>for Linux to partition them.
>
>
>  
>
I agree using partitions is unlikely with large amounts of disks. 
 Someone should be using LVM to manage those disks if they have a large 
amount.  Unfortunately even though no partitions are needed, 4096 disks 
still require 16 dev_t minors for each device.  This is a significant 
waste of space.  The user could hack their kernel to remove the 
partitions entirely, which someone has already designed a patch to do. 
 This isn't general purpose enough to be useable by the linux user. 
 What is needed is a compromise, described above, limiting the number of 
partitions to some sane amount, but allowing significantly more disks 
for the power user.

Thanks for your comments.
-steve

