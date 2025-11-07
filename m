Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573A130F946
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 08:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503233; cv=none; b=jcYzpfU2he+UbKdaExmgOf3aeZZ8Yuwn27XW6fFK79+Ci0q2jmKIFvxVlf2TA1xBM3MjBUBF0OjLVstNDLgd4uLcGtb9Y8LKGEysJOOJBiJinID0YU5zIl2yu+g2cLbLza1A7TlpjJP0oyi66vJpFcE7wF8mqfRQEpyqBxI4WK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503233; c=relaxed/simple;
	bh=tRDS/bbu/QwcpIhKPWrdi0REu6cpcYpp/MSDPyhellk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TN+3jWoITfic9n8ScD6eB+rMWYSENFry/Eb7FfV+rJDqaG0HofNoVDr07SXfjDAYStECxCh4kFepJbNYWODXFC5ZIXUXdEXa2Muv3gqDRUlSB9y3kLh/OdDzUIMl8uvrzkHoxcI6T2dQf7ao54xUz/SlMXcj/lcXa0s4WEni1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldeXZfy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldeXZfy2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5C18C19422
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 08:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762503231;
	bh=tRDS/bbu/QwcpIhKPWrdi0REu6cpcYpp/MSDPyhellk=;
	h=From:To:Subject:Date:From;
	b=ldeXZfy2iKr02MKoVw+J/q9R8howVFp0Wzp4JcjXjRkQBslx35rGKUNqhOXKz3AsD
	 yM0A3aZ3TNGIa29/dPJSMDRAySDsYq1/G5ZbGh73SWsSfxhzHA332mrQTIho1BfFkQ
	 wa0nNUBjOWLqy4NZVVNPv+YxIlZFDskmw3dRZh7z3Ih/MUqjdU9tSNL6+zJYcM1HuP
	 oyi3AbIW9GBFbrtX+Xkkx0KV0eN+ZQ53Bd0eOGGO7AsQBfqSehutantylOUPbQ+hXW
	 Q29Gyt0/V9Q425ao2UoFTzsLVP2TR7BSFWl7/R4zL2WX6qNcPsrU2/wlO3tF7MeuY+
	 FzJABtVDtB3hQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D134CC41612; Fri,  7 Nov 2025 08:13:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220761] New: Observed  data-race in
 pvscsi_process_completion_ring+0x2e5/0x620 [vmw_pvscsi]
Date: Fri, 07 Nov 2025 08:13:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: parsishashank351@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-220761-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220761

            Bug ID: 220761
           Summary: Observed  data-race in
                    pvscsi_process_completion_ring+0x2e5/0x620
                    [vmw_pvscsi]
           Product: IO/Storage
           Version: 2.5
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: parsishashank351@gmail.com
        Regression: No

Created attachment 308914
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308914&action=3Dedit
BUG

Hello Team,
i have build linux kernel 6.17.7 by taking code from kernel.org and i have
enabled CONFIG_KCSAN in kernel config file and installed the kernel.
After the initial boot, i saw some concurrency issues in dmesg kernel ring
buffer.
Few are related to ACPI and few are related to timer subsystem.

ref dmesg log:
[  363.508293] BUG: KCSAN: data-race in
pvscsi_process_completion_ring+0x2e5/0x620 [vmw_pvscsi]

[  363.508335] race at unknown origin, with read to 0xffff888b5a8bd00c of 4
bytes by interrupt on cpu 9:
[  363.508350]  pvscsi_process_completion_ring+0x2e5/0x620 [vmw_pvscsi]
[  363.508382]  pvscsi_isr+0x2c/0xe0 [vmw_pvscsi]
[  363.508410]  __handle_irq_event_percpu+0x7f/0x290
[  363.508431]  handle_irq_event+0x7c/0x100
[  363.508447]  handle_edge_irq+0x1f1/0x3e0
[  363.508463]  __common_interrupt+0x51/0x140
[  363.508488]  common_interrupt+0x9f/0xb0
[  363.508511]  asm_common_interrupt+0x27/0x40
[  363.508529]  pv_native_safe_halt+0xb/0x10
[  363.508544]  arch_cpu_idle+0x9/0x10
[  363.508561]  default_idle_call+0x30/0x110
[  363.508578]  do_idle+0x203/0x240
[  363.508594]  cpu_startup_entry+0x2c/0x30
[  363.508611]  start_secondary+0x12a/0x160
[  363.508628]  common_startup_64+0x13e/0x141

