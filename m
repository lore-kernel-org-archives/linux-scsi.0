From: Russell Kroll <rkroll@exploits.org>
Subject: PROBLEM: sym53c8xx is broken on HP LH 4 after Linux 2.2
Date: Fri, 07 Nov 2003 19:49:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAC4BB1.mail1NJ11B4U4@exploits.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gearbox.exploits.org ([65.64.162.194]:41958 "EHLO
	gearbox.exploits.org") by vger.kernel.org with ESMTP
	id S261262AbTKHBti (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 20:49:38 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On the HP NetServer LH4, the sym53c8xx driver only works in 2.2 kernels, 
and fails with a "CACHE INCORRECTLY CONFIGURED" error on 2.4 and 2.6.  
This also applies to the sym53c8xx_2 driver.

I searched through the 2.4 and 2.3 series, and finally found that it 
broke after the pre4-1 patch from the 2.3.99 era.  I split that patch up 
into little parts and found the one piece that exposed the problem - it's 
a small pair of changes to pci-i386.c.  Backing that patch out of 2.4.22 
with patch -R makes the sym driver work again.

I've captured lspci dumps before and after the change, along with the 
output from the driver on a stock kernel vs. a kernel that has this patch 
backed out.  There's a lot of it, so I've put it out on my web server 
at this URL:

	http://www.exploits.org/~rkroll/sym/

I am not suggesting that the patch be reverted, since it's obviously a bug 
fix.  My guess is that the fix exposed a problem in the driver.

Some background on the hardware: the LH4 seems to have two 53c895 
interfaces on board.  In 2.2, you can't see the primary interface in 
lspci, perhaps due to the bug that was fixed by the pre4-1 patch.  This is 
generally not a problem, since the NetRAID/MegaRAID typically covers that 
interface.

On 2.4, both interfaces are visible, and the driver can't seem to latch 
onto the second one.  I don't care if the first one doesn't work, since 
I don't intend to talk to the disks that way.  All I need is the second 
one, since that's where my tape drive is connected.

This system happens to be a dual Pentium III, but I've whittled the kernel 
builds down to generic UP/Pentium settings without any positive effect.  I 
even threw out just about everything except what I need to boot at one 
point.  I've tried using "sym53c8xx=excl:0x1400", but it doesn't help.  
It's not something in userspace which causes this, since it still happens 
when I boot with 'init=/bin/sh'.

I intend to run 2.4.22 on this system, but tried 2.6.0-test9 in case the 
problem had been discovered and fixed in that tree.  Unfortunately, it 
also failed.  I haven't tried mangling 2.6's PCI code to duplicate the
effects of backing out that patch yet.

This box is not in production, so I can run tests and try different  
things.  My own attempts at making the driver work were not successful.

I'm stuck.  Any advice or pointers would be appreciated.
