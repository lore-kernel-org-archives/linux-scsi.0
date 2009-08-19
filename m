From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Re: Performance issues with Areca 1680 SAS Controllers
Date: Wed, 19 Aug 2009 19:40:29 +0300
Message-ID: <20090819164029.GZ19938@edu.joroinen.fi>
References: <20090819140848.GW19938@edu.joroinen.fi> <200908192247543597389@usish.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:53113 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZHSQk2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2009 12:40:28 -0400
Content-Disposition: inline
In-Reply-To: <200908192247543597389@usish.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wang Jinpu <jack_wang@usish.com>
Cc: Nick Cheng <nick.cheng@areca.com.tw>, 'Andrew Morton' <akpm@linux-foundation.org>, 'Michael Fuckner' <michael@fuckner.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, 'Erich Chen' <erich@areca.com.tw>

On Wed, Aug 19, 2009 at 10:48:00PM +0800, Wang Jinpu wrote:
> 
> 
> 
> 
> 
> 
> ???????? Pasi K?rkk?inen 
> ?????????? 2009-08-19  22:34:28 
> ???????? Nick Cheng 
> ?????? 'Andrew Morton'; 'Michael Fuckner'; linux-kernel; linux-scsi; 'Erich Chen' 
> ?????? Re: Performance issues with Areca 1680 SAS Controllers 
>  
> On Thu, Nov 20, 2008 at 03:39:40PM +0800, Nick Cheng wrote:
> > Hi Michael,
> > I will get around handling your issue.
> > Thanks for your kindly patience,
> > 
> Hello,
> Was this issue resolved? I'm seeing similar behaviour.. I think it's related
> to flushing the controller cache?
> Waiting a while (after the disk leds stop blinking) performance is back to
> normal.. 
> -- Pasi
> 
> In my memory ??It's because the write cache is not enable??You can verify
> it using sdparm 

I'm using battery backed write-back write cache on Areca controller, and it's enabled.
Or did you mean caches in each harddisk?

More information about my setup:

- Areca 1680 24-port SAS RAID controller
- Physical disks 1-4 are raid-10 for the OS (boot volume, /dev/sda)
- Physical disks 5-18 are raid-60 for the data (/dev/sdb)

I downloaded ltp-base-20090731.tgz from http://ltp.sf.net and compiled it. 

from testcases/kernel/io/disktest/ I run:

# echo 3 > /proc/sys/vm/drop_caches
# ./disktest -w -K16 -B 4k -T 60 -pr -Ibd -PA /dev/sdb

(sdb is the raid-60 data array).

So the disktest benchmark is running 4 kB random writes using 16 threads and direct-IO
(bypassing kernel caches) for 60 seconds.

The test completes after 60 seconds, just like it should, but the disk leds will
keep blinking for many minutes more.. 

So basicly Areca controller is first caching the random write IOs and then flushing
them from the cache (2 GB) to the disks.. 

The problem is while Areca is doing the flushing _all_ IOs are really slow,
including the other raid-10 array for the OS, which uses totally separate physical disks. 

Opening another shell in screen takes at least 30 seconds, starting "top"
takes forever etc.. 

While Areca is flushing the caches (and all the IOs are slow), "iostat 1"
doesn't show any "leftover" IOs from the benchmark. So the benchmark was
really using direct IO, bypassing kernel caches.

I tried with different io-schedulers (cfq,deadline,noop) but they didn't
have big effect.. which makes sense, since the OS/kernel is not doing any
big IO when the 'stalling' happens.

Is there some way to make Areca NOT use all cpu-power for cache flushing? 

OS is CentOS 5.3 x86_64 with linux-2.6.18-128 kernel.

-- Pasi

> 2009-08-19 
> 
> 
> 
> Wang Jinpu 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > Sent: Thursday, November 20, 2008 9:18 AM
> > To: Michael Fuckner
> > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick Cheng;
> > Erich Chen
> > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> > 
> > (cc's added)
> > 
> > On Wed, 19 Nov 2008 13:16:56 +0100
> > Michael Fuckner <michael@fuckner.net> wrote:
> > 
> > > Hi,
> > > 
> > > I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate 1TB
> > > ST31000640SS). I set up a Raid6 with all 16 disks and formatted it with
> > > XFS. The Controller has 512MB RAM and a BBU. The OS is installed to
> > > another disk attached to the onboard AHCI controller.
> > > 
> > > After doing some IO, the areca raidset is slower compared to the rate 
> > > directly
> > > after boot.
> > > 
> > > 
> > > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> > iflag=direct
> > > 51200+0 records in
> > > 51200+0 records out
> > > 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> > > [root@storage ~]# mount /dev/sdb1 /data
> > > [root@storage ~]# cd /data/
> > > [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
> > > -o  >raid6_sync_t8.log
> > > [root@storage data]# cd
> > > [root@storage ~]# umount /data/
> > > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> > iflag=direct
> > > 51200+0 records in
> > > 51200+0 records out
> > > 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> > > 
> > > I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
> > > Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.
> > > 
> > > Idea why the device slows down after IO- or better: how to keep the high
> > > rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and
> > 12XX)
> > > 
> > > Regards,
> > >    Michael!
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> __________ Information from ESET NOD32 Antivirus, version of virus signature database 4347 (20090819) __________
> The message was checked by ESET NOD32 Antivirus.
> http://www.eset.com
