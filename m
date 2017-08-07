From: Sergey Borisov <borisovs@gmail.com>
Subject: https://bugzilla.kernel.org/show_bug.cgi?id=196517
Date: Mon, 7 Aug 2017 09:22:30 +0300
Message-ID: <CAKY7HN0d7gaRBK7LcqTKdGuHVFZDv1Yifkv9UD2U5vtCtfqfqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:37362 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdHGGWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 02:22:31 -0400
Received: by mail-pg0-f50.google.com with SMTP id y129so30188877pgy.4
        for <linux-scsi@vger.kernel.org>; Sun, 06 Aug 2017 23:22:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!
I've also reproduced this issue on this kernel
Linux desktop 4.10.0-28-generic #32~16.04.2-Ubuntu SMP Thu Jul 20
10:19:48 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
====================

Each one second, my program reads /sys/block/$DEVICE/stat.

It substracts previously saved values, then saves current values, so I
know the hdd activity.
But sometimes (once in 7 days) I've got too big values for sda
(between last and current ones) (5GB/second).

sudo lshw -class disk
 *-disk
       description: ATA Disk
       product: SPCC Solid State
       physical id: 0.0.0
       bus info: scsi@2:0.0.0
       logical name: /dev/sda
       version: 08.2
       serial: EB84075517B200427436
       size: 111GiB (120GB)
       capabilities: partitioned partitioned:dos
       configuration: ansiversion=5 logicalsectorsize=512
sectorsize=512 signature=d01f3b8e

Also I've written the script for monitoring the statistics

#!/bin/bash

while (true) do
str=`date`" $(cat /sys/block/sda/stat)"
echo $str >> log.txt
sleep 10;
done

And got this values

Fr Jul 28 07:39:38 MSK 2017 2368466 475339 105223134 1362848 5753154
7692148 661424840 31319540 0 4790052 32687100
Fr Jul 28 07:39:48 MSK 2017 2368466 475339 105223134 1362848 5753170
7692160 661425104 31319548 0 4790060 32687108
Fr Jul 28 07:39:58 MSK 2017 2368466 475339 105223134 1362848 5753174
7692162 661425152 31319556 0 4790068 32687116
Fr Jul 28 07:40:08 MSK 2017 2369133 475339 105228750 1363380 5771079
7694395 706209560 31324696 0 4795572 32692780
Fr Jul 28 07:40:18 MSK 2017 2369133 475339 105228750 1363380 5771087
7694431 706209960 31324708 0 4795584 32692792
Fr Jul 28 07:40:28 MSK 2017 2369133 475339 105228750 1363380 5771091
7694433 706210008 31324716 0 4795592 32692800
Fr Jul 28 07:40:38 MSK 2017 2369133 475339 105228750 1363380 5771244
7694714 706213528 31325052 0 4795604 32693136

You can see that the difference (3,4 lines) is very big between
706209560 and 661425152, my ssd can read/write 250 Mb/sec, but not 5
Gb/sec.




-- 
Best regards,
Sergey Borisov
