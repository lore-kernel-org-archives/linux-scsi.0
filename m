From: Ricky Beam <jfbeam@bluetronic.net>
Subject: RE: qla2xxx (2100) vs. qlogicfc [again]
Date: Mon, 10 May 2004 21:43:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405102054400.14297-100000@sweetums.bluetronic.net>
References: <B179AE41C1147041AA1121F44614F0B0DD0145@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:60570 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S263000AbUEKBsB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 21:48:01 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD0145@AVEXCH02.qlogic.org>
Content-ID: <Pine.GSO.4.33.0405102054402.14297@sweetums.bluetronic.net>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Mon, 10 May 2004, Andrew Vasquez wrote:
>Ok, well there aren't too many folks using an QLA2100 in a fabric
>topology

And technically, neither was I :-) (TL-port mode)

I've switched to Fabric mode for the HBA facing ports (TL for the
shelves or WWN zoning won't work... hard drives will not login to the
fabric :-()  AND, I removed the p.o.s. gadzoox hubs -- they try to be
too smart and don't bring ports into the loop correctly. (Plus, they
are, in fact, slow. Directly to the switch, I'm moving ~90+MB/s to
that 7 year old qla2100... addressing 14 drives in 2 sw raid 5 arrays.)

[http://sweetums.bluetronic.net/~jfbeam/private/san/webgui.jpg]

(Note: that's with the qlogicfc driver.  qla2100 locks up.)

BIOS: 1.37 (fw) 1.15.37

That version does not have fabric support, but I don't boot from it. So,
that's not a problem.

>since it seems the driver is never receiving a LOOP_UP event from the
>firmware indicating that we have successfully negotiated with the
>fabric and may begin discovery.

I'm thinking this is 100% "translated loop" related.  The switch is logging
devices in (see above w.r.t. drives.)  Disclaimer: I'm not even going to
pretend I understand what TL mode is doing.

At this point, the thing does come up and see the devices in it's zone
with the HBA port in "Fabric" mode.  But now I'm back to the same problems
from a month or so back... qla2100 fails immediately under load.

See also: [http://sweetums.bluetronic.net/~jfbeam/private/san/debug/]
  qlogic_20040510.log
  qlogicfc_20040510.log

The first is several invocations of qla2100... skip to the bottom to see
the problem:
	May 10 20:48:49 master kernel: cmd_timeout: Found in ISP
	...
md10 and md20 are started.  I then fire up zcav (from
bonnie++) to read test the array.  md10 first, and then a bit later, md20.
The instant I hit enter on the md20 test (two zcav's running), a timeout
shows up and then the game is over.

The second log is the kernel log from boot to (basically) right now using
qlogicfc (compiled without optimization and "-g" ... so I could debug it.)
That's where the traffic in webgui.jpg is coming from.

--Ricky

BTW...
  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME CPU COMMAND
 4128 root      15   0     0    0     0 SW   12.9  0.0   4:11   0 md20_raid5
 3154 root      15   0     0    0     0 SW   12.3  0.0   4:21   1 md10_raid5
(single P4 Xeon 2.8GHz w/HT)


