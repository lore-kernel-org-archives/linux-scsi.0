From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [BUG] The kernel thread for md RAID1 could cause a md RAID1 array
 deadlock
Date: Tue, 15 Jan 2008 12:10:07 +0900
Message-ID: <478C240F.8070004@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org


This message describes the details about md-RAID1 issue found by
testing the md RAID1 using the SCSI fault injection framework.

Abstract:
Both the error handler for md RAID1 and write access request to the md RAID1
use raid1d kernel thread. The nr_pending flag could cause a race condition
in raid1d, results in a raid1d deadlock.

Details:
         error handling                            write operation
   ------------------------------------------------------------------------------
    A-1. Issue a read request

    A-2  SCSI error detected
                                               B-1. make_request() for raid1 starts.
    A-3. raid1_end_read_request() is called
         in the interrupt context. It detects
         read error and wakes up raid1d
         kernel thread.                        B-2. make_request() calls wait_barrier() to
                                                    increment nr_pending flag.
    A-4. raid1d wake up

    A-5. raid1d calls freeze_array() and waiting
         for nr_pending to be decremented.
         That means stop IO and wait for       B-3. make_request() wakes up raid1d kernel thread
         everything to go quite.                    to send write request to the lower layer.

                                               B-4. raid1d wake up (already waken up by A-3)

                   (****  process stalls here because A-5 never ends ****)

    A-6. raid1d calls fix_read_error() to
         handle read error.                    B-5. raid1d calls generic_make_request() for write request.

                                               B-6. raid1_end_write_request() is called in the
                                                    interrupt context when the write access is completed
                                                    and nr_pending flag is decremented.
The deadlock mechanism:
If raid1d waken up by detecting read error (A-4) goes into freeze_array()
right after make_request() for write request has incremented nr_pending flag(B-2),
raid1d stalls waiting for nr_pending flag to be decremented (A-5).
On the other hand, nr_pending flag incremented by make_request() for write request
will never be decremented because the flag can be decremented after raid1d issues
generic_make_request() (B-5, B-6) but now raid1d is stopped.

This problem could could easily be reproduced with by using the new fault injection framework,
using "no response from the SCSI device" simulation.
However, it could also occur if raid1 error handler contends with write
operation,  but with low probability.

I will report the other problems after I clean up and post the code for
the scsi fault injection framework.

-- 
------------------------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com


