From: "Jones, David G" <david.g.jones@lmco.com>
Subject: SCSI timeouts with sym-2 driver
Date: Fri, 15 Sep 2006 13:36:37 -0400
Message-ID: <824B13109773064F92372DAB2F3B3C9D0EFB1F02@emss35m05.us.lmco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw3a.lmco.com ([192.35.35.7]:35010 "EHLO mailgw3a.lmco.com")
	by vger.kernel.org with ESMTP id S1750821AbWIORho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 13:37:44 -0400
Received: from emss04g01.ems.lmco.com (relay4.ems.lmco.com [166.17.13.122])by mailgw3a.lmco.com  (LM-6) with ESMTP id k8FHbgWO012909for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 13:37:43 -0400 (EDT)
Received: from CONVERSION-DAEMON.lmco.com by lmco.com (PMDF V6.3-x3 #31239)
 id <0J5N00601A96RZ@lmco.com> for linux-scsi@vger.kernel.org; Fri, 15 Sep 2006 13:36:42 -0400 (EDT)
Received: from EMSS04I00.us.lmco.com ([166.17.13.135]) by lmco.com (PMDF V6.3-x3 #31239)
 with ESMTP id <0J5N002RRA8PZG@lmco.com> for linux-scsi@vger.kernel.org; Fri, 15 Sep 2006 13:36:32 -0400 (EDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to debug a SCSI problem on an embedded system with a MPC8540
CPU and LSI53C1010-66 controller. The system is running a 2.4.25 kernel
and sym-2.1.19-pre3 driver. A Seagate 300 GB drive is attached to one
channel of the controller and an Adtron SDDS-01A1 PC Card reader is
attached to the other channel.

Everything works fine until I try to use the hard drive and PC card at
the same time. Then I get SCSI timeouts for the PC card reader and
eventually I/O errors for the PCCard devices. Continously copying a file
from the PCCard reader to the hard drive results in these messages in
the kernel log :

sym0:0:0: queue depth is now 135
sym0:0:0: queue depth is now 136
sym0:0:0: queue depth is now 137
Command timed out active=4 busy=4 failed=1
Command timed out chan=0 target=0 lun=1
Command timed out active=4 busy=4 failed=2
Command timed out chan=0 target=0 lun=0
Command timed out active=4 busy=4 failed=3
Command timed out chan=0 target=0 lun=1
Command timed out active=4 busy=4 failed=4
Command timed out chan=0 target=0 lun=0
sym1:0:0: ABORT operation started.
sym1:0:0: ABORT operation timed-out.
sym1:0:0: ABORT operation started.
sym1:0:0: ABORT operation timed-out.
sym1:0:1: ABORT operation started.
sym1:0:1: ABORT operation timed-out.
sym1:0:1: ABORT operation started.
sym1:0:1: ABORT operation timed-out.
sym1:0:0: DEVICE RESET operation started.
sym1:0:0: DEVICE RESET operation timed-out.
sym1:0:1: DEVICE RESET operation started.
sym1:0:1: DEVICE RESET operation timed-out.
sym1:0:0: BUS RESET operation started.
sym1: SCSI BUS reset detected.
sym1: enabling clock multiplier
sym1: Downloading SCSI SCRIPTS.
sym1: SCSI BUS has been reset.
sym1: command processing suspended for 3 seconds
sym1:0:0: BUS RESET operation complete.
sym1: command processing resumed
sym1:0:sync msgout: 1-3-1-29-f.
sym1:0:sync msgin: 1-3-1-29-f.
sym1:0:sdtr: ofs=15 per=41 div=5 fak=1 chg=0.
sym1:0:sync msgout: 1-3-1-29-f.
sym1:0:sync msgin: 1-3-1-29-f.
sym1:0:sdtr: ofs=15 per=41 div=5 fak=1 chg=0.
sym1:0:sync msgout: 1-3-1-29-f.
sym1:0:sync msgin: 1-3-1-29-f.
sym1:0:sdtr: ofs=15 per=41 div=5 fak=1 chg=0.
 UNIT_ATTENTION ?
This architecture does not implement dump_stack()
 I/O error: dev 08:21, sector 1099392
SCSI disk has been changed. Prohibiting further I/O.
from scsi_request_fn
 I/O error: dev 08:21, sector 1099896


I/O errors never occur for the hard drive, just the PC Card reader
device. Also copying files to /dev/null on the PCCard reader and hard
drive simultaneously results in about 2-3 MB/s on the hard drive, verus
50-60 MB/s with just the hard drive alone.

Has anyone seen a similar problem ? What's the best stratgey to debug
this kind of problem ? Thanks !



