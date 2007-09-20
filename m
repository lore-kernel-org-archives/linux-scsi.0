From: stefan@mdy.univie.ac.at (Stefan Boresch)
Subject: aic79xx problems
Date: Thu, 20 Sep 2007 15:04:40 +0200
Message-ID: <20070920130440.GE1606@loop.mdy.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from helix.mdy.univie.ac.at ([131.130.40.7]:43747 "EHLO
	epsilon.mdy.univie.ac.at" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756294AbXITNZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 09:25:28 -0400
Received: from loop.mdy.univie.ac.at (loop.mdy.univie.ac.at [131.130.40.12])
	by server1.mdy.univie.ac.at (Postfix) with ESMTP id 7D12716C2B4
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 15:00:30 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am trying to set up a server with an onboard Super Micro AIC 7902B
U320 controller under the latest Ubuntu version(s), i.e., using the
respective Ubuntu supplied kernels (2.6.20 based for "feisty" and 2.6.22 based
for "gutsy"). However, so far all kernels
based on 2.6.x, x greater or equal to 20 hang/crash when inserting the
aic79xx module. Earlier kernels from various distributions,
e.g. 2.6.15 (ubuntu dapper), 2.6.18 (opensuse 10.2), 2.6.18 (debian
unstable install kernel) work, but the discs are only running at a
fraction of the theoretical performance (see below).

I fully understand that it's not the job of the developers to take
care of users of the various distributions, but I guess if there are
experts to be found who have "been there, done this", then this is the
place to ask. I am perfectly happy to try to boot the machine with a
standard, self-compiled Linux 2.6.2x kernel, but would appreciate
hints as to what version plus which patches (if any) to use.

So, if anyone is willing to take a look, here are some facts (again,
please let me know whatever other info you need!). I have put the output of
lspci, dmesg and cat /proc/scsi/aic79xx/0 of the system running a
default Ubuntu dapper installation (2.6.15 based kernel) on
 
http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.lspci.output
http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.dmesg.output
http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.proc_aic79xx.output

respectively.

Hardware:

* Supermicro H8DAR-8 motherboard with two dual-core Opterons
* Two Seagate Cheetahs (ST373207LC) attached to the onboard Super
  Micro (Adaptec) AIC 7902B U320 controller
* There is also a LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT
  Dual Ultra320 SCSI (rev 08) controller, to which an external RAID is
  connected. This part of the system seems to be working flawlessly!!

The problem(s):

With the kernels 2.6.x (x < 20) I have tried so far the system boots,
but there are many warnings during the boot when loading the aic79xx
controller and the result to me seems nowhere near the speed which the
disks should be capable of.

E.g., for the first SCSI disk from /proc/scsi/aic79xx/0

Target 0 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
	Goal: 40.000MB/s transfers (40.000MHz)
	Curr: 40.000MB/s transfers (40.000MHz)
	Channel A Target 0 Lun 0 Settings
		Commands Queued 3039
		Commands Active 0
		Command Openings 32
		Max Tagged Openings 32
		Device Queue Frozen Count 0

The User: entries correspond to what is set in the SCSI BIOS (Adaptec,
version 4.30), and which, according to the vendor of the box
(transtec) is correct.

I could live with all this if kernels 2.6.2x I have tried would not
simply crash.  When the aic79xx module loads, I get again endless

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<

listings, but the warnings / error messages get more and more severe
until the system hangs.

At this point I am really unexperienced and have no clue how I could
capture these pages of messages. Again, I am happy to dig in but don't
quite know where to start.

According to Seagate Tools the disks themselves are fine.

I can easily dig out all the source from which the various Ubuntu kernels
are compiled; in fact, i have stared at them, and my feeling is that
this may be less an issue with the low level driver itself (which claims to
be version 3.0 in all cases) but with the
surrounding SCSI subsystem ...

Many thanks in advance,

Stefan

-- 
Stefan Boresch
Institute for Computational Biological Chemistry
University of Vienna, Waehringerstr. 17       A-1090 Vienna, Austria
Phone: -43-1-427752715                        Fax:   -43-1-427752790
