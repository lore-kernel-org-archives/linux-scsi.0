Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AEDC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 11:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjKMLx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 06:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjKMLx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 06:53:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDC4D76
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 03:53:52 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE222C433C8
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 11:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699876431;
        bh=joJWMQwXNDrshevJUeHbub5KNe8gcHqtvVi8b6k58Vk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=csPjaId2W2w87RlXIEmCXlFbNK6piw/PK8vq3JxbRwHo2/KFZX695bqjN0DcqnOLi
         vHlOJbnUZkISO+3K0L/MMpKSuUJhIhc15v6L3D7TZZGsQJ6OpYd9QOPh0J2fJ1LMNR
         VOzgjrvIMzWjrwC0tBX75pJlIXeP8US9evimpkZQ6+PfPYoDGNMc1YSMGUY9M+mmMc
         BG6xXQFGUR5nt5pl4Q0O0u/dw6iptxAMUCDMEVdUs9oy2cpN8d2K+jKJUsBRcQk5yS
         z6iX5owGe7x392ehE/ulEGDFb3GPrVKQYTBkepeEN9GEOt5fyVCc6db8vicesQ7SiS
         UFyXLRTJDak3A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 926F2C53BD4; Mon, 13 Nov 2023 11:53:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Date:   Mon, 13 Nov 2023 11:53:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: Niklas.Cassel@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217914-11613-3gQfpb0Nbx@https.bugzilla.kernel.org/>
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

