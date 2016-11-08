From: Jens Axboe <axboe@kernel.dk>
Subject: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
Date: Tue, 8 Nov 2016 10:42:37 -0700
Message-ID: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:33338 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbcKHRmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 12:42:40 -0500
Received: by mail-it0-f53.google.com with SMTP id e187so33328653itc.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 09:42:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi,

I wasted half a day on this, thinking it was something in my 4.10
branches. But it turns out it is not, the regression is in mainline.

Looking at the recent fixes, turns out to be this one:

commit 1e793f6fc0db920400574211c48f9157a37e3945
Author: Kashyap Desai <kashyap.desai@broadcom.com>
Date:   Fri Oct 21 06:33:32 2016 -0700

     scsi: megaraid_sas: Fix data integrity failure for JBOD 
(passthrough) devices

If I revert that, box boots fine again. The effect of the regression is
that my box detects tons of SCSI devices (literally, thousands):

[   11.675834] sd 0:2:0:0: [sda] Sector size 0 reported, assuming 512.
[   11.675840] sd 0:2:0:0: Attached scsi generic sg0 type 0
[   11.676096] sd 0:2:1:0: Attached scsi generic sg1 type 0
[   11.676099] sd 0:2:1:0: [sdb] Sector size 0 reported, assuming 512.
[   11.676105] sd 0:2:1:0: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[   11.676107] sd 0:2:1:0: [sdb] 0-byte physical blocks
[   11.676132] sd 0:2:1:0: [sdb] Write Protect is off
[   11.676170] sd 0:2:1:0: [sdb] Asking for cache data failed
[   11.676173] sd 0:2:1:0: [sdb] Assuming drive cache: write through
[   11.676410] sd 0:2:2:0: Attached scsi generic sg2 type 0
[   11.676432] sd 0:2:2:0: [sdc] Sector size 0 reported, assuming 512.
[   11.676435] sd 0:2:2:0: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[   11.676438] sd 0:2:2:0: [sdc] 0-byte physical blocks
[   11.676442] sd 0:2:1:0: [sdb] Sector size 0 reported, assuming 512.
[   11.676454] sd 0:2:2:0: [sdc] Write Protect is off
[   11.676476] sd 0:2:2:0: [sdc] Asking for cache data failed
[   11.676478] sd 0:2:2:0: [sdc] Assuming drive cache: write through
[...]

[   11.717641] sd 0:3:63:0: Attached scsi generic sg127 type 0
[   11.717757] sd 0:3:62:0: [sddw] Sector size 0 reported, assuming 512.
[   11.717801] sd 0:3:63:0: [sddx] Sector size 0 reported, assuming 512.
[   11.717802] sd 0:3:62:0: [sddw] Attached SCSI disk
[   11.718011] sd 0:3:63:0: [sddx] Sector size 0 reported, assuming 512.

where a normal boots just detects sda and the CD-ROM:

[   10.398120] sd 0:2:0:0: Attached scsi generic sg0 type 0
[   10.398369] sd 0:2:0:0: [sda] 975699968 512-byte logical blocks: (500 
GB/465 GiB)
[   10.398684] sd 0:2:0:0: [sda] Write Protect is off
[   10.398872] sd 0:2:0:0: [sda] Write cache: disabled, read cache: 
enabled, supports DPO and FUA
[   10.435084]  sda: sda1 sda2 < sda5 sda6 > sda3
[   10.437522] scsi 5:0:0:0: CD-ROM            TEAC     DVD-ROM DV-28SW 
R.2B PQ: 0 ANSI: 5
[   10.456582] sd 0:2:0:0: [sda] Attached SCSI disk
[   10.500499] sr 5:0:0:0: [sr0] scsi3-mmc drive: 24x/24x cd/rw xa/form2 
cdda tray
[   10.508830] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.515186] sr 5:0:0:0: Attached scsi generic sg1 type 5


-- 
Jens Axboe

