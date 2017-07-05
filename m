From: Chris Clayton <chris2553@googlemail.com>
Subject: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 08:06:17 +0100
Message-ID: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34138 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbdGEHIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 03:08:21 -0400
Received: by mail-wm0-f49.google.com with SMTP id 70so29762945wmo.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 00:08:20 -0700 (PDT)
Received: from [192.168.0.20] (97e51daa.skybroadband.com. [151.229.29.170])
        by smtp.googlemail.com with ESMTPSA id v8sm13458970wrd.28.2017.07.05.00.08.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jul 2017 00:08:18 -0700 (PDT)
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi.

I use the applications from Nero 4 Linux to write to blu-ray media, principally, but not exclusively, as part of my
back-up regime. Those applications have stopped working with Linux 4.12 because they fail to detect my drives (one built
in to my laptop and the other attached via USB). The applications successfully detect my drives with 4.11.8 and 4.9.35
kernels. I have been using the applications since 3.x.x days. Unfortunately, development of the applications has deeb
discontinued.

I've bisected the problem and the outcome is:

28676d869bbb5257b5f14c0c95ad3af3a7019dd5 is the first bad commit
commit 28676d869bbb5257b5f14c0c95ad3af3a7019dd5
Author: Johannes Thumshirn <jthumshirn@suse.de>
Date:   Fri Apr 7 09:34:15 2017 +0200

    scsi: sg: check for valid direction before starting the request

    Check for a valid direction before starting the request, otherwise we
    risk running into an assertion in the scsi midlayer checking for valid
    requests.

    [mkp: fixed typo]

    Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
    Link: http://www.spinics.net/lists/linux-scsi/msg104400.html
    Reported-by: Dmitry Vyukov <dvyukov@google.com>
    Signed-off-by: Hannes Reinecke <hare@suse.com>
    Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

:040000 040000 5f268585ddc59bdc4e7bd3b473b8e041f59083af 6d44c177d8eb1df63a3e285e8a77010de0368d01 M	drivers

With this change reversed in 4.12.0, the applications can detect my drive again, although I haven't tried burning
anything to media yet.

Using kernels 4.11.8 and 4.12.0, I ran the console command "nerocmd --scanbus" under strace and logged the resultant
traces. The first material difference between the traces seems to be:

diff -up nerocmd-strace.log-4.11.8 nerocmd-strace.log-4.12.0  > nerocmd-strace.log.diff
--- nerocmd-strace.log-4.11.8	2017-07-04 22:25:19.251996566 +0100
+++ nerocmd-strace.log-4.12.0	2017-07-04 22:31:05.575997661 +0100
...
 open("/dev/sg0", O_RDWR)                = 6
 ioctl(6, SG_SET_RESERVED_SIZE, [131072]) = 0
 ioctl(6, SG_SET_TIMEOUT, [10800000])    = 0
-write(6, "\0\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 42) = 42
-read(6, "H\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 72) = 72
+write(6, "\0\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 42) = -1 EINVAL (Invalid argument)
 close(6)                                = 0
 open("/dev/sg1", O_RDWR)                = 6
 ioctl(6, SG_SET_RESERVED_SIZE, [131072]) = 0
 ioctl(6, SG_SET_TIMEOUT, [10800000])    = 0
-write(6, "\0\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 42) = 42
-read(6, "H\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 72) = 72
+write(6, "\0\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 42) = -1 EINVAL (Invalid argument)
 close(6)                                = 0
 open("/usr/lib64/nero/libMmc.so", O_RDONLY|O_CLOEXEC) = 6
 read(6, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0k\v\0\0\0\0\0"..., 832) = 832
...

I can provide the full traces or any other diagnostics, if they would help.

Thanks

Chris
