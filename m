From: Johannes Maibaum <jmaibaum@gmail.com>
Subject: Re: HD is powered off too early during shutdown/reboot (4.8
 regression?)
Date: Tue, 6 Dec 2016 15:31:58 +0100
Message-ID: <C4E35808-B2E0-434B-A808-076D810BB3E7@gmail.com>
References: <ec2c184d-ca59-eb67-8a3f-2d46c157d400@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38277 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbcLFOcC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 09:32:02 -0500
Received: by mail-wm0-f49.google.com with SMTP id f82so128043662wmf.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 06:32:01 -0800 (PST)
Received: from [192.168.1.6] (x4e34edd9.dyn.telefonica.de. [78.52.237.217])
        by smtp.gmail.com with ESMTPSA id 63sm4351578wmg.2.2016.12.06.06.31.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2016 06:32:00 -0800 (PST)
In-Reply-To: <ec2c184d-ca59-eb67-8a3f-2d46c157d400@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

just FYI, obviously my issue was related to kernel bug #187061 [1]. I
did a test build of kernel 4.8.12 with the patch from the bug report
applied and this resolved the issue for me.

So, I=E2=80=99m voting for a backport of this change to kernel 4.8.

If this is the wrong place to ask for a backport, please excuse me,
I=E2=80=99m still new here. I=E2=80=99d be grateful if you could point =
me to the right
place in this case.

Best, and sorry for the noise,
Johannes

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D187061
> Am 24.11.2016 um 18:24 schrieb Johannes Maibaum <jmaibaum@gmail.com>:
>=20
> Hi,
>=20
> this is my first posting on a Linux kernel related list, and I hope =
that
> this is the correct place.  If not, I'd be glad if you could point me =
to
> the right place.  People on the Arch Linux forums [1] and on the
> systemd-devel mailing list [2] suggested to report this issue to the
> kernel community.
>=20
> I try to be as specific as I can, but unfortunately I'm not a =
low-level
> Linux expert.
>=20
> Since installing kernel 4.8, I have a problem with my MacBook Pro
> running Arch Linux on a second HD installed in a HD caddy [1].  The =
root
> and /home file systems are on this HD (/dev/sdb, see below), while =
/boot
> is on the first HD alongside macOS (/dev/sda).
>=20
> On shutdown/reboot, it seems that the HD (or the caddy?) gets powered
> off too early, which is clearly audible ('clank!').  Shortly =
afterwards,
> the following errors appears on screen (transcribed from a photo):
>=20
> ata2: exception Emask 0x10 SAct 0x0 SErr 0x1990000 action 0xe
> frozenbd204ed5c
> ata2: irq_stat 0x00400000, PHY RDY changed
> ata2: SError: { PHYRdyChg 10B8B Dispar LinkSeq TrStaTrns }
>=20
> The machine shuts down or reboots a few seconds later, but I've never
> seen the above errors on another kernel before (kernel 4.4 through 4.7
> were installed on this machine and all worked OK), so it seems to be a
> regression.
>=20
> Unfortunately, I haven't yet succeeded in gathering more verbose debug
> information from late shutdown.  I tried to follow the guide in the
> systemd docs [4], but the script failed (probably, since the hd is
> already gone when the script tries to run).  But I will happily try to
> provide you with more information if needed.
>=20
> Here's some more information about my setup:
>=20
> $ dmesg | grep ata2 | head
> [    2.508533] ata2: SATA max UDMA/133 abar m8192@0xd3484000 port
> 0xd3484180 irq 26
> [    2.824504] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.825383] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    2.825543] ata2.00: ATA-8: Hitachi HTS545032B9SA02, PB3AC60W, max
> UDMA/133
> [    2.825545] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth =
31/32)
> [    2.826577] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    2.826745] ata2.00: configured for UDMA/133
> $ readlink /dev/disk/by-id/*HTS545032B9SA02* | head -n1
> ../../sdb
> $ lsblk
> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sdb      8:16   0 298,1G  0 disk
> =E2=94=9C=E2=94=80sdb2   8:18   0 268,1G  0 part /home
> =E2=94=94=E2=94=80sdb1   8:17   0    30G  0 part /
> sda      8:0    0 931,5G  0 disk
> =E2=94=9C=E2=94=80sda2   8:2    0 930,7G  0 part
> =E2=94=9C=E2=94=80sda3   8:3    0 619,9M  0 part
> =E2=94=94=E2=94=80sda1   8:1    0   200M  0 part /boot
>=20
>=20
> Best,
> Johannes
>=20
> [1] Here's a link to the HD caddy: =
https://www.amazon.com/dp/B0090KFOYS
> [2] Arch Linux forum thread:
> https://bbs.archlinux.org/viewtopic.php?pid=3D1668277
> [3] Systemd-devel thread:
> =
https://lists.freedesktop.org/archives/systemd-devel/2016-November/037882.=
html
> [4] https://freedesktop.org/wiki/Software/systemd/Debugging/#index2h1

