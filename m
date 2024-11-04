Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125C1FCC6A
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730758625; cv=none; b=DSwTIdUIc4qRXOOlqvHBUeEGCxmxeidn+bz27snXPOwn4op87LWQV9xar2G7BBZU8Fhb+seF7TW4XRomzY5dPmnW73Eog1645vgBJ5uR9+8Gng+kaiu3ybw79Smis4v3fPNT0yaN+UhuIO6yYt3FLdvInXtNrt1xqW1OkDGacpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730758625; c=relaxed/simple;
	bh=YDmpNKZVC6LfFG9ihyjqKKOrdZM/YfR7bmikDoS9ABU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u5//kWWV/hhqUM/o+TKt5BwPIJd1mdr7V8S+e7xt2/jUHR2H+8QY7y0qszHprRQhX3dq8mUH56/uvXsuNtk0/CZ+cO5ocwKp9gSYsgX4SIqqDiCibXopbCc05lB5UUHE6agjs6Ut2GJyAfyYKmWFvzRWJnQPUhGu0axsznzycKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nuIDuScZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nuIDuScZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84989C4CED4
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730758624;
	bh=YDmpNKZVC6LfFG9ihyjqKKOrdZM/YfR7bmikDoS9ABU=;
	h=From:To:Subject:Date:From;
	b=nuIDuScZ1THGBEKmIPGShTUuZj/6QMm461n9OT+PYdoAJS/Rs7c72hHad2q4Aa9i7
	 TVT78cL2xvVuGVm1CbHDxmz/PKvP6mQT98c4Td/tSyLeVzuB+xGsX6tQGtwZNSCh9m
	 a4T3wsbU5NUXjWxAiLr09vn7YBBdGYER9D7rezybxwTmz/gyphyxqSbcZnjNfq3PZD
	 i64UUQ9wF4TRbrCLwlp2PudYISuBwS631HFXmd3p5cpju7E5L79gGryjVYjx5PTV2L
	 IJ2EqmYaLXk1In+JUMLsbchMlW0Vc/8/gExDFwGz/PYWX5EsvFJ1XR5CRwLEXIK5Eg
	 5iZLw3pRvZJOQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 76B26C53BC8; Mon,  4 Nov 2024 22:17:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219467] New: Adaptec 71605 hangs with aacraid: Host adapter
 abort request after update to linux 6.11.5
Date: Mon, 04 Nov 2024 22:17:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel-bugzilla@cygnusx-1.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219467-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219467

            Bug ID: 219467
           Summary: Adaptec 71605 hangs with aacraid: Host adapter abort
                    request after update to linux 6.11.5
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: kernel-bugzilla@cygnusx-1.org
        Regression: No

On October 31st I upgraded a system from Fedora 40 to Fedora 41. This upgra=
ded
the kernel from 6.10.6-200.fc40.x86_64 to 6.11.5-300.fc41.x86_64. One of the
system's primary uses is as a NAS using an Adaptec 71605 and zfs-2.2.6. The
system does zfs scrubs on the two zfs filesystems on Mondays, like Oct 28th=
 and
Nov 4th. On Oct 28th it was still on the 6.10.6 kernel, and today it was on=
 the
6.11.5 kernel.

The errors repeated until I woke up, and found the scrubs had stopped from =
zfs
errors caused by the controller errors. After a bit I rebooted the system, =
and
then had to stop the scrubs again. They had automatically restarted. I then
installed 6.10.14-200.fc40.x86_64, and restarted the scrubs.

The scrub processes started at nearly 4am. You can see from the timing of t=
he
logs below that the errors didn't start for over two hours into the scrub. =
The
house thermostat is set to 73F/76F, and the outside temperature at 6am was =
45F.
So the room shouldn't have been unusually hot.

I saw zfs read and write errors on all the drives on the 71605.

I restarted the scrubs after downgrading to 6.10.14. It has been about three
hours since then. Which means it has lasted longer than 6.11.5 so far. I wi=
ll
update with a new comment when it either throws an error or completes.

I built the system in May of 2021, and it hasn't given many any issues like
this before. It started with a 5.11.12-300.fc34 kernel.

I did look for a newer version of the disk controller's bios, but found it =
is
already the latest, 32118.

System hardware:
AMD Ryzen 9 5950X, processor
Kingston 128gb(4x32gb) DDR4 ECC, memory
ASUS Pro WS X570-ACE, motherboard
Adaptec 71605, disk controller
6 WD 18tb SATA, drives(one on the 71605, rest on other controllers)
9 WD 8tb SATA, drives(all on the 71605)

BIOS/Firmware versions:
BIOS                                       : 7.5-0 (32118)
Firmware                                   : 7.5-0 (32118)

A older, but very similar bug:
https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Timing of scrubs and errors:
Nov 04 03:46:01 storage zed[2545101]: eid=3D11 class=3Dscrub_start pool=3D'=
data18'
Nov 04 03:46:11 storage zed[2545231]: eid=3D13 class=3Dscrub_start pool=3D'=
data8'
Nov 04 06:08:38 storage kernel: aacraid: Host adapter abort request.

