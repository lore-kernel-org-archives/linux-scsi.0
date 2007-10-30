From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: slow after upgrade to CentOS 5 (RHEL5)
Date: Mon, 29 Oct 2007 21:36:11 -0500
Message-ID: <1193711771.3383.150.camel@localhost.localdomain>
References: <471FEB81.80103@verizon.net>
	 <1193502827.3281.9.camel@localhost.localdomain>
	 <47239DAD.4020005@verizon.net>
	 <1193581594.3333.4.camel@localhost.localdomain>
	 <47252B18.6060504@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44981 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752486AbXJ3CgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 22:36:21 -0400
In-Reply-To: <47252B18.6060504@verizon.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Ewell <amewell@verizon.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Please don't drop the cc lists.  There are others who probably have more
informed opinions than I do who won't get to comment if they don't see
it.

On Sun, 2007-10-28 at 17:36 -0700, Anthony Ewell wrote:
> James Bottomley wrote:
> > On Sat, 2007-10-27 at 13:21 -0700, Anthony Ewell wrote:
> >> James Bottomley wrote:
> >>> On Wed, 2007-10-24 at 18:04 -0700, Anthony Ewell wrote:
> >>>> Hi All,
> >>>>
> >>>>     If you all would not mind a post from the general
> >>>> public Linux user, after doing a complete disk wipe
> >>>> of CentOS 4 and installing CentOS5, my system is preceived
> >>>> to be 3 times slower.
> >>>>
> >>>>      To troubleshooting this, I made a post on CentOS's
> >>>> bugzilla:  http://bugs.centos.org/view.php?id=2382
> >>>>
> >>>>      Would some of the experts on this group mind
> >>>> looking at the bug to evaluate the possibility
> >>>> that it is being caused by the underlying scsi
> >>>> driver?   The post contains a dmesg from "Computer C".
> >>>> (Yes, I am getting a bit desperate.)
> >>> There's still too little information in the bug report to tell much of
> >>> anything.  The dmesg doesn't indicate any anomaly with the megaraid
> >>> (although the LSI people might be able to tell better).  However, it
> >>> also doesn't contain a trace of the tape drive.
> >>>
> >>> Best guess would be a slow down in the megaraid driver.  Can you try
> >>> doing a speed test on it?  (hdparm -t should suffice).
> >>>
> >>> James
> >>
> >> Hi James,
> >>
> >> The other guy reporting the problem
> >>  
> >> http://www.centos.org/modules/newbb/viewtopic.php?topic_id=10659&start=0#forumpost34209
> >> is not using a MegaRAID card.  He is using 3ware9508 Raid Controllers.
> >> He is also using a different processor (amd vs xeon) and a different
> >> chipset (Intel Greenwood vs nVidia)
> >>
> >> I also spoke to Neela Kolli (Mega RAID maintainer) and he said he'd
> >> never heard of the problem.  Here are some tests (including dhparm)
> >> that I sent to Neela (he never wrote back).
> >>
> >> I have also checked with Stellen over at the "dump"
> >> list and he has not seen the problem (yet).
> >>
> >> The problem occurs when backing up to a two different types
> >> of tape drives and to an eSata drive.
> >>
> >> When I am running a "dump" on computer C, gnome-system-monitor
> >> shows my two cores running at only about 10 to 20% and
> >> switching back and forth (one at 0% the other at 20% for
> >> about 5 seconds, then switching positions)
> >>
> >> On Computer C (Cent OS 5), when typing in Word Pro (a windows word 
> >> processor) in Parallels, I can watch myself type.  Computer B
> >> (CentOS 4.4, now 4.5) has the same version of Parallels
> >> installed on it (Parallels-2.2.2112-lin.i386) that computer C
> >> (CentOS 5) has. The perceived speed difference is about a factor
> >> of three (you can not watch yourself type).
> >>
> >> All the "Low Level" test I run seem to come out the same between
> >> Cent OS 4.4 and 5.  Very frustrating!  It is almost like some
> >> system monitor component is looking at everything and
> >> slowing things down.  If this was Windows, I'd go straight
> >> to the Anti Virus as the culprit.  (Does SE Linux do such
> >> things?)
> >>
> >> Are there any performance tests I can run for you?
> >>
> >> Thank you for letting me ramble, this problem is
> >> really frustrating.  I am afraid to any additional CentOS5
> >> server out there and CentOS 4.x is so terribly out of
> >> date.
> >>
> >> -T
> >>
> >> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> Tests I sent to Neela:
> >>
> >> CentOS 5 (2.6.18-8.1.8.el5, Sata150-4):
> >>
> >> #grep -i bogomips /var/log/dmesg
> >> Calibrating delay using timer specific routine.. 4001.91 BogoMIPS 
> >> (lpj=2000959)
> >> Calibrating delay using timer specific routine.. 3999.58 BogoMIPS 
> >> (lpj=1999791)
> >> Total of 2 processors activated (8001.50 BogoMIPS).
> >>
> >>
> >> #/sbin/hdparm -t /dev/sda
> >> /dev/sda:
> >>   Timing buffered disk reads:  236 MB in  3.01 seconds =  78.53 MB/sec
> >>
> >>
> >> #/sbin/hdparm -t /dev/sdb
> >> /dev/sdb:
> >>   Timing buffered disk reads:  182 MB in  3.01 seconds =  60.37 MB/sec
> >>
> >>
> >> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> CentOS 4.4 (linux rescue 2.6.9-42.EL, IDE):
> >>
> >> #cat /proc/cpuinfo
> >> bogomips	: 4002.92
> >>
> >> #/sbin/hdparm -t /dev/sda
> >> /dev/sda:
> >>   Timing buffered disk reads:  216 MB in  3.01 seconds =  71.87 MB/sec
> >>
> >> #/sbin/hdparm -t /dev/sdb
> >> /dev/sdb:
> >>   Timing buffered disk reads:  184 MB in  3.01 seconds =  61.18 MB/sec
> > 
> > That pretty much shows, if anything, that transfer speed improved
> > from .9 to .18.
> > 
> >> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> CentOS 5 (2.6.18-8.1.3.el5, Sata300-4):
> >> #grep -i bogomips /var/log/dmesg
> >> Calibrating delay using timer specific routine.. 4001.92 BogoMIPS 
> >> (lpj=2000960)
> >> Calibrating delay using timer specific routine.. 3999.58 BogoMIPS 
> >> (lpj=1999794)
> >> Total of 2 processors activated (8001.50 BogoMIPS).
> >>
> >> #/sbin/hdparm -t /dev/sda
> >> /dev/sda:
> >>   Timing buffered disk reads:  214 MB in  3.02 seconds =  70.86 MB/sec
> >>
> >>
> >> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> CentOS 5  (2.6.18-10.1.3.el5, Sata300-4):
> >>
> >> eSata:  dump -0a -z -f /dev/nul winxp.hdd
> >>    DUMP: Volume 1 took 0:04:04
> >>    DUMP: Volume 1 transfer rate: 4247 kB/s
> >>    DUMP: Volume 1 1567020kB uncompressed, 1036385kB compressed, 1.513:1
> >>
> >> eSata:  dump -0a -f /dev/nul winxp.hdd  (no compression)
> >>    DUMP: Volume 1 1036420 blocks (1012.13MB)
> >>    DUMP: Volume 1 took 0:02:09
> >>    DUMP: Volume 1 transfer rate: 8034 kB/s
> >>
> >>
> >> 150-4:  dump -0a -z -f /dev/nul winxp.hdd
> >>    DUMP: Volume 1 took 0:04:05
> >>    DUMP: Volume 1 transfer rate: 4230 kB/s
> >>    DUMP: Volume 1 1573150kB uncompressed, 1036383kB compressed, 1.518:1
> >>
> >> 150-4:  dump -0a -f /dev/nul winxp.hdd  (no compression)
> >>    DUMP: Volume 1 1036420 blocks (1012.13MB)
> >>    DUMP: Volume 1 took 0:02:05
> >>    DUMP: Volume 1 transfer rate: 8291 kB/s
> > 
> > I think this is beginning to point to problems with dump.  What are the
> > corresponding figures for dump under 2.6.9 (or are the two sets of
> > figures centos5 followed by centos4)?
> > 
> > James
> > 
> 
> Computer C:
> backup drive: eSATA
> hard drive: RAID SATA-150-4
> 
> CentOS 4.4, 1:05 hours, approx 52 GB backup file 13,333 kBytes/sec
> CentOS 5.0, 3:16 hours, approx 43 GB backup file 3,656 kBytes/sec
> Note: 3.6 times slower
> 
> Hi James,
> 
>      The above shows the dump speed difference between CentOS 4.4 and
> CentOS 5.
> 
>      I suspected dump at first, until I noticed everything else
> was about 3 times slower too, such as Parallels, etc.  Open
> Office 2.3 (linux version) opens about 3 times slower.
> 
>      Are there any tests you know of to shake out who is
> slowing the works down?

Yes, could you do backup write tests without dump in the process (as in
just do a straight dd from /dev/zero to the devices in centos 4 and 5).
If there's no difference in that, it's some scheduling or filesystem
issue with dump, I'd expect.

>      When I get a chance, I am going to run a dump from my
> CentOS 5 install DVD in rescue mode (linux rescue).  This
> to make sure no high level driver is slowing things
> down.  I will let you know what shows up.

James


