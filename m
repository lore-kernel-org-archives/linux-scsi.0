Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E609C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 03:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjKMDbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Nov 2023 22:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjKMDbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Nov 2023 22:31:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682E41719
        for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2023 19:30:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8380C433C9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 03:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699846257;
        bh=6tVchCZW0FEO+bi7afiC5Z8sc1kmxXDKp3bi3eFzrtg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OrrfRORVjfaayXQx7Jkz74wnb6+A1jTvmaQ6RTAqG91JIR+YFCWT6MRjABo0xtMST
         vqvhNFhiwfaqDVSpemJo4A+wW5tEiZXGPYw4ZotOUEsQHJamX5zj+HFWmDac7KXGCg
         K3pnlS5Kz5BruVkeafq1HPUJzSDXUUQnmRHU0sV3ihy+Y86f/tccxnILModPrlNujb
         SW6xxec2MMo9A0G2ny/KzfGgHYpWUcFZTmIqUPha6sKZHj4FVxpPcbSsRymu0Wrm2Y
         nTiinDEx3jKfhhwtz+JJtM2LVXa7COEoO2JMANUQyl6a+l3wdOE859v8I4QRQ9Kwss
         UN4xxdkUJi63w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CDDCFC53BD3; Mon, 13 Nov 2023 03:30:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Mon, 13 Nov 2023 03:30:57 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: kernel@nerdbynature.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217914-11613-kPEwzlBcn3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217914

Christian Kujau (kernel@nerdbynature.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@nerdbynature.de

--- Comment #7 from Christian Kujau (kernel@nerdbynature.de) ---
Noticed the same here when upgrading from 6.1.0-13-amd64 to
6.5.0-0.deb12.1-amd64 (both Debian kernels) earlier this month:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
$ sar -f /var/log/sysstat/sa20231108
                CPU     %user     %nice   %system   %iowait    %steal     %=
idle
[...]
18:30:03        all      1.03      0.00      0.45      0.04      0.00     9=
8.47
18:40:01        all      1.07      0.00      0.52      0.05      0.00     9=
8.36
18:50:01        all      1.07      0.00      0.53      0.04      0.00     9=
8.37
19:00:01        all      1.35      0.00      0.69      0.08      0.00     9=
7.88
19:10:04        all      1.09      0.00      0.52      0.07      0.00     9=
8.31
19:20:02        all      1.14      0.00      0.51      0.05      0.00     9=
8.30
19:30:04        all      1.62      0.00      0.65      0.08      0.00     9=
7.65
Average:        all      1.06      0.00      0.50      0.06      0.00     9=
8.38

19:32:27     LINUX RESTART     (2 CPU)

19:40:03        CPU     %user     %nice   %system   %iowait    %steal     %=
idle
19:50:00        all      2.27      0.00      3.23     57.40      0.00     3=
7.11
20:00:02        all      1.29      0.00      2.70     59.27      0.00     3=
6.75
20:10:03        all      1.48      0.00      2.93     58.38      0.00     3=
7.21
20:20:03        all      1.40      0.00      2.94     58.93      0.00     3=
6.73
20:30:02        all      1.39      0.00      2.87     59.99      0.00     3=
5.74
20:40:03        all      1.48      0.00      3.44     59.83      0.00     3=
5.26
20:50:00        all      1.29      0.00      2.88     60.84      0.00     3=
4.98
21:00:03        all      1.31      0.00      2.63     59.81      0.00     3=
6.25
21:10:03        all      1.33      0.00      2.72     59.85      0.00     3=
6.09
21:20:01        all      1.31      0.00      2.82     59.28      0.00     3=
6.59
21:30:01        all      1.39      0.00      2.92     60.51      0.00     3=
5.18
21:40:01        all      1.34      0.00      3.04     60.04      0.00     3=
5.57
21:50:03        all      1.29      0.00      2.51     59.79      0.00     3=
6.41
22:00:03        all      1.36      0.00      3.23     59.81      0.00     3=
5.59
22:10:03        all      1.37      0.00      2.56     59.13      0.00     3=
6.93
22:20:03        all      1.36      0.00      2.88     58.46      0.00     3=
7.29
22:30:03        all      1.31      0.00      2.65     59.07      0.00     3=
6.97
22:40:00        all      1.32      0.00      2.72     59.61      0.00     3=
6.35
22:50:01        all      1.32      0.00      2.72     59.35      0.00     3=
6.61
23:00:03        all      1.29      0.00      2.68     59.30      0.00     3=
6.72
23:10:03        all      1.35      0.00      2.62     60.11      0.00     3=
5.91
23:20:02        all      1.29      0.00      2.91     59.55      0.00     3=
6.25
23:30:03        all      1.32      0.00      2.72     58.37      0.00     3=
7.59
23:40:01        all      1.34      0.00      2.97     57.74      0.00     3=
7.95
23:50:00        all      1.33      0.00      2.54     59.90      0.00     3=
6.24
Average:        all      1.38      0.00      2.83     59.37      0.00     3=
6.41

$ last -n 3 reboot
reboot   system boot  6.5.0-0.deb12.1- Wed Nov  8 19:32   still running
reboot   system boot  6.1.0-13-amd64   Mon Oct  9 23:14 - 19:32 (29+21:17)
reboot   system boot  6.1.0-13-amd64   Mon Oct  9 22:39 - 23:14  (00:35)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

And top only shows a single [scsi_eh_2] thread using ~50% of CPU time,
sometimes there's an events thread too.


    PID USER  PR  NI    VIRT    RES    SHR   S  %CPU  %MEM     TIME+ COMMAND
    336 root  20   0    0.0m   0.0m   0.0m   D  50.0   0.0     53,37
[scsi_eh_2]
3794126 root  20   0    0.0m   0.0m   0.0m   I  25.7   0.0   0:06.27
[kworker/0:0-events]

This is a Debian/amd64 VM running on a VMware ESX host. There's a virtual C=
DROM
drive, but nothing is attached here and I'm not using it, all:


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
$ lsblk -d --scsi
NAME HCTL    TYPE VENDOR   MODEL                           REV SERIAL=20=20=
=20=20=20=20=20=20=20=20
    TRAN
sda  0:0:0:0 disk VMware   Virtual disk                    2.0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
sr0  2:0:0:0 rom  NECVMWar VMware Virtual IDE CDROM Drive 1.00
10000000000000000001 ata


$ dmesg -t | grep -i scsi
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
SCSI subsystem initialized
VMware PVSCSI driver - version 1.0.7.0-k
vmw_pvscsi: using 64bit dma
vmw_pvscsi: max_id: 65
vmw_pvscsi: setting ring_pages to 32
vmw_pvscsi: enabling reqCallThreshold
vmw_pvscsi: driver-based request coalescing enabled
vmw_pvscsi: using MSI-X
scsi host0: VMware PVSCSI storage adapter rev 2, req/cmp/msg rings: 32/32/1
pages, cmd_per_lun=3D254
vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 2 host #0
scsi 0:0:0:0: Direct-Access     VMware   Virtual disk     2.0  PQ: 0 ANSI: 6
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi host1: ata_piix
scsi host2: ata_piix
scsi 2:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
scsi 2:0:0:0: Attached scsi generic sg1 type 5
sr 2:0:0:0: [sr0] scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda
tray
sr 2:0:0:0: Attached scsi CD-ROM sr0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Will that "scsi: Do no try to probe for CDL on old drives" patch land in
mainline or is this still under discussion?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
