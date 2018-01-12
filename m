From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: PMC(Adaptec) 7805H(7H series) HBA compatibility problem with many
 Seagate HDDs
Date: Fri, 12 Jan 2018 16:16:14 +0100
Message-ID: <CAD+HZHWc5nGS2W7dV7AfbYj5d_HKhgiGyYWr=G7+ZbsCk45xSw@mail.gmail.com>
References: <20180112111556.570F96001DC@mta-1.openmailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34453 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933866AbeALPQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2018 10:16:17 -0500
Received: by mail-wr0-f194.google.com with SMTP id 36so5619856wrh.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2018 07:16:16 -0800 (PST)
In-Reply-To: <20180112111556.570F96001DC@mta-1.openmailbox.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sonofagun@openmailbox.org, Viswas G <viswas.g@microsemi.com>
Cc: linux-scsi@vger.kernel.org

+cc Viswas from micorsemi. maybe he can help.

2018-01-12 12:15 GMT+01:00  <sonofagun@openmailbox.org>:
>
> Hello, we have a long standing issue for a couple of years with our SAS HBA.
>
> It happens no matter what distribution we use(Debian, CentOS, Ubuntu).
>
> When we bought this HBA we had already two 500GB Seagate SAS HDDs, Constellation ES.2 ST3500620SS. Those were working fine as expected.
> In order to back up SATA disks we bought a couple of 4TB Seagate SAS HDDs, Constellation ES.3 ST4000NM0023.
> Unfortunately they did not work with this HBA even though we updated both the HBA and the HDDs firmware a couple of times back in 2015 :(
> Our LSI SAS Gen2 HBA had no issues at all with the same disks...
>
> A couple of years ago my brother contacted PMC and Seagate but the issue remains... Since the issue persisted they were moved to the LSI HBA.
>
> My brother thought it was a compatibility issue with Constellation ES.3 so he bought 3 newer Seagate disks in December. Those are Enterprise Capacity v5(ECv5) now called Exos 7E2.
> Unfortunately none of them works on this HBA! Again our LSI SAS Gen2 HBA had no issues at all with the newer disks...
>
> In order to have a decent disk for the PMC HBA, we bought a couple of 10K 2,5" Toshiba HDDs which support T1O DIF but have it inactive. Luckily those disks worked fine!
>
> The problem is that we have 5(2+3) Seagate 7200 class disks that cannot work with this controller!
> Any newer seagate SAS HDD we tried and had protection information (aka T1O DIF) cannot be written on this HBA for some reason (even though DIF was never activated).
> Formatting the disk from the HBA did not solve the issue. So dd and mke2fs are unusable. Both always hang even though the disk and the HBA are in good condition.
> The affected disk was tested on all SAS ports but it failed miserably. Different cables were also used to ensure that no cabling issues arise.
>
> The ES.3 disks are unavailable for now as they have data. Any patch will be only tested with our ECv5.
>
> Here is what we get at normal boot with dd (input /dev/zero, block 8k in this case):
>
> [    0.000000] Linux version 4.9.0-5-amd64 (debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian 6.3.0-18) ) #1 SMP Debian 4.9.65-3+deb9u2 (2018-01-04)
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.9.0-5-amd64 root=UUID=5e47893b-3c41-4eef-b6c8-c401681ec19f ro quiet
> [    0.644856] pci 0000:06:00.0: [9005:8088] type 00 class 0x010700
> [    0.644867] pci 0000:06:00.0: reg 0x10: [mem 0xfe250000-0xfe25ffff 64bit]
> [    0.644875] pci 0000:06:00.0: reg 0x18: [mem 0xfe240000-0xfe24ffff 64bit]
> [    0.644884] pci 0000:06:00.0: reg 0x24: [mem 0xfe200000-0xfe23ffff]
> [    0.644890] pci 0000:06:00.0: reg 0x30: [mem 0xfe100000-0xfe1fffff pref]
> [    0.644933] pci 0000:06:00.0: supports D1
> [    0.644934] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
> [    1.290266] iommu: Adding device 0000:06:00.0 to group 22
> [    1.441672] pm80xx 0000:06:00.0: pm80xx: driver version 0.1.38
> [    2.302240] scsi host0: pm80xx
> [    2.802851] sas: phy-0:1 added to port-0:0, phy_mask:0x2 (5000c500********)
> [    2.802858] sas: DOING DISCOVERY on port 0, pid:189
> [    2.862822] sas: DONE DISCOVERY on port 0, pid:189, result:0
> [    2.877467] scsi 0:0:0:0: Direct-Access     SEAGATE  ST2000NM0045     N003 PQ: 0 ANSI: 6
> [    3.792502] sd 0:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> [    3.795080] sd 0:0:0:0: [sdb] Write Protect is off
> [    3.795082] sd 0:0:0:0: [sdb] Mode Sense: db 00 10 08
> [    3.796995] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    3.810543] sd 0:0:0:0: [sdb] Attached SCSI disk
> [    8.164122] sd 0:0:0:0: Attached scsi generic sg2 type 0
> [  380.487177] sas: Enter sas_scsi_recover_host busy: 151 failed: 151
Looks all IO just can't finished, and was aborted. I suppose
PMCS/microsemi have compatible list for their HBA, did you check that?
Have you try the driver from their website, does it work?
https://storage.microsemi.com/en-us/support/sas/sas/asa-7805h/

[snip]

Regards,
Jack
