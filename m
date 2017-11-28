From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: aacraid: address UBSAN warning regression
Date: Tue, 28 Nov 2017 14:25:25 +0100
Message-ID: <20171128132536.3037571-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Meelis Roos <mroos@linux.ee>, Arnd Bergmann <arnd@arndb.de>, Dave Carroll <david.carroll@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As reported by Meelis Roos, my previous patch causes an incorrect
calculation of the timeout, through an undefined signed integer
overflow:

[   12.228155] UBSAN: Undefined behaviour in drivers/scsi/aacraid/commsup.c:2514:49
[   12.228229] signed integer overflow:
[   12.228283] 964297611 * 250 cannot be represented in type 'long int'

The problem is that doing a multiplication with HZ first and then
dividing by USEC_PER_SEC worked correctly for 32-bit microseconds,
but not for 32-bit nanoseconds, which would require up to 41 bits.

This reworks the calculation to first convert the nanoseconds into
jiffies, which should give us the same result as before and not overflow.

Unfortunately I did not understand the exact intention of the algorithm,
in particular the part where we add half a second, so it's possible that
there is still a preexisting problem in this function. I added a comment
that this would be handled more nicely using usleep_range(), which
generally works better for waking up at a particular time than the
current schedule_timeout() based implementation. I did not feel
comfortable trying to implement that without being sure what the
intent is here though.

Fixes: 820f18865912 ("scsi: aacraid: use timespec64 instead of timeval")
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/commsup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 525a652dab48..cc8fdefaebb6 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2511,8 +2511,8 @@ int aac_command_thread(void *data)
 			/* Synchronize our watches */
 			if (((NSEC_PER_SEC - (NSEC_PER_SEC / HZ)) > now.tv_nsec)
 			 && (now.tv_nsec > (NSEC_PER_SEC / HZ)))
-				difference = (((NSEC_PER_SEC - now.tv_nsec) * HZ)
-				  + NSEC_PER_SEC / 2) / NSEC_PER_SEC;
+				difference = HZ + HZ / 2 -
+					     now.tv_nsec / (NSEC_PER_SEC / HZ);
 			else {
 				if (now.tv_nsec > NSEC_PER_SEC / 2)
 					++now.tv_sec;
@@ -2536,6 +2536,10 @@ int aac_command_thread(void *data)
 		if (kthread_should_stop())
 			break;
 
+		/*
+		 * we probably want usleep_range() here instead of the
+		 * jiffies computation
+		 */
 		schedule_timeout(difference);
 
 		if (kthread_should_stop())
-- 
2.9.0
