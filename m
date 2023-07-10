Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023E9EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 01:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjGJBDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 21:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGJBDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 21:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51EEB1
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 18:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B34360CEB
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 01:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9D2DC433B7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 01:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688950978;
        bh=htP+ZRXQefs6VMOVQBM4LCGkg4J9IFWkYpn+qSRLl/w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OUzpVytSAlk8Jxmh0SmirYausE8XhASZOb9EdFprHIVvT8J4mhJkhWnjl6BiFiuva
         L4c8eHUgWxhtu/ajz78zraJHPnGVL0zZ0r6r4gVI0kFq1VxGiASk6ETtxNVeCvkU9t
         XD7OXDm8OXYdcMMVy529s8t+t2hpVXEVhzbEvXjAzTz8aiv2lOBG9E9ePjS5zTj+UK
         YZl0Xv4Ydr7QR4tBL+Tal4yuVpjtCuypfNLqeuZwZMVQ7qG2358FUxY9EGI3Wpm/24
         TFwQeJHt3OTNLTFhRZy+smk4bZFX9D18E9vsvoMLsxiF5g2RhO37UOKesUIIpcNBuE
         1WFKjk+8EQNyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9B3AFC53BCD; Mon, 10 Jul 2023 01:02:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 01:02:57 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-pGyky8F80q@https.bugzilla.kernel.org/>
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

--- Comment #49 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
My reflex memory says that when resuming Debian 11/5.10 the mouse cursor was
live immediately after the LCD monitor came on. Current testing says that w=
hen
resuming Debian 12/6.1 the mouse cursor is frozen until at least five secon=
ds
after the monitor comes on.

In order to verify that my reflex memory was correct, I booted Debian 12 but
with the 5.10 kernel. Sure enough, upon resume the mouse cursor is immediat=
ely
alive once the LCD monitor comes on.

I've attached the end portion of the Debian 12/5.10 resume dmesg log below.
Note that the restarting of tasks and the PCI/GPU activity that happened at=
 the
end of resume for the Debian 12/6.1 combination happens before ATA bring up
with the Debian 12/5.10 combination.

This is starting to look like a regression to me.

[   45.516511] OOM killer enabled.
[   45.516512] Restarting tasks ...=20
[   45.516726] pci_bus 0000:03: Allocating resources
[   45.516743] pci 0000:02:00.0: bridge window [io  0x1000-0x0fff] to [bus =
03]
add_size 1000
[   45.516748] pci 0000:02:00.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit
pref] to [bus 03] add_size 200000 add_align 100000
[   45.516756] pci 0000:02:00.0: BAR 15: no space for [mem size 0x00200000
64bit pref]
[   45.516759] pci 0000:02:00.0: BAR 15: failed to assign [mem size 0x00200=
000
64bit pref]
[   45.516762] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[   45.516764] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[   45.516768] pci 0000:02:00.0: BAR 15: no space for [mem size 0x00200000
64bit pref]
[   45.516769] pci 0000:02:00.0: BAR 15: failed to assign [mem size 0x00200=
000
64bit pref]
[   45.516771] pci 0000:02:00.0: BAR 13: no space for [io  size 0x1000]
[   45.516772] pci 0000:02:00.0: BAR 13: failed to assign [io  size 0x1000]
[   45.518520] done.
[   45.518693] video LNXVIDEO:00: Restoring backlight state
[   45.518696] PM: suspend exit
[   45.641461] br0: port 1(eth0) entered disabled state
[   45.734342] ata6: SATA link down (SStatus 0 SControl 300)
[   45.734372] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   45.734405] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   45.734435] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   45.735377] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.735382] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.735384] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.735433] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.735437] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.735440] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.735499] ata1.00: supports DRM functions and may not be fully accessi=
ble
[   45.736244] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.736249] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.736251] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.736531] ata2.00: configured for UDMA/133
[   45.746293] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.746298] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.746301] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.767136] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.767141] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.767144] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.772405] ata5.00: configured for UDMA/100
[   45.819126] ata1.00: NCQ Send/Recv Log not supported
[   45.820557] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   45.820571] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   45.820573] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   45.820687] ata1.00: supports DRM functions and may not be fully accessi=
ble
[   45.820786] ata1.00: NCQ Send/Recv Log not supported
[   45.821701] ata1.00: configured for UDMA/133
[   45.947955] firewire_core 0000:03:01.0: rediscovered device fw0
[   48.373868] e1000e 0000:00:19.0 eth0: NIC Link is Up 1000 Mbps Full Dupl=
ex,
Flow Control: Rx/Tx
[   48.373927] br0: port 1(eth0) entered blocking state

[   48.373930] br0: port 1(eth0) entered forwarding state
[   50.775921] ata3: link is slow to respond, please be patient (ready=3D0)
[   50.783922] ata4: link is slow to respond, please be patient (ready=3D0)
[   51.143938] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   51.262481] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   51.262485] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   51.262488] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   51.264139] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   51.264144] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   51.264147] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   51.264802] ata4.00: configured for UDMA/133
[   55.403919] ata3: COMRESET failed (errno=3D-16)
[   56.799938] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   56.981696] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   56.981702] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   56.981705] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   57.008271] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succee=
ded
[   57.008277] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK)
filtered out
[   57.008280] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION
OVERLAY) filtered out
[   57.012179] ata3.00: configured for UDMA/133

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
