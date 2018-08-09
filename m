From: ard <ard@kwaak.net>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Thu, 9 Aug 2018 12:01:30 +0200
Message-ID: <20180809100130.GF23827@kwaak.net>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
 <20180806132234.GA23827@kwaak.net>
 <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
 <20180806142414.GB23827@kwaak.net>
 <20180807065400.nxpndw4kf6jdd55i@linux-x5ow.site>
 <20180807092619.GC23827@kwaak.net>
 <20180807160452.GE23827@kwaak.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807160452.GE23827@kwaak.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Guys,

On Tue, Aug 07, 2018 at 06:04:52PM +0200, ard wrote:
> PC+steam machine with 4.14 (patched) and 4.16 (upstream,
> nodebug): no kmemleaks
> Every device sees every device.

New day, new conflicting results.
Yay \0/.

As I did not trust the results, I redid the tests, and the same
tests gave some different results.
Before giving the results I've changed my stance on the bug:
The bug is not a regression in memory leak. As far as I can tell
now, the memory leaks were already there.
It's a regression in vn2vn enodes being able to PLOGI.
Since I've seen the steam machine and the PC setup an rport,
there must be some racy thing going on how the accept or reject
the PLOGI.
Now once it rejects, it will never succeed to accept, and the
relogin happens ad infinitum.
In this mode there are about 47 kmemleaks per 10 minutes.
I also notice that the kmemleaks takes a while to be detected or
to die out. So there are state timers involved that hold on to
the memory and after time out do not free it.
And another thing I noticed: When the pc and the steam machine
had a working rport, after a while the steam machine (4.16
unpatched) fc_timedout the rports to all nodes (so all nodes with
kernel < 4.14 too), and all with different timeouts, except the
one it has an fc_transport with.
So it's sole remaining rport was the "designated" target.
Currently I am compiling 4.9 with kmemleak to determine if that
exhibits the same leaks when disconnecting and reconnecting the
FCoE vlan.
This to determine if we have a single regression in just the
login handling or both.
I will add the dmesg's of a working rport, and a failing rport
later.

Regards,
Ard

-- 
.signature not found
