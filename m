Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0876BEB64DA
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Jul 2023 23:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjGHXR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jul 2023 19:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjGHXR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jul 2023 19:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E062E43
        for <linux-scsi@vger.kernel.org>; Sat,  8 Jul 2023 16:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE9B060B4A
        for <linux-scsi@vger.kernel.org>; Sat,  8 Jul 2023 23:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39842C433AD
        for <linux-scsi@vger.kernel.org>; Sat,  8 Jul 2023 23:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688858275;
        bh=yTpS4SDk8HYWbk+HwLdLttI/vRzIlC3gEJLJsjX8kuM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=smOqej9m5ympZ+fGTRmU6STiUsmvq35t+jFQwyg90RkX2MaiAQwIVru/2zCFsCqGv
         D0cRXHh2eV3sOmc0SkFtoK0AMyEtEfaIsnRslMBfbN5VXKglt5h3o7gBWoYaqJjwJo
         kIBsGvxOOqsnVpxCrIDrQEKpFkyHwHXpBVS8SopTi170TXs9k5Jf1Nkk2whh3JyPGC
         +ZOgijbxOhUf/FL3mWoA43YkY9uHIoNUpgLOsXqmqOA3bquGoCUP8r7x1XJGyJw0TT
         TXjmKy/Qx1/st/E7XCy/CseLn0Zuel/K1mPSqvnbMwInBVVqW07CrR1UO8G7ypRWRU
         1EiCPlCT5N4Fg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 291A6C4332E; Sat,  8 Jul 2023 23:17:55 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Sat, 08 Jul 2023 23:17:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: paula@alumni.cse.ucsc.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215880-11613-n508TVXrnr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

Paul Ausbeck (paula@alumni.cse.ucsc.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |paula@alumni.cse.ucsc.edu

--- Comment #44 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
I'd like to add that I've also noticed this regression after upgrading from
Debian 11/5.10 to Debian 12/6.1

I've copied the resume portion of the dmesg log below. Note that the pci bus
activity and related gpu messages don't happen until after my 10 year old 2=
TB
hdd spins up. Restarting of tasks is also deferred until then. I also note =
that
the mouse cursor is also frozen until all those platters spin up..

To my mind, it would be a major improvement/tour de force if linux could de=
fer
spinning up the hdd at all until it is needed. Think of all the drive wear =
and
energy savings that would ensue. I use my 2TB hdd for backing up smaller dr=
ives
and for storing movies. It would be quite nice if the drive were to not spi=
n up
at all until accessed.


[167498.654484] ACPI: PM: Waking up from system sleep state S3
[167498.655607] pcieport 0000:00:1c.0: Enabling MPC IRBNCE
[167498.655608] pcieport 0000:00:1c.7: Enabling MPC IRBNCE
[167498.655613] pcieport 0000:00:1c.0: Intel PCH root port ACS workaround
enabled
[167498.655614] pcieport 0000:00:1c.7: Intel PCH root port ACS workaround
enabled
[167498.657222] parport_pc 00:05: activated
[167498.657638] serial 00:07: activated
[167498.666692] sd 2:0:0:0: [sdb] Starting disk
[167498.666709] sd 3:0:0:0: [sdd] Starting disk
[167498.666720] sd 1:0:0:0: [sdc] Starting disk
[167498.666725] sd 0:0:0:0: [sda] Starting disk
[167498.751660] input input0: event field not found
[167499.041464] ata6: SATA link down (SStatus 0 SControl 300)
[167499.041525] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[167499.041556] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[167499.041581] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[167499.042450] ata2.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.042455] ata2.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.042479] ata1.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.042484] ata1.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.042605] ata1.00: supports DRM functions and may not be fully access=
ible
[167499.043225] ata2.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.043233] ata2.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.043464] ata2.00: configured for UDMA/133
[167499.053394] ata5.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.053402] ata5.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.074315] ata5.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.074323] ata5.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.079649] ata5.00: configured for UDMA/100
[167499.130641] ata1.00: NCQ Send/Recv Log not supported
[167499.132638] ata1.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167499.132646] ata1.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167499.132837] ata1.00: supports DRM functions and may not be fully access=
ible
[167499.132990] ata1.00: NCQ Send/Recv Log not supported
[167499.134317] ata1.00: configured for UDMA/133
[167499.247035] firewire_core 0000:03:01.0: rediscovered device fw0
[167499.247089] br0: port 1(eth0) entered disabled state
[167501.553034] e1000e 0000:00:19.0 eth0: NIC Link is Up 1000 Mbps Full Dup=
lex,
Flow Control: Rx/Tx
[167501.553075] br0: port 1(eth0) entered blocking state
[167501.553078] br0: port 1(eth0) entered forwarding state
[167504.079109] ata4: link is slow to respond, please be patient (ready=3D0)
[167504.079117] ata3: link is slow to respond, please be patient (ready=3D0)
[167504.799136] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[167504.917319] ata4.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167504.917324] ata4.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167504.918915] ata4.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167504.918922] ata4.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167504.919646] ata4.00: configured for UDMA/133
[167508.699207] ata3: COMRESET failed (errno=3D-16)
[167510.871278] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[167511.040204] ata3.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167511.040212] ata3.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167511.078770] ata3.00: ACPI cmd f5/00:00:00:00:00:00(SECURITY FREEZE LOCK)
filtered out
[167511.078778] ata3.00: ACPI cmd b1/c1:00:00:00:00:00(DEVICE CONFIGURATION
OVERLAY) filtered out
[167511.082920] ata3.00: configured for UDMA/133
[167511.107913] pci_bus 0000:03: Allocating resources
[167511.107932] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus=
 03]
add_size 1000
[167511.107939] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff
64bit pref] to [bus 03] add_size 200000 add_align 100000
[167511.107949] pci 0000:02:00.0: BAR 15: no space for [mem size 0x00200000
64bit pref]
[167511.107952] pci 0000:02:00.0: BAR 15: failed to assign [mem size 0x0020=
0000
64bit pref]
[167511.107955] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[167511.107958] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[167511.107962] pci 0000:02:00.0: BAR 15: no space for [mem size 0x00200000
64bit pref]
[167511.107965] pci 0000:02:00.0: BAR 15: failed to assign [mem size 0x0020=
0000
64bit pref]
[167511.107967] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[167511.107970] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[167511.108011] OOM killer enabled.
[167511.108014] Restarting tasks ... done.
[167511.111619] random: crng reseeded on system resumption
[167511.111760] PM: suspend exit

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
