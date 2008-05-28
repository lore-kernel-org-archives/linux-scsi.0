From: Maarten Vanraes <maarten@ba.be>
Subject: Re: megaraid_sata vs megasr
Date: Wed, 28 May 2008 18:31:25 +0200
Message-ID: <200805281831.26066.maarten@ba.be>
References: <0631C836DBF79F42B5A60C8C8D4E8229010EF1F5@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from powered.by.e-leven.be ([88.82.32.98]:37301 "EHLO
	queen.hive.selfip.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYE1QlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 12:41:22 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229010EF1F5@NAMAIL2.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

Op Wednesday 28 May 2008 17:44:50 schreef Moore, Eric:
> On Wednesday, May 28, 2008 8:18 AM, Maarten Vanraes wrote:
> > So in effect, you are telling me that we bought fakeraid
> > cards... since this
> > is the "recommended driver"? is the card a hardware raid? or software.
> >
> > We had specifically asked for hardware raid... :-(
>
> I worked on megaraid team some five years ago, now I work on mpt fusion.
> I can't tell you what the recommended megaraid cards, as they have
> changed since then from U320.   The mpt fusion cards come with Raid
> levels 0, 1, and 1 enhanced, which is implemented in hardware/firmware.
>
>
> You could try looking here:
> http://www.lsi.com/storage_home/products_home/internal_raid/index.html

i think it's this one: 
http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_sas/megaraid_sas_8208elp/index.html

in any case: LSI support site directs me to the megasr driver for my card. But 
there is something wrong in either case:

on machine 2: i did an rsync from machine A array 2 to machine B array 2 (SATA 
disks of 1T in raid 1): speed is around 20MB/s probably due to load on 
machine A, or whatever (machine B has nothing running whatsoever.)

hdparm -tT /dev/sdb shows between 50 and 80MB/s

the moment i do an scp or rsync from something else, the first rsync drops 
immediately to around 5MB/s, while the second doesn't do more than 5MB/s 
(often one would show around 2MB/s.)

at that time, the iowait (dual quad core) is above 90% ...

Since both identical machines behave in the same matter, i believe there is 
something seriously wrong with the megasr driver in the first place, and 
tried to get support, but they request me to supply a serial number of the 
card. (Both machines are already running in a colocation room).

I had to patch it to work with 2.6.21, i'm wondering if i did anything stupid 
in the patch. can you check that maybe? (it's a small patch)

on the other hand, if there is an driver that works well, but just needs a 
little work, i'll be happy to test this out.

I'm just not a kernel devel, and don't really know how to solve this.

the problem is just that i want to be helped one way or another.

IF in your opinion the cards are not the best solution and i would have to 
upgrade it, i can do that; but i suspect the megasr driver.

am i wrong in my thinking?

Sincerely,

Maarten
