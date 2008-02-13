From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [BUGREPORT] The kernel thread for md RAID10 could cause a md RAID10
 array deadlock
Date: Wed, 13 Feb 2008 17:33:44 +0900
Message-ID: <47B2AB68.1040604@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This message describes another issue about md-RAID10 found by
testing the 2.6.24 md RAID10 using new scsi fault injection framework.

Abstract:
When a scsi command timeout occurs during RAID10 recovery, the kernel
threads for md RAID10 could cause a md RAID10 array deadlock.
The nr_pending flag set during normal I/O and barrier flag set by recovery
thread conflicts, results in raid10d() and sync_request() deadlock.

Details:
             normal I/O                             recovery I/O
   -----------------------------------------------------------------------------
                                           B-1. kernel thread starts by calling
   A-1. A process issues a read request.         md_do_sync()
        make_request() for raid10 is called
        by block layer.
                                           B-2. md_do_sync() calls sync_request
                                                operation for md raid10.
   A-2. In make_request(), wait_barrier()
        increments nr_pending flag.

   A-3. A read command is issued to the disk,
        but it takes a lot of time because
        of no response from the disk.
                                           B-3. sync_request() of raid10 calls
                                                raise_barrier(), increments barrier
                                                flag, and waits for nr_pending set
                                                in (A-2) to be cleared.
   A-4. raid10_end_read_request() is called
        in the interrupt context. It detects
        read error and wakes up raid10d kernel
        thread.

   A-5. raid10d() calls freeze_array() and waits
        for barrier flag incremented in (B-3)
        to be cleared.

    (**  stalls here because waiting conditions in A-5 and B-3 are never met **)


   A-6. raid1d calls fix_read_error() to
        handle read error.                 B-4. barrier flag will be cleared after
                                                the pending barrier request completes.
   A-7  nr_pending flag will be cleared after
        the pending read request completes.

The deadlock mechanism:
When a normal I/O occurs during recovery, nr_pending flag incremented in (A-2)
blocks subsequent recovery I/O until the normal I/O completes. The recovery thread
will increment barrier flag and wait for nr_pending flag to be decremented (B-3).

Normally, nr_pending flag is decremented after the I/O has completed successfully.
Also, barrier flag is decremented after barrier request (such as recovery I/O) has
completed successfully.

If a normal read I/O results in scsi command timeout, the read request is handled
by error handler in raid10d kernel thread. Then, raid10d calls freeze_array().
But the barrier flag is set by (B-3), freeze_array() waits for barrier request
completion. On the other hand, the recovery thread stalls waiting for nr_pending
flag to  be decremented(B-3). In this way, both error handler and recovery
thread are deadlocked.

This problem can be reproduced  by using the new scsi fault injection framework,
using "no response from the SCSI device" simulation.
I think the new scsi fault injection framework is a little bit complicated
to use, so I will upload some sample wrapper shell scripts for usability.

-- 

---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com
