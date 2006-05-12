From: Kumba <kumba@gentoo.org>
Subject: qla1280: failing mbox check
Date: Fri, 12 May 2006 00:06:34 -0400
Message-ID: <446409CA.2090100@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.200.81]:51627 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1750895AbWELEG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 00:06:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Trying to get 2.6.17-rc3 up and running on my SGI Octane, I've hit an odd quirk, 
and I'm looking for some clarification on whether the bug may potentially lie in 
the SCSI layer, or possibly more in the mips core someplace.

Booting 2.6.17, the QLogic 1040 chip is detected, but upon sending the mbox 
command, it timeouts and fails, reporting this message:

scsi(0): mailbox timed out, mailbox0 4000, ictrl 0006, istatus 0004
qla1280: Failed mbox check
scsi(0): mailbox timed out, mailbox0 4000, ictrl 0006, istatus 0004

The last line will then repeat indefinitely.


Now I know between 2.6.16 and 2.6.17-rc3, a lot of changes occured across a 
number of archs to consolidate some of the bitops functions into the generic 
section of the tree, I'm not sure if this is one possible area of breakage or 
not.  I tried turning all the debug options for qla1280, but didn't get any 
additional output that was meaningful.  Are there other ways to debug this?  I 
stuck a printk to see what the returned values of mb[] are, and got nothing but 
0x0, so I can only assume something bad is happening to them someplace.

Any ideas where to start looking or things to try?  2.6.16.* works flawlessly, 
and I didn't see anything odd done to qla1280.c itself that could be the point 
of breakage.  So I can only assume that the error is in a higher-level somewheres.



--Kumba

-- 
Gentoo/MIPS Team Lead
Gentoo Foundation Board of Trustees

"Such is oft the course of deeds that move the wheels of the world: small hands 
do them because they must, while the eyes of the great are elsewhere."  --Elrond
