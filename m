From: ard <ard@kwaak.net>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Tue, 7 Aug 2018 18:04:52 +0200
Message-ID: <20180807160452.GE23827@kwaak.net>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
 <20180806132234.GA23827@kwaak.net>
 <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
 <20180806142414.GB23827@kwaak.net>
 <20180807065400.nxpndw4kf6jdd55i@linux-x5ow.site>
 <20180807092619.GC23827@kwaak.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807092619.GC23827@kwaak.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, Aug 07, 2018 at 11:26:19AM +0200, ard wrote:
> So a conclusion of my rambling:
> 1) you either need 6 vn2vn hosts *or* you need more than one 4.14
> kernel in a network to trigger. One of the two. I need to think
> about this. The fact that the 4.14 systems can't see eachother is
> an indicator.  I can turn off the FCoE on some other system to
> see if the memleak stops.

I've gone all out:

Ok, deleted everything, long story short:
(for now(!))

PC+steam machine with 4.14 (patched) and 4.16 (upstream,
nodebug): no kmemleaks
Every device sees every device.

Now if I add two odroids running 4.14 (not patched):
The odroids will see *every* device running < 4.14 and vv
The odroids will not see any device running >= 4.14 and vv
The PC starts to kmemleak a lot.

I've removed the two 4.14 odroids again from the FCoE lan, and
upgraded them with a patched 4.14 .
I rebooted the PC with steam (4.16 upstream unpatched) and all
other systems in the lan I mentioned.
To be clear: the steam machine has a dedicated nic for FCoE. All
other systems use a vlan.
I will let that talk with eachother for now.

I fear there is a platform specific thing in the vn2vn chatter
that has changed > 4.9 .
4.14 can communicate with lower revisions, but they can't see
eachother, and whatever they chat about, it induces memory leaks
on the PC.
Oh, another difference is that steam and the PC has targets
assigned. I might try that for the 4.14 too.

Anyway, I will do some cooking and let the current systems chat
with eachother and see if we get a kmemleak making my statement
bogus.

Regards,
Ard

-- 
.signature not found
