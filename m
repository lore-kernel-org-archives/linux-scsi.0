From: Larkin Lowrey <llowrey@gmail.com>
Subject: mvsas sata drives with high ioerr_cnt and long stalls
Date: Wed, 15 Nov 2017 18:55:30 -0500
Message-ID: <2efdd536-caa8-8da7-9c82-58d63670eb57@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:49743 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756328AbdKOXzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 18:55:35 -0500
Received: by mail-vk0-f46.google.com with SMTP id t184so15497890vka.6
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2017 15:55:35 -0800 (PST)
Received: from ?IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c? ([2601:6c5:8000:1480:54ff:ba2b:b29:792c])
        by smtp.gmail.com with ESMTPSA id x184sm5362647vkc.50.2017.11.15.15.55.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Nov 2017 15:55:32 -0800 (PST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, I'm looking for some help to diagnose write stalls for sata 
drives connected to Highpoint controllers running the mvsas driver.

I'm seeing writes stall for several seconds at a time for md raid arrays 
using Highpoint 2740 and 2720sgl controllers running in JBOD mode (mvsas 
driver). I'm seeing the same behavior on two servers that use the same 
controllers but are otherwise configured differently.

Reads are just fine, the only time I encounter problems is when writing. 
When writing large amounts of data, all of the drives in the array will 
go idle (according to iostat) with all zeros in iostat except for 
avgrq-sz (numbers < 10) and %util (always 100%). After a few seconds, 
iostat will show resumed activity with the first report showing await 
times for all drives roughly equal to the length of he stall. These 
stalls will occur periodically during the write.

Here's iostat during a stall:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     2.00    0.00    0.00    0.00   0.00 100.10
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00     2.00    0.00    0.00    0.00   0.00 100.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     9.00    0.00    0.00    0.00   0.00 100.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00    0.00    0.00   0.00 100.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     0.00     2.00    0.00    0.00    0.00   0.00 100.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     0.00     2.00    0.00    0.00    0.00   0.00 100.10
sdo               0.00     0.00    0.00    0.00     0.00     0.00     0.00     3.00    0.00    0.00    0.00   0.00 100.10
sdq               0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00    0.00    0.00   0.00 100.10
sdp               0.00     0.00    0.00    0.00     0.00     0.00     0.00     4.00    0.00    0.00    0.00   0.00 100.00


Then, after a few seconds, the first iostat report after the stall with 
non-zero activity:

sdf               0.00     0.00    0.00    3.00     0.00     0.01     5.67     1.03 3361.67    0.00 3361.67 175.67  52.70
sdg               0.00     0.00    0.00    3.00     0.00     0.01     5.67     1.01 3357.00    0.00 3357.00 171.33  51.40
sdj               0.00     0.00    1.00    9.00     0.00     0.22    46.50     4.61 3839.90    4.00 4266.11  55.30  55.30
sdl               0.00     0.00    0.00    2.00     0.00     0.01    12.50     0.54 2534.00    0.00 2534.00 269.50  53.90
sdm               0.00     0.00    0.00    4.00     0.00     0.01     4.25     1.01 2516.00    0.00 2516.00 126.75  50.70
sdn               0.00     0.00    0.00    3.00     0.00     0.12    83.00     1.02 1685.33    0.00 1685.33 175.33  52.60
sdo               0.00     0.00    0.00    4.00     0.00     0.02    10.25     1.60 3798.00    0.00 3798.00 149.00  59.60
sdq               0.00     0.00    0.00    2.00     0.00     0.06    64.50     0.53 1558.50    0.00 1558.50 266.50  53.30
sdp               0.00     0.00    0.00    5.00     0.00     0.02     9.80     2.11 4046.00    0.00 4046.00 120.80  60.40


There are no error messages printed to the console (serial console is 
logged, plus checked dmesg and /var/log/messages).

The drives in the array show high  ioerr_cnt values (0x330 aka 816d below).

[8:0:4:0]    disk    ATA      ST8000DM002-1YW1 DN02  /dev/sdj
   device_blocked=0
   iocounterbits=32
   iodone_cnt=0x147fa
   ioerr_cnt=0x330
   iorequest_cnt=0x1487a
   queue_depth=31
   queue_type=simple
   scsi_level=6
   state=running
   timeout=30
   type=0

SMART does not show any errors (no pending or relocated sectors, no UDMA 
CRC errors, etc).

My guess is the write transfer to the drive is failing and is retried by 
the driver. Since the start and end of the stall is the same for all of 
the drives in the array I find it hard to believe the issue is related 
to individual drives or cabling.

Ideas?

Are there any other sources of diagnostic data that would help to debug 
this?

Kernel machine A: 4.13.5-100.fc25.x86_64
Kernel machine B:  4.13.10-200.fc26.x86_64

--Larkin
