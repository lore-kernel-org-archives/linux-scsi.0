From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 20:15:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308072015.45732.gene.heskett@verizon.net>
References: <200308070422.41412.gene.heskett@verizon.net> <200308071444.55616.gene.heskett@verizon.net> <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out003pub.verizon.net ([206.46.170.103]:18678 "EHLO
	out003.verizon.net") by vger.kernel.org with ESMTP id S271144AbTHHAPs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 20:15:48 -0400
In-Reply-To: <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Thursday 07 August 2003 15:56, Matthew Wilcox wrote:
>On Thu, Aug 07, 2003 at 02:44:55PM -0400, Gene Heskett wrote:
>> 1. For whatever reason, the diffs between the 2.4.22-pre10 version
>> of this driver and the 2.6.0-test2-mm2 versions are extensive,
>> many kilobytes.  Done by who knows, and basicly
>> un-commented/un-documented.
>
>Irrelevant to whether or not check_region is broken.
>
>> 2. Substituting the request_region call, with no other changes,
>> made it work.
>>
>> 3. Adding the release_region calls broke it again, even worse than
>> before.
>
>I don't see how adding release_region can make it "worse than
> before". Look at what __check_region does in kernel/resource.c.
>
>> >Something else is going on here, and someone with one of these
>> > cards needs to debug it properly.
>>
>> I agree.  Its a very good scsi-2 fast (20Mb/sec) card, something
>> thats impossible to find new today.
>
>So you're willing to help debug this properly?  OK.  I'd like you to
>turn on ADVANSYS_DEBUG (around line 828 of the driver).  Then send
> me the debug messages the driver emits during bootup.
>
Well, for starters, I cp'd the -orig file over the one I'd been 
hacking so I had the distro version, then turned on ADVANSYS_DEBUG 
and made it into a module again.

The make failed, with this group of messages:
----
  CC [M]  drivers/scsi/advansys.o
drivers/scsi/advansys.c: In function `advansys_detect':
drivers/scsi/advansys.c:4622: warning: `check_region' is deprecated 
(declared at include/linux/ioport.h:117)
drivers/scsi/advansys.c: In function `advansys_slave_configure':
drivers/scsi/advansys.c:6364: `shp' undeclared (first use in this 
function)
drivers/scsi/advansys.c:6364: (Each undeclared identifier is reported 
only once
drivers/scsi/advansys.c:6364: for each function it appears in.)
drivers/scsi/advansys.c: In function `asc_prt_scsi_host':
drivers/scsi/advansys.c:9356: structure has no member named `next'
drivers/scsi/advansys.c: In function `asc_prt_scsi_cmnd':
drivers/scsi/advansys.c:9400: structure has no member named `host'
drivers/scsi/advansys.c:9400: structure has no member named `target'
drivers/scsi/advansys.c:9400: structure has no member named `lun'
drivers/scsi/advansys.c:9401: structure has no member named `channel'
drivers/scsi/advansys.c: In function `AscSearchIOPortAddr11':
drivers/scsi/advansys.c:10004: warning: `check_region' is deprecated 
(declared at include/linux/ioport.h:117)
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
----
This suggests that the file is contaminated, so I'm gonna unpack the 
archive again and go look at line 6364.  Nope, no change in 'shp'  
I'm doing a remake just in case.

Humm, I'm not sure I'm reading the logic of the debugging tests 
correctly or not, but it looks as if the keyword 'STATIC' which is 
defined as 'static' if debugging is off, but then becomes '' if 
debugging is on.  Does this make anything starting with STATIC 
disappear, or lose its scope?

>For comparison, I'd also like to see them from 2.4.

Let's get this one going in debug mode first...

Note that I didn't re-apply the -mm2 patch to the newly unpacked tree 
yet. For this, I don't think it makes any diff in the outcome.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

