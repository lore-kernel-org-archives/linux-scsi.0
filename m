From: Nathan Hunsperger <linux-scsi@hunsperger.com>
Subject: Are QLA2000's doomed under 2.4?
Date: Sun, 8 Jun 2003 21:20:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609042014.GH4373@munchnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-66-120-172-74.dsl.sntc01.pacbell.net ([66.120.172.74]:62407
	"EHLO server-linux.munchnet.com") by vger.kernel.org with ESMTP
	id S264143AbTFIEEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 00:04:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been trying to get a QLA2000 (ISP2100) up and running under 2.4.20
for a while now.  While I've been able to make it work, I can't make the
system stable.

When I use the drivers in the kernel, the system locks up within 1
minute of applying a heavy load.  When I use QLogic's driver, I get a
very nice "this should not happen" error message and a frozen system
within 15 minutes of heavy load.

With Feral's driver, the system never freezes, but I'm having problems
on the FC loop.  After about an hour of heavy load, anything using disks
on the FC loop freezes, and syslog gives the following (where ... is
many more instances of above message):

May 27 22:12:25 delta kernel: isp0: Interrupting Mailbox Command (0x15) Timeout
May 27 22:12:25 delta kernel: isp0: Mailbox Command 'ABORT' failed (TIMEOUT)
May 27 22:12:30 delta kernel: isp0: Interrupting Mailbox Command (0x15) Timeout
May 27 22:12:30 delta kernel: isp0: Mailbox Command 'ABORT' failed (TIMEOUT)
...
May 27 22:21:30 delta kernel: isp0: Interrupting Mailbox Command (0x17) Timeout
May 27 22:21:30 delta kernel: isp0: Mailbox Command 'ABORT TARGET' failed (TIMEOUT) 
May 27 22:21:35 delta kernel: isp0: Interrupting Mailbox Command (0x17) Timeout
May 27 22:21:35 delta kernel: isp0: Mailbox Command 'ABORT TARGET' failed (TIMEOUT)
...
May 27 22:22:40 delta kernel: isp0: Interrupting Mailbox Command (0x18) Timeout
May 27 22:22:40 delta kernel: isp0: Mailbox Command 'BUS RESET' failed (TIMEOUT)
May 27 22:22:50 delta kernel: isp0: Interrupting Mailbox Command (0x18) Timeout
May 27 22:22:50 delta kernel: isp0: Mailbox Command 'BUS RESET' failed (TIMEOUT)...
May 27 22:40:46 delta kernel: isp0: Board Type 2100, Chip Revision 0x3, loaded F/W Revision 1.19.20
May 27 22:40:46 delta kernel: isp0: Loop ID 7, AL_PA 0xda, Port ID 0xda, Loop State 0x2, Topology 'Private Loop'

Other times, I get similar results, but with COMMAND_ERROR messages
instead.  Always, the card eventually is reset, and all processes
continue normally.

I've been able to trace the final resets to the SCSI layer finally
calling the eh_host_reset_handler function (isplinux_hreset).

Originally, I was thinking that I had a hardware problem, but I have
swapped everything except the disk chassis and disks.  Also, during a 45
minute session of 'BUS RESET' failed, I power-cycled the disk chassis,
unplugged the FC cable, etc, all to no avail.  If something other than
the QLA2000 card itself was causing the reset to fail, I would have
expected one of those two actions to allow the reset to occur.

Does anybody have any ideas on what is going on?  Is the QLA2000 simply
destined to never work?  I've heard of many getting the QLA2100 (same
chipset) to work without a hitch.  So, in short, I'm a tad lost trying
to get this card up and working, and any suggestions would be very much
appreciated.

- Nathan

Some additional info:
I have 14 disks on the loop, all as part of a software raid 5 array,
with lvm on top of that, and an ext3 fs on that.  I am able to cause
these symptoms during parity resync, as well as when doing things like
10 parallel untars of 5GB each.  The system is SMP, though I have also
tried this with non-SMP kernels.  Under FreeBSD and Solaris, I have no
issues, although I get 1/2 the throughput.
