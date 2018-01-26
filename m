From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Mishandling SCSI status CONDITION MET
Date: Fri, 26 Jan 2018 12:13:34 -0500
Message-ID: <41de5da2-da88-36c8-2768-ffb5207de565@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48533 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751540AbeAZRNj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jan 2018 12:13:39 -0500
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>

Summary: CONDITION MET is a GOOD status but the mid-level logs it as if
it were an error.

If you scan recent SPC and SBC drafts you will find only two commands that
yield the SCSI status CONDITION MET: PRE-FETCH(10) and PRE_FETCH(16).
Those commands are like READ but don't return the data instead they try
to cache it. And those commands have an IMMED bit. The idea is the
PRE-FETCH will start putting the identified LBA and the following given
number of blocks into the cache. The assumption is a following READ will
be able to fetch that data faster (from the cache rather than flash
or magnetic media).

The definition of PRE-FETCH has two situations it tries to report:
   1) the specified data will fit in the cache: report a status
      of CONDITION MET
   2) the specified data will not fit in the cache: report a status
      of GOOD

Yes, I wrote that correctly: CONDITION MET is better the GOOD!

So what happens with a current kernel (lk 4.15.0-rc9) if you send lots
of PRE-FETCH(10) commands to a disk (or a simulated one) with a big
cache (so lots of CONDITION METs)? A mess:

kernel: scsi_io_completion: 140 callbacks suppressed
kernel: sd 0:0:0:0: [sg0] tag#21 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK
kernel: sd 0:0:0:0: [sg0] tag#21 CDB: Prefetch/Read Position 34 02 00 11 22 33 
05 00 03 00
kernel: sd 0:0:0:0: [sg0] tag#21 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK
kernel: sd 0:0:0:0: [sg0] tag#21 CDB: Prefetch/Read Position 34 02 00 11 22 37 
05 00 03 00
...


Additionally there seems to be a bug (or resource problem) with that
suppression code. When I sent 1 million PRE-FETCH(10)s it should have
taken less than a minute, extrapolating from the result with smaller
numbers. I killed the job after 15 minutes.

Doug Gilbert
