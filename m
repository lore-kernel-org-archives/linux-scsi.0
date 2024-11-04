Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3AC83CD3
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730759521; cv=none; b=q0AfFJPjj2U2CJE3Wc2zMaOQuOkNfPBbY6aJOTNwXBuy2gLUltq1gVB0L0AzXK6GPwRs8Pm8ygYLK1eqDfc4TWYZ5Pg725TUsoYyyBfPjHg4Qp3d/sMF0uKmacn5lq5RPV24SDS7SPQOI6TQIzTJqOFgWKC1e/3oZCADyw0R40M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730759521; c=relaxed/simple;
	bh=jJ6DA8lA8hwpXu08pIFP9i1gYAuMtvX/pN2x9nAXZgM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Aw5AzsKmc+M/7OgEcmEjVZL6TSAR8tn0lyaBfhxhPjeOaMuv24E9C8Y+txTCpdSvjvm9gvYEoFTLx2lwKgYSoG+4h3xc2fsGW2UfihkkWyxc3oV0OX3XZXSHQfuMjsqnnn5CaqJyV7GULidVTKzCC697hL7YHiZbQQ26t3BV9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE9i6F6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE9i6F6M"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7123C4CED4
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730759520;
	bh=jJ6DA8lA8hwpXu08pIFP9i1gYAuMtvX/pN2x9nAXZgM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eE9i6F6M/ZgeC65M/EBYb3qaLKVOD+qzGOvsAwSvHgPrRjSepTGtXf1G/0rv6ccMC
	 LyO4TOJoSxdsHTP+6TzH1wBYzEN7uGFQgW9Od8UyaUIFntFfkTGATh41U/Z2HCILHU
	 o7hrtTMX6DjAJESQVlXWhPJjV6owsWyfVRKW5l7Y0Et4lE8p02Gq5MmLR/OZWM7mxr
	 ghUinFDBe061kut1VBu+1j7p7E60O2sCbav643uk/to7dw+VIXLS+VEhP2eX3qkipr
	 TMY/NJlmqSzLf+azTdMjfXuf0sL/oj42s4qT6/NeDkk2F7KqkOxwbsjR2pYjr2D6Up
	 ySzKqhDTOQ1ZA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD543C53BC4; Mon,  4 Nov 2024 22:32:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219467] Adaptec 71605 hangs with aacraid: Host adapter abort
 request after update to linux 6.11.5
Date: Mon, 04 Nov 2024 22:32:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219467-11613-xyOD54Qh7y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219467-11613@https.bugzilla.kernel.org/>
References: <bug-219467-11613@https.bugzilla.kernel.org/>
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

--- Comment #1 from Nathan Grennan (kernel-bugzilla@cygnusx-1.org) ---
boot drives:
2x Samsung SSD 980 PRO 500GB drives in mdadm raid1

lspci, short, disk controllers:
07:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Contro=
ller
[AHCI mode] (rev 51)
08:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Contro=
ller
[AHCI mode] (rev 51)
0a:00.0 RAID bus controller: Adaptec Series 7 6G SAS/PCIe 3 (rev 01)

lspci, long, everything:
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Ro=
ot
Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Starship/Matisse IOMMU
00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP
Bridge
00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP
Bridge
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:03.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP
Bridge
00:03.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP
Bridge
00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:05.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse
Internal PCIe GPP Bridge 0 to bus[E:B]
00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PC=
Ie
Dummy Host Bridge
00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse
Internal PCIe GPP Bridge 0 to bus[E:B]
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev=
 61)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev =
51)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 5
00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 6
00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data
Fabric: Device 18h; Function 7
01:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD
Controller PM9A1/PM9A3/980PRO
02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstr=
eam
03:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bri=
dge
03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bri=
dge
03:08.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bri=
dge
03:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bri=
dge
03:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bri=
dge
04:00.0 Ethernet controller: Intel Corporation Ethernet Controller I225-V (=
rev
03)
05:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD
Controller PM9A1/PM9A3/980PRO
06:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc.
[AMD] Starship/Matisse Reserved SPP
06:00.1 USB controller: Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 =
Host
Controller
06:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 =
Host
Controller
07:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Contro=
ller
[AHCI mode] (rev 51)
08:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Contro=
ller
[AHCI mode] (rev 51)
09:00.0 VGA compatible controller: NVIDIA Corporation GP106 [GeForce GTX 10=
60
3GB] (rev a1)
09:00.1 Audio device: NVIDIA Corporation GP106 High Definition Audio Contro=
ller
(rev a1)
0a:00.0 RAID bus controller: Adaptec Series 7 6G SAS/PCIe 3 (rev 01)
0b:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc.
[AMD] Starship/Matisse PCIe Dummy Function
0c:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc.
[AMD] Starship/Matisse Reserved SPP
0c:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD]
Starship/Matisse Cryptographic Coprocessor PSPCPP
0c:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 =
Host
Controller
0c:00.4 Audio device: Advanced Micro Devices, Inc. [AMD] Starship/Matisse HD
Audio Controller

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
