From: Douglas Gilbert <dougg@torque.net>
Subject: dismal scsi report in '2.5 - what to expect'
Date: Wed, 16 Apr 2003 10:59:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E9CAB04.5040004@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:19721 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264180AbTDPAqW
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 20:46:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, davej@codemonkey.org.uk

Dave Jones recently sent version 0.33 of his
'2.5 - what to expect' document to the linux kernel list:
http://marc.theaimsgroup.com/?l=linux-kernel&m=105034885830405&w=2

The SCSI report while probably correct lacked any positive
"spin":

 > SCSI.
 > ~~~~~
 > - Various SCSI drivers still need work, and don't even
 >   compile.
 > - Various drivers currently lack error handling.
 >   These drivers will cause warnings during compilation
 >   due to missing abort: & reset: functions.
 > - Note, that some drivers have had these members removed,
 >   but still lack error handling. Those noticed so far are
 >   ncr53c8xxx, sym53c8xx and inia100

The IDE report was arguably as bad though the "IO subsystem"
did fair better.

So what positive can we say about the SCSI subsystem in 2.5
(compared to the 2.4 series)?

Some suggestions:
- large dev_t support allowing thousands of disks to be
   supported (was 128 or 256 in the 2.4 series)
- major code cleanup, initially to support the block layer
   (bio) improvements have led to:
    - better throughput (?) [less double handling of data]
    - per HBA locks (there was a single io_request_lock in
      the 2.4 series)
    - more flexible interface to HBA drivers
    - better hotplug support, especially for USB mass storage
      and ieee1394 sbp2 devices [well it's work_in_progress]
- improved error processing and scanning code (support for
   large, sparse lun spaces)
- lots of scsi driver "innards" (quoting Dave Jones) available
   via sysfs

Comments, additions, deletions?

Doug Gilbert

