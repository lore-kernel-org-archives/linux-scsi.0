From: Mogens Valentin <monz@danbbs.dk>
Subject: SCSI vs SATA considerations
Date: Fri, 07 May 2004 13:56:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409B7983.A3031C21@danbbs.dk>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:23953 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S263564AbUEGLy2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 07:54:28 -0400
Received: from danbbs.dk (0xc2ef15a4.bynxx4.adsl-dhcp.tele.dk [194.239.21.164])
	by pfepc.post.tele.dk (Postfix) with ESMTP id 683BA262857
	for <linux-scsi@vger.kernel.org>; Fri,  7 May 2004 13:54:27 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi <linux-scsi@vger.kernel.org>

I'm in the middle of some implementation decisions.
I've been used to scsi, and now have had some experience with sata.

I was never able to fully utilize scsi due do insufficient cpu/FSB
speeds.
A 29160 with Atlas 10K3 on a FSB 112, 550MHz cpu, hdparm -t gets me
27MB/s.

On a new DDR400, 2200MHz cpu, system, using 29160 with an IBM DDYS disk,
I get 37MB/s. For reasons I don't understand, the DDYS won't negotiate
at 80MB/s, will only do 40MB/s.
The problem here is that I simply don't know what performance I can
expect from the Atlas 10K3, if I move it to this new system.

After resolving the system lockup problem using Seagate 7200.7 160GB
sata with Sil3121a and nForce2 Ultra400, hdparm -t gets me 54-55MB/s.

(For those interested, it's not a Seagate problem, but an nForce2 APIC
problem, which can be solved with 
http://www.kernel.org/pub/linux/kernel/people/bart/2.6.0-test11-bart1/broken-out/nforce2-disconnect-quirk.patch
. The patch doesn't apply cleanly to 2.6.5, so I added it manually to
fixes.c . I can make a diff if needed..)


I'd prefer using both scsi and sata, for reasons of both performance and
for having experience with both technologies.

The system will be used with vmware, using Linux as the host system.
If I go for the combined scsi/sata solution, I expect using scsi for the
host OS, vmware layer and the virtual client systems: XP, W2K, two more
Linux distros, and use sata for storage, i.e. /home and what else..

Using vmware, I can expect some swapping going on, though I have 1GB
ram.

Therefore, using two disks, it makes sense setting up swap on both disks
with PRI= for raid-like swapping. However, I fail to foresee how this is
expected to perform with two different disk subsystems with different
characteristics and speeds, especially as I don't know how well the
Atlas disk will perform on the new, faster system.

Alternatively, I could go for using two Seagate sata disks, and no scsi.

Anyone care to shed a light on the swap issues?
I'd also like a comment on the IBM DDYS negotiating at only 40MB/s.

-- 
Kind regards,
Mogens Valentin
Networking, Security
www.danbbs.dk/~monz
Phone +45 32 525 878
