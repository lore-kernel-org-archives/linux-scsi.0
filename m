From: Johannes Maibaum <jmaibaum@gmail.com>
Subject: HD is powered off too early during shutdown/reboot (4.8 regression?)
Date: Thu, 24 Nov 2016 18:24:16 +0100
Message-ID: <ec2c184d-ca59-eb67-8a3f-2d46c157d400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36533 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754307AbcKXRYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Nov 2016 12:24:19 -0500
Received: by mail-wm0-f54.google.com with SMTP id g23so121434030wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Nov 2016 09:24:18 -0800 (PST)
Received: from [192.168.1.27] ([141.20.150.176])
        by smtp.gmail.com with ESMTPSA id e6sm42811458wjw.33.2016.11.24.09.24.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Nov 2016 09:24:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

this is my first posting on a Linux kernel related list, and I hope that
this is the correct place.  If not, I'd be glad if you could point me to
the right place.  People on the Arch Linux forums [1] and on the
systemd-devel mailing list [2] suggested to report this issue to the
kernel community.

I try to be as specific as I can, but unfortunately I'm not a low-level
Linux expert.

Since installing kernel 4.8, I have a problem with my MacBook Pro
running Arch Linux on a second HD installed in a HD caddy [1].  The root
and /home file systems are on this HD (/dev/sdb, see below), while /boot
is on the first HD alongside macOS (/dev/sda).

On shutdown/reboot, it seems that the HD (or the caddy?) gets powered
off too early, which is clearly audible ('clank!').  Shortly afterwards,
the following errors appears on screen (transcribed from a photo):

ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe
frozenbd204ed5c
ata2: irq_stat 0x00400000, PHY RDY changed
ata2: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }

The machine shuts down or reboots a few seconds later, but I've never
seen the above errors on another kernel before (kernel 4.4 through 4.7
were installed on this machine and all worked OK), so it seems to be a
regression.

Unfortunately, I haven't yet succeeded in gathering more verbose debug
information from late shutdown.  I tried to follow the guide in the
systemd docs [4], but the script failed (probably, since the hd is
already gone when the script tries to run).  But I will happily try to
provide you with more information if needed.

Here's some more information about my setup:

$ dmesg | grep ata2 | head
[    2.508533] ata2: SATA max UDMA/133 abar m8192@0xd3484000 port
0xd3484180 irq 26
[    2.824504] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.825383] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.825543] ata2.00: ATA-8: Hitachi HTS545032B9SA02, PB3AC60W, max
UDMA/133
[    2.825545] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.826577] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    2.826745] ata2.00: configured for UDMA/133
$ readlink /dev/disk/by-id/*HTS545032B9SA02* | head -n1
../../sdb
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 298,1G  0 disk
├─sdb2   8:18   0 268,1G  0 part /home
└─sdb1   8:17   0    30G  0 part /
sda      8:0    0 931,5G  0 disk
├─sda2   8:2    0 930,7G  0 part
├─sda3   8:3    0 619,9M  0 part
└─sda1   8:1    0   200M  0 part /boot


Best,
Johannes

[1] Here's a link to the HD caddy: https://www.amazon.com/dp/B0090KFOYS
[2] Arch Linux forum thread:
https://bbs.archlinux.org/viewtopic.php?pid=1668277
[3] Systemd-devel thread:
https://lists.freedesktop.org/archives/systemd-devel/2016-November/037882.html
[4] https://freedesktop.org/wiki/Software/systemd/Debugging/#index2h1
