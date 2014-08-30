From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi_debug module deadlock on 3.17-rc2
Date: Sat, 30 Aug 2014 19:14:41 -0400
Message-ID: <54025AE1.9030406@interlog.com>
References: <54023A60.1090208@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050402000607050904020501"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54023A60.1090208@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050402000607050904020501
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14-08-30 04:56 PM, Milan Broz wrote:
> Hi,
>
> I am using scsi_debug in cryptsetup testsuite and with recent 3.17-rc kernel
> it deadlocks on rmmod of scsi_debug module.
>
> For me even this simple reproducer causes deadlock:
>    modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1
>    DEV="/dev/"$(grep -l -e scsi_debug /sys/block/*/device/model | cut -f4 -d /)
>    mkfs -t ext4 $DEV
>    rmmod scsi_debug
>
> (adding small delay before rmmod obviously helps here)

So I used this slight variation for testing:

modprobe scsi_debug dev_size_mb=16 sector_size=512 num_tgts=1 num_parts=1
DEV="/dev/"$(grep -l -e scsi_debug /sys/block/*/device/model | cut -f4 -d /)"1"
echo "mkfs -t ext4 ${DEV}"
mkfs -t ext4 ${DEV}
sleep 0.1
rmmod scsi_debug

> Bisect tracked it to commit
>    commit cbf67842c3d9e7af8ccc031332b79e88d9cca592
>    Author: Douglas Gilbert <dgilbert@interlog.com>
>    Date:   Sat Jul 26 11:55:35 2014 -0400
>    scsi_debug: support scsi-mq, queues and locks
>
> I guess that with introducing mq the del_timer_sync() must not be called
> with acquired queued_arr_lock.
> (to me it looks like situation described in comment before
> del_timer_sync() in kernel/time/timer.c...)

Looks like something a lawyer would write.

> Here is the log (running on vmware VM and i686 arch):
>
> [   67.916472] scsi_debug: host protection
> [   67.916483] scsi host3: scsi_debug, version 1.84 [20140706], dev_size_mb=16, opts=0x0
> [   67.917446] scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0184 PQ: 0 ANSI: 5
> [   67.920539] sd 3:0:0:0: Attached scsi generic sg8 type 0
> [   67.940542] sd 3:0:0:0: [sdh] 32768 512-byte logical blocks: (16.7 MB/16.0 MiB)
> [   67.940548] sd 3:0:0:0: [sdh] 4096-byte physical blocks
> [   67.950705] sd 3:0:0:0: [sdh] Write Protect is off
> [   67.950715] sd 3:0:0:0: [sdh] Mode Sense: 73 00 10 08
> [   67.970514] sd 3:0:0:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   68.040566]  sdh: unknown partition table
> [   68.090618] sd 3:0:0:0: [sdh] Attached SCSI disk
> [   68.799699]  sdh: unknown partition table
> [   69.072314]
> [   69.072387] ======================================================
> [   69.072433] [ INFO: possible circular locking dependency detected ]
> [   69.072487] 3.17.0-rc2+ #80 Not tainted
> [   69.072518] -------------------------------------------------------
> [   69.072560] rmmod/2890 is trying to acquire lock:
> [   69.072595]  ((sqcp->cmnd_timerp)){+.-...}, at: [<c10846c0>] del_timer_sync+0x0/0xb0
> [   69.072704]
> [   69.072704] but task is already holding lock:
> [   69.072743]  (queued_arr_lock){..-...}, at: [<e1271887>] stop_all_queued+0x17/0xc0 [scsi_debug]
> [   69.072852]
> [   69.072852] which lock already depends on the new lock.
> [   69.072852]

<snip>

> [   69.075321]  Possible unsafe locking scenario:
> [   69.075321]
> [   69.075380]        CPU0                    CPU1
> [   69.075424]        ----                    ----
> [   69.075468]   lock(queued_arr_lock);
> [   69.075534]                                lock((sqcp->cmnd_timerp));
> [   69.075613]                                lock(queued_arr_lock);
> [   69.075690]   lock((sqcp->cmnd_timerp));
> [   69.075758]
> [   69.075758]  *** DEADLOCK ***

Interesting analysis, somewhat confusing because cmnd_timerp
is a pointer. Also my guess is the sqcp pointers in the
two threads were different.

Anyway the attached patch removes the lock(queued_arr_lock)
from around the del_timer calls. Could you try it and report
back.

Doug Gilbert



--------------050402000607050904020501
Content-Type: text/x-patch;
 name="sdebug317rc2_dlock1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug317rc2_dlock1.patch"

--- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
+++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
@@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (cmnd == sqcp->a_cmnd) {
+				devip = (struct sdebug_dev_info *)
+					cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				spin_unlock_irqrestore(&queued_arr_lock,
+						       iflags);
 				if (scsi_debug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
@@ -2755,18 +2762,13 @@ static int stop_queued_cmnd(struct scsi_
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
-				__clear_bit(k, queued_in_use_bm);
-				devip = (struct sdebug_dev_info *)
-					cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
-				break;
+				clear_bit(k, queued_in_use_bm);
+				return 1;
 			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < qmax) ? 1 : 0;
+	return 0;
 }
 
 /* Deletes (stops) timers or tasklets of all queued commands */
@@ -2782,6 +2784,13 @@ static void stop_all_queued(void)
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (sqcp->a_cmnd) {
+				devip = (struct sdebug_dev_info *)
+					sqcp->a_cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				spin_unlock_irqrestore(&queued_arr_lock,
+						       iflags);
 				if (scsi_debug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
@@ -2794,12 +2803,8 @@ static void stop_all_queued(void)
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
-				__clear_bit(k, queued_in_use_bm);
-				devip = (struct sdebug_dev_info *)
-					sqcp->a_cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
+				clear_bit(k, queued_in_use_bm);
+				spin_lock_irqsave(&queued_arr_lock, iflags);
 			}
 		}
 	}

--------------050402000607050904020501--
