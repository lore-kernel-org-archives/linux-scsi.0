From: Abhishek Rai <abba@cs.sunysb.edu>
Subject: [2.4.25], [aic79xx-2.0.8] problems with aic79xx on 2.4 (fwd)
Date: Thu, 1 Apr 2004 18:41:47 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.53.0404011838350.19252@compserv1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:31123 "EHLO sbcs.cs.sunysb.edu")
	by vger.kernel.org with ESMTP id S263168AbUDAXoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2004 18:44:07 -0500
Received: from compserv1 (compserv1 [130.245.1.44])
	by sbcs.cs.sunysb.edu (8.12.3/8.12.3) with ESMTP id i31Nfk2X019404
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2004 18:41:46 -0500 (EST)
Content-ID: <Pine.LNX.4.44.0404011811192.17243@filer.fsl.cs.sunysb.edu>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I have an Adaptec 29320A Ultra320 SCSI host bus adapter with which I
connect to a SCSI array of 9 disks, each of which is capable of 320MBps.
Initially, in the BIOS settings, I configure each disk to operate at
160MBps. aic79xx-2.0.8 driver for 2.4 works just fine on 2.4.25 with this
setting. I am able to create a raid device on top of this 9-disk array,
and everything works fine.

Now, I configure each disk in the BIOS settings to operate at 320MBps. I
now start having trouble beginning with aic79xx module insertion itself.

1. modprobe aic79xx.o (version 2.0.8 dated 3/16/2004, latest from justin's
page) gives some warnings/errors (a couple of "overrun detected")
2. sometimes upon insertion, aic79xx.o is able to configure all of the 9
disks while at other times, it misses out on one of them (I couldn't
repeat it for long enough to make sure if it misses out on more than one
or is it just that disk, as this happened only once).
3. After this, I can see all the 9 disks in /proc/scsi/scsi and I try to
build raid on top of this array (mkraid -R /dev/md0). This eventually
causes the kernel to crash with a NULL pointer dereference. But before
that a lot of stuff happens. The Internet url to my log file is at the
bottom of this email. The log file shows the trace following insmod of
aic79xx (2.0.8, dated 3/16/2004), and later shows what all happens when a
mkraid is started.

4. In addition, during this mkraid, there are no LEDs glowing on any of
the 9 disks (as happens in the OK case, when the disks operate at 160MBps)
while the driver times out again and again (as the following log shows)
and the proc/mdstat keeps showing an increasingly long time until
completion.


The log files are at:

http://www.fsl.cs.sunysb.edu/~abba/scsi-raid-1.txt
(this instance ended with a kernel NULL pointer dereference within 2
minutes, couldn't ksymoops it)

http://www.fsl.cs.sunysb.edu/~abba/scsi-raid-2.txt
(this instance ran with errors and without any actual disk activity (no
LEDs glowing) for around 90 minutes before I terminated it).


Abhishek