--- Comment #8 from Niklas.Cassel@wdc.com ---
On Mon, Nov 13, 2023 at 03:30:57AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217914
>=20
> Christian Kujau (kernel@nerdbynature.de) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |kernel@nerdbynature.de
>=20
> --- Comment #7 from Christian Kujau (kernel@nerdbynature.de) ---
> Noticed the same here when upgrading from 6.1.0-13-amd64 to
> 6.5.0-0.deb12.1-amd64 (both Debian kernels) earlier this month:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> $ sar -f /var/log/sysstat/sa20231108
>                 CPU     %user     %nice   %system   %iowait    %steal=20=
=20=20=20
>                 %idle
> [...]
> 18:30:03        all      1.03      0.00      0.45      0.04      0.00=20=
=20=20=20
> 98.47
> 18:40:01        all      1.07      0.00      0.52      0.05      0.00=20=
=20=20=20
> 98.36
> 18:50:01        all      1.07      0.00      0.53      0.04      0.00=20=
=20=20=20
> 98.37
> 19:00:01        all      1.35      0.00      0.69      0.08      0.00=20=
=20=20=20
> 97.88
> 19:10:04        all      1.09      0.00      0.52      0.07      0.00=20=
=20=20=20
> 98.31
> 19:20:02        all      1.14      0.00      0.51      0.05      0.00=20=
=20=20=20
> 98.30
> 19:30:04        all      1.62      0.00      0.65      0.08      0.00=20=
=20=20=20
> 97.65
> Average:        all      1.06      0.00      0.50      0.06      0.00=20=
=20=20=20
> 98.38
>=20
> 19:32:27     LINUX RESTART     (2 CPU)
>=20
> 19:40:03        CPU     %user     %nice   %system   %iowait    %steal=20=
=20=20=20
> %idle
> 19:50:00        all      2.27      0.00      3.23     57.40      0.00=20=
=20=20=20
> 37.11
> 20:00:02        all      1.29      0.00      2.70     59.27      0.00=20=
=20=20=20
> 36.75
> 20:10:03        all      1.48      0.00      2.93     58.38      0.00=20=
=20=20=20
> 37.21
> 20:20:03        all      1.40      0.00      2.94     58.93      0.00=20=
=20=20=20
> 36.73
> 20:30:02        all      1.39      0.00      2.87     59.99      0.00=20=
=20=20=20
> 35.74
> 20:40:03        all      1.48      0.00      3.44     59.83      0.00=20=
=20=20=20
> 35.26
> 20:50:00        all      1.29      0.00      2.88     60.84      0.00=20=
=20=20=20
> 34.98
> 21:00:03        all      1.31      0.00      2.63     59.81      0.00=20=
=20=20=20
> 36.25
> 21:10:03        all      1.33      0.00      2.72     59.85      0.00=20=
=20=20=20
> 36.09
> 21:20:01        all      1.31      0.00      2.82     59.28      0.00=20=
=20=20=20
> 36.59
> 21:30:01        all      1.39      0.00      2.92     60.51      0.00=20=
=20=20=20
> 35.18
> 21:40:01        all      1.34      0.00      3.04     60.04      0.00=20=
=20=20=20
> 35.57
> 21:50:03        all      1.29      0.00      2.51     59.79      0.00=20=
=20=20=20
> 36.41
> 22:00:03        all      1.36      0.00      3.23     59.81      0.00=20=
=20=20=20
> 35.59
> 22:10:03        all      1.37      0.00      2.56     59.13      0.00=20=
=20=20=20
> 36.93
> 22:20:03        all      1.36      0.00      2.88     58.46      0.00=20=
=20=20=20
> 37.29
> 22:30:03        all      1.31      0.00      2.65     59.07      0.00=20=
=20=20=20
> 36.97
> 22:40:00        all      1.32      0.00      2.72     59.61      0.00=20=
=20=20=20
> 36.35
> 22:50:01        all      1.32      0.00      2.72     59.35      0.00=20=
=20=20=20
> 36.61
> 23:00:03        all      1.29      0.00      2.68     59.30      0.00=20=
=20=20=20
> 36.72
> 23:10:03        all      1.35      0.00      2.62     60.11      0.00=20=
=20=20=20
> 35.91
> 23:20:02        all      1.29      0.00      2.91     59.55      0.00=20=
=20=20=20
> 36.25
> 23:30:03        all      1.32      0.00      2.72     58.37      0.00=20=
=20=20=20
> 37.59
> 23:40:01        all      1.34      0.00      2.97     57.74      0.00=20=
=20=20=20
> 37.95
> 23:50:00        all      1.33      0.00      2.54     59.90      0.00=20=
=20=20=20
> 36.24
> Average:        all      1.38      0.00      2.83     59.37      0.00=20=
=20=20=20
> 36.41
>=20
> $ last -n 3 reboot
> reboot   system boot  6.5.0-0.deb12.1- Wed Nov  8 19:32   still running
> reboot   system boot  6.1.0-13-amd64   Mon Oct  9 23:14 - 19:32 (29+21:17)
> reboot   system boot  6.1.0-13-amd64   Mon Oct  9 22:39 - 23:14  (00:35)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
> And top only shows a single [scsi_eh_2] thread using ~50% of CPU time,
> sometimes there's an events thread too.
>=20
>=20
>     PID USER  PR  NI    VIRT    RES    SHR   S  %CPU  %MEM     TIME+ COMM=
AND
>     336 root  20   0    0.0m   0.0m   0.0m   D  50.0   0.0     53,37
> [scsi_eh_2]
> 3794126 root  20   0    0.0m   0.0m   0.0m   I  25.7   0.0   0:06.27
> [kworker/0:0-events]
>=20
> This is a Debian/amd64 VM running on a VMware ESX host. There's a virtual
> CDROM
> drive, but nothing is attached here and I'm not using it, all:
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> $ lsblk -d --scsi
> NAME HCTL    TYPE VENDOR   MODEL                           REV SERIAL=20=
=20=20=20=20=20=20=20=20
>     TRAN
> sda  0:0:0:0 disk VMware   Virtual disk                    2.0=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> sr0  2:0:0:0 rom  NECVMWar VMware Virtual IDE CDROM Drive 1.00
> 10000000000000000001 ata
>=20
>=20
> $ dmesg -t | grep -i scsi
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
> SCSI subsystem initialized
> VMware PVSCSI driver - version 1.0.7.0-k
> vmw_pvscsi: using 64bit dma
> vmw_pvscsi: max_id: 65
> vmw_pvscsi: setting ring_pages to 32
> vmw_pvscsi: enabling reqCallThreshold
> vmw_pvscsi: driver-based request coalescing enabled
> vmw_pvscsi: using MSI-X
> scsi host0: VMware PVSCSI storage adapter rev 2, req/cmp/msg rings: 32/32=
/1
> pages, cmd_per_lun=3D254
> vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 2 host #0
> scsi 0:0:0:0: Direct-Access     VMware   Virtual disk     2.0  PQ: 0 ANSI=
: 6
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi host1: ata_piix
> scsi host2: ata_piix
> scsi 2:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI=
: 5
> scsi 2:0:0:0: Attached scsi generic sg1 type 5
> sr 2:0:0:0: [sr0] scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cd=
da
> tray
> sr 2:0:0:0: Attached scsi CD-ROM sr0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
> Will that "scsi: Do no try to probe for CDL on old drives" patch land in
> mainline or is this still under discussion?

It has been in mainline for a while:

2132df16f53b ("scsi: core: ata: Do no try to probe for CDL on old drives")

$ git tag --contains 2132df16f53b
v6.6
v6.6-rc4
v6.6-rc5
v6.6-rc6
v6.6-rc7
v6.6.1
v6.7-rc1


Kind regards,
Niklas

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
