From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: News UBSAN warnings in aacraid
Date: Mon, 27 Nov 2017 22:32:45 +0100
Message-ID: <CAK8P3a00CC20bD2cfuJhRwrmmSte7y83a0Z2hx+CRoqQotJktA@mail.gmail.com>
References: <alpine.LRH.2.21.1711272112050.5402@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1711272112050.5402@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Dave Carroll <david.carroll@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 27, 2017 at 8:17 PM, Meelis Roos <mroos@linux.ee> wrote:
> Tried 4.15-rc1 on an old 32-bit HP Netserver with aacraid card. Compared
> to 4.14, there are new UBSAN warnings with timer related backtraces, so
> the timespec64 change seems suspicious:

> [   12.228155] UBSAN: Undefined behaviour in drivers/scsi/aacraid/commsup.c:2514:49
> [   12.228229] signed integer overflow:
> [   12.228283] 964297611 * 250 cannot be represented in type 'long int'

Thanks for reporting it! For reference, this is my change that got applied to
aac_command_thread:

@@ -2496,7 +2496,7 @@ int aac_command_thread(void *data)
                }
                if (!time_before(next_check_jiffies,next_jiffies)
                 && ((difference = next_jiffies - jiffies) <= 0)) {
-                       struct timeval now;
+                       struct timespec64 now;
                        int ret;

                        /* Don't even try to talk to adapter if its sick */
@@ -2506,15 +2506,15 @@ int aac_command_thread(void *data)
                        next_check_jiffies = jiffies
                                           + ((long)(unsigned)check_interval)
                                           * HZ;
-                       do_gettimeofday(&now);
+                       ktime_get_real_ts64(&now);

                        /* Synchronize our watches */
-                       if (((1000000 - (1000000 / HZ)) > now.tv_usec)
-                        && (now.tv_usec > (1000000 / HZ)))
-                               difference = (((1000000 - now.tv_usec) * HZ)
-                                 + 500000) / 1000000;
+                       if (((NSEC_PER_SEC - (NSEC_PER_SEC / HZ)) > now.tv_nsec)
+                        && (now.tv_nsec > (NSEC_PER_SEC / HZ)))
+                               difference = (((NSEC_PER_SEC -
now.tv_nsec) * HZ)
+                                 + NSEC_PER_SEC / 2) / NSEC_PER_SEC;
                        else {
-                               if (now.tv_usec > 500000)
+                               if (now.tv_nsec > NSEC_PER_SEC / 2)
                                        ++now.tv_sec;

                                if (dev->sa_firmware)

The problem is that a microsecond number (0 to 999999) multiplied by
HZ (100 to 1024) always fits in a 32-bit integer, but the nanosecond
number doesn't.

We could make that a 64-bit division, but that would be fairly expensive.

I'm trying to understand the bigger picture now, rather than simply
attempting to do a simple conversion, but I don't see what we are
actually trying to compute in 'difference' here.

I think this chunk would solve the problem and result in the
same behavior as before:

--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2511,8 +2511,8 @@ int aac_command_thread(void *data)
                        /* Synchronize our watches */
                        if (((NSEC_PER_SEC - (NSEC_PER_SEC / HZ)) > now.tv_nsec)
                         && (now.tv_nsec > (NSEC_PER_SEC / HZ)))
-                               difference = (((NSEC_PER_SEC -
now.tv_nsec) * HZ)
-                                 + NSEC_PER_SEC / 2) / NSEC_PER_SEC;
+                               difference = HZ + HZ / 2 -
+                                            now.tv_nsec / (NSEC_PER_SEC / HZ);
                        else {
                                if (now.tv_nsec > NSEC_PER_SEC / 2)
                                        ++now.tv_sec;

but I don't see why we add in half a second here. Any ideas?

       Arnd
