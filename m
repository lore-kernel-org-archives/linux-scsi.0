From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [PATCH] The md RAID10 resync thread could cause a md RAID10 array
 deadlock
Date: Thu, 28 Feb 2008 11:55:15 +0900
Message-ID: <47C62293.9010904@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63879 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYB1CyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 21:54:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This message describes another issue about md RAID10 found by
testing the 2.6.24 md RAID10 using new scsi fault injection framework.

Abstract:
When a scsi error results in disabling a disk during RAID10 recovery,
the resync threads of md RAID10 could stall.
This case, the raid array has already been broken and it may not matter.
But I think stall is not preferable. If it occurs, even shutdown or reboot
will fail because of resource busy.

The deadlock mechanism:
The r10bio_s structure has a "remaining" member to keep track of BIOs yet to be
handled when recovering. The "remaining" counter is incremented when building a BIO
in sync_request() and is decremented when finish a BIO in end_sync_write().

If building a BIO fails for some reasons in sync_request(), the "remaining" should be
decremented if it has already been incremented. I found a case where this decrement
is forgotten. This causes a md_do_sync() deadlock because md_do_sync() waits for
md_done_sync() called by end_sync_write(), but end_sync_write() never calls
md_done_sync() because of the "remaining" counter mismatch.

For example, this problem would be reproduced in the following case:

Personalities : [raid10]
md0 : active raid10 sdf1[4] sde1[5](F) sdd1[2] sdc1[1] sdb1[6](F)
      3919616 blocks 64K chunks 2 near-copies [4/2] [_UU_]
      [>....................]  recovery =  2.2% (45376/1959808) finish=0.7min speed=45376K/sec

This case, sdf1 is recovering, sdb1 and sde1 are disabled.
An additional error with detaching sdd will cause a deadlock.

md0 : active raid10 sdf1[4] sde1[5](F) sdd1[6](F) sdc1[1] sdb1[7](F)
      3919616 blocks 64K chunks 2 near-copies [4/1] [_U__]
      [=>...................]  recovery =  5.0% (99520/1959808) finish=5.9min speed=5237K/sec

 2739 ?        S<     0:17 [md0_raid10]
28608 ?        D<     0:00 [md0_resync]
28629 pts/1    Ss     0:00 bash
28830 pts/1    R+     0:00 ps ax
31819 ?        D<     0:00 [kjournald]

The resync thread keeps working, but actually it is deadlocked.

Patch:
By this patch, the remaining counter will be decremented if needed.

--- raid10.c.org	2008-01-30 01:09:04.000000000 +0900
+++ raid10.c	2008-02-26 16:27:22.000000000 +0900
@@ -1805,6 +1805,9 @@ static sector_t sync_request(mddev_t *md
 				if (j == conf->copies) {
 					/* Cannot recover, so abort the recovery */
 					put_buf(r10_bio);
+  				        if (rb2) {
+ 					    atomic_dec(&rb2->remaining);
+                                        }
 					r10_bio = rb2;
 					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
 						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",


This problem is also detected by using new scsi fault injection framework.
I have posted a new version to sourceforge with some sample shell script
using the framework for usability. If you are interested, please take a look at it.


-- 

---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com