[  363.508656] value changed: 0x00000382 -> 0x00000383

[  363.508673] Reported by Kernel Concurrency Sanitizer on:
[  363.508687] CPU: 9 UID: 0 PID: 0 Comm: swapper/9 Not tainted 6.17.7 #4
PREEMPT(voluntary)
[  363.508706] Hardware name: VMware, Inc. VMware20,1/440BX Desktop Referen=
ce
Platform, BIOS VMW201.00V.23553139.B64.2403260940 03/26/2024
[  363.508720]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  363.545735] block sda: the capability attribute has been deprecated.
[  363.747366] systemd[1]: Configuration file
/run/systemd/system/netplan-ovs-cleanup.service is marked world-inaccessibl=
e.
This has no effect as configuration data is accessible via APIs without
restrictions. Proceeding anyway.
[  363.897787] systemd[1]: Queued start job for default target Graphical
Interface.
[  363.930839] systemd[1]: Created slice Slice /system/modprobe.
[  363.934173] systemd[1]: Created slice Slice /system/systemd-fsck.
[  363.936786] systemd[1]: Created slice User and Session Slice.
[  363.937067] systemd[1]: Started Forward Password Requests to Wall Direct=
ory
Watch.
[  363.937949] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts
File System Automount Point.
[  363.938020] systemd[1]: Reached target User and Group Name Lookups.
[  363.938045] systemd[1]: Reached target Remote File Systems.
[  363.938063] systemd[1]: Reached target Slice Units.
[  363.938083] systemd[1]: Reached target Mounting snaps.
[  363.938107] systemd[1]: Reached target Local Verity Protected Volumes.
[  363.938580] systemd[1]: Listening on Syslog Socket.
[  363.938937] systemd[1]: Listening on fsck to fsckd communication Socket.
[  363.939234] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  363.940197] systemd[1]: Listening on Journal Audit Socket.
[  363.940795] systemd[1]: Listening on Journal Socket (/dev/log).
[  363.941449] systemd[1]: Listening on Journal Socket.
[  363.942538] systemd[1]: Listening on udev Control Socket.
[  363.942925] systemd[1]: Listening on udev Kernel Socket.
[  363.964408] systemd[1]: Mounting Huge Pages File System...
[  363.970229] systemd[1]: Mounting POSIX Message Queue File System...
[  363.977223] systemd[1]: Mounting Kernel Debug File System...
[  363.983582] systemd[1]: Mounting Kernel Trace File System...
[  363.999254] systemd[1]: Starting Journal Service...
[  364.005925] systemd[1]: Starting Set the console keyboard layout...
[  364.012971] systemd[1]: Starting Create List of Static Device Nodes...
[  364.018779] systemd[1]: Starting Load Kernel Module configfs...
[  364.024851] systemd[1]: Starting Load Kernel Module drm...
[  364.030800] systemd[1]: Starting Load Kernel Module efi_pstore...
[  364.036699] systemd[1]: Starting Load Kernel Module fuse...
[  364.037136] systemd[1]: Condition check resulted in File System Check on
Root Device being skipped.
[  364.044537] systemd[1]: Starting Load Kernel Modules...
[  364.050739] systemd[1]: Starting Remount Root and Kernel File Systems...
[  364.057033] systemd[1]: Starting Coldplug All udev Devices...
[  364.065689] systemd[1]: Mounted Huge Pages File System.
[  364.066124] systemd[1]: Mounted POSIX Message Queue File System.
[  364.066574] systemd[1]: Mounted Kernel Debug File System.
[  364.066992] systemd[1]: Mounted Kernel Trace File System.
[  364.069385] pstore: Using crash dump compression: deflate
[  364.070955] systemd[1]: Finished Create List of Static Device Nodes.
[  364.073527] systemd[1]: modprobe@configfs.service: Deactivated successfu=
lly.
[  364.075228] pstore: Registered efi_pstore as persistent store backend
[  364.076498] systemd[1]: Finished Load Kernel Module configfs.
[  364.078235] systemd[1]: modprobe@drm.service: Deactivated successfully.
[  364.080939] systemd[1]: Finished Load Kernel Module drm.
[  364.083058] systemd[1]: modprobe@efi_pstore.service: Deactivated
successfully.
[  364.085668] systemd[1]: Finished Load Kernel Module efi_pstore.
[  364.087328] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[  364.091109] systemd[1]: Finished Load Kernel Module fuse.
[  364.108372] EXT4-fs (sda4): re-mounted 574a78d5-a611-492b-a2fd-0fd9308f9=
50d
r/w.
[  364.118805] systemd[1]: Mounting FUSE Control File System...
[  364.124774] systemd[1]: Mounting Kernel Configuration File System...
[  364.136436] systemd[1]: Finished Set the console keyboard layout.
[  364.142841] systemd[1]: Finished Remount Root and Kernel File Systems.
[  364.143464] systemd[1]: Mounted FUSE Control File System.
[  364.143954] systemd[1]: Mounted Kernel Configuration File System.
[  364.151632] lp: driver loaded but no devices found
[  364.171827] systemd[1]: Mounting VMware vmblock fuse mount...
[  364.172204] systemd[1]: Condition check resulted in Platform Persistent
Storage Archival being skipped.
[  364.179357] systemd[1]: Starting Load/Save Random Seed...
[  364.186032] systemd[1]: Starting Create System Users...
[  364.186747] ppdev: user-space parallel port driver
[  364.205481] systemd[1]: Mounted VMware vmblock fuse mount.
[  364.212386] systemd[1]: Finished Load/Save Random Seed.
[  364.212783] systemd[1]: Condition check resulted in First Boot Complete
being skipped.
[  364.234204] systemd[1]: Finished Create System Users.
[  364.254294] msr: no symbol version for __tsan_init
[  364.254302] systemd[1]: Starting Create Static Device Nodes in /dev...
[  364.300265] systemd[1]: Finished Create Static Device Nodes in /dev.
[  364.300510] systemd[1]: Reached target Preparation for Local File System=
s.
[  364.328501] systemd[1]: Mounting Mount unit for bare, revision 5...
[  364.336778] systemd[1]: Mounting Mount unit for core22, revision 2133...
[  364.343687] systemd[1]: Mounting Mount unit for core22, revision 2139...
[  364.344085] loop0: detected capacity change from 0 to 8
[  364.350286] loop1: detected capacity change from 0 to 151392
[  364.350638] systemd[1]: Mounting Mount unit for firefox, revision 7084...
[  364.356953] systemd[1]: Mounting Mount unit for firefox, revision 7177...
[  364.357372] loop2: detected capacity change from 0 to 151368
[  364.362444] loop3: detected capacity change from 0 to 510400
[  364.364115] systemd[1]: Mounting Mount unit for gnome-42-2204, revision
202...
[  364.370947] systemd[1]: Mounting Mount unit for gnome-42-2204, revision
226...
[  364.372429] loop4: detected capacity change from 0 to 510136
[  364.378103] loop5: detected capacity change from 0 to 1056784
[  364.378878] systemd[1]: Mounting Mount unit for gtk-common-themes, revis=
ion
1535...
[  364.385871] loop6: detected capacity change from 0 to 1057184
[  364.386625] systemd[1]: Mounting Mount unit for snap-store, revision 121=
6...
[  364.392379] loop7: detected capacity change from 0 to 187776
[  364.393941] systemd[1]: Mounting Mount unit for snap-store, revision 959=
...
[  364.404926] systemd[1]: Mounting Mount unit for snapd, revision 25202...
[  364.411548] loop8: detected capacity change from 0 to 24984
[  364.412569] systemd[1]: Mounting Mount unit for snapd, revision 25577...
[  364.414038] loop9: detected capacity change from 0 to 25240
[  364.419985] systemd[1]: Mounting Mount unit for snapd-desktop-integratio=
n,
revision 253...
[  364.423848] loop10: detected capacity change from 0 to 103976
[  364.427710] systemd[1]: Mounting Mount unit for snapd-desktop-integratio=
n,
revision 315...
[  364.431245] loop11: detected capacity change from 0 to 104296
[  364.438064] systemd[1]: Mounting Mount unit for firefox, revision 3836 v=
ia
mount-control...
[  364.438718] loop12: detected capacity change from 0 to 1136
[  364.448012] loop13: detected capacity change from 0 to 1152
[  364.452837] systemd[1]: Starting Rule-based Manager for Device Events and
Files...
[  364.457940] systemd[1]: Started Journal Service.
[  364.800902] systemd-journald[719]: Received client request to flush runt=
ime
journal.
[  364.823278] Console: switching to colour dummy device 80x25
[  364.839494] vmwgfx 0000:00:0f.0: vgaarb: deactivate vga console
[  364.852763] vmwgfx 0000:00:0f.0: [drm] FIFO at 0x00000000ff000000 size is
8192 KiB
[  364.852821] vmwgfx 0000:00:0f.0: [drm] VRAM at 0x00000000f0000000 size is
131072 KiB
[  364.852850] vmwgfx 0000:00:0f.0: [drm] Running on SVGA version 2.
[  364.852919] vmwgfx 0000:00:0f.0: [drm] Capabilities: rect copy, cursor,
cursor bypass, cursor bypass 2, 8bit emulation, alpha cursor, extended fifo,
multimon, pitchlock, irq mask, display topology, gmr, traces, gmr2, screen
object 2, command buffers, command buffers 2, gbobject, dx, hp cmd queue, n=
o bb
restriction, cap2 register,
[  364.852960] vmwgfx 0000:00:0f.0: [drm] Capabilities2: grow otable, intra
surface copy, dx2, gb memsize 2, screendma reg, otable ptdepth2, non ms to =
ms
stretchblt, cursor mob, mshint, cb max size 4mb, dx3, frame type, trace full
fb, extra regs, lo staging,
[  364.853398] vmwgfx 0000:00:0f.0: [drm] DMA map mode: Caching DMA mapping=
s.
[  364.853632] vmwgfx 0000:00:0f.0: [drm] Legacy memory limits: VRAM =3D 40=
96
KiB, FIFO =3D 256 KiB, surface =3D 0 KiB
[  364.853695] vmwgfx 0000:00:0f.0: [drm] MOB limits: max mob size =3D 1638=
4 KiB,
max mob pages =3D 4096
[  364.853710] vmwgfx 0000:00:0f.0: [drm] Max GMR ids is 64
[  364.853723] vmwgfx 0000:00:0f.0: [drm] Max number of GMR pages is 65536
[  364.853737] vmwgfx 0000:00:0f.0: [drm] Maximum display memory size is 16=
384
KiB
[  364.858502] vmwgfx 0000:00:0f.0: [drm] Screen Target display unit
initialized
[  364.862100] vmwgfx 0000:00:0f.0: [drm] Fifo max 0x00040000 min 0x00001000
cap 0x0000077f
[  364.863558] vmwgfx 0000:00:0f.0: [drm] Using command buffers with DMA po=
ol.
[  364.863588] vmwgfx 0000:00:0f.0: [drm] Available shader model: Legacy.
[  364.869914] [drm] Initialized vmwgfx 2.21.0 for 0000:00:0f.0 on minor 0
[  364.874233] fbcon: vmwgfxdrmfb (fb0) is primary device
[  364.911854] Console: switching to colour frame buffer device 160x50
[  365.004215] vmwgfx 0000:00:0f.0: [drm] fb0: vmwgfxdrmfb frame buffer dev=
ice

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
