From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: LSISAS1068E + WDC WD2002FYPS: I/O error & Sense Key
Date: Mon, 3 Aug 2009 01:08:53 -0400
Message-ID: <20090803050853.GA26430@lifeintegrity.com>
References: <20090727060322.GB27002@lifeintegrity.com> <4A70A64A.2070605@gmail.com> <20090729200714.GA20706@lifeintegrity.com> <4A70D57B.6030301@gmail.com> <20090731184023.GT3211@lifeintegrity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-173-48-39-13.bstnma.fios.verizon.net ([173.48.39.13]:43257
	"EHLO lifeintegrity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZHCFIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 01:08:54 -0400
Content-Disposition: inline
In-Reply-To: <20090731184023.GT3211@lifeintegrity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On 2009-07-31T14:40:23, Allan Wind wrote:
> On 2009-07-29T17:04:27, Robert Hancock wrote:
> > On 07/29/2009 02:07 PM, Allan Wind wrote:
> >> On 2009-07-29T13:43:06, Robert Hancock wrote:
> >>> On 07/27/2009 12:03 AM, Allan Wind wrote:
> >>>> I have a pair of Western Digital RE4-GP (WD2002FYPS) in RAID1 configuration
> >>>> using Linux 2.6.30.3 and seeing the following:
> >>>>
> >>>> [ 4907.485324] end_request: I/O error, dev sdb, sector 3907028974
> >>> Are there no error messages before this point? Can you post the full
> >>> dmesg output from bootup?
> >>
> >> Thanks for looking into this, Robert.  I do not see any relevant error
> >> message before this point, but made the entire 82k dmesg available here:
> >> http://lifeintegrity.com/~allan/dmesg
> >
> > It seems like some request failed but apparently that mptsas driver  
> > isn't dumping out what happened for some reason. There are some of those  
> > "recovered error" indications but they're not near the I/O error report,  
> > so I'm not sure what's going on. CCing linux-scsi.
> 
> Is there any data I can help with to advance this issue?

The above complains about sector 3907028974 which is exactly 
19566 sectors greater than the size of the raid array according 
to parted.  In other words it appears to be an access to the last 
sector of the array.


Number  Start   End          Size         File system  Name  
Flags
 1      34s     19565s       19532s                          
bios_grub
 2      19566s  3907029134s  3907009569s  ext3               raid


Model: ATA WDC WD2002FYPS-0 (scsi)
Disk /dev/sdb: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End          Size         File system  Name  
Flags
 1      34s     19565s       19532s                          
bios_grub
 2      19566s  3907029134s  3907009569s  ext3               raid


Model: Unknown (unknown)
Disk /dev/md0: 3907009408s
Sector size (logical/physical): 512B/512B
Partition Table: loop

Number  Start  End          Size         File system  Flags
 1      0s     3907009407s  3907009408s  ext3


# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Tue Jul 21 00:06:07 2009
     Raid Level : raid1
     Array Size : 1953504704 (1863.01 GiB 2000.39 GB)
  Used Dev Size : 1953504704 (1863.01 GiB 2000.39 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Aug  3 00:59:07 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : fdc1a639:0e6cf1a1:14ef9d30:0388f34d
         Events : 0.59706

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2

Disabled NCQ did not work around this issue.

 
/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>