Errors:
Nov 04 06:08:38 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host adapter abort request.
                                aacraid: Outstanding commands on (2,1,12,0):
Nov 04 06:09:08 storage kernel: aacraid: Host bus reset request. SCSI hang ?
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
midlevel-0
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
lowlevel-0
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: error
handler-8
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
firmware-0
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: kern=
el-0
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: Controller reset type=
 is
3
Nov 04 06:09:08 storage kernel: aacraid 0000:0a:00.0: Issuing IOP reset
Nov 04 06:10:19 storage kernel: aacraid 0000:0a:00.0: IOP reset failed
Nov 04 06:10:19 storage kernel: aacraid 0000:0a:00.0: ARC Reset attempt fai=
led
Nov 04 06:11:19 storage kernel: aacraid: Host bus reset request. SCSI hang ?
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: Adapter health - -3
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
midlevel-0
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
lowlevel-0
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: error
Issuing IOP resethandler-0
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
firmware-124
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: kern=
el-0
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: Controller reset type=
 is
3
Nov 04 06:11:19 storage kernel: aacraid 0000:0a:00.0: Issuing IOP reset
Nov 04 06:11:19 storage kernel:  rfkill wmi_bmof snd_timer drm_ttm_helper
pcspkr ttm k10temp i2c_piix4 snd i2c_smbus video soundcore igc nfsd auth_rp=
cgss
nfs_acl lockd grace sunrpc loop nfnetlink crct10dif_pclmul crc32_pclmul
crc32c_intel polyval_clmulni polyval_generic raid1 ghash_clmulni_intel mxm_=
wmi
nvme sha512_ssse3 aacraid sha256_ssse3 sha1_ssse3 nvme_core sp5100_tco
nvme_auth wmi ip6_tables ip_tables fuse
Nov 04 06:11:19 storage kernel:  src_sync_cmd+0x108/0x2e0 [aacraid]
Nov 04 06:11:19 storage kernel:  aac_src_restart_adapter.part.0+0x112/0x2b6
[aacraid]
Nov 04 06:11:19 storage kernel:  aac_reset_adapter+0xeb/0x650 [aacraid]
Nov 04 06:11:19 storage kernel:  aac_eh_host_reset+0x62/0xe0 [aacraid]
Nov 04 06:12:34 storage kernel: aacraid 0000:0a:00.0: IOP reset failed
Nov 04 06:12:34 storage kernel: aacraid 0000:0a:00.0: ARC Reset attempt fai=
led
Nov 04 06:12:34 storage kernel:  mxm_wmi nvme sha512_ssse3 aacraid
Nov 04 06:13:04 storage kernel: aacraid: Host bus reset request. SCSI hang ?
Nov 04 06:13:04 storage kernel: aacraid 0000:0a:00.0: Adapter health - -3
Nov 04 06:13:04 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
midlevel-0
Nov 04 06:13:04 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
lowlevel-0
Nov 04 06:13:04 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: error
handler-0
Nov 04 06:13:05 storage kernel: aacraid 0000:0a:00.0: outstanding cmd:
firmware-1
Nov 04 06:13:05 storage kernel: aacraid 0000:0a:00.0: outstanding cmd: kern=
el-0
Nov 04 06:13:05 storage kernel: aacraid 0000:0a:00.0: Controller reset type=
 is
3
Nov 04 06:13:05 storage kernel: aacraid 0000:0a:00.0: Issuing IOP reset
Nov 04 06:13:05 storage kernel:  rfkill wmi_bmof snd_timer drm_ttm_helper
pcspkr ttm k10temp i2c_piix4 snd i2c_smbus video soundcore igc nfsd auth_rp=
cgss
nfs_acl lockd grace sunrpc loop nfnetlink crct10dif_pclmul crc32_pclmul
crc32c_intel polyval_clmulni polyval_generic raid1 ghash_clmulni_intel mxm_=
wmi
nvme sha512_ssse3 aacraid sha256_ssse3 sha1_ssse3 nvme_core sp5100_tco
nvme_auth wmi ip6_tables ip_tables fuse
Nov 04 06:13:05 storage kernel:  src_sync_cmd+0x108/0x2e0 [aacraid]
Nov 04 06:13:05 storage kernel:  aac_src_restart_adapter.part.0+0x112/0x2b6
[aacraid]
Nov 04 06:13:05 storage kernel:  aac_reset_adapter+0xeb/0x650 [aacraid]
Nov 04 06:13:05 storage kernel:  aac_eh_host_reset+0x62/0xe0 [aacraid]
Nov 04 06:14:20 storage kernel: aacraid 0000:0a:00.0: IOP reset failed
Nov 04 06:14:20 storage kernel: aacraid 0000:0a:00.0: ARC Reset attempt fai=
led

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
